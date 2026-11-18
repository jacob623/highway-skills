# Quickstart: Codex Smoke Failures

Validate FR-002–FR-008 after implementation. See [contracts/git-pre-refuse.md](contracts/git-pre-refuse.md)
and [contracts/live-runs.md](contracts/live-runs.md).

## Prerequisites

- Node on `PATH` (`$HOME/.local/node/bin` if needed).
- `OPENAI_API_KEY` or `CODEX_API_KEY` for live Codex; Cursor key for judge.
- Repo root: `highway-skills`.

## Unit / suite (no live key required for unit subset)

```bash
bash tests/run-all.sh
npm --prefix harness test
npm --prefix harness run typecheck
```

Expect: green suite; new tests cover git pre-refuse vs completed-fatal and throwaway guidance/rules
files.

## Live confirmation

```bash
mkdir -p specs/253-codex-smoke-failures/harness
# smoke ×2 then codify — redact secrets and temp abs paths before keeping logs
node harness/src/cli.ts --agent codex --smoke 2>&1 | tee specs/253-codex-smoke-failures/harness/smoke-1.log
node harness/src/cli.ts --agent codex --smoke 2>&1 | tee specs/253-codex-smoke-failures/harness/smoke-2.log
node harness/src/cli.ts --agent codex --skills highway-codify 2>&1 | tee specs/253-codex-smoke-failures/harness/codify.log
```

### Expected outcomes

1. Each smoke: ≥9/16 pass (or findings document miss).
2. Every attempt: Highway install with 16 skills.
3. Pre-refused git alone does not dominate fatal storage fails the way Phase 9 did.
4. Codify log saved; failures mapped to F31 / new findings (no numeric floor).
5. Update `harness-model-findings.md` per FR-008.

## Manual spot-check (optional)

Inspect a failing Phase 9 transcript vs a new attempt: denied git lines should appear without
always ending the attempt; completed git must still fail.
