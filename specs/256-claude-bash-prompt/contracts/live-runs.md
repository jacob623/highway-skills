# Contract: Claude F33 session-start guidance live runs

## Prerequisites

- `ANTHROPIC_API_KEY` in `harness/.env` (never print the value).
- `models.claude` pinned to `claude-haiku-5-5` (or remapped Haiku noted in tasks Notes).
- Judge configured as Cursor + Luna.
- Suite and harness unit tests green.
- Session-start guidance shipped (see [claude-session-guidance.md](claude-session-guidance.md)).

## Runs

| Log | Command | Pass bar |
| --- | --- | --- |
| `specs/256-claude-bash-prompt/harness/smoke-1.log` | `node harness/src/cli.ts --agent claude --smoke` | ≥14 of 16 |
| `specs/256-claude-bash-prompt/harness/smoke-2.log` | same, second run | ≥14 of 16 |
| `specs/256-claude-bash-prompt/harness/codify.log` | `node harness/src/cli.ts --agent claude --skills highway-codify` | No numeric floor |

## Expected

- Every attempt installs plugin `highway` with **16** skills.
- Enforcement: every Bash denied; refuse still fails storage as `rejected-request`.
- Bash-driven `rejected-request` fails on confirming smoke fewer than Phase 8 baseline, or
  findings explain why.
- No secrets or raw temporary absolute paths in committed logs.
- F33 closed only when both smoke bars hold and Bash-driven fails drop vs Phase 8.

## Judge

Cursor + Luna (not Claude).
