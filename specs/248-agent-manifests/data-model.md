# Data Model: Agent Manifests

## Shared fields (`framework/plugin/plugin.json`)

The Agent Plugins 1.0.0 manifest, copied byte for byte to `highway-agent-plugin/plugin.json`.

| Field | Value | Change |
| --- | --- | --- |
| `$schema` | `https://agent-plugins.org/schemas/1.0.0/plugin.schema.json` | none; root only |
| `name` | `highway` | none |
| `version` | `0.1.0` | none (FR-012: the one place a release changes) |
| `description` | the current description | none |
| `author` | `{ "name": "Highway", "url": "https://www.highway.systems" }` | new (FR-005) |
| `homepage` | `https://www.highway.systems` | changed (FR-001) |
| `repository` | `https://github.com/jacob623/highway-skills` | none until Phase 19 |
| `license` | `Apache-2.0` | none |
| `keywords` | `governance`, `architecture`, `adr`, `traceability`, `platform-engineering`, `agent-skills` | new (FR-001; research R11) |

Validation: Agent Plugins 1.0.0, as today (`pm_check`).

## Listing file (`framework/plugin/listing.json`)

One JSON object keyed by agent. Exactly the keys `codex`, `cursor`, and `antigravity`. Each entry
holds only the fields its format allows (see [contracts/manifests.md](contracts/manifests.md)) and
never a shared field or a derived field.

| Agent | Fields |
| --- | --- |
| `codex` | `interface`: `displayName`, `shortDescription`, `longDescription`, `category`, `capabilities`, `defaultPrompt`, `composerIcon`, `logo` |
| `cursor` | `logo` |
| `antigravity` | `displayName`, `logo`, `suggestedPrompts` |

Validation: the generator's listing check ([contracts/checks.md](contracts/checks.md)), run before
anything is written.

## Logo (`framework/plugin/assets/logo.svg`)

A text SVG, 512 by 512, copied to `highway-agent-plugin/assets/logo.svg`. Named by the Codex
(`./assets/logo.svg`, twice), Cursor (`assets/logo.svg`), and Antigravity (`assets/logo.svg`)
listing entries. Every file under `framework/plugin/assets/` is copied, and the validator fails on
an asset no manifest names.

## Manifest set (`highway-agent-plugin/`)

| Path | Format | Draws from |
| --- | --- | --- |
| `plugin.json` | Agent Plugins 1.0.0 | copy of the source |
| `.claude-plugin/plugin.json` | Claude Code | shared fields |
| `.codex-plugin/plugin.json` | Codex | shared fields, `skills`, `interface` (listing plus derived) |
| `.cursor-plugin/plugin.json` | Cursor | shared fields (author name only), `skills`, listing |
| `.antigravity-plugin/plugin.json` | Antigravity | `$schema`, shared fields, listing |
| `gemini-extension.json` | Gemini CLI | name, version, description |

Derived fields (FR-003): Codex `interface.developerName` = `author.name`; `interface.websiteURL` =
`homepage`.

## Shipped set (closed list)

Top-level entries: `plugin.json`, `README.md`, `LICENSE`, `skills`, `assets`, `.claude-plugin`,
`.codex-plugin`, `.cursor-plugin`, `.antigravity-plugin`, `gemini-extension.json`. Each
`.<agent>-plugin` folder holds only `plugin.json`. `assets/` holds only files a manifest names.

## Format table

One table in `framework/lib/plugin-manifest.sh` describes each agent format: its path, its leading
constants, its accepted shared keys (and author keys), its trailing constants, and its listing
fields in output order. The renderer and the validator both read it. State: none; the generator
replaces the plugin folder whole on each build.
