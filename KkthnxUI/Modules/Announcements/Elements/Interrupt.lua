local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Announcements")

local _G = _G
local string_match = _G.string.match
local string_format = _G.string_format

local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
local IsInGroup = _G.IsInGroup
local IsInInstance = _G.IsInInstance
local IsInRaid = _G.IsInRaid
local SendChatMessage = _G.SendChatMessage
local UNKNOWN = _G.UNKNOWN
local UnitGUID = _G.UnitGUID

local INTERRUPT_MSG = INTERRUPTED.." %s's [%s]!"

local function SetupInterruptAnnounce()
	local inGroup, inRaid = IsInGroup(), IsInRaid()
	if not inGroup then -- not in group, exit.
		return
	end

	local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, _, spellName = CombatLogGetCurrentEventInfo()
	if not (string_match(event, "_INTERRUPT") and (sourceGUID == K.GUID or sourceGUID == UnitGUID("pet"))) then -- No announce-able interrupt from player or pet, exit.
		return
	end

	local interruptAnnounce, msg = C["Announcements"].Interrupt.Value, string_format(INTERRUPT_MSG, destName or UNKNOWN, spellName or UNKNOWN)
	if interruptAnnounce == "PARTY" then
		SendChatMessage(msg, "PARTY")
	elseif interruptAnnounce == "RAID" then
		SendChatMessage(msg, (inRaid and "RAID" or "PARTY"))
	elseif interruptAnnounce == "RAID_ONLY" and inRaid then
		SendChatMessage(msg, "RAID")
	elseif interruptAnnounce == "SAY" and IsInInstance() then
		SendChatMessage(msg, "SAY")
	elseif interruptAnnounce == "YELL" and IsInInstance() then
		SendChatMessage(msg, "YELL")
	elseif interruptAnnounce == "EMOTE" then
		SendChatMessage(msg, "EMOTE")
	end
end

function Module:CreateInterruptAnnounce()
	if C["Announcements"].Interrupt.Value == "NONE" then
		return
	end

	K:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", SetupInterruptAnnounce)
end