--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Localization: Espanol (Latinoamerica)   (esMX)

	enUS is the canonical source. Any key that is missing here falls back
	to the enUS string automatically, so an incomplete file is safe.

	Keep every %s / %d / %% placeholder, every |cffxxxxxx colour code and
	every line break exactly as they appear in the enUS file.
----------------------------------------------------------------------]]

if not ACP or not ACP.RegisterLocale then return end

ACP:RegisterLocale("esMX", {

	-- Main window and buttons  (keep these short, the buttons are 80px wide)
	["AddOns"] = "AddOns",
	["Load"] = "Cargar",
	["Disable All"] = "Desact. todos",
	["Enable All"] = "Activar todos",
	["Reload UI"] = "Recargar IU",
	["Sets"] = "Sets",
	["Close"] = "Cerrar",
	["Recursive"] = "Recursivo",

	-- Sorting criteria shown in the drop down menu
	["Default"] = "Predeterminado",
	["Titles"] = "Títulos",
	["Ace2"] = "Ace2",
	["Author"] = "Autor",
	["Separate LoD List"] = "Lista CbD aparte",
	["Group By Name"] = "Agrupar por nombre",

	-- Category headers built by ACP itself
	["Blizzard"] = "Blizzard",
	["Blizzard AddOns"] = "AddOns de Blizzard",
	["Standard AddOns"] = "AddOns estándar",
	["Load on Demand AddOns"] = "AddOns de carga bajo demanda",
	["Libraries"] = "Bibliotecas",
	["Undefined"] = "Sin definir",
	["Unknown"] = "Desconocido",

	-- Sets menu
	["Save"] = "Guardar",
	["Rename"] = "Renombrar",
	["Add to current selection"] = "Añadir a la selección actual",
	["Remove from current selection"] = "Quitar de la selección actual",
	["Set %d"] = "Set %d",

	-- Confirmation popups
	["Reload your user interface?"] = "¿Recargar la interfaz de usuario?",
	["Save the current AddOn list to [%s]?"] = "¿Guardar la lista actual de AddOns en [%s]?",
	["Enter the new name for [%s]:"] = "Escribe el nuevo nombre para [%s]:",
	["ACP: Some protected AddOns are not enabled. Reload the UI now?"] = "ACP: algunos AddOns protegidos no están activados. ¿Recargar la interfaz ahora?",

	-- Chat messages
	["AddOn set [%s] saved."] = "Set de AddOns [%s] guardado.",
	["AddOn set [%s] loaded."] = "Set de AddOns [%s] cargado.",
	["AddOn set [%s] unloaded."] = "Set de AddOns [%s] descargado.",
	["AddOn set [%s] renamed to [%s]."] = "Set de AddOns [%s] renombrado a [%s].",
	["%s is collapsed. Setting all of its AddOns to %s."] = "%s está contraído. Todos sus AddOns pasan a %s.",
	["ENABLED"] = "ACTIVADOS",
	["DISABLED"] = "DESACTIVADOS",
	["ON"] = "SÍ",
	["OFF"] = "NO",
	["Load on demand child enabling is now %s."] = "Activación de AddOns hijos de carga bajo demanda: %s",
	["Recursive enabling is now %s."] = "Activación recursiva: %s",
	["Debug mode is now %s."] = "Modo de depuración: %s",

	-- Slash commands  (/acp)
	["Valid commands:"] = "Comandos válidos:",
	["Opens the AddOn Control Panel."] = "Abre el Addon Control Panel.",
	["Toggles enabling of load on demand child AddOns."] = "Alterna la activación de los AddOns hijos de carga bajo demanda.",
	["Toggles recursive enabling of dependencies."] = "Alterna la activación recursiva de dependencias.",
	["Toggles debug output."] = "Alterna los mensajes de depuración.",
	["Shows this list."] = "Muestra esta lista.",

	-- Tooltips
	["No information available."] = "No hay información disponible.",
	["Version"] = "Versión",
	["Status"] = "Estado",
	["Dependencies"] = "Dependencias",
	["Embedded Libraries"] = "Bibliotecas incluidas",
	["Active Embedded Libraries"] = "Bibliotecas incluidas activas",
	["Memory Usage"] = "Uso de memoria",
	["Compatible"] = "Compatible",
	["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."] = "Da clic para alternar el modo protegido. Los AddOns protegidos se vuelven a activar automáticamente al recargar la interfaz.",
	["Use SHIFT to override the current dependency enabling behavior."] = "Usa MAYÚS para invertir el comportamiento actual de activación de dependencias.",

	-- AddOn status column
	["Loadable on demand"] = "Cargable bajo demanda",
	["Disabled after Reload UI"] = "Se desactivará al recargar",
	["Loaded"] = "Cargado",
	["Loaded on demand."] = "Cargado bajo demanda.",

	-- Reserved: used by code paths that are currently commented out in ACP.lua
	["Reload"] = "Recargar",
	["*** Enabling <%s> %s your UI ***"] = "*** Activando <%s> %s tu interfaz ***",
	["*** Unknown AddOn <%s> required ***"] = "*** Se requiere el AddOn desconocido <%s> ***",
	["AddOn <%s> is not valid."] = "El AddOn <%s> no es válido.",

	-- Manual language selector  (/acp locale, and the drop down in the window)
	["Language"] = "Idioma",
	["Automatic"] = "Automático",
	["Detected locale: %s"] = "Idioma detectado: %s",
	["ACP locale: %s"] = "Idioma de ACP: %s",
	["Locale override: %s"] = "Selección manual: %s",
	["Locale %s is not registered."] = "El idioma %s no está disponible.",
	["ACP language set to %s."] = "Idioma de ACP cambiado a %s.",
	["ACP language returned to automatic detection."] = "ACP vuelve a la detección automática.",
	["Reload the UI to apply the language change."] = "Recarga la interfaz para aplicar el cambio de idioma.",
	["Reload now"] = "Recargar ahora",
	["Later"] = "Más tarde",
	["Valid locale commands:"] = "Comandos de idioma válidos:",
	["Shows the language ACP is using."] = "Muestra el idioma que usa ACP.",
	["Forces a language."] = "Fuerza un idioma.",
	["Returns to automatic detection."] = "Vuelve a la detección automática.",

	-- Diagnostics. Only shown while /acp debug is on, or raised as Lua errors.
	["Untranslated key: %s"] = "Clave sin traducir: %s",
	["No untranslated key has been requested so far."] = "Hasta ahora no se ha solicitado ninguna clave sin traducir.",
	["No translation is registered for locale %s, using %s."] = "No hay traducción registrada para el idioma %s; se usa %s.",
	["Cannot find AddOn %s."] = "No se encuentra el AddOn %s.",
	["GetAddonIndex(): addon must be a number or a string."] = "GetAddonIndex(): addon debe ser un número o una cadena.",

	-- Blizzard AddOn titles. Never translate the folder name on the left,
	-- only the descriptive title on the right.
	["Blizzard_AchievementUI"] = "Blizzard: Logros",
	["Blizzard_ArenaUI"] = "Blizzard: Arena",
	["Blizzard_AuctionUI"] = "Blizzard: Casa de subastas",
	["Blizzard_BarbershopUI"] = "Blizzard: Peluquería",
	["Blizzard_BattlefieldMinimap"] = "Blizzard: Minimapa de campo de batalla",
	["Blizzard_BindingUI"] = "Blizzard: Asignación de teclas",
	["Blizzard_Calendar"] = "Blizzard: Calendario",
	["Blizzard_CombatLog"] = "Blizzard: Registro de combate",
	["Blizzard_CombatText"] = "Blizzard: Texto de combate",
	["Blizzard_DebugTools"] = "Blizzard: Herramientas de depuración",
	["Blizzard_GlyphUI"] = "Blizzard: Glifos",
	["Blizzard_GMChatUI"] = "Blizzard: Chat de MJ",
	["Blizzard_GMSurveyUI"] = "Blizzard: Encuesta de MJ",
	["Blizzard_GuildBankUI"] = "Blizzard: Banco de hermandad",
	["Blizzard_InspectUI"] = "Blizzard: Inspeccionar",
	["Blizzard_ItemSocketingUI"] = "Blizzard: Engarzado de objetos",
	["Blizzard_MacroUI"] = "Blizzard: Macros",
	["Blizzard_RaidUI"] = "Blizzard: Banda",
	["Blizzard_TalentUI"] = "Blizzard: Talentos",
	["Blizzard_TimeManager"] = "Blizzard: Gestor de tiempo",
	["Blizzard_TokenUI"] = "Blizzard: Monedas",
	["Blizzard_TradeSkillUI"] = "Blizzard: Profesiones",
	["Blizzard_TrainerUI"] = "Blizzard: Maestro",

})
