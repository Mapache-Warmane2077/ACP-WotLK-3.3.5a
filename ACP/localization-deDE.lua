--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Localization: Deutsch   (deDE)

	enUS is the canonical source. Any key that is missing here falls back
	to the enUS string automatically, so an incomplete file is safe.

	Keep every %s / %d / %% placeholder, every |cffxxxxxx colour code and
	every line break exactly as they appear in the enUS file.
----------------------------------------------------------------------]]

if not ACP or not ACP.RegisterLocale then return end

ACP:RegisterLocale("deDE", {

	-- Main window and buttons  (keep these short, the buttons are 80px wide)
	["AddOns"] = "AddOns",
	["Load"] = "Laden",
	["Disable All"] = "Alle aus",
	["Enable All"] = "Alle an",
	["Reload UI"] = "UI neu laden",
	["Sets"] = "Sets",
	["Close"] = "Schließen",
	["Recursive"] = "Rekursiv",

	-- Sorting criteria shown in the drop down menu
	["Default"] = "Standard",
	["Titles"] = "Titel",
	["Ace2"] = "Ace2",
	["Author"] = "Autor",
	["Separate LoD List"] = "Getrennte LoD-Liste",
	["Group By Name"] = "Nach Namen gruppieren",

	-- Category headers built by ACP itself
	["Blizzard"] = "Blizzard",
	["Blizzard AddOns"] = "Blizzard-AddOns",
	["Standard AddOns"] = "Standard-AddOns",
	["Load on Demand AddOns"] = "AddOns, die bei Bedarf geladen werden",
	["Libraries"] = "Bibliotheken",
	["Undefined"] = "Nicht angegeben",
	["Unknown"] = "Unbekannt",

	-- Sets menu
	["Save"] = "Speichern",
	["Rename"] = "Umbenennen",
	["Add to current selection"] = "Zur aktuellen Auswahl hinzufügen",
	["Remove from current selection"] = "Aus der aktuellen Auswahl entfernen",
	["Set %d"] = "Set %d",

	-- Confirmation popups
	["Reload your user interface?"] = "Benutzeroberfläche neu laden?",
	["Save the current AddOn list to [%s]?"] = "Die aktuelle AddOn-Liste als [%s] speichern?",
	["Enter the new name for [%s]:"] = "Gib den neuen Namen für [%s] ein:",
	["ACP: Some protected AddOns are not enabled. Reload the UI now?"] = "ACP: Einige geschützte AddOns sind nicht aktiviert. Benutzeroberfläche jetzt neu laden?",

	-- Chat messages
	["AddOn set [%s] saved."] = "AddOn-Set [%s] gespeichert.",
	["AddOn set [%s] loaded."] = "AddOn-Set [%s] geladen.",
	["AddOn set [%s] unloaded."] = "AddOn-Set [%s] entladen.",
	["AddOn set [%s] renamed to [%s]."] = "AddOn-Set [%s] in [%s] umbenannt.",
	["%s is collapsed. Setting all of its AddOns to %s."] = "%s ist eingeklappt. Alle enthaltenen AddOns werden auf %s gesetzt.",
	["ENABLED"] = "AKTIVIERT",
	["DISABLED"] = "DEAKTIVIERT",
	["ON"] = "AN",
	["OFF"] = "AUS",
	["Load on demand child enabling is now %s."] = "Aktivieren von LoD-Unter-AddOns: %s",
	["Recursive enabling is now %s."] = "Rekursives Aktivieren: %s",
	["Debug mode is now %s."] = "Debug-Modus: %s",

	-- Slash commands  (/acp)
	["Valid commands:"] = "Gültige Befehle:",
	["Opens the AddOn Control Panel."] = "Öffnet das Addon Control Panel.",
	["Toggles enabling of load on demand child AddOns."] = "Schaltet das Aktivieren von LoD-Unter-AddOns um.",
	["Toggles recursive enabling of dependencies."] = "Schaltet das rekursive Aktivieren von Abhängigkeiten um.",
	["Toggles debug output."] = "Schaltet die Debug-Ausgabe um.",
	["Shows this list."] = "Zeigt diese Liste an.",

	-- Tooltips
	["No information available."] = "Keine Informationen verfügbar.",
	["Version"] = "Version",
	["Status"] = "Status",
	["Dependencies"] = "Abhängigkeiten",
	["Embedded Libraries"] = "Eingebettete Bibliotheken",
	["Active Embedded Libraries"] = "Aktive eingebettete Bibliotheken",
	["Memory Usage"] = "Speichernutzung",
	["Compatible"] = "Kompatibel",
	["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."] = "Klicken, um den geschützten Modus umzuschalten. Geschützte AddOns werden beim Neuladen der Benutzeroberfläche automatisch wieder aktiviert.",
	["Use SHIFT to override the current dependency enabling behavior."] = "Halte UMSCHALT gedrückt, um das aktuelle Verhalten beim Aktivieren von Abhängigkeiten umzukehren.",

	-- AddOn status column
	["Loadable on demand"] = "Bei Bedarf ladbar",
	["Disabled after Reload UI"] = "Nach dem Neuladen deaktiviert",
	["Loaded"] = "Geladen",
	["Loaded on demand."] = "Bei Bedarf geladen.",

	-- Reserved: used by code paths that are currently commented out in ACP.lua
	["Reload"] = "Neu laden",
	["*** Enabling <%s> %s your UI ***"] = "*** Aktiviere <%s> %s deiner UI ***",
	["*** Unknown AddOn <%s> required ***"] = "*** Unbekanntes AddOn <%s> benötigt ***",
	["AddOn <%s> is not valid."] = "AddOn <%s> ist ungültig.",

	-- Manual language selector  (/acp locale, and the drop down in the window)
	["Language"] = "Sprache",
	["Automatic"] = "Automatisch",
	["Detected locale: %s"] = "Erkannte Sprache: %s",
	["ACP locale: %s"] = "ACP-Sprache: %s",
	["Locale override: %s"] = "Manuelle Auswahl: %s",
	["Locale %s is not registered."] = "Die Sprache %s ist nicht registriert.",
	["ACP language set to %s."] = "ACP-Sprache auf %s gesetzt.",
	["ACP language returned to automatic detection."] = "ACP verwendet wieder die automatische Erkennung.",
	["Reload the UI to apply the language change."] = "Lade die Benutzeroberfläche neu, um die Sprachänderung anzuwenden.",
	["Reload now"] = "Jetzt neu laden",
	["Later"] = "Später",
	["Valid locale commands:"] = "Gültige Sprachbefehle:",
	["Shows the language ACP is using."] = "Zeigt die Sprache an, die ACP verwendet.",
	["Forces a language."] = "Erzwingt eine Sprache.",
	["Returns to automatic detection."] = "Zurück zur automatischen Erkennung.",

	-- Diagnostics. Only shown while /acp debug is on, or raised as Lua errors.
	["Untranslated key: %s"] = "Nicht übersetzter Schlüssel: %s",
	["No untranslated key has been requested so far."] = "Bisher wurde kein nicht übersetzter Schlüssel angefordert.",
	["No translation is registered for locale %s, using %s."] = "Für die Sprache %s ist keine Übersetzung registriert, es wird %s verwendet.",
	["Cannot find AddOn %s."] = "AddOn %s wurde nicht gefunden.",
	["GetAddonIndex(): addon must be a number or a string."] = "GetAddonIndex(): addon muss eine Zahl oder eine Zeichenkette sein.",

	-- Blizzard AddOn titles. Never translate the folder name on the left,
	-- only the descriptive title on the right.
	["Blizzard_AchievementUI"] = "Blizzard: Erfolge",
	["Blizzard_ArenaUI"] = "Blizzard: Arena",
	["Blizzard_AuctionUI"] = "Blizzard: Auktionshaus",
	["Blizzard_BarbershopUI"] = "Blizzard: Friseursalon",
	["Blizzard_BattlefieldMinimap"] = "Blizzard: Schlachtfeldkarte",
	["Blizzard_BindingUI"] = "Blizzard: Tastenbelegung",
	["Blizzard_Calendar"] = "Blizzard: Kalender",
	["Blizzard_CombatLog"] = "Blizzard: Kampfprotokoll",
	["Blizzard_CombatText"] = "Blizzard: Schwebender Kampftext",
	["Blizzard_DebugTools"] = "Blizzard: Debug-Werkzeuge",
	["Blizzard_GlyphUI"] = "Blizzard: Glyphen",
	["Blizzard_GMChatUI"] = "Blizzard: GM-Chat",
	["Blizzard_GMSurveyUI"] = "Blizzard: GM-Umfrage",
	["Blizzard_GuildBankUI"] = "Blizzard: Gildenbank",
	["Blizzard_InspectUI"] = "Blizzard: Betrachten",
	["Blizzard_ItemSocketingUI"] = "Blizzard: Sockeln",
	["Blizzard_MacroUI"] = "Blizzard: Makros",
	["Blizzard_RaidUI"] = "Blizzard: Schlachtzug",
	["Blizzard_TalentUI"] = "Blizzard: Talente",
	["Blizzard_TimeManager"] = "Blizzard: Zeitmanager",
	["Blizzard_TokenUI"] = "Blizzard: Währung",
	["Blizzard_TradeSkillUI"] = "Blizzard: Berufe",
	["Blizzard_TrainerUI"] = "Blizzard: Lehrer",

})
