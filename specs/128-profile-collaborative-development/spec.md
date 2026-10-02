# Feature Specification: Profile Collaborative Development

**Feature Branch**: `128-profile-collaborative-development`

**Created**: 2026-10-02

**Status**: Draft

**Input**: User description: "Update only `highway-profile` so Profile becomes the first concrete implementation of the collaborative model established by the Constitution, Highway Identity, and Experience Standard. Distinguish Working Ideas from Converged Proposals, allow ideas to evolve before artifact acceptance, re-evaluate accepted knowledge with accumulated context, and preserve the Profile schema and four retained domains."

## User Scenarios & Testing

### User Story 1 - Develop Profile domains collaboratively (Priority: P1)

As a person building an organizational Profile, I want incomplete contributions and recommendations to remain Working Ideas until they are coherent enough to represent a domain, so that Profile captures durable knowledge rather than prematurely persisting conversational suggestions.

**Why this priority**: This is the core behavioral change. Without a clear Working Idea and Converged Proposal boundary, Profile will continue treating every recommendation as an immediately accepted artifact.

**Independent Test**: Exercise Identity, Vision, Competitive Path, and Guiding Principles with both partial and mature inputs. Confirm partial inputs can be interpreted, sharpened, corrected, or extended without changing readiness, while a complete domain candidate can be presented for validation and persisted after acceptance.

**Acceptance Scenarios**:

1. **Given** a Profile domain has an incomplete, vague, conflicting, or developing contribution, **When** Profile responds, **Then** it may interpret, sharpen, contribute a grounded perspective, or ask one bounded question while keeping the contribution transient as a Working Idea.
2. **Given** a Profile domain has a mature contribution or sufficiently grounded synthesis, **When** further discussion would not materially improve it, **Then** Profile may present it directly as a Converged Proposal without forcing exploratory turns.
3. **Given** a domain is represented by a complete Converged Proposal, **When** the person accepts it, **Then** Profile persists the accepted domain narrative and only then produces any dependent owner result.
4. **Given** a person agrees casually with a Working Idea, **When** the content has not been presented as the complete domain candidate, **Then** Profile continues collaboration without changing the domain to `discussed`.

### User Story 2 - Carry accepted understanding across Profile subjects (Priority: P1)

As a person moving through Profile subjects, I want accepted knowledge to be reconsidered with the accumulated Profile so that each later subject reflects useful implications and relationships rather than merely repeating the prior answer.

**Why this priority**: Profile's value depends on compounding organizational context across Identity, Vision, Competitive Path, and Guiding Principles.

**Independent Test**: Accept Identity, then Vision, then Competitive Path, and inspect each transition. Confirm the next subject uses accumulated accepted context, does not require a prescribed acknowledgment formula, and transitions naturally when re-evaluation reveals nothing useful.

**Acceptance Scenarios**:

1. **Given** accepted Profile knowledge changes the active understanding, **When** Profile decides what to contribute next, **Then** it re-evaluates the new knowledge with relevant accumulated accepted Profile context and carries forward a useful distinction, implication, relationship, tension, opportunity, concern, or recommendation when one exists.
2. **Given** accepted Vision is available, **When** Competitive Path begins, **Then** Profile considers what the accepted Vision implies about how the organization could pursue its direction instead of merely summarizing Vision.
3. **Given** accepted Identity, Vision, and Competitive Path are available, **When** Guiding Principles begins, **Then** Profile derives and sharpens principles from the accumulated organizational direction rather than generating a generic virtue list.
4. **Given** contextual re-evaluation reveals nothing useful to add, **When** the current subject is complete, **Then** Profile transitions naturally without manufacturing commentary or an acknowledgment stage.

### User Story 3 - Preserve Profile ownership and data semantics (Priority: P1)

As a maintainer of Profile records, I want the collaborative interaction to remain a transient conversational behavior so that the existing Profile artifact, readiness model, website boundary, and persistence contract remain stable.

**Why this priority**: The feature must improve interaction without creating schema migration, new readiness states, or scope expansion into technology discovery or other Highway domains.

**Independent Test**: Compare the implementation change against the Profile template and contract. Confirm only `highway-profile` changes, schema `3.0.0` and the four domains remain, readiness remains `not_discussed`/`discussed`/`bounded`, and only accepted organizational narrative is retained.

**Acceptance Scenarios**:

1. **Given** a Working Idea contains interpretations, tensions, alternatives, or implications, **When** the active Profile task continues, **Then** those threads may remain in transient Active Reasoning Context but are not persisted as fields, files, logs, or readiness states.
2. **Given** a domain is accepted, **When** Profile mutates the retained record, **Then** the ordering remains Converged Proposal, user acceptance, Profile mutation, persisted accepted knowledge, and dependent owner result.
3. **Given** website evidence is available, **When** Profile uses it, **Then** it remains within organizational Profile evidence and does not become technology-platform discovery or a technology inventory.
4. **Given** Profile reaches final Guiding Principles acceptance, **When** completion is synthesized, **Then** Profile emits the existing concise user-relevant synthesis without a new Profile question or machine status fields.

### Edge Cases

- A discovered or user-supplied Identity is incomplete, conflicting, or vague; Profile keeps it transient and allows interpretation, correction, refinement, or one bounded question before validation.
- A mature domain is already complete; Profile does not prolong collaboration solely to demonstrate the model.
- A person says "I like that" or equivalent while a Working Idea is still developing; Profile does not treat that agreement as domain acceptance.
- A user-authored correction or replacement supersedes a Highway Working Idea; the user's contribution remains authoritative and can become the basis for convergence.
- A Vision discussion reveals a Guiding Principles implication before Guiding Principles is active; Profile carries it in transient reasoning context without interrupting the active subject.
- No grounded recommendation can seed useful collaboration; the existing canonical domain question remains available as a fallback.
- Optional enrichment is accepted for an already `discussed` or `bounded` domain; readiness does not change.
- The retained Profile is absent, malformed, unsupported, or schema `2.0.0`; existing readiness and non-mutation behavior remains unchanged.

## Requirements

### Functional Requirements

- **FR-001**: Profile MUST use the shared collaborative-development model from the Highway Experience Standard and Constitution without reproducing the full shared interaction guidance.
- **FR-002**: Profile MUST distinguish a transient Working Idea from a complete Converged Proposal for each of Identity, Vision, Competitive Path, and Guiding Principles.
- **FR-003**: Profile MUST NOT seek domain acceptance until the current understanding is complete enough to represent the domain as a Converged Proposal.
- **FR-004**: Profile MUST allow a mature contribution or sufficiently grounded synthesis to converge immediately when further discussion would not materially improve the result.
- **FR-005**: Profile MUST support the lifecycle of introducing a subject, seeding or presenting an idea, developing it when useful, converging, validating, persisting accepted knowledge, re-evaluating, and continuing.
- **FR-006**: Profile MUST preserve the user-visible subject introductions `### Where you're going`, `### How you'll get there`, and `### What will guide your decisions`, while keeping those introductions separate from artifact acceptance.
- **FR-007**: Profile MUST re-evaluate accepted Profile knowledge together with accumulated accepted Profile context before deciding what useful contribution or next subject to present.
- **FR-008**: Profile MUST interpret or sharpen newly accepted knowledge when contextual re-evaluation reveals a useful distinction, implication, relationship, tension, opportunity, concern, or recommendation.
- **FR-009**: Profile MUST transition naturally without manufacturing commentary when contextual re-evaluation reveals nothing useful to add.
- **FR-010**: Vision MUST use accepted Identity, accepted website-derived organizational evidence, existing accepted Vision evidence, and other accepted Profile context as grounding.
- **FR-011**: Vision MUST permit a grounded Working Idea to develop before presenting one cohesive Converged Proposal and MUST retain the existing Vision validation wording.
- **FR-012**: Competitive Path MUST begin from accepted Vision or sufficient accepted evidence, re-evaluate accumulated context, consider what Vision implies about pursuit, and retain the existing Competitive Path validation wording.
- **FR-013**: Guiding Principles MUST use accepted Identity, Vision, Competitive Path, and other accepted Profile context, derive principles from the organization's accepted direction, and retain the existing Guiding Principles validation wording.
- **FR-014**: Identity MUST be allowed to converge immediately when evidence is complete and MUST support collaborative interpretation, correction, refinement, and bounded questioning when evidence is incomplete, conflicting, or vague.
- **FR-015**: Profile MUST preserve existing internal enrichment categories as reasoning aids only; they MUST NOT become conversational fields, mandatory questions, or a required conversational order.
- **FR-016**: A Profile domain MUST be considered ready for a Converged Proposal when accumulated evidence supports one coherent organizational narrative that answers the domain's purpose without unsupported facts; exhaustive category coverage MUST NOT be required.
- **FR-017**: Profile recommendations MUST be allowed to function as either Working Ideas or Converged Proposals, and artifact-acceptance questions MUST NOT be asked around Working Ideas.
- **FR-018**: Agreement with a Working Idea MUST NOT establish a domain as `discussed`; natural acceptance of an explicitly presented Converged Proposal MUST cross the existing acceptance boundary without redundant confirmation.
- **FR-019**: Profile MUST preserve the readiness states `not_discussed`, `discussed`, and `bounded`, and MUST NOT add a readiness state for Working Ideas, maturity, or Active Reasoning Context.
- **FR-020**: Profile MUST keep relevant Working Ideas, user contributions, interpretations, alternatives, tensions, and implications transient in Active Reasoning Context while the active task continues, without persisting or exposing that context as workflow state.
- **FR-021**: Profile MUST keep related conversational threads anchored to the active Profile subject and carry implications forward without interrupting the active subject solely to complete another domain.
- **FR-022**: Profile MUST preserve constructive advisory behavior, evolution-aware reasoning, organizational website scope, canonical questions as fallback acquisition tools, and the existing persistence ordering.
- **FR-023**: Profile MUST use clear sentences and short paragraphs when useful; one cohesive recommendation MUST NOT require one sentence or one paragraph.
- **FR-024**: Profile MUST persist only accepted organizational narrative and MUST NOT persist acknowledgments, headings, introductions, unadopted advisory commentary, internal category names, Working Idea files, reasoning logs, or new schema fields.
- **FR-025**: Profile MUST preserve schema version `3.0.0`, exactly the four retained domains `identity`, `vision`, `competitive_path`, and `guiding_principles`, and the existing retained-record structure.
- **FR-026**: Profile MUST preserve first-time Identity introduction behavior, website acquisition boundaries, unsupported-schema handling, malformed-record handling, obsolete-YAML handling, and all existing explicit operations.
- **FR-027**: Profile MUST emit the existing concise user-relevant completion synthesis after final Guiding Principles acceptance without adding a new question, machine status field, or workflow narration.
- **FR-028**: Profile Verification MUST cover transient Working Ideas, Converged Proposal boundaries, contextual re-evaluation, subject anchoring, mature-contribution convergence, acceptance-before-persistence ordering, preserved readiness semantics, preserved validation wording, fallback questions, and absence of a distinct acknowledgment stage.
- **FR-029**: The implementation MUST update only `highway-profile/SKILL.md`; it MUST NOT modify `profile-record.md`, other skills, schemas, shared governance documents, or unrelated artifacts.

### Key Entities

- **Working Idea**: A transient user contribution or Highway recommendation that may be interpreted, sharpened, challenged, corrected, extended, or redirected before it is complete enough for domain acceptance.
- **Converged Proposal**: A complete Profile-domain candidate that answers the domain's purpose coherently without unsupported facts and is presented at the artifact-acceptance boundary.
- **Accepted Profile Knowledge**: User-owned organizational narrative persisted after a Converged Proposal crosses the applicable acceptance boundary.
- **Active Reasoning Context**: Transient context containing relevant developing ideas, interpretations, tensions, alternatives, implications, and user contributions used while the active Profile subject is unresolved.
- **Profile Domain**: One of Identity, Vision, Competitive Path, or Guiding Principles, each retaining its existing readiness semantics.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Every Profile domain has a documented and testable distinction between Working Idea development and Converged Proposal acceptance, with no required acknowledgment stage.
- **SC-002**: A complete Profile walkthrough covering all four domains preserves schema `3.0.0`, exactly four readiness domains, and only the existing readiness states.
- **SC-003**: In contract checks covering partial contributions, agreement with Working Ideas does not create `discussed` readiness, while acceptance of a presented Converged Proposal does persist the domain before dependent results.
- **SC-004**: In contract checks covering accepted domain transitions, each later subject receives accumulated accepted Profile context and at least one useful contextual implication when the fixture provides one; transitions remain natural when none is available.
- **SC-005**: Profile-specific verification contains no required `Acknowledge -> Introduce -> Suggest -> Validate` stage and no requirement that every recommendation be immediately followed by validation.
- **SC-006**: The implementation diff changes exactly one shipped skill file, leaves `profile-record.md` byte-identical, and leaves all other skill, schema, governance, and template files unchanged.
- **SC-007**: Existing Profile validation wording, canonical fallback questions, website boundary, operations, malformed-record behavior, and final completion synthesis remain present and contract-checkable.
- **SC-008**: Reviewers can complete the primary Profile setup journey without encountering persistence narration, readiness narration, workflow progression narration, or a machine status field in normal orchestrated output.

## Assumptions

- The current `.highway/skills/highway-profile/SKILL.md` is the only shipped Profile behavior artifact in scope for this feature.
- The shared Constitution, Highway Identity, and Experience Standard remain authoritative for generic collaborative-development, contextual re-evaluation, constructive advisory, evolution-aware, and workflow-narration behavior.
- `profile-record.md` remains the authority for retained Profile structure and schema version `3.0.0`.
- Existing Profile tests and fixtures may require their stale Profile-specific assertions to be updated as directly affected verification, while unrelated coverage remains unchanged.
- No new persistence format, migration path, readiness state, or feature-specific data store is needed.
- The feature is a development-iteration change and does not require compatibility with unreleased intermediate Profile wording.
