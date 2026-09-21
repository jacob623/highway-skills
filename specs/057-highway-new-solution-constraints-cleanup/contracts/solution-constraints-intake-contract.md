# Solution Constraints Intake Contract

## Purpose

Define the repository-owned conversational contract for collecting the existing eight Solution
Constraints fields in `highway-new`.

## Ordered Questions

The skill asks one question per turn in the existing order:

1. `allowed_solution_classes`
2. `existing_platforms_required`
3. `existing_platforms_preferred`
4. `hosting_restrictions`
5. `vendor_restrictions`
6. `procurement_constraints`
7. `regulatory_restrictions`
8. `known_systems`

The cleanup does not add, remove, or reorder questions.

## Accepted Answers

- `allowed_solution_classes`: one or more non-empty values, or `unknown`; an empty list is rejected
  because it would leave the future Discovery candidate space indeterminate.
- `existing_platforms_required`, `existing_platforms_preferred`, and `known_systems`: one or more
  values, explicit `[]` when none apply, or `unknown` when the requester cannot determine the answer.
- `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and
  `regulatory_restrictions`: a non-empty scalar value or `unknown`; an empty array is rejected.

The skill preserves populated, empty, and unknown states according to these field-specific rules.
For Business Constraints, the no-constraint prompt uses `No business constraints`; the existing
explicit empty durable state is preserved, and uncertainty is recorded as `unknown`.

## Field Error Recovery

An invalid answer receives a focused correction request containing all of the following:

- the exact field name;
- the accepted value shape and permitted states;
- at least one valid example; and
- a request for a replacement value or `unknown`.

The requester corrects only the failed field. Earlier valid answers remain collected, the domain
does not restart, and the next question follows the existing order after correction. Privacy
screening remains in force: a sensitive or otherwise disallowed answer is not written.

## Ownership Boundary

This contract validates and records intake evidence only. It does not choose a solution, generate
Discovery candidates, rank or score candidates, perform architecture analysis, or create ADR
content.
