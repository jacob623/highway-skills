# Contract: Switches and configuration

## Switches (changes only)

| Group | Switch | Argument | Default | Usage |
|---|---|---|---|---|
| Agent | `--agent` | `<id>` | `harness.config.json` `agent` | Agent under test |
| Agent | `--model` | `<id>` | `harness.config.json` `models` entry | Model for the agent under test |
| Agent | `--judge-agent` | `<id>` | `harness.config.json` `judge.agent` | Agent for the judge and the reply fallback |
| Agent | `--judge-model` | `<id>` | `harness.config.json` `judge.model` | Model for the judge and the reply fallback |
| Output | `--transcripts` | `<dir>` | — | Write a run folder (transcripts, reports, candidate snapshots) under `<dir>` |
| Output | `--verbose` | — | off | Add approved permission requests and usage to the run log |

`--transcripts` with no folder exits 2 (`--transcripts needs <dir>`).

## `harness/harness.config.json`

```json
{
  "agent": "copilot",
  "models": { "copilot": "gpt-5.6-luna" },
  "judge": { "agent": "copilot", "model": "gpt-5.6-luna" },
  "parallel": 4,
  "maxTurns": 40,
  "timeoutMinutes": 20
}
```

## Configuration errors (exit 2, before the header)

Each prints `Configuration error: <message>`, then `Run with --help for usage.`

| Condition | Message names |
|---|---|
| `model` field present | `"model" is replaced by "models"` |
| `transcripts` field present | `"transcripts" is removed; pass --transcripts <dir>` |
| `agent` missing or empty | `"agent"` |
| `models` not an object of non-empty strings | `"models"` |
| `judge` missing, or `judge.agent` or `judge.model` empty | the field |
| Agent not registered | the id and the registered agents |
| No model for the agent and no `--model` | `models.<agent>` |
| Judge agent not registered | the id and the registered agents |
| Judge agent has no one-shot ask | the id |
| Judge key missing (judge on, judge agent differs from the agent under test) | the key variable |

## Run failures that name the agent

| Kind | Cause (Copilot) |
|---|---|
| `missing-token` | No Copilot token was found. Set GITHUB_TOKEN in harness/.env. |
| `no-access` | The GITHUB_TOKEN key has no Copilot access. Check the account's Copilot plan. |

## Promotion

`--promote <dir>/<run folder>` exits 2 when the folder name carries an agent other than `copilot`,
saying fixtures are promoted only from Copilot runs until Phase 16, and changes no fixture.
