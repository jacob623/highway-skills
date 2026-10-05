# Feature Specification: Profile Convergence Alignment

**Feature Branch**: `140-profile-convergence-alignment`

**Created**: 2026-10-05

**Status**: Draft

**Input**: User description: Align `highway-profile` with the finalized reciprocal collaborative-development model in Highway Identity and the Experience Standard while preserving Profile domain, readiness, acquisition, acceptance, persistence, and ownership behavior.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Separate Profile completeness from conversational convergence (Priority: P1)

As a person developing organizational Profile knowledge, I want Profile to distinguish a complete domain candidate from a collaboratively settled Working Idea, so that a writable narrative is not presented for acceptance while useful substantive development can still change its meaning.

**Why this priority**: This is the central behavioral boundary. Without it, Profile can bypass the shared Experience Standard and prematurely convert domain-complete material into accepted knowledge.

**Independent Test**: Inspect Profile model, acquisition, enrichment, and validation guidance for all four domains, then verify that final presentation and acceptance require both Profile domain completeness and shared conversational convergence.

**Acceptance Scenarios**:

1. **Given** accepted evidence supports a coherent Identity, Vision, Competitive Path, or Guiding Principles candidate, **When** a newly surfaced connection, implication, alternative, assumption, challenge, or recommendation can still change its meaning, **Then** Profile continues domain-specific collaborative development instead of presenting the candidate as a Converged Proposal.
2. **Given** a Profile domain is complete and its Working Idea has converged under the Experience Standard, **When** Profile presents the domain candidate, **Then** the existing accuracy-oriented validation wording and owner-controlled acceptance behavior remain unchanged.
3. **Given** a person supplies a domain-complete contribution that Profile does not materially reshape, **When** further development would add no substantive value, **Then** the existing direct or mature-contribution path remains available.

### User Story 2 - Apply reciprocal domain-specific development (Priority: P1)

As a person working through Profile, I want useful Profile connections and possibilities to be discussed before they are forced into provisional structure or final prose, so that my response can adopt, modify, combine, narrow, redirect, challenge, reject, or extend the developing domain understanding.

**Why this priority**: Highway Identity defines collaboration as reciprocal. Profile must apply that model in domain-specific terms without copying the generic interaction loop into the skill.

**Independent Test**: Review each of Identity, Vision, Competitive Path, and Guiding Principles for a domain-specific allowance to surface and reconsider useful contributions conversationally, with the response treated as new reasoning material.

**Acceptance Scenarios**:

1. **Given** Profile identifies a useful domain relationship or possibility, **When** that idea has not yet been established as accepted organizational knowledge, **Then** Profile may discuss it conversationally before representing it as a facet, theme, strategic piece, principle, or final narrative.
2. **Given** a person responds substantively to a Profile contribution or Contribution Opportunity, **When** the response changes or reveals the domain meaning, **Then** Profile re-evaluates the changed Working Idea and may continue development before final synthesis.
3. **Given** a possible Vision, Competitive Path, or Guiding Principles contribution extends beyond established organizational context, **When** Profile raises it, **Then** Profile presents it as an advisory possibility with enough basis or uncertainty for evaluation and does not silently establish it as fact.

### User Story 3 - Preserve Profile domain and ownership boundaries (Priority: P1)

As a maintainer of Profile governance, I want the alignment to retain the four readiness domains and existing owner boundaries, so that improved collaboration does not change what Profile owns, what downstream skills own, or how accepted knowledge is persisted.

**Why this priority**: Profile is a shared retained organizational artifact. Collaboration changes must not alter its schema, readiness semantics, mutation behavior, acquisition sources, or downstream responsibilities.

**Independent Test**: Compare the amended Profile behavior against the retained structure and existing ownership contracts, confirming that only Profile-specific convergence guidance changes.

**Acceptance Scenarios**:

1. **Given** Profile setup or configuration is active, **When** evidence is acquired from direct input, supported websites, or imported organizational material, **Then** acquisition, proposal status, acceptance, mutation, and readiness semantics remain unchanged.
2. **Given** a person volunteers Controls, NFRs, architecture, implementation, or operational detail while developing Competitive Path, **When** that information does not change the broad organizational approach, **Then** Profile leaves the downstream-owned detail outside Profile evidence.
3. **Given** an accepted Profile mutation succeeds or fails, **When** Profile produces dependent readiness or completion behavior, **Then** existing mutation-before-dependent-output and failure semantics remain unchanged.

### User Story 4 - Keep canonical questions and verification actionable (Priority: P2)

As a workflow author or reviewer, I want Profile questions to remain fallbacks and verification to make the completeness/convergence boundary visible, so that Profile remains an advisor without manufacturing turns or duplicating generic Experience Standard rules.

**Why this priority**: The alignment must be reviewable and usable by maintainers while preserving the shared standard as the owner of generic interaction mechanics.

**Independent Test**: Review Acquisition, Enrichment, Verification, and version metadata for Profile-specific outcomes, absence of duplicated generic rules, preserved canonical questions, and explicit self-application of the shared boundary.

**Acceptance Scenarios**:

1. **Given** accepted Profile evidence supports neither a complete converged candidate nor a useful Profile contribution, **When** unresolved organizational information is genuinely required, **Then** the applicable focused canonical question remains the fallback.
2. **Given** no useful substantive development remains, **When** a mature or direct domain-complete contribution is being handled, **Then** Profile does not manufacture additional turns merely because more detail could theoretically be collected.
3. **Given** a reviewer checks Profile Verification, **When** they assess convergence, provisional structure, Contribution Opportunity re-entry, advisory possibilities, and downstream boundaries, **Then** the checks are Profile-specific outcomes rather than a duplicate of the generic Experience Standard.

### Edge Cases

- A domain candidate is complete enough to write but a new substantive connection can still change its meaning; Profile continues development rather than presenting acceptance.
- A Contribution Opportunity response adds nothing substantive after the Working Idea settles; Profile may proceed directly to the existing final candidate and validation path.
- A Contribution Opportunity response adds a correction, relationship, alternative, or extension; Profile re-enters development without requiring another Contribution Opportunity unless the shared criteria independently require one.
- A person directly supplies a precise domain-complete contribution and Profile does not materially reshape it; the mature direct-contribution path remains available.
- Website or imported evidence supports multiple unresolved domains but does not itself establish accepted Profile facts; evidence remains proposed until the existing acceptance boundary is satisfied.
- A plausible future Vision connection is useful but not established organizational direction; Profile raises it as an advisory possibility rather than persisting it as fact.
- Competitive Path reasoning exposes a broad strategic connection alongside implementation detail; Profile retains only the broad meaning and leaves implementation ownership downstream.
- A possible principle is visible in accepted context but discussion can still refine or reject it; Profile keeps it in transient development until the existing acceptance boundary.
- Optional enrichment remains optional and does not change readiness.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile MUST state that its complete-candidate and domain-readiness responsibility is distinct from the Experience Standard's responsibility for conversational convergence.
- **FR-002**: Profile MUST apply shared contextual re-evaluation and Contribution Opportunity behavior when its interpretation, synthesis, acquisition, or recommendation materially shapes a Working Idea, without restating the full generic interaction loop.
- **FR-003**: Profile acquisition MUST present a Converged Proposal only when the applicable domain candidate is complete and its Working Idea has converged under the Experience Standard.
- **FR-004**: Profile acquisition MUST continue developing a useful Profile Working Idea when supported before falling back to a canonical question.
- **FR-005**: Profile MUST ask a canonical domain question only when accepted evidence and active Working Idea context support neither a Converged Proposal nor a useful Profile contribution, or when unresolved organizational information requires the person's input.
- **FR-006**: Profile MUST define domain completeness as a coherent, supported answer to the active domain and MUST NOT treat domain completeness alone as conversational convergence.
- **FR-007**: Profile MUST allow useful domain connections to be discussed conversationally before they are represented as provisional facets, themes, strategic pieces, principles, or final narratives.
- **FR-008**: A substantive response to a Profile contribution or Contribution Opportunity MUST be treated as new Profile reasoning material and may return the active domain to collaborative development when it changes the domain meaning.
- **FR-009**: Identity final synthesis and accuracy-oriented validation MUST require a complete Identity candidate and shared conversational convergence, while preserving Identity breadth, provisional-facet, direct-complete, and mature-contribution behavior.
- **FR-010**: Vision guidance MUST reconsider changed understanding before synthesis when a useful interpretation, connection, distinction, or implication exists, and MUST distinguish advisory future possibilities from established organizational direction.
- **FR-011**: Competitive Path guidance MUST permit broad strategic connections to be surfaced and reconsidered before provisional or final structure, while keeping implementation mechanisms with downstream owners.
- **FR-012**: Guiding Principles guidance MUST permit possible principles to be discussed and refined, rejected, narrowed, or extended before inclusion in provisional or final principle structure.
- **FR-013**: Final validation questions for Identity, Vision, Competitive Path, and Guiding Principles MUST remain the existing accuracy-oriented acceptance wording and MUST be used only after the applicable candidate is complete and conversationally converged.
- **FR-014**: Provisional facets, themes, strategic pieces, and principle lists MUST remain representations of transient Working Idea substance and MUST be regenerated or revised when useful discussion changes that substance.
- **FR-015**: Profile MUST preserve its four readiness domains: Identity, Vision, Competitive Path, and Guiding Principles, including existing `not_discussed`, `discussed`, and `bounded` semantics.
- **FR-016**: Profile MUST preserve retained Profile structure, `profile-record.md`, schema version behavior, Repository Name and optional Context behavior, supported website and imported-material acquisition, and existing readiness semantics.
- **FR-017**: Profile MUST preserve proposal evidence remaining transient until accepted, accepted evidence persistence, mutation-before-dependent-output behavior, failure behavior, update/remove/reset behavior, and guided completion synthesis.
- **FR-018**: Profile MUST preserve downstream ownership boundaries and MUST NOT develop or retain Controls, NFRs, architecture, implementation, operational, or other downstream-owned detail as Profile evidence solely because it is volunteered.
- **FR-019**: Profile MUST preserve its scope exclusions, canonical fallback questions, organization-name acceptance requirements, organization-URL behavior, organizational-expression behavior, and technology-landscape exclusion.
- **FR-020**: Profile MUST keep generic Experience Standard rules, recursive interaction mechanics, clarification semantics, advisory calibration, one-question behavior, and acceptance semantics referenced rather than duplicated locally.
- **FR-021**: Profile Verification MUST include checkable Profile-specific outcomes for completeness versus convergence, conversational development before provisional structure, Contribution Opportunity re-entry, advisory possibilities, mature direct contributions, no manufactured turns, and downstream ownership.
- **FR-022**: The amended Profile skill MUST complete its self-application and Constitution compatibility review, preserve applicable versioning requirements, and modify neither the Constitution nor the shared Experience Standard as part of this feature.

### Key Entities *(include if data involved)*

- **Profile Domain Candidate**: A coherent, supported candidate for one of Identity, Vision, Competitive Path, or Guiding Principles; complete according to Profile's domain meaning but not necessarily conversationally converged.
- **Profile Working Idea**: Transient domain-specific understanding containing accepted context, active evidence, interpretations, connections, possibilities, alternatives, implications, assumptions, and responses that may still change the candidate.
- **Converged Proposal**: A complete Profile domain candidate whose substantive Working Idea has converged under the shared Experience Standard and is ready for the existing owner-controlled validation and acceptance interaction.
- **Provisional Profile Structure**: Transient facets, themes, strategic pieces, or principle lists used to inspect developed substance; it is not accepted Profile knowledge and may be revised from changed understanding.
- **Accepted Profile Evidence**: User-provided or user-accepted organizational knowledge retained through the existing Profile mutation and persistence boundaries.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Reviewers can identify the distinct domain-completeness and conversational-convergence conditions in the Profile model, acquisition, enrichment, and all four domain sections with zero ambiguous final-acceptance triggers.
- **SC-002**: All four Profile domains contain explicit guidance that final validation occurs only after domain completeness and shared conversational convergence, while preserving their existing acceptance wording.
- **SC-003**: A focused Profile contract review detects every required convergence boundary, reciprocal development path, provisional-structure safeguard, and ownership boundary with 100% pass results.
- **SC-004**: The full repository validation suite passes with zero failures after the alignment is applied.
- **SC-005**: No changes are made to `profile-record.md`, the Highway Skills Constitution, the shared Experience Standard, Highway Identity, setup, Objectives, readiness state semantics, persistence behavior, or downstream owner artifacts as part of implementation.
- **SC-006**: Reviewers find no Profile-local copy of the generic person-Highway recursive loop, X2.41, generic clarification rules, advisory calibration, one-question rules, or generic acceptance semantics.
- **SC-007**: Mature direct contributions and explicit domain-complete contributions can still reach the existing validation path without an additional manufactured collaboration turn.

## Assumptions

- The current `highway-profile` skill, retained Profile template, Profile tests, Experience Standard, Highway Identity, and Constitution are the authoritative baseline.
- The shared Experience Standard remains the owner of generic collaborative interaction behavior; this feature adds only concise Profile-specific application guidance.
- Profile versioning treats this focused behavior and guidance alignment as a minor skill amendment from version 7.0.0 unless the Constitution's versioning policy determines otherwise during planning.
- No new runtime interaction engine, persisted conversational state, Profile schema field, external contract, or retained artifact structure is required.
- Existing user-facing validation wording and existing direct or mature-contribution exceptions are preserved exactly unless a current Profile contract requires an equivalent non-semantic formatting adjustment.
- Focused static document-contract validation and the existing shipped-tree suite are sufficient to verify this documentation-and-skill alignment.
