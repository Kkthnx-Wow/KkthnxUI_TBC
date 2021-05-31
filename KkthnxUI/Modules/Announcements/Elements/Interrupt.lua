local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Announcements")

local _G = _G
local string_format = _G.string.format

local IsInGroup = _G.IsInGroup
local IsInRaid = _G.IsInRaid
local SendChatMessage = _G.SendChatMessage

local function sendQuestMsg()
	if IsInRaid() then
		return "RAID"
	elseif IsInGroup() then
		return "PARTY"
	end
end

local infoType = {
	["SPELL_INTERRUPT"] = "Interrupted %s",
	["SPELL_STOLEN"] = "Stole %s",
	["SPELL_DISPEL"] = "Dispeled %s",
	["SPELL_AURA_BROKEN_SPELL"] = "Broke %s",
}

local blackList = {
	[99] = true, -- 夺魂咆哮
	[122] = true, -- 冰霜新星
	[1776] = true, -- 凿击
	[1784] = true, -- 潜行
	[5246] = true, -- 破胆怒吼
	[8122] = true, -- 心灵尖啸
	[31661] = true, -- 龙息术
	[33395] = true, -- 冰冻术
	[64695] = true, -- 陷地
	[82691] = true, -- 冰霜之环
	[91807] = true, -- 蹒跚冲锋
	[102359] = true, -- 群体缠绕
	[105421] = true, -- 盲目之光
	[115191] = true, -- 潜行
	[157997] = true, -- 寒冰新星
	[197214] = true, -- 裂地术
	[198121] = true, -- 冰霜撕咬
	[207167] = true, -- 致盲冰雨
	[207685] = true, -- 悲苦咒符
	[226943] = true, -- 心灵炸弹
	[228600] = true, -- 冰川尖刺
}

function Module:IsAllyPet(sourceFlags)
	if K.IsMyPet(sourceFlags) or (not C["Announcements"].OwnInterrupt and (sourceFlags == K.PartyPetFlags or sourceFlags == K.RaidPetFlags)) then
		return true
	end
end

function Module:InterruptAlert_Update(...)
	if C["Announcements"].AlertInInstance and (not IsInInstance()) then
		return
	end

	local _, eventType, _, sourceGUID, sourceName, sourceFlags, _, _, destName, _, _, spellID, _, _, extraskillID, _, _, auraType = ...
	if not sourceGUID or sourceName == destName then
		return
	end

	if UnitInRaid(sourceName) or UnitInParty(sourceName) or Module:IsAllyPet(sourceFlags) then
		local infoText = infoType[eventType]
		if infoText then
			if infoText == "Broke %s" then
				if not C["Announcements"].BrokenSpell then
					return
				end

				if auraType and auraType == AURA_TYPE_BUFF or blackList[spellID] then
					return
				end

				SendChatMessage(string_format(infoText, destName.."'s "..GetSpellLink(spellID).."!"), sendQuestMsg())
			else
				if C["Announcements"].OwnInterrupt and not Module:IsAllyPet(sourceFlags) then
					return
				end

				SendChatMessage(string_format(infoText, destName.."'s "..GetSpellLink(extraskillID).."!"), sendQuestMsg())
			end
		end
	end
end

function Module:InterruptAlert_CheckGroup()
	if IsInGroup() then
		K:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Module.InterruptAlert_Update)
	else
		K:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Module.InterruptAlert_Update)
	end
end

function Module:CreateInterruptAnnounce()
	if C["Announcements"].Interrupt then
		self:InterruptAlert_CheckGroup()
		K:RegisterEvent("GROUP_LEFT", self.InterruptAlert_CheckGroup)
		K:RegisterEvent("GROUP_JOINED", self.InterruptAlert_CheckGroup)
	else
		K:UnregisterEvent("GROUP_LEFT", self.InterruptAlert_CheckGroup)
		K:UnregisterEvent("GROUP_JOINED", self.InterruptAlert_CheckGroup)
		K:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED", Module.InterruptAlert_Update)
	end
end