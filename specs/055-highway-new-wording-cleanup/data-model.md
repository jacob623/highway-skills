# Data Model: Highway New Wording Cleanup

## Intake Guidance

The authoritative `highway-new` skill contains requester-facing descriptions of Business and
Solution Constraints. This feature changes wording only; it does not add a field or evidence domain.

## Solution Constraints States

| Field grouping | Valid states | Invalid or excluded state |
|---|---|---|
| `allowed_solution_classes` | One or more non-empty values; `unknown` | Empty list, blank answer, malformed scalar, whitespace-only entry, empty entry |
| Other list-shaped fields | Populated list; explicit empty array; `unknown` | Malformed value or invalid empty entry |
| Scalar restrictions, where applicable | Non-empty value; `unknown` | Blank or malformed value |

The other list-shaped fields are `existing_platforms_required`, `existing_platforms_preferred`,
`known_systems`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and
`regulatory_restrictions`. `allowed_solution_classes` is explicitly excluded from the empty-array
state.

## Business Constraints States

| State | Intake wording | Durable behavior |
|---|---|---|
| Explicit absence | `No business constraints` | Existing explicit empty-state representation |
| Uncertainty | `unknown` | Existing `unknown` representation |
| Incomplete | No accepted value yet | No durable Request write |

The new phrase is intake guidance, not a new persisted literal.

## Field Error

A Solution Constraints field error identifies the field, states its accepted value shape, and
requests a replacement or `unknown`. It is transient intake guidance and is not stored as Request
evidence.

## Relationships and Invariants

- The wording correction changes no field order or field names.
- `allowed_solution_classes` remains non-empty-or-`unknown`.
- `unknown` remains distinct from explicit absence and from incomplete input.
- Existing Request identity, catalog allocation, privacy, retry, and no-partial-write behavior remain unchanged.
- Discovery and ADR remain outside this data model.
