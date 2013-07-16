local function InstallThis()

ClassColorsDB = {
	["DEATHKNIGHT"] = {
		["hex"] = "ffc41e3a",
		["colorStr"] = "ffff284d",
		["b"] = 0.3019607843137255,
		["g"] = 0.1568627450980392,
		["r"] = 1,
	},
	["WARRIOR"] = {
		["hex"] = "ffc69b6d",
		["colorStr"] = "ffda9b54",
		["b"] = 0.3294117647058824,
		["g"] = 0.6078431372549019,
		["r"] = 0.8549019607843137,
	},
	["PALADIN"] = {
		["hex"] = "fff48cba",
		["colorStr"] = "ffff00da",
		["b"] = 0.8549019607843137,
		["g"] = 0,
		["r"] = 1,
	},
	["MAGE"] = {
		["hex"] = "ff68ccef",
		["colorStr"] = "ff00d0ff",
		["b"] = 1,
		["g"] = 0.8156862745098039,
		["r"] = 0,
	},
	["PRIEST"] = {
		["hex"] = "ffffffff",
		["colorStr"] = "ffffffff",
		["b"] = 1,
		["g"] = 1,
		["r"] = 1,
	},
	["WARLOCK"] = {
		["hex"] = "ff9382c9",
		["colorStr"] = "ff7426ff",
		["b"] = 1,
		["g"] = 0.1490196078431373,
		["r"] = 0.4549019607843137,
	},
	["SHAMAN"] = {
		["hex"] = "ff0070dd",
		["colorStr"] = "ff0069ff",
		["b"] = 1,
		["g"] = 0.4117647058823529,
		["r"] = 0,
	},
	["HUNTER"] = {
		["hex"] = "ffaad372",
		["colorStr"] = "ff8aff18",
		["b"] = 0.09411764705882353,
		["g"] = 1,
		["r"] = 0.5411764705882353,
	},
	["DRUID"] = {
		["hex"] = "ffff7c0a",
		["colorStr"] = "ffff5d0f",
		["b"] = 0.05882352941176471,
		["g"] = 0.3647058823529412,
		["r"] = 1,
	},
	["MONK"] = {
		["hex"] = "ff00ff96",
		["colorStr"] = "ff00ff96",
		["b"] = 0.5882352941176471,
		["g"] = 1,
		["r"] = 0,
	},
	["ROGUE"] = {
		["hex"] = "fffff468",
		["colorStr"] = "fffff100",
		["b"] = 0,
		["g"] = 0.9450980392156863,
		["r"] = 1,
	},
}

AuroraConfig = {
	["customColour"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 1,
	},
	["chatBubbles"] = false,
	["bags"] = false,
	["alpha"] = 0.5,
	["loot"] = false,
	["useCustomColour"] = false,
	["tooltips"] = false,
	["enableFont"] = false,
	["map"] = true,
}

BigWigs3DB = {
	["namespaces"] = {
		["BigWigs_Bosses_Madness of Deathwing"] = {
			["profiles"] = {
				["Default"] = {
					["impale"] = 515,
				},
			},
		},
		["BigWigs_Plugins_Sounds"] = {
			["profiles"] = {
				["Default"] = {
					["media"] = {
						["Victory"] = "None",
					},
				},
			},
		},
		["BigWigs_Bosses_Alizabal"] = {
		},
		["BigWigs_Bosses_Morchok"] = {
		},
		["BigWigs_Plugins_Tip of the Raid"] = {
			["profiles"] = {
				["Default"] = {
					["show"] = false,
				},
			},
		},
		["BigWigs_Bosses_Elegon"] = {
		},
		["BigWigs_Plugins_Colors"] = {
			["profiles"] = {
				["Default"] = {
					["flashshake"] = {
						["BigWigs_Plugins_Colors"] = {
							["default"] = {
								0.6274509803921569, -- [1]
								1, -- [2]
								0.2823529411764706, -- [3]
								1, -- [4]
							},
						},
					},
					["barEmphasized"] = {
						["BigWigs_Plugins_Colors"] = {
							["default"] = {
								[3] = 0.7568627450980392,
							},
						},
					},
					["barBackground"] = {
						["BigWigs_Plugins_Colors"] = {
							["default"] = {
								0, -- [1]
								0, -- [2]
								0, -- [3]
								0.5, -- [4]
							},
						},
					},
					["barColor"] = {
						["BigWigs_Plugins_Colors"] = {
							["default"] = {
								0.6274509803921569, -- [1]
								1, -- [2]
								0.2823529411764706, -- [3]
							},
						},
					},
				},
			},
		},
		["BigWigs_Plugins_Raid Icons"] = {
		},
		["BigWigs_Bosses_Yor'sahj the Unsleeping"] = {
		},
		["BigWigs_Plugins_Bars"] = {
			["profiles"] = {
				["Default"] = {
					["barStyle"] = "QuseUI",
					["emphasize"] = false,
					["BigWigsAnchor_width"] = 185.7429962158203,
					["BigWigsAnchor_y"] = 631.7916137580869,
					["emphasizeMove"] = false,
					["emphasizeScale"] = 1,
					["fill"] = false,
					["font"] = "Pixel Font",
					["BigWigsAnchor_x"] = 918.1545040053825,
					["BigWigsEmphasizeAnchor_width"] = 300.0000610351563,
					["growup"] = false,
					["emphasizeFlash"] = false,
					["icon"] = false,
					["texture"] = "Statusbar",
				},
			},
		},
		["BigWigs_Bosses_Warlord Zon'ozz"] = {
		},
		["BigWigs_Plugins_Super Emphasize"] = {
		},
		["BigWigs_Bosses_Ultraxion"] = {
		},
		["BigWigs_Bosses_Warmaster Blackhorn"] = {
		},
		["BigWigs_Plugins_Messages"] = {
			["profiles"] = {
				["Default"] = {
					["outline"] = "OUTLINE",
					["fontSize"] = 16,
					["BWMessageAnchor_x"] = 536.7149316034083,
					["font"] = "Pixel Font",
					["BWEmphasizeMessageAnchor_y"] = 531.7516301288597,
					["BWMessageAnchor_y"] = 673.346722901344,
					["monochrome"] = true,
					["BWEmphasizeMessageAnchor_x"] = 537.446237947177,
					["useicons"] = false,
				},
			},
		},
		["BigWigs_Bosses_Gara'jal the Spiritbinder"] = {
		},
		["BigWigs_Plugins_Proximity"] = {
			["profiles"] = {
				["Default"] = {
					["objects"] = {
						["ability"] = false,
						["background"] = false,
						["title"] = false,
						["sound"] = false,
					},
					["fontSize"] = 20,
					["lock"] = true,
					["posy"] = 263.9516856052887,
					["posx"] = 1066.565447052089,
					["sound"] = false,
					["font"] = "Friz Quadrata TT",
				},
			},
		},
		["BigWigs_Bosses_Atramedes"] = {
		},
		["BigWigs_Bosses_Hagara the Stormbinder"] = {
		},
		["BigWigs_Bosses_Spine of Deathwing"] = {
		},
	},
	["profileKeys"] = {
		["Quse - Illidan"] = "Default",
		["Pupe - Illidan"] = "Default",
		["Qupe - Illidan"] = "Default",
		["Quze - Illidan"] = "Default",
		["Pupex - Illidan"] = "Default",
		["Pupers - Lost Isles (US)"] = "Default",
		["Qused - Illidan"] = "Default",
		["Quzex - Illidan"] = "Default",
		["Pupedx - Illidan"] = "Default",
		["Quzex - Kilrogg"] = "Default",
		["Puped - Illidan"] = "Default",
		["Pupers - Illidan"] = "Default",
		["Frantasia - Kilrogg"] = "Default",
	},
	["profiles"] = {
		["Default"] = {
			["seenmovies"] = {
				[73] = true,
				[74] = true,
				[75] = true,
				[76] = true,
			},
		},
	},
}
BigWigs3IconDB = {
	["hide"] = true,
}

gxCooldownsDB = {
	["scale"] = 0.87,
	["gap"] = 2,
	["blacklist"] = {
	},
	["minDuration"] = 1.5,
	["style"] = {
		"Blizzard", -- [1]
		0.5, -- [2]
		true, -- [3]
	},
	["maxDuration"] = 300,
	["items"] = {
	},
	["growth"] = "Right",
	["xOffset"] = "192",
	["yOffset"] = "-215",
}

ItemTooltipCleanerSettings = {
	["customTooltips"] = {
		"AtlasLootTooltip", -- [1]
		"AtlasQuestTooltip", -- [2]
		"EQCompareTooltip", -- [3]
		"ComparisonTooltip", -- [4]
		"LinksTooltip", -- [5]
		"tekKompareTooltip", -- [6]
	},
	["hideRightClickBuy"] = true,
	["enchantColor"] = {
		0, -- [1]
		0.8, -- [2]
		1, -- [3]
	},
	["hideEquipmentSets"] = true,
	["compactBonuses"] = true,
	["hideRightClickSocket"] = true,
	["hideItemLevel"] = false,
	["hideMadeBy"] = false,
}

OmniCC4Config = {
	["groupSettings"] = {
		["gxCooldown"] = {
			["scaleText"] = false,
			["fontSize"] = 9,
			["fontOutline"] = "OUTLINEMONOCHROME",
			["fontFace"] = "Interface\\AddOns\\SharedMedia\\fonts\\font.ttf",
			["styles"] = {
				["soon"] = {
					["scale"] = 1,
				},
				["hours"] = {
					["scale"] = 1,
				},
			},
			["xOff"] = 2,
		},
		["base"] = {
			["scaleText"] = false,
			["styles"] = {
				["hours"] = {
					["scale"] = 1,
				},
				["soon"] = {
					["scale"] = 1,
				},
			},
			["fontOutline"] = "OUTLINEMONOCHROME",
			["fontSize"] = 8,
			["fontFace"] = "Interface\\AddOns\\SharedMedia\\fonts\\font.ttf",
			["xOff"] = 2,
		},
		["Actionbars"] = {
			["scaleText"] = false,
			["styles"] = {
				["soon"] = {
					["scale"] = 1,
				},
				["hours"] = {
					["scale"] = 1,
				},
			},
			["tenthsDuration"] = 1,
			["effect"] = "none",
			["fontFace"] = "Interface\\AddOns\\SharedMedia\\fonts\\font.ttf",
			["fontSize"] = 8,
			["fontOutline"] = "OUTLINEMONOCHROME",
			["xOff"] = 2,
		},
	},
	["version"] = "4.3.0",
	["groups"] = {
		{
			["id"] = "gxCooldown",
			["rules"] = {
				"gxCooldownsIcon", -- [1]
			},
			["enabled"] = true,
		}, -- [1]
		{
			["id"] = "Actionbars",
			["rules"] = {
				"ActionButton", -- [1]
				"MultiBar", -- [2]
				"rABS", -- [3]
			},
			["enabled"] = true,
		}, -- [2]
	},
}

XanAM_DB = {
	["AchievementAlertFrame1"] = {
		["yOfs"] = 0,
		["xOfs"] = 0,
		["point"] = "CENTER",
		["relativePoint"] = "CENTER",
	},
	["xanAchievementMover_Anchor"] = {
		["yOfs"] = 10.00008296966553,
		["xOfs"] = -3.799612045288086,
		["point"] = "TOP",
		["relativePoint"] = "TOP",
	},
	["xanAchievementMover_Ach1"] = {
		["yOfs"] = -43.99999237060547,
		["xOfs"] = 0,
		["point"] = "CENTER",
		["relativePoint"] = "BOTTOM",
	},
	["DungeonCompletionAlertFrame1"] = {
		["yOfs"] = 0,
		["xOfs"] = 0,
		["point"] = "CENTER",
		["relativePoint"] = "CENTER",
	},
}

xErrD_DB = {
	["there is nothing to attack."] = true,
	["you can't do that yet"] = true,
	["another action is in progress"] = true,
	["you can't do that while moving!"] = true,
	["can't attack while stunned."] = true,
	["you are in combat"] = true,
	["not enough runic power"] = true,
	["can't attack while pacified."] = true,
	["out of range."] = true,
	["you are too far away!"] = true,
	["spell is not ready yet."] = true,
	["can't attack while fleeing."] = true,
	["target needs to be in front of you."] = true,
	["you must be behind your target."] = true,
	["can't attack while confused."] = true,
	["you are facing the wrong way!"] = true,
	["you are too far away."] = true,
	["that ability requires combo points"] = true,
	["ability is not ready yet."] = true,
	["not enough health"] = true,
	["not enough focus"] = true,
	["dbver"] = 1.4,
	["can't attack while charmed."] = true,
	["can't attack while dead."] = true,
	["not enough chi"] = true,
	["target too close"] = true,
	["not enough runes"] = true,
	["invalid target"] = true,
	["you have no target."] = true,
	["your target is dead"] = true,
	["can't attack while horrified."] = true,
	["not enough mana"] = true,
	["you cannot attack that target."] = true,
	["not enough energy"] = true,
	["can't do that while horrified."] = true,
	["not enough rage"] = true,
	["you are too far away"] = true,
}
xErrD_CDB = {
	["not enough chi"] = true,
}

DBM_SavedOptions = {
	["SpecialWarningFontSize"] = 50,
	["ArrowPosX"] = 0,
	["HPFramePoint"] = "BOTTOMRIGHT",
	["UseMasterVolume"] = true,
	["StatusEnabled"] = true,
	["InfoFrameX"] = 75,
	["AprilFools"] = true,
	["RangeFrameX"] = 50,
	["WarningColors"] = {
		{
			["r"] = 0.4117647058823529,
			["g"] = 0.8,
			["b"] = 0.9411764705882353,
		}, -- [1]
		{
			["r"] = 0.9490196078431372,
			["g"] = 0.9490196078431372,
			["b"] = 0,
		}, -- [2]
		{
			["r"] = 1,
			["g"] = 0.5019607843137255,
			["b"] = 0,
		}, -- [3]
		{
			["r"] = 1,
			["g"] = 0.1019607843137255,
			["b"] = 0.1019607843137255,
		}, -- [4]
	},
	["AlwaysShowSpeedKillTimer"] = true,
	["RangeFrameY"] = -50,
	["EnableModels"] = true,
	["ArrowPoint"] = "TOP",
	["ModelSoundValue"] = "Short",
	["SpecialWarningSound2"] = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav",
	["InfoFramePoint"] = "CENTER",
	["RangeFrameRadarPoint"] = "CENTER",
	["SpecialWarningY"] = 75,
	["RangeFrameUpdates"] = "Average",
	["SpecialWarningPoint"] = "CENTER",
	["RaidWarningSound"] = "Sound\\Doodad\\BellTollNightElf.wav",
	["SpecialWarningX"] = 0,
	["WhisperStats"] = true,
	["RaidWarningPosition"] = {
		["Y"] = -146.9999237060547,
		["X"] = -0.950478196144104,
		["Point"] = "TOP",
	},
	["ShowKillMessage"] = true,
	["HealthFrameWidth"] = 200,
	["WarningIconLeft"] = false,
	["RangeFrameSound1"] = "none",
	["HPFrameY"] = -35.00006866455078,
	["ShowMinimapButton"] = false,
	["MoviesSeen"] = {
	},
	["SettingsMessageShown"] = true,
	["ShowWarningsInChat"] = true,
	["DontSetIcons"] = false,
	["BigBrotherAnnounceToRaid"] = false,
	["CountdownVoice"] = "Corsica",
	["InfoFrameY"] = -75,
	["SpecialWarningSound"] = "Sound\\Spells\\PVPFlagTaken.wav",
	["WarningIconRight"] = false,
	["HealthFrameGrowUp"] = false,
	["HideBossEmoteFrame"] = false,
	["RangeFrameRadarX"] = 100,
	["ShowBigBrotherOnCombatStart"] = false,
	["InfoFrameShowSelf"] = false,
	["SpecialWarningFont"] = "Fonts\\FRIZQT__.TTF",
	["SpamBlockRaidWarning"] = true,
	["ShowFakedRaidWarnings"] = false,
	["LatencyThreshold"] = 200,
	["ShowLoadMessage"] = true,
	["DontShowBossAnnounces"] = false,
	["RangeFramePoint"] = "CENTER",
	["SpecialWarningFontColor"] = {
		0, -- [1]
		0, -- [2]
		1, -- [3]
	},
	["DontSendBossWhispers"] = true,
	["BlockVersionUpdateNotice"] = false,
	["ShowPizzaMessage"] = true,
	["RangeFrameSound2"] = "none",
	["ShowLHFrame"] = true,
	["DontSendBossAnnounces"] = true,
	["HPFrameMaxEntries"] = 5,
	["Enabled"] = true,
	["ArrowPosY"] = -150,
	["HealthFrameLocked"] = false,
	["DisableCinematics"] = false,
	["MovieFilters"] = {
	},
	["RangeFrameRadarY"] = -100,
	["ShowWipeMessage"] = true,
	["RangeFrameLocked"] = false,
	["RangeFrameFrames"] = "radar",
	["ShowSpecialWarnings"] = true,
	["AlwaysShowHealthFrame"] = false,
	["HPFrameX"] = 30.37512397766113,
	["AutoRespond"] = true,
	["SpamBlockBossWhispers"] = false,
	["ShowRecoveryMessage"] = true,
	["ShowEngageMessage"] = true,
}
DBT_SavedOptions = {
	["DBM"] = {
		["EndColorG"] = 0,
		["HugeTimerY"] = -120,
		["HugeBarXOffset"] = 0,
		["Scale"] = 1,
		["IconLeft"] = false,
		["StartColorR"] = 0.7803921568627451,
		["HugeWidth"] = 200,
		["BarYOffset"] = 1,
		["TimerX"] = -310.4426574707031,
		["ExpandUpwards"] = false,
		["TimerPoint"] = "TOPRIGHT",
		["StartColorG"] = 1,
		["TimerY"] = -196.9996185302734,
		["HugeBarsEnabled"] = false,
		["EndColorR"] = 0.8901960784313725,
		["Width"] = 189,
		["HugeTimerPoint"] = "CENTER",
		["HugeTimerX"] = 0,
		["FontSize"] = 10,
		["HugeBarYOffset"] = 0,
		["StartColorB"] = 0.02352941176470588,
		["HugeScale"] = 1.049999952316284,
		["BarXOffset"] = 0,
		["EndColorB"] = 1,
	},
}

	--DisableAddOn("SnifflesInstaller");
	ReloadUI()
end

StaticPopupDialogs["SNIFFLESINSTALLER"] = {
	text = "Install QuseUI now?",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = InstallThis,
	timeout = 0,
	whileDead = 1,
}

SLASH_InstallThis1 = "/install"
SlashCmdList.InstallThis = function()
	StaticPopup_Show("SNIFFLESINSTALLER")
end