# ACP 3.3.8-WotLK

**Unofficial community-maintained edition of Addon Control Panel for World of Warcraft 3.3.5a.**

[Español](README.md) | **English**

ACP 3.3.8-WotLK preserves and updates the classic Addon Control Panel experience while maintaining compatibility with the World of Warcraft 3.3.5a client and existing ACP 3.3.7 saved data.

This project is not affiliated with or maintained by the current official ACP project team.

---

## Compatibility

- World of Warcraft 3.3.5a
- Interface version `30300`
- Lua 5.1
- Compatible with existing `ACP_Data` SavedVariables from ACP 3.3.7
- Does not use modern Retail, current Classic or Cataclysm Classic APIs

---

## Improvements in this WotLK edition

Compared with ACP 3.3.7, this community edition includes:

- A rebuilt and centralized localization system.
- Safe fallback to English when a translation is unavailable.
- Automatic language detection for official WoW clients.
- Manual language selection for community-translated clients.
- A visual language selector inside the ACP window.
- Persistent language override through `ACP_Data.localeOverride`.
- Compatibility with localization files written for ACP 3.3.7.
- Stable internal sorter and category identifiers independent of language.
- Automatic migration of legacy sorter values stored by ACP 3.3.7.
- Corrections for inherited bugs affecting:
  - AddOn status tooltips.
  - Missing AddOn status handling.
  - Blizzard AddOn prefix detection.
  - Recursive dependency activation.
  - Folded category mass activation.
  - Saved set renaming.
  - The final AddOn entry in the list.
  - Accidental global variables.
  - AddOn title collisions with localization keys.
- Updated and corrected translations.
- 129 automated checks covering localization, fallback behavior, legacy compatibility, SavedVariables and the language selector.

---

## Main features

- Enable and disable AddOns without returning to the character selection screen.
- Load AddOns marked as Load on Demand.
- Protect important AddOns from being disabled.
- Save, load and rename AddOn sets.
- Sort and group AddOns using different criteria.
- Display dependencies, embedded libraries, status and compatibility information.
- Automatically enable required dependencies.
- Built-in localization system with safe English fallback.
- Automatic language detection for official WoW clients.
- Manual language selection for community-translated clients.
- Visual language selector inside the ACP window.
- Compatibility with localization files written for ACP 3.3.7.

---

## Included languages

ACP includes complete translations for:

- `enUS` — English
- `enGB` — English (United Kingdom)
- `enCN` — English for Chinese community clients
- `deDE` — Deutsch
- `frFR` — Français
- `esES` — Español (España)
- `esMX` — Español (Latinoamérica)
- `ptBR` — Português (Brasil)
- `itIT` — Italiano
- `ruRU` — Русский
- `koKR` — 한국어
- `zhCN` — 简体中文
- `zhTW` — 繁體中文

Official client languages are selected automatically through `GetLocale()`.

Some community-translated clients still identify themselves as `enUS`. In that case, use the language selector inside ACP or the commands described below.

---

## Manual language selection

Open ACP and use the language dropdown next to the sorting dropdown.

You can also use:

```text
/acp locale
/acp locale ptBR
/acp locale esMX
/acp locale esES
/acp locale auto
```

Example:

```text
/acp locale ptBR
```

Forces Portuguese (Brazil).

```text
/acp locale auto
```

Removes the manual override and returns to automatic detection.

The `/acp language` command is also supported as an alias for `/acp locale`.

---

## Installation

1. Download the latest version from the **Releases** section.
2. Extract the ZIP archive.
3. Copy the `ACP` folder into:

```text
World of Warcraft\Interface\AddOns\
```

The final path must be:

```text
World of Warcraft\Interface\AddOns\ACP\ACP.toc
```

4. Start World of Warcraft.
5. Enable Addon Control Panel in the AddOns list.
6. Open ACP from the game menu or use:

```text
/acp
```

---

## Updating from ACP 3.3.7

ACP 3.3.8-WotLK preserves the existing `ACP_Data` structure and saved AddOn sets.

Creating a backup before updating is still recommended:

```text
WTF\Account\<ACCOUNT>\SavedVariables\ACP.lua
```

Replace the old folder completely:

```text
Interface\AddOns\ACP
```

Do not mix files from different versions inside the same folder.

---

## Commands

```text
/acp
/acp help
/acp nochildren
/acp norecurse
/acp debug
/acp locale
/acp locale <code>
/acp locale auto
/acp language <code>
```

### Command descriptions

- `/acp` — Opens or closes Addon Control Panel.
- `/acp help` — Displays the available commands.
- `/acp nochildren` — Toggles Load on Demand child AddOn handling.
- `/acp norecurse` — Toggles recursive dependency enabling.
- `/acp debug` — Toggles localization debugging messages.
- `/acp locale` — Displays the detected and effective ACP language.
- `/acp locale <code>` — Forces one of the registered languages.
- `/acp locale auto` — Returns to automatic language detection.
- `/acp language <code>` — Alias for `/acp locale <code>`.

---

## Recursive option

When **Recursive** is enabled, activating an AddOn also attempts to enable its required dependencies and related embedded libraries.

When it is disabled, ACP only enables the selected AddOn.

The command:

```text
/acp norecurse
```

toggles the same option as the **Recursive** checkbox.

---

## Testing

The project includes:

```text
ACP-SelfTest.lua
```

This file is a command-line test harness and is intentionally not loaded by World of Warcraft.

The automated tests cover:

- Localization keys and placeholders.
- Language fallback behavior.
- Manual locale selection and persistence.
- ACP 3.3.7 localization compatibility.
- `ACP_Data` compatibility.
- Legacy sorter migration.
- AddOn folder name collisions with localization keys.
- Recursive option synchronization.
- Visual language selector behavior.

The current version passes 129 automated checks.

Visual layout and real World of Warcraft API behavior must still be verified inside a WoW 3.3.5a client.

---

## Project status

This project is maintained exclusively for World of Warcraft 3.3.5a.

It is not intended for:

- World of Warcraft Retail.
- Modern Classic.
- Cataclysm Classic.
- Later expansions.
- Clients using the modern `C_AddOns` API.

---

## Credits

Original Addon Control Panel authors and contributors:

- sylvanaar
- Rophy
- Saien

ACP is based on rMCP, which is MCP modified by Rophy and originally created by Saien.

### WotLK 3.3.5a Community Edition maintainer

- Mapache-Warmane2077

---

## License

Distributed under the MIT License.

See the `LICENSE` file for details.
