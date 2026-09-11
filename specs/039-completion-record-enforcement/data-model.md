# Feature 039 Data Model

## Coverage Record

A development-only `coverage.md` file stored in each completed feature directory.

| Field | Meaning | Validation |
|---|---|---|
| Requirement | One `FR-NNN` identifier declared exactly once in that feature's `spec.md` | Required; no duplicates or unknown IDs |
| Outcome | The requirement's recorded disposition | Exactly `satisfied`, `deferred`, or `historical`; `historical` only in Features 001-020 |
| Evidence | Artifact and concise evidence supporting the outcome | Non-empty; satisfying artifact exists; deferred rows name the reason and owner; historical rows name the carried-forward record |

Required table header:

```text
| Requirement | Outcome | Evidence |
```

## Requirement Coverage Row

A single row in a Coverage Record. Rows form a one-to-one mapping with the feature's functional requirements.

### Relationships

- One feature has one Coverage Record.
- One Coverage Record has one row for every functional requirement in that feature's `spec.md`.
- A row with outcome `satisfied` points to an existing artifact.
- A row with outcome `deferred` points to the reason and the later feature or work owning the deferral.

## Corrective Feature Link

A semantic relationship represented in coverage evidence when a later feature corrects an earlier completed feature.

| Field | Meaning | Validation |
|---|---|---|
| Originating feature | Completed feature whose claim is being qualified | Names an existing feature directory |
| Revised requirement | Requirement whose disposition is changed or completed later | Names an FR identifier from the originating spec |
| Superseding feature | Later feature that addresses the gap | Names the corrective feature directory |
| Disposition | Historical status in the originating record | Uses `deferred` until the correction is explicitly recorded |

## Declared Check Scope

The set of completed feature directories from 021 onward plus Feature 020, and the artifact classes used to prove the completion check can fail. Features 001-019 are declared as owned by Feature 040.

| Property | Rule |
|---|---|
| Feature inclusion | Include every completed feature from 021 onward plus Feature 020; name Feature 040 as owner of 001-019 |
| Coverage path | `coverage.md` only |
| Required schema | `Requirement`, `Outcome`, `Evidence` in that order |
| Failure behavior | Missing, malformed, duplicate, unknown, or unsupported data exits non-zero |
| Probe behavior | One seeded defect per declared artifact class produces a non-zero result |

## Feature Record Identity

The relationship between a feature directory and its `Feature Branch` field.

| Component | Rule |
|---|---|
| Numeric prefix | Three-digit feature number remains sequential |
| Descriptive suffix | Matches the declared branch suffix and is not a numeric placeholder |
| Historical content | Completed substantive spec content remains unchanged |
| Allowed correction | Coverage record changes are permitted by the narrow D5.1 exception |

## Current Inventory

The completed feature records currently in the repository are 001 through 039. Before
implementation, the coverage artifacts are:

| Record state | Features |
|---|---|
| Canonical `coverage.md` | 020 through 037 where the feature is completed, plus Feature 039 |
| Alternate filename | None in the enforced completed scope |
| Missing record in the enforced scope | None |
| Historical owner outside this change | 001 through 019, Feature 040 |

Feature identity reconciliation was required for 001, 005, 033, and 036. The 033 and 036 records
now use their declared branch paths; the 001 and 005 declarations no longer contain brackets.
