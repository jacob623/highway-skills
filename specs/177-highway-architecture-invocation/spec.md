# Feature Specification: Highway Architecture and Implementation Invocation Guards

**Feature Branch**: `177-highway-architecture-invocation`

**Created**: 2026-10-15

**Status**: Draft

**Input**: User description: "Add direct invocation behavior to `highway-architecture` and `highway-implementation`: require one explicit upstream identifier, request it when missing, validate it before processing, reject implicit source selection, and preserve traceability."

## Clarifications

### Session 2026-10-15

- Q: Should both invocation guards reuse the existing canonical completeness and readiness validators for ADR and ARCH artifacts? → A: Reuse existing canonical validators and their established failure outcomes.

## User Scenarios & Testing

### User Story 1 - Request the Missing Reference Architecture (Priority: P1)

An implementation owner invokes `/highway-implementation` without an identifier and receives a clear request for the Reference Architecture to implement instead of a silent failure or an automatic selection.

**Why this priority**: Implementation generation cannot safely begin without an explicit upstream architecture source.

**Independent Test**: Invoke `/highway-implementation` with no identifier and verify the exact next action, question, examples, no allocation, no implementation artifact, and no automatic architecture selection.

**Acceptance Scenarios**:

1. **Given** no ARCH identifier is supplied, **When** the skill starts, **Then** it responds with `Next Action: Provide the Reference Architecture to implement.`.
2. **Given** no ARCH identifier is supplied, **When** the response is reviewed, **Then** it asks `Which Reference Architecture would you like to use?` and shows `ARCH000001` and `ARCH000002` examples.
3. **Given** no ARCH identifier is supplied, **When** the workflow responds, **Then** it allocates no identifier, creates no implementation artifact, and selects no architecture automatically.

### User Story 2 - Validate the Explicit Architecture Source (Priority: P1)

An implementation owner invokes `/highway-implementation ARCH000001` and receives deterministic validation of the identifier, architecture existence, unique resolution, completeness, and readiness before processing.

**Why this priority**: Explicit source selection only protects architecture ownership when the selected source is valid and ready.

**Independent Test**: Exercise accepted, invalid-format, missing, duplicate, ambiguous, and malformed ARCH fixtures and verify each outcome stops or proceeds as specified without partial output.

**Acceptance Scenarios**:

1. **Given** `/highway-implementation ARCH000001`, **When** the identifier format, artifact existence, unique resolution, architecture completeness, and architecture readiness all pass, **Then** processing may continue with that architecture.
2. **Given** an invalid ARCH identifier, **When** the workflow runs, **Then** it identifies the invalid identifier and stops without writes.
3. **Given** a missing, duplicate, ambiguous, or malformed Reference Architecture resolution, **When** the workflow runs, **Then** it stops without creating an implementation artifact or changing the implementation catalog.

### User Story 3 - Prevent Implicit Architecture Selection (Priority: P1)

A repository maintainer can rely on the implementation workflow never substituting an architecture based on availability, context, ordering, recency, or session state.

**Why this priority**: Selecting the wrong architecture would invalidate implementation decisions and traceability.

**Independent Test**: Repeat missing-identifier scenarios with zero, one, and many architectures while varying filesystem order, timestamps, recency, environment state, and session memory; verify the workflow always requests explicit input.

**Acceptance Scenarios**:

1. **Given** only one ARCH exists and no identifier is supplied, **When** the workflow runs, **Then** it still requests an ARCH identifier.
2. **Given** multiple ARCH records exist and no identifier is supplied, **When** the workflow runs, **Then** it does not select the newest or only candidate.
3. **Given** an explicit valid ARCH identifier is supplied, **When** processing succeeds, **Then** traceability preserves the explicit `REQ -> DISC -> ADR -> ARCH -> RI` chain where identifiers are available.

### User Story 4 - Request the Missing Architecture Decision (Priority: P1)

An architecture authority invokes `/highway-architecture` without an identifier and receives a clear request for the Architecture Decision Record to convert instead of a silent failure or automatic selection.

**Why this priority**: Reference Architecture creation cannot safely begin without an explicit ADR source.

**Independent Test**: Invoke `/highway-architecture` without an identifier and verify the next action, question, examples, no allocation, no architecture artifact, and no automatic ADR selection.

**Acceptance Scenarios**:

1. **Given** no ADR identifier is supplied, **When** the skill starts, **Then** it responds with `Next Action: Provide the Architecture Decision Record to use.`.
2. **Given** no ADR identifier is supplied, **When** the response is reviewed, **Then** it asks `Which ADR would you like to convert into a Reference Architecture?` and shows `ADR000001` and `ADR000002` examples.
3. **Given** no ADR identifier is supplied, **When** the workflow responds, **Then** it allocates no identifier, creates no Reference Architecture, and selects no ADR automatically.

### User Story 5 - Validate the Explicit Architecture Decision (Priority: P1)

An architecture authority invokes `/highway-architecture ADR000001` and receives deterministic validation of the identifier, ADR existence, unique resolution, completeness, and readiness before architecture processing.

**Why this priority**: Explicit ADR selection only protects architecture ownership when the selected decision is valid and ready.

**Independent Test**: Exercise accepted, invalid-format, missing, duplicate, ambiguous, and malformed ADR fixtures and verify each outcome stops or proceeds as specified without partial output.

**Acceptance Scenarios**:

1. **Given** `/highway-architecture ADR000001`, **When** identifier format, ADR existence, unique resolution, ADR completeness, and ADR readiness pass, **Then** processing may continue with that ADR.
2. **Given** an invalid ADR identifier, **When** the workflow runs, **Then** it identifies the invalid identifier and stops without writes.
3. **Given** a missing, duplicate, ambiguous, or malformed ADR resolution, **When** the workflow runs, **Then** it stops without creating a Reference Architecture or changing its catalog.

### User Story 6 - Prevent Implicit ADR Selection (Priority: P1)

A repository maintainer can rely on `/highway-architecture` never substituting an ADR based on availability, context, ordering, recency, or session state.

**Why this priority**: Selecting the wrong ADR would invalidate architecture decisions and downstream traceability.

**Independent Test**: Repeat missing-identifier scenarios with zero, one, and many ADRs while varying filesystem order, timestamps, recency, environment state, and session memory; verify the workflow always requests explicit input.

**Acceptance Scenarios**:

1. **Given** only one ADR exists and no identifier is supplied, **When** the workflow runs, **Then** it still requests an ADR identifier.
2. **Given** multiple ADRs exist and no identifier is supplied, **When** the workflow runs, **Then** it does not select the newest or only candidate.
3. **Given** an explicit valid ADR identifier is supplied, **When** processing succeeds, **Then** architecture traceability preserves that ADR and the available `REQ -> DISC -> ADR -> ARCH` chain.

### Edge Cases

- The invocation is empty, whitespace-only, or contains more than one ARCH identifier.
- The identifier is lowercase, has the wrong prefix, has the wrong digit count, or contains surrounding text.
- The identifier is well formed but the Reference Architecture is absent from the authoritative catalog.
- The catalog resolves the identifier ambiguously or contains duplicate relationships.
- The Reference Architecture is unreadable, malformed, incomplete, inconsistent, or not ready.
- No ARCH records exist, exactly one exists, or many exist when the identifier is omitted.
- A failed validation occurs while a previous implementation already exists; existing implementation and catalog bytes remain unchanged.
- The `/highway-architecture` invocation is empty, contains whitespace only, or contains more than one ADR identifier.
- The ADR identifier is lowercase, has the wrong prefix, has the wrong digit count, or contains surrounding text.
- The ADR is absent, unreadable, malformed, incomplete, inconsistent, or not ready.
- No ADRs exist, exactly one exists, or many exist when the architecture identifier is omitted.
- A failed architecture validation occurs while a previous Reference Architecture already exists; existing architecture and catalog bytes remain unchanged.

## Requirements

### Functional Requirements

- **FR-001**: The `/highway-implementation` invocation MUST require exactly one explicit `ARCH######` identifier before processing.
- **FR-002**: When no ARCH identifier is supplied, the workflow MUST respond with `Next Action: Provide the Reference Architecture to implement.`.
- **FR-003**: The missing-identifier response MUST ask `Which Reference Architecture would you like to use?`.
- **FR-004**: The missing-identifier response MUST include `ARCH000001` and `ARCH000002` examples.
- **FR-005**: A missing-identifier invocation MUST allocate no identifier, create no implementation artifact, and select no architecture automatically.
- **FR-006**: The workflow MUST validate the exact uppercase `ARCH` prefix followed by six digits before processing.
- **FR-007**: The workflow MUST validate Reference Architecture artifact existence before processing.
- **FR-008**: The workflow MUST validate unique resolution before processing and reject ambiguous or duplicate resolution.
- **FR-009**: The workflow MUST apply the existing canonical completeness validator to the selected Reference Architecture before processing.
- **FR-010**: The workflow MUST apply the existing canonical readiness validator and its established failure outcomes to the selected Reference Architecture before processing.
- **FR-011**: An invalid identifier MUST be identified in the error response and MUST stop without writes.
- **FR-012**: A missing Reference Architecture MUST stop without creating an implementation artifact or changing the implementation catalog.
- **FR-013**: A duplicate or ambiguous resolution MUST stop without selecting a source or writing output.
- **FR-014**: A malformed Reference Architecture MUST stop without writing implementation output.
- **FR-015**: The workflow MUST NOT select the newest ARCH automatically.
- **FR-016**: The workflow MUST NOT select the only ARCH automatically.
- **FR-017**: The workflow MUST NOT infer an ARCH from context.
- **FR-018**: The workflow MUST NOT use filesystem order, timestamps, recency, or session memory for source selection.
- **FR-019**: A valid explicit identifier MUST remain the sole architecture source for subsequent processing.
- **FR-020**: Traceability MUST preserve `REQ000001 -> DISC000001 -> ADR000001 -> ARCH000001 -> RI000001` when those identifiers are available.
- **FR-021**: All missing, invalid, missing-source, duplicate, ambiguous, and malformed invocation cases MUST preserve every pre-operation implementation and catalog byte.
- **FR-022**: This invocation guard MUST NOT change Reference Architecture ownership, implementation ownership, or downstream planning and code-generation boundaries.
- **FR-023**: The `/highway-architecture` invocation MUST require exactly one explicit `ADR######` identifier before processing.
- **FR-024**: When no ADR identifier is supplied, the architecture workflow MUST respond with `Next Action: Provide the Architecture Decision Record to use.`.
- **FR-025**: The missing-ADR response MUST ask `Which ADR would you like to convert into a Reference Architecture?`.
- **FR-026**: The missing-ADR response MUST include `ADR000001` and `ADR000002` examples.
- **FR-027**: A missing-ADR invocation MUST allocate no identifier, create no Reference Architecture, and select no ADR automatically.
- **FR-028**: The architecture workflow MUST validate the exact uppercase `ADR` prefix followed by six digits before processing.
- **FR-029**: The architecture workflow MUST validate ADR artifact existence before processing.
- **FR-030**: The architecture workflow MUST validate unique resolution before processing and reject ambiguous or duplicate resolution.
- **FR-031**: The architecture workflow MUST apply the existing canonical completeness validator to the selected ADR before processing.
- **FR-032**: The architecture workflow MUST apply the existing canonical readiness validator and its established failure outcomes to the selected ADR before processing.
- **FR-033**: An invalid ADR identifier MUST be identified in the error response and MUST stop without writes.
- **FR-034**: A missing ADR MUST stop without creating a Reference Architecture or changing its catalog.
- **FR-035**: A duplicate or ambiguous ADR resolution MUST stop without selecting a source or writing output.
- **FR-036**: A malformed ADR MUST stop without writing Reference Architecture output.
- **FR-037**: The architecture workflow MUST NOT select the newest ADR automatically.
- **FR-038**: The architecture workflow MUST NOT select the only ADR automatically.
- **FR-039**: The architecture workflow MUST NOT infer an ADR from context.
- **FR-040**: The architecture workflow MUST NOT use filesystem order, timestamps, recency, or session memory for source selection.
- **FR-041**: A valid explicit ADR identifier MUST remain the sole source for subsequent architecture processing.
- **FR-042**: Architecture traceability MUST preserve `REQ000001 -> DISC000001 -> ADR000001 -> ARCH000001` when those identifiers are available.
- **FR-043**: All missing, invalid, missing-source, duplicate, ambiguous, and malformed architecture invocation cases MUST preserve every pre-operation architecture and catalog byte.
- **FR-044**: Both invocation guards MUST preserve upstream ownership and must not change architecture decisions, implementation realization ownership, or downstream planning and code-generation boundaries.

### Key Entities

- **Reference Architecture**: The required upstream artifact identified by one explicit `ARCH######` identifier.
- **Implementation Invocation**: The direct command and supplied identifier used to select the implementation source.
- **Invocation Guard**: The validation boundary that requests missing input, rejects invalid input, and permits one ready architecture to continue.
- **Implementation Traceability Chain**: The available upstream and downstream identifiers from REQ through RI.
- **Architecture Invocation**: The direct command and supplied `ADR######` identifier used to select the decision for Reference Architecture creation.
- **Architecture Traceability Chain**: The available upstream identifiers from REQ through ARCH.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of missing-identifier invocations produce the specified next action, question, examples, and zero writes.
- **SC-002**: 100% of invalid-format, missing, duplicate, ambiguous, incomplete, and malformed ARCH fixtures stop before processing and preserve all pre-operation bytes.
- **SC-003**: 100% of valid explicit ARCH identifiers pass through all five validation checks before processing continues.
- **SC-004**: 100% of repeated missing-identifier runs make the same no-selection decision regardless of ARCH count, filesystem order, timestamps, recency, environment state, or session memory.
- **SC-005**: 100% of successful explicit-source runs preserve the available REQ-to-RI traceability chain.
- **SC-006**: At least 95% of representative implementation owners can identify the next action and required ARCH input from the missing-identifier response without additional documentation.
- **SC-007**: 100% of missing-ADR invocations produce the specified next action, question, examples, and zero architecture or catalog writes.
- **SC-008**: 100% of invalid-format, missing, duplicate, ambiguous, incomplete, and malformed ADR fixtures stop before architecture processing and preserve all pre-operation bytes.
- **SC-009**: 100% of valid explicit ADR identifiers pass through all five architecture validation checks before processing continues.
- **SC-010**: 100% of repeated missing-ADR runs make the same no-selection decision regardless of ADR count, filesystem order, timestamps, recency, environment state, or session memory.
- **SC-011**: 100% of successful explicit ADR runs preserve the available REQ-to-ARCH traceability chain.
- **SC-012**: At least 95% of representative architecture authorities can identify the next action and required ADR input from the missing-identifier response without additional documentation.

## Assumptions

- `ARCH######` is the canonical Reference Architecture identifier format established by Feature 175.
- The existing Reference Architecture catalog owns source resolution and the existing implementation workflow owns RI generation after this guard succeeds.
- The missing-identifier response is conversational and creates no retained artifact.
- Existing implementation realization, governance, determinism, and downstream-boundary behavior remain owned by Feature 176.
- This feature adds invocation and source-readiness behavior for both skills without changing architecture or implementation artifact structures.
- `ADR######` is the canonical Architecture Decision Record identifier format already used by `highway-architecture` and `highway-adr`.
- The existing ADR catalog owns decision resolution and the existing architecture workflow owns Reference Architecture generation after this guard succeeds.
- Both invocation guards reuse the existing canonical completeness and readiness validators and their established failure outcomes; Feature 177 does not define competing validation rules.

## Scope Boundaries

### Included in Version 1

- Direct `/highway-implementation` invocation behavior.
- Missing-identifier prompting and exact examples.
- Explicit ARCH format, existence, uniqueness, completeness, and readiness validation.
- Prohibition of implicit source selection and no-write error behavior.
- Explicit REQ-to-RI traceability preservation.
- Direct `/highway-architecture` invocation behavior.
- Missing-ADR prompting and exact examples.
- Explicit ADR format, existence, uniqueness, completeness, and readiness validation.
- Prohibition of implicit ADR selection and no-write error behavior.
- Explicit REQ-to-ARCH traceability preservation.

### Excluded from Version 1

- Changes to Reference Architecture content, lifecycle, or ownership.
- Changes to Reference Implementation structure, technology realization, or catalog allocation after validation.
- Changes to ADR decision content, ADR lifecycle, or Reference Architecture structure beyond the invocation gate.
- Automatic source ranking, fuzzy matching, context inference, or new identifier formats.
- Planning, task generation, executable code, infrastructure definitions, deployment authorization, or productization.
