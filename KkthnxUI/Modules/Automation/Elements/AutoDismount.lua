local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Automation")

-- Auto dismount and auto stand
function Module:CreateAutoDismount()
	--if not C["Automation"].AutoDismount then return end

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