local K, C = unpack(select(2, ...))

local _G = _G

local hooksecurefunc = _G.hooksecurefunc

tinsert(C.defaultThemes, function()
	for _, slot in pairs({PaperDollItemsFrame:GetChildren()}) do
		if slot:IsObjectType('Button') then
			local icon = _G[slot:GetName()..'IconTexture']

			slot:StripTextures()
			slot:CreateBorder()
			slot:StyleButton(slot)
			icon:SetTexCoord(unpack(K.TexCoords))
		end
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function(slot)
		local highlight = slot:GetHighlightTexture()
		highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
		highlight:SetBlendMode("ADD")
		highlight:SetAllPoints()
	end)

	for i = 1, 5 do
		local bu = _G["MagicResFrame"..i]
		bu:SetSize(24, 24)
		--bu:CreateBorder()
		local icon = bu:GetRegions()
		local a, b, _, _, _, _, c, d = icon:GetTexCoord()
		icon:SetTexCoord(a+.2, c-.2, b+.018, d-.018)
	end
end)