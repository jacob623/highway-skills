# Feature Specification: Experience Runtime Refactor

**Feature Branch**: `146-experience-runtime-refactor`

**Created**: 2026-10-06

**Status**: Draft

**Input**: User description: Update the Highway Experience Standard into a self-contained runtime interaction standard with no runtime dependency on the Highway Skills Constitution, while strengthening constructive advisory reasoning, substantive re-evaluation, convergence, and acceptance boundaries.

## Clarifications

### Session 2026-10-06

- Q: What version should the revised Experience Standard use after this refactor? → A: 9.0.0, classified as a major refactor because it removes and consolidates runtime rules and materially changes convergence semantics.
- Q: Which existing rule IDs should remain after consolidating the duplicate questioning and re-evaluation rules? → A: Keep X2.4 as the single questioning rule, X2.38 as the single re-evaluation rule, X2.41 for convergence, and X2.37 for Contribution Opportunity; retire X2.14, X2.39, X2.40, and X2.8 into X2.4/X2.38 respectively; rationalize X2.2 and X2.13 separately.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Runtime authority is self-contained (Priority: P1)

As a person using Highway, I need user-visible interaction to be governed by one understandable runtime experience standard and the owning capability, so development governance does not appear as a runtime dependency.

**Why this priority**: Removing the wrong runtime authority is the architectural foundation for all other interaction changes.

**Independent Test**: Review the revised Experience Standard without loading the Highway Skills Constitution and verify that its scope, authorities, definitions, and rules are understandable and actionable.

**Acceptance Scenarios**:

1. **Given** the Experience Standard is the only interaction-governance document supplied at runtime, **When** an interactive workflow determines how to respond, **Then** the standard provides sufficient generic interaction guidance without requiring the Highway Skills Constitution.
2. **Given** a decision concerns domain meaning, completeness, ownership, acceptance, or persistence, **When** the workflow applies its authorities, **Then** the owning skill remains authoritative and the Experience Standard governs only user-visible interaction.
3. **Given** a user correction conflicts with stale provisional context, **When** the next response is prepared, **Then** the active correction takes precedence for the interaction.

### User Story 2 - Highway contributes useful grounded perspective (Priority: P1)

As a person developing an idea with Highway, I need Highway to volunteer useful, grounded relationships, implications, distinctions, alternatives, tensions, opportunities, concerns, challenges, and recommendations without waiting for an explicit request for advice.

**Why this priority**: Constructive advisory behavior is the primary runtime improvement and prevents the experience from collapsing into passive transcription.

**Independent Test**: Exercise an interactive workflow with accepted evidence that supports a non-obvious observation and verify that Highway presents it as advisory reasoning rather than as accepted organizational fact.

**Acceptance Scenarios**:

1. **Given** accepted evidence and active context support a non-redundant observation that could sharpen understanding, **When** Highway responds, **Then** it may present the observation as a Working Idea with enough reasoning or uncertainty to distinguish inference from fact.
2. **Given** no grounded contribution would materially improve understanding, **When** Highway responds to mature direct input, **Then** it may proceed without manufacturing commentary, disagreement, or an additional conversational turn.
3. **Given** Highway-originated reasoning is not accepted through the owning workflow, **When** the workflow presents it, **Then** it remains advisory and is not represented as organizational fact.

### User Story 3 - Corrections cause meaningful re-evaluation (Priority: P1)

As a person correcting or extending Highway's interpretation, I need the correction to influence the next behavior and the surrounding understanding, rather than merely replace words in a candidate artifact.

**Why this priority**: Learning from substantive correction is necessary for trustworthy collaboration and guards against shallow artifact editing.

**Independent Test**: Supply a material correction that overturns a provisional interpretation and inspect the next response for changed reasoning, distinctions, implications, or affected context.

**Acceptance Scenarios**:

1. **Given** a Substantive Contribution materially changes or overturns Highway's previous interpretation, **When** Highway selects its next behavior, **Then** it re-evaluates the contribution with relevant active and accepted context.
2. **Given** re-evaluation produces a useful user-facing implication, **When** Highway responds, **Then** the response reflects that changed understanding without requiring an apology ritual or a mandatory follow-up question.
3. **Given** re-evaluation produces no useful user-facing implication, **When** Highway responds, **Then** it need not narrate the internal re-evaluation.

### User Story 4 - Convergence precedes acceptance (Priority: P1)

As a person accepting a proposed artifact or representation, I need Highway to distinguish substantive convergence from artifact completeness so that an acceptance question cannot prematurely end useful reasoning.

**Why this priority**: This prevents complete-looking artifacts from bypassing grounded collaborative development.

**Independent Test**: Present a complete candidate while grounded non-redundant reasoning could materially improve understanding, then verify that Highway develops the useful Working Idea before requesting acceptance.

**Acceptance Scenarios**:

1. **Given** enough information exists to construct a valid artifact but grounded non-redundant reasoning could materially improve the relevant substance, **When** Highway evaluates whether to present a complete candidate, **Then** it continues developing the Working Idea rather than converging.
2. **Given** further contribution would be redundant, optional, unsupported, manufactured, or unlikely to improve understanding and the owner considers the candidate complete, **When** Highway selects the next behavior, **Then** it may present a Converged Proposal.
3. **Given** a Converged Proposal is presented, **When** the owning workflow asks for acceptance, **Then** that question determines whether the person accepts the representation and does not determine whether conversational development was complete.
4. **Given** the person supplies mature, complete, domain-ready content and no useful grounded contribution remains, **When** Highway receives it, **Then** the workflow retains a short path to acceptance without a mandatory enrichment turn.

### User Story 5 - Questions resolve consequential user-owned uncertainty (Priority: P2)

As a person working with Highway, I need questions only when unresolved uncertainty can change the result and I own information needed to resolve it, so accepted context and responsible advisory reasoning are not needlessly re-requested.

**Why this priority**: Focused clarification supports progress while preserving the distinction between questions and advisory reasoning.

**Independent Test**: Provide accepted context and an inferable but provisional interpretation, then verify Highway reuses what is known and asks only for consequential unresolved information that the person owns.

**Acceptance Scenarios**:

1. **Given** accepted evidence or responsible advisory reasoning can resolve the need, **When** Highway considers asking a question, **Then** it contributes or reuses that basis instead of asking for information it already has or can responsibly frame as a Working Idea.
2. **Given** consequential uncertainty remains, can change the result, and requires user-owned information, **When** Highway asks, **Then** it presents at most one unresolved response-demanding question at a time where that interaction principle applies.
3. **Given** one responsible interpretation is clear and restatement would add no value, **When** Highway proceeds, **Then** it does not ask the person to restate the same information.

### Edge Cases

- A complete artifact can be constructed while a grounded relationship, tension, implication, or distinction would materially sharpen understanding; completeness alone must not trigger convergence.
- Several possible observations exist, but each is optional, repetitive, speculative, or low-value; Highway should not exhaust every imaginable implication.
- A user correction overturns a previously accepted-looking but unaccepted interpretation; the correction governs the active interaction while the earlier interpretation remains non-authoritative.
- Highway's observation is plausible but not sufficiently grounded; it must remain unknown or be clearly framed as provisional rather than asserted as fact.
- Highway materially shaped a candidate, but the person's response to that Working Idea already provided a meaningful opportunity to add, correct, remove, or extend it; no ceremonial extra turn is required.
- Acceptance succeeds conversationally but the owning workflow reports persistence failure; the interaction must not present the failed persistence as successful completion.
- Setup-specific presentation needs to hide machine-oriented owner results while still showing the person the relevant user-visible state and next action.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Experience Standard MUST define runtime user-visible interaction without requiring access to or reasoning about the Highway Skills Constitution.
- **FR-002**: The Experience Standard MUST state that it does not own domain semantics, domain completeness, artifact ownership, acceptance, persistence, readiness, schema, identifiers, mutation transactions, routing contracts, or authoritative owner state.
- **FR-003**: The Experience Standard MUST define runtime authority boundaries for security and safety constraints, owning skills, accepted user-owned organizational knowledge, active user corrections, and generic user-visible interaction.
- **FR-004**: The Experience Standard MUST retain clear definitions for Working Idea, Substantive Contribution, Conversational Clarification, Contribution Opportunity, Converged Proposal, Accepted Knowledge, Artifact Acceptance Boundary, and Owner.
- **FR-005**: The Experience Standard MUST distinguish accepted evidence from Highway-originated reasoning, and MUST keep unaccepted interpretations, implications, connections, alternatives, and recommendations advisory until the owning workflow accepts them.
- **FR-006**: The Experience Standard MUST permit Highway to volunteer a useful grounded advisory contribution without an explicit request for advice when that contribution could materially improve understanding.
- **FR-007**: The Experience Standard MUST require Highway to expose enough reasoning or uncertainty for a useful inference to remain distinguishable from established organizational fact.
- **FR-008**: The Experience Standard MUST require re-evaluation of each Substantive Contribution using relevant active and accepted context, with the next user-visible behavior reflecting material change when it has a useful implication.
- **FR-009**: The Experience Standard MUST prevent a Converged Proposal from being presented while grounded non-redundant reasoning could materially improve the relevant Working Idea.
- **FR-010**: The convergence requirement MUST distinguish useful material improvement from optional enrichment, repetition, unsupported speculation, manufactured disagreement, ceremonial interaction, or low-value detail.
- **FR-011**: The Experience Standard MUST state that an Artifact Acceptance Boundary is not a convergence mechanism; acceptance authorizes the owning workflow's declared action but does not prove persistence succeeded.
- **FR-012**: The Experience Standard MUST preserve a short path for mature, complete input when no useful supported advisory development remains.
- **FR-013**: The Experience Standard MUST require a meaningful Contribution Opportunity when Highway materially shaped the substance, while allowing a substantive interaction with the Working Idea to satisfy that opportunity without an extra ritual turn.
- **FR-014**: The Experience Standard MUST require questions only for consequential, result-changing uncertainty that the person owns and that accepted evidence or responsible advisory reasoning cannot resolve.
- **FR-015**: The Experience Standard MUST avoid asking for accepted information, internal schema completion, demonstrations of collaboration, responsible provisional inferences, or restatements when one responsible interpretation is clear.
- **FR-016**: The Experience Standard MUST preserve the distinction between a Conversational Clarification and a grounded advisory Working Idea.
- **FR-017**: The Experience Standard MUST keep recommendation behavior flexible: recommendations remain Working Ideas while discussion can improve them, user-authored alternatives remain available, duplicate or exhausted options are not repeated, and a single useful observation is valid when a recommendation set would add no value.
- **FR-018**: The Experience Standard MUST retain user-visible Setup presentation guidance only where it describes shared interaction, including clear next actions, domain transitions, closing synthesis, and hiding machine-oriented owner results; it MUST omit orchestration mechanics.
- **FR-019**: The Experience Standard MUST remove runtime development/test metadata, including tier columns, tier labels, detailed amendment/versioning policy, self-application mechanics, reviewer/validator decision procedures, and Constitution non-restatement rules.
- **FR-020**: The Experience Standard MUST avoid retaining rules that are specific only to Profile, Objectives, Controls, or Non-Functional Requirements ownership; those domain-specific responsibilities remain with their owning workflows.
- **FR-021**: The revised standard MUST use fewer overlapping runtime rules than the current standard by retaining X2.4 as the single questioning rule, X2.38 as the single substantive re-evaluation rule, X2.41 as the convergence boundary, and X2.37 as the Contribution Opportunity rule; X2.14, X2.39, X2.40, and X2.8 MUST be retired into X2.4 or X2.38 as specified, and X2.2/X2.13 MUST be rationalized separately without reusing retired identifiers.
- **FR-026**: The revised Experience Standard MUST identify version `9.0.0`, reflecting the major refactor of runtime rules and convergence semantics.
- **FR-022**: The revised Interaction Model MUST describe an adaptive loop from context and evidence through grounded advisory contribution, user response, re-evaluation, consequential clarification, convergence, acceptance, and owner action.
- **FR-023**: The Interaction Model MUST state that its stages may collapse together, do not prescribe a fixed number of turns, may produce a response with no question, and permit rapid progress for mature direct input.
- **FR-024**: The Experience Standard MUST preserve epistemic restraint: missing evidence remains unknown when it cannot responsibly be inferred, active correction overrides conflicting provisional interpretation, accepted repository information is reused, and external sources are used only when the owning workflow permits them.
- **FR-025**: The revised standard MUST include an explicit constructive-advisory statement that useful outside perspective is normal runtime behavior, while Highway-originated reasoning remains advisory until accepted.

### Key Entities

- **Working Idea**: Transient substance or reasoning still being developed by the person, Highway, or their interaction.
- **Substantive Contribution**: A contribution that changes the relevant meaning, interpretation, relationship, implication, constraint, or direction of the work.
- **Conversational Clarification**: A response-demanding question used to resolve consequential user-owned uncertainty that cannot responsibly be resolved from available context and reasoning.
- **Contribution Opportunity**: A meaningful opportunity for the person to add, correct, remove, or extend substance Highway materially shaped before acceptance.
- **Converged Proposal**: A complete candidate whose relevant substance is developed enough that further grounded reasoning is unlikely to materially improve it.
- **Accepted Knowledge**: User-owned knowledge that has crossed the applicable acceptance boundary.
- **Artifact Acceptance Boundary**: The owning skill's point at which an accepted proposal becomes eligible for the owner's declared persistence behavior.
- **Owner**: The skill or workflow authoritative for domain semantics, completeness, acceptance, persistence, and related capability-specific runtime behavior.
- **Accepted Evidence**: Accepted repository or user-owned organizational information available to inform runtime interaction.
- **Constructive Advisory Contribution**: A grounded Highway-originated possibility, implication, relationship, distinction, alternative, tension, opportunity, concern, challenge, or recommendation that remains provisional until accepted.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A reviewer can execute the revised Experience Standard without loading the Highway Skills Constitution and identify the runtime authority for every decision described in the standard, with no unresolved runtime dependency references.
- **SC-002**: The revised Experience Standard contains zero references to the Highway Skills Constitution, the P namespace, Constitution non-restatement, tier labels, reviewer/validator tiers, or detailed Experience Standard versioning policy.
- **SC-003**: Every retained runtime rule can be classified as generic user-visible interaction guidance or an explicit presentation boundary, and 100% of retained rules have no development/test metadata column or tier label.
- **SC-004**: In a review corpus containing at least 10 mature direct inputs and 10 inputs with grounded advisory opportunities, the standard permits a short path for all mature inputs with no useful contribution and requires development of each materially useful opportunity before convergence.
- **SC-005**: In at least 90% of correction scenarios where a user materially overturns a provisional interpretation, the next response reflects the changed understanding, a newly visible distinction, or a relevant implication; no scenario requires an apology ritual or mandatory follow-up question.
- **SC-006**: In at least 90% of question scenarios, a reviewer can identify consequential result-changing uncertainty, user-owned resolving information, and the absence of a responsible resolution from accepted evidence or advisory reasoning before a question is asked.
- **SC-007**: In acceptance scenarios, 100% of reviewed workflows distinguish proposal acceptance from persistence success and do not present an owner-reported persistence failure as successful completion.
- **SC-008**: Reviewers rate the revised standard as having fewer overlapping runtime obligations than the current standard while preserving all eight named epistemic and ownership concepts.
- **SC-009**: The revised Experience Standard records version `9.0.0` as the result of this major runtime-contract refactor.

## Assumptions

- The Experience Standard remains a Markdown artifact used by Highway runtime workflows; this feature changes its contract and wording, not the execution environment.
- Owning skills will be updated in later work where domain-specific behavior or older context roles need migration; this feature does not edit those skills.
- Existing user-visible Setup presentation behavior is retained only where it is generic interaction guidance; readiness, routing, owner state, and persistence mechanics remain outside this standard.
- A simple document version identifier may remain for provenance, but amendment classification and self-review records belong to development governance.
- The current accepted-knowledge and ownership vocabulary is the baseline; this feature simplifies overlapping rules without weakening those boundaries.
- External evidence remains governed by the owning workflow's permissions and is not made universally available by this refactor.

## Out of Scope

- Updating the Highway Skills Constitution, Highway Identity, Setup, Profile, Objectives, Controls, Non-Functional Requirements, Clarify, output templates, or other skills.
- Moving domain-specific rules into owning skills during this feature.
- Implementing a new runtime interaction engine or prescribing a fixed number of conversational turns.
- Reclassifying user-owned organizational knowledge or changing persistence transactions.
