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

--[[ PVP Section
This is a list of bufs on targets i.e. Shild Wall or Bubble, there will be three icons, first will be major safe ablities (Ice Block, Icebond Fortitude), second is safe abilities from another player (Blessing of protection, Antimagic zone)
and third wiil be minor buffs (Blessing of Freedom, Stoneclaw totem)

Spells will be added by slot of priority

All icons 64 size

-- Add this list to your character class

PVP Spells = {
	-- Major Safe abilities: Icebond Fortitude(DK), Anti-magic shield (DK), Divine Protection(PAL), Divine Protection(PAL), Dispersion(PRIEST), Ice Block(MAGE), Dettrence(HUNTER), Spell Reflect(WAR), Shield Wall(WAR), Barkskin(DRU), Survival Instincts(DRU), Cloack of Shadows(ROG), Evasion(ROG), Sacrifice(LOCK Pet), Shamanistic Rage(SHA), The Beast Within(HUNT)
	{spellId = 48792, spellId2 = 48707, spellId3 = 498, spellId4 = 642, spellId5 = 47585, spellId6 = 45438, spellId7 = 19263, spellId8 = 23920, spellId9 = 871, spellId10 = 22812, spellId11 = 61336, spellId12 = 31224, spellId13 = 26669, spellId14 = 47986, spellId15 = 30823, spellid16 = 34471, size = 64, unitId = "target", isMine = all, setPoint = {"CENTER", UIParent, "CENTER", -148, 37}},
	-- Shareable safe abilities: Anti-magic zone(DK), Hand of Protection(PAL), Hand of Sacriface(PAL), Aura Mastery(PAL), Divine Sacriface(PAL), Guardian Spirit(PRIEST), Pain Suppression(PRIEST), Intervene(WAR), Hymn of Hope(PRIEST), Tranquility(DRU)
	{spellId = 50461, spellId2 = 1022, spellId3 = 6940, spellId4 = 31821, spellId5 = 64205, spellId6 = 47788, spellId7 = 33206, spellId8 = 3411, spellId9 = 64901, spellId10 = 48447, size = 64, unitId = "target", isMine = all, setPoint = {"CENTER", UIParent, "CENTER", -222, 37}},
	-- Minor safe abilities: Hand of Freedom(PAL), Divine Hymn(PRIEST), , Ice Barrier(MAGE), Mana Shield(MAGE), Fire Ward(MAGE), Frost Ward(MAGE), Shield Block(WAR), Enraged Regeneration(WAR), Frenzied Regeneration(DRU), Shadow Ward(LOCK), Stoneclaw Totem(SHA)
	{spellId = 1044, spellId2 = 64843, spellId3 = 43039, spellId4 = 43020, spellId67= 43010, spellId8 = 43012, spellId9 = 2565, spellId10 = 55694, spellId11 = 22842, spellId12 = 47891, spellid13 = 58582, size = 64, unitId = "target", isMine = all, setPoint = {"CENTER", UIParent, "CENTER", -296, 37}},

--]]

sFilter_Spells = {
	-- Universal Procs
	-- Heart of Unliving (LFR, NM, HM procs) - move to specific class as desired.
	--{spellId = 109811, spellId2 = 107962, spellId3 = 109813, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 50, -146}},

	
	-- Template 1
	{spellId = 76301, size = 30.5, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -178, -112}},
	-- Template 2
	{spellId = 76301, size = 30.5, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -210, -112}},
	-- Template 3
	{spellId = 76301, size = 30.5, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -242, -112}},
	-- Template 4
	{spellId = 76301, size = 30.5, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -178, -182}},
	-- Template 5
	{spellId = 76301, size = 30.5, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -210, -182}},
	-- Template 6
	{spellId = 76301, size = 30.5, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -242, -182}},
	-- Spiritual Stimulus (T13 resto 2pc)
	{spellId = 105763, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -210, -112}},
	-- Heart of Unliving (LFR, NM, HM procs) - move to specific class as desired.
	{spellId = 109811, spellId2 = 107962, spellId3 = 109813, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -242, -112}},
	-- Tidal Waves, Maelstrom Weapon, Elemental Mastery (haste, damage)
    {spellId = 53390, spellId2 = 53817, spellId3 = 64701, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -178, -112}},
	-- Hex
    {spellId = 51514, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", -178, -182}},

	
	
    ["DEATHKNIGHT"] = {

	-- Bone Shield
	--{spellId = 49222, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 0, -146}},
	-- Vampiric Blood  
	--{spellId = 55233, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 37}},
	-- Icebound Fortitude
	{spellId = 48792, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -195}},
	-- Anti-magic shield and zone
	{spellId = 48707, spellId2 = 50461, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 207, -195}},

	-- Shadow Infusion (Unholy)
	{spellId = 91342, size = 28, unitId = "pet", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},
	-- Dark Transformation
	{spellId = 63560, size = 28, unitId = "pet", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},		
	-- Blood Shield (Blood Mastery)
	{spellId = 77535, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},	
	-- Blade Barrier
	--{spellId = 64856, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},		

    -- Ebon Plague
    --{spellId = 65142, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
    -- Frost Fever
    --{spellId = 59921, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},
    -- Blood Plague
    --{spellId = 59879, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, -37}},
    -- Unholy Blight
    --{spellId = 49194, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -37}},

	-- Killing Machine (Frost), Sudden Doom (Unholy)
	{spellId = 51124, spellId2 = 81340, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 119, -35}},
	-- Rime (Freezing Fog), Unholy Frenzy on self(Unholy) 
	{spellId = 59052, spellId2 = 49016, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -119, -35}},
    },

    ["DRUID"] = {
	-- Resto Druid Auras --
	-- Harmony
	{spellId = 77495, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},	
	-- Tree of Life
	{spellId = 33891, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 207, -195}},
	-- Natural Harmony (T13 resto 2pc)
	{spellId = 105713, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -195}},
	
    -- Barkskin
    --{spellId = 22812, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 37}},
    -- Survival Instincts
    --{spellId = 61336, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 37}},
	-- Frenzied Regeneration
    --{spellId = 22842, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 37}},
	
	-- Faerie Fire (Feral), Faerie Fire
    --{spellId = 91565, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
    -- CoE, Ebon Plague, Earth and Moon
    --{spellId = 1490, spellId2 = 65142, spellId3 = 60433, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 0}},
    -- Mangle
    --{spellId = 33878, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},    
    -- Savage roar
    --{spellId = 52610, size = 34, unitId = "player", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},
	-- Eclipse Solar, Eclipse Lunar
	{spellId = 48517, spellId2 = 48518, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},
	-- Enrage
	--{spellId = 5229, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 0}},
	
    -- Moonfire, Lacirate, Rake
    --{spellId = 8921, spellId2 = 33745, spellId3 = 1822, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
    -- Insect Swarm, Rip
	--{spellId = 5570, spellId2 = 1079, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},
	-- Lunar Shower (Balance)
    --{spellId = 81192, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -37}},	
	-- Entangling Roots
    --{spellId = 339, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, -37}},	

    -- Shooting Stars (Starsurge instant), Predator's Swiftness 
    {spellId = 93400, spellId2 = 69369, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -119, -35}},	
	-- Omen of Clarity 
    {spellId = 16870,  size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 119, -35}},
    },

    ["HUNTER"] = {

	-- Bestial Wrath (Beastmaster)
	--{spellId = 19574, size = 34, unitId = "pet", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 37}},
	-- Focus Fire (Beastmaster), Improved Steady Shot (Marksman), Sniper Training (Survival) 
    --{spellId = 82692,  spellId2 = 53220, spellId3 = 64420, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 37}},
	-- Cobra Strikes (Beastmaster)
    --{spellId = 53257, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 37}},	

	-- Frenzy Effect (Beastmaster)
    --{spellId = 19615, size = 34, unitId = "pet", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
	-- Ice trap, Concussive shot  
    --{spellId = 71647, spellId2 = 5116, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 0}},
	-- Freezing Trap, Scatter Shot, Silencing shot 
    --{spellId = 3355, spellId2 = 19503, spellId3 = 34490, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},	
    -- Hunter's Mark, Marked for Death
    --{spellId = 1130, spellId2 = 88691, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 0}},

    -- Serpent Sting
    --{spellId = 1978, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
    -- Black Arrow
    --{spellId = 3674, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},
    -- Explosive Shot
    --{spellId = 53301, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, -37}},
	-- Wyvern Sting dot
    --{spellId = 24131, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -37}},


    -- Lock and Load (Suvival), Ready, Set, Aim ... (Marksman), Killing Streak (Beastmaster)
    {spellId = 56453, spellId2 = 82925, spellId3 = 94007, size = 42, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 0, -35}},
	-- 

	},

    ["MAGE"] = {

    -- Winter's Chill (Frost), Improved Scorch (Fire)
    --{spellId = 28593, spellId2 = 22959, size = 34, unitId = "target", isMine = "1", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 37}}, 
    -- Impact proc (Fire)
    {spellId = 64343, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},
	-- Blazing Speed (Fire), Improved Blink (Arcane)
	--{spellId = 31643, spellId2 = 47000, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 37}},
    -- Polymorph - Sheep, Pig, Turkey, Black Cat, Rabbit, Turtle 
    --{spellId = 118, spellId2 = 28272, spellId3 = 61780, spellId4 = 61305, spellId5 = 61721, spellId6 = 28271, size = 34, unitId = "target", isMine = "1", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 37}},

	-- Combustion (Fire)
    {spellId = 83853, size = 28, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},	
    -- Arcane Blast debuff 
    --{spellId = 36032, size = 28, unitId = "player", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},
    -- Invocation (Arcane), Pyromaniac (Fire)
    --{spellId = 87098, spellid2 = 83582, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 0}},
	-- Incanter's Absorption (Arcane)
	--{spellId = 44413, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},
	-- Deep Freeze (Frost)
	--{spellId = 44572, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 0}},
	
    -- Living Bomb
    {spellId = 44457, size = 28, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 207, -191}},
    -- Slow (Arcane), Ignite (Fire), Frostbite (Frost)
    --{spellId = 31589, spellId2 = 12654, spellId3 = 12497, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},
	-- Pyroblast debuff (Fire)
    --{spellId = 92315, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, -37}},
	-- Frostfire bolt (glyphed)
    --{spellId = 44614, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -37}},

    -- Fingers of Frost (Frost), Arcane Missiles! (Arcane), Hot Streak (Fire)
    {spellId = 44544, spellId2 = 79683, spellId3 = 48108, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 119, -35}},
    -- Brain Freeze (Frost), Clear Casting, Cauterize (Fire)
    {spellId = 57761, spellId2 = 12536, spellId3 = 87023, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -119, -35}},  
	},

	["MONK"] = {
	-- Mistweaver Auras --
	-- Mana Tea
	{spellId = 123761, size = 30.5, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -178, -112}},	
	-- Test
	--{spellId = 117666, size = 30.5, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -210, -112}},
	},
	
    ["PALADIN"] = {
	
	-- Seal of Righteousness (AKA TURN IT OFF)
    {spellId = 20154, size = 38, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 0, 210}},	
    -- Speed of Light (Holy), Divine protection
    --{spellId = 85497, spellId2 = 498, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 37}},
	-- Ardent Defender
    {spellId = 31850, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 119, -35}},
	-- Forbearance
	--{spellId = 25771, size = 34, unitId = "player", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 37}},

	-- Daybreak (Holy), Holy Shield (Protection)
	--{spellId = 88819, spellId2 = 20925, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
	-- Guarded by the light (Protection)
	{spellId = 88063, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -119, -35}},
 	-- Divine Plea
	--{spellId = 54428 , size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 0}},
	
	-- Censore (SoT debuff)
	--{spellId = 31803, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
	-- Inquisition
	{spellId = 84963, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},
	-- Avenging Wrath
    {spellId = 31884, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -195}},	
    --Divine Purpose (retribution), Infusion of Light (Holy)
	{spellId = 90174, spellId2 = 54149, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 119, -35}},		
	-- Art of War (Retribution), Denounce (Holy)
    {spellId = 59578, spellId2 = 85509, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -119, -35}},
	-- Zealotry, Grand Crusader (Protection)
    {spellId = 85696, spellId2 = 85416, size = 28, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 207, -195}},
	},
    
	["PRIEST"] = {

    -- Surge of Light (Holy) 
    --{spellId = 33151, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 37}},
	-- Mind Spike 
	--{spellId = 87178, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 37}},	
	-- Serendipity (Rank 1,2) (Holy), Mind Melt (Shadow)
	{spellId = 63731, spellId2 = 63735, spellId3 = 81292, size = 28, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},
	-- Empowered Shadow (Shadow Mastery)
	{spellId = 95799, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},	

	
	-- Chakra, Chakra States: Heal, Renew, Prayer of Healing, Smite 
	--{spellId = 14751, spellId2 = 81208, spellId3 = 81207, spellId4 = 81206, spellId5 = 81209, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
	-- Borrowed Time (Discipline)
	--{spellId = 59889, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
	-- Shadow Orb
	{spellId = 77487, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 119, -35}},
	-- Evangelism, Dark Evangelism 
	{spellId = 81660, spellId2 = 87117, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 207, -195}},
	-- Archangel, Dark Archangel 
	{spellId = 81700, spellId2 = 87153, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -195}},

    -- Shadow Word:Pain
    --{spellId = 589, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},
    -- Vampiric Touch
    --{spellId = 34914, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
    -- Devouring Plague
    --{spellId = 2944, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, -37}},
    -- Power Word:Shield on self
    --{spellId = 17, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -37}},

	-- Power Infusion on self
	--{spellId = 10060, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 148, -91}},
	-- Spirit of Redemption (Holy)
	--{spellId = 27827, size = 64, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 222, -91}},
	
    },

    ["ROGUE"] = {

	-- Adrenaline Rush, Shallow Insight, Vendetta (Assassination)
	{spellId = 13750, spellId2 = 79140, size = 28, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 207, -195}},
	-- Bandit's Guile (Combat) 
	{spellId = 84745, spellId2 = 84746, spellId3 = 84747, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -195}},
	--Shadowdance
	{spellId = 51713, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},	
	
	-- Rupture
	--{spellId = 1943, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 0}},	
	-- Deadly Poison
    --{spellId = 67710, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
	-- Wound Poison 
    --{spellId = 13218, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},
   	-- Crippling Poison 
	--{spellId = 3409, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, -37}},
    -- Mind-numbing Poison
    --{spellId = 5760, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -37}},
	
	-- Rogue T13 2P Bonus (Tricks of Time)
	{spellId = 105864, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -229}},
	-- Recuperate
	--{spellId = 73651, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -35, -146}},
	--Faint
	{spellId = 1966, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 119, -35}},
	-- Slice and Dice
	{spellId = 5171, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -119, -35}},
	
	},
	
    ["SHAMAN"] = {
	-- Spiritual Stimulus (T13 resto 2pc)
	{spellId = 105763, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 207, -195}},
	-- Heart of Unliving (LFR, NM, HM procs) - move to specific class as desired.
	{spellId = 109811, spellId2 = 107962, spellId3 = 109813, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -195}},
	-- Mana Tide
	--{spellId = 16191, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -195}},	
	
    -- Hex
    {spellId = 51514, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 119, -35}},
	-- Searing Flame (Enhancement Searing Totem)
	--{spellId = 77661, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 37}},

    -- Water Shield, Earth Shield, Lightning Shield
    --{spellId = 52127, spellId2 = 974, spellId3 = 324, size = 34, unitId = "player", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
    -- Flame Shock, Frost Shock
    --{spellId = 8050, spellId2 = 8056, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},
	-- Tidal Waves, Maelstrom Weapon, Elemental Mastery (haste, damage)
    {spellId = 53390, spellId2 = 53817, spellId3 = 64701, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},

	-- Earth Shield on target 
    --{spellId = 974, size = 34, unitId = "target", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
    -- Riptide
    --{spellId = 61295, size = 34, unitId = "target", isMine = "all", filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},

	},

    ["WARLOCK"] = {
	-- Fear, Nightmare 
	--{spellId = 5782, spellId2 = 1714, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 37}},

    -- CoE, Ebon Plague, Earth and Moon
    --{spellId = 1490, spellId2 = 65142, spellId3 = 60433, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, 0}},
    -- CoT, CoEx, CoW
    --{spellId = 1714, spellId2 = 18223, spellId3 = 702, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 0}},
    -- Molten Core (Demonology), Shadow Trance (Affliction), Improved Soulfire (Destruction)
    {spellId = 47383, spellId2 = 18095, spellId3 = 85383, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},
    -- Decimation (Demonology), Backdraft (Destruction), Eradication (Affliction)
    --{spellId = 63158, spellId2 = 54277, spellId3 = 47195, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 0}},

    -- Immolation, Unstable Affliction (Affliction)
    --{spellId = 348, spellId2 = 30108, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
    -- Corruption, SoC
    --{spellId = 172, spellId2 = 27243, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},
    -- BoA, BoD, BoH (Destruction)
    --{spellId = 980, spellId2 = 603, spellId3 = 80240, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, -37}},
    -- Haunt, Demonic Rebirth (Demonology)
	{spellId = 48181, spellId2 = 88448, size = 28, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 207, -195}},

	-- Empowered Imp (Destruction)
	{spellId = 47283, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -195}},
	-- Backlash
	{spellId = 34939, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 119, -35}},
	},

    ["WARRIOR"] = {

	-- Shield Wall
	{spellId = 871, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, -195}},
	-- Last Stand, Die by the Sword
	{spellId = 12975, spellId2 = 85386, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 171, -195}},
	-- Enraged Regeneration
	--{spellId = 55694, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 37}},	

	-- Inner Rage 
	{spellId = 1134, size = 28, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 207, -195}},
	-- Enrage 
	--{spellId = 12880, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, 0}},
	-- Rude Interruption (Fury), Jaggernaut (Arms) 
    --{spellId = 86663, spellId2 = 65156, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, 0}},
	-- Stuns: Throwdown, Charge, Intercept, Concussion Blow
	--{spellId = 85388, spellId2 = 7922, spellId3 = 20253, spellId4 = 12809, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 243, 0}},

    -- Rend
    --{spellId = 94009, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 132, -37}},
    -- Hamstring, Piercing Howl
    --{spellId = 1715, spellId2 = 12323, size = 34, unitId = "target", isMine = "all", filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 169, -37}},
	-- Thunderstruck (Protection)
    --{spellId = 87095, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, -37}},	
	-- Colossus Smash debuff
    --{spellId = 86346, size = 34, unitId = "target", isMine = 1, filter = "HARMFUL", setPoint = {"CENTER", UIParent, "CENTER", 206, -37}},	
	
    -- Sword and Board (Protection), Bloodsurge (Fury), Sudden Death (Arms)
    {spellId = 50227, spellId2 = 46916, spellId3 = 52437,size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", 119, -35}}, 
	-- Taste of Blood (Arms) 
	{spellId = 60503, size = 34, unitId = "player", isMine = 1, filter = "HELPFUL", setPoint = {"CENTER", UIParent, "CENTER", -119, -35}},
	},
}