---
description: "Task list for writing accepted Profile bullets to the person's repository"
---

# Tasks: Profile Direct Write

**Input**: Design documents from `/specs/188-profile-direct-write/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request new test-first work. Existing checks that require the fallback questions, the capture paragraph, or the old profile path are updated with the behavior they replace.

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before the profile conversation changes

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/188-profile-direct-write/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Name the conversation text this change removes

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Record the three fallback questions and the capture paragraph from `specs/188-profile-direct-write/contracts/profile-file.md` in `specs/188-profile-direct-write/retirements.md`, including the superseded second acceptance

**Checkpoint**: The retirement note names the questions and the capture paragraph

---

## Phase 3: User Story 1 - Always receive a proposal (Priority: P1) 🎯 MVP

**Goal**: Vision, Competitive Path, and Guiding Principles always open with a proposal. A thin slot, including the tradeoff, is inferred and offered for correction

**Independent Test**: `.highway/skills/highway-profile/SKILL.md` contains no fallback question for those three domains and still contains **What would you add, correct, or remove?**

### Implementation for User Story 1

- [X] T003 [US1] In `.highway/skills/highway-profile/SKILL.md`, delete the Vision, Competitive Path, and Guiding Principles fallback questions and the instruction to emit them when a starting point cannot be filled
- [X] T004 [US1] In `.highway/skills/highway-profile/SKILL.md`, require those three domains to always emit the proposal, including an inferred Competitive Path tradeoff and 3 to 5 Guiding Principles, even when a slot has no direct statement

**Checkpoint**: A thin context still produces three proposals and no fallback question

---

## Phase 4: User Story 2 - Accept once, then store the bullets (Priority: P2)

**Goal**: Acceptance of a proposal holds those bullets. Profile does not show a capture paragraph or ask for a second acceptance

**Independent Test**: `.highway/skills/highway-profile/SKILL.md` does not contain **Here's what I've captured**, and the write step stores the accepted bullets

### Implementation for User Story 2

- [X] T005 [US2] Delete the capture template from `.highway/skills/highway-profile/SKILL.md`
- [X] T006 [US2] In `.highway/skills/highway-profile/SKILL.md`, hold the accepted bullets for each domain, form an Identity question answer into bullets without a second confirmation, and write those bullets instead of a joined paragraph
- [X] T007 [US2] In `.highway/library/templates/output/profile-record.md`, state that each rendered domain section is the accepted bullets

**Checkpoint**: One acceptance per domain, and the stored narrative is those bullets

---

## Phase 5: User Story 3 - Store the profile in the person's repository (Priority: P3)

**Goal**: The profile is read and written only at `library/knowledge/profile.md` from the repository root. The old framework path is ignored

**Independent Test**: Profile, Setup, Objectives, Controls, NFRs, and `profile_path` name `library/knowledge/profile.md` and do not read or write `.highway/library/knowledge/profile.md`

### Implementation for User Story 3

- [X] T008 [US3] In `.highway/skills/highway-profile/SKILL.md`, read and write `library/knowledge/profile.md` from the repository root, create `library/knowledge/` when it is absent, and do not read, copy, or review `.highway/library/knowledge/profile.md`
- [X] T009 [P] [US3] In `.highway/skills/highway-setup/SKILL.md`, use `library/knowledge/profile.md` for the welcome check and the profile input
- [X] T010 [P] [US3] In `.highway/skills/highway-objectives/SKILL.md`, name `library/knowledge/profile.md` as the profile input
- [X] T011 [P] [US3] In `.highway/skills/highway-controls/SKILL.md`, name `library/knowledge/profile.md` as the profile input
- [X] T012 [P] [US3] In `.highway/skills/highway-nfrs/SKILL.md`, name `library/knowledge/profile.md` as the profile input
- [X] T013 [P] [US3] In `.highway/tools/lib/profile.sh`, return `library/knowledge/profile.md` from `profile_path`
- [X] T014 [US3] In `.highway/governance/constitution.md`, change the user-owned profile path to `library/knowledge/profile.md`, add the Sync Impact Report, and bump the constitution version MINOR
- [X] T015 [US3] Update `.highway/tools/tests/profile-template-migration.test.sh` and any other test under `.highway/tools/tests/` that requires `.highway/library/knowledge/profile.md`, the capture paragraph, or the three fallback questions. Name the superseded behavior in `specs/188-profile-direct-write/retirements.md`

**Checkpoint**: The person's profile path is the only profile path

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Publish the edited skills and prove the suite is green

- [X] T016 Bump the version in `.highway/skills/highway-profile/SKILL.md` to the next MAJOR, and bump `.highway/skills/highway-setup/SKILL.md`, `highway-objectives/SKILL.md`, `highway-controls/SKILL.md`, and `highway-nfrs/SKILL.md` for the path change
- [X] T017 Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-profile`, `highway-setup`, `highway-objectives`, `highway-controls`, and `highway-nfrs`. Repair only reported authoring-rule failures
- [X] T018 Run `.highway/tools/generate-agent-adapters.sh` so the published copies match the edited sources
- [X] T019 Run `.highway/tools/tests/run-all.sh` and require exit 0
- [X] T020 Execute the checks in `specs/188-profile-direct-write/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Story 1 (Phase 3)**: Depends on Foundational
- **User Story 2 (Phase 4)**: Depends on User Story 1 because both edit `.highway/skills/highway-profile/SKILL.md`
- **User Story 3 (Phase 5)**: Depends on User Story 2 for the profile skill. The other path edits can start after Foundational
- **Polish (Phase 6)**: Depends on User Stories 1, 2, and 3

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. MVP is the three proposals with no fallback question
- **User Story 2 (P2)**: Starts after User Story 1. The template edit in T007 can run beside T005
- **User Story 3 (P3)**: T009 through T013 can run in parallel after Foundational. T008 waits until the profile conversation edits are finished

### Within Each User Story

- The profile skill is edited in story order: proposals, then capture removal, then path
- Tests that lock the old text are updated after the skill and template match the contract
- Adapters are regenerated only after validation

### Parallel Opportunities

- T007 can run with T005
- T009 through T013 can run together
- T010, T011, and T012 touch different skill files

---

## Parallel Example: User Story 3

```bash
# Point the readers at the person's profile together:
Task: "In .highway/skills/highway-setup/SKILL.md, use library/knowledge/profile.md"
Task: "In .highway/skills/highway-objectives/SKILL.md, name library/knowledge/profile.md"
Task: "In .highway/skills/highway-controls/SKILL.md, name library/knowledge/profile.md"
Task: "In .highway/skills/highway-nfrs/SKILL.md, name library/knowledge/profile.md"
Task: "In .highway/tools/lib/profile.sh, return library/knowledge/profile.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: The three fallback questions are gone and the proposals remain
5. Continue through User Story 2 and User Story 3 before expecting the full suite to pass

### Incremental Delivery

1. Setup and Foundational record the green baseline and the retired conversation text
2. User Story 1 makes the three domains always propose
3. User Story 2 stores the accepted bullets without a second acceptance
4. User Story 3 moves the file to the person's repository and updates every reader
5. Polish validates, regenerates adapters, and runs the suite

### Parallel Team Strategy

1. One person completes Setup, Foundational, and the profile conversation edits
2. After Foundational, others can update Setup, Objectives, Controls, NFRs, and `profile.sh`
3. The constitution path sentence and the test updates follow those edits
4. Regeneration and the full suite run last

---

## Notes

- [P] tasks use different files and have no ordering dependency
- Do not read, copy, or review `.highway/library/knowledge/profile.md`
- Keep the Identity question for the case with no supported starting point
- Do not hand-edit generated adapters
- The profile skill version bump is MAJOR. The constitution bump is MINOR
