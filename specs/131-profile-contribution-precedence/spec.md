# Feature Specification: Profile Contribution-First Synchronization

**Feature Branch**: `131-profile-contribution-precedence`

**Created**: 2026-10-02

**Status**: Draft

**Input**: User description: "Synchronize highway-profile with the shared Experience Standard contribution precedence: Converged Proposal, useful Working Idea, then focused unresolved question."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Apply Shared Precedence During Profile Acquisition (Priority: P1)

As a person completing Profile setup, I want Profile to use the shared contribution precedence before asking a canonical question, so that insufficient grounding for a complete proposal does not prematurely force me to originate the entire answer.

**Why this priority**: This is the direct synchronization gap and prevents the observed failure mode where accepted Profile evidence is followed by a generic question even though a useful contribution is possible.

**Independent Test**: Inspect the Acquisition guidance and canonical-question verification checks, then evaluate cases with enough evidence for a complete Profile-domain candidate, enough evidence for a useful Working Idea, and insufficient evidence for either.

**Acceptance Scenarios**:

1. **Given** accepted Profile evidence supports a complete domain candidate, **When** an unresolved canonical question would otherwise be asked, **Then** Profile presents a Converged Proposal before asking for acceptance.
2. **Given** accepted Profile evidence does not support a complete candidate but supports a responsible domain-specific direction, distinction, implication, alternative, or recommendation, **When** an unresolved canonical question would otherwise be asked, **Then** Profile contributes a useful Working Idea before asking.
3. **Given** accepted Profile evidence supports neither contribution form, **When** user knowledge is still required, **Then** Profile asks the focused canonical question.

### User Story 2 - Enrich Profile Domains Through Accumulated Context (Priority: P1)

As a person developing a Profile, I want accepted Identity, Vision, and Competitive Path context to compound across later domains, so that each domain receives grounded collaboration instead of restarting with a generic question.

**Why this priority**: Profile domains are sequentially related, and the synchronization must correct the same fallback interpretation for Vision, Competitive Path, and Guiding Principles without redesigning their workflows.

**Independent Test**: Review the Vision, Competitive Path, and Guiding Principles guidance and verify that each domain evaluates accumulated accepted Profile context for a Converged Proposal or Working Idea before its canonical question.

**Acceptance Scenarios**:

1. **Given** accepted Identity and other Profile context support a complete Vision, **When** Vision remains unresolved, **Then** Profile presents the Vision Converged Proposal rather than automatically asking the canonical Vision question.
2. **Given** accepted Identity and other Profile context support a useful but incomplete Vision direction, **When** Vision remains unresolved, **Then** Profile contributes a Vision Working Idea that remains transient and non-authoritative.
3. **Given** accepted Vision is available and Competitive Path remains unresolved, **When** the next domain is evaluated, **Then** Profile uses accumulated accepted Profile context for a Converged Proposal or useful Working Idea before the Competitive Path question.
4. **Given** accepted Competitive Path is available and Guiding Principles remain unresolved, **When** the next domain is evaluated, **Then** Profile uses accumulated accepted Profile context for a Converged Proposal or useful Working Idea before the Guiding Principles question.

### User Story 3 - Preserve Profile Ownership and Existing Boundaries (Priority: P1)

As a person authoring organizational knowledge, I want contribution-first Profile guidance to preserve ownership, acceptance, readiness, persistence, and schema behavior, so that a Working Idea helps development without becoming accepted Profile truth.

**Why this priority**: The synchronization must remain narrow and must not turn contribution-first behavior into proposal-first behavior or introduce a new Profile state.

**Independent Test**: Review the changed Profile guidance and existing Profile contracts to confirm that Working Ideas remain transient, Converged Proposals still require the existing acceptance boundary, accepted knowledge still drives mutation and re-evaluation, and all retained Profile states and schema fields remain unchanged.

**Acceptance Scenarios**:

1. **Given** Profile contributes a Working Idea, **When** the person agrees, refines it, or supplies an alternative, **Then** the idea remains collaborative development until the existing Converged Proposal acceptance boundary is crossed.
2. **Given** Profile lacks evidence for a complete candidate but has enough evidence for a useful Working Idea, **When** the domain remains unresolved, **Then** Profile does not present the Working Idea as accepted organizational fact.
3. **Given** a Working Idea and one focused question can both advance the active domain, **When** the person's information is genuinely required, **Then** Profile may include both without violating the one-question constraint.
4. **Given** the synchronization is implemented, **When** Profile readiness, persistence, schema, website acquisition, organization-name handling, or retained states are checked, **Then** their existing behavior remains unchanged.

### Edge Cases

- A complete domain candidate must not be withheld merely to demonstrate a Working Idea first.
- A Working Idea must not be forced when accepted Profile evidence provides no responsible basis for contribution.
- A focused question remains appropriate when the person's information is required to choose among materially different directions, establish an organizational fact, resolve ambiguity Highway cannot responsibly infer, or supply unavailable evidence.
- A useful Working Idea may be deliberately incomplete and may be followed by one focused question when that question is genuinely needed to develop it.
- Working Ideas must not create a new Profile state or mutate retained Profile knowledge before acceptance.
- The synchronization must not copy X2.13 into Profile as a new Profile-local normative rule; the shared Experience Standard remains the owner of interaction precedence.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile Acquisition MUST follow the shared contribution precedence by presenting a Converged Proposal when supported, otherwise contributing a useful Working Idea when supported, and otherwise asking the focused canonical question.
- **FR-002**: Profile MUST remove the local implication that insufficient grounding for a complete proposal automatically permits asking the canonical question.
- **FR-003**: Profile MUST state that lack of grounding for a complete Profile-domain proposal does not by itself justify asking the canonical question.
- **FR-004**: Profile MUST evaluate accumulated accepted evidence for a useful domain-specific Working Idea before using the canonical question as fallback.
- **FR-005**: Vision MUST evaluate accepted Identity, accepted website-derived evidence, existing accepted Vision evidence, and other accepted Profile context using the shared contribution precedence before asking the Vision canonical question.
- **FR-006**: Vision MUST permit a useful Working Idea to be a grounded direction, distinction, implication, alternative, or recommendation without requiring it to complete the Vision.
- **FR-007**: Competitive Path MUST apply the shared contribution precedence using accumulated accepted Profile context before asking its canonical question.
- **FR-008**: Guiding Principles MUST apply the shared contribution precedence using accepted Identity, Vision, Competitive Path, and their relationships before asking its canonical question.
- **FR-009**: Profile MUST retain the existing acceptance sequence: Working Idea, collaborative development, Converged Proposal, acceptance, Profile mutation, accepted Profile knowledge, and contextual re-evaluation.
- **FR-010**: Profile MUST preserve user ownership, grounding, artifact acceptance, readiness, persistence, website acquisition, organization-name handling, retained headings, validation questions, enrichment categories, Active Reasoning Context, completion synthesis, and error handling.
- **FR-011**: Profile MUST NOT add a new persisted state or schema field for Working Ideas, and MUST preserve schema version `3.0.0`, Identity, Vision, Competitive Path, Guiding Principles, `not_discussed`, `discussed`, and `bounded`.
- **FR-012**: Profile MUST allow a useful Working Idea and one focused question in the same turn when the question is genuinely required to develop the idea further.
- **FR-013**: Verification guidance MUST check the shared contribution order, the domain-specific Working Idea fallback boundary, Vision evaluation after accepted Identity, Competitive Path evaluation after accepted Vision, and Guiding Principles evaluation after accepted Competitive Path.
- **FR-014**: The synchronization MUST update only `highway-profile`; it MUST NOT modify `profile-record.md`, other individual skills, or the shared Experience Standard.

### Key Entities

- **Converged Proposal**: A complete Profile-domain candidate eligible for the existing owner acceptance decision.
- **Working Idea**: A transient, grounded Profile contribution that advances domain thinking without becoming accepted Profile knowledge.
- **Focused Canonical Question**: The existing domain-specific question used only when neither contribution form is responsible or the person's information is genuinely required.
- **Accumulated Accepted Profile Context**: Accepted Identity, Vision, Competitive Path, Guiding Principles, accepted discoveries, and other existing Profile evidence available to ground later-domain collaboration.
- **Profile Acceptance Boundary**: The existing transition from collaborative development to accepted Profile mutation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A document-contract review can identify the exact Converged Proposal -> useful Working Idea -> focused question order in Acquisition, Vision, Competitive Path, Guiding Principles, and Verification guidance.
- **SC-002**: All specified complete-candidate, useful-incomplete-contribution, and missing-user-knowledge scenarios select the correct next interaction with no direct fallback from incomplete grounding to a canonical question.
- **SC-003**: Profile-specific verification checks cover all four domains and confirm accumulated accepted context is evaluated before each unresolved canonical question.
- **SC-004**: Existing Profile ownership, acceptance, readiness, persistence, and schema checks continue to pass without adding a Profile state or changing schema version `3.0.0`.
- **SC-005**: The implementation diff contains changes only under `highway-profile`, with no changes to `profile-record.md`, other skills, or the shared Experience Standard.
- **SC-006**: A Working Idea remains non-authoritative until the existing acceptance boundary in 100% of reviewed Profile scenarios.
- **SC-007**: The full repository validation suite exits with zero failures after synchronization.

## Assumptions

- The current shared Experience Standard is authoritative for the contribution precedence; Profile will consume its behavior rather than restating X2.13 as a new Profile-local rule.
- The current `highway-profile` wording, tests, schema, readiness, and persistence boundaries are the baseline to preserve.
- A Working Idea is transient and does not require a new persisted Profile state.
- The existing canonical questions remain the domain-specific fallback when accepted evidence cannot support either contribution form or user knowledge is genuinely required.
- Profile synchronization is limited to the specified Acquisition, Enrichment, and Verification wording; no redesign of Profile workflows is included.
