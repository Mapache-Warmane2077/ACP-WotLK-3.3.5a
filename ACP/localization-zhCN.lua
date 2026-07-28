--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Localization: Simplified Chinese   (zhCN)

	enUS is the canonical source. Any key that is missing here falls back
	to the enUS string automatically, so an incomplete file is safe.

	Keep every %s / %d / %% placeholder, every |cffxxxxxx colour code and
	every line break exactly as they appear in the enUS file.
----------------------------------------------------------------------]]

if not ACP or not ACP.RegisterLocale then return end

ACP:RegisterLocale("zhCN", {

	-- Main window and buttons  (keep these short, the buttons are 80px wide)
	["AddOns"] = "插件",
	["Load"] = "加载",
	["Disable All"] = "全部禁用",
	["Enable All"] = "全部启用",
	["Reload UI"] = "重载界面",
	["Sets"] = "配置",
	["Close"] = "关闭",
	["Recursive"] = "递归",

	-- Sorting criteria shown in the drop down menu
	["Default"] = "默认",
	["Titles"] = "名称",
	["Ace2"] = "Ace2",
	["Author"] = "作者",
	["Separate LoD List"] = "单独列出按需加载",
	["Group By Name"] = "按名称分组",

	-- Category headers built by ACP itself
	["Blizzard"] = "Blizzard",
	["Blizzard AddOns"] = "暴雪插件",
	["Standard AddOns"] = "普通插件",
	["Load on Demand AddOns"] = "按需加载的插件",
	["Libraries"] = "库",
	["Undefined"] = "未指定",
	["Unknown"] = "未知",

	-- Sets menu
	["Save"] = "保存",
	["Rename"] = "重命名",
	["Add to current selection"] = "添加到当前选择",
	["Remove from current selection"] = "从当前选择中移除",
	["Set %d"] = "配置 %d",

	-- Confirmation popups
	["Reload your user interface?"] = "重载你的用户界面？",
	["Save the current AddOn list to [%s]?"] = "将当前插件列表保存为[%s]？",
	["Enter the new name for [%s]:"] = "输入[%s]的新名称：",
	["ACP: Some protected AddOns are not enabled. Reload the UI now?"] = "ACP：部分受保护的插件没有启用。现在重载界面吗？",

	-- Chat messages
	["AddOn set [%s] saved."] = "插件配置[%s]已保存。",
	["AddOn set [%s] loaded."] = "插件配置[%s]已加载。",
	["AddOn set [%s] unloaded."] = "插件配置[%s]已卸载。",
	["AddOn set [%s] renamed to [%s]."] = "插件配置[%s]已重命名为[%s]。",
	["%s is collapsed. Setting all of its AddOns to %s."] = "%s 已折叠。其中所有插件将被设置为 %s。",
	["ENABLED"] = "已启用",
	["DISABLED"] = "已禁用",
	["ON"] = "开",
	["OFF"] = "关",
	["Load on demand child enabling is now %s."] = "按需加载子插件的启用：%s",
	["Recursive enabling is now %s."] = "递归启用：%s",
	["Debug mode is now %s."] = "调试模式：%s",

	-- Slash commands  (/acp)
	["Valid commands:"] = "可用命令：",
	["Opens the AddOn Control Panel."] = "打开插件管理面板。",
	["Toggles enabling of load on demand child AddOns."] = "切换按需加载子插件的启用方式。",
	["Toggles recursive enabling of dependencies."] = "切换依赖插件的递归启用。",
	["Toggles debug output."] = "切换调试信息输出。",
	["Shows this list."] = "显示此列表。",

	-- Tooltips
	["No information available."] = "没有可用信息。",
	["Version"] = "版本",
	["Status"] = "状态",
	["Dependencies"] = "依赖",
	["Embedded Libraries"] = "内嵌库",
	["Active Embedded Libraries"] = "生效的内嵌库",
	["Memory Usage"] = "内存占用",
	["Compatible"] = "兼容",
	["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."] = "点击切换保护模式。受保护的插件在重载界面时会自动重新启用。",
	["Use SHIFT to override the current dependency enabling behavior."] = "按住 SHIFT 可临时反转当前的依赖启用方式。",

	-- AddOn status column
	["Loadable on demand"] = "可按需加载",
	["Disabled after Reload UI"] = "重载界面后将被禁用",
	["Loaded"] = "已加载",
	["Loaded on demand."] = "按需加载。",

	-- Reserved: used by code paths that are currently commented out in ACP.lua
	["Reload"] = "重载",
	["*** Enabling <%s> %s your UI ***"] = "*** 启用 <%s>，%s 你的界面 ***",
	["*** Unknown AddOn <%s> required ***"] = "*** 需要未知插件 <%s> ***",
	["AddOn <%s> is not valid."] = "插件 <%s> 无效。",

	-- Manual language selector  (/acp locale, and the drop down in the window)
	["Language"] = "语言",
	["Automatic"] = "自动",
	["Detected locale: %s"] = "检测到的语言：%s",
	["ACP locale: %s"] = "ACP 语言：%s",
	["Locale override: %s"] = "手动选择：%s",
	["Locale %s is not registered."] = "语言 %s 未注册。",
	["ACP language set to %s."] = "ACP 语言已切换为 %s。",
	["ACP language returned to automatic detection."] = "ACP 已恢复自动检测。",
	["Reload the UI to apply the language change."] = "请重载界面以应用语言更改。",
	["Reload now"] = "立即重载",
	["Later"] = "稍后",
	["Valid locale commands:"] = "可用的语言命令：",
	["Shows the language ACP is using."] = "显示 ACP 正在使用的语言。",
	["Forces a language."] = "强制指定语言。",
	["Returns to automatic detection."] = "恢复自动检测。",

	-- Diagnostics. Only shown while /acp debug is on, or raised as Lua errors.
	["Untranslated key: %s"] = "未翻译的键：%s",
	["No untranslated key has been requested so far."] = "目前没有请求过未翻译的键。",
	["No translation is registered for locale %s, using %s."] = "语言 %s 没有注册翻译，改用 %s。",
	["Cannot find AddOn %s."] = "找不到插件 %s。",
	["GetAddonIndex(): addon must be a number or a string."] = "GetAddonIndex()：addon 必须是数字或字符串。",

	-- Blizzard AddOn titles. Never translate the folder name on the left,
	-- only the descriptive title on the right.
	["Blizzard_AchievementUI"] = "Blizzard: 成就",
	["Blizzard_ArenaUI"] = "Blizzard: 竞技场",
	["Blizzard_AuctionUI"] = "Blizzard: 拍卖行",
	["Blizzard_BarbershopUI"] = "Blizzard: 理发店",
	["Blizzard_BattlefieldMinimap"] = "Blizzard: 战场小地图",
	["Blizzard_BindingUI"] = "Blizzard: 按键设置",
	["Blizzard_Calendar"] = "Blizzard: 日历",
	["Blizzard_CombatLog"] = "Blizzard: 战斗记录",
	["Blizzard_CombatText"] = "Blizzard: 战斗文字",
	["Blizzard_DebugTools"] = "Blizzard: 调试工具",
	["Blizzard_GlyphUI"] = "Blizzard: 雕文",
	["Blizzard_GMChatUI"] = "Blizzard: GM 对话",
	["Blizzard_GMSurveyUI"] = "Blizzard: GM 调查",
	["Blizzard_GuildBankUI"] = "Blizzard: 公会银行",
	["Blizzard_InspectUI"] = "Blizzard: 观察",
	["Blizzard_ItemSocketingUI"] = "Blizzard: 物品镶嵌",
	["Blizzard_MacroUI"] = "Blizzard: 宏",
	["Blizzard_RaidUI"] = "Blizzard: 团队",
	["Blizzard_TalentUI"] = "Blizzard: 天赋",
	["Blizzard_TimeManager"] = "Blizzard: 时间管理",
	["Blizzard_TokenUI"] = "Blizzard: 货币",
	["Blizzard_TradeSkillUI"] = "Blizzard: 专业技能",
	["Blizzard_TrainerUI"] = "Blizzard: 训练师",

})
