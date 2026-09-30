---

description: "Task list for simplifying the Objectives skill"
---

# Tasks: Simplify the Objectives Skill

**Input**: Design documents from `specs/105-simplify-objectives-skill/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/objectives-skill.md, contracts/objectives-record.md, quickstart.md

**Tests**: Required. The specification updates checks that still require Outcome, Significance, the suggestion sentence, `Here's the objective I've captured:`, `Anything else you'd like to accomplish?`, persist-and-verify, or the current Experience restatements. D3.6 requires each updated test to fail on the current text before the edit that makes it pass. D3.1 requires `.highway/tools/tests/run-all.sh` to exit 0 before the first edit of this feature.

**Organization**: `.highway/skills/highway-objectives/SKILL.md` is shared by every user story, so skill edits stay sequential. Test edits in different files can run together before the skill edit they cover.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5, US6)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup

**Purpose**: Confirm the current skill, record template, and Setup quotation before changing them.

- [X] T001 Confirm `.highway/skills/highway-objectives/SKILL.md` is metadata version 2.0.0, still discovers Outcome, Success, and Significance, and still contains `If you'd like some suggestions based on your organization's Profile`. Confirm `.highway/library/templates/output/objective-record.md` is template version 1.0.0 and still has `## Statement`, `## Success Measures`, and `## Rationale`. Confirm `.highway/skills/highway-setup/SKILL.md` still quotes the suggestion sentence. Do not edit those files in this task. Do not edit `.highway/governance/experience-standard.md`, `.highway/governance/constitution.md`, `.specify/memory/constitution.md`, or any `generate-*.sh` script.

---

## Phase 2: Foundational

**Purpose**: Start from a green suite.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Run `.highway/tools/tests/run-all.sh` from the repository root with unrestricted filesystem access. Expect exit 0 before any edit in this feature. If it fails, update only the failing files under `.highway/tools/tests/` until the suite exits 0, and comment each replaced assertion with the superseded behavior. Do not edit `.highway/skills/highway-objectives/SKILL.md`, `.highway/skills/highway-setup/SKILL.md`, or `.highway/library/templates/output/objective-record.md` in this task.

**Checkpoint**: Suite exits 0. Story work can begin.

---

## Phase 3: User Story 1 - Discovery uses three Objective concerns (Priority: P1) 🎯 MVP

**Goal**: Discovery evaluates Business Objective, Success, and Highway Relevance. Significance is gone. The retained record stays Statement, Success Measures, and Rationale, with no Highway Relevance field.

**Independent Test**: The skill names the three concerns, does not ask why an Objective is meaningful, and does not add a stored Highway Relevance field. `.highway/library/templates/output/objective-record.md` is unchanged.

### Tests for User Story 1

- [X] T003 [US1] In `.highway/tools/tests/objective-management.test.sh`, require `.highway/skills/highway-objectives/SKILL.md` to contain `Business Objective`, `Highway Relevance`, `## Statement`, `## Success Measures`, and `## Rationale`. Require it not to contain `if Significance is unresolved` and not to contain a persisted Highway Relevance field. Comment that Outcome, Success, and Significance discovery was superseded. Run the test and confirm it fails before the skill is edited.
- [X] T004 [P] [US1] In `.highway/tools/tests/highway-ux-alignment.test.sh`, stop requiring `Outcome evidence` in `.highway/skills/highway-objectives/SKILL.md`. Require `Business Objective` and `Highway Relevance`. Keep the existing requirements for `Success Measures`, `Why it matters:`, and the absence of `Step 1 of 3`. Comment that `Outcome evidence` was the superseded discovery label. Run the test and confirm it fails before the skill is edited.

### Implementation for User Story 1

- [X] T005 [US1] In `.highway/skills/highway-objectives/SKILL.md`, replace Outcome, Success, and Significance discovery with Business Objective, Success, and Highway Relevance as specified in `specs/105-simplify-objectives-skill/contracts/objectives-skill.md` and `specs/105-simplify-objectives-skill/data-model.md`. Remove the question about why the outcome matters. State that the retained record stays Statement, Success Measures, and Rationale and that Highway Relevance is not stored. Do not edit `.highway/library/templates/output/objective-record.md`. Re-run `.highway/tools/tests/objective-management.test.sh` and `.highway/tools/tests/highway-ux-alignment.test.sh` and confirm they exit 0.

**Checkpoint**: Discovery names three concerns and the record template is still version 1.0.0.

---

## Phase 4: User Story 2 - Grounded recommendations come first (Priority: P1)

**Goal**: Accepted Profile evidence produces a grounded recommendation before a broad question. A displayed selection is captured directly. Recommendations are not manufactured.

**Independent Test**: The skill offers a Profile-grounded recommendation without waiting for a suggestion request, captures a selection without a second confirmation, and asks the broad opening when Profile cannot ground a recommendation.

### Tests for User Story 2

- [X] T006 [US2] In `.highway/tools/tests/objective-management.test.sh`, require `.highway/skills/highway-objectives/SKILL.md` to contain `accepted Profile`, `without a second confirmation`, and `What's an important outcome you'd like to achieve?`. Require it not to contain `explicit request for suggestions`. Comment that waiting for a suggestion request was superseded. Run the test and confirm it fails before the skill is edited.

### Implementation for User Story 2

- [X] T007 [US2] In `.highway/skills/highway-objectives/SKILL.md`, state that accepted Profile evidence is the primary grounding source, that Identity, Highway Vision, and Highway Platform Objectives stay framing sources, and that existing Objectives are used for duplicate and overlap detection. Offer a grounded recommendation before an unnecessary question. Capture a selection of one, several, or all displayed recommendations directly, and keep the user-authored path available. When Profile evidence cannot ground a recommendation, ask `**What's an important outcome you'd like to achieve?**` and do not manufacture one. Prefer the accepted Organization Name. Re-run `.highway/tools/tests/objective-management.test.sh` and confirm it exits 0.

**Checkpoint**: Recommendations are grounded and a selection is direct acceptance.

---

## Phase 5: User Story 3 - Follow-ups ask only for missing information (Priority: P1)

**Goal**: The broad opening is used only when nothing is supplied and no recommendation is available. Follow-ups ask for missing Success or Highway Relevance in the specified wording.

**Independent Test**: The suggestion sentence is absent from the Objectives skill and from the Setup quotation. Missing Success and missing Highway Relevance use the questions in `specs/105-simplify-objectives-skill/contracts/objectives-skill.md`.

### Tests for User Story 3

- [X] T008 [US3] In `.highway/tools/tests/objective-management.test.sh`, require `.highway/skills/highway-objectives/SKILL.md` to contain `How would you measure success in` and `What role should technology play in helping`. Require it not to contain `If you'd like some suggestions based on your organization's Profile`. Comment that the suggestion sentence was superseded. Run the test and confirm it fails before the skill is edited.
- [X] T009 [P] [US3] In `.highway/tools/tests/highway-setup.test.sh`, stop requiring `If you'd like some suggestions based on your organization's Profile` in `.highway/skills/highway-setup/SKILL.md`. Require `What's an important outcome you'd like to achieve?` and require the suggestion sentence to be absent. Comment that the suggestion sentence was the superseded Objectives opening. Run the test and confirm it fails before Setup is edited.

### Implementation for User Story 3

- [X] T010 [US3] In `.highway/skills/highway-objectives/SKILL.md`, use the broad opening only when no Objective evidence was supplied and no useful grounded recommendation is available. Remove the suggestion sentence. Add the Success question and the Highway Relevance question from `specs/105-simplify-objectives-skill/data-model.md`, including the Organization Name and Repository Name fallback. Evaluate each answer across Business Objective, Success, and Highway Relevance. Re-run `.highway/tools/tests/objective-management.test.sh` and confirm it exits 0.
- [X] T011 [P] [US3] In `.highway/skills/highway-setup/SKILL.md`, remove the quoted sentence `If you'd like some suggestions based on your organization's Profile, just let me know.` Keep the broad question and the uncertainty sentence. State that Objectives supplies either a grounded recommendation or that opening. Do not change Setup orchestration, the purpose introduction, or the Setup version. Re-run `.highway/tools/tests/highway-setup.test.sh` and confirm it exits 0.

**Checkpoint**: Follow-ups are direct and Setup no longer quotes the suggestion sentence.

---

## Phase 6: User Story 4 - A user-authored Objective is reviewed once (Priority: P1)

**Goal**: Materially interpreted user-authored input uses the captured-content review. A selected recommendation skips it.

**Independent Test**: The review contains `Here's what I've captured as your objective:` and `**Does this objective look right?**`. The old capture heading and the malformed Success Measures label are absent.

### Tests for User Story 4

- [X] T012 [US4] In `.highway/tools/tests/objective-management.test.sh`, require `.highway/skills/highway-objectives/SKILL.md` to contain `Here's what I've captured as your objective:` and `Does this objective look right?`. Require it not to contain `Here's the objective I've captured:` and not to contain `Success Measures Success looks like:`. Comment that those two strings were superseded. Run the test and confirm it fails before the skill is edited.

### Implementation for User Story 4

- [X] T013 [US4] In `.highway/skills/highway-objectives/SKILL.md`, replace the captured review with the content in `specs/105-simplify-objectives-skill/contracts/objectives-skill.md`. Keep `**Success looks like:**` and `**Why it matters:**` as the Success Measure and Rationale labels. Do not use this review for an Objective selected from displayed recommendations. Re-run `.highway/tools/tests/objective-management.test.sh` and confirm it exits 0.

**Checkpoint**: User-authored interpretation has one review. Selected recommendations skip it.

---

## Phase 7: User Story 5 - Setup and configure keep collecting (Priority: P1)

**Goal**: Setup and configure ask the continuation question after one Objective, and once after a multi-selection. Add and new do not ask it. Readiness becoming Complete does not end collection.

**Independent Test**: The skill contains `**Is there another objective you'd like to capture?**`, states that a multi-selection is followed by that question once, and does not contain `Anything else you'd like to accomplish?`.

### Tests for User Story 5

- [X] T014 [US5] In `.highway/tools/tests/objective-management.test.sh`, require `.highway/skills/highway-objectives/SKILL.md` to contain `Is there another objective you'd like to capture?` and `once after a selection of several`. Require it not to contain `Anything else you'd like to accomplish?`. Comment that the old continuation question was superseded. Run the test and confirm it fails before the skill is edited.

### Implementation for User Story 5

- [X] T015 [US5] In `.highway/skills/highway-objectives/SKILL.md`, replace `Anything else you'd like to accomplish?` with `**Is there another objective you'd like to capture?**`. After a single captured Objective during setup or configure, ask it. After a selection of several or all displayed recommendations, capture them together and ask it once. Handle the replies in `specs/105-simplify-objectives-skill/data-model.md`. Do not end setup or configure because readiness became Complete. Direct add and new capture the selection and do not ask the continuation question. Re-run `.highway/tools/tests/objective-management.test.sh` and confirm it exits 0.

**Checkpoint**: Continuation stays open until an explicit finish, and a multi-selection asks once.

---

## Phase 8: User Story 6 - The skill keeps only Objective behavior (Priority: P2)

**Goal**: The Experience section is one sentence. Inputs, errors, verification, and persistence drop the generic restatements and the post-write byte check. The skill version is 3.0.0.

**Independent Test**: The Experience section is exactly `User-visible interaction follows the Highway Experience Standard.` The skill version is 3.0.0. No instruction requires persist-and-verify. Objectives no longer restates User Exits, Owner Outcomes, Resume Applicability, or the implementation-detail boundary.

### Tests for User Story 6

- [X] T016 [US6] In `.highway/tools/tests/objective-management.test.sh`, require `.highway/skills/highway-objectives/SKILL.md` to contain `User-visible interaction follows the Highway Experience Standard.` and `version: 3.0.0`. Require it not to contain `persist and verify`. Comment that persist-and-verify was superseded. Run the test and confirm it fails before the skill is edited.
- [X] T017 [P] [US6] In `.highway/tools/tests/highway-ux-alignment.test.sh`, exempt `highway-objectives` from the requirements for `implementation details`, `User Exits`, `Owner Outcomes`, and `Resume Applicability`, using the same exemption Profile already has. Require `.highway/skills/highway-objectives/SKILL.md` not to contain `User Exits`. Comment that those restatements were superseded and stay with the Highway Experience Standard. Run the test and confirm it fails before the skill is edited.
- [X] T018 [P] [US6] In `.highway/tools/tests/experience-x23-contract.test.sh`, stop requiring `.highway/skills/highway-objectives/SKILL.md` to restate the implementation-detail boundary. Require that file not to contain `implementation details`. Comment that the restatement was superseded and the skill cites the Highway Experience Standard instead. Do not edit `.highway/governance/experience-standard.md`. Run the test and confirm it fails before the skill is edited.

### Implementation for User Story 6

- [X] T019 [US6] In `.highway/skills/highway-objectives/SKILL.md`, set metadata version to 3.0.0. Set the Experience section to exactly `User-visible interaction follows the Highway Experience Standard.` Remove restatements of one-question behavior, Decision Context, acknowledgments, implementation details, recommendation acceptance, examples, progress, confirmation behavior, User Exits, Owner Outcomes, and Resume Applicability. Simplify Inputs to the context sources and roles in `specs/105-simplify-objectives-skill/data-model.md`. Replace Error Handling with the three Objective exceptions in `specs/105-simplify-objectives-skill/contracts/objectives-skill.md`. Replace Verification with the checks in spec FR-034. Describe persistence as successful atomic persistence and remove post-write byte, file-existence, and retained-output verification. Replace the example with an inline invocation that does not repeat the version. Re-run `.highway/tools/tests/objective-management.test.sh`, `.highway/tools/tests/highway-ux-alignment.test.sh`, and `.highway/tools/tests/experience-x23-contract.test.sh` and confirm they exit 0.

**Checkpoint**: The skill is version 3.0.0 and cites the Experience Standard in one sentence.

---

## Phase 9: Polish

**Purpose**: Regenerate copies and confirm the suite.

- [X] T020 Run `.highway/tools/generate-agent-adapters.sh` from the repository root. Run it a second time and confirm the second run leaves no further diff. Run `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, and `.highway/tools/generate-instructions.sh`. Confirm the highway-objectives catalog entry is version 3.0.0 and that other entry fields are unchanged aside from a generation timestamp. Do not hand-edit generated skill copies or `.highway/catalog/library-index.md`.
- [X] T021 Run `.highway/tools/tests/run-all.sh` from the repository root with unrestricted filesystem access. Expect exit 0.
- [X] T022 [P] Walk steps 3 through 5 of `specs/105-simplify-objectives-skill/quickstart.md`. Confirm the diff does not include `.highway/governance/experience-standard.md`, `.highway/governance/constitution.md`, `.specify/memory/constitution.md`, `.highway/library/templates/output/objective-record.md`, `.highway/library/templates/output/objective-catalog.md`, or `.highway/skills/highway-profile/SKILL.md`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup. Blocks all user stories.
- **User Stories (Phases 3–8)**: Depend on Foundational. Later stories edit the same Objectives skill, so they stay in phase order.
- **Polish (Phase 9)**: Depends on User Story 6.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. No dependency on later stories.
- **User Story 2 (P1)**: Starts after User Story 1 because both edit `.highway/skills/highway-objectives/SKILL.md` and `.highway/tools/tests/objective-management.test.sh`.
- **User Story 3 (P1)**: Starts after User Story 2. The Setup quotation is independent of the Objectives skill edit once its test fails.
- **User Story 4 (P1)**: Starts after User Story 3 because it edits the same Objectives test and skill.
- **User Story 5 (P1)**: Starts after User Story 4 because it edits the same Objectives test and skill.
- **User Story 6 (P2)**: Starts after User Story 5. Its highway-ux edit depends on T004.

### Parallel Opportunities

- T003 and T004 can run together.
- T008 and T009 can run together. T010 and T011 can run together after those tests fail.
- T016, T017, and T018 can run together.
- T022 can run with T021 after T020.

---

## Parallel Example: User Story 3

```bash
# Fail the two opening tests together:
Task: "Update .highway/tools/tests/objective-management.test.sh for the Success and Highway Relevance questions"
Task: "Update .highway/tools/tests/highway-setup.test.sh so the suggestion sentence is absent"

# After both fail, edit the two skills together:
Task: "Update the opening and follow-ups in .highway/skills/highway-objectives/SKILL.md"
Task: "Remove the quoted suggestion sentence from .highway/skills/highway-setup/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3.
3. Stop and confirm discovery names Business Objective, Success, and Highway Relevance, and that `.highway/library/templates/output/objective-record.md` is still version 1.0.0.

### Incremental Delivery

1. Add User Story 2 for grounded recommendations.
2. Add User Story 3 for direct follow-ups and the Setup quotation.
3. Add User Story 4 for the captured-content review.
4. Add User Story 5 for continuation.
5. Add User Story 6 for the Experience sentence, error handling, verification, and version 3.0.0.
6. Regenerate copies and run the suite.

---

## Notes

- [P] tasks use different files and do not depend on an unfinished task.
- Do not edit `.highway/library/templates/output/objective-record.md` or `.highway/library/templates/output/objective-catalog.md`.
- Do not edit `.highway/governance/experience-standard.md`, `.highway/governance/constitution.md`, or `.specify/memory/constitution.md`.
- A replaced assertion names the superseded behavior in a comment.
- Mark a task `[X]` only after its outcome is true.
