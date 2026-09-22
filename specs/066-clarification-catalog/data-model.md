# Data Model: Clarification Catalog

## Clarification Artifact

The existing authoritative record produced by `highway-clarify`.

| Field | Meaning | Validation / ownership |
|---|---|---|
| `id` | Stable clarification identity, formatted `CLAR-<ARTIFACT-ID>` | Derived from the source artifact ID; exactly one catalog row references it |
| `artifact_id` | Source artifact identifier | Exact uppercase supported identifier with six digits |
| `artifact_type` | Source artifact family | One of `REQ`, `DISC`, `ADR`, `RA` |
| `status` | Current clarification state | One of `not-started`, `in-progress`, `complete`, `blocked`; authoritative in the clarification artifact |
| `path` | Colocated clarification artifact path | Must resolve to an existing clarification artifact for a catalog entry |
| `content` | Findings, responses, history, source, and analysis output | Owned by the clarification artifact; not copied into the catalog |

## Clarification Catalog

The repository artifact at `clarifications/clarifications.md`.

| Element | Meaning | Validation |
|---|---|---|
| `Version` | Catalog document version | Must be `1.0.0` for Phase 1 |
| `Clarification Index` | The catalog's only index section | Must contain the required four columns |
| `rows` | Inventory of clarification mappings | Exactly one row per clarification artifact; sorted by artifact type then artifact ID |

## Catalog Entry

Each row has exactly four required fields:

| Field | Example | Rule |
|---|---|---|
| Clarification ID | `CLAR-REQ000123` | Unique across the catalog and derived from Artifact ID |
| Artifact ID | `REQ000123` | Unique mapping target and source of the Clarification ID |
| Artifact Type | `REQ` | Must match the source artifact family |
| Status | `in-progress` | Must match the clarification artifact status |

## Relationships

- One Clarification Artifact has exactly one Catalog Entry.
- One Catalog Entry references exactly one Clarification Artifact.
- The Clarification ID is a deterministic projection of the Artifact ID.
- The Catalog owns lookup, linkage, inventory, and status projection.
- The Clarification Artifact owns findings, responses, revision history, content, and analysis output.

## Lifecycle and State Rules

1. Validate the source identifier and clarification artifact.
2. Derive the Clarification ID and current status.
3. Validate the existing catalog if it exists.
4. Insert or replace exactly one row for the artifact.
5. Sort all rows by Artifact Type, then Artifact ID.
6. Render and validate the complete catalog structure.
7. Commit the clarification artifact and catalog together on success.
8. On validation or write failure, abort and preserve pre-operation bytes.

`not-started`, `in-progress`, `complete`, and `blocked` are allowed states. Phase 1 does not define new status transitions; it mirrors transitions already accepted by the clarification workflow.

## Invariants

- No duplicate Clarification IDs.
- No duplicate clarification artifact paths.
- No duplicate Artifact IDs or conflicting Clarification ID to Artifact ID mappings.
- Every catalog entry resolves to an existing clarification artifact.
- Every clarification artifact appears exactly once in the catalog.
- Catalog status equals clarification artifact status.
- Identical inputs yield identical catalog ordering and bytes.
