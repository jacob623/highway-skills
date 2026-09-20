# Quickstart: Request Solution Constraints

## Prerequisites

- Run from the repository root.
- Bash 3.2-compatible repository tooling is available.
- The existing `highway-new` skill, shared Request templates, and focused test are present.
- Feature 053 implementation work has updated the authoritative `.highway/` source files before
  running behavioral checks.

## 1. Validate the design contracts

Review:

- [data-model.md](data-model.md)
- [contracts/request-solution-constraints-intake-contract.md](contracts/request-solution-constraints-intake-contract.md)
- [contracts/request-solution-constraints-record-contract.md](contracts/request-solution-constraints-record-contract.md)

Confirm that the eight Solution Constraints fields, value-state semantics, ordering, and ownership
boundaries agree across the three documents.

## 2. Validate the source skill and shared output

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-new
.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md
```

Expected result: both commands exit 0 without new validation errors.

## 3. Run focused Request scenarios

```sh
.highway/tools/tests/highway-new.test.sh
```

The focused scenarios must cover:

- Multiple `allowed_solution_classes` without ranking.
- Separate required and preferred platforms.
- Known systems as descriptive context.
- Procurement constraints that do not eliminate custom development.
- Populated values, explicit empty arrays, and `unknown` values.
- Neutral handling of absent constraints.
- Existing privacy, completeness, transaction, and no-write behavior.

## 4. Regenerate and verify derived artifacts

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/adapter-coverage.test.sh
```

Expected result: generated catalog and adapters correspond to the authoritative source skill, with
no hand-edited generated files and no development-only path dependencies.

## 5. Run the repository suite

```sh
.highway/tools/tests/run-all.sh
```

Record the final result separately from Feature 053 coverage. Existing baseline failures must not
be attributed to this feature unless the focused evidence identifies a new regression.

## 6. Boundary review

Confirm no Feature 053 change modifies Discovery recommendation, classification, scoring, candidate
generation, or architecture analysis, and no ADR decision or artifact is created.
