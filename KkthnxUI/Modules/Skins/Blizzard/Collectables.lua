local K, C = unpack(select(2, ...))

local _G = _G

C.themes["Blizzard_Collections"] = function()
	local WardrobeFrame = _G["WardrobeFrame"]
    local WardrobeTransmogFrame = _G["WardrobeTransmogFrame"]
    local initialParentFrameWidth = WardrobeFrame:GetWidth() -- Expecting 965
    local desiredParentFrameWidth = 1092
    local parentFrameWidthIncrease = desiredParentFrameWidth - initialParentFrameWidth
	local weaponSlotOffset = 25

    WardrobeFrame:SetWidth(desiredParentFrameWidth)

    local initialTransmogFrameWidth = WardrobeTransmogFrame:GetWidth()
    local desiredTransmogFrameWidth = initialTransmogFrameWidth + parentFrameWidthIncrease
    WardrobeTransmogFrame:SetWidth(desiredTransmogFrameWidth)

	-- Insert better BG
	WardrobeTransmogFrame.Inset.BG:SetTexture("Interface\\DressUpFrame\\DressingRoom"..K.Class)
	WardrobeTransmogFrame.Inset.BG:SetTexCoord(1 / 512, 479 / 512, 46 / 512, 455 / 512)
	WardrobeTransmogFrame.Inset.BG:SetHorizTile(false)
	WardrobeTransmogFrame.Inset.BG:SetVertTile(false)
	WardrobeTransmogFrame.Inset.BG:SetVertexColor(0.9, 0.9, 0.9, 0.9)

    -- These frames are built using absolute sizes instead of relative points for some reason. Let's stick with that..
    local insetWidth = K.Round(initialTransmogFrameWidth - WardrobeTransmogFrame.ModelScene:GetWidth(), 0)
    WardrobeTransmogFrame.Inset.BG:SetWidth(WardrobeTransmogFrame.Inset.Bg:GetWidth() - insetWidth)
    WardrobeTransmogFrame.ModelScene:SetWidth(WardrobeTransmogFrame:GetWidth() - insetWidth)

    -- Move HEADSLOT -- Other slots in the left column are attached relative to it
    WardrobeTransmogFrame.ModelScene.SlotButtons[1]:SetPoint("LEFT", WardrobeTransmogFrame.ModelScene, 6, 0)

    -- Move HANDSSLOT -- Other slots in the right column are attached relative to it
    WardrobeTransmogFrame.ModelScene.SlotButtons[8]:SetPoint("RIGHT", WardrobeTransmogFrame.ModelScene, -4, 0)

    -- Move MAINHANDSLOT
    local mainHandPoint, _, _, mainHandXOffset, mainHandYOffset = WardrobeTransmogFrame.ModelScene.SlotButtons[12]:GetPoint("BOTTOM")
    local mainHandEnchantPoint, _, _, mainHandEnchantXOffset, mainHandEnchantYOffset = WardrobeTransmogFrame.ModelScene.SlotButtons[14]:GetPoint()
    WardrobeTransmogFrame.ModelScene.SlotButtons[12]:SetPoint(mainHandPoint, mainHandXOffset, mainHandYOffset - weaponSlotOffset)
    WardrobeTransmogFrame.ModelScene.SlotButtons[14]:SetPoint(mainHandEnchantPoint, mainHandEnchantXOffset, mainHandEnchantYOffset - weaponSlotOffset)

    -- Move SECONDARYHANDSLOT
    local offHandPoint, _, _, offHandXOffset, offHandYOffset = WardrobeTransmogFrame.ModelScene.SlotButtons[13]:GetPoint("BOTTOM")
    local offHandEnchantPoint, _, _, offHandEnchantXOffset, offHandEnchantYOffset = WardrobeTransmogFrame.ModelScene.SlotButtons[15]:GetPoint()
    WardrobeTransmogFrame.ModelScene.SlotButtons[13]:SetPoint(offHandPoint, offHandXOffset, offHandYOffset - weaponSlotOffset)
    WardrobeTransmogFrame.ModelScene.SlotButtons[15]:SetPoint(offHandEnchantPoint, offHandEnchantXOffset, offHandEnchantYOffset - weaponSlotOffset)

    local modelScene = WardrobeTransmogFrame.ModelScene
	modelScene.ClearAllPendingButton:DisableDrawLayer("BACKGROUND")
    local slots = {"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "Back", "Shirt", "Tabard", "MainHand", "SecondaryHand", "MainHandEnchant", "SecondaryHandEnchant"}
	for i = 1, #slots do
		local slot = modelScene[slots[i].."Button"]
		if slot then
			slot.Border:Hide()
            slot:SetFrameLevel(slot:GetFrameLevel() + 4)
            slot.StatusBorder:Kill()

            slot.Icon:SetTexCoord(unpack(K.TexCoords))

	        slot.Icon.bg = CreateFrame("Frame", nil, slot)
	        slot.Icon.bg:SetAllPoints(slot.Icon)
	        slot.Icon.bg:SetFrameLevel(slot:GetFrameLevel())
	        slot.Icon.bg:CreateBorder()

            slot.Icon.bg.ismogged = CreateFrame("Frame", nil, slot)
		    slot.Icon.bg.ismogged:SetBackdrop({edgeFile = C["Media"].Borders.GlowBorder, edgeSize = 12})
		    slot.Icon.bg.ismogged:SetPoint("TOPLEFT", slot.Icon.bg, -5, 5)
		    slot.Icon.bg.ismogged:SetPoint("BOTTOMRIGHT", slot.Icon.bg, 5, -5)
            slot.Icon.bg.ismogged:SetBackdropBorderColor(255/255, 124/255, 189/255)
		    slot.Icon.bg.ismogged:SetAlpha(0)

            slot.SelectedTexture:SetSize(slot.Icon.bg.ismogged:GetSize(), slot.Icon.bg.ismogged:GetSize())
            slot.SelectedTexture:SetDrawLayer("OVERLAY", 7)
            slot.SelectedTexture:ClearAllPoints()
            slot.SelectedTexture:SetPoint("TOPLEFT", slot.Icon.bg.ismogged, -1, 1)
		    slot.SelectedTexture:SetPoint("BOTTOMRIGHT", slot.Icon.bg.ismogged, 1, -1)

            hooksecurefunc(slot.SelectedTexture, "Show", function()
                slot.Icon.bg.ismogged:SetAlpha(0)
            end)

            hooksecurefunc(slot.SelectedTexture, "Hide", function()
                slot.Icon.bg.ismogged:SetAlpha(1)
            end)

            hooksecurefunc(slot.StatusBorder, "Show", function()
                slot.Icon.bg.ismogged:SetAlpha(1)
            end)

            hooksecurefunc(slot.StatusBorder, "Hide", function()
                slot.Icon.bg.ismogged:SetAlpha(0)
            end)
		end
	end

	if C["General"].NoTutorialButtons then
		_G.PetJournalTutorialButton:Kill()
	end
end