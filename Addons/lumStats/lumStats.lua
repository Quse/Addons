-- ------------------------------------------------------------------------
-- > lumStats (Kreoss @ Quel'Thalas EU) <
-- ------------------------------------------------------------------------
-- Credits: Lyn (LynStats), Katae (LiteStats) and Tekkub
-- ------------------------------------------------------------------------

	local st = CreateFrame("Button", "lumStats", UIParent)

-- ------------------------------------------------------------------------
-- > 0. Configuration and Media
-- ------------------------------------------------------------------------

	-- Media
	local font = "Interface\\addons\\sharedmedia\\fonts\\font.ttf"
	
	-- Modules
	local show_clock = false -- Clock
	local show_fps = true -- Frame Rate
	local show_lag = true -- Latency
	local show_mail = false -- New Mail
	local show_bags = false -- Bag Space
	local show_dur = true -- Durability
	local show_spec = true -- Talent Spec
	
	-- Config
	local fWidth = 130 -- Main Frame Width
	local fHeight = 14 -- Main Frame Height
	local fParent = "UIParent" -- Main Frame Parent
	local fParentPoint = "BOTTOM" -- Main Frame Parent Anchor
	local fPoint = "CENTER" -- Main Frame Set Point
	local fPosx = 0 -- Main Horizontal Position
	local fPosy = 11 -- Main Vertical Position
		
	local fontSize = 8 -- Font Size duh!
	local fontFlag = "OUTLINEMONOCHROME" -- The Font Outline
	local fontShadow = false -- Font Shadow
	local tmargin = 4 -- Text Left and Right Margins
	
	local time24 = true -- If true show Time in 24H Format
	local nraddons = 50 -- Number of addons to show on the memory tooltip
	local CalendarEventWarning = true -- Flashes the hour if there is a new event on the calendar (requires show_clock = true)

-- ------------------------------------------------------------------------
-- > 1. Variables
-- ------------------------------------------------------------------------

	local hour, mail, fps, lag, bags, dur, spec
	local refresh_timer, newEvent, slotsfree, memBefore, memAfter, memory, entry, BlizzMem, gotMail, lowdur, PlayerLevel, curSpec, unspentPoints, numSpecs, specNum = 0, 0
	
	-- Copy Global functions to speed references
	local GetContainerNumFreeSlots, GetInventorySlotInfo, GetInventoryItemDurability = GetContainerNumFreeSlots, GetInventorySlotInfo, GetInventoryItemDurability
	local GetFramerate, HasNewMail, GetNetStats, GetActiveSpecGroup, GetNumTalentGroups = GetFramerate, HasNewMail, GetNetStats, GetActiveSpecGroup, GetNumTalentGroups
	local CalendarGetNumPendingInvites, ChatFrame_TimeBreakDown, GetTalentTabInfo = CalendarGetNumPendingInvites, ChatFrame_TimeBreakDown, GetTalentTabInfo
	local format, pairs, ipairs, collectgarbage, gcinfo, floor = string.format, pairs, ipairs, collectgarbage, gcinfo, math.floor
	
	-- Text Color
	local tColor = {r = 0.92, g = 0.92, b = 0.92, a = 1} -- Text Color
	local lColor = RAID_CLASS_COLORS[select(2, UnitClass("player"))] -- Label Class Colored
	
	-- Font Strings
	local Ltext, Ctext, Rtext, caltext
	
	-- Repair Slots
	local SLOTS = {}
	for _,slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do SLOTS[slot] = GetInventorySlotInfo(slot .. "Slot") end
	
	-- Flashing Variables
	local PI = PI
	local TWOPI = PI * 2.0
	local cos = math.cos
	local INVITE_PULSE_SEC  = 1.0 / (2.0*1.0)
	local flashTimer = 0
	
-- ------------------------------------------------------------------------
-- > 2. Functions
-- ------------------------------------------------------------------------

	-- !ClassColors addon
	if(IsAddOnLoaded('!ClassColors') and CUSTOM_CLASS_COLORS) then
		lColor = CUSTOM_CLASS_COLORS[select(2, UnitClass("player"))]
	end

	-- Hex Color
	local Hex
		do 
			Hex = function(color)
        	return format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
   		end
	end
	
	function Gradient(perc)
		perc = perc > 1 and 1 or perc < 0 and 0 or perc
		local seg, relperc = math.modf(perc*2)
		local r1,g1,b1,r2,g2,b2 = select(seg*3+1,1,0,0,1,1,0,1,1,1,0,0,0) -- R -> Y -> W
		local r,g,b = r1+(r2-r1)*relperc,g1+(g2-g1)*relperc,b1+(b2-b1)*relperc
		return format("|cff%02x%02x%02x",r*255,g*255,b*255),r,g,b
	end

	-- Fontstring Function
  	local createFontstring = function(fr, font, size, outline, shadow)
	
    	local fs = fr:CreateFontString(nil, "OVERLAY")
    	fs:SetFont(font, size, outline)
    	if shadow then fs:SetShadowColor(0,0,0,1) end
    	return fs
  	end
	
	-- Format Memory String (LynStats)
	local memFormat = function(num)
		if num > 1024 then
			return format("%.2f mb", (num / 1024))
		else
			return format("%.1f kb", floor(num))
		end
	end
	
	-- Time Format
	local timeFormat = function(t)
	
		local day, hour, minute, second = ChatFrame_TimeBreakDown(floor(t)) -- Blizzard Function
		
		if t >= 86400 then -- Days
			return format("%d|cff999999d|r", day)
		elseif t >= 3600 then -- Hours
			return format("%d|cff999999h|r %d|cff999999m|r", hour, minute)
		elseif t >= 60 then -- Minutes
			return format("%d|cff999999m|r", minute)
		elseif t >= 0 then -- Seconds
			return format("%d|cff999999s|r", second)
		end
	end
		
	-- Cool short number
	local shortFormat = function(num)
	
		if(num >= 1e6) then
			return (floor((num/1e6)*10 + 0.5))/10 .."|cffb3b3b3m"
		elseif(num >= 1e3) then
			return (floor((num/1e3)*10 + 0.5))/10 .."|cffb3b3b3k"
		else
			return num
		end
	end
	
	-- Ordering
	local AddonCompare = function(a, b)
		return a.memory > b.memory
	end
	
	-- ClearGarbage (LynStats)
	local ClearGarbage = function()
		UpdateAddOnMemoryUsage()
		memBefore = gcinfo()
		collectgarbage()
		UpdateAddOnMemoryUsage()
		memAfter = gcinfo()
		ChatFrame1:AddMessage(("%sGarbage Cleaned:|r "..memFormat(memBefore - memAfter)):format(Hex(lColor)))
	end
	
	-- Count Free Bags Free Slots 
	function st:bagsSlotsFree()
	
		local free = 0
		for i = 0, NUM_BAG_SLOTS do
			free = free + GetContainerNumFreeSlots(i)
		end
		return free
	end
	
	-- Calculates Lower Durability
	function st:Durability()

		local l = 1
		for slot,id in pairs(SLOTS) do
			local d, md = GetInventoryItemDurability(id)
			if d and md and md ~= 0 then
				l = math.min(d/md, l)
			end
		end

		return format("%s%d|r",Gradient(l),l*100)
	end
	
	-- Talent Tree
	function st:Talents()
	
		PlayerLevel = UnitLevel("PLAYER")
		if PlayerLevel >= 10 then -- If Level is inferior to Level 10 player has no talents yet
			local specName
			local primaryTalentTree = GetActiveSpecGroup() -- 1:3 = Spec number, 0 = No primary talent tree set yet
			specNum = GetActiveSpecGroup() -- Currently Active Spec: 1 = Primary, 2 = Secundary
			if specNum == 1 then specNum = 2 else specNum = 1 end
			numSpecGroups = GetNumSpecGroups(false, false) -- 1 = Player has no DualSpec, 2 = Player has DualSpec

			if (primaryTalentTree) then
				_, specName =  GetSpecializationInfo(primaryTalentTree)
				unspentPoints = GetNumUnspentTalents(false, false, nil)
				if specName == nil then specName = '-' end
				if unspentPoints and unspentPoints > 0 then
					return ("%s*|r|cffB2B2B2 (%d)  |r"):format(Hex(lColor),unspentPoints)
				else
					return ("%s*  |r"):format(Hex(lColor))
				end
			else
				return "|cff6B6B6B*  "
					end
			
		else
			return "*  "
					
		end
	end
	
	-- Flashing Event
	function st:FlashingText(elapsed)
		
		local flashIndex = TWOPI * flashTimer * INVITE_PULSE_SEC
		local flashValue = max(0.0, 0.5 + 0.5*cos(flashIndex))
		
		if ( flashIndex >= TWOPI ) then
            flashTimer = 0.0
        else
            flashTimer = flashTimer + elapsed
        end
		
		return flashValue
	end
			
	function st:leftTooltip()
	
		if not InCombatLockdown() then -- Don't Show in Combat
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 4, 8)
			
			
			GameTooltip:AddLine("Talent Spec", lColor.r, lColor.g, lColor.b)
			GameTooltip:AddLine(" ")
			if unspentPoints and unspentPoints > 0 then
				GameTooltip:AddLine(format("You have %d unspent talent points",unspentPoints), 1,0,0.42)
				GameTooltip:AddLine(" ")
			end
			if numSpecGroups == 2 then
				GameTooltip:AddLine("Left click to open Talents")
				GameTooltip:AddLine("Right click to Change Spec")
			else
				GameTooltip:AddLine("Left click to open Talents")
			end
			GameTooltip:Show()
		end
	end
	
	function st:rightTooltip()
	
		if not InCombatLockdown() then -- Don't Show in Combat
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -4, 8)
			GameTooltip:AddLine(date('%A, %d %B'), lColor.r, lColor.g, lColor.b)
			GameTooltip:AddLine(" ")
			for i = 1,2 do
				local _,mapName,isActive,_,startTime,_,status = GetWorldPVPAreaInfo(i)
				if(not isActive) then status = timeFormat(startTime) else status = "In Progress" end
				GameTooltip:AddDoubleLine(format("Next %s Battle:",mapName),status, 0,0.5,1, 1,1,1)
			end
			GameTooltip:AddLine(" ")
			if(GetLatestThreeSenders()) then
				local s1, s2, s3 = GetLatestThreeSenders()
				local senders = {s1,s2,s3}
				GameTooltip:AddLine("New mail from:", 1,0,0.42)
				for i, sender in ipairs(senders) do
					if sender == nil then break end
					GameTooltip:AddLine(sender,  1, 1, 1)
				end
				GameTooltip:AddLine(" ")
			end
			GameTooltip:AddLine("Left click to show the Calendar")
			GameTooltip:AddLine("Right click to open Friends List")
			GameTooltip:Show()
		end
	end
	
	-- Memory Tooltip Function (LynStats)
	function st:centerTooltip()
	
		if not InCombatLockdown() then -- Don't Show in Combat
			local addons, total, nr, name = {}, 0, 0
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 8)
			BlizzMem = collectgarbage("count")
			UpdateAddOnMemoryUsage()
			GameTooltip:AddLine("Top "..nraddons.." AddOns", lColor.r, lColor.g, lColor.b)
			GameTooltip:AddLine(" ")
			for i = 1, GetNumAddOns(), 1 do
				if (GetAddOnMemoryUsage(i) > 0 ) then
					memory = GetAddOnMemoryUsage(i)
					entry = {name = GetAddOnInfo(i), memory = memory}
					table.insert(addons, entry)
					total = total + memory
				end
			end
			table.sort(addons, AddonCompare)
			for _, entry in pairs(addons) do
				if nr < nraddons then
					GameTooltip:AddDoubleLine(entry.name, memFormat(entry.memory), 1, 1, 1, 0.75, 0.75, 0.75)
					nr = nr+1
				end
			end
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine("UI Memory usage", memFormat(total), lColor.r, lColor.g, lColor.b, lColor.r, lColor.g, lColor.b)
			GameTooltip:AddDoubleLine("Total incl. Blizzard", memFormat(BlizzMem), lColor.r, lColor.g, lColor.b, lColor.r, lColor.g, lColor.b)
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Left Click to open Bags")
			GameTooltip:AddLine("Right click to Colect Garbage")
			GameTooltip:Show()
		end
	end
	
	local function TooltipHide()
		GameTooltip:Hide()
	end
	
	-- Initialize Function
	function st:Init()
			
		curSpec = st:Talents()
		
		if not show_clock then CalendarEventWarning = false end -- Disables hour flashing for new events if hour is not showing
		
		self:SetWidth(fWidth)
		self:SetHeight(fHeight)
		self:SetPoint(fPoint, fParent, fParentPoint, fPosx, fPosy)
		
		self.lf = CreateFrame("Button", nil, self) -- Left Frame
		self.cf = CreateFrame("Button", nil, self) -- Center Frame
		self.rf = CreateFrame("Button", nil, self) -- Right Frame
		
		self.lf:SetHeight(fHeight)
		self.lf:SetPoint("LEFT", self, tmargin, 0)
		self.cf:SetHeight(fHeight)
		self.cf:SetPoint("CENTER", self, tmargin, 0)
		self.rf:SetHeight(fHeight)
		self.rf:SetPoint("RIGHT", self, -tmargin, 0)
		
		-- Create Left Text
		Ltext = createFontstring(self.lf, font, fontSize, fontFlag, fontShadow) 
		Ltext:SetPoint("LEFT", self.lf, tmargin, 0)
		Ltext:SetTextColor(tColor.r, tColor.g, tColor.b)
		-- Create Center Text
		Ctext = createFontstring(self.cf, font, fontSize, fontFlag, fontShadow) 
		Ctext:SetPoint("CENTER", self.cf, 0, 0)
		Ctext:SetTextColor(tColor.r, tColor.g, tColor.b)
		-- Create Right Text
		Rtext = createFontstring(self.rf, font, fontSize, fontFlag, fontShadow) 
		Rtext:SetPoint("RIGHT", self.rf, -tmargin, 0)
		Rtext:SetTextColor(tColor.r, tColor.g, tColor.b)
		
		-- Create Calendar New Event String
		if CalendarEventWarning then
			caltext = createFontstring(self.rf, font, fontSize, fontFlag, fontShadow) 
			caltext:SetPoint("LEFT", Rtext, 0, 0)
			caltext:SetTextColor(tColor.r, tColor.g, tColor.b)
			caltext:SetAlpha(0)
		end
		
		self.lf:SetScript("OnEnter", self.leftTooltip)
		self.cf:SetScript("OnEnter", self.centerTooltip)
		self.rf:SetScript("OnEnter", self.rightTooltip)		
		self.lf:SetScript("OnLeave", TooltipHide)
		self.cf:SetScript("OnLeave", TooltipHide)
		self.rf:SetScript("OnLeave", TooltipHide)
		self.lf:RegisterForClicks("AnyUp") -- Accept clicks from any mouse button
		self.lf:SetScript("OnClick", function(self,button) if button == "LeftButton" then ToggleTalentFrame() elseif button == "RightButton" then SetActiveSpecGroup(specNum) end end)
		self.cf:RegisterForClicks("AnyUp") -- Accept clicks from any mouse button
		self.cf:SetScript("OnClick", function(self,button) if button == "LeftButton" then OpenAllBags() elseif button == "RightButton" then ClearGarbage() end end)
		self.rf:RegisterForClicks("AnyUp") -- Accept clicks from any mouse button
		self.rf:SetScript("OnClick", function(self,button) if button == "LeftButton" then ToggleCalendar() caltext:SetAlpha(0) newEvent = 0 elseif button == "RightButton" then ToggleFriendsFrame() end end)
		self:SetScript("OnUpdate", self.Update)
	end
	
	-- Update Function
	function st:Update(elapsed)
	
		-- Time
		if show_clock then
			if time24 then
				hour = date("%H:%M") -- Time 24H Format
			else
				hour = date("%I:%M|cff919191%p|r") -- Time 12H Format
			end
			
			if CalendarEventWarning and (newEvent ~= 0) then -- If the calendar new event is on flash the hour
				caltext:SetText(("%s"..hour.."|r"):format(Hex(lColor)))
				caltext:SetAlpha(st:FlashingText(elapsed))
			end
		else
			hour = ''
		end	
	
		-- Main Update
		
		refresh_timer = refresh_timer + elapsed -- Only update this values every refresh_timer seconds
		if refresh_timer > 1 then -- Updates each X seconds	
			
			-- Mail
			if show_mail then
				if gotMail then
					mail = ("|cffff0054 Mail!|r")
				else
					mail = ('')
				end
			else
				mail = ''
			end
			
			-- FPS
			if show_fps then
				fps = GetFramerate()
				fps = (floor(fps).."%sfps  |r"):format(Hex(lColor))
			else
				fps = ''
			end
			
			-- Latency
			if show_lag then
				lag = select(3, GetNetStats())
				lag = (lag.."%sms|r "):format(Hex(lColor))
			else
				lag = ''
			end
						
			-- Bags
			if show_bags then	
				bags = (slotsfree.."%sbag|r  "):format(Hex(lColor))			
			end
			
			-- Durability
			if show_dur then
				dur = (lowdur.."%sdur|r  "):format(Hex(lColor))
			end
			
			-- Talent Spec
			if show_spec then
				spec = curSpec
			end
			
			-- Show me the money!
			Ltext:SetText() -- Left Anchored Text
			Ctext:SetText(spec..dur..fps..lag) -- Center Anchored Text
			Rtext:SetText() -- Right Anchored Text
			
			-- Frames Width
			self.lf:SetWidth(18)
			self.cf:SetWidth(100)
			self.rf:SetWidth(0)
			
			refresh_timer = 0 -- Reset Timer
		end
	end
		
	-- Bag Update
	function st:BAG_UPDATE(event,...)
	
		slotsfree = st:bagsSlotsFree()
	end
	
	function st:PLAYER_TALENT_UPDATE(event,...)
	
		curSpec = st:Talents()
	end
	
	function st:CHARACTER_POINTS_CHANGED(event,...)
	
		curSpec = st:Talents()
	end
		
	function st:UPDATE_INVENTORY_DURABILITY(event,...)
		
		lowdur = st:Durability()
	end
	
	function st:UPDATE_PENDING_MAIL(event,...)
	
		gotMail = (HasNewMail() or nil)
	end
	
	function st:CALENDAR_UPDATE_PENDING_INVITES(event,...)
	
		newEvent = CalendarGetNumPendingInvites()
	end
	
	function st:PLAYER_ENTERING_WORLD(event,...)
	
		slotsfree = st:bagsSlotsFree()
		lowdur = st:Durability()
		gotMail = (HasNewMail() or nil)
		curSpec = st:Talents()
		newEvent = CalendarGetNumPendingInvites()
	end
	
	function st:PLAYER_LOGIN(event,...)
	
		slotsfree = st:bagsSlotsFree()
		lowdur = st:Durability()
		gotMail = (HasNewMail() or nil)
		curSpec = st:Talents()
		newEvent = CalendarGetNumPendingInvites()
	end
	
	function st:ADDON_LOADED(event,...)

		-- Events
		st:RegisterEvent("PLAYER_LOGIN")
		st:RegisterEvent("PLAYER_ENTERING_WORLD")
		st:RegisterEvent("BAG_UPDATE")  
		st:RegisterEvent("UPDATE_INVENTORY_DURABILITY")  
		st:RegisterEvent("UPDATE_PENDING_MAIL") 
		st:RegisterEvent("PLAYER_TALENT_UPDATE") 
		st:RegisterEvent("CHARACTER_POINTS_CHANGED") 
		st:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
			
		st:UnregisterEvent("ADDON_LOADED")
	end
	
-- ------------------------------------------------------------------------
-- > 3. Calls
-- ------------------------------------------------------------------------
	
	st:Init() -- Begins the Magic!
	
-- ------------------------------------------------------------------------
-- > 4. Events
-- ------------------------------------------------------------------------

	st:SetScript("OnEvent", function(self,event, ...) if self[event] then return self[event](self, event, ...) end end)
	st:RegisterEvent("ADDON_LOADED")