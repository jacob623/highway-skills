# Contract: Claude F33 recovery live runs

## Prerequisites

- `ANTHROPIC_API_KEY` in `harness/.env` (never print the value).
- `models.claude` pinned to `claude-haiku-5-5` (or remapped Haiku noted in tasks Notes).
- Judge configured as Cursor + Luna.
- Suite and harness unit tests green.
- Throwaway-home guidance shipped (see [claude-guidance.md](claude-guidance.md)).

## Runs

| Log | Command | Pass bar |
| --- | --- | --- |
| `specs/255-claude-bash-failures/harness/smoke-1.log` | `node harness/src/cli.ts --agent claude --smoke` | ≥14 of 16 |
| `specs/255-claude-bash-failures/harness/smoke-2.log` | same, second run | ≥14 of 16 |
| `specs/255-claude-bash-failures/harness/codify.log` | `node harness/src/cli.ts --agent claude --skills highway-codify` | No numeric floor |

Use configured `parallel` unless Notes record a serial override.

## Expected

- Every attempt installs plugin name `highway` with **16** skills, no warning, enabled.
- Enforcement: every Bash denied (or recorded + attempt failed); refuse still fails storage as
  `rejected-request`; outside writes / memory denied; project + plugin file tools allowed.
- Bash-driven `rejected-request` fails on confirming smoke fewer than Phase 8 baseline
  (`specs/254-claude-code-driver/harness/smoke-*.log`), or findings explain why guidance could
  not close the gap.
- No secrets or raw temporary absolute paths in committed logs.
- Each log under ~100 KB when possible.
- Failures mapped in `harness-model-findings.md`; F33 closed only when both smoke bars hold and
  Bash-driven fails drop vs baseline.

## Judge

Harness runs in this phase use Cursor + Luna as judge, not Claude.
