# Feature Specification: Unified Recommendation Exploration Refactor

**Feature Branch**: `173-unified-recommendation-exploration-refactor`

**Created**: 2026-10-14

**Status**: Draft

**Input**: User description: Align the highway-objectives and highway-controls owner contracts with the established NFR recommendation-exploration model, including recommendation lineage, queue construction, exhaustion, explicit queue-start behavior, proposal and acceptance boundaries, and continuation semantics.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Explore and Queue Objective Recommendations (Priority: P1)

As a person configuring Objectives, I want to explore multiple grounded recommendation sets and select recommendations into an active queue without starting processing prematurely, so that I can shape the Objective work before proposals are developed.

**Why this priority**: This establishes the central behavior change and prevents selection from being mistaken for processing or capture.

**Independent Test**: Present several Objective recommendations, select some, request another set, and verify that the active queue grows while exploration remains active and no proposal processing has started.

**Acceptance Scenarios**:

1. **Given** Objective recommendations are presented, **When** the person selects one or more recommendations, **Then** the selected recommendations are added to the active Objective queue and exploration remains active.
2. **Given** recommendations remain under evaluation, **When** the person selects additional recommendations, **Then** the active queue expands and queue processing does not begin from selection alone.
3. **Given** recommendation exploration is exhausted, **When** the person has not explicitly started processing, **Then** the owner can recognize exhaustion without silently capturing or processing an Objective.

### User Story 2 - Explore and Queue Control Recommendations (Priority: P1)

As a person configuring Controls, I want accepted Objectives to inform Control recommendations while retaining independent Control ownership, so that recommendations are grounded without creating Controls automatically.

**Why this priority**: Controls are the second owner in the lineage and must preserve the same recommendation-exploration and acceptance boundaries as Objectives and NFRs.

**Independent Test**: Present Control recommendations grounded in accepted Objectives, select several, request additional recommendations, and verify that the queue grows without automatic Control creation, ownership transfer, or processing.

**Acceptance Scenarios**:

1. **Given** accepted Objectives are available as context, **When** Control recommendations are generated, **Then** the recommendations identify Objective influence without treating Objectives as Control records.
2. **Given** Control recommendations are selected, **When** exploration continues, **Then** selected recommendations enter the active Control queue and remain unprocessed Working Ideas.
3. **Given** a person provides a complete Control directly, **When** the owner develops it, **Then** it follows the normal proposal and acceptance path and does not silently process the recommendation queue.

### User Story 3 - Start Processing Only at the Defined Boundary (Priority: P1)

As a person using Objective or Control setup, I want queue processing to begin only after recommendation exhaustion or an explicit queue-processing request, so that proposal development and capture occur at a predictable point.

**Why this priority**: A single, visible start condition is necessary for consistent behavior across both owners and for preserving the existing proposal, acceptance, and capture boundaries.

**Independent Test**: Exercise both exhaustion and explicit-start conversations, then verify that processing begins only at one of those boundaries and remains closed to new recommendation generation until processing completes.

**Acceptance Scenarios**:

1. **Given** recommendation exploration is active, **When** the person says "Process the queue," "Let's start with these," "Review the queue," or "Capture the queue," **Then** queue processing begins and exploration closes.
2. **Given** no useful grounded non-duplicate recommendation remains, **When** the owner determines recommendation exhaustion, **Then** queue processing may begin without requiring a separate recommendation selection event.
3. **Given** queue processing has begun, **When** the person requests additional recommendations, **Then** the owner does not return to recommendation generation until queue processing is complete.

### User Story 4 - Continue Collection Across Recommendation Sets (Priority: P2)

As a person completing setup or configuration, I want collection to continue across multiple recommendation sets before queue processing starts, so that a continue result does not force premature processing.

**Why this priority**: Setup continuity allows the person to build a useful queue over time while keeping collection completion separate from queue processing.

**Independent Test**: Complete one recommendation set, return a continuation result, provide another set, and verify that processing has not started solely because collection continued.

**Acceptance Scenarios**:

1. **Given** useful recommendation opportunities remain, **When** setup returns `Collection Result: Continue`, **Then** exploration may continue across another recommendation set.
2. **Given** collection continues, **When** no explicit queue-processing request has been made and exhaustion has not occurred, **Then** queue processing has not started.

### Edge Cases

- If remaining recommendations would duplicate existing coverage, overlap accepted artifacts, or restate queued recommendations, the owner treats recommendation exploration as exhausted rather than manufacturing more recommendations.
- Recommendations under evaluation are not queue members; only selected recommendations are eligible for processing.
- A user-provided Objective or Control follows the normal proposal and acceptance path and does not silently process the queue.
- Queue processing freezes recommendation exploration until processing is complete.
- An empty recommendation set does not create an Objective or Control implicitly.
- Collection continuation remains separate from readiness, capture, and completion evaluation.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Objectives owner MUST provide Profile-Informed Recommendations immediately after Recommendation Development and identify accepted Profile evidence as a source of Objective recommendations.
- **FR-002**: The Controls owner MUST provide Objective-Informed Recommendations immediately after Recommendation Development and identify accepted Objectives as a source of Control recommendations.
- **FR-003**: Objective and Control recommendation guidance MUST state that the upstream context participates in recommendation generation without creating downstream records or transferring ownership.
- **FR-004**: The Objectives and Controls owners MUST provide Recommendation Exploration after Recommendation Presentation and before Additional Suggestions.
- **FR-005**: Recommendation Exploration MUST distinguish recommendation exploration, queue construction, and queue processing as separate phases.
- **FR-006**: Queue processing MUST begin only when recommendation exploration is exhausted or the person explicitly requests queue processing.
- **FR-007**: Selecting recommendations MUST expand the active queue while allowing recommendation exploration to continue; selection alone MUST NOT begin queue processing, proposal development, or capture.
- **FR-008**: The owners MUST define recommendation exhaustion as the absence of useful grounded non-duplicate recommendations or the presence of remaining recommendations that primarily repeat coverage, overlap accepted artifacts, or restate queued recommendations.
- **FR-009**: Recommendation Exploration MUST define exit conditions for exhaustion, a user-provided Objective or Control, and an explicit queue-processing request.
- **FR-010**: Recommendations under evaluation MUST remain distinct from queue members, and only selected queue members MAY enter queue processing.
- **FR-011**: Once queue processing begins, recommendation exploration MUST remain closed until queue processing is complete.
- **FR-012**: Objective and Control queue boundaries MUST state that an active queue may continue growing during exploration, queue membership does not begin proposal development, and queue membership does not imply capture.
- **FR-013**: Objective and Control setup/configure workflows MUST present the phases Recommendation Exploration, Queue Construction, Recommendation Exhaustion or Explicit Queue Start, Queue Processing, Capture, and Completion Evaluation in that order.
- **FR-014**: Creation Workflow MUST reference the Recommendation Exploration contract as the authority for determining when queue processing begins.
- **FR-015**: Setup/configure collection MUST allow exploration across multiple recommendation sets, and `Collection Result: Continue` MUST NOT require queue processing to have started.
- **FR-016**: Objective and Control continuation examples MUST describe continued exploration while recommendations remain, queue processing after exhaustion or explicit start, continued queue processing while the queue remains, and portfolio assessment or continuation after the queue is exhausted.
- **FR-017**: Objective and Control recommendation examples MUST demonstrate that selection adds recommendations to the appropriate active queue while exploration remains active and processing has not started.
- **FR-018**: The refactor MUST preserve existing proposal, acceptance, capture, ownership, relationship, persistence, readiness, and destructive-action boundaries; it MUST NOT introduce candidate lifecycle or automatic downstream record creation.

### Key Entities *(include if feature involves data)*

- **Recommendation**: A grounded Working Idea offered for consideration from the owner’s accepted context.
- **Active Objective Queue**: The ordered set of Objective recommendations selected by the person for later processing.
- **Active Control Queue**: The ordered set of Control recommendations selected by the person for later processing.
- **Recommendation Exploration**: The phase in which recommendations are evaluated, selected, and expanded before queue processing begins.
- **Converged Proposal**: A developed Objective or Control proposal that must be explicitly accepted before capture.
- **Captured Objective or Control**: An accepted owner record created only after proposal development and explicit acceptance.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of reviewed Objective and Control setup flows, selecting recommendations alone leaves recommendation exploration active and queue processing unstarted.
- **SC-002**: In 100% of reviewed Objective and Control owner contracts, the queue-processing trigger is limited to recommendation exhaustion or an explicit queue-processing request.
- **SC-003**: In 100% of reviewed Objective and Control examples, selected recommendations are shown in the correct active queue before proposal development or capture.
- **SC-004**: Reviewers can identify the upstream recommendation source, downstream owner, and non-transfer of ownership for both Objective and Control lineage without relying on unstated behavior.
- **SC-005**: Setup/configure continuation supports at least two recommendation sets before processing while returning `Collection Result: Continue` without starting queue processing.
- **SC-006**: No reviewed flow creates an Objective or Control, assigns ownership, captures an item, or introduces candidate state solely because an upstream artifact or recommendation was accepted.

## Assumptions

- The established NFR recommendation-exploration model is the behavioral reference and does not require changes as part of this feature.
- Objectives remain independently owned records, and Controls remain independently owned records.
- Accepted Profile evidence is available as Objective recommendation context, and accepted Objectives are available as Control recommendation context when present.
- Existing identifiers, catalogs, relationships, readiness behavior, persistence rules, and destructive safeguards remain unchanged.
- The feature updates owner guidance, examples, and corresponding contract tests; it does not add a new user-facing capability area.
- `setup` and `configure` continue to use the existing collection result contract and explicit finish behavior.
