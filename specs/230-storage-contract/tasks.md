---

description: "Task list for storage contract"
---

# Tasks: Storage Contract

**Input**: Design documents from `/specs/230-storage-contract/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new test is written and observed failing before any source edit. Moved pins are in research R8.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US4)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/230-storage-contract/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/storage-contract.test.sh (mode 644). It requires: `.highway/governance/storage.md` with an Operations table of exactly four rows, each with a Local entry and `not supported yet` for Remote and Chat; the P2.6 row in .highway/governance/constitution.md with tier `[auto]` and `**Version**: 10.0.0`; P2.6 in the rule-checks registry and library exempt list; seeded skills that fail with `ERROR: [P2.6]` for a script, a `git` command, an absolute path, and a file time; seeded skills that pass for a slash command, a URL, `.gitignore`, `GitHub`, a fenced pipeline, and "Emit no timestamp"; every shipped skill passing `rc_check_P2_6`; the help and codify lines in contracts/wording.md; the Features table in codify-metadata.md; the agent-context sentence in the source and the four generated instruction files; and the versions in R8. The PASS line is `PASS: every skill reaches the repository only through the storage contract`
- [X] T003 Run the new test, observe it fail, and save its output to specs/230-storage-contract/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - One storage contract (Priority: P1) 🎯 MVP

**Goal**: One shipped document defines the four operations and three modes

**Independent Test**: The storage.md pins of storage-contract.test.sh pass

- [X] T004 [US1] Write .highway/governance/storage.md per data-model.md: Scope, Paths, Modes, an Operations table with four rows and Local, Remote (Option A), and Chat (Option B) columns, and What a skill does not do

---

## Phase 4: User Story 2 - The rule and its check (Priority: P1)

**Goal**: P2.6 is in the constitution and decided by a registered check

**Independent Test**: The seeded P2.6 cases and the all-skills pass of storage-contract.test.sh pass

- [X] T005 [US2] In .highway/tools/tests/fixtures/*/SKILL.md, reword each Verification line naming `.highway/tools/validate-skill.sh` per contracts/wording.md, and confirm each fixture's verdict matches research R3 (D3.4)
- [X] T006 [US2] In .highway/skills/highway-help/SKILL.md, reword the Inputs catalog line and the missing-catalog Error Handling item per contracts/wording.md, and set `version: 3.1.0`
- [X] T007 [US2] In .highway/tools/lib/rule-checks.sh, add `P2.6	rc_check_P2_6	-` to `rc_registry`, add P2.6 to `rc_library_exempt_ids`, and add `rc_check_P2_6` per research R2
- [X] T008 [US2] In .highway/governance/constitution.md, add the P2.6 row after P2.5, a Sync Impact Report for 9.1.0 → 10.0.0 (MAJOR), and the footer `**Version**: 10.0.0 | **Ratified**: 2026-09-06 | **Last Amended**: 2026-11-09`
- [X] T009 [US2] In .highway/tools/tests/rule-checks.test.sh, add a seeded `"P2.6"` case with `assert_reports`

---

## Phase 5: User Story 3 - The Features table (Priority: P2)

**Goal**: Codify numbers from the product's Features table and never lists the features folder

**Independent Test**: The codify and codify-metadata pins of storage-contract.test.sh pass

- [X] T010 [P] [US3] In .highway/library/templates/output/codify-metadata.md, add the `## Features` table, define its columns, replace the "written once" sentence, and set `version: 2.0.0`
- [X] T011 [US3] In .highway/skills/highway-codify/SKILL.md, change Inputs, Outputs, `write`, and the two Verification bullets per contracts/wording.md, and set `version: 14.0.0`. Keep `write` at or under 250 words

---

## Phase 6: User Story 4 - Agent pointer (Priority: P3)

**Goal**: Agents learn where the storage contract lives

**Independent Test**: The agent-context pins of storage-contract.test.sh pass

- [X] T012 [US4] In .highway/instructions/highway-agent-context.md, add the storage bullet per contracts/wording.md, then run `bash .highway/tools/generate-instructions.sh`

---

## Phase 7: Polish & Cross-Cutting Concerns

- [X] T013 [P] Add the "Reaching the repository" section to .highway/skills/_authoring-standard.md and name the storage contract in the `governance/` line of .highway/DISTRIBUTION.md (D6.1)
- [X] T014 Move the pins in research R8 across .highway/tools/tests/*.test.sh (D3.5)
- [X] T015 Run `bash .highway/tools/validate-skill.sh` for every skill under .highway/skills/ and `bash .highway/tools/validate-library.sh` for .highway/library/templates/output/codify-metadata.md
- [X] T016 Regenerate with `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh` (D4.5 through D4.7)
- [X] T017 Run `bash .highway/tools/tests/run-all.sh` into specs/230-storage-contract/final.txt. Require 0 failed (D3.2)
- [X] T018 Confirm no shipped file under .highway/ references `.specify/` or `specs/` (D1.1)

---

## Dependencies & Execution Order

- T001 → T002 → T003 → T004 → T005 → T006 → T007 → T008 → T009 → T010 and T011 → T012 → T013 → T014 → T015 → T016 → T017 → T018.
- T005 and T006 come before T007, so no artifact fails P2.6 once the check is registered (D3.4).
- T007 comes before T008: `constitution-inventory.test.sh` requires every `[auto]` row to have a registered check.

## Parallel Example

- T010 and T013 edit files no other task in their phase touches.

## Implementation Strategy

US1 is the MVP: the contract exists. US2 makes it binding. US3 removes the one folder listing. US4 makes the contract discoverable.
