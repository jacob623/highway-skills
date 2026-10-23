---
description: "Task list for two operating NFR limits and the Request fields they fill"
---

# Tasks: Static Operating NFRs

**Input**: Design documents from `/specs/191-static-operating-nfrs/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request test-first work. The plan adds one contract check because the behavior change must amend a test. No current test asserts the absence of these two limits.

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before the NFR review and Request proposal change

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/191-static-operating-nfrs/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Keep Discovery on its current exclusion rules

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Confirm `.highway/skills/highway-discovery/SKILL.md` is not an edit target for this feature. Do not change it. The Request fields filled in User Story 2 are what its current exclusion and class filter already read

**Checkpoint**: Discovery stays unchanged

---

## Phase 3: User Story 1 - See two operating limits in the NFR review (Priority: P1) 🎯 MVP

**Goal**: A new NFR review includes **No system hosting** and **Direct purchase** with the queued NFRs. Accepted material replaces the matching default. Silence keeps the default. A stored review does not put a removed limit back

**Independent Test**: `.highway/skills/highway-nfrs/SKILL.md` shows both default statements from `specs/191-static-operating-nfrs/contracts/operating-limits.md` in the new-set review, and the stored-record review does not insert a missing limit

### Implementation for User Story 1

- [X] T003 [P] [US1] In `.highway/skills/highway-nfrs/SKILL.md`, include **No system hosting** and **Direct purchase** in the new-set `capture` with the queued NFRs. Use accepted hosting or buying material when it exists. Otherwise use the default statement and rationale in `specs/191-static-operating-nfrs/contracts/operating-limits.md`. Do not ask a question in place of either limit. Do not insert a missing limit during the stored-record `review`

**Checkpoint**: A silent new-set review shows both defaults, and a removed limit stays removed

---

## Phase 4: User Story 2 - Copy an accepted limit into the Request (Priority: P2)

**Goal**: A Request proposal fills hosting, solution class, procurement, and vendor from the accepted titles. Another NFR does not fill those fields

**Independent Test**: `.highway/skills/highway-request/SKILL.md` names both titles and the four fields in `specs/191-static-operating-nfrs/data-model.md`. A removed or retitled limit is not recreated

### Implementation for User Story 2

- [X] T004 [P] [US2] In `.highway/skills/highway-request/SKILL.md`, copy an active NFR titled **No system hosting** into `hosting_restrictions` and `allowed_solution_classes`. Use `managed service` when the statement says the organization does not host, and `hosted system` when it says the organization hosts. Copy an active NFR titled **Direct purchase** into `procurement_constraints` and `vendor_restrictions`. Copy a corrected statement under the same title. Do not recreate a removed or retitled limit from another NFR. When the request material states the limit, show that material for the field instead

**Checkpoint**: Both accepted titles fill the four fields, and any other NFR fills none of them

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Publish the edited skills and prove the suite is green

- [X] T005 Add `.highway/tools/tests/static-operating-nfrs.test.sh` with instrument-class and artifact-class comments. Require both default limits in `.highway/skills/highway-nfrs/SKILL.md`. Require the title-to-field mapping in `.highway/skills/highway-request/SKILL.md`. Fail if `.highway/skills/highway-discovery/SKILL.md` differs from git HEAD for this feature
- [X] T006 Bump `.highway/skills/highway-nfrs/SKILL.md` from `6.0.0` to `7.0.0` and `.highway/skills/highway-request/SKILL.md` from `2.0.0` to `3.0.0`
- [X] T007 Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-nfrs` and `.highway/skills/highway-request`. Repair only reported authoring-rule failures
- [X] T008 Run `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh` so the catalog and published copies match the edited sources
- [X] T009 Run `.highway/tools/tests/run-all.sh` and require exit 0
- [X] T010 Execute the checks in `specs/191-static-operating-nfrs/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Story 1 (Phase 3)**: Depends on Foundational
- **User Story 2 (Phase 4)**: Depends on Foundational. It edits a different skill from User Story 1
- **Polish (Phase 5)**: Depends on User Stories 1 and 2

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. MVP is the two limits in the new-set review
- **User Story 2 (P2)**: Starts after Foundational. It can proceed with User Story 1 because the titles and fields are fixed in the contract

### Within Each User Story

- T003 is the only NFR edit
- T004 is the only Request edit
- T005 waits until both skill texts exist
- Version bumps before validation, regeneration, and the suite

### Parallel Opportunities

- T003 and T004 edit different files and can run together after Foundational

---

## Parallel Example: User Story 1 and User Story 2

```text
Task: "Add the two limits to .highway/skills/highway-nfrs/SKILL.md"
Task: "Copy the accepted titles into .highway/skills/highway-request/SKILL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and confirm both limits appear in a new NFR review

### Incremental Delivery

1. Setup and Foundational leave Discovery unchanged
2. User Story 1 delivers the two limits
3. User Story 2 delivers the Request field mapping
4. Polish publishes both skills and requires a green suite

### Parallel Story Strategy

One person can edit the NFR skill while another edits the Request skill. The contract test waits until both files contain the agreed text.

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- Discovery, Profile, Objectives, and Controls are not edited
- Commit after each task or logical group
- Stop at any checkpoint to validate that story on its own
