--[[--------------------------------------------------------------------
	Addon Control Panel 3.3.8-WotLK
	Localization core

	Target client : World of Warcraft 3.3.5a (Interface 30300)
	Language      : Lua 5.1 only. No modern API is used or allowed here.

	This file must be listed FIRST in ACP.toc, before every
	localization-<code>.lua file and before ACP.lua.

	Why a manual selector exists
	----------------------------
	Community translated 3.3.5a clients keep reporting the locale they were
	built from. A Brazilian client can answer enUS to both GetLocale() and
	GetCVar("locale"), so automatic detection cannot find ptBR. The user must
	be able to say so, and that choice lives in ACP_Data.localeOverride.

	Public API
	----------
	ACP:RegisterLocale(localeCode, translations [, isDefault])
		Registers a translation table. Called once per localization file.
		Every registered table is kept in ACP.Locales, so a language can be
		selected later, after the saved variables are available.

	ACP.L[key]
		Translated string for the EFFECTIVE locale.
		Lookup order:  effective locale  ->  enUS  ->  the key itself.
		A missing key NEVER raises a Lua error. Values are not cached, so a
		later registration or language change is visible immediately.

	ACP:GetDetectedLocale()    always the raw result of GetLocale()
	ACP:GetEffectiveLocale()   what ACP actually uses
	ACP:GetActiveLocale()      same as GetEffectiveLocale()
	ACP:GetLocaleOverride()    manual selection, or nil
	ACP:SetLocale(code)        forces a language, returns ok, normalizedCode
	ACP:ClearLocaleOverride()  back to automatic detection
	ACP:GetRegisteredLocales() ordered array of the codes that have a table
	ACP:GetLocaleName(code)    native display name
	ACP:NormalizeLocaleCode(c) "ptbr" -> "ptBR", nil when not registered
	ACP:IsLocaleRegistered([code])  defaults to the detected locale
	ACP:GetLocaleString(key)   effective locale only, no fallback, may be nil
	ACP:WarnUnknownLocale()    debug only, prints once per session
	ACP:ReportMissingLocaleKeys()

	Effective locale resolution
	---------------------------
	    a registered ACP_Data.localeOverride
	 -> GetLocale() if it is registered
	 -> enUS

	Memory
	------
	All 13 tables are kept, roughly a hundred short strings each. That is the
	price of being able to switch language after VARIABLES_LOADED, and it is
	small. No file is ever read: no dofile, no loadfile, no Config.wtf.
----------------------------------------------------------------------]]

ACP = ACP or {}

local DEFAULT_LOCALE = "enUS"
local detectedCode = GetLocale()

-- [code] = table of translations. Kept for every registered language.
local locales = {}
ACP.Locales = locales

local localeOverride = nil
local activeCode = DEFAULT_LOCALE

-- Resolved views, recomputed by resolveActive()
local defaultStrings = {}
local activeStrings = {}

local localeWarningShown = false
local missing = {}
local reported = {}

ACP.DEFAULT_LOCALE = DEFAULT_LOCALE

--------------------------------------------------------------------
-- Display metadata
--
-- Native names on purpose: someone who picks the wrong language by mistake
-- has to be able to find their way back, and "Deutsch" is recognisable from
-- any other language while "German" is not.
--------------------------------------------------------------------
local LOCALE_NAMES = {
	["enUS"] = "English",
	["enGB"] = "English (UK)",
	["enCN"] = "English (Chinese client)",
	["deDE"] = "Deutsch",
	["frFR"] = "Français",
	["esES"] = "Español (España)",
	["esMX"] = "Español (Latinoamérica)",
	["ptBR"] = "Português (Brasil)",
	["itIT"] = "Italiano",
	["ruRU"] = "Русский",
	["koKR"] = "한국어",
	["zhCN"] = "简体中文",
	["zhTW"] = "繁體中文",
}
ACP.LocaleNames = LOCALE_NAMES

local LOCALE_ORDER = {
	"enUS", "enGB", "enCN", "deDE", "frFR", "esES", "esMX",
	"ptBR", "itIT", "ruRU", "koKR", "zhCN", "zhTW",
}
ACP.LocaleOrder = LOCALE_ORDER

--------------------------------------------------------------------
-- Internal resolver
--
-- raw() never warns, never caches and never touches ACP.L, so it can be used
-- to translate the "untranslated key" message itself without recursing back
-- into the metatable.
--------------------------------------------------------------------
local function raw(key)
	local value = activeStrings[key]

	if value == nil or value == true or value == "" then
		value = defaultStrings[key]
	end

	if value == nil or value == true or value == "" then
		return tostring(key), false
	end

	return value, true
end

--------------------------------------------------------------------
-- The lookup table
--------------------------------------------------------------------
local L = setmetatable({}, {
	__index = function(t, key)
		local value, translated = raw(key)

		if not translated then
			missing[key] = true
			if ACP.debug and not reported[key] and DEFAULT_CHAT_FRAME then
				reported[key] = true
				DEFAULT_CHAT_FRAME:AddMessage("ACP: " ..
					string.format(raw("Untranslated key: %s"), value))
			end
		end

		return value
	end,
} )

ACP.L = L

--- Drop everything that was read out of L. The metatable does not cache, but
-- a third party may have written into ACP.L directly and a new registration
-- or a language change has to win over that.
local function invalidate()
	for key in pairs(L) do
		rawset(L, key, nil)
	end
	for key in pairs(missing) do
		missing[key] = nil
	end
	for key in pairs(reported) do
		reported[key] = nil
	end
end

--- Recomputes the effective locale and the two lookup tables.
local function resolveActive()
	if localeOverride and locales[localeOverride] then
		activeCode = localeOverride
	elseif locales[detectedCode] then
		activeCode = detectedCode
	else
		activeCode = DEFAULT_LOCALE
	end

	defaultStrings = locales[DEFAULT_LOCALE] or {}
	activeStrings = locales[activeCode] or defaultStrings

	invalidate()
end

--------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------
local function merge(target, source)
	for key, value in pairs(source) do
		if value == true then
			value = key
		end
		if type(value) == "string" and value ~= "" then
			target[key] = value
		end
	end
end

--- Register a translation table.
-- @param localeCode  any four character locale code, official or custom
-- @param translations  table of [englishKey] = "translated string"
-- @param isDefault  optional, true also merges the table into enUS
-- @return true when the table was stored
function ACP:RegisterLocale(localeCode, translations, isDefault)
	if type(localeCode) ~= "string" or type(translations) ~= "table" then
		return false
	end

	if isDefault == nil then
		isDefault = (localeCode == DEFAULT_LOCALE)
	end

	local target = locales[localeCode]
	if not target then
		target = {}
		locales[localeCode] = target
	end
	merge(target, translations)

	if isDefault and localeCode ~= DEFAULT_LOCALE then
		local fallback = locales[DEFAULT_LOCALE]
		if not fallback then
			fallback = {}
			locales[DEFAULT_LOCALE] = fallback
		end
		merge(fallback, translations)
	end

	resolveActive()
	return true
end

--------------------------------------------------------------------
-- Language selection
--------------------------------------------------------------------
local function trim(text)
	return (string.gsub(text, "^%s*(.-)%s*$", "%1"))
end

--- "ptbr" -> "ptBR". Returns nil when no registered locale matches.
function ACP:NormalizeLocaleCode(code)
	if type(code) ~= "string" then
		return nil
	end

	code = trim(code)
	if code == "" then
		return nil
	end

	if locales[code] then
		return code
	end

	local lowered = string.lower(code)
	for registered in pairs(locales) do
		if string.lower(registered) == lowered then
			return registered
		end
	end

	return nil
end

--- Forces a language. Refuses codes that have no registered table, so a typo
-- can never leave ACP without strings.
-- @return ok, normalizedCode
function ACP:SetLocale(code)
	local normalized = self:NormalizeLocaleCode(code)
	if not normalized then
		return false, nil
	end

	localeOverride = normalized
	resolveActive()
	return true, normalized
end

--- Back to GetLocale() based detection.
function ACP:ClearLocaleOverride()
	localeOverride = nil
	resolveActive()
	return true
end

function ACP:GetLocaleOverride()
	return localeOverride
end

function ACP:GetDetectedLocale()
	return detectedCode
end

function ACP:GetEffectiveLocale()
	return activeCode
end

-- Kept under the old name: it has always meant "the locale ACP is using",
-- which is now the effective one rather than blindly what WoW reported.
function ACP:GetActiveLocale()
	return activeCode
end

--- Defaults to the detected locale, which is what the debug warning is about.
function ACP:IsLocaleRegistered(code)
	return locales[code or detectedCode] ~= nil
end

function ACP:GetLocaleName(code)
	return LOCALE_NAMES[code] or code
end

--- Ordered list of the codes that actually have a table: the known ones in
-- display order first, then anything a third party registered, sorted.
function ACP:GetRegisteredLocales()
	local out, seen = {}, {}

	for i = 1, #LOCALE_ORDER do
		local code = LOCALE_ORDER[i]
		if locales[code] then
			out[#out + 1] = code
			seen[code] = true
		end
	end

	local extra = {}
	for code in pairs(locales) do
		if not seen[code] then
			extra[#extra + 1] = code
		end
	end
	table.sort(extra)
	for i = 1, #extra do
		out[#out + 1] = extra[i]
	end

	return out
end

--------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------
--- Effective locale only, no fallback to enUS and no fallback to the key.
function ACP:GetLocaleString(key)
	local value = activeStrings[key]
	if value == true then
		value = key
	end
	if value == "" then
		value = nil
	end
	return value
end

--- Debug only. Says once per session that the detected locale has no file.
-- An unknown locale is not an error: ACP simply runs in enUS.
function ACP:WarnUnknownLocale()
	if localeWarningShown or self:IsLocaleRegistered() then
		return false
	end
	localeWarningShown = true
	if DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage("ACP: " ..
			string.format(L["No translation is registered for locale %s, using %s."],
				tostring(detectedCode), tostring(activeCode)))
	end
	return true
end

--- Debug only. Lists every key that had to fall back to the key itself.
function ACP:ReportMissingLocaleKeys()
	local count = 0
	for key in pairs(missing) do
		count = count + 1
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage("ACP: " ..
				string.format(L["Untranslated key: %s"], tostring(key)))
		end
	end
	if count == 0 and DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage("ACP: " ..
			L["No untranslated key has been requested so far."])
	end
	return count
end

--------------------------------------------------------------------
-- Compatibility with ACP 3.3.7 localization files
--
-- In this addon the English source string IS the key, and 3.3.8 corrected a
-- number of those English strings. A translation table written for 3.3.7
-- therefore fills keys that 3.3.8 never asks for.
--
-- The map below was built by diffing the full key set of the 3.3.7
-- localization-enUS.lua against the 3.3.8 one. Of the 22 keys that 3.3.7
-- defined and 3.3.8 no longer uses, 17 are plain renames and live here, two
-- need special handling (see below) and three are gone on purpose:
-- Blizzard_FeedbackUI and Blizzard_VehicleUI are not in ACP_BLIZZARD_ADDONS.
--
-- IMPORTANT: this normalization is applied ONLY to tables that arrive through
-- ACP:UpdateLocale(). The 13 canonical files go through RegisterLocale() and
-- are never touched by it, so none of these old keys leak into them.
--------------------------------------------------------------------
local LEGACY_LOCALE_KEY_ALIASES = {
	["ReloadUI"]                          = "Reload UI",
	["Reload your User Interface?"]       = "Reload your user interface?",
	["Embeds"]                            = "Embedded Libraries",
	["Active Embeds"]                     = "Active Embedded Libraries",
	["Loadable OnDemand"]                 = "Loadable on demand",
	["Disabled on reloadUI"]              = "Disabled after Reload UI",
	["LoD Child Enable is now %s"]        = "Load on demand child enabling is now %s.",
	["Recursive Enable is now %s"]        = "Recursive enabling is now %s.",
	["Addons [%s] Saved."]                = "AddOn set [%s] saved.",
	["Addons [%s] Loaded."]               = "AddOn set [%s] loaded.",
	["Addons [%s] Unloaded."]             = "AddOn set [%s] unloaded.",
	["Addons [%s] renamed to [%s]."]      = "AddOn set [%s] renamed to [%s].",
	["Save the current addon list to [%s]?"] = "Save the current AddOn list to [%s]?",
	["ACP: Some protected addons aren't loaded. Reload now?"] =
		"ACP: Some protected AddOns are not enabled. Reload the UI now?",
	["*** Unknown Addon <%s> Required ***"] = "*** Unknown AddOn <%s> required ***",
	["Addon <%s> not valid"]              = "AddOn <%s> is not valid.",
	["Use SHIFT to override the current enabling of dependancies behaviour."] =
		"Use SHIFT to override the current dependency enabling behavior.",
}

-- Special case 1: 3.3.7 built the set name as  L["Set "] .. number.
local LEGACY_SET_KEY = "Set "
local SET_NAME_KEY   = "Set %d"

-- Special case 2: 3.3.7 split the protected mode tooltip over two lines.
local LEGACY_PROTECT_1 = "Click to enable protect mode. Protected addons will not be disabled"
local LEGACY_PROTECT_2 = "when performing a reloadui."
local PROTECT_KEY =
	"Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."

--- Returns the value of a legacy entry as a usable string, or nil.
local function legacyValue(translations, key)
	local value = translations[key]
	if value == true then
		value = key
	end
	if type(value) ~= "string" or value == "" then
		return nil
	end
	return value
end

--- Copies 3.3.7 translations onto the 3.3.8 keys.
-- A value given directly under the new key always wins. The old key is kept
-- as well, in case external code still reads it.
local function normalizeLegacyKeys(translations)
	local out = {}
	for key, value in pairs(translations) do
		out[key] = value
	end

	for oldKey, newKey in pairs(LEGACY_LOCALE_KEY_ALIASES) do
		if translations[newKey] == nil then
			local value = legacyValue(translations, oldKey)
			if value then
				out[newKey] = value
			end
		end
	end

	-- "Perfil " .. 1  ->  "Perfil %d". Appending the placeholder reproduces
	-- the 3.3.7 concatenation byte for byte, including whatever separator the
	-- translator chose to end the string with.
	if translations[SET_NAME_KEY] == nil then
		local prefix = legacyValue(translations, LEGACY_SET_KEY)
		if prefix then
			out[SET_NAME_KEY] = prefix .. "%d"
		end
	end

	-- Two tooltip lines -> one sentence. Never produce nil, never double a
	-- space, and accept a table that only translated one of the two lines.
	if translations[PROTECT_KEY] == nil then
		local first = legacyValue(translations, LEGACY_PROTECT_1)
		local second = legacyValue(translations, LEGACY_PROTECT_2)
		if first and second then
			out[PROTECT_KEY] = (first:gsub("%s+$", "")) .. " " ..
			                   (second:gsub("^%s+", ""))
		elseif first then
			out[PROTECT_KEY] = first
		elseif second then
			out[PROTECT_KEY] = second
		end
	end

	return out
end

--------------------------------------------------------------------
-- Backwards compatibility with ACP 3.3.7
--------------------------------------------------------------------
-- 3.3.7 localization files called ACP:UpdateLocale(table) from inside an
-- "if GetLocale() == xx" guard, so the table belongs to the DETECTED locale,
-- not to whatever language the user may have forced afterwards. Third party
-- files written for 3.3.7 keep working, and like any registration they
-- override strings that were already read.
function ACP:UpdateLocale(translations)
	if type(translations) ~= "table" then
		return false
	end
	return self:RegisterLocale(detectedCode, normalizeLegacyKeys(translations), false)
end

--- Exposed for the self test only: normalization is not part of the public
-- contract and nothing inside ACP calls this.
ACP.NormalizeLegacyLocaleKeys = normalizeLegacyKeys
