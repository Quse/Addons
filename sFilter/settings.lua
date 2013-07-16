-- "true" means enabled, "false" means disabled
sFilter_Settings = {
    configmode = false, -- In this mode all icons are shown and can be moved.
-- This code is null.   
   -- FontSize = 8,      -- Font size for stacks text
    -- r = .8,             -- Text color for stacks text More info: http://www.wowwiki.com/API_FontString_SetTextColor
    -- g = .8,
    -- b = .8,
    -- CountPoint = {"TOPRIGHT"},            -- Stacks text position. More info: http://www.wowwiki.com/API_Region_SetPoint
}

--[[ More info about config mode:
You can move icons with left mouse button while holding Alt OR Shift. Changed position won't be saved between sessions.
After click on icon you will see in chat info about its position. This can be used to change setPoint attribute is spell list.
Clicking on icon with right mouse button will reset its position to default.
]]

--[[ Closer look at spell lists:
All classes have their own spell list.
Each entry in list creates a separate icon. Entry is a table with values in it:
- spellId - id of spell you want to track. If you don't know it - check wowhead.com - last number in any spell link is spellid (example: http://www.wowhead.com/?spell=55095, id is 55095)
- spellId2, spellId3, spellId4, spellId5 - optional entries, these are the spellids you want to track if primary spell is NOT active.
- size - icon size in pixels
- unitId - unit at which you wish to track selected spell(s). More info: http://www.wowwiki.com/UnitId
- isMine - this is filter. isMine = 1 means only  effects from units in MyUnits table will be shown (see below for this table. Note: isMine = "1" will NOT work, it should be number, not string. Any other value will show effect from any source
- filter - filter again =). Needs to be "HELPFUL" for buffs and "HARMFUL" for debuffs.
- setPoint - where to place the icon. It's a table with coordinates inside. More info: http://www.wowwiki.com/API_Region_SetPoint
Original addon version: http://toxila.googlecode.com/svn/zips/sFilter/
]]

--[[ TEMPLATE SPELLS FOR REUSE!
	These are the original template locations for spell icons in case you need to recopy them.
	
	Large Button Template Locations: 
	- These show up near the center of the screen on the lined up above the player and target frames.
	
	--Big Left Template
	{spellId = 76301, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -184, 10}},
	--Big Right Template
	{spellId = 76301, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 184, 10}},		
	
	Normal location templates:
	- These show up below the player frame beginning at the right edge and extend left.
	
	-- Template 1
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Template 2
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},
	
	
]]
	
sFilter_Spells = {
    ["DEATHKNIGHT"] = {
	-- Killing Machine (Frost), Sudden Doom (Unholy) - Big Left
	{spellId = 51124, spellId2 = 81340, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -184, 10}},
	-- Rime (Freezing Fog), Unholy Frenzy on self(Unholy) - Big Right
	{spellId = 59052, spellId2 = 49016, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 184, 10}},	
	
	-- Template 1
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Template 2
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},
	
	
	},

    ["DRUID"] = {
	-- Resto Druid Auras --
	--Omen of Clarity (Big Right Template)
	{spellId = 16870, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 184, 10}},	
	
	-- Harmony
	{spellId = 100977, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Tree of Life
	{spellId = 117679, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},
	
	--Balance
	-- Eclipse Solar, Eclipse Lunar
	{spellId = 48517, spellId2 = 48518, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Shooting Stars (Starsurge instant), Predator's Swiftness (Big Left Template)
    {spellId = 93400, spellId2 = 69369, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -184, 10}},
    },

    ["HUNTER"] = {
	-- Template 1
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Template 2
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},	
	
	},

    ["MAGE"] = {
	-- Fingers of Frost (Frost), Arcane Missiles! (Arcane), Hot Streak (Fire) - Big Right
	{spellId = 44544, spellId2 = 79683, spellId3 = 48108, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 184, 10}},
	
	-- Template 1
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Template 2
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},
	
	
	},

	["MONK"] = {
	-- Mistweaver Auras --
	-- Mana Tea
	{spellId = 123761, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Template 2
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},
	
	
	},
	
    ["PALADIN"] = {
	-- Sacred Shield
	{spellId = 20925, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Template 2
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},
	
	
	},
    
	["PRIEST"] = {
	-- Template 1
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Template 2
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},
	
	
    },

    ["ROGUE"] = {
	-- Slice and Dice
	{spellId = 5171, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Template 2
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},
	
	
	},
	
    ["SHAMAN"] = {
	-- Spiritual Stimulus (T13 resto 2pc)
	--{spellId = 105763, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -210, -112}},
	-- Heart of Unliving (LFR, NM, HM procs) - move to specific class as desired.
	--{spellId = 109811, spellId2 = 107962, spellId3 = 109813, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -242, -112}},
	
	--- Tidal Waves, Maelstrom Weapon, Elemental Mastery (haste, damage)
    {spellId = 53390, spellId2 = 53817, spellId3 = 64701, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Hex
    {spellId = 51514, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},
	
	
	},

    ["WARLOCK"] = {
	-- Template 1
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Template 2
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},
	
	
	},

    ["WARRIOR"] = {
	-- Template 1
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -183, -187}},
	-- Template 2
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -216.5, -187}},
	-- Template 3
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -251, -187}},
	-- Template 4
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -285, -187}},
	-- Template 5
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -319, -187}},
	-- Template 6
	{spellId = 76301, size = 32, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -352, -187}},
	
	
	},
}