--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Localization: Portugues (Brasil)   (ptBR)

	enUS is the canonical source. Any key that is missing here falls back
	to the enUS string automatically, so an incomplete file is safe.

	Keep every %s / %d / %% placeholder, every |cffxxxxxx colour code and
	every line break exactly as they appear in the enUS file.
----------------------------------------------------------------------]]

if not ACP or not ACP.RegisterLocale then return end

ACP:RegisterLocale("ptBR", {

	-- Main window and buttons  (keep these short, the buttons are 80px wide)
	["AddOns"] = "AddOns",
	["Load"] = "Carregar",
	["Disable All"] = "Desat. todos",
	["Enable All"] = "Ativar todos",
	["Reload UI"] = "Recarregar",
	["Sets"] = "Sets",
	["Close"] = "Fechar",
	["Recursive"] = "Recursivo",

	-- Sorting criteria shown in the drop down menu
	["Default"] = "Padrão",
	["Titles"] = "Títulos",
	["Ace2"] = "Ace2",
	["Author"] = "Autor",
	["Separate LoD List"] = "Lista LoD separada",
	["Group By Name"] = "Agrupar por nome",

	-- Category headers built by ACP itself
	["Blizzard"] = "Blizzard",
	["Blizzard AddOns"] = "AddOns da Blizzard",
	["Standard AddOns"] = "AddOns padrão",
	["Load on Demand AddOns"] = "AddOns de carregamento sob demanda",
	["Libraries"] = "Bibliotecas",
	["Undefined"] = "Não definido",
	["Unknown"] = "Desconhecido",

	-- Sets menu
	["Save"] = "Salvar",
	["Rename"] = "Renomear",
	["Add to current selection"] = "Adicionar à seleção atual",
	["Remove from current selection"] = "Remover da seleção atual",
	["Set %d"] = "Set %d",

	-- Confirmation popups
	["Reload your user interface?"] = "Recarregar a interface do usuário?",
	["Save the current AddOn list to [%s]?"] = "Salvar a lista atual de AddOns em [%s]?",
	["Enter the new name for [%s]:"] = "Digite o novo nome para [%s]:",
	["ACP: Some protected AddOns are not enabled. Reload the UI now?"] = "ACP: alguns AddOns protegidos não estão ativados. Recarregar a interface agora?",

	-- Chat messages
	["AddOn set [%s] saved."] = "Conjunto de AddOns [%s] salvo.",
	["AddOn set [%s] loaded."] = "Conjunto de AddOns [%s] carregado.",
	["AddOn set [%s] unloaded."] = "Conjunto de AddOns [%s] descarregado.",
	["AddOn set [%s] renamed to [%s]."] = "Conjunto de AddOns [%s] renomeado para [%s].",
	["%s is collapsed. Setting all of its AddOns to %s."] = "%s está recolhido. Todos os seus AddOns passam a %s.",
	["ENABLED"] = "ATIVADOS",
	["DISABLED"] = "DESATIVADOS",
	["ON"] = "SIM",
	["OFF"] = "NÃO",
	["Load on demand child enabling is now %s."] = "Ativação de AddOns filhos sob demanda: %s",
	["Recursive enabling is now %s."] = "Ativação recursiva: %s",
	["Debug mode is now %s."] = "Modo de depuração: %s",

	-- Slash commands  (/acp)
	["Valid commands:"] = "Comandos válidos:",
	["Opens the AddOn Control Panel."] = "Abre o Addon Control Panel.",
	["Toggles enabling of load on demand child AddOns."] = "Alterna a ativação dos AddOns filhos de carregamento sob demanda.",
	["Toggles recursive enabling of dependencies."] = "Alterna a ativação recursiva de dependências.",
	["Toggles debug output."] = "Alterna as mensagens de depuração.",
	["Shows this list."] = "Mostra esta lista.",

	-- Tooltips
	["No information available."] = "Nenhuma informação disponível.",
	["Version"] = "Versão",
	["Status"] = "Estado",
	["Dependencies"] = "Dependências",
	["Embedded Libraries"] = "Bibliotecas embutidas",
	["Active Embedded Libraries"] = "Bibliotecas embutidas ativas",
	["Memory Usage"] = "Uso de memória",
	["Compatible"] = "Compatível",
	["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."] = "Clique para alternar o modo protegido. AddOns protegidos são reativados automaticamente ao recarregar a interface.",
	["Use SHIFT to override the current dependency enabling behavior."] = "Use SHIFT para inverter o comportamento atual de ativação de dependências.",

	-- AddOn status column
	["Loadable on demand"] = "Carregável sob demanda",
	["Disabled after Reload UI"] = "Desativado após recarregar",
	["Loaded"] = "Carregado",
	["Loaded on demand."] = "Carregado sob demanda.",

	-- Reserved: used by code paths that are currently commented out in ACP.lua
	["Reload"] = "Recarregar",
	["*** Enabling <%s> %s your UI ***"] = "*** Ativando <%s> %s sua interface ***",
	["*** Unknown AddOn <%s> required ***"] = "*** AddOn desconhecido <%s> necessário ***",
	["AddOn <%s> is not valid."] = "O AddOn <%s> não é válido.",

	-- Manual language selector  (/acp locale, and the drop down in the window)
	["Language"] = "Idioma",
	["Automatic"] = "Automático",
	["Detected locale: %s"] = "Idioma detectado: %s",
	["ACP locale: %s"] = "Idioma do ACP: %s",
	["Locale override: %s"] = "Seleção manual: %s",
	["Locale %s is not registered."] = "O idioma %s não está disponível.",
	["ACP language set to %s."] = "Idioma do ACP alterado para %s.",
	["ACP language returned to automatic detection."] = "O ACP voltou à detecção automática.",
	["Reload the UI to apply the language change."] = "Recarregue a interface para aplicar a mudança de idioma.",
	["Reload now"] = "Recarregar agora",
	["Later"] = "Mais tarde",
	["Valid locale commands:"] = "Comandos de idioma válidos:",
	["Shows the language ACP is using."] = "Mostra o idioma que o ACP está usando.",
	["Forces a language."] = "Força um idioma.",
	["Returns to automatic detection."] = "Volta para a detecção automática.",

	-- Diagnostics. Only shown while /acp debug is on, or raised as Lua errors.
	["Untranslated key: %s"] = "Chave sem tradução: %s",
	["No untranslated key has been requested so far."] = "Até agora nenhuma chave sem tradução foi solicitada.",
	["No translation is registered for locale %s, using %s."] = "Não há tradução registrada para o idioma %s; usando %s.",
	["Cannot find AddOn %s."] = "AddOn %s não encontrado.",
	["GetAddonIndex(): addon must be a number or a string."] = "GetAddonIndex(): addon deve ser um número ou uma string.",

	-- Blizzard AddOn titles. Never translate the folder name on the left,
	-- only the descriptive title on the right.
	["Blizzard_AchievementUI"] = "Blizzard: Conquistas",
	["Blizzard_ArenaUI"] = "Blizzard: Arena",
	["Blizzard_AuctionUI"] = "Blizzard: Casa de leilões",
	["Blizzard_BarbershopUI"] = "Blizzard: Barbearia",
	["Blizzard_BattlefieldMinimap"] = "Blizzard: Minimapa do campo de batalha",
	["Blizzard_BindingUI"] = "Blizzard: Atalhos de teclado",
	["Blizzard_Calendar"] = "Blizzard: Calendário",
	["Blizzard_CombatLog"] = "Blizzard: Registro de combate",
	["Blizzard_CombatText"] = "Blizzard: Texto de combate",
	["Blizzard_DebugTools"] = "Blizzard: Ferramentas de depuração",
	["Blizzard_GlyphUI"] = "Blizzard: Glifos",
	["Blizzard_GMChatUI"] = "Blizzard: Bate-papo com MJ",
	["Blizzard_GMSurveyUI"] = "Blizzard: Pesquisa do MJ",
	["Blizzard_GuildBankUI"] = "Blizzard: Banco da guilda",
	["Blizzard_InspectUI"] = "Blizzard: Inspecionar",
	["Blizzard_ItemSocketingUI"] = "Blizzard: Engaste de itens",
	["Blizzard_MacroUI"] = "Blizzard: Macros",
	["Blizzard_RaidUI"] = "Blizzard: Raide",
	["Blizzard_TalentUI"] = "Blizzard: Talentos",
	["Blizzard_TimeManager"] = "Blizzard: Gerenciador de tempo",
	["Blizzard_TokenUI"] = "Blizzard: Moedas",
	["Blizzard_TradeSkillUI"] = "Blizzard: Profissões",
	["Blizzard_TrainerUI"] = "Blizzard: Treinador",

})
