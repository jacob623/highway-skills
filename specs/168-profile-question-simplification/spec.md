# Feature Specification: Profile Question-Bias Simplification

**Feature Branch**: `168-profile-question-simplification`

**Created**: 2026-10-13

**Status**: Draft

**Input**: User description: "Simplify highway-profile guidance so grounded reasoning normally becomes structured proposal content and user reaction, rather than an additional exploratory question. Narrow advisory question scaffolding, remove question-centric worked examples, simplify structure-revealing contributions, and strengthen Interpretation Confidence while preserving consequential-ambiguity clarification and canonical fallback questions."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review grounded reasoning inside a starting point (Priority: P1)

As a person configuring a Profile, I want accepted evidence and useful advisory reasoning to appear inside an active Discovery Contribution Opportunity so that I can react to a coherent starting point instead of reconstructing the interpretation through extra questions.

**Why this priority**: This is the central behavior change and directly reduces unnecessary conversational effort while preserving user authority over the proposed Profile content.

**Independent Test**: Present accepted evidence sufficient for a responsible Vision, Competitive Path, or Guiding Principles interpretation and verify that the guidance directs the reasoning into the structured starting point and its shared reaction path.

**Acceptance Scenarios**:

1. **Given** accepted evidence supports a responsible first-pass interpretation and a Discovery Contribution Opportunity is active, **When** grounded advisory reasoning is available, **Then** the reasoning is incorporated into the proposed starting point rather than used to justify an additional exploratory question.
2. **Given** a structured starting point is presented, **When** the person responds with an addition, correction, removal, or replacement, **Then** the response remains within the existing contribution and refinement flow.
3. **Given** accepted evidence does not support a responsible starting point, **When** the workflow needs information owned by the person, **Then** the canonical fallback question remains available.

### User Story 2 - Receive only necessary clarification (Priority: P1)

As a person contributing Profile information, I want questions reserved for consequential ambiguity or missing evidence so that questions remain useful and result-changing rather than automatic closures to every insight.

**Why this priority**: Preserving focused clarification protects accuracy while removing the question bias; it is the primary safety boundary for the simplification.

**Independent Test**: Evaluate representative interactions containing sufficient evidence, unresolved consequential ambiguity, and insufficient evidence, and verify that only the latter two cases retain advisory questions.

**Acceptance Scenarios**:

1. **Given** accepted evidence leaves a consequential ambiguity that can change the Profile result, **When** the ambiguity cannot be resolved through responsible framing, **Then** a focused advisory question remains appropriate.
2. **Given** accepted evidence already supports a responsible starting point, **When** the only purpose of a question would be to obtain permission to express an interpretation, **Then** no additional exploratory question is required.
3. **Given** the user has not supplied enough information for a responsible starting point, **When** the unresolved domain needs user-owned information, **Then** the existing canonical fallback question is used.

### User Story 3 - Learn from proposal-shaped examples (Priority: P2)

As a maintainer reviewing Profile guidance, I want examples and structure guidance to reinforce proposal-first interaction so that the document does not teach a competing insight-to-question pattern.

**Why this priority**: Removing contradictory teaching material makes the intended behavior more consistent without creating a new workflow or lifecycle.

**Independent Test**: Inspect the Profile guidance and verify that the three question-closing worked examples are absent, the unsupported-reasoning counter-example remains, and structure guidance directs implications and possibilities into an active starting point.

**Acceptance Scenarios**:

1. **Given** the Contribution in practice guidance is read, **When** a maintainer checks its worked examples, **Then** the three question-centric examples are absent and the unsupported-reasoning counter-example remains.
2. **Given** structure-revealing guidance is read while a Discovery Contribution Opportunity is active, **When** structure, implications, tradeoffs, or possibilities are developed, **Then** they are directed into the proposed starting point and not automatically closed with another question.
3. **Given** a user-facing proposal is not active, **When** a consequential ambiguity remains unresolved, **Then** the guidance still permits a focused question.

### Edge Cases

- A useful interpretation exists, but the accepted evidence is too weak or contradictory to support a responsible starting point; the workflow must ask rather than manufacture proposal content.
- A starting point is active and the person supplies a substantive correction; the workflow must re-present the updated proposal flow without adding a redundant exploratory question.
- A canonical fallback question is needed after advisory reasoning cannot responsibly resolve the missing information; the fallback remains available and is not removed by the simplification.
- The unsupported-reasoning counter-example must remain available even though the three question-centric worked examples are removed.
- The change must not alter Profile domain ownership, acceptance boundaries, persistence behavior, readiness, or retained schema fields.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile guidance MUST direct grounded advisory reasoning into an active Discovery Contribution Opportunity's structured starting point when accepted evidence supports a responsible first-pass interpretation.
- **FR-002**: Profile guidance MUST reserve advisory questions for cases where accepted evidence cannot support a responsible starting point or consequential ambiguity remains unresolved.
- **FR-003**: Profile guidance MUST preserve direct clarification of consequential ambiguity and canonical fallback questions for unresolved user-owned information.
- **FR-004**: Profile guidance MUST remove the instruction that advisory reasoning should be used to explain an additional exploratory question when a Discovery Contribution Opportunity is active.
- **FR-005**: Profile guidance MUST remove the three question-centric worked examples from Contribution in practice while retaining that section's purpose and unsupported-reasoning counter-example.
- **FR-006**: Profile guidance MUST express revealed structure and its implications in the most useful form for the active interaction, including inside a proposed starting point when one is active.
- **FR-007**: Profile guidance MUST replace the instruction to close a connected advisory move with a reaction question with guidance to let the person react through the active Discovery Contribution Opportunity.
- **FR-008**: Profile guidance MUST state that a grounded interpretation should be expressed inside a proposed starting point rather than questioned separately when a Discovery Contribution Opportunity is active.
- **FR-009**: Profile guidance MUST preserve the existing shared reaction invitation, provisional status, convergence flow, acceptance boundary, persistence behavior, readiness behavior, ownership, attribution, and retained Profile schema.
- **FR-010**: Generated Profile delivery surfaces MUST remain identical to the authoritative Profile guidance after the simplification is applied.
- **FR-011**: The simplification MUST remain limited to the Profile guidance and its directly corresponding validation contracts; it MUST NOT add a new lifecycle state, persisted artifact, readiness dimension, or runtime service.

## Key Entities *(include if feature involves data)*

- **Discovery Contribution Opportunity**: A transient, structured proposal-first presentation that gives the person something grounded to add, correct, remove, or extend before convergence.
- **Structured Starting Point**: A provisional, reviewable representation of grounded interpretation, implication, tradeoff, or possibility for an active Profile domain.
- **Advisory Question**: A focused question used only for consequential ambiguity or information that accepted evidence cannot responsibly supply.
- **Contribution in Practice Guidance**: Profile guidance that demonstrates useful grounded contribution and its boundaries.
- **Profile Guidance Surface**: The authoritative Profile instructions and their generated delivery copies.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the three Profile domain guidance paths (Vision, Competitive Path, and Guiding Principles) explicitly direct grounded advisory reasoning into the active structured starting point when responsible evidence exists.
- **SC-002**: 100% of representative cases with sufficient accepted evidence avoid an additional exploratory question whose only purpose is to obtain permission to express a grounded interpretation.
- **SC-003**: 100% of representative cases with unresolved consequential ambiguity or insufficient user-owned evidence retain an appropriate focused or canonical fallback question.
- **SC-004**: The three question-centric worked examples are absent, while the Contribution in practice section and unsupported-reasoning counter-example remain present.
- **SC-005**: All generated Profile delivery surfaces match the authoritative guidance byte-for-byte after regeneration.
- **SC-006**: Existing Profile acceptance, persistence, readiness, ownership, attribution, and retained-schema checks remain passing after the simplification.
- **SC-007**: Maintainers reviewing the updated guidance can identify the intended sequence as reasoning, structured starting point, and reaction without encountering a competing default instruction that turns every useful observation into a question.

## Assumptions

- The existing Vision, Competitive Path, and Guiding Principles Discovery Contribution Opportunities are the proposal-first interaction surface for this change.
- The shared reaction invitation remains the primary response path when a structured starting point is active.
- Direct clarification of consequential ambiguity and canonical fallback questions remain necessary and are not removed.
- The Profile source remains authoritative; generated delivery copies continue to be regenerated from it.
- No new durable data model, lifecycle state, readiness field, or external dependency is required.
- Validation is primarily document-contract and generated-correspondence verification; this feature does not claim to prove runtime conversational behavior from static text alone.
- Existing Profile domain semantics and user-owned acceptance boundaries remain unchanged.
