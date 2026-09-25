# Feature Specification: Adaptive Organizational Profile Evidence

**Feature Branch**: `091-adaptive-profile-evidence`

**Created**: 2026-09-24

**Status**: Draft

**Input**: User description: Replace the fixed highway-profile technical questionnaire with adaptive organizational evidence collection, persist a human-readable Markdown Profile as durable Repository Context, and recognize the Profile in the Highway governance model.

## Clarifications

### Session 2026-09-24

- Q: When an existing `profile.yaml` contains organizational data but `profile.md` does not yet exist, how should setup handle that legacy data? -> A: Ignore legacy data. The YAML artifact is obsolete and is neither migrated nor used as a fallback; users provide or recreate context in the Markdown Profile.
- Q: What should make Profile setup complete when all five evidence domains have been discussed? -> A: All five domains must be Discussed or Bounded, with no unresolved Profile questions; the user must accept the proposed Profile, and completion is claimed only after the accepted Profile is persisted and persistence is verified. A domain may contain no section when the user provides no knowledge worth retaining.
- Q: Can interrupted initial setup resume from unaccepted answers? -> A: No. Initial setup evidence is transient proposal state; if setup is interrupted or the proposal is declined before acceptance and persistence, a later invocation starts again because no authoritative Profile evidence was retained. An existing accepted Profile may resume from its persisted domain outcomes.
- Q: Does Feature 091 require an existing production Highway skill to consume Profile context? -> A: No. Feature 091 establishes the Repository Context contract and validates it through a reference participation fixture. Production skill adoption is separate unless explicitly added to scope.

## Evidence Targets and Domain Entry

Evidence targets guide recognition and adaptive follow-up; they are not required fields and do not
form a hidden questionnaire. Evidence from an earlier response may establish a later domain without
requiring that domain's starting question. During setup this is proposal evidence; after persistence
it is accepted Profile evidence.

### Identity: Who We Are

Starting question: "Tell me about your organization."

Evidence targets:

- Organization identity and description
- What the organization does
- Who it serves
- Industry or business domain
- Approximate organizational scale
- Role of technology in the business
- Responsibility for technology
- Relevant organizational or technology capabilities
- Operating or sourcing model when applicable

### Vision: Where We're Going

Starting question: "Where do you want your organization to go?"

Evidence targets:

- Desired future state
- Strategic direction
- Major priorities
- Desired outcomes
- Important challenges
- Areas the organization wants to improve, transform, enable, or become

### Competitive Path: How We'll Get There

Starting question: "How do you plan to achieve that vision? What will you need to do particularly well or differently?"

Evidence targets:

- Competitive advantage
- Core strengths
- Strategic capabilities
- Differentiators
- Role of technology in the strategy
- Important areas of investment or capability development
- Strategic tradeoffs

### Guiding Principles: What Sets the Guardrails

Starting question: "What principles or beliefs should guide decisions as you pursue that vision?"

Evidence targets:

- Organizational values
- Decision principles
- Risk posture
- Investment philosophy
- Technology philosophy when applicable
- Governance philosophy when applicable
- Autonomy versus standardization preferences
- Important non-negotiables or boundaries

### Highway's Role: Where Highway Fits

Starting question: "How do you envision Highway helping your organization achieve its goals?"

Evidence targets:

- Expected advisory role
- Problems Highway should help solve
- Capability or expertise gaps Highway can help address
- Existing expertise Highway should complement
- Desired outcomes from Highway
- Areas needing guidance
- Areas needing acceleration or automation
- Responsibilities the organization intends to retain

These starting questions are domain entry points, not a fixed five-question sequence. Follow-ups
remain adaptive, and one response may support multiple domains.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Discover Organizational Context Conversationally (Priority: P1)

As an organization representative, I want Profile setup to begin with broad natural-language questions and learn from each response, so that I can explain my organization without completing a rigid technical questionnaire.

**Why this priority**: The primary value of the feature is a lower-friction way to establish organizational context that works for organizations with different sizes, structures, and capabilities.

**Independent Test**: Start Profile setup with no retained Profile, answer each broad domain question with a response containing multiple facts, and confirm the workflow extracts those facts, asks at most one unresolved question at a time, and advances when further detail would not change future guidance.

**Acceptance Scenarios**:

1. **Given** no retained Profile exists, **when** setup begins, **then** the first question asks the person to describe the organization broadly rather than presenting a fixed field-by-field form.
2. **Given** one response establishes multiple facts, **when** the response is processed, **then** all supported evidence is preserved in the active proposal and applied to every supported domain before another question is asked.
3. **Given** resolving missing evidence would alter none of the behavior categories enumerated by FR-005, **when** the active domain is evaluated, **then** the workflow advances without asking a completion-only question.
4. **Given** resolving missing evidence can alter a behavior category enumerated by FR-005, **when** the active domain is evaluated, **then** the workflow asks one natural follow-up question focused on that evidence.
5. **Given** all five domains are Discussed or Bounded and no Profile question remains unresolved, **when** the user accepts the proposed Profile, **then** setup persists and verifies the Profile before reporting completion.
6. **Given** proposal evidence from an earlier response establishes a later domain and no unresolved follow-up remains, **when** that domain is evaluated, **then** the workflow marks it Discussed without asking its canonical starting question; it may mark the domain Bounded only when the earlier response explicitly established a boundary.

### User Story 2 - Build a Durable Human-Readable Profile (Priority: P1)

As an organization representative, I want accepted organizational knowledge preserved in a readable Profile, so that future Highway workflows can use the context without asking for it again.

**Why this priority**: Durable context is necessary for the adaptive collection work to improve future recommendations instead of remaining a one-time conversation.

**Independent Test**: Complete a setup conversation with evidence in multiple domains, inspect the retained Profile, and confirm it preserves the user's meaning in Markdown, includes only supported sections, and can be read by later workflows.

**Acceptance Scenarios**:

1. **Given** accepted evidence exists for some domains, **when** the Profile is persisted, **then** the retained artifact is a human-readable Markdown document at `.highway/library/knowledge/profile.md` with required metadata and only evidence-supported domain sections.
2. **Given** a response contains nuanced organizational knowledge, **when** that evidence is persisted, **then** the Profile preserves the meaning in natural language rather than reducing it to unsupported booleans or fixed classifications.
3. **Given** a domain has no accepted evidence and is not needed to complete the Profile, **when** the artifact is generated, **then** no empty section is emitted solely to satisfy a schema and `# Organizational Profile` remains present.
4. **Given** the Profile is changed, **when** completion is reported, **then** persistence of `.highway/library/knowledge/profile.md` has been verified first and the completion report names that artifact.
5. **Given** a domain is Bounded because the user does not know or chooses not to provide more evidence, **when** the Profile is persisted, **then** the workflow does not invent facts or emit an empty domain section solely to represent the bounded outcome.

### User Story 3 - Make Profile Context Available to Participating Skills (Priority: P1)

As a Highway user, I want skills that explicitly participate in Profile Repository Context to use accepted Profile evidence when it affects their work, so that Profile can support context-aware behavior without silently changing unrelated workflows.

**Why this priority**: The Profile has value only if it changes future Highway behavior in a bounded, evidence-based way.

**Independent Test**: Provide Profile evidence and a reference Participating Skill contract, then confirm the contract makes relevant evidence available, avoids re-asking established evidence, and asks for context required by the reference skill's declared behavior criteria rather than assuming it.

**Acceptance Scenarios**:

1. **Given** the reference Participating Skill fixture declares Profile context and the Profile contains behavior-changing evidence, **when** the participation contract is evaluated, **then** the fixture demonstrates that Profile evidence can alter behavior without changing unrelated skills.
2. **Given** the reference participation fixture does not find a capability or organizational structure established by Profile evidence, **when** it evaluates that need, **then** it asks rather than assuming the capability or structure exists.
3. **Given** the reference participation fixture encounters a new information need, **when** the Profile lacks that evidence, **then** it asks without repeating evidence already present in the Profile.
4. **Given** Profile context conflicts with a workflow-specific input, **when** the workflow executes, **then** the workflow-specific input remains authoritative for that execution.

### User Story 4 - Manage Profile Through Existing Operations (Priority: P2)

As a Highway user, I want existing Profile operations to work against the durable Markdown Profile, so that I can inspect, add, update, remove, reset, and assess readiness without maintaining two competing Profile locations.

**Why this priority**: Moving the authoritative artifact must not make established Profile management operations ambiguous or unusable.

**Independent Test**: Exercise setup, configure, view, show, describe, readiness, add, update, remove, and reset against a Profile, and confirm each operation reads or modifies `.highway/library/knowledge/profile.md` while the former YAML location is not authoritative.

**Acceptance Scenarios**:

1. **Given** a Profile exists at the knowledge-library path, **when** a supported Profile operation reads or displays Profile state, **then** it reads that Markdown artifact.
2. **Given** a user requests a mutation, **when** the mutation is previewed and completed, **then** both reports identify the knowledge-library Profile path.
3. **Given** a former `profile.yaml` artifact exists, **when** Profile state is evaluated, **then** it is not treated as the authoritative retained Profile.
4. **Given** Profile setup or configuration is requested and no authoritative Profile exists, **when** evidence collection begins, **then** no authoritative Profile artifact is created until the completed Profile proposal is accepted.
5. **Given** removing evidence would eliminate the only retained evidence for a Discussed domain, **when** the mutation is previewed, **then** the preview identifies a transition to Not Discussed unless the same request explicitly establishes a Bounded condition, and identifies the resulting readiness change.
6. **Given** all five persisted domain outcomes are Discussed or Bounded, **when** Configure is invoked without a requested Profile change, **then** the workflow reports Profile Complete, writes nothing, and lists the supported mutation actions.
7. **Given** a user resets a domain, **when** the reset completes, **then** that domain becomes Not Discussed and Profile readiness becomes Missing until the domain is discussed again.
8. **Given** an accepted Profile is incomplete after an authorized Remove or Reset, **when** Configure collects evidence for unresolved domains, **then** interruption or decline preserves the previously accepted Profile byte-for-byte.

### Edge Cases

- A single response may establish evidence in more than one listed evidence area; all relevant evidence is preserved in the active proposal or accepted Profile and applied to every supported domain without forcing the workflow to revisit the response.
- A response may establish enough context to skip several possible follow-up questions; skipped questions must not appear later merely because a fixed sequence expected them.
- An organization may have no dedicated technology, security, architecture, governance, or specialist team; the workflow must not infer one or ask about it unless resolving that information can alter one of the behavior categories enumerated by FR-005.
- An organization may be small, informal, distributed, or externally supported; the workflow must remain applicable without requiring enterprise structures or maturity labels.
- A user may decline to provide evidence or state that a topic is unknown; the workflow preserves that boundary and does not invent a value.
- Profile evidence may be partial; completion depends on every domain reaching a Discussed or Bounded outcome rather than populating every possible evidence target.
- A domain may be Discussed when it has proposal or accepted evidence and no unresolved information need remains under FR-005, or Bounded when the user explicitly establishes that further evidence is unavailable, unknown, not established, or intentionally withheld; setup cannot complete while any domain is Not Discussed.
- User acceptance of the proposed Profile is distinct from successful persistence; completion is reported only after the accepted artifact has been persisted and verified.
- A user may add new evidence later; later interactions enrich the Profile without discarding previously accepted context unless the user explicitly changes it.
- Existing YAML Profile state may be present; it is obsolete and is ignored rather than migrated or used as a fallback.
- Removing some evidence from a Discussed domain does not reopen it while other accepted evidence remains; removing all retained evidence requires an explicit Bounded outcome or transitions the domain to Not Discussed, and the preview identifies any readiness change.
- The representative adaptive review corpus covers a very small non-technical organization, a small technology startup, a small-to-medium organization with dedicated IT, and a large enterprise. These are test fixtures, not customer classifications or Profile states.
- A domain is not marked Discussed from a thin incidental fact; cross-domain evidence must supply Profile evidence for the domain and leave no unresolved information need under FR-005.
- Initial setup evidence and domain outcomes remain proposal state until the user accepts the Profile; initial setup never persists a `not_discussed` Profile. An accepted Profile may resume from persisted `not_discussed` outcomes only when a previously completed Profile became incomplete through an authorized Remove or Reset; an interrupted or declined first setup leaves an absent authoritative Profile absent.
- Bounded does not mean empty. A Bounded domain may retain accepted evidence already provided, and its narrative section is emitted when such evidence exists.
- A persisted Bounded outcome represents the user's accepted boundary at that time; later Add or Configure evidence may replace that boundary and transition the domain to Discussed.

### Adaptive review fixtures

The implementation review corpus includes these illustrative cases:

- **Very small non-technical organization**: fewer than five people with owner-managed technology; the workflow advances quickly and does not ask about specialist teams without another evidence-based reason.
- **Small technology startup**: approximately ten people with technology central to the business; technology responsibility may warrant deeper evidence without assuming enterprise structure.
- **Small-to-medium organization with dedicated IT**: hundreds of employees and a dedicated technology organization; structure receives follow-up only when it can change Highway behavior, and named specialist functions are not assumed.
- **Large enterprise**: a substantial technology organization; the workflow may explore specialized responsibilities, while absence of a named function is not interpreted as absence of that capability.

These fixtures test adaptive evidence behavior across scale and maturity; they do not create customer
classifications, personas, maturity tiers, product modes, or advisory classes.

The deterministic corpus also includes:

- A complete Profile with four `discussed` domains and one `bounded` domain, no narrative section for the bounded domain, and `Complete` readiness.
- A partial accepted Profile with at least one `not_discussed` domain, `Missing` readiness, preserved narrative from completed domains, and Setup/Configure selecting the first remaining domain.
- Narrative fidelity cases that preserve factual meaning, intentions, uncertainty, and explicit boundaries without adding structures, technology choices, governance obligations, or Business Objectives.
- Rendering cases that produce identical bytes, frontmatter order, section order, and narrative for identical inputs, with no timestamp, random value, or environment-derived content.
- Mutation cases for no-op changes, ambiguous narrative targets, version transitions, readiness transitions, and persistence verification before completion.
- A cross-domain conflict case in which Configure evidence contradicts an accepted organizational fact, names the conflicting retained evidence, writes nothing before resolution, and leaves unrelated accepted evidence unchanged.
- Explicit boundary cases such as "We haven't established guiding principles yet," "I don't know" in response to the active domain, and "I'd rather not provide that"; unrelated or incomprehensible responses remain Not Discussed rather than Bounded.
- **Setup resume routing**: interrupted first-time Profile collection has no authoritative Profile and therefore restarts at Identity; a valid incomplete retained Profile resumes at the first `not_discussed` domain; a valid Complete Profile causes Highway Setup to advance to Objectives. No case restores an unanswered prompt or separate Setup checkpoint.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile setup MUST begin with a broad conversational question rather than a fixed field-by-field questionnaire.
- **FR-002**: Profile setup MUST seek evidence across five stable domains: Identity, Vision, Competitive Path, Guiding Principles, and Highway's Role.
- **FR-003**: The workflow MUST extract all supported organizational evidence from each response and preserve it in the active proposal before asking another question.
- **FR-004**: The workflow MUST ask no more than one unresolved evidence question at a time.
- **FR-005**: The workflow MUST ask a follow-up question only when resolving missing evidence could alter recommendation selection, recommendation depth, explanation depth, assumed organizational responsibility, governance interpretation, workflow selection, or generated artifact content.
- **FR-006**: The workflow MUST advance beyond a domain when resolving additional evidence would alter none of the behavior categories enumerated by FR-005.
- **FR-007**: The workflow MUST NOT ask for evidence already established by active proposal evidence or accepted Profile evidence.
- **FR-008**: The workflow MUST NOT expose internal classifications, maturity scores, evidence-completeness calculations, or branching logic to the user.
- **FR-009**: Profile processing MUST preserve user-provided organizational knowledge and MUST NOT invent organizational facts that the user did not provide.
- **FR-010**: Profile setup MUST reach a Discussed or Bounded outcome for every evidence domain before completion.
- **FR-010a**: Profile setup MUST present the proposed Profile for user acceptance after all domains are Discussed or Bounded and before persistence.
- **FR-011**: The authoritative retained Profile MUST be a human-readable Markdown artifact at `.highway/library/knowledge/profile.md`.
- **FR-012**: The retained Profile MUST always contain `# Organizational Profile`, preserve canonical narrative ordering, and emit only domain sections containing accepted organizational knowledge.
- **FR-013**: Profile operations MUST use `.highway/library/knowledge/profile.md` for setup, configuration, viewing, description, readiness, addition, update, removal, reset, preview, completion reporting, and persistence verification.
- **FR-014**: Legacy `profile.yaml` MUST NOT be migrated, read as fallback, treated as authoritative, modified, deleted, or allowed to influence Markdown Profile behavior, including readiness, setup or Configure routing, mutations, domain outcomes, content generation, completion, or Setup orchestration.
- **FR-015**: Accepted Profile content MUST be available as organizational Repository Context to Participating Skills that declare Profile context.
- **FR-016**: A Participating Skill that declares Profile as Repository Context MUST use accepted Profile context when that context alters one of the behavior categories declared by that skill.
- **FR-017**: A Participating Skill MUST NOT infer an organizational capability or structure that Profile does not establish.
- **FR-018**: A workflow-specific input MUST remain authoritative for that execution when it conflicts with Profile context.
- **FR-019**: Profile context MUST remain user-owned organizational knowledge and MUST NOT become a Control, NFR, Objective, or replacement for workflow-specific inputs.
- **FR-020**: The Highway Skills Constitution MUST expand the Repository Context Document definition to include user-owned organizational context, add `profile.md` to the authoritative document list, and distinguish it from Highway identity, vision, and platform objectives.
- **FR-021**: All successful Profile writes are subject to the Persistence and Completion Integrity requirements of the Highway Skills Constitution; Profile-specific persistence verification MUST check `.highway/library/knowledge/profile.md`.
- **FR-023**: Evidence supplied for one domain MUST be applied to every domain it supports and MUST NOT be requested again while that proposal or accepted evidence remains available.
- **FR-024**: `.highway/library/templates/output/profile.md` MUST be the sole complete shared structural template for the retained Markdown Profile.
- **FR-025**: Highway MAY consolidate or rewrite accepted evidence into readable Profile prose but MUST NOT introduce organizational claims unsupported by accepted evidence.
- **FR-026**: Highway Setup MUST consume Profile-owned five-domain readiness and MUST NOT independently determine Profile completeness from `organization.name` or any other Profile field.
- **FR-028**: Profile evidence collection MUST NOT automatically create, replace, or modify Objectives, Controls, NFRs, or other governed artifacts.
- **FR-029**: Organizational evidence MUST NOT assign a fixed Highway persona, maturity tier, product mode, or advisory class.
- **FR-030**: Resetting a Profile evidence domain MUST return that domain to Not Discussed.
- **FR-031**: Evidence supplied before a domain's canonical starting question MAY establish that domain without asking the canonical question when no unresolved follow-up remains.
- **FR-032**: Each Profile domain MUST persist exactly one outcome from `not_discussed`, `discussed`, or `bounded`.
- **FR-033**: A missing, duplicated, or unrecognized persisted domain outcome MUST make Profile readiness Blocked.
- **FR-034**: Profile frontmatter MUST contain exactly one persisted outcome for each of the five evidence domains.
- **FR-035**: A narrative domain section MUST be omitted when no accepted organizational knowledge exists for that domain.
- **FR-036**: A domain MUST NOT become Bounded without an explicit user-established boundary.
- **FR-037**: Cross-domain evidence MUST satisfy the same follow-up criteria as evidence collected through that domain's canonical starting question.
- **FR-038**: Initial setup MUST NOT persist proposed organizational evidence as authoritative Profile content before Profile acceptance.
- **FR-039**: Declining an initial Profile proposal MUST leave an absent authoritative Profile absent.
- **FR-041**: Profile readiness Complete MUST depend on current valid persisted state rather than historical persistence-verification evidence.
- **FR-043**: Profile context MUST NOT override Highway identity, Highway vision, or Highway platform objectives.
- **FR-044**: The Highway identity Repository Context description MUST list `profile.md` consistently with the amended constitutional Repository Context definition.
- **FR-045**: The `highway-profile` skill revision MUST be treated as a breaking contract change and MUST increment its MAJOR version according to the Highway Skills Constitution Skill Versioning Policy.
- **FR-046**: The shared Markdown Profile template MUST document the Profile version contract without recreating the former organizational YAML schema.
- **FR-047**: Every Profile mutation MUST validate the authoritative Profile, construct and preview the proposed evidence and domain-state change, request confirmation, write only after confirmation, and apply the constitutional persistence and completion requirements before reporting success.
- **FR-048**: Declined, ambiguous, malformed, or failed Profile mutations MUST leave the original authoritative artifact unchanged.
- **FR-049**: Highway Setup MUST consume the Profile owner's readiness contract and advance to Objectives only when `Status: Complete`; Setup MUST NOT recompute Profile readiness.
- **FR-050**: Feature 091 MUST NOT modify downstream skills to consume Profile context unless those skills are explicitly added as Participating Skills with declared Profile Repository Context.
- **FR-051**: The implementation MUST update or replace tests and compliance checks that assume fixed questions, `organization.name` readiness, YAML retention, YAML node mutation, required empty mappings, or question-count progress.
- **FR-052**: Amendments to the Highway Skills Constitution MUST follow its amendment and Sync Impact Report requirements before the implementation is complete.
- **FR-053**: The implementation MUST run the applicable Highway Skills Constitution Compliance Review Protocol and Highway Experience Standard checks before completion.
- **FR-054**: The implementation MUST provide deterministic review fixtures for the four representative organizational scales and record each fixture's response, extracted evidence, supported domains, outcome, next action, non-inferred facts, and expected Profile prose.
- **FR-055**: Configure MUST keep newly collected evidence and proposed domain outcomes transient until the resulting Profile proposal is accepted.
- **FR-056**: Interrupted or declined Configure MUST preserve the previously accepted Profile unchanged.
- **FR-057**: Highway Setup MUST describe `/highway-profile` as owning organizational Profile evidence, domain outcomes, Profile readiness, and the Profile artifact.
- **FR-058**: A Profile mutation whose proposed artifact is byte-identical to the authoritative Profile MUST report `Confirmation Status: Not Required`, `Summary: No Change`, perform no write, and preserve the current Profile schema version without requiring persistence verification.
- **FR-059**: When a Profile mutation matches multiple retained evidence passages, the workflow MUST request target selection and MUST NOT write until one target is resolved.
- **FR-060**: Profile readiness MUST evaluate only the authoritative persisted Profile and MUST NOT report proposal evidence or provisional domain outcomes as persisted readiness state.
- **FR-061**: A successful Profile write MUST persist bytes matching the accepted proposal and MUST pass Profile structural validation before completion is reported.
- **FR-062**: A successful Profile mutation MUST NOT persist narrative content for a `not_discussed` domain; `not_discussed` always means no retained narrative exists for that domain.
- **FR-063**: Setup or Configure responses that establish neither evidence nor an explicit boundary MUST leave the active domain Not Discussed; the workflow MAY clarify the current question without advancing.
- **FR-064**: Configure MUST construct its proposal from the accepted Profile plus collected proposal evidence and MUST preserve untouched accepted domain content.
- **FR-065**: When proposal evidence conflicts with accepted evidence, the workflow MUST surface the conflicting retained evidence and resolve the conflict before persisting the resulting Profile; unrelated accepted evidence MUST remain unchanged.

### Profile operation semantics

- **Add**: add new accepted organizational evidence only to a Discussed or Bounded domain. Changes to a Not Discussed domain use Setup or Configure. Adding to a Discussed domain leaves it Discussed. If the user wants the domain rediscovered, use Reset and then Setup or Configure. Adding to a Bounded domain changes it to Discussed when the new evidence establishes the domain.
- **Update**: replace or revise uniquely identified accepted evidence while preserving the current domain outcome unless the change removes the basis for that outcome. If all meaningful evidence is removed, apply the Remove transition.
- **Remove**: remove identified accepted evidence. Removing the last accepted evidence transitions the domain to Not Discussed unless the same request explicitly establishes a Bounded condition; do not request a boundary solely to preserve readiness.
- **Reset**: remove all accepted evidence and any explicit boundary for one domain, transition it to Not Discussed, and make it eligible for recollection through Setup or Configure.
- **Setup**: with no authoritative Profile, always ask Identity's canonical starting question first. For an existing incomplete Profile, Setup and Configure are aliases that begin at the first Not Discussed domain using accepted Profile evidence; for a Complete Profile, report Complete without starting recollection. Explicit Add, Update, Remove, or Reset remains the route for changing a Complete Profile.
- **Configure**: use existing accepted evidence and domain outcomes, beginning at the first Not Discussed domain. If all domains are Discussed or Bounded, report Profile Complete and direct explicit changes through Add, Update, Remove, or Reset. Against an incomplete accepted Profile, the complete resulting proposal is composed from unchanged accepted evidence plus transient proposal evidence for unresolved domains; when all domains reach Discussed or Bounded, present that proposal for acceptance before modifying the authoritative artifact. Preserve accepted narrative for domains not being recollected unless a response explicitly changes evidence belonging to those domains.
- **View/Show/Describe**: inspect the current Profile without exposing internal branching or evidence-completeness calculations.
- **Readiness**: read-only evaluation of current persisted domain outcomes and retained-artifact validity.

### Setup and Configure routing

| Current Profile State | Setup / Configure Behavior |
|---|---|
| No authoritative Profile | Start with Identity's canonical question; collection remains transient until acceptance |
| Valid incomplete Profile | Start with the first `not_discussed` domain; existing accepted Profile content remains authoritative until the resulting proposal is accepted |
| Valid Complete Profile | Report Complete and do not start recollection; use Add, Update, Remove, or Reset for explicit changes |
| Malformed Profile | Report Blocked and do not overwrite the authoritative artifact |

Setup and Configure are aliases when operating on a valid incomplete Profile. The owner workflow
determines the next unresolved Profile domain; Highway Setup consumes that owner result rather than
independently inspecting Profile metadata.

Mutation target resolution operates on a domain plus quoted or uniquely matched retained evidence.
Markdown paragraph position or line number is not the user-facing identity of Profile evidence. If
multiple retained passages match a requested change, the mutation is ambiguous and no write occurs
until one target is selected. If a proposed mutation is byte-identical to the authoritative Profile,
report `Confirmation Status: Not Required` and `Summary: No Change`, perform no write, and do not
change the Profile schema version or require persistence verification. If proposal evidence conflicts
with accepted evidence, surface the conflicting retained evidence and resolve the conflict before
persisting; unrelated accepted evidence remains unchanged.

### Domain-state transition table

| Current State | Operation | Result |
|---|---|---|
| `not_discussed` | Setup or Configure evidence establishes the domain and no follow-up remains | `discussed` |
| `not_discussed` | User explicitly establishes a boundary | `bounded` |
| `discussed` | Add evidence | `discussed` |
| `bounded` | Add evidence establishing the domain | `discussed` |
| `discussed` | Update while evidence remains established | `discussed` |
| `bounded` | Update while the boundary remains | `bounded` |
| `discussed` | Remove while accepted evidence remains | `discussed` |
| `discussed` | Remove all evidence without an explicit boundary | `not_discussed` |
| `discussed` | Remove all evidence with an explicit boundary | `bounded` |
| `bounded` | Remove some retained evidence while the explicit boundary remains | `bounded` |
| `bounded` | Remove the last retained evidence while the explicit boundary remains | `bounded` |
| `bounded` | Update with evidence that establishes the domain | `discussed` |
| `bounded` | Reset | `not_discussed` |
| `discussed` | Reset | `not_discussed` |
| `not_discussed` | Reset | `not_discussed` |

Mutation previews MUST show a domain-state transition whenever the outcome changes.

Every mutation preview emits these fields, using `None` rather than omitting an unchanged field:

- Action
- File
- Domain
- Current Evidence
- Proposed Evidence
- Domain Outcome Change
- Readiness Change
- Confirmation Status

Remove and Reset previews identify the exact retained evidence that will be lost and every resulting
domain or readiness transition before confirmation. Mutation completion emits:

- Action
- File
- Domain
- Summary
- Domain Outcome
- Readiness
- Confirmation Status

Declined, ambiguous, malformed, failed, and no-op mutations do not write and use the corresponding
unchanged or failure result in these fields. A schema migration, if separately introduced, reports
schema version independently rather than as an ordinary mutation completion field.

### Domain Evaluation

On first-time setup with no authoritative Profile, Identity's canonical starting question is always
the first collection question. Canonical-question skipping applies only after that response has been
processed and to later domains.

Evaluate each domain in this order:

1. Apply proposal or accepted evidence already collected to every domain it supports.
2. If the user explicitly establishes a boundary for the active domain, assign Bounded.
3. Evaluate unresolved evidence against FR-005.
4. If an unresolved information need can alter an FR-005 behavior category, ask one follow-up.
5. If the domain has proposal or accepted evidence and no such information need remains, assign Discussed.
6. If the domain has no evidence and no explicit boundary, ask its canonical starting question.
7. Select the first remaining Not Discussed domain in canonical domain order.
8. When no Not Discussed domain remains, present the complete Profile proposal.
9. If evaluation cannot determine a valid next action from the available evidence, stop without changing persisted state and surface the unresolved or contradictory input.

If a response establishes neither domain evidence nor an explicit boundary, the domain remains Not
Discussed and the workflow may clarify the current question without advancing. A domain's central
meaning is established when available evidence communicates at least one coherent organizational
statement corresponding to that domain and FR-005 identifies no unresolved behavior-changing
information need.

Canonical domain order is Identity, Vision, Competitive Path, Guiding Principles, and Highway's Role.
The order determines which unresolved domain is evaluated next; it does not require asking every
canonical starting question. Cross-domain evidence may establish a domain only when it supplies
Profile evidence for that domain and leaves no unresolved information need under FR-005.

### Profile persistence contract

The reusable structural template is `.highway/library/templates/output/profile.md`. The authoritative
user-owned artifact is `.highway/library/knowledge/profile.md`.

The retained Profile uses minimal frontmatter for metadata and persisted domain outcomes. It does
not recreate the former YAML organizational schema:

```yaml
---
schema_version: 2.0.0
domains:
  identity: not_discussed
  vision: not_discussed
  competitive_path: not_discussed
  guiding_principles: not_discussed
  highway_role: not_discussed
---
```

The first Profile created under Feature 091 starts at `schema_version: 2.0.0` regardless of whether
legacy YAML exists, because the Markdown contract is the intentional successor to the obsolete YAML
Profile baseline and legacy YAML is not migrated into it. The Profile schema version and the
`highway-profile` skill MAJOR version are independent concerns. The shared
template's Highway library metadata version is distinct from the generated Profile's `schema_version`.
Only a structural Profile contract change updates `schema_version`; Add, Update, Remove, Reset, and
ordinary narrative changes do not change it. Git history records ordinary organizational-content changes.

Each of the five domain-state entries is required workflow metadata and persists exactly one of
`not_discussed`, `discussed`, or `bounded`. The narrative body contains only accepted organizational
knowledge under supported domain headings; narrative sections are conditional and are omitted when
no accepted knowledge exists. The five domain-state entries are required even when narrative sections
are absent.
Every retained Profile contains `# Organizational Profile`; domain headings appear only when accepted
organizational knowledge exists for that domain.
Accepted persisted Profile content is retained organizational evidence; unaccepted setup content is
transient proposal evidence.
The workflow does not emit question-count progress; where progress is applicable, it uses domain
state such as current, Discussed, Bounded, and remaining domains.

**Discussed** means the domain has proposal or accepted evidence and no unresolved information need
remains under FR-005. The evidence may have been supplied while another domain was active; it does
not mean that every evidence target was found. **Bounded** means the user has explicitly indicated that
additional evidence for the domain is unknown, unavailable, not established, or intentionally not
provided. The workflow MUST NOT assign Bounded solely because it cannot identify additional evidence.

During initial setup, collected evidence and provisional domain outcomes remain proposal state until
the user accepts the Profile. Only the accepted Profile becomes authoritative retained organizational
knowledge. Initial setup never persists a `not_discussed` Profile. An interrupted first-time setup
restarts later because no authoritative Profile evidence was retained; an existing accepted Profile
may resume from persisted `not_discussed` outcomes only after an authorized Remove or Reset made it
incomplete.

Profile narrative sections, when present, use this deterministic order:

1. `# Organizational Profile` (always present)
2. `## Who We Are` (when accepted evidence exists)
3. `## Where We're Going`
4. `## How We Plan to Get There`
5. `## What Guides Our Decisions`
6. `## How Highway Helps`

Unsupported sections are omitted while the relative order of remaining sections is preserved.

The Profile schema version is independent of content history. A domain-outcome transition is part of
the Add, Update, Remove, or Reset operation that produced it and never causes an additional schema
version increment.

### Readiness decision table

Readiness is derived from the current authoritative Markdown artifact and remains read-only:

| Condition | Readiness |
|---|---|
| `.highway/library/knowledge/profile.md` is absent | Missing |
| Profile is malformed | Blocked |
| Required domain-state metadata is malformed or incomplete | Blocked |
| Any domain is `not_discussed` | Missing |
| All five domains are `discussed` or `bounded` | Complete |
| Narrative and domain-state metadata contradict the structural contract | Blocked |

The valid state-to-narrative relationships are:

| Domain State | Narrative Section |
|---|---|
| `not_discussed` | MUST be absent |
| `bounded` with no accepted evidence | MUST be absent |
| `bounded` with accepted evidence | MAY be present |
| `discussed` | MUST be present |

Malformed or contradictory retained state includes unknown, duplicated, or missing domain outcomes,
malformed frontmatter, missing or malformed `schema_version`, unsupported frontmatter structure,
a domain state outside the closed vocabulary, `not_discussed` with a narrative section, `discussed`
without a narrative section, or a narrative section that cannot be mapped to exactly one canonical
Profile domain. Nuance or tension between ordinary user-authored prose statements is not by itself
a contradiction or a reason to block readiness.

Readiness never evaluates transient setup or Configure proposal state. Until a proposal is accepted
and persisted, readiness reflects only the current authoritative Profile.

Profile-specific Persistence Verification checks that the authoritative file exists, frontmatter
parses, `schema_version` is valid, all five domain outcomes are present and valid, state-to-narrative
invariants pass, and persisted bytes equal the accepted proposal. If persisted bytes do not match the
accepted proposal, the workflow reports a persistence failure, names
`.highway/library/knowledge/profile.md`, and does not report completion.

Profile readiness emits exactly:

```text
Status: <Complete, Missing, or Blocked>
Summary: <Profile readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Missing` uses `Blocking Reason: None`; `Complete` uses `Next Action: None` and `Blocking Reason:
None`; `Blocked` uses a non-empty `Blocking Reason`.

### Validation matrix

| Scenario | Artifact Exists | Domain State | Narrative | Readiness |
|---|---:|---|---|---|
| Never set up | No | N/A | N/A | Missing |
| Initial setup active | No | Proposal only | Proposal only | Missing |
| Completed setup | Yes | All Discussed or Bounded | Supported sections | Complete |
| Bounded without evidence | Yes | Bounded | Absent | Complete when other domains complete |
| Bounded with evidence | Yes | Bounded | Present | Complete when other domains complete |
| Reset domain | Yes | Not Discussed | Absent | Missing |
| Remove last Discussed evidence | Yes | Not Discussed | Absent | Missing |
| Malformed metadata | Yes | Invalid | Any | Blocked |
| Configure active | Yes, previous accepted bytes | Proposal transition only | Previous artifact unchanged | Existing persisted readiness until accepted |
| Configure accepted | Yes | New persisted outcomes | New accepted narrative | Derived from new persisted state |

### Experience Standard review cases

Adaptive Profile review fixtures confirm that each prompt contains one unresolved question at most,
uses no implementation mechanics in routine prompts, acknowledges behavior-changing evidence
concisely, explains when a targeted follow-up can affect Highway's advice, and uses examples only
when they clarify the desired kind of response.

### Repository Context ownership

The constitutional amendment recognizes these distinct ownership boundaries:

- `highway-identity.md` provides Highway identity and behavioral guidance.
- `highway-vision.md` provides Highway strategic direction.
- `highway-platform-objectives.md` provides platform evaluation criteria.
- `profile.md` provides user-owned organizational context.
- Workflow-specific inputs remain authoritative for the active execution when they conflict with Profile context.

Profile evidence does not automatically become a Business Objective, Control, NFR, or other governed
artifact. A downstream skill adopts Profile context only when it explicitly declares itself a
Participating Skill for that context. Identity governs Highway behavior, Vision governs Highway
strategic direction, Platform Objectives govern Highway evaluation criteria, Profile supplies
organizational context, and workflow-specific inputs govern the active execution.

### Key Entities *(include if feature involves data)*

- **Profile evidence**: User-provided organizational knowledge considered by the Profile workflow.
- **Proposal evidence**: Profile evidence collected in the current unaccepted setup or Configure proposal.
- **Accepted evidence**: Profile evidence represented in the authoritative retained Profile.
- **Narrative rendering**: Highway-authored prose that faithfully represents accepted evidence without introducing unsupported organizational claims.
- **Evidence domain**: One of the five stable areas used to organize Profile understanding without turning collection into a fixed questionnaire.
- **Adaptive follow-up**: A single question selected because resolving missing evidence can alter one of the behavior categories enumerated by FR-005.
- **Organizational Profile**: The durable, human-readable representation of accepted evidence at `.highway/library/knowledge/profile.md`.
- **Repository Context Document**: A recognized knowledge artifact that may materially influence recommendations, explanations, workflows, or generated artifacts.
- **Profile operation**: Any setup, configuration, inspection, readiness, mutation, reset, preview, completion, or persistence action involving Profile state.
- **Domain outcome**: The state of an evidence domain: Not Discussed, Discussed when no additional follow-up is warranted, or Bounded when the user does not know or chooses not to provide more evidence.
- **Profile readiness**: The owner-computed state derived from persisted domain outcomes and artifact validity: Missing, Complete, or Blocked.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In representative setup sessions, 100% of user responses are processed for all supported evidence before the next question is selected.
- **SC-002**: 100% of adaptive follow-up prompts contain no more than one unresolved evidence question.
- **SC-003**: In review cases where resolving missing evidence would alter none of the FR-005 behavior categories, 100% advance without a completion-only question.
- **SC-004**: In review cases where resolving missing evidence can alter an FR-005 behavior category, 100% produce one targeted follow-up or honor an explicit user boundary.
- **SC-004a**: A deterministic review corpus records the response, extracted evidence, supported domains, domain outcome, next domain or follow-up, facts not inferred, and whether each fact appears in Profile prose for every adaptive fixture.
- **SC-005**: A completed Profile preserves accepted evidence in all five domains when evidence for all five domains is supplied, with zero unsupported empty sections.
- **SC-005a**: Profile setup does not complete while any evidence domain is Not Discussed; it may complete when every domain is Discussed or Bounded and the user accepts the proposed Profile.
- **SC-006**: All supported Profile operations identify and use `.highway/library/knowledge/profile.md` as the authoritative path, with zero operations treating the former YAML path as authoritative.
- **SC-007**: The Repository Context contract makes the authoritative Profile path available for explicit Participating Skill declaration, and no existing skill is silently changed into a Profile participant.
- **SC-008**: A reference participation fixture demonstrates that a skill can use behavior-changing Profile evidence without re-asking established evidence and asks for missing capability or structure rather than asserting it; no production downstream adoption is implied.
- **SC-009**: Profile completion reports occur only after the authoritative artifact passes structural validation and its persisted bytes match the accepted proposal.
- **SC-010**: Reviewers can distinguish Profile from Highway identity, vision, platform objectives, Controls, NFRs, Objectives, and workflow-specific inputs without finding a conflicting ownership statement.
- **SC-011**: Four representative scale and maturity fixtures demonstrate adaptive behavior without assigning a customer classification, persona, maturity tier, product mode, or advisory class.
- **SC-012**: A complete Profile with one bounded domain reaches Complete readiness without inventing a narrative section for that domain.
- **SC-013**: A previously completed Profile made partial by Remove or Reset preserves completed-domain narrative, returns Missing readiness, and resumes at the first `not_discussed` domain.
- **SC-014**: Identical accepted evidence and domain outcomes render identical Profile bytes with stable frontmatter and section ordering and no time-, random-, or environment-derived content.
- **SC-015**: Narrative fidelity fixtures preserve facts, intentions, uncertainty, and boundaries without creating structures, technology choices, governance obligations, or Business Objectives.
- **SC-016**: Setup resume fixtures demonstrate that an absent Profile restarts Profile collection at Identity, an incomplete retained Profile resumes at the first `not_discussed` domain, and a Complete Profile advances Setup to Objectives without restoring transient interaction state.

## Assumptions

- Existing Profile command names and user-facing operations remain supported unless a later implementation plan identifies a necessary compatibility change.
- Existing YAML Profile content is intentionally ignored; users must provide or recreate any desired context through Profile evidence collection or later Profile operations.
- The five evidence domains are stable organizing concepts, not a requirement to collect a fixed list of fields.
- Accepted user responses are the source of organizational facts; Highway may interpret them for question selection but may not infer unsupported facts.
- Markdown is the authoritative retained representation; any reusable output template is subordinate to the user-owned Profile artifact and does not replace it.
- Profile setup may complete with individual evidence items unknown when each evidence domain has reached a Discussed or Bounded outcome.
- Existing downstream workflows continue to own their Controls, NFRs, Objectives, artifacts, decisions, and workflow-specific inputs.
- The repository's existing governance, output-template, persistence, and Repository Context contracts remain applicable unless explicitly amended by the implementation plan.
- Profile readiness evaluates current valid persisted state: Missing covers an absent Profile or any `not_discussed` domain; Complete requires five valid persisted `discussed` or `bounded` outcomes; Blocked covers malformed or structurally contradictory retained state. Persistence verification remains a post-write requirement before the original setup or mutation completion claim, not historical readiness state.
- Feature 091 establishes Profile creation, persistence, readiness ownership, Setup consumption, and the Repository Context contract; individual downstream skills adopt Profile context only when they explicitly declare themselves Participating Skills for Profile.
- Retired requirement identifiers FR-022, FR-027, FR-040, and FR-042 are intentionally not reused after consolidation; the remaining identifiers remain stable for traceability.

## Implementation Scope and Completion

This feature is a breaking revision of `highway-profile`. The implementation replaces its fixed
technical questionnaire, YAML node-oriented mutations, YAML retention, `organization.name` readiness,
and question-count progress with the adaptive evidence and Markdown contracts in this specification.
The `highway-profile` skill MAJOR version is incremented according to the constitutional Skill
Versioning Policy.

The implementation plan MUST treat this specification as implementation and test requirements rather
than copying every FR into `SKILL.md`. The skill remains within the constitutional MUST-level rule
limit by consolidating related behavior into bounded workflow algorithms, decision tables, Inputs,
Outputs, Verification, and Error Handling.

The complete shared structural template is `.highway/library/templates/output/profile.md`. The
authoritative retained artifact is `.highway/library/knowledge/profile.md`, beginning with frontmatter
that contains `schema_version: 2.0.0` for a new Profile and exactly one closed-vocabulary outcome for
each domain. The obsolete `.highway/library/templates/output/profile.yaml` and any retained `profile.yaml`
are not deleted, migrated, inspected, or used as fallback solely because this feature is present.

`.highway/library/templates/output/profile.md` is the sole complete structural authority for emitted
Profile frontmatter and body structure. The `highway-profile` skill cites that template from its
Outputs contract and does not maintain a competing complete structural definition. The feature
specification describes required behavior and invariants; implementation keeps the reusable file
skeleton centralized in the shared template. The skill rewrite references this template rather than
duplicating its complete frontmatter and body skeleton.

The implementation updates `highway-setup` to consume `/highway-profile readiness` without inspecting
Profile metadata or recomputing readiness. It amends the Highway Skills Constitution and synchronizes
the Repository Context description in `highway-identity.md` so both recognize `profile.md` as
user-owned organizational context while preserving Highway identity, vision, and platform ownership.

The implementation replaces the `organization.name` Setup input dependency with the Profile owner's
readiness contract and replaces the Setup ownership statement with ownership of organizational Profile
evidence, domain outcomes, Profile readiness, and the Profile artifact. The constitutional amendment
plan classifies its version impact under the Constitution Versioning Policy because it changes the
normative Repository Context definition and authoritative context list. The `highway-identity.md`
update occurs after that amendment and remains descriptive; the Constitution remains normative for
participation, precedence, and validation.

### Repository Context amendment sequence

Implement Repository Context changes in this order:

1. Amend the Highway Skills Constitution's Repository Context Document definition so it includes user-owned organizational context.
2. Add `profile.md` to the Constitution's authoritative Repository Context Document list.
3. Update constitutional overlap language so Identity governs Highway behavior, Vision governs strategic direction, Platform Objectives govern evaluation criteria, Profile supplies organizational context, and workflow-specific inputs remain authoritative for the active execution.
4. Complete the constitutional Sync Impact Report, semantic-version classification, required self-application review, and applicable compliance review.
5. Synchronize the descriptive Repository Context Documents section in `highway-identity.md`.
6. Validate the reference Participating Skill fixture against the amended constitutional Repository Context contract.

`highway-identity.md` remains descriptive. The Highway Skills Constitution remains normative for
Repository Context document membership, participating-skill obligations, precedence, and validation.

The implementation plan MUST determine the constitutional semantic-version change from the actual
Repository Context amendment under the Constitution Versioning Policy. Feature 091 does not preassign
the resulting Constitution version. The plan separately preserves the decided `highway-profile` MAJOR
skill-version increment because Feature 091 replaces its existing artifact, readiness, questionnaire,
mutation, and verification contracts.

Any existing setup transcript containing the former fourteen-question interaction remains historical
documentation unless explicitly used as a current behavioral fixture; current tests use adaptive
Profile fixtures instead of silently treating historical behavior as the new contract.

The implementation includes adaptive review fixtures, mutation and readiness tests, Markdown template
conformance tests, persistence-before-completion tests, obsolete-YAML isolation tests, Setup ownership
tests, and applicable Experience Standard and constitutional compliance reviews. It does not change
downstream skills to consume Profile context unless they are separately declared Participating Skills.

Feature 091 is complete only when `highway-profile` implements adaptive five-domain evidence
collection; the Markdown template and authoritative artifact contract exist; closed domain outcomes,
current-state readiness, transient initial proposals, evidence-based mutations, versioning, and
persistence verification pass their tests; Setup consumes Profile readiness; the Constitution and
Highway identity recognize Profile context; legacy YAML is behaviorally inert; and the adaptive,
Experience Standard, and constitutional compliance reviews pass.

The governing design boundary is: domain state tells Highway where organizational discovery stands;
Profile narrative tells Highway what it knows about the organization.

Domain outcomes are workflow metadata, not organizational conclusions. They indicate whether Highway
has finished discussing a domain, not whether the organization itself is mature, complete, documented,
or objectively understood.

Implementation planning should resolve this specification as written rather than introduce additional
Profile evidence domains, customer classifications, persistence stores, maturity models, or questionnaire
fields unless a blocking technical contradiction is discovered.

Implementation planning should freeze this product model after these state-lifecycle corrections. The
remaining work is translation into the breaking `highway-profile` revision, Markdown template,
`highway-setup` readiness and ownership update, constitutional amendment, descriptive identity
synchronization, deterministic fixtures and tests, and applicable Experience Standard and constitutional
reviews.
