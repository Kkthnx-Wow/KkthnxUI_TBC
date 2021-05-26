local K, C, L = unpack(select(2, ...))
local Module = K:NewModule("GameMenuTest")

local GUI = K["GUI"]

function Module:SetupGameMenu()
	if Module.GameMenuButtonKkthnxUI then
        GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + GameMenuButtonLogout:GetHeight() + 32)

		GameMenuButtonHelp:ClearAllPoints()
		GameMenuButtonHelp:SetPoint("CENTER", GameMenuFrame, "TOP", 0, -50)

		GameMenuButtonOptions:ClearAllPoints()
		GameMenuButtonOptions:SetPoint("TOP", GameMenuButtonHelp, "BOTTOM", 0, -6)

		GameMenuButtonUIOptions:ClearAllPoints()
		GameMenuButtonUIOptions:SetPoint("TOP", GameMenuButtonOptions, "BOTTOM", 0, -6)

		GameMenuButtonKeybindings:ClearAllPoints()
		GameMenuButtonKeybindings:SetPoint("TOP", GameMenuButtonUIOptions, "BOTTOM", 0, -6)

		GameMenuButtonMacros:ClearAllPoints()
		GameMenuButtonMacros:SetPoint("TOP", GameMenuButtonKeybindings, "BOTTOM", 0, -6)

		GameMenuButtonAddons:ClearAllPoints()
		GameMenuButtonAddons:SetPoint("TOP", GameMenuButtonMacros, "BOTTOM", 0, -6)

		GameMenuButtonLogout:ClearAllPoints()
		GameMenuButtonLogout:SetPoint("TOP", Module.GameMenuButtonKkthnxUI, "BOTTOM", 0, -18)

		GameMenuButtonQuit:ClearAllPoints()
		GameMenuButtonQuit:SetPoint("TOP", GameMenuButtonLogout, "BOTTOM", 0, -6)

		GameMenuButtonContinue:ClearAllPoints()
		GameMenuButtonContinue:SetPoint("TOP", GameMenuButtonQuit, "BOTTOM", 0, -18)

		Module.GameMenuButtonKkthnxUI:ClearAllPoints()
		Module.GameMenuButtonKkthnxUI:SetPoint("TOPLEFT", GameMenuButtonAddons, "BOTTOMLEFT", 0, -6)
	end
end

function Module:CreateGameMenu()
	Module.GameMenuButtonKkthnxUI = CreateFrame("Button", nil, GameMenuFrame, "GameMenuButtonTemplate")
	Module.GameMenuButtonKkthnxUI:SetSize(GameMenuButtonLogout:GetWidth(), GameMenuButtonLogout:GetHeight())
	Module.GameMenuButtonKkthnxUI:SetPoint("TOPLEFT", GameMenuButtonAddons, "BOTTOMLEFT", 0, -6)
	Module.GameMenuButtonKkthnxUI:SetText(K.InfoColor.."KkthnxUI|r")
	Module.GameMenuButtonKkthnxUI:SetScript("OnClick", function()
		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(K.InfoColor..ERR_NOT_IN_COMBAT)
			return
		end

		GUI:Toggle()
		HideUIPanel(GameMenuFrame)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	end)

	hooksecurefunc("GameMenuFrame_UpdateVisibleButtons", Module.SetupGameMenu)
end

function Module:OnEnable()
	Module:CreateGameMenu()

    do -- NZoth textures
		local texTop = GameMenuFrame:CreateTexture(nil, "OVERLAY", 7)
		local texBotomLeft = GameMenuFrame:CreateTexture(nil, "OVERLAY", 7)
		local texBottomRight = GameMenuFrame:CreateTexture(nil, "OVERLAY", 7)

		GameMenuFrame.textures = {
			TOP = texTop, BOTTOMLEFT = texBotomLeft, BOTTOMRIGHT = texBottomRight,
			Show = function() texTop:Show() texBotomLeft:Show() texBottomRight:Show() end,
			Hide = function() texTop:Hide() texBotomLeft:Hide() texBottomRight:Hide() end,
		}

		texTop:SetTexture([[Interface\AddOns\KkthnxUI\Media\Textures\NZothTop]])
		texTop:SetPoint("CENTER", GameMenuFrame, "TOP", 0, -19)
		texBotomLeft:SetTexture([[Interface\AddOns\KkthnxUI\Media\Textures\NZothBottomLeft]])
		texBotomLeft:SetPoint("BOTTOMLEFT", GameMenuFrame, "BOTTOMLEFT", -7, -10)
		texBottomRight:SetTexture([[Interface\AddOns\KkthnxUI\Media\Textures\NZothBottomRight]])
		texBottomRight:SetPoint("BOTTOMRIGHT", GameMenuFrame, "BOTTOMRIGHT", 7, -10)
	end

    GameMenuButtonLogoutText:SetTextColor(1, 1, 0)
    GameMenuButtonQuitText:SetTextColor(1, 0, 0)
    GameMenuButtonContinueText:SetTextColor(0, 1, 0)

	GameMenuFrameHeader:StripTextures()
	GameMenuFrameHeader:ClearAllPoints()
	GameMenuFrameHeader:SetPoint("TOP", GameMenuFrame, 0, 1)
    -- GameMenuFrameHeader.Text:SetFont(C["Media"].Fonts.KkthnxUIFont, 13)

    GameMenuFrame:StripTextures()
	GameMenuFrame:CreateBorder(nil, -1)

	for _, Button in pairs({GameMenuFrame:GetChildren()}) do
		if Button.IsObjectType and Button:IsObjectType("Button") then
			Button:SkinButton()
		end
	end
end

-------------------------------------
local helpCommands = {
	["checkquest"] = "|cff669DFF/checkquest ID|r or |cff669DFF/questcheck ID|r - Check the completion status of a quest",
	["clearchat"] = "|cff669DFF/clearchat|r - Clear your chat window of all text in it",
	["clearcombat"] = "|cff669DFF/clearcombat|r - Clear your combatlog of all text in it",
	["convert"] = "|cff669DFF/convert|r or |cff669DFF/toraid|r or |cff669DFF/toparty|r - Convert to party or raid and vise versa",
	["dbmtest"] = "|cff669DFF/dbmtest|r - Test DeadlyBossMods bars (Must have DBM installed/enabled)",
	["deleteheirlooms"] = "|cff669DFF/deleteheirlooms|r or |cff669DFF/deletelooms|r - Delete all heirlooms that are in your bags",
	["deletequestitems"] = "|cff669DFF/deletequestitems|r or |cff669DFF/dqi|r - Delete all quest items that are in your bags",
	["install"] = "|cff669DFF/install|r - Show KkthnxUI installer",
	["kaw"] = "|cff669DFF/kaw|r - Show KkthnxUI aurawatch configurations window",
	["kcl"] = "|cff669DFF/kcl|r - Show KkthnxUI most recent changelog",
	["killquests"] = "|cff669DFF/killquests|r - Remove all quests from your questlog",
	["kstatus"] = "|cff669DFF/kstatus|r - Show KkthnxUI status report window. Used to reporting bugs",
	["moveui"] = "|cff669DFF/moveui|r - Move 'most' KkthnxUI elements as you please",
	["rc"] = "|cff669DFF/rc|r - Start a readycheck on your current group",
	["ri"] = "|cff669DFF/ri|r - Reset the most recent instance you were in",
	["rl"] = "|cff669DFF/rl|r - Reload your user interface quickly",
	["statpriority"] = "|cff669DFF/ksp|r - Show commands for KthnxUI Stat Priority",
	["ticket"] = "|cff669DFF/ticket|r - Write a ticket to Blizzard for help",
	["grid"] = "|cff669DFF/grid #|r or |cff669DFF/align #|r - Display a grid which allows you to better align frames",
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

K["Help"] = Help

SlashCmdList["KKUI_HELP"] = function()
	K.Help:Show()
end
_G.SLASH_KKUI_HELP1 = "/khelp"
