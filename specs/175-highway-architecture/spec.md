# Feature Specification: Highway Reference Architecture Workflow

**Feature Branch**: `175-highway-architecture`

**Created**: 2026-10-15

**Status**: Draft

**Input**: User description: "Implement a new Highway skill named `highway-architecture` that creates one authoritative Reference Architecture from exactly one accepted ADR while preserving ADR ownership of the architectural decision and rationale."

## Clarifications

### Session 2026-10-15

- Q: When an optional Profile, Objective, Control, or NFR input is malformed, should Reference Architecture creation continue while omitting that input, or abort without writing? → A: Abort without writes whenever any optional input is malformed.
- Q: When an optional Profile, Objective, Control, or NFR is present but blocked, should Reference Architecture creation continue while recording the blocked source as a risk? → A: Continue and record the blocked source as an architecture risk.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Create a Reference Architecture from one accepted ADR (Priority: P1)

As a Reference Architecture owner, I want to provide exactly one accepted ADR and receive one conceptual architecture record so that reusable architectural knowledge is captured between ADR and future Reference Implementation work.

**Why this priority**: The accepted-ADR-to-Reference-Architecture handoff is the complete MVP value and the only required creation path.

**Independent Test**: Provide one valid accepted ADR and optional governance context, run the architecture workflow, and verify that exactly one `ARCHXXXXXX` record and one catalog entry are produced with the ADR reference, required architecture sections, and traceability.

**Acceptance Scenarios**:

1. **Given** exactly one valid accepted ADR identifier, **When** Reference Architecture creation runs, **Then** it creates one proposed architecture record with a permanent `ARCHXXXXXX` identifier and references the source ADR.
2. **Given** an accepted ADR with context, decision, rationale, alternatives, and consequences, **When** the architecture is generated, **Then** those inputs inform the architecture without changing the ADR or transferring decision ownership.
3. **Given** optional Profile, Objectives, Controls, or NFRs, **When** architecture creation runs, **Then** available evidence may inform constraints, relationships, assumptions, risks, and required capabilities without becoming architecture-owned replacements for those sources.
4. **Given** a valid architecture record, **When** it is completed, **Then** it contains a conceptual logical architecture, component model, interaction model, deployment pattern, trust boundaries, required capabilities, assumptions, risks, constraints, and future implementation guidance.

### User Story 2 - Preserve ownership and provide a clean implementation handoff (Priority: P1)

As an ADR owner and future Reference Implementation owner, I want the architecture artifact to preserve decision authority and clearly separate conceptual guidance from implementation authorization so that downstream work can consume the architecture without mutating upstream decisions or prematurely generating implementation artifacts.

**Why this priority**: The architecture skill is valuable only if it becomes an authoritative knowledge boundary without competing with ADR or Reference Implementation ownership.

**Independent Test**: Inspect a generated architecture and its completion response, then compare ADR, Discovery, Request, Objectives, Controls, and NFRs before and after creation; verify ownership statements, traceability, and absence of implementation authorization.

**Acceptance Scenarios**:

1. **Given** an accepted ADR, **When** architecture creation completes, **Then** the architecture identifies the ADR as the inherited decision source and does not alter its decision, rationale, alternatives, or consequences.
2. **Given** architecture content includes components, interactions, deployment, trust boundaries, or capabilities, **When** a future implementation consumes it, **Then** the record provides guidance only and does not create implementation artifacts or authorize implementation.
3. **Given** upstream Request, Discovery, ADR, Profile, Objective, Control, or NFR records exist, **When** architecture creation succeeds or fails, **Then** their existing bytes and ownership remain unchanged.
4. **Given** successful creation, **When** the completion response is returned, **Then** it identifies the Architecture ID, ADR ID, record path, catalog path, and traceability from upstream request/discovery/ADR evidence when available.

### User Story 3 - Produce deterministic, atomic architecture records (Priority: P1)

As a repository maintainer, I want architecture identifiers, records, and catalog updates to follow existing Highway persistence rules so that retries are safe, outputs are reproducible, and failures do not leave partial architecture state.

**Why this priority**: Deterministic allocation and atomic persistence are required for the architecture skill to belong to the existing Highway workflow family.

**Independent Test**: Run valid, duplicate, malformed, missing, ambiguous, invalid-catalog, allocation-conflict, validation-failure, and write-failure fixtures; compare pre-operation and post-operation bytes and repeat valid generation with identical inputs.

**Acceptance Scenarios**:

1. **Given** identical closed inputs and catalog state, **When** architecture generation is repeated, **Then** architecture content, ordering, identifiers, and catalog results are deterministic and contain no volatile metadata.
2. **Given** a catalog with a next identifier, **When** creation succeeds, **Then** allocation uses the next permanent `ARCHXXXXXX` identifier, advances the catalog exactly once, and never reuses an identifier.
3. **Given** an architecture already exists for the supplied ADR, **When** creation is attempted again, **Then** the workflow aborts without creating a duplicate or changing the existing architecture or catalog.
4. **Given** missing, malformed, ambiguous, non-accepted, or multiply resolved ADR input, **When** creation is attempted, **Then** it aborts before writing architecture or catalog output.
5. **Given** validation, allocation, or persistence failure, **When** creation aborts, **Then** all pre-operation architecture, catalog, ADR, and governance bytes remain unchanged and no partial record is left behind.

### Edge Cases

- No ADR identifier is supplied, more than one is supplied, or the identifier does not match the exact `ADRXXXXXX` form.
- The ADR identifier resolves to no record, multiple records, a malformed record, or an ADR whose status is not `accepted`.
- The ADR catalog is missing, malformed, internally inconsistent, or has an invalid next identifier.
- An architecture already exists for the ADR, including an existing record not listed consistently in the catalog.
- Optional Profile, Objectives, Controls, or NFR inputs are absent or blocked; missing optional evidence is omitted, while malformed or internally inconsistent optional evidence aborts creation without writes.
- The ADR contains absent or empty constraints, consequences, alternatives, traceability, or Reference Architecture direction; the architecture records an explicit `None`, empty set, or assumption rather than inventing facts.
- Multiple components, relationships, capabilities, assumptions, or risks have equal precedence; output ordering uses stable repository identifiers and deterministic title ordering.
- A catalog allocation conflict persists through the existing retry limit, or a write fails after validation; no partial architecture or catalog output remains.
- Required Architecture sections are incomplete, contain implementation authorization, or introduce a decision not present in the ADR; validation fails before persistence.
- Sensitive or environment-specific values appear in source inputs; the generated architecture excludes volatile session, environment, timestamp, and random values.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The workflow MUST be invocable as `/highway-architecture ADRXXXXXX` and MUST require exactly one explicit ADR identifier.
- **FR-002**: The workflow MUST accept only an identifier matching `ADR` followed by exactly six digits and MUST reject missing, extra, malformed, or ambiguous identifiers before resolution.
- **FR-003**: The workflow MUST resolve exactly one ADR record through the authoritative ADR catalog and MUST abort when the catalog or resolved record is missing, duplicated, malformed, or inconsistent.
- **FR-004**: The workflow MUST require the resolved ADR status to be `accepted` and MUST abort without writes for `proposed`, `rejected`, `superseded`, or any unknown status.
- **FR-005**: The workflow MUST preserve ADR ownership of decision, rationale, alternatives, consequences, and authorization to proceed to Reference Architecture.
- **FR-006**: The workflow MUST NOT modify ADR, Discovery, Request, Profile, Objective, Control, or NFR records or their catalogs.
- **FR-007**: The workflow MUST consume optional Profile, Objectives, Controls, and NFRs as advisory context only, MUST preserve their ownership and source bytes, MUST continue when a supplied optional input is blocked while recording that condition as an architecture risk, and MUST abort without writes when any supplied optional input is malformed or internally inconsistent.
- **FR-008**: The workflow MUST create one Reference Architecture record for one accepted ADR and MUST reject duplicate architecture creation for the same ADR.
- **FR-009**: Each architecture identifier MUST use the format `ARCH` followed by exactly six digits and MUST be allocated from the authoritative architecture catalog.
- **FR-010**: Architecture identifiers MUST be permanent, deterministic, never reused, and allocated using the existing Highway catalog allocation and bounded-retry rules.
- **FR-011**: A successful creation MUST write exactly one architecture record at `architectures/ARCHXXXXXX.md` and exactly one corresponding entry in `architectures/architectures.md`.
- **FR-012**: The architecture catalog MUST advance exactly once per successful creation and MUST resolve directly to the generated record.
- **FR-013**: The generated record MUST use status `proposed` on initial creation and MUST reference the source ADR identifier.
- **FR-014**: Every successful architecture record MUST contain sections for ADR Reference, Context, Architecture Summary, Architecture Style, Logical Components, Interaction Model, Trust Boundaries, Deployment Pattern, Key Technologies, Architecture Decisions Inherited, Constraints, Objective Relationships, Control Relationships, NFR Relationships, Required Capabilities, Assumptions, Risks, Reference Implementation Guidance, and Traceability.
- **FR-015**: Logical Components MUST identify major conceptual building blocks and their purposes without prescribing implementation artifacts.
- **FR-016**: The Interaction Model MUST describe conceptual communication or collaboration between components without becoming an implementation design.
- **FR-017**: Trust Boundaries MUST identify relevant security, ownership, or responsibility boundaries implied by the ADR and available governance evidence.
- **FR-018**: Deployment Pattern MUST describe a conceptual deployment approach, such as cloud-hosted, hybrid, event-driven, or another ADR-supported pattern, without generating deployment artifacts.
- **FR-019**: Required Capabilities MUST list advisory capabilities implied by the architecture and MUST NOT create capability artifacts or capability identifiers.
- **FR-020**: Assumptions MUST identify architecture assumptions that are not established as accepted ADR decisions or authoritative governance facts.
- **FR-021**: Risks MUST identify architecture risks, including unresolved constraints or source limitations, without changing upstream risk ownership.
- **FR-022**: Reference Implementation Guidance MUST describe future implementation concerns and handoff guidance while explicitly excluding implementation generation and implementation authorization.
- **FR-023**: Constraints MUST preserve applicable constraints inherited from ADR, Controls, and NFRs and MUST identify their source relationships.
- **FR-024**: Objective, Control, and NFR relationships MUST reference existing identifiers only, preserve source ownership, and use deterministic ordering.
- **FR-025**: Traceability MUST preserve available Request, Discovery, ADR, and Architecture identifiers and MUST represent unavailable upstream identifiers explicitly rather than inventing them.
- **FR-026**: Architecture generation MUST derive content primarily from ADR Context, Decision, Consequences, Constraints, and available governance relationships, with no unsupported architectural decisions presented as inherited facts.
- **FR-027**: The workflow MUST NOT select ADR alternatives, change the ADR decision, approve an implementation, or create a Reference Implementation.
- **FR-028**: The workflow MUST exclude timestamps, creation dates, modification dates, environment identifiers, random values, and user-session identifiers from generated architecture content and catalog semantics.
- **FR-029**: Identical valid inputs MUST produce byte-identical architecture content, stable section ordering, stable relationship ordering, stable capability ordering, and the same catalog result.
- **FR-030**: Missing or blocked optional Profile, Objectives, Controls, or NFRs MUST NOT prevent architecture creation when the accepted ADR is otherwise valid; absence MUST be represented without fabricated evidence, blocked status MUST be represented as an architecture risk, and malformed or internally inconsistent supplied optional inputs MUST prevent creation without writes.
- **FR-031**: Malformed required ADR or catalog input, invalid catalog state, duplicate architecture, validation failure, allocation failure after the retry limit, and write failure MUST abort without partial writes.
- **FR-032**: Before persistence, the workflow MUST validate required identifiers, status, required sections, ownership boundaries, traceability, deterministic ordering, and absence of implementation authorization.
- **FR-033**: Persistence MUST be atomic across the architecture record and architecture catalog, preserving all existing bytes if either write fails.
- **FR-034**: The completion response MUST report `Reference Architecture Created`, the Architecture Identifier, ADR Identifier, record path, catalog path, and available traceability chain.
- **FR-035**: The architecture workflow MUST remain scoped to the MVP handoff from ADR to Reference Architecture and MUST defer capability artifacts, lifecycle activities, diagrams, threat models, implementation generation, brownfield onboarding, architecture scoring, and Reference Implementation generation.

### Key Entities *(include if feature involves data)*

- **Accepted ADR**: The single authoritative decision input containing decision, rationale, alternatives, consequences, constraints, and architecture direction.
- **Reference Architecture**: The conceptual architecture record identified by `ARCHXXXXXX`, containing reusable architectural knowledge and a future implementation handoff.
- **Architecture Catalog**: The authoritative allocation and index record for Reference Architecture identifiers and record references.
- **Architecture Component**: A conceptual building block with a purpose and relationships to other components.
- **Architecture Relationship**: A traceable Objective, Control, or NFR relationship that informs the architecture without transferring ownership.
- **Required Capability**: An advisory capability candidate implied by the architecture, not a capability artifact.
- **Architecture Assumption**: A bounded premise used to explain the architecture that is not an accepted decision or source fact.
- **Architecture Risk**: A concern or uncertainty affecting the architecture or future implementation handoff.
- **Reference Implementation Guidance**: Conceptual guidance for a future implementation owner that does not authorize or generate implementation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of valid creation attempts consume exactly one accepted ADR and produce exactly one `ARCHXXXXXX` record with one catalog entry.
- **SC-002**: 100% of successful architecture records contain all 19 required sections, a valid ADR reference, and available traceability identifiers.
- **SC-003**: 100% of invalid, missing, ambiguous, duplicate, malformed, non-accepted, or failed creation attempts preserve all pre-operation architecture, catalog, ADR, and governance bytes.
- **SC-004**: 100% of repeated runs with identical valid inputs produce byte-identical architecture content, deterministic ordering, and no volatile metadata.
- **SC-005**: 100% of successful catalog updates advance exactly once, allocate a permanent identifier, and directly resolve to the generated record.
- **SC-006**: 100% of generated architectures preserve ADR decision ownership and contain no implementation artifacts or implementation authorization.
- **SC-007**: At least 95% of representative ADR consumers can identify the architecture summary, major components, interactions, deployment pattern, trust boundaries, required capabilities, risks, and implementation handoff without reconstructing the ADR analysis.
- **SC-008**: 100% of optional-input fixtures demonstrate that missing optional governance evidence does not block a valid architecture and does not produce fabricated relationships.
- **SC-009**: 100% of failure fixtures demonstrate no partial architecture record, no partial catalog update, and unchanged upstream source bytes.
- **SC-010**: 100% of deferred-scope checks confirm that capability artifacts, diagrams, threat models, implementation generation, scoring, and downstream Reference Implementation outputs are not created by the MVP.

## Assumptions

- The existing ADR workflow and ADR catalog provide authoritative resolution, accepted status, decision content, and traceability vocabulary.
- Existing Highway catalog allocation, atomic persistence, deterministic serialization, generated-adapter, and validation patterns are available for reuse.
- A missing optional Profile, Objective, Control, or NFR is permitted; malformed or internally inconsistent supplied optional governance input, required ADR input, or catalog input is fatal.
- The initial architecture status is `proposed`; future architecture lifecycle transitions are outside this feature.
- Architecture content is conceptual and advisory; Reference Implementation remains a future owner.
- The architecture catalog is the sole owner of `ARCHXXXXXX` allocation state and is not hand-edited by users.
- When upstream Request or Discovery identifiers are unavailable through the accepted ADR, the architecture records the available traceability and does not invent missing identifiers.
- Deterministic ordering uses stable identifiers first and normalized titles or names as a secondary ordering rule where needed.
- No new external service, runtime dependency, capability artifact type, or implementation generator is required for this MVP.
- The supplied Shopify booking example is illustrative only; the workflow must not hard-code domain-specific components or capabilities.
