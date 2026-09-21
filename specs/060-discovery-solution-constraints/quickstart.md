# Feature 060 Quickstart

This guide validates the Solution Constraints contract for `highway-discovery` without creating
user-owned Request or Discovery records.

## Prerequisites

- Repository root is the current directory.
- Existing Discovery skill, templates, and Bash 3.2-compatible test harness are present.
- Feature 060 design artifacts exist under `specs/060-discovery-solution-constraints/`.
- No extension hooks are required.

## Contract Review

Verify the design artifacts and canonical inputs:

```sh
sed -n '1,260p' specs/060-discovery-solution-constraints/contracts/discovery-analysis-contract.md
sed -n '1,220p' specs/060-discovery-solution-constraints/contracts/discovery-artifact-contract.md
```

Expected outcomes:

- Eight Request Solution Constraints fields appear in canonical order.
- Required-platform, hosting, vendor, procurement, and regulatory failures are pre-scoring
  exclusions with elimination evidence.
- Preferred platforms and known systems never eliminate candidates.
- Known-system alignment uses 100/75/50.
- Retained candidates report Required Platform Match 100.
- Matrix compliance uses `Fully Compliant` or `Satisfied`.

## Focused Static Validation

Run the existing validators and focused tests after implementation:

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-discovery
.highway/tools/validate-library.sh .highway/library/templates/output/discovery-record.md
.highway/tools/tests/highway-discovery.test.sh
.highway/tools/tests/output-template.test.sh
```

Expected outcome: every command exits 0 and the focused Discovery test confirms input loading,
required-platform elimination, elimination-log ordering, known-system scoring, canonical rendering,
retained-only scoring, matrix compliance, advisory ownership, and no-write failure behavior.

## Generated Artifact Validation

Regenerate canonical outputs using the repository generators:

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/generate-catalog.test.sh
.highway/tools/tests/generate-library-catalog.test.sh
.highway/tools/tests/distribution-packaging.test.sh
```

Expected outcome: generated adapters and catalogs match canonical sources and packaging remains
valid.

## Full Regression

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected outcome: the full suite exits 0 and no whitespace errors are reported.

## Behavioral Probe Expectations

The focused Discovery test should include disposable scenarios proving:

1. Known allowed classes restrict generated candidates.
2. `unknown` allowed classes preserve existing unconstrained generation.
3. Required-platform mismatch is logged and excluded before scoring.
4. Hosting, vendor, procurement, and regulatory violations are logged and excluded.
5. Preferred-platform mismatch remains eligible and changes scoring only.
6. Known-system scores are exactly 100, 75, or 50.
7. Retained candidates always report Required Platform Match 100.
8. Elimination entries sort by candidate identifier, category, and constraint identifier/value.
9. Zero viable candidates abort without record/catalog writes.
10. Identical closed inputs produce identical candidate sets and output ordering.
