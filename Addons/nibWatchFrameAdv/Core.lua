local Opts = nibWatchFrameAdv_Cfg

local nWFA = CreateFrame("Frame")
local EventsRegistered

local _
local WF
local OrigWFSetPoint, OrigWFClearAllPoints
local origWFHighlight
local WFColorsHooked = false

local class, classColor
local titleColor
local lineColor
local dashColor

-- Quest / achievement link URLs
local linkSiteTitle = "Wowhead"
local linkQuest = "http://www.wowhead.com/quest=%d"
local linkAchievement = "http://www.wowhead.com/achievement=%d"

function nWFA.CreateBD(frame, alpha)
	frame:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8X8]], 
		edgeFile = [[Interface\Buttons\WHITE8X8]], 
		edgeSize = 1, 
	})
	frame:SetBackdropColor(0.15, 0.15, 0.15)
	frame:SetBackdropBorderColor(0, 0, 0)
end

function nWFA.SkinButton(button, icon, border)
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	icon:SetPoint("TOPLEFT", 3, -3)
	icon:SetPoint("BOTTOMRIGHT", -3, 3)

	border:SetTexture(nil)

	local bd1 = CreateFrame("Frame", nil, button)
	bd1:SetPoint("TOPLEFT", button, 2, -2)
	bd1:SetPoint("BOTTOMRIGHT", button, -2, 2)
	bd1:SetFrameLevel(1)
	nWFA.CreateBD(bd1, 0)

	local bd2 = CreateFrame("Frame", nil, button)
	bd2:SetPoint("TOPLEFT", button, 0, 0)
	bd2:SetPoint("BOTTOMRIGHT", button, 0, 0)
	bd2:SetFrameLevel(1)
	nWFA.CreateBD(bd2, 0)
	bd2:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
end

-- Hide Quest Tracker based on zone
function nWFA.UpdateHideState()
	if not WF then WF = _G["WatchFrame"] end
	
	local Inst, InstType = IsInInstance()
	local Hide = false
	if Opts.hidden.enabled and Inst then
		if (InstType == "pvp" and Opts.hidden.hide.pvp) then			-- Battlegrounds
			Hide = true
		elseif (InstType == "arena" and Opts.hidden.hide.arena) then	-- Arena
			Hide = true
		elseif (InstType == "party" and Opts.hidden.hide.party) then	-- 5 Man Dungeons
			Hide = true
		elseif (InstType == "raid" and Opts.hidden.hide.raid) then	-- Raid Dungeons
			Hide = true
		end
	end
	if Hide then WF:Hide() else WF:Show() end
end

-- Collapse Quest Tracker based on zone
function nWFA.UpdateCollapseState()
	if not WF then WF = _G["WatchFrame"] end
	if not Opts.hidden.enabled then return end
	
	local Inst, InstType = IsInInstance()
	local Collapsed = false
	if Inst then
		if (InstType == "pvp" and Opts.hidden.collapse.pvp) then			-- Battlegrounds
			Collapsed = true
		elseif (InstType == "arena" and Opts.hidden.collapse.arena) then	-- Arena
			Collapsed = true
		elseif (InstType == "party" and Opts.hidden.collapse.party) then	-- 5 Man Dungeons
			Collapsed = true
		elseif (InstType == "raid" and Opts.hidden.collapse.raid) then	-- Raid Dungeons
			Collapsed = true
		end
	end
	
	if Collapsed then
		WF.userCollapsed = true
		WatchFrame_Collapse(WF)
	else
		WF.userCollapsed = false
		WatchFrame_Expand(WF)
	end	
end

-- Update font
function nWFA.UpdateFont()
	local nextline = 1

	WatchFrameTitle:SetFont(Opts.font.path, Opts.font.size, Opts.font.outline)
	WatchFrameTitle:SetShadowColor(0, 0, 0, Opts.font.shadow and 1 or 0)

	hooksecurefunc("WatchFrame_Update", function()
		for i = nextline, 50 do
			local line = _G["WatchFrameLine"..i]
			if line then
				line.text:SetFont(Opts.font.path, Opts.font.size, Opts.font.outline)
				line.text:SetSpacing(Opts.font.linespacing)
				line.text:SetShadowColor(0, 0, 0, Opts.font.shadow and 1 or 0)
				
				line.dash:SetFont(Opts.font.path, Opts.font.size, Opts.font.outline)
				line.dash:SetShadowColor(0, 0, 0, Opts.font.shadow and 1 or 0)
				
				if Opts.colors.enabled and Opts.colors.dashToSquare then
					line.dash:SetTextColor(0, 0, 0, 0)
					
					line.square = CreateFrame("Frame", nil, line)
					line.square:SetPoint("TOPRIGHT", line, "TOPLEFT", 8 + Opts.colors.dash.xOffset, -6 + Opts.colors.dash.yOffset)
					line.square:SetSize(Opts.colors.dash.size, Opts.colors.dash.size)
					line.square:SetBackdrop({
						bgFile = "Interface\\Buttons\\WHITE8X8", 
						edgeFile = "Interface\\Buttons\\WHITE8X8", 
						edgeSize = 1, 
					})
					line.square:SetBackdropBorderColor(0, 0, 0)
					line.square:SetBackdropColor(Opts.colors.dash.normal.r, Opts.colors.dash.normal.g, Opts.colors.dash.normal.b)
					if line.hasdash then
						line.square:Show()
					else
						line.square:Hide()
					end
				end
			else
				nextline = i
				break
			end
		end
	end)
end

-- Position the Quest Tracker
function nWFA.UpdatePosition()
	if not WF then WF = _G["WatchFrame"] end
	if not Opts.position.enabled then return end
	
	if not OrigWFSetPoint then
		OrigWFSetPoint = WF.SetPoint
	else
		WF.SetPoint = OrigWFSetPoint
	end
	if not OrigWFClearAllPoints then
		OrigWFClearAllPoints = WF.ClearAllPoints
	else
		WF.ClearAllPoints = OrigWFClearAllPoints
	end
	
	WF:ClearAllPoints()
	WF:SetPoint(Opts.position.anchor, "UIParent", Opts.position.anchor, Opts.position.x, Opts.position.y)
	WF:SetHeight(UIParent:GetHeight() - Opts.position.negheightofs)
	WF.ClearAllPoints = function() end
	WF.SetPoint = function() end
	
end

-- Udate WatchFrame styling
function nWFA.UpdateStyle()
	local WFT = _G["WatchFrameTitle"]
	
	-- Header
	if Opts.colors.enabled then
		if not WFColorsHooked then nWFA.HookWFColors() end
		if WFT then	
			WFT:SetTextColor(titleColor.r, titleColor.g, titleColor.b)
		end
	end
	
	-- Update all lines
	for i = 1, #WATCHFRAME_LINKBUTTONS do
		WatchFrameLinkButtonTemplate_Highlight(WATCHFRAME_LINKBUTTONS[i], false)
	end
end

-- Hook into / replace WatchFrame functions for Colors
function nWFA.HookWFColors()
	-- Colors
	if Opts.colors.enabled then
		local lc = lineColor
		local dc = dashColor
		
		-- Hook into SetLine to change color of lines	
		hooksecurefunc("WatchFrame_SetLine", function(line, anchor, verticalOffset, isHeader, text, dash, hasItem, isComplete)
			if dash == 1 then
				line.hasdash = true
			else
				line.hasdash = false
			end
			if line.square and Opts.colors.dashToSquare then
				if line.hasdash then
					line.square:Show()
				else
					line.square:Hide()
				end
			end
			if isHeader then 
				line.text:SetTextColor(lc.n.h.r, lc.n.h.g, lc.n.h.b)
			else
				line.text:SetTextColor(lc.n.o.r, lc.n.o.g, lc.n.o.b)
			end
		end)
		
		-- Replace Highlight function
		WatchFrameLinkButtonTemplate_Highlight = function(self, onEnter)
			local line
			for index = self.startLine, self.lastLine do
				line = self.lines[index]
				if line then
					if index == self.startLine then
						-- header
						if onEnter then
							line.text:SetTextColor(lc.h.h.r, lc.h.h.g, lc.h.h.b)
						else
							line.text:SetTextColor(lc.n.h.r, lc.n.h.g, lc.n.h.b)
						end
					else
						if onEnter then
							line.text:SetTextColor(lc.h.o.r, lc.h.o.g, lc.h.o.b)
							line.dash:SetTextColor(dc.h.r, dc.h.g, dc.h.b, Opts.colors.dashToSquare and 0 or 1)
							if line.square and Opts.colors.dashToSquare then
								line.square:SetBackdropColor(dc.h.r, dc.h.g, dc.h.b)
							end
						else
							line.text:SetTextColor(lc.n.o.r, lc.n.o.g, lc.n.o.b)
							line.dash:SetTextColor(dc.n.r, dc.n.g, dc.n.b, Opts.colors.dashToSquare and 0 or 1)
							if line.square and Opts.colors.dashToSquare then
								line.square:SetBackdropColor(dc.n.r, dc.n.g, dc.n.b)
							end
						end
					end
				end
			end
		end
		WFColorsHooked = true
	end
end

function nWFA.AddInternetLinks()
	_G.StaticPopupDialogs["WATCHFRAME_URL"] = {
		text = linkSiteTitle .. " link",
		button1 = OKAY,
		timeout = 0,
		whileDead = true,
		hasEditBox = true,
		editBoxWidth = 350,
		OnShow = function(self, ...) self.editBox:SetFocus() end,
		EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	}

	local tblDropDown = {}
	hooksecurefunc("WatchFrameDropDown_Initialize", function(self)
		if self.type == "QUEST" then
			tblDropDown = {
				text = linkSiteTitle .. " link",
				notCheckable = true,
				arg1 = self.index,
				func = function(_, watchId)
					local logId = GetQuestIndexForWatch(watchId)
					local _, _, _, _, _, _, _, _, questId = GetQuestLogTitle(logId)
					local inputBox = StaticPopup_Show("WATCHFRAME_URL")
					inputBox.editBox:SetText(linkQuest:format(questId))
					inputBox.editBox:HighlightText()
				end
			}
			UIDropDownMenu_AddButton(tblDropDown, UIDROPDOWN_MENU_LEVEL)
		elseif self.type == "ACHIEVEMENT" then
			tblDropDown = {
				text = linkSiteTitle .. " link",
				notCheckable = true,
				arg1 = self.index,
				func = function(_, id)
					local inputBox = StaticPopup_Show("WATCHFRAME_URL")
					inputBox.editBox:SetText(linkAchievement:format(id))
					inputBox.editBox:HighlightText()
				end
			}
			UIDropDownMenu_AddButton(tblDropDown, UIDROPDOWN_MENU_LEVEL)
		end
	end)
	UIDropDownMenu_Initialize(WatchFrameDropDown, WatchFrameDropDown_Initialize, "MENU")
end

----
function nWFA.PLAYER_ENTERING_WORLD()
	nWFA.UpdateCollapseState()
	nWFA.UpdateHideState()
end

function nWFA.PLAYER_LOGIN()
	class = select(2, UnitClass("player"))
	classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

	if Opts.colors.classColor then
		titleColor = classColor
		lineColor = {
			n = {h = {r = classColor.r * 0.85, g = classColor.g * 0.85, b = classColor.b * 0.85}, o = {r = 0.85, g = 0.85, b = 0.85}},
			h = {h = classColor, o = {r = 1, g = 1, b = 1}},
		}
		dashColor = {
			n = {r = classColor.r * 0.85, g = classColor.g * 0.85, b = classColor.b * 0.85},
			h = classColor,
		}
	else
		titleColor = Opts.colors.title
		lineColor = {
			n = {h = Opts.colors.lines.normal.header, o = Opts.colors.lines.normal.objectives},
			h = {h = Opts.colors.lines.highlight.header, o = Opts.colors.lines.highlight.objectives},
		}
		dashColor = {
			n = Opts.colors.dash.normal,
			h = Opts.colors.dash.highlight,
		}
	end

	nWFA.HookWFColors()
	nWFA.AddInternetLinks()
	nWFA.UpdatePosition()
	nWFA.UpdateStyle()
	nWFA.UpdateFont()
end

nWFA:RegisterEvent("PLAYER_LOGIN")
nWFA:RegisterEvent("PLAYER_ENTERING_WORLD")
nWFA:SetScript("OnEvent", function(_, event) nWFA[event]() end)