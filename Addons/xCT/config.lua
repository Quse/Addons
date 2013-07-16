--[[   ____ _____
__  __/ ___|_   _|_
\ \/ / |     | |_| |_
 >  <| |___  | |_   _|
/_/\_\\____| |_| |_|
World of Warcraft (4.3)

Title: xCT+
Author: Dandruff
Version: 2.x.x
Description:
  xCT+ is an extremely lightwight scrolling combat text addon.  It replaces Blizzard's default
scrolling combat text with something that is more concised and organized.  xCT+ is a stand alone
addon, based on xCT (by Affli).

]]

local addon, ns = ...
ns.config = {
    -- --------------------------------------------------------------------------------------
    -- Blizzard Damage Options.
    -- --------------------------------------------------------------------------------------   
        -- Use Blizzard Damage/Healing Output (Numbers Above Mob/Player's Head)
        ["blizzheadnumbers"]    = true,  -- (You need to restart WoW to see changes!)
        
        -- DO NOT USE - BUGGY
        -- Change Default Damage/Healing Font Above Mobs/Player Heads. (This has no effect if ["blizzheadnumbers"] = false)
        -- ["damagestyle"]         = true,  -- (You need to restart WoW to see changes!)
        -- DO NOT USE - BUGGY
        
        -- "Everything else" font size (heals/interrupts and the like)
        ["fontsize"]        = 16,
        ["font"]            = "Interface\\Addons\\sharedmedia\\fonts\\font.TTF",  -- "Fonts\\ARIALN.ttf" is default WoW font.
        
        
    -- --------------------------------------------------------------------------------------
    -- xCT+ Frames
    -- --------------------------------------------------------------------------------------
        -- Allow mouse scrolling on ALL frames (recommended "false")
        ["scrollable"]          = true,
        ["maxlines"]            = 32,       -- Max lines to keep in scrollable mode. More lines = more Memory Nom nom nom
        
        
        -- ==================================================================================
        -- Healing/Damage Outing Frame (frame is called "xCTdone")
        -- ==================================================================================
        ["damageout"]           = false,     -- show outgoing damage
        ["healingout"]          = false,     -- show outgoing heals
        
            -- Filter Units/Periodic Spells
            ["petdamage"]       = true,     -- show your pet damage.
            ["dotdamage"]       = true,     -- show DoT damage
            ["showhots"]        = true,     -- show periodic healing effects in xCT healing frame.
            ["showimmunes"]     = true,     -- show "IMMUNE"s when you or your target cannot take damage or healing
            ["hideautoattack"]  = false,    -- Hides the auto attack icon from outgoing frame
            
            -- Damage/Healing Icon Sizes and Appearence
            ["damagecolor"]     = true,     -- display colored damage numbers by type
            ["icons"]           = false,     -- show outgoing damage icons
            ["iconsize"]        = 8,       -- outgoing damage icons' size
            ["damagefontsize"]  = 8,
            ["fontstyle"]       = "OUTLINEMONOCHROME",                            -- valid options are "OUTLINE", "MONOCHROME", "THICKOUTLINE", "OUTLINE,MONOCHROME", "THICKOUTLINE,MONOCHROME"
            ["damagefont"]      = "Interface\\Addons\\sharedmedia\\fonts\\font.TTF",  -- "Fonts\\FRIZQT__.ttf" is default WoW damage font
            
            -- Damage/Healing Minimum Value threshold
            ["treshold"]        = 1,        -- minimum value for outgoing damage
            ["healtreshold"]    = 1,        -- minimum value for outgoing heals
        -- __________________________________________________________________________________


        -- ==================================================================================
        -- Critical Damage/Healing Outging Frame (frame is called "xCTcrit")
        -- ==================================================================================
        ["critwindow"]          = false,
        
            -- Critical Icon Sizes
            ["criticons"]       = true,     -- show crit icons
            ["criticonsize"]    = 14,       -- size of the icons in the crit frame
                        
            -- Critical Custom Font and Format
            ["critfont"]        = "Interface\\Addons\\sharedmedia\\fonts\\font.TTF",  -- Special font for the crit frame
            ["critfontstyle"]   = "OUTLINEMONOCHROME",
            ["critfontsize"]    = 16,                   -- crit font size ("auto" or Number)
            
            -- Critical Appearance Options
            ["critprefix"]      = "|cffFF0000*|r",      -- prefix symbol shown before crit'd amount (default: red *)
            ["critpostfix"]     = "|cffFF0000*|r",      -- postfix symbol shown after crit'd amount (default: red *)
            
            -- Filter Criticals
            ["filtercrits"]     = false,    -- Allows you to turn on a list that will filter out buffs
            ["crits_blacklist"] = false,    -- Filter list is a blacklist (If you want a TRUE whitelist, don't forget to hide Swings too!!)
            ["showswingcrits"]  = true,     -- Allows you to show/hide (true / false) swing criticals
            ["showasnoncrit"]   = true,     -- When a spell it filtered, show it in the non Critical window (with critical pre/post-fixes)
        -- __________________________________________________________________________________

        
        -- ==================================================================================
        -- Loot Items/Money Gains (frame is called "xCTloot")
        -- ==================================================================================
        ["lootwindow"]          = false,     -- Enable the frame "xCTloot" (use instead of "xCTgen" for Loot/Money)
        
            -- What to show in "xCTloot"
            ["lootitems"]       = false,
            ["lootmoney"]       = false,
            
            -- Item Options
            ["loothideicons"]   = true,    -- hide item icons when looted
            ["looticonsize"]    = 20,       -- Icon size of looted, crafted and quest items
            ["itemstotal"]      = false,    -- show the total amount of items in bag ("[Epic Item Name]x1 (x23)") - This is currently bugged and inacurate
            
            -- Item/Money Filter
            ["crafteditems"]    = nil,      -- show crafted items ( nil = default, false = always hide, true = always show)
            ["questitems"]      = nil,      -- show quest items ( nil = default, false = always hide, true = always show)
            ["itemsquality"]    = 3,        -- filter items shown by item quality: 0 = Poor, 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Epic, 5 = Legendary, 6 = Artifact, 7 = Heirloom
            ["minmoney"]        = 0,        -- filter money received events, less than this amount (4G 32S 12C = 43212)
        
            -- Item/Money Appearance 
            ["colorblind"]      = false,    -- shows letters G, S, and C instead of textures
        -- __________________________________________________________________________________


        -- ==================================================================================
        -- Spell / Ability Procs Frame (frame is called "xCTproc")
        -- ==================================================================================
        -- NOTE: This only has the ability to show only procs that blizzards sends to it
        --       (mostly spells that "light up" and some others too).
        ["procwindow"]          = false,     -- Enable the frame to show Procs
        
            -- Proc Frame Custom Font Options
            ["procfont"]        = "Interface\\Addons\\sharedmedia\\fonts\\font.TTF",  -- Special font for the proc frame
            ["procfontsize"]    = 8,                   -- proc font size ("auto" or Number)
            ["procfontstyle"]   = "OUTLINEMONOCHROME",
        -- __________________________________________________________________________________
        
        
        -- ==================================================================================
        -- Power Gains/Fades Incoming Frame (frame is called "xCTpwr")
        -- ==================================================================================
        ["powergainswindow"]    = false,     -- Enable the frame to show Auras
        
            -- Filter Auras Gains or Fades
            ["showharmfulaura"] = true,   -- Show Harmful Auras (Gains and Losses)
            ["showhelpfulaura"] = true,   -- Show Helpful Auras (Gains and Losses)
            ["showgains"]       = true,   -- Show Gains in the Aura frame
            ["showfades"]       = true,   -- Show Fades in the Aura frame
            ["filteraura"]      = true,   -- allows you to filter out unwanted aura gains/losses
            ["aura_blacklist"]  = true,   -- aura list is a blacklist (opposed to a whitelist)
            
            -- Filter Aura Helpers
            ["debug_aura"]      = false,  -- Shows your Aura's names in the chatbox.  Useful when adding to the filter yourself.
        -- __________________________________________________________________________________
    

    -- --------------------------------------------------------------------------------------
    -- xCT+ Frames' Justification
    -- --------------------------------------------------------------------------------------
        --[[Justification Options: "RIGHT", "LEFT", "CENTER" ]]
        ["justify_1"] = "RIGHT",             -- Damage Incoming Frame (frame is called "xCTdmg")
        ["justify_2"] = "LEFT",            -- Healing Incoming Frame (frame is called "xCTheal")
        ["justify_3"] = "CENTER",           -- General Buffs Gains/Drops Frame (frame is called "xCTgen")
        ["justify_4"] = "RIGHT",            -- Healing/Damage Outgoing Frame (frame is called "xCTdone")
        ["justify_5"] = "CENTER",           -- Loot/Money Gains Frame (frame is called "xCTloot")
        ["justify_6"] = "RIGHT",            -- Criticals Outgoing Frame (frame is called "xCTcrit")
        ["justify_7"] = "LEFT",             -- Power Gains Frame (frame is called "xCTpwr")
        ["justify_8"] = "CENTER",           -- Procs Frame (frame is called "xCTproc")    
    
    
    -- --------------------------------------------------------------------------------------
    -- xCT+ Class Specific and Misc. Options
    -- --------------------------------------------------------------------------------------
        -- Priest
        ["stopvespam"]          = false,  -- Hides Healing Spam for Priests in Shadowform.
        
        -- Death Knight
        ["dkrunes"]             = true,   -- Show Death Knight Rune Recharge
        ["mergedualwield"]      = true,   -- Merge dual wield damage
        
        -- Misc.
            -- Spell Spam Spam Spam Spam Spam Spam Spam Spam
            ["mergeaoespam"]    = true,   -- Merges multiple AoE spam into single message, can be useful for dots too.
            ["mergeaoespamtime"] = 3,     -- Time in seconds AoE spell will be merged into single message.  Minimum is 1.
        
            -- Helpful Alerts (Shown in the Gerenal Gains/Drops Frame)
            ["killingblow"]     = true,   -- Alerts with the name of the PC/NPC that you had a killing blow on (Req. ["damageout"] = true)
            ["dispel"]          = true,   -- Alerts with the name of the (De)Buff Dispelled (Req. ["damageout"] = true)
            ["interrupt"]       = true,   -- Alerts with the name of the Spell Interupted (Req. ["damageout"] = true)
        
            -- Alignment Help (Shown when configuring frames)
            ["showgrid"]        = true,   -- shows a grid when moving xCT windows around
            
            -- Show Procs
            ["filterprocs"]     = true,   -- Enable to hide procs from ALL frames (will show in xCTproc or xCTgen otherwise)
            
            
    -- --------------------------------------------------------------------------------------
    -- Experimental Options - USE CAUTION
    -- --------------------------------------------------------------------------------------
--[[ Please Note:  Any option below might not work according to the description, which may include poor implementation, bugs, and
--                 and rare cases unstability.  Enable only if you are specifically told you can try out features.
--  
--                 In other words:  USE AT YOUR OWN RISK
]]    

        -- (DISABLED: Currently does not work)
        ["loottimevisible"]     = 6,
        ["crittimevisible"]     = 3,
        ["timevisible"]         = 3,
}

