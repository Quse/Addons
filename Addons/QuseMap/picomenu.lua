-- Picomenu: MainMenuBar replacement by Neal, butchered by Qupe

local config = {
["showPicomenu"] = true,
}


if config.showPicomenu == true then
local menuFrame = CreateFrame('Frame', 'picomenuDropDownMenu', MainMenuBar, 'UIDropDownMenuTemplate')

local menuList = {
    {
        text = MAINMENU_BUTTON,
        isTitle = true,
        notCheckable = true,
    },
    {
        text = CHARACTER_BUTTON,
        icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle',
        func = function() 
            securecall(ToggleCharacter, 'PaperDollFrame') 
        end,
                tooltipTitle = 'MOOO',
        notCheckable = true,
    },
    {
        text = SPELLBOOK_ABILITIES_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\Class',
        func = function() 
            securecall(ToggleSpellBook, BOOKTYPE_SPELL)
        end,
        notCheckable = true,
    },
    {
        text = TALENTS_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\Ammunition',
        -- icon = 'Interface\\AddOns\\qusemap\\picomenu\\picomenuTalents',
        func = function() 
			if (not PlayerTalentFrame) then 
                LoadAddOn('Blizzard_TalentUI') 
            end

			if (not GlyphFrame) then 
                LoadAddOn('Blizzard_GlyphUI') 
            end 

			PlayerTalentFrame_Toggle()
        end,
        notCheckable = true,
    },
    {
        text = ACHIEVEMENT_BUTTON,
        icon = 'Interface\\AddOns\\qusemap\\picomenu\\picomenuAchievement',
        func = function() 
            securecall(ToggleAchievementFrame) 
        end,
        notCheckable = true,
    },
    {
        text = QUESTLOG_BUTTON,
        icon = 'Interface\\GossipFrame\\ActiveQuestIcon',
        func = function() 
            securecall(ToggleFrame, QuestLogFrame) 
        end,
        notCheckable = true,
    },
    {
        text = GUILD,
        icon = 'Interface\\GossipFrame\\TabardGossipIcon',
        arg1 = IsInGuild('player'),
        func = function() 
            ToggleGuildFrame()
        end,
        notCheckable = true,
    },
    {
        text = SOCIAL_BUTTON,
        icon = 'Interface\\FriendsFrame\\PlusManz-BattleNet',
        func = function() 
            securecall(ToggleFriendsFrame, 1) 
        end,
        notCheckable = true,
    },
    {
        text = PLAYER_V_PLAYER,
        icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster',
        func = function() 
            securecall(ToggleFrame, PVPFrame) 
        end,
        notCheckable = true,
    },
    {
        text = DUNGEONS_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\None',
        func = function() 
            securecall(ToggleLFDParentFrame)
        end,
        notCheckable = true,
    },
    {
        text = MOUNTS_AND_PETS,
        icon = 'Interface\\MINIMAP\\TRACKING\\StableMaster',
        func = function() 
            securecall(TogglePetJournal)
        end,
        notCheckable = true,
    },
    {
        text = RAID,
        icon = 'Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull',
        func = function() 
            securecall(ToggleFriendsFrame, 4)
        end,
        notCheckable = true,
    },
    {
        text = ENCOUNTER_JOURNAL,
        icon = 'Interface\\MINIMAP\\TRACKING\\Profession',
        func = function() 
            securecall(ToggleEncounterJournal)
        end,
        notCheckable = true,
    },
    {
        text = GM_EMAIL_NAME,
        icon = 'Interface\\CHATFRAME\\UI-ChatIcon-Blizz',
        func = function() 
            securecall(ToggleHelpFrame) 
        end,
        notCheckable = true,
    },
    {
        text = BATTLEFIELD_MINIMAP,
        colorCode = '|cff999999',
        func = function() 
            securecall(ToggleBattlefieldMinimap) 
        end,
        notCheckable = true,
    },
}


local f = CreateFrame('Button', nil, PicoMenuBar)
--f:SetFrameStrata('LOW')
--f:SetToplevel(false)
f:SetSize(11,8)
f:SetPoint('BOTTOMLEFT', Minimap, 'BOTTOMLEFT', -.5,18)
f:RegisterForClicks('Anyup')
f:RegisterEvent('ADDON_LOADED')

f:SetNormalTexture('Interface\\AddOns\\qusemap\\picomenu\\picomenuNormal')
f:GetNormalTexture():SetSize(11,8)

f:SetHighlightTexture('Interface\\AddOns\\qusemap\\picomenu\\picomenuHighlight')
f:GetHighlightTexture():SetAllPoints(f:GetNormalTexture())

f:SetScript('OnMouseDown', function(self)
    self:GetNormalTexture():ClearAllPoints()
    self:GetNormalTexture():SetPoint('CENTER', 1, -1)
end)

f:SetScript('OnMouseUp', function(self, button)
    self:GetNormalTexture():ClearAllPoints()
    self:GetNormalTexture():SetPoint('CENTER')

    if (button == 'LeftButton') then
        if (self:IsMouseOver()) then
            if (DropDownList1:IsShown()) then
                DropDownList1:Hide()
            else
                securecall(EasyMenu, menuList, menuFrame, self, 27, 190, 'MENU', 8)
                -- DropDownList1:ClearAllPoints()
                -- DropDownList1:SetPoint('BOTTOMLEFT', self, 'TOPRIGHT')
            end
        end
    else
        if (self:IsMouseOver()) then
            ToggleFrame(GameMenuFrame)
        end
    end

    GameTooltip:Hide()
end)

f:SetScript('OnEnter', function(self) 
    GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 25, -5)
    GameTooltip:AddLine(MAINMENU_BUTTON)
    GameTooltip:Show()
end)

f:SetScript('OnLeave', function() 
    GameTooltip:Hide()
end)
end
HelpOpenTicketButton:ClearAllPoints()
HelpOpenTicketButton:SetPoint('TOPLEFT', f, 'BOTTOMRIGHT', -26, 26)
HelpOpenTicketButton:SetScale(0.6)
HelpOpenTicketButton:SetParent(f)