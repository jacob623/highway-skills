# Feature Specification: Profile Verification Cleanup

**Feature Branch**: `129-profile-verification-cleanup`

**Created**: 2026-10-02

**Status**: Draft

**Input**: User description: "Create a new spec for a targeted cleanup of stale highway-profile Verification language before behavioral testing. Align Verification with the existing Working Idea and Converged Proposal model, remove the duplicate final Experience section, preserve the Profile schema and all current behavior, then run Grow Creative setup and freeze Profile for this iteration."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Verify Collaborative Profile Lifecycle (Priority: P1)

As a Highway maintainer, I want Profile Verification statements to describe the existing Working Idea and Converged Proposal lifecycle so that behavioral testing checks collaboration, convergence, acceptance, and contextual re-evaluation rather than obsolete paragraph and acknowledgment rules.

**Why this priority**: Accurate Verification language is the direct gate before behavioral testing. Stale checks can reject the intended collaborative behavior or preserve obsolete interaction assumptions.

**Independent Test**: Inspect the Profile Verification section and confirm it covers transient Working Ideas, Converged Proposals, adaptive convergence, contextual re-evaluation, active reasoning context, acceptance boundaries, and grounded advisory contribution without stale acknowledgment or one-paragraph requirements.

**Acceptance Scenarios**:

1. **Given** a Profile Verification section containing legacy paragraph, acknowledgment, or one-observation checks, **When** the cleanup is applied, **Then** each check is replaced by the corresponding Working Idea, Converged Proposal, or contextual re-evaluation check.
2. **Given** a partial, vague, or developing Profile contribution, **When** Verification is evaluated, **Then** it allows the contribution to remain transient while interpretation, sharpening, or additional evidence improves it.
3. **Given** a mature Profile contribution, **When** Verification is evaluated, **Then** it allows direct convergence into a Converged Proposal without unnecessary exploratory turns.
4. **Given** an accepted Profile domain, **When** the next contribution is evaluated, **Then** Verification requires relevant accumulated Profile context to inform the next contribution and permits a natural transition when no useful contribution exists.

### User Story 2 - Preserve Profile Ownership and Boundaries (Priority: P1)

As a Profile owner, I want the cleanup to preserve the current Profile model, retained record schema, readiness semantics, persistence boundary, and organizational scope so that Verification changes do not redesign Profile behavior.

**Why this priority**: The requested change is documentation alignment only. Preserving the owner-controlled artifact contract prevents a verification cleanup from silently introducing new persisted collaboration state or changing Profile ownership.

**Independent Test**: Compare the cleaned Profile skill with the protected Profile template and existing behavioral contracts, confirming the schema, four domains, readiness states, website boundary, persistence ordering, canonical questions, completion synthesis, and error handling remain unchanged.

**Acceptance Scenarios**:

1. **Given** the protected Profile record template, **When** the cleanup is completed, **Then** schema version `3.0.0`, the four domains, and `not_discussed`, `discussed`, and `bounded` remain unchanged.
2. **Given** the Profile skill after cleanup, **When** its boundaries are reviewed, **Then** Working Idea, Active Reasoning Context, collaboration, maturity, and evolution remain transient concepts rather than retained fields.
3. **Given** Profile website acquisition and brownfield behavior, **When** the cleanup is reviewed, **Then** organizational evidence remains in Profile scope and technology-platform discovery remains outside Profile.
4. **Given** accepted Profile evidence, **When** persistence and dependent results are reviewed, **Then** the existing mutation-before-dependent-result ordering remains intact.

### User Story 3 - Prepare Profile for Behavioral Testing (Priority: P1)

As a Highway maintainer, I want the Profile contract to be free of duplicated or contradictory Verification language before running behavioral testing and Grow Creative setup so that test results measure the intended collaborative behavior.

**Why this priority**: The cleanup is explicitly a precondition for behavioral testing and the next Objectives rollout. A clean, single-source interaction contract reduces ambiguity in the test outcome.

**Independent Test**: Run the focused Profile contract checks, inspect the final Profile skill for one authoritative Experience reference, run Grow Creative setup, and confirm the Profile implementation is frozen after the cleanup.

**Acceptance Scenarios**:

1. **Given** the end of the Profile skill, **When** the cleaned file is inspected, **Then** the duplicate final Experience section is absent and the shared Experience Standard remains authoritative through the existing interaction guidance.
2. **Given** the cleaned Profile skill and its protected dependencies, **When** focused checks run, **Then** they pass without requiring changes to the Profile record template or shared governance authorities.
3. **Given** successful focused behavioral testing, **When** Grow Creative setup completes, **Then** no additional Profile redesign is required for this iteration and work can move to Objectives.

### Edge Cases

- A Working Idea may receive natural agreement without crossing the persistence boundary; Verification must not interpret that agreement as domain acceptance.
- A complete Converged Proposal may be accepted without a redundant second confirmation.
- Contextual re-evaluation may reveal no useful contribution; Verification must allow a natural transition without manufactured commentary.
- Related Working Ideas may remain anchored to the active Profile subject without becoming retained Profile evidence.
- Verification must continue to distinguish artifact-level validation of a Converged Proposal from development of a Working Idea.
- The cleanup must not reintroduce a local numeric limit on advisory observations or a one-sentence/one-paragraph response constraint.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Profile Verification section MUST state that Vision, Competitive Path, and Guiding Principles may develop through a Working Idea and present a cohesive Converged Proposal when grounded evidence supports one.
- **FR-002**: The Profile Verification section MUST state that accepted Profile knowledge is combined with relevant accumulated Profile context before subsequent Profile behavior advances.
- **FR-003**: The Profile Verification section MUST describe interpretation, explanation, subject introductions, and grounded advisory contribution as transient unless explicitly incorporated into accepted Profile evidence.
- **FR-004**: The Profile Verification section MUST distinguish a Working Idea from a Converged Proposal, including that agreement with a Working Idea does not trigger persistence or establish a domain as `discussed`.
- **FR-005**: The Profile Verification section MUST state that a mature contribution may converge directly and that a partial, vague, or developing contribution may remain transient while it improves.
- **FR-006**: The Profile Verification section MUST cover transient Active Reasoning Context and require related Working Ideas to remain anchored to the active Profile subject.
- **FR-007**: The Profile Verification section MUST state that contextual re-evaluation may produce interpretation, sharpening, useful connections, or advisory contribution without making that contribution accepted Profile evidence.
- **FR-008**: The Profile Verification section MUST permit a natural transition when contextual re-evaluation reveals nothing useful to add.
- **FR-009**: Artifact-level validation MUST be described as applying only to a Converged Proposal, not to a Working Idea, while preserving the existing Identity, Vision, Competitive Path, and Guiding Principles validation wording.
- **FR-010**: The Profile Verification section MUST allow cohesive recommendations to use multiple sentences or short paragraphs when readability improves and MUST NOT impose a local one-sentence, one-paragraph, or numeric advisory limit.
- **FR-011**: The cleanup MUST remove the duplicate final Experience section from `highway-profile` while leaving the shared Experience Standard authoritative.
- **FR-012**: The cleanup MUST NOT modify the Profile record template, schema version, four retained domains, readiness states, canonical questions, website boundary, persistence ordering, completion synthesis, or error handling.
- **FR-013**: The cleanup MUST NOT add Working Idea, Active Reasoning Context, collaboration, maturity, or evolution fields to the retained Profile record.
- **FR-014**: The cleanup MUST leave technology-platform discovery outside Profile.
- **FR-015**: Focused Profile validation and the Grow Creative setup MUST be run after the cleanup before Profile is frozen for this iteration.

### Key Entities

- **Working Idea**: A transient developing Profile interpretation, contribution, recommendation, alternative, implication, or related thread that has not crossed the artifact acceptance boundary.
- **Converged Proposal**: A complete Profile candidate presented for the applicable acceptance decision.
- **Active Reasoning Context**: Transient task-anchored context containing relevant developing ideas and unresolved relationships while the active Profile subject continues.
- **Verification Contract**: The Profile skill's user-visible checks that confirm lifecycle behavior, acceptance boundaries, ownership, and preserved Profile semantics.
- **Protected Profile Record**: The retained Profile structure governed by the existing template and schema.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the nine specified stale Verification checks are replaced by their collaborative-development equivalents, with no obsolete acknowledgment, paragraph-only, or one-observation wording remaining.
- **SC-002**: The cleaned Profile Verification section contains at least 12 distinct checks covering Working Ideas, Converged Proposals, active reasoning context, adaptive convergence, contextual re-evaluation, validation boundaries, readability, and persistence ownership.
- **SC-003**: 100% of focused Profile contract checks pass after the cleanup, with no protected-template or shared-governance file changes.
- **SC-004**: Behavioral testing can distinguish agreement with a Working Idea from acceptance of a Converged Proposal in every tested Profile domain.
- **SC-005**: At least 90% of reviewed Profile interaction examples correctly identify when Highway should interpret, sharpen, contribute, converge, present for acceptance, and re-evaluate accepted knowledge.
- **SC-006**: The Profile skill contains exactly one authoritative shared Experience Standard reference section at its conclusion and no duplicate final Experience section.
- **SC-007**: Grow Creative setup completes successfully after focused behavioral testing, and the maintainer records Profile as frozen for this iteration before moving to Objectives.

## Assumptions

- The collaborative-development model already present in Profile, the Experience Standard, the Constitution, and Highway Identity is the authoritative behavioral baseline.
- The request is limited to Verification wording and removal of the duplicate final Experience section; existing Profile behavior is not redesigned.
- The protected Profile record template and shared governance authorities are read-only dependencies for this feature.
- Existing focused Profile checks and the repository's Grow Creative setup provide the validation path for behavioral readiness.
- No new persisted data, readiness state, external interface, or Profile field is required.
- The repository is on the intended Profile cleanup work context before implementation begins.

## Out of Scope

- Changes to Profile Acquisition, Enrichment, Operations, readiness, persistence, completion synthesis, error handling, or subject-specific collaborative behavior.
- Changes to `profile-record.md`, the Profile schema, retained domains, readiness states, or shared governance authorities.
- Changes to Objectives, Controls, NFRs, or other Highway skills during this cleanup.
- Introduction of persisted Working Idea, Active Reasoning Context, collaboration, maturity, or evolution data.
- Technology-platform discovery or brownfield onboarding through Profile.
