
  -- // rBuffFrameStyler
  -- // zork - 2010

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = CreateFrame("Frame")
  ns.cfg = cfg

  -----------------------------
  -- CONFIG
  -----------------------------

  cfg.buffframe = {
    scale           = 1,
    pos             = { a1 = "TOPRIGHT", af = "UIParent", a2 = "TOPRIGHT", x = -20, y = -21 },
    userplaced      = false, --want to place the bar somewhere else?
    rowSpacing      = 0,
    colSpacing      = 0,
    buffsPerRow     = 10,
    gap             = 40, --gap in pixel between buff and debuff
  }

  cfg.tempenchant = {
    scale           = 1,
    pos             = { a1 = "TOPLEFT", af = "Minimap", a2 = "TOPLEFT", x = -20, y = -5 },
    userplaced      = false, --want to place the bar somewhere else?
    colSpacing      = 1,
  }
  
  -- cfg.tempenchant = {
    -- scale           = 1,
    -- pos             = { a1 = "CENTER", af = "UIParent", a2 = "CENTER", x = -166, y = -157 },
    -- userplaced      = false, --want to place the bar somewhere else?
    -- colSpacing      = 1,
  -- }

  cfg.textures = {
    normal            = "",
	debuff            = "Interface\\AddOns\\rBuffFrameStyler\\media\\debuff",
    outer_shadow      = "Interface\ChatFrame\ChatFrameBackground",
  }

  cfg.background = {
    showshadow        = true,   --show an outer shadow?
    shadowcolor       = { r = 0, g = 0, b = 0, a = 1},
    inset             = 1,
  }

  cfg.color = {
    normal            = { r = 0, g = 0, b = 0, },
    classcolored      = false,
  }

  cfg.duration = {
    fontsize        = 8,
    pos             = { a1 = "CENTER", x = 2, y = -1 },
  }

  cfg.count = {
    fontsize        = 8,
    pos             = { a1 = "BOTTOMRIGHT", x =0, y = 2 },
  }

  cfg.font = "Interface\\Addons\\SharedMedia\\fonts\\font.ttf"
  cfg.fontflag = "OUTLINEMONOCHROME"
