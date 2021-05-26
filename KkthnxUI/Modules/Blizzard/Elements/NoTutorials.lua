local K, C = unpack(select(2, ...))
local Module = K:GetModule("Blizzard")

local _G = _G

local NUM_LE_FRAME_TUTORIALS = _G.NUM_LE_FRAME_TUTORIALS
local NUM_LE_FRAME_TUTORIAL_ACCCOUNTS = _G.NUM_LE_FRAME_TUTORIAL_ACCCOUNTS

local function SetupNoBlizzardTutorials(_, addon)
	local lastInfoFrame = C_CVar.GetCVarBitfield("closedInfoFrames", NUM_LE_FRAME_TUTORIALS)
	if not lastInfoFrame and addon == "KkthnxUI" then
		print(addon)
		C_CVar.SetCVar("showTutorials", 0)
		C_CVar.SetCVar("showNPETutorials", 0)
		C_CVar.SetCVar("hideAdventureJournalAlerts", 1)

		-- help plates
		for i = 1, NUM_LE_FRAME_TUTORIALS do
			C_CVar.SetCVarBitfield("closedInfoFrames", i, true)
		end

		for i = 1, NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
			C_CVar.SetCVarBitfield("closedInfoFramesAccountWide", i, true)
		end
	end

	if not IsAddOnLoaded("HideTalentAlert") then
		function MainMenuMicroButton_AreAlertsEnabled()
			return false
		end
	end

    if TalentMicroButtonAlert then
		TalentMicroButtonAlert:EnableMouse(false)
		TalentMicroButtonAlert:SetAlpha(0)
		TalentMicroButtonAlert:SetScale(0.00001)
	end

	if EJMicroButtonAlert then
		EJMicroButtonAlert:EnableMouse(false)
		EJMicroButtonAlert:SetAlpha(0)
		EJMicroButtonAlert:SetScale(0.00001)
	end

	if CollectionsMicroButtonAlert then
		CollectionsMicroButtonAlert:EnableMouse(false)
		CollectionsMicroButtonAlert:SetAlpha(0)
		CollectionsMicroButtonAlert:SetScale(0.00001)
	end

	if CharacterMicroButtonAlert then
		CharacterMicroButtonAlert:EnableMouse(false)
		CharacterMicroButtonAlert:SetAlpha(0)
		CharacterMicroButtonAlert:SetScale(0.00001)
	end

	_G.HelpPlate:Kill()
	_G.HelpPlateTooltip:Kill()
	_G.SpellBookFrameTutorialButton:Kill()
	_G.WorldMapFrame.BorderFrame.Tutorial:Kill()
end

function Module:CreateNoBlizzardTutorials()
	if not C["General"].NoTutorialButtons then
		return
	end

	-- -- if you're in Exile's Reach and level 1 this cvar gets automatically enabled
	-- hooksecurefunc("NPE_CheckTutorials", function()
	-- 	if C_PlayerInfo.IsPlayerNPERestricted() and K.Level == 1 then
	-- 		SetCVar("showTutorials", 0)
	-- 		NewPlayerExperience:Shutdown()
	-- 		-- for some reason this window still shows up
	-- 		NPE_TutorialKeyboardMouseFrame_Frame:Hide()
	-- 	end
	-- end)

	K:RegisterEvent("ADDON_LOADED", SetupNoBlizzardTutorials)
end