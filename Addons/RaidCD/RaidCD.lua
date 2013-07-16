-- Config start
local enabled = true
local width, height = 130, 14
local spacing = 1
local iconsize = 14
local showicon = true
local texture = "Interface\\Buttons\\WHITE8x8"
local font = "Interface\\addons\\sharedmedia\\fonts\\font.ttf"
local fontsize = 8
local fontflag = "OUTLINEMONOCHROME"
local border_size = 1
-- local show = {
	-- raid = true,
	-- party = true,
	-- arena = true,
-- }
-- Config end

local spells = {
	-- Druid
	[20484] = 600,	-- Rebirth
	[29166] = 180,	-- Innervate
	[33891] = 180,	-- Tree of Life
	[740] = 180,	-- Tranq
	-- Monk
	[115310] = 180,	-- Revival
	-- Paladin
	-- Priest
	[33206] = 180,	-- Pain Supp
	[62618] = 180,	-- PWB
	[64843] = 180,	-- Divine Hymn
	[64901] = 360,	-- Hymn of Hope
	[33206] = 180,	-- Guardian Spirit
	-- Shaman
	[98008] = 180,	-- Spirit Link
	[108280] = 180,	-- Healing Tide
	[16190] = 180,	-- Mana Tide
	-- Misc
	[126393] = 600,	-- BM Hunter BRez
	[20707] = 600,	-- Soulstone
	[61999] = 600,	-- Raise Ally
}
	
local cfg = {
	general = {
		enabled = {
			order = 1,
			value = true,
		},
		showicon = {
			order = 2,
			value = true,
		},
		width = {
			order = 3,
			value = width,
			type = "range",
			min = 10,
			max = 300,
		},
		height = {
			order = 4,
			value = height,
			type = "range",
			min = 5,
			max = 30,
		},
		spacing = {
			order = 5,
			value = spacing,
			type = "range",
			min = 0,
			max = 30,
		},
		iconsize = {
			order = 6,
			value = icon_size,
			type = "range",
			min = 5,
			max = 70,
		},
	},
	showin = {
		raid = {
			order = 1,
			value = true,
		},
		party = {
			order = 2,
			value = true,
		},
		arena = {
			order = 3,
			value = true,
		},
	},
}

cfg = cfg

local frame = CreateFrame("Frame")
frame:RegisterEvent("VARIABLES_LOADED")
frame:SetScript("OnEvent", function(self, event)
	width = width
	height = height
	spacing = spacing
	icon_size = iconsize
	show_icon = showicon
	show = {
		raid = cfg.showin.raid, 
		party = cfg.showin.party, 
		arena = cfg.showin.arena,
	}
end)

local CreateFS = CreateFS or function(frame)
	local fstring = frame:CreateFontString(nil, 'OVERLAY')
	fstring:SetFont(font, fontsize, fontflag)
	return fstring
end

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local timer = 0

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = 1,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local bars = {}

local anchorframe = CreateFrame("Frame", "RaidCD", UIParent)
anchorframe:SetSize(width, height)
anchorframe:SetPoint("BOTTOM", -237, 24)
if UIMovableFrames then tinsert(UIMovableFrames, anchorframe) end

local FormatTime = function(time)
	if time >= 60 then
		return sformat('%.2d:%.2d', floor(time / 60), time % 60)
	else
		return sformat('%.2d', time)
	end
end

-- For normal downwards growth
-- local UpdatePositions = function()
	-- for i = 1, #bars do
		-- bars[i]:ClearAllPoints()
		-- if i == 1 then
			-- bars[i]:SetPoint("TOPLEFT", anchorframe, 0, 0)
		-- else
			-- bars[i]:SetPoint("TOPLEFT", bars[i-1], "BOTTOMLEFT", 0, -spacing)
		-- end
		-- bars[i].id = i
	-- end
-- end

-- For upwards growth
local UpdatePositions = function()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		if i == 1 then
			bars[i]:SetPoint("TOPLEFT", anchorframe, 0, 0)
		else
			bars[i]:SetPoint("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, spacing)
		end
		bars[i].id = i
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self.status:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(self.spell)
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		SendChatMessage(sformat("COOLDOWN - %s [%s] %s", self.left:GetText(), self.spell, self.right:GetText()), "RAID")
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = CreateFrame("Frame", nil, UIParent)
	bar:SetSize(width, height)
	bar.status = CreateFrame("Statusbar", nil, bar)
	if show_icon then
		bar.icon = CreateFrame("button", nil, bar)
		bar.icon:SetSize(icon_size, icon_size)
		bar.icon:SetPoint("BOTTOMLEFT", 0, 0)
		
			bar.icon.bg = CreateFrame("Frame", nil, bar.icon)
			bar.icon.bg:SetPoint("TOPLEFT", -1, 1)
			bar.icon.bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bar.icon.bg:SetFrameLevel(bar:GetFrameLevel()-1)
			bar.icon.bg:SetBackdrop(backdrop)
			bar.icon.bg:SetBackdropColor(0,0,0,0.5)
			bar.icon.bg:SetBackdropBorderColor(0,0,0,1)
			
		bar.status:SetPoint("BOTTOMLEFT", bar.icon, "BOTTOMRIGHT", 1, 0)
	else
		bar.status:SetPoint("BOTTOMLEFT", 0, 0)
	end
	bar.status:SetPoint("BOTTOMRIGHT", 0, 0)
	bar.status:SetHeight(height)
	bar.status:SetStatusBarTexture(texture)
	bar.status:SetMinMaxValues(0, 100)
	bar.status:SetFrameLevel(bar:GetFrameLevel()-1)
	
	bar.left = CreateFS(bar)
	bar.left:SetPoint('LEFT', bar.status, 3, 0)
	bar.left:SetJustifyH('LEFT')
	
	bar.right = CreateFS(bar)
	bar.right:SetPoint('RIGHT', bar.status, -2, 0)
	bar.right:SetJustifyH('RIGHT')
	
	bar.status.bg = CreateFrame("Frame", nil, bar.status)
	bar.status.bg:SetPoint("TOPLEFT", -1, 1)
	bar.status.bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bar.status.bg:SetFrameLevel(bar:GetFrameLevel()-1)
	bar.status.bg:SetBackdrop(backdrop)
	bar.status.bg:SetBackdropColor(0,0,0,0.3)
	bar.status.bg:SetBackdropBorderColor(0,0,0,1)
	
	return bar
end

local StartTimer = function(name, spellId)
	local spell, rank, icon = GetSpellInfo(spellId)
	for _, v in pairs(bars) do
		if v.name == name and v.spell == spell then
			return
		end
	end
	local bar = CreateBar()
	bar.endTime = GetTime() + spells[spellId]
	bar.startTime = GetTime()
	bar.left:SetText(name)
	bar.name = name
	bar.right:SetText(FormatTime(spells[spellId]))
	if icon and bar.icon then
		bar.icon:SetNormalTexture(icon)
		bar.icon:GetNormalTexture():SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end
	bar.spell = spell
	bar:Show()
	local color = CUSTOM_CLASS_COLORS[select(2, UnitClass(name))]
	bar.status:SetStatusBarColor(color.r, color.g, color.b)
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	tinsert(bars, bar)
	UpdatePositions()
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if not enabled then
			self:UnregisterAllEvents()
			return
		end
		local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags = ...
		if band(sourceFlags, filter) == 0 then return end
		if eventType == "SPELL_RESURRECT" or eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" then
			local spellId = select(12, ...)
			if spells[spellId] and show[select(2, IsInInstance())] then
				StartTimer(sourceName, spellId)
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" and select(2, IsInInstance()) == "arena" then
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end

local addon = CreateFrame("frame")
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")

SlashCmdList["RaidCD"] = function(msg) 
	StartTimer(UnitName('player'), 740)
	StartTimer(UnitName('player'), 115310)
	StartTimer(UnitName('player'), 108280)
end
SLASH_RaidCD1 = "/raidcd"