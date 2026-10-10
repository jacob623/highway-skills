# Feature Specification: Structure-Revealing Advisory Contributions

**Feature Branch**: `156-structure-revealing-advisory-contributions`

**Created**: 2026-10-10

**Status**: Draft

**Input**: User description: "Improve the quality of Profile advisory contributions without changing the Experience Standard by preferring structure-revealing contributions, then one grounded implication or extension, instead of summaries or unsupported strategic leaps."

## Clarifications

### Session 2026-10-10

- Q: Should “one-step extension” allow only one follow-on implication or possibility after revealing structure, or may it include a short chain such as structure → implication → possibility? → A: A single advisory move may use one connected linear chain of structure → implication → possibility or tradeoff; each step must derive directly from the immediately preceding step. Branching alternatives and multiple independent additions remain prohibited.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See structure in accepted material (Priority: P1)

As a person developing Profile context, I want advisory contributions to reveal relationships, roles, patterns, tensions, dependencies, hierarchies, organizing principles, or decision criteria already implied by accepted evidence so that I can understand my own material more clearly.

**Why this priority**: Revealing structure is the core value of the feature. It improves understanding without inventing a new contribution category or moving prematurely to a strategic recommendation.

**Independent Test**: Provide accepted Profile evidence containing multiple related facts and verify that the contribution identifies the relationship or organizing structure between them rather than merely restating, reorganizing, relabeling, or replacing their words with synonyms.

**Acceptance Scenarios**:

1. **Given** accepted evidence contains several related facts and a useful latent relationship, **When** Profile contributes advisory reasoning, **Then** the contribution identifies the supported relationship, role, pattern, tension, dependency, hierarchy, organizing principle, or decision criterion.
2. **Given** accepted evidence does not support a useful structure, **When** Profile contributes advisory reasoning, **Then** it does not manufacture a structure merely to satisfy this feature.
3. **Given** a contribution reveals structure, **When** Profile asks for reaction, **Then** the contribution remains provisional and attributable to Highway until the person adopts it.

### User Story 2 - Extend the revealed structure through one connected chain (Priority: P1)

As a person developing Profile context, I want any implication, possibility, or tradeoff to follow directly from the preceding reasoning in one connected chain so that advisory reasoning remains useful without becoming a strategic leap.

**Why this priority**: A grounded connected chain adds practical value while preserving the person's authority over the developing Working Idea.

**Independent Test**: Provide accepted evidence with a supported structure and verify that each optional implication, possibility, or tradeoff derives from the immediately preceding step, remains close to the accepted material, and stays provisional.

**Acceptance Scenarios**:

1. **Given** Profile has revealed a grounded structure, **When** further reasoning would materially improve understanding, **Then** Profile may provide one connected chain of direct implications, possibilities, opportunities, risks, questions, or tradeoffs.
2. **Given** a useful structure is available, **When** Profile chooses advisory reasoning, **Then** it does not skip directly to a distant strategic extension and any chain remains connected step by step.
3. **Given** a connected chain is offered, **When** the person reacts, **Then** every chain step remains outside the candidate unless the person adopts it.

### User Story 3 - Preserve existing contribution and interaction contracts (Priority: P1)

As a person using Profile, I want structure-revealing guidance to fit existing contribution behavior so that the workflow remains familiar and does not change its governing interaction contracts.

**Why this priority**: The feature is a quality improvement to existing contributions, not a new interaction model or contribution taxonomy.

**Independent Test**: Compare the existing Profile advisory scaffolding, ordering preference, anti-paraphrase guidance, examples, and bakery counter-example before and after the feature; verify that they remain unchanged while the new selection guidance is present separately.

**Acceptance Scenarios**:

1. **Given** Profile is selecting among existing contribution types, **When** useful grounded reasoning exists, **Then** it prefers structure revelation before an implication or one-step extension without introducing a new contribution category.
2. **Given** existing advisory scaffolding or named examples are present, **When** the feature is applied, **Then** those materials remain unchanged.
3. **Given** a contribution would be equally applicable to unrelated organization types because it is detached from accepted evidence, **When** Profile evaluates it, **Then** it rejects the strategic leap as insufficiently grounded.

### Edge Cases

- Accepted evidence contains only one fact and no supported relationship; Profile does not force a structure-revealing contribution.
- Several facts are related but the relationship is already explicit in the person's own words; restating it does not count as revealing structure.
- More than one structure is available; Profile selects the most useful grounded structure without emitting an unbounded collection of contributions.
- A revealed structure supports no useful implication or extension; Profile stops at the structure and asks for reaction.
- An implication supports multiple distant possibilities; Profile does not emit a strategic option set or leap beyond one grounded step.
- The person corrects or rejects the revealed structure; later reasoning follows the correction and does not reintroduce the rejected framing.
- The contribution uses a term or claim introduced by Highway; it remains attributed and provisional under the existing contracts.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile MUST improve the selection and execution of existing advisory contribution types without introducing a new contribution category.
- **FR-002**: When useful grounded reasoning exists, Profile MUST prefer revealing structure implied by accepted evidence before offering an implication or one-step extension.
- **FR-003**: A structure-revealing contribution MUST identify at least one supported relationship, pattern, role, hierarchy, decision criterion, tension, dependency, or organizing principle that is not already explicit in the person's own words.
- **FR-004**: A structure-revealing contribution MUST NOT be satisfied by restatement, reorganization, relabeling, paraphrase, or synonym replacement alone.
- **FR-005**: After revealing structure, Profile MAY provide one connected linear chain of grounded reasoning, such as structure → implication → possibility or structure → implication → tradeoff, when it would materially improve understanding.
- **FR-006**: Each step in a connected chain MUST derive directly from the immediately preceding step, remain traceable to accepted evidence, be attributable to Highway, and remain provisional until the person adopts it.
- **FR-007**: Profile MUST NOT skip a useful supported structure to make a distant strategic leap, and MUST reject extensions that remain equally applicable when detached from the accepted evidence.
- **FR-008**: The feature MUST preserve the existing Experience Standard and MUST NOT create new contribution categories or modify its grounding, attribution, or Working Idea requirements.
- **FR-009**: The feature MUST leave advisory-question scaffolding, the distinction-to-recommendation preference ordering, anti-paraphrase guidance, the tradeoff exemplar, contribution exemplars, and the anti-consultant bakery counter-example unchanged.
- **FR-010**: Structure-revealing contributions and any one-step extensions MUST remain outside the candidate until the person adopts them and MUST close with the existing reaction invitation when that invitation applies.

## Key Entities *(include if feature involves data)*

- **Accepted Profile Evidence**: Profile material the person has accepted and that can ground further reasoning.
- **Structure-Revealing Contribution**: An existing contribution type executed by making a supported relationship, role, pattern, hierarchy, criterion, tension, dependency, or organizing principle explicit without merely summarizing it.
- **Connected Advisory Chain**: One linear advisory move that reveals structure and may continue through directly derived implications, possibilities, or tradeoffs, with each step depending on the immediately preceding step.
- **Working Idea**: Provisional substance that remains open for the person's reaction before acceptance.
- **Converged Proposal**: The complete candidate presented only after the existing convergence and acceptance conditions are met.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of focused structure-revealing examples, the contribution identifies a supported relationship, role, pattern, hierarchy, decision criterion, tension, dependency, or organizing principle that was not already explicit in the person's own words.
- **SC-002**: In 100% of focused negative examples, restatement, reorganization, relabeling, paraphrase, and synonym replacement alone are rejected as insufficient contributions.
- **SC-003**: In 100% of examples where a useful structure is available, any advisory chain proceeds linearly from structure through only directly derived implications, possibilities, or tradeoffs, with no branching.
- **SC-004**: In 100% of focused examples, every chain step is traceable to accepted evidence and the immediately preceding step, attributable to Highway, and provisional until adopted.
- **SC-005**: 0% of focused examples introduce a new contribution category, alter the Experience Standard, or change the named existing advisory materials.
- **SC-006**: 100% of focused strategic-leap probes that remain equally applicable when detached from accepted evidence are rejected.
- **SC-007**: The full verification suite remains passing after the Profile guidance is implemented.

## Assumptions

- The Profile workflow already supports the contribution types named in this feature; the feature changes selection and execution guidance rather than adding types.
- Accepted Profile evidence is the only grounding source for structure-revealing contributions and their extensions.
- The existing Experience Standard remains authoritative and is not amended by this feature.
- A connected advisory chain may contain structure followed by a directly derived implication and then a directly derived possibility or tradeoff; it is one move, not a list of downstream recommendations.
- Diverging alternatives, recommendation sets, opportunity catalogs, multiple independent implications, and multiple independent possibilities are prohibited.
- Highway-originated structure and extensions remain Working Ideas until the person adopts them.
- The existing reaction invitation remains the applicable closing interaction where a Contribution Opportunity is required.
- Static document checks can verify delivery contracts but cannot alone establish runtime conversational quality.

## Out of Scope

- Changing the Experience Standard.
- Adding new contribution categories or a new advisory interaction model.
- Changing advisory-question scaffolding.
- Changing the distinction-to-implication-to-connection preference ordering.
- Changing anti-paraphrase guidance, the tradeoff exemplar, contribution exemplars, or the bakery counter-example.
- Changing Profile persistence, schema, convergence, or acceptance boundaries.
- Applying this guidance to workflows outside Profile.
