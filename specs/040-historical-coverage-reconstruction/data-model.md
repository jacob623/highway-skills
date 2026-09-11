# Feature 040 Data Model

## Historical Coverage Record

A development-only `coverage.md` file stored in each completed feature directory in the Feature
040 scope.

| Field | Meaning | Validation |
|---|---|---|
| Requirement | One `FR-NNN` identifier declared in that feature's `spec.md` | Every declared identifier appears exactly once; no unknown or duplicate identifiers |
| Outcome | Current disposition of the requirement claim | Exactly `satisfied`, `deferred`, or `historical`; `historical` is valid only for Features 001-020 |
| Evidence | Concise provenance for the outcome | Non-empty; `satisfied` names an existing artifact, `deferred` names a correcting feature, and `historical` names the carried-forward completion record |

Required header:

```text
| Requirement | Outcome | Evidence |
```

## Requirement Row Relationships

- One completed feature has one `coverage.md` record.
- One record has one row for every functional requirement in its feature's `spec.md`.
- A `satisfied` row points to a current repository artifact that substantively meets the requirement.
- A `deferred` row identifies a later feature that demonstrably corrected the requirement.
- A `historical` row preserves the earlier completion claim without creating an owner or asserting current satisfaction.

## Completed Feature Scope

| Scope | Included |
|---|---|
| Historical reconstruction | Features 001, 002, and 004 through 019; 18 new records |
| Existing below-021 coverage | Feature 020's already-present record |
| Current enforcement scope | Every completed feature from 001 onward |
| Explicit exclusion | Incomplete Feature 003 |
| Historical outcome bound | Features 001-020 only |

The verified historical baseline is 19 completed features below 021 and 309 functional requirements,
comprising 18 new records plus Feature 020's existing record.

## Completion Check Contract

`completion-coverage.test.sh` must:

1. Discover every completed feature in the 001-onward scope without relying on a historical
   directory having a `tasks.md` file.
2. Exclude incomplete Feature 003.
3. Require `coverage.md` and the exact three-column header.
4. Compare coverage identifiers with the feature's declared functional requirement identifiers.
5. Reject malformed outcomes, missing evidence, duplicate rows, unknown rows, missing rows, and
   absent artifacts for `satisfied` rows.
6. Reject `historical` rows in Features 021 and above.
7. Preserve Feature 039's disposable failure probes and restore the fixture after each mutation.

## Outcome Review Record

The implementation must report counts and proportions for `satisfied`, `deferred`, and
`historical` rows. A predominantly `satisfied` result is a review failure signal because it may
indicate evidence was manufactured from shipment or green tests rather than from named artifacts.
