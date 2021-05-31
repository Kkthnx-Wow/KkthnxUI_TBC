local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Infobar")

local format, sort, wipe, unpack, tinsert = string.format, table.sort, table.wipe, unpack, table.insert
local C_Timer_After = C_Timer.After
local C_FriendList_GetNumFriends = C_FriendList.GetNumFriends
local C_FriendList_GetNumOnlineFriends = C_FriendList.GetNumOnlineFriends
local C_FriendList_GetFriendInfoByIndex = C_FriendList.GetFriendInfoByIndex
local BNet_GetClientEmbeddedTexture, BNet_GetValidatedCharacterName, BNet_GetClientTexture = BNet_GetClientEmbeddedTexture, BNet_GetValidatedCharacterName, BNet_GetClientTexture
local CanCooperateWithGameAccount, GetRealZoneText, GetQuestDifficultyColor = CanCooperateWithGameAccount, GetRealZoneText, GetQuestDifficultyColor
local BNGetNumFriends, BNGetFriendInfo, BNGetGameAccountInfo, BNGetNumFriendGameAccounts, BNGetFriendGameAccountInfo = BNGetNumFriends, BNGetFriendInfo, BNGetGameAccountInfo, BNGetNumFriendGameAccounts, BNGetFriendGameAccountInfo
local HybridScrollFrame_GetOffset, HybridScrollFrame_Update = HybridScrollFrame_GetOffset, HybridScrollFrame_Update
local BNET_CLIENT_WOW, UNKNOWN, GUILD_ONLINE_LABEL, CHARACTER_FRIEND = BNET_CLIENT_WOW, UNKNOWN, GUILD_ONLINE_LABEL, CHARACTER_FRIEND
local FRIENDS_TEXTURE_ONLINE, FRIENDS_TEXTURE_AFK, FRIENDS_TEXTURE_DND = FRIENDS_TEXTURE_ONLINE, FRIENDS_TEXTURE_AFK, FRIENDS_TEXTURE_DND
local EXPANSION_NAME0 = EXPANSION_NAME0
local WOW_PROJECT_ID = WOW_PROJECT_ID or 5
local WOW_PROJECT_60 = WOW_PROJECT_CLASSIC or 2
local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE or 1
local CLIENT_WOW_DIFF = "WoV"

local r, g, b = K.r, K.g, K.b
local infoFrame, updateRequest, prevTime
local friendTable, bnetTable = {}, {}
local activeZone, inactiveZone = "|cff4cff4c", K.GreyColor
local noteString = "|TInterface\\Buttons\\UI-GuildButton-PublicNote-Up:16|t %s"
local broadcastString = "|TInterface\\FriendsFrame\\BroadcastIcon:12|t %s (%s)"

local menuList = {
	[1] = {text = "Join or Invite", isTitle = true, notCheckable = true}
}

local function sortFriends(a, b)
	if a[1] and b[1] then
		return a[1] < b[1]
	end
end

local function buildFriendTable(num)
	wipe(friendTable)

	for i = 1, num do
		local info = C_FriendList_GetFriendInfoByIndex(i)
		if info and info.connected then
			local status = FRIENDS_TEXTURE_ONLINE
			if info.afk then
				status = FRIENDS_TEXTURE_AFK
			elseif info.dnd then
				status = FRIENDS_TEXTURE_DND
			end
			local class = K.ClassList[info.className]
			tinsert(friendTable, {info.name, info.level, class, info.area, status})
		end
	end

	sort(friendTable, sortFriends)
end

local function sortBNFriends(a, b)
	if a[5] and b[5] then
		return a[5] > b[5]
	end
end

local function buildBNetTable(num)
	wipe(bnetTable)

	for i = 1, num do
		local _, accountName, battleTag, _, charName, gameID, _, isOnline, _, isAFK, isDND, broadcastText, note, _, broadcastTime = BNGetFriendInfo(i)
		if isOnline then
			local _, _, client, realmName, _, _, _, class, _, zoneName, level, gameText, _, _, _, _, _, isGameAFK, isGameBusy, _, wowProjectID = BNGetGameAccountInfo(gameID)

			charName = BNet_GetValidatedCharacterName(charName, battleTag, client)
			class = K.ClassList[class]

			local status, infoText
			if isAFK or isGameAFK then
				status = FRIENDS_TEXTURE_AFK
			elseif isDND or isGameBusy then
				status = FRIENDS_TEXTURE_DND
			else
				status = FRIENDS_TEXTURE_ONLINE
			end
			if client == BNET_CLIENT_WOW and wowProjectID == WOW_PROJECT_ID then
				if not zoneName or zoneName == "" then
					infoText = UNKNOWN
				else
					infoText = zoneName
				end
			else
				if wowProjectID == WOW_PROJECT_MAINLINE then
					infoText = CHARACTER_FRIEND
				elseif wowProjectID == WOW_PROJECT_60 then
					infoText = EXPANSION_NAME0
				else
					infoText = gameText
				end
			end
			if client == BNET_CLIENT_WOW and wowProjectID ~= WOW_PROJECT_ID then client = CLIENT_WOW_DIFF end

			tinsert(bnetTable, {i, accountName, charName, gameID, client, realmName, status, class, level, infoText, note, broadcastText, broadcastTime})
		end
	end

	sort(bnetTable, sortBNFriends)
end

local function isPanelCanHide(self, elapsed)
	self.timer = (self.timer or 0) + elapsed
	if self.timer > .1 then
		if not infoFrame:IsMouseOver() then
			self:Hide()
			self:SetScript("OnUpdate", nil)
		end

		self.timer = 0
	end
end

function Module:FriendsPanel_Init()
	if infoFrame then
		infoFrame:Show()
		return
	end

	infoFrame = CreateFrame("Frame", "KKUI_FriendsFrame", Module.FriendsDataTextFrame)
	infoFrame:SetSize(400, 495)
	infoFrame:SetPoint("BOTTOMLEFT", Module.FriendsDataTextFrame, "TOPRIGHT", 2, 2)
	infoFrame:SetClampedToScreen(true)
	infoFrame:SetFrameStrata("DIALOG")
	infoFrame:CreateBorder()

	infoFrame:SetScript("OnLeave", function(self)
		self:SetScript("OnUpdate", isPanelCanHide)
	end)

	infoFrame:SetScript("OnHide", function()
		if K.EasyMenu:IsShown() then
			K.EasyMenu:Hide()
		end
	end)

	K.CreateFontString(infoFrame, 14, "|cff0099ff"..FRIENDS_LIST, "", nil, "TOPLEFT", 15, -10)
	infoFrame.friendCountText = K.CreateFontString(infoFrame, 13, "-/-", "", nil, "TOPRIGHT", -15, -12)
	infoFrame.friendCountText:SetTextColor(0, .6, 1)

	local scrollFrame = CreateFrame("ScrollFrame", "KKUI_FriendsInfobarScrollFrame", infoFrame, "HybridScrollFrameTemplate")
	scrollFrame:SetSize(370, 400)
	scrollFrame:SetPoint("TOPLEFT", 4, -35)
	infoFrame.scrollFrame = scrollFrame

	local scrollBar = CreateFrame("Slider", "$parentScrollBar", scrollFrame, "HybridScrollBarTemplate")
	scrollBar.doNotHide = true
	scrollBar:SkinScrollBar()
	scrollFrame.scrollBar = scrollBar

	local scrollChild = scrollFrame.scrollChild
	local numButtons = 20 + 1
	local buttonHeight = 22
	local buttons = {}
	for i = 1, numButtons do
		buttons[i] = Module:FriendsPanel_CreateButton(scrollChild, i)
	end

	scrollFrame.buttons = buttons
	scrollFrame.buttonHeight = buttonHeight
	scrollFrame.update = Module.FriendsPanel_Update
	scrollFrame:SetScript("OnMouseWheel", Module.FriendsPanel_OnMouseWheel)
	scrollChild:SetSize(scrollFrame:GetWidth(), numButtons * buttonHeight)
	scrollFrame:SetVerticalScroll(0)
	scrollFrame:UpdateScrollChildRect()
	scrollBar:SetMinMaxValues(0, numButtons * buttonHeight)
	scrollBar:SetValue(0)

	K.CreateFontString(infoFrame, 12, Module.LineString, "", false, "BOTTOMRIGHT", -12, 42)
	local whspInfo = K.InfoColor..K.RightButton..L["Whisper"]
	K.CreateFontString(infoFrame, 12, whspInfo, "", false, "BOTTOMRIGHT", -15, 26)
	local invtInfo = K.InfoColor.."ALT +"..K.LeftButton..L["Invite"]
	K.CreateFontString(infoFrame, 12, invtInfo, "", false, "BOTTOMRIGHT", -15, 10)
end

local function inviteFunc(_, bnetIDGameAccount, guid)
	FriendsFrame_InviteOrRequestToJoin(guid, bnetIDGameAccount)
end

local function buttonOnClick(self, btn)
	if btn == "LeftButton" then
		if IsAltKeyDown() then
			if self.isBNet then
				local index = 2
				if #menuList > 1 then
					for i = 2, #menuList do
						table.wipe(menuList[i])
					end
				end

				local numGameAccounts = BNGetNumFriendGameAccounts(self.data[1])
				local lastGameAccountID, lastGameAccountGUID
				if numGameAccounts > 0 then
					for i = 1, numGameAccounts do
						local _, charName, client, _, _, _, _, class, _, _, _, _, _, _, _, bnetIDGameAccount, _, _, _, guid = BNGetFriendGameAccountInfo(self.data[1], i)
						if client == BNET_CLIENT_WOW and CanCooperateWithGameAccount(bnetIDGameAccount) then
							if not menuList[index] then
								menuList[index] = {}
							end

							menuList[index].text = K.RGBToHex(K.ClassColor(K.ClassList[class]))..charName
							menuList[index].notCheckable = true
							menuList[index].arg1 = bnetIDGameAccount
							menuList[index].arg2 = guid
							menuList[index].func = inviteFunc
							lastGameAccountID = bnetIDGameAccount
							lastGameAccountGUID = guid

							index = index + 1
						end
					end
				end

				if index == 2 then
					return
				end

				if index == 3 then
					FriendsFrame_InviteOrRequestToJoin(lastGameAccountGUID, lastGameAccountID)
				else
					EasyMenu(menuList, K.EasyMenu, self, 0, 0, "MENU", 1)
				end
			else
				InviteToGroup(self.data[1])
			end
		end
	else
		if self.isBNet then
			ChatFrame_SendBNetTell(self.data[2])
		else
			ChatFrame_SendTell(self.data[1], SELECTED_DOCK_FRAME)
		end
	end
end

local function buttonOnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", infoFrame, "TOPRIGHT", 5, 2)
	GameTooltip:ClearLines()
	if self.isBNet then
		GameTooltip:AddLine(L["BN"], 0,.6,1)
		GameTooltip:AddLine(" ")

		local index, accountName, _, _, _, _, _, _, _, _, note, broadcastText, broadcastTime = unpack(self.data)
		local numGameAccounts = BNGetNumFriendGameAccounts(index)
		for i = 1, numGameAccounts do
			local _, charName, client, realmName, _, faction, _, class, _, zoneName, level, gameText, _, _, _, _, _, _, _, _, wowProjectID = BNGetFriendGameAccountInfo(index, i)
			local clientString = BNet_GetClientEmbeddedTexture(client, 16)
			if client == BNET_CLIENT_WOW then
				realmName = (K.Realm == realmName or realmName == "") and "" or "-"..realmName

				-- Get realm name from gameText
				if wowProjectID == WOW_PROJECT_MAINLINE then
					local zone, realm = string.match(gameText, "(.-)%s%-%s(.+)")
					if realm then
						gameText, realmName = zone, "-"..realm
					end
				elseif wowProjectID == WOW_PROJECT_60 then
					gameText = zoneName
				end

				class = K.ClassList[class]
				local classColor = K.RGBToHex(K.ColorClass(class))
				if faction == "Horde" then
					clientString = "|TInterface\\FriendsFrame\\PlusManz-Horde:16:|t"
				elseif faction == "Alliance" then
					clientString = "|TInterface\\FriendsFrame\\PlusManz-Alliance:16:|t"
				end
				GameTooltip:AddLine(format("%s%s %s%s%s", clientString, level, classColor, charName, realmName))

				if wowProjectID ~= WOW_PROJECT_ID then
					zoneName = "*"..gameText
				end

				GameTooltip:AddLine(format("%s%s", inactiveZone, zoneName))
			else
				GameTooltip:AddLine(format("|cffffffff%s%s", clientString, accountName))
				if gameText ~= "" then
					GameTooltip:AddLine(format("%s%s", inactiveZone, gameText))
				end
			end
		end

		if note and note ~= "" then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(format(noteString, note), 1,.8,0)
		end

		if broadcastText and broadcastText ~= "" then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(format(broadcastString, broadcastText, FriendsFrame_GetLastOnline(broadcastTime)), .3,.6,.8, 1)
		end
	else
		GameTooltip:AddLine(L["WoW"], 1,.8,0)
		GameTooltip:AddLine(" ")

		local name, level, class, area = unpack(self.data)
		local classColor = K.RGBToHex(K.ClassColor(class))
		GameTooltip:AddLine(format("%s %s%s", level, classColor, name))
		GameTooltip:AddLine(format("%s%s", inactiveZone, area))
	end
	GameTooltip:Show()
end

function Module:FriendsPanel_CreateButton(parent, index)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(370, 20)
	button:SetPoint("TOPLEFT", 0, - (index-1) *20)
	button.HL = button:CreateTexture(nil, "HIGHLIGHT")
	button.HL:SetAllPoints()
	button.HL:SetColorTexture(r, g, b, .2)

	button.status = button:CreateTexture(nil, "ARTWORK")
	button.status:SetPoint("LEFT", button, 5, 0)
	button.status:SetSize(16, 16)

	button.name = K.CreateFontString(button, 12, "Tag (name)", "", false, "LEFT", 25, 0)
	button.name:SetPoint("RIGHT", button, "LEFT", 230, 0)
	button.name:SetJustifyH("LEFT")
	button.name:SetTextColor(.5, .7, 1)

	button.zone = K.CreateFontString(button, 12, "Zone", "", false, "RIGHT", -28, 0)
	button.zone:SetPoint("LEFT", button, "RIGHT", -130, 0)
	button.zone:SetJustifyH("RIGHT")

	button.gameIcon = button:CreateTexture(nil, "ARTWORK")
	button.gameIcon:SetPoint("RIGHT", button, -8, 0)
	button.gameIcon:SetSize(16, 16)
	button.gameIcon:SetTexCoord(.17, .83, .17, .83)

	button.gameIcon.border = CreateFrame("Frame", nil, button)
	button.gameIcon.border:SetFrameLevel(button:GetFrameLevel())
	button.gameIcon.border:SetAllPoints(button.gameIcon)
	button.gameIcon.border:CreateBorder()

	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick", buttonOnClick)
	button:SetScript("OnEnter", buttonOnEnter)
	button:SetScript("OnLeave", K.HideTooltip)

	return button
end

function Module:FriendsPanel_UpdateButton(button)
	local index = button.index
	local onlineFriends = Module.onlineFriends

	if index <= onlineFriends then
		local name, level, class, area, status = unpack(friendTable[index])
		button.status:SetTexture(status)

		local zoneColor = GetRealZoneText() == area and activeZone or inactiveZone
		local levelColor = K.RGBToHex(GetQuestDifficultyColor(level))
		local classColor = K.ClassColors[class] or levelColor
		button.name:SetText(format("%s%s|r %s%s", levelColor, level, K.RGBToHex(classColor), name))
		button.zone:SetText(format("%s%s", zoneColor, area))
		button.gameIcon:SetTexture(BNet_GetClientTexture(BNET_CLIENT_WOW))

		button.isBNet = nil
		button.data = friendTable[index]
	else
		local bnetIndex = index-onlineFriends
		local _, accountName, charName, gameID, client, _, status, class, _, infoText = unpack(bnetTable[bnetIndex])

		button.status:SetTexture(status)
		local zoneColor = inactiveZone
		local name = inactiveZone..charName
		if client == BNET_CLIENT_WOW then
			if CanCooperateWithGameAccount(gameID) then
				local color = K.ClassColors[class] or GetQuestDifficultyColor(1)
				name = K.RGBToHex(color)..charName
			end
			zoneColor = GetRealZoneText() == infoText and activeZone or inactiveZone
		end
		button.name:SetText(format("%s%s|r (%s|r)", K.InfoColor, accountName, name))
		button.zone:SetText(format("%s%s", zoneColor, infoText))

		if client == CLIENT_WOW_DIFF then
			button.gameIcon:SetTexture(BNet_GetClientTexture(BNET_CLIENT_WOW))
			button.gameIcon:SetVertexColor(.3, .3, .3)
		else
			button.gameIcon:SetTexture(BNet_GetClientTexture(client))
			button.gameIcon:SetVertexColor(1, 1, 1)
		end

		button.isBNet = true
		button.data = bnetTable[bnetIndex]
	end
end

function Module:FriendsPanel_Update()
	local scrollFrame = KKUI_FriendsInfobarScrollFrame
	local usedHeight = 0
	local buttons = scrollFrame.buttons
	local height = scrollFrame.buttonHeight
	local numFriendButtons = Module.totalOnline
	local offset = HybridScrollFrame_GetOffset(scrollFrame)

	for i = 1, #buttons do
		local button = buttons[i]
		local index = offset + i
		if index <= numFriendButtons then
			button.index = index
			Module:FriendsPanel_UpdateButton(button)
			usedHeight = usedHeight + height
			button:Show()
		else
			button.index = nil
			button:Hide()
		end
	end

	HybridScrollFrame_Update(scrollFrame, numFriendButtons*height, usedHeight)
end

function Module:FriendsPanel_OnMouseWheel(delta)
	local scrollBar = self.scrollBar
	local step = delta * self.buttonHeight
	if IsShiftKeyDown() then
		step = step * 19
	end

	scrollBar:SetValue(scrollBar:GetValue() - step)
	Module:FriendsPanel_Update()
end

function Module:FriendsPanel_Refresh()
	local numFriends = C_FriendList_GetNumFriends()
	local onlineFriends = C_FriendList_GetNumOnlineFriends()
	local numBNet, onlineBNet = BNGetNumFriends()
	local totalOnline = onlineFriends + onlineBNet
	local totalFriends = numFriends + numBNet

	Module.numFriends = numFriends
	Module.onlineFriends = onlineFriends
	Module.numBNet = numBNet
	Module.onlineBNet = onlineBNet
	Module.totalOnline = totalOnline
	Module.totalFriends = totalFriends
end

local function FriendsPanel_OnEnter()
	local thisTime = GetTime()
	if not prevTime or (thisTime - prevTime > 5) then
		Module:FriendsPanel_Refresh()
		prevTime = thisTime
	end

	local numFriends = Module.numFriends
	local numBNet = Module.numBNet
	local totalOnline = Module.totalOnline
	local totalFriends = Module.totalFriends

	if totalOnline == 0 then
		GameTooltip:SetOwner(Module.FriendsDataTextFrame, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMRIGHT", Module.FriendsDataTextFrame, "TOPRIGHT", 5, 2)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(FRIENDS_LIST, format("%s: %s/%s", GUILD_ONLINE_LABEL, totalOnline, totalFriends), 0,.6,1, 0,.6,1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(NONE, 1,1,1)
		GameTooltip:Show()
		return
	end

	if not updateRequest then
		if numFriends > 0 then
			buildFriendTable(numFriends)
		end

		if numBNet > 0 then
			buildBNetTable(numBNet)
		end

		updateRequest = true
	end

	if KKUI_GuildInfobar and KKUI_GuildInfobar:IsShown() then
		KKUI_GuildInfobar:Hide()
	end

	Module:FriendsPanel_Init()
	Module:FriendsPanel_Update()
	infoFrame.friendCountText:SetText(format("%s: %s/%s", GUILD_ONLINE_LABEL, totalOnline, totalFriends))
end

local function FriendsPanel_OnEvent()
	Module:FriendsPanel_Refresh()
	Module.FriendsDataTextFrame.Text:SetText(format("%s: "..K.MyClassColor.."%d", FRIENDS, Module.totalOnline))

	updateRequest = false
	if infoFrame and infoFrame:IsShown() then
		FriendsPanel_OnEnter()
	end
end

local function delayLeave()
	if MouseIsOver(infoFrame) then
		return
	end

	infoFrame:Hide()
end

local function FriendsPanel_OnLeave()
	GameTooltip:Hide()
	if not infoFrame then
		return
	end

	C_Timer_After(.1, delayLeave)
end

local function FriendsPanel_OnMouseUp(_, btn)
	if btn ~= "LeftButton" then
		return
	end

	if infoFrame then
		infoFrame:Hide()
	end

	ToggleFrame(FriendsFrame)
end

function Module:CreateSocialDataText()
	if not C["DataText"].Friends then
		return
	end

	Module.FriendsDataTextFrame = CreateFrame("Button", nil, UIParent)
	Module.FriendsDataTextFrame:SetPoint("LEFT", UIParent, "LEFT", 4, -270)
	Module.FriendsDataTextFrame:SetSize(32, 32)

	Module.FriendsDataTextFrame.Texture = Module.FriendsDataTextFrame:CreateTexture(nil, "BACKGROUND")
	Module.FriendsDataTextFrame.Texture:SetPoint("LEFT", Module.FriendsDataTextFrame, "LEFT", 0, 0)
	Module.FriendsDataTextFrame.Texture:SetTexture("Interface\\HELPFRAME\\ReportLagIcon-Chat")
	Module.FriendsDataTextFrame.Texture:SetSize(32, 32)

	Module.FriendsDataTextFrame.Text = Module.FriendsDataTextFrame:CreateFontString(nil, "ARTWORK")
	Module.FriendsDataTextFrame.Text:SetFontObject(K.GetFont(C["UIFonts"].DataTextFonts))
	Module.FriendsDataTextFrame.Text:SetPoint("LEFT", Module.FriendsDataTextFrame.Texture, "RIGHT", 0, 0)

	Module.FriendsDataTextFrame:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE", FriendsPanel_OnEvent)
	Module.FriendsDataTextFrame:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE", FriendsPanel_OnEvent)
	Module.FriendsDataTextFrame:RegisterEvent("BN_FRIEND_INFO_CHANGED", FriendsPanel_OnEvent)
	Module.FriendsDataTextFrame:RegisterEvent("FRIENDLIST_UPDATE", FriendsPanel_OnEvent)
	Module.FriendsDataTextFrame:RegisterEvent("PLAYER_ENTERING_WORLD", FriendsPanel_OnEvent)

	Module.FriendsDataTextFrame:SetScript("OnMouseUp", FriendsPanel_OnMouseUp)
	Module.FriendsDataTextFrame:SetScript("OnEnter", FriendsPanel_OnEnter)
	Module.FriendsDataTextFrame:SetScript("OnLeave", FriendsPanel_OnLeave)
	Module.FriendsDataTextFrame:SetScript("OnEvent", FriendsPanel_OnEvent)

	K.Mover(Module.FriendsDataTextFrame, "FriendsDataText", "FriendsDataText", {"LEFT", UIParent, "LEFT", 4, -270})
end