# Feature Specification: Objective Archetypes

**Feature Branch**: `166-objective-archetypes`

**Created**: 2026-10-13

**Status**: Draft

**Input**: User description: "Add an Objective Archetypes section immediately after ## Recommendation Development and before ### Objective Development Lifecycle in highway-objectives. Expand recommendation generation to use accepted Profile evidence and Objective Archetypes while preserving Objective ownership, acceptance, persistence, and lifecycle boundaries."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Receive broader grounded Objective recommendations (Priority: P1)

As a person developing Objectives from accepted Profile evidence, I want recommendations to include useful outcome areas that Profile evidence alone may not reveal so that I can consider operational, customer, and organizational-effectiveness outcomes alongside mission-oriented outcomes.

**Why this priority**: Broader recommendation coverage is the primary value of the feature and directly changes the recommendation experience.

**Independent Test**: Review recommendation-generation guidance with accepted Profile evidence that produces mission-oriented recommendations and verify that useful coverage gaps can add unified recommendations without changing adoption or presentation behavior.

**Acceptance Scenarios**:

1. **Given** accepted Profile evidence supports specific organizational outcomes, **When** recommendations are generated, **Then** Profile-derived recommendations are generated first and remain preferred.
2. **Given** the initial recommendations are concentrated in one or more outcome areas and a meaningful uncovered area may benefit the organization, **When** coverage is evaluated, **Then** one or more additional recommendations may be generated from Objective Archetypes.
3. **Given** Profile-derived and archetype-derived recommendations are both useful, **When** they are presented, **Then** they appear together as one recommendation set with the same presentation contract and the user's own outcome remains available.
4. **Given** no useful coverage gap exists, **When** recommendations are generated, **Then** no recommendation is manufactured merely to represent an archetype family.

### User Story 2 - Preserve the meaning and boundaries of Objective Archetypes (Priority: P1)

As a person receiving Objective recommendations, I want archetypes to broaden suggestions without implying facts, problems, intent, or acceptance about my organization so that I retain authority over what outcomes matter.

**Why this priority**: The feature must increase coverage without changing the ownership and acceptance model that protects user authority.

**Independent Test**: Inspect the Objective Archetypes and recommendation guidance and verify that archetypes remain internal recommendation-generation guidance, are not exposed as categories, and do not alter the Objective Development Lifecycle.

**Acceptance Scenarios**:

1. **Given** an archetype-derived recommendation is presented, **When** the person reviews it, **Then** the output shows only the recommended Objective and does not reveal its archetype family or source.
2. **Given** an archetype-derived recommendation is offered, **When** the person asks for explanation or rejects it, **Then** it remains a Working Idea and does not become an accepted organizational fact, problem, or Objective.
3. **Given** a person selects, modifies, rejects, or replaces a recommendation, **When** Objective development continues, **Then** the existing Objective Development Lifecycle and acceptance boundary remain unchanged.

### User Story 3 - Receive relevant additional suggestions over time (Priority: P2)

As a person who has already accepted several Objectives, I want additional suggestions to consider both accepted Profile evidence and meaningful gaps in my current Objective portfolio so that recommendations remain useful without becoming repetitive or artificially broad.

**Why this priority**: Additional suggestions are an important continuation path after initial recommendations, but the initial recommendation set is the core experience.

**Independent Test**: Review additional-suggestion guidance with accepted Objectives concentrated in mission-oriented areas and verify that a useful operational, customer, or capability suggestion may be offered with a concise grounded explanation, while duplicate or manufactured suggestions are withheld.

**Acceptance Scenarios**:

1. **Given** accepted Objectives cover curriculum, production, community, and partnerships, **When** the person requests additional suggestions, **Then** the owner may offer a useful operational outcome such as streamlining operations when the coverage gap may benefit the organization.
2. **Given** accepted Profile evidence or the current Objective portfolio reveals no useful non-duplicate suggestion, **When** additional suggestions are requested, **Then** the owner does not manufacture a recommendation and preserves the user-authored path.
3. **Given** an additional suggestion is presented, **When** the person considers it, **Then** the suggestion remains a Working Idea until the person selects, modifies, or provides an Objective and the normal lifecycle continues.

### Edge Cases

- Accepted Profile evidence supports recommendations across several families; the owner does not add recommendations solely to balance the families.
- Profile evidence supports no responsible recommendation; archetypes do not create organizational facts or replace the requirement for responsible evidence.
- A recommendation could fit more than one family; the person sees only the unified Objective recommendation and no family label.
- The recommendation set would exceed five actionable choices; the existing recommendation-set limit remains in force.
- An archetype-derived recommendation resembles an existing accepted Objective; duplicate and semantic-overlap handling remains authoritative.
- The person asks to see archetype categories or recommendation sources; those internal concepts are not exposed as workflow choices or user-facing categories.
- The person requests additional suggestions after accepting Objectives with broad coverage; the owner stops when no useful grounded non-duplicate recommendation remains.
- The person provides their own outcome or asks for explanation, comparison, or more information; the user-authored path and non-acceptance boundaries remain available.
- Generated adapters must preserve equivalent Objective Archetype guidance, recommendation boundaries, and lifecycle behavior.

## Requirements *(mandatory)*

### Requested Skill Structure

The `highway-objectives` skill will contain an `## Objective Archetypes` section immediately after `## Recommendation Development` and before `### Objective Development Lifecycle`. That section will define the coverage principle, Growth, Operations, Customer, and Capability families, recommendation-generation guidance, coverage evaluation, recommendation presentation boundaries, additional-suggestion behavior, and recommendation boundaries.

### Functional Requirements

- **FR-001**: The Objective skill MUST define Objective Archetypes immediately after `## Recommendation Development` and before `### Objective Development Lifecycle`.
- **FR-002**: The Objective skill MUST define accepted Profile evidence and Objective Archetypes as complementary recommendation sources.
- **FR-003**: Profile-derived recommendations MUST be generated first and MUST remain the preferred source when accepted evidence clearly supports specific organizational outcomes.
- **FR-004**: Objective Archetypes MUST improve recommendation coverage without creating organizational facts, establishing organizational intent, implying organizational problems, or replacing Profile-grounded recommendations.
- **FR-005**: The Objective skill MUST define the Growth, Operations, Customer, and Capability archetype families with representative outcome examples.
- **FR-006**: Before presenting recommendations, the owner MUST evaluate whether meaningful coverage gaps exist across the four archetype families and MUST avoid manufacturing recommendations solely to satisfy family coverage.
- **FR-007**: When a meaningful coverage gap may benefit the organization, the owner MAY generate one or more archetype-derived recommendations and present them with Profile-derived recommendations as one unified recommendation set.
- **FR-008**: The owner MUST NOT expose archetype family names, recommendation sources, internal coverage evaluation, or archetypes as user-facing categories or workflow concepts.
- **FR-009**: Archetype-derived recommendations MUST follow the same presentation, choice wording, user-authored alternative, Working Idea, and acceptance behavior as Profile-derived recommendations.
- **FR-010**: When additional suggestions are requested, the owner MUST evaluate accepted Profile evidence, the current accepted Objective portfolio, uncovered evidence areas, meaningful archetype coverage gaps, and meaningful portfolio gaps before presenting a suggestion.
- **FR-011**: Additional suggestions MUST stop when no useful grounded non-duplicate recommendation remains, and the owner MUST NOT manufacture recommendations for volume or family balance.
- **FR-012**: The Objective Archetypes guidance MUST state that all recommended Objectives remain Working Ideas until the person selects, modifies, or provides their own Objective and the normal Objective Development Lifecycle continues.
- **FR-013**: The feature MUST preserve Objective ownership, proposal completeness, user contribution, acceptance, capture, queue behavior, duplicate and overlap handling, persistence, identifiers, catalogs, readiness, mutation output, non-write behavior, and atomic transaction boundaries.
- **FR-014**: The feature MUST preserve the existing recommendation limit of at most five distinct actionable choices and MUST preserve the user's ability to provide their own outcome whenever recommendations are shown.
- **FR-015**: The source Objective skill and all generated Objective adapters MUST contain equivalent Objective Archetype guidance and protected lifecycle boundaries.
- **FR-016**: The feature MUST not add a new Objective dimension, lifecycle state, acceptance path, readiness requirement, persisted artifact, Objective record field, catalog entry, external service, or dependency.

## Key Entities *(include if data involved)*

- **Objective Archetype**: Internal recommendation-generation guidance for a commonly useful outcome area that may improve coverage without asserting organizational facts.
- **Archetype Family**: One of Growth, Operations, Customer, or Capability, used internally to evaluate recommendation coverage.
- **Profile-Derived Recommendation**: A Working Idea grounded in accepted Profile evidence and preferred when that evidence supports a specific organizational outcome.
- **Archetype-Derived Recommendation**: A Working Idea generated from a meaningful coverage gap and presented without revealing its internal source.
- **Recommendation Set**: The unified set of at most five actionable Objective recommendations presented to the person.
- **Coverage Gap**: A meaningful recommendation area not adequately represented by accepted Profile evidence or the current accepted Objective portfolio.
- **Accepted Objective Portfolio**: The user-owned set of captured Objectives used to identify duplicate, overlap, and meaningful additional-suggestion gaps.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of focused recommendation-generation checks verify that Profile-derived recommendations are considered first and that useful coverage gaps may add archetype-derived recommendations without replacing Profile-grounded outcomes.
- **SC-002**: 100% of focused archetype-boundary checks verify that Growth, Operations, Customer, and Capability guidance is present while no user-facing recommendation exposes an archetype family or source.
- **SC-003**: 100% of recommendation-set checks verify that the unified set preserves the existing maximum of five actionable choices, the user-authored alternative, and the existing recommendation presentation and acceptance behavior.
- **SC-004**: 100% of additional-suggestion checks verify that accepted Profile evidence and the accepted Objective portfolio are evaluated together, useful non-duplicate gaps may be suggested, and recommendation generation stops when no useful grounded option remains.
- **SC-005**: 100% of lifecycle-boundary checks verify that archetypes do not create organizational facts, intent, problems, readiness requirements, lifecycle stages, acceptance paths, persisted artifacts, or Objective ownership changes.
- **SC-006**: 100% of generated Objective adapters preserve the source Objective Archetype guidance and protected recommendation behavior.
- **SC-007**: Existing Objective and full repository verification suites remain passing with no regression to Objective development, acceptance, capture, persistence, readiness, duplicate handling, overlap handling, or non-write behavior.
- **SC-008**: In reviewer assessment, every required archetype-derived recommendation example remains understandable as an Objective outcome without requiring the person to understand internal archetype terminology.

## Assumptions

- The existing Objective skill remains the authoritative owner for recommendation generation, Objective development, acceptance, persistence, and lifecycle behavior.
- Objective Archetypes are guidance in the skill document rather than user-owned records or a new persisted baseline.
- Profile evidence remains the primary organizational context for recommendations; archetypes provide coverage guidance only when a useful gap exists.
- The existing Highway Experience Standard governs recommendation presentation, user contribution, attribution, acceptance, and user-authority behavior.
- Existing duplicate, overlap, recommendation-limit, additional-suggestion, and user-authored-outcome rules remain authoritative.
- Generated adapters are expected to remain equivalent representations of the source Objective skill.
- Static contract checks can validate required guidance and protected boundaries, while human review remains necessary for recommendation quality and usefulness.

## Out of Scope

- Creating or persisting Objective Archetype records, family metadata, portfolio scores, coverage scores, or recommendation-source fields.
- Inferring that an organization has a problem, intent, maturity level, customer need, or operational gap from an archetype alone.
- Replacing accepted Profile evidence, the existing Objective Development Lifecycle, Objective ownership, or the recommendation acceptance boundary.
- Exposing archetype names, families, coverage evaluation, or recommendation sources to users.
- Changing Objective record schemas, identifiers, catalogs, readiness, persistence transactions, setup orchestration, or downstream traceability.
- Adding external research, a new service, a new dependency, or a separate user workflow for selecting archetypes.
