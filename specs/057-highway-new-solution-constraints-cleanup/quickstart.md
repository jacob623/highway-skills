# Quickstart: Solution Constraints Cleanup

## Prerequisites

Run from the repository root on macOS or Linux with the existing Bash 3.2-compatible toolchain.
No package installation is required.

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

## Design Artifact Checks

Confirm all design artifacts exist and contain no unresolved clarification markers:

```sh
test -f specs/057-highway-new-solution-constraints-cleanup/plan.md
test -f specs/057-highway-new-solution-constraints-cleanup/research.md
test -f specs/057-highway-new-solution-constraints-cleanup/data-model.md
test -f specs/057-highway-new-solution-constraints-cleanup/quickstart.md
test -f specs/057-highway-new-solution-constraints-cleanup/contracts/solution-constraints-intake-contract.md
test -f specs/057-highway-new-solution-constraints-cleanup/contracts/solution-constraints-verification-contract.md
! grep -R '\[NEEDS CLARIFICATION\]' specs/057-highway-new-solution-constraints-cleanup
```

## Implementation Validation

After implementation, run the focused behavior test first:

```sh
.highway/tools/tests/highway-new.test.sh
```

Then validate source and shared output contracts:

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-new/SKILL.md
.highway/tools/validate-library.sh .highway/library/templates/output/request-record.md
```

Regenerate declared outputs when the authoritative source changes, then run correspondence and
full-suite checks using the repository's existing test commands:

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/tests/run-all.sh
```

## Expected Focused Scenarios

The focused checks should pass for:

- exactly four list-shaped and four scalar fields;
- populated, explicit-empty, and `unknown` states for the three non-candidate list fields;
- populated and `unknown` `allowed_solution_classes` values;
- rejection of an empty candidate-space list, blank candidate value, scalar candidate value, and
  empty candidate entry;
- rejection of blank scalar restrictions and scalar arrays;
- local correction that retains earlier answers and updates only the failed field;
- privacy screening that prevents a disallowed replacement from being written;
- `No business constraints` wording with the existing durable empty state;
- Discovery handoff containing one or more candidate classes or `unknown`, never `[]`;
- rejection of the legacy generic list, Business Constraints, and field-error wording.

This quickstart describes the checks to run after implementation; it does not claim that the
current legacy source passes them before the feature is implemented.
