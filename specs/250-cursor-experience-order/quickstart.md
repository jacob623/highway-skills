# Quickstart: Cursor Experience Order

Run from the repository root. Prefer `export PATH="$HOME/.local/node/bin:$PATH"`.

## 1. Unit tests

```bash
npm --prefix harness test
npm --prefix harness run typecheck
```

Expected: new Cursor activation/path tests pass; Copilot tests still pass. Contract:
[contracts/activation-mapping.md](contracts/activation-mapping.md).

## 2. Bash suite

```bash
bash tests/run-all.sh
```

Expected: exit 0.

## 3. Live confirmation (`CURSOR_API_KEY` in `harness/.env`)

Follow [contracts/live-runs.md](contracts/live-runs.md). Save logs under
`specs/250-cursor-experience-order/harness/`.

Expected for F29 close: zero `actual no skill` across smoke-1, smoke-2, and codify; install still
16 skills; update `harness-model-findings.md` and Phase 7 Status.

## 4. Docs check

Findings list F29 resolved (or still open with evidence). No skill tree edits.
