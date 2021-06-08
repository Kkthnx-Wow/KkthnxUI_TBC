local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Infobar")

local _G = _G
local math_floor = _G.math.floor
local string_gsub = _G.string.gsub
local string_format = _G.string.format
local table_sort = _G.table.sort

local GetInventoryItemLink = _G.GetInventoryItemLink
local GetInventoryItemDurability = _G.GetInventoryItemDurability
local GetInventoryItemTexture = _G.GetInventoryItemTexture

local repairCostString = string_gsub(REPAIR_COST, HEADER_COLON, ":")

local localSlots = {
	[1] = {1, INVTYPE_HEAD, 1000},
	[2] = {3, INVTYPE_SHOULDER, 1000},
	[3] = {5, INVTYPE_CHEST, 1000},
	[4] = {6, INVTYPE_WAIST, 1000},
	[5] = {9, INVTYPE_WRIST, 1000},
	[6] = {10, INVTYPE_HAND, 1000},
	[7] = {7, INVTYPE_LEGS, 1000},
	[8] = {8, INVTYPE_FEET, 1000},
	[9] = {16, INVTYPE_WEAPONMAINHAND, 1000},
	[10] = {17, INVTYPE_WEAPONOFFHAND, 1000},
	[11] = {18, INVTYPE_RANGED, 1000}
}

local lastShown = 0

local function sortSlots(a, b)
	if a and b then
		return (a[3] == b[3] and a[1] < b[1]) or (a[3] < b[3])
	end
end

local function getItemDurability()
	local numSlots = 0
	for i = 1, #localSlots do
		localSlots[i][3] = 1000
		local index = localSlots[i][1]
		if GetInventoryItemLink("player", index) then
			local current, max = GetInventoryItemDurability(index)
			if current then
				localSlots[i][3] = current / max
				numSlots = numSlots + 1
			end
		end
	end
	table_sort(localSlots, sortSlots)

	return numSlots
end

local function isLowDurability()
	for i = 1, #localSlots do
		if localSlots[i][3] < 0.25 then
			return true
		end
	end
end

local function gradientColor(perc)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1

	local seg, relperc = math.modf(perc * 2)
	local r1, g1, b1, r2, g2, b2 = select(seg * 3 + 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0) -- R -> Y -> G
	local r, g, b = r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc

	return string_format("|cff%02x%02x%02x", r*255, g*255, b*255), r, g, b
end

local function SaveClickTime()
	lastShown = GetTime()
end

local function OnEvent()
	local numSlots = getItemDurability()
	if numSlots > 0 then
		Module.DurabilityDataTextFrame.Text:SetText(string_format(string_gsub("[color]%d|r%% ".."Dur", "%[color%]", (gradientColor(math_floor(localSlots[1][3] * 100) / 100))), math_floor(localSlots[1][3] * 100)))
	else
		Module.DurabilityDataTextFrame.Text:SetText("Dur"..": "..K.MyClassColor..NONE)
	end

	if isLowDurability() and ((lastShown == 0) or (GetTime() - lastShown > 0.0833333)) then -- only half an hour
		_G.UIErrorsFrame:AddMessage("You have gear that is very low durability 20% or lower! Repair now!", 1, 0, 0, SaveClickTime)
		K.Print("You have gear that is very low durability 20% or lower! Repair now!")
	end
end

local function OnEnter()
	GameTooltip:SetOwner(Module.DurabilityDataTextFrame, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", Module.DurabilityDataTextFrame, "TOPRIGHT", 0, 0)
	GameTooltip:AddDoubleLine(DURABILITY, " ", 163/255, 211/255, 255/255, 163/255, 211/255, 255/255)
	GameTooltip:AddLine(" ")

	local totalCost = 0
	for i = 1, #localSlots do
		if localSlots[i][3] ~= 1000 then
			local slot = localSlots[i][1]
			local green = localSlots[i][3] * 2
			local red = 1 - green
			local slotIcon = "|T"..GetInventoryItemTexture("player", slot)..":13:15:0:0:50:50:4:46:4:46|t " or ""
			GameTooltip:AddDoubleLine(slotIcon..localSlots[i][2], math_floor(localSlots[i][3] * 100).."%", 1, 1, 1, red + 1, green, 0)

			K.ScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
			totalCost = totalCost + select(3, K.ScanTooltip:SetInventoryItem("player", slot))
		end
	end

	if totalCost > 0 then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine(repairCostString, K.FormatMoney(totalCost), 163/255, 211/255, 255/255, 1, 1, 1)
	end

	GameTooltip:Show()
end

local function OnLeave()
	GameTooltip:Hide()
end

function Module:CreateDurabilityDataText()
	-- if not C["DataText"].Durability then
	-- 	return
	-- end

	Module.DurabilityDataTextFrame = CreateFrame("Frame", nil, UIParent)
    Module.DurabilityDataTextFrame:SetParent(PaperDollFrame)

	Module.DurabilityDataTextFrame.Text = Module.DurabilityDataTextFrame:CreateFontString(nil, "ARTWORK")
    Module.DurabilityDataTextFrame.Text:SetPoint("TOPLEFT", CharacterWristSlot, "BOTTOMRIGHT", -14, -10)
	Module.DurabilityDataTextFrame.Text:SetFontObject(K.GetFont(C["UIFonts"].DataTextFonts))

    Module.DurabilityDataTextFrame:SetAllPoints(Module.DurabilityDataTextFrame.Text)

	Module.DurabilityDataTextFrame:RegisterEvent("UPDATE_INVENTORY_DURABILITY", OnEvent)
	Module.DurabilityDataTextFrame:RegisterEvent("PLAYER_ENTERING_WORLD", OnEvent)

	Module.DurabilityDataTextFrame:SetScript("OnEnter", OnEnter)
	Module.DurabilityDataTextFrame:SetScript("OnLeave", OnLeave)
	Module.DurabilityDataTextFrame:SetScript("OnEvent", OnEvent)
end