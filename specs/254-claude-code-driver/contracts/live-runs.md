# Contract: Claude live confirmation runs

## Prerequisites

- `ANTHROPIC_API_KEY` in `harness/.env` (never print the value).
- `models.claude` pinned to `claude-haiku-5-5` (or remapped Haiku noted in tasks Notes).
- Judge configured as Cursor + Luna.
- Suite and harness unit tests green.

## Runs

| Log | Command |
|---|---|
| `specs/254-claude-code-driver/harness/smoke-1.log` | `node harness/src/cli.ts --agent claude --smoke` |
| `specs/254-claude-code-driver/harness/smoke-2.log` | same, second run |
| `specs/254-claude-code-driver/harness/codify.log` | `node harness/src/cli.ts --agent claude --skills highway-codify` |

Use configured `parallel` (same as other agents) unless research Notes record a serial override.

## Expected

- Every attempt installs plugin name `highway` with **16** skills, no warning, enabled.
- Enforcement: every Bash denied (or recorded + attempt failed); outside writes / memory denied;
  project + plugin reads/writes allowed through `canUseTool`.
- No numeric pass floor for smoke or codify this phase.
- No secrets or operator temporary paths in committed logs (redact / scrub as prior phases).
- Each log under ~100 KB when possible.
- Failures mapped in `harness-model-findings.md` (Runs lines / new findings).

## Judge

Harness runs in this phase use Cursor + Luna as judge, not Claude.
