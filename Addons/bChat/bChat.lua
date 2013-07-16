-----------------------------------------------
--Config
-----------------------------------------------
-- Font Shadow
shadowoffset = {x = 1, y = -1}
-- Hide Black Combat Log Bar
hidecombat = true
-- Justify Combat Log to the Right, 0/1 = off/on
combatlogright = 0
-----------------------------------------------
--Config End
-----------------------------------------------
for i = 1, NUM_CHAT_WINDOWS do
     _G['ChatFrame'..i]:SetFont("Interface\\AddOns\\SharedMedia\\fonts\\font2.ttf", 11, "OUTLINE")
end

CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
ChatTypeInfo.WHISPER.sticky = 1
ChatTypeInfo.OFFICER.sticky = 1
ChatTypeInfo.CHANNEL.sticky = 1

ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide 
ChatFrameMenuButton:Hide() 
FriendsMicroButton.Show = FriendsMicroButton.Hide 
FriendsMicroButton:Hide()
BNToastFrame:SetClampedToScreen(true)


_G.CHAT_WHISPER_INFORM_GET = 'To %s:\32'
_G.CHAT_WHISPER_GET = 'From %s:\32'
_G.CHAT_YELL_GET = '%s:\32'
_G.CHAT_SAY_GET = '%s:\32'
_G.CHAT_BATTLEGROUND_GET = '|Hchannel:Battleground|h[BG]|h %s:\32'
_G.CHAT_BATTLEGROUND_LEADER_GET = '|Hchannel:Battleground|hBG|h %s:\32'
_G.CHAT_GUILD_GET = '|Hchannel:Guild|h[G]|h %s:\32'
_G.CHAT_PARTY_GET = '|Hchannel:Party|h[P]|h %s:\32'
_G.CHAT_PARTY_LEADER_GET = '|Hchannel:party|h[P]|h %s:\32'
_G.CHAT_PARTY_GUIDE_GET = '|Hchannel:PARTY|h[P]|h %s:\32'
_G.CHAT_OFFICER_GET = '|Hchannel:o|h[O]|h %s:\32'
_G.CHAT_RAID_GET = '|Hchannel:raid|h[R]|h %s:\32'
_G.CHAT_RAID_LEADER_GET = '[|Hchannel:raid|hR|h] %s:\32'
_G.CHAT_RAID_WARNING_GET = 'RW %s:\32'

CHAT_FRAME_FADE_OUT_TIME = 0
CHAT_TAB_HIDE_DELAY = 1
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 0

if hidecombat==true then
    local EventFrame = CreateFrame("Frame");
    EventFrame:RegisterEvent("ADDON_LOADED");
    local function EventHandler(self, event, ...)
        if ... == "Blizzard_CombatLog" then
            local topbar = _G["CombatLogQuickButtonFrame_Custom"];
            if not topbar then return end
            topbar:Hide();
            topbar:HookScript("OnShow", function(self) topbar:Hide(); end);
            topbar:SetHeight(0);
        end
    end
    EventFrame:SetScript("OnEvent", EventHandler);
end

local gsub = _G.string.gsub
local newAddMsg = {}
CHAT_FLAG_GM = "GM "
CHAT_BN_WHISPER_INFORM_GET = "T: %s "
CHAT_BN_WHISPER_GET = "F: %s "
CHAT_RAID_WARNING_GET = "%s "

local function AddMessage(frame, text, ...)
    text = gsub(text, "%[(%d0?)%. .-%]", "[%1]")
    text = gsub(text, "^|Hchannel:[^%|]+|h%[[^%]]+%]|h ", "")
	text = gsub(text, "|Hplayer:([^%|]+)|h%[([^%]]+)%]|h", "|Hplayer:%1|h%2|h")
    text = gsub(text, "<Away>", "<AFK>")
	text = gsub(text, "<Busy>", "<DND>")
    text = gsub(text, "|Hplayer:([^%|]+)|h(.+)|h says:", "|Hplayer:%1|h%2|h:")
	text = gsub(text, "|Hplayer:([^%|]+)|h(.+)|h yells:", "|Hplayer:%1|h%2|h:")
	text = gsub(text, "|Hplayer:([^%|]+)|h(.+)|h whispers:", "F |Hplayer:%1|h%2|h:")
	text = gsub(text, "^To ", "T ")
    text = gsub(text, "Guild Message of the Day:", "GMotD -")
    text = gsub(text, '([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])', '|cffffffff|Hurl:%1|h[%1]|h|r')
    text = gsub(text, "%[%d+%. WorldDefense%]", "Defense ")
    text = gsub(text, "%[%d+%. LocalDefense.-%]", "Local ")
    text = gsub(text, "%[%d+%. LookingForGroup%]", "LFG ")
    text = gsub(text, "%[%d+%. GuildRecruitment.-%]", "GRecruit ")
    text = gsub(text, "Joined Channel:", "+")
    text = gsub(text, "Left Channel:", "- ")
    text = gsub(text, "Changed Channel:", ">")
	text = gsub(text, "%[(%d0?)%. .-%]", "%1")
	return newAddMsg[frame:GetName()](frame, text, ...)
end

function string.color(text, color)
    return "|cff"..color..text.."|r"
end
function string.link(text, type, value, color)
    return "|H"..type..":"..tostring(value).."|h"..tostring(text):color(color or "ffffff").."|h"
end
local function highlighturl(before,url,after)
    foundurl = true
    return " "..string.link(""..url.."", "url", url, "DDDDDD").." "
end
local function searchforurl(frame, text, ...)
    foundurl = false
    if string.find(text, "%pTInterface%p+") then foundurl = true end
    if not foundurl then text = string.gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)", highlighturl) end
    if not foundurl then text = string.gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)", highlighturl) end
    if not foundurl then text = string.gsub(text, "(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)", highlighturl) end
    if not foundurl then text = string.gsub(text, "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", highlighturl) end
    if not foundurl then text = string.gsub(text, "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", highlighturl) end
    if not foundurl then text = string.gsub(text, "(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)", highlighturl) end
    frame.am(frame,text,...)
end--]]

local tabs = {"Left", "Middle", "Right", "SelectedLeft", "SelectedMiddle",
    "SelectedRight", "Glow", "HighlightLeft", "HighlightMiddle", 
    "HighlightRight"}

for i = 1, NUM_CHAT_WINDOWS do
    local cf = 'ChatFrame'..i
    local tex = ({_G[cf..'EditBox']:GetRegions()})
    
    _G[cf..'ButtonFrame'].Show = _G[cf..'ButtonFrame'].Hide 
    _G[cf..'ButtonFrame']:Hide()
    
    _G[cf..'EditBox']:SetAltArrowKeyMode(false)
    _G[cf..'EditBox']:ClearAllPoints()
    _G[cf..'EditBox']:SetPoint('BOTTOMLEFT', ChatFrame1, 'TOPLEFT', 0, 6)
    _G[cf..'EditBox']:SetPoint('TOPRIGHT', _G.ChatFrame1, 'TOPRIGHT', 0, 30)
    _G[cf..'EditBox']:SetShadowOffset(0, 0)
    _G[cf..'EditBox']:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8', edgeFile = 'Interface\\Buttons\\WHITE8x8', edgeSize = 2})
    _G[cf..'EditBox']:SetBackdropColor(0,0,0,.8)
    _G[cf..'EditBox']:SetBackdropBorderColor(0,0,0,1)
    _G[cf..'EditBox']:HookScript("OnEditFocusGained", function(self) self:Show() end)
	_G[cf..'EditBox']:HookScript("OnEditFocusLost", function(self) self:Hide() end)
    _G[cf..'EditBoxHeader']:SetShadowOffset(0, 0)
    
	_G["ChatFrame"..i.."Tab"]:HookScript("OnClick", function() _G["ChatFrame"..i.."EditBox"]:Hide() end)
    tex[6]:SetAlpha(0) tex[7]:SetAlpha(0) tex[8]:SetAlpha(0) tex[9]:SetAlpha(0) tex[10]:SetAlpha(0) tex[11]:SetAlpha(0)
    _G[cf]:SetMinResize(0,0)
	_G[cf]:SetMaxResize(0,0)
    _G[cf]:SetFading(true)	
	_G[cf]:SetClampRectInsets(0,0,0,0)
    _G[cf]:SetShadowOffset(shadowoffset.x, shadowoffset.y)
    _G[cf..'ResizeButton']:SetPoint("BOTTOMRIGHT", cf, "BOTTOMRIGHT", 9,-5)
    _G[cf..'ResizeButton']:SetScale(.4)
    _G[cf..'ResizeButton']:SetAlpha(0.5)
    
    for g = 1, #CHAT_FRAME_TEXTURES do
        _G["ChatFrame"..i..CHAT_FRAME_TEXTURES[g]]:SetTexture(nil)
    end
    for index, value in pairs(tabs) do
        local texture = _G['ChatFrame'..i..'Tab'..value]
        texture:SetTexture(nil)
    end
    if i ~= 2 then
		local f = _G[format("%s%d", "ChatFrame", i)]
		newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
		f.AddMessage = AddMessage
	end
    if combatlogright == 1 then
        if i == 2 then
            _G[cf]:SetJustifyH("Right")
        end
    end
end

local AltInvite = SetItemRef
SetItemRef = function(link, text, button)
    local linkType = string.sub(link, 1, 6)
    if IsAltKeyDown() and linkType == "player" then
        local name = string.match(link, "player:([^:]+)")
        InviteUnit(name)
        return nil
    end
    return AltInvite(link,text,button)
end

FloatingChatFrame_OnMouseScroll = function(self, dir)
    if(dir > 0) then
        if(IsShiftKeyDown()) then
            self:ScrollToTop() else self:ScrollUp() end
    else if(IsShiftKeyDown()) then 
        self:ScrollToBottom() else self:ScrollDown() end
    end
end

local orig = ChatFrame_OnHyperlinkShow
	function ChatFrame_OnHyperlinkShow(frame, link, text, button)
		local type, value = link:match("(%a+):(.+)")
		curlink = value
		if ( type == "url" ) then
			StaticPopup_Show("TEXT_COPY_POPUP")
				else
			orig(self, link, text, button)
		end
	end
	
	-- URL Copy (in rChat by zork)
	local foundurl = false
  
	function string.color(text, color)
		return "|cff".."0099FF"..text.."|r"
	end
  
	function string.link(text, type, value, color)
		return "|H"..type..":"..tostring(value).."|h"..tostring(text):color(color or "ffffff").."|h"
	end
  
	local function highlighturl(before,url,after)
		foundurl = true
		return " "..string.link("["..url.."]", "url", url, color).." "
	end
  
	local function searchforurl(frame, text, ...)
  
		foundurl = false
  
		if string.find(text, "%pTInterface%p+") then 
			foundurl = true
		end
		if not foundurl then
			text = string.gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)", highlighturl)
		end	
		if not foundurl then
			text = string.gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)", highlighturl)
		end
		if not foundurl then
			text = string.gsub(text, "(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)", highlighturl)
		end
		if not foundurl then
			text = string.gsub(text, "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", highlighturl)
		end
		if not foundurl then
			text = string.gsub(text, "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", highlighturl)
		end
		if not foundurl then
		text = string.gsub(text, "(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)", highlighturl)
		end
  
		frame.am(frame,text,...)
 	end
	
	StaticPopupDialogs["TEXT_COPY_POPUP"] = {
  		text = "URL Copy",
		button2 = TEXT(CLOSE),
		hasEditBox = 1,
		hasWideEditBox = 1,
		OnShow = function(self)
			local eB = _G[self:GetName().."EditBox"]
			eB:SetText(curlink)
			curlink = nil
			eB:SetFocus()
			eB:HighlightText(0)
			local bt = _G[self:GetName().."Button2"]
			bt:ClearAllPoints()
			bt:SetWidth(200)
			bt:SetHeight(25)
			bt:SetPoint("CENTER", eB, "CENTER", 0, -30)
		end,
  		timeout = 60,
  		whileDead = true,
		EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
  		hideOnEscape = true,
	}
	  
	-- local orig = ChatFrame_OnHyperlinkShow
	-- function ChatFrame_OnHyperlinkShow(frame, link, text, button)
		-- local type, value = link:match("(%a+):(.+)")
		-- curlink = value
		-- if ( type == "url" ) then
			-- StaticPopup_Show("TEXT_COPY_POPUP")		
			-- orig(self, link, text, button)
		-- end
	-- end	
	-- URL Copy -- END
