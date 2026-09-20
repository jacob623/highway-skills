# Research: Highway New Wording Cleanup

## Decision 1: Consolidate the allowed-class rule

**Decision**: Keep one authoritative statement for `allowed_solution_classes`: one or more
non-empty values or `unknown`; preserve multiple entries without ranking; reject empty or malformed
entries.

**Rationale**: The duplicate statement in Feature 054 repeats the cardinality rule and creates two
possible maintenance points. One statement is sufficient and directly matches the acceptance case.

**Alternatives considered**:
- Keep both statements and mark one as explanatory: rejected because repetition can drift.
- Move the rule into a separate glossary: rejected because the requester-facing field list should
  contain the rule where the field is introduced.

## Decision 2: Separate the list-field exception

**Decision**: State that every list-shaped Solution Constraints field except
`allowed_solution_classes` may be recorded as a populated list, explicit empty array, or `unknown`.

**Rationale**: `allowed_solution_classes` cannot be empty, while the other fields retain the
existing explicit-empty state. Naming the exception prevents accidental application of the broader
list rule.

**Alternatives considered**:
- Repeat the three states under every field: rejected because it increases duplication.
- Describe only the exception and omit the common rule: rejected because the valid states for the
  other fields would remain implicit.

## Decision 3: Use one concise field-error rule

**Decision**: Use one sentence that identifies the field, states its accepted value shape, and
requests a replacement or `unknown`.

**Rationale**: The prior wording repeats the same obligation in adjacent sentences. A single rule
preserves the contract while removing ambiguity and unnecessary prose.

**Alternatives considered**:
- Keep a general sentence plus a repeated mandatory-message sentence: rejected because it is the
  defect being corrected.
- Remove accepted-shape guidance: rejected because recovery must remain actionable.

## Decision 4: Change only the intake absence phrase

**Decision**: Use `No business constraints` for explicit Business Constraints absence while keeping
the existing durable empty-state representation and the distinct `unknown` state.

**Rationale**: The requested phrase is clearer for intake and does not require a record-schema
change.

**Alternatives considered**:
- Persist the new phrase as a new durable value: rejected because it would break the existing state
  boundary.
- Treat the phrase as `unknown`: rejected because explicit absence and uncertainty are distinct.

## Validation Strategy

Use static focused assertions for exact wording and duplicate detection, the existing skill and
library validators for structure, and generated correspondence/distribution checks after
regeneration. Run the full suite to detect unrelated regressions.
