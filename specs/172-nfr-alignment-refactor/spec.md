# Feature Specification: NFR Alignment Refactor

**Feature Branch**: `172-nfr-alignment-refactor`

**Created**: 2026-10-14

**Status**: Draft

**Input**: User description: "Align NFRs structurally and behaviorally with Objectives and Controls through recommendation exploration, queue construction, proposal-first development, acceptance, capture, portfolio assessment, and continuation while preserving NFR ownership and Control-to-NFR relationship mapping."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Explore grounded NFR recommendations (Priority: P1)

As a person defining operational expectations, I want to receive and request additional grounded NFR recommendations before development begins so that I can understand the available options before selecting work for the active queue.

**Why this priority**: Recommendation exploration is the primary new behavior and establishes the recommendation-first experience.

**Independent Test**: Start NFR setup with accepted context, request additional suggestions, and verify that recommendations are presented as provisional choices without creating NFR records or beginning proposal development.

**Acceptance Scenarios**:

1. **Given** accepted Profile, Objective, Control, or NFR context supports useful operational expectations, **When** NFR setup begins, **Then** the owner presents recommendations before requiring the person to invent an NFR.
2. **Given** a person asks for additional suggestions, **When** more grounded recommendations are available, **Then** the owner presents them without exposing internal coverage areas or treating them as accepted NFRs.
3. **Given** a person requests more suggestions after meaningful recommendation coverage is exhausted, **When** no useful grounded recommendation remains, **Then** the owner explains that no further useful recommendation is available without manufacturing one.

---

### User Story 2 - Construct and process an NFR queue (Priority: P1)

As a person managing several operational expectations, I want to select one, several, or all recommendations into an ordered queue so that each NFR can be developed and reviewed without accidental capture.

**Why this priority**: Queue construction separates recommendation selection from development and is the central workflow boundary of the refactor.

**Independent Test**: Select multiple recommendations, add later recommendations, explicitly begin processing, and verify that queue membership remains distinct from proposal, acceptance, and capture.

**Acceptance Scenarios**:

1. **Given** a recommendation set is presented, **When** the person selects one, several, or all recommendations, **Then** the selected items enter the active NFR queue in the selected order and no NFR is captured.
2. **Given** the person requests additional recommendations before processing, **When** new items are selected, **Then** they are appended in order without changing existing queue membership.
3. **Given** the person says “Start with these,” “Process the queue,” “Capture the queue,” or “Let’s review them,” **When** the owner recognizes explicit queue-processing intent, **Then** recommendation exploration ends and queue processing begins.
4. **Given** recommendation exploration has no useful grounded recommendations remaining, **When** the person has not explicitly started processing, **Then** the owner begins queue processing or asks for a user-provided NFR without capturing anything implicitly.

---

### User Story 3 - Develop and capture NFRs through a proposal lifecycle (Priority: P1)

As a person adopting an operational expectation, I want each queued or user-provided NFR to become a converged proposal before acceptance and capture so that persistence reflects an explicit decision.

**Why this priority**: Proposal-first development preserves user authority and aligns NFR behavior with the established Objectives and Controls owner framework.

**Independent Test**: Process a queued recommendation and a user-provided NFR through proposal presentation, correction or replacement, acceptance, capture, and continuation.

**Acceptance Scenarios**:

1. **Given** a queued recommendation or user-provided NFR is ready for development, **When** the owner processes it, **Then** the owner presents a converged proposal containing title, statement, and why it matters before capture.
2. **Given** the person corrects, replaces, rejects, or accepts a proposal, **When** the owner responds, **Then** only an accepted proposal can proceed to capture and rejected or abandoned proposals remain transient.
3. **Given** an NFR is captured, **When** more queued NFRs remain, **Then** the owner processes the next queued NFR without requiring a new recommendation-exploration phase.
4. **Given** the person provides an NFR directly, **When** it is complete enough to develop, **Then** it enters the same proposal, acceptance, capture, and continuation lifecycle as a selected recommendation.

---

### User Story 4 - Assess the NFR portfolio without blocking ownership (Priority: P2)

As a person maintaining operational expectations, I want concise portfolio observations about coverage, overlap, duplication, dependencies, gaps, tensions, and operational implications so that I can improve the portfolio without losing decision authority.

**Why this priority**: Portfolio awareness completes the shared owner architecture while keeping assessment advisory.

**Independent Test**: Capture multiple NFRs with different coverage characteristics and verify that the owner can provide an advisory synthesis without rejecting, blocking, or mutating accepted NFRs.

**Acceptance Scenarios**:

1. **Given** multiple NFRs are accepted, **When** portfolio assessment is useful, **Then** the owner may describe strengths, gaps, overlap, duplication, dependencies, tensions, or operational implications concisely.
2. **Given** a portfolio assessment is presented, **When** the person continues collection, **Then** the assessment does not create a lifecycle stage, durable portfolio artifact, or acceptance requirement.
3. **Given** additional grounded recommendations remain after queue processing, **When** the owner offers continuation, **Then** the person can request more suggestions or establish another NFR.

---

### User Story 5 - Preserve NFR ownership and Control relationships (Priority: P1)

As a repository maintainer, I want NFR ownership, records, identifiers, readiness, destructive safeguards, and Control-to-NFR relationships preserved while the interaction model changes so that the refactor does not alter governance ownership.

**Why this priority**: The alignment must improve workflow consistency without weakening the NFR owner or its relationship contract with Controls.

**Independent Test**: Inspect NFR inputs, outputs, readiness, persistence, destructive workflows, relationship fields, generated artifacts, and validation checks after the refactor.

**Acceptance Scenarios**:

1. **Given** an NFR baseline exists, **When** readiness or read-only inspection runs, **Then** it reports NFR state without requiring queue state or a Control-originated candidate.
2. **Given** an accepted Control can inform NFR recommendations, **When** NFR recommendations are generated, **Then** the Control is treated as recommendation context and selected items remain provisional until accepted and captured.
3. **Given** an NFR is captured or updated, **When** relationships are persisted, **Then** the existing Control relationship mapping and NFR ownership remain intact.
4. **Given** an NFR is removed or reset, **When** destructive safeguards run, **Then** explicit confirmation and existing baseline invariants remain enforced.

## Edge Cases

- No accepted context supports a useful recommendation; the owner begins exploratory discussion without inventing an NFR.
- Recommendations are exhausted before the person explicitly starts queue processing; the owner offers the queue-processing boundary without implicit capture.
- The person selects recommendations, then corrects or abandons a proposal; queue membership remains separate from persistence and abandoned work writes nothing.
- A person provides a complete NFR while recommendations are still visible; the user-provided NFR remains available and enters the normal development lifecycle.
- Additional recommendations overlap with accepted NFRs or each other; the owner identifies duplicates or overlap without silently merging, deleting, or capturing records.
- An accepted Control is unavailable while NFR work continues; NFR ownership remains independently usable and does not require Control-derived candidate state.
- The NFR queue is empty after capture; the owner provides portfolio synthesis and continuation support without creating a new lifecycle stage.
- A malformed NFR record, catalog, allocation state, or relationship mapping is encountered; readiness and mutation behavior remain blocked or non-writing according to existing safeguards.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The NFR owner MUST present grounded recommendations before requiring user invention when accepted Profile, Objective, Control, or NFR context supports useful operational expectations.
- **FR-002**: The NFR owner MUST maintain internal coverage areas for recommendation diversity, including Reliability, Availability, Performance, Scalability, Security, Compliance, Maintainability, and Operability.
- **FR-003**: Coverage areas MUST remain internal recommendation guidance and MUST NOT be user-visible, persisted, treated as classification, or create readiness requirements.
- **FR-004**: The NFR owner MUST treat accepted Controls as an important recommendation source while preserving Control ownership and existing Control-to-NFR relationship mapping.
- **FR-005**: Recommendations derived from accepted context or Controls MUST remain Working Ideas until selected, modified, or replaced by the person and processed through the NFR development lifecycle.
- **FR-006**: The NFR owner MUST allow recommendation exploration to continue through additional suggestions until useful grounded recommendations are exhausted, the person provides an NFR, or the person explicitly begins queue processing.
- **FR-007**: The NFR owner MUST allow a person to select one, several, or all recommendations, skip recommendations, provide a user-authored NFR, or request additional suggestions.
- **FR-008**: Selected recommendations MUST enter an ordered active NFR queue immediately, while queue membership MUST remain distinct from development, acceptance, capture, and persistence.
- **FR-009**: Explicit queue-processing intent MUST end recommendation exploration and begin sequential queue processing without implicitly capturing any NFR.
- **FR-010**: Each queued recommendation or user-provided NFR MUST follow a proposal-first lifecycle of converged proposal, acceptance, capture, and next-NFR continuation.
- **FR-011**: A converged NFR proposal MUST contain a title, operational expectation statement, and rationale explaining why it matters.
- **FR-012**: Corrections, replacements, rejections, cancellations, abandonments, and interruptions MUST preserve user authority and MUST NOT persist an unaccepted proposal.
- **FR-013**: After queue processing is exhausted, the owner MUST provide advisory portfolio synthesis and make additional suggestions or another NFR available without creating a new lifecycle stage.
- **FR-014**: Portfolio assessment MUST remain advisory and MUST NOT reject NFRs, force completion, block additional NFRs, mutate the baseline, or replace the person's authority.
- **FR-015**: The NFR owner MUST preserve NFR records, identifiers, catalog, readiness ownership, duplicate handling, overlap handling, destructive safeguards, and independent NFR ownership.
- **FR-016**: The NFR owner MUST preserve the `controls` relationship field and Control-to-NFR relationship ownership while changing only recommendation and development flow.
- **FR-017**: The refactor MUST NOT introduce a Control-derived NFR candidate state, candidate lifecycle, candidate artifact, or automatic candidate persistence path.
- **FR-018**: Readiness, read-only workflows, mutations, verification, and error handling MUST remain usable without pending recommendation candidates or Control-originated candidate state.
- **FR-019**: Generated adapters, catalogs, manifests, and instructions MUST remain synchronized with the authoritative NFR skill after the refactor.
- **FR-020**: Existing NFR records and accepted relationships MUST NOT be silently rewritten solely because the interaction model is aligned.

### Key Entities

- **NFR Owner**: The authoritative owner of NFR recommendation exploration, queue processing, proposal development, acceptance, capture, persistence, readiness, and continuation.
- **NFR Recommendation**: A provisional operational expectation suggested from accepted context, including accepted Controls, that has not yet been selected and accepted.
- **NFR Queue**: An ordered, active set of selected recommendations awaiting sequential proposal development; queue membership is not persistence.
- **Converged NFR Proposal**: A transient title, statement, and rationale presented for correction, replacement, rejection, or acceptance before capture.
- **NFR Record**: A persisted, user-accepted operational expectation with its stable identifier, relationships, and retained record fields.
- **NFR Portfolio**: The accepted set of NFR records assessed for coverage, overlap, duplication, dependencies, gaps, tensions, and operational implications.
- **NFR Coverage Area**: An internal recommendation-diversity guide that is never user-visible or persisted.
- **Control-to-NFR Relationship**: The retained relationship mapping through which accepted Controls inform NFR recommendations and accepted NFR records preserve Control references.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of representative setup scenarios with useful accepted context, the owner presents at least one grounded recommendation before asking the person to invent an NFR.
- **SC-002**: In 100% of queue scenarios, selecting recommendations creates ordered queue membership without creating an NFR record before proposal acceptance and capture.
- **SC-003**: In 100% of representative NFR development scenarios, each persisted NFR has passed through a converged proposal and explicit acceptance boundary.
- **SC-004**: In 100% of representative multi-NFR scenarios, the owner provides portfolio synthesis or continuation support without blocking, rejecting, or silently mutating accepted NFRs.
- **SC-005**: 100% of existing NFR readiness, duplicate, overlap, destructive, relationship, and persistence safeguards continue to pass after the alignment.
- **SC-006**: Repository validation reports zero Control-derived candidate-state dependencies across NFR workflow, readiness, verification, error handling, catalogs, manifests, and generated artifacts.
- **SC-007**: At least 90% of maintainers reviewing the NFR owner flow can identify recommendation exploration, queue construction, proposal development, acceptance, capture, portfolio assessment, and continuation as distinct boundaries without additional explanation.

## Assumptions

- The current NFR records, identifiers, catalog, readiness behavior, relationship mapping, and destructive safeguards are authoritative and remain in scope.
- Accepted Controls are a recommendation source, not an NFR owner and not an automatic capture mechanism.
- Internal NFR coverage areas guide recommendation diversity but are not exposed or persisted.
- Recommendation exploration ends only through grounded recommendation exhaustion, a user-provided NFR, or explicit queue-processing intent.
- Existing shared Experience Standard and Constitution requirements continue to apply without being redefined by this feature.
- Generated artifacts remain derived from authoritative skill sources and are regenerated after source changes.
- No new retained NFR field, candidate-state artifact, runtime dependency, or candidate lifecycle is introduced.
