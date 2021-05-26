local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Infobar")

local _G = _G

local floor, format, strjoin = floor, format, strjoin
local GetInstanceInfo = GetInstanceInfo
local GetTime = GetTime

local timerText, timer, startTime = "Combat", 0, 0

local function UpdateText()
	return format("%02d:%02d", floor(timer/60), timer % 60, (timer - floor(timer)) * 100)
end

local function OnUpdate()
	timer = GetTime() - startTime
	Module.CombatTimeFrame.Text:SetText(string.format("%s: %s", timerText, UpdateText()))
end

local function DelayOnUpdate(_, elapsed)
	startTime = startTime - elapsed
	if startTime <= 0 then
		timer, startTime = 0, GetTime()
		Module.CombatTimeFrame:SetScript("OnUpdate", OnUpdate)
	end
end

local function OnEvent(_, event, _, timeSeconds)
	local _, instanceType = GetInstanceInfo()
	local isInArena = instanceType == "arena"

	if event == "START_TIMER" and isInArena then
		timerText, timer, startTime = "Arena", 0, timeSeconds
		Module.CombatTimeFrame.Text:SetText(string.format("%s: %s", timerText, "00:00:00"))
		Module.CombatTimeFrame:SetScript("OnUpdate", DelayOnUpdate)
	elseif event == "PLAYER_REGEN_ENABLED" and not isInArena then
		Module.CombatTimeFrame:SetScript("OnUpdate", nil)
	elseif event == "PLAYER_REGEN_DISABLED" and not isInArena then
		timerText, timer, startTime = "Combat", 0, GetTime()
		Module.CombatTimeFrame:SetScript("OnUpdate", OnUpdate)
	elseif not Module.CombatTimeFrame.Text:GetText() then
		Module.CombatTimeFrame.Text:SetText(string.format("%s: %s", timerText, "-:-"))
	end
end

function Module:CreateCombatTimeDataText()
	-- Module.CombatTimeFrame = CreateFrame("Frame", "KKUI_CombatTimeDataText", UIParent)
	-- Module.CombatTimeFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", -416, -0)
	-- Module.CombatTimeFrame:SetSize(32, 32)

	-- Module.CombatTimeFrame.Texture = Module.CombatTimeFrame:CreateTexture(nil, "BACKGROUND")
	-- Module.CombatTimeFrame.Texture:SetPoint("LEFT", Module.CombatTimeFrame, "LEFT", 0, 0)
	-- Module.CombatTimeFrame.Texture:SetTexture([[Interface\HELPFRAME\HelpIcon-ItemRestoration]])
	-- Module.CombatTimeFrame.Texture:SetSize(32, 32)

	-- Module.CombatTimeFrame.Text = Module.CombatTimeFrame:CreateFontString(nil, "ARTWORK")
	-- Module.CombatTimeFrame.Text:SetFontObject(K.GetFont(C["UIFonts"].DataTextFonts))
	-- Module.CombatTimeFrame.Text:SetPoint("LEFT", Module.CombatTimeFrame.Texture, "RIGHT", 0, 0)
	-- Module.CombatTimeFrame.Text:SetText(string.format("%s: %s", timerText, "-:-"))

	-- Module.CombatTimeFrame:RegisterEvent("START_TIMER", OnEvent)
	-- Module.CombatTimeFrame:RegisterEvent("PLAYER_REGEN_DISABLED", OnEvent)
	-- Module.CombatTimeFrame:RegisterEvent("PLAYER_REGEN_ENABLED", OnEvent)
	-- Module.CombatTimeFrame:SetScript("OnEvent", OnEvent)

	-- K.Mover(Module.CombatTimeFrame, "CombatTime", "CombatTime", {"BOTTOM", UIParent, "BOTTOM", -416, -0})
end