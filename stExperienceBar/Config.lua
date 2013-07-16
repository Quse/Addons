stExp = {}

-- Config ----------------
--------------------------
--Font/Text
stExp.font = "Interface\\Addons\\sharedmedia\\fonts\\font.ttf"
stExp.fontsize = 8
stExp.fontflags = "MONOCHROMEOUTLINE"
stExp.showText = false		 -- Set to false to hide text
stExp.mouseoverText = true -- Set to true to only show text on mouseover

--Textures/Colors
stExp.barTex = "Interface\\Addons\\sharedmedia\\statusbar\\statusbar.ttf"
stExp.bordercolor = { 0, 0, 0 }
stExp.backdropcolor = { 0.078, 0.078, 0.078 }
--Sizes
stExp.playerWidth = 182
stExp.playerHeight = 7
stExp.guildWidth = 130
stExp.guildHeight = 8 

--Placement
stExp.playerAnchor = { "TOP", Minimap, "BOTTOM", 0, 20 }
stExp.guildAnchor = { "TOP", Minimap, "BOTTOM", 0, -30}

--Misc
stExp.hideinCombat = false