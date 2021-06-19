local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Automation")

local _G = _G
local string_split = _G.string.split
local math_random = _G.math.random

local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
local DoEmote = _G.DoEmote
local GetSpellInfo = _G.GetSpellInfo
local IsAddOnLoaded = _G.IsAddOnLoaded
local UnitInParty = _G.UnitInParty
local UnitInRaid = _G.UnitInRaid

-- Build Spell list (this ignores ranks)
local AutoBuffThanksSpells = {
    [1243] = true, -- Power Word: Fortitude
    [1459] = true, -- Arcane Intellect
    [19742] = true, -- Blessing Of Wisdom
    [19834] = true, -- Blessing Of Might
    [20217] = true, -- Blessing Of Kings
    [467] = true, -- Thorns
    [1126] = true, -- Mark of the Wild
    [5697] = true, -- Unending Breath
}

local AutoBuffThanksEmotes = {
    "THANK",
    "FLEX",
    "CHEER",
}

local AutoAlreadyThanked = {}

function Module:SetupAutoBuffThanksAnnounce()
    local _, event, _, _, sourceName, _, _, _, destName, _, _, spellID, spellName = CombatLogGetCurrentEventInfo()

    -- local now = GetTime()
    -- if Module._enter and now - Module._enter < 2 then
    --     return
    -- end

    --  -- clear expired thank cooldowns
    --  for key,value in pairs(AutoAlreadyThanked) do
    --     if value < now then
    --         AutoAlreadyThanked[key] = nil
    --     end
    -- end

    for key, value in pairs(AutoBuffThanksSpells) do
        if spellID == key and value == true and destName == K.Name and sourceName ~= K.Name and not (UnitInParty(sourceName) or UnitInRaid(sourceName)) and event == "SPELL_CAST_SUCCESS" then
            K.Delay(1.4, function() -- Give this more time to say emote, so we do not look like we are bots.
                DoEmote(AutoBuffThanksEmotes[math_random(1, #AutoBuffThanksEmotes)], sourceName)
            end)
        end
    end
end

function Module:CreateAutoBuffThanksAnnounce()
    if IsAddOnLoaded("TFTB") or C["Automation"].BuffThanks ~= true then
        return
    end

    K:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", self.SetupAutoBuffThanksAnnounce)
end

Module:CreateAutoBuffThanksAnnounce()