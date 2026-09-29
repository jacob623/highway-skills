# Feature Specification: Simplify the Profile Skill

**Feature Branch**: `103-simplify-profile-skill`

**Created**: 2026-09-29

**Status**: Draft

**Input**: User description: "Rewrite highway-profile around Profile-specific behavior. Cite the Experience Standard for shared interaction. Reduce readiness to Identity, Vision, Competitive Path, and Guiding Principles. Remove Highway Role. Add optional context, a fixed first question, website-assisted acquisition, canonical questions, and internal enrichment categories. Drop the validator, byte verification, and the eight-step workflow. Treat the skill and the Profile record as major version changes."

## Background

Profile is the retained organizational context later Highway work can reuse. The skill currently mixes that domain behavior with interaction rules the Experience Standard already owns, a numbered workflow, a per-step failure table, and a persistence check that verifies bytes after writing.

Readiness currently depends on five domains, including Highway Role. A person can finish the organizational story and still be incomplete because Highway's own role was not discussed. Optional facts such as the repository name, the organization name, and a public website have no accepted home that leaves readiness alone.

The current skill version is 3.0.0. The shared Profile record schema is 2.0.0. Removing a readiness domain is a breaking change to both the skill contract and the retained record.

## Clarifications

### Session 2026-09-29

- Q: What should happen to a retained Markdown Profile that is still schema 2.0.0 and includes Highway Role? → A: Profile is still in development, so no backward compatibility is required. Schema 2.0.0 is unsupported and is left unchanged. A new Profile is schema 3.0.0 and has no Highway Role.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Profile is four organizational domains (Priority: P1)

As a person setting up Highway, I want Profile to be complete when Identity, Vision, Competitive Path, and Guiding Principles are settled, so that Highway Role is no longer something I must discuss before Profile is ready.

**Why this priority**: The domain count is the breaking contract. Readiness, the retained record, and every document that still describes five domains depend on it.

**Independent Test**: A retained Profile with those four domains discussed or bounded is Complete. Highway Role does not appear in scope, discovery, readiness, the retained record, or verification. A Profile that still lacks one of the four domains is Missing.

**Acceptance Scenarios**:

1. **Given** no retained Profile, **When** readiness is assessed, **Then** Status is Missing, Next Action is `/highway-profile setup`, and Blocking Reason is None.
2. **Given** a retained Profile whose schema is unsupported or whose structure is malformed, **When** readiness is assessed, **Then** Status is Blocked, the Profile is not mutated, and Next Action is None.
3. **Given** any of the four domains is `not_discussed`, **When** readiness is assessed, **Then** Status is Missing and Next Action is `/highway-profile configure`.
4. **Given** all four domains are `discussed` or `bounded`, **When** readiness is assessed, **Then** Status is Complete, Next Action is None, and Blocking Reason is None.
5. **Given** Highway Role was previously a fifth domain, **When** Profile scope, discovery, readiness, persistence, and verification are read, **Then** Highway Role is absent from all five.
6. **Given** a retained Markdown Profile at schema 2.0.0, **When** readiness is assessed, **Then** Status is Blocked, the file is left unchanged, and Profile does not rewrite it as schema 3.0.0.

---

### User Story 2 - The repository name starts the conversation (Priority: P1)

As a person opening Profile for the first time, I want one clear question about what to call the repository, so that later questions can use a name I have already given.

**Why this priority**: The opening question is the first thing a person sees, and the name it captures is reused before any domain question.

**Independent Test**: First-time setup begins with the repository-name question and its company-name hint. The answer is kept as accepted optional context and appears in the next interaction. Profile is not Missing or Blocked only because an organization name or website is absent.

**Acceptance Scenarios**:

1. **Given** first-time Profile setup, **When** the conversation starts, **Then** the person sees exactly `**What would you like to call your Highway repository?**` followed by `If you're using Highway for a company or organization, its name is usually a good choice.`
2. **Given** the person supplies a repository name, **When** the next prompt is shown, **Then** that name is treated as accepted and is reused where it helps.
3. **Given** an organization name, organization URL, or other optional organizational context has not been supplied, **When** readiness is assessed, **Then** that absence alone leaves Status unchanged.
4. **Given** optional context that is unavailable, **When** Profile is retained, **Then** the record omits it and contains no placeholder value.
5. **Given** accepted optional context, **When** it is retained, **Then** it is Markdown.

---

### User Story 3 - A public website can fill the Profile (Priority: P1)

As a person whose organization has a public website, I want Highway to use that site before asking me to retype what it already shows, so that I confirm useful information instead of recreating it.

**Why this priority**: Website assistance changes the first acquisition path. It can be checked without the later enrichment categories.

**Independent Test**: When public-website retrieval is available, Profile asks for the site using the accepted repository name, keeps the supplied URL as accepted optional context, and holds the organization name and other derived information as proposals until the person accepts them. When retrieval is unavailable, the conversation continues and does not mention the missing capability.

**Acceptance Scenarios**:

1. **Given** public-website retrieval is available and a repository name has been accepted, **When** Profile still needs organizational information, **Then** it uses the existing-information path and asks for the organization's public website using that repository name.
2. **Given** the person supplies an organization URL, **When** the URL is recorded, **Then** it is accepted optional context.
3. **Given** a website yields an organization name or other organizational information, **When** that information is shown, **Then** it is proposed for validation and is retained only after the person accepts it.
4. **Given** website retrieval is unavailable, **When** Profile continues, **Then** the person is not told that a retrieval capability is missing.
5. **Given** discovered, extracted, inferred, or retrieved information has not crossed the acceptance boundary, **When** Profile is retained, **Then** that information is absent from the retained record.

---

### User Story 4 - Unresolved domains use one canonical question (Priority: P1)

As a person answering Profile questions, I want each unsettled domain to ask one recognizable question, so that I am not asked again for something I have already established.

**Why this priority**: The canonical questions replace adaptive question generation. They are the conversation a person has after the opening name.

**Independent Test**: An unresolved domain uses its canonical question, with the accepted organization name, or the accepted repository name when the organization name is not yet accepted. A response is read across all four domains before another question is chosen. A domain already established by accepted or active evidence is not asked.

**Acceptance Scenarios**:

1. **Given** Identity is unresolved and an organization name has been accepted, **When** Profile asks, **Then** the question is `**What does [Organization Name] do?**`.
2. **Given** Vision, Competitive Path, or Guiding Principles is unresolved and an organization name has been accepted, **When** Profile asks, **Then** the question is the canonical question for that domain, using that organization name.
3. **Given** no organization name has been accepted, **When** a canonical question is asked, **Then** the accepted repository name is used where it reads naturally.
4. **Given** one reply establishes more than one domain, **When** Profile decides what to ask next, **Then** it has considered that reply across all four domains and asks only about a domain that is still unresolved.
5. **Given** accepted or active evidence already establishes a domain, **When** the conversation continues, **Then** that domain's canonical question is not asked.
6. **Given** a question is asked, **When** the person reads it, **Then** one-question behavior, `**Why it matters:**`, examples, and whether a question is needed follow the Highway Experience Standard.

---

### User Story 5 - Enrichment stays optional (Priority: P1)

As a person with a domain already complete enough for readiness, I want grounded suggestions I can accept or skip, so that a richer Profile is available without blocking completion.

**Why this priority**: Enrichment is separate from the four-domain readiness rule. It can be checked once a domain can be `discussed` or `bounded` while still open to more evidence.

**Independent Test**: A readiness-complete domain may still receive grounded enrichment. Skipping that enrichment leaves Profile Complete. Selected recommendations become accepted evidence without a second confirmation. The named evidence categories are used to find those recommendations and are not stored as Profile fields.

**Acceptance Scenarios**:

1. **Given** a domain is `discussed` or `bounded` and accepted evidence supports a useful addition, **When** Profile offers enrichment, **Then** the offer is a grounded recommendation and Profile completion does not wait for it.
2. **Given** a displayed enrichment recommendation, **When** the person selects it, **Then** it is accepted Profile evidence and no second confirmation is requested.
3. **Given** available evidence cannot support a useful enrichment recommendation, **When** more enrichment is still warranted, **Then** Profile asks one further question.
4. **Given** Vision enrichment, **When** recommendations are grounded, **Then** they draw on Future State, Impact, Reach / Scale, Position, and Experience / Reputation, and those names are not retained as fields or enums.
5. **Given** Competitive Path enrichment, **When** recommendations are grounded, **Then** they draw on Customer / Participant, Offering, Market / Reach, Differentiation, Operations, and Capability Development, and those names are not retained as fields or enums.
6. **Given** Guiding Principles enrichment, **When** recommendations are grounded, **Then** they describe how a preference should influence later decisions, drawing on People, Trust, Quality, Simplicity, Change, Stewardship, and Autonomy, and those names are not retained as fields or enums.
7. **Given** any of those category sets, **When** enrichment is offered, **Then** coverage of every category is not required.

---

### User Story 6 - The skill keeps only Profile behavior (Priority: P2)

As a skill author, I want highway-profile to state Profile behavior and point at the Experience Standard for shared interaction, so that the skill no longer repeats rules, an eight-step workflow, or a post-write byte check.

**Why this priority**: The shorter skill is how the behavior above stays maintainable. It follows the domain stories because the verification section has to describe them.

**Independent Test**: The Experience section is the statement that Profile follows the Highway Experience Standard. Ordering appears only for context acquisition, acceptance, mutation, and readiness. Inputs do not include the Profile validator. Persistence is named Persist and does not require a byte check. Failure handling lists only the Profile-specific exceptions. The skill version is 4.0.0 and the Profile schema is 3.0.0.

**Acceptance Scenarios**:

1. **Given** the amended skill, **When** its Experience section is read, **Then** it states that Profile follows the Highway Experience Standard and does not restate that standard's presentation, recommendation, question, Decision Context, acceptance, direct capture, optional-enrichment, or implementation-detail rules.
2. **Given** the amended skill, **When** its workflow is read, **Then** numbered steps remain only where order is required for context acquisition, acceptance, mutation, or readiness.
3. **Given** a retained Profile, **When** Profile persists accepted evidence, **Then** it does not require a validator run, a byte-equality check, or a post-write persistence check, and a failed mutation is still not reported as success.
4. **Given** an obsolete YAML Profile, **When** Profile runs, **Then** that artifact is ignored and is never a fallback or a migration input.
5. **Given** the amended skill and the shared Profile template, **When** their versions are read, **Then** the skill is 4.0.0 and the template schema is 3.0.0.

---

### Edge Cases

- A repository name is accepted even when the person is not speaking for a company.
- An organization name taken from a website stays proposed until the person accepts it. An organization URL the person supplies is accepted when they supply it.
- A single reply can settle more than one domain. Profile asks none of the settled domains.
- A domain can be readiness-complete and still accept enrichment. Declining enrichment leaves the domain readiness-complete.
- Missing optional context never flips Complete to Missing or Blocked by itself.
- Unavailable optional information is omitted. A placeholder is not written in its place.
- Public-website retrieval may be absent. The conversation continues without describing that absence.
- Information that is discovered, extracted, inferred, or retrieved stays out of the retained Profile until the person accepts it.
- A direct statement in the requested category, an explicit selection, and accepted imported information are kept without a second review of the whole Profile.
- Materially interpreted information still waits for the Experience Standard review before it is retained.
- Foundational Highway context may show what evidence would be useful. It is never stored as the organization's own evidence.
- Profile does not store a small-business, enterprise, maturity, persona, or advisory classification. The four domains stay the same on every acquisition path.
- A retained Markdown Profile at schema 2.0.0 is unsupported. It is Blocked, left unchanged, and not rewritten as schema 3.0.0.
- An unsupported schema and a malformed retained Profile are Blocked and are not mutated.
- Removing one readiness domain, resetting Profile, or another destructive change uses the Experience Standard's confirmation. An action the standard already counts as acceptance does not gain a second confirmation.
- Enrichment categories identify opportunities. A recommendation may use one category, and no category is mandatory.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: highway-profile MUST state Profile-specific behavior and MUST cite the Highway Experience Standard for presentation, recommendations, questions, Decision Context, acceptance, direct capture, optional enrichment, and implementation-detail suppression. It MUST NOT restate those rules.
- **FR-002**: The skill Experience section MUST be a concise statement that Profile follows the Highway Experience Standard.
- **FR-003**: The skill MUST state ordering only where order is required for context acquisition, acceptance, mutation, or readiness.
- **FR-004**: Failure handling MUST record only these Profile-specific exceptions to the common failure model: an unsupported Profile schema is Blocked and is not mutated; an obsolete YAML Profile is ignored and is never a fallback or a migration input; a malformed retained Profile is Blocked and is not mutated.
- **FR-005**: The skill MUST NOT name `.highway/tools/validate-profile.sh` as an input and MUST NOT instruct anyone to execute a Profile validator.
- **FR-006**: Persistence MUST be named Persist. The skill MUST NOT require persisted-byte verification, byte-equality verification, or post-write persistence verification.
- **FR-007**: Before Profile relies on an existing retained Profile, it MUST determine whether that Profile is structurally usable.
- **FR-008**: A failed mutation MUST NOT be reported as success. Profile MUST leave that obligation with the common failure model and MUST NOT copy that model into a second procedure.
- **FR-009**: Profile readiness MUST use exactly Identity, Vision, Competitive Path, and Guiding Principles. Highway Role MUST be absent from Profile scope, discovery, readiness, persistence, and verification.
- **FR-010**: Profile Status MUST be Complete when all four readiness-bearing domains are `discussed` or `bounded`.
- **FR-011**: The shared Profile template MUST remove Highway Role, including the How Highway Helps section, and MUST set its schema version to 3.0.0. Schema 2.0.0 MUST be unsupported. Profile MUST leave a schema 2.0.0 record unchanged and MUST NOT read it as a current Profile, migrate it, or rewrite it as schema 3.0.0.
- **FR-012**: Every current Profile document that still describes five readiness domains, including a Highway Profile Intent Summary when one is present, MUST be updated to the four-domain model.
- **FR-013**: Accepted optional context MUST be allowed for Repository Name, Organization Name, Organization URL, and additional accepted organizational context that later recommendations can use. It MUST be stored as Markdown. Unavailable optional information MUST be omitted. Absence of optional context MUST NOT by itself make Profile Missing or Blocked.
- **FR-014**: First-time setup MUST begin with exactly `**What would you like to call your Highway repository?**` and `If you're using Highway for a company or organization, its name is usually a good choice.` The supplied Repository Name MUST be accepted optional context and MUST be reused in the following interaction.
- **FR-015**: When supported public-website retrieval is available, Profile MUST use the Experience Standard's existing-information path before ordinary questioning, MUST ask for the organization's public website using the accepted Repository Name, MUST treat the supplied Organization URL as accepted optional context, and MUST treat the Organization Name and every other website-derived fact as proposed until accepted. Useful discovered information MUST be presented for validation.
- **FR-016**: When website retrieval is unavailable, Profile MUST continue and MUST NOT expose the missing capability.
- **FR-017**: Discovered, extracted, inferred, or retrieved information MUST remain unretained until the applicable user-acceptance boundary is satisfied.
- **FR-018**: An unresolved domain MUST use its canonical question: Identity `**What does [Organization Name] do?**`; Vision `**What is the future vision of [Organization Name]?**`; Competitive Path `**How does [Organization Name] plan to get there?**`; Guiding Principles `**What principles or values guide decisions at [Organization Name]?**`. When Organization Name is not accepted, the accepted Repository Name MUST be used where natural. A domain already established by accepted or active evidence MUST NOT be asked. Each response MUST be considered across all four domains before the next unresolved domain is chosen.
- **FR-019**: One-question behavior, `**Why it matters:**`, examples, and whether a question is needed MUST follow the Highway Experience Standard.
- **FR-020**: Domain completeness and domain enrichment MUST be separate. A readiness-complete domain MUST still be allowed to accept optional enrichment. Optional enrichment MUST NOT block Profile completion. Profile MUST prefer a grounded enrichment recommendation when accepted evidence supports a useful choice. A selected recommendation MUST be accepted Profile evidence without a second confirmation. Profile MUST ask another question only when useful enrichment cannot be recommended from available evidence.
- **FR-021**: Vision enrichment MUST be grounded in Future State, Impact, Reach / Scale, Position, and Experience / Reputation. Competitive Path enrichment MUST be grounded in Customer / Participant, Offering, Market / Reach, Differentiation, Operations, and Capability Development. Guiding Principles enrichment MUST be grounded in People, Trust, Quality, Simplicity, Change, Stewardship, and Autonomy, and MUST prefer evidence of how a principle should influence later decisions. These category names MUST NOT be persisted as Profile fields or enums. Coverage of every category MUST NOT be required.
- **FR-022**: Profile MUST NOT store a small-business, enterprise, maturity, persona, or advisory-mode classification. Acquisition MUST adapt to available organizational evidence while preserving the same four domains. When authoritative organizational material already exists, Profile MUST prefer importing, discovering, normalizing, and validating it. When information is partial, Profile MUST reuse it and fill useful gaps. When little information exists, Profile MUST use the canonical questions and grounded enrichment recommendations.
- **FR-023**: Profile MUST persist only information supplied in the requested category, explicitly selected recommendations, imported or discovered information the person accepts, and materially interpreted information after its review. Direct capture and material-interpretation review MUST follow the Experience Standard. A review of the whole Profile MUST NOT be required when that information has already been accepted. Organizational Profile evidence MUST remain user-owned.
- **FR-024**: Readiness MUST use `Status: <Complete, Missing, or Blocked>`, `Summary: <Profile readiness explanation>`, `Next Action: <owner route or None>`, and `Blocking Reason: <reason or None>`. No retained Profile MUST be Missing with Next Action `/highway-profile setup`. An unsupported or malformed retained Profile MUST be Blocked. Any readiness-bearing domain `not_discussed` MUST be Missing with Next Action `/highway-profile configure`. All four domains `discussed` or `bounded` MUST be Complete.
- **FR-025**: Declared Repository Context MUST be limited to Highway Identity for behavioral framing, Highway Vision for strategic direction, and Highway Platform Objectives for evaluation criteria, and only where each source influences Profile. Profile MUST NOT restate generic context-precedence or missing-context rules. Foundational Highway context MUST NOT be stored as organizational evidence.
- **FR-026**: Profile MUST keep `setup`, `configure`, `readiness`, `view`/`show`/`describe`, `add`, `update`, `remove`, and `reset`, with concise domain-specific meaning. Destructive confirmation MUST follow the Experience Standard. Profile MUST NOT add a confirmation when the Experience Standard already treats the person's action as acceptance.
- **FR-027**: The skill Verification section MUST confirm that the retained Profile follows the shared Profile template; readiness uses exactly four domains; Highway Role is outside Profile; Repository Name, Organization Name, and Organization URL are optional context; optional context and enrichment do not affect readiness; only user-provided or user-accepted organizational evidence is retained; website-derived information stays proposed until accepted; canonical questions are used only for unresolved domains; accepted evidence prevents a repeated question; grounded enrichment uses the declared internal categories without persisting them; a selected recommendation is captured without a second confirmation; material interpretation follows the Experience Standard review; no validator, byte verification, or post-write shell verification is required; and Profile ownership and readiness remain with Profile.
- **FR-028**: The highway-profile version MUST move from 3.0.0 to 4.0.0. The shared Profile template schema version MUST move from 2.0.0 to 3.0.0. Dependent Profile documentation MUST be updated after the skill and the template.

### Key Entities

- **Profile**: The retained organizational record. It holds four readiness domains and any accepted optional context.
- **Readiness-bearing domain**: Identity, Vision, Competitive Path, or Guiding Principles. Each is `not_discussed`, `discussed`, or `bounded`.
- **Optional context**: Accepted Markdown that does not affect readiness, including Repository Name, Organization Name, Organization URL, and other accepted organizational context.
- **Canonical question**: The one question for an unresolved domain, using the accepted organization name or, when that name is absent, the accepted repository name.
- **Enrichment category**: An internal grounding label for Vision, Competitive Path, or Guiding Principles. It is not a stored field.
- **Readiness result**: Status, Summary, Next Action, and Blocking Reason.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Profile readiness names exactly 4 domains. 0 current Profile obligations treat Highway Role as a domain. A Profile is Complete only when all 4 domains are `discussed` or `bounded`. 0 behaviors treat schema 2.0.0 as a readable or migratable Profile.
- **SC-002**: 100% of first-time setups open with the repository-name question and its hint. 100% of supplied repository names are accepted optional context and are available in the next prompt. 0 absent optional fields, by themselves, change Status.
- **SC-003**: When website retrieval is available, 100% of website-derived organization names remain proposed until accepted, and 100% of user-supplied organization URLs are accepted optional context. When retrieval is unavailable, 0 prompts describe the missing capability.
- **SC-004**: 100% of questions for an unresolved domain use that domain's canonical question. 0 canonical questions are asked for a domain that accepted or active evidence already establishes.
- **SC-005**: 0 enrichment-category names are stored as Profile fields or enums. 0 enrichment offers block a Profile whose four domains are already `discussed` or `bounded`. A selected recommendation is accepted in 100% of cases without a second confirmation.
- **SC-006**: The skill version is 4.0.0 and the Profile schema is 3.0.0. 0 skill instructions require a validator, a byte-equality check, or a post-write persistence check. The Experience section cites the Highway Experience Standard in 1 concise statement.

## Assumptions

- The skill version moves from 3.0.0 to 4.0.0 because the skill contract breaks under the Skill Versioning Policy. The shared Profile template schema moves from 2.0.0 to 3.0.0 because removing Highway Role breaks the retained record. Profile is still in development, so no backward compatibility is required. Schema 2.0.0 is unsupported. An obsolete YAML Profile stays ignored and is never a fallback or a migration input.
- The four remaining narrative headings stay Who We Are, Where We're Going, How We Plan to Get There, and What Guides Our Decisions. How Highway Helps leaves with Highway Role. Domain keys remain `identity`, `vision`, `competitive_path`, and `guiding_principles`. Outcome values remain `not_discussed`, `discussed`, and `bounded`.
- Checks and live citations that still require five domains, Highway Role, the Profile validator, byte verification, or persist-and-verify are updated with this change. A replaced check names the superseded behavior.
- Copies of the skill distributed to supported agents stay aligned with the source skill.
- Objectives, Controls, Non-Functional Requirements, and Setup keep their own workflows. They are updated only where they still describe Profile's domain count or treat Highway Role as Profile content.
- No document titled Highway Profile Intent Summary is in the repository today. Any such document, and any other current Profile document that still describes five domains, is in scope.
- This feature does not amend the Experience Standard or the Skills Constitution. Profile cites them for shared interaction, context precedence, and the common failure model.
- An example of an unsupported schema uses a version other than 3.0.0, because 3.0.0 becomes the supported schema.
