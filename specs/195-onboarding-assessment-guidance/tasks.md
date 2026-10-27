---
description: "Task list for onboarding and assessment guidance"
---

# Tasks: Onboarding and Assessment Guidance

**Input**: Design documents from `/specs/195-onboarding-assessment-guidance/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, retirements.md

**Tests**: The specification does not request test-first work. The plan amends one test and adds one contract check because the behavior change must be tested.

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before either skill changes

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/195-onboarding-assessment-guidance/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Fix what must not change

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Confirm the `mapping`, `orchestrate`, `lineage`, `summary`, and `review` steps of `.highway/skills/highway-onboarding/SKILL.md`, and the `write`, `explore`, and `summary` behavior of `.highway/skills/highway-assessment/SKILL.md`, stay as they are. Confirm `.highway/library/templates/output/assessment-findings.md` is not edited

**Checkpoint**: Only the named presentation and flow steps will change

---

## Phase 3: User Story 1 - Understand onboarding before it starts (Priority: P1) 🎯 MVP

**Goal**: The onboarding overview appears once before the first capability list

**Independent Test**: `.highway/skills/highway-onboarding/SKILL.md` has an `overview` step between `Classify` and `capabilities` that matches `specs/195-onboarding-assessment-guidance/contracts/guidance-copy.md`, and `capabilities` no longer emits its opening heading

### Implementation for User Story 1

- [X] T003 [US1] In `.highway/skills/highway-onboarding/SKILL.md`, add `overview` to the step order in `Procedure`. Add `### overview` between `Classify` and `capabilities` with the contract copy, the level-3 instruction for "What we'll do together", the `[Name]` rule, and "Then go to `capabilities`." Remove the opening heading, its sentence, and the first-visit instruction from `capabilities`, keeping "On an edit, re-emit only the starting point."

**Checkpoint**: Onboarding opens with the overview

---

## Phase 4: User Story 2 - Review one capability per numbered item (Priority: P1)

**Goal**: Numbered single capabilities, with AI-Assisted Engineering and Planning in place of Highway

**Independent Test**: The capability starting point matches the contract, and no **Highway:** line remains

### Implementation for User Story 2

- [X] T004 [US2] In `capabilities` of `.highway/skills/highway-onboarding/SKILL.md`, replace the starting point with the numbered contract form. Replace the Highway line and inclusion rule with the AI-Assisted Engineering and Planning line and rule. Replace "Emit one line per other capability." with one numbered item per capability, each naming one capability, splitting joined activities in Highway's proposals

**Checkpoint**: The capability list is numbered and single-capability

---

## Phase 5: User Story 3 - Know what mapping will do (Priority: P2)

**Goal**: The mapping transition appears once, and each mapping separates labels from values

**Independent Test**: `map` emits the contract transition for the first capability only, the block uses separated labels, and the provider rule names AI-Assisted Engineering and Planning

### Implementation for User Story 3

- [X] T005 [US3] In `map` of `.highway/skills/highway-onboarding/SKILL.md`, emit the contract transition before the first capability's block only. Change the block to bold labels each followed by a blank line and the value. Change the provider rule to "When the capability title is AI-Assisted Engineering and Planning and the session identifies the agent platform by name, that name is the provider." Update the Verification bullets for the overview, numbered capabilities, the renamed capability, and the transition

**Checkpoint**: Onboarding changes are complete

---

## Phase 6: User Story 4 - Choose which finding to explore (Priority: P1)

**Goal**: Assessment opens, lists up to five findings, shows the chosen finding, and returns to the list

**Independent Test**: `.highway/skills/highway-assessment/SKILL.md` has `list of findings` before `finding`, no `open` step, the contract copy, the new reply types, and the go-back line

### Implementation for User Story 4

- [X] T006 [P] [US4] In `.highway/skills/highway-assessment/SKILL.md`, update `Purpose`, `Outputs`, and the `Procedure` order for the list. Point `Entry` at `list of findings`. Add `select`, `more`, and `back` to `Classify`
- [X] T007 [US4] In `.highway/skills/highway-assessment/SKILL.md`, replace `### open` with `### list of findings`: the opening on the first visit, Open findings first then new grounded findings, at most 5, each new finding written as Open through `write` before the list, the contract list, question, and additional-findings line, and reply handling for `select`, `more`, `question`, `unknown`, and `decline`
- [X] T008 [US4] In `finding` of `.highway/skills/highway-assessment/SKILL.md`, show the finding chosen from the list. Replace the save-or-discard line with the go-back line. Send `accept` and `dismiss` back to `list of findings` after the write. Add `back`. Remove the retained-findings list. Keep `explore`, `edit`, `question`, `unknown`, and `decline` behavior. Update Verification

**Checkpoint**: Assessment changes are complete

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Retire superseded assertions, publish the skills, and prove the suite is green

- [X] T009 [P] Amend `.highway/tools/tests/static-highway-capability.test.sh` to require the AI-Assisted Engineering and Planning line, inclusion rule, and provider rule in place of the three Highway sentences named in `specs/195-onboarding-assessment-guidance/retirements.md`
- [X] T010 [P] Add `.highway/tools/tests/onboarding-assessment-guidance.test.sh` with instrument-class and artifact-class comments. Require the overview, numbered capability form, mapping transition and layout, assessment opening, list copy, reply types, and go-back line. Fail when the save-or-discard line, `### open`, or a **Highway:** capability line remains
- [X] T011 Bump `.highway/skills/highway-onboarding/SKILL.md` from 3.0.0 to 4.0.0 and `.highway/skills/highway-assessment/SKILL.md` from 2.0.0 to 3.0.0
- [X] T012 Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-onboarding` and `.highway/skills/highway-assessment`. Repair only reported authoring-rule failures
- [X] T013 Run `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh` so the catalog and published copies match the edited sources
- [X] T014 Run `.highway/tools/tests/run-all.sh` once, with no other suite running, and require exit 0
- [X] T015 Execute the checks in `specs/195-onboarding-assessment-guidance/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Stories 1 to 3 (Phases 3 to 5)**: Run in order because all edit `.highway/skills/highway-onboarding/SKILL.md`
- **User Story 4 (Phase 6)**: Depends on Foundational only. Can run alongside User Stories 1 to 3
- **Polish (Phase 7)**: Depends on every user story

### Within Each User Story

- T006, T007, and T008 edit the same file in order. T006 is marked [P] only against the onboarding stories
- T009 and T010 edit different test files
- The version bump comes before validation, regeneration, and the suite

### Parallel Opportunities

- User Story 4 can run alongside User Stories 1 to 3
- T009 and T010 can run together

---

## Parallel Example: Onboarding and Assessment

```text
Task: "T003 [US1] Add overview in .highway/skills/highway-onboarding/SKILL.md"
Task: "T006 [US4] Update assessment Purpose, Entry, and Classify in .highway/skills/highway-assessment/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and confirm the overview appears before the capability list

### Incremental Delivery

1. User Story 1 delivers the onboarding overview
2. User Story 2 delivers numbered single capabilities and the renamed capability
3. User Story 3 delivers the mapping transition and layout
4. User Story 4 delivers the assessment list
5. Polish retires superseded assertions, publishes the skills, and requires a green suite

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- The supplied copy is exact, apart from "Highway" capitalization and the missing "to"
- Commit after each task or logical group
- Stop at any checkpoint to validate that story on its own
