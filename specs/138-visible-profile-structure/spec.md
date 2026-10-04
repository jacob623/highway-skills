# Feature Specification: Visible Profile Structure

**Feature Branch**: `138-visible-profile-structure`

**Created**: 2026-10-03

**Status**: Draft

**Input**: User description: "Make the retained organizational Profile structure fully visible in profile-record.md, and shorten highway-profile by removing duplicated structure and collaboration text without removing Profile capabilities."

## Clarifications

### Session 2026-10-03

- Q: Which file path should the retained organizational Profile keep? → A: Keep `.highway/library/knowledge/profile.md`
- Q: Which heading level should the template use for its frontmatter and body sections? → A: Use `## File Frontmatter` and `## Body`, matching the other record templates

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Reconstruct the retained Profile from the template (Priority: P1)

A reader opening the shared Profile record template can see the complete retained file: template identity, retained frontmatter, permitted body headings, and the rules for omitting sections. The reader does not need the Profile skill or a hidden comment to reconstruct that structure.

**Why this priority**: The template is the structural authority for the retained Profile. Hidden body rules force every later reading to depend on duplicated prose.

**Independent Test**: Give a reviewer only the Profile record template and ask them to write a retained Profile skeleton, including frontmatter, heading order, and omission rules.

**Acceptance Scenarios**:

1. **Given** the Profile record template, **When** a reviewer reads it, **Then** they can distinguish template identity, the retained frontmatter skeleton under `## File Frontmatter`, the retained body skeleton under `## Body`, and concise conditional-rendering semantics.
2. **Given** the template, **When** a reviewer lists retained frontmatter, **Then** it contains `schema_version: 3.0.0` and a `domains` mapping whose only keys are `identity`, `vision`, `competitive_path`, and `guiding_principles`.
3. **Given** the template, **When** a reviewer lists permitted body headings, **Then** the title is `# Organizational Profile`, followed in order by `## Who We Are`, `## Where We're Going`, `## How We Plan to Get There`, and `## What Guides Our Decisions`, then optional `## Context`.
4. **Given** the template, **When** a reviewer looks for template name, description, template version, instructions, placeholders, or rendering explanations, **Then** those are template guidance and are not copied into the retained Profile.

---

### User Story 2 - Render only accepted domain and context content (Priority: P1)

A person reading a retained Profile sees a domain heading only when that domain's state permits narrative. Missing domains leave no placeholder. Optional context appears only for accepted children.

**Why this priority**: A visible skeleton is incomplete unless a reader can tell what is written, what is omitted, and what remains in frontmatter.

**Independent Test**: Compare retained Profiles for discussed, bounded-with-narrative, bounded-without-narrative, not-discussed, and partial-context cases against the template's rendering rules.

**Acceptance Scenarios**:

1. **Given** a domain is `discussed`, **When** the retained Profile is rendered, **Then** its accepted narrative appears under that domain's retained heading.
2. **Given** a domain is `bounded` and accepted narrative exists, **When** the retained Profile is rendered, **Then** only that accepted narrative appears.
3. **Given** a domain is `bounded` and no accepted narrative exists, **When** the retained Profile is rendered, **Then** its heading is omitted and no placeholder is written, while frontmatter still records `bounded`.
4. **Given** a domain is `not_discussed`, **When** the retained Profile is rendered, **Then** its heading and any placeholder are omitted, while its key remains in the `domains` mapping.
5. **Given** no accepted Context child exists, **When** the retained Profile is rendered, **Then** `## Context` is omitted. When some children exist, only those children appear, in the defined order, after any rendered domain narratives.
6. **Given** any combination of domain states, **When** the retained Profile is rendered, **Then** `# Organizational Profile` is present.

---

### User Story 3 - Complete a Profile without duplicated instructions (Priority: P1)

A person using the Profile skill can still supply evidence, answer the established fallback questions, accept or bound each domain, reuse accepted evidence across domains, and persist a Profile. The skill no longer repeats the record's structure or the generic collaboration lifecycle.

**Why this priority**: Shortening the skill is valuable only if acquisition, expression, domain meaning, persistence, and guided completion still work.

**Independent Test**: Walk a new repository through guided Profile completion using the amended skill plus the cited template and Experience Standard, and confirm each current capability still has an owner.

**Acceptance Scenarios**:

1. **Given** a repository with no retained Profile, **When** the user runs guided setup, **Then** the skill still establishes Repository Name before ordinary domain development, acquires available evidence, and persists only after acceptance.
2. **Given** accepted evidence that is relevant to more than one unresolved domain, **When** the skill continues, **Then** it evaluates that evidence across those domains instead of asking the person to recreate it.
3. **Given** Identity is materially assembled from discovery, imported material, multiple sources, or substantial interpretation, **When** no equivalent breadth opportunity has occurred, **Then** the skill still offers that breadth opportunity.
4. **Given** the user supplies a domain-complete Identity that the skill does not materially reshape, **When** that Identity is validated, **Then** the skill may proceed directly without forcing the breadth opportunity.
5. **Given** the amended skill, **When** a reviewer searches it for the retained heading skeleton or a generic collaboration tutorial, **Then** those concerns are cited from their owners rather than restated.

---

### User Story 4 - Project only broad Competitive Path meaning (Priority: P1)

A person can mention a safeguard, operational expectation, architecture detail, or implementation detail while discussing the broad approach. The skill keeps only the broad strategic meaning, and only when that meaning changes the path. The downstream specification itself is not developed or retained as Profile evidence.

**Why this priority**: The current skill allows volunteered downstream detail to be used as Competitive Path evidence and also contains a malformed persistence sentence. Both leave the contract ambiguous.

**Independent Test**: Volunteer downstream detail that does not change the broad approach and confirm it stays outside Competitive Path. Then accept a Profile change and confirm the mutation succeeds before any dependent readiness, completion, or owner result.

**Acceptance Scenarios**:

1. **Given** volunteered downstream detail that changes the broad organizational approach, **When** Competitive Path is developed, **Then** only that broad strategic meaning is incorporated.
2. **Given** volunteered downstream detail that does not change the broad approach, **When** Competitive Path is developed, **Then** the detail remains outside Competitive Path and is not refined, validated, or retained as Profile evidence.
3. **Given** the user accepts a Profile change, **When** the skill finishes the operation, **Then** acceptance authorizes the mutation but is not successful persistence, and a dependent result is returned only after the mutation succeeds.
4. **Given** a retained Profile whose schema is `2.0.0` or whose record is malformed, **When** readiness is evaluated, **Then** the result is blocked, has no next action, and does not mutate the artifact.

---

### Edge Cases

- A bounded domain has an explicit boundary but no accepted narrative: frontmatter remains `bounded`, and the body heading is omitted.
- All four domains are `not_discussed`: the title and all four `domains` keys remain, and no domain heading, placeholder, or Context section is written.
- Context has values for only the first and last children: `## Context` is present, only those two children are present, and they stay in the defined order.
- Volunteered architecture detail reveals a sequencing choice: the sequencing meaning may enter Competitive Path, while the architecture specification does not.
- The user directly completes one domain and leaves another `not_discussed`: readiness remains missing configuration rather than complete.
- A schema `2.0.0` record is identifiable but is not a current Profile: it is blocked and is not migrated, rewritten, or used as a fallback.
- A literal break marker appears in Vision or Competitive Path prose: it is replaced with normal spacing without changing the paragraph's meaning.
- A reviewer tries to relocate the retained Profile because a brief quoted a different filename: the retained path stays `.highway/library/knowledge/profile.md`.

## Requirements *(mandatory)*

### Functional Requirements

#### Profile record template

- **FR-001**: The shared Profile record template MUST make the complete retained Profile structure visible. A reader MUST be able to reconstruct that structure from the template alone.
- **FR-002**: The template MUST keep its identity and metadata at the top, then show retained frontmatter under `## File Frontmatter`, then the permitted body under `## Body`, then concise conditional-rendering semantics. Those section headings MUST match the other retained-record templates. The third-level labels in the conceptual sketch are not the template's section headings.
- **FR-003**: The template description MUST be "Complete output skeleton for retained organizational Profile evidence."
- **FR-004**: Template name, description, template version, instructions, placeholders, and rendering explanations MUST NOT be copied into the retained Profile. The template MUST state that template metadata describes the template and is not retained Profile content, and that the retained artifact contains only its retained frontmatter, `# Organizational Profile`, permitted accepted domain narratives, and permitted accepted optional Context.
- **FR-005**: The visible retained frontmatter skeleton MUST be `schema_version: 3.0.0` and a `domains` mapping containing exactly `identity`, `vision`, `competitive_path`, and `guiding_principles`.
- **FR-006**: Each domain value MUST be exactly one of `not_discussed`, `discussed`, or `bounded`. The template MUST NOT add or rename domain states or domain keys.
- **FR-007**: The visible body skeleton MUST use `# Organizational Profile`, then `## Who We Are`, `## Where We're Going`, `## How We Plan to Get There`, and `## What Guides Our Decisions`, in that order. These headings MUST remain the retained domain headings.
- **FR-008**: The skeleton MUST show optional `## Context` after the domain headings, with optional children in this order: `### Repository Name`, `### Organization Name`, `### Organization URL`, and `### Organizational Context`.
- **FR-009**: The template MUST state that the domain headings define the permitted retained narrative sections and their ordering, and that a domain heading is rendered only when its state permits narrative. `discussed` means accepted narrative exists and renders. `bounded` means the person explicitly bounded the domain, and accepted narrative renders only when accepted evidence exists. `not_discussed` renders no narrative section. The template MUST NOT require a bounded narrative for structural symmetry, and MUST NOT emit an empty domain heading or placeholder.
- **FR-010**: All four domain keys MUST remain in the retained `domains` mapping whether or not their narrative sections render. A `bounded` domain MUST remain `bounded` even when no accepted narrative exists.
- **FR-011**: `# Organizational Profile` MUST always be present. Conditional rendering MUST NOT apply to the title.
- **FR-012**: `## Context` MUST be optional, MUST follow all rendered domain narratives, and MUST be omitted when no Context child has accepted content. Within Context, only accepted children render. Absent children are omitted without changing the relative order of the remaining children. Context headings are not domain keys and do not create readiness dimensions.
- **FR-013**: Rendered domain sections MUST keep the heading order in FR-007 regardless of acquisition order, conversational order, update order, which domain changed most recently, or narrative size.
- **FR-014**: The template MUST NOT use conversational subject headings, including `### Where you're going`, `### How you'll get there`, and `### What will guide your decisions`, as retained headings.
- **FR-015**: The template MUST NOT add Highway Role, acquisition sources, provenance, website evidence, assistant-export metadata, source precedence, tone, voice, style, persona, terminology guidance, Identity facets, business lines, products, services, audiences, technology or platform inventory, Working Idea state, Active Reasoning Context, clarification state, or Contribution Opportunity state. It MUST NOT add provenance sections such as Sources, Website Evidence, Imported Context, Assistant Context, or Acquisition History.
- **FR-016**: The template MUST NOT describe how Profile asks questions, acquires evidence, develops domains, handles Working Ideas or contributions, accepts artifacts, evaluates readiness, orchestrates setup, or sequences persistence.
- **FR-017**: The template MUST NOT restate generic retained-artifact or shared-output governance. Structural semantics MUST stay concise and next to the skeleton, and MUST NOT replace the hidden comment with another large explanation.
- **FR-018**: The template's own version MUST be independent of retained `schema_version`. This feature MUST NOT change retained `schema_version` from `3.0.0`.
- **FR-019**: Updating the template MUST NOT be satisfied by amending the Profile skill, and amending the skill MUST NOT be satisfied by updating the template.

#### Profile skill

- **FR-020**: The amendment baseline MUST be Profile skill version 6.0.0. The result MUST be materially shorter without a fixed length target, and MUST preserve current Profile capabilities rather than reduce them.
- **FR-021**: The skill MUST keep the retained artifact at `.highway/library/knowledge/profile.md` and MUST keep the statement that its complete reusable structure is owned by the Profile record template. It MUST NOT reproduce that structural skeleton. It MUST keep Profile-owned readiness semantics.
- **FR-022**: The Profile model MUST replace its structural opening with: "The retained Profile follows the complete structure in .highway/library/templates/output/profile-record.md. Profile owns the meaning, evidence, state, and readiness of Identity, Vision, Competitive Path, and Guiding Principles. Accepted evidence that establishes a domain sets it to discussed; an explicit user boundary may set an otherwise unresolved domain to bounded. Optional Context does not change readiness. Schema 2.0.0 is Blocked and left unchanged."
- **FR-023**: The skill MUST replace generic collaboration tutorial text with: "Profile uses the collaborative-development model defined by the Highway Experience Standard. Working Ideas, Substantive Contributions, Conversational Clarification, Contribution Opportunities, Converged Proposals, and their interaction boundaries follow that shared contract. Profile defines what constitutes a complete candidate for each Profile domain and the Profile-specific evidence, readiness, persistence, and downstream ownership boundaries below."
- **FR-024**: The skill MUST preserve Profile-specific Contribution Opportunity exceptions: a materially Profile-shaped domain may require one; a user-supplied domain-complete Identity that Profile does not materially reshape may proceed directly; and materially assembled Identity receives its breadth opportunity unless an equivalent opportunity already occurred. Generic Contribution Opportunity lifecycle explanations MUST NOT be restated.
- **FR-025**: The skill MUST preserve Repository Name bootstrap, existing-context acquisition, public-website acquisition, organizational-description and strategy-material acquisition, assistant export or summary acquisition, schema-agnostic imported material, evaluation of one source across unresolved domains, evaluation of supplied evidence before asking the person to recreate it, exclusion of unspecified prior-agent or model memory, and the limit that acquisition remains organizational rather than technology-platform discovery.
- **FR-026**: The skill MUST remove the duplicate sentence "Website acquisition is limited to evidence relevant to the organizational Profile." and MUST keep "Website and imported-source acquisition are limited to evidence relevant to the organizational Profile."
- **FR-027**: The skill MUST keep one concise statement that website-derived and imported organizational information remains proposed until the applicable Profile acceptance boundary is crossed. Supplying an Organization URL MUST NOT accept facts derived from that website. Repository Name MUST NOT be invented into, or automatically treated as, Organization Name. Acquisition sources MUST remain optional and MUST NOT affect readiness.
- **FR-028**: Once evidence crosses the applicable acceptance boundary, later reasoning MUST NOT assign different authority solely because it came from a website, imported material, or direct conversation. The skill MUST NOT create retained source-precedence state or an acquisition log.
- **FR-029**: The skill MUST preserve organizational expression as transient representation guidance: source terminology may influence wording, the person's active wording and corrections remain authoritative, and expression does not control other owners. It MUST keep the boundary that tone, style, phrasing, terminology, or communication patterns are not evidence that a substantive organizational claim is true. Transient expression guidance MUST NOT be stored as Organizational Context.
- **FR-030**: The Enrichment opening MUST be replaced with: "Optional enrichment may continue after a domain is discussed or bounded and does not change readiness by itself. User-visible collaborative behavior follows the Highway Experience Standard. Profile-specific enrichment remains transient unless the person incorporates it into accepted Profile evidence."
- **FR-031**: The skill MUST keep the rule that a domain is ready to become a Converged Proposal when accumulated evidence supports one coherent organizational narrative that meaningfully answers the domain's purpose without unsupported facts. It MUST NOT prolong a domain merely to collect more detail, and MUST NOT introduce internal completeness matrices or category-coverage questions.
- **FR-032**: Canonical fallback questions MUST remain exactly: "What does [Organization Name] do?", "What is the future vision of [Organization Name]?", "How does [Organization Name] plan to get there?", and "What principles or values guide decisions at [Organization Name]?" They remain fallbacks, not a mandatory sequence.
- **FR-033**: The skill MUST keep the rule that acquired, direct, and newly supplied substantive evidence is evaluated across all unresolved Profile domains before the next Profile behavior is selected. Accepted Identity informs Vision; Identity and Vision inform Competitive Path; and Identity, Vision, and Competitive Path inform Guiding Principles, as compounding context rather than recall alone.
- **FR-034**: Conversational subject headings `### Where you're going`, `### How you'll get there`, and `### What will guide your decisions` MUST remain presentation transitions and MUST NOT be specified as retained headings.
- **FR-035**: The skill MUST preserve the current domain meanings and Profile-specific validation wording: Identity is who the organization is and what it meaningfully encompasses; Vision is the future the organization is trying to create; Competitive Path is the broad approach toward the accepted Vision; Guiding Principles are the enduring principles that should shape decisions. It MUST preserve the illustrative Identity breadth pattern and Guiding Principles provisional pattern as illustrative wording, and MUST preserve the current accuracy questions and "you can also change it" follow-ups.
- **FR-036**: Vision MUST reason from the full accepted Identity when that Identity contains multiple meaningful activities. One prominent facet MUST NOT become the whole Vision merely because it is the easiest continuation. A Vision question MUST concern only unresolved information capable of changing the desired future.
- **FR-037**: The skill MUST replace the current volunteered-downstream-detail language with: "When the person volunteers a safeguard, operational expectation, architecture detail, implementation detail, or other downstream-owned information while developing Competitive Path, re-evaluate what that information reveals about the organization's broad approach. Incorporate only that broad strategic meaning into Competitive Path when it changes the path. Do not develop, refine, recommend, validate, or retain the downstream-owned detail itself as Profile evidence solely because it was volunteered. When the detail does not change the broad organizational approach, leave it outside Competitive Path."
- **FR-038**: Competitive Path MUST NOT ask for or develop enforceable safeguards, Controls, Non-Functional Requirements, operational requirements, detailed implementation requirements, architecture, or implementation plans. A Guiding Principle MUST NOT be turned into an enforceable Control merely to make it more precise.
- **FR-039**: Literal `<br>` separators in the Vision and Competitive Path paragraphs MUST be replaced with normal spacing without changing those paragraphs' meaning.
- **FR-040**: The skill MUST remove the generic contextual-re-evaluation tutorial and replace it with: "Evaluate new substantive organizational evidence for relevance across every unresolved Profile domain before selecting the next Profile behavior." It MUST replace generic clarification mechanics with: "Profile uses shared Conversational Clarification when consequential uncertainty in organizational evidence requires the person's information. Ordinary Profile clarification remains transient and does not invoke the persisted highway-clarify capability unless that separate capability is explicitly requested."
- **FR-041**: The skill MUST remove the generic local collaboration-lifecycle diagram and generic recommendation, Working Idea, and acceptance tutorials already owned by the Experience Standard. It MUST preserve the person's ability to supply, correct, reject, or replace domain content.
- **FR-042**: The skill MUST keep only this acceptance-plus-new-information rule: "New substantive organizational evidence supplied with acceptance does not silently rewrite previously accepted Profile knowledge; changing accepted domain content still uses the Profile owner's change path."
- **FR-043**: The skill MUST NOT store small-business, enterprise, maturity, persona, or advisory classifications, and MUST NOT add platform, application, hosting, provider, or implementation-technology inventories.
- **FR-044**: Readiness MUST remain ordered: no retained Profile is `Missing` with next action `/highway-profile setup`; an unsupported or malformed Profile, including schema `2.0.0`, is `Blocked` with next action `None` and no mutation; any `not_discussed` domain is `Missing` with next action `/highway-profile configure`; all four domains `discussed` or `bounded` is `Complete` with next action `None`. Optional Context and enrichment MUST NOT affect readiness.
- **FR-045**: Schema `2.0.0` MUST remain blocked and unchanged. Obsolete YAML Profile content MUST remain excluded as a source, fallback, authority, migration input, and mutation target. The skill MUST NOT add migration.
- **FR-046**: The persistence core MUST be replaced with: "After acceptance changes retained Profile state, perform the accepted Profile mutation before any behavior that depends on that accepted knowledge. Acceptance authorizes the mutation but is not successful persistence. Return dependent readiness, completion, or another owner result only after the mutation succeeds." The skill MUST keep the rule that the final accepted domain mutation is persisted before guided completion synthesis. It MUST NOT restore post-write persistence verification.
- **FR-047**: Retained-content guidance MUST be replaced with: "Retain only accepted cohesive domain narrative, accepted explicit corrections or replacements, accepted explicit domain boundaries, and optional Context permitted by profile-record.md." Working Ideas, rejected alternatives, unaccepted advisory commentary, conversational subject headings, internal reasoning constructs, and transient expression guidance MUST remain outside retained content.
- **FR-048**: Guided completion synthesis MUST occur only after required accepted mutations succeed. It MUST use the accepted Organization Name when available, summarize accepted organizational direction, connect that understanding to later guidance, and include no machine-status fields, owner-result mechanics, implementation detail, or new question.
- **FR-049**: Verification MUST be reduced to Profile-specific checks for output and readiness, acquisition, organizational expression, each domain's meaning and boundary, cross-domain compounding, persistence, and completion. It MUST include both decisive checks: volunteered downstream-owned information appears in Competitive Path only through the broad strategic meaning it establishes, and Profile does not develop or retain the downstream specification itself; and a volunteered safeguard, operational expectation, architecture detail, or implementation detail that does not change the broad approach remains outside Competitive Path.
- **FR-050**: Verification MUST require conformance to the Profile record template and MUST NOT separately verify retained heading order, Context child order, conditional section rendering, or retained frontmatter ordering. It MUST NOT restate generic Experience Standard checks for Working Ideas, Contribution Opportunity, one-question behavior, clarification, re-evaluation, acceptance, recommendations, brevity, or Converged Proposal mechanics.
- **FR-051**: Error handling MUST keep only the Profile-specific cases: unsupported schema including `2.0.0` is blocked without mutation; obsolete YAML is ignored and never used as fallback or migration input; malformed retained Profile is blocked without mutation; and a failed accepted mutation means the affected domain is not established as persisted and dependent progression stops, including a Setup-advancing terminal result.
- **FR-052**: The skill change MUST be classified under the Skill Versioning Policy as MAJOR, from 6.0.0 to 7.0.0. Replacing the volunteered-downstream rule narrows the existing guarantee that such detail may be used as Competitive Path evidence, and replacing Verification is not a wording-only patch.
- **FR-053**: The skill amendment MUST NOT change retained `schema_version` from `3.0.0` and MUST NOT modify the Experience Standard, constitution, setup skill, objectives, controls, or NFRs.

### Key Entities

- **Profile Record Template**: The shared structural authority for a retained organizational Profile. It shows template identity, the retained frontmatter skeleton, the permitted body skeleton, and the omission rules. It does not own workflow.
- **Retained Profile**: The accepted organizational record at `.highway/library/knowledge/profile.md`. It contains schema version, the four domain states, the title, accepted domain narratives, and any accepted Context children.
- **Domain Outcome**: One of `not_discussed`, `discussed`, or `bounded` inside the retained `domains` mapping. The outcome controls whether a body heading exists; it does not remove the key.
- **Context Child**: Optional accepted Repository Name, Organization Name, Organization URL, or Organizational Context. Context does not affect readiness.
- **Profile Skill**: The capability that acquires evidence, decides domain meaning and completeness, classifies readiness, and persists accepted Profile knowledge. It cites structural and generic collaboration owners instead of copying them.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A reviewer given only the Profile record template can correctly reconstruct retained frontmatter, allowed domain values, heading order, and omission rules in one pass.
- **SC-002**: In a review set covering discussed, bounded with narrative, bounded without narrative, not discussed, and partial Context, every retained Profile matches the rendering rules with no placeholder text and no missing `domains` key.
- **SC-003**: A capability review finds each preserved capability still specified by the skill or explicitly owned by a cited document: acquisition, expression, Identity breadth, Vision, Competitive Path, Guiding Principles, cross-domain reuse, persistence, and guided completion.
- **SC-004**: The amended skill no longer contains the duplicate website-only acquisition sentence, a literal `<br>` separator in the repaired Vision or Competitive Path prose, or the malformed persistence fragment.
- **SC-005**: In a Competitive Path exercise, downstream detail that does not change the broad approach leaves both the domain state and accepted narrative unchanged, and no downstream specification is retained.
- **SC-006**: For a blocked schema `2.0.0` or malformed record, readiness names the blocked condition, offers no next action, and leaves the artifact unchanged.
- **SC-007**: The published skill version is 7.0.0, the retained schema version remains 3.0.0, and the template version is incremented independently from the schema version.
- **SC-008**: The amended skill is materially shorter than version 6.0.0, and a comparison of protected governance and neighboring capability documents shows no edits caused by this feature.

## Assumptions

- Template section headings are confirmed as `## File Frontmatter` and `## Body`, matching the other retained-record templates. Template identity remains YAML frontmatter. The conceptual sketch's third-level labels are not section headings. Retained Context children remain third-level headings inside the body skeleton.
- The retained artifact path is confirmed as `.highway/library/knowledge/profile.md`. The quoted `.highway/library/knowledge/highway-profile` filename is not a relocation target.
- No separate library-template versioning policy was found. Because the retained field contract continues to hold while the template gains a visible complete skeleton and a more precise description, the template metadata version is assumed to increment MINOR from 3.0.0 to 3.1.0. That number is independent of retained `schema_version: 3.0.0`.
- The current skill says volunteered downstream detail may be used as evidence of the broad Competitive Path, while not retaining that detail as a safeguard, requirement, architecture, or implementation item. The replacement rule narrows that guarantee to broad strategic meaning that changes the path. Under the Skill Versioning Policy, that narrowing, together with replacement of Verification, is MAJOR from 6.0.0 to 7.0.0.
- Removing restated template structure and generic Experience Standard behavior does not remove those requirements. They remain owned by the cited documents.
- Skill amendments remain subject to the repository constitution, including skill-size and normative-language limits. This feature does not authorize adding normative markers to the skill to replace removed text.
- No extension hooks are registered for specification generation.
