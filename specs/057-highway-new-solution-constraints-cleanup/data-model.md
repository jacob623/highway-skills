# Data Model: Solution Constraints

## Entity

**Solution Constraints** is an ordered evidence domain in the Request record. It contains exactly
eight fields in the existing Spec 053 order. This feature changes field-shape guidance and
validation semantics, not the durable field set or order.

## Fields

| Order | Field | Shape | Valid states | Invalid states |
|---:|---|---|---|---|
| 1 | `allowed_solution_classes` | Non-empty list exception | One or more non-empty values; `unknown` | Empty list, blank value, scalar, empty entry, whitespace-only entry |
| 2 | `existing_platforms_required` | List | One or more values; `[]`; `unknown` | Scalar, malformed list, blank entry |
| 3 | `existing_platforms_preferred` | List | One or more values; `[]`; `unknown` | Scalar, malformed list, blank entry |
| 4 | `hosting_restrictions` | Scalar | Non-empty value; `unknown` | Empty array, blank value, malformed list |
| 5 | `vendor_restrictions` | Scalar | Non-empty value; `unknown` | Empty array, blank value, malformed list |
| 6 | `procurement_constraints` | Scalar | Non-empty value; `unknown` | Empty array, blank value, malformed list |
| 7 | `regulatory_restrictions` | Scalar | Non-empty value; `unknown` | Empty array, blank value, malformed list |
| 8 | `known_systems` | List | One or more values; `[]`; `unknown` | Scalar, malformed list, blank entry |

The order is descriptive of the existing intake contract and is not changed by this feature.

## State Semantics

- A populated list means the requester supplied one or more applicable values.
- `[]` means the requester knows that no values apply; it is valid only for the three non-candidate
  list fields.
- `unknown` means the requester cannot determine the answer. It is explicit and must not be
  silently converted to `[]`, a blank, or an absence phrase.
- A scalar value must be non-empty after trimming and must express the restriction as one value;
  scalar fields never use an empty array.
- Business Constraints wording is separate from this entity: `No business constraints` is the
  requester-facing confirmation phrase, while the existing durable empty state remains unchanged.

## Candidate-Space Invariant

`allowed_solution_classes` defines the allowable candidate space for future Discovery analysis.
Therefore it MUST be either:

1. a list containing one or more non-empty values, without ranking or selecting them; or
2. `unknown`.

An empty list is never a valid persisted or forwarded state for this field. Discovery may receive
one of the two valid forms, but this feature does not generate, filter, score, compare, recommend,
or analyze candidates.

## Correction Transition

When a field value fails validation:

1. Identify the exact field.
2. State the accepted shape and state options.
3. Show at least one valid example.
4. Request a replacement value or `unknown`.
5. Replace only the failed field after a valid response.
6. Retain all earlier valid fields and continue without restarting Solution Constraints collection.

Privacy screening occurs before any replacement is written. Disallowed or sensitive input is not
written, and existing retry and write-safety behavior remains in force.
