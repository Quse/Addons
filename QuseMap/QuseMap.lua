-- ------------------------------------------------------------------------
-- QuseMap 
-- ------------------------------------------------------------------------
-- Based on Wanderlust(Ichik) and dRecMap(Dawn), instance difficulty by Haleth. 
-- ------------------------------------------------------------------------

--[[Begin Config]]
local mediaFolder = "Interface\\AddOns\\SharedMedia\\"	-- don't touch this ...

-- CHANGE FONTS HERE!!!!
local pixelFont = true   -- false for normal fonts

if pixelFont == true then
	font = mediaFolder.."fonts\\font.ttf" 	
	fontsize = 8
	fontflag = "OUTLINEMONOCHROME"
else
	font = mediaFolder.."fonts\\font2.ttf"	
	fontsize = 12
	fontflag = "OUTLINE"
	
end
-- END FONTS

-- CHANGE POSITION HERE (DO NOT TOUCH Y VALUE)
position = "TOPLEFT"     	
position_x = 22          		
position_y = 0
-- END POSITION

local Scale = 1
local classcolors = true -- class color text

local texture = "Interface\\Buttons\\WHITE8x8"
local backdrop = {edgeFile = texture, edgeSize = 1}
local rectangleMask = mediaFolder.."background\\rectangle"

local backdropcolor = {0/255, 0/255, 0/255}		-- backdrop color	
local brdcolor = {0/255, 0/255, 0/255}			-- backdrop border color

--[[END CONFIG]]

QuseMap = CreateFrame("Frame", "QuseMap", UIParent)
QuseMap:RegisterEvent("ADDON_LOADED")
QuseMap:SetScript("OnEvent", function(self, event, addon)
    if(addon~="QuseMap") then return end
  
--[[ Style ]]
    MinimapCluster:EnableMouse(false)
	
	Minimap:SetSize(180*Scale, 180*Scale)
	Minimap:SetMaskTexture(rectangleMask)
	Minimap:SetHitRectInsets(0, 0, 24*Scale, 24*Scale)
	Minimap:SetFrameLevel(4)
	Minimap:ClearAllPoints()
	Minimap:SetPoint(position, UIParent, position_x, position_y)
	Minimap:SetScale(Scale)
	
	Minimap:SetArchBlobRingScalar(0);
	Minimap:SetQuestBlobRingScalar(0);

	BorderFrame = CreateFrame("Frame", nil, Minimap)
	BorderFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, -(22*Scale))
	BorderFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, (22*Scale))	
	BorderFrame:SetBackdrop(backdrop)
	BorderFrame:SetBackdropBorderColor(unpack(brdcolor))
	BorderFrame:SetBackdropColor(unpack(backdropcolor))
	BorderFrame:SetFrameLevel(6)
	
	
--[[ Thingies ]] 

if classcolors == true then
	Ccolor = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass("player"))]
else
	Ccolor = {r=255/255, g=255/255, b=255/255 } -- own textcolor
end	

--[[ Click func ]]
    
    local oldOnClick = Minimap:GetScript("OnMouseUp")
    Minimap:SetScript("OnMouseUp", function(self,click)
	    if(click=="RightButton") then
		    ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", 0, 0)
	    elseif(click=="MiddleButton") then
		    if (not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end Calendar_Toggle() 
	    else 
		    oldOnClick(self)
	    end
    end)
	
--[[ Instance Difficulty - From FreeUI by Haleth]]

local rd = CreateFrame("Frame", nil, Minimap)
rd:SetSize(24, 8)
rd:RegisterEvent("PLAYER_ENTERING_WORLD")
rd:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
rd:RegisterEvent("GUILD_PARTY_STATE_UPDATED")

local rdt = rd:CreateFontString(nil, "OVERLAY")
rdt:SetPoint("TOP", Minimap, "TOP", 0, -27)
rdt:SetFont(font, fontsize, fontflag)

rd:SetScript("OnEvent", function()
	local _, _, difficulty, _, maxPlayers = GetInstanceInfo()

	if difficulty == 0 then
		rdt:SetText("")
	elseif maxPlayers == 3 then
		rdt:SetText("3")
	elseif difficulty == 1 then
		rdt:SetText("5")
	elseif difficulty == 2 then
		rdt:SetText("5H")
	elseif difficulty == 3 then
		rdt:SetText("10")
	elseif difficulty == 4 then
		rdt:SetText("25")
	elseif difficulty == 5 then
		rdt:SetText("10H")
	elseif difficulty == 6 then
		rdt:SetText("25H")
	elseif difficulty == 7 then
		rdt:SetText("LFR")
	elseif difficulty == 8 then
		rdt:SetText("5CM")
	elseif difficulty == 9 then
		rdt:SetText("40")
	end

	if GuildInstanceDifficulty:IsShown() then
		rdt:SetTextColor(0, .9, 0)
	else
		rdt:SetTextColor(1, 1, 1)
	end
end)

--[[ BG icon ]]
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetParent(Minimap)
QueueStatusMinimapButton:SetPoint('TOPRIGHT', 2, -20)

QueueStatusFrame:SetClampedToScreen(true)
QueueStatusFrame:SetToplevel(true)

--[[ Clock ]]
if not IsAddOnLoaded("Blizzard_TimeManager") then
	LoadAddOn("Blizzard_TimeManager")
end
local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
clockFrame:Hide()
clockTime:SetFont(font, fontsize, fontflag)
clockTime:SetShadowOffset(0,0)
clockTime:SetTextColor(Ccolor.r, Ccolor.g, Ccolor.b)
TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", -1, 14)
TimeManagerClockButton:SetScript('OnShow', nil)
TimeManagerClockButton:Show()
TimeManagerClockButton:SetScript('OnClick', function(self, button)
	if(button=="RightButton") then
		if(self.alarmFiring) then
			PlaySound('igMainMenuQuit')
			TimeManager_TurnOffAlarm()
		else
			ToggleTimeManager()
		end
	else
		ToggleCalendar()
	end
end)  
TimeManagerFrame:ClearAllPoints()
TimeManagerFrame:SetPoint("CENTER", Minimap, "CENTER", 0, 0)
TimeManagerFrame:SetClampedToScreen(true)
TimeManagerFrame:SetToplevel(true)

-- [[ Mail ]]

MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, 13)
MiniMapMailIcon:SetTexture("Interface\\AddOns\\QuseMap\\mail")
MiniMapMailIcon:SetAlpha(0)
local mail = MiniMapMailFrame:CreateFontString(nil, "OVERLAY")
		mail:SetFont(font, fontsize, fontflag)
		mail:SetText("m!")
		mail:SetTextColor(1, 0, .33)
		mail:SetPoint("RIGHT", MiniMapMailFrame, "RIGHT", 0,0)

--[[ Tracking]]	

	MiniMapTracking:ClearAllPoints()
	MiniMapTracking:SetParent(Minimap)
	MiniMapTracking:SetPoint('TOPLEFT', 0, -25)
	MiniMapTracking:SetAlpha(0)
	MiniMapTrackingBackground:Hide()
	MiniMapTrackingButtonBorder:SetTexture(nil)
	MiniMapTrackingButton:SetHighlightTexture(nil)
	MiniMapTrackingIconOverlay:SetTexture(nil)
	MiniMapTrackingIcon:SetTexCoord(0.065, 0.935, 0.065, 0.935)
	MiniMapTrackingIcon:SetWidth(20)
	MiniMapTrackingIcon:SetHeight(20)
	
    QuseMap.tracking = CreateFrame("Frame", nil, Minimap)
	
	MiniMapTrackingButton:SetScript("OnEnter",function()
		--UpdateTrackignText()
		MiniMapTracking:SetAlpha(1)
        QuseMap.tracking:SetAlpha(1)
	end)

    Minimap:SetScript("OnLeave", function()
        MiniMapTracking:SetAlpha(0)
        QuseMap.tracking:SetAlpha(0)
    end)
	
	MiniMapTrackingButton:SetScript("OnLeave", function()
        MiniMapTracking:SetAlpha(0)
        QuseMap.tracking:SetAlpha(0)
    end)
	
	MiniMapTrackingButton:SetScript("OnMouseUp", function(self,click)
	    if(click=="RightButton") then
		    ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", 0, 0)
		elseif(click=="MiddleButton") then
			if (not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end Calendar_Toggle() 
		end
	end)
	QuseMap.tracking.text = t
  
--[[ Calendar ]]

-- Slashcommand for calendar
SlashCmdList["CALENDAR"] = function()
	ToggleCalendar()
end
SLASH_CALENDAR1 = "/cl"
SLASH_CALENDAR2 = "/calendar"

local cal = CreateFrame("Frame", nil, Minimap)
GameTimeFrame:HookScript("OnShow", cal.Show)
GameTimeFrame:SetScript("OnEvent", function(self, event, addon)
-- cal:SetPoint("CENTER", Minimap)
-- local calt = cal:CreateFontString(nil, "OVERLAY")
-- calt:SetFont(font, fontsize, fontflag)
-- calt:SetPoint("TOP", cal, "TOP", 0, 10)
-- calt:SetTextColor(color.r, color.g, color.b)
	
	if CalendarGetNumPendingInvites() ~= 0 then
		clockTime:SetTextColor(.67,.35,.35)
		-- cal:Show()
		-- calt:SetText("*")	
	else
		clockTime:SetTextColor(Ccolor.r, Ccolor.g, Ccolor.b)
		-- cal:Hide()	
		-- calt:SetText("")
	end
end)

    self:UnregisterEvent(event)
end)

function GetMinimapShape() return "SQUARE" end

--[[ Hiding ugly things	]]
local dummy = function() end
local frames = {
    "MiniMapVoiceChatFrame",
    "MiniMapWorldMapButton",
    "MinimapZoneTextButton",
    "MiniMapMailBorder",
    "MiniMapInstanceDifficulty",
    "MinimapNorthTag",
    "MinimapZoomOut",
    "MinimapZoomIn",
    "MinimapBackdrop",
    "GameTimeFrame",
    "GuildInstanceDifficulty",
	"MiniMapChallengeMode",
	"MinimapBorderTop",
}
GameTimeFrame:SetAlpha(0)
GameTimeFrame:EnableMouse(false)
GameTimeCalendarInvitesTexture:SetParent("Minimap")

for i in pairs(frames) do
    _G[frames[i]]:Hide()
    _G[frames[i]].Show = dummy
end

------------------------
--move and clickable --
----------------------
-- Minimap:SetMovable(true)
-- Minimap:SetUserPlaced(false)
-- Minimap:SetScript("OnMouseDown", function()
    -- if (IsAltKeyDown()) then
        -- Minimap:ClearAllPoints()
        -- Minimap:StartMoving()
    -- end
-- end)

Minimap:SetScript('OnMouseUp', function(self, button)
Minimap:StopMovingOrSizing()
    if (button == 'RightButton') then
        ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * 0.7), -3)
    elseif (button == 'MiddleButton') then
        ToggleCalendar()
    else
        Minimap_OnClick(self)
    end
end)

--[[ Mousewheel zoom ]]
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
    if zoom > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)