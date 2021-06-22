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
	[184865] = true, -- Reawakened Phase-Hunter
	[34061] = true, -- Turbo-Charged Flying Machine Control
	[34060] = true, -- Flying Machine Control
	[33999] = true, -- Cenarion War Hippogryph
	[32768] = true, -- Reins of the Raven Lord
	[29228] = true, -- Reins of the Dark War Talbuk
	[32458] = true, -- Ashes of Al'ar
	[30480] = true, -- Fiery Warhorse's Reins
	[28915] = true, -- Reins of the Dark Riding Talbuk
	[29103] = true, -- Reins of the White War Talbuk
	[25470] = true, -- Golden Gryphon
	[25473] = true, -- Swift Blue Gryphon
	[25472] = true, -- Snowy Gryphon
	[32858] = true, -- Reins of the Azure Netherwing Drake
	[25471] = true, -- Ebon Gryphon
	[30609] = true, -- Swift Nether Drake
	[31830] = true, -- Reins of the Cobalt Riding Talbuk
	[32857] = true, -- Reins of the Onyx Netherwing Drake
	[29227] = true, -- Reins of the Cobalt War Talbuk
	[25474] = true, -- Tawny Windrider
	[32316] = true, -- Purple Riding Nether Ray
	[25529] = true, -- Swift Purple Gryphon
	[31829] = true, -- Reins of the Cobalt Riding Talbuk
	[35513] = true, -- Swift White Hawkstrider
	[25596] = true, -- Peep's Whistle
	[25475] = true, -- Blue Windrider
	[29231] = true, -- Reins of the White War Talbuk
	[29102] = true, -- Reins of the Cobalt War Talbuk
	[25477] = true, -- Swift Red Windrider
	[25527] = true, -- Swift Red Gryphon
	[32859] = true, -- Reins of the Cobalt Netherwing Drake
	[25476] = true, -- Green Windrider
	[32862] = true, -- Reins of the Violet Netherwing Drake
	[32860] = true, -- Reins of the Purple Netherwing Drake
	[29229] = true, -- Reins of the Silver War Talbuk
	[25528] = true, -- Swift Green Gryphon
	[33225] = true, -- Reins of the Swift Spectral Tiger
	[25533] = true, -- Swift Purple Windrider
	[37012] = true, -- The Horseman's Reins
	[37676] = true, -- Vengeful Nether Drake
	[31835] = true, -- Reins of the White Riding Talbuk
	[32317] = true, -- Red Riding Nether Ray
	[29104] = true, -- Reins of the Silver War Talbuk
	[29105] = true, -- Reins of the Tan War Talbuk
	[29471] = true, -- Reins of the Black War Tiger
	[33809] = true, -- Amani War Bear
	[31836] = true, -- Reins of the White Riding Talbuk
	[13086] = true, -- Reins of the Winterspring Frostsaber
	[25531] = true, -- Swift Green Windrider
	[29230] = true, -- Reins of the Tan War Talbuk
	[32319] = true, -- Blue Riding Nether Ray
	[19029] = true, -- Horn of the Frostwolf Howler
	[25532] = true, -- Swift Yellow Windrider
	[32861] = true, -- Reins of the Veridian Netherwing Drake
	[29472] = true, -- Whistle of the Black War Raptor
	[31833] = true, -- Reins of the Tan Riding Talbuk
	[19902] = true, -- Swift Zulian Tiger
	[29221] = true, -- Black Hawkstrider
	[31832] = true, -- Reins of the Silver Riding Talbuk
	[20221] = true, -- Foror's Fabled Steed
	[31831] = true, -- Reins of the Silver Riding Talbuk
	[29470] = true, -- Red Skeletal Warhorse
	[35226] = true, -- X-51 Nether-Rocket X-TREME
	[35906] = true, -- Reins of the Black War Elekk
	[18766] = true, -- Reins of the Swift Frostsaber
	[18902] = true, -- Reins of the Swift Stormsaber
	[29745] = true, -- Great Blue Elekk
	[13335] = true, -- Deathcharger's Reins
	[31834] = true, -- Reins of the Tan Riding Talbuk
	[32314] = true, -- Green Riding Nether Ray
	[18776] = true, -- Swift Palomino
	[18767] = true, -- Reins of the Swift Mistsaber
	[28936] = true, -- Swift Pink Hawkstrider
	[34129] = true, -- Swift Warstrider
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --
	-- [] = true, --



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
	[2411] = true,
	[2414] = true,
	[5655] = true,
	[5656] = true,
	[18778] = true,
	[18777] = true,
	[18241] = true,
	[12353] = true,
	[12354] = true,
	[8629] = true,
	[8631] = true,
	[8632] = true,
	[18242] = true,
	[12302] = true,
	[12303] = true,
	[8628] = true,
	[12326] = true,
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
	[15277] = true,
	[15290] = true,
	[18793] = true,
	[18794] = true,
	[18795] = true,
	[18247] = true,
	[15292] = true,
	[15293] = true,
	[1132] = true,
	[12330] = true,
	[12351] = true,
	[18245] = true,
	[18796] = true,
	[18797] = true,
	[18798] = true,
	[5665] = true,
	[5668] = true,
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
	[13331] = true,
	[13332] = true,
	[13333] = true,
	[13334] = true,
	[18248] = true,
	[18791] = true,
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

	return item.classID == LE_ITEM_CLASS_QUESTITEM
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