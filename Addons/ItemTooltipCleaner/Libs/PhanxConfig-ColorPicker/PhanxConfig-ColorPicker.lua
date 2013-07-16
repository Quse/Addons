--[[--------------------------------------------------------------------
	PhanxConfig-ColorPicker
	Simple color picker widget generator.
	Based on OmniCC_Options by Tuller.
	Requires LibStub.

	This library is not intended for use by other authors. Absolutely no
	support of any kind will be provided for other authors using it, and
	its internals may change at any time without notice.
----------------------------------------------------------------------]]

local MINOR_VERSION = tonumber(("$Revision: 77 $"):match("%d+"))

local lib, oldminor = LibStub:NewLibrary("PhanxConfig-ColorPicker", MINOR_VERSION)
if not lib then return end

local function OnEnter(self)
	local color = NORMAL_FONT_COLOR
	self.bg:SetVertexColor(color.r, color.g, color.b)

	if self.desc then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.desc, nil, nil, nil, nil, true)
	end
end

local function OnLeave(self)
	local color = HIGHLIGHT_FONT_COLOR
	self.bg:SetVertexColor(color.r, color.g, color.b)

	GameTooltip:Hide()
end

local prev = { }
local function OnClick(self)
	OnLeave(self)

	if ColorPickerFrame:IsShown() then
		ColorPickerFrame:Hide()
	else
		local r, g, b, a
		if self.GetColor then
			r, g, b, a = self:GetColor()
		else
			local r, g, b, a = self.swatch:GetVertexColor()
			r, g, b, a = tonumber(format("%.2f", r)), tonumber(format("%.2f", g)), tonumber(format("%.2f", b)), tonumber(format("%.2f", a))
		end
		self.r, self.g, self.b, self.opacity = r, g, b, a

		OpenColorPicker(self)
		ColorPickerFrame:SetFrameStrata("TOOLTIP")
		ColorPickerFrame:Raise()
	end
end

local function SetColor(self, r, g, b, a)
	if not a or not self.hasOpacity then
		a = 1
	end
	r, g, b, a = tonumber(format("%.2f", r)), tonumber(format("%.2f", g)), tonumber(format("%.2f", b)), tonumber(format("%.2f", a))

	self.swatch:SetVertexColor(r, g, b, a)
	self.bg:SetAlpha(a)
	if self.OnColorChanged then
		-- use this for immediate visual updating
		self:OnColorChanged(r, g, b, a)
	end
	if not ColorPickerFrame:IsShown() and self.PostColorChanged then
		-- use this for final updating after the color picker closes
		self:PostColorChanged(r, g, b, a)
	end
end

function lib.CreateColorPicker(parent, name, desc, hasOpacity)
	assert( type(parent) == "table" and parent.CreateFontString, "PhanxConfig-ColorPicker: Parent is not a valid frame!" )
	if type(name) ~= "string" then name = nil end
	if type(desc) ~= "string" then desc = nil end

	local frame = CreateFrame("Button", nil, parent)
	frame:SetHeight(19)

	local swatch = frame:CreateTexture(nil, "OVERLAY")
	swatch:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")
	swatch:SetPoint("LEFT")
	swatch:SetWidth(19)
	swatch:SetHeight(19)
	frame.swatch = swatch

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetTexture(1, 1, 1)
	bg:SetPoint("CENTER", swatch)
	bg:SetWidth(16)
	bg:SetHeight(16)
	frame.bg = bg

	local label = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	label:SetPoint("LEFT", swatch, "RIGHT", 4, 1)
	label:SetHeight(19)
	label:SetText(name)
	frame.label = label

	frame:SetWidth( math.min( 186, math.max( 19 + 4 + label:GetStringWidth(), 100 ) ) )

	frame.SetColor = SetColor

	frame.swatchFunc = function()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		local a = OpacitySliderFrame:GetValue()
		frame:SetColor( r, g, b, a )
	end

	frame.hasOpacity = hasOpacity
	frame.opacityFunc = function()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		local a = OpacitySliderFrame:GetValue()
		frame:SetColor( r, g, b, a )
	end

	frame.cancelFunc = function()
		frame:SetColor( frame.r, frame.g, frame.b, frame.hasOpacity and frame.opacity or 1 )
	end

	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)

	frame.desc = desc

	return frame
end