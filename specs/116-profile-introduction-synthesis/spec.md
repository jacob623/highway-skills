# Feature Specification: Profile Introduction and Synthesis

**Feature Branch**: `116-profile-introduction-synthesis`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: Add a one-time first-time Profile introduction, replace multi-fragment enrichment with cohesive grounded paragraph recommendations for Vision, Competitive Path, and Guiding Principles, preserve Identity discovery and recommendation-first sequencing, and increment Profile from 5.0.0 to 5.1.0 without changing the retained schema.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Explain Profile Collection Once (Priority: P1)

As a person beginning first-time Profile setup, I want a brief explanation of what Highway is about to learn and why, so that I understand how the Profile will improve later recommendations before answering the Repository Name question.

**Why this priority**: The introduction establishes the purpose of Profile collection at the first user-owned interaction without duplicating Setup's welcome.

**Independent Test**: Begin first-time Profile setup and confirm the introduction appears once, uses the required heading and sentence, precedes the existing Repository Name question, and does not appear during configure, resume, or later turns in the same interaction.

**Acceptance Scenarios**:

1. **Given** no retained Profile exists and first-time setup begins, **When** Profile starts its interaction, **Then** it emits `### Let's get to know your organization` followed by `This helps Highway make more relevant recommendations as we go.` before the existing Repository Name question.
2. **Given** the first-time Profile introduction has been emitted, **When** the Repository Name question is presented, **Then** the existing question and supporting sentence remain unchanged.
3. **Given** Profile setup continues after the introduction, **When** later Profile turns occur, **Then** the introduction is not repeated.
4. **Given** a retained Profile is being configured or resumed, **When** Profile begins, **Then** the first-time introduction is not emitted.
5. **Given** Setup has already presented its Highway welcome, **When** Setup delegates to Profile, **Then** Profile adds only its own organizational-context introduction and does not add another Setup-purpose introduction.

### User Story 2 - Review Cohesive Domain Recommendations (Priority: P1)

As a person enriching an organizational Profile, I want one concise grounded paragraph for each supported domain instead of several short fragments, so that I can review and accept a coherent organizational statement.

**Why this priority**: A cohesive recommendation reduces review effort while preserving evidence grounding and user control.

**Independent Test**: Provide accepted evidence sufficient for each domain in turn and confirm Profile presents one paragraph using only supported evidence, keeps internal categories hidden, and accepts, changes, or replaces the paragraph as one recommendation.

**Acceptance Scenarios**:

1. **Given** accepted evidence supports a cohesive Vision interpretation, **When** Profile recommends Vision, **Then** it presents one concise paragraph using the internal Vision categories without exposing their names.
2. **Given** accepted evidence supports a cohesive Competitive Path interpretation, **When** Profile recommends Competitive Path, **Then** it presents one concise paragraph grounded especially in accepted Identity and Vision without exposing internal category names.
3. **Given** accepted evidence supports a cohesive Guiding Principles interpretation, **When** Profile recommends Guiding Principles, **Then** it presents one concise paragraph describing decision-relevant principles without exposing internal category names.
4. **Given** a paragraph recommendation is presented, **When** the person accepts, changes, or replaces it, **Then** the resulting accepted narrative becomes the domain evidence without a second confirmation.
5. **Given** the person asks for clarification or explanation of a paragraph, **When** Profile responds, **Then** the request does not count as acceptance.
6. **Given** evidence does not support a useful cohesive paragraph, **When** a domain remains unresolved, **Then** Profile falls back to that domain's canonical question.
7. **Given** a paragraph recommendation is accepted, **When** Profile continues, **Then** it does not ask that domain's canonical question.

### User Story 3 - Compound Accepted Evidence Safely (Priority: P1)

As a person developing a Profile, I want every accepted answer, correction, discovery, and paragraph recommendation to improve later recommendations without inventing facts, so that Profile becomes more relevant while remaining trustworthy.

**Why this priority**: The feature must preserve recommendation-first behavior and persistence guarantees while changing recommendation shape.

**Independent Test**: Accept evidence across multiple turns and domains, then confirm Profile processes all four domains, persists accepted changes before dependent results, attempts a grounded paragraph, and asks a canonical question only when synthesis cannot resolve the domain.

**Acceptance Scenarios**:

1. **Given** accepted evidence, a correction, a validated discovery, or an accepted paragraph recommendation changes Profile state, **When** Profile processes it, **Then** it processes the evidence across all four domains, persists the accepted change, re-evaluates unresolved domains, and attempts a grounded paragraph before a canonical question.
2. **Given** accepted evidence supports a paragraph, **When** Profile synthesizes it, **Then** every statement is supported by accepted evidence and no unsupported organizational fact is added for completeness.
3. **Given** Identity evidence is discovered from a website or existing information, **When** it is not accepted, **Then** it remains proposed and cannot ground retained recommendations.
4. **Given** Identity evidence is accepted, **When** Profile continues, **Then** it is immediately available as grounding for Vision and later recommendations.
5. **Given** accepted evidence establishes a domain, **When** the change is saved, **Then** that domain is `discussed` and its canonical question is not asked.
6. **Given** an otherwise unresolved domain is explicitly bounded, **When** the boundary is saved, **Then** that domain is `bounded` and its canonical question is not asked.
7. **Given** optional enrichment is declined or omitted, **When** Profile continues, **Then** readiness is unchanged and no additional question is required solely for that enrichment.

### User Story 4 - Preserve the Retained Profile Contract (Priority: P2)

As a governance maintainer, I want the cohesive recommendation change recorded as Profile 5.1.0 without changing the retained Profile shape or shared interaction boundary, so that the update remains compatible with existing records and orchestration.

**Why this priority**: The new interaction is adoptable only if the retained schema, domain states, completion behavior, and ownership boundaries remain stable.

**Independent Test**: Review the Profile skill, retained template, verification, and distributed copies. Confirm version 5.1.0, schema 3.0.0, four readiness domains, preserved completion synthesis, unchanged Experience Standard boundary, and no edits to out-of-scope governance artifacts.

**Acceptance Scenarios**:

1. **Given** the Profile skill is updated, **When** its version is read, **Then** it is 5.1.0 as a semantic version without the skill name.
2. **Given** the retained Profile template is inspected, **When** this feature is complete, **Then** schema 3.0.0 and exactly four readiness-domain keys remain unchanged.
3. **Given** guided Profile completion is reached, **When** Profile returns control to Setup, **Then** the existing concise completion synthesis remains and is not replaced by the first-time introduction.
4. **Given** Profile interaction is reviewed, **When** generic recommendation acceptance, alternatives, and presentation behavior are evaluated, **Then** those rules remain owned by the Highway Experience Standard and are not duplicated in Profile.
5. **Given** distributed Profile copies are inspected, **When** the update is complete, **Then** they match the authoritative Profile skill.

### Edge Cases

- First-time Profile setup begins without a retained Profile, but Setup has already provided its own welcome; Profile still emits only its organizational-context introduction.
- Profile setup is interrupted after the introduction but before Repository Name is accepted; resuming an existing interaction does not repeat the introduction.
- A retained Profile is absent versus present but incomplete; only the absent first-time case receives the introduction.
- Website or existing-information discovery provides partial Identity evidence; unsupported fields remain proposed or omitted rather than being invented.
- Accepted evidence supports several internal categories but not a coherent paragraph; Profile asks the canonical question instead of assembling unsupported prose.
- A paragraph is too broad or inaccurate and the person corrects it; the correction replaces the recommendation as accepted evidence and is persisted before dependent results.
- A clarification request about a paragraph is not acceptance and does not establish the domain.
- A paragraph recommendation is accepted for a domain already `discussed` or `bounded`; it enriches the narrative without changing readiness.
- Internal evidence-category names never appear in user-facing recommendations or retained Profile narratives.
- Optional enrichment does not alter readiness, block completion, or require another question.
- Guided completion emits the existing completion synthesis once; it does not emit the first-time introduction.
- Unsupported or malformed retained Profiles remain Blocked without mutation; obsolete non-Markdown artifacts remain ignored.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Profile skill version MUST be 5.1.0 as a semantic version only and MUST NOT include the skill name.
- **FR-002**: First-time Profile setup with no retained Profile MUST emit `### Let's get to know your organization` followed by `This helps Highway make more relevant recommendations as we go.` before the existing Repository Name question.
- **FR-003**: The first-time introduction MUST be emitted once per first-time Profile setup interaction, MUST NOT repeat later in that interaction, and MUST NOT appear for configure or resume of an existing retained Profile.
- **FR-004**: The Profile introduction MUST remain Profile-owned, MUST explain organizational Profile collection, and MUST NOT replace or duplicate the Setup-owned Highway welcome.
- **FR-005**: The existing Repository Name question and supporting sentence MUST remain unchanged and follow the introduction during first-time setup.
- **FR-006**: Vision recommendations MUST prefer one concise cohesive paragraph when accepted evidence supports a useful synthesis, grounded in Future State, Impact, Reach / Scale, Position, and Experience / Reputation.
- **FR-007**: Competitive Path recommendations MUST prefer one concise cohesive paragraph when accepted evidence supports a useful synthesis, grounded in Customer / Participant, Offering, Market / Reach, Differentiation, Operations, and Capability Development, especially accepted Identity and Vision.
- **FR-008**: Guiding Principles recommendations MUST prefer one concise cohesive paragraph when accepted evidence supports a useful synthesis, grounded in People, Trust, Quality, Simplicity, Change, Stewardship, and Autonomy, with a preference for decision-relevant principles.
- **FR-009**: The internal grounding category names MUST NOT be exposed to the user or persisted in the retained Profile.
- **FR-010**: Each paragraph MUST contain only claims supported by accepted evidence and MUST NOT add unsupported organizational facts to make the statement more complete.
- **FR-011**: Vision paragraph recommendations MUST use wording semantically equivalent to `Based on what I know about [Organization Name], I could see your vision as [grounded Vision paragraph].` followed by a single accept/change/replace decision prompt.
- **FR-012**: Competitive Path paragraph recommendations MUST use wording semantically equivalent to `Based on that direction, [Organization Name] could pursue it by [grounded Competitive Path paragraph].` followed by a single accept/change/replace decision prompt.
- **FR-013**: Guiding Principles paragraph recommendations MUST use wording semantically equivalent to `From what you've shared, [Organization Name] seems guided by [grounded Guiding Principles paragraph].` followed by a single accept/change/replace decision prompt.
- **FR-014**: Acceptance of a paragraph MUST establish its domain as `discussed`; an accepted correction or replacement MUST become the accepted domain evidence; a clarification or explanation request MUST NOT count as acceptance.
- **FR-015**: An accepted paragraph MUST NOT be followed by that domain's canonical question.
- **FR-016**: When evidence does not support a useful cohesive paragraph, Profile MUST ask the applicable canonical question as fallback.
- **FR-017**: Identity MUST continue to support website or existing-information discovery as proposed evidence, retain discovered Identity as proposed until accepted, and make accepted Identity immediately available as grounding for Vision and later recommendations.
- **FR-018**: After every accepted recommendation, answer, correction, or validated discovery, Profile MUST process evidence across all four domains, persist accepted Profile changes, re-evaluate unresolved domains, attempt grounded paragraph recommendations, and ask a canonical question only when no useful synthesis can resolve the domain.
- **FR-019**: Profile MUST NOT revert to a fixed Identity, Vision, Competitive Path, Guiding Principles question sequence.
- **FR-020**: Profile MUST preserve Experience Standard ownership of paragraph recommendation acceptance, user alternatives, clarification handling, and generic presentation behavior without duplicating those generic rules.
- **FR-021**: Accepted evidence that establishes a domain MUST set it to `discussed`; an explicit user boundary MUST set an otherwise unresolved domain to `bounded`; `discussed` MUST NOT imply that every enrichment category was explored.
- **FR-022**: Optional enrichment MUST NOT change readiness, block continuation, or require another question.
- **FR-023**: Every accepted Profile change, including discovered information, paragraph recommendations, corrections, replacements, and direct user evidence, MUST be persisted before dependent readiness or owner results are returned.
- **FR-024**: Profile MUST NOT reintroduce post-write Persistence Verification.
- **FR-025**: Guided Profile completion MUST retain the existing concise completion synthesis before returning control to Setup and MUST NOT replace it with the first-time Profile introduction.
- **FR-026**: The retained Profile template MUST remain schema 3.0.0 with exactly four readiness-domain keys; profile-record.md MUST NOT be changed for this feature.
- **FR-027**: Profile readiness MUST preserve `not_discussed`, `discussed`, and `bounded` domain states and the existing Missing, Blocked, and Complete meanings.
- **FR-028**: The Profile skill's Experience section MUST state exactly `User-visible interaction follows the Highway Experience Standard.`
- **FR-029**: Distributed Profile skill copies MUST remain synchronized with the authoritative Profile skill.
- **FR-030**: Verification MUST cover one-time introduction ordering and suppression, cohesive paragraph recommendations for all three enrichment domains, evidence-only grounding, hidden categories, acceptance/state transitions, canonical fallback, persistence timing, retained completion synthesis, unchanged schema, and synchronized copies.
- **FR-031**: This feature MUST NOT amend the Experience Standard, constitution, Setup, Objectives, Controls, Non-Functional Requirements, output templates, Highway Profile Intent Summary, or Brownfield Onboarding Idea.

### Key Entities

- **Profile introduction**: The one-time first-time setup message explaining that Profile collection helps Highway make more relevant recommendations.
- **Accepted Profile evidence**: User-supplied, user-accepted, or accepted corrected organizational evidence that may ground recommendations and establish domain readiness.
- **Cohesive paragraph recommendation**: One concise grounded narrative for Vision, Competitive Path, or Guiding Principles, generated from accepted evidence and presented as one reviewable recommendation.
- **Readiness domain**: Identity, Vision, Competitive Path, or Guiding Principles with state `not_discussed`, `discussed`, or `bounded`.
- **Retained Profile**: The accepted organizational evidence persisted in the existing Markdown Profile structure and schema 3.0.0.
- **Completion synthesis**: The existing user-relevant closing statement emitted when guided Profile collection is complete before control returns to Setup.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of first-time Profile setups with no retained Profile, the required introduction appears before the Repository Name question and appears no more than once in the interaction.
- **SC-002**: In 100% of configure and resume interactions with an existing retained Profile, the first-time introduction is absent.
- **SC-003**: In 100% of reviewed cases where accepted evidence supports a cohesive Vision, Competitive Path, or Guiding Principles interpretation, Profile presents one paragraph recommendation rather than multiple short fragments.
- **SC-004**: Zero reviewed user-facing recommendations or retained Profile narratives contain internal grounding-category names.
- **SC-005**: Zero reviewed paragraph recommendations contain claims not supported by accepted evidence.
- **SC-006**: In 100% of accepted paragraph recommendations and accepted corrections, the corresponding domain is `discussed` and its canonical question is not asked afterward.
- **SC-007**: In 100% of reviewed cases without a useful cohesive synthesis, Profile asks the applicable canonical question as fallback.
- **SC-008**: In 100% of accepted Profile mutations, persistence occurs before a dependent readiness or owner result; no post-write Persistence Verification is restored.
- **SC-009**: Guided completion emits exactly one existing completion synthesis and does not substitute the first-time introduction for it.
- **SC-010**: The Profile skill version is 5.1.0, the retained template remains schema 3.0.0 with four readiness keys, and all distributed Profile copies are synchronized.
- **SC-011**: The Profile Experience section contains exactly the shared Highway Experience Standard sentence, with no duplicated generic recommendation or acceptance rules.
- **SC-012**: Existing Identity discovery, readiness states, recommendation-first sequencing, and Setup ownership behavior continue to pass their current contract checks.

## Assumptions

- The existing Markdown Profile narrative structure can store cohesive paragraphs without changing profile-record.md or schema 3.0.0.
- A first-time setup interaction is identifiable by the absence of a retained Profile; configure and resume refer to an existing retained Profile, including an incomplete one.
- The existing Experience Standard governs whether accepting, changing, replacing, or asking for clarification is a response-demanding interaction; this feature defines only the Profile-specific paragraph grounding and semantic content.
- The semantic model wording is illustrative; implementation may use equivalent wording while preserving one cohesive paragraph, supported evidence, and a single review boundary.
- Internal category names remain authoring and grounding concepts only and are never retained or displayed.
- The existing completion synthesis, persistence boundary, four readiness domains, domain states, and canonical questions remain authoritative unless a directly conflicting requirement is discovered during implementation.
- No extension hooks are registered for this specification workflow.
