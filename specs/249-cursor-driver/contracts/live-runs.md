# Contract: Cursor live runs and logs

## Prerequisites

- `CURSOR_API_KEY` in `harness/.env` (never printed).
- `models.cursor` set from `Cursor.models.list`.
- Full bash suite and `npm --prefix harness test` already green.

## Required runs (shared `parallel`)

1. `node harness/src/cli.ts --agent cursor --smoke` → `specs/249-cursor-driver/harness/smoke-1.log`
2. Same again → `smoke-2.log`
3. `node harness/src/cli.ts --agent cursor --skills highway-codify` → `codify.log`

Redirect **stdout** only; progress stays on stderr.

## Pass criteria

- Every attempt shows install of `highway` with 16 skills.
- No secret, token, or raw temporary path in a committed log.
- Each log under 100 KB.
- Every failure classified in `harness-model-findings.md` under a “Cursor driver smoke for spec 249” section (new finding or Runs line).
- `--transcripts` used only outside the repo for deep dives.

## Deep dive (not committed)

```bash
node harness/src/cli.ts --agent cursor --skills <skill> --transcripts "$TMPDIR/harness-249" --verbose
```
