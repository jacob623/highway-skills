# Feature Specification: Amend Experience Standard

**Feature Branch**: `114-amend-experience-standard`

**Created**: 2026-10-01

**Status**: Draft

**Input**: User description: Amend the Highway Experience Standard from 4.0.0 to 5.0.0 so guided interaction presents the question before Decision Context, keeps one Setup decision in the final interaction block, compounds grounded recommendations before every unresolved guided question, matches choice wording to the number of recommendations, closes a completed Setup domain with at most one user-relevant synthesis, and hides machine-consumable owner results from normal conversation. Do not change skills or other governance baselines. Update repository checks that still require the superseded contract.

## Clarifications

### Session 2026-10-01

- Q: Should this amendment also update the repository checks that still require the superseded Experience Standard wording? → A: Yes. Update checks that encode Experience Standard behavior changed by this amendment. Require question-then-Why-it-matters, X1.7 Decision Context after the final question, and X2.13 evaluation before each unresolved guided-collection question. Add X2.32–X2.35 checks where corresponding Experience Standard checks exist. Move version, rule-count, inventory, fixture, snapshot, and version-record expectations from 4.0.0 to 5.0.0. Remove superseded X1.7, X2.9, and X2.13 expectations instead of accepting both contracts. Keep the check changes in development and review infrastructure, not as runtime dependencies of the Experience Standard or shipped skills. The passing baseline is the 5.0.0 contract.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Question Before Explanation (Priority: P1)

As a person answering a guided Highway question, I want the question itself to appear before the explanation of why it matters, so that I can see what is being asked before I read the supporting context.

**Why this priority**: Question order is the first thing a person sees. The current standard places the explanation before the question, so previously acceptable presentations will no longer conform.

**Independent Test**: Review a guided question that needs Decision Context and confirm one unresolved question appears first, followed by the literal label and one concise explanation, with no second question.

**Acceptance Scenarios**:

1. **Given** Decision Context applies to an unresolved guided question, **When** the question is presented, **Then** the question appears first, followed by the literal label "**Why it matters:**" and one concise explanation of why the answer matters to the person.
2. **Given** the relevance of the answer was already established immediately before the question, **When** the question is presented, **Then** Decision Context may be omitted and the label is absent.
3. **Given** a captured-content acceptance review, **When** the review is presented, **Then** the proposal remains first and the single acceptance request remains at the bottom; the question-then-explanation order is not applied.
4. **Given** a Setup presentation, **When** the person is asked to respond, **Then** the final interaction block contains one response-demanding question or decision, and Decision Context may follow that question.

---

### User Story 2 - Recommendations That Compound (Priority: P1)

As a person working through guided Setup, I want Highway to use what I have already accepted before asking another question, so that each answer makes the next recommendation more specific instead of restarting a generic questionnaire.

**Why this priority**: Compounding accepted context is the informed-advisor behavior this amendment exists to make enforceable throughout a guided interaction, not only at the start.

**Independent Test**: Walk a guided collection in which accepted answers and one accepted discovery accumulate, and confirm a useful grounded choice replaces the next question whenever that context supports one.

**Acceptance Scenarios**:

1. **Given** accumulated accepted context supports a useful grounded choice, **When** the next unresolved guided-collection question would otherwise be asked, **Then** that choice is shown instead of the question.
2. **Given** discovered or imported information has been accepted, **When** the next recommendation opportunity arises, **Then** that accepted information is used as grounding and the interaction does not restart as a generic question.
3. **Given** several distinct grounded alternatives would meaningfully help the person recognize their intent, **When** recommendations are offered, **Then** more than one may be shown, up to the existing maximum of five.
4. **Given** only one grounded recommendation exists, **When** it is offered, **Then** the workflow does not invent additional recommendations, and the choice wording is singular.
5. **Given** more than one recommendation is shown, **When** the person is asked to choose, **Then** the wording permits one, several, all, or a user-authored alternative.
6. **Given** the person selects a displayed recommendation, **When** that selection is explicit, **Then** it counts as acceptance without another confirmation.

---

### User Story 3 - Human Closure Without Machine Chatter (Priority: P1)

As a person finishing a Setup domain, I want a short statement of what Highway understood and a clean move into the next domain, so that I am not shown internal status, routing, or duplicate completion messages.

**Why this priority**: Machine-facing results currently leak into conversation and make completion feel like a system handoff rather than demonstrated understanding.

**Independent Test**: Complete a guided Setup domain that has meaningful accepted context and confirm at most one user-relevant synthesis appears, machine-only result fields are absent, and the next domain opens without a repeated completion statement.

**Acceptance Scenarios**:

1. **Given** a guided Setup domain has accepted context that can be meaningfully summarized, **When** that domain is complete and before the next active domain begins, **Then** the owner emits one concise synthesis of what was learned or established, with no machine status, owner result, implementation detail, or new question.
2. **Given** a completed domain has nothing meaningful to summarize, **When** the workflow moves on, **Then** no synthesis is emitted.
3. **Given** a synthesis has been given, **When** the orchestrator enters the next active domain, **Then** it uses the existing domain transition and does not repeat the owner's synthesis or turn the synthesis into a second confirmation.
4. **Given** a normal orchestrated exchange, **When** the person did not request readiness, status, inspection, or mutation results, **Then** machine-only fields such as Status, Summary, Next Action, Blocking Reason, Action Status, Collection Result, and orchestrator-only mutation results are not shown.
5. **Given** the person directly requests a readiness, status, inspection, or mutation result, **When** that result is the requested output, **Then** its declared user-facing result may be shown.
6. **Given** the person has made the final guided decision, **When** the delegated interaction closes, **Then** only user-relevant closure, synthesis, or the next-domain transition is visible.

---

### User Story 4 - A Traceable Major Amendment (Priority: P2)

As a governance maintainer, I want this presentation change recorded as a major Experience Standard amendment with stable rule identifiers, so that reviewers can see what was redefined, what was added, and what must remain untouched.

**Why this priority**: The behavior changes are not adoptable until the standard itself states them unambiguously and records why previously conforming presentation can now fail.

**Independent Test**: Read the amended Experience Standard and run its repository review. Confirm version 5.0.0, the redefined and new rules, the preserved rules, unchanged skills and other governance baselines, and a passing review that requires the 5.0.0 contract rather than the superseded 4.0.0 contract.

**Acceptance Scenarios**:

1. **Given** the Experience Standard is amended, **When** its version and impact record are read, **Then** the change is 4.0.0 to 5.0.0, classified major because X1.7, X2.9, and X2.13 are redefined.
2. **Given** the rule table is reviewed, **When** identifiers are compared with the previous standard, **Then** X1.7, X2.9, and X2.13 keep their identifiers, and X2.32 through X2.35 are the only new identifiers.
3. **Given** rules that this amendment explicitly preserves, **When** they are compared with the previous standard, **Then** their obligations are unchanged.
4. **Given** this amendment is complete, **When** other governance baselines and skills are inspected, **Then** none of them were updated as part of this change.
5. **Given** a repository check still requires the former explanation-before-question order, the former X1.7 or X2.13 contract, Experience Standard version 4.0.0, or the superseded rule inventory, **When** the review is updated, **Then** it requires the amended contract only and passes against the amended standard.
6. **Given** the updated review is packaged with a shipped skill, **When** that skill is used, **Then** the review is not a runtime dependency of the Experience Standard or the skill.

---

### Edge Cases

- Decision Context is optional when the relevance was just established; the label must not appear as empty ceremony.
- A captured-content review must not be reordered into question-then-explanation form.
- A useful grounded choice replaces the question; a question is still asked when no such choice resolves the need.
- One grounded recommendation must not be padded into a set, and several useful alternatives must not be collapsed to one.
- Recommendation sets still cannot exceed five distinct actionable choices.
- A request for explanation, comparison, or more information is still not acceptance.
- A domain with nothing meaningful to summarize emits no synthesis and does not invent one.
- A synthesis demonstrates understanding and does not ask the person to confirm it again.
- The owner may still return machine-consumable results for orchestration; those results are hidden from normal conversation, not forbidden as internal results.
- A direct request for readiness, status, inspection, or mutation output may still show the result the person asked for.
- The owner and the orchestrator must not both announce completion.
- Accepted website or other discovered information does not get its own special rule; it becomes ordinary accepted context for the next recommendation.
- Illustrative phrases for recommendations, synthesis, and examples are patterns, not required identical wording, except the literal Decision Context label.
- Non-normative examples that say "Select any of these" for a single recommendation must be removed or revised.
- The amendment must not add persistence, owner-mutation, or skill-authoring obligations to the Experience Standard.
- A repository check must not accept both the superseded and amended X1.7, X2.9, or X2.13 contracts.
- A check that validates an unchanged skill contract is not retargeted to 5.0.0 presentation merely because the Experience Standard changed.
- A skill version record is not an Experience Standard version assertion unless the check explicitly asserts the Experience Standard version.
- Repository review checks are not required for a person to use a shipped skill.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Experience Standard MUST replace X2.9 so Decision Context follows the question it explains under the literal label "**Why it matters:**".
- **FR-002**: When Decision Context applies, the presentation MUST show one unresolved question first, then that literal label, then one concise user-relevant explanation, with no second question, implementation explanation, or repeated rationale.
- **FR-003**: Decision Context MUST remain optional when the relevance was already established immediately before the question, and the label MUST be absent when Decision Context is not needed.
- **FR-004**: The question-then-explanation order MUST NOT be applied to captured-content acceptance reviews. Those reviews MUST keep the proposal first and one acceptance request at the bottom.
- **FR-005**: X1.7 MUST require Setup presentation to keep one response-demanding question or decision in the final interaction block, and MUST allow Decision Context governed by X2.9 to follow that question.
- **FR-006**: X2.13 MUST keep the rule that grounded recommendations are offered before a question when context supports useful choices, and MUST require that evaluation before every unresolved guided-collection question, not only at workflow entry.
- **FR-007**: Before each unresolved guided-collection question, the workflow MUST evaluate accumulated accepted context and show a useful grounded choice instead of the question when one exists.
- **FR-008**: The interaction sequence MUST understand accepted context, reuse it, discover or import authoritative information when supported, accept or validate that information at the applicable boundary, re-evaluate for grounded recommendations, offer those recommendations when Highway can responsibly help, ask one clear question only when they do not resolve the need, capture accepted information, and re-evaluate again before the next guided question.
- **FR-009**: Accepted discovered or imported information MUST immediately become grounding for the next recommendation opportunity. The standard MUST NOT add a website-specific rule.
- **FR-010**: X2.25 MUST remain the shared recommendation rule for Profile enrichment, Objectives, Controls, and Non-Functional Requirements. Its observable MUST require concise grounding tied to what Highway already knows, one or more distinct actionable recommendations, a choice prompt appropriate to that number, a user-authored alternative, and acceptance governed by X2.18.
- **FR-011**: The standard MUST NOT require exactly one recommendation when several grounded alternatives would meaningfully help, and MUST NOT require several when only one grounded recommendation exists. The existing maximum of five distinct actionable choices MUST remain.
- **FR-012**: A new rule X2.32 MUST require recommendation choice wording to match the number of recommendations shown. One recommendation uses singular accept, change, or alternative wording. Multiple recommendations permit one, several, all, or a user-authored alternative.
- **FR-013**: The single-recommendation and multiple-recommendation choice phrases supplied with this amendment MUST be treated as illustrative patterns, not required literal wording.
- **FR-014**: Non-normative examples MUST be revised so a single shown recommendation is not invited with wording such as "Select any of these".
- **FR-015**: A new rule X2.33 MUST require a completed guided Setup domain to close with one concise synthesis when accepted context from that domain can be meaningfully summarized, and to omit that synthesis when it cannot.
- **FR-016**: That synthesis MUST be at most one concise user-relevant statement of what Highway learned or established, emitted before the orchestrator enters the next active domain, and MUST contain no machine status, owner result, implementation detail, or new question.
- **FR-017**: Domain completion synthesis MUST occur before the existing horizontal-rule transition into the next active domain, and the orchestrator MUST NOT duplicate the owner's synthesis or turn it into a second confirmation.
- **FR-018**: A new rule X2.34 MUST prohibit machine-consumable owner results from appearing in normal orchestrated user-visible output. Readiness, mutation, action, and collection result fields consumed only for orchestration MUST be absent unless the person requested them or needs them to act.
- **FR-019**: The hidden machine-facing fields MUST include Status, Summary, Next Action, Blocking Reason, Action Status, Collection Result, and mutation-result fields used only by an orchestrator. Returning those results to the orchestrator MUST remain allowed.
- **FR-020**: A direct readiness, status, inspection, or mutation request MAY still display its declared user-facing result when that result is the requested output.
- **FR-021**: A new rule X2.35 MUST prohibit a delegated guided interaction from exposing a machine result after its final user-facing acknowledgment or question. After the person's final guided decision, only user-relevant closure, synthesis, or the orchestrator's next-domain transition may be visible.
- **FR-022**: The standard MUST NOT require duplicate completion statements from both the owner and the orchestrator, and MUST NOT present routing, persistence, readiness recalculation, collection state, or other handoff mechanics as normal conversation.
- **FR-023**: Non-normative contextual guidance MUST state that accepted information compounds during a guided interaction and that a workflow should become more specific as accepted context accumulates rather than return to generic questioning. That guidance MUST remain non-normative.
- **FR-024**: The non-normative context-awareness example MUST be replaced with an organizational-context contrast equivalent to a generic "What is your vision?" versus a context-aware recommendation grounded in what the person already shared. The example MUST remain explicitly non-normative.
- **FR-025**: Non-normative interaction examples MUST show the new Decision Context order and a human closure that does not display machine-only status, summary, and next-action fields. Those examples MUST remain explicitly non-normative.
- **FR-026**: X2.3, X2.7, X2.16, X2.17, X2.18, X2.19, X2.20, X2.21, X2.22, X2.27, X2.28, X2.29, X2.30, and X2.31 MUST remain unchanged.
- **FR-027**: The amendment MUST preserve the distinction between a grounded recommendation, an accepted recommendation, discovered evidence, and accepted organizational truth.
- **FR-028**: Explicit recommendation selection MUST still count as acceptance without another confirmation, and materially interpreted content MUST still use the existing captured-content review heading, proposal, and bottom acceptance request.
- **FR-029**: X1.7, X2.9, and X2.13 MUST keep their existing identifiers. X2.32, X2.33, X2.34, and X2.35 MUST be added at the agent-checkable tier. No other rule identifier may be added, removed, or reused.
- **FR-030**: The amendment MUST be classified major and MUST increment the Experience Standard from 4.0.0 to 5.0.0 because X1.7, X2.9, and X2.13 are redefined and previously conforming presentation can now fail.
- **FR-031**: The Sync Impact Report, version footer, rule count, internal references, and Self-Application review MUST be updated to match the amendment. The ratification date MUST stay unchanged.
- **FR-032**: The Experience Standard MUST NOT gain persistence or owner-mutation obligations. Those remain outside this standard.
- **FR-033**: This change MUST NOT update Profile, Objectives, Controls, Non-Functional Requirements, Setup, their output templates, or any skill.
- **FR-034**: Repository checks that encode Experience Standard behavior changed by this amendment MUST be updated to the amended contract. Expectations for superseded X1.7, X2.9, or X2.13 wording MUST be removed rather than preserved alongside the new contract.
- **FR-035**: Checks that require the former X2.9 order, explanation before the question, MUST instead require the question before the literal label "**Why it matters:**".
- **FR-036**: Checks for X1.7 MUST allow Decision Context governed by the revised X2.9 to follow the final response-demanding question.
- **FR-037**: Checks for X2.13 MUST verify recommendation evaluation before each unresolved guided-collection question.
- **FR-038**: Where the repository maintains corresponding Experience Standard checks, checks MUST be added for X2.32, X2.33, X2.34, and X2.35.
- **FR-039**: Checks, fixtures, snapshots, rule inventories, and version records that assert Experience Standard version 4.0.0, the superseded rule count, or the superseded amendment record MUST be updated to version 5.0.0 and the amended inventory. A skill version record that does not assert the Experience Standard version MUST NOT be retargeted.
- **FR-040**: These check changes MUST remain in repository development and review infrastructure. They MUST NOT become runtime dependencies of the Experience Standard or shipped skills.
- **FR-041**: The Experience Standard repository review MUST be run against the amended standard and MUST pass with the 5.0.0 contract as the required baseline. A review that still requires the superseded 4.0.0 contract MUST NOT be treated as passing.

### Key Entities

- **Experience Standard**: The user-visible interaction and presentation authority being amended from 4.0.0 to 5.0.0.
- **Decision Context**: The optional concise explanation of why an answer matters, shown after the question under a fixed label when it applies.
- **Guided-collection question**: One unresolved question in a guided information-collection interaction, asked only when accepted context and grounded recommendations do not already resolve the need.
- **Recommendation set**: One or more distinct actionable choices, never more than five, with wording and a user-authored alternative matched to that count.
- **Domain completion synthesis**: One optional user-relevant closing statement of what a completed Setup domain established, emitted before the next domain begins.
- **Machine-consumable owner result**: A readiness, mutation, action, or collection result used to orchestrate work and not normally shown to the person.
- **Sync Impact Report**: The amendment record stating version, classification, changed rules, preserved rules, and self-application review.
- **Repository review check**: A development or review assertion of Experience Standard behavior, version, rule inventory, or amendment record. It is not part of a shipped skill's runtime.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of reviewed presentations where Decision Context applies, one unresolved question appears before the literal "**Why it matters:**" label and exactly one concise explanation, with no second question.
- **SC-002**: In 100% of reviewed captured-content acceptance reviews, the proposal remains first and the only acceptance request remains at the bottom.
- **SC-003**: In 100% of reviewed Setup presentations, the final interaction block contains one response-demanding question or decision, and any Decision Context follows that question rather than preceding it.
- **SC-004**: In a guided collection with at least three opportunities for an unresolved question, recommendation evaluation occurs before each opportunity. Whenever accumulated accepted context supports a useful grounded choice, that choice is shown and the question is not asked.
- **SC-005**: After one accepted discovery or import, the next recommendation uses that accepted information. A generic restart question occurs zero times while a useful grounded choice remains available.
- **SC-006**: Single-recommendation prompts use singular accept, change, or alternative meaning in 100% of reviewed cases. Multiple-recommendation prompts permit one, several, all, or a user-authored alternative. Zero single-recommendation examples use "Select any of these".
- **SC-007**: A completed guided domain with meaningful accepted context produces exactly one concise synthesis and zero new questions before the next domain. A domain with nothing meaningful to summarize produces zero syntheses.
- **SC-008**: In a normal orchestrated completion, the listed machine-only result fields appear zero times unless the person requested that result. Owner and orchestrator completion statements are not both shown.
- **SC-009**: The published standard is version 5.0.0, classified major, with the ratification date unchanged, exactly four new rule identifiers (X2.32 through X2.35), and unchanged identifiers for X1.7, X2.9, and X2.13.
- **SC-010**: A comparison of the preserved rules listed in this specification finds zero wording changes, and a comparison of skills and the excluded governance baselines finds zero files changed by this amendment.
- **SC-011**: A reviewer can account for every changed rule, preserved rule, and non-normative example from the Sync Impact Report and Self-Application review without finding a copied constitution rule sentence.
- **SC-012**: The Experience Standard repository review passes against the amended standard. Zero of its Experience Standard assertions still require version 4.0.0, the explanation-before-question order, or the superseded X1.7, X2.9, or X2.13 wording. The review is not required to run a shipped skill.

## Assumptions

- The governed document is the current Highway Experience Standard, version 4.0.0, ratified 2026-09-08 and last amended 2026-09-29. This amendment records the last-amended date as 2026-10-01 and leaves the ratification date unchanged.
- The current rule table contains 35 rules. This amendment adds exactly four, for a recorded count of 39. The Sync Impact Report states the before and after counts that match the rule table.
- The document keeps a single current Sync Impact Report. The 4.0.0 report is replaced by the 5.0.0 report, and earlier reports remain available in repository history.
- "Final interaction block" means the closing portion of a Setup presentation that asks the person to respond, not an earlier framing section.
- Illustrative recommendation, synthesis, and example sentences are semantic patterns. Only the Decision Context label "**Why it matters:**" is required literal text.
- X2.25's rule sentence stays as written; only its observable is strengthened. X2.13's rule sentence stays as written; only its observable is strengthened. X1.7 and X2.9 change in both rule and observable.
- X2.3 already classifies owner-result mechanics as implementation details. X2.34 makes the orchestrated presentation consequence explicit without rewriting X2.3.
- No git branch was created for this specification because no pre-specification hook is registered.
- Later alignment of Profile, Objectives, Controls, Non-Functional Requirements, and Setup, in that order, is intentionally deferred until Experience Standard 5.0.0 is authoritative. Those skill updates are not part of this feature.
- Checks that read the Experience Standard are in scope when they encode behavior, version, inventory, or amendment text changed by this amendment. Checks that only validate an unchanged skill contract stay aligned to that skill.
- No extension hooks are registered because `.specify/extensions.yml` is absent.
