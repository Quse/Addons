-- Based on wIn1 by Weasoug with additions by Qupe, ALZA, Meeka and Suicidalkatt


local addonName, eventHandlers = ..., { }

--[[-----------------------------------------------------------------------------
Slash commands
-------------------------------------------------------------------------------]]
_G['SLASH_' .. addonName .. 'CommandLists1'] = strlower("/qt")
        SlashCmdList[addonName .. 'CommandLists'] = function()

	    print("|cffCC3333/lp|r - leave your Party/Raid.")
	    print("|cffCC3333/rl|r - Reloads your interface for you.")
	    print("|cffCC3333/rc|r - Perform Ready check, Will post message if not Leader or Assist.")
	    print("|cffCC3333/dr|r - Disbands the raid group if you are Raid Leader or Assist.")
		print("|cffCC3333/gm or /ticket|r - Opens the window for help or GM tickets.")
		print("|cffCC3333/vk or /votekick|r - Initiates LFR/Dungeon vote kick.")
		print("|cffCC3333/dgt or /tele|r - Teleports you in/out of dungeons.")
      end

SlashCmdList.TEST_EXTRABUTTON = function()
	if ExtraActionBarFrame:IsShown() then
		ExtraActionBarFrame:Hide()
	else
		ExtraActionBarFrame:Show()
		ExtraActionBarFrame:SetAlpha(1)
		ExtraActionButton1:Show()
		ExtraActionButton1:SetAlpha(1)
		ExtraActionButton1.icon:SetTexture("Interface\\Icons\\INV_Pet_DiseasedSquirrel")
		ExtraActionButton1.icon:Show()
		ExtraActionButton1.icon:SetAlpha(1)
	end
end
SLASH_TEST_EXTRABUTTON1 = "/teb"	  
	  
_G['SLASH_' .. addonName .. 'LeaveParty1'] = strlower("/lp")
        SlashCmdList[addonName .. 'LeaveParty'] = function() 

       local inInstance, _ = IsInInstance() 
       if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then 
                    LeaveParty() 
       elseif inInstance then 
                    LFGTeleport(true) 
       else print("|cffCC3333Error:|r Not in a group.") 
      end 
   end

_G['SLASH_' .. addonName .. 'ReloadUI1'] = strlower("/rl")
	SlashCmdList[addonName .. 'ReloadUI'] = ReloadUI

SlashCmdList["READYCHECKSLASHRC"] = function()
										DoReadyCheck();
									end;										
SLASH_READYCHECKSLASHRC1 = "/rc";

function DisbandRaid()
        if (UnitInRaid("player") ~= nil) and (GetNumGroupMembers() > 0) then
               if UnitIsGroupLeader("unit") or UnitIsGroupAssistant("unit") then 
               SendChatMessage("<QuseTweaks> Disbanding Raid!", RAID, nil, nil) 
               local pName = UnitName("player") 
        for i = 1, GetNumGroupMembers() do 
        local name = GetRaidRosterInfo(i) 
        if name ~= pName then UninviteUnit(name) 
     end 
          end
               LeaveParty() 
        else print("|cffCC3333Error:|r You aren't the Raid Leader or Raid Assistant.|r") 
      end 
	else
		print("|cffCC3333Error:|r Not in a Raid.") 
	end
   end
 _G['SLASH_' .. addonName .. 'DisbandRaid1'] = strlower("/dr")
	SlashCmdList[addonName .. 'DisbandRaid'] = DisbandRaid

 _G['SLASH_' .. addonName .. 'ConvertToParty1'] = strlower("/c2p")
	SlashCmdList[addonName .. 'ConvertToParty'] = function()
		local numRaid = GetNumRaidMembers()
		if numRaid == 0 then
			print("|cffCC3333Error:|r You are not in a raid.")
		elseif numRaid <= MEMBERS_PER_RAID_GROUP then
			ConvertToParty()
			print("|cffCC3333Message:|r Your raid is now a party.")
		else
			print("|cffCC3333Error:|r Unable to convert the raid into a party.")
		end
	end

 _G['SLASH_' .. addonName .. 'ConvertToRaid1'] = strlower("/c2r")
	SlashCmdList[addonName .. 'ConvertToRaid'] = function()
		if GetNumRaidMembers() > 0 then
			print("|cffCC3333Error:|r You are already in a raid.")
		elseif GetNumPartyMembers() > 0 then
			ConvertToRaid()
			print("|cffCC3333Message:|r Your party is now a raid.")
		else
			print("|cffCC3333Error:|r You are not in a party.")
		end
	end

function osDGT()
	local inInstance, _ = IsInInstance()
	if inInstance then
		LFGTeleport(true);
	else
		LFGTeleport();
	end
end
SlashCmdList["DGT"] = function() osDGT() end
SLASH_DGT1 = "/dgt"
SLASH_DGT2 = "/dungeontele"
SLASH_DGT3 = "/tele"

function osGK()
	UninviteUnit(UnitName("target"))
end
SlashCmdList["GK"] = function() osGK() end
SLASH_GK1 = "/vk";
SLASH_GK2 = "/votekick";
SLASH_GK3 = "/gk";
SLASH_GK4 = "/groupkick";

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/ticket"
SLASH_TICKET2 = "/gm"
SLASH_TICKET3 = "/ãì"

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

print("|cffCC3333Quse|rTweaks is loaded! Type |cffCC3333/qt|r for slash commands.")
