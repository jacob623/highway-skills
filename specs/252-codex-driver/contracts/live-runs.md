# Contract: Codex live confirmation runs

## Prerequisites

- `OPENAI_API_KEY` or `CODEX_API_KEY` in `harness/.env` (never print the value).
- `models.codex` pinned (Luna / closest GPT-5.6 id).
- Judge configured as Cursor + Luna.
- Suite and harness unit tests green.

## Runs

| Log | Command |
|---|---|
| `specs/252-codex-driver/harness/smoke-1.log` | `node harness/src/cli.ts --agent codex --smoke` |
| `specs/252-codex-driver/harness/smoke-2.log` | same, second run |
| `specs/252-codex-driver/harness/codify.log` | `node harness/src/cli.ts --agent codex --skills highway-codify` |

Use configured `parallel` (same as other agents) unless research Notes record a serial override.

## Expected

- Every attempt installs plugin name `highway` with **16** skills, no warning, enabled.
- Enforcement: outside / `git` / network install fails the attempt; in-project R/W and build/test
  may succeed.
- No secrets or operator temporary paths in committed logs (redact / scrub as prior phases).
- Each log under ~100 KB when possible.
- Failures mapped in `harness-model-findings.md` (Runs lines / new findings).

## Judge

Harness runs in this phase use Cursor + Luna as judge, not Copilot.
