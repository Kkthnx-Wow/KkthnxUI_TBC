local K, C = unpack(select(2, ...))
local Module = K:GetModule("Tooltip")

-- Function to show vendor price
local function SetupVendorPrice(tooltip, tooltipObject)
	if tooltip.shownMoneyFrames then
		return
	end

	tooltipObject = tooltipObject or GameTooltip

	-- Get container
	local container = GetMouseFocus()
	if not container then
		return
	end

	-- Get item
	local _, itemlink = tooltipObject:GetItem()
	if not itemlink then
		return
	end

	local _, _, _, _, _, _, _, _, _, _, sellPrice, classID = GetItemInfo(itemlink)
	if sellPrice and sellPrice > 0 then
		local count = container and type(container.count) == "number" and container.count or 1
		if sellPrice and count > 0 then
			if classID and classID == 11 then -- Fix for quiver/ammo pouch so ammo is not included
				count = 1
			end
			SetTooltipMoney(tooltip, sellPrice * count, nil, string.format("%s:", SELL_PRICE))
		end
	end

	-- Refresh chat tooltips
	if tooltipObject == ItemRefTooltip then
		ItemRefTooltip:Show()
	end
end

function Module:CreateVendorPrice()
	if IsAddOnLoaded("Leatrix_Plus") then
		return
	end

	if not C["Tooltip"].VendorPrice then
		return
	end
	-- Show vendor price when tooltips are shown
	GameTooltip:HookScript("OnTooltipSetItem", SetupVendorPrice)

	hooksecurefunc(GameTooltip, "SetHyperlink", function(tip)
		SetupVendorPrice(tip, GameTooltip)
	end)

	hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(tip)
		SetupVendorPrice(tip, ItemRefTooltip)
	end)
end