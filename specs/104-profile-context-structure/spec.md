# Feature Specification: Organize Profile Context

**Feature Branch**: `104-profile-context-structure`

**Created**: 2026-09-29

**Status**: Draft

**Input**: User description: "Reorganize highway-profile so Profile-specific behavior is separated from restated Experience Standard rules. Give the shared Profile record an optional Context section for accepted repository name, organization name, organization URL, and other organizational context. Keep four readiness domains, schema 3.0.0, and the current skill version unless the version policy requires an increment."

## Background

Profile already uses four readiness domains: Identity, Vision, Competitive Path, and Guiding Principles. Repository Name, Organization Name, Organization URL, and additional organizational context are optional and do not affect readiness. The skill version is 4.0.0. The shared record schema is 3.0.0. Highway Role is already outside Profile. Schema 2.0.0 is already unsupported and is left unchanged.

The skill still gathers that behavior in one dense Evidence section. That section repeats interaction rules the Highway Experience Standard already owns, including one question at a time, why a question matters, examples, accepting a selected recommendation, extra confirmation, and how destructive confirmation is presented. The shared record mentions optional context only as guidance. It does not own the reusable Context structure a retained Profile should follow.

## Clarifications

### Session 2026-09-29

- Q: Should the Profile Experience section keep the two sentences it already uses, or become one new sentence? → A: Replace them with one sentence that only says user-visible interaction follows the Highway Experience Standard.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Profile behavior is easier to follow (Priority: P1)

As a person working with Profile, I want the skill to separate the record model, acquisition, enrichment, and operations, so that I can see what Profile owns without rereading interaction rules that already live in the Experience Standard.

**Why this priority**: The dense Evidence section is what a person and an agent follow. Splitting it, and removing duplicated interaction rules, is the behavior change this feature exists to make.

**Independent Test**: The Profile skill presents Profile model, Acquisition, Enrichment, and Operations as separate sections. It still states the repository-name opening, website acquisition, the four canonical questions, the enrichment categories, the acceptance boundary, and the four-domain readiness result. It does not restate one-question behavior, why-it-matters presentation, example behavior, recommendation-selection acceptance, redundant confirmation, or destructive-confirmation presentation. The Experience section is exactly `User-visible interaction follows the Highway Experience Standard.`

**Acceptance Scenarios**:

1. **Given** the Profile skill, **When** its behavior sections are read, **Then** they are Profile model, Acquisition, Enrichment, and Operations, and the former single Evidence block is gone.
2. **Given** the Profile skill, **When** those sections are read, **Then** they do not restate one-question-at-a-time behavior, `**Why it matters:**` presentation, example behavior, acceptance of a selected recommendation, a redundant confirmation rule, or destructive-confirmation presentation.
3. **Given** the Profile skill, **When** Acquisition is read, **Then** it still contains the exact repository-name question and hint, the website trust boundary, and the four canonical questions.
4. **Given** the Profile skill, **When** Enrichment is read, **Then** the Vision, Competitive Path, and Guiding Principles categories are present, are not stored, and do not block completion.
5. **Given** the Profile skill, **When** the Experience section is read, **Then** it is exactly `User-visible interaction follows the Highway Experience Standard.` and it does not contain the former authority sentence or the rules removed from Evidence.
6. **Given** the Profile skill, **When** Error Handling is read, **Then** it still records only the Profile-specific exceptions and does not add the common failure model.

---

### User Story 2 - Acquisition follows one order (Priority: P1)

As a person setting up Profile, I want Highway to classify what I already have, ask for a repository name when I have not given one, use a public website when that help is available, and only then ask the first unanswered domain question, so that I am not asked for something already known.

**Why this priority**: The order changes what the person sees next. It can be checked without the template heading change.

**Independent Test**: Acquisition is described in the eight-step order below. Accepted evidence is reused across all four domains. An unresolved domain is asked only after that reuse. Optional enrichment does not block readiness.

**Acceptance Scenarios**:

1. **Given** Profile acquisition, **When** the skill states the order, **Then** the order is: classify the retained Profile; establish Repository Name when it is missing; use supported existing-information or website acquisition when available; reuse accepted or accepted-discovered evidence across all four domains; ask the first unresolved canonical domain question; use optional grounded enrichment where useful; persist accepted evidence; report readiness.
2. **Given** a repository name has not been accepted, **When** acquisition continues past classification, **Then** the next step establishes Repository Name before a domain question.
3. **Given** accepted or accepted-discovered evidence already settles a domain, **When** the next question is chosen, **Then** that domain is not asked.
4. **Given** public-website retrieval is available, **When** acquisition reaches existing-information help, **Then** the person is asked for the public website using the accepted Repository Name, the supplied URL is accepted context, and website-derived Organization Name and other website-derived facts stay proposed until accepted.
5. **Given** website retrieval is unavailable, **When** acquisition continues, **Then** ordinary Profile acquisition continues and the missing capability is not mentioned.
6. **Given** a domain is already `discussed` or `bounded`, **When** useful enrichment is available, **Then** enrichment may continue and its absence does not keep Profile from Complete.

---

### User Story 3 - Optional context has one home (Priority: P1)

As a person whose Profile is retained, I want accepted names and website details kept in an optional Context section, so that those facts are available later without counting toward readiness.

**Why this priority**: The shared record is what later Highway work reads. Context has to live there, separate from the four domains.

**Independent Test**: The shared Profile record owns an optional Context section after any readiness narratives. Child sections appear only for accepted values. A record with no accepted optional context omits Context entirely. Readiness still depends only on the four domains. The record schema and template version stay 3.0.0.

**Acceptance Scenarios**:

1. **Given** accepted Repository Name, Organization Name, Organization URL, or additional organizational context, **When** the Profile is retained, **Then** those values appear under `## Context` as `### Repository Name`, `### Organization Name`, `### Organization URL`, and `### Organizational Context`, and only the accepted children are present.
2. **Given** no accepted optional context, **When** the Profile is retained, **Then** `## Context` and every child section are omitted, and no placeholder is written.
3. **Given** one accepted optional value and three absent ones, **When** the Profile is retained, **Then** Context contains only the accepted child.
4. **Given** Context is present or absent, **When** readiness is assessed, **Then** Status does not change because of Context.
5. **Given** a readiness domain is `not_discussed`, **When** the record is written, **Then** that domain has no narrative. **Given** it is `discussed`, **Then** it has an accepted narrative. **Given** it is `bounded`, **Then** it may have an accepted narrative and has none when no accepted evidence exists.
6. **Given** the shared record, **When** its versions are read, **Then** the template version and schema version remain 3.0.0, and Highway Role remains absent.

---

### User Story 4 - Profile documents agree (Priority: P2)

As a person reading Profile guidance, I want the skill to point at the shared record for Context structure, so that two documents do not describe two different layouts.

**Why this priority**: Agreement matters after the skill and the record have both changed. The skill can be understood before this citation is tightened.

**Independent Test**: The Profile skill cites the shared record for the optional Context structure and does not restate that heading skeleton. A current Highway Profile Intent Summary, when one exists, no longer describes five domains, Highway Role, schema 2.0.0 as current, or persistence verification. Brownfield onboarding is not edited.

**Acceptance Scenarios**:

1. **Given** the Profile skill, **When** it describes optional context, **Then** it cites the shared Profile record for the Context structure and does not repeat that heading skeleton.
2. **Given** a current document titled Highway Profile Intent Summary, **When** this feature is complete, **Then** that document describes four readiness domains, no Highway Role, schema 3.0.0, and no persistence-verification step.
3. **Given** a Brownfield Onboarding Idea that still lists five Profile domains including Highway Role, **When** this feature is complete, **Then** that idea is unchanged and remains for a later review.
4. **Given** Profile, **When** its scope is read, **Then** it does not collect a technology or platform inventory.

---

### Edge Cases

- A schema 3.0.0 Profile with no Context section remains a valid Profile and is not rewritten only to add an empty Context section.
- A schema 2.0.0 Profile stays Blocked and unchanged.
- Website-derived Organization Name that the person has not accepted does not appear under Context.
- A user-supplied Organization URL is accepted Context even when other website-derived facts are still only proposed.
- A `bounded` domain with no accepted narrative omits that narrative and does not use a placeholder.
- Optional enrichment with no useful recommendation does not block Complete when all four domains are `discussed` or `bounded`.
- Profile does not gain a technology, platform, approved-technology, or prohibited-technology inventory.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: highway-profile MUST keep exactly four readiness domains: Identity, Vision, Competitive Path, and Guiding Principles. Highway Role MUST remain outside Profile.
- **FR-002**: Repository Name, Organization Name, Organization URL, and additional Organizational Context MUST remain optional. Their presence or absence MUST NOT determine Profile readiness.
- **FR-003**: The skill MUST replace the single Evidence section with Profile model, Acquisition, Enrichment, and Operations.
- **FR-004**: Those sections MUST NOT restate one-question-at-a-time behavior, `**Why it matters:**` presentation, example behavior, recommendation-selection acceptance, redundant-confirmation rules, or destructive-confirmation presentation. Those rules MUST remain in the Highway Experience Standard, cited by the skill.
- **FR-005**: The skill MUST keep the exact Repository Name opening: `**What would you like to call your Highway repository?**` and `If you're using Highway for a company or organization, its name is usually a good choice.`
- **FR-006**: Acquisition MUST follow this order: classify the retained Profile; establish Repository Name when missing; use supported existing-information or website acquisition when available; reuse accepted or accepted-discovered evidence across all four domains; ask the first unresolved canonical domain question; use optional grounded enrichment where useful; persist accepted evidence; report readiness.
- **FR-007**: A user-provided Organization URL MUST be accepted context. Website-derived Organization Name and other website-derived facts MUST stay proposed until accepted. When retrieval is unavailable, Profile MUST continue with ordinary acquisition and MUST NOT mention the missing capability.
- **FR-008**: An unresolved domain MUST keep its canonical question: Identity `**What does [Organization Name] do?**`; Vision `**What is the future vision of [Organization Name]?**`; Competitive Path `**How does [Organization Name] plan to get there?**`; Guiding Principles `**What principles or values guide decisions at [Organization Name]?**`. When Organization Name is not accepted, the accepted Repository Name MUST be used where it reads naturally. A domain already established by accepted or active evidence MUST NOT be asked.
- **FR-009**: Enrichment categories MUST stay internal and MUST NOT be persisted. Vision categories remain Future State, Impact, Reach / Scale, Position, and Experience / Reputation. Competitive Path categories remain Customer / Participant, Offering, Market / Reach, Differentiation, Operations, and Capability Development. Guiding Principles categories remain People, Trust, Quality, Simplicity, Change, Stewardship, and Autonomy. Optional enrichment MUST NOT block completion. Coverage of every category MUST NOT be required.
- **FR-010**: Profile MUST keep ownership of its evidence, artifact, domain state, and readiness. Profile MUST persist only user-provided or user-accepted organizational evidence. Foundational Highway context MUST NOT become organizational evidence.
- **FR-011**: Error Handling MUST remain limited to the existing Profile-specific exceptions: an unsupported schema, including schema 2.0.0, is Blocked and is not mutated; an obsolete YAML Profile is ignored and is never a fallback or a migration input; a malformed retained Profile is Blocked and is not mutated. The skill MUST NOT add generic failure handling already governed by the Skills Constitution.
- **FR-012**: The Experience section MUST be exactly `User-visible interaction follows the Highway Experience Standard.` It MUST NOT include the former sentence that the Experience Standard remains the normative authority, and it MUST NOT grow into a second copy of interaction rules.
- **FR-013**: The shared Profile record MUST keep template version 3.0.0 and schema version 3.0.0. It MUST keep the readiness fields `identity`, `vision`, `competitive_path`, and `guiding_principles`, and MUST keep `highway_role` removed.
- **FR-014**: The shared record MUST own this optional body structure after any readiness-domain narratives: `## Context`, then `### Repository Name`, `### Organization Name`, `### Organization URL`, and `### Organizational Context`. The document title MUST remain `# Organizational Profile`. Domain narratives MUST keep their existing headings.
- **FR-015**: `## Context` and each child section MUST be omitted when no accepted value exists. An empty section or placeholder MUST NOT be emitted.
- **FR-016**: The shared record MUST state, concisely, that domain narratives contain only accepted evidence; `not_discussed` has no narrative; `discussed` has an accepted narrative; `bounded` may have an accepted narrative; optional Context contains only user-provided or user-accepted information; and absent optional context is omitted.
- **FR-017**: The shared record MUST remain responsible for structure only. It MUST NOT define the meaning, quality, discovery, recommendation, or acceptance of organizational evidence.
- **FR-018**: The Profile skill MUST cite the shared record for the optional Context structure and MUST NOT restate that heading skeleton.
- **FR-019**: A current Highway Profile Intent Summary, when one is present, MUST be updated so it no longer describes five domains, Highway Role, schema 2.0.0 as the current schema, or the former persistence-verification model.
- **FR-020**: Profile MUST NOT become a technology or platform inventory. Changing technology and platform knowledge MUST remain with the future brownfield architecture and onboarding model.

### Key Entities

- **Profile**: The retained organizational record. It holds four readiness domains and any accepted Context.
- **Readiness domain**: Identity, Vision, Competitive Path, or Guiding Principles. Each is `not_discussed`, `discussed`, or `bounded`.
- **Context**: Optional accepted facts for Repository Name, Organization Name, Organization URL, and additional organizational context. Context does not affect readiness.
- **Enrichment category**: An internal grounding label. It is not stored on the Profile.
- **Readiness result**: Status, Summary, Next Action, and Blocking Reason, decided only by the retained record and the four domains.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The Profile skill has four behavior sections, Profile model, Acquisition, Enrichment, and Operations, and zero restatements of one-question behavior, why-it-matters presentation, example behavior, recommendation-selection acceptance, redundant confirmation, or destructive-confirmation presentation. The Experience section is the single sentence `User-visible interaction follows the Highway Experience Standard.`
- **SC-002**: Acquisition states the eight-step order, and a settled domain is not asked again.
- **SC-003**: A retained Profile with no accepted optional context contains zero Context headings and zero placeholders.
- **SC-004**: A retained Profile with one accepted optional value contains Context and exactly one child section.
- **SC-005**: Readiness outcomes for absent, unsupported, incomplete, and complete Profiles stay the same whether Context is present or absent.
- **SC-006**: The shared record stays at template version 3.0.0 and schema version 3.0.0, and the Profile skill stays at version 4.0.0.
- **SC-007**: Zero in-scope current Profile documents describe five readiness domains, Highway Role, schema 2.0.0 as current, or persistence verification. The Brownfield Onboarding Idea is not one of those documents.

## Assumptions

- The Skill Versioning Policy does not require a skill increment. Reorganizing sections and removing duplicated interaction rules leaves readiness, the canonical questions, the website trust boundary, acceptance, operations, inputs, and outputs in force. The skill stays at 4.0.0.
- The shared-record version stays 3.0.0. Optional Context does not change the four domain outcomes. A schema 3.0.0 record with no Context section still conforms, so the addition does not invalidate a current record and does not change `schema_version`. The user's `## Organizational Profile` label is the existing document title, which remains the level-one heading `# Organizational Profile`.
- The Experience section replaces both current sentences. Checks that still require the Profile skill to say the Experience Standard remains the normative authority are updated with this change. The Experience Standard itself is not amended.
- The former sibling headings `## Repository Name`, `## Organization Name`, `## Organization URL`, and `## Organizational Context` are replaced by the Context group. Checks that still require those sibling headings, or that still require the removed interaction restatements inside the Profile skill, are updated with this change.
- No document titled Highway Profile Intent Summary is in the repository today. This feature updates that document when it is present and does not create it.
- Brownfield Onboarding Idea is reviewed later. This feature does not edit it.
- The Experience Standard and the Skills Constitution are not amended.
- Shipped copies of the Profile skill stay aligned with the source skill.
- A failed mutation is still not reported as success under the common failure model. That model is not copied into the skill again.
