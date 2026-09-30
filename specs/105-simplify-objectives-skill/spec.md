# Feature Specification: Simplify the Objectives Skill

**Feature Branch**: `105-simplify-objectives-skill`

**Created**: 2026-09-29

**Status**: Draft

**Input**: User description: "Rewrite highway-objectives around Objective-specific semantics and workflow. Cite the Experience Standard in one sentence. Replace Outcome, Success, and Significance with Business Objective, Success, and Highway Relevance. Offer grounded recommendations from accepted Profile evidence before asking, and capture a selection without a second confirmation. Keep the broad opening only when no Objective evidence and no grounded recommendation are available. Use direct follow-ups and a fixed captured-content review for materially interpreted user-authored Objectives. Keep setup and configure collecting until the person explicitly finishes. Remove post-write persistence verification and generic Constitution and Experience Standard restatements. Raise the skill from 2.0.0 to 3.0.0 and leave the Objective record template unchanged."

## Background

Objectives keeps the repository's Business Objective baseline. The skill currently discovers each Objective across Outcome, Success, and Significance, waits for the person to ask for suggestions, and verifies retained bytes after writing.

The Experience Standard already governs one-question behavior, Decision Context, acknowledgments, implementation-detail suppression, recommendation acceptance, examples, progress, and confirmation. The Constitution already governs consuming relevant context, preferring active user evidence, refusing fabricated context, excluding unavailable optional context, and the common failure model. The skill repeats those rules beside the Objective behavior.

Profile now supplies Identity, Vision, Competitive Path, Guiding Principles, and optional accepted context. Objectives still describes suggestions as something the person must request, and it still asks why an Objective is meaningful.

The current skill version is 2.0.0. The retained Objective record remains Statement, Success Measures, and Rationale.

## Clarifications

### Session 2026-09-29

- Q: When someone selects several Objectives at once during setup or configure, when should Highway ask whether there is another Objective? → A: Capture every selected Objective, then ask once.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Discovery uses three Objective concerns (Priority: P1)

As a person capturing an Objective, I want Highway to learn what the organization wants to accomplish, how success will be known, and what Highway needs in order to connect that Objective to later technology work, so that I am not asked why the Objective is important.

**Why this priority**: This replaces the discovery model. Recommendations, follow-ups, and the retained review all depend on it.

**Independent Test**: Discovery evaluates Business Objective, Success, and Highway Relevance. Significance is absent. The retained record still has Statement, Success Measures, and Rationale, and it has no Highway Relevance field.

**Acceptance Scenarios**:

1. **Given** an Objective is being captured, **When** discovery evaluates the evidence, **Then** it uses Business Objective for what the organization wants to accomplish, Success for how the organization will know it succeeded, and Highway Relevance for the context Highway needs to connect the Objective to technology, governance, architecture, implementation, automation, or operations.
2. **Given** the amended skill, **When** discovery, follow-ups, verification, and the example are read, **Then** Significance is absent as a discovery requirement and no question asks why the Objective is meaningful or important.
3. **Given** accepted Profile evidence and the active Objective evidence already establish useful downstream relevance, **When** discovery chooses the next question, **Then** it does not ask a Highway Relevance question.
4. **Given** a captured Objective is retained, **When** the record is read, **Then** it still contains Statement, Success Measures, and Rationale, and it does not contain a Highway Relevance field.

---

### User Story 2 - Grounded recommendations come first (Priority: P1)

As a person whose Profile already describes the organization, I want useful Objective recommendations before I am asked to invent one, so that I can select what fits and still write my own when I want to.

**Why this priority**: The opening behavior changes only when a grounded recommendation exists. This story can be tested with accepted Profile evidence and no Objective yet.

**Independent Test**: Accepted Profile evidence that supports a useful Objective produces a recommendation before any broad question. A selection of one, several, or all displayed recommendations is captured directly. When Profile cannot ground a recommendation, the broad opening question is asked and no recommendation is invented.

**Acceptance Scenarios**:

1. **Given** accepted Profile evidence supports a useful Objective and the person has not supplied an Objective, **When** setup or configure begins, **Then** Highway offers that grounded recommendation before asking a question and does not wait for a suggestion request.
2. **Given** displayed recommendations, **When** the person selects one, several, or all of them, **Then** each selected Objective is captured as accepted and no second proposal-confirmation is requested.
3. **Given** recommendations are displayed, **When** the person wants to author an Objective instead, **Then** the user-authored path remains available.
4. **Given** accepted Profile evidence cannot ground a useful Objective, **When** collection needs an Objective, **Then** Highway asks `**What's an important outcome you'd like to achieve?**` and does not manufacture a recommendation.
5. **Given** an accepted Organization Name in Profile, **When** a recommendation is phrased for the person, **Then** that name is preferred in the contextual language.
6. **Given** existing Objectives, **When** a new Objective is considered, **Then** they are used to detect duplicates and overlap.
7. **Given** Identity, Highway Vision, or Highway Platform Objectives, **When** an Objective recommendation is grounded, **Then** those sources keep their declared Highway framing roles and are not treated as organizational facts.

---

### User Story 3 - Follow-ups ask only for missing information (Priority: P1)

As a person who has already stated an Objective, I want the next question to ask for the missing piece in plain language, so that I do not restate what Highway already understands.

**Why this priority**: Follow-ups are the conversation after either a user-authored start or a recommendation that still lacks Success or Highway Relevance.

**Independent Test**: A missing Success measure produces one direct question tied to the stated Objective. A missing Highway Relevance produces one technology-relevant question. Each answer is evaluated across all three concerns before another question is asked.

**Acceptance Scenarios**:

1. **Given** no supplied Objective evidence and no useful grounded recommendation, **When** collection starts, **Then** the opening is exactly `**What's an important outcome you'd like to achieve?**`.
2. **Given** the opening is shown, **When** the prompt is read, **Then** it does not tell the person to ask for suggestions.
3. **Given** Success evidence is missing, **When** Highway asks, **Then** the question is `**How would you measure success in [stated objective]?**`.
4. **Given** Highway Relevance is missing and an Organization Name has been accepted, **When** Highway asks, **Then** the question is `**What role should technology play in helping [Organization Name] achieve this objective?**`.
5. **Given** an answer arrives, **When** Highway decides whether to ask again, **Then** it has evaluated that answer across Business Objective, Success, and Highway Relevance.
6. **Given** Highway already understands the information, **When** the next prompt is chosen, **Then** the person is not asked to restate it in more formal language.

---

### User Story 4 - A user-authored Objective is reviewed once (Priority: P1)

As a person whose words Highway has interpreted into an Objective, I want to see the captured Objective and accept it once, so that I can correct a synthesis before it is kept.

**Why this priority**: The review is the acceptance boundary for interpreted text. Selected recommendations do not use it.

**Independent Test**: Materially interpreted user-authored input is shown in the captured-content review and kept only after the person accepts it. An Objective selected from displayed recommendations skips that review.

**Acceptance Scenarios**:

1. **Given** Highway materially interprets or synthesizes user-authored input, **When** it asks the person to review the Objective, **Then** the review follows the Experience Standard's material-interpretation review and contains `Here's what I've captured as your objective:`, the Objective title, the Statement, `**Success looks like:**`, each Success Measure, `**Why it matters:**`, the Rationale, and `**Does this objective look right?**`.
2. **Given** the amended skill, **When** the review text is read, **Then** `Here's the objective I've captured:` and `Success Measures Success looks like:` are absent.
3. **Given** the person explicitly selects an Objective from displayed recommendations, **When** that Objective is captured, **Then** this review is not used.

---

### User Story 5 - Setup and configure keep collecting (Priority: P1)

As a person setting up Objectives, I want Highway to ask whether I have another Objective after a capture, so that one completed Objective does not end the conversation.

**Why this priority**: Continuation is independent of discovery quality. It changes when setup and configure stop.

**Independent Test**: After a single captured Objective, and once after a multi-selection is captured together, setup and configure ask the continuation question. They stop when the person explicitly finishes. Add and new capture the requested Objective and do not ask that question. Readiness becoming Complete does not end an active setup or configure.

**Acceptance Scenarios**:

1. **Given** setup or configure has just captured one Objective, **When** Highway continues, **Then** it asks exactly `**Is there another objective you'd like to capture?**`.
2. **Given** setup or configure and a selection of several displayed recommendations, **When** those Objectives are captured, **Then** Highway asks that question once after the whole selection and does not ask it between the selected Objectives.
3. **Given** that question, **When** the person supplies another Objective, **Then** Highway begins processing it immediately.
4. **Given** that question, **When** the person says yes and does not supply an Objective, **Then** Highway asks `**What's another important outcome you'd like to achieve?**`.
5. **Given** that question, **When** the person asks for suggestions, **Then** Highway presents grounded Objective recommendations.
6. **Given** that question, **When** the person explicitly finishes, **Then** Objective collection ends and Highway returns the terminal owner result.
7. **Given** readiness is Complete after the first Objective, **When** setup or configure is still active, **Then** collection continues until the person explicitly finishes.
8. **Given** a direct add or new, **When** its Objective is captured, **Then** the operation ends without asking whether another Objective should be captured.

---

### User Story 6 - The skill keeps only Objective behavior (Priority: P2)

As a skill author, I want highway-objectives to state Objective behavior and point at the Experience Standard and the Constitution for shared rules, so that the skill no longer repeats them or checks bytes after writing.

**Why this priority**: The shorter skill is how the behavior above stays maintainable. It follows the domain stories because verification has to describe them.

**Independent Test**: The Experience section is one sentence. Inputs name context sources and their Objective roles. Error handling lists only Objective exceptions. Verification matches the new discovery, recommendation, review, continuation, and persistence behavior. The skill version is 3.0.0 and the Objective record template is unchanged.

**Acceptance Scenarios**:

1. **Given** the amended skill, **When** its Experience section is read, **Then** it is exactly `User-visible interaction follows the Highway Experience Standard.`
2. **Given** the amended skill, **When** its behavior sections are read, **Then** they do not restate one-question behavior, Decision Context, acknowledgments, implementation-detail suppression, recommendation acceptance, examples, progress, or confirmation behavior.
3. **Given** a retained Objective, **When** Objectives persists it, **Then** persistence is successful atomic persistence and the skill does not require a post-write persistence check, a retained-output check, a file-existence check, or a byte-equality check whose purpose is confirming that write.
4. **Given** the amended skill, **When** Inputs are read, **Then** they name the context sources and their Objective-specific roles, and they do not restate the generic rules for relevant context, active user evidence, fabricated context, or unavailable optional context.
5. **Given** a Profile baseline that is Blocked, **When** Objective behavior depends on accepted Profile evidence, **Then** that behavior cannot proceed.
6. **Given** readiness is assessed, **When** the result is shown, **Then** it uses Status, Summary, Next Action, and Blocking Reason, with Status Complete, Missing, or Blocked.
7. **Given** the amended skill and the Objective record template, **When** their versions and structure are read, **Then** the skill is 3.0.0 and the template still governs Statement, Success Measures, and Rationale.

---

### Edge Cases

- Accepted Profile evidence can ground a recommendation before any Objective has been typed. The broad opening is reserved for the case with neither supplied Objective evidence nor a useful grounded recommendation.
- A recommendation is not invented to fill an empty Profile. The broad opening question is used instead.
- Selecting every displayed recommendation captures each selected Objective. During setup or configure, the continuation question is asked once after that capture. During add or new, the selected Objectives are captured and the operation ends without the continuation question.
- A user-authored statement that already supplies an Objective, a success measure, and useful Highway Relevance is not followed by a question for information Highway already has.
- Highway Relevance already supported by accepted Profile evidence and the active Objective evidence produces no relevance question.
- The captured-content review is used for material interpretation of user-authored input. A recommendation the person selected skips that review.
- `**Why it matters:**` in that review is the label for the retained Rationale. It is Objective review content.
- An answer that is neither another Objective, an agreement to continue, a suggestion request, nor an explicit finish does not end setup or configure. Highway asks `**Is there another objective you'd like to capture?**` again.
- Readiness can be Complete after one valid Objective while setup or configure is still collecting.
- Add and new remain single collection cycles. They do not ask whether another Objective should be captured.
- A malformed Objective record, catalog, or allocation state is Blocked and is not mutated.
- Update or remove of an Objective that cannot be resolved stops and identifies the target.
- Remove and reset use the Experience Standard's destructive-confirmation behavior.
- Profile Blocked stops Objective behavior that depends on accepted Profile evidence. It does not, by itself, block a user-authored Objective that does not need that evidence.
- Existing Objectives can show a duplicate or an overlap. They are not a source of new organizational facts.
- Identity, Highway Vision, and Highway Platform Objectives can frame Highway behavior. They are not organizational facts.
- An accepted Organization Name is preferred in recommendation language and in the Highway Relevance question. When that name is absent and a Repository Name has been accepted, the Repository Name is used where it reads naturally. When neither name has been accepted, the relevance question does not insert a name.
- The Objective record template stays on Statement, Success Measures, and Rationale. Highway Relevance is discovery context and is not a stored field.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: highway-objectives MUST state Objective-specific behavior. Its Experience section MUST be exactly `User-visible interaction follows the Highway Experience Standard.`
- **FR-002**: The skill MUST NOT restate one-question behavior, Decision Context, acknowledgments, implementation-detail suppression, recommendation acceptance, examples, progress, or confirmation behavior. Those behaviors follow the Highway Experience Standard.
- **FR-003**: Discovery MUST use Business Objective, Success, and Highway Relevance. Business Objective is what the organization wants to accomplish. Success is how the organization will know it succeeded. Highway Relevance is the context Highway needs to connect the Objective to technology, governance, architecture, implementation, automation, or operations.
- **FR-004**: Significance MUST be removed as a discovery requirement. The skill MUST NOT ask a generic follow-up about why an Objective is meaningful or important.
- **FR-005**: The retained Objective structure MUST remain Statement, Success Measures, and Rationale. The skill MUST NOT add a persisted Highway Relevance field. `objective-record.md` MUST remain unchanged while that structure stays compatible.
- **FR-006**: A Highway Relevance follow-up MUST NOT be asked when accepted Profile evidence and active Objective evidence already establish useful downstream relevance.
- **FR-007**: Accepted Profile evidence MUST be the primary organizational grounding source for Objective recommendations. Profile grounding MUST use Identity, Vision, Competitive Path, Guiding Principles, and optional accepted context.
- **FR-008**: Existing Objectives MUST be used for duplicate and overlap detection. They MUST NOT be treated as a source of new organizational facts.
- **FR-009**: Identity, Highway Vision, and Highway Platform Objectives MUST be used only for their declared Highway framing roles. They MUST NOT be treated as organizational facts.
- **FR-010**: When accepted Profile evidence supports a useful Objective, Highway MUST offer that grounded recommendation before asking an unnecessary question. It MUST NOT wait for an explicit suggestion request.
- **FR-011**: Contextual recommendation language MUST prefer the accepted Organization Name from Profile.
- **FR-012**: The user-authored Objective path MUST remain available whenever recommendations are presented.
- **FR-013**: When the person selects one, several, or all displayed recommendations, Highway MUST treat that selection as acceptance and MUST capture those Objectives directly, without another proposal-confirmation cycle.
- **FR-014**: Highway MUST NOT manufacture an Objective recommendation when accepted Profile evidence cannot ground it. It MUST ask `**What's an important outcome you'd like to achieve?**` instead.
- **FR-015**: The broad opening `**What's an important outcome you'd like to achieve?**` MUST be used only when there is no supplied Objective evidence and no useful grounded recommendation to present first. The sentence that tells the person to ask for suggestions MUST be removed.
- **FR-016**: Follow-up questions MUST be short, direct, and anchored to the Objective already stated. Missing Success evidence MUST use `**How would you measure success in [stated objective]?**`. Missing Highway Relevance MUST use one direct question, `**What role should technology play in helping [Organization Name] achieve this objective?**`, when an Organization Name has been accepted.
- **FR-017**: Highway MUST ask for missing information. It MUST NOT ask the person to restate information Highway already understands in more formal language.
- **FR-018**: Each answer MUST be evaluated across Business Objective, Success, and Highway Relevance before Highway decides whether another question is needed.
- **FR-019**: When Highway materially interprets or synthesizes user-authored input into an Objective, it MUST use the Experience Standard's material-interpretation review. The Objective-specific content of that review MUST be `Here's what I've captured as your objective:`, the Objective title, the Statement, `**Success looks like:**`, each Success Measure, `**Why it matters:**`, the Rationale, and `**Does this objective look right?**`.
- **FR-020**: The skill MUST NOT contain `Here's the objective I've captured:` or `Success Measures Success looks like:`.
- **FR-021**: The captured-content review MUST NOT be used for an Objective the person explicitly selected from displayed Highway recommendations.
- **FR-022**: For setup and configure, accepting or selecting one Objective MUST NOT finish collection. After a single captured Objective, and once after a selection of several or all displayed recommendations has been captured together, Highway MUST ask exactly `**Is there another objective you'd like to capture?**`. It MUST NOT ask that question between Objectives in the same selection.
- **FR-023**: Continuation MUST treat a supplied Objective as the start of processing, an agreement without an Objective as the cue to ask `**What's another important outcome you'd like to achieve?**`, a suggestion request as the cue to present grounded recommendations, and an explicit finish as the end of collection and the return of the terminal owner result.
- **FR-024**: Setup and configure MUST repeat continuation until the person explicitly finishes. Readiness becoming Complete after the first Objective MUST NOT end an active setup or configure.
- **FR-025**: Direct add and new MUST remain single-Objective collection cycles. They MUST NOT ask whether another Objective should be captured.
- **FR-026**: The skill MUST remove post-write persistence verification and retained-output verification. It MUST NOT require a shell check, a file-existence check, a byte-equality check, or an equivalent check whose sole purpose is confirming persistence. Persistence MUST be described as successful atomic persistence.
- **FR-027**: The skill MUST preserve independent baseline validation, duplicate detection, semantic-overlap handling, permanent identifier allocation without reuse, deterministic catalog generation, and atomic record and catalog mutation.
- **FR-028**: User-visible Objective results MUST NOT narrate allocation, catalog updates, persistence, validation, routing, or other implementation mechanics.
- **FR-029**: Inputs MUST declare the context sources and their Objective-specific roles. The skill MUST NOT restate these generic context rules: consume only relevant context, active user evidence wins, missing context is not fabricated, and unavailable optional context is excluded.
- **FR-030**: When the Profile baseline is Blocked, Objective behavior that depends on accepted Profile evidence MUST NOT proceed.
- **FR-031**: Readiness MUST remain `Status: <Complete, Missing, or Blocked>`, `Summary: <objective baseline explanation>`, `Next Action: <owner route or None>`, and `Blocking Reason: <reason or None>`. No valid Objective MUST be Missing. At least one valid Objective with consistent catalog and allocation state MUST be Complete. A malformed Objective baseline MUST be Blocked. Collection completion MUST stay separate from readiness.
- **FR-032**: Error handling MUST list only Objective-specific exceptions to the common failure model: a malformed Objective record, catalog, or allocation state is Blocked and is not mutated; an unresolved Objective target for update or remove stops and identifies the target; destructive Objective removal or reset follows the Experience Standard's destructive-confirmation behavior.
- **FR-033**: Error handling MUST NOT restate generic project-root, user-exit, mutation-failure, or unexpected-failure handling.
- **FR-034**: Verification MUST confirm that retained Objective records follow `objective-record.md`; readiness and mutation outputs preserve their declared contracts; Business Objective, Success, and Highway Relevance replace Outcome, Success, and Significance; recommendations are grounded primarily in accepted Profile evidence; useful grounded recommendations are offered before unnecessary questions; selected recommendations are captured without redundant confirmation; user-authored materially interpreted Objectives use the captured-content review; follow-ups are direct and tied to the stated Objective; Highway Relevance follow-ups stay relevant to technology, governance, architecture, implementation, automation, or operations; setup and configure continue until explicit finish; add and new remain single-Objective operations; duplicate and overlap handling, permanent identifiers, catalog allocation, deterministic output, and atomic persistence remain intact; no post-write persistence-verification requirement remains; and generic Experience Standard and Constitution requirements are not restated.
- **FR-035**: The highway-objectives version MUST move from 2.0.0 to 3.0.0.

### Key Entities

- **Business Objective**: What the organization wants to accomplish. In the retained record this is the Statement.
- **Success**: How the organization will know the Objective succeeded. In the retained record these are the Success Measures.
- **Highway Relevance**: Discovery context Highway needs to connect the Objective to technology, governance, architecture, implementation, automation, or operations. It is not a stored field.
- **Rationale**: The retained explanation shown in review as `**Why it matters:**`. It is filled from accepted user evidence, accepted Profile evidence, or material interpretation.
- **Objective recommendation**: A proposed Objective grounded in accepted Profile evidence. A displayed selection is acceptance.
- **Continuation**: The setup and configure question that asks whether another Objective should be captured.
- **Readiness result**: Status, Summary, Next Action, and Blocking Reason for the persisted Objective baseline.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Discovery names exactly 3 concerns: Business Objective, Success, and Highway Relevance. 0 discovery obligations require Significance or a question about why the Objective is meaningful. 0 retained Objective records gain a Highway Relevance field.
- **SC-002**: When accepted Profile evidence supports a useful Objective, 100% of setup and configure starts offer a grounded recommendation before a broad question. 100% of displayed selections are captured without a second confirmation. 0 recommendations are manufactured when Profile evidence cannot ground them.
- **SC-003**: 100% of openings with neither supplied Objective evidence nor a useful grounded recommendation use `**What's an important outcome you'd like to achieve?**`. 0 of those openings tell the person to ask for suggestions. 100% of missing-Success follow-ups use the stated Objective, and 100% of missing-Highway-Relevance follow-ups ask one technology-relevant question.
- **SC-004**: 100% of materially interpreted user-authored Objectives use the captured-content review, including `Here's what I've captured as your objective:` and `**Does this objective look right?**`. 100% of Objectives selected from displayed recommendations skip that review.
- **SC-005**: 100% of single Objective captures during setup or configure are followed by `**Is there another objective you'd like to capture?**`. A selection of several Objectives is followed by that question once. 0 setup or configure sessions end only because readiness became Complete. 100% of direct add and new operations end without that continuation question.
- **SC-006**: The skill version is 3.0.0. The Experience section is 1 sentence. 0 skill instructions require a post-write persistence check, a byte-equality check, or a file-existence check whose purpose is confirming persistence. The Objective record template still defines Statement, Success Measures, and Rationale.

## Assumptions

- The skill version moves from 2.0.0 to 3.0.0 because discovery, acceptance, recommendations, continuation, and verification break the current skill contract. The Objective record template stays at its current version because Statement, Success Measures, and Rationale remain the retained structure.
- The Experience section remains a level-two section. Its text becomes the one follow sentence. The sentence `The Experience Standard remains the normative authority for user-visible interaction.` is not added.
- `**Why it matters:**` stays inside the captured-content review as the label for Rationale. The skill does not also restate an Experience Standard presentation rule under that name.
- When Organization Name is absent, the Highway Relevance question uses an accepted Repository Name where it reads naturally. When neither name is accepted, the question is asked without an inserted name.
- During add or new, a selection of several displayed recommendations is still captured in full because the person selected them. The operation then ends. "Single-Objective" means add and new do not enter the continuation cycle.
- An explicit finish is a refusal to capture another Objective or another clear statement that collection is done. Agreement without an Objective is not a finish.
- A continuation reply that supplies neither an Objective, an agreement, a suggestion request, nor an explicit finish causes the same continuation question to be asked again.
- The terminal owner result is the result the active setup or configure already returns when collection ends, including the Objective readiness result when that is the owning result. It does not add a persistence-verification report.
- Existing readiness routes stay with the preserved result: Missing uses `/highway-objectives setup`, Complete uses Next Action None, and Blocked uses Next Action None with a non-empty Blocking Reason.
- Baseline version increments stay with the catalog contract: add and new are MINOR, update is PATCH, and remove and reset are MAJOR. Those increments are not narrated as implementation mechanics.
- Checks that still require Outcome, Significance, a suggestion request before recommendations, `Here's the objective I've captured:`, `Anything else you'd like to accomplish?`, persist-and-verify, or the current multi-paragraph Experience section are updated with this change. A replaced check names the superseded behavior.
- Copies of the skill distributed to supported agents stay aligned with the source skill.
- This feature does not amend the Experience Standard, the Skills Constitution, the development constitution, the Objective record template, the Objective catalog template, or the Profile skill. highway-setup is updated only where it quotes the Objectives opening that tells the person to ask for suggestions. Setup orchestration stays as it is.
