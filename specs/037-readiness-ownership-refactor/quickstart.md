# Feature 037 Quickstart

## Prerequisites

Run from the repository root on macOS or Linux with Bash 3.2-compatible syntax and the repository's existing shell utilities.

## Focused owner validation

Run the owner-specific readiness tests after implementation:

```sh
bash .highway/tools/tests/readiness-ownership.test.sh
```

Expected result: Profile, Objectives, Controls, and NFR fixtures emit the four ordered fields, use only allowed statuses, and leave all fixture artifacts and identifiers unchanged.

## Focused Setup validation

```sh
bash .highway/tools/tests/highway-setup.test.sh
```

Expected result: Setup calls readiness in Profile, Objectives, Controls, NFR order, stops at the first non-complete prerequisite, includes owner blocking reasons, and completes for NFR `Complete` and `Not Applicable`.

## Full validation

```sh
bash .highway/tools/tests/run-all.sh
```

Expected result: all discovered tests pass.

## Static and artifact checks

```sh
bash .highway/tools/tests/validate-skill.test.sh
bash .highway/tools/tests/adapter-coverage.test.sh
bash .highway/tools/generate-distribution.sh "$(mktemp -d)"
git diff --check
```

The static checks validate the five changed skills and generated correspondence. Distribution output is written to a temporary directory and must not modify committed generated artifacts.

## Contract references

- Shared response and allowed statuses: [contracts/shared-readiness-contract.md](contracts/shared-readiness-contract.md)
- Owner state rules: [contracts/owner-readiness-contracts.md](contracts/owner-readiness-contracts.md)
- Setup routing: [contracts/setup-readiness-contract.md](contracts/setup-readiness-contract.md)
- Verification evidence categories: [data-model.md](data-model.md)
