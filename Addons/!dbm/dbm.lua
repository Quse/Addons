    hooksecurefunc('CreateFrame', function(...)
        local _, name, _, template = ...
        if(template == 'DBTBarTemplate') then
            local frame = _G[name]     
            local bar = _G[frame:GetName().."Bar"]
			local spark = _G[frame:GetName().."BarSpark"]
			local texture = _G[frame:GetName().."BarTexture"]
			local icon1 = _G[frame:GetName().."BarIcon1"]
			local icon2 = _G[frame:GetName().."BarIcon2"]
			local name = _G[frame:GetName().."BarName"]
			local timer = _G[frame:GetName().."BarTimer"]
			bar:SetHeight(18)
			bar:SetFrameLevel(1)
			
-- BAR STYLE			
			texture:SetTexture("Interface\\AddOns\\sharedmedia\\Statusbar\\statusbar")
			icon1:SetTexCoord(.1,.9,.1,.9) 
			icon1:ClearAllPoints()
			icon1:SetPoint("LEFT", bar, "LEFT", -21, 0)
			icon2:SetTexCoord(.1,.9,.1,.9) 
			name:SetPoint("CENTER") 
			name:SetPoint("LEFT", 4, 0) 
			name:SetFont("Interface\\AddOns\\sharedmedia\\fonts\\font.ttf", 8, "OUTLINEMONOCHROME")
			name:SetShadowColor(0, 0, 0, 0)
			timer:SetPoint("CENTER") 
			timer:SetPoint("RIGHT", -4, 0) 
			timer:SetFont("Interface\\AddOns\\sharedmedia\\fonts\\font.ttf", 8, "OUTLINEMONOCHROME") 
			timer:SetFont("Interface\\AddOns\\sharedmedia\\fonts\\font.ttf", 8, "OUTLINEMONOCHROME") 
			timer:SetShadowColor(0, 0, 0, 0)
			spark:SetAlpha(0)
			
			name.SetFont = function() end
			texture.SetTexture = function() end
			timer.SetFont = function() end
			spark.SetAlpha = function() end
			--bar.styled = true

-- BACKDROP AND BORDER					
			local bg = CreateFrame("Frame", nil, bar)
			bg:SetPoint("TOPRIGHT", frame, 0, 0)
			bg:SetPoint("BOTTOMLEFT", frame, -1, -0)
	 		bg:SetBackdrop({
				bgFile = "Interface\\Buttons\\WHITE8X8", 
				edgeFile = "Interface\\Buttons\\WHITE8X8",
				edgeSize = 1,
			})
			bg:SetBackdropBorderColor(0, 0, 0, 1)
			bg:SetBackdropColor(.078,.078,.078,0.5)
			bg:SetFrameLevel(0)	
			

-- LEFT ICON
			-- local ibg = CreateFrame("Frame", icon1)
			-- ibg:SetPoint("TOPRIGHT", icon1, 1, 1)
			-- ibg:SetPoint("BOTTOMLEFT", icon1, -1, -1)
			-- ibg:SetBackdrop({
				-- bgFile = "", 
				-- edgeFile = "Interface\\Buttons\\WHITE8X8",
				-- edgeSize = 1,
			-- })
			-- ibg:SetBackdropBorderColor(0, 0, 0)
			-- ibg:SetParent(bar)


-- RIGHT ICON
			-- local ibg = CreateFrame("Frame", icon2)
			-- ibg:SetPoint("TOPRIGHT", icon2, 1, 1)
			-- ibg:SetPoint("BOTTOMLEFT", icon2, -1, -1)
			-- ibg:SetBackdrop({
				-- bgFile = "", 
				-- edgeFile = "Interface\\Buttons\\WHITE8X8",
				-- edgeSize = 1,
			-- })
			-- ibg:SetBackdropBorderColor(0, 0, 0)
			-- ibg:SetParent(bar)
			
        end
    end)