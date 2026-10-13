# Feature Specification: Profile Structured Proposals

**Feature Branch**: `167-profile-structured-proposals`

**Created**: 2026-10-13

**Status**: Draft

**Input**: User description: "Update highway-profile so Vision, Competitive Path, and Guiding Principles can present structured proposed starting points from accepted Profile evidence before exploratory questioning, following the existing Identity pattern while preserving discovery, user authority, and acceptance boundaries."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review a proposed Vision starting point (Priority: P1)

As a person developing the organization's Vision, I want Highway to present a structured first-pass interpretation when accepted Profile evidence supports one so that I can react to a meaningful proposal instead of constructing Vision through a question chain.

**Why this priority**: Vision is a core Profile domain and the requested behavior change is primarily about making its first useful interpretation visible earlier.

**Independent Test**: Provide accepted Identity and Profile evidence that supports a cohesive Vision interpretation; verify that Highway presents a structured Vision starting point, invites additions or corrections, and continues to refinement rather than treating the starting point as accepted.

**Acceptance Scenarios**:

1. **Given** accepted Identity and other Profile evidence supports a responsible first-pass Vision interpretation, **When** Vision development begins, **Then** Highway presents a structured proposed Vision starting point before exploratory questioning.
2. **Given** a Vision starting point is presented, **When** the person adds, corrects, or removes substance, **Then** Highway treats the response as a substantive contribution and refines the working Vision.
3. **Given** accepted evidence cannot support a responsible Vision starting point, **When** Vision development begins, **Then** Highway uses focused exploratory questioning as the exception path.

### User Story 2 - Review a proposed Competitive Path starting point (Priority: P1)

As a person developing the organization's Competitive Path, I want Highway to connect the proposed path to accepted Identity, Vision, and other Profile evidence so that I can review how the organization intends to advance without reconstructing the path through repeated questions.

**Why this priority**: Competitive Path depends on preceding Profile context and is central to turning accepted direction into a coherent way forward.

**Independent Test**: Provide accepted Identity, Vision, and other Profile evidence that supports a cohesive Competitive Path interpretation; verify that Highway presents a structured proposed path, invites reaction, and preserves the fallback to questions when evidence is insufficient.

**Acceptance Scenarios**:

1. **Given** accepted Identity, Vision, and other Profile evidence supports a responsible first-pass Competitive Path interpretation, **When** Competitive Path development begins, **Then** Highway presents a structured starting point before exploratory questioning.
2. **Given** the person redirects or corrects the proposed Competitive Path, **When** Highway continues development, **Then** the updated working interpretation reflects the response and remains available for further refinement.
3. **Given** accepted evidence cannot support a responsible Competitive Path starting point, **When** the domain is developed, **Then** Highway asks only consequential questions that accepted context cannot resolve.

### User Story 3 - Review proposed Guiding Principles individually (Priority: P1)

As a person developing Guiding Principles, I want likely decision-making values presented as separate structured items so that I can evaluate each value individually rather than react to an indistinct narrative paragraph.

**Why this priority**: Guiding Principles influence later decisions, and individually visible values make correction, removal, and refinement materially easier.

**Independent Test**: Provide accepted Profile evidence that supports several likely decision-making values; verify that Highway presents them as structured items, invites additions or corrections, and keeps them provisional until the existing acceptance flow.

**Acceptance Scenarios**:

1. **Given** accepted Profile evidence supports a responsible interpretation of likely decision-making values, **When** Guiding Principles development begins, **Then** Highway presents a structured starting point with individual principle items before exploratory questioning.
2. **Given** the person rejects, changes, or adds a principle, **When** Highway continues development, **Then** it updates the working interpretation without silently retaining the proposed principle.
3. **Given** accepted evidence cannot support a responsible starting point, **When** Guiding Principles development begins, **Then** Highway uses focused exploratory questions rather than inventing values.

### User Story 4 - Continue normal convergence and acceptance (Priority: P1)

As a person developing any of the three domains, I want structured starting points to remain provisional and flow into normal convergence so that I remain authoritative over the final Profile content.

**Why this priority**: The feature improves the interaction pattern without changing domain ownership, acceptance, or persistence behavior.

**Independent Test**: Trace a starting point through reaction, refinement, convergence, and acceptance; verify that only the existing domain proposal crosses the existing acceptance boundary and that no new lifecycle or persistence path is introduced.

**Acceptance Scenarios**:

1. **Given** a structured starting point is presented, **When** the person reacts to it, **Then** the response changes the working domain interpretation before convergence.
2. **Given** the person has contributed and further grounded refinement is unlikely to materially improve the domain, **When** Highway converges the domain, **Then** it presents the existing domain proposal and acceptance flow.
3. **Given** a proposed starting point has not been accepted, **When** readiness or persistence is evaluated, **Then** it does not establish accepted Profile content, readiness, ownership, or retained state.

### Edge Cases

- Accepted evidence supports only part of a domain; Highway presents a bounded starting point or asks a focused question for the consequential gap rather than implying unsupported completeness.
- Evidence supports several overlapping interpretations; Highway presents a concise, non-redundant structured proposal that the person can combine, correct, or remove.
- The person provides a direct domain contribution before a starting point is needed; Highway preserves the existing contribution and convergence behavior without redundant presentation.
- The person corrects a starting point but meaningful refinement remains; Highway continues development rather than transitioning immediately to the final proposal.
- The person rejects all proposed values or directions; Highway does not reintroduce rejected substance without new supporting evidence.
- Accepted context is contradictory, stale, or insufficient; Highway states the limitation and uses a consequential question instead of manufacturing a proposal.
- A proposed item is a Highway-introduced term or claim; it remains attributed and provisional until the person adopts or replaces it.
- The person requests explanation or comparison; the request does not count as acceptance and the working idea remains provisional.
- The same starting point would be shown again without new substance; Highway avoids redundant contribution opportunities.
- Generated agent adapters must preserve equivalent guidance and boundaries.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile MUST provide an optional Vision Discovery Contribution Opportunity when accepted Identity and other accepted Profile evidence support a responsible first-pass Vision interpretation.
- **FR-002**: Profile MUST provide an optional Competitive Path Discovery Contribution Opportunity when accepted Identity, Vision, and other accepted Profile evidence support a responsible first-pass Competitive Path interpretation.
- **FR-003**: Profile MUST provide an optional Guiding Principles Discovery Contribution Opportunity when accepted Profile evidence supports a responsible interpretation of likely decision-making values.
- **FR-004**: Each opportunity MUST present a proposed starting point before continuing exploratory questioning when accepted evidence supports one.
- **FR-005**: Vision starting points MUST use structured bullets that reveal major Vision elements in a form that is easy to review, compare, and modify rather than presenting the proposal as narrative prose.
- **FR-006**: Competitive Path starting points MUST use structured bullets that reveal how the organization intends to advance toward its Vision rather than presenting the proposal as narrative prose.
- **FR-007**: Guiding Principles starting points MUST present potential decision-making values as individually visible structured items rather than embedding them in a narrative paragraph.
- **FR-008**: Each structured starting point MUST be visually obvious as a proposed starting point and MUST end with an invitation to add, correct, or remove substance.
- **FR-009**: Profile MUST use accepted context to ground starting points and MUST adapt their content to the relevant accepted Profile evidence rather than presenting unsupported generic labels.
- **FR-010**: When a person makes a substantive contribution to a starting point, Profile MUST re-evaluate the active understanding with relevant accepted context and continue refinement before convergence.
- **FR-011**: Profile MUST prefer a structured starting point over exploratory questioning when accepted evidence supports a responsible interpretation, while retaining focused exploratory questions as the exception when it does not.
- **FR-012**: The three opportunities MUST remain Contribution Opportunities and MUST NOT be presented as accepted content, Converged Proposals, or acceptance requests.
- **FR-013**: Profile MUST preserve the existing domain convergence, proposal, acceptance, persistence, readiness, attribution, ownership, and retained-artifact behavior for Vision, Competitive Path, and Guiding Principles.
- **FR-014**: Profile MUST preserve the person's authority to adopt, redirect, correct, replace, add to, or remove substance from each proposed starting point.
- **FR-015**: Profile MUST NOT convert the three domains into synthesis-only workflows; each remains a discovery domain with questions available when responsible proposals cannot be formed.
- **FR-016**: The feature MUST NOT add new Profile fields, lifecycle stages, acceptance boundaries, readiness requirements, ownership rules, persisted artifacts, identifiers, or external dependencies.
- **FR-017**: The source Profile skill and all generated Profile adapters MUST contain equivalent proposal-first guidance and protected discovery and acceptance boundaries.

## Key Entities *(include if feature involves data)*

- **Vision Starting Point**: A transient, structured interpretation of accepted Profile evidence offered for the person's reaction before Vision convergence.
- **Competitive Path Starting Point**: A transient, structured interpretation of how the organization may advance toward its accepted or developing Vision.
- **Guiding Principles Starting Point**: A transient, structured set of individually visible potential decision-making values derived from accepted Profile evidence.
- **Contribution Opportunity**: A provisional invitation to add, correct, remove, redirect, or replace substance before convergence; it is not a candidate or acceptance request.
- **Converged Proposal**: The existing complete domain proposal that follows substantive contribution and refinement and remains subject to the existing acceptance boundary.
- **Accepted Profile Evidence**: User-owned Profile context that may ground a starting point without being replaced by Highway's provisional interpretation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of representative Vision cases with sufficient accepted evidence present a structured Vision starting point before exploratory questioning, while 100% of insufficient-evidence cases retain a focused question path.
- **SC-002**: 100% of representative Competitive Path cases with sufficient accepted Identity, Vision, and Profile evidence present a structured path starting point before exploratory questioning.
- **SC-003**: 100% of representative Guiding Principles cases with sufficient accepted evidence present individually visible principle items rather than only narrative prose.
- **SC-004**: 100% of starting-point outputs include a clear invitation to add, correct, or remove substance, and 0% present the starting point as accepted content or an acceptance request.
- **SC-005**: 100% of representative substantive reactions cause working-domain re-evaluation before convergence, and no correction transitions directly to the final proposal while meaningful refinement remains.
- **SC-006**: 100% of representative acceptance traces preserve the existing domain proposal, acceptance, persistence, ownership, readiness, and retained-artifact behavior with no additional lifecycle stage or acceptance boundary.
- **SC-007**: 100% of generated Profile adapters preserve the source guidance byte-for-byte or through the repository's declared equivalent transformation, and the existing Profile and full-suite checks remain passing.
- **SC-008**: In reviewer assessment, people can identify the proposed Vision, Competitive Path, and Guiding Principles content and the next reaction opportunity without needing to understand internal workflow terminology.

## Assumptions

- The existing Identity Discovery Contribution Opportunity is the behavioral precedent for these three additions.
- The existing Profile skill remains authoritative for domain meaning, completeness, convergence, acceptance, persistence, readiness, and ownership.
- The Highway Experience Standard governs generic interaction structure, contribution opportunities, grounded reasoning, attribution, and user authority.
- Accepted Profile evidence may support a starting point, but Highway-originated interpretations remain Working Ideas until the existing acceptance boundary is crossed.
- Structured bullets may use domain-appropriate labels; the feature does not require one fixed label taxonomy for all three domains.
- Static contract checks can verify required wording, ordering, structure, and protected boundaries; human review remains necessary for usefulness and quality of interpretations.

## Out of Scope

- Replacing Profile discovery with automatic synthesis or eliminating exploratory questioning.
- Persisting Vision, Competitive Path, or Guiding Principles starting points as new artifacts or records.
- Adding new Profile fields, domain schemas, lifecycle stages, acceptance paths, readiness dimensions, or ownership boundaries.
- Treating Highway interpretations as organizational facts or accepted values before the person accepts the existing domain proposal.
- Requiring one universal set of labels for Vision, Competitive Path, or Guiding Principles.
- Adding external research, services, dependencies, or a separate workflow for reviewing starting points.
