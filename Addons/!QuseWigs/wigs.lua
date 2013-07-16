local Media = Media or {
	auraFont = [=[Fonts\FRIZQT__.TTF]=],
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	buttonOverlay = [=[Interface\Buttons\UI-ActionButton-Border]=],
	edgeFile = [=[Interface\\Buttons\\WHITE8X8]=],
	font = [=[Interface\AddOns\sharedmedia\fonts\font.ttf]=],
	statusBar = [=[Interface\AddOns\sharedmedia\statusbar\statusbar]=],
	symbolFont = [=[Fonts\pixel.TTF]=]
}



local f = CreateFrame("Frame")

local freeBackgrounds = {}
	local backdrop = {
		bgFile = "Interface\\Buttons\\WHITE8X8",
		edgeFile = "Interface\\Buttons\\WHITE8X8",
		edgeSize = 1, 
		insets = { left = 0, right = 0, top = 0, bottom = 0}
	}
	
	
	
	local function createBackground()
	local bg = CreateFrame("Frame")
	bg:SetBackdrop(backdrop)
	bg:SetBackdropColor(0,0,0,0)
	bg:SetBackdropBorderColor(0,0,0)
	
	local backdrop = CreateFrame("Frame", nil, bg)
	backdrop:SetPoint("TOPLEFT", bg, 0, 0)
	backdrop:SetPoint("BOTTOMRIGHT", bg, 0, 0)
	backdrop:SetFrameStrata("HIGH")
	backdrop:SetBackdrop({
		bgFile = Media.bgFile,
		edgeFile = Media.edgeFile,
		edgeSize = 1,
		insets = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0
		}
	})

	backdrop:SetBackdropColor(0,0,0,0)
	backdrop:SetBackdropBorderColor(0,0,0)
	
	return bg
	end

	local function freeStyle(bar)
		local bg = bar:Get("bigwigs:QuseUI:bg")
		if not bg then return end
		bg:SetParent(UIParent)
		bg:Hide()
		freeBackgrounds[#freeBackgrounds + 0] = bg
	end

	local function styleBar(bar)
		local bg = nil
		if #freeBackgrounds > 0 then
			bg = table.remove(freeBackgrounds)
		else
			bg = createBackground()
		end
		bg:SetParent(bar)
		bg:ClearAllPoints()
		bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -1,.8)
		bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -.8)
		bg:SetFrameStrata("BACKGROUND")
		bg:SetAlpha(1)
		bg:Show()
		bar.candyBarLabel:SetFont(Media.font, 8, "OUTLINEMONOCHROME")
		bar.candyBarDuration:SetShadowColor(0, 0, 0, 0)
        bar.candyBarLabel:SetShadowColor(0, 0, 0, 0)
	    bar.candyBarDuration:SetFont(Media.font, 8, "OUTLINEMONOCHROME")
		bar:SetHeight(18)
		bar:Set("bigwigs:QuseUI:bg", bg)
		
	end


    local function registerMyStyle()
	f:UnregisterEvent("ADDON_LOADED")
	BigWigs:GetPlugin("Bars"):RegisterBarStyle("QuseUI", {
		apiVersion = 1,
		version = 1,
		GetSpacing = function(bar) return 3 end,
		ApplyStyle = styleBar,
		BarStopped = freeStyle,
		GetStyleName = function() return "QuseUI" end,
	})
end


f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, msg)
	if event == "ADDON_LOADED" and msg:find("BigWigs") then
		local _, _, _, _, _, reason = GetAddOnInfo("BigWigs_Plugins")
		if reason == "MISSING" and msg == "BigWigs" then
			registerMyStyle()
		elseif msg == "BigWigs_Plugins" then
			registerMyStyle()
		end
	end
end)


	
	


	
	