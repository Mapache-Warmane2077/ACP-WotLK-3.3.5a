CP 3.3.8-WotLK

Unofficial community-maintained edition of Addon Control Panel for World of Warcraft 3.3.5a.

ACP 3.3.8-WotLK preserves the original Addon Control Panel experience while fixing inherited issues, rebuilding the localization system, and adding language selection for official and community-translated clients.

This project is not affiliated with or maintained by the current official Addon Control Panel project team.

Compatibility

World of Warcraft 3.3.5a

Interface: 30300

Lua 5.1

Folder name: ACP

Main changes

Rebuilt localization system with safe fallback to enUS.

Automatic language detection through GetLocale().

Manual language selector for community clients that still report enUS.

Visual language drop-down inside the ACP window.

Compatibility with ACP 3.3.7 saved sets and settings.

Compatibility layer for legacy ACP 3.3.7 localization files.

Corrections for inherited addon-list, tooltip, sorting, protection, and dependency issues.

129 automated behavior checks included in ACP-SelfTest.lua.

Included languages

The following locales include complete translations:

enUS — English

enGB — English (UK)

enCN — English (Chinese client)

deDE — Deutsch

frFR — Français

esES — Español (España)

esMX — Español (Latinoamérica)

ptBR — Português (Brasil)

itIT — Italiano

ruRU — Русский

koKR — 한국어

zhCN — 简体中文

zhTW — 繁體中文

Unknown locale codes fall back safely to English. Additional languages can be added by copying localization-template.lua, translating it, and listing the new file in ACP.toc.

Installation

Download the latest release.

Extract the archive.

Copy the ACP folder into:

World of Warcraft\Interface\AddOns\

Restart the game or use:

/reload

The final path must be:

World of Warcraft\Interface\AddOns\ACP\ACP.toc

Language selection

Official clients are detected automatically. For example, a client returning esES, koKR, or zhCN will use that translation without manual configuration.

Community-translated clients may still return enUS. In that case, use the language selector inside ACP or one of these commands:

/acp locale
/acp locale ptBR
/acp locale esMX
/acp locale auto

/acp locale auto returns ACP to automatic detection.

Commands

/acp
/acp help
/acp nochildren
/acp norecurse
/acp debug
/acp locale
/acp locale <code>
/acp locale auto

/acp language is also accepted as an alias for /acp locale.

Updating from ACP 3.3.7

ACP 3.3.8-WotLK keeps the ACP_Data SavedVariables format and preserves saved AddOn sets. Creating a backup before updating is still recommended:

WTF\Account\<ACCOUNT>\SavedVariables\ACP.lua

Testing

ACP-SelfTest.lua is a command-line test harness and is intentionally not loaded by WoW.

The project includes static checks and automated tests for localization, fallback behavior, legacy migration, locale overrides, title collisions, and SavedVariables compatibility. Visual layout and real WoW API behavior must still be verified inside a 3.3.5a client.

Credits

Original Addon Control Panel authors and contributors:

sylvanaar

Rophy

Saien

ACP is based on rMCP, which is MCP modified by Rophy and originally created by Saien.

WotLK 3.3.5a Community Edition maintainer:

Mapache-Warmane2077

License

Distributed under the MIT License. See LICENSE.
