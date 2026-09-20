# Constraint Hardening Record Contract

## Durable Representation

The Request record keeps the existing seven evidence domains, field names, section order, and
persisted value representations. This feature changes validation and intake guidance only.

Business Constraints remains before Solution Constraints. The canonical absence phrase `None known`
is an intake wording rule; the record uses the existing explicit empty-state representation.

## Solution Constraints Fields

The existing fields remain:

1. `allowed_solution_classes`
2. `existing_platforms_required`
3. `existing_platforms_preferred`
4. `known_systems`
5. `hosting_restrictions`
6. `vendor_restrictions`
7. `procurement_constraints`
8. `regulatory_restrictions`

`allowed_solution_classes` is valid only when it contains one or more non-empty values or is
`unknown`. It MUST NOT be rendered as an empty list.

The other list-shaped fields retain their existing valid states: populated list, explicit empty
list, or `unknown`. Unknown and empty-list states remain distinct.

## Transaction Rules

- Invalid Solution Constraints input is not included in a Request record.
- A valid replacement is rendered only after all existing validation and privacy checks pass.
- Exhausted retries preserve all pre-existing Request and catalog bytes.
- Existing Request identity, catalog allocation, status, completeness, and section ordering remain
  unchanged except for the tightened validity rule on `allowed_solution_classes`.

## Non-Ownership Rules

The record contains evidence only. It does not contain a Discovery recommendation, candidate score,
architecture selection, ADR decision, rationale, consequence, or implementation authorization.
