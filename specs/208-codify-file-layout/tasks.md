---

description: "Task list for codify file layout"
---

# Tasks: Codify File Layout

**Input**: Design documents from `/specs/208-codify-file-layout/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Four existing tests are amended with D3.5 reasons (research R9).

**Organization**: Tasks are grouped by user story. Each story is one feature, and its tasks name the files it changes.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US4)

---

## Phase 1: Setup

**Purpose**: Confirm a green suite before any edit (D3.1)

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` in the background with all permissions, wait for it, and copy the `Summary:` and `EXIT:` lines into specs/208-codify-file-layout/baseline.txt. Stop if any test fails

---

## Phase 2: Foundational (failing test)

**Purpose**: Write the contract test first

- [X] T002 Write .highway/tools/tests/codify-file-layout.test.sh (mode 644, static-document-contract header, `require`/`reject` helpers, and a `test -e` absence check). It requires:
  - `## File and Folder Structure` and `Test path:` in coding-standard.md.
  - **File and Folder Structure:** and the three refusal sentences in highway-codify-config, plus catalog creation with the first standard.
  - `Files:` lines, `README.md`, and feature grouping in codify-tasks.md.
  - `### layout`, **Files:**, and the no-structure pointer in highway-codify, plus **Files:** in codify-record.md.

  It rejects `executor/`, `task-N/`, and "Each task produces one file" in codify and its templates. It checks that both seed files and the manifest include line are absent.
- [X] T003 Run the new test, observe it fail, and save its output to specs/208-codify-file-layout/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - Accept a file and folder structure with each coding standard (Priority: P1) 🎯 MVP

**Goal**: A standard cannot be accepted without a relative layout and a valid tests section

**Independent Test**: The standard proposal in `highway-codify-config` shows **File and Folder Structure:**. `accept` refuses an empty structure, a path that is not relative, and a required test path outside the structure

- [X] T004 [P] [US1] Update .highway/library/templates/output/coding-standard.md to 2.0.0: add `## File and Folder Structure` between Scope and Rules, and add `Test path:` to Tests, following contracts/standard-structure.md
- [X] T005 [US1] In .highway/skills/highway-codify-config/SKILL.md `standard proposal`, add **File and Folder Structure:** after **File Patterns:**, the test path on **Tests:**, the three refusals on `accept`, and proposing the structure from the platform's current documentation when no standard exists
- [X] T006 [US1] In the same file `conflicts`, add two standards naming the same relative path with neither inheriting from the other. Update Verification. Bump to 2.0.0

---

## Phase 4: User Story 4 - Start with no coding standards (Priority: P1)

**Goal**: Nothing is seeded, and the first accepted standard creates the catalog

**Independent Test**: Neither seed file exists, the manifest has no include line, and `highway-codify-config` creates the catalog after the first standard file is written

- [X] T007 [P] [US4] Delete library/coding-standards/coding-standards.md and library/coding-standards/terraform.md
- [X] T008 [P] [US4] Remove `include library/coding-standards -` from .highway/tools/.distribution-manifest, and reword the organization-library comment above `exclude library -`
- [X] T009 [US4] In .highway/skills/highway-codify-config/SKILL.md `standard proposal` `accept`, create the catalog with this row only when it is absent, after the standard file write, creating `library/coding-standards/` when needed

---

## Phase 5: User Story 2 - Place an automation's files from its standards (Priority: P1)

**Goal**: Features own their lines, and the layout places their files

**Independent Test**: The task template has feature-grouped `Files:` lines, a test line first in its feature, `README.md` last, and no `executor/` or `task-N/` path. Codify proposals show **Files:**

- [X] T010 [P] [US2] Rewrite .highway/library/templates/output/codify-tasks.md to 4.0.0, following contracts/task-list.md
- [X] T011 [P] [US2] Update .highway/library/templates/output/codify-record.md to 7.0.0 with a per-task **Files:** ordered list
- [X] T012 [US2] In .highway/skills/highway-codify/SKILL.md, add `### layout` after `align`, add `layout` to the Procedure order, add **Files:** to the `propose` task block and its edit bullet, rewrite the `write` task-list bullets by feature, and change `code` to read the line's standards and named files only. Remove `executor/` and `task-N/` from Outputs, `write`, `code`, and Verification

---

## Phase 6: User Story 3 - Combine standards without mixing their files (Priority: P2)

**Goal**: Inheritance places a language's file names inside the platform folder. Called components keep their own standard

- [X] T013 [US3] In `### layout` of .highway/skills/highway-codify/SKILL.md, add the inheritance rule, the called-component rule, the no-standard root rule, and the no-structure pointer. Update Verification. Bump to 8.0.0
- [X] T014 [US3] Check codify and codify-config section word counts (at most 400 each), then run `validate-skill.sh` on both skills and `validate-library.sh` on the three templates

---

## Phase 7: Polish

- [X] T015 Amend highway-codify.test.sh, codify-config-skill.test.sh, codify-platform-catalog.test.sh, and codify-closing-guide.test.sh per research R9
- [X] T016 Run the new test and the codify tests, all passing
- [X] T017 Regenerate with `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`
- [X] T018 Run the full suite in the background, copy `Summary:` and `EXIT:` into specs/208-codify-file-layout/final.txt, and require 0 failed (D3.2)
- [X] T019 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- US1 (T004 through T006) and US4 (T007 through T009) both edit highway-codify-config, so T005, T006, and T009 run in order
- US2 depends on US1, because codify reads the new structure. US3 extends the `layout` section from US2
- Phase 7 depends on all stories

## Parallel Example

```text
T004 coding-standard.md   |   T007 seed removal   |   T008 manifest
T010 codify-tasks.md      |   T011 codify-record.md
```

## Implementation Strategy

The MVP is US1: a standard that carries its layout. US4 removes the seeds, so the person's catalog starts empty. US2 and US3 make codify place files from the layout, one feature at a time. The suite runs once at the start and once at the end.
