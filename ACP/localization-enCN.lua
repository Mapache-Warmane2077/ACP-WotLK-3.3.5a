--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Localization: English strings for English patched Chinese clients   (enCN)

	enUS is the canonical source. Any key that is missing here falls back
	to the enUS string automatically, so an incomplete file is safe.

	Keep every %s / %d / %% placeholder, every |cffxxxxxx colour code and
	every line break exactly as they appear in the enUS file.
----------------------------------------------------------------------]]

if not ACP or not ACP.RegisterLocale then return end

ACP:RegisterLocale("enCN", {

	-- Main window and buttons  (keep these short, the buttons are 80px wide)
	["AddOns"] = "AddOns",
	["Load"] = "Load",
	["Disable All"] = "Disable All",
	["Enable All"] = "Enable All",
	["Reload UI"] = "Reload UI",
	["Sets"] = "Sets",
	["Close"] = "Close",
	["Recursive"] = "Recursive",

	-- Sorting criteria shown in the drop down menu
	["Default"] = "Default",
	["Titles"] = "Titles",
	["Ace2"] = "Ace2",
	["Author"] = "Author",
	["Separate LoD List"] = "Separate LoD List",
	["Group By Name"] = "Group By Name",

	-- Category headers built by ACP itself
	["Blizzard"] = "Blizzard",
	["Blizzard AddOns"] = "Blizzard AddOns",
	["Standard AddOns"] = "Standard AddOns",
	["Load on Demand AddOns"] = "Load on Demand AddOns",
	["Libraries"] = "Libraries",
	["Undefined"] = "Undefined",
	["Unknown"] = "Unknown",

	-- Sets menu
	["Save"] = "Save",
	["Rename"] = "Rename",
	["Add to current selection"] = "Add to current selection",
	["Remove from current selection"] = "Remove from current selection",
	["Set %d"] = "Set %d",

	-- Confirmation popups
	["Reload your user interface?"] = "Reload your user interface?",
	["Save the current AddOn list to [%s]?"] = "Save the current AddOn list to [%s]?",
	["Enter the new name for [%s]:"] = "Enter the new name for [%s]:",
	["ACP: Some protected AddOns are not enabled. Reload the UI now?"] = "ACP: Some protected AddOns are not enabled. Reload the UI now?",

	-- Chat messages
	["AddOn set [%s] saved."] = "AddOn set [%s] saved.",
	["AddOn set [%s] loaded."] = "AddOn set [%s] loaded.",
	["AddOn set [%s] unloaded."] = "AddOn set [%s] unloaded.",
	["AddOn set [%s] renamed to [%s]."] = "AddOn set [%s] renamed to [%s].",
	["%s is collapsed. Setting all of its AddOns to %s."] = "%s is collapsed. Setting all of its AddOns to %s.",
	["ENABLED"] = "ENABLED",
	["DISABLED"] = "DISABLED",
	["ON"] = "ON",
	["OFF"] = "OFF",
	["Load on demand child enabling is now %s."] = "Load on demand child enabling is now %s.",
	["Recursive enabling is now %s."] = "Recursive enabling is now %s.",
	["Debug mode is now %s."] = "Debug mode is now %s.",

	-- Slash commands  (/acp)
	["Valid commands:"] = "Valid commands:",
	["Opens the AddOn Control Panel."] = "Opens the AddOn Control Panel.",
	["Toggles enabling of load on demand child AddOns."] = "Toggles enabling of load on demand child AddOns.",
	["Toggles recursive enabling of dependencies."] = "Toggles recursive enabling of dependencies.",
	["Toggles debug output."] = "Toggles debug output.",
	["Shows this list."] = "Shows this list.",

	-- Tooltips
	["No information available."] = "No information available.",
	["Version"] = "Version",
	["Status"] = "Status",
	["Dependencies"] = "Dependencies",
	["Embedded Libraries"] = "Embedded Libraries",
	["Active Embedded Libraries"] = "Active Embedded Libraries",
	["Memory Usage"] = "Memory Usage",
	["Compatible"] = "Compatible",
	["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."] = "Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI.",
	["Use SHIFT to override the current dependency enabling behavior."] = "Use SHIFT to override the current dependency enabling behavior.",

	-- AddOn status column
	["Loadable on demand"] = "Loadable on demand",
	["Disabled after Reload UI"] = "Disabled after Reload UI",
	["Loaded"] = "Loaded",
	["Loaded on demand."] = "Loaded on demand.",

	-- Reserved: used by code paths that are currently commented out in ACP.lua
	["Reload"] = "Reload",
	["*** Enabling <%s> %s your UI ***"] = "*** Enabling <%s> %s your UI ***",
	["*** Unknown AddOn <%s> required ***"] = "*** Unknown AddOn <%s> required ***",
	["AddOn <%s> is not valid."] = "AddOn <%s> is not valid.",

	-- Manual language selector  (/acp locale, and the drop down in the window)
	["Language"] = "Language",
	["Automatic"] = "Automatic",
	["Detected locale: %s"] = "Detected locale: %s",
	["ACP locale: %s"] = "ACP locale: %s",
	["Locale override: %s"] = "Locale override: %s",
	["Locale %s is not registered."] = "Locale %s is not registered.",
	["ACP language set to %s."] = "ACP language set to %s.",
	["ACP language returned to automatic detection."] = "ACP language returned to automatic detection.",
	["Reload the UI to apply the language change."] = "Reload the UI to apply the language change.",
	["Reload now"] = "Reload now",
	["Later"] = "Later",
	["Valid locale commands:"] = "Valid locale commands:",
	["Shows the language ACP is using."] = "Shows the language ACP is using.",
	["Forces a language."] = "Forces a language.",
	["Returns to automatic detection."] = "Returns to automatic detection.",

	-- Diagnostics. Only shown while /acp debug is on, or raised as Lua errors.
	["Untranslated key: %s"] = "Untranslated key: %s",
	["No untranslated key has been requested so far."] = "No untranslated key has been requested so far.",
	["No translation is registered for locale %s, using %s."] = "No translation is registered for locale %s, using %s.",
	["Cannot find AddOn %s."] = "Cannot find AddOn %s.",
	["GetAddonIndex(): addon must be a number or a string."] = "GetAddonIndex(): addon must be a number or a string.",

	-- Blizzard AddOn titles. Never translate the folder name on the left,
	-- only the descriptive title on the right.
	["Blizzard_AchievementUI"] = "Blizzard: Achievements",
	["Blizzard_ArenaUI"] = "Blizzard: Arena",
	["Blizzard_AuctionUI"] = "Blizzard: Auction House",
	["Blizzard_BarbershopUI"] = "Blizzard: Barber Shop",
	["Blizzard_BattlefieldMinimap"] = "Blizzard: Battlefield Minimap",
	["Blizzard_BindingUI"] = "Blizzard: Key Bindings",
	["Blizzard_Calendar"] = "Blizzard: Calendar",
	["Blizzard_CombatLog"] = "Blizzard: Combat Log",
	["Blizzard_CombatText"] = "Blizzard: Floating Combat Text",
	["Blizzard_DebugTools"] = "Blizzard: Debug Tools",
	["Blizzard_GlyphUI"] = "Blizzard: Glyphs",
	["Blizzard_GMChatUI"] = "Blizzard: GM Chat",
	["Blizzard_GMSurveyUI"] = "Blizzard: GM Survey",
	["Blizzard_GuildBankUI"] = "Blizzard: Guild Bank",
	["Blizzard_InspectUI"] = "Blizzard: Inspect",
	["Blizzard_ItemSocketingUI"] = "Blizzard: Item Socketing",
	["Blizzard_MacroUI"] = "Blizzard: Macros",
	["Blizzard_RaidUI"] = "Blizzard: Raid",
	["Blizzard_TalentUI"] = "Blizzard: Talents",
	["Blizzard_TimeManager"] = "Blizzard: Time Manager",
	["Blizzard_TokenUI"] = "Blizzard: Currency",
	["Blizzard_TradeSkillUI"] = "Blizzard: Trade Skills",
	["Blizzard_TrainerUI"] = "Blizzard: Trainer",

})
