local K, C = unpack(select(2, ...))
local Module = K:GetModule("Unitframes")

local _G = _G
local select = _G.select
local string_format = _G.string.format

local CreateFrame = _G.CreateFrame

local playerWidth = C["Unitframe"].PlayerFrameWidth

function Module.PostUpdateAddPower(element, _, cur, max)
	-- if element.Text and max > 0 then
	if max > 0 then
		local perc = cur / max * 100
		if perc == 100 then
			--perc = ""
			element:SetAlpha(0)
		else
			--perc = string_format("%d%%", perc)
			element:SetAlpha(1)
		end

		-- element.Text:SetText(perc)
	end
end

function Module:CreatePlayer()
	self.mystyle = "player"

	local UnitframeFont = K.GetFont(C["UIFonts"].UnitframeFonts)
	local UnitframeTexture = K.GetTexture(C["UITextures"].UnitframeTextures)
	local HealPredictionTexture = K.GetTexture(C["UITextures"].HealPredictionTextures)

	self.Overlay = CreateFrame("Frame", nil, self) -- We will use this to overlay onto our special borders.
	self.Overlay:SetAllPoints()
	self.Overlay:SetFrameLevel(5)

	Module.CreateHeader(self)

	self.Health = CreateFrame("StatusBar", nil, self)
	if C["Unitframe"].PlayerPower then
		self.Health:SetHeight(C["Unitframe"].PlayerFrameHeight * 0.7)
	else
		self.Health:SetHeight(C["Unitframe"].PlayerFrameHeight + 6)
	end
	self.Health:SetPoint("TOPLEFT")
	self.Health:SetPoint("TOPRIGHT")
	self.Health:SetStatusBarTexture(UnitframeTexture)
	self.Health:CreateBorder()

	self.Health.PostUpdate = C["Unitframe"].PortraitStyle.Value ~= "ThreeDPortraits" and Module.UpdateHealth
	self.Health.colorTapping = true
	self.Health.colorDisconnected = true
	self.Health.frequentUpdates = true

	if C["Unitframe"].Smooth then
		K:SmoothBar(self.Health)
	end

	if C["Unitframe"].HealthbarColor.Value == "Value" then
		self.Health.colorSmooth = true
		self.Health.colorClass = false
		self.Health.colorReaction = false
	elseif C["Unitframe"].HealthbarColor.Value == "Dark" then
		self.Health.colorSmooth = false
		self.Health.colorClass = false
		self.Health.colorReaction = false
		self.Health:SetStatusBarColor(0.31, 0.31, 0.31)
	else
		self.Health.colorSmooth = false
		self.Health.colorClass = true
		self.Health.colorReaction = true
	end

	self.Health.Value = self.Health:CreateFontString(nil, "OVERLAY")
	self.Health.Value:SetFontObject(UnitframeFont)
	self.Health.Value:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
	self:Tag(self.Health.Value, "[hp]")

	self.Power = CreateFrame("StatusBar", nil, self)
	if C["Unitframe"].PlayerPower then
		self.Power:SetHeight(C["Unitframe"].PlayerFrameHeight * 0.3)
	else
		self.Power:SetHeight(0)
	end
	self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -6)
	self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -6)
	self.Power:SetStatusBarTexture(UnitframeTexture)
	self.Power:CreateBorder()

	self.Power.colorPower = true
	self.Power.frequentUpdates = true

	if C["Unitframe"].Smooth then
		K:SmoothBar(self.Power)
	end

	self.Power.Value = self.Power:CreateFontString(nil, "OVERLAY")
	self.Power.Value:SetPoint("CENTER", self.Power, "CENTER", 0, 0)
	self.Power.Value:SetFontObject(UnitframeFont)
	self.Power.Value:SetFont(select(1, self.Power.Value:GetFont()), 11, select(3, self.Power.Value:GetFont()))
	self:Tag(self.Power.Value, "[power]")

	local portraitSize
	if C["Unitframe"].PlayerPower and C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" then
		portraitSize = self.Health:GetHeight() + self.Power:GetHeight() + 6
	else
		portraitSize = self.Health:GetHeight() + self.Power:GetHeight()
	end

	if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" then
		if C["Unitframe"].PortraitStyle.Value == "ThreeDPortraits" then
			self.Portrait = CreateFrame("PlayerModel", "KKUI_PlayerPortrait", self.Health)
			self.Portrait:SetFrameStrata(self:GetFrameStrata())
			self.Portrait:SetSize(portraitSize, portraitSize)
			self.Portrait:SetPoint("TOPRIGHT", self, "TOPLEFT", -6, 0)
			self.Portrait:CreateBorder()
		elseif C["Unitframe"].PortraitStyle.Value ~= "ThreeDPortraits" then
			self.Portrait = self.Health:CreateTexture("KKUI_PlayerPortrait", "BACKGROUND", nil, 1)
			self.Portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
			self.Portrait:SetSize(portraitSize, portraitSize)
			self.Portrait:SetPoint("TOPRIGHT", self, "TOPLEFT", -6, 0)

			self.Portrait.Border = CreateFrame("Frame", nil, self)
			self.Portrait.Border:SetAllPoints(self.Portrait)
			self.Portrait.Border:CreateBorder()

			if (C["Unitframe"].PortraitStyle.Value == "ClassPortraits" or C["Unitframe"].PortraitStyle.Value == "NewClassPortraits") then
				self.Portrait.PostUpdate = Module.UpdateClassPortraits
			end
		end
	end

	if C["Unitframe"].ClassResources and not C["Nameplate"].ShowPlayerPlate then
		Module:CreateClassPower(self)
	end

	if C["Unitframe"].PlayerDeBuffs then
		local width = playerWidth - portraitSize

		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs.spacing = 6
		self.Debuffs.initialAnchor = "BOTTOMLEFT"
		self.Debuffs["growth-x"] = "RIGHT"
		self.Debuffs["growth-y"] = "UP"
		self.Debuffs:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 26)
		self.Debuffs.num = 14
		self.Debuffs.iconsPerRow = 5

		self.Debuffs.size = Module.auraIconSize(width, self.Debuffs.iconsPerRow, self.Debuffs.spacing)
		self.Debuffs:SetWidth(width)
		self.Debuffs:SetHeight((self.Debuffs.size + self.Debuffs.spacing) * math.floor(self.Debuffs.num / self.Debuffs.iconsPerRow + .5))

		self.Debuffs.CustomFilter = Module.CustomFilter
		self.Debuffs.PostCreateIcon = Module.PostCreateAura
		self.Debuffs.PostUpdateIcon = Module.PostUpdateAura
	end

	if C["Unitframe"].PlayerBuffs then
		local width = playerWidth - portraitSize

		self.Buffs = CreateFrame("Frame", nil, self)
		if C["Unitframe"].PlayerPower then
			self.Buffs:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -6)
		else
			self.Buffs:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -6)
		end
		self.Buffs.initialAnchor = "TOPLEFT"
		self.Buffs["growth-x"] = "RIGHT"
		self.Buffs["growth-y"] = "DOWN"
		self.Buffs.num = 6
		self.Buffs.spacing = 6
		self.Buffs.iconsPerRow = 6
		self.Buffs.onlyShowPlayer = false

		self.Buffs.size = Module.auraIconSize(width, self.Buffs.iconsPerRow, self.Buffs.spacing)
		self.Buffs:SetWidth(width)
		self.Buffs:SetHeight((self.Buffs.size + self.Buffs.spacing) * math.floor(self.Buffs.num/self.Buffs.iconsPerRow + .5))

		self.Buffs.CustomFilter = Module.CustomFilter
		self.Buffs.PostCreateIcon = Module.PostCreateAura
		self.Buffs.PostUpdateIcon = Module.PostUpdateAura
	end

	if C["Unitframe"].PlayerCastbar then
		self.Castbar = CreateFrame("StatusBar", "PlayerCastbar", self)
		self.Castbar:SetPoint("BOTTOM", UIParent, "BOTTOM", 14, 200)
		self.Castbar:SetStatusBarTexture(UnitframeTexture)
		self.Castbar:SetSize(C["Unitframe"].PlayerCastbarWidth, C["Unitframe"].PlayerCastbarHeight)
		self.Castbar:SetClampedToScreen(true)
		self.Castbar:CreateBorder()

		self.Castbar.Spark = self.Castbar:CreateTexture(nil, "OVERLAY")
		self.Castbar.Spark:SetTexture(C["Media"].Textures.Spark128Texture)
		self.Castbar.Spark:SetSize(64, self.Castbar:GetHeight())
		self.Castbar.Spark:SetBlendMode("ADD")

		if C["Unitframe"].CastbarLatency then
			self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "ARTWORK")
			self.Castbar.SafeZone:SetTexture(UnitframeTexture)
			self.Castbar.SafeZone:SetPoint("RIGHT")
			self.Castbar.SafeZone:SetPoint("TOP")
			self.Castbar.SafeZone:SetPoint("BOTTOM")
			self.Castbar.SafeZone:SetVertexColor(0.69, 0.31, 0.31, 0.75)

			self.Castbar.Lag = self.Castbar:CreateFontString(nil, "OVERLAY")
			self.Castbar.Lag:SetPoint("TOPRIGHT", self.Castbar, "BOTTOMRIGHT", -3.5, -3)
			self.Castbar.Lag:SetFontObject(UnitframeFont)
			self.Castbar.Lag:SetFont(select(1, self.Castbar.Lag:GetFont()), 11, select(3, self.Castbar.Lag:GetFont()))
			self.Castbar.Lag:SetTextColor(0.84, 0.75, 0.65)
			self.Castbar.Lag:SetJustifyH("RIGHT")
			--self:RegisterEvent("GLOBAL_MOUSE_UP", Module.OnCastSent, true) -- Fix quests with WorldFrame interaction
			--self:RegisterEvent("GLOBAL_MOUSE_DOWN", Module.OnCastSent, true)
			self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED", Module.OnCastSent, true)
		end

		self.Castbar.decimal = "%.2f"

		self.Castbar.OnUpdate = Module.OnCastbarUpdate
		self.Castbar.PostCastStart = Module.PostCastStart
		self.Castbar.PostChannelStart = Module.PostCastStart
		self.Castbar.PostCastStop = Module.PostCastStop
		self.Castbar.PostChannelStop = Module.PostChannelStop
		self.Castbar.PostCastDelayed = Module.PostCastUpdate
		self.Castbar.PostChannelUpdate = Module.PostCastUpdate
		self.Castbar.PostCastFailed = Module.PostCastFailed
		self.Castbar.PostCastInterrupted = Module.PostCastFailed
		self.Castbar.PostCastInterruptible = Module.PostUpdateInterruptible
		self.Castbar.PostCastNotInterruptible = Module.PostUpdateInterruptible

		self.Castbar.Time = self.Castbar:CreateFontString(nil, "OVERLAY", UnitframeFont)
		self.Castbar.Time:SetPoint("RIGHT", -3.5, 0)
		self.Castbar.Time:SetTextColor(0.84, 0.75, 0.65)
		self.Castbar.Time:SetJustifyH("RIGHT")

		self.Castbar.Text = self.Castbar:CreateFontString(nil, "OVERLAY", UnitframeFont)
		self.Castbar.Text:SetPoint("LEFT", 3.5, 0)
		self.Castbar.Text:SetPoint("RIGHT", self.Castbar.Time, "LEFT", -3.5, 0)
		self.Castbar.Text:SetTextColor(0.84, 0.75, 0.65)
		self.Castbar.Text:SetJustifyH("LEFT")
		self.Castbar.Text:SetWordWrap(false)

		self.Castbar.Button = CreateFrame("Frame", nil, self.Castbar)
		self.Castbar.Button:SetSize(20, 20)
		self.Castbar.Button:CreateBorder()

		self.Castbar.Icon = self.Castbar.Button:CreateTexture(nil, "ARTWORK")
		self.Castbar.Icon:SetSize(self.Castbar:GetHeight(), self.Castbar:GetHeight())
		self.Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar, "BOTTOMLEFT", -6, 0)

		self.Castbar.Button:SetAllPoints(self.Castbar.Icon)

		local mover = K.Mover(self.Castbar, "Player Castbar", "PlayerCB", {"BOTTOM", UIParent, "BOTTOM", 14, 200})
		self.Castbar:ClearAllPoints()
		self.Castbar:SetPoint("RIGHT", mover)
		self.Castbar.mover = mover
	end

	if C["Unitframe"].ShowHealPrediction then
		local myBar = CreateFrame("StatusBar", nil, self)
		myBar:SetWidth(playerWidth)
		myBar:SetPoint("TOP", self.Health, "TOP")
		myBar:SetPoint("BOTTOM", self.Health, "BOTTOM")
		myBar:SetPoint("LEFT", self.Health:GetStatusBarTexture(), "RIGHT")
		myBar:SetStatusBarTexture(HealPredictionTexture)
		myBar:SetStatusBarColor(0, 1, 0, .5)
		myBar:Hide()

		local otherBar = CreateFrame("StatusBar", nil, self)
		otherBar:SetWidth(playerWidth)
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

	if C["Unitframe"].PlayerPowerPrediction then
		local mainBar = CreateFrame("StatusBar", self:GetName().."PowerPrediction", self.Power)
		mainBar:SetReverseFill(true)
		mainBar:SetPoint("TOP", 0, -1)
		mainBar:SetPoint("BOTTOM", 0, 1)
		mainBar:SetPoint("RIGHT", self.Power:GetStatusBarTexture(), "RIGHT", -1, 0)
		mainBar:SetStatusBarTexture(HealPredictionTexture)
		mainBar:SetStatusBarColor(0.8, 0.1, 0.1, 0.6)
		mainBar:SetWidth(playerWidth)

		self.PowerPrediction = {
				mainBar = mainBar
		}
	end

	if C["Unitframe"].ShowPlayerName then
		self.Name = self:CreateFontString(nil, "OVERLAY")
		self.Name:SetPoint("TOP", self.Health, 0, 16)
		self.Name:SetWidth(playerWidth)
		self.Name:SetFontObject(UnitframeFont)
		if C["Unitframe"].PortraitStyle.Value == "NoPortraits" then
			if C["Unitframe"].HealthbarColor.Value == "Class" then
				self:Tag(self.Name, "[name] [fulllevel][afkdnd]")
			else
				self:Tag(self.Name, "[color][name] [fulllevel][afkdnd]")
			end
		else
			if C["Unitframe"].HealthbarColor.Value == "Class" then
				self:Tag(self.Name, "[name][afkdnd]")
			else
				self:Tag(self.Name, "[color][name][afkdnd]")
			end
		end
	end

	-- Level
	if C["Unitframe"].ShowPlayerLevel then
		self.Level = self:CreateFontString(nil, "OVERLAY")
		if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" then
			self.Level:Show()
			self.Level:SetPoint("TOP", self.Portrait, 0, 15)
		else
			self.Level:Hide()
		end
		self.Level:SetFontObject(UnitframeFont)
		self:Tag(self.Level, "[fulllevel]")
	end

	self.LeaderIndicator = self.Overlay:CreateTexture(nil, "OVERLAY")
	self.LeaderIndicator:SetSize(14, 14)
	if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" then
		self.LeaderIndicator:SetPoint("TOPLEFT", self.Portrait, "TOPLEFT", 0, 8)
	else
		self.LeaderIndicator:SetPoint("TOPLEFT", self.Health, "TOPLEFT", -8, 8)
	end

	if C["Unitframe"].AdditionalPower then
		if K.Class ~= "DRUID" then
			return
		end

		self.AdditionalPower = CreateFrame("StatusBar", self:GetName().."AdditionalPower", self.Health)
		self.AdditionalPower:SetWidth(12)
		self.AdditionalPower:SetOrientation("VERTICAL")
		if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" then
			self.AdditionalPower:SetPoint("TOPLEFT", self.Portrait, -18, 0)
			self.AdditionalPower:SetPoint("BOTTOMLEFT", self.Portrait, -18, 0)
		else
			self.AdditionalPower:SetPoint("TOPLEFT", self, -18, 0)
			self.AdditionalPower:SetPoint("BOTTOMLEFT", self, -18, 0)
		end
		self.AdditionalPower:SetStatusBarTexture(K.GetTexture(C["UITextures"].UnitframeTextures))
		self.AdditionalPower:SetStatusBarColor(unpack(K.Colors.power.MANA))
		self.AdditionalPower:CreateBorder()
		self.AdditionalPower.frequentUpdates = true

		if C["Unitframe"].Smooth then
			K:SmoothBar(self.AdditionalPower)
		end

		-- self.AdditionalPower.Text = self.AdditionalPower:CreateFontString(nil, "OVERLAY")
		-- self.AdditionalPower.Text:SetFontObject(K.GetFont(C["UIFonts"].UnitframeFonts))
		-- self.AdditionalPower.Text:SetFont(select(1, self.AdditionalPower.Text:GetFont()), 9, select(3, self.AdditionalPower.Text:GetFont()))
		-- self.AdditionalPower.Text:SetPoint("LEFT", self.AdditionalPower, "LEFT", 1, 1)

		self.AdditionalPower.PostUpdate = Module.PostUpdateAddPower
	end

	-- GCD spark
	if C["Unitframe"].GlobalCooldown then
		-- self.GCD = CreateFrame("Frame", self:GetName().."_GlobalCooldown", self)
		-- self.GCD:SetWidth(playerWidth - portraitSize)
		-- self.GCD:SetHeight(self.Health:GetHeight())
		-- self.GCD:SetFrameStrata("HIGH")
		-- self.GCD:SetPoint("LEFT", self.Health, "LEFT", 0, 0)

		-- self.GCD.Color = {1, 1, 1}
		-- self.GCD.Height = 26
		-- self.GCD.Width = 128
	end

	-- if C["Unitframe"].EnergyTick then
	if K.Class ~= "WARRIOR" then
		self.EnergyManaRegen = CreateFrame("StatusBar", nil, self.Power)
		self.EnergyManaRegen:SetAlpha(0.6)
		self.EnergyManaRegen:SetFrameLevel(self.Power:GetFrameLevel())
		self.EnergyManaRegen:SetAllPoints()
		self.EnergyManaRegen.Spark = self.EnergyManaRegen:CreateTexture(nil, 'OVERLAY')
	end
	-- end

	if C["Unitframe"].CombatText then
		if IsAddOnLoaded("MikScrollingBattleText") or IsAddOnLoaded("Parrot") or IsAddOnLoaded("xCT") or IsAddOnLoaded("sct") then
			C["Unitframe"].CombatText = false
			return
		end

		local parentFrame = CreateFrame("Frame", nil, UIParent)
		self.FloatingCombatFeedback = CreateFrame("Frame", "oUF_Player_CombatTextFrame", parentFrame)
		self.FloatingCombatFeedback:SetSize(32, 32)
		K.Mover(self.FloatingCombatFeedback, "CombatText", "PlayerCombatText", {"BOTTOM", self, "TOPLEFT", 0, 120})

		for i = 1, 36 do
			self.FloatingCombatFeedback[i] = parentFrame:CreateFontString("$parentText", "OVERLAY")
		end

		self.FloatingCombatFeedback.font = C["Media"].Fonts.DamageFont

		self.FloatingCombatFeedback.fontFlags = "OUTLINE"
		self.FloatingCombatFeedback.showPets = C["Unitframe"].PetCombatText
		self.FloatingCombatFeedback.showHots = C["Unitframe"].HotsDots
		self.FloatingCombatFeedback.showAutoAttack = C["Unitframe"].AutoAttack
		self.FloatingCombatFeedback.showOverHealing = C["Unitframe"].FCTOverHealing
		self.FloatingCombatFeedback.abbreviateNumbers = true

		-- Turn off Blizzard's default combat text.
		SetCVar("enableFloatingCombatText", 0)
		SetCVar("floatingCombatTextCombatHealing", 0)
		SetCVar("floatingCombatTextCombatDamage", 0)
		SHOW_COMBAT_TEXT = "0"
		if (CombatText_UpdateDisplayedMessages) then
			CombatText_UpdateDisplayedMessages()
		end
		K.HideInterfaceOption(InterfaceOptionsCombatPanelEnableFloatingCombatText)
	end

	-- Swing timer
	if C["Unitframe"].Swingbar then
		local bar = CreateFrame("Frame", nil, self)
		local width = C["Unitframe"].PlayerCastbarWidth - C["Unitframe"].PlayerCastbarHeight - 5
		bar:SetSize(width, 13)
		if C["Unitframe"].PlayerCastbar then
			bar:SetPoint("TOP", self.Castbar.mover, "BOTTOM", 0, -6)
		else
			bar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 200)
		end

		local two = CreateFrame("StatusBar", nil, bar)
		two:Hide()
		two:SetAllPoints()
		two:SetStatusBarTexture(UnitframeTexture)
		two:SetStatusBarColor(0.31, 0.45, 0.63)
		two:CreateBorder()

		local twospark = two:CreateTexture(nil, "OVERLAY")
		twospark:SetTexture(C["Media"].Textures.Spark16Texture)
		twospark:SetHeight(C["DataBars"].Height)
		twospark:SetBlendMode("ADD")
		twospark:SetPoint("CENTER", two:GetStatusBarTexture(), "RIGHT", 0, 0)

		local bg = two:CreateTexture(nil, "BACKGROUND", nil, 1)
		bg:Hide()
		bg:SetPoint("TOPRIGHT")
		bg:SetPoint("BOTTOMRIGHT")
		bg:SetColorTexture(0.2, 0.2, 0.2, 0.6)

		local main = CreateFrame("StatusBar", nil, bar)
		main:Hide()
		main:SetAllPoints()
		main:SetStatusBarTexture(UnitframeTexture)
		main:SetStatusBarColor(0.31, 0.45, 0.63)
		main:CreateBorder()

		local mainspark = main:CreateTexture(nil, "OVERLAY")
		mainspark:SetTexture(C["Media"].Textures.Spark16Texture)
		mainspark:SetHeight(C["DataBars"].Height)
		mainspark:SetBlendMode("ADD")
		mainspark:SetPoint("CENTER", main:GetStatusBarTexture(), "RIGHT", 0, 0)

		local off = CreateFrame("StatusBar", nil, bar)
		off:Hide()
		off:SetPoint("TOPLEFT", bar, "BOTTOMLEFT", 0, -3)
		off:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, -6)
		off:SetStatusBarTexture(UnitframeTexture)
		off:SetStatusBarColor(0.78, 0.25, 0.25)
		off:CreateBorder()

		local offspark = off:CreateTexture(nil, "OVERLAY")
		offspark:SetTexture(C["Media"].Textures.Spark16Texture)
		offspark:SetHeight(C["DataBars"].Height)
		offspark:SetBlendMode("ADD")
		offspark:SetPoint("CENTER", off:GetStatusBarTexture(), "RIGHT", 0, 0)

		if C["Unitframe"].SwingbarTimer then
			bar.Text = K.CreateFontString(bar, 12, "", "")
			bar.TextMH = K.CreateFontString(main, 12, "", "")
			bar.TextOH = K.CreateFontString(off, 12, "", "", false, "CENTER", 1, -5)
		end

		self.Swing = bar
		self.Swing.Twohand = two
		self.Swing.Mainhand = main
		self.Swing.Offhand = off
		self.Swing.bg = bg
		self.Swing.hideOoc = true

		-- K.Mover(self.Swing, "PlayerSwingBar", "PlayerSwingBar", {"BOTTOM", UIParent, "BOTTOM", 0, 180})
	end

	if C["Unitframe"].PvPIndicator then
		self.PvPIndicator = self:CreateTexture(nil, "OVERLAY")
		self.PvPIndicator:SetSize(30, 33)
		if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" then
			self.PvPIndicator:SetPoint("RIGHT", self.Portrait, "LEFT", -2, 0)
		else
			self.PvPIndicator:SetPoint("RIGHT", self.Health, "LEFT", -2, 0)
		end
		self.PvPIndicator.PostUpdate = Module.PostUpdatePvPIndicator
	end

	self.CombatIndicator = self.Health:CreateTexture(nil, "OVERLAY")
	self.CombatIndicator:SetSize(20, 20)
	self.CombatIndicator:SetPoint("LEFT", 2, 0)

	self.RaidTargetIndicator = self.Overlay:CreateTexture(nil, "OVERLAY")
	if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" then
		self.RaidTargetIndicator:SetPoint("TOP", self.Portrait, "TOP", 0, 8)
	else
		self.RaidTargetIndicator:SetPoint("TOP", self.Health, "TOP", 0, 8)
	end
	self.RaidTargetIndicator:SetSize(16, 16)

	self.ReadyCheckIndicator = self.Overlay:CreateTexture(nil, "OVERLAY")
	if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" then
		self.ReadyCheckIndicator:SetPoint("CENTER", self.Portrait)
	else
		self.ReadyCheckIndicator:SetPoint("CENTER", self.Health)
	end
	self.ReadyCheckIndicator:SetSize(C["Unitframe"].PlayerFrameHeight - 4, C["Unitframe"].PlayerFrameHeight - 4)

	self.ResurrectIndicator = self.Overlay:CreateTexture(nil, "OVERLAY")
	self.ResurrectIndicator:SetSize(44, 44)
	if C["Unitframe"].PortraitStyle.Value ~= "NoPortraits" then
		self.ResurrectIndicator:SetPoint("CENTER", self.Portrait)
	else
		self.ResurrectIndicator:SetPoint("CENTER", self.Health)
	end

	self.RestingIndicator = self.Health:CreateTexture(nil, "OVERLAY")
	self.RestingIndicator:SetPoint("RIGHT", -2, 2)
	self.RestingIndicator:SetSize(22, 22)

	if C["Unitframe"].DebuffHighlight then
		self.DebuffHighlight = self.Health:CreateTexture(nil, "OVERLAY")
		self.DebuffHighlight:SetAllPoints(self.Health)
		self.DebuffHighlight:SetTexture(C["Media"].Textures.BlankTexture)
		self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
		self.DebuffHighlight:SetBlendMode("ADD")

		self.DebuffHighlightAlpha = 0.45
		self.DebuffHighlightFilter = true
	end

	if C["Unitframe"].GlobalCooldown then
		self.GlobalCooldown = CreateFrame("Frame", nil, self.Health)
		self.GlobalCooldown:SetWidth(playerWidth)
		self.GlobalCooldown:SetHeight(28)
		self.GlobalCooldown:SetFrameStrata("HIGH")
		self.GlobalCooldown:SetPoint("LEFT", self.Health, "LEFT", 0, 0)
	end

	self.CombatFade = C["Unitframe"].CombatFade

	self.Highlight = self.Health:CreateTexture(nil, "OVERLAY")
	self.Highlight:SetAllPoints()
	self.Highlight:SetTexture("Interface\\PETBATTLES\\PetBattle-SelectedPetGlow")
	self.Highlight:SetTexCoord(0, 1, .5, 1)
	self.Highlight:SetVertexColor(.6, .6, .6)
	self.Highlight:SetBlendMode("ADD")
	self.Highlight:Hide()

	self.ThreatIndicator = {
		IsObjectType = K.Noop,
		Override = Module.UpdateThreat,
	}
end