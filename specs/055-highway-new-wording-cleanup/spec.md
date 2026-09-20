# Feature Specification: Highway New Wording Cleanup

**Feature Branch**: `055-highway-new-wording-cleanup`

**Created**: 2026-09-20

**Status**: Draft

**Input**: User description: "Create a new spec to address wording and representation corrections in highway-new: collapse duplicate allowed_solution_classes statements, clarify list-shaped field states, simplify Solution Constraints field-error wording, and replace None known with No business constraints."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Present precise Solution Constraints guidance (Priority: P1)

A requester using `highway-new` receives concise, consistent guidance for Solution Constraints and
Business Constraints, without contradictory statements or ambiguity about which fields may be empty.

**Why this priority**: Clear intake wording is the user-facing contract. Removing duplicated and
contradictory phrasing prevents requesters and maintainers from interpreting the same field differently.

**Independent Test**: Inspect the authoritative `highway-new` guidance and its focused assertions,
then verify each requested wording rule appears exactly once in the relevant behavior and the
existing durable states remain unchanged.

**Acceptance Scenarios**:

1. **Given** the `allowed_solution_classes` guidance is displayed, **when** it describes valid values,
   **then** it states once that the field accepts one or more non-empty values or `unknown`, preserves
   multiple entries without ranking, and rejects empty or malformed entries.
2. **Given** the remaining list-shaped Solution Constraints fields are described, **when** their
   permitted states are stated, **then** the guidance lists populated list, explicit empty array,
   and `unknown`, while explicitly excluding `allowed_solution_classes` from that empty-array rule.
3. **Given** a Solution Constraints field error is presented, **when** the requester reads it,
   **then** it identifies the field, states the accepted value shape, and requests a replacement or
   `unknown` without duplicated wording.
4. **Given** the requester has no applicable Business Constraints, **when** the absence phrase is
   presented, **then** the guidance uses `No business constraints` and preserves the existing durable
   empty-state representation.
5. **Given** a requester cannot determine whether a constraint applies, **when** the value is recorded,
   **then** it remains `unknown` and is not changed to either absence wording or an empty array.

### Edge Cases

- `allowed_solution_classes` must not inherit the explicit empty-array state allowed for other list-shaped fields.
- A field-error sentence must not repeat the field name or accepted-shape requirement in a second clause.
- Existing persisted empty-state data must remain compatible when the intake phrase changes.
- The wording correction must not add fields, change question order, or alter Discovery or ADR ownership.
- Existing generated adapters and shared output contracts must remain correspondent with the authoritative skill.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `allowed_solution_classes` guidance MUST contain one consolidated statement describing one or more non-empty values or `unknown`, preservation of multiple entries without ranking, and rejection of empty or malformed entries.
- **FR-002**: The guidance MUST NOT contain two separate statements that repeat the cardinality rule for `allowed_solution_classes`.
- **FR-003**: The guidance for list-shaped fields other than `allowed_solution_classes` MUST state that each may be recorded as a populated list, an explicit empty array, or `unknown`.
- **FR-004**: The guidance MUST explicitly identify `allowed_solution_classes` as the exception to the explicit empty-array state.
- **FR-005**: A Solution Constraints field-error rule MUST identify the field, state its accepted value shape, and request a replacement or `unknown` in one concise statement.
- **FR-006**: The guidance MUST use `No business constraints` for explicit Business Constraints absence.
- **FR-007**: The wording change MUST preserve the existing durable empty-state representation and the distinct `unknown` state.
- **FR-008**: Focused validation MUST detect duplicate or legacy wording and verify each corrected statement.
- **FR-009**: Generated catalog and agent adapters MUST remain correspondent with the authoritative source after the wording correction.
- **FR-010**: The change MUST NOT modify Solution Constraints fields, evidence order, Request allocation, privacy behavior, transaction semantics, Discovery behavior, or ADR behavior.

### Key Entities

- **Intake Guidance**: The requester-facing rules and error wording emitted by `highway-new`.
- **Solution Constraints State**: The valid populated, explicit empty, or `unknown` representation for each applicable field.
- **Business Constraints State**: The existing durable explicit-empty or `unknown` state described using the corrected absence phrase.
- **Generated Adapter**: A distributed copy of the authoritative skill whose wording must remain synchronized.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of focused assertions find exactly one consolidated `allowed_solution_classes` cardinality rule and no duplicate cardinality statement.
- **SC-002**: 100% of non-`allowed_solution_classes` list-field guidance names populated list, explicit empty array, and `unknown` as valid states.
- **SC-003**: 100% of Solution Constraints field-error guidance uses the concise field, shape, and replacement-or-`unknown` form without duplicated wording.
- **SC-004**: 100% of explicit Business Constraints absence guidance uses `No business constraints`, while existing persisted empty-state and `unknown` behavior remain unchanged.
- **SC-005**: 100% of generated catalog and adapter correspondence checks pass after regeneration.
- **SC-006**: Existing focused and repository validation suites report no new failures attributable to the wording correction.

## Assumptions

- Feature 054 remains the behavioral baseline; this feature corrects wording and representation guidance only.
- `allowed_solution_classes` continues to reject empty lists and malformed entries.
- Other list-shaped Solution Constraints fields continue to allow populated lists, explicit empty arrays, and `unknown`.
- `unknown` remains distinct from an explicit empty state and from incomplete input.
- The existing Request record representation is authoritative and is not renamed by this feature.
- Existing retry, privacy, no-partial-write, generated-artifact, Discovery, and ADR rules remain in force.

## Scope Boundaries

### Included in Version 1

- Consolidate the duplicate `allowed_solution_classes` guidance.
- Clarify the exception and permitted states for other list-shaped fields.
- Simplify the Solution Constraints field-error wording.
- Replace the requester-facing Business Constraints absence phrase with `No business constraints`.
- Add focused assertions and regenerate derived copies as needed.

### Excluded from Version 1

- Changing the durable Request record schema or persisted empty-state representation.
- Adding, removing, or renaming Solution Constraints fields.
- Changing evidence-domain order, retry counts, privacy handling, or transaction behavior.
- Changing Discovery candidate generation, comparison, scoring, recommendation, or architecture analysis.
- Creating or changing ADR decisions, selected solutions, rationale, consequences, or authorization.
