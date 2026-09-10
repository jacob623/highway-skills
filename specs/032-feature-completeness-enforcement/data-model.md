# Data Model: Feature Completeness and Behavioral Evidence Enforcement

## Requirement Coverage Record

A per-feature Markdown table that is authoritative for requirement-to-evidence mapping.

| Field | Rule |
|---|---|
| Feature | Exact sequential feature directory name |
| Status | `satisfied` or `deferred` |
| Requirement | Exactly one functional requirement identifier from the feature spec |
| Evidence category | `behavioral`, `structural`, `documentation-only`, or `deferred` |
| Evidence | Repository-relative artifact and the behavior or check it proves |
| Reason | Required for deferred rows; optional qualification for other rows |

**Validation**: Every functional requirement appears exactly once; unknown, duplicate, or missing IDs
fail the completion-coverage check. A check result alone cannot be used as a coverage row without
identifying the requirement evidence it supports.

## Behavioral Evidence Case

A disposable test scenario proving one workflow claim.

| Field | Rule |
|---|---|
| Baseline | Isolated copy of the relevant records, templates, and catalogs |
| Operation | One generation, review, inspection, repair, impact, or lifecycle action |
| Decision | Explicit accepted, modified, replaced, rejected, cancelled, subset, or declined state when applicable |
| Expected output | Report, proposal, write set, or blocking failure |
| Preservation set | Files whose bytes must remain unchanged |
| Failure point | Optional injected validation, allocation, staging, or commit failure |
| Cleanup | Temporary tree and probes removed on every exit path |

## Atomic Operation Result

An all-or-nothing result for an approved operation.

| Field | Rule |
|---|---|
| Pre-state snapshot | Bytes of every affected record and catalog |
| Selected change set | Only explicitly approved relationship or derived-NFR changes |
| Validation result | Complete set accepted or blocking failure named |
| Commit result | Complete change set committed or no bytes changed |
| Post-state assertion | Exact expected bytes on success; exact pre-state bytes on failure |

## Relationship Finding

A deterministic classification of one Control-to-NFR relationship condition.

| Class | Meaning |
|---|---|
| `valid` | Correctly formatted, existing, correctly typed, reciprocal, and unique |
| `malformed` | Identifier format or type is invalid |
| `orphaned` | Identifier is well-formed but target artifact is absent |
| `asymmetric` | Target exists but reciprocal membership is missing |
| `duplicate` | Same immutable identifier occurs more than once in one field |
| `blocked` | Baseline cannot be safely interpreted or contains conflicting records |

## Impact Entry

One artifact or relationship that would be lost by removal or baseline replacement.

| Field | Rule |
|---|---|
| Source type and ID | Existing Control or NFR immutable identity |
| Source title | Current baseline title |
| Target type and ID | Related artifact immutable identity |
| Target title | Current baseline title |
| Impact reason | Removal or replacement comparison result |
| Ordering key | Source type, source ID, target type, target ID, then reason |

## Lifecycle Evidence State

A consistency view across spec, tasks, coverage, and tests.

| State | Meaning |
|---|---|
| `Draft` | Requirements exist, but completion evidence is incomplete or behavioral work is not verified |
| `Implemented` | Artifacts and behavior exist, but completion records are not yet fully reconciled |
| `Complete` | Coverage is exact, required behavior is executable and passing, and status/task language agrees |
