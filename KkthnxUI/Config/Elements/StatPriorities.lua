local K, C = unpack(select(2, ...))

local data = {
	-- 250 - Death Knight: Blood -- https://www.icy-veins.com/wow/blood-death-knight-pve-tank-stat-priority
	[250] = {
		{"Item Level > Strength > Versatility > Haste > Critical > Mastery"},
	},
	-- 251 - Death Knight: Frost -- https://www.icy-veins.com/wow/frost-death-knight-pve-dps-stat-priority
	[251] = {
		{"Strength > Critical > Mastery > Versatility > Haste"},
	},
	-- 252 - Death Knight: Unholy -- https://www.icy-veins.com/wow/unholy-death-knight-pve-dps-stat-priority
	[252] = {
		{"Strength > Haste > (Critical / Versatility) > Mastery"},
	},

	-- 577 - Demon Hunter: Havoc -- https://www.icy-veins.com/wow/havoc-demon-hunter-pve-dps-stat-priority
	[577] = {
		{"Versatility > (Critical = Haste) > Agility > Mastery"},
	},
	-- 581 - Demon Hunter: Vengeance -- https://www.icy-veins.com/wow/vengeance-demon-hunter-pve-tank-stat-priority
	[581] = {
		{"Agility > (Haste >= Versatility) > Mastery > Critical"},
	},

	-- 102 - Druid: Balance -- https://www.icy-veins.com/wow/balance-druid-pve-dps-stat-priority
	[102] = {
		{"(Haste = Critical) > Versatility > Mastery > Intellect", "Single Target"},
		{"Haste > Mastery > Critical > Versatility > Intellect", "Multiple Target"},
	},
	-- 103 - Druid: Feral -- https://www.icy-veins.com/wow/feral-druid-pve-dps-stat-priority
	[103] = {
		{"Critical > Mastery > Versatility > Haste > Agility"},
	},
	-- 104 - Druid: Guardian -- https://www.icy-veins.com/wow/guardian-druid-pve-tank-stat-priority
	[104] = {
		{"(Armor / Agility / Stamina) > Versatility > Mastery > Haste > Critical", "Survival"},
		{"Agility > Versatility >= Haste >= Critical > Mastery", "DPS Boost"},
	},
	-- Druid: Restoration -- https://www.icy-veins.com/wow/restoration-druid-pve-healing-stat-priority
	[105] = {
		{"(Mastery = Haste = Critical = Versatility) > Intellect", "Raid"},
		{"(Mastery = Haste) > Versatility > Critical > Intellect", "Dungeon"},
	},

	-- 253 - Hunter: Beast Mastery -- https://www.icy-veins.com/wow/beast-mastery-hunter-pve-dps-stat-priority
	[253] = {
		{"Agility > Critical > (Haste / Versatility) > Mastery"},
	},
	-- 254 - Hunter: Marksmanship -- https://www.icy-veins.com/wow/marksmanship-hunter-pve-dps-stat-priority
	[254] = {
		{"Agility > Mastery > Haste > Versatility > Critical"},
	},
	-- 255 - Hunter: Survival -- https://www.icy-veins.com/wow/survival-hunter-pve-dps-stat-priority
	[255] = {
		{"Agility > Haste > (Versatility / Critical) > Mastery"},
	},

	-- 62 - Mage: Arcane -- https://www.icy-veins.com/wow/arcane-mage-pve-dps-stat-priority
	[62] = {
		{"Critical > Haste > Mastery > Versatility > Intellect"},
	},
	-- 63 - Mage: Fire -- https://www.icy-veins.com/wow/fire-mage-pve-dps-stat-priority
	[63] = {
		{"Haste > Versatility > Mastery > Critical > Intellect", "Single Target"},
		{"Mastery > Haste > Versatility > Critical > Intellect", "Multiple Target"},
	},
	-- 64 - Mage: Frost -- https://www.icy-veins.com/wow/frost-mage-pve-dps-stat-priority
	[64] = {
		{"Mastery > Critical 33.34% > Haste > Versatility > Intellect > Critical"},
	},

	-- 268 - Monk: Brewmaster -- https://www.icy-veins.com/wow/brewmaster-monk-pve-tank-stat-priority
	[268] = {
		{"Agility > Mastery > (Critical = Versatility) > Haste"},
	},
	-- 269 - Monk: Windwalker -- https://www.icy-veins.com/wow/windwalker-monk-pve-dps-stat-priority
	[269] = {
		{"Agility > Versatility > Mastery > Critical > Haste"},
	},
	-- 270 - Monk: Mistweaver -- https://www.icy-veins.com/wow/mistweaver-monk-pve-healing-stat-priority
	[270] = {
		{"Critical > (Mastery = Versatility) > Intellect > Haste", "Raid"},
		{"Intellect > Critical > (Mastery = Versatility >= Haste)", "Dungeon"},
	},

	-- 65 - Paladin: Holy -- https://www.icy-veins.com/wow/holy-paladin-pve-healing-stat-priority
	[65] = {
		{"Critical > Haste > Versatility > Mastery > Intellect"},
	},
	-- 66 - Paladin: Protection -- https://www.icy-veins.com/wow/protection-paladin-pve-tank-stat-priority
	[66] = {
		{"Haste > Mastery > Versatility > Critical"},
	},
	-- 70 - Paladin: Retribution -- https://www.icy-veins.com/wow/retribution-paladin-pve-dps-stat-priority
	[70] = {
		{"(Haste -= Critical -= Versatility -= Mastery) > Strength"},
	},

	-- 256 - Priest: Discipline -- https://www.icy-veins.com/wow/discipline-priest-pve-healing-stat-priority
	[256] = {
		{"Haste > Critical > Intellect > Versatility > Mastery"},
	},
	-- 257 - Priest: Holy -- https://www.icy-veins.com/wow/holy-priest-pve-healing-stat-priority
	[257] = {
		{"(Mastery = Critical) > Versatility > Intellect > Haste", "Raid"},
		{"Critical > Haste > Versatility > Intellect > Mastery", "Dungeon"},
	},
	-- 258 - Priest: Shadow -- https://www.icy-veins.com/wow/shadow-priest-pve-dps-stat-priority
	[258] = {
		{"(Haste = Critical) > (Mastery = Versatility) > Intellect"},
	},

	-- 259 - Rogue: Assassination -- https://www.icy-veins.com/wow/assassination-rogue-pve-dps-stat-priority
	[259] = {
		{"Haste > (Critical = Mastery) > Versatility > Agility", "Raid"},
		{"Critical 35-40% > Mastery > Versatility > Agility > Haste", "Dungeon"},
	},
	-- 260 - Rogue: Outlaw -- https://www.icy-veins.com/wow/outlaw-rogue-pve-dps-stat-priority
	[260] = {
		{"Agility > Critical > Versatility > Haste > Mastery"},
	},
	-- 261 - Rogue: Subtlety -- https://www.icy-veins.com/wow/subtlety-rogue-pve-dps-stat-priority
	[261] = {
		{"Agility > Critical > Versatility > Mastery > Haste", "Single Target"},
		{"Agility > Mastery > Critical > Versatility > Haste", "Multiple Target"},
	},

	-- 262 - Shaman: Elemental -- https://www.icy-veins.com/wow/elemental-shaman-pve-dps-stat-priority
	[262] = {
		{"Intellect > Versatility > Critical > Haste > Mastery"},
	},
	-- 263 - Shaman: Enhancement -- https://www.icy-veins.com/wow/enhancement-shaman-pve-dps-stat-priority
	[263] = {
		{"Haste > (Critical = Versatility) > Mastery > Agility"},
	},
	-- 264 - Shaman: Restoration -- https://www.icy-veins.com/wow/restoration-shaman-pve-healing-stat-priority
	[264] = {
		{"Intellect > Critical > Versatility > (Haste = Mastery)"},
	},

	-- 265 - Warlock: Affliction -- https://www.icy-veins.com/wow/affliction-warlock-pve-dps-stat-priority
	[265] = {
		{"(Haste = Mastery) > Critical > Versatility > Intellect"},
	},
	-- 266 - Warlock: Demonology -- https://www.icy-veins.com/wow/demonology-warlock-pve-dps-stat-priority
	[266] = {
		{"Haste > (Mastery = Critical) > Versatility > Intellect"},
	},
	-- 267 - Warlock: Destruction -- https://www.icy-veins.com/wow/destruction-warlock-pve-dps-stat-priority
	[267] = {
		{"(Mastery >= Haste) > Critical > Versatility > Intellect"},
	},

	-- 71 - Warrior: Arms -- https://www.icy-veins.com/wow/arms-warrior-pve-dps-stat-priority
	[71] = {
		{"Haste > Critical > Mastery > Versatility > Strength"},
	},
	-- 72 - Warrior: Fury -- https://www.icy-veins.com/wow/fury-warrior-pve-dps-stat-priority
	[72] = {
		{"Critical > Mastery > Haste > Versatility > Strength"},
	},
	-- 73 - Warrior: Protection -- https://www.icy-veins.com/wow/protection-warrior-pve-tank-stat-priority
	[73] = {
		{"Haste > Versatility > Mastery > Critical > Strength > Armor", "General"},
		{"Haste > Critical > Versatility > Mastery > Strength > Armor", "Dungeon"},
	},
}

function K:GetSPText(specID, k)
	if not data[specID] then return end

	local selected = KkthnxUIDB.StatPriority["selected"][specID] or 1
	local text

	if selected > #data[specID] then -- isCustom
		if KkthnxUIDB.StatPriority.Custom[specID] and KkthnxUIDB.StatPriority.Custom[specID][selected - #data[specID]] then
			text = KkthnxUIDB.StatPriority.Custom[specID][selected - #data[specID]][1]
		else -- data not exists
			KkthnxUIDB.StatPriority["selected"][specID] = 1
			selected = 1
		end
	else
		text = data[specID][selected][1]
	end

	-- localize
	text = string.gsub(text, "Agility", SPEC_FRAME_PRIMARY_STAT_AGILITY)
	text = string.gsub(text, "Armor", STAT_ARMOR)
	text = string.gsub(text, "Critical Strike", STAT_CRITICAL_STRIKE)
	text = string.gsub(text, "Haste", STAT_HASTE)
	text = string.gsub(text, "Intellect", SPEC_FRAME_PRIMARY_STAT_INTELLECT)
	text = string.gsub(text, "Item Level", STAT_AVERAGE_ITEM_LEVEL)
	text = string.gsub(text, "Mastery", STAT_MASTERY)
	text = string.gsub(text, "Stamina", ITEM_MOD_STAMINA_SHORT)
	text = string.gsub(text, "Strength", SPEC_FRAME_PRIMARY_STAT_STRENGTH)
	text = string.gsub(text, "Versatility", STAT_VERSATILITY)
	text = string.gsub(text, "Weapon Damage", DAMAGE_TOOLTIP)
	return text
end

function K:GetSPDesc(specID)
	if data[specID] and (#data[specID] ~= 1 or (KkthnxUIDB.StatPriority.Custom[specID] and #KkthnxUIDB.StatPriority.Custom[specID] ~= 0)) then
		local desc = {}
		for _, t in pairs(data[specID]) do
			table.insert(desc, {t[2] or "General"})
		end
		-- load custom
		if KkthnxUIDB.StatPriority.Custom[specID] then
			for k, t in pairs(KkthnxUIDB.StatPriority.Custom[specID]) do
				table.insert(desc, {t[2], k})
			end
		end
		return desc
	end
end