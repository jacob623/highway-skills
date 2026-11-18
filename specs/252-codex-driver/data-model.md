# Data Model: Codex Driver

## Registry entry `codex` (`harness/src/agents.ts`)

| Field | Value |
|---|---|
| `id` | `codex` |
| `service` | `Codex` |
| `keys` | `["OPENAI_API_KEY", "CODEX_API_KEY"]` (prefer first present; document which README names) |
| `driver` | `codexDriver` |
| `ask` | `codexAsk` |
| `classify` | `classifyCodexError` |
| `readRoots(home)` | Installed Highway skill tree under the throwaway home (marketplace cache or staged plugin path; finalize at implement) |
| `versions()` | `{ sdk: <package version>, runtime: "cli" }` |

Copilot and Cursor entries stay. **Judge config** switches to `judge.agent = cursor` and Luna model
id matching `models.cursor`.

## Codex install layout (under `agentHome`)

| Path | Role |
|---|---|
| `CODEX_HOME` / throwaway `HOME` | Entire attempt home (`options.agentHome`) |
| Local marketplace + plugin copy of `highway-agent-plugin/` | Install source (`.codex-plugin/plugin.json` + skills) |
| `$CODEX_HOME/plugins/…` or `plugins/cache/<market>/highway/<ver>/` | Installed plugin / read-root |
| `$CODEX_HOME/config.toml` (if written) | Plugin enablement / marketplace registration |
| sessions under home | Throwaway thread state |

## `PluginRpc` adapter (Codex)

Same interface as Copilot/Cursor (`install` / `enable` / `list`), implemented by staging the plugin
under the throwaway home (and optional `codex plugin marketplace add` / `plugin add` with
`CODEX_HOME` set) so shared `installPlugin` checks still run: name `highway`, skill count 16, no
warning, enabled.

## Stream → harness mapping

| Codex | Harness |
|---|---|
| agent / assistant message item | Turn buffer → `agent` log line |
| `command_execution` item | `AccessRequest` (shell) + permission log; effects fail if forbidden |
| file-change item | write/read `AccessRequest` with paths |
| skill / SKILL.md path in command or file read | `skillsInvoked` / `skillsBeforeOutput` + `skill` log |
| `turn.completed.usage` | `Usage` totals |
| SDK/CLI auth/rate errors | Classifier → retry / `RunStop` / attempt `error` |
| turn / thread error status | Attempt `outcome: "error"` when appropriate |

## Effects classification (FR-001 / FR-008)

| Command / effect | Outcome |
|---|---|
| In-project read/write (paths under project) | Allow |
| In-project build/test (`npm`/`node`/`tsc`/`python`/etc. under project cwd, no outside paths) | Allow |
| Any `git` | Fail attempt |
| Outside-project path read/write | Fail attempt |
| Network-facing install (`npm install` from registry, `curl`/`wget` remote, etc.) | Fail attempt |

## Config

`harness.config.json`:

- `models.codex` — Luna / closest GPT-5.6 id from research at implement time
- `judge.agent` → `cursor`
- `judge.model` → same Luna id as `models.cursor` (or configured Luna)

Default scenario agent for confirmation remains selectable via `--agent codex`.

## Committed run logs

| File | Run |
|---|---|
| `specs/252-codex-driver/harness/smoke-1.log` | First `--agent codex --smoke` |
| `specs/252-codex-driver/harness/smoke-2.log` | Second `--agent codex --smoke` |
| `specs/252-codex-driver/harness/codify.log` | `--agent codex --skills highway-codify` |

## Skill entity change

| Entity | Change |
|---|---|
| `storage-contract.md` | MINOR Local-mode wording: shell may perform in-project R/W when that is the agent’s file tool; still no git / outside / network installs as storage ops |
| `highway-experience` | MINOR version bump; regenerate adapters + plugin |
