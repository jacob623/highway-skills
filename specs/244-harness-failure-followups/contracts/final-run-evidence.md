# Contract: Final Run Evidence

## Preconditions

- Every task before the final run is done.
- `bash tests/run-all.sh` passes (87 tests).
- In `harness/`: `node --test "test/*.test.ts"` and `tsc -p tsconfig.json` pass.
- Two generator runs; the second changes nothing.

## The run (FR-017)

```bash
node harness/src/cli.ts --model gpt-5.6-luna --changed-since 42a0569 \
  --paths <the files below, comma-separated> \
  --transcripts specs/244-harness-failure-followups/harness/final
```

Spec 243 scenarios with a failed attempt (the baseline), by file:

- `harness/scenarios/highway-adr/adr-smoke.scenario`
- `harness/scenarios/highway-codify/chain-codify.scenario`
- `harness/scenarios/highway-discovery/chain-discovery.scenario`
- `harness/scenarios/highway-implementation/chain-implementation.scenario`
- `harness/scenarios/highway-codify-config/codify-config-smoke.scenario`
- `harness/scenarios/highway-codify/codify-configure.scenario`
- `harness/scenarios/highway-codify/codify-controls-conflict.scenario`
- `harness/scenarios/highway-codify/codify-folder-taken.scenario`
- `harness/scenarios/highway-codify/codify-needed-language.scenario`
- `harness/scenarios/highway-codify/codify-no-architecture.scenario`
- `harness/scenarios/highway-codify/codify-no-governance.scenario`
- `harness/scenarios/highway-controls/controls-smoke.scenario`
- `harness/scenarios/highway-discovery/discovery-smoke.scenario`
- `harness/scenarios/highway-implementation/implementation-onboards-platform.scenario`
- `harness/scenarios/highway-nfrs/nfrs-smoke.scenario`
- `harness/scenarios/highway-objectives/objectives-smoke.scenario`
- `harness/scenarios/highway-onboarding/onboarding-smoke.scenario`
- `harness/scenarios/highway-setup/setup-smoke.scenario`

Passing all 18 with `--paths` is harmless when some are already selected; the selection is a
union. If a change follows the run, the run is repeated.

## Capture (FR-018, FR-019)

- The run folder is under `specs/244-harness-failure-followups/harness/final/`.
- `git check-ignore specs/244-harness-failure-followups/harness/final` reports it ignored.
- `git status --short` lists nothing under it.
- `rg --no-ignore -l -F "$TOKEN"` over the folder finds 0 files. The token is read from
  `harness/.env` into a variable and never printed.

## Comparison (SC-001, SC-002)

For each scenario in the run:

| Field | Source |
| --- | --- |
| Baseline | its result in spec 243's three final runs (pass, flaky, fail, blocked, or not run) |
| Final | attempt 1 and attempt 2 kinds |
| Findings | the finding behind each failing attempt |

A scenario that passed in every baseline run it appeared in, and now fails both attempts, is a
regression unless its transcript shows a listed finding.

## Findings update (FR-020)

Done last, from the comparison table. It follows the rules in `data-model.md`.
