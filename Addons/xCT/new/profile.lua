local ADDON_NAME, engine = ...
local ct = engine.config

-- Check to see if we should load this module
if (ct["DisableProfileManager"]) then return end

--//== Default Profile ===========================================================================\\
engine.default_profile = {
  Name = "Default",
  Frames = {
    --[[
    X - Horizontal Axis
    Y - Vertical Axis
    Width - Width of the frame
    Height - Height of the frame
    Justify - Frame Anchor to Parent (this is NOT text justify)
    ]]
    -- <Critical>
    ["crit"] = {
      X = 256,
      Y = 0,
      Width = 256,
      Height = 128,
      Justify = "CENTER",
    }, -- </Critical>
    -- <Damage>
    ["dmg"] = {
      X = -448,
      Y = -80,
      Width = 128,
      Height = 128,
      Justify = "CENTER",
    }, -- </Damage>
    -- <General>
    ["gen"] = {
      X = 0,
      Y = 192,
      Width = 256,
      Height = 128,
      Justify = "CENTER",
    }, -- </General>
    -- <Healing>
    ["heal"] = {
      X = -448,
      Y = 80,
      Width = 128,
      Height = 128,
      Justify = "CENTER",
    }, -- </Healing>
    -- <Loot>
    ["loot"] = {
      X = 0,
      Y = 0,
      Width = 256,
      Height = 128,
      Justify = "CENTER",
    }, -- </Loot>
    -- <Outgoing>
    ["done"] = {
      X = 448,
      Y = 0,
      Width = 128,
      Height = 320,
      Justify = "CENTER",
    }, -- </Outgoing>
    -- <PowerGains>
    ["pwr"] = {
      X = 0,
      Y = -192,
      Width = 256,
      Height = 128,
      Justify = "CENTER",
    }, -- </PowerGains>
    -- <SpellProcs>
    ["proc"] = {
      X = -256,
      Y = 0,
      Width = 256,
      Height = 128,
      Justify = "CENTER",
    }, -- </SpellProcs>
    -- <ComboPoints>
    ["class"] = {
      X = 0,
      Y = 96,
      Width = 64,
      Height = 64,
      Justify = "CENTER",
    }, -- </ComboPoints>
  },
}
--\\==============================================================================================//

--//== Init Functions ============================================================================\\
function engine:Install()
  xCTPlus_SavedVars = {
    Profiles = {
      [1] = self.default_profile,
    },
    Characters = {
      [GetUnitName("player").."-"..GetRealmName()] = 1,
    }
  }
end

local loadingFrame = CreateFrame("Frame")
loadingFrame:RegisterEvent("ADDON_LOADED")
loadingFrame:SetScript("OnEvent", function(self, event, name)
    if name == ADDON_NAME then
      if not xCTPlus_SavedVars then engine:Install() end
    
      -- Get Character Selected ID
      engine.MyName = GetUnitName("player").."-"..GetRealmName()
      
      if not xCTPlus_SavedVars.Characters[engine.MyName] then
        xCTPlus_SavedVars.Characters[engine.MyName] = 1
      end
      
      -- init profile drop down
      UIDropDownMenu_Initialize(xCTProfilesDropDownMenu, engine.DropBox_Initialize)
      UIDropDownMenu_SetSelectedID(xCTProfilesDropDownMenu, xCTPlus_SavedVars.Characters[engine.MyName])

      local enteringWorld = CreateFrame("Frame")
      enteringWorld:RegisterEvent("PLAYER_ENTERING_WORLD")
      enteringWorld:SetScript("OnEvent", engine.LoadFrames)
      
      -- If we are using the default profile
      if UIDropDownMenu_GetSelectedID(xCTProfilesDropDownMenu) == 1 then   -- if Defualt Profile Selected
        xCTRemoveProfileButton:Disable()
      end
    end
  end)
--\\==============================================================================================//
  
--//== Init UI Objects ===========================================================================\\
do -- init xct frame manager gui
  if not xCTProfilesDropDownMenu then
     CreateFrame("Button", "xCTProfilesDropDownMenu", InterfaceOptionsCombatTextPanel, "UIDropDownMenuTemplate")
  end
   
  xCTProfilesDropDownMenu:ClearAllPoints()
  xCTProfilesDropDownMenu:SetPoint("TOPLEFT", 4, -400)
  xCTProfilesDropDownMenu:SetSize(300, 26)
  xCTProfilesDropDownMenu:Show()

  -- When someone clicks a "profile" from the DropDownMenu
  local function xCTProfilesDropDownMenuButtonOnClick(self)
    
    -- Can't change profiles while the frames are being configured
    if not ct.locked then
      StaticPopup_Show("XCT_ERRORPROFILE")
      return
    end
  
    local currentIndex = self:GetID()

    if (currentIndex == 1) then
      xCTRemoveProfileButton:Disable()
    else
      xCTRemoveProfileButton:Enable()
    end
    xCTPlus_SavedVars.Characters[engine.MyName] = currentIndex
    UIDropDownMenu_SetSelectedID(xCTProfilesDropDownMenu, currentIndex)
    
    engine:LoadFrames()
  end

  -- Gets called OnLoad and when you add a profile (populates the drop down menu)
  function engine.DropBox_Initialize(self, level)
     local info = UIDropDownMenu_CreateInfo()
     for index, profile in ipairs(xCTPlus_SavedVars.Profiles) do
        info = UIDropDownMenu_CreateInfo()
        info.text = profile.Name
        info.value = profile.Name
        info.func = xCTProfilesDropDownMenuButtonOnClick
        UIDropDownMenu_AddButton(info, level)
     end
  end

  UIDropDownMenu_SetWidth(xCTProfilesDropDownMenu, 200);
  UIDropDownMenu_SetButtonWidth(xCTProfilesDropDownMenu, 224)
  UIDropDownMenu_JustifyText(xCTProfilesDropDownMenu, "LEFT")

  -- Create a title for the Frame Manager on Blizzard's Combat Text Options Page
  local defaultFont, defaultSize = InterfaceOptionsCombatTextPanelTargetEffectsText:GetFont()

  local fsProfileTitle = InterfaceOptionsCombatTextPanel:CreateFontString(nil, "OVERLAY")
    fsProfileTitle:SetTextColor(1.00, 0.82, 0.00, 1.00)
    fsProfileTitle:SetFont(defaultFont, defaultSize + 6)
    fsProfileTitle:SetText("xCT+ Frame Manager")
    fsProfileTitle:SetPoint("TOPLEFT", 16, -356)
    
  local fsProfileSubtitle = InterfaceOptionsCombatTextPanel:CreateFontString(nil, "OVERLAY")
    fsProfileSubtitle:SetTextColor(0.90, 0.90, 0.00, 1.00)
    fsProfileSubtitle:SetFont(defaultFont, defaultSize)
    fsProfileSubtitle:SetText("Frame Profiles")
    fsProfileSubtitle:SetPoint("TOPLEFT", 20, -382)

  -- Create a button to create new profiles
  if not xCTNewProfileButton then
    CreateFrame("Button", "xCTNewProfileButton", InterfaceOptionsCombatTextPanel, "UIPanelButtonTemplate2")
  end

  xCTNewProfileButton:ClearAllPoints()
  xCTNewProfileButton:SetPoint("TOPLEFT", 242, -400)
  xCTNewProfileButton:SetSize(100, 26)
  xCTNewProfileButton:SetText(CREATE)
  xCTNewProfileButton:Show()
  xCTNewProfileButton:SetScript("OnClick", function(self)
    if ct.locked then
      StaticPopup_Show("XCT_NEWPROFILE")
    else
      StaticPopup_Show("XCT_ERRORPROFILE")
    end
  end)

  -- Create a button to delete profiles
  if not xCTRemoveProfileButton then
    CreateFrame("Button", "xCTRemoveProfileButton", InterfaceOptionsCombatTextPanel, "UIPanelButtonTemplate2")
  end

  xCTRemoveProfileButton:ClearAllPoints()
  xCTRemoveProfileButton:SetPoint("TOPLEFT", 344, -400)
  xCTRemoveProfileButton:SetSize(100, 26)
  xCTRemoveProfileButton:SetText(CALENDAR_VIEW_EVENT_REMOVE)
  xCTRemoveProfileButton:Show()
  xCTRemoveProfileButton:SetScript("OnClick", function(self)
    if ct.locked then
      StaticPopup_Show("XCT_REMOVEPROFILE")
    else
      StaticPopup_Show("XCT_ERRORPROFILE")
    end
  end)


  -- Create a button that allows you to enter config
  if not xCTStartConfigButton then
    CreateFrame("Button", "xCTStartConfigButton", InterfaceOptionsCombatTextPanel, "UIPanelButtonTemplate2")
  end

  xCTStartConfigButton:ClearAllPoints()
  xCTStartConfigButton:SetPoint("TOPLEFT", 12, -528)
  xCTStartConfigButton:SetSize(100, 26)
  xCTStartConfigButton:SetText("Unlock Frames")
  xCTStartConfigButton:Show()
  xCTStartConfigButton:SetScript("OnClick", function(self)
    engine.StartConfigMode()
    xCTStartConfigButton:Disable()
    xCTEndConfigButton:Enable()
  end)


  -- Create a button that allows you to enter config
  if not xCTEndConfigButton then
    CreateFrame("Button", "xCTEndConfigButton", InterfaceOptionsCombatTextPanel, "UIPanelButtonTemplate2")
  end

  xCTEndConfigButton:ClearAllPoints()
  xCTEndConfigButton:SetPoint("TOPLEFT", 114, -528)
  xCTEndConfigButton:SetSize(100, 26)
  xCTEndConfigButton:SetText("Lock Frames")
  xCTEndConfigButton:Show()
  xCTEndConfigButton:Disable()
  xCTEndConfigButton:SetScript("OnClick", function(self)
    engine:SaveFrames()
    engine.EndConfigMode()
    xCTEndConfigButton:Disable()
    xCTStartConfigButton:Enable()
  end)
end
--\\==============================================================================================//

--//== Manage the Profiles =======================================================================\\
--[[ Creates a copy of a table (including sub-tables)                                             ]]
function engine:CreateTable(fromTable)
  local newTable = { }
  for i, v in pairs(fromTable) do
    if type(v) == "table" then
      newTable[i] = self:CreateTable(v)
    else
      newTable[i] = v
    end
  end
  return newTable
end

--[[ Creates a new profile                                                                        ]]
function engine:CreateNewProfile(profileName)
  if profileName == "Default" then
    engine.pr("cannot create a profile named: 'Default'")
    return
  end

  local newProfile = engine:CreateTable(engine.default_profile)
  newProfile.Name = profileName
  
  table.insert(xCTPlus_SavedVars.Profiles, newProfile)
  xCTPlus_SavedVars.Characters[engine.MyName] = #xCTPlus_SavedVars.Profiles
  
  UIDropDownMenu_Initialize(xCTProfilesDropDownMenu, engine.DropBox_Initialize)
  UIDropDownMenu_SetSelectedID(xCTProfilesDropDownMenu, xCTPlus_SavedVars.Characters[engine.MyName])
  xCTRemoveProfileButton:Enable()
end

--[[ Removes a profile at the index                                                               ]]
function engine:RemoveProfile(profileIndex)
  table.remove(xCTPlus_SavedVars.Profiles, profileIndex)
  xCTPlus_SavedVars.Characters[engine.MyName] = 1

  xCTRemoveProfileButton:Disable()
  UIDropDownMenu_Initialize(xCTProfilesDropDownMenu, engine.DropBox_Initialize)
  UIDropDownMenu_SetSelectedID(xCTProfilesDropDownMenu, xCTPlus_SavedVars.Characters[engine.MyName])
end
--\\==============================================================================================//

--//== Saving the Frames =========================================================================\\
--[[Saves all the frames to the current profile                                                   ]]
function engine:SaveFrames()
  local selectedIndex = xCTPlus_SavedVars.Characters[engine.MyName]
  local currentProfile = xCTPlus_SavedVars.Profiles[selectedIndex]
  
  for name, config in pairs(currentProfile.Frames) do
    self:SaveFrame(name, config)
  end
  
  --engine.pr("frames saved.")
end

--[[ Saves the current frameName (global name) to a configFrame table                             ]]
function engine:SaveFrame(frameName, frameConfig)
  local frame = _G["xCT"..frameName]

  -- Fixing Error when you disable a frame (reported by Alatariell)
  if frame and frame.Show then
    local width   = frame:GetWidth()
    local height  = frame:GetHeight()
    frameConfig.Width   = width
    frameConfig.Height  = height
    frameConfig.Justify = "CENTER"
    
    -- Calculate the center of the screen
    local ResX, ResY = GetScreenWidth(), GetScreenHeight()
    local midX, midY = ResX / 2, ResY / 2
    
    -- Calculate the Top/Left of a frame relative to the center
    local left, top = math.floor(frame:GetLeft() - midX + 1), math.floor(frame:GetTop() - midY + 1)
    
    -- Calculate get the center of the screen from the left/top
    frameConfig.X = left + (width / 2)
    frameConfig.Y = top - (height / 2)
  end
end
--\\==============================================================================================//

--//== Loading the Frames ========================================================================\\
--[[ Loads all the frames from the current profile                                                ]]
function engine:LoadFrames()
  local selectedIndex = xCTPlus_SavedVars.Characters[engine.MyName]
  local currentProfile = xCTPlus_SavedVars.Profiles[selectedIndex]
  
  for name, config in pairs(currentProfile.Frames) do
    engine:LoadFrame(name, config)
  end
end

--[[ Loads the current frameConfig to the frameName (global name)                                 ]]
function engine:LoadFrame(frameName, frameConfig)
  local frame = _G["xCT"..frameName]
  -- Fixing Error when you disable a frame (reported by Alatariell)
  if frame and frame.Show then
    frame:ClearAllPoints()
    frame:SetHeight(frameConfig.Height)
    frame:SetWidth(frameConfig.Width)
    frame:SetPoint(frameConfig.Justify, frameConfig.X, frameConfig.Y)
  end
end
--\\==============================================================================================//

--//== Static Popup Dialogs ======================================================================\\
StaticPopupDialogs["XCT_NEWPROFILE"] = {
  text          = "|cffFFFF00Creating New Profile|r\n\nA frame profile will remember your frame positions and their enabled states, but it will not save your settings.\n\n|cff5555FFProfile Name:|r",
  hasEditBox    = 1,
  maxLetters    = 120,
  editBoxWidth  = 350,
  timeout       = 0,
  whileDead     = 1,
  OnShow = function(self)
    self.editBox:SetText(GetUnitName("player").."-"..GetRealmName());
    self.editBox:SetFocus();
    self.editBox:HighlightText();
  end,
  
  button1       = ACCEPT,
  button2       = CANCEL,
  OnAccept      = function(self)
      local newProfileName = self.editBox:GetText()
      engine:CreateNewProfile(newProfileName)
    end,
  OnCancel      = function() end,
  hideOnEscape  = true,
  
  -- Taint work around
  preferredIndex = 3,
}

StaticPopupDialogs["XCT_REMOVEPROFILE"] = {
  text          = "Are you certain you want to delete",
  timeout       = 0,
  whileDead     = 1,
  showAlert     = 1,
  OnShow = function(self)
    local currentIndex = UIDropDownMenu_GetSelectedID(xCTProfilesDropDownMenu)
    local currentProfileName = xCTPlus_SavedVars.Profiles[currentIndex].Name
    local message = string.gsub(CONFIRM_COMPACT_UNIT_FRAME_PROFILE_DELETION, "%%s", "|r\n|cffFF0000"..currentProfileName.."|r")
    self.text:SetText(message)
  end,
  
  button1       = DELETE,
  button2       = CANCEL,
  OnAccept      = function()
      local currentIndex = UIDropDownMenu_GetSelectedID(xCTProfilesDropDownMenu)
      engine:RemoveProfile(currentIndex)
      engine:LoadFrames()
    end,
  OnCancel      = function() end,
  hideOnEscape  = true,
  
  -- Taint work around
  preferredIndex = 3,
}

StaticPopupDialogs["XCT_ERRORPROFILE"] = {
  text          = "|cffFF0000Warning:  Unlocked Frames|r\n\n Cannot create, remove, or change profiles while frames are unlocked. To lock the frames type |cffFFFF00/xct lock|r.",
  timeout       = 0,
  whileDead     = 1,
  showAlert     = 1,
  
  button1       = CONTINUE,
  OnAccept      = function() end,
  hideOnEscape  = true,
  
  -- Taint work around
  preferredIndex = 3,
}
--\\==============================================================================================//

--//== Changed Locked State Events ===============================================================\\
-- Someone manually changed the state by typing in a command
function engine:OnChangedLockedState(state)
  if state then
    xCTEndConfigButton:Disable()
    xCTStartConfigButton:Enable()
  else
    xCTEndConfigButton:Enable()
    xCTStartConfigButton:Disable()
  end
end
--\\==============================================================================================//