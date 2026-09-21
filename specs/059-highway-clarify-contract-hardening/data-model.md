# Data Model: Highway Clarify Contract Hardening

## Clarification Artifact Identifier

| Field | Meaning | Validation |
|---|---|---|
| `id` | Stable clarification identifier | Exactly `CLAR-<ARTIFACT-ID>` for the supported source identifier |
| `artifact_id` | Source artifact identifier | Exact uppercase `REQ######`, `DISC######`, `ADR######`, or `RA######` |
| `artifact_type` | Source identifier family | Derived from `artifact_id` |

## Stable Consumer Contract

| Field | Meaning | Type/Rule |
|---|---|---|
| `artifact_id` | Source identifier | String; never renamed |
| `exists` | Whether a clarification artifact exists | Boolean |
| `status` | Current clarification state | One of `not-started`, `in-progress`, `complete`, `blocked` |
| `open_findings` | Findings without valid resolution | Integer >= 0 |
| `resolved_findings` | Findings with valid resolution | Integer >= 0 |
| `total_findings` | Total findings | Integer >= 0; equals open plus resolved |
| `path` | Deterministic colocated artifact path | String or null for not-started |
| `blocking_reason` | Reason for blocked state | String or `None` |

Future versions may add fields but cannot remove, rename, or change these fields' types.

## Clarification Profile

| Field | Meaning | Validation |
|---|---|---|
| `discovery_source` | Selected profile location | Artifact-local, artifact-type, or global |
| `ambiguity_vocabulary` | Additional ambiguity terms | Extends defaults; cannot remove defaults |
| `unknown_markers` | Explicit unknown values | Declared strings |
| `required_fields` | Required source fields | Declared names |
| `required_sections` | Required source sections | Declared names |
| `contradiction_rules` | Explicit contradiction matches | Rule pairs with fields and values |

Discovery order is artifact-local declaration, `.highway/library/clarification/<artifact-type>.yaml`, then `.highway/library/clarification/profile.yaml`. No resolvable profile is valid.

## Finding

| Field | Meaning | Validation |
|---|---|---|
| `finding_id` | Stable evidence identity | Deterministic for unchanged evidence |
| `category` | Priority category | Exact five-category order |
| `severity` | Finding impact | Stable for identical inputs |
| `evidence_ref` | Sanitized source location/evidence identity | Privacy-filtered before retention |
| `source_order` | Source artifact position | Deterministic integer/order key |
| `source_field` | Source field name | Deterministic tie-break key |
| `state` | Resolution state | `open` or `resolved` |
| `response` | Latest accepted response | Privacy-filtered; required when resolved |

Ordering key: category priority, source artifact order, source field name, finding identifier.

## Resolution History Entry

- `finding_id`
- privacy-filtered `response`
- committed integer `revision`
- actor metadata after privacy filtering

History is retained during regeneration and appended only after successful revision-validated updates.

## Revision and Conflict State

- `revision`: integer, starts at 1, increments exactly once per successful Update, never changes on failure or conflict.
- `expected_revision`: caller's revision at Update start.
- `actual_revision`: revision observed during pre-write validation.
- Conflict state is no-write, no-history, and no-revision-change.

## Status Transitions

```text
(no clarification artifact) -> not-started
artifact with open_findings > 0 -> in-progress
artifact with open_findings = 0 -> complete
malformed artifact or invalid required structure -> blocked
```

## Privacy-Filtered Value

Sensitive values in source evidence, findings, responses, history, metadata, and copied content are replaced before retention with `<secret-redacted>` or `<pii-redacted>`.
