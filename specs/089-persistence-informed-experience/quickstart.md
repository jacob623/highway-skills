# Feature 089 Validation Quickstart

## Prerequisites

- macOS or another environment compatible with the repository's Bash 3.2-compatible scripts.
- Repository root as the current working directory.
- No individual skill migration is required for this feature.

## Focused validation

Run the constitutional inventory and UX alignment checks:

```sh
bash .highway/tools/tests/constitution-inventory.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

Expected result: both commands exit 0 and report PASS.

These checks must prove that:

- Constitution and Experience Standard rule inventories remain parseable and uniquely identified.
- P12 rules are atomic and have valid keyword, Observable, Tier, precedence, and count metadata.
- N6-N9 are registered once in the Constitution and referenced correctly by Experience rules.
- X1.6, X2.9, and X2.10 are present without changing X2.1-X2.8 semantics.
- The Interactive Workflow UX Contract contains the anti-ceremony guidance without a duplicate X rule.
- No individual skill file is modified by Feature 089.

## Full validation

Run the complete repository suite:

```sh
.highway/tools/tests/run-all.sh
```

Expected result: every registered test passes and the summary reports zero failures.

## Manual governance review

1. Confirm the Constitution footer version matches the latest completed Sync Impact Report before applying the Feature 089 bump.
2. Confirm Principle XII follows Principle XI and its P12 rules map N6 only to Retained Output-dependent obligations.
3. Confirm the Experience Standard references N6-N9 without defining a competing registry.
4. Confirm validation-tooling changes are limited to Feature 089 governance recognition and no skill file appears in the diff.
5. Confirm the final diff is whitespace-clean:

```sh
git diff --check
```
