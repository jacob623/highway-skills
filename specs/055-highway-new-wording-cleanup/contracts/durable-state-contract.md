# Durable State Contract

## Compatibility Boundary

Feature 055 changes requester-facing wording only. Existing Request records, catalog identifiers,
field names, field order, and durable empty-state representations remain unchanged.

## State Mapping

| Intake condition | Wording | Durable result |
|---|---|---|
| No Business Constraints apply | `No business constraints` | Existing explicit empty state |
| Constraint applicability is unknown | `unknown` | Existing `unknown` state |
| Solution field is incomplete or invalid | Field-specific error and replacement request | No write until complete |

## Non-Changes

- `allowed_solution_classes` remains one or more non-empty values or `unknown`.
- Other list-shaped fields retain populated list, explicit empty array, and `unknown` states.
- Valid replacement behavior, privacy screening, retry behavior, and no-partial-write guarantees remain unchanged.
- Discovery and ADR artifacts are neither created nor modified by this contract.
