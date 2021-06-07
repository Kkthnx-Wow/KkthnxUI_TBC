local K, C, L = unpack(select(2, ...))
local Module = K:NewModule("Miscellaneous")

local _G = _G
local table_insert = _G.table.insert
local string_gsub = _G.string.gsub
local table_wipe = _G.table.wipe

local BNGetGameAccountInfoByGUID = _G.BNGetGameAccountInfoByGUID
local C_FriendList_IsFriend = _G.C_FriendList.IsFriend
local C_QuestLog_GetQuestInfo = _G.C_QuestLog.GetQuestInfo
local FRIEND = _G.FRIEND
local GUILD = _G.GUILD
local GetFileIDFromPath = _G.GetFileIDFromPath
local GetItemInfo = _G.GetItemInfo
local GetItemQualityColor = _G.GetItemQualityColor
local GetMerchantItemLink = _G.GetMerchantItemLink
local GetMerchantItemMaxStack = _G.GetMerchantItemMaxStack
local GetNumQuestLogEntries = _G.GetNumQuestLogEntries
local GetQuestLogTitle = _G.GetQuestLogTitle
local InCombatLockdown = _G.InCombatLockdown
local IsAltKeyDown = _G.IsAltKeyDown
local IsGuildMember = _G.IsGuildMember
local IsQuestComplete = _G.IsQuestComplete
local MAX_NUM_QUESTS = _G.MAX_NUM_QUESTS or 25
local NO = _G.NO
local NUMGOSSIPBUTTONS = _G.NUMGOSSIPBUTTONS or 32
local PlaySound = _G.PlaySound
local StaticPopupDialogs = _G.StaticPopupDialogs
local StaticPopup_Show = _G.StaticPopup_Show
local UIParent = _G.UIParent
local UnitGUID = _G.UnitGUID
local YES = _G.YES
local hooksecurefunc = _G.hooksecurefunc

-- Reanchor DurabilityFrame
function Module:CreateDurabilityFrameMove()
	hooksecurefunc(DurabilityFrame, "SetPoint", function(self, _, parent)
		if parent == "MinimapCluster" or parent == MinimapCluster then
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -40, -50)
		end
	end)
end

-- Reanchor TicketStatusFrame
function Module:CreateTicketStatusFrameMove()
	hooksecurefunc(TicketStatusFrame, "SetPoint", function(self, relF)
		if relF == "TOPRIGHT" then
			self:ClearAllPoints()
			self:SetPoint("TOP", UIParent, "TOP", -400, -20)
		end
	end)
end

-- Hide boss emote
function Module:CreateBossEmote()
	if C["Misc"].HideBossEmote then
		RaidBossEmoteFrame:UnregisterAllEvents()
	else
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_EMOTE")
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_WHISPER")
		RaidBossEmoteFrame:RegisterEvent("CLEAR_BOSS_EMOTES")
	end
end

local function CreateErrorFrameToggle(event)
	if not C["General"].NoErrorFrame then
		return
	end

	if event == "PLAYER_REGEN_DISABLED" then
		_G.UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
		K:RegisterEvent("PLAYER_REGEN_ENABLED", CreateErrorFrameToggle)
	else
		_G.UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
		K:UnregisterEvent(event, CreateErrorFrameToggle)
	end
end

function Module:CreateQuestSizeUpdate()
	QuestTitleFont:SetFont(QuestFont:GetFont(), C["UIFonts"].QuestFontSize + 3, nil)
	QuestFont:SetFont(QuestFont:GetFont(), C["UIFonts"].QuestFontSize + 1, nil)
	QuestFontNormalSmall:SetFont(QuestFontNormalSmall:GetFont(), C["UIFonts"].QuestFontSize, nil)
end

function Module:CreateErrorsFrame()
	local Font = K.GetFont(C["UIFonts"].GeneralFonts)
	local Path, _, Flag = _G[Font]:GetFont()

	UIErrorsFrame:SetFont(Path, 15, Flag)
	UIErrorsFrame:ClearAllPoints()
	UIErrorsFrame:SetPoint("TOP", 0, -300)

	K.Mover(UIErrorsFrame, "UIErrorsFrame", "UIErrorsFrame", {"TOP", 0, -300})
end

-- TradeFrame hook
function Module:CreateTradeTargetInfo()
	local infoText = K.CreateFontString(TradeFrame, 16, "", "")
	infoText:ClearAllPoints()
	infoText:SetPoint("TOP", TradeFrameRecipientNameText, "BOTTOM", 0, -8)

	local function updateColor()
		local r, g, b = K.UnitColor("NPC")
		TradeFrameRecipientNameText:SetTextColor(r, g, b)

		local guid = UnitGUID("NPC")
		if not guid then return end
		local text = "|cffff0000"..L["Stranger"]
		if BNGetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) then
			text = "|cffffff00"..FRIEND
		elseif IsGuildMember(guid) then
			text = "|cff00ff00"..GUILD
		end
		infoText:SetText(text)
	end

	hooksecurefunc("TradeFrame_Update", updateColor)
end

-- ALT+RightClick to buy a stack
do
	local cache = {}
	local itemLink, id

	StaticPopupDialogs["BUY_STACK"] = {
		text = L["Stack Buying Check"],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			if not itemLink then
				return
			end

			BuyMerchantItem(id, GetMerchantItemMaxStack(id))
			cache[itemLink] = true
			itemLink = nil
		end,
		hideOnEscape = 1,
		hasItemFrame = 1,
	}

	local _MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
	function MerchantItemButton_OnModifiedClick(self, ...)
		if IsAltKeyDown() then
			id = self:GetID()
			itemLink = GetMerchantItemLink(id)
			if not itemLink then
				return
			end

			local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
			if maxStack and maxStack > 1 then
				if not cache[itemLink] then
					local r, g, b = GetItemQualityColor(quality or 1)
					StaticPopup_Show("BUY_STACK", " ", " ", {["texture"] = texture, ["name"] = name, ["color"] = {r, g, b, 1}, ["link"] = itemLink, ["index"] = id, ["count"] = maxStack})
				else
					BuyMerchantItem(id, GetMerchantItemMaxStack(id))
				end
			end
		end

		_MerchantItemButton_OnModifiedClick(self, ...)
	end
end

-- Temporary taint fix
do
	InterfaceOptionsFrameCancel:SetScript("OnClick", function()
		InterfaceOptionsFrameOkay:Click()
	end)
end

-- Select target when click on raid units
do
	local function fixRaidGroupButton()
		for i = 1, 40 do
			local bu = _G["RaidGroupButton"..i]
			if bu and bu.unit and not bu.clickFixed then
				bu:SetAttribute("type", "target")
				bu:SetAttribute("unit", bu.unit)

				bu.clickFixed = true
			end
		end
	end

	local function setupMisc(event, addon)
		if event == "ADDON_LOADED" and addon == "Blizzard_RaidUI" then
			if not InCombatLockdown() then
				fixRaidGroupButton()
			else
				K:RegisterEvent("PLAYER_REGEN_ENABLED", setupMisc)
			end
			K:UnregisterEvent(event, setupMisc)
		elseif event == "PLAYER_REGEN_ENABLED" then
			if RaidGroupButton1 and RaidGroupButton1:GetAttribute("type") ~= "target" then
				fixRaidGroupButton()
				K:UnregisterEvent(event, setupMisc)
			end
		end
	end

	K:RegisterEvent("ADDON_LOADED", setupMisc)
end

do
	local function soundOnResurrect()
		if C["Unitframe"].ResurrectSound then
			PlaySound("72978", "Master")
		end
	end
	K:RegisterEvent("RESURRECT_REQUEST", soundOnResurrect)
end

function Module:CreateBlockStrangerInvites()
	K:RegisterEvent("PARTY_INVITE_REQUEST", function(_, _, _, _, _, _, _, guid)
		if C["Automation"].AutoBlockStrangerInvites and not (IsGuildMember(guid) or BNGetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid)) then
			_G.DeclineGroup()
			_G.StaticPopup_Hide("PARTY_INVITE")
		end
	end)
end

function Module:CreateEnhanceNormalDressup()
	local parent = _G.DressUpFrameResetButton
	local button = Module:MailBox_CreatButton(parent, 80, 22, "Undress", {"RIGHT", parent, "LEFT", -1, 0})
	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick", function(_, btn)
		local actor = DressUpFrame.DressUpModel
		if not actor then
			return
		end

		if btn == "LeftButton" then
			actor:Undress()
		else
			actor:UndressSlot(19)
		end
	end)

	K.AddTooltip(button, "ANCHOR_TOP", string.format("%sUndress all|n%sUndress tabard", K.LeftButton, K.RightButton))
end

function Module:CreateEnhanceAuctionDressup()
	local parent = _G.SideDressUpModelResetButton
	local button = Module:MailBox_CreatButton(parent, 80, 22, "Undress", {"TOP", parent, "BOTTOM", 0, -4})
	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick", function(_, btn)
		local actor = SideDressUpModel
		if not actor then
			return
		end

		if btn == "LeftButton" then
			actor:Undress()
		else
			actor:UndressSlot(19)
		end
	end)

	K.AddTooltip(button, "ANCHOR_TOP", string.format("%sUndress all|n%sUndress tabard", K.LeftButton, K.RightButton))
end

-- Add friend and guild invite on target menu
function Module:MenuButton_OnClick(info)
	local name, server = UnitName(info.unit)
	if server and server ~= "" then
		name = name.."-"..server
	end

	if info.value == "name" then
		if MailFrame:IsShown() then
			MailFrameTab_OnClick(nil, 2)
			SendMailNameEditBox:SetText(name)
			SendMailNameEditBox:HighlightText()
		else
			local editBox = ChatEdit_ChooseBoxForSend()
			local hasText = (editBox:GetText() ~= "")
			ChatEdit_ActivateChat(editBox)
			editBox:Insert(name)
			if not hasText then
				editBox:HighlightText()
			end
		end
	elseif info.value == "guild" then
		GuildInvite(name)
	end
end

function Module:MenuButton_Show(_, unit)
	if UIDROPDOWNMENU_MENU_LEVEL > 1 then
		return
	end

	if unit and (unit == "target" or string.find(unit, "party") or string.find(unit, "raid")) then
		local info = UIDropDownMenu_CreateInfo()
		info.text = Module.MenuButtonList["name"]
		info.arg1 = {value = "name", unit = unit}
		info.func = Module.MenuButton_OnClick
		info.notCheckable = true
		UIDropDownMenu_AddButton(info)

		if IsInGuild() and UnitIsPlayer(unit) and not UnitCanAttack("player", unit) and not UnitIsUnit("player", unit) then
			info = UIDropDownMenu_CreateInfo()
			info.text = Module.MenuButtonList["guild"]
			info.arg1 = {value = "guild", unit = unit}
			info.func = Module.MenuButton_OnClick
			info.notCheckable = true
			UIDropDownMenu_AddButton(info)
		end
	end
end

function Module:CreateMenuButton_Add()
	Module.MenuButtonList = {
		["name"] = COPY_NAME,
		["guild"] = gsub(CHAT_GUILD_INVITE_SEND, HEADER_COLON, ""),
	}
	hooksecurefunc("UnitPopup_ShowMenu", Module.MenuButton_Show)
end

do
	-- Sourced: https://www.curseforge.com/wow/addons/questframefixer
	if not IsAddOnLoaded("QuestFrameFixer") then
		local ACTIVE_QUEST_ICON_FILEID = GetFileIDFromPath("Interface\\GossipFrame\\ActiveQuestIcon")
		local AVAILABLE_QUEST_ICON_FILEID = GetFileIDFromPath("Interface\\GossipFrame\\AvailableQuestIcon")

		local titleLines = {}
		local questIconTextures = {}

		for i = 1, MAX_NUM_QUESTS do
			local titleLine = _G["QuestTitleButton" .. i]
			table_insert(titleLines, titleLine)
			table_insert(questIconTextures, _G[titleLine:GetName() .. "QuestIcon"])
		end

		QuestFrameGreetingPanel:HookScript("OnShow", function()
			for i, titleLine in ipairs(titleLines) do
				if (titleLine:IsVisible()) then
					local bulletPointTexture = questIconTextures[i]
					if (titleLine.isActive == 1) then
						bulletPointTexture:SetTexture(ACTIVE_QUEST_ICON_FILEID)
					else
						bulletPointTexture:SetTexture(AVAILABLE_QUEST_ICON_FILEID)
					end
				end
			end
		end)
	end

	-- Sourced: https://www.curseforge.com/wow/addons/quest-icon-desaturation
	if not IsAddOnLoaded("QuestIconDesaturation") then
		local escapes = {
			["|c%x%x%x%x%x%x%x%x"] = "", -- color start
			["|r"] = "" -- color end
		}

		local function unescape(str)
			for k, v in pairs(escapes) do
				str = string_gsub(str, k, v)
			end

			return str
		end

		local completedActiveQuests = {}
		local function getCompletedQuestsInLog()
			table_wipe(completedActiveQuests)
			local numEntries = GetNumQuestLogEntries()
			local questLogTitleText, isComplete, questId, _
			for i = 1, numEntries, 1 do
				_, _, _, _, _, isComplete, _, questId = GetQuestLogTitle(i)
				if (isComplete == 1 or IsQuestComplete(questId)) then
					questLogTitleText = C_QuestLog_GetQuestInfo(questId)
					completedActiveQuests[questLogTitleText] = true
				end
			end

			return completedActiveQuests
		end

		local function setDesaturation(maxLines, lineMap, iconMap, activePred)
			local completedQuests = getCompletedQuestsInLog()
			for i = 1, maxLines do
				local line = lineMap[i]
				local icon = iconMap[i]
				icon:SetDesaturated(nil)
				if (line:IsVisible() and activePred(line)) then
					local questName = unescape(line:GetText())
					if (not completedQuests[questName]) then
						icon:SetDesaturated(1)
					end
				end
			end
		end

		local function getLineAndIconMaps(maxLines, titleIdent, iconIdent)
			local lines = {}
			local icons = {}
			for i = 1, maxLines do
				local titleLine = _G[titleIdent .. i]
				table_insert(lines, titleLine)
				table_insert(icons, _G[titleLine:GetName() .. iconIdent])
			end

			return lines, icons
		end

		local questFrameTitleLines, questFrameIconTextures = getLineAndIconMaps(MAX_NUM_QUESTS, "QuestTitleButton", "QuestIcon")
		QuestFrameGreetingPanel:HookScript("OnShow", function()
			setDesaturation(MAX_NUM_QUESTS, questFrameTitleLines, questFrameIconTextures, function(line)
				return line.isActive == 1
			end)
		end)

		local gossipFrameTitleLines, gossipFrameIconTextures = getLineAndIconMaps(NUMGOSSIPBUTTONS, "GossipTitleButton", "GossipIcon")
		hooksecurefunc("GossipFrameUpdate", function()
			setDesaturation(NUMGOSSIPBUTTONS, gossipFrameTitleLines, gossipFrameIconTextures, function(line)
				return line.type == "Active"
			end)
		end)
	end
end

function Module:OnEnable()
	self:CharacterStatePanel()
	self:CreateAFKCam()
	self:CreateBlockStrangerInvites()
	self:CreateBossEmote()
	self:CreateDurabilityFrameMove()
	self:CreateEnhanceAuctionDressup()
	self:CreateEnhanceNormalDressup()
	self:CreateErrorsFrame()
	self:CreateHelmCloakToggle()
	self:CreateImprovedMail()
	self:CreateMenuButton_Add()
	self:CreateMouseTrail()
	self:CreateMuteSounds()
	self:CreatePulseCooldown()
	self:CreateQuestSizeUpdate()
	self:CreateRaidMarker()
	self:CreateSlotDurability()
	self:CreateSlotItemLevel()
	self:CreateTicketStatusFrameMove()
	self:CreateTradeTabs()
	self:CreateTradeTargetInfo()

	K:RegisterEvent("PLAYER_REGEN_DISABLED", CreateErrorFrameToggle)

	-- Auto chatBubbles
	if C["Misc"].AutoBubbles then
		local function updateBubble()
			local name, instType = GetInstanceInfo()
			if name and instType == "raid" then
				SetCVar("chatBubbles", 1)
			else
				SetCVar("chatBubbles", 0)
			end
		end
		K:RegisterEvent("PLAYER_ENTERING_WORLD", updateBubble)
	end

	-- Instant delete
	local deleteDialog = StaticPopupDialogs["DELETE_GOOD_ITEM"]
	if deleteDialog.OnShow then
		hooksecurefunc(deleteDialog, "OnShow", function(self)
			self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
		end)
	end

	-- Fix blizz bug in addon list
	local _AddonTooltip_Update = AddonTooltip_Update
	function AddonTooltip_Update(owner)
		if not owner then
			return
		end

		if owner:GetID() < 1 then
			return
		end
		_AddonTooltip_Update(owner)
	end
end