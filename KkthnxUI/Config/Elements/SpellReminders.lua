local _, C = unpack(select(2, ...))

-- Reminder Buffs Checklist
C.SpellReminderBuffs = {
	MAGE = {
		{	spells = {	-- 奥术智慧
				[1459] = true,
				[8096] = true,  -- 智力卷轴
				[23028] = true, -- 奥术光辉
			},
			depend = 1459,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	PRIEST = {
		{	spells = {	-- 真言术耐
				[1243] = true,
				[8099] = true,  -- 耐力卷轴
				[21562] = true, -- 坚韧祷言
			},
			depend = 1243,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {	-- 心灵之火
				[588] = true,
			},
			depend = 588,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	DRUID = {
		{	spells = {	-- 野性印记
				[1126] = true,
				[21849] = true, -- 野性赐福
			},
			depend = 1126,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {	--- 荆棘术
				[467] = true,
			},
			depend = 467,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	WARRIOR = {
		{	spells = {	-- 战斗怒吼
				[6673] = true,
				[25289] = true,
			},
			depends = {6673, 5242, 6192, 11549, 11550, 11551, 25289},
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	HUNTER = {
		{	spells = {	-- 雄鹰守护
				[13165] = true,
			},
			depend = 13165,
			combat = true,
			instance = true,
			pvp = true,
		},
		{	spells = {	--- 强击光环
				[20906] = true,
			},
			depend = 20906,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
}