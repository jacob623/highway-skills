# Data Model: Claude Code Driver

## Registry entry `claude` (`harness/src/agents.ts`)

| Field | Value |
|---|---|
| `id` | `claude` |
| `service` | `Claude` |
| `keys` | `["ANTHROPIC_API_KEY"]` |
| `driver` | `claudeDriver` |
| `ask` | `claudeAsk` |
| `classify` | `classifyClaudeError` |
| `readRoots(home)` | `[join(home, "plugins", "highway")]` (staged install path; adjust if live layout differs) |
| `versions()` | `{ sdk: <package version>, runtime: "cli" }` |

Copilot, Cursor, and Codex entries stay. **Judge config** stays `judge.agent = cursor` and
`judge.model = gpt-5.6-luna`.

## Claude install layout (under `agentHome`)

| Path | Role |
|---|---|
| `agentHome` / throwaway `HOME` | Entire attempt home |
| `CLAUDE_CONFIG_DIR` → `join(agentHome, "claude-config")` | Global config / sessions relocation |
| `join(agentHome, "plugins", "highway")` | Copy of `highway-agent-plugin/` (`.claude-plugin/plugin.json` + skills) |
| sessions under config dir | Throwaway session state for resume |

## `PluginRpc` adapter (Claude)

Same interface as Cursor/Codex (`install` / `enable` / `list`), implemented by copying the plugin
into `plugins/highway` under the throwaway home so shared `installPlugin` checks still run: name
`highway`, skill count 16, no warning, enabled. The driver then passes that absolute path as
`plugins: [{ type: "local", path }]`.

## Stream → harness mapping

| Claude | Harness |
|---|---|
| assistant text | Turn buffer → `agent` log line |
| `tool_use` Read/Glob/Grep | `AccessRequest` read + permission log |
| `tool_use` Write/Edit | `AccessRequest` write + permission log |
| `tool_use` Bash | `AccessRequest` shell → **deny** (+ fail attempt if it ran) |
| `tool_use` WebFetch/WebSearch | `AccessRequest` url |
| `AskUserQuestion` | Answer from scripted replies via `canUseTool` allow + `updatedInput` |
| Skill tool / `/highway:…` / `skills/highway-…/SKILL.md` | `skillsInvoked` / `skillsBeforeOutput` + `skill` log |
| result `usage` / cost | `Usage` totals |
| SDK auth/rate errors | Classifier → retry / `RunStop` / attempt `error` |

## Permission classification (FR-010)

| Tool / effect | Outcome |
|---|---|
| Read/Glob/Grep inside project or read root | Allow |
| Write/Edit inside project | Allow |
| Write/Edit outside project | Deny |
| **Any Bash** | **Deny** (always) |
| Memory | Deny |
| Web when `web: no` | Deny |
| Unknown / no path | `other` → shared policy |

## Config

`harness.config.json`:

- `models.claude` — `claude-haiku-5-5` (remap only if live listing rejects)
- `judge.agent` / `judge.model` unchanged (cursor / Luna)

## Committed run logs

| File | Run |
|---|---|
| `specs/254-claude-code-driver/harness/smoke-1.log` | First `--agent claude --smoke` |
| `specs/254-claude-code-driver/harness/smoke-2.log` | Second `--agent claude --smoke` |
| `specs/254-claude-code-driver/harness/codify.log` | `--agent claude --skills highway-codify` |

No numeric pass floor for smoke or codify this phase (install + classify + suite green).
