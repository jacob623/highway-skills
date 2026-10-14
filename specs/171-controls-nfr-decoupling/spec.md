# Feature Specification: Controls NFR Decoupling

**Feature Branch**: `171-controls-nfr-decoupling`

**Created**: 2026-10-14

**Status**: Draft

**Input**: User description: "Remove the Control-derived NFR candidate-generation model entirely and align Controls structurally and behaviorally with Objectives."

## Clarifications

### Session 2026-10-14

- Q: Should Feature 171 implement direct NFR recommendation and development now, or only remove the Control-derived candidate lifecycle and leave direct NFR recommendations as a follow-on? → A: Remove candidate generation only; direct NFR recommendations remain follow-on work.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Controls own only Control governance (Priority: P1)

As a person establishing repository safeguards, I want Controls to recommend, develop, accept, capture, and persist Controls without involving NFR candidate generation so that Control ownership is clear and the Control lifecycle is independent.

**Why this priority**: Removing the cross-owner candidate lifecycle is the central refactor and prevents Controls from carrying responsibilities that belong outside the Control owner.

**Independent Test**: Inspect and exercise Control recommendation, proposal, acceptance, capture, persistence, continuation, readiness, and error paths, then verify that none require an NFR candidate-generation state or result.

**Acceptance Scenarios**:

1. **Given** a person starts or continues Control collection, **When** recommendations or user-authored safeguards are developed, **Then** the workflow completes through Control acceptance and capture without invoking or consuming NFR candidate generation.
2. **Given** a Control is accepted and captured, **When** downstream collection continues, **Then** the Control owner reports only Control collection state and does not report candidate-generation progress, completion, blocking, or recovery.
3. **Given** Control persistence or validation fails, **When** the owner handles the failure, **Then** the failure preserves existing Control safeguards without creating or recovering NFR candidate state.
4. **Given** a user inspects Control readiness, **When** the readiness result is produced, **Then** it reflects persisted Control state only and contains no NFR candidate-generation status.

---

### User Story 2 - NFRs remain independent of Control candidate state (Priority: P1)

As a person managing non-functional requirements, I want the NFR owner to operate without generated candidate state supplied by Controls so that NFR decisions are not coupled to Control capture transactions.

**Why this priority**: Candidate state and lifecycle are the remaining structural dependency between the two owners and must be removed for the target Profile -> Objectives -> Controls -> NFRs model.

**Independent Test**: Inspect NFR inputs, outputs, workflow, ownership, verification, readiness, and error handling, then verify that NFR behavior has no dependency on Control-originated candidate state or lifecycle.

**Acceptance Scenarios**:

1. **Given** the NFR owner is invoked independently, **When** it loads context or begins NFR work, **Then** it does not require pending candidates, candidate recovery, candidate review, or an originating Control identifier.
2. **Given** existing candidate-state artifacts or references are absent, **When** NFR readiness and workflow behavior are evaluated, **Then** the owner remains internally coherent and does not report a missing candidate-state dependency.
3. **Given** a Control is captured, **When** NFR behavior is subsequently invoked, **Then** NFR work begins through the NFR owner's own recommendation and development path rather than an automatically generated Control-derived candidate.
4. **Given** a prior candidate-generation result or lifecycle state exists in historical context, **When** the refactored owner is used, **Then** it is ignored or removed from active ownership behavior and does not affect current readiness or completion claims.

---

### User Story 3 - Controls align structurally with Objectives (Priority: P2)

As a person using Highway governance owners, I want Controls to follow the same recommendation-first lifecycle as Objectives so that each owner is predictable: recommend, develop, capture, and continue collection.

**Why this priority**: Structural parallelism makes the ownership chain understandable and establishes the target interaction model after the NFR coupling is removed.

**Independent Test**: Compare the Controls and Objectives owner contracts and run representative collection flows to verify equivalent recommendation, proposal, acceptance, capture, continuation, and user-authored paths while preserving Control-specific semantics.

**Acceptance Scenarios**:

1. **Given** accepted context supports a useful safeguard, **When** Control collection begins, **Then** Controls recommends before asking unnecessary discovery questions and develops the selection into a proposal before capture.
2. **Given** a person corrects, replaces, rejects, or accepts a Control proposal, **When** the owner continues, **Then** the same acceptance boundary and user authority pattern applies without changing Control persistence or classification semantics.
3. **Given** a Control has been captured, **When** collection remains active, **Then** Controls provides concise continuation and recommendation support until explicit finish.
4. **Given** a person does not adopt a recommendation, **When** they provide their own safeguard, **Then** Controls keeps the user-authored path available and processes it through the same proposal and acceptance lifecycle.

---

### User Story 4 - Repository artifacts remain coherent after removal (Priority: P2)

As a repository maintainer, I want candidate-state artifacts, references, generated adapters, catalogs, and validation checks to agree with the refactored ownership model so that the distributed skill suite contains no stale coupling.

**Why this priority**: Removing an ownership concept without removing its references would leave contradictory contracts and fail the repository's source-first artifact guarantees.

**Independent Test**: Search the governed source and derived artifacts for candidate-generation concepts, regenerate distribution outputs, and run the complete validation suite with the candidate-state artifact absent.

**Acceptance Scenarios**:

1. **Given** the candidate-state artifact is removed, **When** catalogs, manifests, adapters, and documentation are regenerated or validated, **Then** no orphaned entry or stale reference remains.
2. **Given** Controls, NFRs, and Setup are inspected, **When** ownership and workflow are described, **Then** no component claims candidate-generation ownership, recovery, blocking, or completion.
3. **Given** existing Control persistence and NFR behavior tests are run, **When** the full suite completes, **Then** preserved behaviors pass and the refactor is covered by explicit decoupling checks.

## Edge Cases

- A Control is captured while the NFR owner is unavailable; Control capture must remain governed by the Control owner and must not create a blocked candidate-generation state.
- A repository contains stale candidate-state files or references from an earlier version; validation must identify and remove or reconcile them rather than silently preserving contradictory ownership.
- An NFR workflow is invoked before any Control exists; it must not require a Control-originated candidate or Control identifier.
- A person requests additional Control recommendations after capture; continuation must remain available without candidate review or candidate completion language.
- A Control-derived NFR relationship exists in retained historical data; removal of the candidate-generation model must not silently mutate unrelated accepted Control or NFR records.
- A generated adapter or catalog remains stale after source changes; correspondence validation must fail until regeneration is complete.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Controls MUST own Control recommendation, development, acceptance, capture, persistence, readiness, and continuation behavior without owning NFR generation.
- **FR-002**: Controls MUST NOT invoke, consume, or report an NFR candidate-generation action, result, lifecycle, ownership boundary, blocking reason, recovery path, or completion state.
- **FR-003**: Controls MUST NOT require an originating Control identifier as input to any NFR candidate-generation contract.
- **FR-004**: The NFR owner MUST NOT require Control-originated candidate state, pending candidates, candidate recovery, candidate review, candidate completion, or candidate-generation results for its inputs, outputs, readiness, workflow, verification, or error handling.
- **FR-005**: The repository MUST remove the dedicated NFR candidate-state artifact and MUST NOT retain catalog, ownership, setup, verification, readiness, workflow, or error-handling references that depend on it.
- **FR-006**: NFR behavior MUST remain independently invocable without a persisted Control candidate or candidate-generation result.
- **FR-007**: Controls MUST retain the proposal-first interaction model established by Objectives, including recommendations, development, explicit acceptance, capture, user-authored alternatives, and continued collection.
- **FR-008**: Control selection MUST remain distinct from Control acceptance and capture, and removal of NFR candidate generation MUST NOT change that boundary.
- **FR-009**: Controls MUST preserve existing Control ownership, persistence, classification, relationship, readiness, and user-authority behavior except for removing NFR candidate-generation coupling.
- **FR-010**: This feature MUST remove the Control-derived candidate dependency without implementing direct NFR recommendation and development; direct NFR recommendation and development remains a follow-on feature.
- **FR-011**: Generated adapters, catalogs, manifests, and distributed instructions MUST remain synchronized with their authoritative sources after the refactor.
- **FR-012**: Validation MUST include explicit checks that candidate-generation concepts and candidate-state references are absent from the governed ownership surfaces.
- **FR-013**: Existing Control and NFR retained records MUST NOT be silently rewritten solely because candidate-generation ownership is removed.
- **FR-014**: The refactor MUST preserve the target ownership sequence: Profile, then Objectives, then Controls, then NFRs, with each owner responsible for its own recommendation, development, capture, and continuation lifecycle.

### Key Entities

- **Control Owner**: The authoritative owner of Control recommendation, development, acceptance, capture, persistence, readiness, and collection continuation.
- **NFR Owner**: The authoritative owner of NFR recommendation, development, acceptance, capture, persistence, readiness, and collection continuation, independent of Control candidate state.
- **Control Candidate State**: The obsolete transient or retained state representing NFR candidates derived from Controls; removed by this feature.
- **Candidate-State Artifact**: The obsolete repository artifact that stores or describes NFR candidate-generation lifecycle state; removed by this feature.
- **Governance Ownership Chain**: The ordered relationship Profile -> Objectives -> Controls -> NFRs, where each owner retains its own lifecycle responsibilities.
- **Generated Skill Artifact**: A distributed adapter, catalog, manifest, or instruction artifact derived from an authoritative source and required to remain correspondent after source changes.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of Control collection, capture, readiness, continuation, and failure-path validation scenarios complete without an NFR candidate-generation action, result, or lifecycle state.
- **SC-002**: 100% of NFR readiness and workflow validation scenarios pass with the candidate-state artifact and Control-originated candidate input absent.
- **SC-003**: Repository-wide validation reports zero stale candidate-state references across governed ownership, workflow, verification, readiness, error-handling, catalog, and generated artifact surfaces.
- **SC-004**: 100% of representative Controls and Objectives collection scenarios distinguish recommendation, development, acceptance, capture, and continuation as separate steps.
- **SC-005**: 100% of retained Control and NFR records remain unchanged unless an independent user-authorized mutation is requested.
- **SC-006**: The complete repository test suite passes with zero failures after the refactor and artifact regeneration.
- **SC-007**: At least 90% of maintainers reviewing the ownership chain can identify Controls and NFRs as separate owners with no Control-derived NFR candidate dependency without additional explanation.

## Assumptions

- The existing Controls and Objectives interaction contracts remain the source for recommendation-first behavior; this feature does not redefine generic Experience Standard rules.
- Removing candidate generation does not require deleting accepted Control-derived NFR relationships already present in retained records; it removes the generation lifecycle and its ownership contract.
- Direct NFR recommendation and development is explicitly out of scope for this feature and remains a follow-on capability.
- Generated adapters, catalogs, manifests, and instructions remain derived artifacts and are regenerated from authoritative sources.
- No new runtime dependency, retained Control field, NFR field, or lifecycle state is introduced.
- The repository's existing executable and static contract tests are the validation mechanism for this refactor.
