# Feature Specification: Profile Contribution Opportunity

**Feature Branch**: `134-profile-contribution-opportunity`

**Created**: 2026-10-03

**Status**: Draft

**Input**: User description: "Make highway-profile the proving implementation of the shared Contribution Opportunity behavior for Vision, Competitive Path, and Guiding Principles while preserving mature-contribution, acceptance, persistence, and owner boundaries."

## User Scenarios & Testing

### User Story 1 - Complete a Highway-shaped Profile idea (Priority: P1)

When Profile has materially helped develop the substance of a Vision, Competitive Path, or Guiding Principles Working Idea, the person can contribute to that substance before Profile turns it into the final domain proposal.

**Why this priority**: This is the core synchronization with the shared Experience Standard and prevents Profile from treating Highway-shaped completeness as user-complete meaning.

**Independent Test**: Exercise each applicable domain with a Working Idea substantially shaped by Profile, then verify that the person receives one substantive opportunity to add, correct, remove, or extend the developing content before the Converged Proposal.

**Acceptance Scenarios**:

1. **Given** Profile has materially shaped an incomplete Vision Working Idea and no equivalent opportunity has occurred, **When** the substantive shape becomes clear, **Then** Profile presents provisional Vision substance and offers a Contribution Opportunity before the final Vision narrative.
2. **Given** Profile has materially shaped a Competitive Path Working Idea and no equivalent opportunity has occurred, **When** the path is ready to converge, **Then** Profile offers the person an opportunity to add, correct, remove, or change the substantive path before synthesizing it.
3. **Given** Profile has materially shaped Guiding Principles and no equivalent opportunity has occurred, **When** the principles have a coherent substantive shape, **Then** Profile presents provisional principles and offers one opportunity to complete their substance before the final proposal.

### User Story 2 - Preserve adaptive depth for complete contributions (Priority: P1)

When the person supplies a domain-complete contribution, or has already had an equivalent opportunity during the active collaboration, Profile can proceed to convergence without adding a ceremonial question.

**Why this priority**: Profile must remain useful for mature contributors and must not turn Contribution Opportunity into a mandatory "anything else?" step.

**Independent Test**: Provide a domain-complete Vision, Competitive Path, Guiding Principles, or complete discovered Identity and verify that Profile follows the existing convergence behavior without an unnecessary separate Contribution Opportunity.

**Acceptance Scenarios**:

1. **Given** the person supplies a domain-complete contribution, **When** Profile evaluates it, **Then** Profile may converge without a distinct Contribution Opportunity.
2. **Given** the immediately preceding collaboration already invited substantive additions or corrections, **When** Profile is ready to converge, **Then** Profile does not repeat an equivalent opportunity.
3. **Given** Profile presents a complete discovered Identity for accuracy validation, **When** Profile has not materially changed its substance, **Then** Profile may use the existing accuracy-oriented validation path without a distinct Contribution Opportunity.

### User Story 3 - Separate substance completion from artifact acceptance (Priority: P1)

The person can respond to a Profile Contribution Opportunity without accidentally accepting the Profile domain, and can review the cohesive Converged Proposal only after the substantive opportunity is resolved.

**Why this priority**: The feature must preserve the existing Profile acceptance and persistence boundary while preventing duplicate final-form review.

**Independent Test**: Respond to a Contribution Opportunity with additions and with a "nothing else" response, then verify that both responses lead to re-evaluation or synthesis as appropriate but neither authorizes persistence before the separate domain acceptance decision.

**Acceptance Scenarios**:

1. **Given** the person adds, corrects, removes, or extends substantive content, **When** Profile receives the response, **Then** Profile incorporates it into the Working Idea and re-evaluates the domain before convergence.
2. **Given** the person indicates that nothing else should be added, **When** Profile receives the response, **Then** Profile treats the opportunity as complete, synthesizes the Converged Proposal, and does not treat the response as domain acceptance.
3. **Given** the Contribution Opportunity has resolved, **When** Profile presents the complete domain narrative, **Then** the existing domain acceptance question remains separate and only its acceptance can authorize the existing persistence path.
4. **Given** Profile can present provisional substance before convergence, **When** it later presents the Converged Proposal, **Then** it does not repeat substantially identical cohesive final-form domain prose twice.

### User Story 4 - Preserve Profile ownership and lifecycle boundaries (Priority: P1)

Profile implements the shared interaction behavior within its existing owner responsibilities without changing retained schema, readiness states, persistence ownership, subject transitions, or Setup responsibilities.

**Why this priority**: The synchronization is intentionally narrow and must not create a new Profile lifecycle state or move authority into another owner.

**Independent Test**: Inspect the Profile contract and protected artifacts after implementation, then verify that only the Profile interaction guidance and its verification evidence change while retained Profile structure and Setup boundaries remain unchanged.

**Acceptance Scenarios**:

1. **Given** a Contribution Opportunity is active, **When** the person responds, **Then** the content remains transient Working Idea material until the existing Converged Proposal acceptance boundary is crossed.
2. **Given** Profile moves between its existing domains, **When** Contribution Opportunity guidance applies within a domain, **Then** the existing visible subject transitions remain unchanged.
3. **Given** the feature is implemented, **When** protected shared and owner artifacts are inspected, **Then** Experience Standard, Constitution, Profile record template, Setup, Objectives, Controls, and NFRs are unchanged by this feature.

### Edge Cases

- The person explicitly says "no," "nothing else," or equivalent completion intent at the Contribution Opportunity; this completes substantive contribution but does not accept the domain.
- The person asks a new substantive question instead of adding content; Profile continues development only if another turn materially improves the result.
- Profile has materially shaped content but the preceding interaction already invited additions, corrections, omissions, or extensions; a distinct opportunity is skipped.
- Profile has not materially shaped the substance; the shared opportunity is not manufactured merely because a Converged Proposal will follow.
- A complete website-derived Identity is presented for accuracy validation; it follows the existing path unless Profile materially developed an incomplete or ambiguous Identity.
- The person tries to combine a Contribution Opportunity response with domain acceptance; Profile keeps the two boundaries distinct.
- A domain contains insufficient grounded information; Profile continues contribution-first discovery rather than presenting an unsupported provisional or final proposal.

## Requirements

### Functional Requirements

- **FR-001**: Profile MUST consume the shared Contribution Opportunity behavior when it materially shapes a Working Idea and the person has not already received an equivalent opportunity.
- **FR-002**: Profile MUST keep Contribution Opportunity within transient Working Idea development and MUST NOT treat it as acceptance, provisional acceptance, persistence approval, or workflow completion.
- **FR-003**: Profile MUST allow the person to add, correct, remove, extend, or redirect substantive content during an applicable Contribution Opportunity.
- **FR-004**: Profile MUST present applicable Contribution Opportunity content as provisional substantive pieces when that avoids repeating substantially identical final-form domain prose.
- **FR-005**: Profile MUST synthesize the resulting complete Vision, Competitive Path, or Guiding Principles once as the Converged Proposal after the applicable opportunity resolves.
- **FR-006**: Profile MUST preserve the existing domain acceptance question as a separate interaction from the Contribution Opportunity.
- **FR-007**: Profile MUST incorporate additive, corrective, removing, or extending responses into the active Working Idea and re-evaluate the domain.
- **FR-008**: Profile MUST treat a response indicating that nothing else should be added as completion of substantive contribution, not as artifact acceptance.
- **FR-009**: Profile MUST skip a distinct Contribution Opportunity for a domain-complete user contribution, a prior equivalent opportunity, an explicitly finished substantive contribution, or another applicable shared exception.
- **FR-010**: Profile MUST apply the proving behavior to Vision, Competitive Path, and Guiding Principles when each domain is materially shaped by Profile and no equivalent opportunity has occurred.
- **FR-011**: Profile MAY use the shared Contribution Opportunity for an incomplete or ambiguous Identity that Profile materially develops, but MUST NOT add one for a complete discovered Identity solely because accuracy validation follows.
- **FR-012**: Profile MUST keep a Contribution Opportunity as the only response-demanding question for its interaction turn and MUST NOT combine it with domain acceptance or another unresolved discovery question.
- **FR-013**: Profile MUST preserve contribution-first behavior, existing domain completeness, mature-contribution convergence, contextual re-evaluation, subject transitions, and readable final synthesis.
- **FR-014**: Profile MUST NOT add retained readiness values, lifecycle markers, checkpoints, or other persisted state for Contribution Opportunity.
- **FR-015**: Profile MUST leave the existing Profile record structure, persistence ownership, acceptance semantics, and Setup responsibility boundaries unchanged.
- **FR-016**: Profile verification MUST demonstrate applicability, skip conditions, response handling, substance-versus-representation behavior, domain coverage, one-question discipline, and protected-boundary preservation.

### Key Entities

- **Working Idea**: Transient Profile reasoning or developing domain substance that has not crossed the applicable acceptance boundary.
- **Contribution Opportunity**: A transient opportunity for the person to complete or correct substantive Working Idea content before final synthesis.
- **Converged Proposal**: The complete cohesive Profile domain representation presented for the existing acceptance decision.
- **Profile domain**: One of Identity, Vision, Competitive Path, or Guiding Principles, each with its existing completeness and acceptance behavior.
- **Accepted Profile knowledge**: Profile information retained only after the existing domain acceptance and persistence path succeeds.

## Success Criteria

### Measurable Outcomes

- **SC-001**: In verification scenarios where Profile materially shapes Vision, Competitive Path, or Guiding Principles without a prior equivalent opportunity, 100% of applicable scenarios provide a Contribution Opportunity before the Converged Proposal.
- **SC-002**: In verification scenarios involving domain-complete contributions, prior equivalent opportunities, or complete discovered Identity, 100% of exempt scenarios avoid a ceremonial duplicate Contribution Opportunity.
- **SC-003**: In 100% of tested Contribution Opportunity responses, additions, corrections, removals, and extensions remain transient until the separate Converged Proposal acceptance boundary is crossed.
- **SC-004**: In 100% of tested domain flows, the Contribution Opportunity and artifact acceptance appear as separate interaction turns and no turn combines the Contribution Opportunity with another unresolved discovery question.
- **SC-005**: In 100% of tested Vision, Competitive Path, and Guiding Principles flows, the final cohesive domain narrative is synthesized once after substantive contribution rather than presented as substantially identical final-form prose twice.
- **SC-006**: All protected artifacts named in the feature scope remain byte-for-byte unchanged after implementation, and the Profile verification contract reports zero failures.
- **SC-007**: Reviewers can identify the four distinct moments of Profile interaction: Working Idea development, Contribution Opportunity, Converged Proposal, and acceptance, without relying on undocumented behavior.

## Assumptions

- The shared Experience Standard and X2.37 remain the authoritative source for generic Contribution Opportunity triggers, exemptions, one-question discipline, and acceptance boundaries.
- Profile remains the owner of domain completeness, Converged Proposal presentation, acceptance, persistence, and contextual re-evaluation.
- Vision, Competitive Path, and Guiding Principles are the primary proving domains; Identity remains primarily accuracy-oriented for complete discovered evidence.
- The existing Profile record schema, readiness values, mutation path, visible subject transitions, and Setup orchestration contract are stable dependencies.
- Verification may use existing repository contract patterns and focused Profile checks, but this specification does not prescribe implementation technology or a new persisted state.
- No user-facing literal phrase is mandatory; wording may vary as long as the substantive opportunity and separate acceptance boundary are clear.

## Out of Scope

- Changes to the shared Experience Standard, Constitution, Profile record template, Setup, Objectives, Controls, or Non-Functional Requirements.
- New Profile persistence states, readiness values, contribution checkpoints, or artifact lifecycle statuses.
- A mandatory Contribution Opportunity for every Profile domain or every Working Idea.
- Changes to Profile subject transitions, domain acceptance questions, schema version, or mutation ownership.
