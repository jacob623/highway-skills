# Feature Specification: Experience Standard Runtime Contract Refactor

**Feature Branch**: `141-experience-standard-refactor`

**Created**: 2026-10-05

**Status**: Draft

**Input**: User description: Refactor `experience-standard.md` into the smallest complete shared runtime interaction contract without intentionally changing Highway's current user-visible behavior.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Preserve the normative interaction contract (Priority: P1)

As a maintainer of Highway's shared interaction model, I want the Experience Standard's normative X-rules and behavioral guarantees preserved while explanatory duplication is removed, so that every owning skill continues to produce the same supported user-visible behavior.

**Why this priority**: The refactor is successful only if consolidation does not weaken the stable interaction contract, especially convergence, acceptance, clarification, contribution, and ownership boundaries.

**Independent Test**: Compare the refactored rules and Observables against the current X-rule inventory, confirming every stable X-rule ID remains present and the named interaction guarantees remain materially intact.

**Acceptance Scenarios**:

1. **Given** the refactored Experience Standard, **When** a reviewer inventories the X-rules, **Then** all current X-rule IDs remain present without renumbering or newly introduced normative rules unless a genuine uncovered behavior is demonstrated.
2. **Given** accepted context, a mature contribution, a substantive response, or a model-originated possibility, **When** the interaction is evaluated, **Then** the preserved contribution, clarification, convergence, acceptance, and user-ownership boundaries remain available.
3. **Given** a complete candidate whose Working Idea is still substantively changing, **When** the standard is applied, **Then** the candidate is not presented as a Converged Proposal until collaborative development has settled.

### User Story 2 - Use one compact interaction model (Priority: P1)

As an agent author or reviewer, I want one concise Interaction Model to explain how the shared rules combine, so that the runtime contract is easier to execute and does not contain competing copies of the collaborative loop.

**Why this priority**: The main value of the refactor is reducing instruction density and making the person-Highway loop unambiguous without changing its adaptive nature.

**Independent Test**: Review the Interaction Model and targeted guidance to confirm one adaptive loop covers context reuse, useful contribution, substantive re-evaluation, selective clarification, Contribution Opportunity, convergence, acceptance, and hidden internal mechanics.

**Acceptance Scenarios**:

1. **Given** a developing Working Idea, **When** the model determines whether to continue, clarify, contribute, or converge, **Then** it uses substantive improvement as the criterion rather than a fixed number of turns or questions.
2. **Given** clear user input that supports a responsible interpretation, **When** the model is applied, **Then** it incorporates that interpretation without ceremonial clarification.
3. **Given** a Contribution Opportunity response that changes the substance, **When** the loop re-evaluates it, **Then** the Working Idea may reopen and continue development without requiring another automatic opportunity.
4. **Given** internal routing, persistence, state evaluation, or machine results, **When** the interaction is user-visible, **Then** those mechanics remain hidden unless the person needs them to act.

### User Story 3 - Keep targeted guidance and minimal boundary examples (Priority: P1)

As a person maintaining or applying Highway skills, I want only the targeted guidance and contrastive examples needed to resolve likely misapplications, so that the standard remains reusable across Profile, Objectives, Controls, NFRs, and future workflows without copying domain behavior or Highway Identity.

**Why this priority**: Removing redundant essays is safe only when the remaining guidance still makes model-originated novelty, clarification, advisory calibration, mature contributions, acceptance boundaries, and anti-belaboring behavior clear.

**Independent Test**: Inspect the retained definitions, targeted guidance, five interaction examples, recommendation guidance, and ownership references for complete boundaries with no Profile-specific semantics or duplicated Highway Identity prose.

**Acceptance Scenarios**:

1. **Given** Highway notices a grounded possibility not explicitly stated by the person, **When** it presents that possibility, **Then** its basis or uncertainty is visible when needed, the idea remains non-authoritative, and it may be discussed before becoming structured artifact content.
2. **Given** a mature domain-ready contribution, **When** additional development would not improve its substance, **Then** the standard permits immediate progression through the owning workflow without manufactured questions, commentary, or Contribution Opportunity ritual.
3. **Given** consequential ambiguity or clear input, **When** clarification is considered, **Then** clarification is asked only for unresolved user-owned information that can change the result, while clear input is incorporated directly.
4. **Given** the shared standard is used by an owning skill, **When** domain completeness, artifact content, acceptance, or persistence is determined, **Then** those responsibilities remain with the owning skill rather than being redefined in the standard.

### User Story 4 - Remove runtime history and verify self-application (Priority: P2)

As a maintainer of a pre-release runtime contract, I want design history, abandoned approaches, compatibility explanations, and development-only material removed while versioning and self-application remain correct, so that the document reads as a current supported model.

**Why this priority**: Historical density undermines execution clarity, but removing it must not break governance, cross-document ownership, stable rule identifiers, or validation coverage.

**Independent Test**: Review the resulting document structure, version metadata, self-application record, protected paths, and validation evidence against the requested exclusions and current Constitution obligations.

**Acceptance Scenarios**:

1. **Given** the refactored standard, **When** a reviewer searches for previous-version comparisons, abandoned designs, candidate governance, and historical rationale, **Then** those runtime passages are absent unless required to interpret current behavior.
2. **Given** the refactor is complete, **When** protected artifacts are compared with their pre-change state, **Then** `highway-identity.md`, `highway-profile`, `constitution.md`, and other skills are unchanged.
3. **Given** the Experience Standard's versioning policy and self-application requirements, **When** the amendment is reviewed, **Then** its version, last-amended date, stable X-rule IDs, and self-application review are current and complete.

### Edge Cases

- A complete candidate remains non-converged when a useful connection, possibility, implication, or assumption can still change its substantive meaning.
- A mature contribution may proceed without a Contribution Opportunity when Highway did not materially reshape it or the person already had an equivalent meaningful opportunity.
- A Contribution Opportunity response may add no substantive information; the Working Idea may converge without another manufactured turn.
- A Contribution Opportunity response may change the substance; the Working Idea remains active and may reopen collaborative development.
- Clear input can support a responsible interpretation; the standard must not ask the person to restate it merely to demonstrate re-evaluation.
- Consequential uncertainty may require a focused clarification; the standard must not silently choose between materially different user-owned interpretations.
- A model-originated possibility may be useful but unsupported as accepted organizational fact; it remains advisory and transient until the owning acceptance boundary is crossed.
- A collaborative response may contain no question when no unresolved information or decision remains.
- Persisted deterministic clarification remains owned by the separately invoked `highway-clarify` capability.
- Removing examples and guidance must not remove the behavioral meaning of any retained X-rule or accidentally introduce Profile-specific behavior.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Experience Standard MUST remain the shared runtime contract for user-visible interaction and MUST not become a contract for owning-skill domain semantics or user-authored content.
- **FR-002**: All current X-rule identifiers MUST remain stable, including X2.2, X2.4, X2.7, X2.8, X2.11, X2.13, X2.17-X2.22, X2.29-X2.31, X2.33-X2.41, and X5.1-X5.2.
- **FR-003**: The refactor MUST preserve the current behavioral guarantees and Observables of the retained X-rules unless wording is changed only to remove historical or backward-compatibility framing.
- **FR-004**: The Converged Proposal definition MUST require both an owning-workflow complete candidate and conversational convergence of the substantive Working Idea.
- **FR-005**: Domain or candidate completeness MUST NOT by itself establish conversational convergence or authorize Converged Proposal presentation.
- **FR-006**: The standard MUST contain one compact Interaction Model as the sole full prose representation of the adaptive person-Highway collaboration loop.
- **FR-007**: The Interaction Model MUST cover context reuse, useful grounded contribution before fallback questioning, Working Idea development, post-contribution re-evaluation, selective clarification, Contribution Opportunity, convergence, owning-workflow acceptance, and subsequent contextual re-evaluation.
- **FR-008**: The Interaction Model MUST state that collaboration continues while substantive understanding is improving, not merely because another turn, question, detail, or possible insight exists.
- **FR-009**: The standard MUST preserve mature-contribution behavior and MUST NOT require fixed turns, ceremonial questions, recurring "anything else?" prompts, or manufactured disagreement, commentary, or recommendations.
- **FR-010**: The standard MUST state that a substantive response to a Contribution Opportunity remains Working Idea material and may reopen collaborative development.
- **FR-011**: Conversational Clarification guidance MUST distinguish consequential uncertainty from clear input, require user-owned information when clarification is needed, and prohibit clarification used solely to demonstrate re-evaluation.
- **FR-012**: Conversational Clarification MUST remain transient interaction behavior, while persisted deterministic clarification remains owned by the separately invoked `highway-clarify` capability.
- **FR-013**: Contribution Opportunity guidance MUST state when a distinct opportunity is appropriate, when mature or equivalent contribution paths may skip it, and that it is not a recurring ritual.
- **FR-014**: Constructive Advisory guidance MUST allow grounded implications, possibilities, recommendations, alternatives, tradeoffs, concerns, downstream consequences, and connections while making relevant reasoning or uncertainty visible.
- **FR-015**: Model-originated possibilities MUST remain non-authoritative until accepted, MUST be discussable before becoming bullets or artifact prose, and MUST be subject to re-evaluation after the person's response without introducing a formal confidence scale or persisted inference status.
- **FR-016**: The standard MUST retain compact Evolution-Aware Guidance that distinguishes grounded present reality, advisory future possibilities, and unsupported organizational fact.
- **FR-017**: The standard MUST retain exactly the minimal five interaction boundaries: mature contribution, model-originated connection, Contribution Opportunity, complete candidate with developing idea, and consequential ambiguity versus clear input.
- **FR-018**: Recommendation Sets guidance MUST preserve Working Idea status, convergence requirements, user-authored alternatives, recommendation-count and choice-wording rules, and the distinction between agreement or selection and artifact acceptance.
- **FR-019**: The standard MUST remove standalone long-form Collaborative Development, Contextual Re-evaluation, Conversational Voice, Conversational Presence, and Context Awareness guidance when their behavior is covered by retained rules, definitions, the compact Interaction Model, or targeted guidance.
- **FR-020**: The standard MUST remove runtime candidates/governance material, abandoned design notes, historical rationale, previous-version comparisons, and compatibility-oriented explanations that are not required to interpret current behavior.
- **FR-021**: The Artifact Acceptance Boundary definition MUST describe the owning workflow's declared persistence behavior without historical "existing behavior" compatibility wording.
- **FR-022**: Contextual Guidance MUST be compressed to relevant accepted context, reduced user effort, useful changed-understanding reflection, and increasingly specific guidance as context accumulates.
- **FR-023**: The standard MUST preserve the distinction that pure acceptance, rejection, or selection does not independently trigger substantive-contribution handling, while acceptance plus new substantive information requires re-evaluation.
- **FR-024**: The standard MUST keep machine-consumable owner results available when explicitly requested while hiding internal persistence, routing, orchestration, state, and progression mechanics otherwise.
- **FR-025**: The standard MUST NOT add Profile-specific behavior, Profile domain semantics, Profile acquisition or readiness guidance, Profile canonical questions, or any modification to `highway-profile` as part of this feature.
- **FR-026**: The refactor MUST NOT modify `highway-identity.md`, `constitution.md`, `highway-profile`, or any other skill.
- **FR-027**: The refactor MUST preserve the current pre-release versioning policy, update the Experience Standard version and Last Amended metadata according to that policy, preserve stable X-rule identifiers, and complete the document's self-application review.
- **FR-028**: The resulting document MUST be materially shorter and lower-density than the current baseline while retaining one clear authoritative home for each remaining runtime concept.

### Key Entities *(include if data involved)*

- **Experience Standard**: The shared runtime interaction contract governing what Highway skills emit and how they interact with the person.
- **X-rule**: A stable normative interaction rule with an Observable that establishes user-visible behavior.
- **Working Idea**: A developing user or Highway contribution that remains non-authoritative and may change through contextual re-evaluation.
- **Substantive Contribution**: New user-provided information, correction, relationship, implication, alternative, constraint, preference, or other material that can change the active Working Idea.
- **Conversational Clarification**: Transient interaction used to resolve consequential uncertainty requiring user-owned information.
- **Contribution Opportunity**: A meaningful opportunity for the person to alter substance Highway materially shaped before convergence.
- **Converged Proposal**: A complete candidate from the owning workflow whose substantive Working Idea has also converged and is ready for the owning acceptance boundary.
- **Artifact Acceptance Boundary**: The owning workflow's decision point for promoting a complete candidate into accepted user-owned knowledge and performing declared persistence.
- **Interaction Model**: The single compact explanatory loop describing how retained rules combine without prescribing fixed turns.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the current X-rule identifiers remain present and addressable after the refactor, with zero intentional renumbering.
- **SC-002**: The refactored document contains one Interaction Model, one Conversational Clarification guidance section, one Contribution Opportunity guidance section, one Constructive Advisory section, one Evolution-Aware Guidance section, one Recommendation Sets section, and exactly five retained interaction boundary examples.
- **SC-003**: The runtime document is at least 25% shorter than the pre-refactor baseline while preserving all requirements in the maintained contract review.
- **SC-004**: Reviewers can locate the answer to all 20 specified interaction questions without consulting deleted design history, with 100% of questions judged answerable.
- **SC-005**: A focused contract review passes all preserved X-rule, convergence, mature-contribution, clarification, advisory, ownership, and no-duplication checks with zero failures.
- **SC-006**: The full repository validation suite passes with zero failures after the refactor.
- **SC-007**: No changes occur to `highway-identity.md`, `highway-profile`, `constitution.md`, or any other skill as part of this feature.
- **SC-008**: Reviewers find zero retained runtime passages whose primary purpose is previous-version compatibility, abandoned design history, candidates/governance, or historical rationale.

## Assumptions

- The current `.highway/governance/experience-standard.md` and `.highway/library/knowledge/highway-identity.md` are the authoritative behavioral baseline.
- Existing X-rule IDs, Observables, acceptance semantics, user ownership, owner boundaries, and pre-release versioning policy remain authoritative unless this feature explicitly removes redundant explanatory prose.
- The current repository test suite and a focused Experience Standard contract review are sufficient to verify the documentation refactor.
- A 25% reduction from the pre-refactor document length is a reasonable measurable interpretation of “materially shorter”; planning may refine the measurement method without changing the behavioral scope.
- Development-only history that is removed from the runtime document does not need to be relocated as part of this feature.
- No new runtime interaction state, schema, persistence artifact, external interface, or dependency is required.
