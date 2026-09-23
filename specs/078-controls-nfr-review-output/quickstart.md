# Quickstart: Controls and NFR Review Output Contracts

## Prerequisites

- Run from `/Users/jacoblong/Documents/wayfinder/highway/highway-skills`.
- Use macOS or Linux with the repository's Bash 3.2-compatible toolchain.
- Feature 077 canonical skills, generated artifacts, and onboarding fixtures are present.

## Focused validation

Run the contract and adjacent ownership checks:

```sh
.highway/tools/tests/highway-controls-onboarding.test.sh
.highway/tools/tests/highway-nfr-onboarding.test.sh
.highway/tools/tests/governance-routing.test.sh
.highway/tools/tests/control-derived-nfr.test.sh
.highway/tools/tests/readiness-owner-states.test.sh
```

Expected result: all commands exit 0. The checks cover canonical output wording, empty-review
fixtures, proposal-state write boundaries, existing-baseline routing, candidate ordering, readiness
ownership, and duplicate-failure preservation.

Execution note: `control-derived-nfr.test.sh` and `readiness-owner-states.test.sh` are currently
invoked with `bash` when their executable bit is absent; their test contents and results are unchanged.

## Generated correspondence validation

If canonical skill sources are changed, regenerate and validate the existing distributed artifacts:

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/adapter-coverage.test.sh
```

Expected result: no stale catalog or adapter correspondence is reported.

Feature 078 implementation validation completed with all five focused checks passing and both
generated-artifact checks passing.

## Full validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the repository suite exits 0 and no whitespace errors are reported. Do not run
concurrent suite instances because temporary catalog fixtures can race.

Feature 078 result: `.highway/tools/tests/run-all.sh` exited 0 and `git diff --check` exited 0.

## Review scenarios

1. Populate Control proposals and verify all four fields and four decisions appear in collection order.
2. Render empty Control and NFR reviews and verify `Status: Empty` with `Entry Count: 0`.
3. Cancel or fail before `Review Complete` and compare proposal, identifier, onboarding, catalog, and relationship bytes.
4. Re-render identical candidates and compare ordering; then exercise duplicate detection before NFR allocation and verify no partial write.
5. Complete a successful NFR review and evaluate readiness afterward; compare readiness-consumed state after cancellation and failure paths.

See [data-model.md](./data-model.md) for state and ownership invariants and [contracts/](./contracts/)
for owner-local output contracts.
