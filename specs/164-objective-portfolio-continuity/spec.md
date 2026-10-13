# Feature Specification: Objective Portfolio Continuity

**Feature Branch**: `164-objective-portfolio-continuity`

**Created**: 2026-10-12

**Status**: Draft

**Input**: User description: "Improve continuity after Objective capture by allowing a concise advisory synthesis of the accepted Objective set before the next user-relevant activity."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Continue queued Objective development with portfolio context (Priority: P1)

As a person developing several selected Objectives, I want a brief acknowledgment of how the accepted Objective set is evolving before the next queued Objective is developed so that the transition feels intentional and understandable.

**Why this priority**: Queued Objective development is the primary continuity gap and affects the central multi-Objective workflow.

**Independent Test**: Inspect the queued Objective transition guidance and verify that after capture it allows a concise coverage synthesis, optionally identifies the next Objective, and proceeds without creating another review or proposal.

**Acceptance Scenarios**:

1. **Given** an Objective has been captured while an active queue remains, **When** the owner continues the workflow, **Then** the owner may briefly describe accepted Objective coverage before identifying the next Objective being developed.
2. **Given** the owner provides a queued transition synthesis, **When** the next Objective is developed, **Then** the synthesis remains advisory and does not create an additional acceptance or review cycle.
3. **Given** the accepted Objective set already covers several areas, **When** the next transition is presented, **Then** the owner avoids repeating the full contents of accepted Objectives.

### User Story 2 - Preserve continuity during active collection (Priority: P1)

As a person capturing Objectives during an active collection session, I want a concise synthesis of current coverage before the continuation question so that I can understand what the accepted set now represents without entering a separate portfolio discussion.

**Why this priority**: Collection continuation is a common boundary after capture and must remain compatible with existing reassurance and user-authority guidance.

**Independent Test**: Inspect the collection continuation guidance and verify that it can summarize accepted coverage, preserve additional-suggestions reassurance, and ask whether another Objective should be captured without redefining portfolio assessment.

**Acceptance Scenarios**:

1. **Given** an Objective has been captured and collection remains active, **When** the owner asks whether another Objective should be captured, **Then** the owner may first provide a concise accepted-coverage synthesis.
2. **Given** the synthesis is presented during active collection, **When** the person requests additional suggestions, **Then** existing recommendation support remains available and the synthesis does not become a recommendation set.
3. **Given** the person explicitly finishes collection, **When** the owner provides the final transition, **Then** the synthesis does not reopen collection or require another Objective question.

### User Story 3 - Make setup transition acknowledge the accepted portfolio (Priority: P2)

As a person moving from Objective collection into safeguards or downstream setup, I want a concise statement of the accepted Objective coverage so that the transition reflects what has been established before the next activity begins.

**Why this priority**: Setup transition is important for continuity but follows the queued and collection paths in frequency and centrality.

**Independent Test**: Inspect the setup transition guidance and verify that it may summarize accepted coverage before the next setup activity without adding a review, proposal, recommendation set, or durable portfolio artifact.

**Acceptance Scenarios**:

1. **Given** accepted Objectives establish coverage and setup is the next activity, **When** the owner transitions out of Objective collection, **Then** the owner may summarize the coverage before introducing the safeguards activity.
2. **Given** the setup transition synthesis is concise, **When** the next activity begins, **Then** the synthesis does not repeat Objective contents or create a new Objective state.

### Edge Cases

- No Objective has been captured; no portfolio synthesis is presented.
- An Objective is captured but no active queue remains; the owner may provide a collection or setup transition synthesis only when that next activity is relevant.
- The accepted Objective set has overlapping or sparse coverage; the synthesis remains concise and descriptive rather than becoming a detailed portfolio assessment.
- The person corrects, replaces, rejects, cancels, abandons, or interrupts an Objective proposal; synthesis occurs only after capture and does not imply acceptance.
- Additional suggestions remain available during active collection, but the synthesis itself never becomes a recommendation set.
- An active queue contains a next Objective; the synthesis may identify it without restating the lifecycle mechanics owned by the Objective Development Lifecycle.
- The person explicitly finishes collection; the finish decision takes precedence over a continuation question.
- Generated adapters must preserve equivalent continuity guidance and boundaries.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: After an Objective is captured, the owner MAY provide a brief synthesis of the accepted Objective set before the next user-relevant activity.
- **FR-002**: The synthesis MUST describe current coverage provided by accepted Objectives.
- **FR-003**: The synthesis SHOULD explain how the newly accepted Objective fits within the current Objective portfolio when that explanation can remain concise.
- **FR-004**: The synthesis MUST avoid repeating the full contents of accepted Objectives.
- **FR-005**: When an active Objective queue remains, the synthesis MAY identify the next Objective being developed.
- **FR-006**: Queued transition guidance MUST permit a brief synthesis between Objective capture and development of the next queued Objective.
- **FR-007**: Collection continuation guidance MUST permit a brief synthesis before asking whether another Objective should be captured.
- **FR-008**: Setup transition guidance MUST permit a brief synthesis before the next setup activity when Objective collection has established accepted coverage.
- **FR-009**: The synthesis MUST remain advisory and MUST NOT constitute a second review, second proposal, recommendation set, or detailed portfolio assessment.
- **FR-010**: The synthesis MUST NOT create a new lifecycle state, acceptance mechanism, Objective record field, durable portfolio artifact, or additional discussion requirement.
- **FR-011**: Existing User Acceptance, capture, queue continuation, collection finish, additional-suggestions reassurance, and user-authority boundaries MUST remain unchanged.
- **FR-012**: Synthesis MUST occur only after Objective capture and MUST NOT imply that a transient proposal has been accepted or persisted.
- **FR-013**: The queued, collection, and setup examples MUST demonstrate concise coverage acknowledgment followed by the relevant next activity without defining a competing lifecycle.
- **FR-014**: The source skill and all generated Objective adapters MUST preserve equivalent continuity guidance and protected Objective behavior.
- **FR-015**: The feature MUST preserve Objective ownership, lifecycle sequence, proposal contents, Business Objective, Success, Highway Relevance, recommendation adoption, queue membership, portfolio assessment, identifiers, catalogs, atomic persistence, readiness, mutation output, non-write, duplicate, overlap, revalidation, setup orchestration, and Repository Context contracts.
- **FR-016**: The feature MUST not add a new lifecycle state, acceptance path, recommendation behavior, Objective dimension, external service, or durable queue.

## Key Entities *(include if data involved)*

- **Accepted Objective Set**: The captured Objectives whose combined coverage may be summarized.
- **Portfolio Synthesis**: A brief advisory description of accepted Objective coverage and, when relevant, how the newest Objective fits.
- **Queued Objective Transition**: The post-capture boundary before the next active queue item is developed.
- **Collection Continuation Transition**: The post-capture boundary before asking whether another Objective should be captured.
- **Setup Transition**: The boundary from accepted Objective collection to safeguards or another downstream setup activity.
- **Next User-Relevant Activity**: The queue development, continuation question, or setup activity that follows the synthesis.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of queued post-capture transition checks find an optional concise coverage synthesis before the next queued Objective activity and 0 checks find a required second review or proposal.
- **SC-002**: 100% of active-collection transition checks preserve a concise coverage synthesis, existing additional-suggestions reassurance, and the continuation question without creating a recommendation set.
- **SC-003**: 100% of setup-transition checks preserve an optional coverage synthesis before safeguards or the next setup activity without adding a lifecycle state or durable artifact.
- **SC-004**: 100% of synthesis checks verify that synthesis occurs after capture and does not imply acceptance or persistence of a transient proposal.
- **SC-005**: 100% of focused wording checks find coverage description and newest-Objective fit guidance while finding 0 full accepted-Objective restatements.
- **SC-006**: 100% of focused boundary checks find that synthesis is advisory and not a second review, second proposal, recommendation set, or detailed portfolio assessment.
- **SC-007**: 100% of generated Objective adapters preserve the source continuity guidance and protected Objective behavior.
- **SC-008**: Existing Objective and full repository verification suites remain passing with no changes to lifecycle, persistence, readiness, ownership, or non-write behavior.

## Assumptions

- Feature 163 is the documentation ownership baseline; this feature adds continuity guidance to the existing Objective Portfolio Assessment and transition surfaces.
- A synthesis is optional and concise; the owner does not need to produce one after every capture when no useful coverage statement is available.
- Accepted Objective coverage is described at a high level and does not require a new schema, computed portfolio score, or durable summary.
- Existing collection finish behavior, recommendation reassurance, User Acceptance, and capture semantics remain authoritative.
- Generated adapters remain identity copies of the source skill.
- Static contract checks can validate required wording and prohibited boundary changes but cannot measure conversational quality directly.

## Out of Scope

- Changing the Objective Development Lifecycle, proposal contents, User Acceptance, capture mechanics, or user authority.
- Creating a persisted portfolio summary, portfolio score, new Objective record field, catalog entry, or lifecycle state.
- Adding recommendation generation or changing recommendation adoption behavior.
- Replacing the existing detailed Objective Portfolio Assessment with this concise synthesis.
- Requiring a synthesis when no meaningful accepted coverage can be described.
- Changing setup orchestration, safeguards semantics, readiness, persistence, duplicate detection, overlap handling, or revalidation.
