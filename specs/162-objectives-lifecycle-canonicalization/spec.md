# Feature Specification: Objectives Lifecycle Canonicalization

**Feature Branch**: `162-objectives-lifecycle-canonicalization`

**Created**: 2026-10-12

**Status**: Draft

**Input**: User description: "Refactor the Objective development model so the Converged Objective proposal is defined exactly once, recommendation selection always enters development, User Acceptance is the explicit boundary before capture, and queue and capture guidance reference one canonical lifecycle."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Use one canonical Objective lifecycle (Priority: P1)

As a person developing an Objective, I want one clear lifecycle from selection or direct contribution through proposal, User Acceptance, capture, and the next Objective so that the workflow cannot be interpreted as having multiple competing stages.

**Why this priority**: A single lifecycle is the foundation for consistent Objective behavior and prevents drift between sections.

**Independent Test**: Inspect the Objective guidance and verify that the lifecycle appears once with the sequence Recommendation Selected or User Provided Objective, Present Converged Objective proposal, User Acceptance, Capture, and Next Objective.

**Acceptance Scenarios**:

1. **Given** a person selects a recommendation or provides an Objective, **When** Objective development begins, **Then** the owner presents the canonical Converged Objective proposal before User Acceptance.
2. **Given** the canonical lifecycle is presented, **When** the person accepts the proposal, **Then** capture follows User Acceptance and the next Objective follows capture.
3. **Given** a person requests changes, **When** the proposal is corrected, replaced, or rejected, **Then** the workflow does not treat a preliminary proposal as a separate lifecycle stage.

### User Story 2 - Understand the authoritative proposal definition (Priority: P1)

As a person relying on Objective guidance, I want the Converged Objective proposal contents defined once so that every other section can reference the same title, statement, proposed Success Measures, and synthesized Rationale.

**Why this priority**: Duplicate proposal definitions create wording drift and allow different interpretations of completeness.

**Independent Test**: Search the Objective guidance for proposal-content definitions and verify that one authoritative definition lists all four fields while queue and acceptance sections reference it instead of redefining it.

**Acceptance Scenarios**:

1. **Given** a Converged Objective proposal is presented, **When** the person considers its completeness, **Then** the authoritative definition includes Objective title, Objective statement, proposed Success Measures, and synthesized Rationale.
2. **Given** queue or capture guidance describes the proposal, **When** the person follows that guidance, **Then** it references the lifecycle definition rather than introducing another proposal field list.
3. **Given** accepted Profile evidence supports a responsible proposal, **When** the owner develops it, **Then** the person can approve, correct, replace, or reject it without being asked to recreate supported information.

### User Story 3 - Treat User Acceptance as the capture boundary (Priority: P1)

As a person reviewing an Objective proposal, I want User Acceptance to be the explicit event before capture so that activity such as presenting or discussing a proposal cannot be mistaken for acceptance.

**Why this priority**: Separating an activity from the acceptance event protects user authority and aligns capture with the existing acceptance boundary.

**Independent Test**: Verify that Objective workflow guidance consistently names User Acceptance before capture and does not use review terminology as the capture boundary.

**Acceptance Scenarios**:

1. **Given** a Converged Objective proposal is presented, **When** the person has not accepted it, **Then** the Objective remains uncaptured.
2. **Given** the person accepts, corrects, replaces, or rejects the proposal, **When** the owner continues, **Then** only acceptance of the current proposal permits capture.
3. **Given** the guidance describes the normal path, **When** the person reads it, **Then** it uses Present Converged Objective proposal, User Acceptance, and Capture rather than a preliminary review stage.

### User Story 4 - Keep queue processing aligned with the lifecycle (Priority: P2)

As a person selecting several recommendations, I want each queue item to use the same canonical proposal and acceptance path so that queue processing does not redefine development stages or imply capture at selection.

**Why this priority**: Queue guidance is a common source of alternative interpretations after the lifecycle is clarified.

**Independent Test**: Select multiple recommendations and verify that each item is processed sequentially by presenting the canonical proposal, obtaining User Acceptance, capturing the Objective, and continuing to the next item.

**Acceptance Scenarios**:

1. **Given** multiple recommendations are selected, **When** the queue begins, **Then** selection enters development and does not capture any Objective.
2. **Given** a queue item is current, **When** it is processed, **Then** the owner presents the Converged Objective proposal defined in the lifecycle, obtains User Acceptance, captures it, and continues to the next item.
3. **Given** a queue example is shown, **When** the first item is described, **Then** it references the canonical proposal and says the Objective is accepted and captured before the second item begins.
4. **Given** a person requests changes to a proposal, **When** the owner updates it, **Then** the owner does not introduce a preliminary Objective and later second complete proposal unless the person requested changes.

### Edge Cases

- A direct user-provided Objective enters the same canonical lifecycle as a selected recommendation.
- Accepted evidence is insufficient for a responsible Converged Objective proposal; discovery remains the exception path.
- Accepted evidence supports likely Success Measures; the owner proposes them without creating a separate lifecycle stage.
- A proposal is corrected, replaced, or rejected; stale content is not treated as accepted or captured.
- A recommendation is selected for explanation or comparison; selection or information requests do not count as User Acceptance.
- A queue item is declined or interrupted; it remains uncaptured and later items do not skip ahead to capture.
- Existing duplicate, overlap, revalidation, non-write, and atomic persistence behavior remains unchanged.
- The guidance is distributed to agent adapters; every adapter must retain the same canonical wording as the source.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Objective guidance MUST define the Objective Development Lifecycle exactly once as Recommendation Selected or User Provided Objective, Present Converged Objective proposal, User Acceptance, Capture, and Next Objective.
- **FR-002**: The authoritative Converged Objective proposal definition MUST contain Objective title, Objective statement, proposed Success Measures, and synthesized Rationale.
- **FR-003**: Every other Objective workflow section that needs proposal completeness MUST reference the lifecycle definition rather than restating a separate proposal definition.
- **FR-004**: Recommendation selection MUST always transition into Objective development and MUST NOT directly capture an Objective.
- **FR-005**: A person-provided Objective MUST enter the same canonical lifecycle as a selected recommendation.
- **FR-006**: Objective development MUST normally begin from a proposal rather than a question when accepted evidence supports a responsible Converged Objective proposal.
- **FR-007**: Discovery MUST remain an exception when accepted evidence cannot support a responsible Converged Objective proposal, cannot support reasonable Success Measures, or leaves consequential ambiguity unresolved.
- **FR-008**: The owner MUST NOT ask a discovery question when a grounded Converged Objective proposal can reasonably be presented first.
- **FR-009**: When accepted evidence supports likely Success Measures, the owner MUST propose them within the canonical proposal rather than creating a separate lifecycle stage.
- **FR-010**: The person MUST be able to approve, correct, replace, or reject the canonical proposal before capture.
- **FR-011**: User Acceptance MUST be the explicit event required before Objective capture.
- **FR-012**: Presenting, discussing, or changing a proposal MUST NOT be treated as User Acceptance unless the person accepts the current proposal.
- **FR-013**: Objective workflow guidance MUST replace review-as-boundary wording with User Acceptance terminology.
- **FR-014**: The guidance MUST state that the Converged Objective proposal is presented once and MUST NOT introduce a preliminary Objective followed by a second complete proposal unless the person requested changes.
- **FR-015**: Queue processing MUST reference the canonical lifecycle and consist of presenting the Converged Objective proposal, obtaining User Acceptance, capturing the Objective, and continuing to the next queue item.
- **FR-016**: Queue membership MUST determine development order only and MUST NOT constitute User Acceptance or Objective capture.
- **FR-017**: Queue examples MUST describe the first Objective as accepted and captured before the next recommendation is developed.
- **FR-018**: Recommendations, interpretations, proposed Success Measures, synthesized Rationale, and presented proposals MUST remain advisory or transient until User Acceptance crosses the existing acceptance boundary.
- **FR-019**: The feature MUST preserve Business Objective, Success, Highway Relevance, recommendation adoption, queue, continuation, portfolio assessment, identifiers, catalog, atomic persistence, readiness, mutation output, non-write, duplicate, overlap, revalidation, setup orchestration, and Repository Context contracts.
- **FR-020**: The source guidance and all generated adapters MUST contain equivalent canonical lifecycle behavior.

## Key Entities *(include if feature involves data)*

- **Objective Development Lifecycle**: The single authoritative sequence from recommendation selection or user-provided Objective through proposal presentation, User Acceptance, capture, and the next Objective.
- **Converged Objective Proposal**: The one canonical complete proposal containing title, statement, proposed Success Measures, and synthesized Rationale.
- **User Acceptance**: The explicit user-owned event that permits the existing Objective owner to capture the current proposal.
- **Active Objective Queue**: The transient ordered set of selected recommendations processed through the canonical lifecycle one at a time.
- **Discovery Exception**: The focused question path used only when accepted evidence cannot support the canonical proposal or consequential user-owned ambiguity remains.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of focused Objective guidance checks identify exactly one authoritative definition of Converged Objective proposal contents.
- **SC-002**: 100% of focused lifecycle checks show Recommendation Selected or User Provided Objective, Present Converged Objective proposal, User Acceptance, Capture, and Next Objective in that order.
- **SC-003**: 0 focused checks identify review terminology as the event that permits capture; User Acceptance is the only named capture boundary.
- **SC-004**: 100% of focused queue checks show recommendation selection entering development without capture and each queue item using the canonical proposal and User Acceptance path.
- **SC-005**: 100% of focused sufficient-evidence scenarios keep proposal contents in one authoritative definition and prevent a separate preliminary proposal stage.
- **SC-006**: 100% of focused insufficient-evidence scenarios preserve discovery only for missing proposal support, missing reasonable Success Measures, or consequential ambiguity.
- **SC-007**: 100% of generated Objective adapters preserve the source lifecycle wording and proposal-reference behavior.
- **SC-008**: Existing Objective and full repository verification suites remain passing after implementation, with no changes to protected ownership, persistence, readiness, or non-write contracts.

## Assumptions

- Feature 161 remains the behavioral foundation; Feature 162 refines its terminology and canonical structure rather than introducing new Objective capabilities.
- The existing Objective acceptance boundary remains authoritative for capture and persistence.
- “User Acceptance” describes the acceptance event and does not require a new durable state, record field, or persistence mechanism.
- Queue state remains transient and preserves selected order only.
- Existing Experience Standard rules govern what counts as acceptance and how corrections, replacements, and rejections are handled.
- Static document checks can prove singular definitions, terminology, ordering, and adapter correspondence, but cannot alone prove conversational quality.

## Out of Scope

- Changing Objective record schema, catalog format, identifiers, versions, duplicate detection, overlap handling, atomic persistence, or readiness behavior.
- Changing Profile behavior, the Highway Experience Standard, Highway Identity, or Repository Context ownership.
- Adding a second acceptance mechanism, durable queue records, external services, or a new Objective dimension.
- Changing the substantive proposal-first, Success Measure, discovery-exception, or user-authority behavior established by Feature 161.
