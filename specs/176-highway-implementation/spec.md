# Feature Specification: Highway Reference Implementation Workflow

**Feature Branch**: `176-highway-implementation`

**Created**: 2026-10-15

**Status**: Draft

**Input**: User description: "Design an MVP skill named `highway-implementation` that creates one Reference Implementation artifact from one accepted Reference Architecture and sits before planning, task generation, code generation, and self-service productization."

## Clarifications

### Session 2026-10-15

- Q: Should `highway-implementation` use the existing `ARCH######` identifier format from Feature 175 for Reference Architectures, or introduce the requested `RA######` format? → A: Use the existing canonical `ARCH######` format for Reference Architecture inputs and traceability.

## User Scenarios & Testing

### User Story 1 - Create a Reference Implementation (Priority: P1)

An architecture authority invokes `highway-implementation` with one accepted Reference Architecture identifier. The workflow resolves that architecture, preserves its ownership, and creates one implementation blueprint with a permanent `RI######` identifier and a direct implementation catalog entry.

**Why this priority**: This is the MVP handoff between conceptual architecture and downstream planning. Without it, implementation choices cannot be represented as a governed, traceable artifact.

**Independent Test**: Run the workflow against one valid accepted Reference Architecture and verify exactly one complete proposed Reference Implementation record, one catalog entry, and a traceability chain back to the architecture and upstream records.

**Acceptance Scenarios**:

1. **Given** one explicit identifier resolves to one accepted Reference Architecture and a valid implementation catalog, **When** the workflow runs, **Then** it creates exactly one `RI######` artifact and one direct catalog entry with the initial status `proposed`.
2. **Given** the Reference Architecture permits multiple realizations and deterministic evidence supports a technology choice, **When** the workflow creates the blueprint, **Then** the choice is recorded with its architecture intent and evidence.
3. **Given** the workflow completes successfully, **When** the user reviews the result, **Then** the response identifies the RI, source RA, record path, catalog path, and available REQ, DISC, ADR, RA, and RI traceability.

### User Story 2 - Realize Governance and Operational Expectations (Priority: P1)

An implementation owner uses the blueprint to understand how architecture components, Controls, NFRs, Objectives, and lifecycle activities can be realized without changing the source owners' records.

**Why this priority**: An implementation blueprint must be useful beyond a component mapping. It must carry safeguards, operational expectations, business relationships, lifecycle responsibilities, assumptions, risks, constraints, and dependencies into the next workflow.

**Independent Test**: Run the workflow with valid and blocked optional governance inputs, then verify that Controls and NFRs are represented as implementation realization, blocked evidence appears as risk, and every upstream source remains byte-identical.

**Acceptance Scenarios**:

1. **Given** valid Controls and NFRs are available, **When** the implementation is generated, **Then** the artifact maps them to security-control and operational realization requirements without changing their source records.
2. **Given** an optional governance source is blocked, **When** the workflow runs, **Then** it continues and records the source condition as an implementation risk.
3. **Given** the implementation blueprint includes lifecycle work, **When** the artifact is reviewed, **Then** it contains realization mappings for design, build, test, deploy, operate, monitor, and improve.

### User Story 3 - Preserve Determinism and Downstream Boundaries (Priority: P1)

A repository maintainer can repeat or reject implementation generation safely because input resolution, evidence precedence, identifier allocation, ordering, and failure behavior are deterministic and atomic.

**Why this priority**: The artifact becomes a durable handoff only when repeated runs are stable, failures leave no partial state, and the workflow cannot silently redesign architecture or jump ahead into planning or code generation.

**Independent Test**: Exercise missing, malformed, ambiguous, duplicate, non-accepted, allocation-conflict, validation-failure, and write-failure fixtures and compare all pre-operation bytes and repeated outputs.

**Acceptance Scenarios**:

1. **Given** identical declared inputs and catalog state, **When** the workflow runs more than once, **Then** implementation content, section ordering, traceability, and allocation behavior are byte-identical.
2. **Given** a missing or malformed Reference Architecture, **When** the workflow runs, **Then** it aborts without creating or modifying an implementation record or catalog entry.
3. **Given** validation or write failure occurs after input resolution, **When** the workflow stops, **Then** no partial output remains and every upstream artifact is unchanged.
4. **Given** a valid implementation blueprint exists, **When** downstream planning is considered, **Then** the artifact provides a clean handoff but does not create plans, tasks, executable code, infrastructure definitions, or deployment authorization.

### Edge Cases

- The invocation contains no identifier, more than one identifier, a lowercase identifier, or an identifier that cannot be resolved uniquely.
- The resolved Reference Architecture is missing, malformed, inconsistent, or not in the accepted state.
- An implementation already exists for the same Reference Architecture.
- The implementation catalog is missing, malformed, has an invalid next identifier, or changes during allocation.
- Optional Profile, Objective, Control, or NFR evidence is missing, blocked, malformed, or internally inconsistent.
- Clarification is `not-started`, `complete`, `in-progress`, `blocked`, or malformed; open findings must not block generation.
- Architecture permits no technology choice, permits several choices without deterministic evidence, or contains a component with no supported realization.
- A generated artifact would contain timestamps, environment metadata, random values, session identifiers, executable code, or an implementation decision not traceable to architecture intent.
- A record write succeeds while a catalog write fails, or the reverse.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST provide a skill named `highway-implementation` in the Highway skill namespace.
- **FR-002**: The skill MUST operate in the workflow position `REQ -> DISC -> ADR -> RA -> RI -> Plan -> Tasks -> Generated Code`.
- **FR-003**: The invocation MUST contain exactly one explicit uppercase `ARCH######` identifier.
- **FR-004**: The workflow MUST resolve the identifier through the authoritative Reference Architecture catalog and reject missing, ambiguous, duplicated, malformed, or non-accepted results without writes.
- **FR-005**: The workflow MUST consume the authoritative Reference Architecture record and preserve its architecture decisions, logical architecture, component model, interaction model, trust boundaries, rationale, and ownership.
- **FR-006**: The workflow MUST accept the implementation catalog and shared implementation output template as required inputs.
- **FR-007**: The workflow MUST treat optional `CLAR-ARCH######`, Profile, Objective, Control, and NFR inputs as read-only advisory evidence.
- **FR-008**: The workflow MUST resolve evidence in this order: Reference Architecture, `CLAR-ARCH######`, Objectives, Controls, NFRs, then Profile.
- **FR-009**: The workflow MUST continue without fabricated evidence when optional Profile, Objective, Control, or NFR input is missing.
- **FR-010**: The workflow MUST continue and record an implementation risk when optional evidence is blocked.
- **FR-011**: The workflow MUST abort without writes when optional evidence is malformed or internally inconsistent.
- **FR-012**: The workflow MUST consume resolved findings from complete Clarification and treat resolved findings plus open findings from in-progress Clarification as advisory context.
- **FR-013**: The workflow MUST continue for `not-started` Clarification, record blocked Clarification as risk, and never allow open findings to block implementation generation.
- **FR-014**: The workflow MUST abort or apply the declared architecture fallback without writes when Clarification is malformed.
- **FR-015**: The workflow MUST create exactly one `RI######` Reference Implementation artifact for one accepted Reference Architecture.
- **FR-016**: The initial Reference Implementation status MUST be `proposed`.
- **FR-017**: The workflow MUST create exactly one direct implementation catalog entry and advance the catalog identifier exactly once after successful publication.
- **FR-018**: The implementation artifact MUST contain Context, Implementation Summary, Technology Realization, Runtime Components, Deployment Topology, Environment Strategy, Data Realization, Integration Realization, Security Control Realization, NFR Realization, Lifecycle Activities, Assumptions, Risks, Constraints, Dependencies, and Traceability.
- **FR-019**: Technology Realization MUST translate architecture components into implementation components while preserving architecture intent.
- **FR-020**: The workflow MUST permit technology choices only when the architecture permits multiple realizations and deterministic implementation evidence supports the choice.
- **FR-021**: Every implementation technology choice MUST reference the architecture intent and supporting evidence.
- **FR-022**: Security Control Realization MUST map available Controls to implementation mechanisms such as encryption, secrets management, MFA, audit logging, or access control without changing Control ownership.
- **FR-023**: NFR Realization MUST map available NFRs to implementation requirements such as scalability, recovery, availability, and monitoring without changing NFR ownership.
- **FR-024**: Lifecycle Activities MUST include design, build, test, deploy, operate, monitor, and improve realization mappings.
- **FR-025**: Traceability MUST preserve available REQ, DISC, ADR, RA, Objective, Control, and NFR relationships.
- **FR-026**: The workflow MUST NOT modify Requests, Discovery records, ADRs, Reference Architectures, Objectives, Controls, NFRs, or Clarifications.
- **FR-027**: The workflow MUST NOT generate source code, infrastructure definitions, plans, tasks, deployment authorization, or self-service productization artifacts.
- **FR-028**: The workflow MUST NOT change architecture decisions, redesign the architecture, or select a different ADR option.
- **FR-029**: Identical declared inputs and catalog state MUST produce byte-identical implementation content, section ordering, traceability, and identifier allocation behavior.
- **FR-030**: Generated content MUST exclude timestamps, creation dates, modification dates, random values, environment metadata, and session identifiers.
- **FR-031**: Allocation conflicts MUST retry no more than three times before aborting without writes.
- **FR-032**: Validation MUST complete before persistence, and record/catalog publication MUST be atomic.
- **FR-033**: Any resolution, validation, allocation, duplicate, or write failure MUST preserve every pre-operation byte and leave no partial implementation output.
- **FR-034**: The completion response MUST identify the RI identifier, RA identifier, record path, catalog path, and available traceability chain.
- **FR-035**: Verification MUST confirm exactly one ARCH input, exactly one RI output, unchanged architecture bytes, architecture-traceable implementation decisions, realized Controls and NFRs, complete lifecycle activities, deterministic ordering, complete traceability, no executable code, and no deployment authorization.

### Key Entities

- **Accepted Reference Architecture**: The authoritative conceptual architecture identified by one `ARCH######`, including its decisions, components, interactions, trust boundaries, rationale, constraints, and traceability.
- **Optional Clarification Context**: Read-only clarification findings, responses, status, and resolution history associated with the Reference Architecture.
- **Implementation Context**: Optional Profile, Objective, Control, and NFR evidence used to ground realization, relationships, constraints, risks, and dependencies.
- **Reference Implementation**: The conceptual-to-realization blueprint identified by `RI######`, with proposed status, implementation choices, runtime and deployment realization, lifecycle activities, and traceability.
- **Implementation Catalog**: The authoritative allocation and direct index for Reference Implementation identifiers.
- **Technology Realization**: A traceable choice of implementation technologies or mechanisms that realizes an architecture intent.
- **Lifecycle Activity**: A realization mapping for design, build, test, deploy, operate, monitor, or improve.

## Success Criteria

### Measurable Outcomes

- **SC-001**: 100% of valid accepted Reference Architecture fixtures produce exactly one proposed RI artifact and exactly one catalog entry.
- **SC-002**: 100% of missing, ambiguous, malformed, duplicated, and non-accepted Reference Architecture fixtures abort without changing any pre-operation byte.
- **SC-003**: 100% of repeated runs with identical inputs and catalog state produce byte-identical RI content, ordering, traceability, and allocation results.
- **SC-004**: 100% of valid governance fixtures preserve source ownership while representing Controls, NFRs, Objectives, and Profile relationships in the implementation blueprint.
- **SC-005**: 100% of blocked optional-input fixtures continue and record the blocked condition as an implementation risk.
- **SC-006**: 100% of malformed optional-input, validation-failure, allocation-failure, and write-failure fixtures produce no partial RI or catalog output.
- **SC-007**: 100% of successful RI artifacts contain all required realization and lifecycle sections and a complete available REQ-to-RI traceability chain.
- **SC-008**: 100% of successful RI artifacts contain no executable source code, infrastructure definitions, plans, tasks, timestamps, session identifiers, or deployment authorization.

## Assumptions

- The Reference Architecture workflow has already produced a cataloged accepted architecture and remains the authoritative source for architecture intent.
- `ARCH######` and `RI######` are the canonical identifier forms exposed by this workflow and its catalogs.
- Implementation generation is conceptual and blueprint-oriented; later workflows own planning, task generation, code generation, deployment, and self-service productization.
- Optional governance and Clarification inputs are advisory and may be absent without preventing a valid architecture-to-implementation handoff.
- Deterministic implementation evidence may be repository knowledge or explicitly accepted implementation evidence available to the workflow; unsupported technology choices remain unknown rather than invented.
- Existing Highway templates, catalogs, validation conventions, and generated-surface workflows remain available.
