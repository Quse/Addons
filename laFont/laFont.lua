------------------------------------------------------------------------------------------------------------
---------- A very special thanks goes to -------------------------------------------------------------------
---------- Xzatly  - for xDamgeFont ------------------------------------------------------------------------
---------- abomb93 - for aZoneText  ------------------------------------------------------------------------ 
------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------
---------- Config, nothing really special ;-P --------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

--- true = yes 
--- false = no

local font = "Interface\\AddOns\\sharedmedia\\fonts\\FCT.ttf"                            --- The font you want to have.
 
local ZoneText = false                                          --- Should the ZoneText have another font?
local DamageText = true                                         --- Should the DamageText have another font?
 
local CustomColors = true                   --ONLY ZONETEXT!                    --- Want some custom colors?
local CustomText = false                    --ONLY ZONETEXT!                      --- Want some custom text?

--- Default: pvp: 20; Zone: 100; SubZone: 30  
--- Fontsize has to be between 0 and 100
local pvpFontSize = {20}                                                                     -- pvp Fontsize
local ZoneFontSize = {30}                                                                  -- Zone Fontsize
local SubZoneFontSize = {20}                                                             -- SubZone Fontsize

local SColor = {0, 255, 255}                                                      --- Sanctuary custom color
local AColor = {255, 0, 0}														      --- Arena custom color
local FColor = {0, 255, 0}														   --- Friendly custom color
local HColor = {255, 0, 0}															--- Hostile custom color
local CColor = {255, 255, 0}												      --- Contested custom color

local SText = 'Safe Zone!'                                                         --- Sanctuary custom text
local AText = 'Arena!'									    	                	   --- Arena custom text
local FText = 'Friends inc!'                                     		    	    --- Friendly custom text
local HText = 'Enemies inc!'			                                             --- Hostile custom text
local CText = 'Letz fight!'         									           --- Contested custom text

------------------------------------------------------------------------------------------------------------
---------- Zone Font ---------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

if (ZoneText == true) then

		ZoneFadeInDuration = 0.5
		ZoneHoldDuration = 1.0
		ZoneFadeOutDuration = 2.0
		ZonePVPType = nil

		function SetZoneText(showZone)
			local pvpType, isSubZonePvP, factionName = GetZonePVPInfo()
			PVPArenaTextString:SetText("")
			PVPInfoTextString:SetText("")
			local pvpTextString = PVPInfoTextString
			if ( isSubZonePvP ) then
				pvpTextString = PVPArenaTextString
			end			

			if ( pvpType == "sanctuary" ) then
				pvpTextString:SetFont(font, unpack(pvpFontSize))					
				ZoneTextString:SetFont(font, unpack(ZoneFontSize))
				SubZoneTextString:SetFont(font, unpack(SubZoneFontSize)) 	
				
				if (CustomText == true) then
				   pvpTextString:SetText(SText)
				else pvpTextString:SetText(SANCTUARY_TERRITORY)   
				end   				
				
				if (CustomColors == true) then 
				   pvpTextString:SetTextColor(unpack(SColor))
				   ZoneTextString:SetTextColor(unpack(SColor))
				   SubZoneTextString:SetTextColor(unpack(SColor))   
				end
				
			elseif ( pvpType == "arena" ) then
				pvpTextString:SetFont(font, unpack(pvpFontSize))					
				ZoneTextString:SetFont(font, unpack(ZoneFontSize))
				SubZoneTextString:SetFont(font, unpack(SubZoneFontSize)) 	
				
				if (CustomText == true) then
				   pvpTextString:SetText(AText)
				else pvpTextString:SetText(FREE_FOR_ALL_TERRITORY)  
				end   				
				
				if (CustomColors == true) then 
				   pvpTextString:SetTextColor(unpack(AColor))
				   ZoneTextString:SetTextColor(unpack(AColor))
				   SubZoneTextString:SetTextColor(unpack(AColor))
				end	
				
			elseif ( pvpType == "friendly" ) then
				pvpTextString:SetFont(font, unpack(pvpFontSize))					
				ZoneTextString:SetFont(font, unpack(ZoneFontSize))
				SubZoneTextString:SetFont(font, unpack(SubZoneFontSize)) 	
				
				if (CustomText == true) then
				   pvpTextString:SetText(FText)
				else pvpTextString:SetText(format(FACTION_CONTROLLED_TERRITORY, factionName))   
				end   				
				
				if (CustomColors == true) then 
				   pvpTextString:SetTextColor(unpack(FColor))
				   ZoneTextString:SetTextColor(unpack(FColor))
				   SubZoneTextString:SetTextColor(unpack(FColor))
				end		
				
			elseif ( pvpType == "hostile" ) then
				pvpTextString:SetFont(font, unpack(pvpFontSize))					
				ZoneTextString:SetFont(font, unpack(ZoneFontSize))
				SubZoneTextString:SetFont(font, unpack(SubZoneFontSize)) 	
				
				if (CustomText == true) then
				   pvpTextString:SetText(HText)
				else pvpTextString:SetText(format(FACTION_CONTROLLED_TERRITORY, factionName))   
				end   				
				
				if (CustomColors == true) then 
				   pvpTextString:SetTextColor(unpack(HColor))
				   ZoneTextString:SetTextColor(unpack(HColor))
				   SubZoneTextString:SetTextColor(unpack(HColor))
				end		
				
			elseif ( pvpType == "contested" ) then
				pvpTextString:SetFont(font, unpack(pvpFontSize))					
				ZoneTextString:SetFont(font, unpack(ZoneFontSize))
				SubZoneTextString:SetFont(font, unpack(SubZoneFontSize)) 	
				
				if (CustomText == true) then
				   pvpTextString:SetText(CText)
				else pvpTextString:SetText(CONTESTED_TERRITORY)   
				end   				
				
				if (CustomColors == true) then 
				   pvpTextString:SetTextColor(unpack(CColor))
				   ZoneTextString:SetTextColor(unpack(CColor))
				   SubZoneTextString:SetTextColor(unpack(CColor))
				end								
				
			else
				ZoneTextString:SetTextColor(1.0, 0.9294, 0.7607)
				SubZoneTextString:SetTextColor(1.0, 0.9294, 0.7607)
			end

			if ( ZonePVPType ~= pvpType ) then
				ZonePVPType = pvpType;
			elseif ( not showZone ) then
				PVPInfoTextString:SetText("");
				SubZoneTextString:SetPoint("TOP", "ZoneTextString", "BOTTOM", 0, 0)
			end

			if ( PVPInfoTextString:GetText() == "" ) then
				SubZoneTextString:SetPoint("TOP", "ZoneTextString", "BOTTOM", 0, 0)
			else
				SubZoneTextString:SetPoint("TOP", "PVPInfoTextString", "BOTTOM", 0, 0)
			end
		end	
end		

-----------------------------------------------------------------------------------------------------------
---------- Damage Font ------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

if (DamageText == true) then 
DaFont = CreateFrame("Frame", "DaFont")

local damagefont_FONT_NUMBER = font

function DaFont:ApplySystemFonts()

DAMAGE_TEXT_FONT = damagefont_FONT_NUMBER

end

DaFont:SetScript("OnEvent",
		    function() 
		       if (event == "ADDON_LOADED") then
			  DaFont:ApplySystemFonts()
		       end
		    end);
DaFont:RegisterEvent("ADDON_LOADED")

DaFont:ApplySystemFonts()
end 