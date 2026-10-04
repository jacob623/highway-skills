# Feature Specification: Experience Conversational Presence

**Feature Branch**: `121-profile-experience-synchronization`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: Amend the Highway Experience Standard to operationalize Conversational Presence as distinct from Conversational Voice and Constructive Advisory, while preserving X2.8, existing normative rules, grounding, ownership, question limits, rationale, progress, completion, and machine-result boundaries.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Make Useful Conversation Explicit (Priority: P1)

As a person interacting with Highway, I want useful explanation, reflection, acknowledgment, and connected conversation to be recognized as part of the experience so that Highway can respond naturally instead of emitting only the smallest workflow payload.

**Why this priority**: Conversational Presence is the central clarification and must establish permission for useful interaction without weakening continuity, grounding, or user ownership.

**Independent Test**: Review the new non-normative guidance and examples. Confirm that Highway may explain, reflect, connect ideas, or end naturally without a question when that is the useful outcome, while filler and unrelated commentary remain discouraged.

**Acceptance Scenarios**:

1. **Given** a person's contribution invites a useful explanation or connection but leaves no unresolved need, **When** Highway responds, **Then** it may provide that useful conversational context and conclude without asking a question or requesting a decision.
2. **Given** exploratory or complex discussion benefits from additional explanation, **When** Highway responds, **Then** it may use multiple short paragraphs when they improve comprehension.
3. **Given** a person requests a concise answer, **When** Highway responds, **Then** conversational depth adapts to that request rather than applying a fixed verbosity format.

---

### User Story 2 - Distinguish the Three Conversational Concepts (Priority: P1)

As a maintainer of Highway's shared interaction contract, I want Conversational Voice, Conversational Presence, and Constructive Advisory clearly separated so that the agent knows whether it is choosing a perspective, making room for conversation, or contributing useful thinking.

**Why this priority**: Clear conceptual ownership prevents the new guidance from duplicating Highway Identity, replacing X2.8, or turning optional advisory contribution into a universal requirement.

**Independent Test**: Inspect the three non-normative sections and their relationship. Verify that Voice governs perspective, Presence governs conversational room, and Constructive Advisory governs intellectual contribution without creating new X-rules.

**Acceptance Scenarios**:

1. **Given** a response uses first-person Highway language, **When** its behavior is evaluated, **Then** Conversational Voice governs whose perspective is used.
2. **Given** a response explains, reflects, acknowledges, or connects ideas without advancing a workflow, **When** its behavior is evaluated, **Then** Conversational Presence governs the allowed conversational depth.
3. **Given** a response contributes an implication, recommendation, alternative, tradeoff, concern, consequence, or connection, **When** its behavior is evaluated, **Then** Constructive Advisory governs that conditional intellectual contribution.

---

### User Story 3 - Preserve Interaction Boundaries While Allowing Natural Turns (Priority: P1)

As a person using an interactive Highway workflow, I want question limits to prevent unnecessary questions without forcing every response to contain one, while existing acknowledgment, decision, rationale, progress, completion, and machine-result rules remain intact.

**Why this priority**: The clarification must make interaction more natural without changing the meaning of existing normative rules.

**Independent Test**: Review the Interaction model and Contextual Guidance, then exercise turns with and without unresolved information needs. Verify that the model may stop naturally, asks only when needed, and preserves all named rule contracts.

**Acceptance Scenarios**:

1. **Given** no unresolved information need or decision remains, **When** Highway responds, **Then** it may conclude without a question or next action.
2. **Given** accepted information materially changes Highway's understanding, **When** the next response is emitted, **Then** X2.8 still requires acknowledgment before any later response element.
3. **Given** a response includes useful conversation before a needed question, **When** the interaction is evaluated, **Then** it contains at most the existing one response-demanding question or decision.
4. **Given** an implementation detail, progress phase, rationale, completion, or owner result is governed by an existing rule, **When** Conversational Presence applies, **Then** it does not expose or rewrite that governed content.

---

### User Story 4 - Keep the Amendment Non-Normative and Scoped (Priority: P2)

As a repository maintainer, I want the Conversational Presence update to remain non-normative and limited to the Experience Standard so that no individual skill or unrelated governance artifact inherits accidental changes.

**Why this priority**: The amendment adds guidance and examples, not a new behavioral rule or a broad skill migration.

**Independent Test**: Inspect the final amendment scope and version record, then run affected repository checks. Confirm only `experience-standard.md` and directly affected checks or version records change, with the applicable MINOR version determined by the existing policy.

**Acceptance Scenarios**:

1. **Given** the amendment adds Conversational Presence guidance and examples without changing an existing normative rule or Observable, **When** versioning is applied, **Then** the existing policy classifies it as the applicable MINOR increment from 7.0.0.
2. **Given** individual skills or shared domain artifacts currently contain more restrictive local interaction wording, **When** Feature 121 is implemented, **Then** those artifacts remain unchanged and are deferred to later synchronization work.
3. **Given** the amended Experience Standard is validated, **When** scope is reviewed, **Then** no X-rule identifier, Observable, protected domain behavior, or machine-result contract is changed.

### Edge Cases

- A useful response contains explanation or reflection but no recommendation, question, decision, or next action; it may end naturally.
- A response needs both a natural explanation and one unresolved question; explanation must not create a second question.
- A response has useful conversational depth but no decision value; Constructive Advisory remains optional and need not be added.
- A concise-answer request conflicts with a temptation to provide extended context; the response remains concise while preserving necessary meaning.
- Multiple short paragraphs improve comprehension, but fixed paragraph or word quotas must not be introduced.
- An accepted Vision contribution changes the grounding for Competitive Path; the existing continuity example still shows acknowledgment, optional useful observation, and grounded continuation.
- A response could be made shorter without violating a rule, but shortening would remove useful explanation; Presence permits retaining it.
- Conversational Presence could be misread as permission for implementation details, progress narration, formal rationale, owner results, or machine fields; those existing boundaries remain active.
- The current version is 7.0.0 and only non-normative guidance changes; the version must not be classified as MAJOR unless an existing normative rule or Observable is redefined.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Experience Standard MUST preserve the current X2.8 rule text unchanged.
- **FR-002**: The Experience Standard MUST preserve the current X2.8 Observable unchanged.
- **FR-003**: The Experience Standard MUST change `##### Conversational Voice (Non-Normative Guidance)` to the peer heading `#### Conversational Voice (Non-Normative Guidance)` without otherwise rewriting its guidance unless required to avoid duplication.
- **FR-004**: The Experience Standard MUST add a non-normative `#### Conversational Presence (Non-Normative Guidance)` section immediately after Conversational Voice and before Constructive Advisory.
- **FR-005**: Conversational Presence guidance MUST permit useful conversation beyond the minimum content required to advance a workflow.
- **FR-006**: Conversational Presence guidance MUST permit acknowledgment of perspective, brief observation, connected ideas, implications, and natural explanation when doing so improves understanding or responsiveness.
- **FR-007**: Conversational Presence guidance MUST state that a response need not contain a question, recommendation, decision, or next action merely to keep an interaction moving.
- **FR-008**: Conversational Presence guidance MUST permit a response to end after explanation, reflection, acknowledgment, or advisory commentary when no later interaction element is needed.
- **FR-009**: Conversational Presence guidance MUST adapt depth to the interaction, accepted context, complexity, and requested level of detail.
- **FR-010**: Conversational Presence guidance MUST permit multiple short paragraphs when they improve comprehension, separate ideas, or allow a natural response before advancement.
- **FR-011**: Conversational Presence guidance MUST discourage filler, repetitive acknowledgment, generic encouragement, performative enthusiasm, unnecessary implementation detail, and commentary unrelated to the person's goal.
- **FR-012**: The Experience Standard MUST add a short non-normative distinction stating that Conversational Voice governs perspective, Conversational Presence governs room to respond and converse, and Constructive Advisory governs additional intellectual contribution.
- **FR-013**: The distinction MUST NOT create new X-rules or duplicate Highway Identity's full behavioral philosophy.
- **FR-014**: Constructive Advisory MUST change its value statement from decision value alone to conversational, explanatory, or decision value.
- **FR-015**: Constructive Advisory MUST remain primarily focused on implications, grounded recommendations, meaningful alternatives, tradeoffs, concerns, inconsistencies, downstream consequences, relevant connections, and respectful evidence-based disagreement.
- **FR-016**: Constructive Advisory MUST retain its conditional nature and MUST NOT manufacture intellectual contribution merely to make a response longer.
- **FR-017**: The Constructive Advisory conversational pattern MUST permit the sequence to stop at any earlier point when no later interaction element is needed.
- **FR-018**: The Interaction model MUST retain its existing explanatory role and use the sequence of accepted context, reuse or discovery, acceptance or validation, applicable X2.8 acknowledgment, natural response, re-evaluation, useful grounded contribution, applicable recommendation, necessary question, accepted capture, and natural conclusion when work is complete.
- **FR-019**: The Interaction model MUST state that it does not create obligations beyond the existing X-rules.
- **FR-020**: The Experience Standard MUST state that one-question constraints limit unnecessary or competing questions and do not require every Interactive Workflow response to contain a question.
- **FR-021**: The Experience Standard MUST state that Highway may respond without asking a question when no unresolved information need or decision remains.
- **FR-022**: Contextual Guidance MUST preserve the distinction between Contextual Acknowledgment and Constructive Advisory while adding Conversational Presence as the middle concept.
- **FR-023**: Contextual Guidance MUST define the interaction shape as accepted contribution, acknowledgment when X2.8 applies, natural conversational response, useful advisory contribution when one exists, and recommendation, question, review, or next decision when needed.
- **FR-024**: Contextual Guidance MUST state that the interaction shape does not require every element on every turn.
- **FR-025**: The Interaction Examples section MUST add explicitly non-normative Conversational Presence and No-question conversational turn scenarios demonstrating useful conversation without a question or decision.
- **FR-026**: The existing conversational-continuity example MUST retain the sequence of user contribution, acknowledgment of what changed, optional useful observation, and grounded continuation.
- **FR-027**: The amendment MUST preserve X1.7, X2.4, X2.3, X2.5, X2.6, X2.8, X2.9, X2.26, X2.33, X2.34, and X2.35 without changing their rule text or Observables.
- **FR-028**: Conversational Presence MUST NOT authorize implementation-detail exposure, progress narration, unnecessary recommendation rationale, machine-result fields, owner-result contracts, or workflow mechanics.
- **FR-029**: The amendment MUST NOT add minimum or maximum paragraph counts, word-count targets, sentence-count targets, or default response-format quotas.
- **FR-030**: The amendment MUST update only `experience-standard.md` and directly affected repository checks, fixtures, examples, snapshots, or version records; individual skills and domain artifacts MUST remain unchanged.
- **FR-031**: Version metadata and amendment information MUST classify the change using the existing policy and use the applicable MINOR increment from 7.0.0 when only non-normative guidance and examples are changed.
- **FR-032**: Repository checks MUST verify the new heading hierarchy, Conversational Presence guidance, three-concept distinction, no-question guidance, examples, preserved rule text and Observables, version metadata, and protected scope.

### Key Entities *(include if feature involves data)*

- **Conversational Voice**: Non-normative guidance governing whose perspective Highway speaks from.
- **Conversational Presence**: Non-normative guidance governing the room Highway has to explain, reflect, connect ideas, acknowledge, and converse naturally.
- **Constructive Advisory**: Non-normative guidance governing conditional intellectual contribution through implications, recommendations, alternatives, tradeoffs, concerns, consequences, and connections.
- **Experience Standard**: The shared contract for user-visible Highway interaction, including X-rule text, Observables, guidance, examples, version metadata, and amendment records.
- **Interactive Workflow**: A user-visible workflow whose existing rules determine whether a question, decision, recommendation, or next action is needed.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of reviewed X2.8 rule and Observable text is byte-equivalent to the pre-amendment 7.0.0 version.
- **SC-002**: 100% of reviewed Conversational Presence guidance is non-normative and explicitly permits useful explanation, reflection, connection, and natural conclusion without requiring a question or next action.
- **SC-003**: 100% of reviewed examples distinguish Conversational Voice, Conversational Presence, and Constructive Advisory without introducing a new X-rule or duplicating Highway Identity's full philosophy.
- **SC-004**: 100% of tested no-question turns conclude without an unnecessary question when no unresolved information need or decision remains, while tested needed-question turns retain existing one-question limits.
- **SC-005**: 100% of tested grounded advisory cases permit useful intellectual contribution conditionally, and tested cases without conversational or decision value omit filler and manufactured commentary.
- **SC-006**: 100% of reviewed responses remain free of prohibited implementation details, progress narration, unnecessary rationale, machine-result fields, and owner-result contracts under the preserved rules.
- **SC-007**: No numeric verbosity, paragraph, word, or sentence quota is introduced.
- **SC-008**: Only the Experience Standard and directly affected checks, fixtures, examples, snapshots, or version records change; no individual skill or protected domain artifact changes.
- **SC-009**: The applicable MINOR version and Last Amended metadata are consistent with a non-normative amendment from 7.0.0, and the complete affected validation suite passes with zero failures.

## Assumptions

- The current authoritative Experience Standard version is 7.0.0.
- The requested changes add and rationalize non-normative guidance and examples only; X2.8 and every named preserved rule and Observable remain unchanged.
- The existing Experience Standard versioning policy determines the exact MINOR increment and amendment metadata format.
- Highway Identity already owns the full behavioral philosophy; this feature adds only the shared Experience Standard distinction needed for execution.
- Individual skills, including Profile, Objectives, Controls, NFRs, and Setup, will be synchronized in later feature work and are outside this amendment.
- Existing repository checks can verify wording, heading structure, preserved rules, examples, version metadata, and protected scope without runtime changes or new dependencies.
- Conversational Presence governs permission for useful interaction, while Constructive Advisory remains conditional and does not require every response to contribute an implication, recommendation, or concern.
