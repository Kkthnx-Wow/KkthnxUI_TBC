local K, C = unpack(select(2, ...))

local _G = _G
local table_insert = _G.table.insert

table_insert(C.defaultThemes, function()
	for i = 1, 6 do
		select(i, GhostFrame:GetRegions()):Hide()
	end

	GhostFrameContentsFrameIcon:SetTexCoord(K.TexCoords[1], K.TexCoords[2], K.TexCoords[3], K.TexCoords[4])

	GhostFrameContentsFrameIcon.Icon = CreateFrame("Frame", nil, GhostFrameContentsFrameIcon:GetParent())
	GhostFrameContentsFrameIcon.Icon:SetAllPoints(GhostFrameContentsFrameIcon)
	GhostFrameContentsFrameIcon.Icon:SetFrameLevel(GhostFrame:GetFrameLevel() + 1)
	GhostFrameContentsFrameIcon.Icon:CreateBorder()

	GhostFrame:SkinButton()

	-- -- GameMenu
	-- GameMenuFrame.Header:StripTextures()
	-- GameMenuFrame.Header:ClearAllPoints()
	-- GameMenuFrame.Header:SetPoint("TOP", GameMenuFrame, 0, 7)
	-- GameMenuFrame:CreateBorder()
	-- GameMenuFrame.Border:Hide()

	-- local buttons = {
	-- 	GameMenuButtonHelp,
	-- 	GameMenuButtonWhatsNew,
	-- 	GameMenuButtonStore,
	-- 	GameMenuButtonOptions,
	-- 	GameMenuButtonUIOptions,
	-- 	GameMenuButtonKeybindings,
	-- 	GameMenuButtonMacros,
	-- 	GameMenuButtonAddons,
	-- 	GameMenuButtonLogout,
	-- 	GameMenuButtonQuit,
	-- 	GameMenuButtonContinue
	-- }

	-- for _, button in next, buttons do
	-- 	button:SkinButton()
	-- end
end)

local function reskinTableAttribute(frame)
	if frame.styled then return end

	frame:StripTextures(frame)
	frame:CreateBorder()
	frame.CloseButton:SkinCloseButton()
	frame.VisibilityButton:SkinCheckBox()
	frame.HighlightButton:SkinCheckBox()
	frame.DynamicUpdateButton:SkinCheckBox()
	frame.FilterBox:CreateBackdrop()
	frame.FilterBox.Backdrop:SetPoint("TOPLEFT", frame.FilterBox, "TOPLEFT", -3, -4)
	frame.FilterBox.Backdrop:SetPoint("BOTTOMRIGHT", frame.FilterBox, "BOTTOMRIGHT", -1, 4)

	-- B.ReskinArrow(frame.OpenParentButton, "up")
	-- B.ReskinArrow(frame.NavigateBackwardButton, "left")
	-- B.ReskinArrow(frame.NavigateForwardButton, "right")
	-- B.ReskinArrow(frame.DuplicateButton, "up")

	frame.NavigateBackwardButton:ClearAllPoints()
	frame.NavigateBackwardButton:SetPoint("LEFT", frame.OpenParentButton, "RIGHT")
	frame.NavigateForwardButton:ClearAllPoints()
	frame.NavigateForwardButton:SetPoint("LEFT", frame.NavigateBackwardButton, "RIGHT")
	frame.DuplicateButton:ClearAllPoints()
	frame.DuplicateButton:SetPoint("LEFT", frame.NavigateForwardButton, "RIGHT")

	frame.ScrollFrameArt:StripTextures()
	frame.ScrollFrameArt:CreateBorder()
	frame.LinesScrollFrame.ScrollBar:SkinScrollBar()

	frame.styled = true
end

C.themes["Blizzard_DebugTools"] = function()
	-- EventTraceFrame
	EventTraceFrame:StripTextures()
	EventTraceFrame:CreateBorder()

	EventTraceFrameCloseButton:SkinCloseButton()
	EventTraceFrameCloseButton:SetPoint("TOPRIGHT", EventTraceFrame, "TOPRIGHT", 1, 1)

	local bg, bu = EventTraceFrameScroll:GetRegions()
	bg:Hide()
	bu:SetAlpha(0)
	bu:SetWidth(16)

	bu.bg = CreateFrame("Frame", nil, EventTraceFrame)
	bu.bg:SetAllPoints(bu)
	bu.bg:SetFrameLevel(EventTraceFrame:GetFrameLevel())
	bu.bg:CreateBorder()

	-- Table Attribute Display
	-- reskinTableAttribute(TableAttributeDisplay)
	-- hooksecurefunc(TableInspectorMixin, "InspectTable", reskinTableAttribute)
end