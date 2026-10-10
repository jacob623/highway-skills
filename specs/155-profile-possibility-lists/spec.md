# Feature Specification: Profile Possibility Lists

**Feature Branch**: `155-profile-possibility-lists`

**Created**: 2026-10-10

**Status**: Draft

**Input**: User description: "Create a new spec for allowing concise, grounded possibility lists while a Profile Working Idea is still developing and before convergence, while keeping Converged Proposals singular and leaving advisor scaffolding unchanged."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - React selectively to grounded possibilities (Priority: P1)

As a person developing Profile context, I want to react to individual possibilities in a short list so that I can adopt, reject, combine, modify, or ignore them without restating the whole direction.

**Why this priority**: Selective reaction can expose which parts of a developing Working Idea are useful and reduce the effort required to refine several related directions.

**Independent Test**: Present a pre-convergence Working Idea with a concise grounded possibility list and verify that each item is provisional, traceable to accepted Profile evidence, and available for individual reaction.

**Acceptance Scenarios**:

1. **Given** a Working Idea is still developing and accepted Profile evidence supports several distinct possibilities, **When** Profile invites a reaction, **Then** it may present a short numbered or bulleted list followed by `**What would you add, correct, or remove?**`.
2. **Given** a possibility list is presented, **When** the person accepts some items and rejects or changes others, **Then** Profile preserves the individual reactions and continues development from the selected, rejected, combined, or modified material.
3. **Given** a possibility list is presented, **When** the person ignores an item, **Then** Profile does not treat that item as accepted Profile content.

### User Story 2 - Preserve provisional development and singular convergence (Priority: P1)

As a person accepting Profile context, I want possibility lists to remain provisional until I adopt their substance so that a list cannot become an accidental candidate or recommendation selection.

**Why this priority**: The list is intended to improve Working Idea development without weakening the existing acceptance boundary or changing the shape of retained Profile content.

**Independent Test**: Trace a possibility list through rejection, combination, adoption, and convergence, confirming that only adopted substance can enter a Converged Proposal and that the final proposal remains singular.

**Acceptance Scenarios**:

1. **Given** the workflow is before convergence, **When** Profile emits a possibility list, **Then** every item remains reaction material and no item is presented as accepted fact, a candidate, or a selection choice.
2. **Given** a possibility list has been discussed, **When** Profile presents a Converged Proposal, **Then** the proposal is singular rather than a list of alternatives.
3. **Given** the active Working Idea has converged, **When** Profile continues the domain workflow, **Then** no new possibility list is introduced for that converged subject.

### Edge Cases

- Accepted Profile evidence supports only one useful possibility; Profile may use a single possibility instead of manufacturing a list.
- Accepted Profile evidence supports no grounded possibility; Profile does not create a list merely to satisfy this feature.
- A list would exceed the concise limit; Profile reduces or withholds the list rather than emitting a long recommendation set.
- A person adopts, rejects, combines, modifies, or ignores different items in one response; each reaction remains attributable to the relevant item.
- A person asks to accept the whole list without clarifying its items; the existing acceptance and convergence rules determine whether the response is sufficient.
- Imported or discovered material has not been accepted into Profile evidence; it cannot ground a possibility list as accepted Profile evidence.
- A list would be emitted after convergence; Profile keeps the singular Converged Proposal path instead.

## Requirements *(mandatory)

### Functional Requirements

- **FR-001**: Profile MUST allow a short numbered or bulleted possibility list while a Working Idea is developing and before convergence when accepted Profile evidence supports multiple useful possibilities.
- **FR-002**: Each possibility in a list MUST be grounded in accepted Profile evidence.
- **FR-003**: Each possibility MUST remain provisional Working Idea material until the person adopts it.
- **FR-004**: The person MUST be able to adopt, reject, combine, modify, or ignore individual possibilities without the workflow treating unaddressed items as accepted.
- **FR-005**: Possibility lists MUST remain concise and MUST NOT become recommendation selections or a substitute for a Converged Proposal.
- **FR-006**: Possibility lists MUST appear only before convergence; a Converged Proposal MUST remain a singular candidate representation.
- **FR-007**: A possibility-list interaction MUST close with the existing request for what to add, correct, or remove, unless an applicable existing interaction contract supplies a more specific reaction request.
- **FR-008**: Possibility lists MUST remain governed by the existing Experience Standard without modifying X2.69; Profile MUST treat the whole concise list and its closing reaction invitation as one Contribution Opportunity rather than as multiple contributed additions.
- **FR-009**: This feature MUST NOT modify Profile advisory-question scaffolding, its trigger, its ordering preferences, its anti-paraphrase guidance, or its examples.

## Key Entities *(include if feature involves data)*

- **Working Idea**: Provisional substance still being developed before convergence, including individual possibilities in a list.
- **Possibility**: One grounded, provisional direction offered for the person's reaction.
- **Possibility List**: A concise numbered or bulleted group of grounded possibilities presented before convergence.
- **Converged Proposal**: The singular candidate representation presented after development has converged and before acceptance.
- **Accepted Profile Evidence**: Profile information the person has accepted and that can ground further reasoning.

## Success Criteria *(mandatory)

### Measurable Outcomes

- **SC-001**: 100% of possibility-list examples occur before convergence and 0% occur after a Converged Proposal for the same subject.
- **SC-002**: 100% of listed possibilities in the focused delivery examples have a traceable accepted Profile-evidence anchor.
- **SC-003**: 100% of possibility-list examples mark the items as provisional reaction material, and 0% present them as accepted content, candidates, or recommendation selections.
- **SC-004**: 100% of tested list responses preserve item-level adoption, rejection, combination, modification, and ignore outcomes without silently accepting unaddressed items.
- **SC-005**: 100% of Converged Proposal examples remain singular, regardless of whether development used a possibility list.
- **SC-006**: The existing advisor-scaffolding delivery sites and behavior remain unchanged by this feature.
- **SC-007**: The full verification suite remains passing after the possibility-list delivery sites are implemented.

## Assumptions

- Possibility lists are Profile-owned delivery behavior and do not require a new persisted Profile schema or state field.
- Possibility lists are concise reaction material, not recommendation selections, even when several items are shown.
- The existing Profile acceptance boundary, Working Idea semantics, grounding requirements, and Converged Proposal capture shape remain authoritative.
- A short list contains no more than three items unless planning establishes a smaller repository-specific limit.
- Imported, discovered, or inferred material cannot ground a possibility as accepted Profile evidence until the person accepts it.
- The advisor-scaffolding guidance introduced by Feature 154 is explicitly outside this feature.
- Conversational usefulness requires transcript evaluation beyond static document-contract checks.

## Out of Scope

- Changing Profile advisory-question scaffolding or adding new advisor-scaffolding examples.
- Changing the Experience Standard, including X2.69.
- Changing the singular Converged Proposal shape or acceptance boundary.
- Adding persisted item-level possibility state to the Profile artifact.
- Standardizing possibility lists across other Highway owner workflows.
- Establishing runtime conversational improvement solely through static document checks.
