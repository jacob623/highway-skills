# Data Model: Highway ADR Contract Hardening

## ADR Record

| Field | Shape | Rule |
|---|---|---|
| `id` | `ADRXXXXXX` | Allocated from the catalog `Next ID` immediately before publication. |
| `request` | `REQXXXXXX` | Projected from the uniquely resolved Discovery. |
| `discovery` | `DISC######` | Exactly one explicit source; unique across the authoritative ADR catalog. |
| `status` | `accepted` | Initial ADR status remains accepted. |
| `supersedes` | scalar frontmatter value or `None` | Authoritative supersession metadata appears only in frontmatter. |
| `superseded_by` | scalar frontmatter value or `None` | Authoritative supersession metadata appears only in frontmatter. |

## Decision Confidence

- `Discovery Confidence`: Discovery value or scalar `None`.
- `Confidence Considerations`: Discovery considerations or scalar `None`.
- The section and both fields are mandatory even when evidence is unavailable.

## Alternatives Considered

- `option_id`: existing Discovery `OPTXXXXXX`.
- `outcome`: exactly one of `Selected`, `Rejected`, `Evaluated`.
- `meaning`: `Selected` is the sole chosen option; `Evaluated` is viable but not selected; `Rejected` is invalid or unsuitable.
- Cardinality: exactly one selected option; all remaining options are Rejected or Evaluated.

## Clarification Input State

- Contributing snapshot: ordered `CLAR-REQ######` or `CLAR-DISC######` evidence.
- No contributing evidence: the body contains `## Clarification Inputs` followed by exactly `None`.
- `CLAR-ADR######` is excluded from ADR generation.

## Comparison Matrix Projection

- Source: Discovery Comparison Matrix.
- Output: the same matrix content, with no recalculation, reordering, or interpretation.
- Test comparison: normalize LF line endings and canonical serialization before comparing fixture values.

## Recommendation Override

- Omitted when selected option equals Discovery recommendation.
- Immediately follows `## Decision` when selection diverges.
- Contains Discovery recommended option, selected option, and rationale.

## Catalog State Transition

`Next ID: ADRn` plus no matching Discovery -> one ADR `ADRn` and one direct index row -> `Next ID: ADR(n+1)`.

Duplicate Discovery, malformed allocation, conflict after three retries, or any validation failure leaves ADR files, catalog bytes, and source bytes unchanged.
