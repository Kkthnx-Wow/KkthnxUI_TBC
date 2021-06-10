local K, C = unpack(select(2, ...))
local Module = K:GetModule("Automation")

local _G = _G

-- Auto dismount on Taxi
local function dismountCheck()
	if _G.IsMounted() then
		_G.Dismount()
	end
end

function Module:CreateAutoDismount()
	if C["Automation"].AutoDismount then
		K:RegisterEvent("TAXIMAP_OPENED", dismountCheck)
	else
		K:UnregisterEvent("TAXIMAP_OPENED", dismountCheck)
	end
end