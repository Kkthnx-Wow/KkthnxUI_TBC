local K, C = unpack(select(2, ...))
local Module = K:NewModule("WorldMap")

local _G = _G

local C_Map_GetBestMapForUnit = _G.C_Map.GetBestMapForUnit
local CreateFrame = _G.CreateFrame
local IsPlayerMoving = _G.IsPlayerMoving
local PLAYER = _G.PLAYER
local UIParent = _G.UIParent
local hooksecurefunc = _G.hooksecurefunc

local currentMapID, playerCoords, cursorCoords
local smallerMapScale = 0.8
local updateThrottle = 1 / 20

function Module:SetLargeWorldMap()
	local WorldMapFrame = _G.WorldMapFrame
	WorldMapFrame:SetParent(UIParent)
	WorldMapFrame:SetScale(1)
	WorldMapFrame:OnFrameSizeChanged()
	WorldMapFrame.ScrollContainer.Child:SetScale(smallerMapScale)
end

function Module:SetSmallWorldMap(smallerScale)
	local WorldMapFrame = _G.WorldMapFrame
	WorldMapFrame:SetParent(UIParent)
	WorldMapFrame:SetScale(smallerScale)
	WorldMapFrame:EnableKeyboard(false)
	WorldMapFrame:EnableMouse(false)
	WorldMapFrame:SetFrameStrata('HIGH')

	_G.WorldMapTooltip:SetFrameLevel(WorldMapFrame.ScrollContainer:GetFrameLevel() + 110)
end

function Module:GetCursorCoords()
	if not WorldMapFrame.ScrollContainer:IsMouseOver() then
		return
	end

	local cursorX, cursorY = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
	if cursorX < 0 or cursorX > 1 or cursorY < 0 or cursorY > 1 then
		return
	end

	return cursorX, cursorY
end

local function CoordsFormat(owner, none)
	local text = none and ": --, --" or ": %.1f, %.1f"
	return owner..K.MyClassColor..text
end

function Module:UpdateCoords(elapsed)
	-- Throttle the updates, to increase the performance.
	self.elapsed = (self.elapsed or 0) + elapsed

	if self.elapsed < updateThrottle then
		return
	end

	local cursorX, cursorY = Module:GetCursorCoords()
	if cursorX and cursorY then
		cursorCoords:SetFormattedText(CoordsFormat("Mouse"), 100 * cursorX, 100 * cursorY)
	else
		cursorCoords:SetText(CoordsFormat("Mouse", true))
	end

	if not currentMapID then
		playerCoords:SetText(CoordsFormat(PLAYER, true))
	else
		local x, y = K.GetPlayerMapPos(currentMapID)
		if not x or (x == 0 and y == 0) then
			playerCoords:SetText(CoordsFormat(PLAYER, true))
		else
			playerCoords:SetFormattedText(CoordsFormat(PLAYER), 100 * x, 100 * y)
		end
	end

	self.elapsed = 0
end

function Module:UpdateMapID()
	if self:GetMapID() == C_Map_GetBestMapForUnit("player") then
		currentMapID = self:GetMapID()
	else
		currentMapID = nil
	end
end

function Module:ToggleMapFix(event)
	local WorldMapFrame = _G.WorldMapFrame
	ShowUIPanel(WorldMapFrame)
	WorldMapFrame:SetAttribute('UIPanelLayout-area', 'center')
	WorldMapFrame:SetAttribute('UIPanelLayout-allowOtherPanels', true)
	HideUIPanel(WorldMapFrame)

	if event then
		print(event)
		K:UnregisterEvent(event, Module.ToggleMapFix)
	end
end

function Module:MapShouldFade()
	-- normally we would check GetCVarBool('mapFade') here instead of the setting
	return C["WorldMap"].FadeWhenMoving and not _G.WorldMapFrame:IsMouseOver()
end

function Module:MapFadeOnUpdate(elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < updateThrottle then
		return
	end

	local object = self.FadeObject
	local settings = object and object.FadeSettings
	if not settings then
		return
	end

	local fadeOut = IsPlayerMoving() and (not settings.fadePredicate or settings.fadePredicate())
	local endAlpha = (fadeOut and (settings.minAlpha or 0.5)) or settings.maxAlpha or 1
	local startAlpha = _G.WorldMapFrame:GetAlpha()

	object.timeToFade = settings.durationSec or 0.5
	object.startAlpha = startAlpha
	object.endAlpha = endAlpha
	object.diffAlpha = endAlpha - startAlpha

	if object.fadeTimer then
		object.fadeTimer = nil
	end

	UIFrameFade(_G.WorldMapFrame, object)

	self.elapsed = 0
end

local fadeFrame
function Module:StopMapFromFading()
	if fadeFrame then
		fadeFrame:Hide()
	end
end

function Module:EnableMapFading(frame)
	if not fadeFrame then
		fadeFrame = CreateFrame("Frame")
		fadeFrame:SetScript("OnUpdate", Module.MapFadeOnUpdate)
		frame:HookScript("OnHide", Module.StopMapFromFading)
	end

	if not fadeFrame.FadeObject then
		fadeFrame.FadeObject = {}
	end

	if not fadeFrame.FadeObject.FadeSettings then
		fadeFrame.FadeObject.FadeSettings = {}
	end

	local settings = fadeFrame.FadeObject.FadeSettings
	settings.fadePredicate = Module.MapShouldFade
	settings.durationSec = 0.2
	settings.minAlpha = C["WorldMap"].AlphaWhenMoving
	settings.maxAlpha = 1

	fadeFrame:Show()
end

function Module:OnEnable()
	if C["WorldMap"].Coordinates then
		local coordsFrame = CreateFrame("FRAME", nil, WorldMapFrame.ScrollContainer)
		coordsFrame:SetSize(WorldMapFrame:GetWidth(), 17)
		coordsFrame:SetPoint("BOTTOMLEFT", 17)
		coordsFrame:SetPoint("BOTTOMRIGHT", 0)

		coordsFrame.Texture = coordsFrame:CreateTexture(nil, "BACKGROUND")
		coordsFrame.Texture:SetAllPoints()
		coordsFrame.Texture:SetTexture(C["Media"].Textures.BlankTexture)
		coordsFrame.Texture:SetVertexColor(0.04, 0.04, 0.04, 0.5)

		-- Create cursor coordinates frame
		cursorCoords = WorldMapFrame.ScrollContainer:CreateFontString(nil, "OVERLAY")
		cursorCoords:FontTemplate(nil, 13, "OUTLINE")
		cursorCoords:SetSize(200, 16)
		cursorCoords:SetParent(coordsFrame)
		cursorCoords:ClearAllPoints()
		cursorCoords:SetPoint("BOTTOMLEFT", 152, 1)
		cursorCoords:SetTextColor(255/255, 204/255, 102/255)

		-- Create player coordinates frame
		playerCoords = WorldMapFrame.ScrollContainer:CreateFontString(nil, "OVERLAY")
		playerCoords:FontTemplate(nil, 13, "OUTLINE")
		playerCoords:SetSize(200, 16)
		playerCoords:SetParent(coordsFrame)
		playerCoords:ClearAllPoints()
		playerCoords:SetPoint("BOTTOMRIGHT", -132, 1)
		playerCoords:SetTextColor(255/255, 204/255, 102/255)

		hooksecurefunc(WorldMapFrame, "OnFrameSizeChanged", self.UpdateMapID)
		hooksecurefunc(WorldMapFrame, "OnMapChanged", self.UpdateMapID)

		local CoordsUpdater = CreateFrame("Frame", nil, WorldMapFrame.ScrollContainer)
		CoordsUpdater:SetScript("OnUpdate", self.UpdateCoords)
	end

	if C["WorldMap"].SmallWorldMap then
		smallerMapScale = C["WorldMap"].SmallWorldMapScale or 0.8

		WorldMapFrame.BlackoutFrame.Blackout:SetTexture(nil)
		WorldMapFrame.BlackoutFrame:EnableMouse(false)

		if InCombatLockdown() then
			K:RegisterEvent("PLAYER_REGEN_ENABLED", Module.ToggleMapFix)
		else
			Module:ToggleMapFix()
		end

		WorldMapFrame:HookScript("OnShow", function()
			Module:EnableMapFading(WorldMapFrame)
			Module:SetSmallWorldMap(smallerMapScale)
		end)
	else
		Module:SetLargeWorldMap()
	end

	_G.WorldMapMagnifyingGlassButton:SetPoint('TOPLEFT', 60, -120)

	WorldMapFrame.ScrollContainer.GetCursorPosition = function(self)
		local X, Y = MapCanvasScrollControllerMixin.GetCursorPosition(self)
		local Scale = WorldMapFrame:GetScale()

		return X / Scale, Y / Scale
	 end

	self:CreateWorldMapReveal()
	self:CreateWowHeadLinks()
end