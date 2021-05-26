local _, C = unpack(select(2, ...))

local _G = _G

C.NameplateWhiteList = {
	-- Buffs
	[642]	= true,	-- 圣盾术
	[1022]	= true,	-- 保护之手
	[23920]	= true,	-- 法术反射
	[45438]	= true,	-- 寒冰屏障
	-- Debuffs
	[2094]	= true,	-- 致盲
}

C.NameplateBlackList = {
	[15407] = true, -- 精神鞭笞
}

C.NameplateCustomUnits = {
	[120651] = true, -- 爆炸物
}

C.NameplateShowPowerList = {
	[155432] = true, -- 魔力使者
}