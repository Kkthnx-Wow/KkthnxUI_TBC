local K, C = unpack(select(2, ...))
local Bar = K:GetModule("ActionBar")

local _G = _G
local tinsert, pairs, type = table.insert, pairs, type
local buttonList = {}

function Bar:MicroButton_SetupTexture(icon, texture)
	icon:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\MicroMenu\\"..texture)
	icon:SetTexCoord(0.17, 0.87, 0.5, 0.908)
	icon:SetAllPoints()
end

local function ResetButtonParent(button, parent)
	if parent ~= button.__owner then
		button:SetParent(button.__owner)
	end
end

local function ResetButtonAnchor(button)
	button:ClearAllPoints()
	button:SetAllPoints()
end

function Bar:MicroButton_Create(parent, data)
	local texture, method, tooltip = unpack(data)

	local bu = CreateFrame("Frame", nil, parent)
	tinsert(buttonList, bu)
	bu:SetSize(22, 28)
	bu:SetFrameLevel(parent:GetFrameLevel())
	bu:CreateBorder()

	local icon = bu:CreateTexture(nil, "ARTWORK")
	Bar:MicroButton_SetupTexture(icon, texture)

	if type(method) == "string" then
		local button = _G[method]
		button:SetHitRectInsets(0, 0, 0, 0)
		button:SetParent(bu)
		button.__owner = bu

		hooksecurefunc(button, "SetParent", ResetButtonParent)
		ResetButtonAnchor(button)
		hooksecurefunc(button, "SetPoint", ResetButtonAnchor)

		button:UnregisterAllEvents()
		button:SetNormalTexture(nil)
		button:SetPushedTexture(nil)
		button:SetDisabledTexture(nil)

		if tooltip then
			button.title = "|cffffffff"..tooltip
			K.AddTooltip(button, "ANCHOR_RIGHT", button.newbieText, "system")
		end

		local hl = button:GetHighlightTexture()
		Bar:MicroButton_SetupTexture(hl, texture)

		local flash = button.Flash
		Bar:MicroButton_SetupTexture(flash, texture)
	else
		bu:SetScript("OnMouseUp", method)
		K.AddTooltip(bu, "ANCHOR_RIGHT", tooltip)

		local hl = bu:CreateTexture(nil, "HIGHLIGHT")
		hl:SetBlendMode("ADD")
		Bar:MicroButton_SetupTexture(hl, texture)
	end
end

function Bar:CreateMicroMenu()
	if not C["ActionBar"].MicroBar then
		return
	end

	local menubar = CreateFrame("Frame", nil, UIParent)
	menubar:SetSize(218, 28)
	K.Mover(menubar, "Menubar", "Menubar", {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -4, 4})

	-- Generate Buttons
	local buttonInfo = {
		{K.Class, "CharacterMicroButton", MicroButtonTooltipText(CHARACTER_BUTTON, "TOGGLECHARACTER0")},
		{"spellbook", "SpellbookMicroButton", MicroButtonTooltipText(SPELLBOOK_ABILITIES_BUTTON, "TOGGLESPELLBOOK")},
		{"talents", "TalentMicroButton", MicroButtonTooltipText(TALENTS, "TOGGLETALENTS")},
		{"quests", "QuestLogMicroButton", MicroButtonTooltipText(QUESTLOG_BUTTON, "TOGGLEQUESTLOG")},
		{"social", "SocialsMicroButton", MicroButtonTooltipText(SOCIAL_BUTTON, "TOGGLESOCIAL")},
		{"worldmap", "WorldMapMicroButton", MicroButtonTooltipText(WORLDMAP_BUTTON, "TOGGLEWORLDMAP")},
		{"options", "MainMenuMicroButton", MicroButtonTooltipText(MAINMENU_BUTTON, "TOGGLEGAMEMENU")},
		{"help", "HelpMicroButton", MicroButtonTooltipText(HELP_BUTTON, "TOGGLEHELP")},
	}

	for _, info in pairs(buttonInfo) do
		Bar:MicroButton_Create(menubar, info)
	end

	-- Order Positions
	for i = 1, #buttonList do
		if i == 1 then
			buttonList[i]:SetPoint("LEFT")
		else
			buttonList[i]:SetPoint("LEFT", buttonList[i - 1], "RIGHT", 6, 0)
		end
	end

	-- Default elements
	MainMenuBar:EnableMouse(false)
	MainMenuBar:SetAlpha(0)
	MainMenuBar:UnregisterEvent("DISPLAY_SIZE_CHANGED")
	MainMenuBar:UnregisterEvent("UI_SCALE_CHANGED")
	MainMenuBar.slideOut:GetAnimations():SetOffset(0,0)
	MainMenuBarPerformanceBar:SetAlpha(0)
	MainMenuBarPerformanceBar:SetScale(.00001)
	MainMenuMicroButton:SetScript("OnUpdate", nil)
end