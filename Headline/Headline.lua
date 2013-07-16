local FONT
local TEXTURE

if IsAddOnLoaded("HeadlineCustomOptions") then
	FONT = HeadlineCustomOptions:GetFont()
	TEXTURE = HeadlineCustomOptions:GetTexture()
else
	FONT = [=[Interface\AddOns\Sharedmedia\fonts\font.ttf]=]
	TEXTURE = [=[Interface\AddOns\SharedMedia\statusbar\statusbar]=]
end

local combat = false

local numChildren = -1
local frames = {}
local activeFrames = {}

local function debuginfo(region)
	if(region)then
		print(region:GetObjectType())
	else
		print("empty")
	end
end

local function QueueObject(parent, object)
	parent.queue = parent.queue or {}
	parent.queue[object] = true
end

local function QueueCastBar(parent, object)
	parent.queuecb = parent.queuecb or {}
	parent.queuecb[object] = true
end

local function HideObjects(parent)
	parent, _ = parent:GetChildren()
	for object in pairs(parent.queue) do
		if(object:GetObjectType() == 'Texture') then
			object:SetTexture(EMPTY_TEXTURE)
		else
			object:Hide()
		end
	end
end

local function HideCastBar(parent)
	for object in pairs(parent.queuecb) do
		if(object:GetObjectType() == 'Texture') then
			object:SetTexture(EMPTY_TEXTURE)
		else
			object:Hide()
		end
	end
end

local function UpdatePlates(frame)
	local barFrames = frame.barFrames
	local nameFrame = frame.nameFrame
	
	if(HeadlineGlobalSettings.target) then
		if(UnitName('target') and frame:GetAlpha() == 1) then
			barFrames.bg:SetTexture(0, 0, 0)
		else
			barFrames.bg:SetTexture(0, 0, 0)
		end
	end
	if(barFrames.hostile) then
		local red, green, blue = nameFrame.name:GetTextColor()
		local tapped = ((red > 0.50) and (red < 0.51)) and ((green > 0.50) and (green < 0.51)) and ((blue > 0.50) and (blue < 0.51)) --abit extreme but just to make sure.
		if(tapped == false) then
			if(combat) then
				if(frame.region:IsShown()) then
					local r, g, b = frame.region:GetVertexColor() --threat border around frame
					if(g + b == 0) then
						barFrames.hp:SetStatusBarColor(1, 0, 0)
					else
						barFrames.hp:SetStatusBarColor(1, 1, 0.3)
					end
				else
					barFrames.hp:SetStatusBarColor(0.3, 1, 0.3)
				end
			else
				barFrames.hp:SetStatusBarColor(1, 0, 0)
			end
		end
	end
end

local function UpdateObjects(frame)
	activeFrames[frame] = true
	local barFrames = frame.barFrames
	local nameFrame = frame.nameFrame
	
	-- Fix text on tiny plates to be 1:1 scale
	nameFrame:SetScale(1)
	
	-- Most probably will need to set the scale of small cast bar text aswell...
	
	-- Redo the frame offsets as they're reused - need this until tiny plates are disabled...
	local offset = UIParent:GetScale() / barFrames.hp:GetEffectiveScale()
	barFrames.bg:SetPoint('BOTTOMRIGHT', offset, -offset)
	barFrames.bg:SetPoint('TOPLEFT', -offset, offset)
	
	local r, g, b = barFrames.hp:GetStatusBarColor()
	barFrames.hostile = g + b == 0
	
	barFrames.hp:SetHeight(HeadlineGlobalSettings.height)
	barFrames.hp:SetWidth(HeadlineGlobalSettings.width)
	barFrames.hp:ClearAllPoints()
	barFrames.hp:SetPoint('CENTER', barFrames)
	
	if(HeadlineGlobalSettings.level) then
		local r, g, b = barFrames.level:GetTextColor()
		if(barFrames.bossicon:IsShown()) then
			nameFrame.name:SetText('|cffff0000??|r ' .. nameFrame.name:GetText())
		else
			nameFrame.name:SetText(format('|cff%02x%02x%02x', r*255, g*255, b*255) .. (barFrames.elite:IsShown() and '+' or '') .. tonumber(barFrames.level:GetText()) .. '|r ' .. nameFrame.name:GetText())
		end
	-- Why was this ever here...
	-- else
		-- nameFrame.name:SetText(nameFrame.name:GetText())
	end
	HideObjects(frame)
end

local function UpdateCastbar(bar)
	-- Redo the frame offsets as they're reused - need this until tiny plates are disabled...
	local offset = UIParent:GetScale() / bar:GetEffectiveScale()
	bar.bg:SetPoint('BOTTOMRIGHT', offset, -offset)
	bar.bg:SetPoint('TOPLEFT', -offset, offset)
	
	bar:SetHeight(HeadlineGlobalSettings.height)
	bar:SetWidth(HeadlineGlobalSettings.width)
	bar:ClearAllPoints()
	bar:SetPoint('TOP', bar:GetParent().hp, 'BOTTOM', 0, -5)
	bar.icon:SetHeight((HeadlineGlobalSettings.height * 2) + 5)
	bar.icon:SetWidth((HeadlineGlobalSettings.height * 2) + 5)
	bar.icon:ClearAllPoints()
	bar.icon:SetPoint('BOTTOMLEFT', bar, 'BOTTOMRIGHT', 2, 0)
	-- Color Castbar
	if(bar.shield:IsShown()) then
		-- bar:SetStatusBarColor(1, 0.35, 0.2)
		bar:SetStatusBarColor(1, 1, 1)
	end
	HideCastBar(bar)
end	

local function StopUpdates(f)
	activeFrames[f] = nil
end

local function SkinObjects(f)
	f.barFrames, f.nameFrame = f:GetChildren()
	
	local level, bossicon, elite
	
	-- Status Bars --
	f.barFrames.hp, f.barFrames.cb = f.barFrames:GetChildren()
	f.barFrames.threat, f.barFrames.hpborder, f.barFrames.overlay, level, bossicon, f.barFrames.raidicon, elite = f.barFrames:GetRegions()
	_, f.barFrames.cb.border, f.barFrames.cb.shield, f.barFrames.cb.icon, f.barFrames.cb.spell, f.barFrames.cb.spellbg = f.barFrames.cb:GetRegions()

	-- Health Bar --
	local offset = UIParent:GetScale() / f.barFrames.hp:GetEffectiveScale()
	
	local hpbg = f.barFrames.hp:CreateTexture(nil, 'BACKGROUND')
	hpbg:SetPoint('BOTTOMRIGHT', offset, -offset)
	hpbg:SetPoint('TOPLEFT', -offset, offset)
	hpbg:SetTexture(0, 0, 0)
	f.barFrames.bg = hpbg

	local hpbg2 = f.barFrames.hp:CreateTexture(nil, 'BORDER')
	hpbg2:SetAllPoints(f.barFrames.hp)
	--hpbg2:SetTexture(1/3, 1/3, 1/3)
	hpbg2:SetTexture(1/5, 1/5, 1/5)

	f:HookScript('OnShow', UpdateObjects)
	f:HookScript('OnHide', StopUpdates)
	f.barFrames.hp:SetStatusBarTexture(TEXTURE)

	-- Cast Bar --
	offset = UIParent:GetScale() / f.barFrames.cb:GetEffectiveScale()
	
	local cbbg = f.barFrames.cb:CreateTexture(nil, 'BACKGROUND')
	cbbg:SetPoint('BOTTOMRIGHT', offset, -offset)
	cbbg:SetPoint('TOPLEFT', -offset, offset)
	cbbg:SetTexture(0, 0, 0)
	f.barFrames.cb.bg = cbbg

	local cbbg2 = f.barFrames.cb:CreateTexture(nil, 'BORDER')
	cbbg2:SetAllPoints(f.barFrames.cb)
	--cbbg2:SetTexture(1/3, 1/3, 1/3)
	cbbg2:SetTexture(1/5, 1/5, 1/5)
	
	f.barFrames.cb:HookScript('OnShow', UpdateCastbar)
	f.barFrames.cb:HookScript('OnSizeChanged', UpdateCastbar)
	f.barFrames.cb:HookScript('OnUpdate', UpdateCastbar)

	f.barFrames.cb:SetStatusBarTexture(TEXTURE)
	
	-- Spell Name --
	f.barFrames.cb.spell:SetPoint('TOPLEFT', f.barFrames.cb, 'BOTTOMLEFT', 0, -2)
	f.barFrames.cb.spell:SetPoint('TOPRIGHT', f.barFrames.cb, 'BOTTOMRIGHT', 0, -2)
	f.barFrames.cb.spell:SetFont(FONT, HeadlineGlobalSettings.fsize, HeadlineGlobalSettings.foutline)
	f.barFrames.cb.spell:SetShadowOffset(0, 0)
	
	-- Name Bar --
	f.nameFrame.name = f.nameFrame:GetRegions()
	f.nameFrame.name:SetPoint('BOTTOMLEFT', f.barFrames.hp, 'TOPLEFT', 1, 0)
	f.nameFrame.name:SetPoint('BOTTOMRIGHT', f.barFrames.hp, 'TOPRIGHT', 2, 0)
	f.nameFrame.name:SetFont(FONT, HeadlineGlobalSettings.fsize, HeadlineGlobalSettings.foutline)
	f.nameFrame.name:SetJustifyH("LEFT")
	f.nameFrame.name:SetShadowOffset(0, 0)
	
	-- Raid Icon --
	f.barFrames.raidicon:ClearAllPoints()
	f.barFrames.raidicon:SetPoint('TOP', f.barFrames.hp, 'TOP', 0, 35)
	f.barFrames.raidicon:SetSize(30, 30)
	
	if(HeadlineGlobalSettings.level) then
		f.barFrames.bossicon = bossicon
		f.barFrames.elite = elite
		f.barFrames.level = level
	end
	
	-- Old Level Text -- 
	level:SetWidth(1) --Stops the level text showing up on level ups and getting drunk/sober.
	
	-- Hide Blizzard panel and icon
	QueueObject(f.barFrames, f.barFrames.threat)
	QueueObject(f.barFrames, f.barFrames.hpborder)
	QueueObject(f.barFrames, f.barFrames.overlay)
	QueueObject(f.barFrames, level)
	QueueObject(f.barFrames, bossicon)
	QueueObject(f.barFrames, elite)
	
	QueueCastBar(f.barFrames.cb, f.barFrames.cb.border)
	QueueCastBar(f.barFrames.cb, f.barFrames.cb.shield)
	QueueCastBar(f.barFrames.cb, f.barFrames.cb.spellbg)
	-- QueueCastBar(cb, cbicon)

	UpdateObjects(f)

	UpdateCastbar(f.barFrames.cb)
	
	activeFrames[f] = true
	frames[f] = true
end

local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		if( not frames[frame] and frame:GetName() and frame:GetName():find("NamePlate%d") ) then
			frame.region = frame:GetChildren():GetRegions()
			SkinObjects(frame)
		end
	end
end

local f = CreateFrame'Frame'
f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('PLAYER_REGEN_ENABLED')
f:RegisterEvent('PLAYER_REGEN_DISABLED')

local temp = nil
local WorldFrame = WorldFrame

f:SetScript('OnUpdate', function(self, elapsed)
	temp = WorldFrame:GetNumChildren()
	if(temp ~= numChildren) then
		numChildren = temp
		HookFrames(WorldFrame:GetChildren())
	end	
	
	if(self.elapsed and self.elapsed > 0.1) then
		for frame in pairs(activeFrames) do
			UpdatePlates(frame)
		end
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end)

f:SetScript('OnEvent', function(self, e, name) 
	if(e == 'PLAYER_REGEN_DISABLED') then
		combat = true
	elseif(e == 'PLAYER_REGEN_ENABLED') then
		combat = false
	elseif(name == 'Headline' and e == 'ADDON_LOADED') then
		if not HeadlineGlobalSettings then
			HeadlineGlobalSettings = { width = 110, height = 5, fsize = 9, foutline = "OUTLINE", level = true, target = true }
		elseif not HeadlineGlobalSettings.foutline then
			print("Headline updated with new font outline option. /headline to find out more..")
			HeadlineGlobalSettings.foutline = "OUTLINE"
		end
		SetCVar('ShowClassColorInNameplate', 1)
		SetCVar('bloattest', 0)
	--	SetCVar('spreadnameplates', 0)
		SetCVar('bloatnameplates', 0)
		SetCVar('bloatthreat', 0)
	end
end)

SLASH_HEADLINE1 = '/headline';
function SlashCmdList.HEADLINE(args)
	local arg = string.split(' ', args):lower() or args:lower()
	if(arg == 'width') then
		arg = tonumber(select(2, string.split(' ', args)))
		if(arg and arg > 49 and arg < 301) then
			HeadlineGlobalSettings.width = arg
			ReloadUI()
		end
	elseif(arg == 'height') then
		arg = tonumber(select(2, string.split(' ', args)))
		if(arg and arg > 1 and arg < 51) then
			HeadlineGlobalSettings.height = arg
			ReloadUI()
		end
	elseif(arg == 'fontsize') then
		arg = tonumber(select(2, string.split(' ', args)))
		if(arg and arg > 4 and arg < 31) then
			HeadlineGlobalSettings.fsize = arg
			ReloadUI()
		end
	elseif(arg == 'level') then
		HeadlineGlobalSettings.level = not HeadlineGlobalSettings.level
		ReloadUI()
	elseif(arg == 'target') then
		HeadlineGlobalSettings.target = not HeadlineGlobalSettings.target
		ReloadUI()
	elseif(arg == 'fontoutline') then
		if HeadlineGlobalSettings.foutline == "OUTLINE" then
			HeadlineGlobalSettings.foutline = "MONOCHROMEOUTLINE"
		else
			HeadlineGlobalSettings.foutline = "OUTLINE"
		end
		ReloadUI()
	else
		print('Headline')
		print(' - |cFF33FF99width <num>|r: current width is '..HeadlineGlobalSettings.width)
		print(' - |cFF33FF99height <num>|r: current height is '..HeadlineGlobalSettings.height)
		print(' - |cFF33FF99fontsize <num>|r: current font size is '..HeadlineGlobalSettings.fsize)
		print(' - |cFF33FF99fontoutline|r: toggles the font outline between normal and monochrome(for pixel fonts). The current font outline is '..HeadlineGlobalSettings.foutline)
		print(' - |cFF33FF99level|r: toggles the level display')
		print(' - |cFF33FF99target|r: amplify target display')
	end
end