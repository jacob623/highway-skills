# Feature Specification: Highway Implementation Compatibility Assessment

**Feature Branch**: `178-highway-implementation-compatibility`

**Created**: 2026-10-15

**Status**: Draft

**Input**: User description: "Elevate highway-implementation from an architecture-to-document projection workflow into an implementation validation and realization workflow. Require user-owned Implementation Selections, assess compatibility before Reference Implementation generation, identify gaps and conflicts, preserve architecture authority, and support future brownfield alignment."

## User Scenarios & Testing

### User Story 1 - Provide Implementation Selections (Priority: P1)

An implementation owner provides one or more user-owned Implementation Selections alongside an accepted Reference Architecture so that the workflow validates real realization choices rather than inventing a technology list.

**Why this priority**: Compatibility cannot be assessed without the components that will realize the architecture.

**Independent Test**: Invoke the implementation workflow with one accepted architecture and one or more selections such as AWS Lambda, SQS, and DynamoDB. Verify that the selections are captured, normalized deterministically, and retained in the resulting assessment context.

**Acceptance Scenarios**:

1. **Given** an accepted `ARCH######`, **when** the owner supplies one or more Implementation Selections, **then** the workflow accepts cloud services, infrastructure components, frameworks, databases, software products, provider services, middleware, and other implementation building blocks.
2. **Given** selections supplied in different ordering, **when** the same architecture and selection set is assessed, **then** the normalized selection set and assessment inputs are deterministic.
3. **Given** no Implementation Selections are supplied, **when** implementation begins, **then** the workflow requests the required selections and does not silently generate or assume them.
4. **Given** a selection named `Products`, **when** the input is reviewed, **then** it is not treated as the primary concept; the workflow uses the named implementation component or service instead.

---

### User Story 2 - Assess Architecture Compatibility (Priority: P1)

An implementation owner receives a first-class Architecture Compatibility Assessment before any Reference Implementation proposal is generated.

**Why this priority**: The core value of the feature is proving that selected implementation components can realize the accepted architecture.

**Independent Test**: Run the same architecture and selection fixtures through the assessment and verify that each produces exactly one outcome: `Compatible`, `Incomplete`, or `Incompatible`.

**Acceptance Scenarios**:

1. **Given** selections that realize every required architecture responsibility without contradiction, **when** compatibility is assessed, **then** the result is exactly `Compatible`.
2. **Given** selections that do not contradict the architecture but leave required responsibilities unresolved, **when** compatibility is assessed, **then** the result is exactly `Incomplete`.
3. **Given** a selection that directly contradicts an explicit architecture requirement, **when** compatibility is assessed, **then** the result is exactly `Incompatible`.
4. **Given** identical architecture, governance, and selection inputs, **when** the assessment is repeated, **then** the result and assessment content are identical.

---

### User Story 3 - Resolve Implementation Gaps (Priority: P1)

An implementation owner can understand and resolve significant realization responsibilities that remain open without weakening the architecture.

**Why this priority**: An incomplete selection set must become actionable rather than producing an incomplete Reference Implementation.

**Independent Test**: Assess an architecture requiring messaging, identity, and observability with selections that provide only compute and persistence. Verify a gap analysis and that RI generation is blocked until every required gap is addressed.

**Acceptance Scenarios**:

1. **Given** an `Incomplete` assessment, **when** the workflow reports gaps, **then** each gap contains `Missing Capability`, `Why It Matters`, `Suggested Realization`, and `Recommendation Confidence`.
2. **Given** architecture evidence supports multiple realization choices, **when** a gap is analyzed, **then** the workflow may recommend a grounded realization and lets the owner accept it, substitute an alternative, or provide an additional selection.
3. **Given** architecture evidence is insufficient to recommend a realization, **when** a gap is analyzed, **then** the recommendation remains `Unknown` rather than inventing a product or service.
4. **Given** unresolved required gaps remain, **when** the owner attempts to generate an RI, **then** the workflow does not create an RI artifact or change the implementation catalog.

---

### User Story 4 - Resolve Implementation Conflicts (Priority: P1)

An implementation owner can see when a selection contradicts the accepted architecture and can choose whether to resolve the implementation or revisit the architecture through an explicit path.

**Why this priority**: Silent repair or reinterpretation would undermine architecture authority and traceability.

**Independent Test**: Assess explicit conflicts such as event-driven architecture with scheduled batch jobs, stateless compute with a stateful VM cluster, or an excluded self-hosted approach. Verify the conflict report and exactly two available paths.

**Acceptance Scenarios**:

1. **Given** a selection that contradicts an explicit architecture requirement, **when** the assessment completes, **then** it is `Incompatible` and identifies each conflict with `Architecture Requirement`, `Implementation Selection`, and `Conflict Explanation`.
2. **Given** an `Incompatible` assessment, **when** the result is presented, **then** the workflow offers exactly `Resolve Implementation` and `Revisit Architecture`.
3. **Given** an `Incompatible` assessment, **when** the owner has not resolved the conflict, **then** no RI artifact or implementation catalog mutation is produced.
4. **Given** a conflict, **when** the owner chooses to resolve implementation, **then** the architecture remains unchanged and the owner must provide a compatible selection or other explicit resolution.

---

### User Story 5 - Generate a Validated Reference Implementation (Priority: P1)

An implementation owner receives a Reference Implementation proposal only after selections are shown to realize the accepted architecture and its required governance concerns.

**Why this priority**: Generation is valuable only when the resulting implementation is demonstrably realizable.

**Independent Test**: Supply a compatible selection set and verify that the workflow creates one RI proposal with compatibility, coverage, selections, realization rationale, governance realization, and complete traceability.

**Acceptance Scenarios**:

1. **Given** a `Compatible` assessment, **when** the implementation workflow proceeds, **then** it may generate one proposed RI using the selected components and existing RI ownership rules.
2. **Given** a compatible RI proposal, **when** its technology realization is reviewed, **then** every selected component records the architecture responsibility, reason selected, and supporting evidence.
3. **Given** required Controls or NFRs are not realized by the selections, **when** no explicit architectural contradiction exists, **then** the assessment is `Incomplete` and identifies the missing realization rather than producing a falsely compatible RI.
4. **Given** a successful RI proposal, **when** traceability is reviewed, **then** the available `REQ -> DISC -> ADR -> ARCH -> RI` chain and architecture ownership are preserved.

---

### User Story 6 - Review Deterministic Coverage and Ownership (Priority: P2)

A repository maintainer can review how architecture responsibilities were evaluated and confirm that the implementation workflow does not redesign upstream architecture.

**Why this priority**: Coverage transparency and authority preservation make the new validation behavior auditable and reusable.

**Independent Test**: Review assessment fixtures with required and non-required realization categories and verify every required category has one status while non-required categories are marked `Not Applicable`.

**Acceptance Scenarios**:

1. **Given** an architecture with known realization needs, **when** coverage is assessed, **then** each required category is marked exactly `Satisfied` or `Unsatisfied`.
2. **Given** a realization category not required by the architecture, **when** coverage is assessed, **then** it is marked `Not Applicable`.
3. **Given** any compatibility result, **when** the assessment is reviewed, **then** no architecture requirement is silently ignored and no ADR or architecture decision is weakened, substituted, or reinterpreted.
4. **Given** the same declared inputs and source state, **when** the assessment is repeated, **then** category ordering, gaps, conflicts, recommendations, and result remain stable.

---

### User Story 7 - Align Future Brownfield Observations (Priority: P2)

A future brownfield onboarding workflow can submit observed implementation components to the same compatibility assessment without requiring a separate validation model.

**Why this priority**: Reusing one assessment concept avoids divergent validation logic for new and existing environments.

**Independent Test**: Review the assessment input contract and verify that user-selected and observed implementation components share the same component representation and outcome model, while brownfield discovery remains outside this feature's delivery scope.

**Acceptance Scenarios**:

1. **Given** a future source of observed implementation components, **when** those components are supplied to the assessment, **then** they can be evaluated using the same compatibility outcomes and coverage categories.
2. **Given** no brownfield observation source exists in this feature, **when** the current workflow is implemented, **then** no separate brownfield workflow or duplicate validation engine is created.

### Edge Cases

- The owner supplies zero selections, whitespace-only selections, duplicate selections, or selections with equivalent names.
- A selection names a valid implementation building block but has no architecture responsibility supported by evidence.
- The architecture has no requirement for one or more coverage categories.
- The architecture contains optional guidance, Controls, or NFRs that are unavailable, blocked, malformed, or insufficient to support a recommendation.
- A selection satisfies one responsibility but conflicts with another requirement.
- Multiple selections jointly satisfy one responsibility, or one selection realizes multiple responsibilities.
- A required responsibility is unresolved while all explicit selections are otherwise non-contradictory.
- A conflict is discovered after a previous RI already exists; the existing RI and catalog bytes remain unchanged.
- A compatible assessment is repeated with selections in a different order; output remains deterministic.
- A user chooses `Resolve Implementation` or `Revisit Architecture` without supplying a new substantive resolution.
- The future brownfield input contains observed components that are incomplete, duplicated, or not attributable to a source.

## Requirements

### Functional Requirements

- **FR-001**: The implementation workflow MUST require one or more user-owned `Implementation Selections` in addition to exactly one explicit accepted `ARCH######` source.
- **FR-002**: The workflow MUST support selections representing cloud services, infrastructure components, application frameworks, databases, software products, provider services, middleware, and implementation building blocks.
- **FR-003**: The workflow MUST normalize equivalent selection names and establish deterministic ordering without changing their user-owned meaning.
- **FR-004**: The workflow MUST request missing selections and MUST NOT invent, infer, or silently generate selections.
- **FR-005**: The workflow MUST extract implementation-relevant requirements from Logical Components, Interaction Model, Trust Boundaries, Deployment Pattern, Required Capabilities, Constraints, Control Relationships, NFR Relationships, and Reference Implementation Guidance when those sections are present.
- **FR-006**: The workflow MUST perform an explicit Architecture Compatibility Assessment after source and selection validation and before RI generation.
- **FR-007**: Each assessment MUST produce exactly one result: `Compatible`, `Incomplete`, or `Incompatible`.
- **FR-008**: The workflow MUST evaluate only realization categories required by the architecture and MUST use these categories when applicable: Compute, Messaging, Persistence, Identity, Networking, Security, Observability, Recovery, Deployment, and Operations.
- **FR-009**: Each required realization category MUST be assigned exactly one status: `Satisfied` or `Unsatisfied`; each non-required category MUST be assigned `Not Applicable`.
- **FR-010**: The workflow MUST mark an assessment `Compatible` only when all required architecture responsibilities are realizable, no selection contradicts architecture intent, and required realization concerns are covered.
- **FR-011**: The workflow MUST mark an assessment `Incomplete` when selections do not contradict architecture intent but one or more significant required implementation responsibilities remain unresolved.
- **FR-012**: The workflow MUST mark an assessment `Incompatible` when one or more selections directly contradict an explicit architecture requirement.
- **FR-013**: For an `Incomplete` result, the workflow MUST produce an Implementation Gap Analysis containing `Missing Capability`, `Why It Matters`, `Suggested Realization`, and `Recommendation Confidence` for each required unresolved responsibility.
- **FR-014**: The workflow MUST allow the owner to accept a gap recommendation, substitute an alternative, or provide additional Implementation Selections.
- **FR-015**: The workflow MUST keep a recommendation `Unknown` when available architecture evidence is insufficient to support a realization recommendation.
- **FR-016**: The workflow MUST NOT generate an RI while required implementation gaps remain unresolved.
- **FR-017**: For an `Incompatible` result, the workflow MUST produce an Architecture Compatibility Assessment containing `Result: Incompatible` and a conflict for each contradiction.
- **FR-018**: Each conflict MUST contain `Architecture Requirement`, `Implementation Selection`, and `Conflict Explanation`.
- **FR-019**: An incompatible result MUST provide exactly two resolution paths: `Resolve Implementation` and `Revisit Architecture`.
- **FR-020**: The workflow MUST NOT silently repair, weaken, reinterpret, substitute, or override architecture requirements, ADR decisions, or architecture intent.
- **FR-021**: The Reference Architecture MUST remain authoritative when implementation selections conflict with it.
- **FR-022**: The workflow MUST generate an RI only from a `Compatible` assessment and MUST preserve existing RI allocation, persistence, and no-partial-write behavior.
- **FR-023**: The implementation record MUST include `Architecture Compatibility Assessment`, `Coverage Summary`, `Implementation Gaps`, `Implementation Conflicts`, `Implementation Selections`, and `Technology Realization Rationale` sections.
- **FR-024**: Technology Realization Rationale MUST record each selected component, its architecture responsibility, reason selected, and supporting evidence.
- **FR-025**: Every Implementation Selection MUST map to one or more architecture responsibilities or be identified as unsupported for owner resolution.
- **FR-026**: Every required architecture responsibility MUST have a realization status and MUST NOT be silently omitted from the assessment.
- **FR-027**: Controls and NFRs MUST participate in compatibility evaluation when they impose implementation realization concerns.
- **FR-028**: Missing Control or NFR realization MUST contribute to `Incomplete` unless the architecture explicitly requires a contradictory mechanism, in which case the result MUST be `Incompatible`.
- **FR-029**: Identical architecture, governance, and selection inputs MUST produce byte-stable compatibility results, ordering, recommendations, and traceability.
- **FR-030**: An incompatible assessment MUST produce no RI artifact and MUST preserve existing implementation and catalog bytes.
- **FR-031**: An incomplete assessment MUST produce no RI artifact until all required gaps are resolved and reassessed as `Compatible`.
- **FR-032**: A compatible assessment MAY proceed to one proposed RI while preserving `REQ -> DISC -> ADR -> ARCH -> RI` traceability where identifiers are available.
- **FR-033**: The compatibility assessment MUST support future observed implementation components as an equivalent input shape without creating a separate brownfield validation model in this feature.
- **FR-034**: The feature MUST NOT change Reference Architecture ownership, ADR authority, implementation ownership, or downstream planning and code-generation boundaries.
- **FR-035**: Failed source, selection, assessment, gap, conflict, allocation, validation, or write operations MUST preserve every pre-operation source, RI, and catalog byte.

### Key Entities

- **Implementation Selection**: A user-owned implementation component, service, product, framework, database, middleware, infrastructure element, or provider capability proposed to realize an accepted Reference Architecture.
- **Architecture Requirement**: An implementation-relevant responsibility extracted from accepted architecture evidence, governance relationships, constraints, or implementation guidance.
- **Realization Category**: A deterministic category used to evaluate required implementation responsibilities, including Compute, Messaging, Persistence, Identity, Networking, Security, Observability, Recovery, Deployment, and Operations.
- **Coverage Status**: The result for a realization category: `Satisfied`, `Unsatisfied`, or `Not Applicable`.
- **Architecture Compatibility Assessment**: The first-class assessment containing the normalized selections, extracted requirements, coverage summary, one compatibility result, gaps, conflicts, recommendations, and traceability.
- **Implementation Gap**: An unresolved required architecture responsibility that does not contradict the architecture but prevents a complete realization.
- **Implementation Conflict**: A direct contradiction between an Implementation Selection and an explicit Architecture Requirement.
- **Technology Realization Rationale**: The explanation connecting each selected component to architecture responsibilities and supporting evidence.
- **Reference Implementation**: A proposed validated realization of an accepted Reference Architecture, generated only after a `Compatible` assessment.
- **Observed Implementation Component**: A future brownfield-compatible input representing an existing implementation component evaluated by the same assessment model as a user-owned selection.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of implementation runs with supplied selections produce exactly one of the three declared compatibility results.
- **SC-002**: 100% of required architecture responsibilities receive one coverage status, and 100% of non-required categories are explicitly marked `Not Applicable`.
- **SC-003**: 100% of `Incomplete` assessments contain at least one actionable implementation gap with all four required fields.
- **SC-004**: 100% of `Incompatible` assessments contain at least one structured conflict and exactly two resolution paths.
- **SC-005**: 100% of incompatible and unresolved incomplete assessments create zero new RI artifacts and preserve all pre-operation implementation and catalog bytes.
- **SC-006**: 100% of compatible assessments that proceed to generation include every selected component's responsibility, rationale, and supporting evidence.
- **SC-007**: 100% of repeated assessments with identical declared inputs produce identical result, category ordering, gap/conflict ordering, recommendation values, and traceability.
- **SC-008**: 100% of architecture requirements, Controls, and NFR realization concerns used by the assessment are either covered, identified as unresolved, marked unsupported, or explicitly marked not applicable.
- **SC-009**: At least 95% of implementation owners can distinguish `Compatible`, `Incomplete`, and `Incompatible` outcomes and identify the next action from representative assessment outputs without additional explanation.
- **SC-010**: 100% of conflict scenarios preserve the accepted Reference Architecture and ADR decisions without silent reinterpretation or substitution.
- **SC-011**: 100% of future brownfield-compatible component fixtures can be evaluated through the same outcome and coverage model without a second validation definition.

## Assumptions

- `ARCH######` remains the required explicit upstream identifier and the accepted Reference Architecture remains the source of architecture authority.
- Implementation Selections are supplied by the implementation owner and may be named products, services, components, frameworks, databases, middleware, or non-vendor building blocks.
- The existing canonical source completeness, readiness, allocation, persistence, and traceability validators remain authoritative.
- A recommendation is advisory until the owner accepts it or supplies an alternative selection; recommendations do not become organizational facts.
- Controls and NFRs remain authoritative in their own artifacts; this feature evaluates their implementation realization without changing their ownership.
- The current feature does not implement brownfield discovery or observed-component collection; it defines a reusable assessment input boundary for future work.
- A `Compatible` assessment is a prerequisite to RI generation, while `Incomplete` and `Incompatible` assessments are non-generating outcomes.

## Scope Boundaries

### Included in Version 1

- User-owned Implementation Selections as a required runtime input.
- Deterministic selection normalization and ordering.
- Architecture requirement extraction for implementation-relevant evidence.
- Compatibility assessment with exactly three outcomes.
- Deterministic realization coverage categories and statuses.
- Implementation Gap Analysis and grounded recommendation behavior.
- Structured implementation conflict reporting and the two explicit resolution paths.
- Controls and NFR participation in realization completeness.
- Compatibility sections and selection rationale in the RI output.
- No-generation behavior for incomplete and incompatible assessments.
- Preservation of architecture authority, ownership, no-write failure behavior, and traceability.
- A shared input boundary suitable for future brownfield observations.

### Excluded from Version 1

- Changes to Reference Architecture content, lifecycle, acceptance, or ownership.
- Automatic redesign of architecture or ADR decisions.
- Automatic selection of products without supporting architecture evidence.
- A separate brownfield discovery workflow or observed-component ingestion process.
- Plans, tasks, executable source code, infrastructure definitions, deployment authorization, or productization artifacts.
- New identifier families, new governance ownership, or replacement of existing canonical validators.
