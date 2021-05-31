local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Infobar")

local _G = _G
local pairs = _G.pairs
local table_wipe = _G.table.wipe
local unpack = _G.unpack

local CLASS_ICON_TCOORDS = _G.CLASS_ICON_TCOORDS
local CURRENCY = _G.CURRENCY
local C_Timer_NewTicker = _G.C_Timer.NewTicker
local ERR_NOT_IN_COMBAT = _G.ERR_NOT_IN_COMBAT
local GameTooltip = _G.GameTooltip
local GetAutoCompleteRealms = _G.GetAutoCompleteRealms
local GetMoney = _G.GetMoney
local GetNumWatchedTokens = _G.GetNumWatchedTokens
local InCombatLockdown = _G.InCombatLockdown
local IsControlKeyDown = _G.IsControlKeyDown
local NO = _G.NO
local StaticPopupDialogs = _G.StaticPopupDialogs
local TOTAL = _G.TOTAL
local YES = _G.YES

local slotString = "Bags"..": %s%d"
local profit = 0
local spent = 0
local oldMoney = 0
local crossRealms = GetAutoCompleteRealms()

if not crossRealms or #crossRealms == 0 then
	crossRealms = {[1] = K.Realm}
end

StaticPopupDialogs["RESETGOLD"] = {
	text = "Are you sure to reset the gold count?",
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		for _, realm in pairs(crossRealms) do
			if KkthnxUIDB.Gold.totalGold[realm] then
				table_wipe(KkthnxUIDB.Gold.totalGold[realm])
			end
		end
		KkthnxUIDB.Gold.totalGold[K.Realm][K.Name] = {GetMoney(), K.Class}
	end,
	whileDead = 1,
}

local function getClassIcon(class)
	local c1, c2, c3, c4 = unpack(CLASS_ICON_TCOORDS[class])
	c1, c2, c3, c4 = (c1 + 0.03) * 50, (c2 - 0.03) * 50, (c3 + 0.03) * 50, (c4 - 0.03) * 50
	local classStr = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:12:12:0:0:50:50:"..c1..":"..c2..":"..c3..":"..c4.."|t "
	return classStr or ""
end

local function getSlotString()
	local num = CalculateTotalNumberOfFreeBagSlots()
	if num < 10 then
		return format(slotString, "|cffff0000", num)
	else
		return format(slotString, "|cff00ff00", num)
	end
end

local function OnEvent(_, event, arg1)
	if not IsLoggedIn() then
		return
	end

	if event == "PLAYER_ENTERING_WORLD" then
		oldMoney = GetMoney()
		Module.GoldDataTextFrame:UnregisterEvent(event)
	elseif event == "BAG_UPDATE" then
		if arg1 < 0 or arg1 > 4 then
			return
		end
	end

	local newMoney = GetMoney()
	local change = newMoney - oldMoney -- Positive if we gain money
	if oldMoney > newMoney then -- Lost Money
		spent = spent - change
	else -- Gained Moeny
		profit = profit + change
	end

	if C["DataText"].Gold then
		if C["DataText"].HideText then
			Module.GoldDataTextFrame.Text:SetText("")
		else
			if KkthnxUIDB.ShowSlots then
				Module.GoldDataTextFrame.Text:SetText(getSlotString())
			else
				Module.GoldDataTextFrame.Text:SetText(K.FormatMoney(newMoney))
			end
		end
	end

	KkthnxUIDB.Gold = KkthnxUIDB.Gold or {}
	KkthnxUIDB.Gold.totalGold = KkthnxUIDB.Gold.totalGold or {}

	if not KkthnxUIDB.Gold.totalGold[K.Realm] then
		KkthnxUIDB.Gold.totalGold[K.Realm] = {}
	end

	if not KkthnxUIDB.Gold.totalGold[K.Realm][K.Name] then
		KkthnxUIDB.Gold.totalGold[K.Realm][K.Name] = {}
	end

	KkthnxUIDB.Gold.ServerID = KkthnxUIDB.Gold.ServerID or {}
	KkthnxUIDB.Gold.ServerID[K.ServerID] = KkthnxUIDB.Gold.ServerID[K.ServerID] or {}
	KkthnxUIDB.Gold.ServerID[K.ServerID][K.Realm] = true

	KkthnxUIDB.Gold.totalGold[K.Realm][K.Name][1] = GetMoney()
	KkthnxUIDB.Gold.totalGold[K.Realm][K.Name][2] = K.Class

	oldMoney = newMoney
end

local function OnEnter()
	GameTooltip:SetOwner(Module.GoldDataTextFrame, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", Module.GoldDataTextFrame, "TOPRIGHT", 2, 2)
	GameTooltip:ClearLines()

	GameTooltip:AddLine(K.InfoColor..CURRENCY)
	GameTooltip:AddLine(" ")

	GameTooltip:AddLine(L["Session"], 0.6, 0.8, 1)
	GameTooltip:AddDoubleLine(L["Earned"], K.FormatMoney(profit), 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(L["Spent"], K.FormatMoney(spent), 1, 1, 1, 1, 1, 1)
	if profit < spent then
		GameTooltip:AddDoubleLine(L["Deficit"], K.FormatMoney(spent - profit), 1, 0, 0, 1, 1, 1)
	elseif profit > spent then
		GameTooltip:AddDoubleLine(L["Profit"], K.FormatMoney(profit - spent), 0, 1, 0, 1, 1, 1)
	end
	GameTooltip:AddLine(" ")

	local totalGold = 0
	GameTooltip:AddLine(L["RealmCharacter"], 0.6, 0.8, 1)
	for realm in pairs(KkthnxUIDB.Gold.ServerID[K.ServerID]) do
		local thisRealmList = KkthnxUIDB.Gold.totalGold[realm]
		if thisRealmList then
			for k, v in pairs(thisRealmList) do
				local name = Ambiguate(k.."-"..realm, "none")
				local gold, class = unpack(v)
				local r, g, b = K.ColorClass(class)
				GameTooltip:AddDoubleLine(getClassIcon(class)..name, K.FormatMoney(gold), r, g, b, 1, 1, 1)
				totalGold = totalGold + gold
			end
		end
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(TOTAL..":", K.FormatMoney(totalGold), 0.63, 0.82, 1, 1, 1, 1)

	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(" ", K.LeftButton.."Toggle Bags".." ", 1, 1, 1, 0.6, 0.8, 1)
	GameTooltip:AddDoubleLine(" ", K.RightButton.."Switch Mode".." ", 1,1,1, .6,.8,1)
	GameTooltip:AddDoubleLine(" ", L["Ctrl Key"]..K.RightButton.."Reset Gold".." ", 1, 1, 1, 0.6, 0.8, 1)
	GameTooltip:Show()
end

local function OnMouseUp(_, btn)
	if btn == "RightButton" then
		if IsControlKeyDown() then
			StaticPopup_Show("RESETGOLD")
		else
			KkthnxUIDB.ShowSlots = not KkthnxUIDB.ShowSlots
			if KkthnxUIDB.ShowSlots then
				Module.GoldDataTextFrame:RegisterEvent("BAG_UPDATE")
			else
				Module.GoldDataTextFrame:UnregisterEvent("BAG_UPDATE")
			end
			OnEvent()
		end
	elseif btn == "MiddleButton" then
		OnEnter()
	else
		if InCombatLockdown() then
			UIErrorsFrame:AddMessage(K.InfoColor..ERR_NOT_IN_COMBAT)
			return
		end
		ToggleAllBags()
	end
end

local function OnLeave()
	K.HideTooltip()
end

function Module:CreateGoldDataText()
	if not C["DataText"].Gold then
		return
	end

	Module.GoldDataTextFrame = CreateFrame("Button", nil, UIParent)
	if C["DataText"].Gold then
		Module.GoldDataTextFrame:SetPoint("LEFT", UIParent, "LEFT", 4, -302)
		Module.GoldDataTextFrame:SetSize(32, 32)

		Module.GoldDataTextFrame.Texture = Module.GoldDataTextFrame:CreateTexture(nil, "BACKGROUND")
		Module.GoldDataTextFrame.Texture:SetPoint("LEFT", Module.GoldDataTextFrame, "LEFT", 0, 0)
		Module.GoldDataTextFrame.Texture:SetTexture([[Interface\HELPFRAME\ReportLagIcon-Loot]])
		Module.GoldDataTextFrame.Texture:SetSize(32, 32)

		Module.GoldDataTextFrame.Text = Module.GoldDataTextFrame:CreateFontString(nil, "ARTWORK")
		Module.GoldDataTextFrame.Text:SetFontObject(K.GetFont(C["UIFonts"].DataTextFonts))
		Module.GoldDataTextFrame.Text:SetPoint("LEFT", Module.GoldDataTextFrame.Texture, "RIGHT", 0, 0)
	end

	Module.GoldDataTextFrame:RegisterEvent("PLAYER_MONEY", OnEvent)
	Module.GoldDataTextFrame:RegisterEvent("SEND_MAIL_MONEY_CHANGED", OnEvent)
	Module.GoldDataTextFrame:RegisterEvent("SEND_MAIL_COD_CHANGED", OnEvent)
	Module.GoldDataTextFrame:RegisterEvent("PLAYER_TRADE_MONEY", OnEvent)
	Module.GoldDataTextFrame:RegisterEvent("TRADE_MONEY_CHANGED", OnEvent)
	Module.GoldDataTextFrame:RegisterEvent("PLAYER_ENTERING_WORLD", OnEvent)

	Module.GoldDataTextFrame:SetScript("OnEvent", OnEvent)
	if C["DataText"].Gold then
		Module.GoldDataTextFrame:SetScript("OnMouseUp", OnMouseUp)
		Module.GoldDataTextFrame:SetScript("OnEnter", OnEnter)
		Module.GoldDataTextFrame:SetScript("OnLeave", OnLeave)

		K.Mover(Module.GoldDataTextFrame, "GoldDataText", "GoldDataText", {"LEFT", UIParent, "LEFT", 4, -302})
	end
end