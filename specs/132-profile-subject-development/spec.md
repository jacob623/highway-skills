# Feature Specification: Profile Subject Transition and Working-Idea Development

**Feature Branch**: `132-profile-subject-development`

**Created**: 2026-10-02

**Status**: Draft

**Input**: User description: "Update only `highway-profile` so Profile visibly introduces each new subject and continues developing a useful Working Idea with focused questions instead of falling back to a broad canonical question."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See the Next Profile Subject Open Clearly (Priority: P1)

As a person developing an organizational Profile, I want each move from an accepted subject to the next unresolved subject to be visibly marked, so that I can tell whether Highway is closing the previous understanding or beginning a new one.

**Why this priority**: The current Profile defines subject headings but does not reliably make them part of the visible transition. Without that separation, the conversation can appear to continue the previous subject or blend multiple stages together.

**Independent Test**: Review transitions from Identity to Vision, Vision to Competitive Path, and Competitive Path to Guiding Principles; confirm the relevant subject heading appears before the new subject's Working Idea, Converged Proposal, or focused question.

**Acceptance Scenarios**:

1. **Given** accepted Identity is followed by unresolved Vision, **When** Profile advances, **Then** the visible interaction opens Vision with `### Where you're going` before presenting Vision content or a question.
2. **Given** accepted Vision is followed by unresolved Competitive Path, **When** Profile advances, **Then** the visible interaction opens Competitive Path with `### How you'll get there` before presenting path content or a question.
3. **Given** accepted Competitive Path is followed by unresolved Guiding Principles, **When** Profile advances, **Then** the visible interaction opens Guiding Principles with `### What will guide your decisions` before presenting principles content or a question.
4. **Given** contextual re-evaluation of the accepted subject is useful, **When** the next subject opens, **Then** the re-evaluation remains distinguishable from the new subject heading and its developing content.

---

### User Story 2 - Develop a Vision Working Idea with Focused Input (Priority: P1)

As a person developing organizational Vision, I want Highway to continue developing a useful Working Idea with me, so that an incomplete idea leads to a focused question about what is still unresolved rather than restarting with the broad Vision question.

**Why this priority**: Profile testing showed that Highway could produce a useful Vision Working Idea but then asked the broad canonical question, discarding the progress already made.

**Independent Test**: Provide accepted Identity and enough context for a useful but incomplete Vision direction; confirm Profile presents the subject heading and Working Idea, then asks at most one focused question about the unresolved choice, distinction, priority, boundary, or organizational fact.

**Acceptance Scenarios**:

1. **Given** accepted Profile evidence supports a useful but incomplete Vision direction, **When** Vision is developed, **Then** Profile presents a concrete Working Idea rather than merely introducing the domain.
2. **Given** a Vision Working Idea exists and unresolved information remains, **When** Profile asks for input, **Then** the question develops that Working Idea rather than repeating `What is the future vision of [Organization Name]?`.
3. **Given** accepted evidence supports a complete Vision, **When** Vision is opened, **Then** Profile presents a Converged Proposal without forcing a Working-Idea phase first.
4. **Given** accepted evidence supports neither a Converged Proposal nor a useful Working Idea, **When** Profile needs more information, **Then** the canonical Vision question remains the fallback.
5. **Given** a useful Working Idea and one genuinely necessary unresolved question can advance the subject together, **When** Profile responds, **Then** it may present both while preserving the single-question interaction constraint.

---

### User Story 3 - Develop Later Subjects from Grounded Ideas (Priority: P1)

As a person developing Competitive Path or Guiding Principles, I want incomplete Working Ideas to be sharpened with focused questions, so that accepted Profile context compounds instead of causing each subject to restart from a broad canonical question.

**Why this priority**: The same failure mode can recur after Vision if later subjects do not apply focused development to their own unresolved choices and tensions.

**Independent Test**: Provide accepted Vision or Competitive Path context that supports an incomplete later-domain Working Idea; confirm the relevant subject heading, grounded contribution, and focused follow-up behavior for each domain.

**Acceptance Scenarios**:

1. **Given** a Competitive Path Working Idea is incomplete, **When** Profile requests more information, **Then** it asks about the unresolved choice, tradeoff, capability, approach, or organizational fact that would sharpen that idea rather than reverting to the broad Competitive Path question.
2. **Given** a Guiding Principles Working Idea is incomplete, **When** Profile requests more information, **Then** it asks about the unresolved principle, decision boundary, tension, or priority needed to sharpen the emerging principles rather than reverting to the broad canonical question.
3. **Given** a later domain has enough accepted context for a complete candidate, **When** Profile opens it, **Then** it may present a Converged Proposal directly and preserve the existing validation wording.
4. **Given** contextual re-evaluation reveals no responsible contribution, **When** a later domain remains unresolved, **Then** the applicable canonical question remains available as fallback.

---

### User Story 4 - Preserve Grounding and Profile Ownership (Priority: P1)

As an organization owner, I want richer subject development to remain grounded and transient until acceptance, so that alternatives, perspectives, and reasoning do not become retained organizational facts or new Profile state.

**Why this priority**: The requested experience change must not weaken the existing Working Idea, Converged Proposal, persistence, readiness, or schema boundaries.

**Independent Test**: Review the updated Profile guidance against the retained Profile template and shared Experience Standard; confirm all Working Ideas and alternatives remain transient, only accepted Converged Proposals mutate Profile state, and existing readiness and schema semantics remain unchanged.

**Acceptance Scenarios**:

1. **Given** Profile presents multiple grounded Working-Idea directions, **When** the person considers them, **Then** the directions are materially distinct, grounded in accepted evidence, and remain non-authoritative until incorporated into an accepted Converged Proposal.
2. **Given** Highway has a grounded perspective about a stronger direction, **When** it is useful to the person, **Then** Profile may state that perspective and its relevant reason without presenting it as accepted organizational truth.
3. **Given** a person agrees with a Working Idea, **When** it has not become a complete Converged Proposal, **Then** Profile does not persist it or mark the domain `discussed`.
4. **Given** a Converged Proposal is accepted, **When** Profile continues, **Then** the existing mutation, persistence-before-dependent-result, and contextual re-evaluation sequence remains unchanged.
5. **Given** Profile communicates contextual re-evaluation, **When** the person sees the result, **Then** it expresses the meaning or implication of accepted information rather than narrating loading, retention, persistence, routing, or workflow state.

## Edge Cases

- A complete domain candidate must not be withheld merely to demonstrate a Working Idea first.
- A Working Idea may be incomplete but still useful enough to support one focused question.
- A Working Idea may include alternatives only when accepted evidence supports materially different directions; Profile must not invent alternatives merely to create a choice.
- The person may supply an alternative or correction; the user-authored path remains available and authoritative for continued development.
- A Working Idea may have a grounded advisory preference without crossing the acceptance boundary.
- No focused question is needed when the available evidence already supports a complete Converged Proposal.
- The canonical question remains appropriate when the person's information is required before Profile can responsibly develop a Working Idea.
- No additional subject, question, Working Idea, alternative, reasoning, or transition state may be added to the retained Profile artifact.
- Completion synthesis, first-time introduction, website scope, Identity validation, readiness, and error handling remain unchanged.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile MUST visibly introduce unresolved Vision with `### Where you're going` before presenting its Working Idea, Converged Proposal, or focused question.
- **FR-002**: Profile MUST visibly introduce unresolved Competitive Path with `### How you'll get there` before presenting its Working Idea, Converged Proposal, or focused question.
- **FR-003**: Profile MUST visibly introduce unresolved Guiding Principles with `### What will guide your decisions` before presenting its Working Idea, Converged Proposal, or focused question.
- **FR-004**: Profile MUST keep contextual re-evaluation of the previously accepted subject distinguishable from the heading and content of the newly opened subject.
- **FR-005**: Profile MUST present a concrete grounded Working Idea when accepted evidence can responsibly advance an unresolved subject without completing it.
- **FR-006**: When a Working Idea exists and information is still needed, Profile MUST ask only for the unresolved choice, distinction, priority, boundary, tradeoff, capability, approach, or organizational fact needed to develop that Working Idea.
- **FR-007**: Profile MUST NOT revert to a broad canonical domain question merely because a useful Working Idea has not yet converged.
- **FR-008**: Profile MUST retain the canonical domain question as fallback when accepted evidence supports neither a Converged Proposal nor a useful Working Idea, or when the person's information is required before Profile can responsibly develop one.
- **FR-009**: Profile MAY present a Working Idea and one focused question in the same turn when the question is genuinely required to develop the idea further.
- **FR-010**: Profile MAY present a small set of grounded alternatives when accepted evidence supports materially different directions and comparison helps sharpen the subject.
- **FR-011**: Alternatives MUST be materially distinct, grounded in accepted Profile evidence, leave the user-authored path available, and remain transient until incorporated into an accepted Converged Proposal.
- **FR-012**: Profile MAY state a grounded advisory perspective about a stronger Working-Idea direction when accepted evidence supports that perspective, without presenting it as accepted organizational truth.
- **FR-013**: Profile MUST keep generic examples subordinate to grounded directions, distinctions, alternatives, and implications when a useful Working Idea already exists.
- **FR-014**: Profile MUST express contextual re-evaluation through useful meaning or implications and MUST NOT narrate accepted information as loaded, retained, stored, available workflow context, or an equivalent internal state unless the person needs that information to act.
- **FR-015**: Profile MUST preserve the existing Working Idea, Converged Proposal, acceptance, persistence, and contextual re-evaluation sequence.
- **FR-016**: Profile MUST preserve schema version `3.0.0`, the four retained domains, and the readiness states `not_discussed`, `discussed`, and `bounded`.
- **FR-017**: Profile MUST NOT add persisted Working-Idea, subject-transition, alternative, reasoning, or domain-question fields or states.
- **FR-018**: Profile MUST preserve existing first-time introduction, Repository Name behavior, website acquisition and scope, Identity validation, readiness, persistence ordering, Active Reasoning Context ownership, completion synthesis, and error handling.
- **FR-019**: Profile MUST preserve existing validation wording for Identity, Vision, Competitive Path, and Guiding Principles.
- **FR-020**: The implementation MUST update only `highway-profile`; it MUST NOT modify the Profile record template, shared Experience Standard, other skills, or retained Profile structure.

### Key Entities

- **Visible Subject Transition**: The user-facing separation between useful re-evaluation of an accepted subject and the heading and content of the next unresolved Profile subject.
- **Working Idea**: A grounded, transient contribution that advances a Profile subject without becoming accepted organizational knowledge.
- **Focused Working-Idea Question**: A single question requesting only the unresolved information needed to develop an existing Working Idea.
- **Grounded Alternative**: A materially distinct direction supported by accepted Profile evidence and presented for collaborative sharpening, not as accepted organizational truth.
- **Converged Proposal**: A complete Profile-domain candidate eligible for the existing acceptance and persistence boundary.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of reviewed transitions from Identity to Vision, Vision to Competitive Path, and Competitive Path to Guiding Principles, the visible subject heading appears before the new subject's contribution or question.
- **SC-002**: In 100% of reviewed scenarios where a useful Working Idea exists but is incomplete, the next question targets an unresolved part of that idea rather than repeating the broad canonical domain question.
- **SC-003**: In 100% of reviewed scenarios where accepted evidence supports a complete candidate, Profile presents a Converged Proposal without requiring an unnecessary Working-Idea phase.
- **SC-004**: In 100% of reviewed scenarios where accepted evidence supports neither contribution form or user knowledge is genuinely required, the canonical question remains available as fallback.
- **SC-005**: 100% of presented Working-Idea alternatives are grounded, materially distinct, user-authority-preserving, and transient until acceptance.
- **SC-006**: A complete Profile walkthrough preserves schema `3.0.0`, exactly four retained domains, and exactly the existing three readiness states.
- **SC-007**: Focused Profile validation and the full repository validation suite pass with zero failures after synchronization.
- **SC-008**: Review of user-visible Profile output finds no narration of loading, retention, persistence, routing, or workflow state when the person only needs the resulting meaning or implication.

## Assumptions

- The Highway Experience Standard remains authoritative for generic question behavior, recommendation-set size, conversational presence, and acceptance mechanics.
- Profile remains the owner of organizational evidence, domain grounding, retained artifact mutation, and readiness.
- The current subject headings, Working Idea / Converged Proposal distinction, contribution precedence, and accumulated contextual re-evaluation are the baseline to preserve and refine.
- The requested synchronization is documentation and contract behavior work in `highway-profile`; no new runtime state or retained data model is required.
- Focused questions are limited to one response-demanding question per interaction, while a useful Working Idea may appear in the same turn.
