# Solution Constraints Verification Contract

## Verification Scope

Focused verification must confirm the corrected `highway-new` guidance and its workflow behavior
without treating static wording checks as proof of runtime behavior.

## Required Assertions

1. Exactly four list-shaped fields are named: `allowed_solution_classes`,
   `existing_platforms_required`, `existing_platforms_preferred`, and `known_systems`.
2. Exactly four scalar fields are named: `hosting_restrictions`, `vendor_restrictions`,
   `procurement_constraints`, and `regulatory_restrictions`.
3. `allowed_solution_classes` accepts one or more non-empty values or `unknown`, and rejects an
   empty list, blank value, scalar, empty entry, or whitespace-only entry.
4. The three other list fields preserve populated list, explicit `[]`, and `unknown` as distinct
   states.
5. Each scalar field accepts a non-empty value or `unknown`, and rejects an empty array or blank.
6. A field error names the field, accepted shape, valid example, and replacement-or-`unknown`
   action; valid correction changes only that field and does not restart collection.
7. Business Constraints uses `No business constraints` for confirmed absence while preserving the
   existing explicit empty durable state and `unknown` for uncertainty.
8. Discovery receives one or more allowed solution classes or `unknown`, never an empty list.
9. Privacy, retry, transaction, write-safety, question-order, and request-record checks remain
   covered.
10. Focused assertions reject the legacy generic list wording, legacy Business Constraints wording,
    and legacy field-error contract, while accepting each corrected contract exactly once.

## Artifact and Boundary Checks

- Run the focused `highway-new` test and the repository's validators.
- Regenerate and compare catalog, adapter, and correspondence artifacts when the source skill changes.
- Run the appropriate full suite before completion.
- Do not add or alter Discovery candidate generation, filtering, comparison, scoring, recommendation,
  architecture analysis, or ADR decisions.
- Do not add fields, reorder questions, change durable Request schema, or introduce a new runtime
  dependency.

## Evidence Interpretation

Static assertions establish wording and contract presence. Executed focused scenarios establish
field validation, local correction, privacy handling, and candidate-space forwarding behavior.
Requirement coverage and command results must be reported separately at completion.
