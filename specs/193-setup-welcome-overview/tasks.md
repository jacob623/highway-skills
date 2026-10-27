---
description: "Task list for the setup welcome overview"
---

# Tasks: Setup Welcome Overview

**Input**: Design documents from `/specs/193-setup-welcome-overview/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request test-first work. The plan adds one contract check because the behavior change must add a test. No current test asserts "Let's get started."

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before the welcome changes

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/193-setup-welcome-overview/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Keep the welcome condition and the surrounding text

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Confirm in `.highway/skills/highway-setup/SKILL.md` that the welcome condition, the heading, the tagline, **Your context stays yours.** with its paragraph, "Then delegate `highway-profile`.", and the Objectives, Controls, and NFRs transitions stay as they are. This feature replaces only the separator and "Let's get started."

**Checkpoint**: Only the end of the welcome will change

---

## Phase 3: User Story 1 - Know what setup will cover before it starts (Priority: P1) 🎯 MVP

**Goal**: The first-run welcome ends with the overview of the four parts of setup, then Profile begins

**Independent Test**: `.highway/skills/highway-setup/SKILL.md` contains every line in `specs/193-setup-welcome-overview/contracts/welcome-overview.md`, names "During setup we'll:" as a level-3 heading, and has no standalone "Let's get started." line

### Implementation for User Story 1

- [X] T003 [US1] In the Welcome section of `.highway/skills/highway-setup/SKILL.md`, replace the line "Let's get started." with the overview from `specs/193-setup-welcome-overview/contracts/welcome-overview.md`. Keep the existing `---` as the opening rule. Write "During setup we'll:" as a plain line. Add the closing `---` after "Now, let's get started." and before "Then delegate `highway-profile`."
- [X] T004 [US1] In the Welcome instruction of `.highway/skills/highway-setup/SKILL.md`, state that "Welcome to Highway" is a level-2 heading and "During setup we'll:" is a level-3 heading, and that the rest of the lines are emitted as written. Keep the condition that the welcome appears only when `library/knowledge/profile.md` is absent

**Checkpoint**: A first setup run shows the overview once, then Profile begins

---

## Phase 4: Polish & Cross-Cutting Concerns

**Purpose**: Publish the edited skill and prove the suite is green

- [X] T005 [P] Add `.highway/tools/tests/setup-welcome-overview.test.sh` with instrument-class and artifact-class comments. Require each overview line from the contract, the level-3 instruction for "During setup we'll:", the closing `---` before "Then delegate `highway-profile`.", and the unchanged heading, tagline, and ownership text. Fail when a standalone "Let's get started." line remains or when a literal `### During setup` line appears in the source
- [X] T006 [P] Bump `.highway/skills/highway-setup/SKILL.md` from `9.1.0` to `10.0.0`
- [X] T007 Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-setup`. Repair only reported authoring-rule failures
- [X] T008 Run `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh` so the catalog and published copies match the edited source
- [X] T009 Run `.highway/tools/tests/run-all.sh` and require exit 0
- [X] T010 Execute the checks in `specs/193-setup-welcome-overview/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks the user story
- **User Story 1 (Phase 3)**: Depends on Foundational
- **Polish (Phase 4)**: Depends on User Story 1

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. It is the whole feature

### Within Each User Story

- T003 is the only copy edit
- T004 follows T003 in the same skill file
- T005 waits until both edits are in the skill
- The version bump comes before validation, regeneration, and the suite

### Parallel Opportunities

- T005 and T006 edit different files and can run in parallel after T004
- No other task is marked [P]

---

## Parallel Example: User Story 1

```text
No parallel tasks. T003 and T004 both edit .highway/skills/highway-setup/SKILL.md.
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and confirm the welcome ends with the overview

### Incremental Delivery

1. Setup and Foundational leave the welcome condition and surrounding text unchanged
2. User Story 1 delivers the overview
3. Polish publishes the skill and requires a green suite

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- The overview copy is exact. Do not reword it
- Commit after each task or logical group
- Stop at any checkpoint to validate that story on its own
