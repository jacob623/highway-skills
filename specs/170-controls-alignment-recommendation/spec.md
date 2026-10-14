# Feature Specification: Controls Alignment Recommendation

**Feature Branch**: `170-controls-alignment-recommendation`

**Created**: 2026-10-14

**Status**: Draft

**Input**: User description: "Align Controls with the proposal-first interaction model established by Objectives, while preserving Control ownership, persistence, classification, and NFR-generation behavior."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Develop Controls from grounded recommendations (Priority: P1)

As a person developing repository Controls, I want grounded safeguard recommendations presented before exploratory questions so that I can review, correct, select, or author the safeguard that best fits my context.

**Why this priority**: Proposal-first development is the central alignment goal and reduces unnecessary discovery while preserving user authority.

**Independent Test**: With accepted repository context available, present a recommendation set and verify that the person can select, modify, reject, or author a safeguard before a Converged Control Proposal is formed.

**Acceptance Scenarios**:

1. **Given** accepted context supports one or more safeguards, **When** Control collection begins, **Then** the workflow presents grounded recommendations before asking an exploratory question.
2. **Given** recommendations are displayed, **When** the person selects one, several, or all recommendations, **Then** the selected items enter development in the selected order without being captured automatically.
3. **Given** the person does not find a suitable recommendation, **When** the person supplies a safeguard, **Then** that safeguard becomes the active Control development subject.
4. **Given** accepted context cannot support a responsible recommendation, **When** Control development begins, **Then** the workflow uses focused discovery as the exception path.

---

### User Story 2 - Review and accept a complete Control proposal (Priority: P1)

As a person reviewing a safeguard, I want a complete Converged Control Proposal with a clear correction path so that acceptance reflects my decision rather than an implicit selection.

**Why this priority**: Controls must preserve their existing ownership, acceptance, persistence, and classification boundaries while adopting the new interaction model.

**Independent Test**: Select or author a safeguard, review its proposal, correct or replace it, accept it, and verify that capture occurs only after acceptance.

**Acceptance Scenarios**:

1. **Given** a selected or authored safeguard, **When** accepted context supports a complete proposal, **Then** the workflow presents its title, statement, and synthesized rationale under a Control capture heading.
2. **Given** a proposal is presented, **When** the person adds, corrects, replaces, rejects, or approves it, **Then** the workflow keeps the proposal provisional until the applicable acceptance boundary is satisfied.
3. **Given** the person approves a complete proposal, **When** the Control owner performs capture, **Then** the Control is persisted and only then may downstream behavior use it as accepted knowledge.
4. **Given** a proposal is materially revised after acceptance, **When** the revision is presented, **Then** the changed substance is identified and the person receives a new correction or acceptance opportunity.

---

### User Story 3 - Expand recommendation coverage without exposing internal categories (Priority: P2)

As a person collecting Controls, I want recommendations to include useful safeguards that accepted context may not reveal immediately, without being asked to reason about internal coverage categories.

**Why this priority**: Coverage guidance improves discovery breadth while remaining subordinate to context-grounded recommendations and user ownership.

**Independent Test**: Provide accepted context with an identifiable coverage gap and verify that context-derived and coverage-derived safeguards are presented together without exposing coverage-area concepts.

**Acceptance Scenarios**:

1. **Given** accepted context yields context-derived recommendations, **When** meaningful coverage gaps remain, **Then** the workflow may add context-adapted coverage recommendations to the same recommendation set.
2. **Given** coverage-derived recommendations are shown, **When** the person reviews them, **Then** the workflow does not present coverage areas as user-facing choices, workflow concepts, policy, obligation, deficiency, or readiness requirements.
3. **Given** the person requests additional suggestions, **When** accepted repository context and the accepted Control portfolio are evaluated, **Then** additional non-duplicate safeguards may be presented only when useful grounded gaps remain.

---

### User Story 4 - Continue collection with portfolio awareness (Priority: P2)

As a person collecting several Controls, I want concise coverage-aware continuation after each captured Control so that I can keep collecting safeguards until I explicitly finish.

**Why this priority**: Collection should remain useful after individual capture and must not end merely because readiness becomes complete.

**Independent Test**: Capture multiple Controls, observe an advisory portfolio assessment and continuation invitation, request more suggestions, and explicitly finish collection.

**Acceptance Scenarios**:

1. **Given** multiple Controls have been accepted, **When** portfolio assessment is useful, **Then** the workflow may summarize overlap, duplication, concentration, meaningful coverage, or meaningful gaps without rejecting or mutating Controls.
2. **Given** a Control has been captured and collection is not explicitly finished, **When** the workflow continues, **Then** it keeps future recommendation support available and asks whether another safeguard should be captured.
3. **Given** readiness becomes Complete while collection continues, **When** the person has not explicitly finished, **Then** collection remains available.
4. **Given** the person explicitly finishes collection, **When** no further action is requested, **Then** the workflow ends Control collection without creating additional recommendations.

### Edge Cases

- A person selects multiple recommendations but changes the order or content of the active queue before development begins.
- Accepted context supports a recommendation but does not support a complete rationale; the workflow must continue development without inventing organizational facts.
- A coverage gap exists but no context-adapted safeguard can be grounded responsibly; the workflow must avoid generic or unsupported recommendations.
- The person asks for more suggestions after all useful non-duplicate recommendations have been exhausted; the workflow must stop recommendation generation and keep the user-authored path available.
- A person requests explanation or comparison of a recommendation; that request must not be treated as acceptance.
- Persistence fails after acceptance; the affected Control must remain unchanged and downstream completion or readiness claims must not be made.
- A portfolio assessment identifies a gap but must not reject, block, or mutate an accepted Control.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Controls experience MUST present a grounded recommendation before exploratory questioning whenever accepted context supports a responsible safeguard recommendation.
- **FR-002**: The Controls experience MUST retain focused conversational discovery as an exception path when accepted context cannot support a responsible proposal, consequential ambiguity remains unresolved, or classification cannot be resolved responsibly.
- **FR-003**: The Controls experience MUST provide reusable response support consisting of a validation question, acceptance reassurance, discovery reassurance, combined reassurance, recommendation reassurance, and additional-suggestions reassurance.
- **FR-004**: The Controls experience MUST offer a correction path that asks what to add, correct, or remove and MUST keep a recommendation or proposal provisional until the applicable acceptance boundary is crossed.
- **FR-005**: The Controls experience MUST support selecting one recommendation, several recommendations, all recommendations, modifying recommendations, providing a user-authored safeguard, and requesting additional suggestions.
- **FR-006**: Selection MUST determine Control development order without capturing or persisting the selected Controls.
- **FR-007**: Each Converged Control Proposal MUST include a title, statement, and synthesized rationale and MUST be presented before capture when a responsible complete proposal can be formed.
- **FR-008**: A Control MUST be captured only after its Converged Control Proposal has been presented, the person has accepted it, and the Control owner has performed capture.
- **FR-009**: Recommendations MUST be grounded in accepted Profile, Objectives, Controls, NFRs, repository context, or declared external expertise permitted by the owning workflow.
- **FR-010**: Context-derived recommendations MUST be generated before coverage-derived recommendations, and coverage-derived recommendations MUST supplement rather than replace context-grounded recommendations.
- **FR-011**: Coverage guidance MUST NOT establish organizational policy, obligations, deficiencies, readiness requirements, lifecycle stages, accepted Controls, or changes to Control ownership, persistence, classification, or acceptance behavior.
- **FR-012**: Coverage guidance MUST remain invisible as an internal category system; users MUST see only the recommended safeguards and their concise descriptions.
- **FR-013**: Additional suggestions MUST consider accepted repository context and the accepted Control portfolio and MUST stop when no useful grounded non-duplicate recommendation remains.
- **FR-014**: The Controls experience MUST keep the user-authored safeguard path available whenever recommendations are presented.
- **FR-015**: The Controls experience MUST support one grounded contribution at a time when accepted context can materially improve a Working Idea, without manufacturing observations or presenting a recommendation set as a contribution.
- **FR-016**: After multiple Controls are accepted, the Controls experience MAY provide a concise advisory portfolio assessment covering overlap, duplication, concentration, meaningful coverage, or meaningful gaps without rejecting or mutating the baseline.
- **FR-017**: After each captured Control, the Controls experience MUST provide a concise coverage-aware synthesis and keep future recommendation support available until explicit finish.
- **FR-018**: Readiness becoming Complete MUST NOT end Control collection, and explicit finish MUST end collection without creating further recommendations.
- **FR-019**: The Controls alignment MUST preserve existing Control persistence, classification, ownership, and Control-derived NFR candidate behavior except where this specification explicitly changes user-visible development order.
- **FR-020**: The Controls experience MUST keep Concern, Condition, and Obligation as internal recommendation-development concepts rather than dominant user-visible workflow stages.

### Key Entities *(include if feature involves data)*

- **Control Recommendation**: A provisional safeguard suggestion grounded in accepted context or coverage guidance, with a title and concise description.
- **Control Queue**: The ordered set of selected recommendations awaiting one-at-a-time development; membership controls order but does not imply capture.
- **Converged Control Proposal**: The complete provisional Control candidate containing title, statement, and synthesized rationale before acceptance.
- **Accepted Control**: A Control whose proposal crossed the acceptance boundary and was captured by the owning workflow.
- **Control Coverage Area**: Internal recommendation-generation guidance used to reveal useful gaps without becoming user-visible policy, obligation, deficiency, or readiness state.
- **Control Portfolio Assessment**: Optional advisory synthesis of accepted Controls that does not reject, block, or mutate the baseline.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In validation scenarios with responsible accepted context, at least 90% of Control development sessions present a grounded recommendation before an exploratory question.
- **SC-002**: In validation scenarios, 100% of captured Controls have a presented Converged Control Proposal and an explicit acceptance event before capture.
- **SC-003**: In validation scenarios with selected recommendations, 100% of selected Controls remain uncaptured until developed and accepted one at a time.
- **SC-004**: In coverage-gap scenarios, at least 80% of useful non-duplicate recommendation gaps are surfaced without exposing internal coverage-area labels to users.
- **SC-005**: In multi-Control collection scenarios, 100% of captured Controls receive a continuation opportunity unless the person explicitly finishes collection.
- **SC-006**: In review scenarios, at least 90% of participants can distinguish recommendation, proposal, acceptance, and capture as separate steps without moderator explanation.
- **SC-007**: In regression validation, all existing Control persistence, classification, ownership, and Control-derived NFR behaviors remain passing.

## Assumptions

- The existing Controls owner remains authoritative for Control semantics, acceptance, persistence, classification, and Control-derived NFR candidates.
- The Highway Experience Standard remains authoritative for generic user-visible interaction rules.
- Accepted Profile, Objectives, Controls, NFRs, repository context, and permitted external expertise are available through existing owner-approved paths.
- Recommendation generation and coverage guidance are user-visible behavior changes, while no new retained Control field, readiness dimension, lifecycle state, or persistence artifact is required.
- The initial release may use static contract validation and existing executable behavior checks to verify the interaction model; live conversational evaluation is outside the specification's implementation guarantee.
- Existing generated adapters and catalog correspondence remain required for distributed skill artifacts.
- The feature does not require exposing Control Coverage Areas, asking users to select them, or changing the retained Control record structure.
