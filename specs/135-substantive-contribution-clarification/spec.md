# Feature Specification: Substantive Contribution Re-evaluation and Conversational Clarification

**Feature Branch**: `135-substantive-contribution-clarification`

**Created**: 2026-10-03

**Status**: Draft

**Input**: Amend the Experience Standard so every substantive contribution is reconsidered in context, while clarification remains selective and is used only for consequential uncertainty that requires the person's information.

## User Scenarios & Testing

### User Story 1 - Reconsider substantive contributions (Priority: P1)

When a person supplies information that can change the active understanding during collaborative development, Highway considers what that contribution changes before selecting the next user-relevant behavior.

**Why this priority**: This closes the central reasoning gap between receiving an answer and advancing the workflow, preventing meaningful information from being treated as mere completion of the preceding question.

**Independent Test**: Present a contribution that adds, changes, corrects, removes, distinguishes, qualifies, redirects, or otherwise supplies consequential information, then verify that the next behavior reflects the changed understanding or the uncertainty it introduces.

**Acceptance Scenarios**:

1. **Given** a Working Idea is developing and the person adds a second meaningful line of business, **When** Highway receives the response, **Then** Highway re-evaluates the active organizational understanding and selects its next behavior from that updated understanding.
2. **Given** the person accepts a proposal and adds new information, **When** Highway receives the combined response, **Then** Highway honors acceptance behavior and also re-evaluates the added information as a Substantive Contribution.
3. **Given** a contribution is clear and does not create consequential uncertainty, **When** Highway re-evaluates it, **Then** Highway incorporates the responsible interpretation without manufacturing a clarification question.

### User Story 2 - Resolve consequential uncertainty selectively (Priority: P1)

When re-evaluation reveals materially different interpretations, an unresolved assumption, contradiction, missing fact, or unclear relationship that can change the active result, Highway uses one focused Conversational Clarification when the person's information is required.

**Why this priority**: Selective clarification preserves accuracy without turning every meaningful response into an interrogation or a mandatory workflow stage.

**Independent Test**: Exercise clear contributions and ambiguous contributions separately, verifying that only the latter produce a focused clarification when silent interpretation could change the active result.

**Acceptance Scenarios**:

1. **Given** a contribution supports two materially different interpretations, **When** choosing silently could change the active result, **Then** Highway asks one focused question that lets the person resolve the uncertainty before advancing.
2. **Given** a contribution exposes an uncertainty Highway can resolve responsibly from active and accepted context, **When** Highway re-evaluates it, **Then** Highway incorporates that interpretation without asking the person to explain information already understood well enough to use.
3. **Given** a clarification is needed, **When** Highway presents it, **Then** the clarification is the only unresolved response-demanding question in that interaction turn.

### User Story 3 - Preserve collaborative-development boundaries (Priority: P1)

The person can clarify meaning and continue developing a Working Idea without that clarification becoming artifact acceptance, persistence, or a replacement for the distinct Contribution Opportunity and Converged Proposal boundaries.

**Why this priority**: The shared reasoning behavior must improve understanding without creating persisted clarification state or weakening owner-controlled completion.

**Independent Test**: Resolve an ambiguity during Working Idea development, then verify that Highway continues development, later applies Contribution Opportunity when X2.37 requires it, and preserves separate Converged Proposal acceptance.

**Acceptance Scenarios**:

1. **Given** a person resolves a consequential ambiguity, **When** the clarification response is received, **Then** Highway updates transient understanding without treating the Working Idea or Converged Proposal as accepted.
2. **Given** a clarification question has occurred during development, **When** the Working Idea later reaches the X2.37 boundary, **Then** Highway provides a distinct Contribution Opportunity unless an equivalent substantive opportunity already occurred.
3. **Given** a Contribution Opportunity is applicable, **When** Highway presents it, **Then** it is not combined with clarification, artifact acceptance, or another unresolved decision.
4. **Given** the owning workflow has a complete candidate, **When** it presents the Converged Proposal, **Then** existing acceptance and persistence behavior remains unchanged.

### User Story 4 - Apply the shared model without importing artifact mechanics (Priority: P1)

The Experience Standard distinguishes conversational reasoning from the deterministic clarification records owned by highway-clarify and provides enough shared guidance for later narrow Profile synchronization.

**Why this priority**: The amendment must generalize user-visible reasoning across workflows without moving source-artifact ownership or introducing a second clarification system.

**Independent Test**: Inspect the amended standard for the three new X2 rules, the interaction model, collaborative-development guidance, natural examples, preserved rule references, and the absence of clarify-specific artifact mechanics.

**Acceptance Scenarios**:

1. **Given** the standard is amended, **When** its rules are reviewed, **Then** X2.38, X2.39, and X2.40 are added without renumbering existing X rules or redefining X2.8, X2.18, X2.19, X2.21, X2.22, X2.37, X1.7, or X2.4.
2. **Given** a workflow needs conversational clarification, **When** it follows the standard, **Then** it does not create clarification records, CLAR identifiers, finding states, clarification catalogs, persisted clarification history, or artifact-specific clarification ownership unless an owning workflow separately invokes that capability.
3. **Given** the Experience Standard amendment is complete, **When** Profile synchronization is planned, **Then** Profile can demonstrate substantive-contribution re-evaluation and selective clarification for Identity, Vision, Competitive Path, and Guiding Principles without changing Profile schema, readiness, persistence, or Setup ownership.

### Edge Cases

- A response that only accepts, confirms, rejects, declines, or selects an already-presented decision is not a Substantive Contribution and follows existing acceptance or selection behavior.
- An acceptance response that also adds information is both an acceptance response and a Substantive Contribution; both behaviors apply.
- A contribution may reveal several uncertainties, but the interaction still presents at most one unresolved clarification question at a time.
- A contribution may be substantively meaningful without requiring any visible clarification when one responsible interpretation is available.
- A clarification may resolve ambiguity without satisfying Contribution Opportunity unless it also meaningfully invites the person to add, correct, remove, or extend the developed substance.
- A missing fact that cannot change the active result does not justify a clarification question.
- A clarification question must not silently choose among materially different interpretations or ask the person to resolve information Highway can responsibly interpret.
- Working Ideas, Substantive Contributions, interpretations, unresolved ambiguity, and clarification reasoning remain transient until the existing acceptance boundary is crossed.
- The amendment must not import deterministic clarification-record concepts from highway-clarify into the shared standard.

## Requirements

### Functional Requirements

- **FR-001**: The Experience Standard MUST define `Substantive Contribution` as a person's response that adds, changes, corrects, removes, distinguishes, qualifies, redirects, or otherwise supplies information that can change the active understanding.
- **FR-002**: The Experience Standard MUST define `Conversational Clarification` as transient focused resolution of consequential ambiguity, unresolved assumption, contradiction, missing fact, unclear relationship, or materially different interpretation during active understanding development.
- **FR-003**: The standard MUST state that a response containing only acceptance, rejection, confirmation, decline, or selection without new information is not a Substantive Contribution.
- **FR-004**: After a Substantive Contribution, an Interactive Workflow MUST re-evaluate the active understanding before selecting its next user-relevant behavior.
- **FR-005**: The observable result of re-evaluation MUST reflect what the contribution changes, clarifies, introduces, corrects, qualifies, connects, or leaves unresolved when considered with relevant active and accepted context.
- **FR-006**: When re-evaluation reveals consequential uncertainty that the person can resolve, an Interactive Workflow MUST address that uncertainty before advancing past the affected understanding.
- **FR-007**: When ambiguity, an unresolved assumption, contradiction, missing fact, unclear relationship, or materially different interpretation can change the active result, the next interaction MUST resolve or explicitly preserve that uncertainty rather than silently choosing an interpretation.
- **FR-008**: An Interactive Workflow MUST NOT ask a clarification question when re-evaluation already supports one responsible interpretation that does not require user-supplied information.
- **FR-009**: The new X2 rules MUST use the next available stable identifiers, X2.38, X2.39, and X2.40, without renumbering existing rules.
- **FR-010**: The Interaction model MUST describe substantive-contribution re-evaluation, focused Conversational Clarification when the person's information is required, and direct continuation when a responsible interpretation is available.
- **FR-011**: Collaborative Development guidance MUST describe the inner loop as listening to what a contribution changes, updating the working understanding, resolving consequential ambiguity when required, contributing useful thinking, and continuing only while development adds value.
- **FR-012**: Collaborative Development guidance MUST state that re-evaluation is universal for Substantive Contributions while visible clarification is selective.
- **FR-013**: The standard MUST include a non-normative Conversational Clarification section covering possible ambiguity, assumptions, contradictions, missing facts, relationships, qualifications, and implications.
- **FR-014**: The standard MUST include natural clarification examples and MUST state that they are illustrative rather than required templates.
- **FR-015**: The standard MUST distinguish Conversational Clarification from Contribution Opportunity, including that clarification does not automatically satisfy X2.37.
- **FR-016**: The standard MUST distinguish Conversational Clarification from artifact review and acceptance; resolving ambiguity MUST NOT itself accept a Working Idea or Converged Proposal.
- **FR-017**: The standard MUST describe the conceptual progression from Substantive Contribution through contextual re-evaluation, selective clarification, continued development, Contribution Opportunity when applicable, Converged Proposal, and acceptance without requiring every step on every interaction.
- **FR-018**: Contextual Re-evaluation guidance MUST cover both transient Working Idea development after Substantive Contributions and accepted-knowledge re-evaluation after artifact acceptance.
- **FR-019**: The explanatory re-evaluation lifecycle MUST distinguish the pre-acceptance Substantive Contribution loop from the post-acceptance Accepted Knowledge loop.
- **FR-020**: Conversational Presence guidance MUST require the next response to reflect changed understanding rather than merely advancing to the next workflow question when new substantive information is supplied.
- **FR-021**: Constructive Advisory guidance MUST include re-evaluation, selective clarification, useful sharpening or contribution, Contribution Opportunity when applicable, Converged Proposal, and questions only when unresolved information or a user decision is genuinely required.
- **FR-022**: Interaction Examples MUST cover substantive contribution before workflow advancement, clear contribution without interrogation, consequential ambiguity, clarification versus Contribution Opportunity, and acceptance plus new information.
- **FR-023**: The amendment MUST preserve X1.7, X2.2, X2.4, X2.8, X2.13, X2.18, X2.19, X2.21, X2.22, X2.37, adaptive depth, Active Reasoning Context, transience, and owner authority.
- **FR-024**: The amendment MUST NOT add clarification records, CLAR identifiers, finding fingerprints, ambiguity vocabularies, clarification catalogs, finding states, revision state, persisted clarification history, A/B/C/D clarification options, or artifact-specific clarification ownership to the Experience Standard.
- **FR-025**: The amendment MUST classify the Experience Standard version change under its existing policy; adding shared obligations without removing existing X rules is a minor version change from 8.1.0 to 8.2.0.
- **FR-026**: The specification MUST define a narrow downstream synchronization expectation for highway-profile across Identity, Vision, Competitive Path, and Guiding Principles without changing Profile schema, readiness, persistence, or Setup ownership in this amendment.

### Key Entities

- **Substantive Contribution**: Transient conversational input that can change the active understanding; it is not retained state, an artifact, a persistence event, or an acceptance boundary.
- **Conversational Clarification**: Transient focused interaction used to resolve consequential uncertainty when the person's information is required; it does not create a clarification record by itself.
- **Working Idea**: Transient developing interpretation, contribution, recommendation, alternative, implication, or related thread before artifact acceptance.
- **Contribution Opportunity**: The distinct X2.37 opportunity for the person to add, correct, remove, or extend developed substance before convergence.
- **Converged Proposal**: Complete candidate representation presented for the owning workflow's existing acceptance decision.
- **Accepted Knowledge**: User-owned knowledge that crossed the existing acceptance boundary and can inform later contextual re-evaluation.
- **Active Reasoning Context**: Transient task-anchored context containing relevant developing ideas, uncertainty, implications, alternatives, tensions, and contributions.

## Success Criteria

### Measurable Outcomes

- **SC-001**: In 100% of tested scenarios containing a Substantive Contribution, the next user-relevant behavior reflects the contribution's changed, clarified, introduced, corrected, qualified, connected, or unresolved meaning in active context.
- **SC-002**: In 100% of tested clear-contribution scenarios, Highway continues without a ceremonial clarification question when no consequential user-owned uncertainty remains.
- **SC-003**: In 100% of tested consequential-ambiguity scenarios, Highway asks no more than one focused clarification question before advancing past the affected understanding.
- **SC-004**: In 100% of tested clarification scenarios, resolving ambiguity does not itself accept or persist the Working Idea or Converged Proposal.
- **SC-005**: In 100% of tested workflows where X2.37 applies, Conversational Clarification and Contribution Opportunity remain distinguishable, and clarification counts as the Contribution Opportunity only when it genuinely invites substantive additions, corrections, removals, or extensions.
- **SC-006**: The amended standard preserves all named existing rules and owner boundaries, with no new persisted state or clarify-specific artifact mechanics introduced.
- **SC-007**: Reviewers can identify the six interaction concepts separately: Substantive Contribution, Conversational Clarification, Working Idea development, Contribution Opportunity, Converged Proposal, and Acceptance.
- **SC-008**: The Experience Standard version advances exactly one minor increment from 8.1.0 to 8.2.0, and the three new X2 rules use X2.38 through X2.40 without changing existing rule IDs.

## Assumptions

- The authoritative source file for this feature is `.highway/governance/experience-standard.md`.
- The amendment is a shared interaction-standard change; no implementation runtime, persistence schema, or clarification-record store is required.
- Existing X2.8 accepted-information re-evaluation remains unchanged and is supplemented by earlier transient re-evaluation after Substantive Contributions.
- Existing X2.2 and X2.13 contribution-first behavior, X1.7 and X2.4 one-question constraints, X2.37 Contribution Opportunity semantics, and owner-controlled acceptance and persistence remain authoritative.
- `highway-clarify` remains the owner of deterministic clarification records for its supported source artifacts; this feature does not alter that capability.
- Profile synchronization is a narrow follow-on consumer expectation and will be planned so Profile demonstrates the shared model before other owners, without moving the shared standard's authority into Profile.
- No clarification markers are required because the requested rule IDs, version classification, scope, and protected boundaries have reasonable repository-grounded defaults.

## Out of Scope

- Changes to `.highway/skills/highway-clarify/SKILL.md` or its deterministic clarification records.
- Clarification records, CLAR identifiers, finding fingerprints, ambiguity vocabularies, clarification catalogs, finding states, revision state, persisted clarification history, or fixed A/B/C/D options in the Experience Standard.
- Changes to X1.7, X2.2, X2.4, X2.8, X2.13, X2.18, X2.19, X2.21, X2.22, or X2.37 semantics or identifiers.
- New persisted state, readiness values, lifecycle markers, or owner-result fields for Substantive Contribution or Conversational Clarification.
- Determining domain validity, artifact structure, acceptance, persistence, or owner results in the Experience Standard.
- Broad synchronization of Objectives, Controls, NFRs, or other owners; Profile is the narrow downstream proving consumer identified for later planning.
