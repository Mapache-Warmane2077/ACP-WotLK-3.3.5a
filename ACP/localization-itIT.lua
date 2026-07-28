--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Localization: Italiano   (itIT)

	enUS is the canonical source. Any key that is missing here falls back
	to the enUS string automatically, so an incomplete file is safe.

	Keep every %s / %d / %% placeholder, every |cffxxxxxx colour code and
	every line break exactly as they appear in the enUS file.
----------------------------------------------------------------------]]

if not ACP or not ACP.RegisterLocale then return end

ACP:RegisterLocale("itIT", {

	-- Main window and buttons  (keep these short, the buttons are 80px wide)
	["AddOns"] = "AddOn",
	["Load"] = "Carica",
	["Disable All"] = "Disatt. tutti",
	["Enable All"] = "Attiva tutti",
	["Reload UI"] = "Ricarica IU",
	["Sets"] = "Set",
	["Close"] = "Chiudi",
	["Recursive"] = "Ricorsivo",

	-- Sorting criteria shown in the drop down menu
	["Default"] = "Predefinito",
	["Titles"] = "Titoli",
	["Ace2"] = "Ace2",
	["Author"] = "Autore",
	["Separate LoD List"] = "Elenco LoD separato",
	["Group By Name"] = "Raggruppa per nome",

	-- Category headers built by ACP itself
	["Blizzard"] = "Blizzard",
	["Blizzard AddOns"] = "AddOn di Blizzard",
	["Standard AddOns"] = "AddOn standard",
	["Load on Demand AddOns"] = "AddOn a caricamento su richiesta",
	["Libraries"] = "Librerie",
	["Undefined"] = "Non definito",
	["Unknown"] = "Sconosciuto",

	-- Sets menu
	["Save"] = "Salva",
	["Rename"] = "Rinomina",
	["Add to current selection"] = "Aggiungi alla selezione attuale",
	["Remove from current selection"] = "Rimuovi dalla selezione attuale",
	["Set %d"] = "Set %d",

	-- Confirmation popups
	["Reload your user interface?"] = "Ricaricare l'interfaccia utente?",
	["Save the current AddOn list to [%s]?"] = "Salvare l'elenco di AddOn attuale in [%s]?",
	["Enter the new name for [%s]:"] = "Inserisci il nuovo nome per [%s]:",
	["ACP: Some protected AddOns are not enabled. Reload the UI now?"] = "ACP: alcuni AddOn protetti non sono attivi. Ricaricare l'interfaccia adesso?",

	-- Chat messages
	["AddOn set [%s] saved."] = "Set di AddOn [%s] salvato.",
	["AddOn set [%s] loaded."] = "Set di AddOn [%s] caricato.",
	["AddOn set [%s] unloaded."] = "Set di AddOn [%s] scaricato.",
	["AddOn set [%s] renamed to [%s]."] = "Set di AddOn [%s] rinominato in [%s].",
	["%s is collapsed. Setting all of its AddOns to %s."] = "%s è compresso. Tutti i suoi AddOn passano a %s.",
	["ENABLED"] = "ATTIVATI",
	["DISABLED"] = "DISATTIVATI",
	["ON"] = "SÌ",
	["OFF"] = "NO",
	["Load on demand child enabling is now %s."] = "Attivazione degli AddOn figli a richiesta: %s",
	["Recursive enabling is now %s."] = "Attivazione ricorsiva: %s",
	["Debug mode is now %s."] = "Modalità di debug: %s",

	-- Slash commands  (/acp)
	["Valid commands:"] = "Comandi validi:",
	["Opens the AddOn Control Panel."] = "Apre l'Addon Control Panel.",
	["Toggles enabling of load on demand child AddOns."] = "Attiva o disattiva l'abilitazione degli AddOn figli a caricamento su richiesta.",
	["Toggles recursive enabling of dependencies."] = "Attiva o disattiva l'abilitazione ricorsiva delle dipendenze.",
	["Toggles debug output."] = "Attiva o disattiva i messaggi di debug.",
	["Shows this list."] = "Mostra questo elenco.",

	-- Tooltips
	["No information available."] = "Nessuna informazione disponibile.",
	["Version"] = "Versione",
	["Status"] = "Stato",
	["Dependencies"] = "Dipendenze",
	["Embedded Libraries"] = "Librerie incorporate",
	["Active Embedded Libraries"] = "Librerie incorporate attive",
	["Memory Usage"] = "Uso della memoria",
	["Compatible"] = "Compatibile",
	["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."] = "Clicca per attivare o disattivare la modalità protetta. Gli AddOn protetti vengono riattivati automaticamente quando ricarichi l'interfaccia.",
	["Use SHIFT to override the current dependency enabling behavior."] = "Usa MAIUSC per invertire il comportamento attuale di attivazione delle dipendenze.",

	-- AddOn status column
	["Loadable on demand"] = "Caricabile su richiesta",
	["Disabled after Reload UI"] = "Disattivato dopo la ricarica",
	["Loaded"] = "Caricato",
	["Loaded on demand."] = "Caricato su richiesta.",

	-- Reserved: used by code paths that are currently commented out in ACP.lua
	["Reload"] = "Ricarica",
	["*** Enabling <%s> %s your UI ***"] = "*** Attivazione di <%s> %s la tua interfaccia ***",
	["*** Unknown AddOn <%s> required ***"] = "*** AddOn sconosciuto <%s> richiesto ***",
	["AddOn <%s> is not valid."] = "L'AddOn <%s> non è valido.",

	-- Manual language selector  (/acp locale, and the drop down in the window)
	["Language"] = "Lingua",
	["Automatic"] = "Automatico",
	["Detected locale: %s"] = "Lingua rilevata: %s",
	["ACP locale: %s"] = "Lingua di ACP: %s",
	["Locale override: %s"] = "Selezione manuale: %s",
	["Locale %s is not registered."] = "La lingua %s non è disponibile.",
	["ACP language set to %s."] = "Lingua di ACP impostata su %s.",
	["ACP language returned to automatic detection."] = "ACP torna al rilevamento automatico.",
	["Reload the UI to apply the language change."] = "Ricarica l'interfaccia per applicare il cambio di lingua.",
	["Reload now"] = "Ricarica ora",
	["Later"] = "Più tardi",
	["Valid locale commands:"] = "Comandi di lingua validi:",
	["Shows the language ACP is using."] = "Mostra la lingua usata da ACP.",
	["Forces a language."] = "Forza una lingua.",
	["Returns to automatic detection."] = "Torna al rilevamento automatico.",

	-- Diagnostics. Only shown while /acp debug is on, or raised as Lua errors.
	["Untranslated key: %s"] = "Chiave non tradotta: %s",
	["No untranslated key has been requested so far."] = "Finora non è stata richiesta nessuna chiave non tradotta.",
	["No translation is registered for locale %s, using %s."] = "Nessuna traduzione registrata per la lingua %s; viene usato %s.",
	["Cannot find AddOn %s."] = "AddOn %s non trovato.",
	["GetAddonIndex(): addon must be a number or a string."] = "GetAddonIndex(): addon deve essere un numero o una stringa.",

	-- Blizzard AddOn titles. Never translate the folder name on the left,
	-- only the descriptive title on the right.
	["Blizzard_AchievementUI"] = "Blizzard: Imprese",
	["Blizzard_ArenaUI"] = "Blizzard: Arena",
	["Blizzard_AuctionUI"] = "Blizzard: Casa d'aste",
	["Blizzard_BarbershopUI"] = "Blizzard: Barbiere",
	["Blizzard_BattlefieldMinimap"] = "Blizzard: Minimappa del campo di battaglia",
	["Blizzard_BindingUI"] = "Blizzard: Assegnazione tasti",
	["Blizzard_Calendar"] = "Blizzard: Calendario",
	["Blizzard_CombatLog"] = "Blizzard: Registro di combattimento",
	["Blizzard_CombatText"] = "Blizzard: Testo di combattimento",
	["Blizzard_DebugTools"] = "Blizzard: Strumenti di debug",
	["Blizzard_GlyphUI"] = "Blizzard: Glifi",
	["Blizzard_GMChatUI"] = "Blizzard: Chat con il GM",
	["Blizzard_GMSurveyUI"] = "Blizzard: Sondaggio del GM",
	["Blizzard_GuildBankUI"] = "Blizzard: Banca di gilda",
	["Blizzard_InspectUI"] = "Blizzard: Esamina",
	["Blizzard_ItemSocketingUI"] = "Blizzard: Incastonatura",
	["Blizzard_MacroUI"] = "Blizzard: Macro",
	["Blizzard_RaidUI"] = "Blizzard: Incursione",
	["Blizzard_TalentUI"] = "Blizzard: Talenti",
	["Blizzard_TimeManager"] = "Blizzard: Gestione del tempo",
	["Blizzard_TokenUI"] = "Blizzard: Valute",
	["Blizzard_TradeSkillUI"] = "Blizzard: Professioni",
	["Blizzard_TrainerUI"] = "Blizzard: Addestratore",

})
