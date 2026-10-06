# Feature Specification: Constitution and Experience Standard Alignment

**Feature Branch**: `142-constitution-experience-alignment`

**Created**: 2026-10-06

**Status**: Draft

**Input**: User description: Align `constitution.md` with the finalized `experience-standard.md` by making the Constitution own authority, transience, accepted repository knowledge, owner completeness, persistence, orchestration, and active reasoning context while delegating visible collaborative development and convergence semantics to the Experience Standard.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Preserve the authority boundary (Priority: P1)

As a maintainer of Highway governance, I want the Constitution to define the authority state of Working Ideas and accepted repository knowledge without defining their conversational behavior, so that transient reasoning cannot be mistaken for accepted knowledge.

**Why this priority**: Authority and ownership are the foundation for every later interaction and persistence decision.

**Independent Test**: Review the amended definitions, Principle XIII introduction, rationale, and lifecycle and verify that they identify Working Ideas as transient and non-authoritative while delegating visible development and convergence to the Experience Standard.

**Acceptance Scenarios**:

1. **Given** a Working Idea inside Active Reasoning Context, **When** the Constitution is reviewed, **Then** it remains transient and non-authoritative until the applicable acceptance boundary is satisfied.
2. **Given** accepted owner persistence, **When** the resulting knowledge is used later, **Then** the Constitution identifies it as accepted repository knowledge available to later reasoning.

### User Story 2 - Separate completeness from convergence (Priority: P1)

As an owner of a governed domain, I want a complete candidate to become a Converged Proposal only after the Experience Standard's convergence requirements are satisfied, so that domain completeness and conversational convergence remain distinct responsibilities.

**Why this priority**: This removes the central ambiguity that currently allows a complete candidate to be treated as converged automatically.

**Independent Test**: Inspect the Converged Proposal definition, P12A.2 Observable, and lifecycle wording, then evaluate complete-but-developing and complete-and-settled scenarios against both governance documents.

**Acceptance Scenarios**:

1. **Given** an owner-complete candidate whose Working Idea is still changing through substantive development, **When** the governance model is applied, **Then** it is not treated as a Converged Proposal.
2. **Given** an owner-complete candidate whose collaborative development has converged, **When** the governance model is applied, **Then** it may be presented as a Converged Proposal at the artifact acceptance boundary.
3. **Given** agreement with an advisory Working Idea before broader development is settled, **When** the governance model is applied, **Then** the agreement does not create accepted repository knowledge or artifact acceptance.

### User Story 3 - Preserve owner-controlled acceptance and persistence (Priority: P1)

As an owning workflow maintainer, I want acceptance, mutation, declared results, and orchestration to remain Constitution-owned, so that aligning interaction semantics does not change persistence behavior or completion claims.

**Why this priority**: The alignment must not blur the boundary between visible acceptance interaction and successful owner persistence.

**Independent Test**: Review P12A.1, P12A.3, P12A.4, Principle XII, and the acceptance-to-owner-result boundary, confirming their required substance remains unchanged except for current-state wording such as `declared mutation`.

**Acceptance Scenarios**:

1. **Given** a person accepts a displayed Converged Proposal, **When** the owner processes the result, **Then** acceptance authorizes the owner mutation but does not itself claim successful persistence.
2. **Given** the owner mutation succeeds, **When** later reasoning occurs, **Then** the persisted result is available as accepted repository knowledge together with other relevant context.
3. **Given** a required owner result is not yet available, **When** orchestration evaluates completion, **Then** it does not advance or claim completion prematurely.

### User Story 4 - Verify cross-document non-duplication (Priority: P2)

As a governance reviewer, I want the amended Constitution and Experience Standard to have clearly separated responsibilities, so that future maintainers can identify which document owns authority, interaction, convergence, domain completeness, and persistence.

**Why this priority**: A reviewable division prevents the two documents from drifting back into competing interaction models.

**Independent Test**: Perform a cross-document review and targeted searches for duplicated collaborative interaction criteria, then run the repository's applicable governance checks.

**Acceptance Scenarios**:

1. **Given** either governance document, **When** a maintainer looks for Substantive Contribution, Conversational Clarification, Contribution Opportunity, or detailed convergence criteria, **Then** those interaction semantics are owned by the Experience Standard rather than recreated in the Constitution.
2. **Given** the Constitution, **When** a maintainer looks for authority, accepted repository knowledge, Active Reasoning Context, owner completeness, mutation, persistence, or orchestration, **Then** those responsibilities remain represented there.

### Edge Cases

- A candidate can be domain-complete while its Working Idea is still changing; completeness alone must not establish convergence.
- A person can agree with a Working Idea without accepting a complete artifact; agreement must not create accepted repository knowledge.
- The owner can accept a Converged Proposal but fail to persist it; the system must retain the distinction between acceptance authorization and the declared owner result.
- Repository context can conflict with active workflow or user evidence; existing Constitution precedence must remain authoritative.
- The amendment changes constitutional rule meaning, so its version classification and Sync Impact Report must accurately describe the change rather than labeling it a wording-only patch.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Constitution MUST define Working Idea as transient developing material within Active Reasoning Context that is not authoritative user-owned knowledge and MUST defer its user-visible development and interaction semantics to the Experience Standard.
- **FR-002**: The Constitution MUST define Converged Proposal as an owner-complete candidate whose applicable Experience Standard convergence requirements are satisfied and that can be presented at the artifact acceptance boundary.
- **FR-003**: The Constitution MUST describe Accepted User-Owned Artifact using the owner's declared mutation path and MUST remove the touched historical/comparative wording about an existing mutation path.
- **FR-004**: The amendment MUST preserve Active Reasoning Context and P12A.1, P12A.3, and P12A.4 in substance, including transient authority, active-task retention, and post-acceptance contextual re-evaluation.
- **FR-005**: Principle XIII MUST state that the Experience Standard governs visible collaborative development and convergence while the owning skill governs domain completeness.
- **FR-006**: P12A.2 MUST retain its distinction rule and MUST state in its Observable that a Converged Proposal requires both a complete owner candidate and the applicable Experience Standard convergence requirements.
- **FR-007**: The Principle XIII rationale and Collaborative knowledge lifecycle MUST describe authority, transience, convergence delegation, owner completeness, declared mutation, successful persistence, and later reasoning without reproducing the Experience Standard's interaction model.
- **FR-008**: The amendment MUST retain the acceptance-to-owner-result persistence boundary and Principle XII's owner readiness, mutation, result, and orchestration responsibilities without moving them into the Experience Standard.
- **FR-009**: The amendment MUST preserve Constitution precedence over the Experience Standard and MUST leave Principles X, XI, and XII unchanged in substance except for required cross-reference or touched current-state wording.
- **FR-010**: The amended Constitution MUST NOT define or duplicate Experience Standard concepts including Substantive Contribution, Conversational Clarification, Contribution Opportunity, Decision Context, Relevant Example, Presentation Label, Structured Information, or detailed conversational convergence criteria.
- **FR-011**: The amendment MUST include a Sync Impact Report naming the changed definitions, P12A.2 Observable, Principle XIII introduction and rationale, lifecycle, delegation boundary, unchanged persistence/orchestration boundary, and likely downstream review scope.
- **FR-012**: The amendment MUST update Constitution version metadata and Last Amended date according to the Constitution Versioning Policy, classifying the redefined P12A.2 governance meaning as MAJOR unless repository validation establishes a stricter applicable classification.
- **FR-013**: Self-Application MUST explicitly review P1.1-P1.4, P6.4, P6.6, P7.3, P12A.1-P12A.4, and the unchanged owner/orchestration rules, including that P12A.2 delegates convergence semantics without duplicating X2.41.
- **FR-014**: Validation MUST cover complete-but-developing, complete-and-settled, Working Idea agreement, artifact acceptance, and accepted-knowledge scenarios consistently across the Constitution and Experience Standard.

### Key Entities *(include if feature involves data)*

- **Working Idea**: Transient, non-authoritative developing material retained in Active Reasoning Context during the active task.
- **Converged Proposal**: A complete owner candidate that also satisfies applicable Experience Standard convergence requirements and is eligible for presentation at the artifact acceptance boundary.
- **Accepted Repository Knowledge**: Accepted user-owned or authoritative repository information available to guide later reasoning.
- **Active Reasoning Context**: Transient information organized during the active interaction to support reasoning toward the active task.
- **Owner Result**: The declared result returned by an owning workflow after its controlled acceptance mutation.
- **Governance Documents**: The Constitution and Experience Standard whose responsibilities must remain distinct and cross-documentally consistent.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The amended Constitution contains exactly one authoritative definition each for Working Idea and Converged Proposal, and both definitions explicitly preserve the authority/convergence boundary described in the requirements.
- **SC-002**: P12A.1, P12A.2, P12A.3, and P12A.4 remain individually present and addressable, with P12A.2 requiring both owner completeness and applicable Experience Standard convergence.
- **SC-003**: A review of the amended Constitution finds zero Constitution-owned lifecycle statements that equate owner completeness alone with a Converged Proposal.
- **SC-004**: A cross-document audit finds zero new Constitution definitions or rule criteria for Substantive Contribution, Conversational Clarification, Contribution Opportunity, or detailed Experience Standard convergence behavior.
- **SC-005**: The acceptance-to-owner-result boundary and Principle XII owner/orchestration responsibilities remain present with no change in their required ownership behavior.
- **SC-006**: The five required semantic regression scenarios produce the expected authority, convergence, acceptance, persistence, and contextual-reasoning outcomes in a documented validation review.
- **SC-007**: All applicable repository governance checks pass with zero failures after the amendment and its tests or guards are updated.
- **SC-008**: A governance reviewer can identify the Constitution as the authority/persistence/orchestration owner, the Experience Standard as the visible interaction/convergence owner, and owning skills as domain-completeness/content/persistence implementers without consulting historical amendment prose.

## Assumptions

- The target runtime Constitution is `.highway/governance/constitution.md`; `.specify/memory/constitution.md` remains development governance and is not amended by this feature.
- The finalized `.highway/governance/experience-standard.md` remains the authoritative source for visible collaborative interaction and convergence semantics.
- The existing Constitution versioning policy classifies redefining P12A.2's governance meaning as MAJOR; the implementation will confirm this classification against the document's own policy.
- Existing Principles X, XI, and XII, accepted-context precedence, owner mutation behavior, and orchestration contracts remain valid unless a directly conflicting touched phrase must be clarified.
- No application code, runtime schema, dependency, or external interface changes are required; the feature is a focused governance-document alignment.
- Downstream skills are reviewed only where they independently define an inconsistent Converged Proposal path; unrelated architecture and historical wording remain out of scope.
