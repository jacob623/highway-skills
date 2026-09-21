# Feature Specification: Highway New Solution Constraints Cleanup

**Feature Branch**: `057-highway-new-solution-constraints-cleanup`

**Created**: 2026-09-20

**Status**: Draft

**Input**: User description: "Create a new spec 057 with the following changes to `highway-new`: explicitly define list-shaped and scalar Solution Constraints fields; document why `allowed_solution_classes` cannot be empty; clarify list, scalar, and Business Constraints states; improve field-error recovery; align verification with workflow; and verify the candidate-space requirement."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Understand Solution Constraints field shapes (Priority: P1)

A requester or workflow maintainer can distinguish which Solution Constraints fields accept lists
from those that accept scalar restriction values, and can provide valid evidence without guessing
how an empty or unknown response is represented.

**Why this priority**: Field shape is the foundation of valid intake. Without it, the same answer
can be interpreted inconsistently or persisted in the wrong form.

**Independent Test**: Review the `highway-new` Solution Constraints guidance and confirm that all
four list-shaped fields and all four scalar fields are explicitly named with their permitted states.

**Acceptance Scenarios**:

1. **Given** the Solution Constraints collection begins, **when** field shapes are explained, **then** `allowed_solution_classes`, `existing_platforms_required`, `existing_platforms_preferred`, and `known_systems` are identified as list-shaped.
2. **Given** the Solution Constraints collection begins, **when** field shapes are explained, **then** `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and `regulatory_restrictions` are identified as scalar fields.
3. **Given** a list-shaped field other than `allowed_solution_classes`, **when** no values apply or the requester is uncertain, **then** the field can be recorded as an explicit empty array or `unknown`, respectively.
4. **Given** a scalar restriction field, **when** the requester answers, **then** the field contains a non-empty value or `unknown`, never an empty array.

### User Story 2 - Preserve a determinate Discovery candidate space (Priority: P1)

A requester can provide the allowable solution classes for future Discovery analysis, or explicitly
state that the allowable classes are unknown, while the intake prevents an empty list from making
the permitted solution domain indeterminate.

**Why this priority**: `allowed_solution_classes` defines the candidate space that future Discovery
may analyze. It is not an optional preference list and cannot be safely represented by an empty list.

**Independent Test**: Verify that the guidance rejects an empty `allowed_solution_classes` list,
accepts one or more values or `unknown`, and states that Discovery receives one of those two valid
forms.

**Acceptance Scenarios**:

1. **Given** the requester knows permitted solution classes, **when** they answer, **then** one or more non-empty values are recorded without ranking them.
2. **Given** the requester cannot determine permitted solution classes, **when** they answer, **then** `unknown` is recorded.
3. **Given** the requester provides an empty list for `allowed_solution_classes`, **when** the value is validated, **then** it is rejected because the allowable candidate space would be indeterminate.
4. **Given** a complete request reaches future Discovery analysis, **when** candidate-space evidence is consumed, **then** Discovery receives one or more allowed solution classes or `unknown`, never an empty list.

### User Story 3 - Recover from a field error without restarting intake (Priority: P1)

A requester who provides an invalid Solution Constraints value receives an actionable correction
request and can correct only that field while the remaining collection flow continues.

**Why this priority**: Local recovery prevents a single malformed answer from causing data loss,
confusing repetition, or an unnecessary restart of the Solution Constraints domain.

**Independent Test**: Seed invalid list, scalar, and empty candidate-space values and verify each
error identifies the field, accepted shape, valid example, and replacement action, then resumes at
the failed field only.

**Acceptance Scenarios**:

1. **Given** an invalid Solution Constraints value, **when** the error is reported, **then** it identifies the exact field, states the accepted value shape, provides at least one valid example, and requests a replacement value or `unknown`.
2. **Given** a valid replacement is supplied, **when** recovery completes, **then** only the failed field is updated and Solution Constraints collection does not restart.
3. **Given** a replacement answer contains sensitive or otherwise disallowed information, **when** privacy screening applies, **then** existing privacy handling remains in force and the invalid answer is not written.

### Edge Cases

- `allowed_solution_classes` is an empty array: reject it and explain that it defines the future Discovery candidate space.
- `allowed_solution_classes` is blank, scalar, contains an empty entry, or contains only whitespace: reject it and request one or more non-empty values or `unknown`.
- A non-candidate list field is explicitly empty: preserve `[]` as distinct from `unknown`.
- A scalar restriction is blank or supplied as an array: reject it and request a non-empty value or `unknown`.
- Business Constraints has no applicable constraints: record `No business constraints` as the intake wording and preserve the existing explicit empty state.
- The requester is uncertain: preserve `unknown` rather than converting it to an empty array or an absence phrase.
- A field error occurs after earlier fields were collected: retain valid earlier answers and continue with the failed field only.
- The wording change must not add fields, reorder the eight Solution Constraints questions, or change Discovery and ADR ownership.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `highway-new` guidance MUST explicitly identify `allowed_solution_classes`, `existing_platforms_required`, `existing_platforms_preferred`, and `known_systems` as list-shaped Solution Constraints fields.
- **FR-002**: The `highway-new` guidance MUST explicitly identify `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and `regulatory_restrictions` as scalar Solution Constraints fields.
- **FR-003**: The guidance for list-shaped fields other than `allowed_solution_classes` MUST state that each accepts one or more values, an explicit empty array, or `unknown`, and that these states have distinct meanings that must be preserved.
- **FR-004**: The guidance MUST state that `allowed_solution_classes` cannot be empty because it defines the allowable candidate space for future Discovery analysis and an empty value would make the permitted solution domain indeterminate.
- **FR-005**: The guidance MUST state that `allowed_solution_classes` accepts one or more non-empty values when known or `unknown` when the requester cannot determine the allowable solution classes, and MUST reject an empty list.
- **FR-006**: The guidance for scalar restriction fields MUST state that each accepts either a non-empty value or `unknown`, and MUST reject an empty array or blank value.
- **FR-007**: Business Constraints guidance MUST state `No business constraints` when the requester confirms that none apply, and `unknown` when the requester cannot determine whether constraints exist.
- **FR-008**: A Solution Constraints field-error rule MUST identify the exact field, state the accepted value shape, provide at least one valid example, and request a replacement value or `unknown`.
- **FR-009**: A valid field replacement MUST update only the failed field and MUST continue Solution Constraints collection without restarting the domain.
- **FR-010**: Verification MUST confirm `allowed_solution_classes` contains one or more non-empty values or `unknown`, never an empty list.
- **FR-011**: Verification MUST confirm the three other list-shaped platform/system fields support one or more values, an explicit empty array, or `unknown`, with empty arrays distinct from `unknown`.
- **FR-012**: Verification MUST confirm all four scalar restriction fields contain either a non-empty value or `unknown`.
- **FR-013**: Verification MUST confirm `allowed_solution_classes` cannot be persisted as an empty list and that Discovery receives one or more allowed solution classes or `unknown`.
- **FR-014**: The change MUST preserve existing question order, request-record structure, privacy screening, retry and write-safety behavior, and the distinction between empty arrays and `unknown`.
- **FR-015**: The change MUST NOT implement or alter Discovery candidate generation, classification, comparison, scoring, recommendation, or architecture analysis.
- **FR-016**: The change MUST NOT create or alter ADR decisions, solution selection, architecture selection, rationale, consequences, or authorization.
- **FR-017**: Focused validation MUST detect the legacy generic list wording, the legacy Business Constraints wording, and the legacy field-error contract after the corrected guidance is introduced.

### Key Entities

- **Solution Constraints**: The ordered evidence domain containing allowable solution classes, existing platform context, known systems, and scalar restrictions.
- **List-Shaped Solution Constraints Field**: A field that preserves one or more values, an explicit empty array where permitted, or `unknown`; `allowed_solution_classes` is the non-empty exception.
- **Scalar Restriction Field**: A hosting, vendor, procurement, or regulatory restriction represented by a non-empty value or `unknown`.
- **Allowed Solution Classes**: A user-owned extensible list defining the allowable candidate space for future Discovery analysis without ranking or selecting a candidate.
- **Discovery Candidate Space**: The future analysis input that receives one or more allowed solution classes or `unknown`, never an empty list.
- **Field Correction**: A replacement answer for one invalid Solution Constraints field that preserves valid prior answers and continues collection.
- **Business Constraints State**: The explicit no-constraint wording or the distinct `unknown` state used by existing intake behavior.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the eight Solution Constraints fields are documented under exactly one field-shape category: four list-shaped fields and four scalar fields.
- **SC-002**: 100% of validation cases accept one or more non-empty `allowed_solution_classes` values or `unknown`, and 0% persist an empty list for that field.
- **SC-003**: 100% of other list-shaped field cases preserve the three distinct states: populated list, explicit empty array, and `unknown`.
- **SC-004**: 100% of scalar restriction cases preserve either a non-empty value or `unknown`, with no scalar restriction persisted as an empty array.
- **SC-005**: 100% of invalid field-error responses identify the exact field, accepted shape, at least one valid example, and the replacement-or-`unknown` action; valid correction updates only the failed field in all tested cases.
- **SC-006**: 100% of verification cases confirm Discovery receives one or more allowed solution classes or `unknown`, and no empty candidate space is persisted or forwarded.
- **SC-007**: 100% of existing request-intake, privacy, ordering, retry, transaction, and write-safety checks continue to pass with no new failures attributable to this cleanup.
- **SC-008**: 100% of focused assertions reject the legacy generic list, Business Constraints, and field-error wording while accepting the corrected wording exactly once.

## Assumptions

- Spec 053 remains the behavioral baseline for the eight Solution Constraints fields and their question order.
- This feature changes authoritative guidance and its verification contract; it does not add or remove fields.
- `unknown` remains a valid non-blocking state for every Solution Constraints field, including `allowed_solution_classes`.
- Empty arrays remain valid only for `existing_platforms_required`, `existing_platforms_preferred`, and `known_systems`.
- Business Constraints' existing explicit empty representation remains unchanged; only the requester-facing wording is clarified.
- Discovery and ADR remain downstream owners of candidate analysis and decisions, respectively.
- Existing privacy screening, retry limits, byte-preservation, and no-partial-write behavior remain authoritative.
- No extension hooks are registered in `.specify/extensions.yml` for this invocation.

## Scope Boundaries

### Included in Version 1

- Explicit list-shaped and scalar field classification in `highway-new`.
- Rationale and validation for the non-empty `allowed_solution_classes` candidate-space requirement.
- Deterministic list, scalar, Business Constraints, and field-error wording.
- Verification for valid states, invalid states, local field correction, and Discovery handoff shape.
- Focused assertions against legacy wording and corrected wording.

### Excluded from Version 1

- Adding, removing, renaming, or reordering Solution Constraints fields or questions.
- Changing the durable Request record schema or the existing Business Constraints empty-state representation.
- Implementing Discovery candidate generation, filtering, scoring, recommendation, or architecture analysis.
- Creating or changing ADR artifacts, selections, rationale, consequences, or authorization.
- Changing privacy, retry, transaction, catalog allocation, or write-safety behavior.
