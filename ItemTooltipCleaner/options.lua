--[[--------------------------------------------------------------------
	Item Tooltip Cleaner
	Compacts equipment bonus text and removes extraneous lines from item tooltips.
	Copyright (c) 2010-2012 Akkorian, Phanx. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/addons/info19129-ItemTooltipCleaner.html
	http://www.curse.com/addons/wow/itemtooltipcleaner
----------------------------------------------------------------------]]

local ADDON_NAME, namespace = ...
local settings = namespace.settings
local L = namespace.L

local panel = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME)

panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, event, addon)
	if addon ~= ADDON_NAME then return end

	if ItemTooltipCleanerSettings then
		for k, v in pairs(settings) do
			if type(v) ~= type(ItemTooltipCleanerSettings[k]) then
				ItemTooltipCleanerSettings[k] = v
			end
		end
		for k, v in pairs(ItemTooltipCleanerSettings) do
			settings[k] = v
		end
	end
	ItemTooltipCleanerSettings = settings

	local stat_names = namespace.names
	local stat_patterns = namespace.patterns
--[[
	for k, v in pairs(_G) do
		if type(v) == "string" and v:match("%%d") and k:match("^ITEM_MOD") and not k:match("_SHORT$") then
			local str = v:gsub("%%d", 13)
			for i, pattern in ipairs(stat_patterns) do
				local stat, amount = str:match(pattern:gsub("^" .. ITEM_SPELL_TRIGGER_ONEQUIP, ""):trim())
				if stat and amount then
					if stat == "13" then stat = amount end
					stat_names[stat] = _G[k .. "_SHORT"]
				end
			end
		end
	end
--]]
	self:UnregisterAllEvents()
	self:SetScript("OnEvent", nil)
end)

panel.runOnce = function(self)
	local title, notes = LibStub("PhanxConfig-Header").CreateHeader(self, ADDON_NAME, GetAddOnMetadata(ADDON_NAME, "Notes"))

	local colorEnchant = LibStub("PhanxConfig-ColorPicker").CreateColorPicker(self, L["Enchantment color"])
	colorEnchant:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 4, -12)
	colorEnchant:SetColor(unpack(settings.enchantColor))
	colorEnchant.GetColor = function()
		return unpack(settings.enchantColor)
	end
	colorEnchant.OnColorChanged = function(self, r, g, b)
		settings.enchantColor[1] = r
		settings.enchantColor[2] = g
		settings.enchantColor[3] = b
	end

	local CreateCheckbox = LibStub("PhanxConfig-Checkbox").CreateCheckbox
	local function OnClick(self, checked)
		settings[self.key] = checked
	end

	local checkBonus = CreateCheckbox(self, L["Compact equipment bonuses"])
	checkBonus:SetPoint("TOPLEFT", colorEnchant, "BOTTOMLEFT", -3, -10)
	checkBonus.OnClick = OnClick
	checkBonus.key = "compactBonuses"

	local checkILevel = CreateCheckbox(self, L["Hide item levels"])
	checkILevel:SetPoint("TOPLEFT", checkBonus, "BOTTOMLEFT", 0, -8)
	checkILevel.OnClick = OnClick
	checkILevel.key = "hideItemLevel"

	local checkEquipSets = CreateCheckbox(self, L["Hide equipment sets"])
	checkEquipSets:SetPoint("TOPLEFT", checkILevel, "BOTTOMLEFT", 0, -8)
	checkEquipSets.OnClick = function(self, checked)
		if checked then
			SetCVar("dontShowEquipmentSetsOnItems", 1)
		else
			SetCVar("dontShowEquipmentSetsOnItems", 0)
		end
	end

	local checkHeroic = CreateCheckbox(self, string.format(L["Hide %q tags"], ITEM_HEROIC))
	checkHeroic:SetPoint("TOPLEFT", checkEquipSets, "BOTTOMLEFT", 0, -8)
	checkHeroic.OnClick = OnClick
	checkHeroic.key = "hideHeroic"

	local checkMadeBy = CreateCheckbox(self, string.format(L["Hide %q tags"], L["Made by"]))
	checkMadeBy:SetPoint("TOPLEFT", checkHeroic, "BOTTOMLEFT", 0, -8)
	checkMadeBy.OnClick = OnClick
	checkMadeBy.key = "hideMadeBy"

	local checkRaidFinder = CreateCheckbox(self, string.format(L["Hide %q tags"], RAID_FINDER))
	checkRaidFinder:SetPoint("TOPLEFT", checkMadeBy, "BOTTOMLEFT", 0, -8)
	checkRaidFinder.OnClick = OnClick
	checkRaidFinder.key = "hideRaidFinder"

	local checkReforged = CreateCheckbox(self, string.format(L["Hide %q tags"], REFORGED))
	checkReforged:SetPoint("TOPLEFT", checkRaidFinder, "BOTTOMLEFT", 0, -8)
	checkReforged.OnClick = OnClick
	checkReforged.key = "hideReforged"

	local checkSoulbound = CreateCheckbox(self, string.format(L["Hide %q tags"], ITEM_SOULBOUND))
	checkSoulbound:SetPoint("TOPLEFT", checkReforged, "BOTTOMLEFT", 0, -8)
	checkSoulbound.OnClick = OnClick
	checkSoulbound.key = "hideSoulbound"

	local checkBuy = CreateCheckbox(self, L["Hide buying instructions"])
	checkBuy:SetPoint("TOPLEFT", checkSoulbound, "BOTTOMLEFT", 0, -8)
	checkBuy.OnClick = OnClick
	checkBuy.key = "hideRightClickBuy"

	local checkSocket = CreateCheckbox(self, L["Hide socketing instructions"])
	checkSocket:SetPoint("TOPLEFT", checkBuy, "BOTTOMLEFT", 0, -8)
	checkSocket.OnClick = OnClick
	checkSocket.key = "hideRightClickSocket"

	local checkReqs = CreateCheckbox(self, L["Hide requirements"], L["Hide level, reputation, and skill requirements for items, enchantements, and sockets."])
	checkReqs:SetPoint("TOPLEFT", checkSocket, "BOTTOMLEFT", 0, -8)
	checkReqs.OnClick = OnClick
	checkReqs.key = "hideRequirements"

	local checkValue = CreateCheckbox(self, L["Hide vendor values"], L["Hide vendor values, except while interacting with a vendor, at the auction house, or choosing a quest reward."])
	checkValue:SetPoint("TOPLEFT", checkReqs, "BOTTOMLEFT", 0, -8)
	checkValue.OnClick = OnClick
	checkValue.key = "hideSellValue"

	self.refresh = function(self)
		checkBonus:SetChecked(settings.compactBonuses)
		checkILevel:SetChecked(settings.hideItemLevel)
		checkEquipSets:SetChecked(GetCVarBool("dontShowEquipmentSetsOnItems"))
		checkHeroic:SetChecked(settings.hideHeroic)
		checkMadeBy:SetChecked(settings.hideMadeBy)
		checkRaidFinder:SetChecked(settings.hideRaidFinder)
		checkReforged:SetChecked(settings.hideReforged)
		checkSoulbound:SetChecked(settings.hideSoulbound)
		checkBuy:SetChecked(settings.hideRightClickBuy)
		checkSocket:SetChecked(settings.hideRightClickSocket)
		checkReqs:SetChecked(settings.hideRequirements)
		checkValue:SetChecked(settings.hideSellValue)
	end
end

local about = LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)

SLASH_ITEMTOOLTIPCLEANER1 = "/itc"

SlashCmdList["ITEMTOOLTIPCLEANER"] = function()
	InterfaceOptionsFrame_OpenToCategory(about)
	InterfaceOptionsFrame_OpenToCategory(panel)
end