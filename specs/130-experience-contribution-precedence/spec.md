# Feature Specification: Experience Contribution Precedence

**Feature Branch**: `130-experience-contribution-precedence`

**Created**: 2026-10-02

**Status**: Draft

**Input**: User description: "Update the Highway Experience Standard so grounded contribution follows the precedence Converged Proposal -> useful Working Idea -> focused question, while preserving ownership, grounding, acceptance boundaries, adaptive depth, and the scope boundary that only experience-standard.md changes in this amendment."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Contribute Before Asking (Priority: P1)

As a person working with an Interactive Workflow, I want Highway to use available accepted context and evidence to offer the strongest responsible contribution before asking me to originate more information, so that incomplete grounding leads to useful development rather than an unnecessary generic question.

**Why this priority**: This is the central behavioral gap. It determines whether the shared Experience Standard consistently supports useful collaboration before fallback questioning.

**Independent Test**: Inspect the X2.2 and X2.13 rules and Observables, then evaluate scenarios with enough grounding for a Converged Proposal, enough grounding only for a Working Idea, and no responsible contribution. Each scenario must select the correct next interaction.

**Acceptance Scenarios**:

1. **Given** available relevant context supports a complete candidate, **When** an unresolved question would otherwise be asked, **Then** the workflow presents a grounded Converged Proposal and requests only the applicable acceptance decision.
2. **Given** available relevant context does not support a complete candidate but supports a useful direction, distinction, implication, alternative, hypothesis, or recommendation, **When** an unresolved question would otherwise be asked, **Then** the workflow contributes a grounded Working Idea before asking.
3. **Given** available context supports neither a responsible Converged Proposal nor a useful Working Idea, **When** the person must supply missing information, **Then** the workflow asks one focused unresolved question.

### User Story 2 - Preserve Ownership and Acceptance Boundaries (Priority: P1)

As a person authoring organizational knowledge, I want useful Working Ideas to help me think without being treated as accepted organizational truth, so that contribution-first behavior remains grounded and user-owned.

**Why this priority**: Contribution must improve collaboration without weakening the existing authority, evidence, proposal, and artifact-acceptance boundaries.

**Independent Test**: Review the preserved rules and examples for grounding, accepted-information reuse, organization-name authority, proposed discovered information, unknown evidence, and artifact acceptance; confirm the amendment changes contribution precedence without changing those boundaries.

**Acceptance Scenarios**:

1. **Given** Highway offers a grounded Working Idea, **When** the person agrees, requests refinement, or supplies an alternative, **Then** the idea remains collaborative development until the owning acceptance boundary is crossed.
2. **Given** Highway lacks evidence for an organizational fact, **When** contribution-first behavior is evaluated, **Then** the workflow does not invent the fact and may ask for the focused information when it is genuinely required.
3. **Given** a complete candidate is eligible for acceptance, **When** the owning workflow presents it, **Then** the existing Converged Proposal acceptance boundary remains unchanged.

### User Story 3 - Keep Collaboration Adaptive and Natural (Priority: P1)

As a person using a shared Highway workflow, I want contribution depth to adapt to the available grounding, so that mature ideas converge immediately, useful incomplete ideas receive development, and questioning remains natural when no useful contribution exists.

**Why this priority**: The precedence must improve behavior without making verbosity, Working Ideas, or additional turns mandatory.

**Independent Test**: Review the Interaction model, Collaborative Development guidance, Context Awareness example, Interaction Examples, and Recommendation sets guidance; confirm they cover immediate convergence, useful Working Idea development, focused questioning, natural conclusion, and no forced verbosity.

**Acceptance Scenarios**:

1. **Given** a mature contribution already supports a complete candidate, **When** the workflow evaluates the contribution, **Then** it may converge immediately without exploratory turns.
2. **Given** a useful Working Idea can materially develop the active task, **When** the final artifact is not complete, **Then** the workflow contributes that idea without labeling internal categories in normal conversation.
3. **Given** contextual re-evaluation produces nothing useful and no unresolved information is needed, **When** the workflow completes its turn, **Then** it may conclude naturally without manufacturing a recommendation or question.

### Edge Cases

- A Working Idea must not be forced when available context provides no responsible basis for contribution.
- A complete candidate must not be withheld merely to demonstrate a Working Idea first.
- A focused question remains appropriate when the person's information is required to choose among materially different directions, establish an organizational fact, resolve ambiguity that Highway cannot responsibly infer, or supply unavailable evidence.
- A useful Working Idea may contain multiple plausible interpretations or a tradeoff, but those possibilities must not be presented as accepted organizational truth.
- The amendment must not duplicate X2.36 or move workflow-narration suppression into an individual skill.
- Optional enrichment and related workflows must retain adaptive depth and must not become blocked by the new precedence.
- The document version follows the repository's active-development versioning practice; X-rule IDs are not renumbered or reused.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Experience Standard MUST define the shared contribution precedence as a grounded Converged Proposal when supported, otherwise a useful Working Idea when supported, otherwise a focused unresolved question.
- **FR-002**: X2.13 MUST require an Interactive Workflow to contribute a grounded Converged Proposal or useful Working Idea before asking when available context supports either.
- **FR-003**: The X2.13 Observable MUST require evaluation of available relevant context in the order Converged Proposal, useful Working Idea, focused unresolved question.
- **FR-004**: The X2.2 Observable MUST require accepted information and evidence to be evaluated for a useful contribution before a question, and MUST use an available grounded Working Idea or Converged Proposal first.
- **FR-005**: X2.25 and its Observable MUST remain unchanged and continue to define Working Ideas and Converged Proposals as the shared recommendation forms for Profile enrichment, Objectives, Controls, and Non-Functional Requirements.
- **FR-006**: The Interaction model MUST prefer the strongest responsible grounded contribution, using a Converged Proposal when understanding is complete and a useful Working Idea otherwise.
- **FR-007**: The Interaction model MUST permit one focused question only after relevant context has been evaluated for both a Converged Proposal and a useful Working Idea, while allowing a turn with no question.
- **FR-008**: Collaborative Development guidance MUST state that insufficient grounding for a Converged Proposal does not imply insufficient grounding for a Working Idea.
- **FR-009**: Collaborative Development guidance MUST define useful Working Ideas as contributions that materially develop the active task, including grounded directions, distinctions, plausible interpretations, implications, tradeoffs, connections, provisional recommendations, or explanations.
- **FR-010**: Collaborative Development guidance MUST state that a question is appropriate when the person's information is genuinely required and MUST prohibit asking the person to originate an answer merely because the final artifact is incomplete.
- **FR-011**: The Experience Standard MUST preserve user ownership and grounding, including the existing boundaries for accepted information, organization-name authority, proposed discovered information, unknown evidence, and artifact acceptance.
- **FR-012**: The Experience Standard MUST preserve adaptive depth: mature contributions may converge immediately, collaboration must not be prolonged for ceremony, and no response is required to produce a new insight.
- **FR-013**: Non-normative guidance MUST include a Working-Idea-before-fallback-question example, a useful-contribution-then-question example, and an immediate-Converged-Proposal example.
- **FR-014**: The Context Awareness example MUST demonstrate a grounded Working Idea that sharpens possible directions before turning them into a Vision.
- **FR-015**: Recommendation sets guidance MUST state that a workflow must not skip directly to questioning when the same context can support a useful Working Idea.
- **FR-016**: This amendment MUST update only `.highway/governance/experience-standard.md`; individual skills, including Profile, Objectives, Controls, and NFRs, MUST remain unchanged.
- **FR-017**: The amendment MUST preserve X2.18, X2.19, X2.21, X2.22, X2.25, X2.7, X2.11, X2.24, X2.29, X2.30, Constitution P11.3, and Constitution P11.4 without weakening their authority or acceptance boundaries.
- **FR-018**: The amendment MUST not duplicate X2.36 or add workflow-narration suppression to the Experience Standard beyond its existing ownership.
- **FR-019**: The amendment MUST not rationalize or renumber existing X rules.

### Key Entities *(include if data involved)*

- **Working Idea**: A transient, grounded developing contribution that helps the person develop an active task without crossing an artifact acceptance boundary.
- **Converged Proposal**: A complete grounded candidate eligible for the owning workflow's existing acceptance decision.
- **Focused Unresolved Question**: A narrowly scoped request for information that remains genuinely necessary after available context has been evaluated for both contribution forms.
- **Contribution Precedence**: The shared decision order Converged Proposal, useful Working Idea, then focused unresolved question.
- **Available Relevant Context**: Accepted information, available evidence, active task context, and other declared grounding that can support a responsible contribution.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All three precedence states are explicitly represented in the X2.2/X2.13 rules or Observables and in the Interaction model, with no contradictory fallback wording remaining.
- **SC-002**: A requirements review can trace every requested amendment item to at least one functional requirement and acceptance scenario, with zero unresolved clarification markers.
- **SC-003**: Focused document-contract checks can distinguish complete-candidate convergence, useful-Working-Idea contribution, and focused-question fallback in 100% of the specified scenarios.
- **SC-004**: Existing artifact-boundary checks for X2.18, X2.19, X2.21, X2.22, and X2.25 continue to pass without changes to their governing rule text.
- **SC-005**: The final amendment changes only `experience-standard.md` in the implementation slice and leaves individual skills and retained artifact schemas unchanged.
- **SC-006**: Reviewers can identify the Working-Idea-before-question behavior from the standard's normative rules and non-normative examples without consulting an individual skill.
- **SC-007**: Mature contributions remain eligible for immediate convergence and no new requirement forces a recommendation, question, extra turn, or minimum response length when no useful grounded contribution exists.

## Assumptions

- The current Experience Standard at version 8.0.0 is the authoritative source for this amendment.
- The repository's active-development versioning practice determines the resulting document version; no rule renumbering or compatibility rationalization is required.
- Existing shared tests and document-contract checks provide the validation path; no new persisted data model or external contract is needed.
- Profile synchronization is explicitly deferred until this shared amendment is authoritative and separately tested.
- Objectives, Controls, and Non-Functional Requirements synchronization is explicitly deferred to later work.
- User ownership, accepted-information boundaries, and artifact acceptance remain governed by the existing Experience Standard and Constitution rules.
