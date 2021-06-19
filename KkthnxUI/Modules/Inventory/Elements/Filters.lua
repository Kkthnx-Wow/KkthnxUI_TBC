local K, C = unpack(select(2, ...))
local Module = K:GetModule("Bags")

local _G = _G

local LE_ITEM_CLASS_ARMOR = _G.LE_ITEM_CLASS_ARMOR
local LE_ITEM_CLASS_CONSUMABLE = _G.LE_ITEM_CLASS_CONSUMABLE
local LE_ITEM_CLASS_ITEM_ENHANCEMENT = _G.LE_ITEM_CLASS_ITEM_ENHANCEMENT
local LE_ITEM_CLASS_TRADEGOODS = _G.LE_ITEM_CLASS_TRADEGOODS
local LE_ITEM_CLASS_WEAPON = _G.LE_ITEM_CLASS_WEAPON
local LE_ITEM_QUALITY_LEGENDARY = _G.LE_ITEM_QUALITY_LEGENDARY
local LE_ITEM_QUALITY_POOR = _G.LE_ITEM_QUALITY_POOR

-- Custom filter
local CustomFilterList = {
	[12450] = true,	-- Juju Flurry
	[12451] = true,	-- Juju Power
	[12455] = true,	-- Juju Ember
	[12457] = true, -- Juju Chill
	[12458] = true,	-- Juju Guile
	[12459] = true,	-- Juju Escape
	[12460] = true,	-- Juju Might
}

local MountFilterList = {
	-- Deluxe Edition Mount
	[184865] = true,

	-- Rams
	[5864] = true,
	[5872] = true,
	[5873] = true,
	[18785] = true,
	[18786] = true,
	[18787] = true,
	[18244] = true,
	[19030] = true,
	[13328] = true,
	[13329] = true,

	-- Horses
	[2411] = true,
	[2414] = true,
	[5655] = true,
	[5656] = true,
	[18778] = true,
	[18776] = true,
	[18777] = true,
	[18241] = true,
	[12353] = true,
	[12354] = true,

	-- Sabers
	[8629] = true,
	[8631] = true,
	[8632] = true,
	[18766] = true,
	[18767] = true,
	[18902] = true,
	[18242] = true,
	[13086] = true,
	[19902] = true,
	[12302] = true,
	[12303] = true,
	[8628] = true,
	[12326] = true,

	-- Mechanostriders
	[8563] = true,
	[8595] = true,
	[13321] = true,
	[13322] = true,
	[18772] = true,
	[18773] = true,
	[18774] = true,
	[18243] = true,
	[13326] = true,
	[13327] = true,

	-- Kodos
	[15277] = true,
	[15290] = true,
	[18793] = true,
	[18794] = true,
	[18795] = true,
	[18247] = true,
	[15292] = true,
	[15293] = true,

	-- Wolves
	[1132] = true,
	[12330] = true,
	[12351] = true,
	[18245] = true,
	[18796] = true,
	[18797] = true,
	[18798] = true,
	[19029] = true,
	[5665] = true,
	[5668] = true,

	-- Raptors
	[13317] = true,
	[18246] = true,
	[18788] = true,
	[18789] = true,
	[18790] = true,
	[19872] = true,
	[8586] = true,
	[8588] = true,
	[8591] = true,
	[8592] = true,

	-- Undead Horses
	[13331] = true,
	[13332] = true,
	[13333] = true,
	[13334] = true,
	[13335] = true,
	[18248] = true,
	[18791] = true,

	-- Qiraji Battle Tanks
	[21176] = true,
	[21218] = true,
	[21321] = true,
	[21323] = true,
	[21324] = true,
}

local function isCustomFilter(item)
	if not C["Inventory"].ItemFilter then
		return
	end

	return CustomFilterList[item.id]
end

-- Default filter
local function isItemInBag(item)
	return item.bagID >= 0 and item.bagID <= 4
end

local function isItemInBank(item)
	return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11
end

local function isItemJunk(item)
	if not C["Inventory"].ItemFilter then
		return
	end

	if not C["Inventory"].FilterJunk then
		return
	end

	return (item.rarity == LE_ITEM_QUALITY_POOR or KkthnxUIDB.Variables[K.Realm][K.Name].CustomJunkList[item.id]) and item.sellPrice and item.sellPrice > 0
end

local function isItemAmmo(item)
	if not C["Inventory"].ItemFilter then
		return
	end

	if not C["Inventory"].FilterAmmo then
		return
	end

	if K.Class == "HUNTER" then
		return item.equipLoc == "INVTYPE_AMMO" or Module.BagsType[item.bagID] == -1
	elseif K.Class == "WARLOCK" then
		return item.id == 6265 or Module.BagsType[item.bagID] == 1
	end
end

local function isItemEquipment(item)
	if not C["Inventory"].ItemFilter then
		return
	end

	if not C["Inventory"].FilterEquipment then
		return
	end

	return item.level and item.rarity > LE_ITEM_QUALITY_POOR and (item.classID == LE_ITEM_CLASS_WEAPON or item.classID == LE_ITEM_CLASS_ARMOR)
end

local function isItemConsumable(item)
	if not C["Inventory"].ItemFilter then
		return
	end

	if not C["Inventory"].FilterConsumable then
		return
	end

	if isCustomFilter(item) == false then
		return
	end

	return isCustomFilter(item) or (item.classID and (item.classID == LE_ITEM_CLASS_CONSUMABLE or item.classID == LE_ITEM_CLASS_ITEM_ENHANCEMENT))
end

local function isItemMount(item)
	if not C["Inventory"].ItemFilter then
		return
	end

	if not C["Inventory"].FilterMount then
		return
	end

	return MountFilterList[item.id]
end

local function isItemLegendary(item)
	if not C["Inventory"].ItemFilter then
		return
	end

	if not C["Inventory"].FilterLegendary then
		return
	end

	return item.rarity == LE_ITEM_QUALITY_LEGENDARY
end

local function isItemFavourite(item)
	if not C["Inventory"].ItemFilter then
		return
	end

	if not C["Inventory"].FilterFavourite then
		return
	end

	return item.id and KkthnxUIDB.Variables[K.Realm][K.Name].FavouriteItems[item.id]
end

local function isEmptySlot(item)
	if not C["Inventory"].GatherEmpty then
		return
	end

	return Module.initComplete and not item.texture and Module.BagsType[item.bagID] == 0
end

local function isItemKeyRing(item)
	return item.bagID == -2
end

local function isTradeGoods(item)
	if not C["Inventory"].ItemFilter then
		return
	end

	if not C["Inventory"].FilterGoods then
		return
	end

	return item.classID == LE_ITEM_CLASS_TRADEGOODS
end

local function isQuestItem(item)
	if not C["Inventory"].ItemFilter then
		return
	end

	if not C["Inventory"].FilterQuest then
		return
	end

	return item.isQuestItem
end

function Module:GetFilters()
	local filters = {}

	filters.onlyBags = function(item) return isItemInBag(item) and not isEmptySlot(item) end
	filters.bagAmmo = function(item) return isItemInBag(item) and isItemAmmo(item) end
	filters.bagMount = function(item) return isItemInBag(item) and isItemMount(item) end
	filters.bagEquipment = function(item) return isItemInBag(item) and isItemEquipment(item) end
	filters.bagConsumable = function(item) return isItemInBag(item) and isItemConsumable(item) end
	filters.bagsJunk = function(item) return isItemInBag(item) and isItemJunk(item) end
	filters.onlyBank = function(item) return isItemInBank(item) and not isEmptySlot(item) end
	filters.bankAmmo = function(item) return isItemInBank(item) and isItemAmmo(item) end
	filters.bankLegendary = function(item) return isItemInBank(item) and isItemLegendary(item) end
	filters.bankEquipment = function(item) return isItemInBank(item) and isItemEquipment(item) end
	filters.bankConsumable = function(item) return isItemInBank(item) and isItemConsumable(item) end
	filters.onlyReagent = function(item) return item.bagID == -3 end
	filters.bagFavourite = function(item) return isItemInBag(item) and isItemFavourite(item) end
	filters.bankFavourite = function(item) return isItemInBank(item) and isItemFavourite(item) end
	filters.onlyKeyring = function(item) return isItemKeyRing(item) end
	filters.bagGoods = function(item) return isItemInBag(item) and isTradeGoods(item) end
	filters.bankGoods = function(item) return isItemInBank(item) and isTradeGoods(item) end
	filters.bagQuest = function(item) return isItemInBag(item) and isQuestItem(item) end
	filters.bankQuest = function(item) return isItemInBank(item) and isQuestItem(item) end

	return filters
end