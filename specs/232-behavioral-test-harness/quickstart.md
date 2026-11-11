# Quickstart: Behavioral Test Harness

## Prerequisites

- Node 24 on the PATH.
- `npm --prefix harness ci`.
- For live runs: a GitHub token with Copilot access in `harness/.env` as `GITHUB_TOKEN=...`.

## Static checks (no Node, no token)

```bash
bash .highway/tools/tests/run-all.sh
```

Expect the `harness-*.test.sh` checks to pass: placement, scenarios, fixtures, coverage (highway-codify
gated), path map, and switches.

## Runner logic (Node, no token)

```bash
npm --prefix harness test
npm --prefix harness run typecheck
node harness/src/cli.ts --help        # exit 0, every switch listed
node harness/src/cli.ts --bogus       # exit 2, points to --help
node harness/src/cli.ts --smoke --skills highway-codify   # exit 2, conflict
env -u GITHUB_TOKEN node harness/src/cli.ts --skills highway-help   # exit 2, missing-token block
```

## Live runs (token required)

1. Spike: `node harness/src/cli.ts --skills highway-help` and confirm the skill answered, then
   `node harness/src/cli.ts --paths harness/scenarios/highway-codify/codify-plan-review.scenario`.
   Record in `harness/README.md` whether `/highway-codify` invoked the skill and how usage was
   reported.
2. Targeted: change `.highway/library/templates/output/codify-plan.md` and run
   `node harness/src/cli.ts --changed-since main`. Expect only highway-codify scenarios, each with
   the reason "highway-codify names .highway/library/templates/output/codify-plan.md".
3. Smoke: `node harness/src/cli.ts --smoke`. Expect 15 scenarios, run type `smoke`.
4. Full: `node harness/src/cli.ts`, then `node harness/src/cli.ts --promote harness/runs/<run>`.

Expected outcomes and stdout shapes: see [contracts/cli.md](contracts/cli.md) and
[contracts/failure-output.md](contracts/failure-output.md).
