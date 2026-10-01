# Quickstart: Setup Orchestrator Contract Simplification

## Prerequisites

- Run from the repository root.
- Ensure the `.highway/` tree and generated agent trees are present.

## Focused validation

Run the Setup contract checks:

```sh
.highway/tools/tests/highway-setup.test.sh
.highway/tools/tests/highway-setup-executable.test.sh
.highway/tools/tests/setup-owner-loop-contract.test.sh
```

Expected outcome: each script exits `0` and reports `OK`.

## Full validation

Run the complete repository suite:

```sh
.highway/tools/tests/run-all.sh
```

Expected outcome: the suite exits `0` with no failures. Verified on 2026-09-30: 62 tests passed and 0 failed.

## Generated artifact validation

After editing `.highway/skills/highway-setup/SKILL.md`, run the repository's declared catalog and
adapter generators, then rerun the focused and full validation commands. Generated output must
match the canonical skill and contain version `8.0.0`.

See [setup-owner-orchestration.md](contracts/setup-owner-orchestration.md) for the owner-result
contract exercised by these checks.
