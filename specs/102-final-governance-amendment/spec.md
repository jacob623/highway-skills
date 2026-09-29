# Feature Specification: Final Governance Amendment

**Feature Branch**: `102-final-governance-amendment`

**Created**: 2026-09-29

**Status**: Draft

**Input**: User description: "Amend the Skills Constitution so an oversized skill is reduced until it meets the existing size limits, instead of being split. Strengthen Decision Context so it uses the label Why it matters. Replace the shared recommendation layout with a semantic model that still caps a set at five and treats selection as acceptance. Leave one current Experience Standard amendment record, and stop further governance changes before any skill rewrite."

## Background

The Skills Constitution and the Experience Standard are the runtime authorities a person and a skill author rely on. The constitution already states runtime-only governance, common failure handling, no mandatory post-write persistence verification, simplified repository context, delegation to the Experience Standard, shared-template ownership, and owner-controlled readiness and orchestration. The Experience Standard already states evidence-first interaction, a five-choice recommendation cap, selection as acceptance, inferred-content review, and setup transitions.

Two rules still push work in the wrong direction. An oversized skill is told to split into more skills. Decision Context explains why an answer matters, but it does not use one presentation label. Shared recommendations for Profile enrichment, Objectives, Controls, and Non-Functional Requirements are required to appear as a numbered list, even when one recommendation or another concise layout would be clearer.

The current Skills Constitution is version 4.1.0. Redefining a rule is a major amendment under its versioning policy. The current Experience Standard is version 3.0.0. Strengthening Decision Context so unlabeled context can fail, and redefining the recommendation presentation, are each a major amendment under its versioning policy. The Experience Standard also carries every prior amendment narrative in the runtime document. Prior detail belongs in version history, not in the document a person reads to understand the current standard.

## Clarifications

### Session 2026-09-29

- Q: Should this amendment also update the tests and live citations that still require the old rules, or only the two governance documents? → A: Update the two governance documents, and also update tests and live citations that still require a split, the old Decision Context wording, a numbered recommendation list, or the removed history. Do not rewrite skill domain workflows.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - An oversized skill is reduced, not split (Priority: P1)

As a skill author, I want an oversized skill brought back inside the existing size limits without being forced into extra skills, so that related guidance stays together and the authoring standard does not manufacture skills only to satisfy a count.

**Why this priority**: The split rule is the constitution change. It changes what a conforming skill must do, and the version classification depends on it.

**Independent Test**: Read the amended size rule. A skill over the existing rule-count limit or the existing section-length limit must be reduced until that same skill satisfies both limits. The rule does not require a second skill. Live guidance and checks that required a split now require that reduction. The rule that forbids restating an outside requirement is unchanged. Every other current constitution obligation is unchanged.

**Acceptance Scenarios**:

1. **Given** a skill over the rule-count limit or the section-length limit, **When** it is brought into compliance, **Then** the same skill is reduced until both limits are satisfied, and creating additional skills is not required.
2. **Given** a skill already inside both limits, **When** the size rule is applied, **Then** the skill is not required to split or to shrink further.
3. **Given** a requirement owned by the Skills Constitution, the Experience Standard, a shared contract, or another skill, **When** a skill needs that requirement, **Then** the skill references the owner and does not restate the requirement.
4. **Given** the amended constitution, **When** its other current rules are read, **Then** runtime-only governance, common failure handling, persistence, repository context, Experience Standard delegation, shared-template ownership, and owner-controlled readiness and orchestration are unchanged.
5. **Given** live guidance or a check that required an oversized skill to be split, **When** the amendment is complete, **Then** that guidance and that check require the skill to be reduced until both limits are met, and they do not require additional skills.

---

### User Story 2 - Decision Context says why it matters (Priority: P1)

As a person answering a Highway question, I want the reason for the question under one recognizable label, so that I can see why my answer matters before I answer, and I am not asked a second question in the explanation.

**Why this priority**: This is the presentation a person sees whenever a question needs context. It is independently valuable without the recommendation-layout change.

**Independent Test**: When Decision Context applies, the prompt uses the exact label `**Why it matters:**`, places a concise explanation of the person's stake immediately after it, and places one unresolved question after that explanation. The explanation does not describe implementation, does not ask a second question, and is omitted when the implication was just established or when no Decision Context is needed.

**Acceptance Scenarios**:

1. **Given** an answer that affects a later recommendation, decision, artifact, or governance interpretation, **When** the question is asked, **Then** the person sees `**Why it matters:**`, then a concise explanation of that downstream relevance, then one unresolved question.
2. **Given** that pattern, **When** the explanation is read, **Then** it does not explain internal processing and it does not contain a second response-demanding question.
3. **Given** the implication was established immediately before the prompt, **When** the question is asked, **Then** the same explanation is not repeated.
4. **Given** no Decision Context is needed, **When** the interaction continues, **Then** `**Why it matters:**` is not shown.

---

### User Story 3 - Recommendations share a meaning, not one layout (Priority: P1)

As a person reviewing suggestions for Profile enrichment, Objectives, Controls, or Non-Functional Requirements, I want a short grounded set I can select or replace with my own wording, so that the interaction is recognizable across those domains without forcing a numbered list.

**Why this priority**: The numbered-list requirement is the other major Experience Standard change. It can be checked without the history cleanup.

**Independent Test**: Those four domains use one recommendation model: concise grounding, one or more distinct actionable recommendations, a clear way to select them, and a user-authored alternative. Selecting a shown recommendation is acceptance. A set contains at most five recommendations. Numbering, bullets, a single recommendation, or another concise domain presentation are all allowed. The model does not require a numbered list.

**Acceptance Scenarios**:

1. **Given** grounded choices in one of the four domains, **When** recommendations are shown, **Then** the person sees concise grounding, at least one distinct actionable recommendation, a clear selection path, and a way to supply their own alternative.
2. **Given** a displayed recommendation, **When** the person selects it, **Then** that selection is acceptance and is not treated as a request for more information.
3. **Given** a request to explain, compare, or learn more, **When** the person has not selected a recommendation, **Then** that request is not acceptance.
4. **Given** more than five distinct recommendations, **When** a set is shown, **Then** the set contains at most five, and further sets stop when no useful grounded non-duplicate choice remains, the person is finished, or the person will author their own information.
5. **Given** a domain where one recommendation, bullets, or another concise layout is clearer than numbers, **When** the set is shown, **Then** that presentation is acceptable and a numbered list is not required.
6. **Given** non-normative recommendation guidance, **When** it is read, **Then** it demonstrates this shared meaning and does not prescribe one exact layout.
7. **Given** a check that required those recommendations to be a numbered list, or that required the previous Decision Context wording, **When** the amendment is complete, **Then** that check accepts the shared model and the Why it matters label, and it does not require numbering.

---

### User Story 4 - The current standard stands on its current record (Priority: P2)

As a reviewer of the Experience Standard, I want the runtime document to explain the current amendment only, so that I am not asked to reconstruct today's rules from a stack of superseded narratives.

**Why this priority**: The history reduction makes the amended standard readable. It follows the rule changes because the current report must describe those changes.

**Independent Test**: The Experience Standard contains one sync impact report, for the amendment from 3.0.0 to 4.0.0. Prior amendment narratives, historical test names, old feature references, superseded rule-count discussions, and development-constitution commentary are absent from the runtime document. The current rules, including the rules this amendment does not change, remain understandable without those narratives. The Skills Constitution keeps its older reports and adds the new major report.

**Acceptance Scenarios**:

1. **Given** the amended Experience Standard, **When** a reviewer reads its opening record, **Then** the only sync impact report is the current amendment, and version history is left to the repository history.
2. **Given** that document, **When** it is searched for prior amendment narratives, historical test names, old feature references, superseded rule counts, and development-constitution commentary, **Then** those are absent from the runtime text.
3. **Given** the amended Skills Constitution, **When** its opening records are read, **Then** the new major report is present and the older reports remain.
4. **Given** a check that required a removed Experience Standard history entry as current text, **When** the amendment is complete, **Then** that check requires the current 4.0.0 record and does not require the removed history.

---

### Edge Cases

- A skill inside both size limits is not split and is not reduced solely because the rule changed.
- A skill over only one of the two limits is reduced until both limits hold. The remedy is reduction of that skill, not a required second skill.
- Decision Context that was acceptable without the label no longer passes. That strengthening is part of the major Experience Standard amendment.
- When the reason for a question was just stated, the label and explanation are not repeated.
- When no Decision Context applies, the label is absent rather than shown empty.
- A recommendation set of one is valid. A set of six in one showing is not.
- A numbered list remains allowed. It is not the required shape.
- An explanation, comparison, or request for more information is still not acceptance.
- An explicit selection, a direct statement already in the requested category, or clearly presented imported information is still captured without the inferred-content review.
- Materially interpreted or transformed input still uses `Here's what I've captured as your [category]:` with the proposal immediately below and one acceptance request at the bottom.
- A move into a new setup domain still uses one short outcome-oriented transition and a horizontal rule between major setup domains.
- Discovered or extracted information stays proposed until accepted. Missing evidence stays unknown. Optional enrichment does not block continuation unless the owning domain requires it for validity.
- Removing historical narratives must not remove the current rule text those narratives once introduced.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Skills Constitution MUST replace the current oversized-skill rule with: a skill exceeding the rule-count limit or the section-length limit MUST be reduced until it satisfies those limits.
- **FR-002**: The observable for that rule MUST require the resulting skill to satisfy both existing limits, and MUST NOT prescribe splitting the skill into additional skills.
- **FR-003**: The rule that a skill must reference, rather than restate, a requirement owned by the Skills Constitution, the Experience Standard, a shared contract, or another owning skill MUST remain unchanged.
- **FR-004**: This change MUST NOT make any other substantive change to the Skills Constitution. Runtime-only governance, common failure handling, the absence of mandatory post-write persistence verification, simplified repository context, Experience Standard delegation, shared-template ownership, and owner-controlled readiness and orchestration MUST remain as they are.
- **FR-005**: The Skills Constitution amendment MUST be classified as major because it redefines an existing rule. The version MUST move from 4.1.0 to 5.0.0. The ratified date MUST stay 2026-09-06. The last-amended date MUST be 2026-09-29. A new sync impact report MUST name the redefined rule, and the older constitution reports MUST remain.
- **FR-006**: The Experience Standard MUST replace the current Decision Context rule with an equivalent of: Decision Context MUST use the label `**Why it matters:**` and explain why the answer matters to the person without asking a second question.
- **FR-007**: When Decision Context applies, a passing prompt MUST show the literal label `**Why it matters:**`, a concise user-relevant explanation immediately after it, no implementation explanation, no second response-demanding question, and no repetition when the implication was established immediately before the prompt. The question MUST follow that explanation. The standard pattern is the label, the concise explanation, then one unresolved question.
- **FR-008**: The label `**Why it matters:**` MUST NOT appear when no Decision Context is needed.
- **FR-009**: The Experience Standard MUST replace the current shared-recommendation rule with an equivalent of: Profile enrichment, Objectives, Controls, and Non-Functional Requirements MUST use the shared recommendation interaction model.
- **FR-010**: That model's observable MUST require concise grounding, one or more distinct actionable recommendations, a clear selection path, a user-authored alternative, and selection treated as acceptance. It MUST NOT require a numbered list. One recommendation, bullets, numbering, or another concise domain presentation MUST all be permitted.
- **FR-011**: A recommendation set MUST still contain at most five recommendations. The person MUST still be able to provide their own alternative. Selection MUST still be acceptance. A request for explanation, comparison, or more information MUST still not be acceptance. Further recommendations MUST still stop when no useful grounded non-duplicate choice remains, the person is finished, or the person will author their own information.
- **FR-012**: Non-normative recommendation guidance MUST demonstrate the shared meaning and MUST NOT prescribe one exact layout.
- **FR-013**: The inferred-content review, direct capture without that review, the short setup transition, the horizontal rule between major setup domains, the proposal boundary for discovered information, the refusal to invent unknown evidence, and the rule that optional enrichment does not block continuation MUST remain unchanged.
- **FR-014**: The Experience Standard amendment MUST be classified as major because Decision Context is strengthened and the recommendation rule is redefined. The version MUST move from 3.0.0 to 4.0.0. The ratified date MUST stay 2026-09-08. The last-amended date MUST be 2026-09-29. The sync impact report MUST describe this amendment.
- **FR-015**: The Experience Standard MUST contain only the sync impact report for this amendment. Prior amendment reports MUST be removed from the runtime document. Repository history remains the source of prior amendment detail.
- **FR-016**: The runtime Experience Standard MUST NOT contain historical test filenames, old feature references, superseded rule-count discussions, prior development-constitution commentary, or obsolete amendment narratives. It MUST keep the current rules and the information required to understand them.
- **FR-017**: This feature MUST NOT rewrite Profile, Objectives, Controls, Non-Functional Requirements, or Setup domain workflows, and MUST NOT add domain-specific behavior for those skills to either governance document.
- **FR-018**: Tests and live citations that still require a skill to be split, the previous Decision Context wording, a numbered recommendation list, or a removed Experience Standard history entry MUST be updated to the new obligations. Skill domain workflows MUST NOT be rewritten.

### Key Entities

- **Skills Constitution**: The runtime authority for what a skill file must contain. This change redefines one size rule and records a major version.
- **Experience Standard**: The runtime authority for what a person sees. This change strengthens Decision Context, redefines shared recommendations, and keeps a single current amendment record.
- **Decision Context**: The concise reason a requested answer matters to the person, shown only when needed, under the label `**Why it matters:**`.
- **Shared recommendation model**: The common meaning of a recommendation set for Profile enrichment, Objectives, Controls, and Non-Functional Requirements: grounding, distinct actionable choices, a selection path, and a user-authored alternative.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The oversized-skill rule requires reduction until both existing size limits are met, and 0 current constitution rules require splitting a skill to meet those limits. The constitution version is 5.0.0. Every current constitution rule other than that size rule is unchanged.
- **SC-002**: 100% of prompts that need Decision Context show `**Why it matters:**`, a concise person-relevant explanation, and one question. 0 such prompts add a second question, an implementation explanation, or a repeated explanation that was just given. 0 prompts show the label when Decision Context is not needed.
- **SC-003**: 100% of recommendation sets in the four named domains can be satisfied by grounding, one to five distinct actionable recommendations, a selection path, and a user-authored alternative. 0 current rules require those sets to be numbered. Selection remains acceptance in 100% of those sets.
- **SC-004**: The Experience Standard contains exactly 1 sync impact report, for version 4.0.0. 0 prior amendment narratives, historical test names, old feature references, superseded rule-count discussions, or development-constitution commentaries remain in that runtime document.
- **SC-005**: 0 domain workflows in Profile, Objectives, Controls, Non-Functional Requirements, or Setup are rewritten. The unchanged interaction rules named in the requirements remain present with the same obligations.
- **SC-006**: 0 live citations and 0 checks still require a split, the previous Decision Context wording, a numbered recommendation list, or a removed history entry as a current obligation.

## Assumptions

- The constitution version moves from 4.1.0 to 5.0.0 because redefining a rule is major under that document's versioning policy. The ratified date stays 2026-09-06. The last-amended date is 2026-09-29, the date of this amendment.
- The Experience Standard version moves from 3.0.0 to 4.0.0 because strengthening Decision Context and redefining the recommendation rule are each major under that document's versioning policy. The ratified date stays 2026-09-08. The last-amended date is 2026-09-29.
- Older Skills Constitution sync reports stay. Only the Experience Standard's accumulated reports are replaced by the single current report.
- The existing rule-count limit and section-length limit stay where they are. This change replaces the remedy for exceeding them.
- The exact Decision Context label includes the bold markers and the colon: `**Why it matters:**`.
- One recommendation satisfies "one or more." Five remains the maximum in one set.
- Individual rationalization of Profile, Objectives, Controls, Non-Functional Requirements, and Setup domain workflows is a later change. This feature updates the two governance documents and the tests and live citations that still state the superseded rules. During that later work, an instruction that only repeats either document is removed from the skill, and domain-specific meaning stays.
