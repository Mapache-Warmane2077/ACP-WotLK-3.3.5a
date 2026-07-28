--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Localization: Russkiy   (ruRU)

	enUS is the canonical source. Any key that is missing here falls back
	to the enUS string automatically, so an incomplete file is safe.

	Keep every %s / %d / %% placeholder, every |cffxxxxxx colour code and
	every line break exactly as they appear in the enUS file.
----------------------------------------------------------------------]]

if not ACP or not ACP.RegisterLocale then return end

ACP:RegisterLocale("ruRU", {

	-- Main window and buttons  (keep these short, the buttons are 80px wide)
	["AddOns"] = "Аддоны",
	["Load"] = "Загрузить",
	["Disable All"] = "Откл. все",
	["Enable All"] = "Вкл. все",
	["Reload UI"] = "Перезагрузка",
	["Sets"] = "Наб.",
	["Close"] = "Закрыть",
	["Recursive"] = "Рекурсивно",

	-- Sorting criteria shown in the drop down menu
	["Default"] = "По умолчанию",
	["Titles"] = "По названию",
	["Ace2"] = "Ace2",
	["Author"] = "Автор",
	["Separate LoD List"] = "Отдельный список ЗПТ",
	["Group By Name"] = "Группировать по имени",

	-- Category headers built by ACP itself
	["Blizzard"] = "Blizzard",
	["Blizzard AddOns"] = "Аддоны Blizzard",
	["Standard AddOns"] = "Обычные аддоны",
	["Load on Demand AddOns"] = "Аддоны, загружаемые по требованию",
	["Libraries"] = "Библиотеки",
	["Undefined"] = "Не указано",
	["Unknown"] = "Неизвестно",

	-- Sets menu
	["Save"] = "Сохранить",
	["Rename"] = "Переименовать",
	["Add to current selection"] = "Добавить к текущему выбору",
	["Remove from current selection"] = "Убрать из текущего выбора",
	["Set %d"] = "Набор %d",

	-- Confirmation popups
	["Reload your user interface?"] = "Перезагрузить пользовательский интерфейс?",
	["Save the current AddOn list to [%s]?"] = "Сохранить текущий список аддонов в [%s]?",
	["Enter the new name for [%s]:"] = "Введите новое имя для [%s]:",
	["ACP: Some protected AddOns are not enabled. Reload the UI now?"] = "ACP: некоторые защищённые аддоны не включены. Перезагрузить интерфейс сейчас?",

	-- Chat messages
	["AddOn set [%s] saved."] = "Набор аддонов [%s] сохранён.",
	["AddOn set [%s] loaded."] = "Набор аддонов [%s] загружен.",
	["AddOn set [%s] unloaded."] = "Набор аддонов [%s] выгружен.",
	["AddOn set [%s] renamed to [%s]."] = "Набор аддонов [%s] переименован в [%s].",
	["%s is collapsed. Setting all of its AddOns to %s."] = "%s свёрнут. Все его аддоны переводятся в состояние %s.",
	["ENABLED"] = "ВКЛЮЧЕНО",
	["DISABLED"] = "ОТКЛЮЧЕНО",
	["ON"] = "ВКЛ",
	["OFF"] = "ВЫКЛ",
	["Load on demand child enabling is now %s."] = "Включение дочерних аддонов ЗПТ: %s",
	["Recursive enabling is now %s."] = "Рекурсивное включение: %s",
	["Debug mode is now %s."] = "Режим отладки: %s",

	-- Slash commands  (/acp)
	["Valid commands:"] = "Доступные команды:",
	["Opens the AddOn Control Panel."] = "Открывает панель управления аддонами.",
	["Toggles enabling of load on demand child AddOns."] = "Переключает включение дочерних аддонов, загружаемых по требованию.",
	["Toggles recursive enabling of dependencies."] = "Переключает рекурсивное включение зависимостей.",
	["Toggles debug output."] = "Переключает вывод отладочных сообщений.",
	["Shows this list."] = "Показывает этот список.",

	-- Tooltips
	["No information available."] = "Информация недоступна.",
	["Version"] = "Версия",
	["Status"] = "Статус",
	["Dependencies"] = "Зависимости",
	["Embedded Libraries"] = "Встроенные библиотеки",
	["Active Embedded Libraries"] = "Активные встроенные библиотеки",
	["Memory Usage"] = "Использование памяти",
	["Compatible"] = "Совместим",
	["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."] = "Щёлкните, чтобы переключить режим защиты. Защищённые аддоны автоматически включаются заново при перезагрузке интерфейса.",
	["Use SHIFT to override the current dependency enabling behavior."] = "Удерживайте SHIFT, чтобы изменить текущее поведение включения зависимостей.",

	-- AddOn status column
	["Loadable on demand"] = "Загружается по требованию",
	["Disabled after Reload UI"] = "Отключится после перезагрузки",
	["Loaded"] = "Загружен",
	["Loaded on demand."] = "Загружен по требованию.",

	-- Reserved: used by code paths that are currently commented out in ACP.lua
	["Reload"] = "Перезагрузить",
	["*** Enabling <%s> %s your UI ***"] = "*** Включаю <%s> %s ваш интерфейс ***",
	["*** Unknown AddOn <%s> required ***"] = "*** Требуется неизвестный аддон <%s> ***",
	["AddOn <%s> is not valid."] = "Аддон <%s> недействителен.",

	-- Manual language selector  (/acp locale, and the drop down in the window)
	["Language"] = "Язык",
	["Automatic"] = "Автоматически",
	["Detected locale: %s"] = "Определённый язык: %s",
	["ACP locale: %s"] = "Язык ACP: %s",
	["Locale override: %s"] = "Ручной выбор: %s",
	["Locale %s is not registered."] = "Язык %s не зарегистрирован.",
	["ACP language set to %s."] = "Язык ACP изменён на %s.",
	["ACP language returned to automatic detection."] = "ACP вернулся к автоматическому определению.",
	["Reload the UI to apply the language change."] = "Перезагрузите интерфейс, чтобы применить смену языка.",
	["Reload now"] = "Перезагрузить",
	["Later"] = "Позже",
	["Valid locale commands:"] = "Доступные команды языка:",
	["Shows the language ACP is using."] = "Показывает язык, который использует ACP.",
	["Forces a language."] = "Принудительно задаёт язык.",
	["Returns to automatic detection."] = "Возврат к автоматическому определению.",

	-- Diagnostics. Only shown while /acp debug is on, or raised as Lua errors.
	["Untranslated key: %s"] = "Непереведённый ключ: %s",
	["No untranslated key has been requested so far."] = "Пока не запрашивалось ни одного непереведённого ключа.",
	["No translation is registered for locale %s, using %s."] = "Для языка %s не зарегистрирован перевод, используется %s.",
	["Cannot find AddOn %s."] = "Аддон %s не найден.",
	["GetAddonIndex(): addon must be a number or a string."] = "GetAddonIndex(): addon должен быть числом или строкой.",

	-- Blizzard AddOn titles. Never translate the folder name on the left,
	-- only the descriptive title on the right.
	["Blizzard_AchievementUI"] = "Blizzard: Достижения",
	["Blizzard_ArenaUI"] = "Blizzard: Арена",
	["Blizzard_AuctionUI"] = "Blizzard: Аукцион",
	["Blizzard_BarbershopUI"] = "Blizzard: Парикмахерская",
	["Blizzard_BattlefieldMinimap"] = "Blizzard: Миникарта поля боя",
	["Blizzard_BindingUI"] = "Blizzard: Назначение клавиш",
	["Blizzard_Calendar"] = "Blizzard: Календарь",
	["Blizzard_CombatLog"] = "Blizzard: Журнал боя",
	["Blizzard_CombatText"] = "Blizzard: Боевой текст",
	["Blizzard_DebugTools"] = "Blizzard: Средства отладки",
	["Blizzard_GlyphUI"] = "Blizzard: Символы",
	["Blizzard_GMChatUI"] = "Blizzard: Чат с ГМ",
	["Blizzard_GMSurveyUI"] = "Blizzard: Опрос ГМ",
	["Blizzard_GuildBankUI"] = "Blizzard: Банк гильдии",
	["Blizzard_InspectUI"] = "Blizzard: Осмотр",
	["Blizzard_ItemSocketingUI"] = "Blizzard: Инкрустация",
	["Blizzard_MacroUI"] = "Blizzard: Макросы",
	["Blizzard_RaidUI"] = "Blizzard: Рейд",
	["Blizzard_TalentUI"] = "Blizzard: Таланты",
	["Blizzard_TimeManager"] = "Blizzard: Время",
	["Blizzard_TokenUI"] = "Blizzard: Валюта",
	["Blizzard_TradeSkillUI"] = "Blizzard: Профессии",
	["Blizzard_TrainerUI"] = "Blizzard: Обучение",

})
