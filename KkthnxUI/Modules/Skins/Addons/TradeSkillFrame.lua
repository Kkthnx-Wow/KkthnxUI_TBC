local K, C = unpack(select(2, ...))
local S = K:GetModule("Skins")

local _G = _G

local skinIndex = 0
function S:TradeSkill_OnEvent(addon)
	if addon == "Blizzard_CraftUI" then
		S:EnhancedCraft()
		skinIndex = skinIndex + 1
	elseif addon == "Blizzard_TradeSkillUI" then
		S:EnhancedTradeSkill()
		skinIndex = skinIndex + 1
	end

	if skinIndex >= 2 then
		K:UnregisterEvent("ADDON_LOADED", S.TradeSkill_OnEvent)
	end
end

function S:CreateTradeSkillSkin()
	if IsAddOnLoaded("Leatrix_Plus") then
        return
    end

    if not C["Skins"].EnhancedTradeSkill then
        return
    end

	K:RegisterEvent("ADDON_LOADED", S.TradeSkill_OnEvent)
end

-- LeatrixPlus
function S:EnhancedTradeSkill()
	-- Make the tradeskill frame double-wide
    UIPanelWindows["TradeSkillFrame"] = {area = "override", pushable = 1, xoffset = -16, yoffset = 12, bottomClampOverride = 140 + 12, width = 714, height = 487, whileDead = 1}

    -- Size the tradeskill frame
    _G["TradeSkillFrame"]:SetWidth(714)
    _G["TradeSkillFrame"]:SetHeight(487)

    -- Adjust title text
    _G["TradeSkillFrameTitleText"]:ClearAllPoints()
    _G["TradeSkillFrameTitleText"]:SetPoint("TOP", _G["TradeSkillFrame"], "TOP", 0, -18)

    -- Expand the tradeskill list to full height
    _G["TradeSkillListScrollFrame"]:ClearAllPoints()
    _G["TradeSkillListScrollFrame"]:SetPoint("TOPLEFT", _G["TradeSkillFrame"], "TOPLEFT", 25, -75)
    _G["TradeSkillListScrollFrame"]:SetSize(295, 336)

    -- Create additional list rows
    local oldTradeSkillsDisplayed = TRADE_SKILLS_DISPLAYED

    -- Position existing buttons
    for i = 1 + 1, TRADE_SKILLS_DISPLAYED do
        _G["TradeSkillSkill" .. i]:ClearAllPoints()
        _G["TradeSkillSkill" .. i]:SetPoint("TOPLEFT", _G["TradeSkillSkill" .. (i-1)], "BOTTOMLEFT", 0, 1)
    end

    -- Create and position new buttons
    _G.TRADE_SKILLS_DISPLAYED = _G.TRADE_SKILLS_DISPLAYED + 14
    for i = oldTradeSkillsDisplayed + 1, TRADE_SKILLS_DISPLAYED do
        local button = CreateFrame("Button", "TradeSkillSkill" .. i, TradeSkillFrame, "TradeSkillSkillButtonTemplate")
        button:SetID(i)
        button:Hide()
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", _G["TradeSkillSkill" .. (i-1)], "BOTTOMLEFT", 0, 1)
    end

    -- Set highlight bar width when shown
    hooksecurefunc(_G["TradeSkillHighlightFrame"], "Show", function()
        _G["TradeSkillHighlightFrame"]:SetWidth(290)
    end)

    -- Move the tradeskill detail frame to the right and stretch it to full height
    _G["TradeSkillDetailScrollFrame"]:ClearAllPoints()
    _G["TradeSkillDetailScrollFrame"]:SetPoint("TOPLEFT", _G["TradeSkillFrame"], "TOPLEFT", 352, -74)
    _G["TradeSkillDetailScrollFrame"]:SetSize(298, 336)
    -- _G["TradeSkillReagent1"]:SetHeight(500) -- Debug

    -- Hide detail scroll frame textures
    _G["TradeSkillDetailScrollFrameTop"]:SetAlpha(0)
    _G["TradeSkillDetailScrollFrameBottom"]:SetAlpha(0)

    -- Create texture for skills list
    local RecipeInset = _G["TradeSkillFrame"]:CreateTexture(nil, "ARTWORK")
    RecipeInset:SetSize(304, 361)
    RecipeInset:SetPoint("TOPLEFT", _G["TradeSkillFrame"], "TOPLEFT", 16, -72)
    RecipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")

    -- Set detail frame backdrop
    local DetailsInset = _G["TradeSkillFrame"]:CreateTexture(nil, "ARTWORK")
    DetailsInset:SetSize(302, 339)
    DetailsInset:SetPoint("TOPLEFT", _G["TradeSkillFrame"], "TOPLEFT", 348, -72)
    DetailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")

    -- Hide expand tab (left of All button)
    _G["TradeSkillExpandTabLeft"]:Hide()

    -- Get tradeskill frame textures
    local regions = {_G["TradeSkillFrame"]:GetRegions()}

    -- Set top left texture
    regions[2]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
    regions[2]:SetSize(512, 512)

    -- Set top right texture
    regions[3]:ClearAllPoints()
    regions[3]:SetPoint("TOPLEFT", regions[2], "TOPRIGHT", 0, 0)
    regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
    regions[3]:SetSize(256, 512)

    -- Hide bottom left and bottom right textures
    regions[4]:Hide()
    regions[5]:Hide()

    -- Hide skills list dividing bar
    regions[9]:Hide()
    regions[10]:Hide()

    -- Move create button row
    _G["TradeSkillCreateButton"]:ClearAllPoints()
    _G["TradeSkillCreateButton"]:SetPoint("RIGHT", _G["TradeSkillCancelButton"], "LEFT", -1, 0)

    -- Position and size close button
    _G["TradeSkillCancelButton"]:SetSize(80, 22)
    _G["TradeSkillCancelButton"]:SetText(CLOSE)
    _G["TradeSkillCancelButton"]:ClearAllPoints()
    _G["TradeSkillCancelButton"]:SetPoint("BOTTOMRIGHT", _G["TradeSkillFrame"], "BOTTOMRIGHT", -42, 54)

    -- Position close box
    _G["TradeSkillFrameCloseButton"]:ClearAllPoints()
    _G["TradeSkillFrameCloseButton"]:SetPoint("TOPRIGHT", _G["TradeSkillFrame"], "TOPRIGHT", -30, -8)

    -- Position dropdown menus
    TradeSkillInvSlotDropDown:ClearAllPoints()
    TradeSkillInvSlotDropDown:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 510, -40)
    TradeSkillSubClassDropDown:ClearAllPoints()
    TradeSkillSubClassDropDown:SetPoint("RIGHT", TradeSkillInvSlotDropDown, "LEFT", 0, 0)
end

function S:EnhancedCraft()
	-- Make the craft frame double-wide
    UIPanelWindows["CraftFrame"] = {area = "override", pushable = 1, xoffset = -16, yoffset = 12, bottomClampOverride = 140 + 12, width = 714, height = 487, whileDead = 1}

    -- Size the craft frame
    _G["CraftFrame"]:SetWidth(714)
    _G["CraftFrame"]:SetHeight(487)

    -- Adjust title text
    _G["CraftFrameTitleText"]:ClearAllPoints()
    _G["CraftFrameTitleText"]:SetPoint("TOP", _G["CraftFrame"], "TOP", 0, -18)

    -- Expand the crafting list to full height
    _G["CraftListScrollFrame"]:ClearAllPoints()
    _G["CraftListScrollFrame"]:SetPoint("TOPLEFT", _G["CraftFrame"], "TOPLEFT", 25, -75)
    _G["CraftListScrollFrame"]:SetSize(295, 336)

    -- Create additional list rows
    local oldCraftsDisplayed = CRAFTS_DISPLAYED

    -- Position existing buttons
    _G["Craft1Cost"]:ClearAllPoints()
    _G["Craft1Cost"]:SetPoint("RIGHT", _G["Craft1"], "RIGHT", -30, 0)
    for i = 1 + 1, CRAFTS_DISPLAYED do
        _G["Craft" .. i]:ClearAllPoints()
        _G["Craft" .. i]:SetPoint("TOPLEFT", _G["Craft" .. (i-1)], "BOTTOMLEFT", 0, 1)
        _G["Craft" .. i .. "Cost"]:ClearAllPoints()
        _G["Craft" .. i .. "Cost"]:SetPoint("RIGHT", _G["Craft" .. i], "RIGHT", -30, 0)
    end

    -- Create and position new buttons
    _G.CRAFTS_DISPLAYED = _G.CRAFTS_DISPLAYED + 14
    for i = oldCraftsDisplayed + 1, CRAFTS_DISPLAYED do
        local button = CreateFrame("Button", "Craft" .. i, CraftFrame, "CraftButtonTemplate")
        button:SetID(i)
        button:Hide()
        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", _G["Craft" .. (i-1)], "BOTTOMLEFT", 0, 1)
        _G["Craft" .. i .. "Cost"]:ClearAllPoints()
        _G["Craft" .. i .. "Cost"]:SetPoint("RIGHT", _G["Craft" .. i], "RIGHT", -30, 0)
    end

    -- Move craft frame points (such as Beast Training)
    CraftFramePointsLabel:ClearAllPoints()
    CraftFramePointsLabel:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 100, -50)
    CraftFramePointsText:ClearAllPoints()
    CraftFramePointsText:SetPoint("LEFT", CraftFramePointsLabel, "RIGHT", 3, 0)

    -- Set highlight bar width when shown
    hooksecurefunc(_G["CraftHighlightFrame"], "Show", function()
        _G["CraftHighlightFrame"]:SetWidth(290)
    end)

    -- Move the craft detail frame to the right and stretch it to full height
    _G["CraftDetailScrollFrame"]:ClearAllPoints()
    _G["CraftDetailScrollFrame"]:SetPoint("TOPLEFT", _G["CraftFrame"], "TOPLEFT", 352, -74)
    _G["CraftDetailScrollFrame"]:SetSize(298, 336)
    -- _G["CraftReagent1"]:SetHeight(500) -- Debug

    -- Hide detail scroll frame textures
    _G["CraftDetailScrollFrameTop"]:SetAlpha(0)
    _G["CraftDetailScrollFrameBottom"]:SetAlpha(0)

    -- Create texture for skills list
    local RecipeInset = _G["CraftFrame"]:CreateTexture(nil, "ARTWORK")
    RecipeInset:SetSize(304, 361)
    RecipeInset:SetPoint("TOPLEFT", _G["CraftFrame"], "TOPLEFT", 16, -72)
    RecipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")

    -- Set detail frame backdrop
    local DetailsInset = _G["CraftFrame"]:CreateTexture(nil, "ARTWORK")
    DetailsInset:SetSize(302, 339)
    DetailsInset:SetPoint("TOPLEFT", _G["CraftFrame"], "TOPLEFT", 348, -72)
    DetailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")

    -- Hide expand tab (left of All button)
    _G["CraftExpandTabLeft"]:Hide()

    -- Get craft frame textures
    local regions = {_G["CraftFrame"]:GetRegions()}

    -- Set top left texture
    regions[2]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Left")
    regions[2]:SetSize(512, 512)

    -- Set top right texture
    regions[3]:ClearAllPoints()
    regions[3]:SetPoint("TOPLEFT", regions[2], "TOPRIGHT", 0, 0)
    regions[3]:SetTexture("Interface\\QUESTFRAME\\UI-QuestLogDualPane-Right")
    regions[3]:SetSize(256, 512)

    -- Hide bottom left and bottom right textures
    regions[4]:Hide()
    regions[5]:Hide()

    -- Hide skills list dividing bar
    regions[9]:Hide()
    regions[10]:Hide()

    -- Move create button row
    _G["CraftCreateButton"]:ClearAllPoints()
    _G["CraftCreateButton"]:SetPoint("RIGHT", _G["CraftCancelButton"], "LEFT", -1, 0)

    -- Position and size close button
    _G["CraftCancelButton"]:SetSize(80, 22)
    _G["CraftCancelButton"]:SetText(CLOSE)
    _G["CraftCancelButton"]:ClearAllPoints()
    _G["CraftCancelButton"]:SetPoint("BOTTOMRIGHT", _G["CraftFrame"], "BOTTOMRIGHT", -42, 54)

    -- Position close box
    _G["CraftFrameCloseButton"]:ClearAllPoints()
    _G["CraftFrameCloseButton"]:SetPoint("TOPRIGHT", _G["CraftFrame"], "TOPRIGHT", -30, -8)
end