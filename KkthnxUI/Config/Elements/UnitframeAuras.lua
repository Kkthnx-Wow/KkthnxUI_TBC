local K, C = unpack(select(2, ...))

local function Priority(priorityOverride)
	return {
		enable = true,
		priority = priorityOverride or 0,
		stackThreshold = 0
	}
end

-- Raid Debuffs
C.DebuffsTracking_PvE = {
	["type"] = "Whitelist",
		["spells"] = {
			
		---------------
		-- Pre-Patch --
		---------------
			
			-- Onyxia's Lair
				[18431] = Priority(2), --Bellowing Roar
			-- Molten Core
				[19703] = Priority(2), --Lucifron's Curse
				[19408] = Priority(2), --Panic
				[19716] = Priority(2), --Gehennas' Curse
				[20277] = Priority(2), --Fist of Ragnaros
				[20475] = Priority(6), --Living Bomb
				[19695] = Priority(6), --Inferno
				[19659] = Priority(2), --Ignite Mana
				[19714] = Priority(2), --Deaden Magic
				[19713] = Priority(2), --Shazzrah's Curse
			-- Blackwing's Lair
				[23023] = Priority(2), --Conflagration
				[18173] = Priority(2), --Burning Adrenaline
				[24573] = Priority(2), --Mortal Strike
				[23340] = Priority(2), --Shadow of Ebonroc
				[23170] = Priority(2), --Brood Affliction: Bronze
				[22687] = Priority(2), --Veil of Shadow
			-- Zul'Gurub
				[23860] = Priority(2), --Holy Fire
				[22884] = Priority(2), --Psychic Scream
				[23918] = Priority(2), --Sonic Burst
				[24111] = Priority(2), --Corrosive Poison
				[21060] = Priority(2), --Blind
				[24328] = Priority(2), --Corrupted Blood
				[16856] = Priority(2), --Mortal Strike
				[24664] = Priority(2), --Sleep
				[17172] = Priority(2), --Hex
				[24306] = Priority(2), --Delusions of Jin'do
				[24099] = Priority(2), --Poison Bolt Volley
			-- Ahn'Qiraj Ruins
				[25646] = Priority(2), --Mortal Wound
				[25471] = Priority(2), --Attack Order
				[96] = Priority(2), --Dismember
				[25725] = Priority(2), --Paralyze
				[25189] = Priority(2), --Enveloping Winds
			-- Ahn'Qiraj Temple
				[785] = Priority(2), --True Fulfillment
				[26580] = Priority(2), --Fear
				[26050] = Priority(2), --Acid Spit
				[26180] = Priority(2), --Wyvern Sting
				[26053] = Priority(2), --Noxious Poison
				[26613] = Priority(2), --Unbalancing Strike
				[26029] = Priority(2), --Dark Glare
			-- Naxxramas
				[28732] = Priority(2), --Widow's Embrace
				[28622] = Priority(2), --Web Wrap
				[28169] = Priority(2), --Mutating Injection
				[29213] = Priority(2), --Curse of the Plaguebringer
				[28835] = Priority(2), --Mark of Zeliek
				[27808] = Priority(2), --Frost Blast
				[28410] = Priority(2), --Chains of Kel'Thuzad
				[27819] = Priority(2), --Detonate Mana

		-------------
		-- Phase 1 --
		-------------

		-- Karazhan
			-- Trash
				[29679] = Priority(4), -- Bad Poetry
				[29505] = Priority(3), -- Banshee Shriek
				[32441] = Priority(4), -- Brittle Bones
				[29690] = Priority(5), -- Drunken Skull Crack
				[29321] = Priority(4), -- Fear
				[29935] = Priority(4), -- Gaping Maw
				[29670] = Priority(5), -- Ice Tomb
				[29491] = Priority(4), -- Impending Betrayal
				[41580] = Priority(3), -- Net
				[29676] = Priority(5), -- Rolling Pin
				[29490] = Priority(5), -- Seduction
				[29684] = Priority(5), -- Shield Slam
				[29300] = Priority(5), -- Sonic Blast
				[29900] = Priority(5), -- Unstable Magic (Good Debuff)
			-- Attumen the Huntsman
				[29833] = Priority(3), -- Intangible Presence
				[29711] = Priority(4), -- Knockdown
			-- Moroes
				[34694] = Priority(4), -- Blind
				[37066] = Priority(5), -- Garrote
				[29425] = Priority(4), -- Gouge
				[13005] = Priority(3), -- Hammer of Justice (Baron Rafe Dreuger)
				[29572] = Priority(3), -- Mortal Strike (Lord Robin Daris)
			-- Maiden of Virtue
				[29522] = Priority(3), -- Holy Fire
				[29511] = Priority(4), -- Repentance
			-- Animal Bosses
			-- Hyakiss the Lurker
				[29901] = Priority(3), -- Acidic Fang
				[29896] = Priority(4), -- Hyakiss' Web
			-- Rokad the Ravager
				[29906] = Priority(3), -- Ravage
			-- Shadikith the Glider
				[29903] = Priority(4), -- Dive
				[29904] = Priority(3), -- Sonic Burst
			-- Opera Event (Wizard of Oz)
				[31042] = Priority(5), -- Shred Armor
				[31046] = Priority(4), -- Brain Bash
			-- Opera Event (The Big Bad Wolf)
				[30753] = Priority(5), -- Red Riding Hood
				[30752] = Priority(3), -- Terrifying Howl
				[30761] = Priority(4), -- Wide Swipe
			-- Opera Event (Romulo and Julianne)
				[30890] = Priority(3), -- Blinding Passion
				[30822] = Priority(4), -- Poisoned Thrust
				[30889] = Priority(5), -- Powerful Attraction
			-- The Curator
			-- Shade of Aran
				[29991] = Priority(5), -- Chains of Ice
				[29954] = Priority(3), -- Frostbolt
				[30035] = Priority(4), -- Mass Slow
				[29990] = Priority(5), -- Slow
			-- Terestian Illhoof
				[30053] = Priority(3), -- Amplify Flames
				[30115] = Priority(4), -- Sacrifice
			-- Netherspite
				[37063] = Priority(3), -- Void Zone
			-- Chess Event
			-- Prince Malchezaar
				[39095] = Priority(3), -- Amplify Damage
				[30843] = Priority(5), -- Enfeeble
				[30854] = Priority(4), -- Shadow Word: Pain (Tank)
				[30898] = Priority(4), -- Shadow Word: Pain (Raid)
				[30901] = Priority(3), -- Sunder Armor
			-- Nightbane
				[36922] = Priority(5), -- Bellowing Roar
				[30129] = Priority(6), -- Charred Earth
				[30130] = Priority(3), -- Distracting Ash
				[37098] = Priority(5), -- Rain of Bones
				[30127] = Priority(4), -- Searing Cinders
				[30210] = Priority(3), -- Smoldering Breath
				[25653] = Priority(3), -- Tail Sweep
		-- Gruul's Lair
			-- Trash
				[22884] = Priority(4), -- Psychic Scream
			-- High King Maulgar
			-- Blindeye the Seer
			-- Kiggler the Crazed
				[33175] = Priority(3), -- Arcane Shock
				[33173] = Priority(5), -- Greater Polymorph
			-- Krosh Firehand
				[33061] = Priority(3), -- Blast Wave
			-- Olm the Summoner
				[33129] = Priority(4), -- Dark Decay
				[33130] = Priority(5), -- Death Coil
			-- High King Maulgar
				[16508] = Priority(5), -- Intimidating Roar
			-- Gruul the Dragonkiller
				[36240] = Priority(4), -- Cave In
		-- Magtheridon's Lair
			-- Trash
				[34437] = Priority(4), -- Death Coil
				[34435] = Priority(3), -- Rain of Fire
				[34439] = Priority(5), -- Unstable Affliction
			-- Magtheridon
				[30410] = Priority(3), -- Shadow Grasp

		-------------
		-- Phase 2 --
		-------------

		-- Serpentshrine Cavern
			-- Trash
				[38634] = Priority(3), -- Arcane Lightning
				[39032] = Priority(4), -- Initial Infection
				[38572] = Priority(3), -- Mortal Cleave
				[38635] = Priority(3), -- Rain of Fire
				[39042] = Priority(5), -- Rampent Infection
				[39044] = Priority(4), -- Serpentshrine Parasite
				[38591] = Priority(4), -- Shatter Armor
				[38491] = Priority(3), -- Silence
			-- Hydross the Unstable
				[38246] = Priority(3), -- Vile Sludge
				[38235] = Priority(4), -- Water Tomb
			-- The Lurker Below
			-- Morogrim Tidewalker
				[38049] = Priority(4), -- Watery Grave
				[37850] = Priority(4), -- Watery Grave
			-- Fathom-Lord Karathress
				[39261] = Priority(3), -- Gusting Winds
				[29436] = Priority(4), -- Leeching Throw
			-- Leotheras the Blind
				[37675] = Priority(3), -- Chaos Blast
				[37749] = Priority(5), -- Consuming Madness
				[37676] = Priority(4), -- Insidious Whisper
				[37641] = Priority(3), -- Whirlwind
			-- Lady Vashj
				[38316] = Priority(3), -- Entangle
				[38280] = Priority(5), -- Static Charge
		-- Tempest Keep: The Eye
			-- Trash
				[37133] = Priority(4), -- Arcane Buffet
				[37132] = Priority(3), -- Arcane Shock
				[37122] = Priority(5), -- Domination
				[37135] = Priority(5), -- Domination
				[37120] = Priority(4), -- Fragmentation Bomb
				[13005] = Priority(3), -- Hammer of Justice
				[39077] = Priority(3), -- Hammer of Justice
				[37279] = Priority(3), -- Rain of Fire
				[37123] = Priority(4), -- Saw Blade
				[37118] = Priority(5), -- Shell Shock
				[37160] = Priority(3), -- Silence
			-- Al'ar
				[35410] = Priority(4), -- Melt Armor
			-- Void Reaver
			-- High Astromancer Solarian
				[34322] = Priority(4), -- Psychic Scream
				[42783] = Priority(5), -- Wrath of the Astromancer (Patch 2.2.0)
			-- Kael'thas Sunstrider
				[36965] = Priority(4), -- Rend
				[30225] = Priority(4), -- Silence
				[44863] = Priority(5), -- Bellowing Roar
				[37018] = Priority(4), -- Conflagration
				[37027] = Priority(5), -- Remote Toy
				[36991] = Priority(4), -- Rend
				[36797] = Priority(5), -- Mind Control

		-------------
		-- Phase 3 --
		-------------

		-- The Battle for Mount Hyjal
			-- Rage Winterchill
			-- Anetheron
			-- Kaz'rogal
			-- Azgalor
			-- Archimonde
		-- Black Temple
			-- High Warlord Naj'entus
			-- Supremus
			-- Shade of Akama
			-- Teron Gorefiend
			-- Gurtogg Bloodboil
			-- Reliquary of Souls
			-- Mother Shahraz
			-- Illidari Council
			-- Illidan Stormrage

		-------------
		-- Phase 4 --
		-------------

		-- Zul'Aman
			-- Nalorakk
			-- Jan'alai
			-- Akil'zon
			-- Halazzi
			-- Hexxlord Jin'Zakk
			-- Zul'jin

		-------------
		-- Phase 5 --
		-------------

		-- Sunwell Plateau
			-- Kalecgos
			-- Sathrovarr
			-- Brutallus
			-- Felmyst
			-- Alythess
			-- Sacrolash
			-- M'uru
			-- Kil'Jaeden
		},
	}


-- Dispell Debuffs
C.DebuffsTracking_PvP = {
	["type"] = "Whitelist",
		["spells"] = {
		-- Druid
			[5211] = Priority(3), -- Bash
			[16922] = Priority(3), -- Celestial Focus
			[33786] = Priority(3), -- Cyclone
			[339] = Priority(2), -- Entangling Roots
			[19975] = Priority(2), -- Entangling Roots (Nature's Grasp)
			[45334] = Priority(2), -- Feral Charge Effect
			[2637] = Priority(3), -- Hibernate
			[22570] = Priority(3), -- Maim
			[9005] = Priority(3), -- Pounce
		-- Hunter
			[19306] = Priority(2), -- Counterattack
			[19185] = Priority(2), -- Entrapment
			[3355] = Priority(3), -- Freezing Trap
			[2637] = Priority(3), -- Hibernate
			[19410] = Priority(3), -- Improved Concussive Shot
			[19229] = Priority(2), -- Improved Wing Clip
			[24394] = Priority(3), -- Intimidation
			[19503] = Priority(3), -- Scatter Shot
			[34490] = Priority(3), -- Silencing Shot
			[4167] = Priority(2), -- Web (Pet)
			[19386] = Priority(3), -- Wyvern Sting
		-- Mage
			[31661] = Priority(3), -- Dragon's Breath
			[33395] = Priority(2), -- Freeze (Water Elemental)
			[12494] = Priority(2), -- Frostbite
			[122] = Priority(2), -- Frost Nova
			[12355] = Priority(3), -- Impact
			[118] = Priority(3), -- Polymorph
			[28272] = Priority(3), -- Polymorph: Pig
			[28271] = Priority(3), -- Polymorph: Turtle
			[18469] = Priority(3), -- Silenced - Improved Counterspell
		-- Paladin
			[853] = Priority(3), -- Hammer of Justice
			[20066] = Priority(3), -- Repentance
			[20170] = Priority(3), -- Stun (Seal of Justice Proc)
			[10326] = Priority(3), -- Turn Evil
			[2878] = Priority(3), -- Turn Undead
		-- Priest
			[15269] = Priority(3), -- Blackout
			[44041] = Priority(3), -- Chastise
			[605] = Priority(3), -- Mind Control
			[8122] = Priority(3), -- Psychic Scream
			[9484] = Priority(3), -- Shackle Undead
			[15487] = Priority(3), -- Silence
		-- Rogue
			[2094] = Priority(3), -- Blind
			[1833] = Priority(3), -- Cheap Shot
			[32747] = Priority(3), -- Deadly Throw Interrupt
			[1330] = Priority(3), -- Garrote - Silence
			[1776] = Priority(3), -- Gouge
			[408] = Priority(3), -- Kidney Shot
			[14251] = Priority(3), -- Riposte
			[6770] = Priority(3), -- Sap
			[18425] = Priority(3), -- Silenced - Improved Kick
		-- Warlock
			[6789] = Priority(3), -- Death Coil
			[5782] = Priority(3), -- Fear
			[5484] = Priority(3), -- Howl of Terror
			[30153] = Priority(3), -- Intercept Stun (Felguard)
			[18093] = Priority(3), -- Pyroclasm
			[6358] = Priority(3), -- Seduction (Succubus)
			[30283] = Priority(3), -- Shadowfury
			[24259] = Priority(3), -- Spell Lock (Felhunter)
		-- Warrior
			[7922] = Priority(3), -- Charge Stun
			[12809] = Priority(3), -- Concussion Blow
			[676] = Priority(3), -- Disarm
			[23694] = Priority(2), -- Improved Hamstring
			[5246] = Priority(3), -- Intimidating Shout
			[20253] = Priority(3), -- Intercept Stun
			[12798] = Priority(3), -- Revenge Stun
			[18498] = Priority(3), -- Shield Bash - Silenced
		-- Racial
			[28730]  = Priority(3), -- Arcane Torrent
			[20549] = Priority(3), -- War Stomp
		-- Others
			[5530] = Priority(3), -- Mace Specialization
		},
	}



-- PvP CrowdControl
C.DebuffsTracking_CrowdControl = {
	["type"] = "Whitelist",
	["spells"] = {
		-- Death Knight
		[47476] = Priority(2), -- Strangulate
		[108194] = Priority(4), -- Asphyxiate UH
		[221562] = Priority(4), -- Asphyxiate Blood
		[207171] = Priority(4), -- Winter is Coming
		[206961] = Priority(3), -- Tremble Before Me
		[207167] = Priority(4), -- Blinding Sleet
		[212540] = Priority(1), -- Flesh Hook (Pet)
		[91807] = Priority(1), -- Shambling Rush (Pet)
		[204085] = Priority(1), -- Deathchill
		[233395] = Priority(1), -- Frozen Center
		[212332] = Priority(4), -- Smash (Pet)
		[212337] = Priority(4), -- Powerful Smash (Pet)
		[91800] = Priority(4), -- Gnaw (Pet)
		[91797] = Priority(4), -- Monstrous Blow (Pet)
		[210141] = Priority(3), -- Zombie Explosion
		-- Demon Hunter
		[207685] = Priority(4), -- Sigil of Misery
		[217832] = Priority(3), -- Imprison
		[221527] = Priority(5), -- Imprison (Banished version)
		[204490] = Priority(2), -- Sigil of Silence
		[179057] = Priority(3), -- Chaos Nova
		[211881] = Priority(4), -- Fel Eruption
		[205630] = Priority(3), -- Illidan's Grasp
		[208618] = Priority(3), -- Illidan's Grasp (Afterward)
		[213491] = Priority(4), -- Demonic Trample (it's this one or the other)
		[208645] = Priority(4), -- Demonic Trample
		-- Druid
		[81261] = Priority(2), -- Solar Beam
		[5211] = Priority(4), -- Mighty Bash
		[163505] = Priority(4), -- Rake
		[203123] = Priority(4), -- Maim
		[202244] = Priority(4), -- Overrun
		[99] = Priority(4), -- Incapacitating Roar
		[33786] = Priority(5), -- Cyclone
		[209753] = Priority(5), -- Cyclone Balance
		[45334] = Priority(1), -- Immobilized
		[102359] = Priority(1), -- Mass Entanglement
		[339] = Priority(1), -- Entangling Roots
		[2637] = Priority(1), -- Hibernate
		[102793] = Priority(1), -- Ursol's Vortex
		-- Hunter
		[202933] = Priority(2), -- Spider Sting (it's this one or the other)
		[233022] = Priority(2), -- Spider Sting
		[213691] = Priority(4), -- Scatter Shot
		[19386] = Priority(3), -- Wyvern Sting
		[3355] = Priority(3), -- Freezing Trap
		[203337] = Priority(5), -- Freezing Trap (Survival PvPT)
		[209790] = Priority(3), -- Freezing Arrow
		[24394] = Priority(4), -- Intimidation
		[117526] = Priority(4), -- Binding Shot
		[190927] = Priority(1), -- Harpoon
		[201158] = Priority(1), -- Super Sticky Tar
		[162480] = Priority(1), -- Steel Trap
		[212638] = Priority(1), -- Tracker's Net
		[200108] = Priority(1), -- Ranger's Net
		-- Mage
		[61721] = Priority(3), -- Rabbit (Poly)
		[61305] = Priority(3), -- Black Cat (Poly)
		[28272] = Priority(3), -- Pig (Poly)
		[28271] = Priority(3), -- Turtle (Poly)
		[126819] = Priority(3), -- Porcupine (Poly)
		[161354] = Priority(3), -- Monkey (Poly)
		[161353] = Priority(3), -- Polar bear (Poly)
		[61780] = Priority(3), -- Turkey (Poly)
		[161355] = Priority(3), -- Penguin (Poly)
		[161372] = Priority(3), -- Peacock (Poly)
		[277787] = Priority(3), -- Direhorn (Poly)
		[277792] = Priority(3), -- Bumblebee (Poly)
		[118] = Priority(3), -- Polymorph
		[82691] = Priority(3), -- Ring of Frost
		[31661] = Priority(3), -- Dragon's Breath
		[122] = Priority(1), -- Frost Nova
		[33395] = Priority(1), -- Freeze
		[157997] = Priority(1), -- Ice Nova
		[228600] = Priority(1), -- Glacial Spike
		[198121] = Priority(1), -- Forstbite
		-- Monk
		[119381] = Priority(4), -- Leg Sweep
		[202346] = Priority(4), -- Double Barrel
		[115078] = Priority(4), -- Paralysis
		[198909] = Priority(3), -- Song of Chi-Ji
		[202274] = Priority(3), -- Incendiary Brew
		[233759] = Priority(2), -- Grapple Weapon
		[123407] = Priority(1), -- Spinning Fire Blossom
		[116706] = Priority(1), -- Disable
		[232055] = Priority(4), -- Fists of Fury (it's this one or the other)
		-- Paladin
		[853] = Priority(3), -- Hammer of Justice
		[20066] = Priority(3), -- Repentance
		[105421] = Priority(3), -- Blinding Light
		[31935] = Priority(2), -- Avenger's Shield
		[217824] = Priority(2), -- Shield of Virtue
		[205290] = Priority(3), -- Wake of Ashes
		-- Priest
		[9484] = Priority(3), -- Shackle Undead
		[200196] = Priority(4), -- Holy Word: Chastise
		[200200] = Priority(4), -- Holy Word: Chastise
		[226943] = Priority(3), -- Mind Bomb
		[605] = Priority(5), -- Mind Control
		[8122] = Priority(3), -- Psychic Scream
		[15487] = Priority(2), -- Silence
		[64044] = Priority(1), -- Psychic Horror
		-- Rogue
		[2094] = Priority(4), -- Blind
		[6770] = Priority(4), -- Sap
		[1776] = Priority(4), -- Gouge
		[1330] = Priority(2), -- Garrote - Silence
		[207777] = Priority(2), -- Dismantle
		[199804] = Priority(4), -- Between the Eyes
		[408] = Priority(4), -- Kidney Shot
		[1833] = Priority(4), -- Cheap Shot
		[207736] = Priority(5), -- Shadowy Duel (Smoke effect)
		[212182] = Priority(5), -- Smoke Bomb
		-- Shaman
		[51514] = Priority(3), -- Hex
		[211015] = Priority(3), -- Hex (Cockroach)
		[211010] = Priority(3), -- Hex (Snake)
		[211004] = Priority(3), -- Hex (Spider)
		[210873] = Priority(3), -- Hex (Compy)
		[196942] = Priority(3), -- Hex (Voodoo Totem)
		[269352] = Priority(3), -- Hex (Skeletal Hatchling)
		[277778] = Priority(3), -- Hex (Zandalari Tendonripper)
		[277784] = Priority(3), -- Hex (Wicker Mongrel)
		[118905] = Priority(3), -- Static Charge
		[77505] = Priority(4), -- Earthquake (Knocking down)
		[118345] = Priority(4), -- Pulverize (Pet)
		[204399] = Priority(3), -- Earthfury
		[204437] = Priority(3), -- Lightning Lasso
		[157375] = Priority(4), -- Gale Force
		[64695] = Priority(1), -- Earthgrab
		-- Warlock
		[710] = Priority(5), -- Banish
		[6789] = Priority(3), -- Mortal Coil
		[118699] = Priority(3), -- Fear
		[6358] = Priority(3), -- Seduction (Succub)
		[171017] = Priority(4), -- Meteor Strike (Infernal)
		[22703] = Priority(4), -- Infernal Awakening (Infernal CD)
		[30283] = Priority(3), -- Shadowfury
		[89766] = Priority(4), -- Axe Toss
		[233582] = Priority(1), -- Entrenched in Flame
		-- Warrior
		[5246] = Priority(4), -- Intimidating Shout
		[7922] = Priority(4), -- Warbringer
		[132169] = Priority(4), -- Storm Bolt
		[132168] = Priority(4), -- Shockwave
		[199085] = Priority(4), -- Warpath
		[105771] = Priority(1), -- Charge
		[199042] = Priority(1), -- Thunderstruck
		[236077] = Priority(2), -- Disarm
		-- Racial
		[20549] = Priority(4), -- War Stomp
		[107079] = Priority(4), -- Quaking Palm
	},
}

-- Buffs that really we dont need to see
C.DebuffsTracking_Blacklist = {
	type = "Blacklist",
	spells = {
		[36900]  = Priority(), -- Soul Split: Evil!
		[36901]  = Priority(), -- Soul Split: Good
		[36893]  = Priority(), -- Transporter Malfunction
		[97821]  = Priority(), -- Void-Touched
		[36032]  = Priority(), -- Arcane Charge
		[8733]   = Priority(), -- Blessing of Blackfathom
		[25771]  = Priority(), -- Forbearance (pally: divine shield, hand of protection, and lay on hands)
		[57724]  = Priority(), -- Sated (lust debuff)
		[57723]  = Priority(), -- Exhaustion (heroism debuff)
		[80354]  = Priority(), -- Temporal Displacement (timewarp debuff)
		[95809]  = Priority(), -- Insanity debuff (hunter pet heroism: ancient hysteria)
		[58539]  = Priority(), -- Watcher's Corpse
		[26013]  = Priority(), -- Deserter
		[71041]  = Priority(), -- Dungeon Deserter
		[41425]  = Priority(), -- Hypothermia
		[55711]  = Priority(), -- Weakened Heart
		[8326]   = Priority(), -- Ghost
		[23445]  = Priority(), -- Evil Twin
		[24755]  = Priority(), -- Tricked or Treated
		[25163]  = Priority(), -- Oozeling's Disgusting Aura
		[124275] = Priority(), -- Stagger
		[124274] = Priority(), -- Stagger
		[124273] = Priority(), -- Stagger
		[117870] = Priority(), -- Touch of The Titans
		[123981] = Priority(), -- Perdition
		[15007]  = Priority(), -- Ress Sickness
		[113942] = Priority(), -- Demonic: Gateway
		[89140]  = Priority(), -- Demonic Rebirth: Cooldown
		[287825] = Priority(), -- Lethargy debuff (fight or flight)
		[206662] = Priority(), -- Experience Eliminated (in range)
		[306600] = Priority(), -- Experience Eliminated (oor - 5m)
	},
}

C.ChannelingTicks = {
	--First Aid
	[23567] = 8, --Warsong Gulch Runecloth Bandage
	[23696] = 8, --Alterac Heavy Runecloth Bandage
	[24414] = 8, --Arathi Basin Runecloth Bandage
	[18610] = 8, --Heavy Runecloth Bandage
	[18608] = 8, --Runecloth Bandage
	[10839] = 8, --Heavy Mageweave Bandage
	[10838] = 8, --Mageweave Bandage
	[7927] = 8, --Heavy Silk Bandage
	[7926] = 8, --Silk Bandage
	[3268] = 7, --Heavy Wool Bandage
	[3267] = 7, --Wool Bandage
	[1159] = 6, --Heavy Linen Bandage
	[746] = 6, --Linen Bandage
	-- Warlock
	[1120] = 5, -- Drain Soul(Rank 1)
	[8288] = 5, -- Drain Soul(Rank 2)
	[8289] = 5, -- Drain Soul(Rank 3)
	[11675] = 5, -- Drain Soul(Rank 4)
	[27217] = 5, -- Drain Soul(Rank 5)
	[755] = 10, -- Health Funnel(Rank 1)
	[3698] = 10, -- Health Funnel(Rank 2)
	[3699] = 10, -- Health Funnel(Rank 3)
	[3700] = 10, -- Health Funnel(Rank 4)
	[11693] = 10, -- Health Funnel(Rank 5)
	[11694] = 10, -- Health Funnel(Rank 6)
	[11695] = 10, -- Health Funnel(Rank 7)
	[27259] = 10, -- Health Funnel(Rank 8)
	[689] = 5, -- Drain Life(Rank 1)
	[699] = 5, -- Drain Life(Rank 2)
	[709] = 5, -- Drain Life(Rank 3)
	[7651] = 5, -- Drain Life(Rank 4)
	[11699] = 5, -- Drain Life(Rank 5)
	[11700] = 5, -- Drain Life(Rank 6)
	[27219] = 5, -- Drain Life(Rank 7)
	[27220] = 5, -- Drain Life(Rank 8)
	[5740] =  4, --Rain of Fire(Rank 1)
	[6219] =  4, --Rain of Fire(Rank 2)
	[11677] =  4, --Rain of Fire(Rank 3)
	[11678] =  4, --Rain of Fire(Rank 4)
	[27212] =  4, --Rain of Fire(Rank 5)
	[1949] = 15, --Hellfire(Rank 1)
	[11683] = 15, --Hellfire(Rank 2)
	[11684] = 15, --Hellfire(Rank 3)
	[27213] = 15, --Hellfire(Rank 4)
	[5138] = 5, --Drain Mana(Rank 1)
	[6226] = 5, --Drain Mana(Rank 2)
	[11703] = 5, --Drain Mana(Rank 3)
	[11704] = 5, --Drain Mana(Rank 4)
	[27221] = 5, --Drain Mana(Rank 5)
	[30908] = 5, --Drain Mana(Rank 6)
	-- Priest
	[15407] = 3, -- Mind Flay(Rank 1)
	[17311] = 3, -- Mind Flay(Rank 2)
	[17312] = 3, -- Mind Flay(Rank 3)
	[17313] = 3, -- Mind Flay(Rank 4)
	[17314] = 3, -- Mind Flay(Rank 5)
	[18807] = 3, -- Mind Flay(Rank 6)
	[25387] = 3, -- Mind Flay(Rank 7)
	-- Mage
	[10] = 8, --Blizzard(Rank 1)
	[6141] = 8, --Blizzard(Rank 2)
	[8427] = 8, --Blizzard(Rank 3)
	[10185] = 8, --Blizzard(Rank 4)
	[10186] = 8, --Blizzard(Rank 5)
	[10187] = 8, --Blizzard(Rank 6)
	[27085] = 8, --Blizzard(Rank 7)
	[5143] = 3, -- Arcane Missiles(Rank 1)
	[5144] = 4, -- Arcane Missiles(Rank 2)
	[5145] = 5, -- Arcane Missiles(Rank 3)
	[8416] = 5, -- Arcane Missiles(Rank 4)
	[8417] = 5, -- Arcane Missiles(Rank 5)
	[10211] = 5, -- Arcane Missiles(Rank 6)
	[10212] = 5, -- Arcane Missiles(Rank 7)
	[25345] = 5, -- Arcane Missiles(Rank 8)
	[27075] = 5, -- Arcane Missiles(Rank 9)
	[38699] = 5, -- Arcane Missiles(Rank 10)
	[12051] = 4, -- Evocation
	--Druid
	[740] = 5, -- Tranquility(Rank 1)
	[8918] = 5, --Tranquility(Rank 2)
	[9862] = 5, --Tranquility(Rank 3)
	[9863] = 5, --Tranquility(Rank 4)
	[26983] = 5, --Tranquility(Rank 5)
	[16914] = 10, --Hurricane(Rank 1)
	[17401] = 10, --Hurricane(Rank 2)
	[17402] = 10, --Hurricane(Rank 3)
	[27012] = 10, --Hurricane(Rank 4)
	--Hunter
	[1510] = 6, --Volley(Rank 1)
	[14294] = 6, --Volley(Rank 2)
	[14295] = 6, --Volley(Rank 3)
	[27022] = 6, --Volley(Rank 4)
}

if K.Class == "PRIEST" then
	local penanceID = 47758
	local function updateTicks()
		local numTicks = 3
		if IsPlayerSpell(193134) then numTicks = 4 end
		C.ChannelingTicks[penanceID] = numTicks
	end
	K:RegisterEvent("PLAYER_LOGIN", updateTicks)
	K:RegisterEvent("PLAYER_TALENT_UPDATE", updateTicks)
end