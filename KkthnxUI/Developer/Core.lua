local K, C, L = unpack(select(2, ...))
local Module = K:NewModule("DevCore")

local GUI = K["GUI"]

function Module:OnEnable()
	local gui = CreateFrame("Button", "KKUI_GameMenuFrame", GameMenuFrame, "GameMenuButtonTemplate, BackdropTemplate")
	gui:SetText(K.InfoColor.."KkthnxUI|r")
	gui:SetPoint("TOP", GameMenuButtonAddons, "BOTTOM", 0, -21)
	GameMenuFrame:HookScript("OnShow", function(self)
		GameMenuButtonLogout:SetPoint("TOP", gui, "BOTTOM", 0, -21)
		self:SetHeight(self:GetHeight() + gui:GetHeight() + 22)
	end)

	gui:SetScript("OnClick", function()
		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(K.InfoColor..ERR_NOT_IN_COMBAT)
			return
		end

		GUI:Toggle()
		HideUIPanel(GameMenuFrame)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	end)
end

do
	local helpCommands = {
		["checkquest"] = "|cff669DFF/checkquest ID|r or |cff669DFF/questcheck ID|r - Check the completion status of a quest",
		["clearchat"] = "|cff669DFF/clearchat|r - Clear your chat window of all text in it",
		["clearcombat"] = "|cff669DFF/clearcombat|r - Clear your combatlog of all text in it",
		["convert"] = "|cff669DFF/convert|r or |cff669DFF/toraid|r or |cff669DFF/toparty|r - Convert to party or raid and vise versa",
		["dbmtest"] = "|cff669DFF/dbmtest|r - Test DeadlyBossMods bars (Must have DBM installed/enabled)",
		["deletequestitems"] = "|cff669DFF/deletequestitems|r or |cff669DFF/dqi|r - Delete all quest items that are in your bags",
		["grid"] = "|cff669DFF/grid #|r or |cff669DFF/align #|r - Display a grid which allows you to better align frames",
		["install"] = "|cff669DFF/install|r - Show KkthnxUI installer",
		["kaw"] = "|cff669DFF/kaw|r - Show KkthnxUI aurawatch configurations window",
		["kcl"] = "|cff669DFF/kcl|r - Show KkthnxUI most recent changelog",
		["killquests"] = "|cff669DFF/killquests|r - Remove all quests from your questlog",
		["kstatus"] = "|cff669DFF/kstatus|r - Show KkthnxUI status report window. Used to reporting bugs",
		["moveui"] = "|cff669DFF/moveui|r - Move 'most' KkthnxUI elements as you please",
		["rc"] = "|cff669DFF/rc|r - Start a readycheck on your current group",
		["ri"] = "|cff669DFF/ri|r - Reset the most recent instance you were in",
		["rl"] = "|cff669DFF/rl|r - Reload your user interface quickly",
		["ticket"] = "|cff669DFF/ticket|r - Write a ticket to Blizzard for help",
		["trackingdebuffs"] = "|cff669DFF/tracking|r or |cff669DFF/kt|r - Add/remove debuff tracking for auras on raid",
	}

	local Help = CreateFrame("Frame", "KKUI_Help", UIParent)
	local Texts = {}
	local Count = 1

	function Help:Enable()
		self:SetSize(600, 500)
		self:SetPoint("TOP", UIParent, "TOP", 0, -200)
		self:CreateBorder()

		self.Logo = self:CreateTexture(nil, "OVERLAY")
		self.Logo:SetSize(512, 256)
		self.Logo:SetBlendMode("ADD")
		self.Logo:SetAlpha(0.06)
		self.Logo:SetTexture(C["Media"].Textures.LogoTexture)
		self.Logo:SetPoint("CENTER", self, "CENTER", 0, 0)

		self.Title = self:CreateFontString(nil, "OVERLAY")
		self.Title:SetFontObject(KkthnxUIFont)
		self.Title:SetFont(select(1, self.Title:GetFont()), 22, select(3, self.Title:GetFont()))
		self.Title:SetPoint("TOP", self, "TOP", 0, -8)
		self.Title:SetText(K.InfoColor.."KkthnxUI|r "..K.SystemColor.."Commands Help|r")

		local ll = CreateFrame("Frame", nil, self)
		ll:SetPoint("TOP", self.Title, -100, -30)
		K.CreateGF(ll, 200, 1, "Horizontal", .7, .7, .7, 0, .7)
		ll:SetFrameStrata("HIGH")
		local lr = CreateFrame("Frame", nil, self)
		lr:SetPoint("TOP", self.Title, 100, -30)
		K.CreateGF(lr, 200, 1, "Horizontal", .7, .7, .7, .7, 0)
		lr:SetFrameStrata("HIGH")

		self.Close = CreateFrame("Button", nil, self)
		self.Close:SetSize(32, 32)
		self.Close:SetPoint("TOPRIGHT", self, "TOPRIGHT", -4, -4)
		self.Close:SkinCloseButton()
		self.Close:SetScript("OnClick", function(self) self:GetParent():Hide() end)

		for Index, Value in pairs(helpCommands) do
			Texts[Index] = self:CreateFontString(nil, "OVERLAY")
			Texts[Index]:SetFontObject(KkthnxUIFont)
			Texts[Index]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 20, 22 * Count)
			Texts[Index]:SetText(Value)

			Count = Count + 1
		end

		self:Hide()
	end

	Help:Enable()

	SlashCmdList["KKUI_HELP"] = function()
		Help:Show()
	end
	_G.SLASH_KKUI_HELP1 = "/khelp"
end

do
	-- Function to show vendor price
	local function ShowSellPrice(tooltip, tooltipObject)
		if IsAddOnLoaded("Leatrix_Plus") then
			return
		end

		if tooltip.shownMoneyFrames then
			return
		end

		tooltipObject = tooltipObject or GameTooltip

		-- Get container
		local container = GetMouseFocus()
		if not container then
			return
		end

		-- Get item
		local _, itemlink = tooltipObject:GetItem()
		if not itemlink then
			return
		end

		local _, _, _, _, _, _, _, _, _, _, sellPrice, classID = GetItemInfo(itemlink)
		if sellPrice and sellPrice > 0 then
			local count = container and type(container.count) == "number" and container.count or 1
			if sellPrice and count > 0 then
				if classID and classID == 11 then -- Fix for quiver/ammo pouch so ammo is not included
					count = 1
				end
				SetTooltipMoney(tooltip, sellPrice * count, "STATIC", SELL_PRICE .. ":")
			end
		end

		-- Refresh chat tooltips
		if tooltipObject == ItemRefTooltip then
			ItemRefTooltip:Show()
		end
	end

	-- Show vendor price when tooltips are shown
	GameTooltip:HookScript("OnTooltipSetItem", ShowSellPrice)
	hooksecurefunc(GameTooltip, "SetHyperlink", function(tip) ShowSellPrice(tip, GameTooltip) end)
	hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(tip) ShowSellPrice(tip, ItemRefTooltip) end)
end


do
	if IsAddOnLoaded("Anti-Deluxe") then
		local function FuckYou_AntiDeluxe() -- Dont let others hook and change this
			local buffs, i = { }, 1
			local buff = UnitBuff("target", i)
			local check = ""
			local setEmotes = {"CHEER", "HUG", "CLAP", "CONGRATS", "GLAD"} -- make it interesting

			while buff do
				buffs[#buffs + 1] = buff
				i = i + 1
				buff = UnitBuff("target", i)
			end

			buffs = table.concat(buffs, ", ")
			if string.match(buffs, "Reawakened") then
				Check = "False"
				DeluxeAndy = GetUnitName("target")

				if DeluxeAndy == K.Name then -- Dont cheer yourself -.-
					return
				end

				for _, v in pairs(MountOwners) do
					if v == DeluxeAndy then
						Check = "True"
						break
					end
				end

				if Check == "False" then -- No Need to keep emoting the same person
					DoEmote(setEmotes[math.random(1, #setEmotes)])
					table.insert(MountOwners, DeluxeAndy)
				end
			end
		end

		BuffCheck = FuckYou_AntiDeluxe -- Hook this shitty addon to fix the shitty choices this dev has made
	end
end

-- function FuckYou_Spitters(_, msg, sender)
-- 	if msg and msg:find("spits on you") then
-- 		local Responses = {"Spit on me Daddy", "Oh yeah I like it dirty", "uWu thanks"}
-- 		SendChatMessage(Responses[math.random(1, #Responses)], "WHISPER", nil, sender)
-- 	end
-- end

-- local frame = CreateFrame("Frame")
-- frame:RegisterEvent("PLAYER_LOGIN")
-- frame:RegisterEvent("CHAT_MSG_EMOTE")
-- frame:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
-- frame:SetScript("OnEvent", function(self, event)
-- 	FuckYou_Spitters()
-- end)

do
	local KKUI_ShowHelm = CreateFrame('CheckButton', "KKUI_ShowHelmButton", PaperDollFrame, "ChatConfigCheckButtonTemplate")
	KKUI_ShowHelm:SetPoint("TOPLEFT", 70, -246)
	KKUI_ShowHelm:SetSize(16, 16)
	KKUI_ShowHelm:SetFrameStrata("HIGH")
	KKUI_ShowHelm:SkinCheckBox()
	KKUI_ShowHelm:SetAlpha(0.25)

	local KKUI_ShowHelm_Text = KKUI_ShowHelm:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	KKUI_ShowHelm_Text:SetText("Helm")
	KKUI_ShowHelm_Text:SetPoint("LEFT", KKUI_ShowHelm, "RIGHT", 4, 0)
	KKUI_ShowHelm:SetHitRectInsets(3, -KKUI_ShowHelm_Text:GetStringWidth(), 0, 0)

	KKUI_ShowHelm:HookScript("OnEnter", function(self)
		UIFrameFadeIn(self, 0.25, self:GetAlpha(), 1)
	end)

	KKUI_ShowHelm:HookScript("OnLeave", function(self)
		UIFrameFadeOut(self, 1, self:GetAlpha(), 0.25)
	end)

	KKUI_ShowHelm:HookScript("OnClick", function(self)
		self:Disable()
		self:SetAlpha(1.0)
		C_Timer.After(0.5, function()
			if ShowingHelm() then
				ShowHelm(false)
			else
				ShowHelm(true)
			end
			self:Enable()
			if not self:IsMouseOver() then
				self:SetAlpha(0.25)
			end
		end)
	end)

	local KKUI_ShowCloak = CreateFrame('CheckButton', "KKUI_ShowCloakButton", PaperDollFrame, "ChatConfigCheckButtonTemplate")
	KKUI_ShowCloak:SetPoint("TOPLEFT", 277, -246)
	KKUI_ShowCloak:SetSize(16, 16)
	KKUI_ShowCloak:SetFrameStrata("HIGH")
	KKUI_ShowCloak:SkinCheckBox()
	KKUI_ShowCloak:SetAlpha(0.25)

	local KKUI_ShowCloak_Text = KKUI_ShowCloak:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	KKUI_ShowCloak_Text:SetJustifyH("RIGHT")
	KKUI_ShowCloak_Text:SetWordWrap(false)
	KKUI_ShowCloak_Text:SetText("Cloak")
	KKUI_ShowCloak_Text:SetPoint("RIGHT", KKUI_ShowCloak, "LEFT", -2, 0)
	KKUI_ShowCloak:SetHitRectInsets(-KKUI_ShowCloak_Text:GetStringWidth(), 3, 0, 0)

	KKUI_ShowCloak:HookScript("OnEnter", function(self)
		UIFrameFadeIn(self, 0.25, self:GetAlpha(), 1)
	end)

	KKUI_ShowCloak:HookScript("OnLeave", function(self)
		UIFrameFadeOut(self, 1, self:GetAlpha(), 0.25)
	end)

	KKUI_ShowCloak:HookScript("OnClick", function(self)
		self:Disable()
		self:SetAlpha(1.0)
		C_Timer.After(0.5, function()
			if ShowingCloak() then
				ShowCloak(false)
			else
				ShowCloak(true)
			end
			self:Enable()
			if not self:IsMouseOver() then
				self:SetAlpha( 0.25)
			end
		end)
	end)

	KKUI_ShowCloak:HookScript("OnShow", function()
		if ShowingHelm() then
			KKUI_ShowHelm:SetChecked(true)
		else
			KKUI_ShowHelm:SetChecked(false)
		end

		if ShowingCloak() then
			KKUI_ShowCloak:SetChecked(true)
		else
			KKUI_ShowCloak:SetChecked(false)
		end
	end)
end