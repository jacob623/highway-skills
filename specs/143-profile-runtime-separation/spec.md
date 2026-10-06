# Feature Specification: Profile Runtime Separation Cleanup

**Feature Branch**: `143-profile-runtime-separation`

**Created**: 2026-10-06

**Status**: Draft

**Input**: User description: Update `highway-profile` to align with the finalized runtime separation established by the Constitution, Experience Standard, Highway Identity, and Profile-specific ownership contracts. Remove obsolete compatibility guidance and duplicated shared interaction mechanics without changing the retained Profile template or shared runtime documents.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Use only the current Profile model (Priority: P1)

As a person using Profile, I want readiness and acquisition to describe the current supported Profile model, so that historical schemas and obsolete formats cannot change the workflow or create conflicting behavior.

**Why this priority**: Removing obsolete branching is the foundation for a deterministic Profile workflow and prevents compatibility language from competing with the current retained structure.

**Independent Test**: Review `When not to use`, Outputs, Profile model, Acquisition, Verification, and Error Handling, then run readiness scenarios for absent, malformed, incomplete, bounded, and complete Profiles.

**Acceptance Scenarios**:

1. **Given** no retained Profile exists, **When** readiness is requested, **Then** Profile reports Missing and identifies setup as the next action.
2. **Given** a retained Profile is malformed, contradictory, or structurally invalid, **When** readiness is requested, **Then** Profile reports Blocked, leaves the artifact unchanged, and does not invoke historical-format handling.
3. **Given** a valid Profile has an unresolved `not_discussed` domain, **When** readiness is requested, **Then** Profile reports Missing and identifies configure as the next action.
4. **Given** all four readiness domains are `discussed` or `bounded`, **When** readiness is requested, **Then** Profile reports Complete and optional Context or enrichment does not alter that result.
5. **Given** a supplied website or organizational source contains useful information, **When** Profile acquires it, **Then** it remains acquisition evidence until accepted and is evaluated across unresolved Profile domains.

### User Story 2 - Keep Profile-specific domain meaning concise (Priority: P1)

As a person developing organizational understanding, I want Profile to focus on Identity, Vision, Competitive Path, and Guiding Principles, so that each domain remains useful without being forced through generic interaction mechanics or an internal category checklist.

**Why this priority**: The requested cleanup is primarily semantic deduplication. Profile must retain its domain expertise while delegating shared collaboration and convergence to the authoritative runtime documents.

**Independent Test**: Review the Domain model, domain completeness, four domain contracts, Cross-domain reasoning, and subject presentation guidance for Profile-owned meaning, evidence, completeness, and boundaries.

**Acceptance Scenarios**:

1. **Given** accepted evidence supports a Profile domain, **When** Profile evaluates completeness, **Then** it determines whether the evidence forms a coherent supported narrative for that domain rather than checking an internal category framework.
2. **Given** Profile identifies useful provisional facets, themes, strategic pieces, or principle lists, **When** the developing understanding changes, **Then** those transient structures can be revised without becoming retained schema.
3. **Given** Identity contains multiple meaningful organizational aspects, **When** Vision is developed, **Then** Profile reasons from the accepted Identity without letting one prominent facet become the whole future merely because it is the easiest continuation.
4. **Given** Competitive Path includes downstream technical or governance detail, **When** Profile evaluates it, **Then** Profile retains only broad strategic meaning when relevant and leaves implementation, Controls, NFRs, architecture, and operational requirements to their owners.
5. **Given** Guiding Principles become more precise during development, **When** Profile evaluates them, **Then** they remain enduring organizational guidance and do not become enforceable Controls.
6. **Given** a person moves from one Profile subject to another, **When** the next subject opens, **Then** Profile uses the established conversational presentation headings without treating them as retained artifact headings.

### User Story 3 - Preserve acquisition, persistence, and readiness outcomes (Priority: P1)

As a Profile owner, I want the cleanup to preserve acquisition, acceptance, mutation, persistence, readiness, and guided completion behavior, so that simpler instructions do not weaken retained organizational knowledge.

**Why this priority**: Profile-specific persistence and readiness are part of the owner contract and must remain intact while shared authority and interaction mechanics are referenced rather than duplicated.

**Independent Test**: Exercise first-time setup, existing-material reuse, direct Repository Name capture, explicit `bounded` decisions, accepted mutations, failed mutations, and guided completion.

**Acceptance Scenarios**:

1. **Given** Repository Name is missing, **When** setup accepts it, **Then** Profile preserves the existing opportunity to reuse organizational material before ordinary domain questioning.
2. **Given** a person supplies a Repository Name, **When** Profile continues, **Then** it does not infer Organization Name or other organizational facts from that name alone.
3. **Given** a person explicitly decides not to establish an unresolved domain, **When** Profile persists that boundary, **Then** the domain may become `bounded`; missing evidence, uncertainty, failed discovery, or `I don't know` alone cannot do so.
4. **Given** a person accepts a Profile candidate or correction, **When** the result changes retained Profile state, **Then** Profile performs the owner mutation before returning dependent readiness, completion, or progression behavior.
5. **Given** an accepted Profile mutation fails, **When** Profile handles the failure, **Then** it does not claim accepted persisted knowledge, does not proceed with dependent output, and reports actionable failure context without adding a post-write read-back stage.
6. **Given** guided setup or configure reaches complete readiness, **When** all required persistence succeeds, **Then** Profile emits one concise user-relevant synthesis and returns to the existing setup flow without exposing machine-result mechanics or asking a new question.

### User Story 4 - Keep shared runtime ownership singular (Priority: P2)

As a maintainer, I want Profile to reference shared runtime contracts instead of copying them, so that collaboration, clarification, advisory interaction, acceptance interaction, and authority semantics have one authoritative home.

**Why this priority**: Reducing duplicate interaction guidance lowers execution ambiguity while preserving Profile-specific behavior and the finalized Constitution, Experience Standard, and Highway Identity contracts.

**Independent Test**: Compare Profile against the protected shared documents and inspect every remaining shared-runtime term for a Profile-specific reason to remain.

**Acceptance Scenarios**:

1. **Given** Profile needs collaborative development, convergence, clarification, Contribution Opportunity, advisory interaction, or acceptance interaction, **When** its instructions describe that behavior, **Then** they refer to the Highway Experience Standard rather than restating its generic mechanics.
2. **Given** Profile discusses authority, transience, owner completeness, mutation, persistence, or orchestration, **When** those boundaries are described, **Then** they remain consistent with the Constitution without copying its wider lifecycle.
3. **Given** Highway identity or contextual-advisor behavior is relevant, **When** Profile refers to it, **Then** it uses Highway Identity as the behavioral authority and keeps Profile-specific organizational meaning local.
4. **Given** the cleanup is implemented, **When** protected artifacts are compared, **Then** `profile-record.md`, `experience-standard.md`, `constitution.md`, and `highway-identity.md` are unchanged.

### Edge Cases

- A supplied website and imported organizational material both contain evidence for multiple unresolved domains; Profile evaluates them together, keeps derived facts proposed, and lets active user input override conflicting acquisition evidence.
- Acquisition material uses different headings, terminology, or structure from Profile; Profile can evaluate it without requiring conversion to the retained template.
- Optional Context or enrichment is present while one or more readiness domains remain unresolved; readiness still depends only on the four Profile domains.
- A complete domain candidate is still being collaboratively developed; Profile keeps it transient until the shared convergence and acceptance boundaries are satisfied.
- A direct domain-complete contribution does not require a manufactured interaction merely because optional detail remains.
- A model-originated possibility is useful but unsupported as organizational fact; it remains advisory and transient until accepted.
- New evidence affects more than one unresolved Profile domain; Profile evaluates all relevant domains before choosing the next Profile-owned action.
- Existing organizational material includes technology inventory or implementation details; Profile does not turn that material into technology-platform discovery.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `highway-profile` skill MUST describe only the current supported Profile model and MUST remove obsolete YAML, historical schema, migration-input, fallback, and legacy-format handling.
- **FR-002**: Readiness MUST classify retained Profile state in this order: absent as Missing with setup; malformed, contradictory, or structurally invalid as Blocked with no next action and no mutation; valid incomplete state with any `not_discussed` domain as Missing with configure; and valid state with all four domains `discussed` or `bounded` as Complete with no next action.
- **FR-003**: Optional Context and optional enrichment MUST NOT create readiness domains or change readiness classification.
- **FR-004**: The skill MUST preserve the four readiness domains Identity, Vision, Competitive Path, and Guiding Principles and their current state meanings.
- **FR-005**: Profile model guidance MUST assign Profile ownership for domain meaning, evidence, state, readiness, completeness, acquisition, retention eligibility, and persistence, while delegating shared interaction and authority mechanics to their authoritative runtime documents.
- **FR-006**: Profile MUST define domain completeness as a coherent, supported organizational narrative that answers the domain's purpose without unsupported facts or internal category coverage requirements.
- **FR-007**: Profile MAY use transient facets, themes, strategic pieces, or principle lists to help inspect developing substance; these structures MUST NOT become retained Profile schema and MUST be revisable when understanding changes.
- **FR-008**: Acquisition MUST classify retained state, establish Repository Name when missing, use supported organizational material or a supplied public website when available, evaluate evidence across unresolved domains, reuse accepted evidence, develop unresolved domains under the Experience Standard, persist accepted evidence, and report readiness.
- **FR-009**: A supplied Organization URL MAY be accepted as optional Context, but facts derived from it MUST remain proposed until accepted; Profile MUST NOT infer Organization Name from Repository Name.
- **FR-010**: Acquisition material MUST be evaluated as evidence rather than automatically accepted truth, MUST support multiple unresolved domains, and MUST NOT be required to match Profile headings, schema, terminology, or structure.
- **FR-011**: Profile MUST limit acquisition to organizational Profile evidence and MUST NOT turn websites or imported material into technology-platform discovery or inventory.
- **FR-012**: Profile's canonical questions MUST remain the fallback for unresolved organizational information, and Profile MUST evaluate available evidence across unresolved domains before asking them.
- **FR-013**: Organizational expression MAY guide representation through supported terminology, phrasing, and formality, but MUST NOT establish organizational truth or be retained as tone, voice, persona, style, terminology, or Organizational Context fields.
- **FR-014**: Profile MUST preserve Identity breadth, Vision's full-Identity reasoning, Competitive Path's broad-strategy boundary, Guiding Principles' non-Control boundary, and the four existing subject headings and validation questions.
- **FR-015**: Profile MUST evaluate new substantive organizational evidence across unresolved domains; accepted Identity informs Vision, accepted Identity and Vision inform Competitive Path, and accepted Identity, Vision, and Competitive Path inform Guiding Principles.
- **FR-016**: Profile MUST use transient Conversational Clarification through the Highway Experience Standard, with persisted deterministic clarification remaining owned by `highway-clarify`.
- **FR-017**: Profile MUST persist only accepted domain narratives, accepted corrections or replacements, explicit accepted domain boundaries, and optional Context permitted by the retained template.
- **FR-018**: Acceptance MUST authorize Profile mutation but MUST NOT itself count as successful persistence; dependent readiness, completion, or progression MUST wait for successful owner mutation.
- **FR-019**: A failed accepted mutation MUST NOT establish persisted accepted Profile knowledge or permit dependent progression, and Profile MUST NOT add a post-write read-back or verification stage.
- **FR-020**: Guided setup or configure completion MUST emit one concise user-relevant synthesis only after required Profile persistence succeeds and MUST preserve the existing supported operations.
- **FR-021**: Profile MUST keep Working Ideas, rejected alternatives, unaccepted advisory commentary, presentation headings, and transient organizational-expression guidance out of retained Profile content.
- **FR-022**: Profile MUST reference the Highway Experience Standard for visible collaboration, convergence, clarification, Contribution Opportunity, advisory interaction, and acceptance interaction rather than duplicating generic mechanics.
- **FR-023**: Profile MUST remain compatible with Highway Identity's collaborative-advisor identity and MUST NOT redefine identity, contextual re-evaluation, or constructive-advisory rules locally.
- **FR-024**: The implementation MUST modify only the `highway-profile` skill and directly necessary Profile validation artifacts; it MUST NOT modify `profile-record.md`, `experience-standard.md`, `constitution.md`, or `highway-identity.md`.
- **FR-025**: The skill version MUST be classified under the current Constitution Skill Versioning Policy, and the Profile schema version MUST remain unchanged.
- **FR-026**: Verification MUST check current-state readiness, acquisition evidence, bounded semantics, domain completeness, cross-domain reasoning, expression boundaries, downstream ownership, mutation-before-dependent-output, guided completion, and absence of duplicated generic runtime mechanics.

### Key Entities *(include if feature involves data)*

- **Profile Domain**: One of Identity, Vision, Competitive Path, or Guiding Principles with Profile-owned meaning, evidence, state, completeness, and readiness.
- **Acquisition Evidence**: User-supplied or supported public-website information used to develop Profile understanding; it remains proposed until accepted and is not retained as source metadata.
- **Organizational Expression**: Transient terminology, phrasing, or formality guidance that affects representation without establishing truth or becoming a retained Profile field.
- **Profile Domain Candidate**: A coherent supported domain narrative that may be complete without yet being conversationally converged or accepted.
- **Accepted Profile Mutation**: The owner-controlled persistence of accepted Profile knowledge; acceptance authorizes it, but only successful mutation establishes retained knowledge.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In every readiness scenario, the four documented state outcomes are distinguishable with no historical-schema branch affecting the result.
- **SC-002**: Reviewers can identify Profile ownership and shared-runtime ownership in every major skill section with zero unresolved responsibility conflicts.
- **SC-003**: All four Profile domains retain their current semantic boundaries, canonical fallback questions, subject presentation, and acceptance wording while no internal enrichment category is required for completeness.
- **SC-004**: In every reviewed acquisition scenario, supplied evidence is evaluated across unresolved domains, remains proposed until acceptance, and never becomes a technology inventory.
- **SC-005**: In every reviewed boundary scenario, `bounded` requires an explicit user decision and optional Context or enrichment does not affect readiness.
- **SC-006**: In every reviewed persistence scenario, zero dependent readiness, completion, or progression results occur before successful accepted Profile mutation; failed mutations produce zero dependent terminal results.
- **SC-007**: Reviewers find zero Profile-local copies of generic convergence, clarification, Contribution Opportunity, advisory calibration, one-question, or acceptance mechanics that belong to the Experience Standard.
- **SC-008**: Protected documents `profile-record.md`, `experience-standard.md`, `constitution.md`, and `highway-identity.md` receive zero changes.
- **SC-009**: The full repository validation suite passes with zero failures, and focused Profile validation covers every requirement group.
- **SC-010**: Direct complete contributions can proceed without manufactured interaction, while useful model-originated or acquired possibilities remain transient until accepted.

## Assumptions

- The current `highway-profile` skill and its existing validation contracts are the authoritative implementation baseline.
- The retained Profile template remains the authority for frontmatter, domain keys, narrative order, and optional Context structure.
- The Highway Experience Standard remains authoritative for visible collaboration, convergence, clarification, Contribution Opportunity, advisory interaction, and acceptance interaction.
- The Highway Constitution remains authoritative for authority, transience, owner completeness, mutation, persistence, orchestration, and context precedence.
- Highway Identity remains authoritative for collaborative-advisor identity, contextual intelligence, constructive advisory, and conversational presence.
- The existing supported Profile operations, readiness semantics, acquisition sources, guided completion synthesis, and persistence failure model are preserved unless explicitly named above.
- The requested cleanup is a skill-contract amendment, not a retained Profile schema change or redesign of neighboring governance artifacts.
- Skill version classification is determined during planning under the current Constitution policy rather than assumed from the feature number.
