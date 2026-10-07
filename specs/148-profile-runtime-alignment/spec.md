# Feature Specification: Profile Runtime Architecture Alignment

**Feature Branch**: `148-profile-runtime-alignment`

**Created**: 2026-10-06

**Status**: Draft

**Input**: User description: "Update highway-profile to align with the revised Highway Identity, Highway Experience Standard, and runtime/development governance boundary."

## User Scenarios & Testing

### User Story 1 - Profile-owned organizational meaning (Priority: P1)

As a person establishing organizational context, I want Profile to remain authoritative for its four organizational domains and their completeness, so that accepted Profile knowledge remains coherent and useful to later Highway work.

**Why this priority**: Domain ownership is the foundation of Profile correctness. If generic collaboration or unrelated governance determines Profile meaning, the retained organizational context can become inaccurate or incomplete.

**Independent Test**: Exercise Profile with evidence for Identity, Vision, Competitive Path, and Guiding Principles, including incomplete, bounded, and complete states, and verify that Profile alone determines domain meaning, evidence, completeness, readiness, acceptance, and persistence.

**Acceptance Scenarios**:

1. **Given** evidence about one or more Profile domains, **When** Profile evaluates it, **Then** it preserves the four domain meanings and determines domain completeness without adding technology, governance, or downstream-owner content.
2. **Given** all four domains are discussed or bounded, **When** Profile assesses readiness, **Then** it reports Profile completion without using optional enrichment or Highway context as an additional readiness domain.
3. **Given** a domain candidate has conversationally converged, **When** Profile presents its domain acceptance question, **Then** the question requests acceptance of the representation and does not decide whether conversational development is complete.
4. **Given** acceptance has been granted, **When** Profile persists the domain, **Then** dependent readiness and owner results use the new state only after persistence succeeds.

### User Story 2 - Experience-governed collaboration (Priority: P1)

As a person developing organizational understanding with Highway, I want generic collaboration to follow the Highway Experience Standard, so that Profile does not duplicate or compete with shared interaction behavior.

**Why this priority**: Separating generic collaboration from Profile semantics prevents competing convergence, advisory, clarification, and presentation rules across skills.

**Independent Test**: Provide mature direct input, ambiguous evidence, substantive corrections, and opportunities for grounded development, then verify that Profile supplies domain semantics while the Experience Standard governs Working Ideas, advisory reasoning, clarification, Contribution Opportunities, re-evaluation, direct contribution short paths, and conversational convergence.

**Acceptance Scenarios**:

1. **Given** Profile evidence is domain-complete but still has useful grounded development available, **When** Profile collaborates, **Then** it relies on the Experience Standard rather than applying a separate Profile convergence procedure.
2. **Given** a mature direct contribution requires no material interpretation or useful grounded development, **When** Profile evaluates it, **Then** it may proceed through the Experience Standard short path without forced advisory exploration.
3. **Given** a domain proposal is not a Converged Proposal, **When** Profile is ready to ask for acceptance, **Then** it continues collaboration under the Experience Standard rather than presenting the domain acceptance question prematurely.
4. **Given** the person provides a substantive correction, **When** Profile continues, **Then** active and accepted context is re-evaluated according to the Experience Standard before the next user-relevant behavior.

### User Story 3 - Contextual acquisition and cross-domain reasoning (Priority: P1)

As a person supplying organizational material, I want Profile to use accepted Profile evidence and shared Highway context appropriately across unresolved domains, so that useful relationships are preserved without turning Highway context or provisional reasoning into organizational fact.

**Why this priority**: Acquisition and cross-domain reasoning are Profile-specific sources of value, but they must preserve user ownership and the distinction between context, evidence, and accepted knowledge.

**Independent Test**: Start with retained context, supplied organizational material, optional public-source material, and accepted domain narratives; verify that Profile evaluates available evidence across unresolved domains, preserves supported cross-domain implications, and retains only supplied, selected, or accepted organizational information.

**Acceptance Scenarios**:

1. **Given** Highway Identity is available, **When** Profile interprets its role, **Then** it uses Identity only as shared non-normative context and never persists it as organizational evidence or fact.
2. **Given** accepted Identity, Vision, or Competitive Path provides a relationship relevant to an unresolved domain, **When** Profile evaluates the evidence, **Then** the relationship can inform that later domain without being forced into the active domain.
3. **Given** supplied material or an optional supported public website is available, **When** Profile acquires evidence, **Then** discovered or imported facts remain proposed until accepted and unavailable optional retrieval does not falsely create facts or block valid continuation.
4. **Given** a canonical domain question is available, **When** Profile selects its next contribution, **Then** it uses the question only as a fallback when the Experience Standard has not already produced a better grounded contribution or consequential clarification.

### User Story 4 - Safe Profile persistence and completion handoff (Priority: P2)

As a person completing Profile setup, I want persistence failures and completion handoff to be explicit and safe, so that Profile never reports successful readiness or completion from knowledge that was not actually retained and Setup does not duplicate Profile's completion synthesis.

**Why this priority**: Incorrect persistence or duplicated completion messaging can make the repository appear more complete than it is and can confuse ownership between Profile and Setup.

**Independent Test**: Exercise malformed retained Profiles, accepted mutation failures, unexpected persistence failures, successful final persistence, and Profile-to-Setup handoff; verify local failure behavior, progression gating, and exactly-once Profile synthesis ownership.

**Acceptance Scenarios**:

1. **Given** a retained Profile is malformed, contradictory, or structurally invalid, **When** Profile assesses it, **Then** it reports Blocked without mutation.
2. **Given** an accepted Profile mutation fails, **When** Profile handles the failure, **Then** the affected domain remains unpersisted, dependent progression stops, and no successful readiness, completion, or owner result claims the mutation succeeded.
3. **Given** optional retrieval or discovery is unavailable, **When** Profile can continue from available evidence, **Then** it continues without claiming unavailable facts.
4. **Given** final Profile persistence succeeds during guided setup or configure, **When** Profile returns to Setup, **Then** Profile emits one concise user-relevant completion synthesis without a new question and Setup does not duplicate it.

### Edge Cases

- Highway Identity is present but contains no organizational evidence; Profile uses it only as contextual guidance about Highway's purpose and connected-knowledge model.
- A supplied public website or imported organizational material cannot be retrieved; Profile continues where valid without representing unavailable facts as discovered.
- A single evidence contribution has implications for multiple unresolved Profile domains; Profile evaluates those relationships across domains and preserves them for the appropriate unresolved domain.
- A domain is complete but the Experience Standard identifies consequential uncertainty or useful grounded development; Profile does not ask its acceptance question prematurely.
- A direct contribution is mature and domain-complete without material interpretation; Profile does not force generic advisory exploration.
- A person accepts a domain proposal but persistence fails; readiness and dependent owner results do not advance from the failed mutation.
- Profile completion synthesis is already supplied by Profile; Setup does not emit a second synthesis or a ceremonial question.
- A downstream-owned Control, NFR, architecture, implementation, or plan detail is volunteered; Profile may retain only broad strategic meaning where relevant and does not persist downstream content in Profile.

## Requirements

### Functional Requirements

- **FR-001**: Profile MUST remain authoritative for Identity, Vision, Competitive Path, and Guiding Principles, including their meanings, evidence, completeness, discussed/bounded/not_discussed state, readiness, acceptance, and persistence.
- **FR-002**: Profile MUST determine domain completeness independently from conversational convergence.
- **FR-003**: Profile MUST delegate generic collaboration behavior to the Highway Experience Standard, including Working Idea development, advisory reasoning, substantive re-evaluation, Contribution Opportunities, clarification, conversational convergence, mature direct-contribution short paths, and generic presentation.
- **FR-004**: Profile MUST NOT contain a separate convergence procedure that resolves ambiguity, develops implications, provides Contribution Opportunities, decides convergence, or prescribes Working Idea sequencing.
- **FR-005**: Profile MUST present each domain acceptance question only after the Experience Standard permits a Converged Proposal.
- **FR-006**: Profile acceptance questions MUST request acceptance of the domain representation and MUST NOT serve as convergence tests or add another confirmation after natural acceptance.
- **FR-007**: Profile MUST preserve its domain-specific meanings and boundaries, including the exclusion of technology-landscape inventory from Identity, evidence-grounded Vision, broad Competitive Path, and non-enforceable Guiding Principles.
- **FR-008**: Profile MUST evaluate substantive organizational evidence across unresolved Profile domains and preserve supported cross-domain relationships for the appropriate unresolved domain.
- **FR-009**: Profile MUST use Highway Identity only as shared, non-normative context about what Highway is, why it exists, and what it is trying to achieve; Identity MUST NOT be treated as organizational evidence, behavioral governance, strategic organizational direction, an evaluation criterion, or a source of organizational facts.
- **FR-010**: Profile MUST NOT use Highway Vision or Highway Platform Objectives as runtime context.
- **FR-011**: Profile MUST preserve acquisition of retained Profile context, Repository Name, supplied organizational material, and supported public organizational website evidence while treating discovered or imported facts as proposed until accepted.
- **FR-012**: Profile MUST use canonical domain questions as fallbacks only when the Experience Standard has not already produced a better grounded next contribution or consequential clarification.
- **FR-013**: Profile MUST persist only supplied, selected, or accepted organizational evidence and MUST NOT add retained fields for Working Ideas, convergence, recommendations, advisory reasoning, Contribution Opportunities, conversational clarification, or expression/persona/style.
- **FR-014**: Profile MUST establish the Repository Name when missing and offer one opportunity to reuse supplied organizational material or a supported public website before ordinary domain questioning.
- **FR-015**: Profile MUST treat acceptance as authorization for its declared mutation, not as proof of successful persistence.
- **FR-016**: Profile MUST complete the accepted mutation before dependent readiness, completion, or owner results use the new Profile state.
- **FR-017**: Profile MUST report malformed, contradictory, or structurally invalid retained Profile state as Blocked without mutation.
- **FR-018**: Profile MUST stop before dependent progression and provide actionable user-facing context when accepted persistence fails or an unexpected persistence failure occurs.
- **FR-019**: Profile MUST NOT claim successful domain, readiness, completion, or owner results from a mutation that did not succeed.
- **FR-020**: Profile MUST continue when optional retrieval or discovery is unavailable and MUST NOT claim facts that could not be obtained.
- **FR-021**: Profile MUST emit one concise user-relevant completion synthesis after successful final Profile persistence before returning to Setup, without adding a question or exposing readiness/status mechanics.
- **FR-022**: Setup MUST consume Profile's completion synthesis without duplicating it.
- **FR-023**: Profile MUST NOT reference the Highway Skills Constitution common failure model at runtime and MUST define its effective failure behavior locally.
- **FR-024**: Profile MUST retain the Highway Experience Standard as the authoritative generic interaction contract.
- **FR-025**: Profile MUST preserve the existing Profile record output contract and four-domain readiness dimensions without adding generic collaboration fields or readiness dimensions.

### Key Entities

- **Profile Domain**: One of Identity, Vision, Competitive Path, or Guiding Principles, with domain-specific meaning, evidence, narrative, state, and completeness.
- **Profile Evidence**: Organizational information supplied, selected, accepted, or otherwise permitted by the Profile acquisition contract.
- **Highway Identity Context**: Shared, non-normative context about Highway that may inform interpretation but is never organizational evidence or retained Profile content.
- **Converged Proposal**: A candidate whose relevant substance is developed enough under the Highway Experience Standard for Profile to present its domain acceptance question.
- **Accepted Profile Knowledge**: User-owned Profile information that crossed the applicable domain acceptance boundary and may inform later Profile reasoning.
- **Profile Readiness**: Profile's owner result based only on the four Profile domains and their valid states.
- **Profile Completion Synthesis**: One concise user-relevant summary emitted by Profile after successful final persistence before returning to Setup.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Automated and review-based checks identify zero runtime references in Profile to `highway-vision.md`, `highway-platform-objectives.md`, or the Constitution common failure model.
- **SC-002**: Profile readiness checks show that 100% of readiness outcomes depend only on Identity, Vision, Competitive Path, and Guiding Principles states; optional Context and enrichment do not alter readiness.
- **SC-003**: Contract checks confirm that all four Profile acceptance questions occur only after the Experience Standard permits a Converged Proposal and are not used as convergence tests.
- **SC-004**: Collaboration-boundary checks find zero Profile-owned duplicate procedures for generic Working Ideas, advisory reasoning, clarification, Contribution Opportunities, re-evaluation, or conversational convergence.
- **SC-005**: Persistence checks confirm that 100% of failed Profile mutations block dependent progression and produce no successful domain, readiness, completion, or owner result claim.
- **SC-006**: Acquisition checks confirm that 100% of discovered or imported organizational facts remain proposed until accepted and that unavailable optional retrieval produces no claimed facts.
- **SC-007**: Completion-handoff checks confirm exactly one Profile completion synthesis after successful final persistence and zero duplicate synthesis from Setup.
- **SC-008**: Output-contract checks confirm zero new retained fields or readiness dimensions for Working Ideas, convergence, recommendations, advisory reasoning, Contribution Opportunities, conversational clarification, or expression/persona/style.
- **SC-009**: Reviewers can trace every Profile-specific behavior in Verification to a functional requirement without relying on generic Experience rules being restated in Profile.

## Assumptions

- The four existing Profile domains and the current `profile-record.md` output contract remain the authoritative domain and persistence shape.
- The Highway Experience Standard remains available as the generic interaction contract and continues to own its declared collaboration rules.
- Highway Identity remains a shared contextual document and is not changed by this feature.
- Setup, Objectives, Controls, NFRs, and Clarify remain unchanged by this feature; generated Profile adapters and Profile-specific tests may be updated as dependent artifacts when required by repository correspondence rules.
- Existing Profile acceptance questions are product-approved and remain textually stable unless alignment requires only a boundary clarification.
- Optional enrichment and public-source retrieval are non-blocking when Profile can proceed from available evidence.
- No external API or new retained data schema is introduced.

## Verification

- The retained Profile follows `.highway/library/templates/output/profile-record.md` and preserves the four Profile readiness domains.
- Optional Context and enrichment do not change Profile readiness.
- Identity, Vision, Competitive Path, and Guiding Principles retain their specific meanings and downstream boundaries.
- Profile determines domain completeness, while conversational convergence is delegated to the Highway Experience Standard.
- The separate Profile convergence procedure is absent and no replacement convergence algorithm is introduced.
- Domain acceptance questions occur only for Converged Proposals and are not used as convergence tests.
- Canonical questions remain fallbacks rather than a mandatory interview sequence.
- Mature direct contributions retain the Experience Standard short path.
- Only supplied, selected, or accepted organizational evidence is persisted; model-originated Working Ideas remain unretained until accepted.
- Supported evidence is evaluated across unresolved Profile domains and cross-domain relationships can inform later unresolved domains.
- Highway Identity remains non-normative context and is never retained as organizational fact.
- Highway Vision and Highway Platform Objectives are absent as runtime dependencies.
- Accepted mutations succeed before dependent results use the new state.
- Failed persistence cannot produce a successful domain, readiness, completion, or owner result.
- Optional retrieval or discovery failure does not produce claimed facts when Profile can proceed without it.
- Profile completion synthesis is emitted once after successful final persistence and is not duplicated by Setup.
- Profile does not expose or retain generic collaboration concepts as schema fields or readiness dimensions.
- Profile's local runtime failure behavior is explicit and does not reference the Constitution common failure model.

