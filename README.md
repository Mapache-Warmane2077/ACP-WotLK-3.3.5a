# ACP 3.3.8-WotLK

**Unofficial community-maintained edition of Addon Control Panel for World of Warcraft 3.3.5a.**

ACP 3.3.8-WotLK preserves and updates the classic Addon Control Panel experience specifically for the World of Warcraft 3.3.5a client.

This project is not affiliated with or maintained by the current official ACP project team.

---

## Compatibility

- World of Warcraft 3.3.5a
- Interface version `30300`
- Lua 5.1
- Compatible with existing `ACP_Data` SavedVariables from ACP 3.3.7
- No Retail, modern Classic or Cataclysm Classic API is used

---

## Main features

- Enable and disable AddOns without returning to the character selection screen
- Load AddOns marked as Load on Demand
- Protect important AddOns from being disabled
- Save and restore AddOn sets
- Group and sort AddOns using different criteria
- Display dependencies, embedded libraries, status and compatibility information
- Automatically enable required dependencies
- Built-in localization system with safe English fallback
- Automatic language detection for official WoW clients
- Manual language selection for community-translated clients
- Visual language selector inside the ACP window
- Compatibility with localization files written for ACP 3.3.7

---

## Languages

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

Community-translated clients may still identify themselves as `enUS`. In that case, use the language selector in the ACP window or one of the commands below.

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

Examples:

```text
/acp locale ptBR
```

Forces Portuguese (Brazil).

```text
/acp locale auto
```

Returns ACP to automatic language detection.

The command alias `/acp language` is also supported.

---

## Installation

1. Download the latest release.
2. Extract the archive.
3. Copy the folder named `ACP` into:

```text
World of Warcraft\Interface\AddOns\
```

The final path must look like:

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

ACP 3.3.8-WotLK preserves the existing `ACP_Data` SavedVariables structure and keeps saved AddOn sets.

Creating a backup before updating is still recommended:

```text
WTF\Account\<ACCOUNT>\SavedVariables\ACP.lua
```

Replace the old `Interface\AddOns\ACP` folder with the new one.

Do not merge old and new files inside the same folder.

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
- `/acp locale <code>` — Forces a registered language.
- `/acp locale auto` — Returns to automatic language detection.
- `/acp language <code>` — Alias for `/acp locale <code>`.

---

## Recursive option

When **Recursive** is enabled, activating an AddOn also enables its required dependencies and related embedded libraries.

When it is disabled, ACP only enables the selected AddOn.

The command:

```text
/acp norecurse
```

toggles the same option as the Recursive checkbox.

---

## Testing

The repository includes:

```text
ACP-SelfTest.lua
```

This is a command-line test harness and is intentionally not loaded by World of Warcraft.

The automated tests cover:

- Localization keys and placeholders
- Language fallback behavior
- Manual locale overrides
- Legacy ACP 3.3.7 localization compatibility
- SavedVariables compatibility
- Sorter migration
- AddOn title collisions
- Recursive option synchronization
- Language selector behavior

Visual layout and real World of Warcraft API behavior must still be verified inside a WoW 3.3.5a client.

---

## Project status

This project is maintained specifically for World of Warcraft 3.3.5a.

It is not intended for:

- Retail
- Modern Classic
- Cataclysm Classic
- Later expansions
- Clients using modern `C_AddOns` APIs

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
