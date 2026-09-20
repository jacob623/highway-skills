# Quickstart: Highway New Constraint Hardening

## Prerequisites

- Run commands from the repository root.
- Bash 3.2-compatible tooling is available.
- Feature 053 Solution Constraints behavior is present in the authoritative source files.
- The current Feature 054 source, contract, and focused-test changes are available before running
  the checks below.

## 1. Review the design contracts

Review:

- [data-model.md](data-model.md)
- [contracts/constraint-hardening-intake-contract.md](contracts/constraint-hardening-intake-contract.md)
- [contracts/constraint-hardening-record-contract.md](contracts/constraint-hardening-record-contract.md)

Confirm that the allowed-class cardinality, `None known` wording boundary, field-specific recovery
shapes, and no-write rules agree.

## 2. Validate authoritative sources

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-new
.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md
```

Expected result: both commands exit 0.

## 3. Run focused hardening scenarios

```sh
.highway/tools/tests/highway-new.test.sh
.highway/tools/tests/output-template.test.sh
```

Focused scenarios must cover:

- Single-value, multi-value, `unknown`, empty, and malformed `allowed_solution_classes` input.
- `None known` wording for Business Constraints and distinction from `unknown`.
- Field-specific errors for list-shaped and scalar Solution Constraints values.
- Valid replacement continuation, bounded retry, privacy rejection, and no-partial-write behavior.
- Preservation of existing Request identity, catalog, transaction, and unrelated domain behavior.

## 4. Regenerate and verify derived artifacts

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/shipped-tree-independence.test.sh
.highway/tools/tests/distribution-packaging.test.sh
```

Expected result: generated artifacts correspond to authoritative inputs, shipped files contain no
development-only references, and packaging succeeds.

## 5. Run the repository suite

```sh
.highway/tools/tests/run-all.sh
```

Record the final result separately from Feature 054 focused coverage. Any baseline failure or
runtime timeout must be named rather than reported as a pass.

## 6. Boundary review

Confirm that no change modifies Discovery candidate generation, classification, comparison, scoring,
recommendation, or architecture analysis, and that no ADR decision or artifact is created.
