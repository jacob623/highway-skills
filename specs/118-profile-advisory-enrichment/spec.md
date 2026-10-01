# Feature Specification: Profile Advisory Enrichment

**Feature Branch**: `118-profile-advisory-enrichment`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: Update only `highway-profile` so its Profile introduction, website-assisted organizational discovery, context-driven recommendations, cohesive enrichment paragraphs, constructive advisory behavior, persistence boundaries, completion synthesis, and verification align with the 6.0.0 Experience Standard, 6.0.0 Constitution, and Highway identity while preserving the existing four-domain Profile schema.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Understand Profile Setup Before Providing Context (Priority: P1)

As a person starting Profile setup for the first time, I want a brief explanation of why Highway is asking about my organization and a clear Repository Name prompt, so that I understand the purpose of Profile without receiving a duplicate Setup welcome.

**Why this priority**: The first interaction establishes trust and gives the person the context needed for later recommendations.

**Independent Test**: Start Profile setup with no retained Profile and verify the introduction appears once before the Repository Name question, then start configure and resume flows and verify the introduction does not repeat.

**Acceptance Scenarios**:

1. **Given** no retained Profile exists and first-time Profile setup begins, **When** Profile emits its opening, **Then** it emits `### Let's get to know your organization` and `This helps Highway make more relevant recommendations as we go.` before the Repository Name question.
2. **Given** first-time Profile setup is opening, **When** Profile asks for the repository name, **Then** it uses `**What would you like to call your Highway repository?**` followed by the company-or-organization guidance sentence.
3. **Given** Profile is invoked through configure or resumed interaction, **When** the flow continues, **Then** the first-time introduction is not repeated.
4. **Given** Setup has already emitted its Highway welcome, **When** Profile begins, **Then** Profile's introduction remains separate and does not replace or duplicate Setup's welcome.

### User Story 2 - Build Organizational Understanding From Accepted Evidence (Priority: P1)

As a person providing organizational context, I want supported public-website evidence and accepted answers reused across all Profile domains, so that Highway becomes more specific instead of restarting generic discovery.

**Why this priority**: Accepted organizational evidence is the foundation for grounded recommendations and reduced repetitive questioning.

**Independent Test**: Provide a Repository Name, Organization URL, accepted website-derived evidence, direct answers, corrections, and validated discoveries. Verify proposed-versus-accepted boundaries, cross-domain re-evaluation, and recommendation-before-question behavior.

**Acceptance Scenarios**:

1. **Given** an accepted Repository Name and supported public-website retrieval, **When** Identity acquisition continues, **Then** Profile asks for the organization's public website using the accepted Repository Name before ordinary domain questioning.
2. **Given** a person supplies an Organization URL, **When** Profile accepts the optional context, **Then** the URL is retained as accepted optional context without affecting readiness.
3. **Given** website retrieval returns an Organization Name or organizational facts, **When** the person has not accepted those discoveries, **Then** the discoveries remain proposed and are not retained as user-owned Profile evidence.
4. **Given** website retrieval is unavailable, **When** Profile continues, **Then** it proceeds normally without exposing the unavailable retrieval capability.
5. **Given** accepted Identity or other organizational evidence changes, **When** Profile continues, **Then** it persists the accepted change, processes the evidence across all four domains, re-evaluates unresolved domains, and attempts a grounded recommendation before asking another canonical question.
6. **Given** accepted evidence already establishes a domain, **When** Profile selects the next interaction, **Then** it does not ask that domain's canonical question.
7. **Given** accepted evidence is corrected, replaced, selected, or validated, **When** Profile continues, **Then** it repeats cross-domain re-evaluation before the next unresolved question.
8. **Given** the available evidence cannot support a useful recommendation, **When** Profile needs more information, **Then** it uses the applicable canonical question as a fallback.

### User Story 3 - Receive Cohesive, Grounded Profile Recommendations (Priority: P1)

As a person describing an organization, I want one cohesive recommendation for Vision, Competitive Path, or Guiding Principles when accepted evidence supports it, so that I can review meaningful organizational language instead of filling out hidden enrichment categories.

**Why this priority**: Cohesive recommendations express useful understanding while preserving user ownership and the existing Profile narrative schema.

**Independent Test**: Seed accepted Identity and related evidence for each enrichment domain. Verify one grounded paragraph is offered, internal categories are not shown or persisted, explicit acceptance establishes the domain, and canonical questions remain fallback behavior.

**Acceptance Scenarios**:

1. **Given** accepted evidence supports a useful Vision synthesis, **When** Profile offers enrichment, **Then** it presents one cohesive paragraph grounded in accepted evidence and asks whether it reflects the organization's direction with accept, change, or user-authored alternative wording.
2. **Given** accepted evidence supports a useful Competitive Path synthesis, **When** Profile offers enrichment, **Then** it presents one cohesive paragraph grounded in accepted Profile evidence and asks whether it reflects how the organization expects to get there with accept, change, or user-authored alternative wording.
3. **Given** accepted evidence supports a useful Guiding Principles synthesis, **When** Profile offers enrichment, **Then** it presents one cohesive paragraph grounded in accepted evidence and asks whether it reflects what should guide decisions with accept, change, or user-authored alternative wording.
4. **Given** a person accepts a cohesive paragraph recommendation, **When** Profile persists the acceptance, **Then** the corresponding domain becomes `discussed` and its canonical question is not subsequently asked.
5. **Given** accepted evidence is insufficient for a useful cohesive paragraph, **When** Profile needs that domain, **Then** it asks the domain's canonical question.
6. **Given** an enrichment category is used internally to reason about a recommendation, **When** Profile presents or persists the result, **Then** the category name is neither shown nor stored.
7. **Given** accepted evidence does not support a detail, **When** Profile forms a recommendation, **Then** it does not manufacture that detail merely to make the paragraph richer.
8. **Given** the person provides an incomplete idea and accepted evidence supports a useful implication, stronger formulation, tradeoff, concern, or alternative, **When** Profile responds, **Then** it may contribute that constructive advisory value without manufacturing disagreement or overriding user ownership.

### User Story 4 - Preserve Profile State and Completion Ownership (Priority: P1)

As a person completing Profile setup, I want accepted evidence and recommendations saved before dependent readiness results and a concise completion synthesis before Setup resumes, so that the retained Profile and visible conversation agree.

**Why this priority**: Persistence and completion boundaries protect user-owned organizational context and prevent false success claims.

**Independent Test**: Accept direct evidence, discovered evidence, recommendations, corrections, and replacements; verify each accepted mutation is persisted before dependent results and that guided completion emits one concise user-relevant synthesis without machine fields or another question.

**Acceptance Scenarios**:

1. **Given** accepted direct, discovered, recommended, corrected, or replacement Profile evidence, **When** Profile changes retained state, **Then** it constructs and persists the accepted mutation before returning readiness or another dependent owner result.
2. **Given** conversational acceptance has occurred but persistence has not succeeded, **When** Profile reports the outcome, **Then** it does not claim mutation success or expose a dependent result as complete.
3. **Given** all four Profile domains are `discussed` or `bounded` and the accepted Profile can be meaningfully summarized, **When** guided setup completes, **Then** Profile emits one concise warm synthesis before returning control to Setup.
4. **Given** the completion synthesis is visible, **When** it describes the retained understanding, **Then** it uses the accepted Organization Name when available, mentions that Highway will use the understanding to improve later guidance, and contains no status, next action, blocking reason, owner-result mechanics, or new question.
5. **Given** Profile returns a machine-consumable readiness result to Setup or a direct readiness invocation, **When** the result is requested through that owner boundary, **Then** its fields remain available without being rendered in normal orchestrated conversation.

### User Story 5 - Keep Profile Boundaries and Schema Stable (Priority: P2)

As a governance maintainer, I want Profile improvements to preserve the existing retained schema and domain ownership, so that downstream consumers continue to read the same four-domain Profile while technology discovery stays with a future brownfield workflow.

**Why this priority**: Compatibility prevents this user-facing improvement from changing the repository's Profile contract or expanding Profile into architecture discovery.

**Independent Test**: Review the updated Profile skill against `profile-record.md`, the Experience Standard, the Constitution, and Highway identity. Verify schema, states, readiness, error handling, scope, and minimal Experience wording remain compatible.

**Acceptance Scenarios**:

1. **Given** Profile state is evaluated, **When** readiness is calculated, **Then** exactly Identity, Vision, Competitive Path, and Guiding Principles determine readiness.
2. **Given** a domain has accepted evidence establishing it, an explicit user boundary, or neither, **When** its state is persisted, **Then** it is respectively `discussed`, `bounded`, or `not_discussed`.
3. **Given** a domain is `discussed`, **When** Profile considers optional enrichment, **Then** it does not require every possible enrichment category, change readiness, or block continuation.
4. **Given** Profile processes an Organization URL or website evidence, **When** it classifies the evidence, **Then** it retains organizational context only and does not investigate or retain registrar, hosting, CMS, commerce, SaaS, technology-stack, or other brownfield technology observations.
5. **Given** the retained Profile structure is reviewed, **When** the feature is implemented, **Then** `profile-record.md` remains unchanged, schema version `3.0.0` remains unchanged, and the four readiness-domain keys remain unchanged.
6. **Given** Profile's Experience section is reviewed, **When** generic interaction behavior is described, **Then** it remains exactly `User-visible interaction follows the Highway Experience Standard.` and does not duplicate shared recommendation, Decision Context, advisory, synthesis, machine-result, or acceptance rules.
7. **Given** unsupported schema, obsolete YAML, or malformed retained Profile input is encountered, **When** Profile handles the error, **Then** it preserves the existing blocked, ignored, and no-mutation behavior.

### Edge Cases

- First-time setup is invoked after Setup already emitted its welcome; Profile emits its own introduction once without duplicating Setup.
- Configure or resumed Profile interaction begins with no first-time introduction.
- Repository Name is accepted but public-website retrieval is unavailable; Profile continues without exposing the unavailable capability.
- Website-derived Organization Name or facts are plausible but not accepted; they remain proposed.
- Organization URL is accepted while website-derived facts remain proposed.
- Accepted Identity evidence supports Vision but not Competitive Path or Guiding Principles; Profile recommends only where grounding is sufficient and falls back to canonical questions elsewhere.
- Accepted evidence supports several internal enrichment categories but not a defensible cohesive paragraph; Profile does not manufacture a paragraph.
- An already `discussed` or `bounded` domain receives optional enrichment; readiness and continuation remain unchanged.
- A person changes a recommendation after Profile has staged it; only the accepted replacement is persisted.
- Persistence fails after conversational acceptance; Profile does not return a successful dependent result.
- The accepted Profile is complete but has no accepted Organization Name; completion synthesis remains natural without inventing one.
- A person explicitly bounds an unresolved domain; Profile records `bounded` and does not ask its canonical question.
- A malformed retained Profile, unsupported schema, or obsolete YAML artifact is encountered; existing error handling remains unchanged.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The feature MUST modify only the `highway-profile` skill and its Profile-specific verification or contract tests; it MUST NOT modify `profile-record.md`.
- **FR-002**: Profile MUST retain exactly four readiness domains: Identity, Vision, Competitive Path, and Guiding Principles.
- **FR-003**: Each Profile domain MUST retain exactly one of `not_discussed`, `discussed`, or `bounded` as its readiness state.
- **FR-004**: Accepted evidence that establishes a domain MUST set that domain to `discussed`; an explicit user boundary on an otherwise unresolved domain MUST set it to `bounded`; absent evidence or boundary MUST leave it `not_discussed`.
- **FR-005**: A `discussed` domain MUST mean accepted evidence establishes the domain and MUST NOT require all possible enrichment categories to have been explored.
- **FR-006**: Optional enrichment MUST remain non-readiness-bearing and MUST NOT block continuation.
- **FR-007**: First-time Profile setup MUST emit `### Let's get to know your organization` and `This helps Highway make more relevant recommendations as we go.` before the Repository Name question.
- **FR-008**: The first-time Repository Name interaction MUST use `**What would you like to call your Highway repository?**` followed by `If you're using Highway for a company or organization, its name is usually a good choice.`
- **FR-009**: The first-time Profile introduction MUST be emitted once for initial setup, MUST NOT repeat during configure or resumed interaction, and MUST remain separate from Setup's Highway welcome.
- **FR-010**: After an accepted Repository Name, Profile MUST use supported public-website retrieval before ordinary domain questioning when retrieval is available.
- **FR-011**: Profile MUST treat a supplied Organization URL as accepted optional context and MUST keep website-derived Organization Name and organizational facts proposed until the person accepts them.
- **FR-012**: Website discovery MUST be limited to organizational Profile evidence. Profile MUST NOT investigate or retain registrar, hosting, CMS, commerce, SaaS dependency, technology-stack, or other brownfield technology observations.
- **FR-013**: When website retrieval is unavailable, Profile MUST continue normally without exposing the missing retrieval capability.
- **FR-014**: After accepted organizational evidence changes, Profile MUST persist the accepted change, process the evidence across all four domains, re-evaluate unresolved domains, and attempt a grounded recommendation before asking another canonical question.
- **FR-015**: Profile MUST repeat accepted-evidence re-evaluation after every accepted answer, recommendation, correction, replacement, or validated discovery.
- **FR-016**: Profile MUST NOT ask a domain's canonical question when accepted evidence establishes that domain or an explicit user boundary makes it `bounded`.
- **FR-017**: For Vision, Competitive Path, and Guiding Principles, Profile MUST prefer one cohesive grounded paragraph recommendation when accumulated accepted evidence supports a useful combined interpretation.
- **FR-018**: Profile MUST use internal enrichment categories only as reasoning inputs; category names MUST NOT be shown to the person or persisted in the retained Profile.
- **FR-019**: Profile recommendations MUST contain only grounded organizational content and MUST NOT manufacture unsupported details.
- **FR-020**: Accepted Vision, Competitive Path, and Guiding Principles paragraph recommendations MUST establish the corresponding domain as `discussed` and prevent that domain's canonical question.
- **FR-021**: When a grounded cohesive recommendation cannot be produced, Profile MUST use the applicable canonical question as the fallback acquisition mechanism.
- **FR-022**: Profile MUST preserve Identity's supported organizational discovery behavior and MUST NOT force the synthesized-paragraph recommendation model onto Identity.
- **FR-023**: Profile MAY contribute a grounded implication, stronger formulation, meaningful alternative, relevant tradeoff, concern, or inconsistency when accepted evidence supports it; it MUST NOT manufacture disagreement or override user ownership.
- **FR-024**: Profile MUST use the Experience Standard's shared acceptance wording, user-authored alternatives, Decision Context ordering, and presentation rules without duplicating those generic rules in the Profile skill.
- **FR-025**: Profile MUST accept a direct statement, accepted discovery, accepted recommendation, correction, or replacement only through the existing save-before-result boundary: accepted evidence, mutation construction, persistence, then dependent readiness or owner result.
- **FR-026**: Conversational acceptance without successful persistence MUST NOT be reported as mutation success or as a dependent successful result.
- **FR-027**: Guided Profile completion MUST emit one concise user-relevant synthesis after the final accepted Profile mutation and before returning control to Setup when the accepted Profile can be meaningfully summarized.
- **FR-028**: The completion synthesis MUST use the accepted Organization Name when available, summarize accepted organizational understanding naturally, state that Highway will use it to improve later guidance, and contain no status, next action, blocking reason, owner-result mechanics, or new question.
- **FR-029**: Profile's machine-consumable readiness result MUST remain available to Setup and direct readiness invocation while remaining absent from normal orchestrated user-visible conversation.
- **FR-030**: Profile MUST preserve schema version `3.0.0`, the existing four readiness-domain keys, and the current unsupported-schema, obsolete-YAML, and malformed-retained-Profile error behavior.
- **FR-031**: Profile MUST retain `Organization URL` as optional context for future brownfield workflows while keeping technology and brownfield discovery outside Profile.
- **FR-032**: Profile's Experience section MUST remain exactly `User-visible interaction follows the Highway Experience Standard.` and MUST NOT duplicate shared recommendation, singular/multiple wording, Decision Context, Constructive Advisory, completion synthesis, machine-result suppression, or acceptance semantics.
- **FR-033**: The feature MUST align Profile behavior with `experience-standard.md` 6.0.0, `.specify/memory/constitution.md` 6.0.0, and the Constructive Advisory direction in `highway-identity.md` without copying their generic rule text.
- **FR-034**: The feature MUST be classified as a MINOR Profile capability addition with the requested release metadata of `highway-profile` 5.1.0 from a 5.0.0 baseline; if 5.1.0 is already present when implementation begins, the feature MUST preserve that version rather than introduce an additional version bump.

### Key Entities

- **Profile**: The retained organizational context with schema version `3.0.0`, four readiness domains, optional context, and domain narratives.
- **Readiness domain**: One of Identity, Vision, Competitive Path, or Guiding Principles with state `not_discussed`, `discussed`, or `bounded`.
- **Accepted evidence**: User-provided or user-accepted organizational information that may be persisted and reused across domains.
- **Proposed discovery**: Website-derived or otherwise discovered information that remains transient until accepted.
- **Cohesive paragraph recommendation**: One grounded, reviewable narrative offered for Vision, Competitive Path, or Guiding Principles without exposing internal enrichment categories.
- **Canonical question**: The fallback domain-specific acquisition prompt used only when grounding cannot produce a useful recommendation.
- **Organization URL**: Accepted optional organizational context retained for future brownfield workflows but not used for technology discovery within Profile.
- **Completion synthesis**: One concise, warm, user-relevant summary emitted after final accepted Profile mutation before Setup resumes.
- **Machine readiness result**: Internal readiness fields available to Setup or direct invocation but suppressed from normal orchestrated conversation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of first-time Profile setup flows, the required introduction appears before the Repository Name question, and in 100% of configure or resumed flows it does not repeat.
- **SC-002**: In 100% of website-assisted flows, accepted Organization URL context is retained, unaccepted website-derived facts remain proposed, and unavailable retrieval does not block or expose an implementation capability.
- **SC-003**: In 100% of transitions after accepted organizational evidence, Profile evaluates all four readiness domains and attempts a grounded recommendation before an unresolved canonical question.
- **SC-004**: In 100% of supported grounded Vision, Competitive Path, and Guiding Principles cases, Profile presents one cohesive paragraph recommendation with no visible or persisted internal enrichment-category names.
- **SC-005**: In 100% of accepted paragraph recommendation cases, the corresponding domain is `discussed`, its canonical question is not repeated, and only grounded accepted evidence is retained.
- **SC-006**: In 100% of insufficient-grounding cases, Profile uses the applicable canonical question rather than fabricating a recommendation.
- **SC-007**: In 100% of accepted Profile mutations, persistence occurs before any dependent readiness or owner result is returned; failed persistence produces no successful mutation claim.
- **SC-008**: In 100% of completed guided Profile flows with meaningful accepted context, exactly one concise synthesis appears before Setup resumes, with zero machine status fields and zero additional questions.
- **SC-009**: In 100% of readiness evaluations, only the four Profile domains determine readiness; optional enrichment, Organization Name, and Organization URL do not change readiness.
- **SC-010**: In 100% of scope reviews, Profile performs no brownfield technology discovery, `profile-record.md` remains unchanged at schema version `3.0.0`, and the four readiness-domain keys remain unchanged.
- **SC-011**: In 100% of contract reviews, the Profile Experience section remains the single shared-standard sentence and contains no duplicated generic interaction rules.
- **SC-012**: The shipped `highway-profile` skill version advances from 5.0.0 to 5.1.0 with no breaking change to existing supported operations, inputs, outputs, retained schema, or readiness semantics.

## Assumptions

- Feature numbering remains sequential and the next feature directory is `specs/118-profile-advisory-enrichment`.
- The current `highway-profile` skill is version 5.1.0 and will be amended to 5.1.0 only if the repository's current version is actually 5.0.0 at implementation time; otherwise the implementation preserves the repository's established versioning decision and records the resulting MINOR increment.
- The request's explicit target of `highway-profile` 5.1.0 is authoritative for the intended release metadata.
- `.highway/library/templates/output/profile-record.md` remains unchanged and schema version `3.0.0` remains authoritative.
- The current Profile operations, error handling, save-before-result boundary, and readiness result fields remain compatible and are refined rather than replaced.
- Supported public-website retrieval is an existing capability boundary; this feature does not add a new external service contract.
- Highway identity, Experience Standard, and Constitution remain authoritative sources for generic advisory, interaction, and development-governance behavior.
- Profile-specific verification may update tests under `.highway/tools/tests/`, but no generated adapters or catalogs are changed unless a source skill change requires their established regeneration workflow.
- A cohesive paragraph recommendation is one recommendation under the shared Experience Standard, so Profile does not define its own acceptance or alternative wording contract.
