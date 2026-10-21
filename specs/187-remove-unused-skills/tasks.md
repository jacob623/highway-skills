---
description: "Task list for removing unused Highway skills"
---

# Tasks: Remove Unused Skills

**Input**: Design documents from `/specs/187-remove-unused-skills/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not ask for new tests. It requires the checks that exist only for the removed skills to be deleted, and the remaining suite to pass.

**Organization**: Tasks are grouped by user story. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before any removal

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/187-remove-unused-skills/baseline.txt`. Stop if it exits non-zero
- [X] T002 [P] Confirm `.highway/skills/highway-clarify/`, `highway-inquiry/`, `highway-relationships/`, and `highway-new/` exist, and confirm `.highway/library/templates/output/request-record.md` and `request-catalog.md` exist

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Name the skills being retired before any directory is deleted

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T003 Create `specs/187-remove-unused-skills/retirements.md` with one entry each for `highway-clarify`, `highway-inquiry`, `highway-relationships`, and `highway-new`, using `specs/187-remove-unused-skills/contracts/removal.md`

**Checkpoint**: The retirement register names the four skills

---

## Phase 3: User Story 1 - Stop offering the unused skills (Priority: P1) 🎯 MVP

**Goal**: The four skills are gone from the sources, the published copies, the catalog, and the distribution manifest

**Independent Test**: Search `.highway/skills/`, `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, `.agents/skills/`, and `.highway/catalog/index.md`. None of the four names is offered

### Implementation for User Story 1

- [X] T004 [P] [US1] Delete `.highway/skills/highway-clarify/`
- [X] T005 [P] [US1] Delete `.highway/skills/highway-inquiry/`
- [X] T006 [P] [US1] Delete `.highway/skills/highway-relationships/`
- [X] T007 [P] [US1] Delete `.highway/skills/highway-new/`
- [X] T008 [P] [US1] Delete `highway-clarify` under `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/`
- [X] T009 [P] [US1] Delete `highway-inquiry` under `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/`
- [X] T010 [P] [US1] Delete `highway-relationships` under `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/`
- [X] T011 [P] [US1] Delete `highway-new` under `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/`
- [X] T012 [US1] Remove every `include` row for those four skills from `.highway/tools/.distribution-manifest`
- [X] T013 [US1] Run `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-agent-adapters.sh` so `.highway/catalog/index.md` and `.highway/tools/.adapter-manifest` no longer name the removed skills

**Checkpoint**: The four skills are not offered. User Story 1 can be checked before the owned templates are deleted

---

## Phase 4: User Story 2 - Remove files that only those skills used (Priority: P2)

**Goal**: Owned templates and skill-only tests are gone, and mixed tests no longer require the removed skills. The shared request templates stay

**Independent Test**: The clarification templates and the requirements-inquiry template are absent. `request-record.md` and `request-catalog.md` remain, and `.highway/skills/highway-request/SKILL.md` still cites both

### Implementation for User Story 2

- [X] T014 [P] [US2] Delete `.highway/library/templates/output/clarification-record.md`
- [X] T015 [P] [US2] Delete `.highway/library/templates/output/clarification-catalog.md`
- [X] T016 [P] [US2] Delete `.highway/library/templates/requirements-inquiry.md`
- [X] T017 [P] [US2] Delete `.highway/tools/tests/highway-clarify.test.sh` and record it in `specs/187-remove-unused-skills/retirements.md`
- [X] T018 [P] [US2] Delete `.highway/tools/tests/highway-new.test.sh` and record it in `specs/187-remove-unused-skills/retirements.md`
- [X] T019 [P] [US2] Delete `.highway/tools/tests/relationship-integrity.test.sh` and record it in `specs/187-remove-unused-skills/retirements.md`
- [X] T020 [US2] Edit `.highway/tools/tests/output-template.test.sh` so it no longer requires the clarification templates or `highway-clarify`, and still checks that `.highway/skills/highway-request/SKILL.md` cites the request templates
- [X] T021 [US2] Edit `.highway/tools/tests/highway-ux-alignment.test.sh` so its skill list no longer includes `highway-new` or `highway-clarify`
- [X] T022 [US2] Run `.highway/tools/generate-library-catalog.sh` so `.highway/catalog/library-index.md` no longer lists the deleted templates

**Checkpoint**: Orphaned templates and skill-only tests are gone. The request templates remain

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Prove the remaining suite is green and the skills that stay were not rewritten

- [X] T023 Confirm `.highway/library/templates/output/request-record.md` and `request-catalog.md` are unchanged and that `.highway/skills/highway-request/SKILL.md` still cites both
- [X] T024 [P] Confirm `.highway/governance/constitution.md`, `.specify/memory/constitution.md`, `.highway/governance/experience-standard.md`, and `.highway/skills/highway-discovery/SKILL.md` have no content change
- [X] T025 Run `.highway/tools/tests/run-all.sh` and require exit 0
- [X] T026 Execute the checks in `specs/187-remove-unused-skills/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Story 1 (Phase 3)**: Depends on Foundational. Does not depend on User Story 2
- **User Story 2 (Phase 4)**: Depends on Foundational. T020 depends on the clarification templates being deleted or on the clarify skill being gone
- **Polish (Phase 5)**: Depends on User Stories 1 and 2

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. MVP is the four skills no longer being offered
- **User Story 2 (P2)**: Template and test deletion can start after Foundational. Library catalog regeneration waits until the three templates are deleted

### Within Each User Story

- The four source deletions run in parallel
- The four published-copy deletions run in parallel with the source deletions
- The distribution manifest is edited after those deletions
- Catalog regeneration runs after the sources and the manifest are updated

### Parallel Opportunities

- T002 can run with T001
- T004 through T011 can run together
- T014 through T019 can run together

---

## Parallel Example: User Story 1

```bash
# Remove the four sources and their published copies together:
Task: "Delete .highway/skills/highway-clarify/"
Task: "Delete .highway/skills/highway-inquiry/"
Task: "Delete .highway/skills/highway-relationships/"
Task: "Delete .highway/skills/highway-new/"
Task: "Delete highway-clarify under .github/skills/, .claude/skills/, .cursor/skills/, and .agents/skills/"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: The four names are absent from the skill list
5. Continue to User Story 2 before expecting `.highway/tools/tests/run-all.sh` to pass

### Incremental Delivery

1. Setup and Foundational record the green baseline and the four retired names
2. User Story 1 stops offering the skills
3. User Story 2 removes the templates and tests that only those skills used
4. Polish confirms the request templates, the untouched skills, and a green suite

### Parallel Team Strategy

1. One person completes Setup and Foundational
2. After that, one person removes each skill source while another removes its published copies
3. Template deletion and test deletion can proceed together
4. Catalog regeneration and the full suite run last

---

## Notes

- [P] tasks use different files and have no ordering dependency
- Do not delete `.highway/library/templates/output/request-record.md` or `request-catalog.md`
- Do not edit `.highway/skills/highway-discovery/SKILL.md` or `.highway/skills/highway-request/SKILL.md`
- Do not edit either constitution or `.highway/governance/experience-standard.md`
- Do not delete historical directories under `specs/`
- `generate-agent-adapters.sh` does not delete an adapter whose source is gone. Delete those directories directly
