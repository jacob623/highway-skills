---
description: "Task list for guided flow refinements across Profile, Objectives, Controls, and NFRs"
---

# Tasks: Guided Flow Refinements

**Input**: Design documents from `/specs/194-guided-flow-refinements/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request test-first work. The plan adds one contract check because the behavior change must add a test. No current test asserts the replaced copy.

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before the four skills change

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/194-guided-flow-refinements/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Fix what must not change

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Confirm the batch review, `capture`, `write`, and stored `review` sections in `.highway/skills/highway-objectives/SKILL.md`, `.highway/skills/highway-controls/SKILL.md`, and `.highway/skills/highway-nfrs/SKILL.md` stay as they are. Confirm the **No system hosting** and **Direct purchase** text in `.highway/skills/highway-nfrs/SKILL.md` and the Request mapping in `.highway/skills/highway-request/SKILL.md` stay as they are. Do not edit `.highway/skills/highway-discovery/SKILL.md`

**Checkpoint**: Only presentation, reply handling, and NFR recommendation order will change

---

## Phase 3: User Story 1 - Read Profile starting points clearly (Priority: P1) 🎯 MVP

**Goal**: Each Profile starting-point label is bold, with its content in its own paragraph beneath it

**Independent Test**: `.highway/skills/highway-profile/SKILL.md` matches the Profile starting points in `specs/194-guided-flow-refinements/contracts/guided-flow-copy.md`, and no plain `- Future Direction` label remains

### Implementation for User Story 1

- [X] T003 [P] [US1] In the Vision starting point of `.highway/skills/highway-profile/SKILL.md`, change each of Future Direction, Desired Impact, and Future State to `- **[Label]**`, a blank line, then `  [Inferred from accepted context.]`
- [X] T004 [US1] In `.highway/skills/highway-profile/SKILL.md`, apply the same form to Competitive Path (Primary Approach, Strategic Advantage, Important Tradeoff) and to the Guiding Principles item: `- **[Short principle name]**`, a blank line, then `  [Accepted-evidence decision-making value.]`

**Checkpoint**: All three Profile starting points show bold labels with content on its own line

---

## Phase 4: User Story 2 - Choose recommendations from a numbered list (Priority: P1)

**Goal**: Every recommendation set is numbered, numbers select, and each set closes with the approved copy

**Independent Test**: Each of the three skills uses `1. **[Title]:** [One sentence.]` in every set, classifies numbers as `select`, and closes every set with the copy in `specs/194-guided-flow-refinements/contracts/guided-flow-copy.md`. "If none of these fit" and "just let me know" no longer appear

### Implementation for User Story 2

- [X] T005 [P] [US2] In `.highway/skills/highway-objectives/SKILL.md`: change `select` in `Classify` to name recommendations by title or by number. In `recommend` and `queue`, change every `- **[Title]:** [One sentence.]` to `1. **[Title]:** [One sentence.]` and add "Number every recommendation in the set, starting at 1." In `queue`, add "A number in the reply refers to the recommendation set, not the queue list." Replace each "If none of these fit, feel free to suggest your own outcome." plus its question with the question, then "You can select some, all or provide your own outcome.", then "If you'd like additional suggestions, just say so." In the queue-has-items set, remove "If none of these fit, feel free to suggest your own outcome. If you'd like additional suggestions, just let me know." and follow its existing question with the same two lines
- [X] T006 [P] [US2] In `.highway/skills/highway-controls/SKILL.md`, make the T005 changes with the Controls copy: "You can select some, all or provide your own safeguards." and the safeguard question
- [X] T007 [P] [US2] In `.highway/skills/highway-nfrs/SKILL.md`, make the T005 changes with the NFRs copy: "You can select some, all or provide your own operational expectation." and the operational-expectation question. **No system hosting** and **Direct purchase** are numbered items in the first set using their title and statement

**Checkpoint**: Every set in the three skills is numbered and closes with the approved copy

---

## Phase 5: User Story 3 - Add one more item before review (Priority: P2)

**Goal**: Each ready-to-review question after recommendations run out is followed by the add-another line

**Independent Test**: In `more` and in the queue's exhaustion message, each skill's ready-to-review question is followed by its line from `specs/194-guided-flow-refinements/contracts/guided-flow-copy.md`

### Implementation for User Story 3

- [X] T008 [P] [US3] In `.highway/skills/highway-objectives/SKILL.md`, after both **Are you ready to review the selected objectives?** lines, add a blank line and "If you'd like to add another outcome first, just say so."
- [X] T009 [P] [US3] In `.highway/skills/highway-controls/SKILL.md`, after both **Are you ready to review the selected Controls?** lines, add a blank line and "If you'd like to add another safeguard first, just say so."
- [X] T010 [P] [US3] In `.highway/skills/highway-nfrs/SKILL.md`, after both **Are you ready to review the selected NFRs?** lines, add a blank line and "If you'd like to add another operational expectation first, just say so."

**Checkpoint**: The person is told they can add their own item before review

---

## Phase 6: User Story 4 - NFRs that follow from Controls (Priority: P2)

**Goal**: NFR recommendations come from accepted Controls first until every Control is reflected

**Independent Test**: `.highway/skills/highway-nfrs/SKILL.md` `recommend` states the Control-first rules in `specs/194-guided-flow-refinements/contracts/guided-flow-copy.md`, and an unreflected Control counts as a remaining recommendation

### Implementation for User Story 4

- [X] T011 [US4] In `recommend` of `.highway/skills/highway-nfrs/SKILL.md`, replace rules 1 to 3. While an accepted Control is not reflected by a queued, shown, or captured NFR, derive each recommendation from accepted Controls, and use the accepted Profile and Objectives to refine scope, priority, and wording. A set then contains only Control-derived recommendations, plus **No system hosting** and **Direct purchase** in the first set. One NFR may reflect more than one Control. After every accepted Control is reflected, check coverage across the existing areas and add a grounded expectation from the accepted Profile, accepted Objectives, or an uncovered area only when it would reasonably benefit this organization. State that an unreflected Control is a remaining grounded recommendation, so `more` and `queue` do not show the exhaustion message while one remains. Keep rules 4 to 6 and the limit text unchanged

**Checkpoint**: Every accepted Control is reflected before other NFR sources are used

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Publish the edited skills and prove the suite is green

- [X] T012 [P] Add `.highway/tools/tests/guided-flow-refinements.test.sh` with instrument-class and artifact-class comments. Require the bold Profile labels, the numbered item form, the number rule, each closing line, each add-another line, and the NFR Control-first sentences. Fail when "If none of these fit", "just let me know", `- **[Title]:** [One sentence.]`, or a plain `- Future Direction` remains in the four skills
- [X] T013 [P] Bump versions: `.highway/skills/highway-profile/SKILL.md` 13.0.0 to 14.0.0, `.highway/skills/highway-objectives/SKILL.md` 6.0.0 to 7.0.0, `.highway/skills/highway-controls/SKILL.md` 6.0.0 to 7.0.0, `.highway/skills/highway-nfrs/SKILL.md` 7.0.0 to 8.0.0
- [X] T014 Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-profile`, `.highway/skills/highway-objectives`, `.highway/skills/highway-controls`, and `.highway/skills/highway-nfrs`. Repair only reported authoring-rule failures
- [X] T015 Run `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh` so the catalog and published copies match the edited sources
- [X] T016 Run `.highway/tools/tests/run-all.sh` and require exit 0
- [X] T017 Execute the checks in `specs/194-guided-flow-refinements/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Story 1 (Phase 3)**: Depends on Foundational. Independent of the other stories
- **User Story 2 (Phase 4)**: Depends on Foundational. Independent of User Story 1
- **User Story 3 (Phase 5)**: Depends on User Story 2 because both edit the same `more` and `queue` sections
- **User Story 4 (Phase 6)**: Depends on User Stories 2 and 3 because all three edit `.highway/skills/highway-nfrs/SKILL.md`
- **Polish (Phase 7)**: Depends on every user story

### User Story Dependencies

- **User Story 1 (P1)**: Profile only. MVP
- **User Story 2 (P1)**: Objectives, Controls, and NFRs presentation and reply handling
- **User Story 3 (P2)**: Follows User Story 2 in the same three files
- **User Story 4 (P2)**: NFRs only. Follows User Stories 2 and 3 in that file

### Within Each User Story

- T003 before T004 in the Profile skill
- T005, T006, and T007 edit different skills
- T008, T009, and T010 edit different skills
- The version bump comes before validation, regeneration, and the suite

### Parallel Opportunities

- User Story 1 can run alongside User Story 2
- T005, T006, and T007 can run together
- T008, T009, and T010 can run together
- T012 and T013 can run together

---

## Parallel Example: User Story 2

```text
Task: "T005 [US2] Number and reclose Objectives sets in .highway/skills/highway-objectives/SKILL.md"
Task: "T006 [US2] Number and reclose Controls sets in .highway/skills/highway-controls/SKILL.md"
Task: "T007 [US2] Number and reclose NFR sets in .highway/skills/highway-nfrs/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and confirm the Profile starting points render as specified

### Incremental Delivery

1. User Story 1 delivers Profile formatting
2. User Story 2 delivers numbered sets and the closing copy
3. User Story 3 delivers the add-another line
4. User Story 4 delivers Control-first NFRs
5. Polish publishes the skills and requires a green suite

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- The supplied copy is exact, apart from the "expectation" typo fix
- Commit after each task or logical group
- Stop at any checkpoint to validate that story on its own
