local K, C = unpack(select(2, ...))
local Module = K:GetModule("Automation")

local _G = _G

local ERR_ATTACK_MOUNTED = _G.ERR_ATTACK_MOUNTED
local ERR_LOOT_NOTSTANDING = _G.ERR_LOOT_NOTSTANDING
local ERR_NOT_WHILE_MOUNTED = _G.ERR_NOT_WHILE_MOUNTED
local ERR_TAXIPLAYERALREADYMOUNTED = _G.ERR_TAXIPLAYERALREADYMOUNTED
local SPELL_FAILED_NOT_MOUNTED = _G.SPELL_FAILED_NOT_MOUNTED
local SPELL_FAILED_NOT_STANDING = _G.SPELL_FAILED_NOT_STANDING

-- Auto dismount and auto stand
function Module:CreateAutoDismount()
	if not C["Automation"].AutoDismount then
		return
	end

	local standString = {
		[ERR_LOOT_NOTSTANDING] = true,
		[SPELL_FAILED_NOT_STANDING] = true,
	}

	local dismountString = {
		[ERR_ATTACK_MOUNTED] = true,
		[ERR_NOT_WHILE_MOUNTED] = true,
		[ERR_TAXIPLAYERALREADYMOUNTED] = true,
		[SPELL_FAILED_NOT_MOUNTED] = true,
	}

	local function updateEvent(event, ...)
		local _, msg = ...
		if standString[msg] then
			DoEmote("STAND")
		elseif dismountString[msg] then
			Dismount()
		end
	end
	K:RegisterEvent("UI_ERROR_MESSAGE", updateEvent)
end