# Feature Specification: Profile Substantive Re-evaluation and Fuller Identity

**Feature Branch**: `136-profile-substantive-re-evaluation`

**Created**: 2026-10-03

**Status**: Draft

**Input**: User description: Update highway-profile as the proving implementation of substantive-contribution re-evaluation, selective clarification, and fuller Identity reasoning under Experience Standard X2.38-X2.40.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Re-evaluate every Profile contribution (Priority: P1)

As a person developing organizational Profile knowledge, I want each substantive response to change the conversation's active understanding before Profile chooses its next behavior, so that my answer is treated as evidence rather than merely completion of the preceding question.

**Why this priority**: This is the shared inner-loop behavior that makes Profile conform to X2.38-X2.40 and prevents premature routing through the four Profile domains.

**Independent Test**: Provide a substantive response that changes, qualifies, connects, or leaves uncertainty in the active Profile understanding. Verify that Profile re-evaluates the active Working Idea and then interprets, contributes, clarifies, converges, or asks only the next behavior justified by that re-evaluation.

**Acceptance Scenarios**:

1. **Given** a Profile Working Idea is active, **When** the person adds, corrects, removes, qualifies, or redirects substantive organizational information, **Then** Profile incorporates the response as new reasoning material and re-evaluates the active understanding before selecting the next behavior.
2. **Given** a substantive response supports one responsible interpretation from available Profile context, **When** Profile re-evaluates it, **Then** Profile incorporates that interpretation without asking a ceremonial clarification question.
3. **Given** a substantive response creates consequential uncertainty that can change the active result, **When** the person's information is required to resolve it, **Then** Profile asks one focused Conversational Clarification before advancing past that uncertainty.
4. **Given** a response only accepts, rejects, selects, or confirms an already-presented Converged Proposal without adding information, **When** Profile handles the response, **Then** existing acceptance behavior remains intact; when the response also adds substantive information, Profile applies acceptance behavior and re-evaluates the added information.

### User Story 2 - Establish a fuller organizational Identity (Priority: P1)

As a person reviewing Profile's understanding of my organization, I want materially assembled Identity evidence presented as provisional meaningful facets before final synthesis, so that I can identify missing, incorrect, overstated, or incomplete parts of what the organization does.

**Why this priority**: Identity is the foundation for later Vision and Competitive Path reasoning. A narrow or technology-focused Identity can cause every later domain to reason from an incomplete organizational picture.

**Independent Test**: Supply website or multiple evidence sources that establish several meaningful organizational activities. Verify that Profile presents provisional facets when it materially assembled or interpreted the picture, offers one Contribution Opportunity when applicable, incorporates the person's response, selectively clarifies consequential ambiguity, and synthesizes one cohesive Identity for the existing accuracy validation.

**Acceptance Scenarios**:

1. **Given** website or multiple evidence sources establish several meaningful organizational activities, **When** Profile materially assembles or interprets the organizational picture, **Then** Profile presents provisional substantive facets and gives the person an equivalent opportunity to add, correct, remove, qualify, or redirect the picture before Identity convergence unless that opportunity already occurred.
2. **Given** the person directly supplies a domain-complete Identity that Profile does not materially reshape, **When** Profile evaluates the contribution, **Then** Profile may proceed directly to the existing Identity accuracy validation without forcing provisional facets or additional exploration.
3. **Given** the person adds another meaningful organizational activity to provisional Identity facets, **When** Profile re-evaluates the addition, **Then** Profile incorporates its effect on Identity and asks clarification only if materially different interpretations of the activity or its relationship can change the result and require the person's information.
4. **Given** Profile presents provisional Identity facets, **When** the person responds with no addition, correction, removal, qualification, or redirection, **Then** Profile may synthesize the cohesive Identity and retain the existing accuracy validation boundary without treating the Contribution Opportunity as acceptance.
5. **Given** Identity is being developed, **When** Profile evaluates coverage, **Then** Identity reasoning concerns durable organizational activity and purpose and does not become an inventory of platforms, applications, hosting providers, infrastructure, or implementation technologies.

### User Story 3 - Ground Vision and Competitive Path in the full Identity (Priority: P1)

As a person developing future direction and practical direction, I want Profile to reason across the accepted Identity's meaningful activities and their relationships, so that Vision and Competitive Path reflect the organization I actually have rather than the easiest single facet to continue.

**Why this priority**: Fuller Identity only creates value if downstream Profile domains use it. Cross-domain reasoning prevents a newly accepted organizational facet from being ignored when it affects future direction or how the organization plans to progress.

**Independent Test**: Accept an Identity containing multiple meaningful activities, then enter Vision and Competitive Path. Verify that each domain evaluates the full accepted Identity, considers useful relationships among activities, contributes grounded reasoning before fallback questions, and uses focused clarification only when unresolved information is genuinely required.

**Acceptance Scenarios**:

1. **Given** accepted Identity contains multiple meaningful organizational activities or expressions, **When** Vision begins, **Then** Vision evaluates the full Identity and may surface a useful future-oriented relationship, distinction, implication, tension, or recommendation before asking its canonical question.
2. **Given** accepted Identity facets have a consequentially unresolved relationship for future direction, **When** available context cannot responsibly resolve it, **Then** Vision asks one focused question for the person's information rather than an internal category question.
3. **Given** accepted Identity already supports one responsible relationship interpretation, **When** Vision re-evaluates the accepted context, **Then** Vision incorporates that relationship into its Working Idea without a ceremonial clarification question.
4. **Given** accepted Identity and Vision establish multiple ways the organization creates value, reaches people, delivers experiences, develops offerings, or pursues direction, **When** Competitive Path begins, **Then** Competitive Path evaluates how those pieces reinforce, sequence, constrain, or depend on one another when that relationship affects progress.
5. **Given** a Competitive Path relationship is consequentially ambiguous and requires the person's information, **When** Competitive Path evaluates it, **Then** it asks one focused Conversational Clarification; when one responsible interpretation is supported, it incorporates it directly.

### User Story 4 - Preserve Profile boundaries while verifying the new behavior (Priority: P1)

As a maintainer of Highway Profile, I want the new interaction behavior verified without changing Profile's retained schema, ownership boundaries, or neighboring governance artifacts, so that richer conversational reasoning does not create hidden state or move responsibilities between skills.

**Why this priority**: The behavior is shared and user-visible, but the implementation must remain within Profile's existing four-domain model and owner boundaries.

**Independent Test**: Inspect the Profile contract and behavioral checks after the update. Verify the four readiness domains, schema version, transient reasoning boundaries, owner-controlled acceptance, one-question behavior, clarification ownership, and protected artifact scope remain intact while new Profile-specific checks cover substantive re-evaluation and cross-domain reasoning.

**Acceptance Scenarios**:

1. **Given** the Profile update is applied, **When** its retained structure is inspected, **Then** it still contains only `identity`, `vision`, `competitive_path`, and `guiding_principles` with the existing readiness outcomes and schema version 3.0.0.
2. **Given** Profile performs conversational re-evaluation, **When** the interaction concludes, **Then** Working Ideas, facets, clarification reasoning, Contribution Opportunities, and advisory commentary remain transient unless explicitly incorporated into accepted Profile evidence.
3. **Given** Profile needs deterministic clarification records, **When** clarification artifact behavior is invoked, **Then** highway-clarify remains the owning capability; Profile does not create clarification identifiers, state, catalogs, or records.
4. **Given** Profile's user-facing behavior is updated, **When** protected neighboring artifacts are inspected, **Then** Experience Standard, Profile record template, Setup, clarify, and Constitution remain unchanged by this feature.
5. **Given** the Profile contract suite runs, **When** verification completes, **Then** checks cover Identity provisional facets, selective clarification, cross-domain reasoning, acceptance plus new information, Contribution Opportunity boundaries, technology exclusion, and accepted-context re-evaluation.

### Edge Cases

- A direct, complete Identity contribution must not be forced through a provisional-facet exchange merely because the shared model supports one.
- A website-derived or multi-source Identity synthesis must not be presented as accepted before the existing acceptance boundary is satisfied.
- A response that adds a new activity while accepting a Converged Proposal must not silently rewrite the already accepted domain; the existing owner-controlled change path remains required.
- A clarification response does not satisfy Identity's Contribution Opportunity unless the same interaction also gave the person a meaningful opportunity to add, correct, remove, qualify, extend, or redirect the broader substance.
- A clear contribution must not trigger a clarification question merely because Profile re-evaluated it.
- Identity breadth must not be used to collect technology-estate details outside Profile scope.
- New evidence relevant to more than one unresolved domain must be evaluated across all four domains before Profile chooses the next behavior.
- Optional enrichment, contextual commentary, and conversational reasoning must not change readiness or retained schema.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile MUST apply X2.38-X2.40 to each Substantive Contribution before selecting the next user-relevant behavior.
- **FR-002**: Profile MUST treat each Substantive Contribution as new reasoning material for the active Working Idea.
- **FR-003**: Profile MUST evaluate whether a substantive response changes, clarifies, introduces, qualifies, connects, or leaves unresolved information in the active Profile understanding.
- **FR-004**: Profile MUST incorporate one responsible interpretation directly when available context supports it and no user-owned information is required.
- **FR-005**: Profile MUST ask one focused Conversational Clarification when consequential uncertainty can change the active result and the person's information is required to resolve it.
- **FR-006**: Profile MUST NOT ask a ceremonial Conversational Clarification merely to demonstrate that it noticed or re-evaluated a contribution.
- **FR-007**: Profile MUST preserve existing acceptance behavior for an acceptance-only response and MUST also re-evaluate newly supplied substantive information when an acceptance response adds it.
- **FR-008**: Profile MUST process each substantive response, selected recommendation, or validated discovery across all four Profile domains before choosing the next behavior.
- **FR-009**: Profile MUST preserve the existing one-question constraint by keeping a Conversational Clarification separate from another discovery question, a Contribution Opportunity, and a domain acceptance question.
- **FR-010**: Profile MUST distinguish Conversational Clarification from Contribution Opportunity; resolving one ambiguity does not by itself complete the broader opportunity to add or correct developed substance.
- **FR-011**: Profile MUST present provisional meaningful Identity facets when it materially assembles or interprets Identity from website discovery, multiple evidence sources, or substantial synthesis and no equivalent opportunity has already occurred.
- **FR-012**: Profile MUST permit a person to add, correct, remove, qualify, extend, or redirect provisional Identity substance before cohesive Identity synthesis.
- **FR-013**: Profile MUST allow a person-provided domain-complete Identity to proceed directly to existing accuracy validation when Profile does not materially reshape it.
- **FR-014**: Profile MUST synthesize provisional Identity facets into one cohesive Identity representation before existing Identity accuracy validation.
- **FR-015**: Profile MUST keep Identity reasoning focused on durable organizational activity and purpose rather than technology-estate inventory.
- **FR-016**: Profile MUST reason from the full accepted Identity, including distinct meaningful organizational activities or expressions represented in it, when beginning Vision.
- **FR-017**: Vision MUST consider useful relationships among accepted Identity facets when those relationships produce a future-oriented question, distinction, implication, tension, or recommendation.
- **FR-018**: Competitive Path MUST re-evaluate accepted Identity, accepted Vision, relationships among their meaningful activities or expressions, and other accepted Profile context before developing how the organization plans to progress.
- **FR-019**: Guiding Principles MUST treat each Substantive Contribution as new reasoning material and apply X2.38-X2.40 before selecting its next behavior.
- **FR-020**: Profile MUST evaluate new substantive evidence for relevance across unresolved Profile domains before choosing the next behavior.
- **FR-021**: Profile MUST retain only accepted cohesive domain narratives or explicit accepted corrections/replacements; provisional facets, Working Ideas, clarification reasoning, Contribution Opportunities, and advisory commentary MUST remain transient unless explicitly accepted.
- **FR-022**: Profile MUST NOT add readiness domains, Identity facet fields, ambiguity fields, clarification state, reasoning state, or Contribution Opportunity state to the retained Profile schema.
- **FR-023**: Profile MUST preserve schema version 3.0.0 and the readiness domains `identity`, `vision`, `competitive_path`, and `guiding_principles`.
- **FR-024**: Profile MUST leave ownership of deterministic clarification records and mechanics to highway-clarify.
- **FR-025**: Profile MUST preserve Setup ownership, Profile ownership of Identity interaction, and existing owner-controlled acceptance and persistence boundaries.
- **FR-026**: Profile MUST preserve website acquisition as organizational evidence gathering and MUST exclude technology-platform discovery from Profile.
- **FR-027**: Profile MUST retain accepted Profile knowledge before dependent readiness or owner results, without narrating internal persistence or state transitions.
- **FR-028**: Profile verification MUST cover substantive re-evaluation, selective clarification, Identity provisional facets, cross-domain reasoning, acceptance plus new information, Contribution Opportunity boundaries, technology exclusion, and post-acceptance contextual re-evaluation.
- **FR-029**: The Profile skill amendment MUST update its version according to the Skill Versioning Policy while leaving the Profile schema version unchanged.
- **FR-030**: The feature MUST NOT modify the Experience Standard, Profile record template, Setup, clarify, or Constitution artifacts.

### Key Entities *(include if feature involves data)*

- **Substantive Contribution**: A person's response that adds, changes, corrects, removes, qualifies, redirects, or otherwise supplies information that can change active Profile understanding.
- **Working Idea**: Transient Profile reasoning that can be interpreted, clarified, sharpened, connected, corrected, or developed before acceptance.
- **Identity Facet**: A provisional, meaningful aspect of the organization's durable activity or purpose used to help a person inspect the breadth of Profile's understanding; it is not a retained schema field.
- **Conversational Clarification**: A transient focused question used only to resolve consequential uncertainty requiring the person's information.
- **Contribution Opportunity**: A transient opportunity for the person to add, correct, remove, qualify, extend, or redirect materially developed substance before convergence.
- **Converged Proposal**: A complete candidate domain representation presented for the existing acceptance boundary.
- **Accepted Profile Knowledge**: User-owned domain knowledge that has crossed the existing acceptance boundary and can inform later contextual re-evaluation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In contract scenarios covering each of the four Profile domains, 100% of substantive responses are shown to be re-evaluated before the next user-relevant behavior is selected.
- **SC-002**: In all tested clear-contribution scenarios, Profile asks zero ceremonial clarification questions after a responsible interpretation is already supported.
- **SC-003**: In all tested consequential-uncertainty scenarios, Profile asks exactly one focused clarification before advancing past the affected understanding.
- **SC-004**: In all tested materially assembled Identity scenarios, the person receives one provisional-facet Contribution Opportunity before cohesive Identity convergence unless an equivalent opportunity already occurred.
- **SC-005**: In all tested accepted-Identity scenarios containing multiple meaningful activities, Vision and Competitive Path evaluate the full Identity and relevant relationships before their fallback canonical questions.
- **SC-006**: 100% of retained Profile fixtures after the update use the existing four readiness domains and schema version 3.0.0, with no new reasoning, facet, ambiguity, or clarification state.
- **SC-007**: 100% of clarification and provisional-facet reasoning fixtures leave no transient reasoning or clarification mechanics in retained Profile output unless explicitly accepted as domain evidence.
- **SC-008**: The Profile contract and repository validation suite complete with zero failures, and no protected neighboring artifact changes are required for the feature.
- **SC-009**: Reviewers can trace each new Profile behavior to X2.38, X2.39, or X2.40 without finding a changed rule ID, Observable, or shared governance artifact.

## Assumptions

- The current Experience Standard X2.38-X2.40 definitions and obligations remain authoritative and are not amended by this feature.
- The current Profile record template and schema version 3.0.0 remain authoritative and unchanged.
- Existing Profile ownership of Identity, domain acceptance, persistence, readiness, and user-visible interaction remains in force.
- Existing highway-clarify ownership of deterministic clarification artifacts remains in force.
- Website acquisition, when available, supplies proposed organizational evidence; derived evidence remains proposed until accepted.
- A person can distinguish whether a proposed Identity facet is missing, incorrect, overstated, incomplete, or acceptable.
- Existing Profile contract fixtures and repository checks can be extended without introducing a new persistence mechanism.
- Feature implementation is limited to the Profile skill and directly affected Profile verification expectations; Setup, clarify, shared templates, Experience Standard, Constitution, and Profile schema remain out of scope.
