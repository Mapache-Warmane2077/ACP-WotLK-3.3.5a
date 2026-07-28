--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Localization: Hangugeo   (koKR)

	enUS is the canonical source. Any key that is missing here falls back
	to the enUS string automatically, so an incomplete file is safe.

	Keep every %s / %d / %% placeholder, every |cffxxxxxx colour code and
	every line break exactly as they appear in the enUS file.
----------------------------------------------------------------------]]

if not ACP or not ACP.RegisterLocale then return end

ACP:RegisterLocale("koKR", {

	-- Main window and buttons  (keep these short, the buttons are 80px wide)
	["AddOns"] = "애드온",
	["Load"] = "불러오기",
	["Disable All"] = "모두 사용 안 함",
	["Enable All"] = "모두 사용",
	["Reload UI"] = "UI 다시 불러오기",
	["Sets"] = "세트",
	["Close"] = "닫기",
	["Recursive"] = "재귀",

	-- Sorting criteria shown in the drop down menu
	["Default"] = "기본값",
	["Titles"] = "제목",
	["Ace2"] = "Ace2",
	["Author"] = "제작자",
	["Separate LoD List"] = "요청 시 불러오기 목록 분리",
	["Group By Name"] = "이름별 분류",

	-- Category headers built by ACP itself
	["Blizzard"] = "Blizzard",
	["Blizzard AddOns"] = "Blizzard 애드온",
	["Standard AddOns"] = "일반 애드온",
	["Load on Demand AddOns"] = "요청 시 불러오는 애드온",
	["Libraries"] = "라이브러리",
	["Undefined"] = "지정되지 않음",
	["Unknown"] = "알 수 없음",

	-- Sets menu
	["Save"] = "저장",
	["Rename"] = "이름 바꾸기",
	["Add to current selection"] = "현재 선택에 추가",
	["Remove from current selection"] = "현재 선택에서 제거",
	["Set %d"] = "세트 %d",

	-- Confirmation popups
	["Reload your user interface?"] = "사용자 인터페이스를 다시 불러올까요?",
	["Save the current AddOn list to [%s]?"] = "현재 애드온 목록을 [%s]에 저장할까요?",
	["Enter the new name for [%s]:"] = "[%s]의 새 이름 입력:",
	["ACP: Some protected AddOns are not enabled. Reload the UI now?"] = "ACP: 보호된 애드온 중 일부가 사용 설정되어 있지 않습니다. 지금 UI를 다시 불러올까요?",

	-- Chat messages
	["AddOn set [%s] saved."] = "애드온 세트 [%s]을(를) 저장했습니다.",
	["AddOn set [%s] loaded."] = "애드온 세트 [%s]을(를) 불러왔습니다.",
	["AddOn set [%s] unloaded."] = "애드온 세트 [%s]을(를) 해제했습니다.",
	["AddOn set [%s] renamed to [%s]."] = "애드온 세트 [%s]의 이름을 [%s](으)로 바꿨습니다.",
	["%s is collapsed. Setting all of its AddOns to %s."] = "%s이(가) 접혀 있습니다. 포함된 모든 애드온을 %s 상태로 설정합니다.",
	["ENABLED"] = "사용",
	["DISABLED"] = "사용 안 함",
	["ON"] = "켜짐",
	["OFF"] = "꺼짐",
	["Load on demand child enabling is now %s."] = "요청 시 불러오는 하위 애드온 사용 설정: %s",
	["Recursive enabling is now %s."] = "재귀 사용 설정: %s",
	["Debug mode is now %s."] = "디버그 모드: %s",

	-- Slash commands  (/acp)
	["Valid commands:"] = "사용 가능한 명령어:",
	["Opens the AddOn Control Panel."] = "Addon Control Panel을 엽니다.",
	["Toggles enabling of load on demand child AddOns."] = "요청 시 불러오는 하위 애드온의 사용 설정을 전환합니다.",
	["Toggles recursive enabling of dependencies."] = "의존 애드온의 재귀 사용 설정을 전환합니다.",
	["Toggles debug output."] = "디버그 메시지 출력을 전환합니다.",
	["Shows this list."] = "이 목록을 표시합니다.",

	-- Tooltips
	["No information available."] = "사용할 수 있는 정보가 없습니다.",
	["Version"] = "버전",
	["Status"] = "상태",
	["Dependencies"] = "의존 애드온",
	["Embedded Libraries"] = "내장 라이브러리",
	["Active Embedded Libraries"] = "활성 내장 라이브러리",
	["Memory Usage"] = "메모리 사용량",
	["Compatible"] = "호환됨",
	["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."] = "클릭하면 보호 모드를 전환합니다. 보호된 애드온은 UI를 다시 불러올 때 자동으로 다시 사용 설정됩니다.",
	["Use SHIFT to override the current dependency enabling behavior."] = "SHIFT 키를 사용하면 현재의 의존 애드온 사용 설정 방식을 반대로 적용합니다.",

	-- AddOn status column
	["Loadable on demand"] = "요청 시 불러올 수 있음",
	["Disabled after Reload UI"] = "UI를 다시 불러오면 사용 안 함",
	["Loaded"] = "불러옴",
	["Loaded on demand."] = "요청 시 불러옴.",

	-- Reserved: used by code paths that are currently commented out in ACP.lua
	["Reload"] = "다시 불러오기",
	["*** Enabling <%s> %s your UI ***"] = "*** <%s> 사용 설정 %s UI ***",
	["*** Unknown AddOn <%s> required ***"] = "*** 알 수 없는 애드온 <%s> 필요 ***",
	["AddOn <%s> is not valid."] = "애드온 <%s>이(가) 올바르지 않습니다.",

	-- Manual language selector  (/acp locale, and the drop down in the window)
	["Language"] = "언어",
	["Automatic"] = "자동",
	["Detected locale: %s"] = "감지된 언어: %s",
	["ACP locale: %s"] = "ACP 언어: %s",
	["Locale override: %s"] = "수동 선택: %s",
	["Locale %s is not registered."] = "%s 언어는 등록되어 있지 않습니다.",
	["ACP language set to %s."] = "ACP 언어를 %s(으)로 변경했습니다.",
	["ACP language returned to automatic detection."] = "ACP가 자동 감지로 돌아갔습니다.",
	["Reload the UI to apply the language change."] = "언어 변경을 적용하려면 UI를 다시 불러오세요.",
	["Reload now"] = "지금 다시 불러오기",
	["Later"] = "나중에",
	["Valid locale commands:"] = "사용 가능한 언어 명령어:",
	["Shows the language ACP is using."] = "ACP가 사용 중인 언어를 표시합니다.",
	["Forces a language."] = "언어를 강제로 지정합니다.",
	["Returns to automatic detection."] = "자동 감지로 되돌립니다.",

	-- Diagnostics. Only shown while /acp debug is on, or raised as Lua errors.
	["Untranslated key: %s"] = "번역되지 않은 키: %s",
	["No untranslated key has been requested so far."] = "지금까지 번역이 누락된 키가 요청되지 않았습니다.",
	["No translation is registered for locale %s, using %s."] = "%s 언어의 번역이 등록되어 있지 않아 %s을(를) 사용합니다.",
	["Cannot find AddOn %s."] = "애드온 %s을(를) 찾을 수 없습니다.",
	["GetAddonIndex(): addon must be a number or a string."] = "GetAddonIndex(): addon은 숫자나 문자열이어야 합니다.",

	-- Blizzard AddOn titles. Never translate the folder name on the left,
	-- only the descriptive title on the right.
	["Blizzard_AchievementUI"] = "Blizzard: 업적",
	["Blizzard_ArenaUI"] = "Blizzard: 투기장",
	["Blizzard_AuctionUI"] = "Blizzard: 경매장",
	["Blizzard_BarbershopUI"] = "Blizzard: 이발소",
	["Blizzard_BattlefieldMinimap"] = "Blizzard: 전장 미니맵",
	["Blizzard_BindingUI"] = "Blizzard: 단축키",
	["Blizzard_Calendar"] = "Blizzard: 달력",
	["Blizzard_CombatLog"] = "Blizzard: 전투 기록",
	["Blizzard_CombatText"] = "Blizzard: 전투 문자",
	["Blizzard_DebugTools"] = "Blizzard: 디버그 도구",
	["Blizzard_GlyphUI"] = "Blizzard: 문양",
	["Blizzard_GMChatUI"] = "Blizzard: GM 대화",
	["Blizzard_GMSurveyUI"] = "Blizzard: GM 설문",
	["Blizzard_GuildBankUI"] = "Blizzard: 길드 은행",
	["Blizzard_InspectUI"] = "Blizzard: 살펴보기",
	["Blizzard_ItemSocketingUI"] = "Blizzard: 보석 부착",
	["Blizzard_MacroUI"] = "Blizzard: 매크로",
	["Blizzard_RaidUI"] = "Blizzard: 공격대",
	["Blizzard_TalentUI"] = "Blizzard: 특성",
	["Blizzard_TimeManager"] = "Blizzard: 시간 관리",
	["Blizzard_TokenUI"] = "Blizzard: 화폐",
	["Blizzard_TradeSkillUI"] = "Blizzard: 전문 기술",
	["Blizzard_TrainerUI"] = "Blizzard: 교관",

})
