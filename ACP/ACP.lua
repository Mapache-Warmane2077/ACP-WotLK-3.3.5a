--==============
-- Global Variables
--==============
ACP = ACP or {}

-- ACP-Locale.lua defines the localization core and is loaded first by the TOC.
-- The fallback table keeps ACP loadable even if that file were missing.
local L = ACP.L or setmetatable({}, { __index = function(t, k) return k end })
ACP.L = L

-- Debug output, toggled with /acp debug. It only adds chat output, it never
-- changes how the addon behaves, and it is deliberately NOT stored in
-- ACP_Data: every session starts with debugging off.
ACP.debug = false

-- Deprecated since 3.3.8-WotLK. ACP does not read this field any more, but it
-- was part of the public ACP table in 3.3.7, so it is kept for anything that
-- still looks at it.
ACP.CheckEvents = ACP.CheckEvents or 0

ACP_LINEHEIGHT = 16


ACP.TAGS = {
    PART_OF = "X-Part-Of",
    INTERFACE_MIN = "X-Min-Interface",
    INTERFACE_MIN_ORG = "X-Since-Interface",
    INTERFACE_MAX = "X-Max-Interface",
    INTERFACE_MAX_ORG = "X-Compatible-With",
}

-- Handle various annoying special case names
function ACP:SpecialCaseName(name)
	local partof = GetAddOnMetadata(name, ACP.TAGS.PART_OF)

	if partof ~= nil then
		return partof.."_"..name
	end

	if name == "DBM-Core" then
		return "DBM"
	elseif name:match("DBM%-") then
		return name:gsub("DBM%-", "DBM_")
	elseif name:match("CT_") then
		return name:gsub("CT_", "CT-")
	elseif name:sub(1,1) == "+" or name:sub(1,1) == "!" or name:sub(1,1) == "_" then
		return name:sub(2,-1)
	elseif name == "ShadowedUF_Options" then
	    return "ShadowedUnitFrames_Options"
--	elseif name == "Auc-Advanced" then
--		return "Auc"
--	elseif name:match("Auc%-") then
--		return name:gsub("Auc%-", "Auc_")
--	elseif
	end

	return name
end
--==============
-- Sorting criteria
--
-- Internal, locale independent keys. They are the keys of addonListBuilders
-- and they are what gets written to ACP_Data.sorter, so a saved sorting
-- criteria no longer depends on the language of the client.
-- They are translated only at the moment they are displayed.
--==============
local DEFAULT = "Default"
local TITLES = "Titles"
local ACE2 = "Ace2"
local AUTHOR = "Author"
local SEPARATE_LOD_LIST = "Separate LoD List"
local GROUP_BY_NAME = "Group By Name"

local SORTER_ORDER = { DEFAULT, TITLES, ACE2, AUTHOR, SEPARATE_LOD_LIST, GROUP_BY_NAME }
ACP.SORTER_ORDER = SORTER_ORDER

-- ACP 3.3.7 wrote the *localized* sorter name into ACP_Data.sorter. This maps
-- every string 3.3.7 could have written back to the internal key so that
-- people upgrading from 3.3.7 keep their sorting criteria.
local LEGACY_SORTERS = {
	-- enUS / deDE and every locale 3.3.7 left untranslated
	["Separate LOD List"]              = SEPARATE_LOD_LIST,
	-- zhCN
	["默认"]                       = DEFAULT,
	["名称"]                       = TITLES,
	["作者"]                       = AUTHOR,
	["按需求加载"]               = SEPARATE_LOD_LIST,
	["按名称分组"]               = GROUP_BY_NAME,
	-- zhTW
	["預設"]                       = DEFAULT,
	["名稱"]                       = TITLES,
	["隨需求載入"]               = SEPARATE_LOD_LIST,
	["以名稱分組"]               = GROUP_BY_NAME,
	-- koKR
	["기본"]                       = DEFAULT,
	["제목"]                       = TITLES,
	["제작자"]                     = AUTHOR,
	["LOD 목록 분리"]              = SEPARATE_LOD_LIST,
	["이름별 분류"]              = GROUP_BY_NAME,
	-- frFR
	["Défaut"]                     = DEFAULT,
	["Titres"]                     = TITLES,
	["Auteur"]                     = AUTHOR,
	["Liste LOD séparée"]           = SEPARATE_LOD_LIST,
	["Groupement par nom"]         = GROUP_BY_NAME,
	-- esES
	["Por Defecto"]                = DEFAULT,
	["T?tulos"]                    = TITLES,
	["Autor"]                      = AUTHOR,
	["Lista CaD por separado"]     = SEPARATE_LOD_LIST,
	["Agrupar por nombre"]         = GROUP_BY_NAME,
	-- ruRU
	["По умолчанию"]           = DEFAULT,
	["Заголовкам"]              = TITLES,
	["Автор"]                     = AUTHOR,
	["Отдел. список ЗПТ"]      = SEPARATE_LOD_LIST,
	["Группир. по имени"]      = GROUP_BY_NAME,
}

--==============
-- Category names built by ACP itself
--
-- Internal keys as well: they are used as keys of ACP_Data.collapsed, so they
-- must not change with the language. Translated only when displayed.
--==============
local CAT_BLIZZARD        = "Blizzard"
local CAT_BLIZZARD_ADDONS = "Blizzard AddOns"
local CAT_STANDARD_ADDONS = "Standard AddOns"
local CAT_LOD_ADDONS      = "Load on Demand AddOns"
local CAT_LIBRARIES       = "Libraries"
local CAT_UNDEFINED       = "Undefined"
local CAT_UNKNOWN         = "Unknown"

local BUILTIN_CATEGORIES = {
	[CAT_BLIZZARD]        = true,
	[CAT_BLIZZARD_ADDONS] = true,
	[CAT_STANDARD_ADDONS] = true,
	[CAT_LOD_ADDONS]      = true,
	[CAT_LIBRARIES]       = true,
	[CAT_UNDEFINED]       = true,
	[CAT_UNKNOWN]         = true,
}

-- 3.3.7 category names, renamed for consistent AddOn/AddOns spelling.
local LEGACY_CATEGORIES = {
	["Blizzard Addons"]       = CAT_BLIZZARD_ADDONS,
	["Standard Addons"]       = CAT_STANDARD_ADDONS,
	["Load On Demand Addons"] = CAT_LOD_ADDONS,
}

-- Categories built by ACP are translated. Anything that comes from an addon
-- (author name, X-Category value, name prefix) is shown exactly as it is.
function ACP:LocalizeCategory(category)
	if type(category) ~= "string" then return category end
	if BUILTIN_CATEGORIES[category] then return L[category] end
	return category
end

--==============
-- Special Tables
--==============

--[[
	masterAddonList : master list of sorted addons.
	It should be in the following structures:
		masterAddonList = {
			addon1Index,
			addon2Index,
			{
				addon3Index,
				addon4Index,
				...
				['category'] = "Category1Name"
			},
			addon5Index,
			{
				addon6Index,
				addon7Index,
				['category'] = "Category2Name"
			},
		}

	This list is used to build sortedAddonList, which is the list used in the FauxScrollFrame.

	NEW: addonIndex can now be number or string, where string is the addon name,
			so you can directly insert the Blizzard addon names to the list.

--]]
local masterAddonList = {}
ACP.masterAddonList = masterAddonList


--[[
	sortedAddonList : list of addonIndexes, which is used by the FauxScrollFrame.
	It should be in the following structure:
		sortedAddonList = {
			addon1Index,
			addon2Index,
			"Category1Name",
			addon3Index,
			addon4Index,
			...,
			addon5Index,
			"Category2Name",
			addon6Index,
			addon7Index,
			...,
		}

	- If type(addonIndex) == 'string', it will be shown in the panel as a category header.
	- The collapse state will be retrieved from the saved variables: collapsedAddons.
	- If addonIndex > GetNumAddOns(), it''s a Blizzard addon, the index references to ACP_BLIZZARD_ADDONS[addonIndex - GetNumAddOns()].
	- otherwise, addonIndex is the index used in GetAddOnInfo().

	This list will be rebuilt whenever use expanded/collapsed a category, or when user changed the sorting criteria.

--]]
local sortedAddonList = {}
ACP.sortedAddonList = sortedAddonList

--[[
	addonListBuilders : a table of functions used to build masterAddonList

	To define your own sorting criteria, check the default builder functions as examples.
	Note if you create the build function in an external scope, you cannot access to the ACP local variables,
	  i.e. masterAddonList and ACP_BLIZZARD_ADDONS, but they can be accessed through ACP. e.g.:

		function MyExternalBuilder()
			local masterAddonList = ACP.masterAddonList
			local bzAddons = ACP.ACP_BLIZZARD_ADDONS
			(Now build the masterAddonList)
		end

	When you have defined your own builder function, simple add them to the table by:

		ACP.addonListBuilders["MyExternalBuilder"] = MyExternalBuilder

	After everything is done, the custom defined function can be accessed from the ACP sorter drop down menu.

]]
local addonListBuilders = {}
ACP.addonListBuilders = addonListBuilders

--- Returns the internal builder key for a sorter name.
-- 3.3.7 stored the *localized* criteria name in ACP_Data.sorter, so an
-- upgrading user arrives with a string such as "Agrupar por nombre".
-- Returns nil when the name is not recognized at all, in which case the
-- caller falls back to the default criteria, exactly like 3.3.7 did.
function ACP:MigrateSorterName(name)
	if type(name) ~= "string" then return nil end
	if addonListBuilders[name] then return name end
	return LEGACY_SORTERS[name]
end



--
-- Decorator Pattern Text Colorization Functions
-- Same as crayonlib
--
local CLR = {}
CLR.COLOR_NONE = nil
function CLR:Colorize(hexColor, text)
    if text == nil then text = "" end

    if hexColor == CLR.COLOR_NONE then
        return text
    end

    return "|cff" .. tostring(hexColor or 'ffffff') .. tostring(text) .. "|r"
end
function CLR:GetHexColor(color)
    return string.format("%02x%02x%02x", color.r*255, color.g*255, color.b*255)
end

--
-- Colors used
--
function CLR:Label(txt) return CLR:Colorize('ffff7f', txt) end
function CLR:ActiveEmbed(txt) return CLR:Colorize('80ff80', txt) end
function CLR:Addon(txt) return CLR:Colorize('7f7fff', txt) end
function CLR:On(txt) return CLR:Colorize('00ff00', txt) end
function CLR:Off(txt) return CLR:Colorize('ff0000', txt) end
function CLR:Bool(b, txt) if b then return CLR:On(txt) else return CLR:Off(txt) end end
function CLR:AddonStatus(addon, txt)
    local color = ACP:GetAddonStatus(addon)
    return CLR:Colorize(color, txt)
end

local function formattitle(title)
    return title:gsub("Lib: ", "|cff66ccffLib|r: "):gsub(" |cff7fff7f %-Ace2%-|r", ""):gsub("%-Ace2%-", ""):trim()

end

-- From modmenutufu
local reasons = {}

local function getreason(r)
	if not r then return nil end
	-- Fall back to the raw reason if the client has no ADDON_<REASON> string.
	if not reasons[r] then reasons[r] = _G["ADDON_"..r] or r end
	return reasons[r]
end

function ACP:IsAddonCompatibleWithCurrentInterfaceVersion(addon)
    local build = select(4, GetBuildInfo())

	local addonnum = tonumber(addon)
	if not addonnum or (addonnum and (addonnum == 0 or addonnum > GetNumAddOns())) then
		return true -- Get to the choppa!
	end

    local max_supported =  GetAddOnMetadata(addonnum, ACP.TAGS.INTERFACE_MAX) or
                            GetAddOnMetadata(addonnum, ACP.TAGS.INTERFACE_MAX_ORG)

    local min_supported = GetAddOnMetadata(addonnum, ACP.TAGS.INTERFACE_MIN) or
                                GetAddOnMetadata(addonnum, ACP.TAGS.INTERFACE_MIN_ORG)

    --print("Min: "..tostring(min_supported).."  Max: "..tostring(max_supported))

    if max_supported then
		max_supported = tonumber(max_supported) and (tonumber(max_supported) >= build) or false
	end

    if min_supported then
        min_supported = tonumber(min_supported) and (tonumber(min_supported) <= build) or false
    end

    return max_supported, min_supported

end

-- 3.3.7 shipped this function name with a typo. Keep a working alias in case
-- a third party addon still calls the old name.
ACP.IsAddonCompatibleWithCurrentIntefaceVersion = ACP.IsAddonCompatibleWithCurrentInterfaceVersion

function ACP:GetAddonCompatibilitySummary(addon)
    local high, low = self:IsAddonCompatibleWithCurrentInterfaceVersion(addon)

    if low == false then
		return false
    elseif high == false then
		return false
	elseif high or low then
		return true
	end

    return nil -- Compatibility not specified
end

function ACP:GetAddonStatus(addon)
	local addon = addon

	-- Hi, i'm Mr Kludge! Whats your name?
	local addonnum = tonumber(addon)
	if addonnum and (addonnum == 0 or addonnum > GetNumAddOns()) then
		return -- Get to the choppa!
	end

	local high, low = self:IsAddonCompatibleWithCurrentInterfaceVersion(addon)
    if (low == false) then
        return "FF0000", getreason("INCOMPATIBLE")
    end
    if (high == false) then
        return "FF0000", getreason("INTERFACE_VERSION")
    end


	local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(addon)

	if reason == "MISSING" and type(addon) == "string" then
	    addon = self:ResolveLibraryName(addon) or addon
	end


	local loaded  = IsAddOnLoaded(addon)
	local isondemand = IsAddOnLoadOnDemand(addon)
	local color, note

	if reason == "DISABLED" then color, note = "9d9d9d", getreason(reason) -- Grey
	elseif reason == "NOT_DEMAND_LOADED" then color, note = "0070dd", getreason(reason) -- Blue
	elseif reason == "MISSING" then color, note = "ff0000", getreason(reason) -- Red
	elseif reason then color, note = "ff8000", getreason(reason) -- Orange
	elseif loadable and isondemand and not loaded and enabled then color, note = "1eff00", L["Loadable on demand"] -- Green
	elseif loaded and not enabled then color, note = "a335ee", L["Disabled after Reload UI"] -- Purple
	else
	    color = CLR.COLOR_NONE
	    note = ""
    end

	return color, note
end


--==============
-- Reference to tables in saved variables
--==============
local savedVar
local collapsedAddons


--==============
-- Local Variables
--==============
local cache = setmetatable({}, {__mode='k'})
local function acquire()
	local t = next(cache) or {}
	cache[t] = nil
	return t
end
local function reclaim(t)
	for k in pairs(t) do
		t[k] = nil
	end
	cache[t] = true
end
local ACP_ADDON_NAME = "ACP"
local ACP_FRAME_NAME = "ACP_AddonList"
local playerClass = nil
local ACP_SET_SIZE = 10
local ACP_MAXADDONS = 20
local ACP_DefaultSet = {}
local ACP_DEFAULT_SET = 0
local ACP_BLIZZARD_ADDONS = {
	"Blizzard_AchievementUI",
	"Blizzard_ArenaUI",
	"Blizzard_AuctionUI",
	"Blizzard_BarbershopUI",
	"Blizzard_BattlefieldMinimap",
	"Blizzard_BindingUI",
	"Blizzard_Calendar",
	"Blizzard_CombatLog",
	"Blizzard_CombatText",
	"Blizzard_DebugTools",
	"Blizzard_GlyphUI",
	"Blizzard_GMChatUI",
	"Blizzard_GMSurveyUI",
	"Blizzard_GuildBankUI",
	"Blizzard_InspectUI",
	"Blizzard_ItemSocketingUI",
	"Blizzard_MacroUI",
	"Blizzard_RaidUI",
	"Blizzard_TalentUI",
	"Blizzard_TimeManager",
	"Blizzard_TokenUI",
	"Blizzard_TradeSkillUI",
	"Blizzard_TrainerUI",
}
local NUM_BLIZZARD_ADDONS = #ACP_BLIZZARD_ADDONS
ACP.ACP_BLIZZARD_ADDONS = ACP_BLIZZARD_ADDONS
local enabledList -- Used to prevent recursive loop in EnableAddon.

local function ParseVersion(version)
	if type(version) == "string" then
		version = version:gsub("@project%-version@", CLR:Colorize("ffa0a0", "DEBUG")):trim()
	end
	return version
end

local function toggle(flag)
	if flag then
		return nil
	else
		return true
	end
end




local function GetAddonIndex(addon, noerr)
	if type(addon) == 'number' then
		return addon
	elseif type(addon) == 'string' then
		local addonIndex = ACP_BLIZZARD_ADDONS[addon]
		if addonIndex then
			return addonIndex + GetNumAddOns()
		else
		    if addon == "" then return nil end
			for i=1, GetNumAddOns() do
				local name = ACP:SpecialCaseName(GetAddOnInfo(i))
				if name:lower() ==  ACP:SpecialCaseName(addon):lower() then
					return i
				end
			end

			if not noerr then
    			error(L["Cannot find AddOn %s."]:format(tostring(addon)))
    		end
		end
	else
		if not noerr then
    		error(L["GetAddonIndex(): addon must be a number or a string."])
		end
	end
end

function ACP:ToggleRecursion(val)
    if val == nil then
       savedVar.NoRecurse = not savedVar.NoRecurse
    else
       savedVar.NoRecurse = not val
    end

    -- Keep the check button in sync with the saved setting.
    local checkbox = _G[ACP_FRAME_NAME.."_NoRecurse"]
    if checkbox then
        checkbox:SetChecked(not savedVar.NoRecurse)
    end
end

function ACP:OnLoad(this)

	self.L = L
	self.frame = _G[ACP_FRAME_NAME]

	self:ApplyLocaleToUI()

	UIPanelWindows[ACP_FRAME_NAME] = { area = "center", pushable = 0, whileDead = 1 }
	StaticPopupDialogs["ACP_RELOADUI"] = {
		text = L["Reload your user interface?"],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function()
			ReloadUI()
		end,
		OnCancel = function(data, reason)
    		if ( reason == "timeout" ) then
    			ReloadUI()
    		else
    		   StaticPopupDialogs["ACP_RELOADUI"].reloadAccepted = false
    		end
    	end,
    	OnHide = function()
    		if (StaticPopupDialogs["ACP_RELOADUI"].reloadAccepted ) then
    			ReloadUI();
    		end
    	end,
		OnShow = function()
    	    StaticPopupDialogs["ACP_RELOADUI"].reloadAccepted = true;
    	end,
		timeout = 5,
		hideOnEscape = 1,
		exclusive = 1,
		whileDead = 1
	}

	-- Shown after the language is changed. The language itself already
	-- applies, this only offers to refresh whatever text is still on screen.
	StaticPopupDialogs["ACP_LOCALE_RELOAD"] = {
		text = "%s|n|n%s",
		button1 = L["Reload now"],
		button2 = L["Later"],
		OnAccept = function()
			ReloadUI()
		end,
		timeout = 0,
		hideOnEscape = 1,
		whileDead = 1
	}

	StaticPopupDialogs["ACP_RELOADUI_START"] = {
		text = L["ACP: Some protected AddOns are not enabled. Reload the UI now?"],
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function()
			ReloadUI()
		end,
		OnCancel = function(data, reason)
    		if ( reason == "timeout" ) then
    			ReloadUI()
    		end
    	end,

		timeout = 5,
		hideOnEscape = 1,
		exclusive = 1,
		whileDead = 1
	}

	StaticPopupDialogs["ACP_SAVESET"] = {
		text = L["Save the current AddOn list to [%s]?"],
		button1 = YES,
		button2 = CANCEL,
		OnAccept = function()
			self:SaveSet(self.savingSet)
			CloseDropDownMenus(1)
		end,
		timeout = 0,
		hideOnEscape = 1,
		whileDead = 1,
		exclusive = 1,
	}

	local function OnRenameSet(this)
        local popup;
        if this:GetParent():GetName() == "UIParent" then
            popup = this
        else
            popup = this:GetParent()
        end
		local text = _G[popup:GetName().."EditBox"]:GetText()
		if text == "" then
			text = nil
		end
		self:RenameSet(self.renamingSet, text)
		popup:Hide()
	end

	StaticPopupDialogs["ACP_RENAMESET"] = {
		text = L["Enter the new name for [%s]:"],
		button1 = YES,
		button2 = CANCEL,
		OnAccept = OnRenameSet,
		EditBoxOnEnterPressed = OnRenameSet,
		EditBoxOnEscapePressed = function(this)
			this:GetParent():Hide()
		end,
		timeout = 0,
		hideOnEscape = 1,
		exclusive = 1,
		whileDead = 1,
		hasEditBox = 1,
	}

	for i,v in ipairs(ACP_BLIZZARD_ADDONS) do
		ACP_BLIZZARD_ADDONS[v] = i
	end
--	ACP_BLIZZARD_ADDONS = setmetatable(ACP_BLIZZARD_ADDONS, {
--		__index = function(t,k)
--			for i=1, #t do
--				if t[i] == k then
--
--					return i
--				end
--			end
--		end
--	} )

	local title = "Addon Control Panel"
	local version = GetAddOnMetadata(ACP_ADDON_NAME, "Version")
	if version then
		version = ParseVersion(version)
		title = title.." ("..version..")"
	end
	ACP_AddonListHeaderTitle:SetText(title)
	this:RegisterEvent("VARIABLES_LOADED")
	this:RegisterEvent("ADDON_LOADED")

	-- Deliberately a single assignment: "playerClass, _ = ..." would write
	-- to the global _, which other addons use as a scratch variable.
	playerClass = UnitClass("player")


	SlashCmdList["ACP"] = self.SlashHandler

	SLASH_ACP1 = "/acp"
end

function ACP:OnEvent(this, event, arg1, arg2, arg3)
	if event == "VARIABLES_LOADED" then
		if not ACP_Data then ACP_Data = {} end

		savedVar = ACP_Data

        savedVar.ProtectedAddons = savedVar.ProtectedAddons or { ["ACP"] = true }

		if not savedVar.collapsed then
			savedVar.collapsed = {}
		end
		collapsedAddons = savedVar.collapsed

        -- The saved variables are the first moment a manual language choice
        -- can be honoured: the Lua files were all loaded long before this.
        -- An override pointing at a language whose file is no longer present
        -- is left in ACP_Data untouched, so it starts working again if the
        -- file comes back, while the effective locale falls back safely.
        self:RestoreLocaleOverride()
        self:ApplyLocaleToUI()

        -- Upgrade from 3.3.7, where both of these were stored localized.
        if savedVar.sorter then
            savedVar.sorter = self:MigrateSorterName(savedVar.sorter)
        end
        for oldName, newName in pairs(LEGACY_CATEGORIES) do
            if collapsedAddons[oldName] ~= nil then
                collapsedAddons[newName] = collapsedAddons[oldName]
                collapsedAddons[oldName] = nil
            end
        end

        if not savedVar.sorter then
            ACP:SetMasterAddonBuilder(GROUP_BY_NAME)
        else
    		ACP:ReloadAddonList()
        end

        if savedVar.NoChildren == nil then
            savedVar.NoChildren = true
        end

		for i = 1, GetNumAddOns() do
			if IsAddOnLoaded(i) then
				local name = GetAddOnInfo(i)
				if name ~= ACP_ADDON_NAME then
					table.insert(ACP_DefaultSet, name)
				end
			end
		end

    	self:ToggleRecursion(not savedVar.NoRecurse)

		this:RegisterEvent("PLAYER_ENTERING_WORLD")
		this:UnregisterEvent("VARIABLES_LOADED")
	elseif event == "PLAYER_ALIVE" then

    	for k,v in pairs(savedVar.ProtectedAddons) do
    	    if type(k) == "number" then savedVar.ProtectedAddons[k] = nil end
    	    if not v then savedVar.ProtectedAddons[k] = nil end
    	end

        local reloadRequired = false
    	for k,v in pairs(savedVar.ProtectedAddons) do
    	    local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(k)
    	    
    	    if reason == 'MISSING' then
    	    	savedVar.ProtectedAddons[k] = nil
    	    elseif (not enabled) or enabled == 0 then
    	    	EnableAddOn(k)
    	    	reloadRequired=true
    	    end

        end

        if reloadRequired then
            if savedVar.reloadRequired then
                savedVar.reloadRequired = nil
            else
                savedVar.reloadRequired = true
            end
        else
            savedVar.reloadRequired = nil
        end
		if savedVar.reloadRequired then
		    StaticPopup_Show("ACP_RELOADUI_START");
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		this:UnregisterEvent("PLAYER_ENTERING_WORLD")
		this:RegisterEvent("PLAYER_ALIVE")


--        ACP:ProcessBugSack("session")
	elseif event == "ADDON_LOADED" then
		ACP:ADDON_LOADED(arg1)
	end

end


function ACP:ResolveLibraryName(id)
    local a, name
    for a = 1, GetNumAddOns() do
	    local n = GetAddOnInfo(a)
	    if n == id then
	        name = n
	    elseif GetAddOnMetadata(a, "X-AceLibrary-"..id) then
	        name = name or n
	    end
	end

	return name
end


--function ACP:ProcessBugSack(which)
--    if BugSack then
--        local errs = BugSack:GetErrors(which)
--    	for i=1, #errs do
--    	    local str = errs[i].message
--    	    if type(str) == "table" then
--    	        str = table.concat(str)
--    	    end
--
--    	    local _,_,id = strfind(str, "Cannot find a library instance of ([_A-Za-z0-9-]+%.?%d?)")
--
--    	    if not id then
--    	        _,_,id = strfind(str, "Library \"([_A-Za-z0-9-]+%.?%d?)\" does not exist")
--    	    end
--
--    	    if not id then
--    	        _,_,id = strfind(str, ".-requires ([_A-Za-z0-9-]+%.?%d?)")
--    	    end
--
--    	    if id then
--                local name = self:ResolveLibraryName(id)
--
--        	    if name then
--        	        local _, _, _, enabled = GetAddOnInfo(name)
--                    if not enabled then
--                        local reload = Prat and Prat:GetReloadUILink("ACP") or L["Reload"]
--                	    ACP:Print(L["*** Enabling <%s> %s your UI ***"]:format(CLR:Addon(name), reload), 1.0, 1.0, 0.0)
--                	    ACP:EnableAddon(name)
--                    end
--            	else
--               	    ACP:Print(L["*** Unknown AddOn <%s> required ***"]:format(CLR:Addon(name)), 1.0, 0.0, 0.0)
--            	end
--            end
--    	end
--    end
--end

--ACP_Data.NoRecurse
--ACP_Data.NoChildren
local ACP_NOCHILDREN = "nochildren"
local ACP_NORECURSE = "norecurse"
local ACP_DEBUG = "debug"
local ACP_HELP = "help"
local ACP_LOCALE = "locale"
local ACP_LANGUAGE = "language"
-- Declared here on purpose: ACP.SlashHandler is defined below and would
-- otherwise capture a global nil instead of this upvalue.
local ACP_LOCALE_AUTO = "auto"

-- State of a single setting. Deliberately NOT L["ENABLED"] / L["DISABLED"]:
-- those are translated as plurals agreeing with "AddOns" and read wrong here.
local function onoff(flag)
    return CLR:Bool(flag, flag and L["ON"] or L["OFF"])
end

function ACP.SlashHandler(msg)
    if type(msg) == "string" then
        msg = msg:trim()

        -- Split the first word off, the rest is the argument. Only the
        -- command word is lowercased: a locale code keeps its own case and
        -- ACP:NormalizeLocaleCode() matches it case insensitively anyway.
        local command, argument = msg:match("^(%S*)%s*(.-)%s*$")
        command = string.lower(command or "")
        argument = argument or ""

        if command == ACP_LOCALE or command == ACP_LANGUAGE then
            ACP:LocaleCommand(argument)
            return
        end

        msg = command

        if msg == ACP_NOCHILDREN then
            savedVar.NoChildren = not savedVar.NoChildren
      	    ACP:Print(L["Load on demand child enabling is now %s."]:format(onoff(not savedVar.NoChildren)))
            return
        end

        if msg == ACP_NORECURSE then
            -- Same entry point as the check button, so the saved variable and
            -- the visual state can never drift apart. Works whether the
            -- window is open or closed.
            ACP:ToggleRecursion()
      	    ACP:Print(L["Recursive enabling is now %s."]:format(onoff(not savedVar.NoRecurse)))
            return
        end

        if msg == ACP_DEBUG then
            ACP.debug = not ACP.debug
            ACP:Print(L["Debug mode is now %s."]:format(onoff(ACP.debug)))
            if ACP.debug then
                -- Report an unknown locale straight away, once per session.
                ACP:WarnUnknownLocale()
            end
            return
        end

        if msg == ACP_HELP or msg == "?" then
            ACP:Print(L["Valid commands:"])
            ACP:Print(CLR:Label("/acp").." - "..L["Opens the AddOn Control Panel."])
            ACP:Print(CLR:Label("/acp "..ACP_NOCHILDREN).." - "..L["Toggles enabling of load on demand child AddOns."])
            ACP:Print(CLR:Label("/acp "..ACP_NORECURSE).." - "..L["Toggles recursive enabling of dependencies."])
            ACP:Print(CLR:Label("/acp "..ACP_DEBUG).." - "..L["Toggles debug output."])
            ACP:Print(CLR:Label("/acp "..ACP_LOCALE).." - "..L["Shows the language ACP is using."])
            ACP:Print(CLR:Label("/acp "..ACP_LOCALE.." <code>").." - "..L["Forces a language."])
            ACP:Print(CLR:Label("/acp "..ACP_LOCALE.." "..ACP_LOCALE_AUTO).." - "..L["Returns to automatic detection."])
            ACP:Print(CLR:Label("/acp "..ACP_HELP).." - "..L["Shows this list."])
            return
        end
    end

	ShowUIPanel(ACP_AddonList)
end

addonListBuilders[DEFAULT] = function()
	for k in pairs(masterAddonList) do
		masterAddonList[k] = nil
	end
	local numAddons = GetNumAddOns()
	for i=1, numAddons do
		table.insert(masterAddonList, i)
	end
	for i=1, NUM_BLIZZARD_ADDONS do
		table.insert(masterAddonList, numAddons+i)
	end
end

addonListBuilders[TITLES] = function()
	for k in pairs(masterAddonList) do
		masterAddonList[k] = nil
	end

	local numAddons = GetNumAddOns()
	for i=1, numAddons do
		table.insert(masterAddonList, i)
	end

	-- Sort the addon list by Ace2 Categories.
	table.sort(masterAddonList, function(a, b)
		local _, nameA = GetAddOnInfo(a)
		local _, nameB = GetAddOnInfo(b)
		return formattitle(nameA) < formattitle(nameB)
	end )

	for i=1, NUM_BLIZZARD_ADDONS do
		table.insert(masterAddonList, numAddons+i)
	end
end

addonListBuilders[ACE2] = function()

	local t = {}

	local numAddons = GetNumAddOns()
	for i=1, numAddons do
		table.insert(t, i)
	end

	-- Sort the addon list by Ace2 Categories.
	table.sort(t, function(a, b)
		local catA = GetAddOnMetadata(a, "X-Category")
		local catB = GetAddOnMetadata(b, "X-Category")
		if catA == catB then
			local nameA = GetAddOnInfo(a)
			local nameB = GetAddOnInfo(b)
			return nameA < nameB
		else
			return tostring(catA) < tostring(catB)
		end
	end )

	-- Insert the category titles into the list.
	local prevCategory = ""
	for i, addonIndex in ipairs(t) do
		local category = GetAddOnMetadata(addonIndex, "X-Category")
		if not category then
			category = CAT_UNDEFINED
		end
		if category ~= prevCategory then
			table.insert(t, i, category)
		end
		prevCategory = category
	end

	table.insert(t, CAT_BLIZZARD)

	for i=1, NUM_BLIZZARD_ADDONS do
		table.insert(t, numAddons+i)
	end

	-- Now build the masterAddonList.
	for k in pairs(masterAddonList) do
		masterAddonList[k] = nil
	end
	local list = masterAddonList
	local currPos = list
	for i, addon in ipairs(t) do
		if type(addon) == 'string' then
			local t = {}
			t.category = addon
			table.insert(list, t)
			currPos = t
		else
			table.insert(currPos, addon)
		end
	end


end


addonListBuilders[AUTHOR] = function()
	local t = {}

	local numAddons = GetNumAddOns()
	for i=1, numAddons do
		table.insert(t, i)
	end

	-- Sort the addon list by Ace2 Categories.
	table.sort(t, function(a, b)
		local catA = GetAddOnMetadata(a, "Author")
		local catB = GetAddOnMetadata(b, "Author")
		if catA == catB then
			local nameA = GetAddOnInfo(a)
			local nameB = GetAddOnInfo(b)
			return nameA < nameB
		else
			return tostring(catA) < tostring(catB)
		end
	end )

	-- Insert the category titles into the list.
	local prevCategory = ""
	for i, addonIndex in ipairs(t) do
		local category = GetAddOnMetadata(addonIndex, "Author")
		if not category then
			category = CAT_UNKNOWN
		end
		if category ~= prevCategory then
			table.insert(t, i, category)
		end
		prevCategory = category
	end

	table.insert(t, CAT_BLIZZARD)

	for i=1, NUM_BLIZZARD_ADDONS do
		table.insert(t, numAddons+i)
	end

	-- Now build the masterAddonList.
	for k in pairs(masterAddonList) do
		masterAddonList[k] = nil
	end
	local list = masterAddonList
	local currPos = list
	for i, addon in ipairs(t) do
		if type(addon) == 'string' then
			local t = {}
			t.category = addon
			table.insert(list, t)
			currPos = t
		else
			table.insert(currPos, addon)
		end
	end

end


--[[
addonListBuilders["Ace2 Libs And Packages"] = function()
	for k in pairs(masterAddonList) do
		masterAddonList[k] = nil
	end

	-- Sort the addon list by Ace2 Categories.
	table.sort(t, function(a, b)
		local catA = GetAddOnMetadata(a, "Author")
		local catB = GetAddOnMetadata(b, "Author")
		if catA == catB then
			local nameA = GetAddOnInfo(a)
			local nameB = GetAddOnInfo(b)
			return nameA < nameB
		else
			return tostring(catA) < tostring(catB)
		end
	end )


	local numAddons = GetNumAddOns()
	for i=1, numAddons do
		table.insert(masterAddonList, i)
	end
	for i=1, NUM_BLIZZARD_ADDONS do
		table.insert(masterAddonList, numAddons+i)
	end
end
--]]

addonListBuilders[SEPARATE_LOD_LIST] = function()
	for k in pairs(masterAddonList) do
		masterAddonList[k] = nil
	end
	local numAddons = GetNumAddOns()
	local name

	local lods = {}
	lods.category = CAT_LOD_ADDONS
	local nonlods = {}
	nonlods.category = CAT_STANDARD_ADDONS
    local blizz = {}
    blizz.category = CAT_BLIZZARD_ADDONS

	for i=1, numAddons do
	    name = GetAddOnInfo(i)
	    if not IsAddOnLoadOnDemand(name) then
		    table.insert(nonlods, i)
		else
		    table.insert(lods, i)
		end
	end

	for i=1, NUM_BLIZZARD_ADDONS do
		table.insert(blizz, numAddons+i)
	end

	table.insert(masterAddonList, nonlods)
	table.insert(masterAddonList, lods)
    table.insert(masterAddonList, blizz)
end



addonListBuilders[GROUP_BY_NAME] = function()
	local t = {}

	local numAddons = GetNumAddOns()
	for i=1, numAddons do
		table.insert(t, i)
	end

	local libs = {}
	libs.category = CAT_LIBRARIES

	-- Sort the addon list by Ace2 Categories.
	table.sort(t, function(a, b)
		local nameA = GetAddOnInfo(a)
		local nameB = GetAddOnInfo(b)

		local catA, catB

		nameA, nameB =  ACP:SpecialCaseName(nameA),  ACP:SpecialCaseName(nameB)

		if nameA:find("_") then
			catA, nameA  = strsplit("_", nameA)
		else
			catA, nameA  = nameA
		end

		if nameB:find("_") then
			catB, nameB  = strsplit("_", nameB)
		else
			catB, nameB  = nameB
		end

		if catA:lower() == catB:lower() then
			return (nameA or ""):lower() < (nameB or ""):lower()
		else
			return tostring(catA):lower() < tostring(catB):lower()
		end
	end )



	-- Insert the category titles into the list.
	local prevCategory = ""
	local name = nil
	local t2 = t
	t = {}
	for i, addonIndex in ipairs(t2) do
	    name = ACP:SpecialCaseName(GetAddOnInfo(addonIndex))

	    local acecategory = GetAddOnMetadata(addonIndex, "X-Category")

		if acecategory == "Library" and not ACP:IsAddOnProtected(name) then
		    table.insert(libs, addonIndex)
        else
    		local category, content = strsplit("_", name)
    		if not content then
    		    content = category
    			category = ""
    		end
    		if category:lower() ~= prevCategory:lower() then
    			table.insert(t, category)
    		end

			table.insert(t, addonIndex)
    		prevCategory = category
    	end
	end



    local blizz = {}
    blizz.category = CAT_BLIZZARD_ADDONS

	for i=1, NUM_BLIZZARD_ADDONS do
		table.insert(blizz, numAddons+i)
	end

	-- Now build the masterAddonList.
	for k in pairs(masterAddonList) do
		masterAddonList[k] = nil
	end
	local list = masterAddonList
	local currPos = list
	for i, addon in ipairs(t) do
		if type(addon) == 'string' then
		    if addon == "" then
		        currPos = list
		    else
    			local t = {}
    			t.category = addon
--    			table.remove(currPos, #currPos)
                local addonpos = currPos[#currPos]
                if addonpos then
                    local addonname =  ACP:SpecialCaseName(GetAddOnInfo(addonpos))
                    if (addonname == addon) then table.remove(currPos,#currPos) end
        			table.insert(list, t)
        			currPos = t
        		end
    		end
		else
   			table.insert(currPos, addon)
		end
	end



	table.insert(masterAddonList, libs)
    table.insert(masterAddonList, blizz)
end


function ACP:ToggleUI()
--[[ added Mon Jul 30 12:14:24 CEST 2007 - fin

wanted an easy way to toggle the UI on / off for CustomMenuFu

NOTE: maybe change the slash handler to use this instead?
]]
	if ACP_AddonList:IsShown() then
		HideUIPanel(ACP_AddonList)
	else
		ShowUIPanel(ACP_AddonList)
	end
end



function ACP:ReloadAddonList()

 	local builder = savedVar.sorter
	if not builder then
		builder = DEFAULT
	end

	local func = addonListBuilders[builder]
	if not func then
		func = addonListBuilders[DEFAULT]
	end

	func()

	self:RebuildSortedAddonList()
	ACP:AddonList_OnShow()


	ACP_AddonListSortDropDownText:SetText(L[builder])
	local button = _G[ACP_FRAME_NAME.."SortDropDown"]
	UIDropDownMenu_SetSelectedValue( button, builder)

end

--function ACP:OnKeyDown(this, key)
--   -- print(this, key)
--	if ( key == "ESCAPE" ) then
--		HideUIPanel(ACP_AddonList);
--	elseif ( key == "PRINTSCREEN" ) then
--		Screenshot();
--	elseif ( key == "PAGEUP" ) then
--		ScrollFrameTemplate_OnMouseWheel(ACP_AddonList_ScrollFrame, 1)
--	elseif ( key == "PAGEDOWN" ) then
--		ScrollFrameTemplate_OnMouseWheel(ACP_AddonList_ScrollFrame, -1)
--	end
--end



--
-- Shift will invert the use of recursion
-- Ctrl will invert the use of LoD children
--
function ACP:EnableAddon(addon, shift, ctrl)
    local norecurse = ACP_Data.NoRecurse
    if shift then norecurse = not norecurse end

    local nochildren = ACP_Data.NoChildren
    if ctrl then nochildren = not nochildren end

    if norecurse then
        EnableAddOn(addon)
    else
    	local name = GetAddOnInfo(addon)
        ACP_EnableRecurse(name, nochildren)
    end
end

function ACP:ReadDependencies(t, ...)
	for k in pairs(t) do
		t[k] = nil
	end
	for i=1, select('#', ...) do
		local name = select(i, ...)
		if name then
			t[name] = true
		end
	end
	return t
end

function ACP:EnableDependencies(addon)
	local deps = self:ReadDependencies(acquire(), GetAddOnDependencies(addon))

	if next(deps) then
		for k in pairs(deps) do
			self:EnableAddon(k)
		end
	end

	reclaim(deps)

end

function ACP:FindAddon(list, name)
	for i, v in ipairs(list) do
		if v == name then
			return true
		end
	end
	return nil
end

function ACP:FindAddonKey(list, name)
	for k, v in pairs(list) do
		if k == name then
			return true
		end
	end
	return nil
end


function ACP:Print(msg, r, g, b)
	DEFAULT_CHAT_FRAME:AddMessage("ACP: ".. msg, r, g, b)
end

function ACP:CollapseAll(collapse)
	local categories = {}

	for i, addon in ipairs(masterAddonList) do
		if type(addon) == 'table' and addon.category then
			table.insert(categories, addon.category)
		end
	end


	for i, category in ipairs(categories) do
		collapsedAddons[category] = collapse
	end

	self:RebuildSortedAddonList()
end

function ACP:SaveSet(set)
	if not savedVar.AddonSet then
		savedVar.AddonSet = {}
	end

	if not savedVar.AddonSet[set] then
		savedVar.AddonSet[set] = {}
	end

	local addonSet = savedVar.AddonSet[set]

	local setName = addonSet.name
	for k in pairs(addonSet) do
		addonSet[k] = nil
	end

	addonSet.name = setName

	local name, enabled
	for i = 1, GetNumAddOns() do
		name, _, _, enabled = GetAddOnInfo(i)
		if enabled and name ~= ACP_ADDON_NAME then
			table.insert(addonSet, name)
		end
	end

	self:Print(L["AddOn set [%s] saved."]:format(self:GetSetName(set)) )

end

function ACP:GetSetName(set)
	if set == ACP_DEFAULT_SET then
		return L["Default"]
	elseif set == playerClass then
		return playerClass
	elseif savedVar and savedVar.AddonSet and savedVar.AddonSet[set] and savedVar.AddonSet[set].name then
		return savedVar.AddonSet[set].name
	else
		return L["Set %d"]:format(set)
	end
end

function ACP:UnloadSet(set)

	local list

	if set == ACP_DEFAULT_SET then
		list = ACP_DefaultSet
	else
		if not savedVar or not savedVar.AddonSet or not savedVar.AddonSet[set] then return end
		list = savedVar.AddonSet[set]
	end

	local name
	for i = 1, GetNumAddOns() do
		name = GetAddOnInfo(i)
		if name ~= ACP_ADDON_NAME and ACP:FindAddon( list, name ) and not ACP:IsAddOnProtected(name) then
			DisableAddOn(name)
		end
	end

	self:Print(L["AddOn set [%s] unloaded."]:format(self:GetSetName(set)) )
	ACP:AddonList_OnShow()
end

function ACP:ClearSelectionAndLoadSet(set)
	self:DisableAll_OnClick()

	self:LoadSet(set)
end

function ACP:LoadSet(set)
	local list

	if set == ACP_DEFAULT_SET then
		list = ACP_DefaultSet
	else
		if not savedVar or not savedVar.AddonSet or not savedVar.AddonSet[set] then return end
		list = savedVar.AddonSet[set]
	end

	enabledList = acquire()
	local name
	for i = 1, GetNumAddOns() do
		name = GetAddOnInfo(i)
		if ACP:FindAddon( list, name ) then
			self:EnableAddon(name)
		end
	end

	reclaim(enabledList)
	enabledList = nil

	self:Print(L["AddOn set [%s] loaded."]:format(self:GetSetName(set)) )
	ACP:AddonList_OnShow()

end

function ACP:IsAddOnProtected(addon)
	local addon = GetAddOnInfo(addon)
	if addon and savedVar.ProtectedAddons then
		return savedVar.ProtectedAddons[addon]
	end
end

function ACP:Security_OnClick(addon)
     local addon = GetAddOnInfo(addon)
     if addon then
         savedVar.ProtectedAddons = savedVar.ProtectedAddons or { ["ACP"] = true }
         local prot = savedVar.ProtectedAddons[addon]
         if prot then
            savedVar.ProtectedAddons[addon] = nil
         else
            savedVar.ProtectedAddons[addon] = true
         end

         EnableAddOn(addon)
     end
     self:AddonList_OnShow()
end

function ACP:ShowSecurityTooltip(this)
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT")

    GameTooltip:AddLine(L["Click to toggle protected mode. Protected AddOns are re-enabled automatically when you reload the UI."], 1, 1, 1, 1)

	GameTooltip:Show()
end


function ACP:RenameSet(set, name)

	local oldName = self:GetSetName(set)
	if not savedVar then savedVar = {} end
	if not savedVar.AddonSet then savedVar.AddonSet = {} end
	if not savedVar.AddonSet[set] then savedVar.AddonSet[set] = {} end
	savedVar.AddonSet[set].name = name

	-- Ask for the visible name again: clearing the custom name has to fall
	-- back to "Set 1", "Set 2", ... instead of printing nil.
	local newName = self:GetSetName(set)

	self:Print(L["AddOn set [%s] renamed to [%s]."]:format(oldName, newName) )

end

-- Rebuild sortedAddonList from masterAddonList

function ACP:RebuildSortedAddonList()
	for k in pairs(sortedAddonList) do
		sortedAddonList[k] = nil
	end

	for i, addon in ipairs(masterAddonList) do
		if type(addon) == 'table' then
			local category = addon.category
			if category then
				table.insert(sortedAddonList, category)
			end
			if not category or not collapsedAddons[category] then
				for j, subAddon in ipairs(addon) do
					table.insert(sortedAddonList, subAddon)
				end
			end
		else
			--addon = GetAddonIndex(addon)
			table.insert(sortedAddonList, addon)
		end
	end

--	ACP.masterAddonList = masterAddonList
--	ACP.sortedAddonList = sortedAddonList
end

function ACP:SetMasterAddonBuilder(sorter)
	if not addonListBuilders[sorter] or not savedVar then return end
	for k in pairs(collapsedAddons) do
		collapsedAddons[k] = nil
	end
	savedVar.sorter = sorter
	self:ReloadAddonList()
end

-- UI Controllers.
--==============
-- Language selector
--==============

--- Re-applies every string that was written once into a widget. Called from
-- OnLoad and again whenever the language changes, so most of the window
-- follows a language change without a reload.
function ACP:ApplyLocaleToUI()
	if GameMenuButtonAddOns then
		GameMenuButtonAddOns:SetText(L["AddOns"])
	end

	if not _G[ACP_FRAME_NAME] then return end

	for i = 1, ACP_MAXADDONS do
		local button = _G[ACP_FRAME_NAME.."Entry"..i.."LoadNow"]
		if button then button:SetText(L["Load"]) end
	end

	local function setText(suffix, text)
		local widget = _G[ACP_FRAME_NAME..suffix]
		if widget then widget:SetText(text) end
	end

	setText("DisableAll", L["Disable All"])
	setText("EnableAll", L["Enable All"])
	setText("SetButton", L["Sets"])
	setText("_ReloadUI", L["Reload UI"])
	setText("BottomClose", L["Close"])
	setText("_NoRecurseText", L["Recursive"])

	if savedVar and savedVar.sorter then
		setText("SortDropDownText", L[savedVar.sorter])
	end

	self:UpdateLocaleDropDown()
end

--- Text shown on the closed drop down: the native name of the language in
-- use, never the word "Language". The generic word is the tooltip.
function ACP:GetLocaleDropDownText()
	return self:GetLocaleName(self:GetEffectiveLocale())
end

--- Label of the automatic entry: only the word is translated, the detected
-- code is shown as it is so the user can see what WoW reported.
function ACP:GetAutomaticLocaleText()
	return L["Automatic"].." \226\128\148 "..tostring(self:GetDetectedLocale())
end

function ACP:UpdateLocaleDropDown()
	local button = _G[ACP_FRAME_NAME.."LocaleDropDown"]
	if not button then return end

	local text = _G[ACP_FRAME_NAME.."LocaleDropDownText"]
	if text then text:SetText(self:GetLocaleDropDownText()) end

	if UIDropDownMenu_SetSelectedValue then
		UIDropDownMenu_SetSelectedValue(button, self:GetLocaleOverride() or ACP_LOCALE_AUTO)
	end
end

function ACP:LocaleDropDown_OnShow(this)
	if not self.initLocaleDropDown then
		if UIDropDownMenu_SetWidth then
			-- WotLK signature: (frame, width [, padding]).
			UIDropDownMenu_SetWidth(this, 170)
		end
		UIDropDownMenu_Initialize(this, function() self:LocaleDropDown_Populate() end)
		self.initLocaleDropDown = true
	end
	self:UpdateLocaleDropDown()
end

--- Builds the menu. Language names are always shown in their own language so
-- that a user who picks the wrong one by accident can still find the way back.
function ACP:LocaleDropDown_Populate()
	local current = self:GetLocaleOverride()
	local info

	info = UIDropDownMenu_CreateInfo()
	info.text = self:GetAutomaticLocaleText()
	info.value = ACP_LOCALE_AUTO
	info.checked = (current == nil)
	info.func = function() ACP:SelectLocale(ACP_LOCALE_AUTO) end
	UIDropDownMenu_AddButton(info)

	local codes = self:GetRegisteredLocales()
	for i = 1, #codes do
		local code = codes[i]
		info = UIDropDownMenu_CreateInfo()
		info.text = self:GetLocaleName(code)
		info.value = code
		info.checked = (current == code)
		info.func = function() ACP:SelectLocale(code) end
		UIDropDownMenu_AddButton(info)
	end
end

function ACP:LocaleDropDown_OnEnter(this)
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
	GameTooltip:AddLine(L["Language"])
	GameTooltip:AddLine(L["ACP locale: %s"]:format(self:GetLocaleName(self:GetEffectiveLocale())), 1, 1, 1, 1)
	GameTooltip:AddLine(L["Detected locale: %s"]:format(tostring(self:GetDetectedLocale())), 1, 1, 1, 1)
	GameTooltip:Show()
end

function ACP:LocaleDropDown_OnLeave()
	GameTooltip:Hide()
end

--- Read only access to ACP_Data. Nothing inside ACP uses it; it exists so the
-- saved state can be inspected from a macro or from the self test.
function ACP:GetSavedVariables()
	return savedVar
end

--- Applies ACP_Data.localeOverride. Extracted from the VARIABLES_LOADED
-- handler so it can be tested on its own.
-- An override naming a language whose file is not present is NOT erased from
-- ACP_Data: it starts working again if the file comes back, and meanwhile the
-- effective locale falls back to the detected one, or to enUS.
-- @return true when a stored override was applied
function ACP:RestoreLocaleOverride()
	if not savedVar then return false end

	if not savedVar.localeOverride then
		self:ClearLocaleOverride()
		return false
	end

	if self:SetLocale(savedVar.localeOverride) then
		return true
	end

	if ACP.debug then
		self:Print(L["Locale %s is not registered."]:format(tostring(savedVar.localeOverride)))
	end
	self:ClearLocaleOverride()
	return false
end

--- Single entry point for the slash command and for the drop down.
-- Pass nil or "auto" to go back to automatic detection.
-- @return ok, normalizedCode
function ACP:SelectLocale(code)
	if code == nil or code == ACP_LOCALE_AUTO then
		self:ClearLocaleOverride()
		if savedVar then savedVar.localeOverride = nil end
		self:ApplyLocaleToUI()
		self:Print(L["ACP language returned to automatic detection."])
		self:PromptLocaleReload(L["ACP language returned to automatic detection."])
		return true, nil
	end

	local ok, normalized = self:SetLocale(code)
	if not ok then
		-- Nothing is stored: a typo must never leave ACP without strings.
		self:Print(L["Locale %s is not registered."]:format(tostring(code)))
		return false, nil
	end

	if savedVar then savedVar.localeOverride = normalized end
	self:ApplyLocaleToUI()

	-- From here on L[] already answers in the new language.
	local message = L["ACP language set to %s."]:format(self:GetLocaleName(normalized))
	self:Print(message)
	self:PromptLocaleReload(message)
	return true, normalized
end

function ACP:PromptLocaleReload(message)
	local dialog = StaticPopupDialogs and StaticPopupDialogs["ACP_LOCALE_RELOAD"]
	if not dialog then return false end

	-- Re-translate the buttons: they were built in the previous language.
	dialog.button1 = L["Reload now"]
	dialog.button2 = L["Later"]

	if StaticPopup_Show then
		StaticPopup_Show("ACP_LOCALE_RELOAD", message,
			L["Reload the UI to apply the language change."])
	end
	return true
end

--- /acp locale, /acp locale <code>, /acp locale auto
function ACP:LocaleCommand(argument)
	if argument and argument ~= "" then
		if string.lower(argument) == ACP_LOCALE_AUTO then
			self:SelectLocale(ACP_LOCALE_AUTO)
		else
			self:SelectLocale(argument)
		end
		return
	end

	local override = self:GetLocaleOverride()
	self:Print(L["Detected locale: %s"]:format(tostring(self:GetDetectedLocale())))
	self:Print(L["ACP locale: %s"]:format(
		self:GetEffectiveLocale().." - "..self:GetLocaleName(self:GetEffectiveLocale())))
	self:Print(L["Locale override: %s"]:format(
		override and (override.." - "..self:GetLocaleName(override)) or L["Automatic"]))

	self:Print(L["Valid locale commands:"])
	local codes = self:GetRegisteredLocales()
	self:Print(CLR:Label("/acp locale").." - "..L["Shows the language ACP is using."])
	self:Print(CLR:Label("/acp locale <"..table.concat(codes, "|")..">")
		.." - "..L["Forces a language."])
	self:Print(CLR:Label("/acp locale "..ACP_LOCALE_AUTO).." - "..L["Returns to automatic detection."])
end

function ACP:SortDropDown_OnShow(this)
	if not self.initSortDropDown then
		if UIDropDownMenu_SetWidth then
			-- Same as the template default, stated explicitly so the header
			-- row geometry is deterministic next to the language selector.
			UIDropDownMenu_SetWidth(this, 115)
		end
		UIDropDownMenu_Initialize(this, function() self:SortDropDown_Populate() end)
		self.initSortDropDown = true
	end
end

function ACP:SortDropDown_Populate()
	local info
	local seen = {}

	local function add(name)
		if seen[name] or not addonListBuilders[name] then return end
		seen[name] = true
		info = UIDropDownMenu_CreateInfo()
		info.text = L[name]
		info.value = name
		info.func = function() self:SetMasterAddonBuilder(name) end
		UIDropDownMenu_AddButton(info)
	end

	-- Built in criteria first, always in the same order...
	for i = 1, #SORTER_ORDER do
		add(SORTER_ORDER[i])
	end
	-- ...then whatever a third party addon registered.
	for name in pairs(addonListBuilders) do
		add(name)
	end
end

function ACP:SortDropDown_OnClick(sorter)

end

function ACP:DisableAll_OnClick()
	DisableAllAddOns()
	EnableAddOn(ACP_ADDON_NAME)

	for k in pairs(savedVar.ProtectedAddons) do
	    EnableAddOn(k)
	end
	self:AddonList_OnShow()
end

function ACP:Collapse_OnClick(obj)

	local category = obj.category
	if not category then return end

	collapsedAddons[category] = toggle(collapsedAddons[category])

	self:RebuildSortedAddonList()
	self:AddonList_OnShow()

end

function ACP:CollapseAll_OnClick()
	local obj = _G[ACP_FRAME_NAME.."CollapseAll"]
	local icon = _G[ACP_FRAME_NAME.."CollapseAllIcon"]
	obj.collapsed = toggle(obj.collapsed)
	if obj.collapsed then
		icon:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomInButton-Up")
	else
		icon:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomOutButton-Up")
	end
	self:CollapseAll(obj.collapsed)
	self:AddonList_OnShow()
end

function ACP:GetAddonCategory(addon)
	for i, a in ipairs(masterAddonList) do
		if type(a) == 'table' then
            if self:FindAddon(a, addon) then
                return a.category
            end
        else
            if a == addon then
                return ""
            end
        end
   end
end

function ACP:GetAddonCategoryTable(addon)
	for i, a in ipairs(masterAddonList) do
		if type(a) == 'table' then
            if a.category == addon then
                return a
            end
        else
            if a == addon then
                return nil
            end
        end
   end
end


function ACP:AddonList_Enable(addonIndex,enabled, shift, ctrl, category)
	if (type(addonIndex) == "number") then
		if (enabled) then
			enabledList = acquire()
			self:EnableAddon(addonIndex, shift, ctrl)
			reclaim(enabledList)
			enabledList = nil
		else
			DisableAddOn(addonIndex)
		end

		if category and collapsedAddons[category] then
    	    local t = self:GetAddonCategoryTable(category)
    	    if t then
                self:Print(L["%s is collapsed. Setting all of its AddOns to %s."]:format(
                    CLR:Addon(self:LocalizeCategory(category)),
                    CLR:Bool(enabled, enabled and L["ENABLED"] or L["DISABLED"])))
                -- ipairs: the table also holds a non numeric 'category' field.
        	    for _, v in ipairs(t) do
        	        if enabled then
            	        self:EnableAddon(v, shift, ctrl)
            	    else
            	        DisableAddOn(v)
            	    end
        	    end
        	end
        end
	end
	self:AddonList_OnShow()
end

function ACP:AddonList_LoadNow(index)
	UIParentLoadAddOn(index)
	ACP:AddonList_OnShow()
end

function ACP:AddonList_OnShow(this)
	local function setSecurity (obj, idx)
		local width,height,iconWidth = 64,16,16
		local increment = iconWidth/width
		local left = (idx-1)*increment
		local right = idx*increment
		obj:SetTexCoord(left, right, 0, 1)
	end

	UpdateAddOnMemoryUsage()

    local obj
	local origNumAddons = GetNumAddOns()
	local numAddons = #sortedAddonList
	FauxScrollFrame_Update(ACP_AddonList_ScrollFrame, numAddons, ACP_MAXADDONS, ACP_LINEHEIGHT, nil, nil, nil)
	local i
	local offset = FauxScrollFrame_GetOffset(ACP_AddonList_ScrollFrame)
	local curr_category = ""
	for i = 1, ACP_MAXADDONS, 1 do
		obj = _G["ACP_AddonListEntry"..i]
		local addonIdx = sortedAddonList[offset+i]

   --     if not curr_category then
            curr_category = self:GetAddonCategory(addonIdx) or ""
     --   end
		if offset+i > #sortedAddonList then
			obj:Hide()
			obj.addon = nil
		else
			local headerText = _G["ACP_AddonListEntry"..i.."Header"]
			local titleText = _G["ACP_AddonListEntry"..i.."Title"]
			local status = _G["ACP_AddonListEntry"..i.."Status"]
			local checkbox = _G["ACP_AddonListEntry"..i.."Enabled"]
			local securityButton = _G["ACP_AddonListEntry"..i.."Security"]
			local securityIcon = _G["ACP_AddonListEntry"..i.."SecurityIcon"]
			local loadnow = _G["ACP_AddonListEntry"..i.."LoadNow"]
			local collapse = _G["ACP_AddonListEntry"..i.."Collapse"]
			local collapseIcon = _G["ACP_AddonListEntry"..i.."CollapseIcon"]


			if type(addonIdx) == 'string' and not GetAddonIndex(addonIdx, true) then
--				curr_category  = addonIdx
				obj.addon = nil
				obj.category = addonIdx
				obj:Show()
				headerText:SetText(self:LocalizeCategory(addonIdx))
				headerText:Show()
				titleText:Hide()
				status:Hide()
				checkbox:Hide()
				securityButton:Hide()
				loadnow:Hide()
				if collapsedAddons[addonIdx] then
					collapseIcon:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomInButton-Up")
				else
					collapseIcon:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomOutButton-Up")
				end
				collapse:Show()
			else
			    if type(addonIdx) == 'string' then
				    obj.category = addonIdx
--    				curr_category  = addonIdx
    				if collapsedAddons[addonIdx] then
    					collapseIcon:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomInButton-Up")
    				else
    					collapseIcon:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomOutButton-Up")
    				end
        			collapse:Show()
				    securityButton:Hide()
        			addonIdx = GetAddonIndex(addonIdx, true)
                else
    			    obj.category = nil
					collapse:Hide()

					if curr_category  == "" then
    					securityButton:Show()
    				else
    				    securityButton:Hide()
    			    end
    			end
				obj:Show()
				headerText:Hide()
				titleText:Show()
				status:Show()

                local subCount = nil
                if collapsedAddons[obj.category] then
                    local t = self:GetAddonCategoryTable(obj.category)
                    subCount = t and #t
                end

				local name, title, notes, enabled, loadable, reason, security
				if (addonIdx > origNumAddons) then
					name = ACP_BLIZZARD_ADDONS[(addonIdx-origNumAddons)]
					name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(name)
					-- Friendly title from the active locale, when it has one.
					title = self:GetLocaleString(name) or title
--					obj.addon = name
--					title = L[name]
--					notes = ""
--					enabled = 1
--					loadable = 1
--					if (IsAddOnLoaded(name)) then
--						reason = "LOADED"
--						loadable = 1
--					end
--					security = "SECURE"
					obj.addon = name
				else
					name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(addonIdx)
					obj.addon = addonIdx
				end
				local loaded = IsAddOnLoaded(name)
				local ondemand = IsAddOnLoadOnDemand(name)
				if (loadable) then
					titleText:SetTextColor(1,0.78,0)
				elseif (enabled and reason ~= "DEP_DISABLED") then
					titleText:SetTextColor(1,0.1,0.1)
				else
					titleText:SetTextColor(0.5,0.5,0.5)
				end

				if (title) then

				    if subCount and subCount > 0 then
    				    title = title .. "  |cffffffff(|r"..tostring(subCount).."|cffffffff)|r"
    				end

					title = title:gsub(" |cff7fff7f %-Ace2%-|r", ""):gsub("%-Ace2%-", ""):trim()

				    if not (loaded or loadable) then
					    titleText:SetText(title:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""))
				    else
				        titleText:SetText(formattitle(title))
				    end
				else
					titleText:SetText(name)
				end

--			    checkbox:ClearAllPoints()
			    if curr_category == "" then
                    checkbox:SetPoint("LEFT", 5, 0)
			        if collapse:IsShown() then
                        checkbox:SetWidth(32)
                        checkbox:SetHeight(32)
                    else
                        checkbox:SetWidth(32)
                        checkbox:SetHeight(32)
                    end
	            else
                    checkbox:SetPoint("LEFT", 21, 0)
                    checkbox:SetWidth(16)
                    checkbox:SetHeight(16)
                end

				if (name == ACP_ADDON_NAME or addonIdx > origNumAddons) then
					checkbox:Hide()
				else
					checkbox:Show()
					checkbox:SetChecked(enabled)
				end

				if addonIdx <= origNumAddons and
				    savedVar.ProtectedAddons[name] then
    					setSecurity(securityIcon,4)
    					securityButton:Show()
    					checkbox:Hide()
                else
--    				if (security == "SECURE") then
--    					setSecurity(securityIcon,1)
--    				elseif (security == "INSECURE") then
--    					setSecurity(securityIcon,2)
--    				elseif (security == "BANNED") then -- wtf?
--    					setSecurity(securityIcon,3)
--    				end

                    local compat = self:GetAddonCompatibilitySummary(addonIdx)

                    if compat ~= nil then
                        setSecurity(securityIcon,1)
                    else
                        setSecurity(securityIcon,2)
                    end

                end

--[[
				if (reason) then
					status:SetText(TEXT(_G["ADDON_"..reason)))
				elseif (loaded) then
					status:SetText(L["Loaded"])
				elseif (ondemand) then
					status:SetText(L["Loaded on demand."])
				else
					status:SetText("")
				end
]]				if addonIdx <= origNumAddons then
	                status:SetText(CLR:Colorize(self:GetAddonStatus(addonIdx)))
				end

				if (not loaded and enabled and ondemand) then
					loadnow:Show()
				else
					loadnow:Hide()
				end
			end
		end

	end
end

function ACP:SetButton_OnClick(this)
	if not self.dropDownFrame then
		local frame = CreateFrame("Frame", "ACP_SetDropDown", nil, "UIDropDownMenuTemplate")
		UIDropDownMenu_Initialize(frame, ACP.SetDropDown_Populate, "MENU") -- wotlk temp hack fixing the UIDropDown menu not displayed after pressing "Sets" button
		self.dropDownFrame = frame
	end
	ToggleDropDownMenu(1, nil, self.dropDownFrame, this, 0, 0)
end


function ACP:SetDropDown_Populate(level)
	self = ACP -- wotlk temp hack fixing the UIDropDown menu not displayed after pressing "Sets" button
	if not savedVar then return end

	if level == 1 then

		local info, count, name
		for i = 1, 	ACP_SET_SIZE do
			local name = nil

			info = UIDropDownMenu_CreateInfo()
			if savedVar.AddonSet and savedVar.AddonSet[i] then
				count = #savedVar.AddonSet[i]
			else
				count = 0
			end

			name = self:GetSetName(i)

			info = UIDropDownMenu_CreateInfo()
			info.text = string.format("%s (%d)", name, count)
			info.value = i
			info.hasArrow = 1
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info)
		end

		-- Class set.
		if savedVar.AddonSet and savedVar.AddonSet[playerClass] then
			count = #savedVar.AddonSet[playerClass]
		else
			count = 0
		end
		info = UIDropDownMenu_CreateInfo()
		info.text = string.format("%s (%d)", playerClass, count)
		info.value = playerClass
		info.hasArrow = 1
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info)

		-- Default set.
		info = UIDropDownMenu_CreateInfo()
		info.text = string.format("%s (%d)", L["Default"], #ACP_DefaultSet)
		info.value = ACP_DEFAULT_SET
		info.hasArrow = 1
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info)

	elseif level == 2 then
        local info
		local setName = self:GetSetName(UIDROPDOWNMENU_MENU_VALUE)
		info = UIDropDownMenu_CreateInfo()
		info.text = setName
		info.isTitle = 1
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)


		if UIDROPDOWNMENU_MENU_VALUE ~= ACP_DEFAULT_SET then
			info = UIDropDownMenu_CreateInfo()
			info.text = L["Save"]
			info.func = function()
				self.savingSet = UIDROPDOWNMENU_MENU_VALUE
				StaticPopup_Show("ACP_SAVESET", setName)
			end
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info, level)
		end

		info = UIDropDownMenu_CreateInfo()
		info.text = L["Load"]
		info.func = function() self:ClearSelectionAndLoadSet(UIDROPDOWNMENU_MENU_VALUE) end
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)


		info = UIDropDownMenu_CreateInfo()
		info.text = L["Add to current selection"]
		info.func = function() self:LoadSet(UIDROPDOWNMENU_MENU_VALUE) end
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)


		info = UIDropDownMenu_CreateInfo()
		info.text = L["Remove from current selection"]
		info.func = function() self:UnloadSet(UIDROPDOWNMENU_MENU_VALUE) end
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)

		if UIDROPDOWNMENU_MENU_VALUE ~= ACP_DEFAULT_SET and UIDROPDOWNMENU_MENU_VALUE ~= playerClass then
			info = UIDropDownMenu_CreateInfo()
			info.text = L["Rename"]
			info.func = function()
				self.renamingSet = UIDROPDOWNMENU_MENU_VALUE
				StaticPopup_Show("ACP_RENAMESET", setName)
				CloseDropDownMenus(1)
			end
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info, level)
		end

	end



end





do
	-- /print ACP.embedded_libs
	ACP.embedded_libs = {}
	-- /print ACP.embedded_libs_owners
	ACP.embedded_libs_owners = {}


	function ACP:ADDON_LOADED(name)
		if not LibStub then return end
		self:LocateEmbeds()

		if name == "ACP" or name:sub(1, 9) == "Blizzard_" then
			name = "???"
		end

		for k,v in pairs(ACP.embedded_libs_owners) do
			if type(v) == "boolean" then
				ACP.embedded_libs_owners[k] = name
			end
		end

	end

	-- /script ACP:LocateEmbeds()
	function ACP:LocateEmbeds()
		local embeds = LibStub.libs

		for k,v in pairs(embeds) do
			if self.embedded_libs[k] ~= v then
				self.embedded_libs[k] = v
				self.embedded_libs_owners[k] = true
			end
		end
	end
end

function ACP:ShowTooltip(this, index)
	if not index then return end

	-- Work out what kind of entry this is BEFORE index is turned into a
	-- folder name. Only Blizzard entries may take their title from the locale
	-- table: a normal addon whose folder happens to be called Author, Status,
	-- Default, Libraries, Reload or Unknown must keep its real title.
	-- The list is reached both as a number (from the sorted list) and as a
	-- name (obj.addon holds the folder name for Blizzard rows), so both
	-- shapes are recognized here.
	local isBlizzardEntry = (type(index) == "number" and index > GetNumAddOns())
		or (type(index) == "string" and ACP_BLIZZARD_ADDONS[index] ~= nil)

	if type(index) == "number" and (index > GetNumAddOns()) then
		index = ACP_BLIZZARD_ADDONS[(index-GetNumAddOns())]
	end

	local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(index)
	if isBlizzardEntry then
		title = self:GetLocaleString(name) or title
	end
	local author = GetAddOnMetadata(name, "Author")
	local version = ParseVersion(GetAddOnMetadata(name, "Version"))
	local deps = { GetAddOnDependencies(index) }

	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT")
	if title then
	  GameTooltip:AddLine(formattitle(title), 1,0.78,0,1)
	else
	  GameTooltip:AddLine(name, 1,0.78,0,1)
	end
	if author then
		GameTooltip:AddLine(string.format("%s: %s", CLR:Label(L["Author"]), author), 1, 1, 1, 1)
	end
	if version then
		GameTooltip:AddLine(string.format("%s: %s", CLR:Label(L["Version"]), version), 1, 1, 1, 1)
	end



	if notes then
		GameTooltip:AddLine(notes, 1, 1, 1, 1)
	else
	  GameTooltip:AddLine(L["No information available."], 1, 1, 1)
	end

	-- GetAddonStatus() returns (colour, text). Query it once, keep both apart
	-- and colour the text; never use the colour as an addon index.
	local statusColor, statusText = self:GetAddonStatus(index)
	if statusText and statusText ~= "" then
		GameTooltip:AddLine(CLR:Label(L["Status"])..": "..CLR:Colorize(statusColor, statusText), 1, 1, 1, 1)
    end

    local depLine
	local dep = deps[1]
	if dep then
		depLine = CLR:Label(L["Dependencies"])..": "..CLR:AddonStatus(dep, dep)
		 for i = 2, #deps do
		    dep = deps[i]
		 	if dep and dep:len()>0 then
		 		depLine = depLine..", "..CLR:AddonStatus(dep, dep)
		 	end
		 end
		 GameTooltip:AddLine(depLine, 1, 1, 1, 1)
	end

	local metaXEmbeds = GetAddOnMetadata(name, "X-Embeds")
	if metaXEmbeds ~= nil then
    	local deps = {strsplit(" ,", metaXEmbeds:trim())}

    	local dep = deps[1]
    	if dep then
    		depLine = CLR:Label(L["Embedded Libraries"])..": "..CLR:AddonStatus(dep, dep)
    		 for i = 2, #deps do
    		    dep = deps[i]
    		 	if dep and dep:len()>0 then
    		 		depLine = depLine..", "..CLR:AddonStatus(dep, dep)
    		 	end
    		 end
    		 GameTooltip:AddLine(depLine, 1,0.78,0, 1)
    	end
    end

	local actives = nil
	for k,v in pairs(self.embedded_libs_owners) do
		if v == name then
			if actives == nil then
				actives = CLR:Label(L["Active Embedded Libraries"])..": "..CLR:ActiveEmbed(k)
			else
				actives = actives..", "..CLR:ActiveEmbed(k)
			end
		end
	end
	if actives then
	    GameTooltip:AddLine(actives, 1,0.78,0, 1)
	end

	--UpdateAddOnMemoryUsage()
	local mem = GetAddOnMemoryUsage(index)
	local text2
	if mem > 1024 then
		text2 = ("|cff8080ff%.2f|r MiB"):format(mem / 1024)
	else
		text2 = ("|cff8080ff%.0f|r KiB"):format(mem)
	end

	GameTooltip:AddLine(CLR:Label(L["Memory Usage"])..": "..text2, 1,0.78,0, 1)




    local high, low = self:IsAddonCompatibleWithCurrentInterfaceVersion(index)

    if low == false then
		GameTooltip:AddLine(CLR:Label(L["Compatible"])..": ".. CLR:Bool(false, NO), 1,0.78,0, 1)
    elseif high == false then
		GameTooltip:AddLine(CLR:Label(L["Compatible"])..": ".. CLR:Bool(false, NO), 1,0.78,0, 1)
	elseif high or low then
		GameTooltip:AddLine(CLR:Label(L["Compatible"])..": ".. CLR:Bool(true, YES), 1,0.78,0, 1)
	end



	GameTooltip:Show()
end


function ACP:ShowHintTooltip(this, index)
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT")

    GameTooltip:AddLine(L["Use SHIFT to override the current dependency enabling behavior."], 1, 1, 1, 1)

	GameTooltip:Show()
end

local function find_iterate_over(name, ...)
	for i=1,select("#", ...) do
		local x = select(i, ...)
		if x and x:len()>0 and x == name then
			return true
		end
	end
	return false
end

local function recursive_iterate_over(...)
	for i=1,select("#", ...) do
		local x = select(i, ...)
		if x and x:len()>0 then
			ACP_EnableRecurse(x, true)
		end
	end
end

local function enable_lod_dependants(addon)
	local addon_name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(addon)

    -- dont do this for FuBar, its annoying
    if addon_name == "FuBar" then
        return
    end

	for i=1, GetNumAddOns() do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)
		local isdep = find_iterate_over(addon_name, GetAddOnDependencies(name))
		local ondemand = IsAddOnLoadOnDemand(name)

		if not isdep then
        	local metaXEmbeds = GetAddOnMetadata(name, "X-Embeds")
        	if metaXEmbeds then
           	    isdep = find_iterate_over(addon_name, strsplit(" ,", metaXEmbeds:trim()))
        	end
        end

		if isdep and not enabled and ondemand then
			ACP_EnableRecurse(name, true)
			--EnableAddOn(name)
		end
	end
end

function ACP_EnableRecurse(name, skip_children)
    local _, _, _, enabled = GetAddOnInfo(name)
    if enabled then
        return

    end

    if (type(name) == "string" and strlen(name)>0) or
        (type(name) == "number" and name > 0) then

    	EnableAddOn(name)

    	if not skip_children then
        	enable_lod_dependants(name)
        end

    	recursive_iterate_over(GetAddOnDependencies(name))

    	local metaXEmbeds = GetAddOnMetadata(name, "X-Embeds")
    	if metaXEmbeds then
    		recursive_iterate_over(strsplit(" ,", metaXEmbeds:trim()))
    	end
    else
    --    self:Print(L["AddOn <%s> is not valid."]:format(tostring(name)))
	end
end
