# Quickstart: Clarification Determinism and Lifecycle Contracts

## Prerequisites

Run from the repository root with the existing Highway shell toolchain:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

Use disposable fixtures for behavioral checks. Do not write to user-owned clarification outputs unless a test creates a temporary workspace.

## Static Contract Validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-clarify
.highway/tools/validate-library.sh .highway/library/templates/output/clarification-catalog.md
```

Expected result: both commands exit `0` with no contract violations.

## Focused Contract and Behavior Tests

```sh
.highway/tools/tests/highway-clarify.test.sh
.highway/tools/tests/output-template.test.sh
```

Expected results:

1. The Clarify skill contains the ambiguity, contradiction, finding identity, status precedence, and catalog bootstrap contracts.
2. The catalog template contains the `Clarification Path` column and explanatory note.
3. Default ambiguity terms match only by case-insensitive exact normalized phrase comparison.
4. Profile terms extend, but do not replace, the defaults.
5. Contradiction findings require declared rules, both fields, and a true declared condition.
6. Finding IDs remain stable through reordering and removal; retired sequence IDs are not reused.
7. Exactly one status is selected using `blocked`, `complete`, `in-progress`, `not-started` precedence.
8. Missing catalogs use the authoritative template and the same validation as existing catalogs.
9. Invalid input and write failures preserve clarification and catalog bytes.

## Generated Artifact Validation

After canonical skill or template changes, regenerate and validate derived outputs serially:

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-catalog.sh
.highway/tools/tests/adapter-coverage.test.sh
```

Expected result: all generated adapters and catalog indexes correspond to the canonical sources.

## Full Validation

Run the full suite once, without concurrent test commands. On macOS use the Perl alarm wrapper:

```sh
perl -e '$SIG{ALRM}=sub { exit 124 }; alarm 200; exec @ARGV' .highway/tools/tests/run-all.sh
```

Expected result: all repository checks pass within 200 seconds.

Feature 067 validation result on 2026-09-22: the focused Clarify and output-template tests,
canonical skill/template validators, adapter correspondence test, and serialized full suite passed.
The full suite completed with 42 passed and 0 failed within the 200-second limit.

## Behavioral Scenarios

1. Analyze each default ambiguity term with mixed casing and surrounding whitespace; confirm one finding per match.
2. Analyze partial words, regular-expression-looking text, and semantically similar text; confirm no unsupported ambiguity findings.
3. Add profile vocabulary; confirm defaults remain active and added terms match exactly.
4. Apply a declared contradiction rule with missing, false, and true field conditions; confirm only the true declared condition creates a finding.
5. Reorder findings and regenerate; confirm identifiers remain attached to fingerprints.
6. Remove an earlier finding; confirm later identifiers remain unchanged and the removed identifier is retired.
7. Evaluate malformed, complete, in-progress, and absent records; confirm the declared status precedence.
8. Generate a first clarification with no catalog; confirm template-based bootstrap and full existing-catalog validation.
9. Force clarification or catalog validation/write failure; confirm every affected byte is unchanged.
10. Repeat an identical operation; compare finding IDs and catalog bytes, including the informational Clarification Path.
