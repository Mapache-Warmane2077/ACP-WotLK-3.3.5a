--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Localization: Francais   (frFR)

	enUS is the canonical source. Any key that is missing here falls back
	to the enUS string automatically, so an incomplete file is safe.

	Keep every %s / %d / %% placeholder, every |cffxxxxxx colour code and
	every line break exactly as they appear in the enUS file.
----------------------------------------------------------------------]]

if not ACP or not ACP.RegisterLocale then return end

ACP:RegisterLocale("frFR", {

	-- Main window and buttons  (keep these short, the buttons are 80px wide)
	["AddOns"] = "AddOns",
	["Load"] = "Charger",
	["Disable All"] = "Tout désact.",
	["Enable All"] = "Tout activer",
	["Reload UI"] = "Recharger",
	["Sets"] = "Sets",
	["Close"] = "Fermer",
	["Recursive"] = "Récursif",

	-- Sorting criteria shown in the drop down menu
	["Default"] = "Défaut",
	["Titles"] = "Titres",
	["Ace2"] = "Ace2",
	["Author"] = "Auteur",
	["Separate LoD List"] = "Liste LoD séparée",
	["Group By Name"] = "Grouper par nom",

	-- Category headers built by ACP itself
	["Blizzard"] = "Blizzard",
	["Blizzard AddOns"] = "AddOns de Blizzard",
	["Standard AddOns"] = "AddOns standard",
	["Load on Demand AddOns"] = "AddOns à chargement à la demande",
	["Libraries"] = "Bibliothèques",
	["Undefined"] = "Non défini",
	["Unknown"] = "Inconnu",

	-- Sets menu
	["Save"] = "Sauvegarder",
	["Rename"] = "Renommer",
	["Add to current selection"] = "Ajouter à la sélection actuelle",
	["Remove from current selection"] = "Retirer de la sélection actuelle",
	["Set %d"] = "Set %d",

	-- Confirmation popups
	["Reload your user interface?"] = "Recharger votre interface ?",
	["Save the current AddOn list to [%s]?"] = "Sauvegarder la liste d'AddOns actuelle dans [%s] ?",
	["Enter the new name for [%s]:"] = "Entrez le nouveau nom pour [%s] :",
	["ACP: Some protected AddOns are not enabled. Reload the UI now?"] = "ACP : certains AddOns protégés ne sont pas activés. Recharger l'interface maintenant ?",

	-- Chat messages
	["AddOn set [%s] saved."] = "Set d'AddOns [%s] sauvegardé.",
	["AddOn set [%s] loaded."] = "Set d'AddOns [%s] chargé.",
	["AddOn set [%s] unloaded."] = "Set d'AddOns [%s] déchargé.",
	["AddOn set [%s] renamed to [%s]."] = "Set d'AddOns [%s] renommé en [%s].",
	["%s is collapsed. Setting all of its AddOns to %s."] = "%s est replié. Tous ses AddOns passent à %s.",
	["ENABLED"] = "ACTIVÉS",
	["DISABLED"] = "DÉSACTIVÉS",
	["ON"] = "OUI",
	["OFF"] = "NON",
	["Load on demand child enabling is now %s."] = "Activation des AddOns enfants à la demande : %s",
	["Recursive enabling is now %s."] = "Activation récursive : %s",
	["Debug mode is now %s."] = "Mode débogage : %s",

	-- Slash commands  (/acp)
	["Valid commands:"] = "Commandes valides :",
	["Opens the AddOn Control Panel."] = "Ouvre l'Addon Control Panel.",
	["Toggles enabling of load on demand child AddOns."] = "Bascule l'activation des AddOns enfants à chargement à la demande.",
	["Toggles recursive enabling of dependencies."] = "Bascule l'activation récursive des dépendances.",
	["Toggles debug output."] = "Bascule les messages de débogage.",
	["Shows this list."] = "Affiche cette liste.",

	-- Tooltips
	["No information available."] = "Aucune information disponible.",
	["Version"] = "Version",
	["Status"] = "Statut",
	["Dependencies"] = "Dépendances",
	["Embedded Libraries"] = "Bibliothèques intégrées",
	["Active Embedded Libraries"] = "Bibliothèques intégrées actives",
	["Memory Usage"] = "Utilisation mémoire",
	["Compatible"] = "Compatible",
	["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."] = "Cliquez pour basculer le mode protégé. Les AddOns protégés sont réactivés automatiquement lors du rechargement de l'interface.",
	["Use SHIFT to override the current dependency enabling behavior."] = "Utilisez MAJ pour inverser le comportement actuel d'activation des dépendances.",

	-- AddOn status column
	["Loadable on demand"] = "Chargeable à la demande",
	["Disabled after Reload UI"] = "Désactivé après rechargement",
	["Loaded"] = "Chargé",
	["Loaded on demand."] = "Chargé à la demande.",

	-- Reserved: used by code paths that are currently commented out in ACP.lua
	["Reload"] = "Recharger",
	["*** Enabling <%s> %s your UI ***"] = "*** Activation de <%s> %s votre interface ***",
	["*** Unknown AddOn <%s> required ***"] = "*** AddOn inconnu <%s> requis ***",
	["AddOn <%s> is not valid."] = "L'AddOn <%s> n'est pas valide.",

	-- Manual language selector  (/acp locale, and the drop down in the window)
	["Language"] = "Langue",
	["Automatic"] = "Automatique",
	["Detected locale: %s"] = "Langue détectée : %s",
	["ACP locale: %s"] = "Langue d'ACP : %s",
	["Locale override: %s"] = "Sélection manuelle : %s",
	["Locale %s is not registered."] = "La langue %s n'est pas enregistrée.",
	["ACP language set to %s."] = "Langue d'ACP réglée sur %s.",
	["ACP language returned to automatic detection."] = "ACP revient à la détection automatique.",
	["Reload the UI to apply the language change."] = "Rechargez l'interface pour appliquer le changement de langue.",
	["Reload now"] = "Recharger",
	["Later"] = "Plus tard",
	["Valid locale commands:"] = "Commandes de langue valides :",
	["Shows the language ACP is using."] = "Affiche la langue utilisée par ACP.",
	["Forces a language."] = "Force une langue.",
	["Returns to automatic detection."] = "Revient à la détection automatique.",

	-- Diagnostics. Only shown while /acp debug is on, or raised as Lua errors.
	["Untranslated key: %s"] = "Clé non traduite : %s",
	["No untranslated key has been requested so far."] = "Aucune clé non traduite n'a été demandée jusqu'ici.",
	["No translation is registered for locale %s, using %s."] = "Aucune traduction n'est enregistrée pour la langue %s, utilisation de %s.",
	["Cannot find AddOn %s."] = "AddOn %s introuvable.",
	["GetAddonIndex(): addon must be a number or a string."] = "GetAddonIndex() : addon doit être un nombre ou une chaîne.",

	-- Blizzard AddOn titles. Never translate the folder name on the left,
	-- only the descriptive title on the right.
	["Blizzard_AchievementUI"] = "Blizzard : Hauts faits",
	["Blizzard_ArenaUI"] = "Blizzard : Arène",
	["Blizzard_AuctionUI"] = "Blizzard : Hôtel des ventes",
	["Blizzard_BarbershopUI"] = "Blizzard : Salon de coiffure",
	["Blizzard_BattlefieldMinimap"] = "Blizzard : Minicarte de champ de bataille",
	["Blizzard_BindingUI"] = "Blizzard : Raccourcis clavier",
	["Blizzard_Calendar"] = "Blizzard : Calendrier",
	["Blizzard_CombatLog"] = "Blizzard : Journal de combat",
	["Blizzard_CombatText"] = "Blizzard : Texte de combat",
	["Blizzard_DebugTools"] = "Blizzard : Outils de débogage",
	["Blizzard_GlyphUI"] = "Blizzard : Glyphes",
	["Blizzard_GMChatUI"] = "Blizzard : Discussion MJ",
	["Blizzard_GMSurveyUI"] = "Blizzard : Sondage MJ",
	["Blizzard_GuildBankUI"] = "Blizzard : Banque de guilde",
	["Blizzard_InspectUI"] = "Blizzard : Inspection",
	["Blizzard_ItemSocketingUI"] = "Blizzard : Sertissage",
	["Blizzard_MacroUI"] = "Blizzard : Macros",
	["Blizzard_RaidUI"] = "Blizzard : Raid",
	["Blizzard_TalentUI"] = "Blizzard : Talents",
	["Blizzard_TimeManager"] = "Blizzard : Gestion du temps",
	["Blizzard_TokenUI"] = "Blizzard : Monnaies",
	["Blizzard_TradeSkillUI"] = "Blizzard : Métiers",
	["Blizzard_TrainerUI"] = "Blizzard : Maître",

})
