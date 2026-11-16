# Data Model: Cursor Driver

## Registry entry `cursor` (`harness/src/agents.ts`)

| Field | Value |
|---|---|
| `id` | `cursor` |
| `service` | `Cursor` |
| `keys` | `["CURSOR_API_KEY"]` |
| `driver` | `cursorDriver` |
| `ask` | `cursorAsk` |
| `classify` | `classifyCursorError` |
| `readRoots(home)` | `[join(home, ".cursor/plugins/local/highway")]` |
| `versions()` | `{ sdk: <package version>, runtime: "local" }` |

Copilot’s entry is unchanged. Judge config stays Copilot.

## Cursor install layout (under `agentHome`)

| Path | Role |
|---|---|
| `.cursor/plugins/local/highway/` | Copied plugin root |
| `.cursor/plugins/local/highway/.cursor-plugin/plugin.json` | Preferred manifest for name |
| `.cursor/plugins/local/highway/plugin.json` | Fallback / Agent Plugin manifest |
| `.cursor/plugins/local/highway/skills/` | Skill files (read-root content) |
| `.cursor/hooks.json` + `.cursor/hooks/*` | Policy hooks for this HOME |
| store / SDK data under HOME | Throwaway conversation state |

## `PluginRpc` adapter (Cursor)

Same interface as Copilot’s install path (`install` / `enable` / `list`), implemented by filesystem
copy and directory listing so shared `installPlugin` checks still run.

## Stream → harness mapping

| Cursor | Harness |
|---|---|
| `assistant` text | Turn buffer → `agent` log line |
| `tool_call` | `AccessRequest` + `permission` log; effects fail if forbidden completes |
| skill tool / named skill | `skillsInvoked` / `skillsBeforeOutput` + `skill` log |
| `usage` / `result.usage` | `Usage` totals |
| create throw (`CursorAgentError`) | Classifier → retry / `RunStop` / attempt `error` |
| `result.status === "error"` | Attempt `outcome: "error"` |

## Config

`harness.config.json` gains `models.cursor` (id from `Cursor.models.list` at implement time).
`agent` default remains `copilot`. `judge` unchanged.

## Committed run logs

| File | Run |
|---|---|
| `specs/249-cursor-driver/harness/smoke-1.log` | First `--agent cursor --smoke` |
| `specs/249-cursor-driver/harness/smoke-2.log` | Second `--agent cursor --smoke` |
| `specs/249-cursor-driver/harness/codify.log` | `--agent cursor --skills highway-codify` |
