---
description: "Task list for review presentation refinements"
---

# Tasks: Review Presentation Refinements

**Input**: Design documents from `/specs/196-review-presentation-refinements/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, retirements.md

**Tests**: The specification does not request test-first work. The plan amends two tests and adds one contract check because the behavior change must be tested.

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before any skill changes

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/196-review-presentation-refinements/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Fix what must not change

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Confirm `.highway/library/templates/output/request-record.md` and `.highway/library/templates/output/assessment-findings.md` are not edited, and the request `identifier`, `title`, `write`, and `close` steps stay as they are

**Checkpoint**: Only presentation and the named flow steps will change

---

## Phase 3: User Story 1 - Refer to a captured item by number (Priority: P2)

**Goal**: Numbered capture reviews

**Independent Test**: Each `capture` step shows `1. **[Title]:** [Statement]` with details indented and `---` between items

### Implementation for User Story 1

- [X] T003 [P] [US1] Number the capture review in `.highway/skills/highway-objectives/SKILL.md`, indent the success measures and rationale under the number, and say a number refers to the review just shown
- [X] T004 [P] [US1] Number the capture review in `.highway/skills/highway-controls/SKILL.md`, indent the rationale, and say a number refers to the review just shown
- [X] T005 [P] [US1] Number the capture review in `.highway/skills/highway-nfrs/SKILL.md`, indent the rationale, and say a number refers to the review just shown

**Checkpoint**: Capture reviews are numbered

---

## Phase 4: User Story 2 - Read a shorter AI-assisted capability description (Priority: P3)

**Goal**: The new description

**Independent Test**: Onboarding shows the new description and not the old one

### Implementation for User Story 2

- [X] T006 [P] [US2] Replace the AI-Assisted Engineering and Planning description in `.highway/skills/highway-onboarding/SKILL.md` and in its Verification bullet

**Checkpoint**: Onboarding description updated

---

## Phase 5: User Story 3 - Scan and prune findings (Priority: P1)

**Goal**: Titled findings, Solution Complexity, and dismissal from the list and details

**Independent Test**: `list of findings` and `finding` in `.highway/skills/highway-assessment/SKILL.md` match `specs/196-review-presentation-refinements/contracts/presentation-copy.md`

### Implementation for User Story 3

- [X] T007 [P] [US3] In `.highway/skills/highway-assessment/SKILL.md`, replace the list item with the derived title and **Solution Complexity:**, state that the title is based on the Finding text and is not written, replace the closing line with the two dismiss lines, add list `dismiss`, widen `Classify` `dismiss` to one or more findings, replace the finding closing line, and update Verification

**Checkpoint**: Assessment changes are complete

---

## Phase 6: User Story 4 - Accept a request proposal once (Priority: P1)

**Goal**: One request proposal in the capture layout with readable Solution Constraints

**Independent Test**: `.highway/skills/highway-request/SKILL.md` has no `capture` step, and `start` matches the contract

### Implementation for User Story 4

- [X] T008 [P] [US4] In `.highway/skills/highway-request/SKILL.md`, update the `Procedure` order and `Classify` note, move the title rule into `start`, replace the bulleted starting point with the capture layout under the existing lead-in, show readable names and None, add the "none" holding rule, send `accept` to `identifier`, remove `### capture`, and update Verification

**Checkpoint**: Request changes are complete

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Retire superseded assertions, publish the skills, and prove the suite is green

- [X] T009 [P] Amend `.highway/tools/tests/static-highway-capability.test.sh` and `.highway/tools/tests/onboarding-assessment-guidance.test.sh` for the assertions named in `specs/196-review-presentation-refinements/retirements.md`
- [X] T010 [P] Add `.highway/tools/tests/review-presentation-refinements.test.sh` with instrument-class and artifact-class comments. Require the numbered capture forms, the request layout, lead-in, readable names, None, and the "none" rule. Fail when `### capture` remains in request or when the request still shows `**allowed_solution_classes:**`
- [X] T011 Bump the six skill versions per `specs/196-review-presentation-refinements/plan.md`
- [X] T012 Run `.highway/tools/validate-skill.sh` on the six skills. Repair only reported authoring-rule failures
- [X] T013 Run `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh`
- [X] T014 Run `.highway/tools/tests/run-all.sh` once, with no other suite running, and require exit 0
- [X] T015 Execute the checks in `specs/196-review-presentation-refinements/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Stories (Phases 3 to 6)**: Depend on Foundational. Each edits different files and can run in parallel
- **Polish (Phase 7)**: Depends on every user story

### Parallel Opportunities

- T003 through T008 edit six different files
- T009 and T010 edit different test files

---

## Parallel Example: User Stories

```text
Task: "T003 [US1] Number the capture review in .highway/skills/highway-objectives/SKILL.md"
Task: "T007 [US3] Update the list of findings in .highway/skills/highway-assessment/SKILL.md"
Task: "T008 [US4] Merge start and capture in .highway/skills/highway-request/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 3 and User Story 4)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phases 5 and 6
4. Stop and confirm the findings list and the single request proposal

### Incremental Delivery

1. User Story 3 delivers titled findings and dismissal
2. User Story 4 delivers the single request proposal
3. User Story 1 delivers numbered capture reviews
4. User Story 2 delivers the new description
5. Polish retires superseded assertions, publishes the skills, and requires a green suite

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- The supplied copy is exact
- Commit after each task or logical group
- Stop at any checkpoint to validate that story on its own
