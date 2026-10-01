# Quickstart: Final Setup Contract Cleanup

## Prerequisites

- Run from the repository root.
- Ensure `.highway/` and generated agent trees are present.

## Focused validation

```sh
bash .highway/tools/tests/highway-setup.test.sh
bash .highway/tools/tests/highway-setup-executable.test.sh
bash .highway/tools/tests/setup-owner-loop-contract.test.sh
bash .highway/tools/tests/readiness-contract.test.sh
```

Expected outcome: all focused Setup contract checks exit `0`.

## Full validation

```sh
bash .highway/tools/tests/run-all.sh
```

Verified on 2026-09-30: the full suite exits `0` with 62 tests passed and 0 failures.

## Generated artifacts

After editing `.highway/skills/highway-setup/SKILL.md`, regenerate the catalog and agent adapters,
then rerun focused and full validation. The generated Setup adapters must retain version `8.0.0`
and match the canonical skill.

See [setup-owner-specific-results.md](contracts/setup-owner-specific-results.md) for the exact
welcome, owner-result, and transition contract.
