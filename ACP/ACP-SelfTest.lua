--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Automated self test

	This file is NOT listed in ACP.toc and is never read by World of
	Warcraft. It is a command line harness that stubs the small part of the
	WoW API that ACP touches at load time and then exercises the addon:

	    cd <the ACP folder>
	    lua5.1 ACP-SelfTest.lua          (or: texlua ACP-SelfTest.lua)

	Exit code is 0 when every test passes, 1 otherwise.

	Covered:
	  1. A translation read before ACP:UpdateLocale is replaced afterwards.
	  2. An unknown locale code falls back to enUS and warns only once.
	  3. Renaming a set to an empty name shows "Set 1", never nil.
	  4. Every sorter name ACP 3.3.7 could have saved still migrates.
	  5. ACP_Data.NoRecurse and the Recursive check button stay in sync.
	  6. All 13 languages share the same keys and the same placeholders.
	  7. A real ACP 3.3.7 translation table still translates 3.3.8.
	  8. A normal addon whose folder matches a locale key keeps its title.
	  9. OnLoad never writes to the global _.
	 10. Manual language selection and ACP_Data.localeOverride.
	 11. The language drop down in the window.

	These are logic tests outside the game. They do NOT replace the in game
	test plan in CHANGELOG-ACP-3.3.8-WotLK.txt.
----------------------------------------------------------------------]]

local DIR = "./"
if arg and arg[0] then
	DIR = arg[0]:match("^(.*[/\\])") or "./"
end

local CODES = { "enUS", "enGB", "enCN", "deDE", "frFR", "esES", "esMX",
                "ptBR", "itIT", "ruRU", "koKR", "zhCN", "zhTW" }

--------------------------------------------------------------------------
-- Tiny test framework
--------------------------------------------------------------------------
local passed, failed = 0, 0

local function check(name, ok, detail)
	if ok then
		passed = passed + 1
		print(string.format("  PASS  %s", name))
	else
		failed = failed + 1
		print(string.format("  FAIL  %s%s", name, detail and ("  <-- " .. detail) or ""))
	end
end

local function section(title)
	print("")
	print(title)
end

--------------------------------------------------------------------------
-- Stub of the WoW API that ACP uses while its files are being loaded
--------------------------------------------------------------------------
local chat = {}

local function stringExtensions()
	local meta = getmetatable("")
	meta.__index.trim = function(s)
		return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
	end
end

local function stubWoW(locale)
	stringExtensions()

	_G.GetLocale = function() return locale end

	_G.DEFAULT_CHAT_FRAME = {
		AddMessage = function(self, msg)
			chat[#chat + 1] = msg
		end,
	}

	_G.strlen = string.len
	_G.strsplit = function(sep, str)
		local out = {}
		local pattern = "([^" .. sep .. "]*)"
		for piece in string.gmatch(str, pattern) do
			out[#out + 1] = piece
		end
		return unpack and unpack(out) or table.unpack(out)
	end

	-- Not called during load, present so a stray call fails loudly instead
	-- of silently indexing nil.
	_G.GetNumAddOns = function() return 0 end
	_G.GetAddOnInfo = function() return nil end
	_G.GetAddOnMetadata = function() return nil end
	_G.IsAddOnLoaded = function() return false end
	_G.IsAddOnLoadOnDemand = function() return false end
	_G.GetBuildInfo = function() return "3.3.5", "12340", "2010", 30300 end
end

--- Loads the localization core plus every language file from scratch.
local function loadLocales(locale)
	_G.ACP = nil
	stubWoW(locale)
	dofile(DIR .. "ACP-Locale.lua")
	for _, code in ipairs(CODES) do
		dofile(DIR .. "localization-" .. code .. ".lua")
	end
end

--- Same, plus ACP.lua itself.
local function loadAddon(locale)
	loadLocales(locale)
	dofile(DIR .. "ACP.lua")
end

local function lastChat()
	return chat[#chat] or ""
end

--------------------------------------------------------------------------
-- 1. Translation cache invalidation
--------------------------------------------------------------------------
local function test1()
	section("1. A key read before UpdateLocale must change afterwards")

	loadLocales("esES")

	-- The exact snippet from the review, kept verbatim.
	local before = ACP.L["Close"]
	ACP:UpdateLocale({ ["Close"] = "TEST OVERRIDE" })
	local ok = pcall(function()
		assert(ACP.L["Close"] == "TEST OVERRIDE")
	end)
	check("read, then UpdateLocale, then read again", ok,
	      string.format("before=%q after=%q", before, tostring(ACP.L["Close"])))
	check("the value really was translated before the override",
	      before == "Cerrar", string.format("got %q", before))

	-- The fallback chain must be intact after the invalidation.
	loadLocales("esES")
	check("active locale wins", ACP.L["Close"] == "Cerrar")
	check("enUS fallback for a key the language lacks",
	      (function()
	          ACP:RegisterLocale("esES", { ["OnlyInThisTest"] = "" })
	          return ACP.L["Ace2"] == "Ace2"
	      end)())
	check("unknown key falls back to the key itself",
	      ACP.L["No such key at all"] == "No such key at all")

	-- RegisterLocale must invalidate too, not only UpdateLocale.
	loadLocales("deDE")
	local first = ACP.L["Sets"]
	ACP:RegisterLocale("deDE", { ["Sets"] = "REGISTERED" })
	check("RegisterLocale also invalidates",
	      first == "Sets" and ACP.L["Sets"] == "REGISTERED",
	      string.format("first=%q now=%q", first, ACP.L["Sets"]))
end

--------------------------------------------------------------------------
-- 2. Unknown locale code
--------------------------------------------------------------------------
local function test2()
	section("2. An unknown locale falls back to enUS")

	loadLocales("plPL")

	check("no file registered for the detected locale",
	      ACP:IsLocaleRegistered() == false)
	check("GetDetectedLocale reports what WoW said",
	      ACP:GetDetectedLocale() == "plPL")
	-- GetActiveLocale is the EFFECTIVE locale, which is what ACP really uses.
	check("the effective locale falls back to enUS",
	      ACP:GetEffectiveLocale() == "enUS" and ACP:GetActiveLocale() == "enUS",
	      ACP:GetEffectiveLocale())
	check("strings come from enUS", ACP.L["Close"] == "Close")
	check("no table was invented for the unknown code",
	      ACP.Locales["plPL"] == nil)
	check("GetLocaleString reads the effective locale",
	      ACP:GetLocaleString("Close") == "Close")
	check("unknown key still returns the key",
	      ACP.L["Nope"] == "Nope")

	ACP.debug = true
	local n = #chat
	local firstCall = ACP:WarnUnknownLocale()
	local secondCall = ACP:WarnUnknownLocale()
	check("the warning is emitted once and only once",
	      firstCall == true and secondCall == false and (#chat - n) == 1,
	      string.format("messages added: %d", #chat - n))
	check("the warning names the locale and the fallback",
	      lastChat():find("plPL", 1, true) ~= nil and
	      lastChat():find("enUS", 1, true) ~= nil, lastChat())

	-- A registered locale must never warn.
	loadLocales("frFR")
	ACP.debug = true
	check("a known locale produces no warning",
	      ACP:WarnUnknownLocale() == false)

	-- The "untranslated key" report is itself localized, and translating it
	-- must not recurse back into ACP.L.
	loadLocales("esES")
	ACP.debug = true
	local n2 = #chat
	local value = ACP.L["A key nobody ever defined"]
	check("an unresolved key is reported once while debugging",
	      value == "A key nobody ever defined" and (#chat - n2) == 1,
	      string.format("value=%q messages=%d", tostring(value), #chat - n2))
	check("the report itself is translated",
	      lastChat():find("Clave sin traducir", 1, true) ~= nil, lastChat())
	local _ = ACP.L["A key nobody ever defined"]
	check("and it is not repeated", (#chat - n2) == 1)
	check("ReportMissingLocaleKeys finds it",
	      ACP:ReportMissingLocaleKeys() >= 1)

	ACP.debug = false
	local n3 = #chat
	local _ = ACP.L["Another key nobody defined"]
	check("nothing is printed when debugging is off", #chat == n3)
end

--------------------------------------------------------------------------
-- 3. Renaming a set to an empty name
--------------------------------------------------------------------------
local function test3()
	section("3. Clearing a set name shows Set N, not nil")

	loadAddon("enUS")

	ACP:RenameSet(1, "My raid set")
	check("naming a set is reported", lastChat():find("My raid set", 1, true) ~= nil,
	      lastChat())

	ACP:RenameSet(1, nil)
	local msg = lastChat()
	check("the new name is Set 1", msg:find("[Set 1]", 1, true) ~= nil, msg)
	check("nil never reaches the message", msg:find("nil", 1, true) == nil, msg)
	check("GetSetName agrees", ACP:GetSetName(1) == "Set 1",
	      tostring(ACP:GetSetName(1)))

	ACP:RenameSet(3, nil)
	check("and for another slot", ACP:GetSetName(3) == "Set 3",
	      tostring(ACP:GetSetName(3)))
end

--------------------------------------------------------------------------
-- 4. Migration of every historic ACP_Data.sorter value
--------------------------------------------------------------------------
-- Every string ACP 3.3.7 could write into ACP_Data.sorter. Taken from the
-- GetLocale() if/elseif block at the top of the 3.3.7 ACP.lua.
local HISTORIC_SORTERS = {
	-- enUS, deDE and every locale 3.3.7 left untranslated
	"Default", "Titles", "Ace2", "Author", "Separate LOD List", "Group By Name",
	-- zhCN
	"默认", "名称", "作者", "按需求加载", "按名称分组",
	-- zhTW
	"預設", "名稱", "隨需求載入", "以名稱分組",
	-- koKR
	"기본", "제목", "제작자", "LOD 목록 분리", "이름별 분류",
	-- frFR
	"Défaut", "Titres", "Auteur", "Liste LOD séparée", "Groupement par nom",
	-- esES (the mojibake in "T?tulos" is what 3.3.7 actually shipped)
	"Por Defecto", "T?tulos", "Autor", "Lista CaD por separado", "Agrupar por nombre",
	-- ruRU
	"По умолчанию", "Заголовкам", "Автор", "Отдел. список ЗПТ", "Группир. по имени",
}

local function test4()
	section("4. Every sorter name saved by 3.3.7 still migrates")

	loadAddon("enUS")

	local bad = {}
	for _, name in ipairs(HISTORIC_SORTERS) do
		local key = ACP:MigrateSorterName(name)
		if key == nil or ACP.addonListBuilders[key] == nil then
			bad[#bad + 1] = name
		end
	end
	check(string.format("%d historic values map to a live builder", #HISTORIC_SORTERS),
	      #bad == 0, table.concat(bad, ", "))

	check("a current key maps to itself",
	      ACP:MigrateSorterName("Group By Name") == "Group By Name")
	check("the renamed key is reachable",
	      ACP:MigrateSorterName("Separate LOD List") == "Separate LoD List")
	check("an unknown value returns nil so the caller uses the default",
	      ACP:MigrateSorterName("something else entirely") == nil)
	check("a non string returns nil", ACP:MigrateSorterName(42) == nil)
end

--------------------------------------------------------------------------
-- 5. NoRecurse and the check button stay in sync
--------------------------------------------------------------------------
local function test5()
	section("5. /acp norecurse drives the same code as the check button")

	loadAddon("enUS")

	local checkbox = {
		checked = nil,
		SetChecked = function(self, value) self.checked = value and true or false end,
		GetChecked = function(self) return self.checked end,
	}
	_G["ACP_AddonList_NoRecurse"] = checkbox

	-- RenameSet is the cheapest way to make ACP.lua create its savedVar
	-- without running the whole VARIABLES_LOADED path.
	ACP:RenameSet(1, nil)

	local states = {}
	for i = 1, 4 do
		ACP.SlashHandler("norecurse")
		local msg = lastChat()
		local saysOn = msg:find("ON", 1, true) ~= nil
		local saysOff = msg:find("OFF", 1, true) ~= nil
		-- "OFF" also contains "OF", make the test unambiguous
		if saysOff then saysOn = false end
		states[i] = { checked = checkbox.checked, saysOn = saysOn }
		check(string.format("toggle %d: check button matches the message", i),
		      checkbox.checked == saysOn,
		      string.format("checkbox=%s message=%q", tostring(checkbox.checked), msg))
	end

	check("consecutive toggles alternate",
	      states[1].checked ~= states[2].checked and
	      states[2].checked ~= states[3].checked and
	      states[3].checked ~= states[4].checked)
	check("two toggles return to the starting state",
	      states[1].checked == states[3].checked)

	-- Same through the public function, which is what the XML OnClick calls
	-- with the new state of the check button: checked means "recurse", which
	-- is stored inverted as NoRecurse.
	ACP:ToggleRecursion(true)
	check("ToggleRecursion(true) leaves the box checked",
	      checkbox.checked == true)
	ACP:ToggleRecursion(false)
	check("ToggleRecursion(false) leaves the box unchecked",
	      checkbox.checked == false)
	ACP:ToggleRecursion(true)
	ACP.SlashHandler("norecurse")
	check("the slash command flips what the button had just set",
	      checkbox.checked == false,
	      tostring(checkbox.checked))

	-- With no window created at all, nothing may blow up.
	_G["ACP_AddonList_NoRecurse"] = nil
	local ok = pcall(function() ACP.SlashHandler("norecurse") end)
	check("works with the window never created", ok)
end

--------------------------------------------------------------------------
-- 6. Key and placeholder parity across the 13 languages
--------------------------------------------------------------------------
local function placeholders(s)
	local found = {}
	for ph in string.gmatch(s, "%%[%a%%]") do
		found[#found + 1] = ph
	end
	table.sort(found)
	return table.concat(found, " ")
end

local function test6()
	section("6. All 13 languages share keys and placeholders")

	local collected = {}
	for _, code in ipairs(CODES) do
		_G.ACP = {
			RegisterLocale = function(self, c, tbl)
				collected[c] = tbl
				return true
			end,
		}
		dofile(DIR .. "localization-" .. code .. ".lua")
	end

	local base = collected.enUS
	check("enUS loaded", base ~= nil)
	if not base then return end

	local baseCount = 0
	for _ in pairs(base) do baseCount = baseCount + 1 end
	print(string.format("        enUS defines %d keys", baseCount))

	for _, code in ipairs(CODES) do
		local t = collected[code]
		if not t then
			check(code .. ": file registered a table", false)
		else
			local missing, extra, badPh, empty = {}, {}, {}, {}
			for k, v in pairs(base) do
				if t[k] == nil then
					missing[#missing + 1] = k
				elseif placeholders(t[k]) ~= placeholders(v) then
					badPh[#badPh + 1] = k
				end
			end
			for k, v in pairs(t) do
				if base[k] == nil then extra[#extra + 1] = k end
				if v == "" then empty[#empty + 1] = k end
			end
			check(string.format("%s: %d keys, no missing / extra / empty / placeholder issue", code, baseCount),
			      #missing == 0 and #extra == 0 and #badPh == 0 and #empty == 0,
			      string.format("missing=%d extra=%d placeholders=%d empty=%d",
			                    #missing, #extra, #badPh, #empty))
		end
	end

	-- Restore a usable ACP for anything that runs after this test.
	loadLocales("enUS")
end

--------------------------------------------------------------------------
-- 7. A real ACP 3.3.7 localization table still works
--------------------------------------------------------------------------
-- Verbatim copy of the table in localization-esES.lua of ACP 3.3.7,
-- including the mojibake it actually shipped with. Nothing was corrected.
local LEGACY_ESES_337 = {
	["*** Enabling <%s> %s your UI ***"] = "*** Activando <%s> %s su IU ***",
	["*** Unknown Addon <%s> Required ***"] = "*** Accesorio desconocido <%s> requerido ***",
	["ACP: Some protected addons aren't loaded. Reload now?"] = "ACP: Algunos accesorios protegidos no se encuentran cargados. ?Recargar ahora?",
	["Add to current selection"] = "A?adir a la selección actual",
	["AddOns"] = "Accesorios",
	["Addon <%s> not valid"] = "Accesorio <%s> incorrecto",
	["Addons [%s] Loaded."] = "Accesorios [%s] cargados.",
	["Addons [%s] Saved."] = "Accesorios [%s] grabados.",
	["Addons [%s] Unloaded."] = "Accesorios [%s] descargados.",
	["Addons [%s] renamed to [%s]."] = "Accesorios [%s] renombrados a [%s].",
	["Author"] = "Autor",
	["Blizzard_AchievementUI"] = "Blizzard: Achievement",
	["Blizzard_AuctionUI"] = "Blizzard: Subasta",
	["Blizzard_BarbershopUI"] = "Blizzard: Barbershop",
	["Blizzard_BattlefieldMinimap"] = "Blizzard: Minimapa del Campo de Batalla",
	["Blizzard_BindingUI"] = "Blizzard: Asignación",
	["Blizzard_Calendar"] = "Blizzard: Calendar",
	["Blizzard_CombatLog"] = "Blizzard: Combat Log",
	["Blizzard_CombatText"] = "Blizzard: Texto de Combate",
	["Blizzard_FeedbackUI"] = "Blizzard: Feedback",
	["Blizzard_GMSurveyUI"] = "Blizzard: Ayuda GM",
	["Blizzard_GlyphUI"] = "Blizzard: Glyph",
	["Blizzard_GuildBankUI"] = "Blizzard: GuildBank",
	["Blizzard_InspectUI"] = "Blizzard: Inspeción",
	["Blizzard_ItemSocketingUI"] = "Blizzard: Colocación de objetos",
	["Blizzard_MacroUI"] = "Blizzard: Macro",
	["Blizzard_RaidUI"] = "Blizzard: Raid",
	["Blizzard_TalentUI"] = "Blizzard: Talento",
	["Blizzard_TimeManager"] = "Blizzard: TimeManager",
	["Blizzard_TokenUI"] = "Blizzard: Token",
	["Blizzard_TradeSkillUI"] = "Blizzard: Profesión",
	["Blizzard_TrainerUI"] = "Blizzard: Profesor",
	["Blizzard_VehicleUI"] = "Blizzard: Vehicle",
	["Click to enable protect mode. Protected addons will not be disabled"] = "Clic para activar el modo protegido. Los accesorios protegidos no seran deshabilitados",
	["Default"] = "Por defecto",
	["Dependencies"] = "Dependencias",
	["Disable All"] = "---",
	["Disabled on reloadUI"] = "Desactivar al RecargarIU",
	["Embeds"] = "Inclusiones",
	["Enable All"] = "+++",
	["Enter the new name for [%s]:"] = "Escriba el nuevo nombre para [%s]:",
	["LoD Child Enable is now %s"] = "La Activación de los Hijos CaD es ahora %s",
	["Load"] = "Cargar ",
	["Loadable OnDemand"] = "Cargable a demanda",
	["Loaded"] = "Cargado",
	["Loaded on demand."] = "Cargar a demanda.",
	["No information available."] = "No hay información disponible.",
	["Recursive"] = "Recursivo",
	["Recursive Enable is now %s"] = "La Activación Recursiva es ahora %s",
	["Reload"] = "Recargar",
	["Reload your User Interface?"] = "?Recargar la Interfaz de Usuario?",
	["ReloadUI"] = "RecargarIU",
	["Remove from current selection"] = "Eliminar de la selección actual",
	["Rename"] = "Renombrar ",
	["Save"] = "Grabar ",
	["Save the current addon list to [%s]?"] = "?Grabar la lista actual de accesorios en [%s]?",
	["Set "] = "Perfil ",
	["Sets"] = "Perfiles",
	["Status"] = "Estado",
	["Use SHIFT to override the current enabling of dependancies behaviour."] = "Utilice MAY para reemplazar el comportamiento de activaci?n de dependencias actual.",
	["Version"] = "Versión",
	["when performing a reloadui."] = "cuando realice RecargarIU.",
}

local function test7()
	section("7. An ACP 3.3.7 translation table still translates 3.3.8")

	-- Worst case: a locale ACP 3.3.8 does not ship, so nothing but the old
	-- table can supply a translation. Without key normalization every
	-- assertion below would fall back to the English key.
	loadLocales("plPL")
	ACP:UpdateLocale(LEGACY_ESES_337)

	local ok = pcall(function()
		assert(ACP.L["Reload UI"] ~= "Reload UI")
		assert(ACP.L["Embedded Libraries"] ~= "Embedded Libraries")
		assert(ACP.L["AddOn set [%s] saved."] ~= "AddOn set [%s] saved.")
		assert(ACP.L["Set %d"]:format(1):find("1", 1, true))
	end)
	check("the four assertions from the review", ok)

	check("ReloadUI -> Reload UI", ACP.L["Reload UI"] == "RecargarIU",
	      ACP.L["Reload UI"])
	check("Embeds -> Embedded Libraries",
	      ACP.L["Embedded Libraries"] == "Inclusiones",
	      ACP.L["Embedded Libraries"])
	check("Active Embeds -> Active Embedded Libraries falls back cleanly",
	      ACP.L["Active Embedded Libraries"] == "Active Embedded Libraries",
	      ACP.L["Active Embedded Libraries"])
	check("Addons [%s] Saved. -> AddOn set [%s] saved.",
	      ACP.L["AddOn set [%s] saved."] == "Accesorios [%s] grabados.",
	      ACP.L["AddOn set [%s] saved."])
	check("Set  -> Set %d keeps the placeholder",
	      ACP.L["Set %d"] == "Perfil %d" and ACP.L["Set %d"]:format(7) == "Perfil 7",
	      ACP.L["Set %d"])
	check("dependancies typo key is mapped",
	      ACP.L["Use SHIFT to override the current dependency enabling behavior."]
	          ~= "Use SHIFT to override the current dependency enabling behavior.")
	check("LoD message keeps its %s",
	      select(2, ACP.L["Load on demand child enabling is now %s."]:gsub("%%s", "")) == 1,
	      ACP.L["Load on demand child enabling is now %s."])

	-- The two line tooltip must become one clean sentence.
	local merged = ACP.L[
		"Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."]
	check("the split tooltip is merged",
	      merged:find("Clic para activar", 1, true) ~= nil and
	      merged:find("cuando realice", 1, true) ~= nil, merged)
	check("no double space and no nil in the merged tooltip",
	      merged:find("  ", 1, true) == nil and merged:find("nil", 1, true) == nil,
	      merged)

	-- The old key has to stay readable for anything that still asks for it.
	check("the 3.3.7 key is still available",
	      ACP.L["ReloadUI"] == "RecargarIU", ACP.L["ReloadUI"])

	-- An explicit new key always wins over the alias.
	loadLocales("plPL")
	ACP:UpdateLocale({ ["ReloadUI"] = "OLD VALUE", ["Reload UI"] = "NEW VALUE" })
	check("an explicit new key beats the alias",
	      ACP.L["Reload UI"] == "NEW VALUE", ACP.L["Reload UI"])

	-- Only one of the two tooltip halves present must not produce nil.
	loadLocales("plPL")
	ACP:UpdateLocale({
		["Click to enable protect mode. Protected addons will not be disabled"] = "Solo la primera",
	})
	check("half a tooltip is still a string",
	      ACP.L["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."]
	          == "Solo la primera")

	-- And the aliases must not leak into the canonical files.
	loadLocales("esES")
	check("canonical esES is untouched by the aliases",
	      ACP.L["Reload UI"] == "Recargar IU" and ACP.L["ReloadUI"] == "ReloadUI",
	      ACP.L["Reload UI"] .. " / " .. ACP.L["ReloadUI"])
end

--------------------------------------------------------------------------
-- 8. A normal addon called "Author" keeps its own title
--------------------------------------------------------------------------
local function stubAddonUniverse()
	local addons = {
		[1] = { "Author", "Original AddOn Title" },
		[2] = { "Normal", "Normal Title" },
	}
	local byName = {}
	for i, a in ipairs(addons) do byName[a[1]] = i end

	_G.GetNumAddOns = function() return #addons end
	_G.GetAddOnInfo = function(key)
		local entry
		if type(key) == "number" then
			entry = addons[key]
		else
			entry = addons[byName[key] or -1]
			if not entry and type(key) == "string" and key:sub(1, 9) == "Blizzard_" then
				entry = { key, "Blizzard stock title" }
			end
		end
		if not entry then return nil end
		return entry[1], entry[2], "notes", 1, 1, nil, "SECURE"
	end
	_G.GetAddOnMetadata = function() return nil end
	_G.GetAddOnDependencies = function() return end
	_G.GetAddOnMemoryUsage = function() return 128 end
	_G.IsAddOnLoaded = function() return true end
	_G.IsAddOnLoadOnDemand = function() return false end
	_G.NO, _G.YES = "No", "Yes"

	local tip = { lines = {} }
	function tip:SetOwner() self.lines = {} end
	function tip:AddLine(text) self.lines[#self.lines + 1] = tostring(text) end
	function tip:Show() end
	function tip:Hide() end
	_G.GameTooltip = tip
	return tip
end

local function test8()
	section("8. A normal addon named like a locale key keeps its title")

	loadAddon("esES")
	local tip = stubAddonUniverse()

	-- OnLoad normally builds this reverse map; do the same here.
	local bz = ACP.ACP_BLIZZARD_ADDONS
	for i, v in ipairs(bz) do bz[v] = i end

	check("the locale really would collide",
	      ACP:GetLocaleString("Author") == "Autor",
	      tostring(ACP:GetLocaleString("Author")))

	ACP:ShowTooltip({}, 1)
	check("folder 'Author' keeps its real title",
	      tip.lines[1] == "Original AddOn Title", tip.lines[1])

	ACP:ShowTooltip({}, 2)
	check("an ordinary addon is unaffected",
	      tip.lines[1] == "Normal Title", tip.lines[1])

	-- Blizzard rows must still get the friendly localized title, both when
	-- they arrive as a number and when they arrive as a folder name.
	ACP:ShowTooltip({}, ACP.ACP_BLIZZARD_ADDONS["Blizzard_AuctionUI"] + 2)
	check("a Blizzard row by index is still localized",
	      tip.lines[1] == "Blizzard: Casa de subastas", tip.lines[1])

	ACP:ShowTooltip({}, "Blizzard_AuctionUI")
	check("a Blizzard row by folder name is still localized",
	      tip.lines[1] == "Blizzard: Casa de subastas", tip.lines[1])

	-- Every other locale key that could collide with a folder name.
	for _, folder in ipairs({ "Status", "Default", "Libraries", "Reload", "Unknown" }) do
		addonsProbe = folder
		_G.GetAddOnInfo = function(key)
			if key == 1 or key == folder then
				return folder, "Real title of " .. folder, "notes", 1, 1, nil, "SECURE"
			end
			return nil
		end
		ACP:ShowTooltip({}, 1)
		check("folder '" .. folder .. "' keeps its real title",
		      tip.lines[1] == "Real title of " .. folder, tip.lines[1])
	end
end

--------------------------------------------------------------------------
-- 9. OnLoad must not write to the global _
--------------------------------------------------------------------------
local function widget()
	local w = {}
	function w:SetText() end
	function w:GetText() return "" end
	function w:Show() end
	function w:Hide() end
	function w:IsShown() return false end
	function w:SetChecked(v) self.checked = v end
	function w:GetChecked() return self.checked end
	function w:RegisterEvent() end
	function w:UnregisterEvent() end
	function w:SetWidth() end
	function w:SetHeight() end
	function w:SetPoint() end
	function w:SetTexture() end
	function w:SetTextColor() end
	function w:GetName() return "fake" end
	return w
end

local function test9()
	section("9. OnLoad does not touch the global _")

	loadAddon("enUS")
	stubAddonUniverse()

	for _, name in ipairs({
		"GameMenuButtonAddOns", "ACP_AddonList", "ACP_AddonListDisableAll",
		"ACP_AddonListEnableAll", "ACP_AddonListSetButton",
		"ACP_AddonList_ReloadUI", "ACP_AddonListBottomClose",
		"ACP_AddonList_NoRecurseText", "ACP_AddonList_NoRecurse",
		"ACP_AddonListHeaderTitle",
	}) do
		_G[name] = widget()
	end
	for i = 1, 20 do
		_G["ACP_AddonListEntry" .. i .. "LoadNow"] = widget()
	end
	_G.UIPanelWindows = {}
	_G.StaticPopupDialogs = {}
	_G.SlashCmdList = {}
	_G.ACCEPT, _G.CANCEL, _G.YES = "Accept", "Cancel", "Yes"
	_G.UnitClass = function() return "Mage", "MAGE" end

	_G._ = nil
	local ok, err = pcall(function() ACP:OnLoad(widget()) end)
	check("OnLoad runs", ok, tostring(err))

	local passedAssert = pcall(function() assert(_G._ == nil) end)
	check("the global _ was not written", passedAssert, tostring(_G._))

	check("playerClass was still captured",
	      select(2, pcall(function() return ACP:GetSetName("Mage") end)) == "Mage")
	check("the slash command was registered",
	      type(SlashCmdList["ACP"]) == "function" and SLASH_ACP1 == "/acp")
end

--------------------------------------------------------------------------
-- 10. Manual language selection
--------------------------------------------------------------------------
local function test10()
	section("10. Manual language selection")

	-- 1. enUS client, no override.
	loadAddon("enUS")
	ACP:RenameSet(1, nil)                 -- makes ACP.lua build its savedVar
	local sv = ACP:GetSavedVariables()
	check("a fresh ACP_Data has no localeOverride", sv.localeOverride == nil)
	check("no override means the detected locale",
	      ACP:GetEffectiveLocale() == "enUS" and ACP.L["Close"] == "Close")

	-- 2. enUS client, override ptBR. This is the reported real world case:
	--    a community translated client that still answers enUS.
	sv.localeOverride = "ptBR"
	check("RestoreLocaleOverride applies it", ACP:RestoreLocaleOverride() == true)
	check("the detected locale is still enUS", ACP:GetDetectedLocale() == "enUS")
	check("the effective locale is ptBR", ACP:GetEffectiveLocale() == "ptBR")
	check("strings really come from ptBR",
	      ACP.L["Close"] == "Fechar", ACP.L["Close"])

	-- 3. An override naming a language that is not registered.
	sv.localeOverride = "xxYY"
	check("an unknown override is refused", ACP:RestoreLocaleOverride() == false)
	check("and the fallback is safe",
	      ACP:GetEffectiveLocale() == "enUS" and ACP.L["Close"] == "Close")
	check("the stored value is left alone so the file can come back",
	      sv.localeOverride == "xxYY")

	-- 4. auto clears the override.
	sv.localeOverride = nil
	ACP:RestoreLocaleOverride()
	ACP:SelectLocale("deDE")
	check("a language can be set", sv.localeOverride == "deDE")
	ACP:SelectLocale("auto")
	check("auto clears the stored override", sv.localeOverride == nil)
	check("auto goes back to the detected locale",
	      ACP:GetEffectiveLocale() == "enUS" and ACP:GetLocaleOverride() == nil)

	-- 5. Case insensitive codes.
	check("ptbr normalizes to ptBR", ACP:NormalizeLocaleCode("ptbr") == "ptBR")
	check("eses normalizes to esES", ACP:NormalizeLocaleCode("eses") == "esES")
	check("ZHTW normalizes to zhTW", ACP:NormalizeLocaleCode("ZHTW") == "zhTW")
	check("surrounding spaces are ignored",
	      ACP:NormalizeLocaleCode("  ptBR  ") == "ptBR")
	local ok, normalized = ACP:SelectLocale("ptbr")
	check("selecting ptbr stores exactly ptBR",
	      ok == true and normalized == "ptBR" and sv.localeOverride == "ptBR",
	      tostring(sv.localeOverride))

	-- 6. An unregistered code is never stored.
	ACP:SelectLocale("auto")
	local before = sv.localeOverride
	local failed = ACP:SelectLocale("klingon")
	check("an unregistered code is refused", failed == false)
	check("and nothing is written to ACP_Data", sv.localeOverride == before)
	check("the effective locale did not move", ACP:GetEffectiveLocale() == "enUS")
	check("the refusal is reported in the user language",
	      lastChat():find("klingon", 1, true) ~= nil, lastChat())

	-- 7. An ACP_Data written by 3.3.7 or by an earlier 3.3.8 build.
	loadAddon("enUS")
	ACP:RenameSet(1, nil)
	local old = ACP:GetSavedVariables()
	old.AddonSet = { [1] = { "SomeAddon", name = "raid" } }
	old.ProtectedAddons = { ACP = true }
	old.collapsed = {}
	old.sorter = "Group By Name"
	old.NoRecurse = true
	-- no localeOverride field at all
	check("an old ACP_Data restores without error",
	      ACP:RestoreLocaleOverride() == false)
	check("and ACP still works", ACP:GetEffectiveLocale() == "enUS")
	check("no field of the old ACP_Data was touched",
	      old.sorter == "Group By Name" and old.NoRecurse == true and
	      old.AddonSet[1].name == "raid")
	check("localeOverride is still absent", old.localeOverride == nil)

	-- 13 languages are all selectable.
	local codes = ACP:GetRegisteredLocales()
	check("all 13 languages are registered and selectable", #codes == 13,
	      table.concat(codes, " "))
	local bad = {}
	for _, code in ipairs(codes) do
		if not ACP:SelectLocale(code) or ACP:GetEffectiveLocale() ~= code then
			bad[#bad + 1] = code
		end
	end
	check("every registered language can be selected", #bad == 0,
	      table.concat(bad, " "))
	ACP:SelectLocale("auto")
end

--------------------------------------------------------------------------
-- 11. The drop down in the window
--------------------------------------------------------------------------
local function stubDropDownApi()
	local menu = { entries = {}, selected = nil, width = nil }

	_G.UIDropDownMenu_CreateInfo = function() return {} end
	_G.UIDropDownMenu_AddButton = function(info)
		menu.entries[#menu.entries + 1] = info
	end
	_G.UIDropDownMenu_Initialize = function(frame, fn) menu.initializer = fn end
	_G.UIDropDownMenu_SetSelectedValue = function(frame, value) menu.selected = value end
	_G.UIDropDownMenu_SetWidth = function(frame, width) menu.width = width end

	menu.popups = {}
	_G.StaticPopup_Show = function(which, a, b)
		menu.popups[#menu.popups + 1] = { which = which, a = a, b = b }
	end
	menu.reloads = 0
	_G.ReloadUI = function() menu.reloads = menu.reloads + 1 end

	local tip = {}
	function tip:SetOwner() self.lines = {} end
	function tip:AddLine(t) self.lines = self.lines or {}; self.lines[#self.lines + 1] = tostring(t) end
	function tip:Show() end
	function tip:Hide() end
	_G.GameTooltip = tip

	return menu
end

local function test11()
	section("11. The language drop down in the window")

	loadAddon("enUS")
	local menu = stubDropDownApi()

	_G["ACP_AddonListLocaleDropDown"] = widget()
	_G["ACP_AddonListLocaleDropDownText"] = widget()
	local shownText
	_G["ACP_AddonListLocaleDropDownText"].SetText = function(_, t) shownText = t end
	_G.StaticPopupDialogs = { ACP_LOCALE_RELOAD = {
		button1 = "x", button2 = "y",
		OnAccept = function() ReloadUI() end,
	} }

	ACP:RenameSet(1, nil)
	local sv = ACP:GetSavedVariables()

	-- Build the menu.
	ACP:LocaleDropDown_OnShow(_G["ACP_AddonListLocaleDropDown"])
	menu.entries = {}
	ACP:LocaleDropDown_Populate()

	check("the menu has automatic plus the 13 languages", #menu.entries == 14,
	      tostring(#menu.entries))
	check("the first entry is Automatic with the detected code",
	      menu.entries[1].text == "Automatic \226\128\148 enUS", menu.entries[1].text)
	check("automatic is checked when there is no override",
	      menu.entries[1].checked == true)

	-- Native names, whatever the current language is.
	local byValue = {}
	for _, e in ipairs(menu.entries) do byValue[e.value] = e.text end
	check("ptBR shows its native name", byValue["ptBR"] == "Português (Brasil)", byValue["ptBR"])
	check("deDE shows its native name", byValue["deDE"] == "Deutsch", byValue["deDE"])
	check("ruRU shows its native name", byValue["ruRU"] == "Русский", byValue["ruRU"])
	check("esMX shows its native name",
	      byValue["esMX"] == "Español (Latinoamérica)", byValue["esMX"])
	check("every entry carries a real locale code as its value",
	      (function()
	          for _, e in ipairs(menu.entries) do
	              if e.value ~= "auto" and ACP.Locales[e.value] == nil then return false end
	          end
	          return true
	      end)())

	-- Picking ptBR.
	menu.popups = {}
	byValue = nil
	for _, e in ipairs(menu.entries) do
		if e.value == "ptBR" then e.func() end
	end
	check("choosing ptBR stores exactly ptBR", sv.localeOverride == "ptBR",
	      tostring(sv.localeOverride))
	check("the popup opened", #menu.popups == 1 and menu.popups[1].which == "ACP_LOCALE_RELOAD",
	      tostring(#menu.popups))
	check("the popup mentions the reload",
	      tostring(menu.popups[1].b):find("Recarregue", 1, true) ~= nil,
	      tostring(menu.popups[1].b))
	check("the closed drop down shows the native name of the new language",
	      shownText == "Português (Brasil)", tostring(shownText))
	check("the drop down selection follows ACP_Data", menu.selected == "ptBR",
	      tostring(menu.selected))

	-- The reload button really reloads.
	menu.reloads = 0
	StaticPopupDialogs["ACP_LOCALE_RELOAD"].OnAccept()
	check("Reload now calls ReloadUI()", menu.reloads == 1)

	-- Menu entries are rebuilt against the stored override.
	menu.entries = {}
	ACP:LocaleDropDown_Populate()
	local autoEntry, ptEntry
	for _, e in ipairs(menu.entries) do
		if e.value == "auto" then autoEntry = e end
		if e.value == "ptBR" then ptEntry = e end
	end
	check("ptBR is now the checked entry",
	      ptEntry.checked == true and autoEntry.checked == false)

	-- Picking Automatic.
	autoEntry.func()
	check("automatic clears the override", sv.localeOverride == nil)
	check("and the closed drop down goes back to the detected language",
	      shownText == "English", tostring(shownText))

	-- The tooltip is the generic word, in the current language.
	ACP:SelectLocale("esES")
	ACP:LocaleDropDown_OnEnter(widget())
	check("the tooltip shows the generic word translated",
	      GameTooltip.lines[1] == "Idioma", tostring(GameTooltip.lines[1]))
	check("and the drop down text stays native",
	      ACP:GetLocaleDropDownText() == "Español (España)",
	      ACP:GetLocaleDropDownText())
	ACP:SelectLocale("auto")
end

--------------------------------------------------------------------------
print("ACP 3.3.8-WotLK self test")
print("Lua: " .. _VERSION .. "   folder: " .. DIR)

test1()
test2()
test3()
test4()
test5()
test6()
test7()
test8()
test9()
test10()
test11()

print("")
print(string.format("%d passed, %d failed", passed, failed))

if failed > 0 then
	os.exit(1)
end
os.exit(0)
