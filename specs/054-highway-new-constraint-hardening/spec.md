# Feature Specification: Highway New Constraint Hardening

**Feature Branch**: `054-highway-new-constraint-hardening`

**Created**: 2026-09-20

**Status**: Draft

**Input**: User description: "Restrict allowed_solution_classes to one-or-more values or unknown, standardize Business Constraints 'none' wording, and add Solution Constraints-specific error handling to the highway-new skill."

## Clarifications

### Session 2026-09-20

- Q: Should `None known` be the canonical user-facing phrase only, with the existing empty-state representation preserved in the Request record, or should the exact text `None known` also be persisted in the record? → A: `None known` is the canonical intake phrase; the existing empty-state representation remains unchanged in the Request record.

## User Scenarios & Testing

### User Story 1 - Validate allowed solution classes (Priority: P1)

A requester completing a Request can provide one or more allowed solution classes, or explicitly
state that the value is unknown, while the intake rejects an empty or malformed class list without
silently changing the evidence.

**Why this priority**: `allowed_solution_classes` is a core Solution Constraints field. Its cardinality
must be unambiguous so downstream consumers never receive an empty list presented as a permitted
solution set.

**Independent Test**: Submit single-value, multi-value, `unknown`, empty, and malformed
`allowed_solution_classes` answers and verify valid answers are preserved while invalid answers
request a replacement or `unknown`.

**Acceptance Scenarios**:

1. **Given** a requester names one allowed solution class, **when** the answer is recorded, **then** `allowed_solution_classes` contains exactly that value.
2. **Given** a requester names multiple allowed solution classes, **when** the answer is recorded, **then** all values are retained without ranking.
3. **Given** a requester cannot determine the allowed solution classes, **when** the answer is recorded, **then** the field is recorded as `unknown`.
4. **Given** a requester provides an empty list, blank answer, or malformed scalar for allowed solution classes, **when** validation runs, **then** the intake does not accept it as a valid list and asks for one or more values or `unknown`.

### User Story 2 - Use consistent absence wording in Business Constraints (Priority: P1)

A requester sees one consistent, neutral phrase for stating that no Business Constraints apply, and
the resulting evidence has the existing empty-state meaning rather than being interpreted as an
unknown or preference.

**Why this priority**: Consistent wording prevents equivalent answers from producing different
record states and makes the boundary between no known constraint and unknown information explicit.

**Independent Test**: Review the Business Constraints prompt, examples, and validation assertions,
then submit the standardized phrase and verify it produces the established empty constraint state.

**Acceptance Scenarios**:

1. **Given** the Business Constraints question is presented, **when** the requester has no applicable constraints, **then** the workflow uses the standardized `None known` wording.
2. **Given** the requester responds with the standardized wording, **when** the answer is normalized, **then** Business Constraints records the existing explicit empty state.
3. **Given** the requester says they do not know whether constraints apply, **when** the answer is recorded, **then** it remains distinct from `None known` and uses `unknown`.
4. **Given** legacy or ambiguous “none” wording appears in an example or error message, **when** the specification is applied, **then** it is replaced with the standardized neutral wording.

### User Story 3 - Recover from Solution Constraints errors (Priority: P1)

A requester who supplies an invalid Solution Constraints value receives a field-specific, actionable
error and can replace that value or use `unknown`, without creating a partial Request or changing
other evidence already collected.

**Why this priority**: Field-specific recovery keeps intake deterministic and protects the no-partial-
write guarantee while making malformed constraint answers repairable.

**Independent Test**: Submit invalid values for each Solution Constraints field and verify the workflow
identifies the field, states the accepted value shape, requests a replacement or `unknown`, and
preserves the existing transaction behavior.

**Acceptance Scenarios**:

1. **Given** a list-shaped Solution Constraints field receives a scalar or malformed value, **when** validation fails, **then** the error names the field and requests an empty list, valid values, or `unknown` according to that field’s contract.
2. **Given** `allowed_solution_classes` receives an empty list, **when** validation fails, **then** the error specifically requires one or more values or `unknown`.
3. **Given** a scalar restriction receives an invalid blank value, **when** validation fails, **then** the error requests a non-empty value or `unknown` without converting the blank to an empty list.
4. **Given** a Solution Constraints value remains invalid after the permitted retry limit, **when** intake terminates, **then** no Request or catalog bytes are written and previously existing bytes remain unchanged.
5. **Given** a valid replacement is supplied, **when** validation succeeds, **then** intake continues with the next evidence question and preserves the corrected value only.

### Edge Cases

- `allowed_solution_classes` contains whitespace-only entries, duplicate entries, or a mixture of valid and invalid entries; validation applies the existing normalization rules and rejects entries that do not represent values.
- A requester says “none” for `allowed_solution_classes`; the workflow must not treat that as one allowed class and must request one or more classes or `unknown`.
- `None known` for Business Constraints is distinct from `unknown` and from an omitted answer.
- An invalid Solution Constraints answer must not erase valid values already collected in other fields or domains.
- A requester supplies sensitive or regulated personal data while correcting a field; existing privacy handling still requests replacement and prevents the sensitive value from being written.
- A malformed value in one Solution Constraints field must not cause another field to be inferred, defaulted, or rewritten.
- Discovery recommendation, candidate, architecture, and ADR behavior remains unchanged.

## Requirements

### Functional Requirements

- **FR-001**: The `allowed_solution_classes` field MUST accept either a list containing one or more non-empty values or the literal state `unknown`.
- **FR-002**: The `allowed_solution_classes` field MUST reject an empty list, blank answer, malformed scalar, and list containing invalid empty entries.
- **FR-003**: Valid multiple allowed solution classes MUST be preserved without ranking or recommendation.
- **FR-004**: The Business Constraints intake wording MUST use `None known` as the standardized phrase for an explicitly empty constraint state, while preserving the existing persisted empty-state representation.
- **FR-005**: Business Constraints MUST preserve the distinction between `None known`, `unknown`, and an incomplete or omitted answer.
- **FR-006**: Solution Constraints validation errors MUST identify the affected field and state the accepted value shape.
- **FR-007**: For `allowed_solution_classes` errors, the recovery message MUST request one or more values or `unknown`.
- **FR-008**: For other list-shaped Solution Constraints fields, recovery MUST distinguish valid populated lists, explicit empty lists, and `unknown`.
- **FR-009**: For scalar Solution Constraints fields, recovery MUST request a non-empty value or `unknown` and MUST NOT coerce invalid blanks into empty lists.
- **FR-010**: A failed Solution Constraints validation MUST preserve the existing no-partial-write and byte-preservation behavior.
- **FR-011**: After a valid replacement, intake MUST continue in the existing evidence order without repeating already valid fields unnecessarily.
- **FR-012**: Privacy handling MUST apply to Solution Constraints recovery input, including replacement answers.
- **FR-013**: Focused validation MUST cover valid, empty, unknown, malformed, retry, privacy, and no-write cases for the changed behavior.
- **FR-014**: The change MUST NOT modify Discovery candidate generation, classification, comparison, scoring, recommendation, or architecture analysis.
- **FR-015**: The change MUST NOT create or modify ADR decisions, selected solutions, architecture decisions, rationale, consequences, or authorization.
- **FR-016**: Existing Request identity, catalog allocation, transaction, and unrelated evidence-domain behavior MUST remain unchanged.

### Key Entities

- **Allowed Solution Classes**: A non-empty user-owned list of permitted solution classes or the explicit `unknown` state.
- **Business Constraints State**: The explicit `None known`, `unknown`, populated, or incomplete state for Business Constraints.
- **Solution Constraints Field Error**: A field-specific validation response describing the accepted value shape and recovery action.
- **Request Record**: The durable record that must not be written from an invalid or privacy-blocked intake.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of valid single-value, multi-value, and `unknown` allowed-solution-class cases are accepted, while 100% of empty and malformed cases are rejected with recovery guidance.
- **SC-002**: 100% of Business Constraints prompts and examples use the standardized `None known` wording for explicit absence.
- **SC-003**: 100% of invalid Solution Constraints cases identify the affected field and accepted replacement shape.
- **SC-004**: 100% of exhausted invalid-input and privacy-blocked cases preserve existing Request and catalog bytes.
- **SC-005**: 100% of valid replacements continue intake without changing already valid evidence or creating Discovery or ADR artifacts.
- **SC-006**: Existing focused Request, privacy, transaction, catalog, and distribution validations continue to pass without unrelated behavior changes.

## Assumptions

- Feature 053 remains the authoritative definition of the seven evidence domains and eight Solution Constraints fields.
- `unknown` is a literal valid state and is distinct from an explicit empty list.
- `None known` is the repository-wide intake wording for an explicitly empty Business Constraints state; the Request record continues to use the existing persisted empty-state representation.
- The existing retry limit and no-partial-write transaction rules remain authoritative unless a later plan changes them.
- Solution Constraints-specific errors are user-facing intake guidance, not Discovery or ADR decisions.
- Existing privacy screening and generated-artifact correspondence checks remain in scope.

## Scope Boundaries

### Included in Version 1

- Tighten `allowed_solution_classes` cardinality and malformed-value handling.
- Standardize Business Constraints absence wording across intake guidance, examples, and focused validation.
- Add field-specific Solution Constraints error and recovery behavior.
- Add focused contract and regression validation for the three changes.

### Excluded from Version 1

- Adding or renaming Solution Constraints fields.
- Changing Discovery candidate generation, recommendation, architecture analysis, or scoring.
- Creating or changing ADR decisions or selected solutions.
- Changing Request catalog allocation, identifier rules, privacy policy, or transaction semantics beyond validating their preservation.
- Redesigning the broader intake question order or adding new evidence domains.
