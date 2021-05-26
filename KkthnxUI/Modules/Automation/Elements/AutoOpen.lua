local K, C = unpack(select(2, ...))

-- Auto opening of items in bag (kAutoOpen by Kellett)

local _G = _G

local GetContainerItemInfo = _G.GetContainerItemInfo
local GetContainerNumSlots = _G.GetContainerNumSlots
local IsModifiedClick = _G.IsModifiedClick
local AUTOLOOTTOGGLE = _G.AUTOLOOTTOGGLE
local SetCVar = _G.SetCVar
local GetContainerItemLink = _G.GetContainerItemLink

local KKUI_StopModule = false
local KKUI_Blacklist = {}

local AutoOpen = CreateFrame("Frame")
AutoOpen:RegisterEvent("BAG_UPDATE")
AutoOpen:RegisterEvent("MERCHANT_SHOW")
AutoOpen:RegisterEvent("MERCHANT_CLOSED")
AutoOpen:RegisterEvent("BANKFRAME_OPENED")
AutoOpen:RegisterEvent("BANKFRAME_CLOSED")
AutoOpen:SetScript("OnEvent", function(self, event, ...)
	if not C["Automation"].AutoOpenItems then
		return
	end

	return self[event] and self[event](self, ...)
end)

function AutoOpen:MERCHANT_SHOW()
	KKUI_StopModule = true
end

function AutoOpen:MERCHANT_CLOSED()
	KKUI_StopModule = false
end

function AutoOpen:BANKFRAME_OPENED()
	KKUI_StopModule = true
end

function AutoOpen:BANKFRAME_CLOSED()
	KKUI_StopModule = false
end

function AutoOpen:BAG_UPDATE(bag)
	if KKUI_StopModule then return end

	if UnitCastingInfo("player") then
		C_Timer.After(3.2, function()
			--local bag = bag
			AutoOpen:BAG_UPDATE(bag)
		end)
	end


	for slot = 1, GetContainerNumSlots(bag) do
		local _, _, locked, _, _, lootable, itemLink = GetContainerItemInfo(bag, slot)
		local itemName = itemLink and string.match(itemLink, "%[(.*)%]") or nil

		if lootable and not locked and not string.find(itemLink:lower(), "lockbox") and not string.find(itemLink, "Junkbox") and not KKUI_Blacklist[itemName] then -- make sure its not a lockbox or in blacklist
			local autolootDefault = GetCVar("autoLootDefault")

			if autolootDefault then -- autolooting
				if IsModifiedClick(AUTOLOOTTOGGLE) then -- currently holding autoloot mod key
					SetCVar("autoLootDefault", 0) -- swap the autoloot behaviour so it autoloots even with mod key held
					UseContainerItem(bag, slot)
					K.Print(K.SystemColor.._G.USE.." "..GetContainerItemLink(bag, slot))
					SetCVar("autoLootDefault", 1) -- swap back
				else -- not holding autoloot mod key
					UseContainerItem(bag, slot)
					K.Print(K.SystemColor.._G.USE.." "..GetContainerItemLink(bag, slot))
				end
			else -- not autolooting
				SetCVar("autoLootDefault", 1)
				UseContainerItem(bag, slot)
				K.Print(K.SystemColor.._G.USE.." "..GetContainerItemLink(bag, slot))
				SetCVar("autoLootDefault", 0)
			end
			return
		end
	end
end