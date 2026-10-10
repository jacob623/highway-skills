# Feature Specification: Profile Response Support Text

**Feature Branch**: `157-profile-response-support-text`

**Created**: 2026-10-10

**Status**: Draft

**Input**: User description: "Create one authoritative owner for Profile validation prompts, acceptance reassurance, discovery reassurance, and combined reassurance without changing advisory behavior, structure-revealing contributions, possibility lists, convergence, acceptance boundaries, or domain reasoning."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review a candidate with consistent support text (Priority: P1)

As a person reviewing a Profile candidate or Converged Proposal, I want the validation prompt and applicable reassurance to appear in a consistent order so that I can understand how to respond without formatting drift.

**Why this priority**: Candidate review is the primary interaction where duplicated support wording can create inconsistent prompts or reassurance placement.

**Independent Test**: Inspect each Profile domain's candidate-review contract and verify that the capture heading is followed by the Validation Question and then the applicable reassurance, with the Validation Question as the only emphasized element in the review block.

**Acceptance Scenarios**:

1. **Given** a Profile domain has a candidate or Converged Proposal ready for review, **When** Profile presents it, **Then** the candidate uses its capture heading, places the Validation Question beneath it, and places the applicable reassurance beneath the question.
2. **Given** a review block contains reassurance, **When** Profile renders the block, **Then** the Validation Question is the only emphasized element in that block.
3. **Given** a sharper open question replaces the default Validation Question, **When** Profile presents it, **Then** the replacement still asks what to add, correct, or remove.

### User Story 2 - Receive the appropriate discovery reassurance (Priority: P1)

As a person asked to originate unresolved organizational information, I want discovery reassurance only when no meaningful starting point has been supplied so that the wording fits whether I am discovering information or reacting to existing material.

**Why this priority**: The distinction between originating information and reacting to a Working Idea determines whether "I don't know" support is natural and useful.

**Independent Test**: Exercise Profile entry points with no meaningful starting point, with a grounded Working Idea or possibility, and with a candidate under review; verify that Discovery, Acceptance, or Combined Reassurance is selected according to the supplied context.

**Acceptance Scenarios**:

1. **Given** the person is being asked to originate unresolved organizational information and no meaningful starting point has been supplied, **When** Profile asks the question, **Then** it may use the Discovery Reassurance.
2. **Given** a grounded possibility, interpretation, distinction, implication, connection, tension, tradeoff, recommendation, or other Working Idea has already been supplied for reaction, **When** Profile asks for the person's response, **Then** it does not use Discovery Reassurance merely because no user Substantive Contribution has occurred.
3. **Given** both candidate review and uncertainty about originating information are reasonable outcomes, **When** Profile presents the interaction, **Then** it may use the Combined Reassurance.
4. **Given** the person is reacting to a candidate or Working Idea and "I don't know" would be unnatural, **When** Profile presents the interaction, **Then** it uses Acceptance Reassurance alone.
5. **Given** imported website evidence is available but the person has not contributed substantively, **When** Profile evaluates discovery reassurance, **Then** imported evidence does not count as a user Substantive Contribution.

### User Story 3 - Maintain one authoritative support-text owner (Priority: P1)

As a maintainer of Profile guidance, I want reusable support-text definitions in one location so that future wording changes do not require editing duplicated behavioral definitions across domain guidance.

**Why this priority**: Central ownership is the maintainability outcome and reduces the risk of contradictory user-visible prompts.

**Independent Test**: Inspect Profile guidance and verify that reusable definitions are centralized, behavioral references use the canonical labels, and literal wording remains only where needed for examples or the authoritative definitions.

**Acceptance Scenarios**:

1. **Given** Profile guidance needs to describe validation or reassurance behavior, **When** the guidance refers to those elements, **Then** it uses the canonical Validation Question, Acceptance Reassurance, Discovery Reassurance, or Combined Reassurance labels where it is defining behavior.
2. **Given** a worked example or transcript-style illustration uses literal support wording, **When** the example is retained, **Then** the literal wording remains available as an example.
3. **Given** the support-text refactor is applied, **When** Profile handles advisory reasoning, structure-revealing contributions, possibility lists, convergence, acceptance boundaries, and domain reasoning, **Then** those behaviors remain unchanged.

### Edge Cases

- A candidate review has no natural uncertainty about originating information; use Acceptance Reassurance rather than Combined Reassurance.
- A discovery question has no candidate, Working Idea, interpretation, possibility, or advisory contribution available; use Discovery Reassurance.
- Both reviewing a candidate and saying "I don't know" are reasonable responses; use Combined Reassurance.
- A grounded possibility or other Working Idea is present before the person's first Substantive Contribution; do not infer that Discovery Reassurance is required.
- Imported website evidence exists without a user Substantive Contribution; preserve the imported-evidence exception.
- A sharper question is used instead of the default Validation Question; it must still ask what to add, correct, or remove.
- Literal support text appears in a worked example; do not remove it solely to reduce behavioral duplication.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile MUST define the Validation Question, Acceptance Reassurance, Discovery Reassurance, and Combined Reassurance in one authoritative support-text section.
- **FR-002**: The Validation Question MUST default to "What would you add, correct, or remove?" and a sharper replacement MUST still ask what to add, correct, or remove.
- **FR-003**: Profile MUST place the Validation Question beneath a candidate or Converged Proposal and the applicable reassurance beneath the Validation Question.
- **FR-004**: The Validation Question MUST remain the only emphasized element in a review block.
- **FR-005**: Profile MUST use Discovery Reassurance only when the person is being asked to originate unresolved organizational information and no meaningful starting point has been supplied for reaction.
- **FR-006**: Profile MUST NOT require Discovery Reassurance merely because no user Substantive Contribution has occurred when a grounded Working Idea or other meaningful starting point is available.
- **FR-007**: Profile MUST use Acceptance Reassurance when the person is reacting to a candidate or Working Idea and "I don't know" would be unnatural, and MAY use Combined Reassurance when both outcomes are reasonable.
- **FR-008**: Imported website evidence MUST NOT count as a user Substantive Contribution for Discovery Reassurance selection.
- **FR-009**: Behavioral definitions MUST use the canonical support-text labels instead of duplicating literal wording, while worked examples, transcript-style examples, illustrations, and example outputs MAY retain literal wording.
- **FR-010**: This feature MUST NOT change advisory behavior, structure-revealing contributions, possibility-list Contribution Opportunities, convergence, acceptance boundaries, or domain reasoning.
- **FR-011**: Profile MUST define domain completeness at the top of the `#### Domain completeness` section, followed by the self-contained `##### Response Support Text` subsection and then the existing `#### Advisory question scaffolding` section.
- **FR-012**: Profile MUST present every candidate under the capture heading `**Here's what I've captured as your [domain]:**`, followed by the Validation Question, a blank line, and the applicable reassurance.

## Key Entities *(include if feature involves data)*

- **Validation Question**: The default or sharper emphasized request for what the person would add, correct, or remove from a candidate or Working Idea.
- **Acceptance Reassurance**: The reassurance that the person may simply confirm accuracy when reviewing a candidate or Converged Proposal.
- **Discovery Reassurance**: The reassurance that the person may say they do not know when asked to originate unresolved organizational information without a meaningful starting point.
- **Combined Reassurance**: The single reassurance that accommodates both candidate confirmation and not knowing when both responses are reasonable.
- **Meaningful Starting Point**: A grounded starting point, Working Idea, interpretation, possibility, or advisory contribution supplied for the person's reaction.
- **User Substantive Contribution**: New information supplied by the person that changes active understanding; imported website evidence does not qualify.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of Profile candidate-review contract examples place the Validation Question beneath the candidate and the applicable reassurance beneath the question.
- **SC-002**: 100% of Profile review-block examples contain no emphasized element other than the Validation Question.
- **SC-003**: 100% of discovery-reassurance examples use Discovery Reassurance only when no meaningful starting point is available for reaction.
- **SC-004**: 100% of examples with a grounded Working Idea, possibility, or other meaningful starting point avoid selecting Discovery Reassurance solely because no user Substantive Contribution has occurred.
- **SC-005**: 100% of behavioral support-text definitions use the canonical labels, while required literal examples remain present.
- **SC-006**: 0% of focused regression checks report changes to advisory reasoning, structure-revealing contributions, possibility lists, convergence, acceptance boundaries, or domain reasoning.
- **SC-007**: The full verification suite remains passing after the support-text refactor.
- **SC-008**: The Profile source contains exactly one `##### Response Support Text` subsection after the domain-completeness definition and before the existing `#### Advisory question scaffolding` section.
- **SC-009**: 100% of Profile candidate-review contract examples use the specified capture heading and render the Validation Question before the applicable reassurance.

## Assumptions

- Profile remains the sole owner of these support-text definitions; no Experience Standard change is required.
- The support-text section is placed inside Profile domain-completeness guidance before advisory-question scaffolding.
- The existing candidate capture heading and acceptance boundary remain authoritative.
- Existing literal wording in examples is intentionally retained even when the same wording is not repeated in behavioral definitions.
- "Meaningful starting point" includes a grounded possibility, interpretation, distinction, implication, connection, tension, tradeoff, recommendation, or other Working Idea supplied for reaction.
- Imported website evidence remains distinct from a user Substantive Contribution.
- Static document checks can verify ownership and delivery contracts but cannot alone establish runtime conversational quality.

## Out of Scope

- Changing the Experience Standard.
- Changing advisory reasoning or the selection of contribution types.
- Changing structure-revealing contribution guidance.
- Changing possibility-list Contribution Opportunities.
- Changing convergence, acceptance boundaries, persistence, or domain reasoning.
- Applying the support-text ownership model to workflows outside Profile.
