local K, C = unpack(select(2, ...))
local Module = K:GetModule("Unitframes")

local _G = _G
local select = _G.select

local CreateFrame = _G.CreateFrame
local GetThreatStatusColor = _G.GetThreatStatusColor
local UnitIsUnit = _G.UnitIsUnit
local UnitPowerType = _G.UnitPowerType
local UnitThreatSituation = _G.UnitThreatSituation

local function UpdateRaidThreat(self, _, unit)
	if unit ~= self.unit then
		return
	end

	local situation = UnitThreatSituation(unit)
	if (situation and situation > 0) then
		local r, g, b = GetThreatStatusColor(situation)
		self.KKUI_Border:SetVertexColor(r, g, b)
	else
		self.KKUI_Border:SetVertexColor(1, 1, 1)
	end
end

local function UpdateRaidPower(self, _, unit)
	if self.unit ~= unit then
		return
	end

	local _, powerToken = UnitPowerType(unit)

	if powerToken == "MANA" and C["Raid"].ManabarShow then
		if not self.Power:IsVisible() then
			self.Health:ClearAllPoints()
			self.Health:SetPoint("BOTTOMLEFT", self, 0, 6)
			self.Health:SetPoint("TOPRIGHT", self)

			self.Power:Show()
		end
	else
		if self.Power:IsVisible() then
			self.Health:ClearAllPoints()
			self.Health:SetAllPoints(self)
			self.Power:Hide()
		end
	end
end

function Module:CreateRaid()
	local RaidframeFont = K.GetFont(C["UIFonts"].UnitframeFonts)
	local RaidframeTexture = K.GetTexture(C["UITextures"].UnitframeTextures)
	local HealPredictionTexture = K.GetTexture(C["UITextures"].HealPredictionTextures)

	Module.CreateHeader(self)

	self:CreateBorder()

	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetFrameLevel(self:GetFrameLevel())
	self.Health:SetAllPoints(self)
	self.Health:SetStatusBarTexture(RaidframeTexture)

	self.Health.Value = self.Health:CreateFontString(nil, "OVERLAY")
	self.Health.Value:SetPoint("CENTER", self.Health, 0, -9)
	self.Health.Value:SetFontObject(RaidframeFont)
	self.Health.Value:SetFont(select(1, self.Health.Value:GetFont()), 11, select(3, self.Health.Value:GetFont()))
	self:Tag(self.Health.Value, "[raidhp]")

	self.Health.colorDisconnected = true
	self.Health.frequentUpdates = true

	if C["Raid"].HealthbarColor.Value == "Value" then
		self.Health.colorSmooth = true
		self.Health.colorClass = false
		self.Health.colorReaction = false
	elseif C["Raid"].HealthbarColor.Value == "Dark" then
		self.Health.colorSmooth = false
		self.Health.colorClass = false
		self.Health.colorReaction = false
		self.Health:SetStatusBarColor(0.31, 0.31, 0.31)
	else
		self.Health.colorSmooth = false
		self.Health.colorClass = true
		self.Health.colorReaction = true
	end

	if C["Raid"].Smooth then
		K:SmoothBar(self.Health)
	end

	if C["Raid"].ManabarShow then
		self.Power = CreateFrame("StatusBar", nil, self)
		self.Power:SetFrameStrata("LOW")
		self.Power:SetFrameLevel(self:GetFrameLevel())
		self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -1)
		self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -1)
		self.Power:SetHeight(5.5)
		self.Power:SetStatusBarTexture(RaidframeTexture)

		self.Power.colorPower = true
		self.Power.frequentUpdates = false

		if C["Raid"].Smooth then
			K:SmoothBar(self.Power)
		end

		self.Power.Background = self.Power:CreateTexture(nil, "BORDER")
		self.Power.Background:SetAllPoints(self.Power)
		self.Power.Background:SetColorTexture(.2, .2, .2)
		self.Power.Background.multiplier = 0.3

		table.insert(self.__elements, UpdateRaidPower)
		self:RegisterEvent("UNIT_DISPLAYPOWER", UpdateRaidPower)
		UpdateRaidPower(self)
	end

	if C["Raid"].ShowHealPrediction then
		local myBar = CreateFrame("StatusBar", nil, self)
		myBar:SetWidth(self:GetWidth())
		myBar:SetPoint("TOP", self.Health, "TOP")
		myBar:SetPoint("BOTTOM", self.Health, "BOTTOM")
		myBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
		myBar:SetStatusBarTexture(HealPredictionTexture)
		myBar:SetStatusBarColor(0, 1, 0, .5)
		myBar:Hide()

		local otherBar = CreateFrame("StatusBar", nil, self)
		otherBar:SetWidth(self:GetWidth())
		otherBar:SetPoint("TOP", self.Health, "TOP")
		otherBar:SetPoint("BOTTOM", self.Health, "BOTTOM")
		otherBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
		otherBar:SetStatusBarTexture(HealPredictionTexture)
		otherBar:SetStatusBarColor(0, 1, 1, .5)
		otherBar:Hide()

		self.HealthPrediction = {
			myBar = myBar,
			otherBar = otherBar,
			maxOverflow = 1,
		}
	end

	self.Name = self:CreateFontString(nil, "OVERLAY")
	self.Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 3, -15)
	self.Name:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -3, -15)
	self.Name:SetFontObject(RaidframeFont)
	self.Name:SetWordWrap(false)
	self:Tag(self.Name, "[afkdnd][name]")

	self.Overlay = CreateFrame("Frame", nil, self)
	self.Overlay:SetAllPoints(self.Health)
	self.Overlay:SetFrameLevel(self:GetFrameLevel() + 4)

	self.ReadyCheckIndicator = self.Overlay:CreateTexture(nil, "OVERLAY", 2)
	self.ReadyCheckIndicator:SetSize(22, 22)
	self.ReadyCheckIndicator:SetPoint("CENTER")

	self.PhaseIndicator = self.Overlay:CreateTexture(nil, "OVERLAY")
	self.PhaseIndicator:SetSize(20, 20)
	self.PhaseIndicator:SetPoint("CENTER")
	self.PhaseIndicator:SetTexture([[Interface\AddOns\KkthnxUI\Media\Textures\PhaseIcons.tga]])
	self.PhaseIndicator.PostUpdate = Module.UpdatePhaseIcon

	self.SummonIndicator = self.Overlay:CreateTexture(nil, "OVERLAY")
	self.SummonIndicator:SetSize(20, 20)
	self.SummonIndicator:SetPoint("CENTER", self.Overlay)

	self.RaidTargetIndicator = self.Overlay:CreateTexture(nil, "OVERLAY")
	self.RaidTargetIndicator:SetSize(16, 16)
	self.RaidTargetIndicator:SetPoint("TOP", self, 0, 8)

	self.ResurrectIndicator = self.Overlay:CreateTexture(nil, "OVERLAY")
	self.ResurrectIndicator:SetSize(30, 30)
	self.ResurrectIndicator:SetPoint("CENTER", 0, -3)

	self.LeaderIndicator = self.Overlay:CreateTexture(nil, "OVERLAY")
	self.LeaderIndicator:SetSize(12, 12)
	self.LeaderIndicator:SetPoint("TOPLEFT", -2, 7)

	if C["Raid"].ShowNotHereTimer then
		-- self.StatusIndicator = self:CreateFontString(nil, "OVERLAY")
		-- self.StatusIndicator:SetPoint("CENTER", self.Overlay, "BOTTOM", 0, 6)
		-- self.StatusIndicator:SetFontObject(RaidframeFont)
		-- self.StatusIndicator:SetFont(select(1, self.StatusIndicator:GetFont()), 10, select(3, self.StatusIndicator:GetFont()))
		-- self.StatusIndicator:SetTextColor(1, 0, 0)
		-- self:Tag(self.StatusIndicator, "[afkdnd]")
	end

	if C["Raid"].RaidBuffsStyle.Value == "Aura Track" then
		local AuraTrack = CreateFrame("Frame", nil, self.Health)
		AuraTrack:SetAllPoints()
		AuraTrack.Texture = RaidframeTexture
		AuraTrack.Icons = C["Raid"].AuraTrackIcons
		AuraTrack.SpellTextures = C["Raid"].AuraTrackSpellTextures
		AuraTrack.Thickness = C["Raid"].AuraTrackThickness

		self.AuraTrack = AuraTrack
	elseif C["Raid"].RaidBuffsStyle.Value == "Standard" then
		local Buffs = CreateFrame("Frame", self:GetName().."Buffs", self.Health)
		local onlyShowPlayer = C["Raid"].RaidBuffs.Value == "Self"
		local filter = C["Raid"].RaidBuffs.Value == "All" and "HELPFUL" or "HELPFUL|RAID"

		Buffs:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 0, 0)
		Buffs:SetHeight(16)
		Buffs:SetWidth(79)
		Buffs.size = 16
		Buffs.num = 5
		Buffs.numRow = 1
		Buffs.spacing = 0
		Buffs.initialAnchor = "TOPLEFT"
		Buffs.disableCooldown = true
		Buffs.disableMouse = true
		Buffs.onlyShowPlayer = onlyShowPlayer
		Buffs.filter = filter
		Buffs.IsRaid = true
		Buffs.PostCreateIcon = Module.PostCreateAura
		Buffs.PostUpdateIcon = Module.PostUpdateAura

		self.Buffs = Buffs
	end

	if C["Raid"].DebuffWatch then
		local RaidDebuffs = CreateFrame("Frame", nil, self.Health)
		local Height = C["Raid"].Height
		local DebuffSize = Height >= 32 and Height - 20 or Height

		RaidDebuffs:SetHeight(DebuffSize)
		RaidDebuffs:SetWidth(DebuffSize)
		RaidDebuffs:SetPoint("CENTER", self.Health)
		RaidDebuffs:SetFrameLevel(self.Health:GetFrameLevel() + 10)
		RaidDebuffs:CreateBorder()

		RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, "ARTWORK")
		RaidDebuffs.icon:SetTexCoord(.1, .9, .1, .9)
		RaidDebuffs.icon:SetAllPoints(RaidDebuffs)

		RaidDebuffs.cd = CreateFrame("Cooldown", nil, RaidDebuffs, "CooldownFrameTemplate")
		RaidDebuffs.cd:SetAllPoints(RaidDebuffs)
		RaidDebuffs.cd:SetReverse(true)
		RaidDebuffs.cd.noOCC = true
		RaidDebuffs.cd.noCooldownCount = true
		RaidDebuffs.cd:SetHideCountdownNumbers(true)
		RaidDebuffs.cd:SetAlpha(.7)

		RaidDebuffs.onlyMatchSpellID = true
		RaidDebuffs.showDispellableDebuff = true

		RaidDebuffs.time = RaidDebuffs:CreateFontString(nil, "OVERLAY")
		RaidDebuffs.time:SetFont(C["Media"].Fonts.KkthnxUIFont, 12, "OUTLINE")
		RaidDebuffs.time:SetPoint("CENTER", RaidDebuffs, 1, 0)

		RaidDebuffs.count = RaidDebuffs:CreateFontString(nil, "OVERLAY")
		RaidDebuffs.count:SetFont(C["Media"].Fonts.KkthnxUIFont, 12, "OUTLINE")
		RaidDebuffs.count:SetPoint("BOTTOMRIGHT", RaidDebuffs, "BOTTOMRIGHT", 2, 0)
		RaidDebuffs.count:SetTextColor(1, .9, 0)
		-- RaidDebuffs.forceShow = true

		self.RaidDebuffs = RaidDebuffs
	end

	if C["Raid"].TargetHighlight then
		self.TargetHighlight = CreateFrame("Frame", nil, self.Overlay, "BackdropTemplate")
		self.TargetHighlight:SetBackdrop({edgeFile = C["Media"].Borders.GlowBorder, edgeSize = 12})
		self.TargetHighlight:SetPoint("TOPLEFT", self, -5, 5)
		self.TargetHighlight:SetPoint("BOTTOMRIGHT", self, 5, -5)
		self.TargetHighlight:SetBackdropBorderColor(1, 1, 0)
		self.TargetHighlight:Hide()

		local function UpdateRaidTargetGlow()
			if UnitIsUnit("target", self.unit) then
				self.TargetHighlight:Show()
			else
				self.TargetHighlight:Hide()
			end
		end

		self:RegisterEvent("PLAYER_TARGET_CHANGED", UpdateRaidTargetGlow, true)
		self:RegisterEvent("GROUP_ROSTER_UPDATE", UpdateRaidTargetGlow, true)
	end

	self.DebuffHighlight = self.Health:CreateTexture(nil, "OVERLAY")
	self.DebuffHighlight:SetAllPoints(self.Health)
	self.DebuffHighlight:SetTexture(C["Media"].Textures.BlankTexture)
	self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
	self.DebuffHighlight:SetBlendMode("ADD")

	self.DebuffHighlightAlpha = 0.45
	self.DebuffHighlightFilter = true

	self.Highlight = self.Health:CreateTexture(nil, "OVERLAY")
	self.Highlight:SetAllPoints()
	self.Highlight:SetTexture("Interface\\PETBATTLES\\PetBattle-SelectedPetGlow")
	self.Highlight:SetTexCoord(0, 1, .5, 1)
	self.Highlight:SetVertexColor(.6, .6, .6)
	self.Highlight:SetBlendMode("ADD")
	self.Highlight:Hide()

	self.ThreatIndicator = {
		IsObjectType = function() end,
		Override = UpdateRaidThreat,
	}

	self.Range = Module.CreateRangeIndicator(self)
end