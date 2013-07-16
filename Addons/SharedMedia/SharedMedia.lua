-- tab size is 4
-- registrations for media from the client itself belongs in LibSharedMedia-3.0

if not SharedMedia then return end
local revision = tonumber(string.sub("$Revision: 163 $", 12, -3))
SharedMedia.revision = (revision > SharedMedia.revision) and revision or SharedMedia.revision

-- -----
-- BACKGROUND
-- -----
SharedMedia:Register("background", "Stripes", [[Interface\Addons\SharedMedia\background\walltex.tga]])
SharedMedia:Register("background", "Flat", [[Interface\Addons\SharedMedia\background\blanktex.tga]])

-- -----
--  BORDER
-- ----
SharedMedia:Register("border", "Glow", [[Interface\Addons\SharedMedia\border\glowtex.tga]])
SharedMedia:Register("border", "Pixel", [[Interface\Addons\SharedMedia\border\pixel.tga]])
SharedMedia:Register("border", "Square", [[Interface\Addons\SharedMedia\border\squareline.tga]])
-- -----
--   FONT
-- -----

SharedMedia:Register("font", "Pixel Font",				[[Interface\Addons\SharedMedia\fonts\font.ttf]])
SharedMedia:Register("font", "Normal Font",				[[Interface\Addons\SharedMedia\fonts\font2.ttf]])
SharedMedia:Register("font", "FCT font",				[[Interface\Addons\SharedMedia\fonts\FCT.ttf]])

-- -----
--   SOUND
-- -----

-- -----
--   STATUSBAR
-- -----
SharedMedia:Register("statusbar", "Statusbar",				[[Interface\Addons\SharedMedia\statusbar\Statusbar]])
