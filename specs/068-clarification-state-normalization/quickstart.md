# Quickstart: Clarification State and Fingerprint Normalization

## Prerequisites

Run from the repository root:

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

Use disposable fixtures for behavioral checks. Do not write to user-owned clarification outputs.

## Static Contract Validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-clarify
.highway/tools/validate-library.sh .highway/library/templates/output/clarification-catalog.md
.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md
```

Expected result: all commands exit `0` with no contract violations. The skill reports version
`1.4.0`, the catalog template reports `1.1.0`, and the record template reports `1.2.0`.

## Focused Contract and Behavior Tests

```sh
.highway/tools/tests/highway-clarify.test.sh
.highway/tools/tests/output-template.test.sh
```

Expected results:

1. Fingerprints normalize line endings, trimming, case, repeated whitespace, and canonical
   source-field names before identity comparison.
2. Equivalent normalized inputs produce identical fingerprints.
3. Findings use only `open` and `resolved`; resolution is one-way and retains identity/history.
4. Count invariants reject malformed records and produce `blocked` status.
5. Catalog entries and clarification artifacts have one-to-one identity, matching status, existing
   references, and directly resolving Clarification Paths.
6. Failed consistency and write operations preserve pre-operation bytes.

## Generated Artifact Validation

After canonical skill or template changes, regenerate and validate derived outputs serially:

```sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-catalog.sh
.highway/tools/tests/adapter-coverage.test.sh
```

## Behavioral Scenarios

1. Compare CRLF, CR, and LF evidence values and confirm one normalized fingerprint.
2. Compare case, surrounding whitespace, and repeated whitespace variants and confirm identical
   fingerprints.
3. Compare source-field aliases with the canonical declared field and confirm identity reuse.
4. Create a finding and confirm it starts `open`; apply an accepted response and confirm it becomes
   `resolved` without changing identifier, fingerprint, history, or evidence references.
5. Attempt a resolved-to-open or unsupported state transition and confirm malformed/blocked output.
6. Use valid and invalid count relationships, including zero-open records, and confirm the invariant
   and blocked precedence.
7. Validate a catalog with missing, duplicate, stale, mismatched, and valid entries; confirm only
   the one-to-one valid relationship succeeds.
8. Resolve each Clarification Path and confirm it points directly to the authoritative artifact.
9. Force consistency or write failure and compare all pre-operation clarification and catalog bytes.

## Full Validation

Run the complete repository suite once, without concurrent test commands:

```sh
perl -e '$SIG{ALRM}=sub { exit 124 }; alarm 200; exec @ARGV' .highway/tools/tests/run-all.sh
```

Expected result: all repository checks pass within 200 seconds.
