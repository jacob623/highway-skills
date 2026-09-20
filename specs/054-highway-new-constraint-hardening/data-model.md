# Data Model: Highway New Constraint Hardening

## Business Constraints State

The existing Business Constraints evidence domain remains durable and backward-compatible.

| State | Meaning | Intake wording | Persisted representation |
|---|---|---|---|
| Populated | One or more known business constraints | Requester supplies the constraints | Existing populated representation |
| Explicitly empty | The requester knows no constraints apply | `None known` | Existing empty-state representation |
| Unknown | The requester cannot determine whether constraints apply | `unknown` | Existing `unknown` representation |
| Incomplete | No usable answer has been supplied | Follow-up question | Not eligible for write |

`None known` is canonical user-facing wording, not a new durable value.

## Solution Constraints Field States

The existing eight fields retain their names and ownership. This feature tightens validation and
recovery semantics only.

| Field | Shape | Valid states | Invalid states | Recovery |
|---|---|---|---|---|
| `allowed_solution_classes` | list or `unknown` | One or more non-empty values, or `unknown` | Empty list, blank answer, malformed scalar, empty entry | Name the field and request one or more values or `unknown` |
| `existing_platforms_required` | list or `unknown` | Populated list, empty list, or `unknown` | Malformed value or invalid empty entry | Name the field and request valid values, an explicit empty list, or `unknown` |
| `existing_platforms_preferred` | list or `unknown` | Populated list, empty list, or `unknown` | Malformed value or invalid empty entry | Name the field and request valid values, an explicit empty list, or `unknown` |
| `known_systems` | list or `unknown` | Populated list, empty list, or `unknown` | Malformed value or invalid empty entry | Name the field and request valid values, an explicit empty list, or `unknown` |
| `hosting_restrictions` | list or `unknown` | Populated list, empty list, or `unknown` | Malformed value or invalid empty entry | Name the field and request valid values, an explicit empty list, or `unknown` |
| `vendor_restrictions` | list or `unknown` | Populated list, empty list, or `unknown` | Malformed value or invalid empty entry | Name the field and request valid values, an explicit empty list, or `unknown` |
| `procurement_constraints` | list or `unknown` | Populated list, empty list, or `unknown` | Malformed value or invalid empty entry | Name the field and request valid values, an explicit empty list, or `unknown` |
| `regulatory_restrictions` | list or `unknown` | Populated list, empty list, or `unknown` | Malformed value or invalid empty entry | Name the field and request valid values, an explicit empty list, or `unknown` |

## Error Recovery Entity

A `Solution Constraints field error` is transient intake guidance, not stored Request evidence. It
names the affected field, explains the accepted shape, and requests a replacement or `unknown`.

| Attribute | Meaning |
|---|---|
| Field name | Exact Solution Constraints field requiring correction |
| Failure reason | Shape or state violation, without rewriting the supplied value |
| Accepted shape | The valid state set for that field |
| Recovery instruction | Request for a replacement value or `unknown` |
| Retry state | At most 3 retries for invalid Solution Constraints input and the next-question position |

## Invariants

- `allowed_solution_classes` never serializes as an empty list.
- `unknown` remains distinct from an explicit empty list.
- `None known` remains distinct from `unknown` and incomplete input.
- Invalid input is never persisted as Request evidence.
- A valid replacement changes only the failed field and resumes the existing evidence order.
- Exhausted retries preserve existing Request and catalog bytes.
- Privacy-blocked replacement input is not persisted.
- No Solution Constraints field creates a Discovery recommendation or ADR decision.
