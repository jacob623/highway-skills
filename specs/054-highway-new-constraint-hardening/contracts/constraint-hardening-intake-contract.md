# Constraint Hardening Intake Contract

## Scope

This contract refines the existing `highway-new` Request intake. It does not add an evidence domain
or change Discovery and ADR ownership.

## Business Constraints Wording

When the requester has no applicable Business Constraints, the canonical prompt and examples use
`None known`. The phrase maps to the existing explicit empty Business Constraints state. It is not
persisted as a new literal value. `unknown` remains the separate answer for uncertainty.

## Solution Constraints Validation

The intake continues one natural-language question at a time in the existing order. For each field,
validation occurs before the value is accepted as evidence.

### Allowed Solution Classes

- Accept one or more non-empty user-provided values.
- Accept the literal state `unknown`.
- Reject an empty list, blank answer, malformed scalar, whitespace-only entry, or invalid empty
  entry.
- On rejection, identify `allowed_solution_classes` and request one or more values or `unknown`.
- Preserve multiple values without ranking, recommendation, or selection.

### Other List-Shaped Fields

For `existing_platforms_required`, `existing_platforms_preferred`, `known_systems`,
`hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and
`regulatory_restrictions`:

- Accept a populated list, an explicit empty list, or `unknown` according to the existing field
  contract.
- Reject malformed values and invalid empty entries.
- On rejection, identify the exact field and request valid values, an explicit empty list when no
  values apply, or `unknown` when the requester cannot determine the value.

## Recovery

A validation error names the affected field, explains the accepted shape, and asks for a replacement
or `unknown`. The existing bounded retry behavior applies. A valid replacement updates only the
failed field and continues at the next unanswered evidence question. An exhausted retry sequence
aborts the write and preserves existing Request and catalog bytes.

Privacy screening applies before a replacement is accepted. Sensitive or regulated personal data
receives the existing privacy recovery behavior and is not written.

## Boundary Rules

Request owns collection, validation, storage, privacy screening, and rendering. Discovery owns
candidate generation, classification, comparison, scoring, recommendation, and architecture
analysis. ADR owns solution and architecture decisions. This contract creates no Discovery or ADR
artifact.

## Acceptance Cases

- A single allowed class is accepted.
- Multiple allowed classes are retained without ranking.
- `unknown` is accepted for allowed classes.
- Empty and malformed allowed-class answers receive field-specific recovery guidance.
- `None known` is used for explicit Business Constraints absence while the existing record state is
  preserved.
- A malformed list field explains populated, empty-list, and unknown states.
- A malformed scalar field explains non-empty value or unknown states.
- Exhausted invalid or privacy-blocked input produces no partial Request or catalog write.
