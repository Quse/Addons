-- Based on wIn1 by Weasoug with additions by Qupe, ALZA, Haleth and Meeka.

local questRewards = true
local acceptres	= false
local battlegroundres = true
local cancelduels = true
local hideerrors = false
local reputationwatch = false
local dingannounce = false
local doubleclickinvite	= false
local acceptfriendlyinvites = false
local autorepair = true
local autorepairguild = true
local selljunk = true
local easyaddfriend = false
local fatiguewarner	= false
local interruptedmsg = false
local leavepartymsg	= false
local visiAFK = false

local MoveScoreFrameAndCaptureBar = true
local ScoreFramePosition = {"TOP", TicketStatusFrame, "TOP", 0, 0}

local addonName, eventHandlers = ..., { }

-- UI Tweaks
local csf = CreateFrame("Frame")
csf:SetScript("OnEvent", function()
SetCVar("cameraDistanceMax", 50) 	    	 -- Camera's max zoom out Distance. 50 is max.
SetCVar("cameraDistanceMaxFactor", 3.4) 	 -- Sets the factor by which cameraDistanceMax is multiplied.
SetCVar("ShowClassColorInNameplate", 1) 	 -- Turns on class coloring in nameplates.
SetCVar( "bloattest", 0)
SetCVar( "bloatnameplates", 0)
SetCVar( "bloatthreat", 0) 					 -- Might make nameplates larger but it fixes the disappearing ones.
SetCVar( "consolidateBuffs", 0) 			 -- Turns off Consolidated Buffs.
SetCVar("ffxDeath", 0)						 -- Turns off full screen death effect.
SetCVar("screenshotQuality", 10) 			 -- Screenshot quality (0-10)
--SetCVar("displaySpellActivationOverlays", 0) -- Turns off default Blizzard Spell Alerts
SetCVar("useUiScale", 0)					 -- Turns off UI scaling
SetCVar("checkAddonVersion", 0) 			 -- Load out-of-date addons
SetCVar("autoLootDefault", 1)				 -- Enable autolooting
end)
csf:RegisterEvent("PLAYER_LOGIN")

function AchievementAlertFrame_FixAnchors()
    if(not AchievementAlertFrame1) then
        return;
    end
    
    AchievementAlertFrame1:ClearAllPoints();
    AchievementAlertFrame1:SetPoint("CENTER");
end

-- ItemGlow by Haleth, based on oGlow by Haste

local function UpdateGlow(button, id)
	local quality, texture, _
	local quest = _G[button:GetName().."IconQuestTexture"]
	if(id) then
		quality, _, _, _, _, _, _, texture = select(3, GetItemInfo(id))
	end

	local glow = button.glow
	if(not glow) then
		button.glow = glow
		glow = button:CreateTexture(nil, "BACKGROUND")
		glow:SetPoint("TOPLEFT", -1, 1)
		glow:SetPoint("BOTTOMRIGHT", 1, -1)
		glow:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		button.glow = glow
	end

	if texture then
		local r, g, b
		if quest and quest:IsShown() then
			r, g, b = 1, 0, 0
		else
			r, g, b = GetItemQualityColor(quality)
			if (r == 1 and g == 1) then r, g, b = 0, 0, 0 end
		end
		glow:SetVertexColor(r, g, b)
		glow:Show()
	else
		glow:Hide()
	end
end

-- Bags and Bank

hooksecurefunc("ContainerFrame_Update", function(self)
	local name = self:GetName()
	local id = self:GetID()

	for i=1, self.size do
		local button = _G[name.."Item"..i]
		local itemID = GetContainerItemID(id, button:GetID())
		UpdateGlow(button, itemID)
	end
end)

hooksecurefunc("BankFrameItemButton_Update", function(self)
	UpdateGlow(self, GetInventoryItemID("player", self:GetInventorySlot()))
end)

-- Item slots for Character/Inspect Frame

local slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", "Tabard",
}

-- Character Frame

local updatechar = function(self)
	if CharacterFrame:IsShown() then
		for key, slotName in ipairs(slots) do
			-- Ammo is located at 0.
			local slotID = key % 20
			local slotFrame = _G['Character' .. slotName .. 'Slot']
			local slotLink = GetInventoryItemLink('player', slotID)

			UpdateGlow(slotFrame, slotLink)
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:SetScript("OnEvent", updatechar)
CharacterFrame:HookScript('OnShow', updatechar)

-- Inspect Frame

local updateinspect = function(self)
	local unit = InspectFrame.unit
	if InspectFrame:IsShown() and unit then
		for key, slotName in ipairs(slots) do
			local slotID = key % 20
			local slotFrame = _G["Inspect"..slotName.."Slot"]
			local slotLink = GetInventoryItemLink(unit, slotID)
			if slotLink then
				slotFrame:Show()
			else
				slotFrame:Hide()
			end
			UpdateGlow(slotFrame, slotLink)
		end
	end

end

local last = 0
local OnUpdate = function(self, elapsed)
	last = last + elapsed
	if last >= 1 then
		self:SetScript("OnUpdate", nil)
		last = 0
		updateinspect()
	end
end

local startinspect = function()
	updateinspect()
	InspectFrame:SetScript("OnUpdate", OnUpdate)
end

local g = CreateFrame("Frame")
g:RegisterEvent("ADDON_LOADED")
g:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "Blizzard_InspectUI" then return end

	InspectFrame:HookScript("OnShow", function()
		g:RegisterEvent("PLAYER_TARGET_CHANGED")
		g:RegisterEvent("INSPECT_READY")
		g:SetScript("OnEvent", startinspect)
	end)
	InspectFrame:HookScript("OnHide", function()
		g:UnregisterEvent("PLAYER_TARGET_CHANGED")
		g:UnregisterEvent("INSPECT_READY")
			g:SetScript("OnEvent", nil)
		InspectFrame:SetScript("OnUpdate", nil)
	end)

	g:UnregisterEvent("ADDON_LOADED")
end)

-- Guild Bank Frame

local h = CreateFrame("Frame")
h:RegisterEvent("GUILDBANKBAGSLOTS_CHANGED")
h:RegisterEvent("GUILDBANKFRAME_OPENED")
h:SetScript("OnEvent", function()
	if not IsAddOnLoaded("Blizzard_GuildBankUI") then return end

	local tab = GetCurrentGuildBankTab()
	for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
		local index = math.fmod(i, 14)
		if index == 0 then
			index = 14
		end
		local column = math.ceil((i-0.5)/14)

		local slotLink = GetGuildBankItemLink(tab, i)
		local slotFrame = _G["GuildBankColumn"..column.."Button"..index]

		UpdateGlow(slotFrame, slotLink)
	end
end)

-- Void Storage Frame

local void = CreateFrame("Frame")
void:RegisterEvent("ADDON_LOADED")
void:RegisterEvent("VOID_STORAGE_CONTENTS_UPDATE")
void:RegisterEvent("VOID_STORAGE_DEPOSIT_UPDATE")
void:RegisterEvent("VOID_TRANSFER_DONE")
void:RegisterEvent("VOID_STORAGE_OPEN")

local updateContents = function(self)
	if not IsAddOnLoaded("Blizzard_VoidStorageUI") then return end

	for slot = 1, VOID_WITHDRAW_MAX or 80 do
		local slotFrame =  _G["VoidStorageStorageButton"..slot]
		UpdateGlow(slotFrame, GetVoidItemInfo(slot))
	end

	for slot = 1, VOID_WITHDRAW_MAX or 9 do
		local slotFrame = _G["VoidStorageWithdrawButton"..slot]
		UpdateGlow(slotFrame, GetVoidTransferWithdrawalInfo(slot))
	end
end

local updateDeposit = function(self, event, slot)
	if not IsAddOnLoaded("Blizzard_VoidStorageUI") then return end

	local slotFrame = _G["VoidStorageDepositButton"..slot]
	UpdateGlow(slotFrame, GetVoidTransferDepositInfo(slot))
end

local update = function(self)
	if not IsAddOnLoaded("Blizzard_VoidStorageUI") then return end

	for slot = 1, VOID_DEPOSIT_MAX or 9 do
		updateDeposit(self, nil, slot)
	end

	return updateContents(self)
end

void:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		if ... == "Blizzard_VoidStorageUI" then
			self:UnregisterEvent("ADDON_LOADED")
			local last = 0
			self:SetScript("OnUpdate", function(self, elapsed)
				last = last + elapsed
				if last > 1 then
					self:SetScript("OnUpdate", nil)
					update(self)
				end
			end)
		end
	elseif event == "VOID_STORAGE_CONTENTS_UPDATE" then
		updateContents(self)
	elseif event == "VOID_STORAGE_DEPOSIT_UPDATE" then
		updateDeposit(self, event, ...)
	elseif event == "VOID_TRANSFER_DONE" or event == "VOID_STORAGE_OPEN" then
		update(self)
	end
end)

local addonName, eventHandlers = ..., { }

-----------------------------------
-- AFK Modification (by Recluse) --
-----------------------------------
if visiAFK then
	local af = CreateFrame("Frame")
	af:SetScript("OnEvent", function(self, event, ...)
		local message = select(1, ...)

		if string.find(message, CLEARED_AFK) or string.find(message, "Welcome to the World of Warcraft") then
			SetCVar("UnitNameOwn", 0)
		elseif string.find(message, string.gsub(MARKED_AFK_MESSAGE, "%%s", ".*")) or string.find(message, MARKED_AFK) then
			SetCVar("UnitNameOwn", 1)
		end
	end)
	af:RegisterEvent("CHAT_MSG_SYSTEM")
end
--[[-----------------------------------------------------------------------------
Accept Res
-------------------------------------------------------------------------------]]
if acceptres then
	eventHandlers['RESURRECT_REQUEST'] = function(name)
		if not (UnitAffectingCombat('player') or UnitAffectingCombat(name)) then
			local delay = GetCorpseRecoveryDelay()
			if delay == 0 then
				AcceptResurrect()
				--DoEmote('thank', name)
			else
                                local b = CreateFrame("Button")
				local formattedText = b:GetText(b:SetFormattedText("%d |4second:seconds", delay))
				SendChatMessage("Thanks for the rez! I still have "..formattedText.." until I can accept it.", 'WHISPER', nil, name)
			end
		end
	end
end

--[[-----------------------------------------------------------------------------
Battleground Res
-------------------------------------------------------------------------------]]
if battlegroundres then
	--eventHandlers['PLAYER_DEAD'] = function()
			--if (MiniMapBattlefieldFrame.status=='active') or (GetRealZoneText()=='Wintergrasp') or (GetRealZoneText()=='TolBarad') then
			--RepopMe()
		--end
	--end
end

--[[-----------------------------------------------------------------------------
Cancel Duels
-------------------------------------------------------------------------------]]
if cancelduels then
	eventHandlers['DUEL_REQUESTED'] = function(name)
		if not IsControlKeyDown() then
			CancelDuel()
			--DoEmote('no', 1)
			print("Duel from " .. name .. " declined, hold CTRL to allow the next request.")
		end
	end
end

--[[-----------------------------------------------------------------------------
Hide Errors
-------------------------------------------------------------------------------]]
if hideerrors then
	local allowedErrors = { }

	eventHandlers['UI_ERROR_MESSAGE'] = function(message)
		if allowedErrors[message] then
			UIErrorsFrame:AddMessage(message, 1, .1, .1)
		end
	end

	UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
end

--[[-----------------------------------------------------------------------------
Reputation Watch
-------------------------------------------------------------------------------]]
if reputationwatch then
function RepC_Event(self, event, txt)
	local a
	local _,_, faction = string.find(txt, "Reputation with (.+) increased by (.+).")
	if IsInGuild() then
		a = GetGuildInfo("player")
	end
	if faction == "Guild" or faction == "guild" or faction == a then 
		return 
	end
	for i = 1, GetNumFactions() do
		if faction == GetFactionInfo(i) then
			SetWatchedFactionIndex(i)
			return
		end
	end
end


local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
f:SetScript("OnEvent", RepC_Event)
end

--[[-----------------------------------------------------------------------------
Ding Announce
-------------------------------------------------------------------------------]]
if dingannounce then
	eventHandlers['PLAYER_LEVEL_UP'] = function()
		local message = "DING!"
		if GetNumGroupMembers() > 0 then
			SendChatMessage(message, 'RAID')
		elseif GetNumSubgroupMembers() > 0 then
			SendChatMessage(message, 'PARTY')
		end
		if IsInGuild() then
			SendChatMessage(message, 'GUILD')
		end
	end
end	

--[[-----------------------------------------------------------------------------
Double Click Invite
-------------------------------------------------------------------------------]]
if doubleclickinvite then
	local function OnDoubleClick(self, button)
		if button == 'LeftButton' then
			if self.buttonType == FRIENDS_BUTTON_TYPE_WOW then
				local name, _, _, _, connected = GetFriendInfo(self.id)
				if connected then
					InviteUnit(name)
				end
			elseif self.buttonType == FRIENDS_BUTTON_TYPE_BNET then
				local _, _, _, toonName, _, client, isOnline = BNGetFriendInfo(self.id)
				if client == 'WoW' and isOnline then
					local _, _, _, realm = BNGetFriendToonInfo(self.id, 1)
					if realm == GetRealmName() then
						InviteUnit(toonName)
					end
				end
			end
		end
	end

	local buttons = FriendsFrameFriendsScrollFrame.buttons
	for index = 1, #buttons do
		buttons[index]:SetScript('OnDoubleClick', OnDoubleClick)
    end
end

--[[-----------------------------------------------------------------------------
Accept Friendly Invites
-------------------------------------------------------------------------------]]
if acceptfriendlyinvites then
	eventHandlers['PARTY_INVITE_REQUEST'] = function(name)
		local accept
		ShowFriends()
		for index = 1, GetNumFriends() do
			if GetFriendInfo(index) == name then
				accept = true
				break
			end
		end
		if not accept and IsInGuild() then
			GuildRoster()
			for index = 1, GetNumGuildMembers() do
				if GetGuildRosterInfo(index) == name then
					accept = true
					break
				end
			end
		end
		if not accept then
			for index = 1, BNGetNumFriends() do
				local _, _, _, toonName = BNGetFriendInfo(index)
				if toonName == name then
					accept = true
					break
				end
			end
		end
		if accept then
			name = StaticPopup_Visible('PARTY_INVITE')
			if name then
				StaticPopup_OnClick(_G[name], 1)
				return
			end
		else
			SendWho('n-"' .. name .. '"')
		end
	end
end

--[[-----------------------------------------------------------------------------
Autorepair or Autorepairguild / SellJunk
-------------------------------------------------------------------------------]]
if autorepair or autorepairguild or selljunk then
	local handler = ""

	if selljunk then
		handler = handler .. [[
			local total = 0
			for bag = 0, NUM_BAG_FRAMES do
				for slot = 1, GetContainerNumSlots(bag) do
					local link = GetContainerItemLink(bag, slot)
					if link then
						local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(link)
						local _, itemCount = GetContainerItemInfo(bag, slot)
						if itemRarity == 0 and itemSellPrice ~= 0 then
							total = total + (itemSellPrice * itemCount)
							UseContainerItem(bag, slot)
						end
					end
				end
			end
			if total > 0 then
				print("Sold all grey items for " .. MoneyToString(total))
			end
		]]
	end

	if autorepairguild then
		handler = handler .. [[
			if CanGuildBankRepair() then
				local cost, canRepair = GetRepairAllCost()
				if canRepair and cost > 0 then
					RepairAllItems(1)
					local newCost = GetRepairAllCost()
					if newCost < cost then
						print("Repairs made using guild funds: " .. MoneyToString(cost - newCost))
					end
				end
			end
		]]
	end

	-- Sell first so there is more money for repairs
	if autorepair then
		handler = handler .. [[
			local cost, canRepair = GetRepairAllCost()
			if canRepair and cost > 0 and cost <= GetMoney() * 0.2 then
				RepairAllItems()
				print("Repairs made: " .. MoneyToString(cost))
			end
		]]
	end

	eventHandlers['MERCHANT_SHOW'] = loadstring(([=[
		local cuInd = [[|TInterface\MoneyFrame\UI-CopperIcon:0:1:2:0|t]]
		local agInd = [[|TInterface\MoneyFrame\UI-SilverIcon:0:1:2:0|t ]]
		local auInd = [[|TInterface\MoneyFrame\UI-GoldIcon:0:1:2:0|t ]]

		local function MoneyToString(ammount)
			local cu = ammount %% 100
			ammount = floor(ammount / 100)
			local ag, au = ammount %% 100, floor(ammount / 100)
			if au > 0 then
				return au .. auInd .. ag .. agInd .. cu .. cuInd
			elseif ag > 0 then
				return ag .. agInd .. cu .. cuInd
			end
			return cu .. cuInd
		end

		local function Handler(...)
			%s
		end

		return Handler
	]=]):format(handler))()
end

--[[-----------------------------------------------------------------------------
Easy Add Friend
-------------------------------------------------------------------------------]]
if easyaddfriend then
local EasyAddFriend = CreateFrame("Frame","EasyAddFriendFrame")
EasyAddFriend:SetScript("OnEvent", function() hooksecurefunc("UnitPopup_ShowMenu", EasyAddFriendCheck) EasyAddFriendSlash() end)
EasyAddFriend:RegisterEvent("PLAYER_LOGIN")

local PopupUnits = {"PARTY", "PLAYER", "RAID_PLAYER", "RAID", "FRIEND", "TEAM", "CHAT_ROSTER", "TARGET", "FOCUS"}

local AddFriendButtonInfo = {
	text = "Add Friend",
	value = "ADD_FRIEND",
	func = function() AddFriend(UIDROPDOWNMENU_OPEN_MENU.name) end,
	notCheckable = 1,
}

local CancelButtonInfo = {
	text = "Cancel",
	value = "CANCEL",
	notCheckable = 1
}

function EasyAddFriendSlash()
	SLASH_EASYADDFRIEND1 = "/add";
	SlashCmdList["EASYADDFRIEND"] = function(msg) if #msg == 0 then DEFAULT_CHAT_FRAME:AddMessage("EasyAddFriend: Use '/add' followed by a character's name to add them to your friends list.") else AddFriend(msg) end end
end
function EasyAddFriendCheck()		
	local PossibleButton = getglobal("DropDownList1Button"..(DropDownList1.numButtons)-1)
	if PossibleButton["value"] ~= "ADD_FRIEND" then
		local GoodUnit = false
		for i=1, #PopupUnits do	
		if OPEN_DROPDOWNMENUS[1]["which"] == PopupUnits[i] then	
			GoodUnit = true
			end
		end
		if UIDROPDOWNMENU_OPEN_MENU["unit"] == "target" and ((not UnitIsPlayer("target")) or (not UnitIsFriend("player", "target"))) then
			GoodUnit = false
		end
		if GoodUnit then				
			local IsAlreadyFriend = false
			for z=1, GetNumFriends() do
				if GetFriendInfo(z) == UIDROPDOWNMENU_OPEN_MENU["name"] or UIDROPDOWNMENU_OPEN_MENU["name"] == UnitName("player") then
					IsAlreadyFriend = true
				end
			end
			if not IsAlreadyFriend then				
				CreateAddFriendButton()
			
			end
		end
	end		
end

function CreateAddFriendButton()

		local CancelButtonFrame = getglobal("DropDownList1Button"..DropDownList1.numButtons)
		CancelButtonFrame:Hide()
		DropDownList1.numButtons = DropDownList1.numButtons - 1
		UIDropDownMenu_AddButton(AddFriendButtonInfo)
		UIDropDownMenu_AddButton(CancelButtonInfo)
	
   end
end

--[[-----------------------------------------------------------------------------
Fatigue Warner
-------------------------------------------------------------------------------]]
if fatiguewarner then
function FatigueWarner_OnUpdate(self) 
	local timer, value, maxvalue, scale, paused, label = GetMirrorTimerInfo(1) 
	if timer == "EXHAUSTION" then 
-- You can change the sounds by deleting the -- in Front of those PlaySoundFile, so that only one will not have the -- in front of it.
              --PlaySoundFile("Sound\\Creature\\ShadeOfAran\\AranAggro01.wav" , "Master")					
              --PlaySoundFile("Sound\\Creature\\ElderIronbranch\\UR_Ironbranch_Aggro01.wav", "Master")	
                PlaySoundFile("Sound\\Creature\\XT002Deconstructor\\UR_XT002_Special01.wav", "Master")
              --PlaySoundFile("Sound\\Creature\\Hodir\\UR_Hodir_Aggro01.wav", "Master")
	end 
	self:SetScript("OnUpdate", nil) 
end 
 
function FatigueWarner_OnEvent(self) 
	self:SetScript("OnUpdate", FatigueWarner_OnUpdate) 
end 
	  
-- Sinnlos; strip bringt ja irgendwie nichts fiel mir dann auf :>
function FatigueWarner_Strip()
	local FatigueWarner_StripTable = {16, 17, 18, 5, 7, 1, 3, 10, 8, 6, 9}
	local start = 1
	local finish = table.getn(FatigueWarner_StripTable)

	for bag = 0, 4 do
		for slot=1, GetContainerNumSlots(bag) do
			if not GetContainerItemLink(bag, slot) then
				for i = start, finish do
					if GetInventoryItemLink("player", FatigueWarner_StripTable[i]) then
						PickupInventoryItem(FatigueWarner_StripTable[i])
						PickupContainerItem(bag, slot)
						start = i + 1
						break
					end
				end
			end
		end
	end
end

local FatigueWarnerFrame = CreateFrame("frame")
FatigueWarnerFrame:RegisterEvent("MIRROR_TIMER_START")
FatigueWarnerFrame:RegisterEvent("MIRROR_TIMER_STOP")
FatigueWarnerFrame:SetScript("OnEvent", FatigueWarner_OnEvent)
end

--[[-----------------------------------------------------------------------------
Interrupted msg
-------------------------------------------------------------------------------]]
if interruptedmsg then
eventHandlers['COMBAT_LOG_EVENT_UNFILTERED'] = function(...)
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16 = ...

	if arg2 ~= "SPELL_INTERRUPT" or arg5 ~= UnitName("player") then
		return
	end

        local channel = GetNumGroupMembers() > 0 and "RAID" or GetNumSubgroupMembers() > 0 and "PARTY"

	if channel then
		SendChatMessage(GetSpellLink(arg12).." Interrupted "..GetSpellLink(arg15), channel)
	end
    end
end

--[[-----------------------------------------------------------------------------
ConfirmLeaveParty
-------------------------------------------------------------------------------]]
if leavepartymsg then
local CONFIRM_LEAVE_PARTY = "Do you really want to leave the group?"

if GetLocale() == "deDE" then
	CONFIRM_LEAVE_PARTY = "Willst du wirklich die Gruppe verlassen?" -- Shantalya @ WoWI
elseif GetLocale() == "esES" or GetLocale() == "esMX" then
	CONFIRM_LEAVE_PARTY = "¿Realmente quiere dejar el grupo?" -- Google Translate
elseif GetLocale() == "frFR" then
	CONFIRM_LEAVE_PARTY = "Veux-tu vraiment à quitter le groupe?" -- Google Translate
elseif GetLocale() == "ptBR" then
	CONFIRM_LEAVE_PARTY = "Tem certeza de que deseja sair o grupo?" -- Google Translate
elseif GetLocale() == "ruRU" then
	CONFIRM_LEAVE_PARTY = "Вы действительно хотите выйти из группы?" -- Google Translate
elseif GetLocale() == "koKR" then
	CONFIRM_LEAVE_PARTY = "당신이 정말로 그룹을 떠나시겠습니까?" -- Google Translate
elseif GetLocale() == "zhCN" then
	CONFIRM_LEAVE_PARTY = "难道你真的想离开组吗?" -- Google Translate
elseif GetLocale() == "zhTW" then
	CONFIRM_LEAVE_PARTY = "難道你真的想離開組嗎?" -- Google Translate
end

------------------------------------------------------------------------

local ReallyLeaveParty = _G.LeaveParty

StaticPopupDialogs["CONFIRM_LEAVE_PARTY"] = {
	text = CONFIRM_LEAVE_PARTY,
	button1 = YES,
	button2 = NO,
	enterClicksFirstButton = 0, -- YES on enter
	hideOnEscape = 0, -- NO on escape
	timeout = 0,
	OnAccept = ReallyLeaveParty,
}

_G.LeaveParty = function()
	local _, instanceType = IsInInstance()
	if instanceType == "party" or instanceType == "raid" then
		if GetNumGroupMembers() > 0 then
			return StaticPopup_Show("CONFIRM_LEAVE_PARTY")
		end
	end
	ReallyLeaveParty()
end
end
----------------------------------------------------------------------------------------
-- Quest level(yQuestLevel by yleaf)
----------------------------------------------------------------------------------------
local function update()
	local buttons = QuestLogScrollFrame.buttons
	local numButtons = #buttons
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries, numQuests = GetNumQuestLogEntries()
	
	for i = 1, numButtons do
		local questIndex = i + scrollOffset
		local questLogTitle = buttons[i]
		if questIndex <= numEntries then
			local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText("[" .. level .. "] " .. title)
				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end

hooksecurefunc("QuestLog_Update", update)
QuestLogScrollFrameScrollBar:HookScript("OnValueChanged", update)

----------------------------------------------------------------------------------------
--Moving TicketStatusFrame, Battlefield score frame, CaptureBar
----------------------------------------------------------------------------------------

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOP",UIParent,"TOP")
TicketStatusFrame.SetPoint = function() end

if MoveScoreFrameAndCaptureBar then
if (WorldStateAlwaysUpFrame) then
	WorldStateAlwaysUpFrame:ClearAllPoints()
	WorldStateAlwaysUpFrame:SetPoint(unpack(ScoreFramePosition))
	WorldStateAlwaysUpFrame:SetScale(1.1)
	WorldStateAlwaysUpFrame.SetPoint = function() end
end 

--local f = CreateFrame("Frame")
-- local function OnEvent()
    -- if(NUM_EXTENDED_UI_FRAMES>0) then
            -- for i = 1, NUM_EXTENDED_UI_FRAMES do
                -- _G["WorldStateCaptureBar" .. i]:ClearAllPoints()
                -- _G["WorldStateCaptureBar" .. i]:SetPoint("CENTER", UIParent, "TOP", 0, -100)
            -- end
    -- end
-- end

local f = CreateFrame"Frame"
f:RegisterEvent"PLAYER_LOGIN"
f:RegisterEvent"UPDATE_WORLD_STATES"
f:RegisterEvent"UPDATE_BATTLEFIELD_STATUS"
f:SetScript("OnEvent", OnEvent)
end

---------------------------------------------------------------------------------
-- New Achievement and loot crap mover - NYI
---------------------------------------------------------------------------------


-- achievements test
SlashCmdList.TEST_ACHIEVEMENT = function()
	PlaySound("LFG_Rewards")
	AchievementFrame_LoadUI()
	AchievementAlertFrame_ShowAlert(5780)
	AchievementAlertFrame_ShowAlert(5000)
	GuildChallengeAlertFrame_ShowAlert(3, 2, 5)
	ChallengeModeAlertFrame_ShowAlert()
	CriteriaAlertFrame_GetAlertFrame()
	MoneyWonAlertFrame_ShowAlert(9999999)
	LootWonAlertFrame_ShowAlert(GetItemInfo(6948), -1, 1, 100)

	AlertFrame_AnimateIn(CriteriaAlertFrame1)
	AlertFrame_AnimateIn(DungeonCompletionAlertFrame1)
	AlertFrame_AnimateIn(ScenarioAlertFrame1)

	AlertFrame_FixAnchors()

	--CriteriaAlertFrame_ShowAlert(achievementID, criteriaID)
end
SLASH_TEST_ACHIEVEMENT1 = "/tach"
		
--[[-----------------------------------------------------------------------------
Initialize
-------------------------------------------------------------------------------]]
if next(eventHandlers) then
	local frame = CreateFrame('Frame')
	frame:Hide()

	for event, handler in pairs(eventHandlers) do
		frame[event] = handler
		frame:RegisterEvent(event)
		eventHandlers[event] = nil
	end

	frame:SetScript('OnEvent', function(self, event, ...)
		self[event](...)
	end)
end

