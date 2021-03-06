local _, ns = ...

local mediapath = "Interface\\AddOns\\SharedMedia\\"
local cfg = {
	font = mediapath.."fonts\\font2.ttf",
	fontsize = 12, -- I'd suggest adjusting the scale instead of the fontsize
	outline = "OUTLINE",
	tex = mediapath.."statusbar\\statusbar",

	scale = .9,
	point = { "BOTTOMRIGHT",  "BOTTOMRIGHT", -25, 25}, -- use "/freebtip" instead
	cursor = false,

	hideTitles = true,
	hideRealm = false,
	hideFaction = true,
	hidePvP = true,

	backdrop = {
		bgFile = "Interface\\Buttons\\WHITE8x8",
		-- original look
		edgeFile = "Interface\ChatFrame\ChatFrameBackground",
		tile = true,
		tileSize = 16,
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },

		-- glow border
		-- edgeFile = mediapath.."glowTex",
		-- tile = false,
		-- tileSize = 16,
		-- edgeSize = 4,
		-- insets = { left = 4, right = 4, top = 4, bottom = 4 },
	},
	-- original
	bgcolor = { r=0, g=0, b=0, t=0.8 }, -- background
	bdrcolor = { r=0, g=0, b=0 }, -- border
	--
	-- glow border
	-- bgcolor = { r=0.05, g=0.05, b=0.05, t=1 }, -- background
	-- bdrcolor = { r=0.02, g=0.02, b=0.02 }, -- border

	gcolor = { r=1, g=0.1, b=0.8 }, -- guild

	you = "<You>",
	boss = "??",

	colorborderClass = false,

	combathide = false,     -- world objects
	combathideALL = false,  -- everything

	multiTip = true, -- show more than one linked item tooltip

	hideHealthbar = false,

	powerbar = false, -- enable power bars
	powerManaOnly = true, -- only show mana users

	showRank = false, -- show guild rank

	showTalents = false, -- inspect errors unless InspectFix (http://www.curse.com/addons/wow/inspectfix) is installed.
	tcacheTime = 900, -- talent cache time in seconds (default 15 mins)
}
ns.cfg = cfg

local GetTime = GetTime
local tonumber = tonumber
local select = select
local _G = _G
local GameTooltip = GameTooltip
local PVP = PVP
local FACTION_ALLIANCE = FACTION_ALLIANCE
local FACTION_HORDE = FACTION_HORDE
local LEVEL = LEVEL
local ICON_LIST = ICON_LIST
local targettext = TARGET..":"

local talentcache = {}
local talenttext = TALENTS..":"
local talentcolor = "|cffFFFFFF"

local colors = {power = {}}
for power, color in next, PowerBarColor do
	if(type(power) == 'string') then
		colors.power[power] = {color.r, color.g, color.b}
	end
end

colors.power['MANA'] = {.31,.45,.63}
colors.power['RAGE'] = {.69,.31,.31}

local classification = {
	elite = "+",
	rare = " R",
	rareelite = " R+",
}

local numberize = function(val)
	if (val >= 1e6) then
		return ("%.1fm"):format(val / 1e6)
	elseif (val >= 1e3) then
		return ("%.1fk"):format(val / 1e3)
	else
		return ("%d"):format(val)
	end
end

local find = string.find
local format = string.format
local hex = function(color)
	return format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end

local function unitColor(unit)
	local color = { r=1, g=1, b=1 }
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		color = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class]) or RAID_CLASS_COLORS[class]
	else
		local reaction = UnitReaction(unit, "player")
		if reaction then
			color = FACTION_BAR_COLORS[reaction]
		end
	end
	return color
end

function GameTooltip_UnitColor(unit)
	local color = unitColor(unit)
	return color.r, color.g, color.b
end

local function getTarget(unit)
	if UnitIsUnit(unit, "player") then
		return ("|cffff0000%s|r"):format(cfg.you)
	else
		return hex(unitColor(unit))..UnitName(unit).."|r"
	end
end

local function UpdatePower()
	return function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed < .25 then return end

		local unit = self.unit
		if(unit) then
			local min, max = UnitPower(unit), UnitPowerMax(unit)
			if(max ~= 0) then
				self:SetValue(min)

				local pp = numberize(min).." / "..numberize(max)
				self.text:SetText(pp)
			end
		end

		self.elapsed = 0
	end
end

local function HidePower(powerbar)
	if powerbar then 
		powerbar:Hide() 

		if powerbar.text then
			powerbar.text:SetText(nil)
		end
	end
end

local function ShowPowerBar(self, unit, statusbar)
	local powerbar = _G[self:GetName().."FreebTipPowerBar"]
	if not unit then return HidePower(powerbar) end

	local min, max = UnitPower(unit), UnitPowerMax(unit)
	local ptype, ptoken = UnitPowerType(unit)

	if(max == 0 or (cfg.powerManaOnly and ptoken ~= 'MANA')) then
		return HidePower(powerbar)
	end

	if(not powerbar) then
		powerbar = CreateFrame("StatusBar", self:GetName().."FreebTipPowerBar", statusbar)
		powerbar:SetHeight(statusbar:GetHeight())
		powerbar:SetWidth(0)
		powerbar:SetStatusBarTexture(cfg.tex, "OVERLAY")
		powerbar.elapsed = 0
		powerbar:SetScript("OnUpdate", UpdatePower())

		local bg = powerbar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(powerbar)
		bg:SetTexture(cfg.tex)
		bg:SetVertexColor(0.3, 0.3, 0.3, 0.5)
	end
	powerbar.unit = unit

	powerbar:SetMinMaxValues(0, max)
	powerbar:SetValue(min)

	local pcolor = colors.power[ptoken]
	if(pcolor) then
		powerbar:SetStatusBarColor(pcolor[1], pcolor[2], pcolor[3])
	end

	powerbar:SetPoint("LEFT", statusbar, "LEFT", 0, -(statusbar:GetHeight()) - 5)
	powerbar:SetPoint("RIGHT", self, "RIGHT", -9, 0)

	self:AddLine(" ")
	powerbar:Show()

	if(not powerbar.text) then
		powerbar.text = powerbar:CreateFontString(nil, "OVERLAY")
		powerbar.text:SetPoint("CENTER", powerbar)
		powerbar.text:SetFont(cfg.font, 12, cfg.outline)
		powerbar.text:Show()
	end

	local pp = numberize(min).." / "..numberize(max)
	powerbar.text:SetText(pp)
end

local talentGUID
local talentevent = CreateFrame"Frame"

local function updateTalents(spec)
	for i=3, GameTooltip:NumLines() do
		local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()

		if linetext and linetext:find(talenttext) then
			_G["GameTooltipTextRight"..i]:SetText(spec)
		end
	end
end

local function ShowTalents(self, unit, isUpdate)
	if not UnitIsPlayer(unit) then return end
	
	local mGUID = UnitGUID("mouseover")
	local uGUID = UnitGUID(unit)

	if uGUID ~= mGUID then return end
	if not isUpdate then
		self:AddDoubleLine(talenttext, talentcolor.."      ...")
	end
	
	if talentcache[uGUID] then
		-- check to see how old the talentcache is
		if(GetTime() - talentcache[uGUID].time) > cfg.tcacheTime then
			talentcache[uGUID] = nil

			return ShowTalents(self, unit)
		end

		local talname = talentcache[uGUID].talent
		updateTalents(talentcolor..talname)
	else
		local canInspect = CanInspect(unit)
		if(not canInspect) or (InspectFrame and InspectFrame:IsShown()) then return end
		talentGUID = uGUID
		talentevent:RegisterEvent"INSPECT_READY"
		
		NotifyInspect(unit)
	end
end

talentevent:SetScript("OnEvent", function(self, event, arg1)
	if event == "INSPECT_READY" then
		if arg1 ~= talentGUID then return end

		local activeSpec = GetInspectSpecialization("mouseover")
		local name = activeSpec and select(2, GetSpecializationInfoByID(activeSpec))

		if InspectFrame and (not InspectFrame:IsShown()) then
			ClearInspectPlayer()
		end
		
		if name then
			talentcache[arg1] = {talent = name,time = GetTime()}
			
			if GameTooltip:IsShown() then
				ShowTalents(GameTooltip, "mouseover", true)
			end
		end

		self:UnregisterEvent"INSPECT_READY"
	end
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local name, unit = self:GetUnit()

	if unit then
		if cfg.combathide and InCombatLockdown() then
			return self:Hide()
		end	

		local isPlayer = UnitIsPlayer(unit)
		local unitGuild, unitRank = GetGuildInfo(unit)
		if isPlayer then
			if cfg.hideTitles and cfg.hideRealm then
				local unitName = GetUnitName(unit)
				if unitName then GameTooltipTextLeft1:SetText(unitName) end
			elseif cfg.hideTitles then
				local unitName = GetUnitName(unit, true)
				if unitName then GameTooltipTextLeft1:SetText(unitName) end
			elseif cfg.hideRealm then
				local _, realm = UnitName(unit)
				if realm then
					local text = GameTooltipTextLeft1:GetText()
					text = text:gsub("- "..realm, "")
					if text then GameTooltipTextLeft1:SetText(text) end
				end
			end

			if UnitIsAFK(unit) then
				self:AppendText(" |cff00cc00AFK|r")
			end	
			if UnitIsDND(unit) then 
				self:AppendText(" |cff00cc00DND|r")				
			end
			if UnitIsConnected(unit) == false then
				self:AppendText(" |cffBFBFBFDC|r")
			else
				self:AppendText(" ")
			end		

			local text2 = GameTooltipTextLeft2:GetText()
			if unitGuild and text2 and text2:find("^"..unitGuild) then	
				GameTooltipTextLeft2:SetTextColor(cfg.gcolor.r, cfg.gcolor.g, cfg.gcolor.b)
				if cfg.showRank and unitRank then
					GameTooltipTextLeft2:SetText(("%s (|cff00FCCC%s|r)"):format(unitGuild, unitRank))
				end
			end
		end
		
		-- if UnitFactionGroup(unit) then
			-- GameTooltipTextLeft1:SetText('|TInterface\\TargetingFrame\\UI-PVP-'..select(1, UnitFactionGroup(unit))..'.blp:16:16:-2:0:64:64:0:40:0:40|t'..GameTooltipTextLeft1:GetText())
			-- for i = 1, GameTooltip:NumLines() do
				-- if _G["GameTooltipTextLeft"..i]:GetText():find(select(2, UnitFactionGroup(unit))) then
				-- end
			-- end
		-- end
		
		local ricon = GetRaidTargetIndex(unit)
		if ricon then
			local text = GameTooltipTextLeft1:GetText()
			GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[ricon]..cfg.fontsize.."|t", text))
		end

		local alive = not UnitIsDeadOrGhost(unit)
		local level = UnitLevel(unit)
		local color = unitColor(unit)

		if level then
			local unitClass = isPlayer and hex(color)..UnitClass(unit).."|r" or ""
			local creature = not isPlayer and UnitCreatureType(unit) or ""
			local diff = GetQuestDifficultyColor(level)

			if level == -1 then
				level = "|cffff0000"..cfg.boss
			end

			local classify = UnitClassification(unit)
			local textLevel = ("%s%s%s|r"):format(hex(diff), tostring(level), classification[classify] or "")

			for i=(unitGuild and 3 or 2), self:NumLines() do
				local tiptext = _G["GameTooltipTextLeft"..i]
				if tiptext:GetText():find(LEVEL) then
					if alive then
						tiptext:SetText(("%s %s%s"):format(textLevel, creature, UnitRace(unit) or ""):trim())
					else
						tiptext:SetText(("%s %s"):format(textLevel, "|cffCCCCCC"..DEAD.."|r"):trim())
					end
				end
			end
		end	

		-- if UnitExists(unit.."target") then
			-- local tarRicon = GetRaidTargetIndex(unit.."target")
			-- local tartext, tar = targettext, ("%s %s"):format((tarRicon and ICON_LIST[tarRicon].."10|t") or 
			-- "", getTarget(unit.."target"))
			-- self:AddDoubleLine(tartext, tar)
		-- end
		
		 if UnitExists(unit.."target") then
            local tartext = ("%s: %s"):format(TARGET, getTarget(unit.."target"))
            self:AddLine(tartext)
        end

		if cfg.showTalents and isPlayer and tonumber(level) > 9 then
			ShowTalents(self, unit)
		end

		if not alive or cfg.hideHealthbar then
			GameTooltipStatusBar:Hide()
		else
			GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)
		end
	else
		GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
	end

	for i=3, self:NumLines() do
		local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()

		if linetext:find(PVP) then
			if cfg.hidePvP then
				tiptext:SetText(nil)
			else
				tiptext:SetText("|cff00FF00"..linetext.."|r")
			end
		elseif linetext:find(FACTION_ALLIANCE) then
			if cfg.hideFaction then
				tiptext:SetText(nil)
			else
				tiptext:SetText("|cff7788FF"..linetext.."|r")
			end
		elseif linetext:find(FACTION_HORDE) then
			if cfg.hideFaction then
				tiptext:SetText(nil)
			else
				tiptext:SetText("|cffFF4444"..linetext.."|r")
			end
		end
	end

	if GameTooltipStatusBar:IsShown() then
		self:AddLine(" ")
		GameTooltipStatusBar:ClearAllPoints()
		GameTooltipStatusBar:SetPoint("LEFT", self:GetName().."TextLeft"..self:NumLines(), "LEFT", 0, 0)
		GameTooltipStatusBar:SetPoint("RIGHT", self, -9, 0)

		if cfg.powerbar then
			ShowPowerBar(self, unit, GameTooltipStatusBar)
		end
	end
end)

GameTooltipStatusBar:SetStatusBarTexture(cfg.tex)
local bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(GameTooltipStatusBar)
bg:SetTexture(cfg.tex)
bg:SetVertexColor(0.3, 0.3, 0.3, 0.5)

GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
	if not value then
		return
	end
	local min, max = self:GetMinMaxValues()
	if (value < min) or (value > max) then
		return
	end
	local _, unit = GameTooltip:GetUnit()
	if unit then
		min, max = UnitHealth(unit), UnitHealthMax(unit)
		if not self.text then
			self.text = self:CreateFontString(nil, "OVERLAY")
			self.text:SetPoint("CENTER", GameTooltipStatusBar)
			self.text:SetFont(cfg.font, cfg.fontsize, cfg.outline)
			self.text:SetAlpha(0)
		end
		self.text:Show()
		local hp = numberize(min).." / "..numberize(max)
		self.text:SetText(hp)
	end
end)

local function setBakdrop(frame)
	frame:SetBackdrop(cfg.backdrop)
	frame:SetScale(cfg.scale)

	frame.freebBak = true
end

local function style(frame)
	if not frame.freebBak then
		setBakdrop(frame)
	end

	frame:SetBackdropColor(cfg.bgcolor.r, cfg.bgcolor.g, cfg.bgcolor.b, cfg.bgcolor.t)
	frame:SetBackdropBorderColor(cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b)

	-- if frame.GetItem then
		-- local _, item = frame:GetItem()
		-- if item then
			-- local quality = select(3, GetItemInfo(item))
			-- if(quality) then
				-- local r, g, b = GetItemQualityColor(quality)
				-- frame:SetBackdropBorderColor(r, g, b)
			-- end
		-- else
			-- frame:SetBackdropBorderColor(cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b)
		-- end
	-- end

	if cfg.colorborderClass then
		local _, unit = GameTooltip:GetUnit()
		if UnitIsPlayer(unit) then
			frame:SetBackdropBorderColor(GameTooltip_UnitColor(unit))
		end
	end

	if frame.NumLines then
		for index=1, frame:NumLines() do
			local frameName = frame:GetName()
			if index == 1 then
				_G[frameName..'TextLeft'..index]:SetFont(cfg.font, cfg.fontsize+2, cfg.outline)
			else
				_G[frameName..'TextLeft'..index]:SetFont(cfg.font, cfg.fontsize, cfg.outline)
			end
			_G[frameName..'TextRight'..index]:SetFont(cfg.font, cfg.fontsize, cfg.outline)

			if _G[frameName..'MoneyFrame'..index.."PrefixText"] then
				_G[frameName..'MoneyFrame'..index.."PrefixText"]:SetFont(cfg.font, cfg.fontsize, cfg.outline)
				_G[frameName..'MoneyFrame'..index.."SuffixText"]:SetFont(cfg.font, cfg.fontsize, cfg.outline)
				_G[frameName..'MoneyFrame'..index.."GoldButton"]:SetNormalFontObject("GameTooltipText")
				_G[frameName..'MoneyFrame'..index.."SilverButton"]:SetNormalFontObject("GameTooltipText")
				_G[frameName..'MoneyFrame'..index.."CopperButton"]:SetNormalFontObject("GameTooltipText")
			end
		end
	end
end

ns.style = style

for i = 1, 3 do
	UIDropDownMenu_CreateFrames(i,i)
end

local tooltips = {
	GameTooltip,
	ItemRefTooltip,
	ShoppingTooltip1,
	ShoppingTooltip2, 
	ShoppingTooltip3,
	WorldMapTooltip,
	DropDownList1MenuBackdrop, 
	DropDownList2MenuBackdrop,
	DropDownList3MenuBackdrop,
	AutoCompleteBox,
}

for i, frame in ipairs(tooltips) do
	frame:SetScript("OnShow", function(frame)
		if(cfg.combathideALL and InCombatLockdown()) then
			return frame:Hide()
		end

		style(frame) 
	end)
end

local itemrefScripts = {
	"OnTooltipSetItem",
	"OnTooltipSetAchievement",
	"OnTooltipSetQuest",
	"OnTooltipSetSpell",
}

for i, script in ipairs(itemrefScripts) do
	ItemRefTooltip:HookScript(script, function(self)
		style(self)
	end)
end

local f = CreateFrame"Frame"
f:SetScript("OnEvent", function(self, event, ...) if ns[event] then return ns[event](ns, event, ...) end end)
function ns:RegisterEvent(...) for i=1,select("#", ...) do f:RegisterEvent((select(i, ...))) end end
function ns:UnregisterEvent(...) for i=1,select("#", ...) do f:UnregisterEvent((select(i, ...))) end end

ns:RegisterEvent"PLAYER_LOGIN"
function ns:PLAYER_LOGIN()
	for i, frame in ipairs(tooltips) do
		setBakdrop(frame)
	end

	ns:UnregisterEvent"PLAYER_LOGIN"
end
