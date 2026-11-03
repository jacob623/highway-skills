---

description: "Task list for the codify config skill"
---

# Tasks: Codify Config Skill

**Input**: Design documents from `/specs/207-codify-config-skill/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Four existing tests are amended with D3.5 reasons (research R11).

**Organization**: Tasks are grouped by user story. Templates come first because every story reads them.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US6)

---

## Phase 1: Setup

**Purpose**: Confirm a green suite before any edit (D3.1)

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` in the background with all permissions, wait for it, and copy the `Summary:` and `EXIT:` lines into specs/207-codify-config-skill/baseline.txt. Stop if any test fails

---

## Phase 2: Foundational (failing test and templates)

**Purpose**: Write the contract test first, then the templates every story reads

- [X] T002 Write .highway/tools/tests/codify-config-skill.test.sh (mode 644, static-document-contract header, `require`/`reject` helpers). It requires the menu heading and three options, the two questions, the cancel line, the ordered-list presentation, the conflict question, the `/highway-codify-config [Platform]` entry, the new templates and columns, codify's `**Standards:**` and `### standards`, and the inclusion question in implementation and onboarding. It rejects `### configure` and `/highway-codify configure` in codify
- [X] T003 Run the new test, observe it fail, and save its output to specs/207-codify-config-skill/probe-fail.txt (D3.6)
- [X] T004 [P] Rewrite .highway/library/templates/output/codify-platforms.md to 2.0.0: path `library/coding-standards/codify-platforms.md`, columns Platform, Implementation ID, When to use, When not to use, semicolon list cells shown as ordered lists in proposals, no Source
- [X] T005 [P] Create .highway/library/templates/output/coding-standards-catalog.md 1.0.0 with the eight-column table and the list-cell rule
- [X] T006 [P] Create .highway/library/templates/output/coding-standard.md 1.0.0 with Scope, Rules (at most ten), and Tests
- [X] T007 [P] Update library/coding-standards/coding-standards.md to the new columns, giving the Terraform row When to use and When not to use entries and a blank Inherits From
- [X] T008 [P] Update .highway/library/templates/output/codify-record.md to 6.0.0 with a per-task `**Standards:**` ordered list
- [X] T009 [P] Update .highway/library/templates/output/codify-tasks.md to 3.0.0: lines name `Standards:` paths in order, and the README text names Setup Instructions and User Guide
- [X] T010 Run `validate-library.sh` on the five templates

---

## Phase 3: User Stories 1-4 - highway-codify-config (Priority: P1/P2) 🎯 MVP

**Goal**: The new skill owns the menu, platforms, standards, and conflicts

**Independent Test**: `validate-skill.sh .highway/skills/highway-codify-config` passes, and the new test's config checks pass

- [X] T011 [US1] Create .highway/skills/highway-codify-config/SKILL.md 1.0.0 with frontmatter, Purpose, When to use, When not to use, Inputs, Outputs, Procedure, `Entry`, `Classify`, and `menu`, following contracts/config-menu.md
- [X] T012 [US2] Add `platforms` and `platform proposal` to the same file, following contracts/platform-proposal.md, including the onboarding hand-off and the follow-up offers
- [X] T013 [US3] Add `standards` and `standard proposal`, following contracts/standard-proposal.md
- [X] T014 [US4] Add `conflicts` and `resolve`, following contracts/conflicts.md
- [X] T015 Add Verification, Error Handling, and Example. Check that each `###` section is at most 400 words, then run `validate-skill.sh`
- [X] T016 [P] Add `highway-codify-config` include lines for the four adapter trees in .highway/tools/.distribution-manifest

---

## Phase 4: User Story 5 - Codify uses the guidance (Priority: P1)

**Goal**: Provider by fit, and a per-task Standards list

- [X] T017 [US5] In .highway/skills/highway-codify/SKILL.md, remove configure (When to use bullet, entry step, `### configure`, Verification, Outputs) and point to `/highway-codify-config`. Change platform paths to `library/coding-standards/codify-platforms.md`
- [X] T018 [US5] Rewrite the Provider rule in `start` to: named, then fit, then this implementation's row, then the first row
- [X] T019 [US5] Add `### standards` between `start` and `align`, add `**Standards:**` to the propose task block and its edit bullet, change `align`, `write` (shorter standards bullets), `code`, and `close` to use each task's list, and update Verification. Bump to 7.0.0
- [X] T020 [US5] Check codify section word counts, then run `validate-skill.sh`

---

## Phase 5: User Story 6 - Implementation and onboarding ask to configure (Priority: P2)

- [X] T021 [P] [US6] In .highway/skills/highway-implementation/SKILL.md, write the row at the new path with blank guidance, emit the inclusion sentence and the configure question, and handle yes and no. Update Inputs, Outputs, and Verification. Bump to 7.0.0
- [X] T022 [P] [US6] In .highway/skills/highway-onboarding/SKILL.md, ask the configure question per automation platform, collect the yes answers, and add the summary pointers and the codify-config hand-off line. Update paths. Bump to 9.0.0
- [X] T023 [US6] Run `validate-skill.sh` on both skills

---

## Phase 6: Polish

- [X] T024 Amend codify-platform-catalog.test.sh, codify-closing-guide.test.sh, output-template.test.sh, and record-purpose-titles.test.sh per research R11
- [X] T025 Run the new test and the four amended tests, all passing
- [X] T026 Regenerate with `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`
- [X] T027 Run the full suite in the background, copy `Summary:` and `EXIT:` into specs/207-codify-config-skill/final.txt, and require 0 failed (D3.2)
- [X] T028 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 through T009 run in parallel. T010 depends on them
- Phase 3 depends on Phase 2. T011 through T015 edit one file in order
- Phase 4 depends on Phase 2. Phase 5 depends on Phase 3 (pointer target)
- Phase 6 depends on all earlier phases

## Implementation Strategy

MVP is Phase 3: the new skill working against the new templates. Then codify reads the guidance, and inclusion asks the configure question. The suite runs once at the start and once at the end.
