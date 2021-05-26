local K, C = unpack(select(2, ...))
local Module = K:GetModule("Blizzard")

local _G = _G

local function SetupNoTalkingHeads()
	if not C["Misc"].NoTalkingHead then
        return
    end

	hooksecurefunc(_G.TalkingHeadFrame, "Show", function(self)
		self:Hide()
	end)
end

local function SetupTalkingHeadOnLoad(event, addon)
	if addon == "Blizzard_TalkingHeadUI" then
		SetupNoTalkingHeads()
		K:UnregisterEvent(event, SetupTalkingHeadOnLoad)
	end
end

function Module:CreateNoTalkingHead()
    if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
        SetupNoTalkingHeads()
    else
        K:RegisterEvent("ADDON_LOADED", SetupTalkingHeadOnLoad)
    end
end