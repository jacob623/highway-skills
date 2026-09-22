# Quickstart: Clarification Catalog (Phase 1)

## Prerequisites

Run from the repository root with the existing Highway shell toolchain available.

```sh
cd /Users/jacoblong/Documents/wayfinder/highway/highway-skills
```

The validation scenarios use disposable fixtures. Do not run them against user-owned clarification outputs unless the test explicitly creates and removes a temporary workspace.

## Static Contract Validation

Validate the Clarify skill and both shared output templates:

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-clarify
.highway/tools/validate-library.sh .highway/library/templates/output/clarification-catalog.md
.highway/tools/validate-library.sh .highway/library/templates/output/clarification-record.md
```

Expected result: each command exits `0` and reports no contract violations.

## Focused Clarification Validation

Run the focused Clarify test:

```sh
.highway/tools/tests/highway-clarify.test.sh
```

Expected result: the Clarify contract, catalog template citation, deterministic catalog behavior, duplicate detection, status synchronization, and failure-path byte preservation checks pass.

## Shared Template and Correspondence Validation

Run the shared output-template check and adapter correspondence check:

```sh
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/adapter-coverage.test.sh
```

Expected result: the catalog template is present and structurally complete, `highway-clarify` cites it without duplicating its structure, and all generated adapters correspond to the canonical skill.

## Full Validation

Run the complete repository suite:

```sh
perl -e '$SIG{ALRM}=sub { exit 124 }; alarm 200; exec @ARGV' .highway/tools/tests/run-all.sh
```

Expected result: all applicable checks pass within 200 seconds, including packaging, path integrity, skill validation, library validation, correspondence, and focused Clarify behavior. In the implementation run, 41 scripts passed and the suite reached the 200-second timeout while entering the final setup executable check; the setup check passed independently within 10 seconds and also passed immediately after the preceding validator.

Observed implementation validation:

- `highway-clarify.test.sh`: passed.
- `output-template.test.sh`: passed.
- `validate-skill.sh`, `validate-library.sh`, and `adapter-coverage.test.sh`: passed after regenerating library and Highway indexes.
- `run-all.sh` under the required 200-second alarm: timed out with 41 scripts passed and 0 failures reported before timeout.

## Behavioral Scenarios

The focused test must cover these observable scenarios:

1. Generate the first valid clarification and verify catalog creation with one row.
2. Generate additional `REQ`, `DISC`, `ADR`, and `RA` clarifications in a deliberately different creation order and verify artifact-type/artifact-ID ordering.
3. Regenerate an existing clarification and verify no duplicate row.
4. Update status to `complete` or `blocked` and verify the catalog mirrors the clarification.
5. Reject unsupported types/statuses, duplicate rows, malformed catalogs, missing artifacts, and mismatched status.
6. Force clarification or catalog write failure and verify every pre-operation byte remains unchanged.
7. Repeat an identical operation and compare catalog bytes.
8. Verify Discovery behavior and existing clarification findings remain unchanged.
