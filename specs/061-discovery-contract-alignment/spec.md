# Feature Specification: Discovery Contract Alignment

**Feature Branch**: `061-discovery-contract-alignment`

**Created**: 2026-09-21

**Status**: Draft

**Input**: User description: "Create a new spec for synchronizing highway-discovery section names and verification ordering, making constraint compliance and alignment deterministic, clarifying required-platform traceability, and documenting candidate-elimination ordering."

## Clarifications

### Session 2026-09-21

- Q: Should Feature 061 add or update executable validators and tests for the synchronized section order, compliance vocabulary, alignment range, traceability wording, and elimination ordering? -> A: Add or update focused executable checks for every deterministic contract rule. The checks are developer-facing validation tools; the highway-discovery skill remains non-executable and advisory.
- Q: Should the focused contract checks use disposable fixtures to prove both valid and invalid Discovery documents? -> A: Add disposable valid and invalid fixtures for each deterministic contract rule. The fixtures are developer-facing test inputs and do not change canonical artifacts or normal Discovery execution.
- Q: Should the invalid fixtures cover each deterministic rule independently, or may one fixture combine multiple violations? -> A: Use one independently failing fixture per deterministic rule; combined regression fixtures are optional. Independent failures keep validator diagnostics attributable to a single contract rule.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Synchronize Discovery section contracts (Priority: P1)

A maintainer can read the Discovery skill and output template and find the same section names and
section order, including Request Reference, Request Solution Constraints, and Candidate Elimination
Log.

**Why this priority**: Mismatched section names and incomplete verification order can cause valid
Discovery records to fail contract checks or be interpreted inconsistently by downstream workflows.

**Independent Test**: Compare the section list declared by the Discovery skill, its Verification
section, and the shared Discovery record template; verify identical names and order.

**Acceptance Scenarios**:

1. **Given** the Discovery output contract declares Request Reference, **when** the shared record template is reviewed, **then** its corresponding heading is `## Request Reference` and its Request contents remain unchanged.
2. **Given** the Discovery record contains constraint sections, **when** the skill Verification ordering is reviewed, **then** Request Solution Constraints and Candidate Elimination Log appear between Unknowns and Candidate Solution Options.
3. **Given** the aligned artifacts are validated, **when** section-order checks run, **then** they accept the synchronized order and reject the former `## Request` heading.

### User Story 2 - Produce deterministic constraint output (Priority: P1)

A reviewer can rely on every retained Discovery candidate using one compliance value and one
explicit alignment representation, so identical inputs cannot produce synonymous but different
outputs.

**Why this priority**: Deterministic vocabulary and value shapes are necessary for repeatable
comparison, validation, and downstream interpretation.

**Independent Test**: Inspect the skill and template contracts and run repeated contract checks;
verify that retained candidates always use `Fully Compliant` and alignment values use one declared
0-100 representation.

**Acceptance Scenarios**:

1. **Given** a retained candidate satisfies all mandatory constraints, **when** its record is rendered, **then** Constraint Compliance is exactly `Fully Compliant` in the candidate section and comparison matrix.
2. **Given** an alignment value is rendered, **when** the record is validated, **then** Desired Change, Objective, and Constraints use the declared `<0-100>` representation.
3. **Given** an alignment value is rendered, **when** the value is validated, **then** values below 0, above 100, or non-integer values are rejected.
4. **Given** identical closed Discovery inputs are processed repeatedly, **when** compliance and alignment fields are compared, **then** their values and ordering are identical.

### User Story 3 - Explain required-platform traceability and elimination ordering (Priority: P1)

A maintainer can understand why retained candidates report Required Platform Match as 100 and how
excluded candidates are ordered, without treating required-platform evidence as an additional score
or ambiguous output detail.

**Why this priority**: Clear traceability prevents future implementations from incorrectly restoring
required-platform scoring or emitting nondeterministically ordered elimination evidence.

**Independent Test**: Review the Discovery skill and shared template for the required-platform
traceability explanation and the three-level Candidate Elimination Log ordering declaration.

**Acceptance Scenarios**:

1. **Given** a candidate fails required-platform evaluation, **when** Discovery filters candidates, **then** it is eliminated before scoring and is absent from retained candidate alignment and the comparison matrix.
2. **Given** a candidate is retained, **when** its traceability fields are rendered, **then** Required Platform Match is 100 and the skill explains that this value exists for traceability only.
3. **Given** multiple candidates are eliminated, **when** the Candidate Elimination Log is rendered, **then** entries are ordered by Candidate Identifier, Constraint Category, and Constraint Identifier or Value.

### Edge Cases

- A record using the old `## Request` heading is invalid even if all other sections are present.
- A record using `Satisfied` for Constraint Compliance is invalid; only `Fully Compliant` is permitted.
- An alignment field with a qualitative value or an out-of-range number is invalid when the declared representation is 0-100.
- An alignment field containing a decimal value is invalid.
- An alignment field containing a value less than 0 is invalid.
- An alignment field containing a value greater than 100 is invalid.
- A Discovery run with no eliminated candidates still includes the Candidate Elimination Log section with its deterministic ordering rule and an explicit empty state.
- Required-platform mismatch remains an elimination condition and never becomes a score penalty or retained-candidate field value below 100.
- Generated adapters and catalogs must reflect canonical source changes and must not become independent contract authorities.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Discovery record template MUST use `## Request Reference` as the Request section heading.
- **FR-002**: The Discovery skill output contract, Verification section, and shared Discovery record template MUST declare identical section names and identical section ordering.
- **FR-003**: The Discovery skill and shared record template MUST permit exactly one Constraint Compliance value for retained candidates: `Fully Compliant`.
- **FR-004**: The comparison matrix MUST use `Fully Compliant` for every retained candidate and MUST NOT use `Satisfied` as an alternative compliance value.
- **FR-005**: The shared record template MUST define Desired Change, Objective, and Constraints alignment values using the numeric representation `<0-100>`.
- **FR-005a**: Alignment values MUST be integers in the inclusive range 0 through 100.
- **FR-006**: The Discovery skill MUST state that Required Platform Match exists for traceability only and that every retained candidate reports Required Platform Match = 100 because required-platform failures are eliminated before scoring.
- **FR-007**: The Candidate Elimination Log template MUST state that entries are ordered by Candidate Identifier, then Constraint Category, then Constraint Identifier or Value.
- **FR-008**: Discovery MUST preserve required-platform filtering before scoring and MUST NOT represent an eliminated candidate in retained alignment fields, the comparison matrix, or the recommendation.
- **FR-009**: The synchronized skill and template MUST retain the existing Request evidence contents, constraint field order, advisory ownership, ADR boundary, source immutability, privacy behavior, and no-write failure behavior.
- **FR-010**: Generated Discovery adapters and catalogs MUST be regenerated from the canonical skill and template after the synchronization changes.
- **FR-011**: Developer-facing validators and tests MUST execute focused checks for synchronized section order, `Fully Compliant` vocabulary, numeric alignment range, Required Platform Match traceability wording, and Candidate Elimination Log ordering; these checks MUST NOT be part of normal Discovery execution.
- **FR-012**: The focused developer-facing contract tests MUST use disposable valid and invalid fixtures to prove acceptance and rejection for each deterministic contract rule without mutating canonical artifacts.
- **FR-013**: The focused contract tests MUST include at least one independently failing invalid fixture for each deterministic contract rule; combined multi-violation fixtures MAY be added as supplemental regression coverage.

### Key Entities *(include if feature involves data)*

- **Discovery Section Contract**: The ordered set of headings shared by the Discovery skill, Verification rules, and record template.
- **Retained Candidate Compliance**: The deterministic `Fully Compliant` value emitted for a candidate that survives mandatory filtering.
- **Alignment Value**: A numeric 0-100 traceability value for Desired Change, Objective, and Constraints.
- **Candidate Elimination Log Ordering**: The deterministic three-key ordering rule for excluded candidates.
- **Required Platform Traceability**: The explanation and retained value proving required-platform filtering precedes scoring.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of synchronized Discovery section-order checks use the same 14-section order across the skill output contract, Verification section, and shared record template.
- **SC-002**: 100% of retained candidate contract examples and matrix rows use `Constraint Compliance: Fully Compliant`; 0 valid contract examples use `Satisfied`.
- **SC-003**: 100% of alignment fields in the shared template declare the same numeric 0-100 representation.
- **SC-003a**: 100% of valid alignment values are integers from 0 through 100 inclusive, and 100% of values outside that range fail validation.
- **SC-004**: 100% of retained candidates report Required Platform Match = 100, and the skill explicitly documents that the field is traceability-only.
- **SC-005**: 100% of Candidate Elimination Log contract examples state ordering by Candidate Identifier, Constraint Category, and Constraint Identifier or Value.
- **SC-006**: Focused validators and tests pass after canonical sources and all generated Discovery adapters/catalogs are regenerated.
- **SC-007**: Repeated validation of identical closed inputs produces identical section names, compliance values, alignment representation, elimination ordering, and advisory ownership wording.
- **SC-008**: Focused developer-facing validators and tests pass for each deterministic contract rule and remain separate from normal advisory Discovery execution.
- **SC-009**: Every deterministic contract rule has at least one disposable valid fixture and one disposable invalid fixture, and the test run leaves canonical artifacts unchanged.
- **SC-010**: Every deterministic contract rule fails independently when its corresponding invalid fixture is applied, while supplemental combined fixtures remain optional and canonical artifacts remain unchanged.

## Assumptions

- Feature 060 remains the authoritative source for Solution Constraint field names, mandatory filtering, retained-only scoring, and ADR ownership.
- Numeric 0-100 alignment values are preferred over qualitative labels because existing score and traceability contracts already use numeric ranges.
- `Fully Compliant` describes retained candidates after all mandatory constraints have passed; excluded candidates remain represented only in the Candidate Elimination Log.
- The existing Markdown skill, shared template, Bash validation harness, generated adapter process, and catalog process remain unchanged except for this contract synchronization.
- No Request schema, Discovery runtime artifact, ADR decision, governance baseline, or user-owned record is changed by this specification.

## Scope Boundaries

### Included in Version 1

- Synchronization of the Request Reference section name and complete Discovery section order.
- Deterministic Constraint Compliance vocabulary and numeric alignment representation.
- Required-platform traceability explanation and Candidate Elimination Log ordering documentation.
- Focused contract validation and regeneration of affected Discovery adapters/catalogs.

### Excluded from Version 1

- Changing candidate generation, mandatory filtering, scoring weights, or known-system scoring from Feature 060.
- Changing Request Solution Constraints collection or validation.
- Adding a new Discovery runtime, parser, persistence mechanism, or external interface.
- Selecting, approving, authorizing, or recording an ADR decision.
- Changing the meaning of any existing Request, Profile, Objective, Control, NFR, Reference Architecture, or Reference Implementation input.
