# Feature Specification: Objectives Synthesis Lifecycle

**Feature Branch**: `161-objectives-synthesis-lifecycle`

**Created**: 2026-10-12

**Status**: Draft

**Input**: User description: "Make highway-objectives operate as a synthesis owner: develop grounded Objective proposals with proposed Success Measures and synthesized Rationale from accepted Profile evidence, use discovery only as an exception, make queue and capture boundaries explicit, and preserve one-review Objective development."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Receive a complete grounded Objective proposal (Priority: P1)

As a person collecting Objectives, I want the owner to synthesize a complete first-pass proposal from accepted Profile evidence so that I can refine, correct, or approve meaningful work instead of rediscovering information already established in Profile.

**Why this priority**: Synthesis-first behavior is the central change and determines whether Objective collection acts as an informed advisor or a second discovery workflow.

**Independent Test**: Provide accepted Profile evidence that reasonably supports an Objective and verify that the owner presents an Objective title, statement, proposed Success Measures, and synthesized Rationale before asking the person to create those elements from scratch.

**Acceptance Scenarios**:

1. **Given** accepted Profile evidence reasonably supports an Objective, **When** Objective collection begins, **Then** the owner presents a complete first-pass proposal with a title, statement, proposed Success Measures, and synthesized Rationale.
2. **Given** a grounded Objective proposal is presented, **When** the person responds, **Then** the person can refine, correct, approve, replace, or reject the proposal while remaining authoritative.
3. **Given** the proposal is complete enough for review, **When** the owner continues, **Then** the proposal itself is the review candidate and the owner does not force a separate discovery chain first.
4. **Given** accepted Profile evidence supports a reasonable proposal, **When** the owner chooses the next interaction, **Then** it does not ask a question merely to rediscover information already established in Profile.

### User Story 2 - Develop Success Measures from grounded evidence (Priority: P1)

As a person reviewing an Objective, I want likely Success Measures proposed alongside the Objective so that I can approve, modify, replace, or remove them as supporting detail rather than being asked to invent them before seeing the outcome they measure.

**Why this priority**: Success Measures should refine the Objective and make it actionable without displacing the Objective as the primary conversational anchor.

**Independent Test**: Provide accepted evidence that supports likely Success Measures and verify that the owner proposes them with the Objective and offers explicit refinement choices.

**Acceptance Scenarios**:

1. **Given** accepted evidence reasonably supports likely Success Measures, **When** the owner develops an Objective proposal, **Then** it proposes those measures with the Objective.
2. **Given** proposed Success Measures are shown, **When** the person responds, **Then** the person can approve, modify, replace, or remove them.
3. **Given** the Objective is not yet visible, **When** Success Measure information is available, **Then** the owner does not begin with a chain of Success questions that makes the person create measures from scratch.
4. **Given** accepted evidence cannot support reasonable Success Measures, **When** the owner continues, **Then** it asks only the consequential unresolved Success question needed for development.

### User Story 3 - Process selected recommendations as development work (Priority: P1)

As a person selecting several recommendations, I want selection to create an ordered development queue rather than immediately capture Objectives so that each recommendation receives a complete proposal, one review, and capture before the next begins.

**Why this priority**: Explicit queue boundaries prevent recommendation selection from becoming an accidental persistence shortcut.

**Independent Test**: Select several recommendations and verify that the owner processes them one at a time through proposal development, review, capture, and continuation without capturing any recommendation at selection time.

**Acceptance Scenarios**:

1. **Given** the person selects one or several recommendations, **When** selection is accepted, **Then** selection identifies which Objective should be developed next and does not capture an Objective.
2. **Given** several recommendations are selected, **When** the queue is active, **Then** queue membership determines development order only and the selected recommendations remain un-captured.
3. **Given** a queued recommendation is current, **When** it is developed, **Then** the owner creates a Converged Objective proposal containing a title, statement, proposed Success Measures, and synthesized Rationale before review.
4. **Given** the current proposal is reviewed and captured, **When** another queue item remains, **Then** the owner develops the next recommendation rather than capturing the remaining items automatically.
5. **Given** the person selects several recommendations, **When** the owner describes the queue, **Then** it makes clear that selection does not capture the recommendations immediately.

### User Story 4 - Use discovery and review as bounded exceptions (Priority: P2)

As a person developing an Objective, I want discovery available when evidence is insufficient and one clear review-to-capture path when evidence is sufficient so that questions resolve real uncertainty without creating redundant proposal or review cycles.

**Why this priority**: Exception handling keeps synthesis grounded without pretending that Profile always contains enough information.

**Independent Test**: Exercise sufficient evidence, insufficient evidence, unresolved ambiguity, and a reviewed proposal; verify proposal-first behavior where possible, focused discovery where necessary, and exactly one review before capture.

**Acceptance Scenarios**:

1. **Given** accepted evidence cannot support a responsible Objective proposal, **When** collection begins, **Then** conversational discovery is used as the exception path.
2. **Given** accepted evidence cannot support reasonable Success Measures, **When** the owner develops the proposal, **Then** it asks a focused Success question rather than manufacturing measures.
3. **Given** consequential ambiguity remains unresolved, **When** the owner cannot responsibly synthesize the proposal, **Then** it asks the one consequential question needed to proceed.
4. **Given** a Converged Objective proposal exists, **When** review completes, **Then** the owner captures it without introducing a second proposal and second review cycle.
5. **Given** the person has already reviewed the Converged Objective proposal, **When** the workflow continues, **Then** the normal path is proposal, review, capture, and next Objective.

### Edge Cases

- Accepted Profile evidence supports an Objective but not a complete Success Measure set; the owner presents the Objective and asks only the unresolved Success question.
- Accepted Profile evidence supports several plausible Objectives; the owner presents grounded alternatives or asks the consequential grouping question without silently choosing between materially different outcomes.
- A person provides an Objective directly; it enters the same development lifecycle and does not require unnecessary rediscovery.
- A person modifies a proposed Objective or Success Measure; the owner re-evaluates the proposal and does not capture stale staged content.
- A person removes all proposed Success Measures; the owner preserves that correction and follows the existing completeness and acceptance rules.
- A selected recommendation is requested for explanation or comparison; the request does not count as capture or completion.
- A selected recommendation cannot support a responsible proposal; it remains in development and uses the discovery exception path.
- A queue item is declined, interrupted, malformed, or unresolved; it is not captured and later queue items are not captured early.
- A reviewed proposal changes before persistence or overlaps an existing Objective; the existing revalidation, duplicate, overlap, and renewed-review rules remain in force.
- No useful grounded recommendation remains; the owner stops manufacturing recommendations and preserves the user-authored path.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Objectives MUST treat accepted Profile evidence as the primary grounding source for first-pass Objective synthesis.
- **FR-002**: When accepted Profile evidence reasonably supports an Objective, the owner MUST present a complete first-pass proposal before requiring discovery of information already established in Profile.
- **FR-003**: A complete first-pass Objective proposal MUST include an Objective title, Objective statement, proposed Success Measures, and synthesized Rationale.
- **FR-004**: The person MUST be able to refine, correct, approve, replace, or reject a grounded Objective proposal before the existing acceptance boundary.
- **FR-005**: Objective development MUST normally begin from a proposal rather than a question when accepted evidence supports a responsible proposal.
- **FR-006**: Conversational discovery MUST remain available as an exception when accepted evidence cannot support a responsible Objective proposal, cannot support reasonable Success Measures, or leaves consequential ambiguity unresolved.
- **FR-007**: The owner MUST NOT ask a discovery question when a grounded proposal can reasonably be presented first.
- **FR-008**: When accepted evidence reasonably supports likely Success Measures, the owner MUST propose them with the Objective.
- **FR-009**: Proposed Success Measures MUST remain user-refinable through approval, modification, replacement, or removal.
- **FR-010**: Success Measure development MUST normally begin with a proposal rather than a request to create measures from scratch.
- **FR-011**: A selected recommendation MUST identify which Objective is developed next and MUST NOT capture an Objective at selection time.
- **FR-012**: A selected recommendation MUST enter the active Objective queue when the person selects it.
- **FR-013**: Queue membership MUST determine development order only and MUST NOT constitute Objective capture.
- **FR-014**: An Objective MUST NOT be captured until a Converged Objective proposal exists, the review step completes, and the Objective owner performs capture.
- **FR-015**: The owner MUST NOT transition directly from recommendation selection to Objective capture.
- **FR-016**: For a selected recommendation, the owner MUST create a Converged Objective proposal containing an Objective title, Objective statement, proposed Success Measures, and synthesized Rationale before review.
- **FR-017**: Multiple selected recommendations MUST be processed one at a time through proposal development, review, capture, and continuation until the queue is exhausted.
- **FR-018**: A Converged Objective proposal MUST be the review candidate and MUST NOT trigger a redundant second proposal and second review cycle after the person has already reviewed it.
- **FR-019**: The default Objective lifecycle MUST be Converged Objective proposal, one review, capture, and next Objective.
- **FR-020**: The feature MUST preserve Business Objective ownership, Success ownership, Highway Relevance ownership, recommendation adoption, queue processing, continuation, portfolio assessment, identifier allocation, catalog ownership, atomic persistence, setup orchestration boundaries, and Repository Context declaration.
- **FR-021**: The feature MUST preserve existing readiness, mutation output, non-write, duplicate, overlap, acceptance, and revalidation contracts.
- **FR-022**: Recommendations, interpretations, proposed Success Measures, and synthesized Rationale MUST remain grounded advisory content until the existing acceptance boundary is crossed.

## Key Entities *(include if feature involves data)*

- **Objective Development Lifecycle**: The synthesis-first path from grounded recommendation or user-provided Objective through proposal, review, capture, and the next Objective.
- **Converged Objective Proposal**: A complete first-pass Objective candidate containing title, statement, proposed Success Measures, and synthesized Rationale, ready for one review.
- **Proposed Success Measures**: Grounded measures offered with the Objective for user approval, modification, replacement, or removal.
- **Active Objective Queue**: The ordered set of selected recommendations awaiting sequential proposal development; queue membership is not capture.
- **Discovery Exception**: A focused question path used only when accepted evidence cannot support a responsible proposal or consequential user-owned uncertainty remains.
- **Objective Capture**: The existing owner-controlled acceptance and persistence boundary reached only after proposal review.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of focused sufficient-evidence scenarios, the owner presents a complete Objective proposal before asking the person to originate information already supported by accepted Profile evidence.
- **SC-002**: In 100% of focused sufficient-evidence scenarios, the first-pass proposal contains an Objective title, statement, proposed Success Measures, and synthesized Rationale.
- **SC-003**: In 100% of focused Success Measure scenarios with sufficient evidence, proposed measures appear with the Objective and support approval, modification, replacement, or removal.
- **SC-004**: In 100% of focused insufficient-evidence scenarios, discovery is used only for missing proposal support, missing reasonable Success Measures, or consequential unresolved ambiguity.
- **SC-005**: In 100% of focused selection scenarios, recommendation selection enters development or the active queue without capturing an Objective.
- **SC-006**: In 100% of focused multi-selection scenarios, queue items are developed in selected order and each reaches proposal, one review, and capture before the next item begins.
- **SC-007**: In 100% of focused review scenarios, a Converged Objective proposal follows the path proposal, one review, capture, and next Objective without a redundant second review cycle.
- **SC-008**: 0% of focused regression checks report changes to Objective ownership, Success, Highway Relevance, recommendation adoption, queue, continuation, portfolio assessment, identifiers, catalog, atomic persistence, setup orchestration, Repository Context, readiness, mutation output, non-write, duplicate, overlap, acceptance, or revalidation contracts.
- **SC-009**: Existing Objective and full repository verification suites remain passing after implementation.

## Assumptions

- Accepted Profile remains the only declared source that may provide accepted organizational evidence for Objective interpretation, recommendations, Success Measures, Highway Relevance, or Rationale.
- Existing Objective records remain accepted context for duplicate and overlap handling but do not become a new source of organizational facts.
- A Converged Objective proposal is a Working Idea until the existing Objective acceptance boundary is crossed.
- The active Objective queue is transient and preserves the person's selected order without changing identifiers, records, catalogs, or baseline versions.
- A person-provided Objective enters the same lifecycle but may move quickly when it is already complete and no grounded development would materially improve it.
- The owner may synthesize a concise Rationale from accepted evidence and does not ask a separate Rationale question.
- Static document checks can verify lifecycle wording, queue boundaries, proposal fields, review count, and protected contracts, but cannot alone establish runtime conversational quality.

## Out of Scope

- Changing Business Objective, Success, or Highway Relevance ownership or discovery dimensions.
- Changing Objective record schema, catalog format, permanent identifier allocation, baseline versions, duplicate detection, overlap detection, atomic mutation, readiness, mutation output, or non-write behavior.
- Changing Profile behavior, the Highway Experience Standard, Highway Identity, or declared Repository Context sources.
- Replacing the existing Objective acceptance boundary or introducing a second persistence mechanism.
- Treating recommendation selection, queue membership, proposal presentation, or review as Objective capture without the existing owner-controlled acceptance and persistence boundary.
- Adding external services, new durable queue records, or a new Objective dimension.
