--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Localization: Traditional Chinese   (zhTW)

	enUS is the canonical source. Any key that is missing here falls back
	to the enUS string automatically, so an incomplete file is safe.

	Keep every %s / %d / %% placeholder, every |cffxxxxxx colour code and
	every line break exactly as they appear in the enUS file.
----------------------------------------------------------------------]]

if not ACP or not ACP.RegisterLocale then return end

ACP:RegisterLocale("zhTW", {

	-- Main window and buttons  (keep these short, the buttons are 80px wide)
	["AddOns"] = "插件",
	["Load"] = "載入",
	["Disable All"] = "全部停用",
	["Enable All"] = "全部啟用",
	["Reload UI"] = "重載介面",
	["Sets"] = "設定",
	["Close"] = "關閉",
	["Recursive"] = "遞迴",

	-- Sorting criteria shown in the drop down menu
	["Default"] = "預設",
	["Titles"] = "名稱",
	["Ace2"] = "Ace2",
	["Author"] = "作者",
	["Separate LoD List"] = "隨需求載入另列",
	["Group By Name"] = "以名稱分組",

	-- Category headers built by ACP itself
	["Blizzard"] = "Blizzard",
	["Blizzard AddOns"] = "暴雪插件",
	["Standard AddOns"] = "一般插件",
	["Load on Demand AddOns"] = "隨需求載入的插件",
	["Libraries"] = "程式庫",
	["Undefined"] = "未指定",
	["Unknown"] = "未知",

	-- Sets menu
	["Save"] = "存檔",
	["Rename"] = "重新命名",
	["Add to current selection"] = "加入目前的選擇",
	["Remove from current selection"] = "從目前的選擇中移除",
	["Set %d"] = "設定 %d",

	-- Confirmation popups
	["Reload your user interface?"] = "重載你的使用者介面？",
	["Save the current AddOn list to [%s]?"] = "將目前的插件清單儲存為[%s]？",
	["Enter the new name for [%s]:"] = "輸入[%s]的新名稱：",
	["ACP: Some protected AddOns are not enabled. Reload the UI now?"] = "ACP：部分受保護的插件沒有啟用。現在重載介面嗎？",

	-- Chat messages
	["AddOn set [%s] saved."] = "插件清單[%s]已儲存。",
	["AddOn set [%s] loaded."] = "插件清單[%s]已載入。",
	["AddOn set [%s] unloaded."] = "插件清單[%s]已卸載。",
	["AddOn set [%s] renamed to [%s]."] = "插件清單[%s]已重新命名為[%s]。",
	["%s is collapsed. Setting all of its AddOns to %s."] = "%s 已收合。其中所有插件將被設為 %s。",
	["ENABLED"] = "已啟用",
	["DISABLED"] = "已停用",
	["ON"] = "開",
	["OFF"] = "關",
	["Load on demand child enabling is now %s."] = "隨需求載入子插件的啟用：%s",
	["Recursive enabling is now %s."] = "遞迴啟用：%s",
	["Debug mode is now %s."] = "偵錯模式：%s",

	-- Slash commands  (/acp)
	["Valid commands:"] = "可用指令：",
	["Opens the AddOn Control Panel."] = "開啟插件管理面板。",
	["Toggles enabling of load on demand child AddOns."] = "切換隨需求載入子插件的啟用方式。",
	["Toggles recursive enabling of dependencies."] = "切換附屬插件的遞迴啟用。",
	["Toggles debug output."] = "切換偵錯訊息輸出。",
	["Shows this list."] = "顯示這個清單。",

	-- Tooltips
	["No information available."] = "沒有可用的資訊。",
	["Version"] = "版本",
	["Status"] = "狀態",
	["Dependencies"] = "附屬插件",
	["Embedded Libraries"] = "內嵌程式庫",
	["Active Embedded Libraries"] = "運行中的內嵌程式庫",
	["Memory Usage"] = "記憶體用量",
	["Compatible"] = "相容",
	["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."] = "點擊切換保護模式。受保護的插件在重載介面時會自動重新啟用。",
	["Use SHIFT to override the current dependency enabling behavior."] = "按住 SHIFT 可暫時反轉目前的附屬插件啟用方式。",

	-- AddOn status column
	["Loadable on demand"] = "可隨需求載入",
	["Disabled after Reload UI"] = "重載介面後將被停用",
	["Loaded"] = "已載入",
	["Loaded on demand."] = "隨需求載入。",

	-- Reserved: used by code paths that are currently commented out in ACP.lua
	["Reload"] = "重載",
	["*** Enabling <%s> %s your UI ***"] = "*** 啟用 <%s>，%s 你的介面 ***",
	["*** Unknown AddOn <%s> required ***"] = "*** 需要未知的插件 <%s> ***",
	["AddOn <%s> is not valid."] = "插件 <%s> 無效。",

	-- Manual language selector  (/acp locale, and the drop down in the window)
	["Language"] = "語言",
	["Automatic"] = "自動",
	["Detected locale: %s"] = "偵測到的語言：%s",
	["ACP locale: %s"] = "ACP 語言：%s",
	["Locale override: %s"] = "手動選擇：%s",
	["Locale %s is not registered."] = "語言 %s 未註冊。",
	["ACP language set to %s."] = "ACP 語言已切換為 %s。",
	["ACP language returned to automatic detection."] = "ACP 已恢復自動偵測。",
	["Reload the UI to apply the language change."] = "請重載介面以套用語言變更。",
	["Reload now"] = "立即重載",
	["Later"] = "稍後",
	["Valid locale commands:"] = "可用的語言指令：",
	["Shows the language ACP is using."] = "顯示 ACP 正在使用的語言。",
	["Forces a language."] = "強制指定語言。",
	["Returns to automatic detection."] = "恢復自動偵測。",

	-- Diagnostics. Only shown while /acp debug is on, or raised as Lua errors.
	["Untranslated key: %s"] = "未翻譯的鍵值：%s",
	["No untranslated key has been requested so far."] = "目前沒有請求過未翻譯的鍵值。",
	["No translation is registered for locale %s, using %s."] = "語言 %s 沒有註冊翻譯，改用 %s。",
	["Cannot find AddOn %s."] = "找不到插件 %s。",
	["GetAddonIndex(): addon must be a number or a string."] = "GetAddonIndex()：addon 必須是數字或字串。",

	-- Blizzard AddOn titles. Never translate the folder name on the left,
	-- only the descriptive title on the right.
	["Blizzard_AchievementUI"] = "Blizzard: 成就",
	["Blizzard_ArenaUI"] = "Blizzard: 競技場",
	["Blizzard_AuctionUI"] = "Blizzard: 拍賣場",
	["Blizzard_BarbershopUI"] = "Blizzard: 理髮廳",
	["Blizzard_BattlefieldMinimap"] = "Blizzard: 戰場小地圖",
	["Blizzard_BindingUI"] = "Blizzard: 按鍵設定",
	["Blizzard_Calendar"] = "Blizzard: 行事曆",
	["Blizzard_CombatLog"] = "Blizzard: 戰鬥記錄",
	["Blizzard_CombatText"] = "Blizzard: 戰鬥文字",
	["Blizzard_DebugTools"] = "Blizzard: 偵錯工具",
	["Blizzard_GlyphUI"] = "Blizzard: 雕紋",
	["Blizzard_GMChatUI"] = "Blizzard: GM 對話",
	["Blizzard_GMSurveyUI"] = "Blizzard: GM 問卷",
	["Blizzard_GuildBankUI"] = "Blizzard: 公會銀行",
	["Blizzard_InspectUI"] = "Blizzard: 觀察",
	["Blizzard_ItemSocketingUI"] = "Blizzard: 物品鑲嵌",
	["Blizzard_MacroUI"] = "Blizzard: 巨集",
	["Blizzard_RaidUI"] = "Blizzard: 團隊",
	["Blizzard_TalentUI"] = "Blizzard: 天賦",
	["Blizzard_TimeManager"] = "Blizzard: 時間管理",
	["Blizzard_TokenUI"] = "Blizzard: 貨幣",
	["Blizzard_TradeSkillUI"] = "Blizzard: 專業技能",
	["Blizzard_TrainerUI"] = "Blizzard: 訓練師",

})
