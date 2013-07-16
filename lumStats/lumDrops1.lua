-- ------------------------------------------------------------------------
-- > lumDrops (Kreoss @ Quel'Thalas EU) <
-- ------------------------------------------------------------------------
-- Credits: zork, Lyn.
-- ------------------------------------------------------------------------

-- ------------------------------------------------------------------------
-- > 0. Configuration and Media
-- ------------------------------------------------------------------------

	-- Media
	local background = "Interface\\AddOns\\sharedmedia\\background\\blanktex"
	local border = "Interface\\AddOns\\sharedmedia\\border\\squareline"
	local shadow = "Interface\\AddOns\\lumMedia\\Textures\\texture_glow"

-- ------------------------------------------------------------------------
-- > 1. Variables
-- ------------------------------------------------------------------------

	local cbColor = RAID_CLASS_COLORS[select(2, UnitClass("player"))] -- Class Colored Borders
	local bgColor = {r = 0.078, g = 0.078, b = 0.078, a = 1} -- Frame Background Color
	local dbColor = {r = 0, g = 0, b = 0, a = 1} -- Default border color if not Class Colored
	local Drops = {}
	
-- ------------------------------------------------------------------------
-- > 2. Functions
-- ------------------------------------------------------------------------

	-- !ClassColors addon
	if(IsAddOnLoaded('!ClassColors') and CUSTOM_CLASS_COLORS) then
		cbColor = CUSTOM_CLASS_COLORS[select(2, UnitClass("player"))]
	end

	-- Create Panel
	function Drops:CreatePanel(classColored, hasShadow, fname, fparent, fstrata, fwidth, fheight, fcolor, fpoints, ftexture, fborder, ftilesize, fedgesize, finsect, shadowalpha)
		local f = CreateFrame("Frame","Drop_"..fname,UIParent)
		if classColored then bColor = cbColor else bColor = dbColor end
		f:SetParent(fparent)
		f:SetFrameStrata(fstrata)
		f:SetFrameLevel(1)
		f:SetWidth(fwidth)
		f:SetHeight(fheight)
		f:SetBackdrop({bgFile = ftexture, edgeFile = fborder, tile = false, tileSize = ftilesize, edgeSize = fedgesize, insets = {left = finsect, right = finsect, top = finsect, bottom = finsect}})
		f:SetBackdropColor(fcolor.r, fcolor.g, fcolor.b, fcolor.a)
		f:SetBackdropBorderColor(bColor.r, bColor.g, bColor.b, bColor.a)
		for i,v in pairs(fpoints) do
			f:SetPoint(unpack(v))
		end
		
		if hasShadow then
			local s = CreateFrame("Frame",nil, f)
			s:SetFrameStrata(fstrata)
			s:SetFrameLevel(0)
			s:SetPoint("TOPLEFT",f,"TOPLEFT", -4, 4)
			s:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT", 4, -4)
			s:SetBackdrop({bgFile = ftexture, edgeFile = shadow, tile = false, tileSize = 32, edgeSize = 5, insets = {left = -5, right = -5, top = -5, bottom = -5}})
			s:SetBackdropColor(fcolor.r, fcolor.g, fcolor.b, 0)
			s:SetBackdropBorderColor(0, 0, 0, shadowalpha)
		end
	end

-- ------------------------------------------------------------------------
-- > 3. Calls
-- ------------------------------------------------------------------------

	Drops:CreatePanel(false, true, "BottomPanel", "UIParent", "BACKGROUND", 276, 19, bgColor, {{"BOTTOM", UIParent, "BOTTOM", 0.5, -6}}, background, border, 1, 6, 1, 1) -- Bottom Panel
	--Drops:CreatePanel(false, false, "MinimapPanel", "Minimap", "BACKGROUND", Minimap:GetWidth()+8, Minimap:GetHeight()+8, bgColor, {{"TOPLEFT", Minimap, "TOPLEFT", -4,4}}, background, border, 32, 12, 0, 0.6) -- Minimap Panel