# Feature Specification: Profile Simplification Pass

**Feature Branch**: `169-profile-simplification-pass`

**Created**: 2026-10-13

**Status**: Draft

**Input**: User description: "Create a new spec for implementing a highway-profile simplification pass that removes competing interaction models, makes the four Discovery Contribution Opportunities dominant, preserves Interpretation confidence, folds structure-revealing guidance into each opportunity, and removes verification entries tied to retired sections."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Use Discovery Contribution Opportunities as the dominant model (Priority: P1)

As a maintainer of Profile guidance, I want the four domain-specific Discovery Contribution Opportunities to be the only general development model so that agents receive one consistent sequence from accepted evidence through a Converged Proposal.

**Why this priority**: Eliminating competing interaction models is the central objective and prevents inconsistent behavior across Profile domains.

**Independent Test**: Review the Profile guidance and verify that the four opportunities define the retained development path, while the five named competing sections are absent.

**Acceptance Scenarios**:

1. **Given** Profile guidance is read for Identity, Vision, Competitive Path, or Guiding Principles, **When** a maintainer looks for the development model, **Then** the guidance leads from accepted evidence to a proposed starting point, reaction, refinement, and convergence through that domain's Discovery Contribution Opportunity.
2. **Given** the retired general guidance sections are searched for, **When** the Profile source is inspected, **Then** Advisory question scaffolding, Contribution in practice, Possibility-list Contribution Opportunities, Structure-revealing contributions, and Organizational expression are no longer presented as standalone sections.
3. **Given** a person has not yet contributed substantive material to a domain, **When** the domain is developed, **Then** the existing Contribution Opportunity and reaction path remains available before convergence.

### User Story 2 - Preserve proposal-first interpretation and grounded structure (Priority: P1)

As a person developing Profile information, I want grounded interpretation and structure to appear inside the proposed starting point so that I can react to a coherent proposal instead of navigating separate question or contribution mechanisms.

**Why this priority**: The simplification must retain the useful reasoning while relocating it into the authoritative proposal-first interaction surface.

**Independent Test**: Inspect Interpretation confidence and all four Discovery Contribution Opportunity sections and verify that the preserved proposal-first guidance and structure sentence appear without a competing scaffolding section.

**Acceptance Scenarios**:

1. **Given** accepted evidence supports a useful interpretation, **When** an active Discovery Contribution Opportunity presents a starting point, **Then** the interpretation remains inside that proposed starting point and is available for correction or refinement.
2. **Given** accepted evidence contains supported relationships, patterns, tensions, tradeoffs, implications, dependencies, or organizing principles, **When** a domain starting point is formed, **Then** the starting point can reveal that structure without invoking a separate structure-revealing contribution model.
3. **Given** accepted evidence cannot support a responsible starting point, **When** the workflow needs user-owned information, **Then** the existing focused clarification or canonical fallback behavior remains available.

### User Story 3 - Remove obsolete verification claims while preserving boundaries (Priority: P2)

As a maintainer validating Profile behavior, I want verification claims tied to retired guidance removed so that checks describe the active Discovery Contribution Opportunity model rather than enforcing obsolete sections.

**Why this priority**: Verification must remain aligned with the surviving interaction model, but the cleanup must not weaken acceptance, persistence, ownership, attribution, readiness, or schema guarantees.

**Independent Test**: Inspect Profile verification guidance and its directly corresponding static contracts, then run the Profile validation suite to confirm obsolete claims are absent and protected boundaries remain enforced.

**Acceptance Scenarios**:

1. **Given** Profile verification guidance is reviewed, **When** claims tied to retired sections are checked, **Then** the three worked-example claims and the two acknowledgment claims are absent.
2. **Given** the Profile source is simplified, **When** lifecycle and domain boundaries are validated, **Then** acceptance, persistence, readiness, ownership, attribution, retained schema, and convergence behavior remain unchanged.
3. **Given** Profile delivery copies are regenerated, **When** their content is compared with the authoritative source, **Then** all generated surfaces remain identical to the source.

### Edge Cases

- A grounded relationship or implication remains useful but must be expressed within a domain's proposed starting point rather than through a removed standalone section.
- Accepted evidence is too weak or contradictory to support a responsible starting point; clarification and canonical fallback behavior must not be removed.
- A useful possibility or tradeoff exists, but presenting it must not create a separate recommendation-set or question-first interaction model.
- Verification text may mention organizational expression as a domain concept where needed, but the retired Organizational expression guidance section must not remain as a competing development model.
- The simplification must not introduce new lifecycle state, persisted artifact, readiness dimension, runtime service, or retained Profile field.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile guidance MUST make the Identity, Vision, Competitive Path, and Guiding Principles Discovery Contribution Opportunities the dominant general development model.
- **FR-002**: Profile guidance MUST remove the standalone Advisory question scaffolding section.
- **FR-003**: Profile guidance MUST remove the standalone Contribution in practice section.
- **FR-004**: Profile guidance MUST remove the standalone Possibility-list Contribution Opportunities section.
- **FR-005**: Profile guidance MUST remove the standalone Structure-revealing contributions section.
- **FR-006**: Profile guidance MUST remove the standalone Organizational expression guidance section while preserving any necessary domain meaning and existing organizational-expression behavior.
- **FR-007**: Profile guidance MUST retain the existing Interpretation confidence guidance without expanding it beyond the preserved proposal-first behavior.
- **FR-008**: Each of the four Discovery Contribution Opportunity sections MUST state that its proposed starting point can reveal relationships, patterns, structure, tensions, tradeoffs, implications, dependencies, and organizing principles already supported by accepted evidence.
- **FR-009**: Profile guidance MUST remove verification claims for three worked Contribution in practice exemplars and one Contribution in practice counter-example.
- **FR-010**: Profile guidance MUST remove verification claims that each Substantive Contribution receives one acknowledgment and that an acknowledgment adds understanding beyond restating the contribution.
- **FR-011**: The simplification MUST preserve existing acceptance, persistence, readiness, ownership, attribution, convergence, and retained-schema behavior.
- **FR-012**: Generated Profile delivery surfaces MUST remain identical to the authoritative Profile guidance after the simplification.
- **FR-013**: The simplification MUST remain limited to Profile guidance and directly corresponding validation contracts; it MUST NOT add a new lifecycle state, persisted artifact, readiness dimension, runtime service, or retained Profile field.

## Key Entities *(include if feature involves data)*

- **Discovery Contribution Opportunity**: A transient, structured proposal-first interaction for developing a Profile domain before convergence.
- **Proposed Starting Point**: A provisional, reviewable representation of accepted-evidence-grounded interpretation and structure that the person can add to, correct, remove, or refine.
- **Interpretation Confidence**: Profile guidance that favors a grounded, correctable interpretation over forcing the person to create one from scratch.
- **Profile Guidance Surface**: The authoritative Profile instructions, verification guidance, and generated delivery copies.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All four Profile domains identify their Discovery Contribution Opportunity as the applicable development model, and all five named competing standalone sections are absent from the authoritative guidance.
- **SC-002**: All four Discovery Contribution Opportunity sections contain the required structure-revealing sentence or an equivalent statement that preserves its complete meaning.
- **SC-003**: 100% of preserved Interpretation confidence statements remain present and no new separate interpretation or contribution mechanism is introduced.
- **SC-004**: 100% of the five obsolete verification claims named in the feature description are absent while existing protected-boundary checks remain passing.
- **SC-005**: All generated Profile delivery surfaces match the authoritative guidance byte-for-byte after regeneration.
- **SC-006**: The complete Profile validation suite exits successfully with zero failures after the simplification.
- **SC-007**: No new lifecycle state, persisted artifact, readiness dimension, runtime service, or retained Profile field is introduced.

## Assumptions

- The authoritative Profile source remains the source of truth for all generated delivery copies.
- The four existing Discovery Contribution Opportunity sections already contain the domain-specific proposal, reaction, refinement, and convergence behavior needed after the competing sections are removed.
- Interpretation confidence remains a concise conceptual foundation and does not absorb the retired sections' detailed examples or mechanics.
- Directly corresponding static contracts may be updated when they assert behavior intentionally removed by this feature; unrelated contracts and governance documents remain unchanged.
- The feature changes guidance and validation surfaces only; no runtime conversational behavior is claimed beyond the static document evidence.
