local alpha

-- [[ Core ]]

local addon, core = ...

core[1] = {} -- F, functions
core[2] = {} -- C, constants/config

Aurora = core

AuroraConfig = {}

local F, C = unpack(select(2, ...))

C.classcolours = {
	["HUNTER"] = { r = 0.58, g = 0.86, b = 0.49 },
	["WARLOCK"] = { r = 0.6, g = 0.47, b = 0.85 },
	["PALADIN"] = { r = 1, g = 0.22, b = 0.52 },
	["PRIEST"] = { r = 0.8, g = 0.87, b = .9 },
	["MAGE"] = { r = 0, g = 0.76, b = 1 },
	["MONK"] = {r = 0.0, g = 1.00 , b = 0.59},
	["ROGUE"] = { r = 1, g = 0.91, b = 0.2 },
	["DRUID"] = { r = 1, g = 0.49, b = 0.04 },
	["SHAMAN"] = { r = 0, g = 0.6, b = 0.6 };
	["WARRIOR"] = { r = 0.9, g = 0.65, b = 0.45 },
	["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
}

C.media = {
	["arrowUp"] = "Interface\\AddOns\\Aurora\\media\\arrow-up-active",
	["arrowDown"] = "Interface\\AddOns\\Aurora\\media\\arrow-down-active",
	["arrowLeft"] = "Interface\\AddOns\\Aurora\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\Aurora\\media\\arrow-right-active",
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground",
	["checked"] = "Interface\\AddOns\\Aurora\\media\\CheckButtonHilight",
	["font"] = "Interface\\AddOns\\SharedMedia\\fonts\\font2.ttf",
	["glow"] = "Interface\\AddOns\\Aurora\\media\\glow",
	["roleIcons"] = "Interface\\Addons\\Aurora\\media\\UI-LFG-ICON-ROLES",
}

C.defaults = {
	["alpha"] = 0.8,
	["bags"] = true,
	["chatBubbles"] = false,
	["enableFont"] = false,
	["gradientAlpha"] = {
		"VERTICAL", 0.09, 0.09, 0.09, 1, 0.09, 0.09, 0.09, 1
	},
	["loot"] = true,
	["useCustomColour"] = false,
		["customColour"] = {r = 1, g = 1, b = 1},
	["map"] = false,
	["qualityColour"] = true,
	["tooltips"] = true,
}

C.frames = {}

-- [[ Functions ]]

local _, class = UnitClass("player")

if CUSTOM_CLASS_COLORS then
	C.classcolours = CUSTOM_CLASS_COLORS
end

local r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b

F.dummy = function() end

F.CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = C.media.backdrop,
		edgeFile = C.media.backdrop,
		edgeSize = 1,
	})
	f:SetBackdropColor(0.04, 0.04, 0.04, a or alpha)
	f:SetBackdropBorderColor(0, 0, 0)
	if not a then tinsert(C.frames, f) end
end

F.CreateBG = function(frame)
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", frame, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", frame, 1, -1)
	bg:SetTexture(C.media.backdrop)
	bg:SetVertexColor(0.04, 0.04, 0.04)

	return bg
end

F.CreateSD = function(parent, size, r, g, b, alpha, offset)
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.offset = offset or 0
	sd:SetBackdrop({
		edgeFile = nil,
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(alpha or 1)
end

-- we assign these after loading variables for caching
-- otherwise we call an extra unpack() every time
local gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha

F.CreateGradient = function(f)
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(C.media.backdrop)
	tex:SetGradientAlpha(gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha)

	return tex
end

F.CreatePulse = function(frame)
	local speed = .05
	local mult = 1
	local alpha = 1
	local last = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		last = last + elapsed
		if last > speed then
			last = 0
			self:SetAlpha(alpha)
		end
		alpha = alpha - elapsed*mult
		if alpha < 0 and mult > 0 then
			mult = mult*-1
			alpha = 0
		elseif alpha > 1 and mult < 0 then
			mult = mult*-1
		end
	end)
end

local function StartGlow(f)
	if not f:IsEnabled() then return end
	f:SetBackdropColor(r, g, b, .1)
	f:SetBackdropBorderColor(r, g, b)
	f.glow:SetAlpha(1)
	F.CreatePulse(f.glow)
end

local function StopGlow(f)
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(0, 0, 0)
	f.glow:SetScript("OnUpdate", nil)
	f.glow:SetAlpha(0)
end

F.Reskin = function(f, noGlow)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	F.CreateBD(f, .0)

	F.CreateGradient(f)

	if not noGlow then
		f.glow = CreateFrame("Frame", nil, f)
		f.glow:SetBackdrop({
			edgeFile = C.media.glow,
			edgeSize = 5,
		})
		f.glow:SetPoint("TOPLEFT", -6, 6)
		f.glow:SetPoint("BOTTOMRIGHT", 6, -6)
		f.glow:SetBackdropBorderColor(r, g, b)
		f.glow:SetAlpha(0)

		f:HookScript("OnEnter", StartGlow)
 		f:HookScript("OnLeave", StopGlow)
	end
end

F.ReskinTab = function(f)
	f:DisableDrawLayer("BACKGROUND")

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", 8, -3)
	bg:SetPoint("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bg)

	f:SetHighlightTexture(C.media.backdrop)
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 9, -4)
	hl:SetPoint("BOTTOMRIGHT", -9, 1)
	hl:SetVertexColor(r, g, b, .25)
end

local function colourScroll(f)
	if f:IsEnabled() then
		f.tex:SetVertexColor(r, g, b)
	end
end

local function clearScroll(f)
	f.tex:SetVertexColor(1, 1, 1)
end

F.ReskinScroll = function(f)
	local frame = f:GetName()

	if _G[frame.."Track"] then _G[frame.."Track"]:Hide() end
	if _G[frame.."BG"] then _G[frame.."BG"]:Hide() end
	if _G[frame.."Top"] then _G[frame.."Top"]:Hide() end
	if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
	if _G[frame.."Bottom"] then _G[frame.."Bottom"]:Hide() end

	local bu = _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:SetWidth(17)

	bu.bg = CreateFrame("Frame", nil, f)
	bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
	F.CreateBD(bu.bg, 0)

	local tex = F.CreateGradient(f)
	tex:SetPoint("TOPLEFT", bu.bg, 1, -1)
	tex:SetPoint("BOTTOMRIGHT", bu.bg, -1, 1)

	local up = _G[frame.."ScrollUpButton"]
	local down = _G[frame.."ScrollDownButton"]

	up:SetWidth(17)
	down:SetWidth(17)

	F.Reskin(up, true)
	F.Reskin(down, true)

	up:SetDisabledTexture(C.media.backdrop)
	local dis1 = up:GetDisabledTexture()
	dis1:SetVertexColor(0, 0, 0, .4)
	dis1:SetDrawLayer("OVERLAY")

	down:SetDisabledTexture(C.media.backdrop)
	local dis2 = down:GetDisabledTexture()
	dis2:SetVertexColor(0, 0, 0, .4)
	dis2:SetDrawLayer("OVERLAY")

	local uptex = up:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture(C.media.arrowUp)
	uptex:SetSize(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)
	up.tex = uptex

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(C.media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
	down.tex = downtex

	up:HookScript("OnEnter", colourScroll)
	up:HookScript("OnLeave", clearScroll)
	down:HookScript("OnEnter", colourScroll)
	down:HookScript("OnLeave", clearScroll)
end

local function colourArrow(f)
	if f:IsEnabled() then
		f.tex:SetVertexColor(r, g, b)
	end
end

local function clearArrow(f)
	f.tex:SetVertexColor(1, 1, 1)
end

F.colourArrow = colourArrow
F.clearArrow = clearArrow

F.ReskinDropDown = function(f)
	local frame = f:GetName()

	local left = _G[frame.."Left"]
	local middle = _G[frame.."Middle"]
	local right = _G[frame.."Right"]

	if left then left:SetAlpha(0) end
	if middle then middle:SetAlpha(0) end
	if right then right:SetAlpha(0) end

	local down = _G[frame.."Button"]

	down:SetSize(20, 20)
	down:ClearAllPoints()
	down:SetPoint("RIGHT", -18, 2)

	F.Reskin(down, true)

	down:SetDisabledTexture(C.media.backdrop)
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local tex = down:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(C.media.arrowDown)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	tex:SetVertexColor(1, 1, 1)
	down.tex = tex

	down:HookScript("OnEnter", colourArrow)
	down:HookScript("OnLeave", clearArrow)

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", -18, 8)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bg, 0)

	local gradient = F.CreateGradient(f)
	gradient:SetPoint("TOPLEFT", bg, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bg, -1, 1)
end

local function colourClose(f)
	if f:IsEnabled() then
		for _, pixel in pairs(f.pixels) do
			pixel:SetVertexColor(r, g, b)
		end
	end
end

local function clearClose(f)
	for _, pixel in pairs(f.pixels) do
		pixel:SetVertexColor(1, 1, 1)
	end
end

F.ReskinClose = function(f, a1, p, a2, x, y)
	f:SetSize(17, 17)

	if not a1 then
		f:SetPoint("TOPRIGHT", -4, -4)
	else
		f:ClearAllPoints()
		f:SetPoint(a1, p, a2, x, y)
	end

	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	F.CreateBD(f, 0)

	F.CreateGradient(f)

	f:SetDisabledTexture(C.media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	f.pixels = {}

	for i = 1, 9 do
		local tex = f:CreateTexture()
		tex:SetTexture(1, 1, 1)
		tex:SetSize(1, 1)
		tex:SetPoint("BOTTOMLEFT", 3+i, 3+i)
		tinsert(f.pixels, tex)
	end

	for i = 1, 9 do
		local tex = f:CreateTexture()
		tex:SetTexture(1, 1, 1)
		tex:SetSize(1, 1)
		tex:SetPoint("TOPLEFT", 3+i, -3-i)
		tinsert(f.pixels, tex)
	end

	f:HookScript("OnEnter", colourClose)
 	f:HookScript("OnLeave", clearClose)
end

F.ReskinInput = function(f, height, width)
	local frame = f:GetName()
	_G[frame.."Left"]:Hide()
	if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
	if _G[frame.."Mid"] then _G[frame.."Mid"]:Hide() end
	_G[frame.."Right"]:Hide()

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	local gradient = F.CreateGradient(f)
	gradient:SetPoint("TOPLEFT", bd, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bd, -1, 1)

	if height then f:SetHeight(height) end
	if width then f:SetWidth(width) end
end

F.ReskinArrow = function(f, direction)
	f:SetSize(18, 18)
	F.Reskin(f, true)

	f:SetDisabledTexture(C.media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = f:CreateTexture(nil, "ARTWORK")
	tex:SetTexture("Interface\\AddOns\\Aurora\\media\\arrow-"..direction.."-active")
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	f.tex = tex

	f:HookScript("OnEnter", colourArrow)
	f:HookScript("OnLeave", clearArrow)
end

F.ReskinCheck = function(f)
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(C.media.backdrop)
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .2)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 4, -4)
	bd:SetPoint("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	local tex = F.CreateGradient(f)
	tex:SetPoint("TOPLEFT", 5, -5)
	tex:SetPoint("BOTTOMRIGHT", -5, 5)

	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

local function colourRadio(f)
	f.bd:SetBackdropBorderColor(r, g, b)
end

local function clearRadio(f)
	f.bd:SetBackdropBorderColor(0, 0, 0)
end

F.ReskinRadio = function(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetCheckedTexture(C.media.backdrop)

	local ch = f:GetCheckedTexture()
	ch:SetPoint("TOPLEFT", 4, -4)
	ch:SetPoint("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(r, g, b, .6)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 3, -3)
	bd:SetPoint("BOTTOMRIGHT", -3, 3)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)
	f.bd = bd

	local tex = F.CreateGradient(f)
	tex:SetPoint("TOPLEFT", 4, -4)
	tex:SetPoint("BOTTOMRIGHT", -4, 4)

	f:HookScript("OnEnter", colourRadio)
	f:HookScript("OnLeave", clearRadio)
end

F.ReskinSlider = function(f)
	f:SetBackdrop(nil)
	f.SetBackdrop = F.dummy

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 14, -2)
	bd:SetPoint("BOTTOMRIGHT", -15, 3)
	bd:SetFrameStrata("BACKGROUND")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	F.CreateGradient(bd)

	local slider = select(4, f:GetRegions())
	slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	slider:SetBlendMode("ADD")
end

local function colourExpandOrCollapse(f)
	if f:IsEnabled() then
		f.plus:SetVertexColor(r, g, b)
		f.minus:SetVertexColor(r, g, b)
	end
end

local function clearExpandOrCollapse(f)
	f.plus:SetVertexColor(1, 1, 1)
	f.minus:SetVertexColor(1, 1, 1)
end

F.colourExpandOrCollapse = colourExpandOrCollapse
F.clearExpandOrCollapse = clearExpandOrCollapse

F.ReskinExpandOrCollapse = function(f)
	f:SetSize(13, 13)

	F.Reskin(f, true)
	f.SetNormalTexture = F.dummy

	f.minus = f:CreateTexture(nil, "OVERLAY")
	f.minus:SetSize(7, 1)
	f.minus:SetPoint("CENTER")
	f.minus:SetTexture(C.media.backdrop)
	f.minus:SetVertexColor(1, 1, 1)

	f.plus = f:CreateTexture(nil, "OVERLAY")
	f.plus:SetSize(1, 7)
	f.plus:SetPoint("CENTER")
	f.plus:SetTexture(C.media.backdrop)
	f.plus:SetVertexColor(1, 1, 1)

	f:HookScript("OnEnter", colourExpandOrCollapse)
	f:HookScript("OnLeave", clearExpandOrCollapse)
end

F.SetBD = function(f, x, y, x2, y2)
	local bg = CreateFrame("Frame", nil, f)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(0)
	F.CreateBD(bg)
	F.CreateSD(bg)
end

F.ReskinPortraitFrame = function(f, isButtonFrame)
	local name = f:GetName()

	_G[name.."Bg"]:Hide()
	_G[name.."TitleBg"]:Hide()
	_G[name.."Portrait"]:Hide()
	_G[name.."PortraitFrame"]:Hide()
	_G[name.."TopRightCorner"]:Hide()
	_G[name.."TopLeftCorner"]:Hide()
	_G[name.."TopBorder"]:Hide()
	_G[name.."TopTileStreaks"]:SetTexture("")
	_G[name.."BotLeftCorner"]:Hide()
	_G[name.."BotRightCorner"]:Hide()
	_G[name.."BottomBorder"]:Hide()
	_G[name.."LeftBorder"]:Hide()
	_G[name.."RightBorder"]:Hide()

	if isButtonFrame then
		_G[name.."BtnCornerLeft"]:SetTexture("")
		_G[name.."BtnCornerRight"]:SetTexture("")
		_G[name.."ButtonBottomBorder"]:SetTexture("")

		f.Inset.Bg:Hide()
		f.Inset:DisableDrawLayer("BORDER")
	end

	F.CreateBD(f)
	F.CreateSD(f)
	F.ReskinClose(_G[name.."CloseButton"])
end

F.CreateBDFrame = function(f, a)
	local frame
	if f:GetObjectType() == "Texture" then
		frame = f:GetParent()
	else
		frame = f
	end

	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", f, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", f, 1, -1)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	F.CreateBD(bg, a or .5)

	return bg
end

F.ReskinColourSwatch = function(f)
	local name = f:GetName()

	local bg = _G[name.."SwatchBg"]

	f:SetNormalTexture(C.media.backdrop)
	local nt = f:GetNormalTexture()

	nt:SetPoint("TOPLEFT", 3, -3)
	nt:SetPoint("BOTTOMRIGHT", -3, 3)

	bg:SetTexture(0, 0, 0)
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)
end

-- [[ Module handling ]]

C.modules = {}
C.modules["Aurora"] = {}

local Skin = CreateFrame("Frame", nil, UIParent)
Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(self, event, addon)
	if addon == "Aurora" then
		-- [[ Load Variables ]]

		for key, value in pairs(C.defaults) do
			if AuroraConfig[key] == nil then
				if type(value) == "table" then
					AuroraConfig[key] = {}
					for k, v in pairs(value) do
						AuroraConfig[key][k] = value[k]
					end
				else
					AuroraConfig[key] = value
				end
			end
		end

		alpha = AuroraConfig.alpha
		gradOr, startR, startG, startB, startAlpha, endR, endG, endB, endAlpha = unpack(AuroraConfig.gradientAlpha)

		if AuroraConfig.useCustomColour then
			r, g, b = AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b
		end
		-- for modules
		C.r, C.g, C.b = r, g, b
	end

	for module, moduleFunc in pairs(C.modules) do
		if type(moduleFunc) == "function" then
			if module == addon then
				moduleFunc()
			end
		elseif type(moduleFunc) == "table" then
			if module == addon then
				for _, moduleFunc in pairs(C.modules[module]) do
					moduleFunc()
				end
			end
		end
	end

	if addon == "Aurora" then

		-- [[ Headers ]]

		local header = {"GameMenuFrame", "InterfaceOptionsFrame", "AudioOptionsFrame", "VideoOptionsFrame", "ChatConfigFrame", "ColorPickerFrame"}
		for i = 1, #header do
		local title = _G[header[i].."Header"]
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", header[i], 0, 0)
				end
			end
		end

		-- [[ Simple backdrops ]]

		local bds = {"AutoCompleteBox", "BNToastFrame", "TicketStatusFrameButton", "GearManagerDialogPopup", "TokenFramePopup", "ReputationDetailFrame", "RaidInfoFrame", "ScrollOfResurrectionSelectionFrame", "ScrollOfResurrectionFrame", "VoiceChatTalkers", "ReportPlayerNameDialog", "ReportCheatingDialog", "QueueStatusFrame"}

		for i = 1, #bds do
			local bd = _G[bds[i]]
			if bd then
				F.CreateBD(bd)
			else
				print("Aurora: "..bds[i].." was not found.")
			end
		end

		local lightbds = {"SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4", "ChatConfigChatSettingsClassColorLegend", "ChatConfigChannelSettingsClassColorLegend", "FriendsFriendsList", "HelpFrameTicketScrollFrame", "HelpFrameGM_ResponseScrollFrame1", "HelpFrameGM_ResponseScrollFrame2", "FriendsFriendsNoteFrame", "AddFriendNoteFrame", "ScrollOfResurrectionSelectionFrameList", "HelpFrameReportBugScrollFrame", "HelpFrameSubmitSuggestionScrollFrame", "ReportPlayerNameDialogCommentFrame", "ReportCheatingDialogCommentFrame"}
		for i = 1, #lightbds do
			local bd = _G[lightbds[i]]
			if bd then
				F.CreateBD(bd, .25)
			else
				print("Aurora: "..lightbds[i].." was not found.")
			end
		end

		-- [[ Scroll bars ]]

		local scrollbars = {"FriendsFrameFriendsScrollFrameScrollBar", "CharacterStatsPaneScrollBar", "LFDQueueFrameSpecificListScrollFrameScrollBar", "HelpFrameKnowledgebaseScrollFrameScrollBar", "HelpFrameReportBugScrollFrameScrollBar", "HelpFrameSubmitSuggestionScrollFrameScrollBar", "HelpFrameTicketScrollFrameScrollBar", "PaperDollTitlesPaneScrollBar", "PaperDollEquipmentManagerPaneScrollBar", "SendMailScrollFrameScrollBar", "OpenMailScrollFrameScrollBar", "RaidInfoScrollFrameScrollBar", "ReputationListScrollFrameScrollBar", "FriendsFriendsScrollFrameScrollBar", "HelpFrameGM_ResponseScrollFrame1ScrollBar", "HelpFrameGM_ResponseScrollFrame2ScrollBar", "HelpFrameKnowledgebaseScrollFrame2ScrollBar", "WhoListScrollFrameScrollBar", "GearManagerDialogPopupScrollFrameScrollBar", "LFDQueueFrameRandomScrollFrameScrollBar", "ScrollOfResurrectionSelectionFrameListScrollFrameScrollBar", "ChannelRosterScrollFrameScrollBar"}
		for i = 1, #scrollbars do
			local scrollbar = _G[scrollbars[i]]
			if scrollbar then
				F.ReskinScroll(scrollbar)
			else
				print("Aurora: "..scrollbars[i].." was not found.")
			end
		end

		-- [[ Dropdowns ]]

		local dropdowns = {"LFDQueueFrameTypeDropDown", "LFRBrowseFrameRaidDropDown", "WhoFrameDropDown", "FriendsFriendsFrameDropDown", "RaidFinderQueueFrameSelectionDropDown", "WorldMapShowDropDown", "Advanced_GraphicsAPIDropDown"}
		for i = 1, #dropdowns do
			local dropdown = _G[dropdowns[i]]
			if dropdown then
				F.ReskinDropDown(dropdown)
			else
				print("Aurora: "..dropdowns[i].." was not found.")
			end
		end

		-- [[ Input frames ]]

		local inputs = {"AddFriendNameEditBox", "SendMailNameEditBox", "SendMailSubjectEditBox", "SendMailMoneyGold", "SendMailMoneySilver", "SendMailMoneyCopper", "GearManagerDialogPopupEditBox", "HelpFrameKnowledgebaseSearchBox", "ChannelFrameDaughterFrameChannelName", "ChannelFrameDaughterFrameChannelPassword", "BagItemSearchBox", "BankItemSearchBox", "ScrollOfResurrectionSelectionFrameTargetEditBox", "ScrollOfResurrectionFrameNoteFrame"}
		for i = 1, #inputs do
			local input = _G[inputs[i]]
			if input then
				F.ReskinInput(input)
			else
				print("Aurora: "..inputs[i].." was not found.")
			end
		end

		F.ReskinInput(FriendsFrameBroadcastInput)

		-- [[ Arrows ]]

		F.ReskinArrow(SpellBookPrevPageButton, "left")
		F.ReskinArrow(SpellBookNextPageButton, "right")
		F.ReskinArrow(InboxPrevPageButton, "left")
		F.ReskinArrow(InboxNextPageButton, "right")
		F.ReskinArrow(MerchantPrevPageButton, "left")
		F.ReskinArrow(MerchantNextPageButton, "right")
		F.ReskinArrow(CharacterFrameExpandButton, "left")
		F.ReskinArrow(TabardCharacterModelRotateLeftButton, "left")
		F.ReskinArrow(TabardCharacterModelRotateRightButton, "right")

		hooksecurefunc("CharacterFrame_Expand", function()
			select(15, CharacterFrameExpandButton:GetRegions()):SetTexture(C.media.arrowLeft)
		end)

		hooksecurefunc("CharacterFrame_Collapse", function()
			select(15, CharacterFrameExpandButton:GetRegions()):SetTexture(C.media.arrowRight)
		end)

		-- [[ Check boxes ]]

		local checkboxes = {"TokenFramePopupInactiveCheckBox", "TokenFramePopupBackpackCheckBox", "ReputationDetailAtWarCheckBox", "ReputationDetailInactiveCheckBox", "ReputationDetailMainScreenCheckBox"}
		for i = 1, #checkboxes do
			local checkbox = _G[checkboxes[i]]
			if checkbox then
				F.ReskinCheck(checkbox)
			else
				print("Aurora: "..checkboxes[i].." was not found.")
			end
		end

		-- [[ Radio buttons ]]

		local radiobuttons = {"ReportPlayerNameDialogPlayerNameCheckButton", "ReportPlayerNameDialogGuildNameCheckButton", "ReportPlayerNameDialogArenaTeamNameCheckButton", "SendMailSendMoneyButton", "SendMailCODButton"}
		for i = 1, #radiobuttons do
			local radiobutton = _G[radiobuttons[i]]
			if radiobutton then
				F.ReskinRadio(radiobutton)
			else
				print("Aurora: "..radiobuttons[i].." was not found.")
			end
		end

		-- [[ Backdrop frames ]]

		F.SetBD(DressUpFrame, 10, -12, -34, 74)
		F.SetBD(HelpFrame)
		F.SetBD(SpellBookFrame)
		F.SetBD(RaidParentFrame)

		local FrameBDs = {"GameMenuFrame", "InterfaceOptionsFrame", "VideoOptionsFrame", "AudioOptionsFrame", "ChatConfigFrame", "StackSplitFrame", "AddFriendFrame", "FriendsFriendsFrame", "ColorPickerFrame", "ReadyCheckFrame", "GuildInviteFrame", "ChannelFrameDaughterFrame"}
		for i = 1, #FrameBDs do
			local FrameBD = _G[FrameBDs[i]]
			F.CreateBD(FrameBD)
			F.CreateSD(FrameBD)
		end

		-- Dropdown lists

		hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local menu = _G["DropDownList"..i.."MenuBackdrop"]
				local backdrop = _G["DropDownList"..i.."Backdrop"]
				if not backdrop.reskinned then
					F.CreateBD(menu)
					F.CreateBD(backdrop)
					backdrop.reskinned = true
				end
			end
		end)

		local createBackdrop = function(parent, texture)
			local bg = parent:CreateTexture(nil, "BACKGROUND")
			bg:SetTexture(0, 0, 0, .5)
			bg:SetPoint("CENTER", texture)
			bg:SetSize(12, 12)
			parent.bg = bg

			local left = parent:CreateTexture(nil, "BACKGROUND")
			left:SetWidth(1)
			left:SetTexture(0, 0, 0)
			left:SetPoint("TOPLEFT", bg)
			left:SetPoint("BOTTOMLEFT", bg)
			parent.left = left

			local right = parent:CreateTexture(nil, "BACKGROUND")
			right:SetWidth(1)
			right:SetTexture(0, 0, 0)
			right:SetPoint("TOPRIGHT", bg)
			right:SetPoint("BOTTOMRIGHT", bg)
			parent.right = right

			local top = parent:CreateTexture(nil, "BACKGROUND")
			top:SetHeight(1)
			top:SetTexture(0, 0, 0)
			top:SetPoint("TOPLEFT", bg)
			top:SetPoint("TOPRIGHT", bg)
			parent.top = top

			local bottom = parent:CreateTexture(nil, "BACKGROUND")
			bottom:SetHeight(1)
			bottom:SetTexture(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", bg)
			bottom:SetPoint("BOTTOMRIGHT", bg)
			parent.bottom = bottom
		end

		local toggleBackdrop = function(bu, show)
			if show then
				bu.bg:Show()
				bu.left:Show()
				bu.right:Show()
				bu.top:Show()
				bu.bottom:Show()
			else
				bu.bg:Hide()
				bu.left:Hide()
				bu.right:Hide()
				bu.top:Hide()
				bu.bottom:Hide()
			end
		end

		hooksecurefunc("ToggleDropDownMenu", function(level, _, dropDownFrame, anchorName)
			if not level then level = 1 end

			local uiScale = UIParent:GetScale()

			local listFrame = _G["DropDownList"..level]

			if level == 1 then
				if not anchorName then
					local xOffset = dropDownFrame.xOffset and dropDownFrame.xOffset or 16
					local yOffset = dropDownFrame.yOffset and dropDownFrame.yOffset or 9
					local point = dropDownFrame.point and dropDownFrame.point or "TOPLEFT"
					local relativeTo = dropDownFrame.relativeTo and dropDownFrame.relativeTo or dropDownFrame
					local relativePoint = dropDownFrame.relativePoint and dropDownFrame.relativePoint or "BOTTOMLEFT"

					listFrame:ClearAllPoints()
					listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)

					-- make sure it doesn't go off the screen
					local offLeft = listFrame:GetLeft()/uiScale
					local offRight = (GetScreenWidth() - listFrame:GetRight())/uiScale
					local offTop = (GetScreenHeight() - listFrame:GetTop())/uiScale
					local offBottom = listFrame:GetBottom()/uiScale

					local xAddOffset, yAddOffset = 0, 0
					if offLeft < 0 then
						xAddOffset = -offLeft
					elseif offRight < 0 then
						xAddOffset = offRight
					end

					if offTop < 0 then
						yAddOffset = offTop
					elseif offBottom < 0 then
						yAddOffset = -offBottom
					end
					listFrame:ClearAllPoints()
					listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset)
				elseif anchorName ~= "cursor" then
					-- this part might be a bit unreliable
					local _, _, relPoint, xOff, yOff = listFrame:GetPoint()
					if relPoint == "BOTTOMLEFT" and xOff == 0 and floor(yOff) == 5 then
						listFrame:SetPoint("TOPLEFT", anchorName, "BOTTOMLEFT", 16, 9)
					end
				end
			else
				local point, anchor, relPoint, _, y = listFrame:GetPoint()
				if point:find("RIGHT") then
					listFrame:SetPoint(point, anchor, relPoint, -14, y)
				else
					listFrame:SetPoint(point, anchor, relPoint, 9, y)
				end
			end

			for j = 1, UIDROPDOWNMENU_MAXBUTTONS do
				local bu = _G["DropDownList"..level.."Button"..j]
				local _, _, _, x = bu:GetPoint()
				if bu:IsShown() and x then
					local hl = _G["DropDownList"..level.."Button"..j.."Highlight"]
					local check = _G["DropDownList"..level.."Button"..j.."Check"]

					hl:SetPoint("TOPLEFT", -x + 1, 0)
					hl:SetPoint("BOTTOMRIGHT", listFrame:GetWidth() - bu:GetWidth() - x - 1, 0)

					if not bu.bg then
						createBackdrop(bu, check)
						hl:SetTexture(r, g, b, .2)
						_G["DropDownList"..level.."Button"..j.."UnCheck"]:SetTexture("")

						local arrow = _G["DropDownList"..level.."Button"..j.."ExpandArrow"]
						arrow:SetNormalTexture(C.media.arrowRight)
						arrow:SetSize(8, 8)
					end

					if not bu.notCheckable then
						toggleBackdrop(bu, true)

						-- only reliable way to see if button is radio or or check...
						local _, co = check:GetTexCoord()

						if co == 0 then
							check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
							check:SetVertexColor(r, g, b, 1)
							check:SetSize(20, 20)
							check:SetDesaturated(true)
						else
							check:SetTexture(C.media.backdrop)
							check:SetVertexColor(r, g, b, .6)
							check:SetSize(10, 10)
							check:SetDesaturated(false)
						end

						check:SetTexCoord(0, 1, 0, 1)
					else
						toggleBackdrop(bu, false)
					end
				end
			end
		end)

		-- [[ Custom skins ]]

		-- Pet stuff

		if class == "HUNTER" or class == "MAGE" or class == "DEATHKNIGHT" or class == "WARLOCK" then
			if class == "HUNTER" then
				PetStableBottomInset:DisableDrawLayer("BACKGROUND")
				PetStableBottomInset:DisableDrawLayer("BORDER")
				PetStableLeftInset:DisableDrawLayer("BACKGROUND")
				PetStableLeftInset:DisableDrawLayer("BORDER")
				PetStableModelShadow:Hide()
				PetStableModelRotateLeftButton:Hide()
				PetStableModelRotateRightButton:Hide()
				PetStableFrameModelBg:Hide()
				PetStablePrevPageButtonIcon:SetTexture("")
				PetStableNextPageButtonIcon:SetTexture("")

				F.ReskinPortraitFrame(PetStableFrame, true)
				F.ReskinArrow(PetStablePrevPageButton, "left")
				F.ReskinArrow(PetStableNextPageButton, "right")

				PetStableSelectedPetIcon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBG(PetStableSelectedPetIcon)

				for i = 1, NUM_PET_ACTIVE_SLOTS do
					local bu = _G["PetStableActivePet"..i]

					bu.Background:Hide()
					bu.Border:Hide()

					bu:SetNormalTexture("")
					bu.Checked:SetTexture(C.media.checked)

					_G["PetStableActivePet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
					F.CreateBD(bu, .25)
				end

				for i = 1, NUM_PET_STABLE_SLOTS do
					local bu = _G["PetStableStabledPet"..i]
					local bd = CreateFrame("Frame", nil, bu)
					bd:SetPoint("TOPLEFT", -1, 1)
					bd:SetPoint("BOTTOMRIGHT", 1, -1)
					F.CreateBD(bd, .25)
					bu:SetNormalTexture("")
					bu:DisableDrawLayer("BACKGROUND")
					_G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
				end
			end

			hooksecurefunc("PetPaperDollFrame_UpdateIsAvailable", function()
				if not HasPetUI() then
					CharacterFrameTab3:SetPoint("LEFT", CharacterFrameTab2, "LEFT", 0, 0)
				else
					CharacterFrameTab3:SetPoint("LEFT", CharacterFrameTab2, "RIGHT", -15, 0)
				end
			end)

			PetModelFrameRotateLeftButton:Hide()
			PetModelFrameRotateRightButton:Hide()
			PetModelFrameShadowOverlay:Hide()
			PetPaperDollPetModelBg:SetAlpha(0)
		end

		-- Ghost frame

		GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)

		local GhostBD = CreateFrame("Frame", nil, GhostFrameContentsFrame)
		GhostBD:SetPoint("TOPLEFT", GhostFrameContentsFrameIcon, -1, 1)
		GhostBD:SetPoint("BOTTOMRIGHT", GhostFrameContentsFrameIcon, 1, -1)
		F.CreateBD(GhostBD, 0)

		-- Mail frame

		SendMailMoneyInset:DisableDrawLayer("BORDER")
		InboxFrame:GetRegions():Hide()
		SendMailMoneyBg:Hide()
		SendMailMoneyInsetBg:Hide()
		OpenMailFrameIcon:Hide()
		OpenMailHorizontalBarLeft:Hide()
		select(18, MailFrame:GetRegions()):Hide()
		select(26, OpenMailFrame:GetRegions()):Hide()

		OpenMailLetterButton:SetNormalTexture("")
		OpenMailLetterButton:SetPushedTexture("")
		OpenMailLetterButtonIconTexture:SetTexCoord(.08, .92, .08, .92)

		local bgmail = CreateFrame("Frame", nil, OpenMailLetterButton)
		bgmail:SetPoint("TOPLEFT", -1, 1)
		bgmail:SetPoint("BOTTOMRIGHT", 1, -1)
		bgmail:SetFrameLevel(OpenMailLetterButton:GetFrameLevel()-1)
		F.CreateBD(bgmail)

		OpenMailMoneyButton:SetNormalTexture("")
		OpenMailMoneyButton:SetPushedTexture("")
		OpenMailMoneyButtonIconTexture:SetTexCoord(.08, .92, .08, .92)

		local bgmoney = CreateFrame("Frame", nil, OpenMailMoneyButton)
		bgmoney:SetPoint("TOPLEFT", -1, 1)
		bgmoney:SetPoint("BOTTOMRIGHT", 1, -1)
		bgmoney:SetFrameLevel(OpenMailMoneyButton:GetFrameLevel()-1)
		F.CreateBD(bgmoney)

		for i = 1, INBOXITEMS_TO_DISPLAY do
			local it = _G["MailItem"..i]
			local bu = _G["MailItem"..i.."Button"]
			local st = _G["MailItem"..i.."ButtonSlot"]
			local ic = _G["MailItem"..i.."Button".."Icon"]
			local line = select(3, _G["MailItem"..i]:GetRegions())

			local a, b = it:GetRegions()
			a:Hide()
			b:Hide()

			bu:SetCheckedTexture(C.media.checked)

			st:Hide()
			line:Hide()
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			F.CreateBD(bg, 0)
		end

		for i = 1, ATTACHMENTS_MAX_SEND do
			local button = _G["SendMailAttachment"..i]
			button:GetRegions():Hide()

			local bg = CreateFrame("Frame", nil, button)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(0)
			F.CreateBD(bg, .25)
		end

		for i = 1, ATTACHMENTS_MAX_RECEIVE do
			local bu = _G["OpenMailAttachmentButton"..i]
			local ic = _G["OpenMailAttachmentButton"..i.."IconTexture"]

			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(0)
			F.CreateBD(bg, .25)
		end

		hooksecurefunc("SendMailFrame_Update", function()
			for i = 1, ATTACHMENTS_MAX_SEND do
				local button = _G["SendMailAttachment"..i]
				if button:GetNormalTexture() then
					button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
				end
			end
		end)

		F.ReskinPortraitFrame(MailFrame, true)
		F.ReskinPortraitFrame(OpenMailFrame, true)

		-- Currency frame

		TokenFrame:HookScript("OnShow", function()
			for i=1, GetCurrencyListSize() do
				local button = _G["TokenFrameContainerButton"..i]

				if button and not button.reskinned then
					button.highlight:SetPoint("TOPLEFT", 1, 0)
					button.highlight:SetPoint("BOTTOMRIGHT", -1, 0)
					button.highlight.SetPoint = F.dummy
					button.highlight:SetTexture(r, g, b, .2)
					button.highlight.SetTexture = F.dummy
					button.categoryMiddle:SetAlpha(0)
					button.categoryLeft:SetAlpha(0)
					button.categoryRight:SetAlpha(0)

					if button.icon and button.icon:GetTexture() then
						button.icon:SetTexCoord(.08, .92, .08, .92)
						F.CreateBG(button.icon)
					end
					button.reskinned = true
				end
			end
		end)

		F.ReskinScroll(TokenFrameContainerScrollBar)

		-- Reputation frame

		local function UpdateFactionSkins()
			for i = 1, GetNumFactions() do
				local statusbar = _G["ReputationBar"..i.."ReputationBar"]

				if statusbar then
					statusbar:SetStatusBarTexture(C.media.backdrop)

					if not statusbar.reskinned then
						F.CreateBD(statusbar, .25)
						statusbar.reskinned = true
					end

					_G["ReputationBar"..i.."Background"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				end
			end
		end

		ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
		ReputationFrame:HookScript("OnEvent", UpdateFactionSkins)

		for i = 1, NUM_FACTIONS_DISPLAYED do
			local bu = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
			F.ReskinExpandOrCollapse(bu)
		end

		hooksecurefunc("ReputationFrame_Update", function()
			local numFactions = GetNumFactions()
			local factionIndex, factionButton, isCollapsed
			local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)

			for i = 1, NUM_FACTIONS_DISPLAYED do
				factionIndex = factionOffset + i
				factionButton = _G["ReputationBar"..i.."ExpandOrCollapseButton"]

				if factionIndex <= numFactions then
					_, _, _, _, _, _, _, _, _, isCollapsed = GetFactionInfo(factionIndex)
					if isCollapsed then
						factionButton.plus:Show()
					else
						factionButton.plus:Hide()
					end
				end
			end
		end)

		-- Raid Finder

		RaidFinderFrameBottomInset:DisableDrawLayer("BORDER")
		RaidFinderFrameBottomInsetBg:Hide()
		RaidFinderFrameBtnCornerRight:Hide()
		RaidFinderFrameButtonBottomBorder:Hide()
		RaidFinderQueueFrameScrollFrameScrollBackground:Hide()
		RaidFinderQueueFrameScrollFrameScrollBackgroundTopLeft:Hide()
		RaidFinderQueueFrameScrollFrameScrollBackgroundBottomRight:Hide()

		for i = 1, LFD_MAX_REWARDS do
			local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i]

			if button then
				local icon = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."IconTexture"]
				local cta = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."ShortageBorder"]
				local count = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."Count"]
				local na = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i.."NameFrame"]

				F.CreateBG(icon)
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:SetDrawLayer("OVERLAY")
				count:SetDrawLayer("OVERLAY")
				na:SetTexture(0, 0, 0, .25)
				na:SetSize(118, 39)
				cta:SetAlpha(0)

				button.bg2 = CreateFrame("Frame", nil, button)
				button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
				button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
				F.CreateBD(button.bg2, 0)
			end
		end

		F.ReskinScroll(RaidFinderQueueFrameScrollFrameScrollBar)

		-- Scenario finder

		ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
		ScenarioFinderFrame.TopTileStreaks:Hide()
		ScenarioFinderFrameBtnCornerRight:Hide()
		ScenarioFinderFrameButtonBottomBorder:Hide()
		ScenarioQueueFrameRandomScrollFrameScrollBackground:Hide()
		ScenarioQueueFrameRandomScrollFrameScrollBackgroundTopLeft:Hide()
		ScenarioQueueFrameRandomScrollFrameScrollBackgroundBottomRight:Hide()
		ScenarioQueueFrame.Bg:Hide()
		ScenarioFinderFrameInset:GetRegions():Hide()

		ScenarioQueueFrameRandomScrollFrame:SetWidth(304)

		hooksecurefunc("ScenarioQueueFrameRandom_UpdateFrame", function()
			for i = 1, 2 do
				local button = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i]

				if button and not button.styled then
					local icon = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]
					local cta = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."ShortageBorder"]
					local count = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
					local na = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i.."NameFrame"]

					F.CreateBG(icon)
					icon:SetTexCoord(.08, .92, .08, .92)
					icon:SetDrawLayer("OVERLAY")
					count:SetDrawLayer("OVERLAY")
					na:SetTexture(0, 0, 0, .25)
					na:SetSize(118, 39)
					cta:SetAlpha(0)

					button.bg2 = CreateFrame("Frame", nil, button)
					button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
					button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
					F.CreateBD(button.bg2, 0)

					button.styled = true
				end
			end
		end)

		local bonusValor = ScenarioQueueFrameRandomScrollFrameChildFrameBonusValor
		bonusValor.Border:Hide()
		bonusValor.Icon:SetTexCoord(.08, .92, .08, .92)
		bonusValor.Icon:SetPoint("CENTER", bonusValor.Border, -3, 0)
		bonusValor.Icon:SetSize(24, 24)
		bonusValor.BonusText:SetPoint("LEFT", bonusValor.Border, "RIGHT", -5, -1)
		F.CreateBG(bonusValor.Icon)

		F.Reskin(ScenarioQueueFrameFindGroupButton)
		F.Reskin(ScenarioQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
		F.ReskinDropDown(ScenarioQueueFrameTypeDropDown)
		F.ReskinScroll(ScenarioQueueFrameRandomScrollFrameScrollBar)

		-- Raid frame (social frame)

		F.Reskin(RaidFrameRaidBrowserButton)
		F.ReskinCheck(RaidFrameAllAssistCheckButton)

		-- Looking for raid

		LFRBrowseFrameRoleInset:DisableDrawLayer("BORDER")
		LFRQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
		LFRQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
		LFRBrowseFrameRoleInsetBg:Hide()

		F.ReskinPortraitFrame(RaidBrowserFrame)
		F.ReskinScroll(LFRQueueFrameSpecificListScrollFrameScrollBar)
		F.ReskinScroll(LFRQueueFrameCommentScrollFrameScrollBar)

		for i = 1, 2 do
			local tab = _G["LFRParentFrameSideTab"..i]
			tab:GetRegions():Hide()
			tab:SetCheckedTexture(C.media.checked)
			if i == 1 then
				local a1, p, a2, x, y = tab:GetPoint()
				tab:SetPoint(a1, p, a2, x + 11, y)
			end
			F.CreateBG(tab)
			F.CreateSD(tab, 5, 0, 0, 0, 1, 1)
			select(2, tab:GetRegions()):SetTexCoord(.08, .92, .08, .92)
		end

		for i = 1, NUM_LFR_CHOICE_BUTTONS do
			local bu = _G["LFRQueueFrameSpecificListButton"..i].enableButton
			F.ReskinCheck(bu)
			bu.SetNormalTexture = F.dummy
			bu.SetPushedTexture = F.dummy

			F.ReskinExpandOrCollapse(_G["LFRQueueFrameSpecificListButton"..i].expandOrCollapseButton)
		end

		hooksecurefunc("LFRQueueFrameSpecificListButton_SetDungeon", function(button, dungeonID)
			if LFGCollapseList[dungeonID] then
				button.expandOrCollapseButton.plus:Show()
			else
				button.expandOrCollapseButton.plus:Hide()
			end

			button.enableButton:GetCheckedTexture():SetDesaturated(true)
		end)

		-- Spellbook frame

		for i = 1, SPELLS_PER_PAGE do
			local bu = _G["SpellButton"..i]
			local ic = _G["SpellButton"..i.."IconTexture"]

			_G["SpellButton"..i.."SlotFrame"]:SetAlpha(0)
			_G["SpellButton"..i.."Highlight"]:SetAlpha(0)

			bu.EmptySlot:SetAlpha(0)
			bu.TextBackground:Hide()
			bu.TextBackground2:Hide()
			bu.UnlearnedFrame:SetAlpha(0)

			bu:SetCheckedTexture("")
			bu:SetPushedTexture("")

			ic:SetTexCoord(.08, .92, .08, .92)

			ic.bg = F.CreateBG(bu)
		end

		hooksecurefunc("SpellButton_UpdateButton", function(self)
			local slot, slotType = SpellBook_GetSpellBookSlot(self);
			local name = self:GetName();
			local subSpellString = _G[name.."SubSpellName"]

			subSpellString:SetTextColor(1, 1, 1)
			if slotType == "FUTURESPELL" then
				local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
				if (level and level > UnitLevel("player")) then
					self.RequiredLevelString:SetTextColor(.7, .7, .7)
					self.SpellName:SetTextColor(.7, .7, .7)
					subSpellString:SetTextColor(.7, .7, .7)
				end
			end

			local ic = _G[name.."IconTexture"]
			if not ic.bg then return end
			if ic:IsShown() then
				ic.bg:Show()
			else
				ic.bg:Hide()
			end
		end)

		SpellBookSkillLineTab1:SetPoint("TOPLEFT", SpellBookSideTabsFrame, "TOPRIGHT", 11, -36)

		hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
			for i = 1, GetNumSpellTabs() do
				local tab = _G["SpellBookSkillLineTab"..i]

				if not tab.styled then
					tab:GetRegions():Hide()
					tab:SetCheckedTexture(C.media.checked)

					F.CreateBG(tab)
					F.CreateSD(tab, 5, 0, 0, 0, 1, 1)

					tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)

					tab.styled = true
				end
			end
		end)

		local coreTabsSkinned = false
		hooksecurefunc("SpellBookCoreAbilities_UpdateTabs", function()
			if coreTabsSkinned then return end
			coreTabsSkinned = true
			for i = 1, GetNumSpecializations() do
				local tab = SpellBookCoreAbilitiesFrame.SpecTabs[i]

				tab:GetRegions():Hide()
				tab:SetCheckedTexture(C.media.checked)

				F.CreateBG(tab)
				F.CreateSD(tab, 5, 0, 0, 0, 1, 1)

				tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)

				if i == 1 then
					tab:SetPoint("TOPLEFT", SpellBookCoreAbilitiesFrame, "TOPRIGHT", 11, -53)
				end
			end
		end)

		hooksecurefunc("SpellBook_UpdateCoreAbilitiesTab", function()
			for i = 1, #SpellBookCoreAbilitiesFrame.Abilities do
				local bu = SpellBook_GetCoreAbilityButton(i)
				if not bu.reskinned then
					bu.EmptySlot:SetAlpha(0)
					bu.ActiveTexture:SetAlpha(0)
					bu.FutureTexture:SetAlpha(0)
					bu.RequiredLevel:SetTextColor(1, 1, 1)

					bu.iconTexture:SetTexCoord(.08, .92, .08, .92)
					bu.iconTexture.bg = F.CreateBG(bu.iconTexture)

					if bu.FutureTexture:IsShown() then
						bu.Name:SetTextColor(.8, .8, .8)
						bu.InfoText:SetTextColor(.7, .7, .7)
					else
						bu.Name:SetTextColor(1, 1, 1)
						bu.InfoText:SetTextColor(.9, .9, .9)
					end
					bu.reskinned = true
				end
			end
		end)

		hooksecurefunc("SpellBook_UpdateWhatHasChangedTab", function()
			for i = 1, #SpellBookWhatHasChanged.ChangedItems do
				local bu = SpellBook_GetWhatChangedItem(i)
				bu.Ring:Hide()
				select(2, bu:GetRegions()):Hide()
				bu:SetTextColor(.9, .9, .9)
				bu.Title:SetTextColor(1, 1, 1)
			end
		end)

		SpellBookFrameTutorialButton.Ring:Hide()
		SpellBookFrameTutorialButton:SetPoint("TOPLEFT", SpellBookFrame, "TOPLEFT", -12, 12)

		-- Professions

		local professions = {"PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4"}

		for _, button in pairs(professions) do
			local bu = _G[button]
			bu.professionName:SetTextColor(1, 1, 1)
			bu.missingHeader:SetTextColor(1, 1, 1)
			bu.missingText:SetTextColor(1, 1, 1)

			bu.statusBar:SetHeight(13)
			bu.statusBar:SetStatusBarTexture(C.media.backdrop)
			bu.statusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .6, 0, 0, .8, 0)
			bu.statusBar.rankText:SetPoint("CENTER")

			local _, p = bu.statusBar:GetPoint()
			bu.statusBar:SetPoint("TOPLEFT", p, "BOTTOMLEFT", 1, -3)

			_G[button.."StatusBarLeft"]:Hide()
			bu.statusBar.capRight:SetAlpha(0)
			_G[button.."StatusBarBGLeft"]:Hide()
			_G[button.."StatusBarBGMiddle"]:Hide()
			_G[button.."StatusBarBGRight"]:Hide()

			local bg = CreateFrame("Frame", nil, bu.statusBar)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			F.CreateBD(bg, .25)
		end

		local professionbuttons = {"PrimaryProfession1SpellButtonTop", "PrimaryProfession1SpellButtonBottom", "PrimaryProfession2SpellButtonTop", "PrimaryProfession2SpellButtonBottom", "SecondaryProfession1SpellButtonLeft", "SecondaryProfession1SpellButtonRight", "SecondaryProfession2SpellButtonLeft", "SecondaryProfession2SpellButtonRight", "SecondaryProfession3SpellButtonLeft", "SecondaryProfession3SpellButtonRight", "SecondaryProfession4SpellButtonLeft", "SecondaryProfession4SpellButtonRight"}

		for _, button in pairs(professionbuttons) do
			local icon = _G[button.."IconTexture"]
			local bu = _G[button]
			_G[button.."NameFrame"]:SetAlpha(0)

			bu:SetPushedTexture("")
			bu:SetCheckedTexture(C.media.checked)
			bu:GetHighlightTexture():Hide()

			if icon then
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				icon:SetPoint("TOPLEFT", 2, -2)
				icon:SetPoint("BOTTOMRIGHT", -2, 2)
				F.CreateBG(icon)
			end
		end

		for i = 1, 2 do
			local bu = _G["PrimaryProfession"..i]
			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, -4)
			bg:SetFrameLevel(0)
			F.CreateBD(bg, .25)
		end

		-- Merchant Frame

		MerchantMoneyInset:DisableDrawLayer("BORDER")
		MerchantExtraCurrencyInset:DisableDrawLayer("BORDER")
		BuybackBG:SetAlpha(0)
		MerchantMoneyBg:Hide()
		MerchantMoneyInsetBg:Hide()
		MerchantFrameBottomLeftBorder:SetAlpha(0)
		MerchantFrameBottomRightBorder:SetAlpha(0)
		MerchantExtraCurrencyBg:SetAlpha(0)
		MerchantExtraCurrencyInsetBg:Hide()

		F.ReskinPortraitFrame(MerchantFrame, true)
		F.ReskinDropDown(MerchantFrameLootFilter)

		for i = 1, BUYBACK_ITEMS_PER_PAGE do
			local button = _G["MerchantItem"..i]
			local bu = _G["MerchantItem"..i.."ItemButton"]
			local mo = _G["MerchantItem"..i.."MoneyFrame"]
			local ic = bu.icon

			bu:SetHighlightTexture("")

			_G["MerchantItem"..i.."SlotTexture"]:Hide()
			_G["MerchantItem"..i.."NameFrame"]:Hide()
			_G["MerchantItem"..i.."Name"]:SetHeight(20)

			local a1, p, a2= bu:GetPoint()
			bu:SetPoint(a1, p, a2, -2, -2)
			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			bu:SetSize(40, 40)

			local a3, p2, a4, x, y = mo:GetPoint()
			mo:SetPoint(a3, p2, a4, x, y+2)

			F.CreateBD(bu, 0)

			button.bd = CreateFrame("Frame", nil, button)
			button.bd:SetPoint("TOPLEFT", 39, 0)
			button.bd:SetPoint("BOTTOMRIGHT")
			button.bd:SetFrameLevel(0)
			F.CreateBD(button.bd, .25)

			ic:SetTexCoord(.08, .92, .08, .92)
			ic:ClearAllPoints()
			ic:SetPoint("TOPLEFT", 1, -1)
			ic:SetPoint("BOTTOMRIGHT", -1, 1)

			for j = 1, 3 do
				F.CreateBG(_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"])
				_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]:SetTexCoord(.08, .92, .08, .92)
			end
		end

		hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
			local numMerchantItems = GetMerchantNumItems()
			for i = 1, MERCHANT_ITEMS_PER_PAGE do
				local index = ((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i
				if index <= numMerchantItems then
					local name, texture, price, stackCount, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index)
					if extendedCost and (price <= 0) then
						_G["MerchantItem"..i.."AltCurrencyFrame"]:SetPoint("BOTTOMLEFT", "MerchantItem"..i.."NameFrame", "BOTTOMLEFT", 0, 35)
					end

					if AuroraConfig.qualityColour then
						local bu = _G["MerchantItem"..i.."ItemButton"]
						local name = _G["MerchantItem"..i.."Name"]
						if bu.link then
							local _, _, quality = GetItemInfo(bu.link)
							local r, g, b = GetItemQualityColor(quality)

							name:SetTextColor(r, g, b)
						else
							name:SetTextColor(1, 1, 1)
						end
					end
				end
			end

			if AuroraConfig.qualityColour then
				local name = GetBuybackItemLink(GetNumBuybackItems())
				if name then
					local _, _, quality = GetItemInfo(name)
					local r, g, b = GetItemQualityColor(quality)

					MerchantBuyBackItemName:SetTextColor(r, g, b)
				end
			end
		end)

		if AuroraConfig.qualityColour then
			hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function()
				for i = 1, BUYBACK_ITEMS_PER_PAGE do
					local itemLink = GetBuybackItemLink(i)
					local name = _G["MerchantItem"..i.."Name"]

					if itemLink then
						local _, _, quality = GetItemInfo(itemLink)
						local r, g, b = GetItemQualityColor(quality)

						name:SetTextColor(r, g, b)
					else
						name:SetTextColor(1, 1, 1)
					end
				end
			end)
		end

		MerchantBuyBackItemSlotTexture:Hide()
		MerchantBuyBackItemNameFrame:Hide()
		MerchantBuyBackItemItemButton:SetNormalTexture("")
		MerchantBuyBackItemItemButton:SetPushedTexture("")

		F.CreateBD(MerchantBuyBackItemItemButton, 0)
		F.CreateBD(MerchantBuyBackItem, .25)

		MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
		MerchantBuyBackItemItemButtonIconTexture:ClearAllPoints()
		MerchantBuyBackItemItemButtonIconTexture:SetPoint("TOPLEFT", 1, -1)
		MerchantBuyBackItemItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -1, 1)

		MerchantGuildBankRepairButton:SetPushedTexture("")
		F.CreateBG(MerchantGuildBankRepairButton)
		MerchantGuildBankRepairButtonIcon:SetTexCoord(0.595, 0.8075, 0.05, 0.52)

		MerchantRepairAllButton:SetPushedTexture("")
		F.CreateBG(MerchantRepairAllButton)
		MerchantRepairAllIcon:SetTexCoord(0.31375, 0.53, 0.06, 0.52)

		MerchantRepairItemButton:SetPushedTexture("")
		F.CreateBG(MerchantRepairItemButton)
		local ic = MerchantRepairItemButton:GetRegions()
		ic:SetTexture("Interface\\Icons\\INV_Hammer_20")
		ic:SetTexCoord(.08, .92, .08, .92)

		hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
			for i = 1, MAX_MERCHANT_CURRENCIES do
				local bu = _G["MerchantToken"..i]
				if bu and not bu.reskinned then
					local ic = _G["MerchantToken"..i.."Icon"]
					local co = _G["MerchantToken"..i.."Count"]

					ic:SetTexCoord(.08, .92, .08, .92)
					ic:SetDrawLayer("OVERLAY")
					ic:SetPoint("LEFT", co, "RIGHT", 2, 0)
					co:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 0)

					F.CreateBG(ic)
					bu.reskinned = true
				end
			end
		end)

		-- Friends Frame

		FriendsFrameIcon:Hide()

		for i = 1, FRIENDS_TO_DISPLAY do
			local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
			local ic = bu.gameIcon

			bu.background:Hide()
			bu.travelPassButton:SetAlpha(0)
			bu.travelPassButton:EnableMouse(false)

			bu:SetHighlightTexture(C.media.backdrop)
			bu:GetHighlightTexture():SetVertexColor(.24, .56, 1, .2)

			ic:SetSize(22, 22)
			ic:SetTexCoord(.15, .85, .15, .85)

			bu.bg = CreateFrame("Frame", nil, bu)
			bu.bg:SetAllPoints(ic)
			F.CreateBD(bu.bg, 0)
		end

		local function UpdateScroll()
			for i = 1, FRIENDS_TO_DISPLAY do
				local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]

				if bu.gameIcon:IsShown() then
					bu.bg:Show()
					bu.gameIcon:SetPoint("TOPRIGHT", bu, "TOPRIGHT", -2, -2)
				else
					bu.bg:Hide()
				end
			end
		end

		local bu1 = FriendsFrameFriendsScrollFrameButton1
		bu1.bg:SetPoint("BOTTOMRIGHT", bu1.gameIcon, 0, -1)

		hooksecurefunc("FriendsFrame_UpdateFriends", UpdateScroll)
		hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", UpdateScroll)

		FriendsFrameStatusDropDown:ClearAllPoints()
		FriendsFrameStatusDropDown:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 10, -28)

		FriendsTabHeaderSoRButton:SetPushedTexture("")
		FriendsTabHeaderSoRButtonIcon:SetTexCoord(.08, .92, .08, .92)
		local SoRBg = CreateFrame("Frame", nil, FriendsTabHeaderSoRButton)
		SoRBg:SetPoint("TOPLEFT", -1, 1)
		SoRBg:SetPoint("BOTTOMRIGHT", 1, -1)
		F.CreateBD(SoRBg, 0)

		F.CreateBD(FriendsFrameBattlenetFrame.UnavailableInfoFrame)
		FriendsFrameBattlenetFrame.UnavailableInfoFrame:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", 1, -18)

		FriendsFrameBattlenetFrame:GetRegions():Hide()
		F.CreateBD(FriendsFrameBattlenetFrame, .25)

		FriendsFrameBattlenetFrame.Tag:SetParent(FriendsListFrame)
		FriendsFrameBattlenetFrame.Tag:SetPoint("TOP", FriendsFrame, "TOP", 0, -8)

		hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function()
			if BNFeaturesEnabled() then
				local frame = FriendsFrameBattlenetFrame

				frame.BroadcastButton:Hide()

				if BNConnected() then
					frame:Hide()
					FriendsFrameBroadcastInput:Show()
					FriendsFrameBroadcastInput_UpdateDisplay()
				end
			end
		end)

		hooksecurefunc("FriendsFrame_Update", function()
			if FriendsFrame.selectedTab == 1 and FriendsTabHeader.selectedTab == 1 and FriendsFrameBattlenetFrame.Tag:IsShown() then
				FriendsFrameTitleText:Hide()
			else
				FriendsFrameTitleText:Show()
			end
		end)

		local whoBg = CreateFrame("Frame", nil, WhoFrameEditBoxInset)
		whoBg:SetPoint("TOPLEFT")
		whoBg:SetPoint("BOTTOMRIGHT", -1, 1)
		whoBg:SetFrameLevel(WhoFrameEditBoxInset:GetFrameLevel()-1)
		F.CreateBD(whoBg, .25)

		F.ReskinPortraitFrame(FriendsFrame, true)
		F.Reskin(FriendsFrameAddFriendButton)
		F.Reskin(FriendsFrameSendMessageButton)
		F.Reskin(FriendsFrameIgnorePlayerButton)
		F.Reskin(FriendsFrameUnsquelchButton)
		F.Reskin(FriendsFrameMutePlayerButton)
		F.ReskinDropDown(FriendsFrameStatusDropDown)

		-- Battletag invite frame

		for i = 1, 9 do
			select(i, BattleTagInviteFrame.NoteFrame:GetRegions()):Hide()
		end

		F.CreateBD(BattleTagInviteFrame)
		F.CreateSD(BattleTagInviteFrame)
		F.CreateBD(BattleTagInviteFrame.NoteFrame, .25)

		local _, send, cancel = BattleTagInviteFrame:GetChildren()
		F.Reskin(send)
		F.Reskin(cancel)

		F.ReskinScroll(BattleTagInviteFrameScrollFrameScrollBar)

		-- Nav Bar

		local function navButtonFrameLevel(self)
			for i=1, #self.navList do
				local navButton = self.navList[i]
				local lastNav = self.navList[i-1]
				if navButton and lastNav then
					navButton:SetFrameLevel(lastNav:GetFrameLevel() - 2)
					navButton:ClearAllPoints()
					navButton:SetPoint("LEFT", lastNav, "RIGHT", 1, 0)
				end
			end
		end

		hooksecurefunc("NavBar_AddButton", function(self, buttonData)
			local navButton = self.navList[#self.navList]


			if not navButton.skinned then
				F.Reskin(navButton)
				navButton:GetRegions():SetAlpha(0)
				select(2, navButton:GetRegions()):SetAlpha(0)
				select(3, navButton:GetRegions()):SetAlpha(0)

				navButton.skinned = true

				navButton:HookScript("OnClick", function()
					navButtonFrameLevel(self)
				end)
			end

			navButtonFrameLevel(self)
		end)

		-- Character frame

		F.ReskinPortraitFrame(CharacterFrame, true)

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Tabard",
		}

		for i = 1, #slots do
			local slot = _G["Character"..slots[i].."Slot"]
			local ic = _G["Character"..slots[i].."SlotIconTexture"]
			_G["Character"..slots[i].."SlotFrame"]:Hide()

			slot:SetNormalTexture("")
			slot:SetPushedTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			slot.bg = F.CreateBG(slot)
		end

		select(10, CharacterMainHandSlot:GetRegions()):Hide()
		select(10, CharacterSecondaryHandSlot:GetRegions()):Hide()

		hooksecurefunc("PaperDollItemSlotButton_Update", function()
			for i = 1, #slots do
				local slot = _G["Character"..slots[i].."Slot"]
				local ic = _G["Character"..slots[i].."SlotIconTexture"]

				if i == 18 then i = 19 end

				if GetInventoryItemLink("player", i) then
					ic:SetAlpha(1)
					slot.bg:SetAlpha(1)
				else
					ic:SetAlpha(1)
					slot.bg:SetAlpha(1)
				end
			end
		end)

		for i = 1, #PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab"..i]

			if i == 1 then
				for i = 1, 4 do
					local region = select(i, tab:GetRegions())
					region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
					region.SetTexCoord = F.dummy
				end
			end

			tab.Highlight:SetTexture(r, g, b, .2)
			tab.Highlight:SetPoint("TOPLEFT", 3, -4)
			tab.Highlight:SetPoint("BOTTOMRIGHT", -1, 0)
			tab.Hider:SetTexture(.3, .3, .3, .4)
			tab.TabBg:SetAlpha(0)

			select(2, tab:GetRegions()):ClearAllPoints()
			if i == 1 then
				select(2, tab:GetRegions()):SetPoint("TOPLEFT", 3, -4)
				select(2, tab:GetRegions()):SetPoint("BOTTOMRIGHT", -1, 0)
			else
				select(2, tab:GetRegions()):SetPoint("TOPLEFT", 2, -4)
				select(2, tab:GetRegions()):SetPoint("BOTTOMRIGHT", -1, -1)
			end

			tab.bg = CreateFrame("Frame", nil, tab)
			tab.bg:SetPoint("TOPLEFT", 2, -3)
			tab.bg:SetPoint("BOTTOMRIGHT", 0, -1)
			tab.bg:SetFrameLevel(0)
			F.CreateBD(tab.bg)

			tab.Hider:SetPoint("TOPLEFT", tab.bg, 1, -1)
			tab.Hider:SetPoint("BOTTOMRIGHT", tab.bg, -1, 1)
		end

		for i = 1, NUM_GEARSET_ICONS_SHOWN do
			local bu = _G["GearManagerDialogPopupButton"..i]
			local ic = _G["GearManagerDialogPopupButton"..i.."Icon"]

			bu:SetCheckedTexture(C.media.checked)
			select(2, bu:GetRegions()):Hide()
			ic:SetPoint("TOPLEFT", 1, -1)
			ic:SetPoint("BOTTOMRIGHT", -1, 1)
			ic:SetTexCoord(.08, .92, .08, .92)

			F.CreateBD(bu, .25)
		end

		local sets = false
		PaperDollSidebarTab3:HookScript("OnClick", function()
			if sets == false then
				for i = 1, 9 do
					local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
					local bd = _G["PaperDollEquipmentManagerPaneButton"..i.."Stripe"]
					local ic = _G["PaperDollEquipmentManagerPaneButton"..i.."Icon"]
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgTop"]:SetAlpha(0)
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgMiddle"]:Hide()
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgBottom"]:SetAlpha(0)

					bu.HighlightBar:SetTexture(r, g, b, .1)
					bu.HighlightBar:SetDrawLayer("BACKGROUND")
					bu.SelectedBar:SetTexture(r, g, b, .2)
					bu.SelectedBar:SetDrawLayer("BACKGROUND")

					bd:Hide()
					bd.Show = F.dummy
					ic:SetTexCoord(.08, .92, .08, .92)

					F.CreateBG(ic)
				end
				sets = true
			end
		end)

		hooksecurefunc("EquipmentFlyout_DisplayButton", function(button)
			if not button.styled then
				button:SetNormalTexture("")
				button:SetPushedTexture("")
				button.bg = F.CreateBG(button)

				button.icon:SetTexCoord(.08, .92, .08, .92)

				button.styled = true
			end

			if AuroraConfig.qualityColour then
				local location = button.location
				if not location then return end
				if location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then return end

				local id = EquipmentManager_GetItemInfoByLocation(location)
				local _, _, quality = GetItemInfo(id)
				local r, g, b = GetItemQualityColor(quality)

				if r == 1 and g == 1 then r, g, b = 0, 0, 0 end

				button.bg:SetVertexColor(r, g, b)
			end
		end)

		-- Quest Frame

		F.ReskinPortraitFrame(QuestLogFrame, true)
		F.ReskinPortraitFrame(QuestLogDetailFrame, true)
		F.ReskinPortraitFrame(QuestFrame, true)

		F.CreateBD(QuestLogCount, .25)

		QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
		QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
		QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
		QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
		EmptyQuestLogFrame:DisableDrawLayer("BACKGROUND")
		QuestFrameDetailPanel:DisableDrawLayer("BORDER")
		QuestFrameRewardPanel:DisableDrawLayer("BORDER")

		select(18, QuestLogFrame:GetRegions()):Hide()
		select(18, QuestLogDetailFrame:GetRegions()):Hide()

		QuestLogFramePageBg:Hide()
		QuestLogFrameBookBg:Hide()
		QuestLogDetailFramePageBg:Hide()
		QuestLogScrollFrameTop:Hide()
		QuestLogScrollFrameBottom:Hide()
		QuestLogScrollFrameMiddle:Hide()
		QuestLogDetailScrollFrameTop:Hide()
		QuestLogDetailScrollFrameBottom:Hide()
		QuestLogDetailScrollFrameMiddle:Hide()
		QuestDetailScrollFrameTop:Hide()
		QuestDetailScrollFrameBottom:Hide()
		QuestDetailScrollFrameMiddle:Hide()
		QuestProgressScrollFrameTop:Hide()
		QuestProgressScrollFrameBottom:Hide()
		QuestProgressScrollFrameMiddle:Hide()
		QuestRewardScrollFrameTop:Hide()
		QuestRewardScrollFrameBottom:Hide()
		QuestRewardScrollFrameMiddle:Hide()
		QuestGreetingScrollFrameTop:Hide()
		QuestGreetingScrollFrameBottom:Hide()
		QuestGreetingScrollFrameMiddle:Hide()
		QuestDetailLeftBorder:Hide()
		QuestDetailBotLeftCorner:Hide()
		QuestDetailTopLeftCorner:Hide()

		QuestNPCModelShadowOverlay:Hide()
		QuestNPCModelBg:Hide()
		QuestNPCModel:DisableDrawLayer("OVERLAY")
		QuestNPCModelNameText:SetDrawLayer("ARTWORK")
		QuestNPCModelTextFrameBg:Hide()
		QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")

		for i = 1, 9 do
			select(i, QuestLogCount:GetRegions()):Hide()
		end

		QuestLogDetailTitleText:SetDrawLayer("OVERLAY")
		QuestInfoItemHighlight:GetRegions():Hide()
		QuestInfoSpellObjectiveFrameNameFrame:Hide()
		QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
		QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
		QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
		QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)

		QuestLogFramePushQuestButton:ClearAllPoints()
		QuestLogFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", 1, 0)
		QuestLogFramePushQuestButton:SetWidth(100)
		QuestLogFrameTrackButton:ClearAllPoints()
		QuestLogFrameTrackButton:SetPoint("LEFT", QuestLogFramePushQuestButton, "RIGHT", 1, 0)

		QuestLogFrameShowMapButton.texture:Hide()
		QuestLogFrameShowMapButtonHighlight:SetAlpha(0)
		QuestLogFrameShowMapButton:SetSize(QuestLogFrameShowMapButton.text:GetStringWidth() + 14, 22)
		QuestLogFrameShowMapButton.text:ClearAllPoints()
		QuestLogFrameShowMapButton.text:SetPoint("CENTER", 1, 0)
		F.Reskin(QuestLogFrameShowMapButton)

		local line = QuestFrameGreetingPanel:CreateTexture()
		line:SetTexture(1, 1, 1, .2)
		line:SetSize(256, 1)
		line:SetPoint("CENTER", QuestGreetingFrameHorizontalBreak)

		QuestGreetingFrameHorizontalBreak:SetTexture("")

		QuestFrameGreetingPanel:HookScript("OnShow", function()
			line:SetShown(QuestGreetingFrameHorizontalBreak:IsShown())
		end)

		local npcbd = CreateFrame("Frame", nil, QuestNPCModel)
		npcbd:SetPoint("TOPLEFT", -1, 1)
		npcbd:SetPoint("RIGHT", 1, 0)
		npcbd:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
		npcbd:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
		F.CreateBD(npcbd)

		local npcLine = CreateFrame("Frame", nil, QuestNPCModel)
		npcLine:SetPoint("BOTTOMLEFT", 0, -1)
		npcLine:SetPoint("BOTTOMRIGHT", 0, -1)
		npcLine:SetHeight(1)
		npcLine:SetFrameLevel(QuestNPCModel:GetFrameLevel()-1)
		F.CreateBD(npcLine, 0)

		QuestInfoSkillPointFrameIconTexture:SetSize(40, 40)
		QuestInfoSkillPointFrameIconTexture:SetTexCoord(.08, .92, .08, .92)

		local bg = CreateFrame("Frame", nil, QuestInfoSkillPointFrame)
		bg:SetPoint("TOPLEFT", -3, 0)
		bg:SetPoint("BOTTOMRIGHT", -3, 0)
		bg:Lower()
		F.CreateBD(bg, .25)

		QuestInfoSkillPointFrameNameFrame:Hide()
		QuestInfoSkillPointFrameName:SetParent(bg)
		QuestInfoSkillPointFrameIconTexture:SetParent(bg)
		QuestInfoSkillPointFrameSkillPointBg:SetParent(bg)
		QuestInfoSkillPointFrameSkillPointBgGlow:SetParent(bg)
		QuestInfoSkillPointFramePoints:SetParent(bg)

		local skillPointLine = QuestInfoSkillPointFrame:CreateTexture(nil, "BACKGROUND")
		skillPointLine:SetSize(1, 40)
		skillPointLine:SetPoint("RIGHT", QuestInfoSkillPointFrameIconTexture, 1, 0)
		skillPointLine:SetTexture(C.media.backdrop)
		skillPointLine:SetVertexColor(0, 0, 0)

		QuestInfoRewardSpellIconTexture:SetSize(40, 40)
		QuestInfoRewardSpellIconTexture:SetTexCoord(.08, .92, .08, .92)
		QuestInfoRewardSpellIconTexture:SetDrawLayer("OVERLAY")

		local bg = CreateFrame("Frame", nil, QuestInfoRewardSpell)
		bg:SetPoint("TOPLEFT", 9, -1)
		bg:SetPoint("BOTTOMRIGHT", -10, 13)
		bg:Lower()
		F.CreateBD(bg, .25)

		QuestInfoRewardSpellNameFrame:Hide()
		QuestInfoRewardSpellSpellBorder:Hide()
		QuestInfoRewardSpellName:SetParent(bg)
		QuestInfoRewardSpellIconTexture:SetParent(bg)

		local spellLine = QuestInfoRewardSpell:CreateTexture(nil, "BACKGROUND")
		spellLine:SetSize(1, 40)
		spellLine:SetPoint("RIGHT", QuestInfoRewardSpellIconTexture, 1, 0)
		spellLine:SetTexture(C.media.backdrop)
		spellLine:SetVertexColor(0, 0, 0)

		local function clearHighlight()
			for i = 1, MAX_NUM_ITEMS do
				_G["QuestInfoItem"..i]:SetBackdropColor(0, 0, 0, .25)
			end
		end

		local function setHighlight(self)
			clearHighlight()

			local _, point = self:GetPoint()
			point:SetBackdropColor(r, g, b, .2)
		end

		hooksecurefunc(QuestInfoItemHighlight, "SetPoint", setHighlight)
		QuestInfoItemHighlight:HookScript("OnShow", setHighlight)
		QuestInfoItemHighlight:HookScript("OnHide", clearHighlight)

		for i = 1, MAX_REQUIRED_ITEMS do
			local bu = _G["QuestProgressItem"..i]
			local ic = _G["QuestProgressItem"..i.."IconTexture"]
			local na = _G["QuestProgressItem"..i.."NameFrame"]
			local co = _G["QuestProgressItem"..i.."Count"]

			ic:SetSize(40, 40)
			ic:SetTexCoord(.08, .92, .08, .92)
			ic:SetDrawLayer("OVERLAY")

			F.CreateBD(bu, .25)

			na:Hide()
			co:SetDrawLayer("OVERLAY")

			local line = CreateFrame("Frame", nil, bu)
			line:SetSize(1, 40)
			line:SetPoint("RIGHT", ic, 1, 0)
			F.CreateBD(line)
		end

		for i = 1, MAX_NUM_ITEMS do
			local bu = _G["QuestInfoItem"..i]
			local ic = _G["QuestInfoItem"..i.."IconTexture"]
			local na = _G["QuestInfoItem"..i.."NameFrame"]
			local co = _G["QuestInfoItem"..i.."Count"]

			ic:SetPoint("TOPLEFT", 1, -1)
			ic:SetSize(39, 39)
			ic:SetTexCoord(.08, .92, .08, .92)
			ic:SetDrawLayer("OVERLAY")

			F.CreateBD(bu, .25)

			na:Hide()
			co:SetDrawLayer("OVERLAY")

			local line = CreateFrame("Frame", nil, bu)
			line:SetSize(1, 40)
			line:SetPoint("RIGHT", ic, 1, 0)
			F.CreateBD(line)
		end

		local function updateQuest()
			local numEntries = GetNumQuestLogEntries()

			local buttons = QuestLogScrollFrame.buttons
			local numButtons = #buttons
			local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
			local questLogTitle, questIndex
			local isHeader, isCollapsed

			for i = 1, numButtons do
				questLogTitle = buttons[i]
				questIndex = i + scrollOffset

				if not questLogTitle.reskinned then
					questLogTitle.reskinned = true

					questLogTitle:SetNormalTexture("")
					questLogTitle.SetNormalTexture = F.dummy
					questLogTitle:SetPushedTexture("")
					questLogTitle:SetHighlightTexture("")
					questLogTitle.SetHighlightTexture = F.dummy

					questLogTitle.bg = CreateFrame("Frame", nil, questLogTitle)
					questLogTitle.bg:SetSize(13, 13)
					questLogTitle.bg:SetPoint("LEFT", 4, 0)
					questLogTitle.bg:SetFrameLevel(questLogTitle:GetFrameLevel()-1)
					F.CreateBD(questLogTitle.bg, 0)

					questLogTitle.tex = F.CreateGradient(questLogTitle)
					questLogTitle.tex:SetAllPoints(questLogTitle.bg)

					questLogTitle.minus = questLogTitle:CreateTexture(nil, "OVERLAY")
					questLogTitle.minus:SetSize(7, 1)
					questLogTitle.minus:SetPoint("CENTER", questLogTitle.bg)
					questLogTitle.minus:SetTexture(C.media.backdrop)
					questLogTitle.minus:SetVertexColor(1, 1, 1)

					questLogTitle.plus = questLogTitle:CreateTexture(nil, "OVERLAY")
					questLogTitle.plus:SetSize(1, 7)
					questLogTitle.plus:SetPoint("CENTER", questLogTitle.bg)
					questLogTitle.plus:SetTexture(C.media.backdrop)
					questLogTitle.plus:SetVertexColor(1, 1, 1)
				end

				if questIndex <= numEntries then
					_, _, _, _, isHeader, isCollapsed = GetQuestLogTitle(questIndex)
					if isHeader then
						questLogTitle.bg:Show()
						questLogTitle.tex:Show()
						questLogTitle.minus:Show()
						if isCollapsed then
							questLogTitle.plus:Show()
						else
							questLogTitle.plus:Hide()
						end
					else
						questLogTitle.bg:Hide()
						questLogTitle.tex:Hide()
						questLogTitle.minus:Hide()
						questLogTitle.plus:Hide()
					end
				end
			end
		end

		hooksecurefunc("QuestLog_Update", updateQuest)
		QuestLogScrollFrame:HookScript("OnVerticalScroll", updateQuest)
		QuestLogScrollFrame:HookScript("OnMouseWheel", updateQuest)

		hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, _, y)
			QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", 2, y)
		end)

		hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", function(self, r, g, b)
			if r == 0 then
				self:SetTextColor(.8, .8, .8)
			elseif r == .2 then
				self:SetTextColor(1, 1, 1)
			end
		end)

		local questButtons = {"QuestLogFrameAbandonButton", "QuestLogFramePushQuestButton", "QuestLogFrameTrackButton", "QuestLogFrameCancelButton", "QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "QuestFrameGreetingGoodbyeButton", "QuestLogFrameCompleteButton"}
		for i = 1, #questButtons do
			F.Reskin(_G[questButtons[i]])
		end

		F.ReskinScroll(QuestLogScrollFrameScrollBar)
		F.ReskinScroll(QuestLogDetailScrollFrameScrollBar)
		F.ReskinScroll(QuestProgressScrollFrameScrollBar)
		F.ReskinScroll(QuestRewardScrollFrameScrollBar)
		F.ReskinScroll(QuestDetailScrollFrameScrollBar)
		F.ReskinScroll(QuestGreetingScrollFrameScrollBar)
		F.ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)

		-- Gossip Frame

		GossipGreetingScrollFrameTop:Hide()
		GossipGreetingScrollFrameBottom:Hide()
		GossipGreetingScrollFrameMiddle:Hide()
		select(19, GossipFrame:GetRegions()):Hide()

		GossipGreetingText:SetTextColor(1, 1, 1)

		NPCFriendshipStatusBar:GetRegions():Hide()
		NPCFriendshipStatusBarNotch1:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch1:SetSize(1, 16)
		NPCFriendshipStatusBarNotch2:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch2:SetSize(1, 16)
		NPCFriendshipStatusBarNotch3:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch3:SetSize(1, 16)
		NPCFriendshipStatusBarNotch4:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch4:SetSize(1, 16)
		select(7, NPCFriendshipStatusBar:GetRegions()):Hide()

		NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
		F.CreateBDFrame(NPCFriendshipStatusBar, .25)

		F.ReskinPortraitFrame(GossipFrame, true)
		F.Reskin(GossipFrameGreetingGoodbyeButton)
		F.ReskinScroll(GossipGreetingScrollFrameScrollBar)

		-- PvP cap bar

		local function CaptureBar()
			if not NUM_EXTENDED_UI_FRAMES then return end
			for i = 1, NUM_EXTENDED_UI_FRAMES do
				local barname = "WorldStateCaptureBar"..i
				local bar = _G[barname]

				if bar and bar:IsVisible() then
					bar:ClearAllPoints()
					bar:SetPoint("TOP", UIParent, "TOP", 0, -120)
					if not bar.skinned then
						local left = _G[barname.."LeftBar"]
						local right = _G[barname.."RightBar"]
						local middle = _G[barname.."MiddleBar"]

						left:SetTexture(C.media.backdrop)
						right:SetTexture(C.media.backdrop)
						middle:SetTexture(C.media.backdrop)
						left:SetDrawLayer("BORDER")
						middle:SetDrawLayer("ARTWORK")
						right:SetDrawLayer("BORDER")

						left:SetGradient("VERTICAL", .1, .4, .9, .2, .6, 1)
						right:SetGradient("VERTICAL", .7, .1, .1, .9, .2, .2)
						middle:SetGradient("VERTICAL", .8, .8, .8, 1, 1, 1)

						_G[barname.."RightLine"]:SetAlpha(0)
						_G[barname.."LeftLine"]:SetAlpha(0)
						select(4, bar:GetRegions()):Hide()
						_G[barname.."LeftIconHighlight"]:SetAlpha(0)
						_G[barname.."RightIconHighlight"]:SetAlpha(0)

						bar.bg = bar:CreateTexture(nil, "BACKGROUND")
						bar.bg:SetPoint("TOPLEFT", left, -1, 1)
						bar.bg:SetPoint("BOTTOMRIGHT", right, 1, -1)
						bar.bg:SetTexture(C.media.backdrop)
						bar.bg:SetVertexColor(0, 0, 0)

						bar.bgmiddle = CreateFrame("Frame", nil, bar)
						bar.bgmiddle:SetPoint("TOPLEFT", middle, -1, 1)
						bar.bgmiddle:SetPoint("BOTTOMRIGHT", middle, 1, -1)
						F.CreateBD(bar.bgmiddle, 0)

						bar.skinned = true
					end
				end
			end
		end

		hooksecurefunc("UIParent_ManageFramePositions", CaptureBar)

		-- Achievement popup

		local function fixBg(f)
			if f:GetObjectType() == "AnimationGroup" then
				f = f:GetParent()
			end
			f.bg:SetBackdropColor(0, 0, 0, AuroraConfig.alpha)
		end

		hooksecurefunc("AlertFrame_FixAnchors", function()
			for i = 1, MAX_ACHIEVEMENT_ALERTS do
				local frame = _G["AchievementAlertFrame"..i]

				if frame then
					frame:SetAlpha(1)
					frame.SetAlpha = F.dummy

					local ic = _G["AchievementAlertFrame"..i.."Icon"]
					local texture = _G["AchievementAlertFrame"..i.."IconTexture"]
					local guildName = _G["AchievementAlertFrame"..i.."GuildName"]

					ic:ClearAllPoints()
					ic:SetPoint("LEFT", frame, "LEFT", -26, 0)

					if not frame.bg then
						frame.bg = CreateFrame("Frame", nil, frame)
						frame.bg:SetPoint("TOPLEFT", texture, -10, 12)
						frame.bg:SetPoint("BOTTOMRIGHT", texture, "BOTTOMRIGHT", 240, -12)
						frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
						F.CreateBD(frame.bg)

						frame:HookScript("OnEnter", fixBg)
						frame:HookScript("OnShow", fixBg)
						frame.animIn:HookScript("OnFinished", fixBg)
						F.CreateBD(frame.bg)

						F.CreateBG(texture)

						_G["AchievementAlertFrame"..i.."Background"]:Hide()
						_G["AchievementAlertFrame"..i.."IconOverlay"]:Hide()
						_G["AchievementAlertFrame"..i.."GuildBanner"]:SetTexture("")
						_G["AchievementAlertFrame"..i.."GuildBorder"]:SetTexture("")
						_G["AchievementAlertFrame"..i.."OldAchievement"]:SetTexture("")

						guildName:ClearAllPoints()
						guildName:SetPoint("TOPLEFT", 50, -14)
						guildName:SetPoint("TOPRIGHT", -50, -14)

						_G["AchievementAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
						_G["AchievementAlertFrame"..i.."Unlocked"]:SetShadowOffset(1, -1)
					end

					frame.glow:Hide()
					frame.shine:Hide()
					frame.glow.Show = F.dummy
					frame.shine.Show = F.dummy

					texture:SetTexCoord(.08, .92, .08, .92)

					if guildName:IsShown() then
						_G["AchievementAlertFrame"..i.."Shield"]:SetPoint("TOPRIGHT", -10, -22)
					end
				end
			end
		end)

		-- Guild challenges

		local challenge = CreateFrame("Frame", nil, GuildChallengeAlertFrame)
		challenge:SetPoint("TOPLEFT", 8, -12)
		challenge:SetPoint("BOTTOMRIGHT", -8, 13)
		challenge:SetFrameLevel(GuildChallengeAlertFrame:GetFrameLevel()-1)
		F.CreateBD(challenge)
		F.CreateBG(GuildChallengeAlertFrameEmblemBackground)

		GuildChallengeAlertFrameGlow:SetTexture("")
		GuildChallengeAlertFrameShine:SetTexture("")
		GuildChallengeAlertFrameEmblemBorder:SetTexture("")

		-- Dungeon completion rewards

		local bg = CreateFrame("Frame", nil, DungeonCompletionAlertFrame1)
		bg:SetPoint("TOPLEFT", 6, -14)
		bg:SetPoint("BOTTOMRIGHT", -6, 6)
		bg:SetFrameLevel(DungeonCompletionAlertFrame1:GetFrameLevel()-1)
		F.CreateBD(bg)

		DungeonCompletionAlertFrame1DungeonTexture:SetDrawLayer("ARTWORK")
		DungeonCompletionAlertFrame1DungeonTexture:SetTexCoord(.02, .98, .02, .98)
		F.CreateBG(DungeonCompletionAlertFrame1DungeonTexture)

		DungeonCompletionAlertFrame1.dungeonArt1:SetAlpha(0)
		DungeonCompletionAlertFrame1.dungeonArt2:SetAlpha(0)
		DungeonCompletionAlertFrame1.dungeonArt3:SetAlpha(0)
		DungeonCompletionAlertFrame1.dungeonArt4:SetAlpha(0)
		DungeonCompletionAlertFrame1.raidArt:SetAlpha(0)

		DungeonCompletionAlertFrame1.dungeonTexture:SetPoint("BOTTOMLEFT", DungeonCompletionAlertFrame1, "BOTTOMLEFT", 13, 13)
		DungeonCompletionAlertFrame1.dungeonTexture.SetPoint = F.dummy

		DungeonCompletionAlertFrame1.shine:Hide()
		DungeonCompletionAlertFrame1.shine.Show = F.dummy
		DungeonCompletionAlertFrame1.glow:Hide()
		DungeonCompletionAlertFrame1.glow.Show = F.dummy

		hooksecurefunc("DungeonCompletionAlertFrame_ShowAlert", function()
			local bu = DungeonCompletionAlertFrame1Reward1
			local index = 1

			while bu do
				if not bu.styled then
					_G["DungeonCompletionAlertFrame1Reward"..index.."Border"]:Hide()

					bu.texture:SetTexCoord(.08, .92, .08, .92)
					F.CreateBG(bu.texture)

					bu.styled = true
				end

				index = index + 1
				bu = _G["DungeonCompletionAlertFrame1Reward"..index]
			end
		end)

		-- Challenge popup

		hooksecurefunc("AlertFrame_SetChallengeModeAnchors", function()
			local frame = ChallengeModeAlertFrame1

			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = F.dummy

				if not frame.bg then
					frame.bg = CreateFrame("Frame", nil, frame)
					frame.bg:SetPoint("TOPLEFT", ChallengeModeAlertFrame1DungeonTexture, -12, 12)
					frame.bg:SetPoint("BOTTOMRIGHT", ChallengeModeAlertFrame1DungeonTexture, 243, -12)
					frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
					F.CreateBD(frame.bg)

					frame:HookScript("OnEnter", fixBg)
					frame:HookScript("OnShow", fixBg)
					frame.animIn:HookScript("OnFinished", fixBg)

					F.CreateBG(ChallengeModeAlertFrame1DungeonTexture)
				end

				frame:GetRegions():Hide()

				ChallengeModeAlertFrame1Shine:Hide()
				ChallengeModeAlertFrame1Shine.Show = F.dummy
				ChallengeModeAlertFrame1GlowFrame:Hide()
				ChallengeModeAlertFrame1GlowFrame.Show = F.dummy
				ChallengeModeAlertFrame1Border:Hide()
				ChallengeModeAlertFrame1Border.Show = F.dummy

				ChallengeModeAlertFrame1DungeonTexture:SetTexCoord(.08, .92, .08, .92)
			end
		end)

		-- Scenario alert

		hooksecurefunc("AlertFrame_SetScenarioAnchors", function()
			local frame = ScenarioAlertFrame1

			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = F.dummy

				if not frame.bg then
					frame.bg = CreateFrame("Frame", nil, frame)
					frame.bg:SetPoint("TOPLEFT", ScenarioAlertFrame1DungeonTexture, -12, 12)
					frame.bg:SetPoint("BOTTOMRIGHT", ScenarioAlertFrame1DungeonTexture, 244, -12)
					frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
					F.CreateBD(frame.bg)

					frame:HookScript("OnEnter", fixBg)
					frame:HookScript("OnShow", fixBg)
					frame.animIn:HookScript("OnFinished", fixBg)

					F.CreateBG(ScenarioAlertFrame1DungeonTexture)
					ScenarioAlertFrame1DungeonTexture:SetDrawLayer("OVERLAY")
				end

				frame:GetRegions():Hide()
				select(3, frame:GetRegions()):Hide()

				ScenarioAlertFrame1Shine:Hide()
				ScenarioAlertFrame1Shine.Show = F.dummy
				ScenarioAlertFrame1GlowFrame:Hide()
				ScenarioAlertFrame1GlowFrame.Show = F.dummy

				ScenarioAlertFrame1DungeonTexture:SetTexCoord(.08, .92, .08, .92)
			end
		end)

		hooksecurefunc("ScenarioAlertFrame_ShowAlert", function()
			local bu = ScenarioAlertFrame1Reward1
			local index = 1

			while bu do
				if not bu.styled then
					_G["ScenarioAlertFrame1Reward"..index.."Border"]:Hide()

					bu.texture:SetTexCoord(.08, .92, .08, .92)
					F.CreateBG(bu.texture)

					bu.styled = true
				end

				index = index + 1
				bu = _G["ScenarioAlertFrame1Reward"..index]
			end
		end)

		-- Loot won alert

		-- I still don't know why I can't parent bg to frame
		local function showHideBg(self)
			self.bg:SetShown(self:IsShown())
		end

		local function onUpdate(self)
			self.bg:SetAlpha(self:GetAlpha())
		end

		hooksecurefunc("LootWonAlertFrame_SetUp", function(frame)
			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, UIParent)
				frame.bg:SetPoint("TOPLEFT", frame, 10, -10)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, -10, 10)
				frame.bg:SetFrameStrata("DIALOG")
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
				frame.bg:SetShown(frame:IsShown())
				F.CreateBD(frame.bg)

				frame:HookScript("OnShow", showHideBg)
				frame:HookScript("OnHide", showHideBg)
				frame:HookScript("OnUpdate", onUpdate)

				frame.Background:Hide()
				frame.IconBorder:Hide()
				frame.glow:SetTexture("")
				frame.shine:SetTexture("")

				frame.Icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBG(frame.Icon)
			end
		end)

		-- Money won alert

		hooksecurefunc("MoneyWonAlertFrame_SetUp", function(frame)
			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, UIParent)
				frame.bg:SetPoint("TOPLEFT", frame, 10, -10)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, -10, 10)
				frame.bg:SetFrameStrata("DIALOG")
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
				frame.bg:SetShown(frame:IsShown())
				F.CreateBD(frame.bg)

				frame:HookScript("OnShow", showHideBg)
				frame:HookScript("OnHide", showHideBg)
				frame:HookScript("OnUpdate", onUpdate)

				frame.Background:Hide()
				frame.IconBorder:Hide()

				frame.Icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBG(frame.Icon)
			end
		end)

		-- Criteria alert

		hooksecurefunc("CriteriaAlertFrame_ShowAlert", function()
			for i = 1, MAX_ACHIEVEMENT_ALERTS do
				local frame = _G["CriteriaAlertFrame"..i]
				if frame and not frame.bg then
					local icon = _G["CriteriaAlertFrame"..i.."IconTexture"]

					frame.bg = CreateFrame("Frame", nil, UIParent)
					frame.bg:SetPoint("TOPLEFT", icon, -6, 5)
					frame.bg:SetPoint("BOTTOMRIGHT", icon, 236, -5)
					frame.bg:SetFrameStrata("DIALOG")
					frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
					frame.bg:SetShown(frame:IsShown())
					F.CreateBD(frame.bg)

					frame:SetScript("OnShow", showHideBg)
					frame:SetScript("OnHide", showHideBg)
					frame:HookScript("OnUpdate", onUpdate)

					_G["CriteriaAlertFrame"..i.."Background"]:Hide()
					_G["CriteriaAlertFrame"..i.."IconOverlay"]:Hide()
					frame.glow:Hide()
					frame.glow.Show = F.dummy
					frame.shine:Hide()
					frame.shine.Show = F.dummy

					_G["CriteriaAlertFrame"..i.."Unlocked"]:SetTextColor(.9, .9, .9)

					icon:SetTexCoord(.08, .92, .08, .92)
					F.CreateBG(icon)
				end
			end
		end)

		-- Help frame

		for i = 1, 15 do
			local bu = _G["HelpFrameKnowledgebaseScrollFrameButton"..i]
			bu:DisableDrawLayer("ARTWORK")
			F.CreateBD(bu, 0)

			F.CreateGradient(bu)
		end

		local function colourTab(f)
			f.text:SetTextColor(1, 1, 1)
			f:SetBackdropBorderColor(r, g, b)
		end

		local function clearTab(f)
			f.text:SetTextColor(1, .82, 0)
			f:SetBackdropBorderColor(0, 0, 0)
		end

		local function styleTab(bu)
			bu.selected:SetTexture(r, g, b, .2)
			bu.selected:SetDrawLayer("BACKGROUND")
			bu.text:SetFont(C.media.font, 14)
			F.Reskin(bu, true)
			bu:SetScript("OnEnter", colourTab)
			bu:SetScript("OnLeave", clearTab)
		end

		for i = 1, 6 do
			styleTab(_G["HelpFrameButton"..i])
		end
		styleTab(HelpFrameButton16)

		HelpFrameAccountSecurityOpenTicket.text:SetFont(C.media.font, 14)
		HelpFrameOpenTicketHelpOpenTicket.text:SetFont(C.media.font, 14)
		HelpFrameOpenTicketHelpTopIssues.text:SetFont(C.media.font, 14)
		HelpFrameOpenTicketHelpItemRestoration.text:SetFont(C.media.font, 14)

		HelpFrameCharacterStuckHearthstone:SetSize(56, 56)
		F.CreateBG(HelpFrameCharacterStuckHearthstone)
		HelpFrameCharacterStuckHearthstoneIconTexture:SetTexCoord(.08, .92, .08, .92)

		-- Option panels

		local options = false
		VideoOptionsFrame:HookScript("OnShow", function()
			if options == true then return end
			options = true

			local line = VideoOptionsFrame:CreateTexture(nil, "ARTWORK")
			line:SetSize(1, 512)
			line:SetPoint("LEFT", 205, 30)
			line:SetTexture(1, 1, 1, .2)

			F.CreateBD(AudioOptionsSoundPanelPlayback, .25)
			F.CreateBD(AudioOptionsSoundPanelHardware, .25)
			F.CreateBD(AudioOptionsSoundPanelVolume, .25)
			F.CreateBD(AudioOptionsVoicePanelTalking, .25)
			F.CreateBD(AudioOptionsVoicePanelBinding, .25)
			F.CreateBD(AudioOptionsVoicePanelListening, .25)

			AudioOptionsSoundPanelPlaybackTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelPlayback, "TOPLEFT", 5, 2)
			AudioOptionsSoundPanelHardwareTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelHardware, "TOPLEFT", 5, 2)
			AudioOptionsSoundPanelVolumeTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelVolume, "TOPLEFT", 5, 2)
			AudioOptionsVoicePanelTalkingTitle:SetPoint("BOTTOMLEFT", AudioOptionsVoicePanelTalking, "TOPLEFT", 5, 2)
			AudioOptionsVoicePanelListeningTitle:SetPoint("BOTTOMLEFT", AudioOptionsVoicePanelListening, "TOPLEFT", 5, 2)

			local dropdowns = {"Graphics_DisplayModeDropDown", "Graphics_ResolutionDropDown", "Graphics_RefreshDropDown", "Graphics_PrimaryMonitorDropDown", "Graphics_MultiSampleDropDown", "Graphics_VerticalSyncDropDown", "Graphics_TextureResolutionDropDown", "Graphics_FilteringDropDown", "Graphics_ProjectedTexturesDropDown", "Graphics_ShadowsDropDown", "Graphics_LiquidDetailDropDown", "Graphics_SunshaftsDropDown", "Graphics_ParticleDensityDropDown", "Graphics_ViewDistanceDropDown", "Graphics_EnvironmentalDetailDropDown", "Graphics_GroundClutterDropDown", "Graphics_SSAODropDown", "Advanced_BufferingDropDown", "Advanced_LagDropDown", "Advanced_HardwareCursorDropDown", "InterfaceOptionsLanguagesPanelLocaleDropDown", "AudioOptionsSoundPanelHardwareDropDown", "AudioOptionsSoundPanelSoundChannelsDropDown", "AudioOptionsVoicePanelInputDeviceDropDown", "AudioOptionsVoicePanelChatModeDropDown", "AudioOptionsVoicePanelOutputDeviceDropDown"}
			for i = 1, #dropdowns do
				F.ReskinDropDown(_G[dropdowns[i]])
			end

			Graphics_RightQuality:GetRegions():Hide()
			Graphics_RightQuality:DisableDrawLayer("BORDER")

			local sliders = {"Graphics_Quality", "Advanced_UIScaleSlider", "Advanced_MaxFPSSlider", "Advanced_MaxFPSBKSlider", "Advanced_GammaSlider", "AudioOptionsSoundPanelSoundQuality", "AudioOptionsSoundPanelMasterVolume", "AudioOptionsSoundPanelSoundVolume", "AudioOptionsSoundPanelMusicVolume", "AudioOptionsSoundPanelAmbienceVolume", "AudioOptionsVoicePanelMicrophoneVolume", "AudioOptionsVoicePanelSpeakerVolume", "AudioOptionsVoicePanelSoundFade", "AudioOptionsVoicePanelMusicFade", "AudioOptionsVoicePanelAmbienceFade"}
			for i = 1, #sliders do
				F.ReskinSlider(_G[sliders[i]])
			end

			Graphics_Quality.SetBackdrop = F.dummy

			local checkboxes = {"Advanced_UseUIScale", "Advanced_MaxFPSCheckBox", "Advanced_MaxFPSBKCheckBox", "Advanced_DesktopGamma", "NetworkOptionsPanelOptimizeSpeed", "NetworkOptionsPanelUseIPv6", "AudioOptionsSoundPanelEnableSound", "AudioOptionsSoundPanelSoundEffects", "AudioOptionsSoundPanelErrorSpeech", "AudioOptionsSoundPanelEmoteSounds", "AudioOptionsSoundPanelPetSounds", "AudioOptionsSoundPanelMusic", "AudioOptionsSoundPanelLoopMusic", "AudioOptionsSoundPanelPetBattleMusic", "AudioOptionsSoundPanelAmbientSounds", "AudioOptionsSoundPanelSoundInBG", "AudioOptionsSoundPanelReverb", "AudioOptionsSoundPanelHRTF", "AudioOptionsSoundPanelEnableDSPs", "AudioOptionsSoundPanelUseHardware", "AudioOptionsVoicePanelEnableVoice", "AudioOptionsVoicePanelEnableMicrophone", "AudioOptionsVoicePanelPushToTalkSound"}
			for i = 1, #checkboxes do
				F.ReskinCheck(_G[checkboxes[i]])
			end

			F.Reskin(RecordLoopbackSoundButton)
			F.Reskin(PlayLoopbackSoundButton)
			F.Reskin(AudioOptionsVoicePanelChatMode1KeyBindingButton)
		end)

		local interface = false
		InterfaceOptionsFrame:HookScript("OnShow", function()
			if interface == true then return end
			interface = true

			local line = InterfaceOptionsFrame:CreateTexture(nil, "ARTWORK")
			line:SetSize(1, 546)
			line:SetPoint("LEFT", 205, 10)
			line:SetTexture(1, 1, 1, .2)

			local checkboxes = {"InterfaceOptionsControlsPanelStickyTargeting", "InterfaceOptionsControlsPanelAutoDismount", "InterfaceOptionsControlsPanelAutoClearAFK", "InterfaceOptionsControlsPanelBlockTrades", "InterfaceOptionsControlsPanelBlockGuildInvites", "InterfaceOptionsControlsPanelLootAtMouse", "InterfaceOptionsControlsPanelAutoLootCorpse", "InterfaceOptionsControlsPanelInteractOnLeftClick", "InterfaceOptionsCombatPanelAttackOnAssist", "InterfaceOptionsCombatPanelStopAutoAttack", "InterfaceOptionsNamesPanelUnitNameplatesNameplateClassColors", "InterfaceOptionsCombatPanelTargetOfTarget", "InterfaceOptionsCombatPanelShowSpellAlerts", "InterfaceOptionsCombatPanelReducedLagTolerance", "InterfaceOptionsCombatPanelActionButtonUseKeyDown", "InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait", "InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates", "InterfaceOptionsCombatPanelAutoSelfCast", "InterfaceOptionsCombatPanelLossOfControl", "InterfaceOptionsDisplayPanelShowCloak", "InterfaceOptionsDisplayPanelShowHelm", "InterfaceOptionsDisplayPanelShowAggroPercentage", "InterfaceOptionsDisplayPanelPlayAggroSounds", "InterfaceOptionsDisplayPanelShowSpellPointsAvg", "InterfaceOptionsDisplayPanelShowFreeBagSpace", "InterfaceOptionsDisplayPanelCinematicSubtitles", "InterfaceOptionsDisplayPanelRotateMinimap", "InterfaceOptionsDisplayPanelShowAccountAchievments", "InterfaceOptionsObjectivesPanelAutoQuestTracking", "InterfaceOptionsObjectivesPanelMapQuestDifficulty", "InterfaceOptionsObjectivesPanelWatchFrameWidth", "InterfaceOptionsSocialPanelProfanityFilter", "InterfaceOptionsSocialPanelSpamFilter", "InterfaceOptionsSocialPanelChatBubbles", "InterfaceOptionsSocialPanelPartyChat", "InterfaceOptionsSocialPanelChatHoverDelay", "InterfaceOptionsSocialPanelGuildMemberAlert", "InterfaceOptionsSocialPanelChatMouseScroll", "InterfaceOptionsSocialPanelWholeChatWindowClickable", "InterfaceOptionsActionBarsPanelBottomLeft", "InterfaceOptionsActionBarsPanelBottomRight", "InterfaceOptionsActionBarsPanelRight", "InterfaceOptionsActionBarsPanelRightTwo", "InterfaceOptionsActionBarsPanelLockActionBars", "InterfaceOptionsActionBarsPanelAlwaysShowActionBars", "InterfaceOptionsActionBarsPanelSecureAbilityToggle", "InterfaceOptionsNamesPanelMyName", "InterfaceOptionsNamesPanelFriendlyPlayerNames", "InterfaceOptionsNamesPanelFriendlyPets", "InterfaceOptionsNamesPanelFriendlyGuardians", "InterfaceOptionsNamesPanelFriendlyTotems", "InterfaceOptionsNamesPanelUnitNameplatesFriends", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyPets", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyGuardians", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyTotems", "InterfaceOptionsNamesPanelGuilds", "InterfaceOptionsNamesPanelGuildTitles", "InterfaceOptionsNamesPanelTitles", "InterfaceOptionsNamesPanelNonCombatCreature", "InterfaceOptionsNamesPanelEnemyPlayerNames", "InterfaceOptionsNamesPanelEnemyPets", "InterfaceOptionsNamesPanelEnemyGuardians", "InterfaceOptionsNamesPanelEnemyTotems", "InterfaceOptionsNamesPanelUnitNameplatesEnemies", "InterfaceOptionsNamesPanelUnitNameplatesEnemyPets", "InterfaceOptionsNamesPanelUnitNameplatesEnemyGuardians", "InterfaceOptionsNamesPanelUnitNameplatesEnemyTotems", "InterfaceOptionsCombatTextPanelTargetDamage", "InterfaceOptionsCombatTextPanelPeriodicDamage", "InterfaceOptionsCombatTextPanelPetDamage", "InterfaceOptionsCombatTextPanelHealing", "InterfaceOptionsCombatTextPanelTargetEffects", "InterfaceOptionsCombatTextPanelOtherTargetEffects", "InterfaceOptionsCombatTextPanelEnableFCT", "InterfaceOptionsCombatTextPanelDodgeParryMiss", "InterfaceOptionsCombatTextPanelDamageReduction", "InterfaceOptionsCombatTextPanelRepChanges", "InterfaceOptionsCombatTextPanelReactiveAbilities", "InterfaceOptionsCombatTextPanelFriendlyHealerNames", "InterfaceOptionsCombatTextPanelCombatState", "InterfaceOptionsCombatTextPanelComboPoints", "InterfaceOptionsCombatTextPanelLowManaHealth", "InterfaceOptionsCombatTextPanelEnergyGains", "InterfaceOptionsCombatTextPanelPeriodicEnergyGains", "InterfaceOptionsCombatTextPanelHonorGains", "InterfaceOptionsCombatTextPanelAuras", "InterfaceOptionsStatusTextPanelPlayer", "InterfaceOptionsStatusTextPanelPet", "InterfaceOptionsStatusTextPanelParty", "InterfaceOptionsStatusTextPanelTarget", "InterfaceOptionsStatusTextPanelAlternateResource", "InterfaceOptionsStatusTextPanelXP", "InterfaceOptionsBattlenetPanelOnlineFriends", "InterfaceOptionsBattlenetPanelOfflineFriends", "InterfaceOptionsBattlenetPanelBroadcasts", "InterfaceOptionsBattlenetPanelFriendRequests", "InterfaceOptionsBattlenetPanelConversations", "InterfaceOptionsBattlenetPanelShowToastWindow", "InterfaceOptionsCameraPanelFollowTerrain", "InterfaceOptionsCameraPanelHeadBob", "InterfaceOptionsCameraPanelWaterCollision", "InterfaceOptionsCameraPanelSmartPivot", "InterfaceOptionsMousePanelInvertMouse", "InterfaceOptionsMousePanelClickToMove", "InterfaceOptionsMousePanelWoWMouse", "InterfaceOptionsHelpPanelShowTutorials", "InterfaceOptionsHelpPanelEnhancedTooltips", "InterfaceOptionsHelpPanelShowLuaErrors", "InterfaceOptionsHelpPanelColorblindMode", "InterfaceOptionsHelpPanelMovePad", "InterfaceOptionsControlsPanelAutoOpenLootHistory", "InterfaceOptionsUnitFramePanelPartyPets", "InterfaceOptionsUnitFramePanelArenaEnemyFrames", "InterfaceOptionsUnitFramePanelArenaEnemyCastBar", "InterfaceOptionsUnitFramePanelArenaEnemyPets", "InterfaceOptionsUnitFramePanelFullSizeFocusFrame", "InterfaceOptionsBuffsPanelDispellableDebuffs", "InterfaceOptionsBuffsPanelCastableBuffs", "InterfaceOptionsBuffsPanelConsolidateBuffs", "InterfaceOptionsBuffsPanelShowAllEnemyDebuffs"}
			for i = 1, #checkboxes do
				F.ReskinCheck(_G[checkboxes[i]])
			end

			local dropdowns = {"InterfaceOptionsControlsPanelAutoLootKeyDropDown", "InterfaceOptionsCombatPanelFocusCastKeyDropDown", "InterfaceOptionsCombatPanelSelfCastKeyDropDown", "InterfaceOptionsCombatPanelLossOfControlFullDropDown", "InterfaceOptionsCombatPanelLossOfControlSilenceDropDown", "InterfaceOptionsCombatPanelLossOfControlInterruptDropDown", "InterfaceOptionsCombatPanelLossOfControlDisarmDropDown", "InterfaceOptionsCombatPanelLossOfControlRootDropDown", "InterfaceOptionsSocialPanelChatStyle", "InterfaceOptionsSocialPanelTimestamps", "InterfaceOptionsSocialPanelWhisperMode", "InterfaceOptionsSocialPanelBnWhisperMode", "InterfaceOptionsSocialPanelConversationMode", "InterfaceOptionsActionBarsPanelPickupActionKeyDropDown", "InterfaceOptionsNamesPanelNPCNamesDropDown", "InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown", "InterfaceOptionsCombatTextPanelFCTDropDown", "InterfaceOptionsStatusTextPanelDisplayDropDown", "InterfaceOptionsCameraPanelStyleDropDown", "InterfaceOptionsMousePanelClickMoveStyleDropDown"}
			for i = 1, #dropdowns do
				F.ReskinDropDown(_G[dropdowns[i]])
			end

			local sliders = {"InterfaceOptionsCombatPanelSpellAlertOpacitySlider", "InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset", "InterfaceOptionsBattlenetPanelToastDurationSlider", "InterfaceOptionsCameraPanelMaxDistanceSlider", "InterfaceOptionsCameraPanelFollowSpeedSlider", "InterfaceOptionsMousePanelMouseSensitivitySlider", "InterfaceOptionsMousePanelMouseLookSpeedSlider"}
			for i = 1, #sliders do
				F.ReskinSlider(_G[sliders[i]])
			end

			F.Reskin(InterfaceOptionsHelpPanelResetTutorials)

			if IsAddOnLoaded("Blizzard_CompactRaidFrames") then
				CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()

				local boxes = {CompactUnitFrameProfilesRaidStylePartyFrames, CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether, CompactUnitFrameProfilesGeneralOptionsFrameDisplayIncomingHeals, CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar, CompactUnitFrameProfilesGeneralOptionsFrameDisplayAggroHighlight, CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors, CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets, CompactUnitFrameProfilesGeneralOptionsFrameDisplayMainTankAndAssist, CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder, CompactUnitFrameProfilesGeneralOptionsFrameShowDebuffs, CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate10Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate15Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate25Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate40Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec1, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec2, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE}

				for _, box in next, boxes do
					F.ReskinCheck(box)
				end

				F.Reskin(CompactUnitFrameProfilesSaveButton)
				F.Reskin(CompactUnitFrameProfilesDeleteButton)
				F.Reskin(CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton)
				F.ReskinDropDown(CompactUnitFrameProfilesProfileSelector)
				F.ReskinDropDown(CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown)
				F.ReskinDropDown(CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown)
				F.ReskinSlider(CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider)
				F.ReskinSlider(CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider)
			end
		end)

		hooksecurefunc("InterfaceOptions_AddCategory", function()
			local num = #INTERFACEOPTIONS_ADDONCATEGORIES
			for i = 1, num do
				local bu = _G["InterfaceOptionsFrameAddOnsButton"..i.."Toggle"]
				if bu and not bu.reskinned then
					F.ReskinExpandOrCollapse(bu)
					bu:SetPushedTexture("")
					bu.SetPushedTexture = F.dummy
					bu.reskinned = true
				end
			end
		end)

		hooksecurefunc("OptionsListButtonToggle_OnClick", function(self)
			if self:GetParent().element.collapsed then
				self.plus:Show()
			else
				self.plus:Hide()
			end
		end)

		-- SideDressUp

		SideDressUpModel:HookScript("OnShow", function(self)
			self:ClearAllPoints()
			self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", 1, 0)
		end)

		SideDressUpModel.bg = CreateFrame("Frame", nil, SideDressUpModel)
		SideDressUpModel.bg:SetPoint("TOPLEFT", 0, 1)
		SideDressUpModel.bg:SetPoint("BOTTOMRIGHT", 1, -1)
		SideDressUpModel.bg:SetFrameLevel(SideDressUpModel:GetFrameLevel()-1)
		F.CreateBD(SideDressUpModel.bg)

		-- Trade Frame

		TradePlayerEnchantInset:DisableDrawLayer("BORDER")
		TradePlayerItemsInset:DisableDrawLayer("BORDER")
		TradeRecipientEnchantInset:DisableDrawLayer("BORDER")
		TradeRecipientItemsInset:DisableDrawLayer("BORDER")
		TradePlayerInputMoneyInset:DisableDrawLayer("BORDER")
		TradeRecipientMoneyInset:DisableDrawLayer("BORDER")
		TradeRecipientBG:Hide()
		TradePlayerEnchantInsetBg:Hide()
		TradePlayerItemsInsetBg:Hide()
		TradePlayerInputMoneyInsetBg:Hide()
		TradeRecipientEnchantInsetBg:Hide()
		TradeRecipientItemsInsetBg:Hide()
		TradeRecipientMoneyBg:Hide()
		TradeRecipientPortraitFrame:Hide()
		TradeRecipientBotLeftCorner:Hide()
		TradeRecipientLeftBorder:Hide()
		select(4, TradePlayerItem7:GetRegions()):Hide()
		select(4, TradeRecipientItem7:GetRegions()):Hide()
		TradeFramePlayerPortrait:Hide()
		TradeFrameRecipientPortrait:Hide()

		F.ReskinPortraitFrame(TradeFrame, true)
		F.Reskin(TradeFrameTradeButton)
		F.Reskin(TradeFrameCancelButton)
		F.ReskinInput(TradePlayerInputMoneyFrameGold)
		F.ReskinInput(TradePlayerInputMoneyFrameSilver)
		F.ReskinInput(TradePlayerInputMoneyFrameCopper)

		TradePlayerInputMoneyFrameSilver:SetPoint("LEFT", TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
		TradePlayerInputMoneyFrameCopper:SetPoint("LEFT", TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

		for i = 1, MAX_TRADE_ITEMS do
			local bu1 = _G["TradePlayerItem"..i.."ItemButton"]
			local bu2 = _G["TradeRecipientItem"..i.."ItemButton"]

			_G["TradePlayerItem"..i.."SlotTexture"]:Hide()
			_G["TradePlayerItem"..i.."NameFrame"]:Hide()
			_G["TradeRecipientItem"..i.."SlotTexture"]:Hide()
			_G["TradeRecipientItem"..i.."NameFrame"]:Hide()

			bu1:SetNormalTexture("")
			bu1:SetPushedTexture("")
			bu1.icon:SetTexCoord(.08, .92, .08, .92)
			bu2:SetNormalTexture("")
			bu2:SetPushedTexture("")
			bu2.icon:SetTexCoord(.08, .92, .08, .92)

			local bg1 = CreateFrame("Frame", nil, bu1)
			bg1:SetPoint("TOPLEFT", -1, 1)
			bg1:SetPoint("BOTTOMRIGHT", 1, -1)
			bg1:SetFrameLevel(bu1:GetFrameLevel()-1)
			F.CreateBD(bg1, .25)

			local bg2 = CreateFrame("Frame", nil, bu2)
			bg2:SetPoint("TOPLEFT", -1, 1)
			bg2:SetPoint("BOTTOMRIGHT", 1, -1)
			bg2:SetFrameLevel(bu2:GetFrameLevel()-1)
			F.CreateBD(bg2, .25)
		end

		-- Tutorial Frame

		F.CreateBD(TutorialFrame)
		F.CreateSD(TutorialFrame)

		TutorialFrameBackground:Hide()
		TutorialFrameBackground.Show = F.dummy
		TutorialFrame:DisableDrawLayer("BORDER")

		F.Reskin(TutorialFrameOkayButton, true)
		F.ReskinClose(TutorialFrameCloseButton)
		F.ReskinArrow(TutorialFramePrevButton, "left")
		F.ReskinArrow(TutorialFrameNextButton, "right")

		TutorialFrameOkayButton:ClearAllPoints()
		TutorialFrameOkayButton:SetPoint("BOTTOMLEFT", TutorialFrameNextButton, "BOTTOMRIGHT", 10, 0)

		-- because gradient alpha and OnUpdate doesn't work for some reason...

		select(14, TutorialFrameOkayButton:GetRegions()):Hide()
		select(15, TutorialFramePrevButton:GetRegions()):Hide()
		select(15, TutorialFrameNextButton:GetRegions()):Hide()
		select(14, TutorialFrameCloseButton:GetRegions()):Hide()
		TutorialFramePrevButton:SetScript("OnEnter", nil)
		TutorialFrameNextButton:SetScript("OnEnter", nil)
		TutorialFrameOkayButton:SetBackdropColor(0, 0, 0, .25)
		TutorialFramePrevButton:SetBackdropColor(0, 0, 0, .25)
		TutorialFrameNextButton:SetBackdropColor(0, 0, 0, .25)

		-- Loot history

		for i = 1, 9 do
			select(i, LootHistoryFrame:GetRegions()):Hide()
		end
		LootHistoryFrameScrollFrame:GetRegions():Hide()

		LootHistoryFrame.ResizeButton:SetPoint("TOP", LootHistoryFrame, "BOTTOM", 0, -1)
		LootHistoryFrame.ResizeButton:SetFrameStrata("LOW")

		F.ReskinArrow(LootHistoryFrame.ResizeButton, "down")
		LootHistoryFrame.ResizeButton:SetSize(32, 12)

		F.CreateBD(LootHistoryFrame)
		F.CreateSD(LootHistoryFrame)

		F.ReskinClose(LootHistoryFrame.CloseButton)
		F.ReskinScroll(LootHistoryFrameScrollFrameScrollBar)

		hooksecurefunc("LootHistoryFrame_UpdateItemFrame", function(self, frame)
			local rollID, _, _, isDone, winnerIdx = C_LootHistory.GetItem(frame.itemIdx)
			local expanded = self.expandedRolls[rollID]

			if not frame.styled then
				frame.Divider:Hide()
				frame.NameBorderLeft:Hide()
				frame.NameBorderRight:Hide()
				frame.NameBorderMid:Hide()
				frame.IconBorder:Hide()

				frame.WinnerRoll:SetTextColor(.9, .9, .9)

				frame.Icon:SetTexCoord(.08, .92, .08, .92)
				frame.Icon:SetDrawLayer("ARTWORK")
				frame.bg = F.CreateBG(frame.Icon)
				frame.bg:SetVertexColor(frame.IconBorder:GetVertexColor())

				F.ReskinExpandOrCollapse(frame.ToggleButton)
				frame.ToggleButton:GetNormalTexture():SetAlpha(0)
				frame.ToggleButton:GetPushedTexture():SetAlpha(0)
				frame.ToggleButton:GetDisabledTexture():SetAlpha(0)

				frame.styled = true
			end

			if isDone and not expanded and winnerIdx then
				local name, class = C_LootHistory.GetPlayerInfo(frame.itemIdx, winnerIdx)
				if name then
					local colour = C.classcolours[class]
					frame.WinnerName:SetVertexColor(colour.r, colour.g, colour.b)
				end
			end

			frame.bg:SetVertexColor(frame.IconBorder:GetVertexColor())
			frame.ToggleButton.plus:SetShown(not expanded)
		end)

		hooksecurefunc("LootHistoryFrame_UpdatePlayerFrame", function(_, playerFrame)
			if not playerFrame.styled then
				playerFrame.RollText:SetTextColor(.9, .9, .9)
				playerFrame.WinMark:SetDesaturated(true)

				playerFrame.styled = true
			end

			if playerFrame.playerIdx then
				local name, class, _, _, isWinner = C_LootHistory.GetPlayerInfo(playerFrame.itemIdx, playerFrame.playerIdx)

				if name then
					local colour = C.classcolours[class]
					playerFrame.PlayerName:SetTextColor(colour.r, colour.g, colour.b)

					if isWinner then
						playerFrame.WinMark:SetVertexColor(colour.r, colour.g, colour.b)
					end
				end
			end
		end)

		LootHistoryDropDown.initialize = function(self)
			local info = UIDropDownMenu_CreateInfo();
			info.isTitle = 1;
			info.text = MASTER_LOOTER;
			info.fontObject = GameFontNormalLeft;
			info.notCheckable = 1;
			UIDropDownMenu_AddButton(info);

			info = UIDropDownMenu_CreateInfo();
			info.notCheckable = 1;
			local name, class = C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx);
			local classColor = C.classcolours[class];
			local colorCode = string.format("|cFF%02x%02x%02x",  classColor.r*255,  classColor.g*255,  classColor.b*255);
			info.text = string.format(MASTER_LOOTER_GIVE_TO, colorCode..name.."|r");
			info.func = LootHistoryDropDown_OnClick;
			UIDropDownMenu_AddButton(info);
		end

		-- Master looter frame

		for i = 1, 9 do
			select(i, MasterLooterFrame:GetRegions()):Hide()
		end

		MasterLooterFrame.Item.NameBorderLeft:Hide()
		MasterLooterFrame.Item.NameBorderRight:Hide()
		MasterLooterFrame.Item.NameBorderMid:Hide()
		MasterLooterFrame.Item.IconBorder:Hide()

		MasterLooterFrame.Item.Icon:SetTexCoord(.08, .92, .08, .92)
		MasterLooterFrame.Item.Icon:SetDrawLayer("ARTWORK")
		MasterLooterFrame.Item.bg = F.CreateBG(MasterLooterFrame.Item.Icon)

		MasterLooterFrame:HookScript("OnShow", function(self)
			self.Item.bg:SetVertexColor(self.Item.IconBorder:GetVertexColor())
			LootFrame:SetAlpha(.4)
		end)

		MasterLooterFrame:HookScript("OnHide", function(self)
			LootFrame:SetAlpha(1)
		end)

		F.CreateBD(MasterLooterFrame)
		F.ReskinClose(select(3, MasterLooterFrame:GetChildren()))

		hooksecurefunc("MasterLooterFrame_UpdatePlayers", function()
			for i = 1, MAX_RAID_MEMBERS do
				local playerFrame = MasterLooterFrame["player"..i]
				if playerFrame then
					if not playerFrame.styled then
						playerFrame.Bg:SetPoint("TOPLEFT", 1, -1)
						playerFrame.Bg:SetPoint("BOTTOMRIGHT", -1, 1)
						playerFrame.Highlight:SetPoint("TOPLEFT", 1, -1)
						playerFrame.Highlight:SetPoint("BOTTOMRIGHT", -1, 1)

						playerFrame.Highlight:SetTexture(C.media.backdrop)

						F.CreateBD(playerFrame, 0)

						playerFrame.styled = true
					end
					local colour = C.classcolours[select(2, UnitClass(playerFrame.Name:GetText()))]
					playerFrame.Name:SetTextColor(colour.r, colour.g, colour.b)
					playerFrame.Highlight:SetVertexColor(colour.r, colour.g, colour.b, .2)
				else
					break
				end
			end
		end)

		-- Missing loot frame

		MissingLootFrameCorner:Hide()

		hooksecurefunc("MissingLootFrame_Show", function()
			for i = 1, GetNumMissingLootItems() do
				local bu = _G["MissingLootFrameItem"..i]

				if not bu.styled then
					_G["MissingLootFrameItem"..i.."NameFrame"]:Hide()

					bu.icon:SetTexCoord(.08, .92, .08, .92)
					F.CreateBG(bu.icon)

					bu.styled = true
				end
			end
		end)

		F.CreateBD(MissingLootFrame)
		F.ReskinClose(MissingLootFramePassButton)

		-- BN conversation

		BNConversationInviteDialogHeader:SetTexture("")

		F.CreateBD(BNConversationInviteDialog)
		F.CreateBD(BNConversationInviteDialogList, .25)

		F.Reskin(BNConversationInviteDialogInviteButton)
		F.Reskin(BNConversationInviteDialogCancelButton)
		F.ReskinScroll(BNConversationInviteDialogListScrollFrameScrollBar)
		for i = 1, BN_CONVERSATION_INVITE_NUM_DISPLAYED do
			F.ReskinCheck(_G["BNConversationInviteDialogListFriend"..i].checkButton)
		end

		-- Taxi Frame

		TaxiFrame:DisableDrawLayer("BORDER")
		TaxiFrame:DisableDrawLayer("OVERLAY")
		TaxiFrame.Bg:Hide()
		TaxiFrame.TitleBg:Hide()

		F.SetBD(TaxiFrame, 3, -23, -5, 3)
		F.ReskinClose(TaxiFrame.CloseButton, "TOPRIGHT", TaxiRouteMap, "TOPRIGHT", -4, -4)

		-- Tabard frame

		TabardFrameMoneyInset:DisableDrawLayer("BORDER")
		TabardFrameCustomizationBorder:Hide()
		TabardFrameMoneyBg:Hide()
		TabardFrameMoneyInsetBg:Hide()

		for i = 19, 28 do
			select(i, TabardFrame:GetRegions()):Hide()
		end

		for i = 1, 5 do
			_G["TabardFrameCustomization"..i.."Left"]:Hide()
			_G["TabardFrameCustomization"..i.."Middle"]:Hide()
			_G["TabardFrameCustomization"..i.."Right"]:Hide()
			F.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
			F.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
		end

		F.ReskinPortraitFrame(TabardFrame, true)
		F.CreateBD(TabardFrameCostFrame, .25)
		F.Reskin(TabardFrameAcceptButton)
		F.Reskin(TabardFrameCancelButton)

		-- Guild registrar frame

		GuildRegistrarFrameTop:Hide()
		GuildRegistrarFrameBottom:Hide()
		GuildRegistrarFrameMiddle:Hide()
		select(19, GuildRegistrarFrame:GetRegions()):Hide()
		select(6, GuildRegistrarFrameEditBox:GetRegions()):Hide()
		select(7, GuildRegistrarFrameEditBox:GetRegions()):Hide()

		GuildRegistrarFrameEditBox:SetHeight(20)

		F.ReskinPortraitFrame(GuildRegistrarFrame, true)
		F.CreateBD(GuildRegistrarFrameEditBox, .25)
		F.Reskin(GuildRegistrarFrameGoodbyeButton)
		F.Reskin(GuildRegistrarFramePurchaseButton)
		F.Reskin(GuildRegistrarFrameCancelButton)

		-- World state score frame

		select(2, WorldStateScoreScrollFrame:GetRegions()):Hide()
		select(3, WorldStateScoreScrollFrame:GetRegions()):Hide()

		WorldStateScoreFrameTab2:SetPoint("LEFT", WorldStateScoreFrameTab1, "RIGHT", -15, 0)
		WorldStateScoreFrameTab3:SetPoint("LEFT", WorldStateScoreFrameTab2, "RIGHT", -15, 0)

		F.ReskinPortraitFrame(WorldStateScoreFrame, true)
		F.Reskin(WorldStateScoreFrameLeaveButton)
		F.ReskinScroll(WorldStateScoreScrollFrameScrollBar)

		for i = 1, 3 do
			F.ReskinTab(_G["WorldStateScoreFrameTab"..i])
		end

		-- Item text

		select(18, ItemTextFrame:GetRegions()):Hide()
		InboxFrameBg:Hide()
		ItemTextScrollFrameMiddle:SetAlpha(0)
		ItemTextScrollFrameTop:SetAlpha(0)
		ItemTextScrollFrameBottom:SetAlpha(0)
		ItemTextPrevPageButton:GetRegions():Hide()
		ItemTextNextPageButton:GetRegions():Hide()
		ItemTextMaterialTopLeft:SetAlpha(0)
		ItemTextMaterialTopRight:SetAlpha(0)
		ItemTextMaterialBotLeft:SetAlpha(0)
		ItemTextMaterialBotRight:SetAlpha(0)

		F.ReskinPortraitFrame(ItemTextFrame, true)
		F.ReskinScroll(ItemTextScrollFrameScrollBar)
		F.ReskinArrow(ItemTextPrevPageButton, "left")
		F.ReskinArrow(ItemTextNextPageButton, "right")

		-- Petition frame

		select(18, PetitionFrame:GetRegions()):Hide()
		select(19, PetitionFrame:GetRegions()):Hide()
		select(23, PetitionFrame:GetRegions()):Hide()
		select(24, PetitionFrame:GetRegions()):Hide()
		PetitionFrameTop:Hide()
		PetitionFrameBottom:Hide()
		PetitionFrameMiddle:Hide()

		F.ReskinPortraitFrame(PetitionFrame, true)
		F.Reskin(PetitionFrameSignButton)
		F.Reskin(PetitionFrameRequestButton)
		F.Reskin(PetitionFrameRenameButton)
		F.Reskin(PetitionFrameCancelButton)

		-- Mac options

		if IsMacClient() then
			F.CreateBD(MacOptionsFrame)
			MacOptionsFrameHeader:SetTexture("")
			MacOptionsFrameHeader:ClearAllPoints()
			MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)

			F.CreateBD(MacOptionsFrameMovieRecording, .25)
			F.CreateBD(MacOptionsITunesRemote, .25)
			F.CreateBD(MacOptionsFrameMisc, .25)

			F.Reskin(MacOptionsButtonKeybindings)
			F.Reskin(MacOptionsButtonCompress)
			F.Reskin(MacOptionsFrameCancel)
			F.Reskin(MacOptionsFrameOkay)
			F.Reskin(MacOptionsFrameDefaults)

			F.ReskinDropDown(MacOptionsFrameResolutionDropDown)
			F.ReskinDropDown(MacOptionsFrameFramerateDropDown)
			F.ReskinDropDown(MacOptionsFrameCodecDropDown)

			for i = 1, 11 do
				F.ReskinCheck(_G["MacOptionsFrameCheckButton"..i])
			end
			F.ReskinSlider(MacOptionsFrameQualitySlider)

			MacOptionsButtonCompress:SetWidth(136)

			MacOptionsFrameCancel:SetWidth(96)
			MacOptionsFrameCancel:SetHeight(22)
			MacOptionsFrameCancel:ClearAllPoints()
			MacOptionsFrameCancel:SetPoint("LEFT", MacOptionsButtonKeybindings, "RIGHT", 107, 0)

			MacOptionsFrameOkay:SetWidth(96)
			MacOptionsFrameOkay:SetHeight(22)
			MacOptionsFrameOkay:ClearAllPoints()
			MacOptionsFrameOkay:SetPoint("LEFT", MacOptionsButtonKeybindings, "RIGHT", 5, 0)

			MacOptionsButtonKeybindings:SetWidth(96)
			MacOptionsButtonKeybindings:SetHeight(22)
			MacOptionsButtonKeybindings:ClearAllPoints()
			MacOptionsButtonKeybindings:SetPoint("LEFT", MacOptionsFrameDefaults, "RIGHT", 5, 0)

			MacOptionsFrameDefaults:SetWidth(96)
			MacOptionsFrameDefaults:SetHeight(22)
		end

		-- Micro button alerts

		local microButtons = {TalentMicroButtonAlert, CompanionsMicroButtonAlert}
			for _, button in pairs(microButtons) do
			button:DisableDrawLayer("BACKGROUND")
			button:DisableDrawLayer("BORDER")
			button.Arrow:Hide()

			F.SetBD(button)
			F.ReskinClose(button.CloseButton)
		end

		-- Cinematic popup

		CinematicFrameCloseDialog:HookScript("OnShow", function(self)
			self:SetScale(UIParent:GetScale())
		end)

		F.CreateBD(CinematicFrameCloseDialog)
		F.CreateSD(CinematicFrameCloseDialog)
		F.Reskin(CinematicFrameCloseDialogConfirmButton)
		F.Reskin(CinematicFrameCloseDialogResumeButton)

		-- Bonus roll

		BonusRollFrame.Background:SetAlpha(0)
		BonusRollFrame.IconBorder:Hide()
		BonusRollFrame.BlackBackgroundHoist.Background:Hide()

		BonusRollFrame.PromptFrame.Icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(BonusRollFrame.PromptFrame.Icon)

		BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(C.media.backdrop)

		F.CreateBD(BonusRollFrame)
		F.CreateBDFrame(BonusRollFrame.PromptFrame.Timer, .25)

		-- Chat config

		hooksecurefunc("ChatConfig_CreateCheckboxes", function(frame, checkBoxTable, checkBoxTemplate)
			if frame.styled then return end

			frame:SetBackdrop(nil)

			local checkBoxNameString = frame:GetName().."CheckBox"

			if checkBoxTemplate == "ChatConfigCheckBoxTemplate" then
				for index, value in ipairs(checkBoxTable) do
					local checkBoxName = checkBoxNameString..index
					local checkbox = _G[checkBoxName]

					checkbox:SetBackdrop(nil)

					local bg = CreateFrame("Frame", nil, checkbox)
					bg:SetPoint("TOPLEFT")
					bg:SetPoint("BOTTOMRIGHT", 0, 1)
					bg:SetFrameLevel(checkbox:GetFrameLevel()-1)
					F.CreateBD(bg, .25)

					F.ReskinCheck(_G[checkBoxName.."Check"])
				end
			elseif checkBoxTemplate == "ChatConfigCheckBoxWithSwatchTemplate" or checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate" then
				for index, value in ipairs(checkBoxTable) do
					local checkBoxName = checkBoxNameString..index
					local checkbox = _G[checkBoxName]

					checkbox:SetBackdrop(nil)

					local bg = CreateFrame("Frame", nil, checkbox)
					bg:SetPoint("TOPLEFT")
					bg:SetPoint("BOTTOMRIGHT", 0, 1)
					bg:SetFrameLevel(checkbox:GetFrameLevel()-1)
					F.CreateBD(bg, .25)

					F.ReskinColourSwatch(_G[checkBoxName.."ColorSwatch"])

					F.ReskinCheck(_G[checkBoxName.."Check"])

					if checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate" then
						F.ReskinCheck(_G[checkBoxName.."ColorClasses"])
					end
				end
			end

			frame.styled = true
		end)

		hooksecurefunc("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable, checkBoxTemplate, subCheckBoxTemplate)
			if frame.styled then return end

			local checkBoxNameString = frame:GetName().."CheckBox"

			for index, value in ipairs(checkBoxTable) do
				local checkBoxName = checkBoxNameString..index

				F.ReskinCheck(_G[checkBoxName])

				if value.subTypes then
					local subCheckBoxNameString = checkBoxName.."_"

					for k, v in ipairs(value.subTypes) do
						F.ReskinCheck(_G[subCheckBoxNameString..k])
					end
				end
			end

			frame.styled = true
		end)

		hooksecurefunc("ChatConfig_CreateColorSwatches", function(frame, swatchTable, swatchTemplate)
			if frame.styled then return end

			frame:SetBackdrop(nil)

			local nameString = frame:GetName().."Swatch"

			for index, value in ipairs(swatchTable) do
				local swatchName = nameString..index
				local swatch = _G[swatchName]

				swatch:SetBackdrop(nil)

				local bg = CreateFrame("Frame", nil, swatch)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 1)
				bg:SetFrameLevel(swatch:GetFrameLevel()-1)
				F.CreateBD(bg, .25)

				F.ReskinColourSwatch(_G[swatchName.."ColorSwatch"])
			end

			frame.styled = true
		end)

		for i = 1, 5 do
			_G["CombatConfigTab"..i.."Left"]:Hide()
			_G["CombatConfigTab"..i.."Middle"]:Hide()
			_G["CombatConfigTab"..i.."Right"]:Hide()
		end

		local line = ChatConfigFrame:CreateTexture()
		line:SetSize(1, 460)
		line:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "TOPRIGHT")
		line:SetTexture(1, 1, 1, .2)

		ChatConfigCategoryFrame:SetBackdrop(nil)
		ChatConfigBackgroundFrame:SetBackdrop(nil)
		ChatConfigCombatSettingsFilters:SetBackdrop(nil)
		CombatConfigColorsHighlighting:SetBackdrop(nil)
		CombatConfigColorsColorizeUnitName:SetBackdrop(nil)
		CombatConfigColorsColorizeSpellNames:SetBackdrop(nil)
		CombatConfigColorsColorizeDamageNumber:SetBackdrop(nil)
		CombatConfigColorsColorizeDamageSchool:SetBackdrop(nil)
		CombatConfigColorsColorizeEntireLine:SetBackdrop(nil)

		local combatBoxes = {CombatConfigColorsHighlightingLine, CombatConfigColorsHighlightingAbility, CombatConfigColorsHighlightingDamage, CombatConfigColorsHighlightingSchool, CombatConfigColorsColorizeUnitNameCheck, CombatConfigColorsColorizeSpellNamesCheck, CombatConfigColorsColorizeSpellNamesSchoolColoring, CombatConfigColorsColorizeDamageNumberCheck, CombatConfigColorsColorizeDamageNumberSchoolColoring, CombatConfigColorsColorizeDamageSchoolCheck, CombatConfigColorsColorizeEntireLineCheck, CombatConfigFormattingShowTimeStamp, CombatConfigFormattingShowBraces, CombatConfigFormattingUnitNames, CombatConfigFormattingSpellNames, CombatConfigFormattingItemNames, CombatConfigFormattingFullText, CombatConfigSettingsShowQuickButton, CombatConfigSettingsSolo, CombatConfigSettingsParty, CombatConfigSettingsRaid}

		for _, box in next, combatBoxes do
			F.ReskinCheck(box)
		end

		local bg = CreateFrame("Frame", nil, ChatConfigCombatSettingsFilters)
		bg:SetPoint("TOPLEFT", 3, 0)
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(ChatConfigCombatSettingsFilters:GetFrameLevel()-1)
		F.CreateBD(bg, .25)

		F.Reskin(CombatLogDefaultButton)
		F.Reskin(ChatConfigCombatSettingsFiltersCopyFilterButton)
		F.Reskin(ChatConfigCombatSettingsFiltersAddFilterButton)
		F.Reskin(ChatConfigCombatSettingsFiltersDeleteButton)
		F.Reskin(CombatConfigSettingsSaveButton)
		F.ReskinArrow(ChatConfigMoveFilterUpButton, "up")
		F.ReskinArrow(ChatConfigMoveFilterDownButton, "down")
		F.ReskinInput(CombatConfigSettingsNameEditBox)
		F.ReskinRadio(CombatConfigColorsColorizeEntireLineBySource)
		F.ReskinRadio(CombatConfigColorsColorizeEntireLineByTarget)
		F.ReskinColourSwatch(CombatConfigColorsColorizeSpellNamesColorSwatch)
		F.ReskinColourSwatch(CombatConfigColorsColorizeDamageNumberColorSwatch)

		ChatConfigMoveFilterUpButton:SetSize(28, 28)
		ChatConfigMoveFilterDownButton:SetSize(28, 28)

		ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0)
		ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0)
		ChatConfigMoveFilterUpButton:SetPoint("TOPLEFT", ChatConfigCombatSettingsFilters, "BOTTOMLEFT", 3, 0)
		ChatConfigMoveFilterDownButton:SetPoint("LEFT", ChatConfigMoveFilterUpButton, "RIGHT", 1, 0)

		-- Level up display

		LevelUpDisplaySide:HookScript("OnShow", function(self)
			for i = 1, #self.unlockList do
				local f = _G["LevelUpDisplaySideUnlockFrame"..i]

				if not f.restyled then
					f.icon:SetTexCoord(.08, .92, .08, .92)
					F.CreateBG(f.icon)
				end
			end
		end)

		-- Movie Frame

		MovieFrame.CloseDialog:HookScript("OnShow", function(self)
			self:SetScale(UIParent:GetScale())
		end)

		F.CreateBD(MovieFrame.CloseDialog)
		F.CreateSD(MovieFrame.CloseDialog)
		F.Reskin(MovieFrame.CloseDialog.ConfirmButton)
		F.Reskin(MovieFrame.CloseDialog.ResumeButton)

		-- Pet battle queue popup

		F.CreateBD(PetBattleQueueReadyFrame)
		F.CreateSD(PetBattleQueueReadyFrame)
		F.CreateBG(PetBattleQueueReadyFrame.Art)
		F.Reskin(PetBattleQueueReadyFrame.AcceptButton)
		F.Reskin(PetBattleQueueReadyFrame.DeclineButton)

		-- PVP Banner Frame

		for i = 1, 3 do
			for j = 1, 2 do
				select(i, _G["PVPBannerFrameCustomization"..j]:GetRegions()):Hide()
			end
		end

		for i = 18, 28 do
			select(i, PVPBannerFrame:GetRegions()):SetTexture("")
		end

		PVPBannerFrameCustomizationBorder:Hide()

		F.ReskinPortraitFrame(PVPBannerFrame, true)
		F.Reskin(select(6, PVPBannerFrame:GetChildren()))
		F.Reskin(PVPBannerFrameAcceptButton)
		F.Reskin(PVPColorPickerButton1)
		F.Reskin(PVPColorPickerButton2)
		F.Reskin(PVPColorPickerButton3)
		F.ReskinInput(PVPBannerFrameEditBox, 20)
		F.ReskinArrow(PVPBannerFrameCustomization1LeftButton, "left")
		F.ReskinArrow(PVPBannerFrameCustomization1RightButton, "right")
		F.ReskinArrow(PVPBannerFrameCustomization2LeftButton, "left")
		F.ReskinArrow(PVPBannerFrameCustomization2RightButton, "right")

		-- [[ Hide regions ]]

		local bglayers = {"SpellBookFrame", "LFDParentFrame", "LFDParentFrameInset", "WhoFrameColumnHeader1", "WhoFrameColumnHeader2", "WhoFrameColumnHeader3", "WhoFrameColumnHeader4", "RaidInfoInstanceLabel", "RaidInfoIDLabel", "CharacterFrameInsetRight", "LFRQueueFrame", "LFRBrowseFrame", "HelpFrameMainInset", "CharacterModelFrame", "HelpFrame", "HelpFrameLeftInset", "EquipmentFlyoutFrameButtons", "VideoOptionsFrameCategoryFrame", "InterfaceOptionsFrameCategories", "InterfaceOptionsFrameAddOns", "RaidParentFrame"}
		for i = 1, #bglayers do
			_G[bglayers[i]]:DisableDrawLayer("BACKGROUND")
		end
		local borderlayers = {"WhoFrameListInset", "WhoFrameEditBoxInset", "ChannelFrameLeftInset", "ChannelFrameRightInset", "SpellBookFrame", "SpellBookFrameInset", "LFDParentFrame", "LFDParentFrameInset", "CharacterFrameInsetRight", "HelpFrame", "HelpFrameLeftInset", "HelpFrameMainInset", "CharacterModelFrame", "VideoOptionsFramePanelContainer", "InterfaceOptionsFramePanelContainer", "RaidParentFrame", "RaidParentFrameInset", "RaidFinderFrameRoleInset", "LFRQueueFrameRoleInset", "LFRQueueFrameListInset", "LFRQueueFrameCommentInset"}
		for i = 1, #borderlayers do
			_G[borderlayers[i]]:DisableDrawLayer("BORDER")
		end
		local overlayers = {"SpellBookFrame", "LFDParentFrame", "CharacterModelFrame"}
		for i = 1, #overlayers do
			_G[overlayers[i]]:DisableDrawLayer("OVERLAY")
		end
		for i = 1, 6 do
			for j = 1, 3 do
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()):Hide()
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()).Show = F.dummy
			end
			select(i, ScrollOfResurrectionFrameNoteFrame:GetRegions()):Hide()
		end
		EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")
		OpenStationeryBackgroundLeft:Hide()
		OpenStationeryBackgroundRight:Hide()
		for i = 4, 7 do
			select(i, SendMailFrame:GetRegions()):Hide()
		end
		SendStationeryBackgroundLeft:Hide()
		SendStationeryBackgroundRight:Hide()
		DressUpFramePortrait:Hide()
		DressUpBackgroundTopLeft:Hide()
		DressUpBackgroundTopRight:Hide()
		DressUpBackgroundBotLeft:Hide()
		DressUpBackgroundBotRight:Hide()
		for i = 1, 4 do
			select(i, GearManagerDialogPopup:GetRegions()):Hide()
			select(i, SideDressUpFrame:GetRegions()):Hide()
		end
		StackSplitFrame:GetRegions():Hide()
		ReputationDetailCorner:Hide()
		ReputationDetailDivider:Hide()
		RaidInfoDetailFooter:Hide()
		RaidInfoDetailHeader:Hide()
		RaidInfoDetailCorner:Hide()
		RaidInfoFrameHeader:Hide()
		for i = 1, 9 do
			select(i, FriendsFriendsNoteFrame:GetRegions()):Hide()
			select(i, AddFriendNoteFrame:GetRegions()):Hide()
			select(i, ReportPlayerNameDialogCommentFrame:GetRegions()):Hide()
			select(i, ReportCheatingDialogCommentFrame:GetRegions()):Hide()
			select(i, QueueStatusFrame:GetRegions()):Hide()
		end
		HelpFrameHeader:Hide()
		ReadyCheckPortrait:SetAlpha(0)
		select(2, ReadyCheckListenerFrame:GetRegions()):Hide()
		HelpFrameLeftInsetBg:Hide()
		LFDQueueFrameBackground:Hide()
		select(3, HelpFrameReportBug:GetChildren()):Hide()
		select(3, HelpFrameSubmitSuggestion:GetChildren()):Hide()
		select(4, HelpFrameTicket:GetChildren()):Hide()
		HelpFrameKnowledgebaseStoneTex:Hide()
		HelpFrameKnowledgebaseNavBarOverlay:Hide()
		GhostFrameLeft:Hide()
		GhostFrameRight:Hide()
		GhostFrameMiddle:Hide()
		for i = 3, 6 do
			select(i, GhostFrame:GetRegions()):Hide()
		end
		PaperDollSidebarTabs:GetRegions():Hide()
		select(2, PaperDollSidebarTabs:GetRegions()):Hide()
		select(6, PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()
		select(5, HelpFrameGM_Response:GetChildren()):Hide()
		select(6, HelpFrameGM_Response:GetChildren()):Hide()
		HelpFrameKnowledgebaseNavBarHomeButtonLeft:Hide()
		TokenFramePopupCorner:Hide()
		GearManagerDialogPopupScrollFrame:GetRegions():Hide()
		select(2, GearManagerDialogPopupScrollFrame:GetRegions()):Hide()
		for i = 1, 10 do
			select(i, GuildInviteFrame:GetRegions()):Hide()
		end
		CharacterFrameExpandButton:GetNormalTexture():SetAlpha(0)
		CharacterFrameExpandButton:GetPushedTexture():SetAlpha(0)
		InboxPrevPageButton:GetRegions():Hide()
		InboxNextPageButton:GetRegions():Hide()
		MerchantPrevPageButton:GetRegions():Hide()
		MerchantNextPageButton:GetRegions():Hide()
		select(2, MerchantPrevPageButton:GetRegions()):Hide()
		select(2, MerchantNextPageButton:GetRegions()):Hide()
		BNToastFrameCloseButton:SetAlpha(0)
		LFDQueueFrameRandomScrollFrameScrollBackground:Hide()
		ChannelFrameDaughterFrameCorner:Hide()
		LFDQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
		LFDQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
		for i = 1, MAX_DISPLAY_CHANNEL_BUTTONS do
			_G["ChannelButton"..i]:SetNormalTexture("")
		end
		CharacterStatsPaneTop:Hide()
		CharacterStatsPaneBottom:Hide()
		hooksecurefunc("PaperDollFrame_CollapseStatCategory", function(categoryFrame)
			categoryFrame.BgMinimized:Hide()
		end)
		hooksecurefunc("PaperDollFrame_ExpandStatCategory", function(categoryFrame)
			categoryFrame.BgTop:Hide()
			categoryFrame.BgMiddle:Hide()
			categoryFrame.BgBottom:Hide()
		end)
		local titles = false
		hooksecurefunc("PaperDollTitlesPane_Update", function()
			if titles == false then
				for i = 1, 17 do
					_G["PaperDollTitlesPaneButton"..i]:DisableDrawLayer("BACKGROUND")
				end
				titles = true
			end
		end)
		ReputationListScrollFrame:GetRegions():Hide()
		select(2, ReputationListScrollFrame:GetRegions()):Hide()
		select(3, ReputationDetailFrame:GetRegions()):Hide()
		MerchantNameText:SetDrawLayer("ARTWORK")
		SendScrollBarBackgroundTop:Hide()
		select(4, SendMailScrollFrame:GetRegions()):Hide()
		for i = 1, 7 do
			_G["LFRBrowseFrameColumnHeader"..i]:DisableDrawLayer("BACKGROUND")
		end
		HelpFrameKnowledgebaseTopTileStreaks:Hide()
		for i = 2, 5 do
			select(i, DressUpFrame:GetRegions()):Hide()
		end
		ChannelFrameDaughterFrameTitlebar:Hide()
		OpenScrollBarBackgroundTop:Hide()
		select(2, OpenMailScrollFrame:GetRegions()):Hide()
		HelpFrameKnowledgebaseNavBar:GetRegions():Hide()
		select(2, WhoListScrollFrame:GetRegions()):Hide()
		select(2, GuildChallengeAlertFrame:GetRegions()):Hide()
		InterfaceOptionsFrameTab1TabSpacer:SetAlpha(0)
		for i = 1, 2 do
			_G["InterfaceOptionsFrameTab"..i.."Left"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."Middle"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."Right"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab2TabSpacer"..i]:SetAlpha(0)
		end
		ChannelRosterScrollFrameTop:SetAlpha(0)
		ChannelRosterScrollFrameBottom:SetAlpha(0)
		FriendsFrameFriendsScrollFrameTop:Hide()
		FriendsFrameFriendsScrollFrameMiddle:Hide()
		FriendsFrameFriendsScrollFrameBottom:Hide()
		WhoFrameListInsetBg:Hide()
		WhoFrameEditBoxInsetBg:Hide()
		ChannelFrameLeftInsetBg:Hide()
		ChannelFrameRightInsetBg:Hide()
		RaidFinderQueueFrameBackground:Hide()
		RaidParentFrameInsetBg:Hide()
		RaidFinderFrameRoleInsetBg:Hide()
		RaidFinderFrameRoleBackground:Hide()
		RaidParentFramePortraitFrame:Hide()
		RaidParentFramePortrait:Hide()
		RaidParentFrameTopBorder:Hide()
		RaidParentFrameTopRightCorner:Hide()
		LFRQueueFrameRoleInsetBg:Hide()
		LFRQueueFrameListInsetBg:Hide()
		LFRQueueFrameCommentInsetBg:Hide()
		select(5, SideDressUpModelCloseButton:GetRegions()):Hide()
		IgnoreListFrameTop:Hide()
		IgnoreListFrameMiddle:Hide()
		IgnoreListFrameBottom:Hide()
		PendingListFrameTop:Hide()
		PendingListFrameMiddle:Hide()
		PendingListFrameBottom:Hide()
		ScrollOfResurrectionSelectionFrameBackground:Hide()

		ReadyCheckFrame:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)

		-- [[ Text colour functions ]]

		NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
		TRIVIAL_QUEST_DISPLAY = "|cffffffff%s (low level)|r"

		GameFontBlackMedium:SetTextColor(1, 1, 1)
		QuestFont:SetTextColor(1, 1, 1)
		MailFont_Large:SetTextColor(1, 1, 1)
		MailFont_Large:SetShadowColor(0, 0, 0)
		MailFont_Large:SetShadowOffset(1, -1)
		MailTextFontNormal:SetTextColor(1, 1, 1)
		MailTextFontNormal:SetShadowOffset(1, -1)
		MailTextFontNormal:SetShadowColor(0, 0, 0)
		InvoiceTextFontNormal:SetTextColor(1, 1, 1)
		InvoiceTextFontSmall:SetTextColor(1, 1, 1)
		SpellBookPageText:SetTextColor(.8, .8, .8)
		QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
		QuestInfoRewardsHeader:SetShadowColor(0, 0, 0)
		QuestProgressTitleText:SetShadowColor(0, 0, 0)
		QuestInfoTitleHeader:SetShadowColor(0, 0, 0)
		AvailableServicesText:SetTextColor(1, 1, 1)
		AvailableServicesText:SetShadowColor(0, 0, 0)
		PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
		PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
		PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
		PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
		PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
		PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)
		QuestInfoTitleHeader:SetTextColor(1, 1, 1)
		QuestInfoTitleHeader.SetTextColor = F.dummy
		QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
		QuestInfoDescriptionHeader.SetTextColor = F.dummy
		QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)
		QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
		QuestInfoObjectivesHeader.SetTextColor = F.dummy
		QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)
		QuestInfoRewardsHeader:SetTextColor(1, 1, 1)
		QuestInfoRewardsHeader.SetTextColor = F.dummy
		QuestInfoDescriptionText:SetTextColor(1, 1, 1)
		QuestInfoDescriptionText.SetTextColor = F.dummy
		QuestInfoObjectivesText:SetTextColor(1, 1, 1)
		QuestInfoObjectivesText.SetTextColor = F.dummy
		QuestInfoGroupSize:SetTextColor(1, 1, 1)
		QuestInfoGroupSize.SetTextColor = F.dummy
		QuestInfoRewardText:SetTextColor(1, 1, 1)
		QuestInfoRewardText.SetTextColor = F.dummy
		QuestInfoItemChooseText:SetTextColor(1, 1, 1)
		QuestInfoItemChooseText.SetTextColor = F.dummy
		QuestInfoItemReceiveText:SetTextColor(1, 1, 1)
		QuestInfoItemReceiveText.SetTextColor = F.dummy
		QuestInfoSpellLearnText:SetTextColor(1, 1, 1)
		QuestInfoSpellLearnText.SetTextColor = F.dummy
		QuestInfoXPFrameReceiveText:SetTextColor(1, 1, 1)
		QuestInfoXPFrameReceiveText.SetTextColor = F.dummy
		QuestProgressTitleText:SetTextColor(1, 1, 1)
		QuestProgressTitleText.SetTextColor = F.dummy
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressText.SetTextColor = F.dummy
		ItemTextPageText:SetTextColor(1, 1, 1)
		ItemTextPageText.SetTextColor = F.dummy
		GreetingText:SetTextColor(1, 1, 1)
		GreetingText.SetTextColor = F.dummy
		AvailableQuestsText:SetTextColor(1, 1, 1)
		AvailableQuestsText.SetTextColor = F.dummy
		AvailableQuestsText:SetShadowColor(0, 0, 0)
		QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
		QuestInfoSpellObjectiveLearnLabel.SetTextColor = F.dummy
		CurrentQuestsText:SetTextColor(1, 1, 1)
		CurrentQuestsText.SetTextColor = F.dummy
		CurrentQuestsText:SetShadowColor(0, 0, 0)
		CoreAbilityFont:SetTextColor(1, 1, 1)
		SystemFont_Large:SetTextColor(1, 1, 1)

		for i = 1, MAX_OBJECTIVES do
			local objective = _G["QuestInfoObjective"..i]
			objective:SetTextColor(1, 1, 1)
			objective.SetTextColor = F.dummy
		end

		hooksecurefunc("UpdateProfessionButton", function(self)
			self.spellString:SetTextColor(1, 1, 1);
			self.subSpellString:SetTextColor(1, 1, 1)
		end)

		function PaperDollFrame_SetLevel()
			local primaryTalentTree = GetSpecialization()
			local classDisplayName, class = UnitClass("player")
			local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or C.classcolours[class]
			local classColorString = format("ff%.2x%.2x%.2x", classColor.r * 255, classColor.g * 255, classColor.b * 255)
			local specName

			if (primaryTalentTree) then
				_, specName = GetSpecializationInfo(primaryTalentTree);
			end

			if (specName and specName ~= "") then
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), classColorString, specName, classDisplayName);
			else
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), classColorString, classDisplayName);
			end
		end

		-- [[ Change positions ]]

		ChatConfigFrameDefaultButton:SetWidth(125)
		ChatConfigFrameDefaultButton:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "BOTTOMLEFT", 0, -4)
		ChatConfigFrameOkayButton:SetPoint("TOPRIGHT", ChatConfigBackgroundFrame, "BOTTOMRIGHT", 0, -4)
		ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 1, -28)
		PaperDollEquipmentManagerPaneEquipSet:SetWidth(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)
		PaperDollEquipmentManagerPaneSaveSet:SetPoint("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 1, 0)
		GearManagerDialogPopup:SetPoint("LEFT", PaperDollFrame, "RIGHT", 1, 0)
		DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)
		SendMailMailButton:SetPoint("RIGHT", SendMailCancelButton, "LEFT", -1, 0)
		OpenMailDeleteButton:SetPoint("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)
		OpenMailReplyButton:SetPoint("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)
		HelpFrameReportBugScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameReportBugScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameSubmitSuggestionScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameSubmitSuggestionScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameTicketScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameTicketScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameGM_ResponseScrollFrame1ScrollBar:SetPoint("TOPLEFT", HelpFrameGM_ResponseScrollFrame1, "TOPRIGHT", 1, -16)
		HelpFrameGM_ResponseScrollFrame2ScrollBar:SetPoint("TOPLEFT", HelpFrameGM_ResponseScrollFrame2, "TOPRIGHT", 1, -16)
		RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 1, -28)
		TokenFramePopup:SetPoint("TOPLEFT", TokenFrame, "TOPRIGHT", 1, -28)
		CharacterFrameExpandButton:SetPoint("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMRIGHT", -14, 6)
		TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)
		LFDQueueFrameSpecificListScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameSpecificListScrollFrameScrollBar, "BOTTOM", 0, 2)
		LFDQueueFrameRandomScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameRandomScrollFrameScrollBar, "BOTTOM", 0, 2)
		MerchantFrameTab2:SetPoint("LEFT", MerchantFrameTab1, "RIGHT", -15, 0)
		SendMailMoneySilver:SetPoint("LEFT", SendMailMoneyGold, "RIGHT", 1, 0)
		SendMailMoneyCopper:SetPoint("LEFT", SendMailMoneySilver, "RIGHT", 1, 0)
		WhoFrameWhoButton:SetPoint("RIGHT", WhoFrameAddFriendButton, "LEFT", -1, 0)
		WhoFrameAddFriendButton:SetPoint("RIGHT", WhoFrameGroupInviteButton, "LEFT", -1, 0)
		FriendsFrameTitleText:SetPoint("TOP", FriendsFrame, "TOP", 0, -8)
		VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
		InterfaceOptionsFrameOkay:SetPoint("BOTTOMRIGHT", InterfaceOptionsFrameCancel, "BOTTOMLEFT", -1, 0)

		-- [[ Tabs ]]

		for i = 1, 5 do
			F.ReskinTab(_G["SpellBookFrameTabButton"..i])
		end

		for i = 1, 4 do
			F.ReskinTab(_G["FriendsFrameTab"..i])
			if _G["CharacterFrameTab"..i] then
				F.ReskinTab(_G["CharacterFrameTab"..i])
			end
		end

		for i = 1, 2 do
			F.ReskinTab(_G["MerchantFrameTab"..i])
			F.ReskinTab(_G["MailFrameTab"..i])
		end

		-- [[ Buttons ]]

		local buttons = {"VideoOptionsFrameOkay", "VideoOptionsFrameCancel", "VideoOptionsFrameDefaults", "VideoOptionsFrameApply", "AudioOptionsFrameOkay", "AudioOptionsFrameCancel", "AudioOptionsFrameDefaults", "InterfaceOptionsFrameDefaults", "InterfaceOptionsFrameOkay", "InterfaceOptionsFrameCancel", "ChatConfigFrameOkayButton", "ChatConfigFrameDefaultButton", "DressUpFrameCancelButton", "DressUpFrameResetButton", "WhoFrameWhoButton", "WhoFrameAddFriendButton", "WhoFrameGroupInviteButton", "SendMailMailButton", "SendMailCancelButton", "OpenMailReplyButton", "OpenMailDeleteButton", "OpenMailCancelButton", "OpenMailReportSpamButton", "ChannelFrameNewButton", "RaidFrameRaidInfoButton", "RaidFrameConvertToRaidButton", "GearManagerDialogPopupOkay", "GearManagerDialogPopupCancel", "StackSplitOkayButton", "StackSplitCancelButton", "GameMenuButtonHelp", "GameMenuButtonOptions", "GameMenuButtonUIOptions", "GameMenuButtonKeybindings", "GameMenuButtonMacros", "GameMenuButtonLogout", "GameMenuButtonQuit", "GameMenuButtonContinue", "GameMenuButtonMacOptions", "LFDQueueFrameFindGroupButton", "LFRQueueFrameFindGroupButton", "LFRQueueFrameAcceptCommentButton", "AddFriendEntryFrameAcceptButton", "AddFriendEntryFrameCancelButton", "FriendsFriendsSendRequestButton", "FriendsFriendsCloseButton", "ColorPickerOkayButton", "ColorPickerCancelButton", "LFRBrowseFrameSendMessageButton", "LFRBrowseFrameInviteButton", "LFRBrowseFrameRefreshButton", "GuildInviteFrameJoinButton", "GuildInviteFrameDeclineButton", "FriendsFramePendingButton1AcceptButton", "FriendsFramePendingButton1DeclineButton", "RaidInfoExtendButton", "RaidInfoCancelButton", "PaperDollEquipmentManagerPaneEquipSet", "PaperDollEquipmentManagerPaneSaveSet", "HelpFrameAccountSecurityOpenTicket", "HelpFrameCharacterStuckStuck", "HelpFrameOpenTicketHelpTopIssues", "HelpFrameOpenTicketHelpOpenTicket", "ReadyCheckFrameYesButton", "ReadyCheckFrameNoButton", "HelpFrameTicketSubmit", "HelpFrameTicketCancel", "HelpFrameKnowledgebaseSearchButton", "GhostFrame", "HelpFrameGM_ResponseNeedMoreHelp", "HelpFrameGM_ResponseCancel", "GMChatOpenLog", "HelpFrameKnowledgebaseNavBarHomeButton", "AddFriendInfoFrameContinueButton", "LFDQueueFramePartyBackfillBackfillButton", "LFDQueueFramePartyBackfillNoBackfillButton", "ChannelFrameDaughterFrameOkayButton", "ChannelFrameDaughterFrameCancelButton", "PendingListInfoFrameContinueButton", "LFDQueueFrameNoLFDWhileLFRLeaveQueueButton", "InterfaceOptionsHelpPanelResetTutorials", "RaidFinderFrameFindRaidButton", "RaidFinderQueueFrameIneligibleFrameLeaveQueueButton", "SideDressUpModelResetButton", "RaidFinderQueueFramePartyBackfillBackfillButton", "RaidFinderQueueFramePartyBackfillNoBackfillButton", "ScrollOfResurrectionSelectionFrameAcceptButton", "ScrollOfResurrectionSelectionFrameCancelButton", "ScrollOfResurrectionFrameAcceptButton", "ScrollOfResurrectionFrameCancelButton", "HelpFrameReportBugSubmit", "HelpFrameSubmitSuggestionSubmit", "ReportPlayerNameDialogReportButton", "ReportPlayerNameDialogCancelButton", "ReportCheatingDialogReportButton", "ReportCheatingDialogCancelButton", "HelpFrameOpenTicketHelpItemRestoration"}
		for i = 1, #buttons do
		local reskinbutton = _G[buttons[i]]
			if reskinbutton then
				F.Reskin(reskinbutton)
			else
				print("Aurora: "..buttons[i].." was not found.")
			end
		end

		if IsAddOnLoaded("ACP") then F.Reskin(GameMenuButtonAddOns) end

		local closebuttons = {"SpellBookFrameCloseButton", "HelpFrameCloseButton", "RaidInfoCloseButton", "ItemRefCloseButton", "TokenFramePopupCloseButton", "ReputationDetailCloseButton", "ChannelFrameDaughterFrameDetailCloseButton", "RaidParentFrameCloseButton", "SideDressUpModelCloseButton"}
		for i = 1, #closebuttons do
			local closebutton = _G[closebuttons[i]]
			F.ReskinClose(closebutton)
		end

		F.ReskinClose(DressUpFrameCloseButton, "TOPRIGHT", DressUpFrame, "TOPRIGHT", -38, -16)
	end
end)

local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if AuroraConfig.tooltips == true and not(IsAddOnLoaded("CowTip") or IsAddOnLoaded("TipTac") or IsAddOnLoaded("FreebTip") or IsAddOnLoaded("lolTip") or IsAddOnLoaded("StarTip") or IsAddOnLoaded("TipTop")) then
		local tooltips = {
			"GameTooltip",
			"ItemRefTooltip",
			"ShoppingTooltip1",
			"ShoppingTooltip2",
			"ShoppingTooltip3",
			"WorldMapTooltip",
			"ChatMenu",
			"EmoteMenu",
			"LanguageMenu",
			"VoiceMacroMenu",
		}

		local backdrop = {
			bgFile = C.media.backdrop,
			edgeFile = C.media.backdrop,
			edgeSize = 1,
		}

		-- so other stuff which tries to look like GameTooltip doesn't mess up
		local getBackdrop = function()
			return backdrop
		end

		local getBackdropColor = function()
			return 0, 0, 0, .8
		end

		local getBackdropBorderColor = function()
			return 0, 0, 0
		end

		for i = 1, #tooltips do
			local t = _G[tooltips[i]]
			t:SetBackdrop(nil)
			local bg = CreateFrame("Frame", nil, t)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT")
			bg:SetFrameLevel(t:GetFrameLevel()-1)
			bg:SetBackdrop(backdrop)
			bg:SetBackdropColor(0, 0, 0, .8)
			bg:SetBackdropBorderColor(0, 0, 0)

			t.GetBackdrop = getBackdrop
			t.GetBackdropColor = getBackdropColor
			t.GetBackdropBorderColor = getBackdropBorderColor
		end

		local sb = _G["GameTooltipStatusBar"]
		sb:SetHeight(3)
		sb:ClearAllPoints()
		sb:SetPoint("BOTTOMLEFT", GameTooltip, "BOTTOMLEFT", 1, 1)
		sb:SetPoint("BOTTOMRIGHT", GameTooltip, "BOTTOMRIGHT", -1, 1)
		sb:SetStatusBarTexture(C.media.backdrop)

		local sep = GameTooltipStatusBar:CreateTexture(nil, "ARTWORK")
		sep:SetHeight(1)
		sep:SetPoint("BOTTOMLEFT", 0, 3)
		sep:SetPoint("BOTTOMRIGHT", 0, 3)
		sep:SetTexture(C.media.backdrop)
		sep:SetVertexColor(0, 0, 0)

		F.CreateBD(FriendsTooltip)

		-- pet battle stuff

		local tooltips = {PetBattlePrimaryAbilityTooltip, PetBattlePrimaryUnitTooltip, FloatingBattlePetTooltip, BattlePetTooltip, FloatingPetBattleAbilityTooltip}
		for _, f in pairs(tooltips) do
			f:DisableDrawLayer("BACKGROUND")
			local bg = CreateFrame("Frame", nil, f)
			bg:SetAllPoints()
			bg:SetFrameLevel(0)
			F.CreateBD(bg)
		end

		PetBattlePrimaryUnitTooltip.Delimiter:SetTexture(0, 0, 0)
		PetBattlePrimaryUnitTooltip.Delimiter:SetHeight(1)
		PetBattlePrimaryAbilityTooltip.Delimiter1:SetHeight(1)
		PetBattlePrimaryAbilityTooltip.Delimiter1:SetTexture(0, 0, 0)
		PetBattlePrimaryAbilityTooltip.Delimiter2:SetHeight(1)
		PetBattlePrimaryAbilityTooltip.Delimiter2:SetTexture(0, 0, 0)
		FloatingPetBattleAbilityTooltip.Delimiter1:SetHeight(1)
		FloatingPetBattleAbilityTooltip.Delimiter1:SetTexture(0, 0, 0)
		FloatingPetBattleAbilityTooltip.Delimiter2:SetHeight(1)
		FloatingPetBattleAbilityTooltip.Delimiter2:SetTexture(0, 0, 0)
		FloatingBattlePetTooltip.Delimiter:SetTexture(0, 0, 0)
		FloatingBattlePetTooltip.Delimiter:SetHeight(1)
		F.ReskinClose(FloatingBattlePetTooltip.CloseButton)
		F.ReskinClose(FloatingPetBattleAbilityTooltip.CloseButton)
	end

	if AuroraConfig.map == true and not(IsAddOnLoaded("MetaMap") or IsAddOnLoaded("m_Map") or IsAddOnLoaded("Mapster")) then
		WorldMapFrameMiniBorderLeft:SetAlpha(0)
		WorldMapFrameMiniBorderRight:SetAlpha(0)

		local scale = WORLDMAP_WINDOWED_SIZE
		local mapbg = CreateFrame("Frame", nil, WorldMapDetailFrame)
		mapbg:SetPoint("TOPLEFT", -1 / scale, 1 / scale)
		mapbg:SetPoint("BOTTOMRIGHT", 1 / scale, -1 / scale)
		mapbg:SetFrameLevel(0)
		mapbg:SetBackdrop({
			bgFile = C.media.backdrop,
		})
		mapbg:SetBackdropColor(0, 0, 0)

		local frame = CreateFrame("Frame",nil,WorldMapButton)
		frame:SetFrameStrata("HIGH")

		local function skinmap()
			WorldMapFrameMiniBorderLeft:SetAlpha(0)
			WorldMapFrameMiniBorderRight:SetAlpha(0)
			WorldMapFrameCloseButton:ClearAllPoints()
			WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, 3)
			WorldMapFrameCloseButton:SetFrameStrata("HIGH")
			WorldMapFrameSizeUpButton:ClearAllPoints()
			WorldMapFrameSizeUpButton:SetPoint("TOPRIGHT", WorldMapButton, "TOPRIGHT", 3, -18)
			WorldMapFrameSizeUpButton:SetFrameStrata("HIGH")
			WorldMapFrameTitle:ClearAllPoints()
			WorldMapFrameTitle:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, 9, 5)
			WorldMapFrameTitle:SetParent(frame)
			WorldMapFrameTitle:SetTextColor(1, 1, 1)
			--[[WorldMapQuestShowObjectives:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT")
			WorldMapQuestShowObjectives.SetPoint = F.dummy
			WorldMapQuestShowObjectives:SetFrameStrata("HIGH")
			WorldMapQuestShowObjectivesText:ClearAllPoints()
			WorldMapQuestShowObjectivesText:SetPoint("RIGHT", WorldMapQuestShowObjectives, "LEFT", -4, 1)
			WorldMapQuestShowObjectivesText:SetTextColor(1, 1, 1)]]--
			WorldMapTrackQuest:SetParent(frame)
			WorldMapTrackQuest:ClearAllPoints()
			WorldMapTrackQuest:SetPoint("TOPLEFT", WorldMapDetailFrame, 9, -5)
			WorldMapTrackQuestText:SetTextColor(1, 1, 1)
			--[[WorldMapShowDigSites:SetFrameStrata("HIGH")
			WorldMapShowDigSites:ClearAllPoints()
			WorldMapShowDigSites:SetPoint("BOTTOMRIGHT", WorldMapButton, "BOTTOMRIGHT", 0, 19)
			WorldMapShowDigSitesText:ClearAllPoints()
			WorldMapShowDigSitesText:SetPoint("RIGHT", WorldMapShowDigSites, "LEFT", -4, 1)
			WorldMapShowDigSitesText:SetTextColor(1, 1, 1)
			if AuroraConfig.enableFont then
				WorldMapFrameTitle:SetFont(C.media.font, 12 / scale, "THINOUTLINE")
				WorldMapFrameTitle:SetShadowOffset(0, 0)
				WorldMapQuestShowObjectivesText:SetFont(C.media.font, 12, "OUTLINE")
				WorldMapQuestShowObjectivesText:SetShadowOffset(0, 0)
				WorldMapTrackQuestText:SetFont(C.media.font, 12 / scale, "OUTLINE")
				WorldMapTrackQuestText:SetShadowOffset(0, 0)
				WorldMapShowDigSitesText:SetFont(C.media.font, 12, "OUTLINE")
				WorldMapShowDigSitesText:SetShadowOffset(0, 0)
			end
		end

		skinmap()
		hooksecurefunc("WorldMap_ToggleSizeDown", skinmap)]]--

		F.ReskinDropDown(WorldMapLevelDropDown)
		F.ReskinCheck(WorldMapShowDigSites)
		F.ReskinCheck(WorldMapQuestShowObjectives)
		F.ReskinCheck(WorldMapTrackQuest)
	end

	if AuroraConfig.bags == true and not(IsAddOnLoaded("Baggins") or IsAddOnLoaded("Stuffing") or IsAddOnLoaded("Combuctor") or IsAddOnLoaded("cargBags") or IsAddOnLoaded("famBags") or IsAddOnLoaded("ArkInventory") or IsAddOnLoaded("Bagnon")) then
		BackpackTokenFrame:GetRegions():Hide()

		for i = 1, 12 do
			local con = _G["ContainerFrame"..i]

			for j = 1, 7 do
				select(j, con:GetRegions()):SetAlpha(0)
			end

			for k = 1, MAX_CONTAINER_ITEMS do
				local item = "ContainerFrame"..i.."Item"..k
				local button = _G[item]
				local icon = _G[item.."IconTexture"]

				_G[item.."IconQuestTexture"]:SetAlpha(0)

				button:SetNormalTexture("")
				button:SetPushedTexture("")

				icon:SetPoint("TOPLEFT", 1, -1)
				icon:SetPoint("BOTTOMRIGHT", -1, 1)
				icon:SetTexCoord(.08, .92, .08, .92)

				F.CreateBD(button, 0)
			end

			local f = CreateFrame("Frame", nil, con)
			f:SetPoint("TOPLEFT", 8, -4)
			f:SetPoint("BOTTOMRIGHT", -4, 3)
			f:SetFrameLevel(con:GetFrameLevel()-1)
			F.CreateBD(f)

			F.ReskinClose(_G["ContainerFrame"..i.."CloseButton"], "TOPRIGHT", con, "TOPRIGHT", -6, -6)
		end

		for i = 1, 3 do
			local ic = _G["BackpackTokenFrameToken"..i.."Icon"]
			ic:SetDrawLayer("OVERLAY")
			ic:SetTexCoord(.08, .92, .08, .92)
			F.CreateBG(ic)
		end

		if not IsAddOnLoaded("oGlow") then
			hooksecurefunc("ContainerFrame_Update", function(frame)
				local name = frame:GetName()
				local bu
				for i = 1, frame.size do
					bu = _G[name.."Item"..i]
					if _G[name.."Item"..i.."IconQuestTexture"]:IsShown() then
						bu:SetBackdropBorderColor(1, 0, 0)
					else
						bu:SetBackdropBorderColor(0, 0, 0)
					end
				end
			end)

			hooksecurefunc("BankFrameItemButton_Update", function(bu)
				if not bu.isBag then
					if _G[bu:GetName().."IconQuestTexture"]:IsShown() then
						bu:SetBackdropBorderColor(1, 0, 0)
					else
						bu:SetBackdropBorderColor(0, 0, 0)
					end
				end
			end)
		end

		F.SetBD(BankFrame)
		BankFrame:DisableDrawLayer("BACKGROUND")
		BankFrame:DisableDrawLayer("BORDER")
		BankFrame:DisableDrawLayer("OVERLAY")
		BankPortraitTexture:Hide()
		BankFrameMoneyFrameInset:Hide()
		BankFrameMoneyFrameBorder:Hide()


		F.Reskin(BankFramePurchaseButton)
		F.ReskinClose(BankFrameCloseButton)

		for i = 1, 28 do
			local item = "BankFrameItem"..i
			local button = _G[item]
			local icon = _G[item.."IconTexture"]

			_G[item.."IconQuestTexture"]:SetAlpha(0)

			button:SetNormalTexture("")
			button:SetPushedTexture("")

			icon:SetPoint("TOPLEFT", 1, -1)
			icon:SetPoint("BOTTOMRIGHT", -1, 1)
			icon:SetTexCoord(.08, .92, .08, .92)

			F.CreateBD(button, 0)
		end

		for i = 1, 7 do
			local bag = _G["BankFrameBag"..i]
			local ic = _G["BankFrameBag"..i.."IconTexture"]
			_G["BankFrameBag"..i.."HighlightFrameTexture"]:SetTexture(C.media.checked)

			bag:SetNormalTexture("")
			bag:SetPushedTexture("")

			ic:SetPoint("TOPLEFT", 1, -1)
			ic:SetPoint("BOTTOMRIGHT", -1, 1)
			ic:SetTexCoord(.08, .92, .08, .92)

			F.CreateBD(bag, 0)
		end
	end

	if AuroraConfig.loot == true and not(IsAddOnLoaded("Butsu") or IsAddOnLoaded("LovelyLoot") or IsAddOnLoaded("XLoot")) then
		LootFramePortraitOverlay:Hide()

		select(19, LootFrame:GetRegions()):SetPoint("TOP", LootFrame, "TOP", 0, -7)

		hooksecurefunc("LootFrame_UpdateButton", function(index)
			local ic = _G["LootButton"..index.."IconTexture"]

			if not ic.bg then
				local bu = _G["LootButton"..index]

				_G["LootButton"..index.."IconQuestTexture"]:SetAlpha(0)
				_G["LootButton"..index.."NameFrame"]:Hide()

				bu:SetNormalTexture("")
				bu:SetPushedTexture("")

				local bd = CreateFrame("Frame", nil, bu)
				bd:SetPoint("TOPLEFT")
				bd:SetPoint("BOTTOMRIGHT", 114, 0)
				bd:SetFrameLevel(bu:GetFrameLevel()-1)
				F.CreateBD(bd, .25)

				ic:SetTexCoord(.08, .92, .08, .92)
				ic.bg = F.CreateBG(ic)
			end

			if select(6, GetLootSlotInfo(index)) then
				ic.bg:SetVertexColor(1, 0, 0)
			else
				ic.bg:SetVertexColor(0, 0, 0)
			end
		end)

		LootFrameDownButton:ClearAllPoints()
		LootFrameDownButton:SetPoint("BOTTOMRIGHT", -8, 6)
		LootFramePrev:ClearAllPoints()
		LootFramePrev:SetPoint("LEFT", LootFrameUpButton, "RIGHT", 4, 0)
		LootFrameNext:ClearAllPoints()
		LootFrameNext:SetPoint("RIGHT", LootFrameDownButton, "LEFT", -4, 0)

		F.ReskinPortraitFrame(LootFrame, true)
		F.ReskinArrow(LootFrameUpButton, "up")
		F.ReskinArrow(LootFrameDownButton, "down")
	end

	if AuroraConfig.chatBubbles then
		local bubbleHook = CreateFrame("Frame")

		local function styleBubble(frame)
			local scale = UIParent:GetScale()

			for i = 1, frame:GetNumRegions() do
				local region = select(i, frame:GetRegions())
				if region:GetObjectType() == "Texture" then
					region:SetTexture(nil)
				elseif region:GetObjectType() == "FontString" then
					region:SetFont(C.media.font, 13)
					region:SetShadowOffset(scale, -scale)
				end
			end

			frame:SetBackdrop({
				bgFile = C.media.backdrop,
				edgeFile = C.media.backdrop,
				edgeSize = scale,
			})
			frame:SetBackdropColor(0, 0, 0, AuroraConfig.alpha)
			frame:SetBackdropBorderColor(0, 0, 0)
		end

		local function isChatBubble(frame)
			if frame:GetName() then return end
			if not frame:GetRegions() then return end
			return frame:GetRegions():GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
		end

		local last = 0
		local numKids = 0

		bubbleHook:SetScript("OnUpdate", function(self, elapsed)
			last = last + elapsed
			if last > .1 then
				last = 0
				local newNumKids = WorldFrame:GetNumChildren()
				if newNumKids ~= numKids then
					for i=numKids + 1, newNumKids do
						local frame = select(i, WorldFrame:GetChildren())

						if isChatBubble(frame) then
							styleBubble(frame)
						end
					end
					numKids = newNumKids
				end
			end
		end)
	end
end
end)
