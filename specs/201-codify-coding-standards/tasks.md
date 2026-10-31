---
description: "Task list for codify coding standards and task list"
---

# Tasks: Codify Coding Standards and Task List

**Input**: Design documents from `/specs/201-codify-coding-standards/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: The specification does not request test-first work. The plan adds assertions to `.highway/tools/tests/highway-codify.test.sh`. No assertion is removed.

**Organization**: Tasks are grouped by user story. All three stories are P1 and stay in spec order. Task IDs follow execution order.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prove the suite is green before any edit

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and record the passing summary in `specs/201-codify-coding-standards/baseline.txt`. Stop if it exits non-zero

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Give every task list one shape

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Create `.highway/library/templates/output/codify-tasks.md` at version 1.0.0 per `specs/201-codify-coding-standards/contracts/task-list.md` and `specs/201-codify-coding-standards/data-model.md`. Frontmatter `name: codify-tasks`, a description, and `metadata.version: 1.0.0`. Sections `## File Frontmatter` with `automation: CDYXXXXXX`, and `## Body` with `# Tasks: <automation title>` and the three example task lines: a component file, its test, and the README task with `Standard: No coding standard applies.` Below the body, state the rules: one task per file, open `[ ]` and done `[X]`, `T001` upward with no gaps, component order from the accepted proposal, a test task directly after its file only when the standard says `Tests: required`, and the README task last
- [X] T003 Confirm `.highway/library/templates/output/codify-record.md`, `.highway/library/templates/output/codify-catalog.md`, `.highway/skills/highway-request/SKILL.md`, and `.highway/skills/highway-assessment/SKILL.md` are not edited

**Checkpoint**: The task list template exists and passes `validate-library.sh`

---

## Phase 3: User Story 1 - Find the coding standard for a technology (Priority: P1) 🎯 MVP

**Goal**: One organization folder holds one catalog and one sample standard, and Highway ships it

**Independent Test**: Read `library/coding-standards/coding-standards.md`. It has one row, and the row's Standard Path exists. The sample has Scope, Rules, and Tests, and its first Tests line says whether tests are required

### Implementation for User Story 1

- [X] T004 [P] [US1] Create `library/coding-standards/coding-standards.md` per `specs/201-codify-coding-standards/contracts/coding-standards.md`. Open with one sentence saying the organization maintains this folder and each standard covers one technology. Add one table with columns Standard Title, Technology, File Patterns, Summary, and Standard Path, and one row: `Terraform Coding Standard`, `Terraform`, `` `*.tf`, `*.tfvars` ``, one summary sentence, and `` `library/coding-standards/terraform.md` ``. Say that adding a standard adds one row and changes no other row
- [X] T005 [P] [US1] Create `library/coding-standards/terraform.md` with `# Terraform Coding Standard`, `## Scope` (Terraform, `*.tf` and `*.tfvars`), `## Rules` (a short numbered list covering formatting, naming, variables with descriptions and types, pinned provider and module versions, no secrets in code, and tagging), and `## Tests` whose first line is `Tests: required`, followed by how a test file is named and where it goes. Do not reference `.specify/` or `specs/`
- [X] T006 [US1] Add `include	library/coding-standards	-` to `.highway/tools/.distribution-manifest` with a one-line comment that the folder is organization content Highway seeds
- [X] T007 [US1] In `.highway/skills/highway-codify/SKILL.md`, add `library/coding-standards/coding-standards.md` and the standards it names to Inputs, and add to When not to use that codify does not create, edit, or remove a coding standard or a row of that catalog

**Checkpoint**: The folder exists, ships, and codify lists it as read-only input

---

## Phase 4: User Story 2 - Get a task list before any code is written (Priority: P1)

**Goal**: Acceptance writes `code/<id>/codify-tasks.md` with the saved proposal and the catalog row, before any component file or README

**Independent Test**: Read the `write` step. It writes the record, the task list, and the catalog row together. Each task names one component or README, one file, and a standard or `No coding standard applies.` A test task appears only when the standard says `Tests: required`. The README task is last

### Implementation for User Story 2

- [X] T008 [US2] In `.highway/skills/highway-codify/SKILL.md`, change `write` per `specs/201-codify-coding-standards/contracts/task-list.md`. Write `code/[ID]/codify.md`, `code/[ID]/codify-tasks.md`, and `code/code.md` together, all or nothing. Do not write the README or component files in `write`. The task list follows `.highway/library/templates/output/codify-tasks.md`. Read the coding standards catalog. A file uses the first row whose File Patterns match its name. A row whose file is absent is unavailable. A second row for one technology is a duplicate and the first row applies. Every component the proposal names has at least one task, and no task names another component. A file whose standard says `Tests: required` gets one test task directly after it. A file with no available standard says `Standard: No coding standard applies.` The README task is last and produces the Implement and Use parts. On success, go to `code` without asking a question
- [X] T009 [US2] In `.highway/skills/highway-codify/SKILL.md`, update Purpose, Outputs, and the Procedure order line so the order is `choose`, `suggest`, `start`, `identifier`, `title` when needed, `write`, `code`, and `close`, and Outputs names `code/[ID]/codify-tasks.md`

**Checkpoint**: Acceptance produces the task list and no code yet

---

## Phase 5: User Story 3 - Code from the task list (Priority: P1)

**Goal**: Codify codes each open task in order, reads its standard first, marks it done, stops at a task it cannot finish, and resumes at the first open task

**Independent Test**: Read the `code` step, the resume rules, and the close. Each task is coded after its standard is read and marked `[X]` before the next. A task that cannot be finished stops the run. A later run starts at the first open task. The close says whether every task is done and that the automation was not run

### Implementation for User Story 3

- [X] T010 [US3] In `.highway/skills/highway-codify/SKILL.md`, add a `code` step per `specs/201-codify-coding-standards/contracts/coding-flow.md`. For each open task in list order: read the standard it names, write that task's file so it follows the standard, mark the task `[X]` in `codify-tasks.md`, and go to the next open task. The accepted architecture and implementation decide what is built, and the standard decides how it is written. Write component files inside the component subfolder, lowercased with spaces as hyphens. Do not run any file. A task that cannot be finished stops the run, leaves it and every later task open, and goes to `close`. Files written by finished tasks stay in place. When every task is done, go to `close`
- [X] T011 [US3] In `.highway/skills/highway-codify/SKILL.md`, add resume handling. In Entry, when the invocation names an automation in `code/code.md` by title or `CDY` id and its task list has an open task, go to `code` at the first open task. In `identifier`, when the same title already has that id, go to `code` at the first open task, or to `close` when every task is done
- [X] T012 [US3] In `.highway/skills/highway-codify/SKILL.md`, extend `close` to name `code/[ID]/codify-tasks.md`, say in a sentence whether every task is done, name a task that could not be finished and what stopped it, name a missing catalog, a missing standard file, or a duplicate technology row, and keep `The automation was not run.` Do not use Status, Missing, Complete, or Blocked as labels
- [X] T013 [US3] In `.highway/skills/highway-codify/SKILL.md`, bump the version from 2.0.0 to 3.0.0 and update Verification and Error Handling for the task list, the standards, the stop at a task that cannot be finished, and resume. Keep the frontmatter description and usage unchanged

**Checkpoint**: Code is produced only from the task list and a stopped run can resume

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Test, publish, and prove the suite is green

- [X] T014 Amend `.highway/tools/tests/highway-codify.test.sh` to require `codify-tasks.md`, `library/coding-standards/coding-standards.md`, `No coding standard applies.`, `Tests: required`, and `first open task` in `.highway/skills/highway-codify/SKILL.md`; `automation: CDYXXXXXX` and `- [ ] T001` in `.highway/library/templates/output/codify-tasks.md`; the `Standard Path` column and `library/coding-standards/terraform.md` in `library/coding-standards/coding-standards.md`; `## Tests` and `Tests: required` in `library/coding-standards/terraform.md`; and the `library/coding-standards` include in `.highway/tools/.distribution-manifest`. Keep every existing assertion
- [X] T015 Run `.highway/tools/validate-library.sh` on `.highway/library/templates/output/codify-tasks.md` and `.highway/tools/validate-skill.sh` on `.highway/skills/highway-codify`. Repair only reported authoring-rule failures
- [X] T016 Run `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh`
- [X] T017 Run `.highway/tools/tests/run-all.sh` once, with no other suite running, and require exit 0
- [X] T018 Execute the checks in `specs/201-codify-coding-standards/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story
- **User Stories (Phases 3 to 5)**: Depend on Foundational. T007 through T013 edit `.highway/skills/highway-codify/SKILL.md` and stay in phase order
- **Polish (Phase 6)**: Depends on every user story

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. Creates the standards folder and its shipping line
- **User Story 2 (P1)**: Starts after User Story 1, because the task list reads the catalog
- **User Story 3 (P1)**: Starts after User Story 2, because coding reads the task list

### Parallel Opportunities

- T002 and T003 touch different files and can run together
- T004 and T005 create different files and can run together
- Do not parallelize T007 through T013. They edit `.highway/skills/highway-codify/SKILL.md`

---

## Parallel Example: User Story 1

```text
Task: "T004 Create library/coding-standards/coding-standards.md"
Task: "T005 Create library/coding-standards/terraform.md"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and confirm the catalog, the sample, and the distribution line

### Incremental Delivery

1. User Story 1 ships the standards folder
2. User Story 2 writes the task list on acceptance
3. User Story 3 codes from the list, stops at a task it cannot finish, and resumes
4. Polish adds the test assertions, regenerates, and requires a green suite

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- Do not commit unless asked
- Stop at any checkpoint to validate that story on its own
