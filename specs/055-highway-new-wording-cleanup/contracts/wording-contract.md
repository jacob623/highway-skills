# Wording Contract

## Scope

This contract defines the requester-facing wording for the existing `highway-new` Business and
Solution Constraints guidance.

## Allowed Solution Classes

The field is described once as accepting one or more non-empty values or `unknown`. Multiple values
remain unranked. Empty lists, blank answers, malformed scalars, whitespace-only entries, and empty
entries remain invalid.

## Other List-Shaped Fields

Except for `allowed_solution_classes`, each list-shaped field may be recorded as:

- populated list
- explicit empty array
- `unknown`

## Field Errors

For a Solution Constraints field error, identify the field, state its accepted value shape, and
request a replacement or `unknown`.

## Business Constraints

Use `No business constraints` when the requester confirms that no Business Constraints apply. This
phrase represents the existing explicit empty state and does not replace `unknown`.

## Acceptance Checks

- The old duplicate `allowed_solution_classes` cardinality statement is absent.
- The old duplicate field-error sentence is absent.
- `No business constraints` is present for explicit absence.
- `None known` is not used as the canonical phrase in the corrected guidance.
- The exception for `allowed_solution_classes` is explicit.
