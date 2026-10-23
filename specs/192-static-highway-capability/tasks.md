---
description: "Task list for the static Highway capability on the onboarding list"
---

# Tasks: Static Highway Capability

**Input**: Design documents from `/specs/192-static-highway-capability/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request test-first work. The plan adds one contract check because the behavior change must amend a test. No current test asserts the absence of the Highway line.

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before the capability list changes

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/192-static-highway-capability/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Keep the existing provider path

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Confirm the decision, reference architecture, and reference implementation steps in `.highway/skills/highway-onboarding/SKILL.md` stay as they are. This feature adds the Highway line and its provider. It does not change how those three records are written

**Checkpoint**: The provider path is unchanged

---

## Phase 3: User Story 1 - See Highway on the capability list (Priority: P1) 🎯 MVP

**Goal**: The capability starting point includes the agreed Highway line. The person can correct or remove it. A removed line is not queued

**Independent Test**: `.highway/skills/highway-onboarding/SKILL.md` contains the line in `specs/192-static-highway-capability/contracts/highway-capability.md`, and a removed line is not placed on the capability queue

### Implementation for User Story 1

- [X] T003 [US1] In `.highway/skills/highway-onboarding/SKILL.md`, add **Highway:** Connect accepted business goals, decisions, architecture, and implementation work into a single traceable system of knowledge. to the `capabilities` starting point. The person may correct or remove it before accept. A removed line is not placed on the capability queue

**Checkpoint**: A new capability list shows the Highway line once

---

## Phase 4: User Story 2 - Name the agent platform as the provider (Priority: P2)

**Goal**: An accepted Highway capability maps to the agent platform. Other capabilities keep their own providers. A second Highway line is omitted when that provider already has an accepted Highway decision

**Independent Test**: `.highway/skills/highway-onboarding/SKILL.md` names the agent platform as Highway's provider, reuses the unable-to-infer prompt when the name is unknown, and does not authorize the platform to act on its own

### Implementation for User Story 2

- [X] T004 [US2] In `.highway/skills/highway-onboarding/SKILL.md`, when Highway is mapped and the session identifies the agent platform by name, use that name as its provider. When the name is unknown, use the existing unable-to-infer prompt. A corrected name replaces it. Do not assign that provider to a capability it does not operate. Omit the Highway line when an accepted ADR already records Highway for the same provider name. Do not authorize the agent platform to act on its own

**Checkpoint**: Highway has one provider, and other capabilities keep theirs

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Publish the edited skill and prove the suite is green

- [X] T005 Add `.highway/tools/tests/static-highway-capability.test.sh` with instrument-class and artifact-class comments. Require the agreed Highway sentence in `.highway/skills/highway-onboarding/SKILL.md`. Require that a removed line is not queued, that the provider is the identified agent platform, and that the skill does not authorize the platform to act on its own
- [X] T006 Bump `.highway/skills/highway-onboarding/SKILL.md` from `2.0.0` to `3.0.0`
- [X] T007 Run `.highway/tools/validate-skill.sh` on `.highway/skills/highway-onboarding`. Repair only reported authoring-rule failures
- [X] T008 Run `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh` so the catalog and published copies match the edited source
- [X] T009 Run `.highway/tools/tests/run-all.sh` and require exit 0
- [X] T010 Execute the checks in `specs/192-static-highway-capability/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Story 1 (Phase 3)**: Depends on Foundational
- **User Story 2 (Phase 4)**: Depends on User Story 1 because both edit `.highway/skills/highway-onboarding/SKILL.md`
- **Polish (Phase 5)**: Depends on User Stories 1 and 2

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. MVP is the Highway line on the capability list
- **User Story 2 (P2)**: Starts after User Story 1. Mapping applies only to a Highway line the person kept

### Within Each User Story

- T003 is the only capability-list edit
- T004 follows T003 in the same skill file
- T005 waits until both edits are in the skill
- The version bump comes before validation, regeneration, and the suite

### Parallel Opportunities

- No task is marked [P]. User Story 1 and User Story 2 edit the same skill file

---

## Parallel Example: User Story 1

```text
No parallel tasks. T003 and T004 both edit .highway/skills/highway-onboarding/SKILL.md.
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and confirm the capability list includes the Highway line

### Incremental Delivery

1. Setup and Foundational leave the provider path unchanged
2. User Story 1 delivers the static line
3. User Story 2 delivers the agent platform as its provider
4. Polish publishes the skill and requires a green suite

### Sequential Story Strategy

One person edits the onboarding skill from the capability list to the provider mapping. Other skills stay untouched.

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- The decision, reference architecture, and reference implementation steps are not rewritten
- Commit after each task or logical group
- Stop at any checkpoint to validate that story on its own
