---

description: "Task list for the codify closing guide"
---

# Tasks: Codify Closing Guide

**Input**: Design documents from `/specs/206-codify-closing-guide/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/readme-headings.md, contracts/completion-close.md, contracts/catalog-view.md, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before the skill edits. Two existing tests are amended with D3.5 reasons.

**Organization**: Tasks are grouped by user story so each story can be checked on its own.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)

---

## Phase 1: Setup

**Purpose**: Confirm a green suite before any edit (D3.1)

- [X] T001 Run `bash .highway/tools/tests/run-all.sh > /tmp/206-baseline.txt 2>&1; echo "EXIT:$?" >> /tmp/206-baseline.txt` in the background with all permissions, wait for it, then copy the `Summary:` and `EXIT:` lines into specs/206-codify-closing-guide/baseline.txt. Stop if any test fails

---

## Phase 2: Foundational

**Purpose**: The failing test every story is checked against

- [X] T002 Create .highway/tools/tests/codify-closing-guide.test.sh (mode 644) in the house style: `# Instrument class: static-document-contract`, `# Artifact classes: source-document`, and `# Seeded failure probe:` header lines, then `require` and `reject` helpers using `grep -Fq`, plus a `reject_line` helper using `grep -Fxq` for whole-line headings. Assert in `.highway/skills/highway-codify/SKILL.md`: require `` Head the first part `## Setup Instructions` and the second part `## User Guide`. ``, `### The codify stage is complete.`, `This code is now part of your Highway knowledge base.`, `The automation was not run.`, `**The files can be found here:**`, `If you'd like to review the files together, just say so.`, `**Setup and Usage Instructions** can be found here:`, `If you'd like to review the instructions together, just say so.`, `just ask highway to show your code catalog`, `Run /highway-help to explore what Highway can help you do.`, `### catalog`, `` When the invocation is the word `catalog` ``, `**Which automation would you like to discuss?**`, `more automations are not shown.`, `1 more automation is not shown.`, `You can name or describe any automation.`, `No automation has been created yet.`, `The instructions are not written yet.`, `Append the new row as the last row.`, and `version: 6.0.0`; reject `` `## Implement` ``, `` `## Use` ``, `Order the index by Automation ID.`, and `[Every task is done. Or: Task`. Assert in `.highway/library/templates/output/codify-record.md`: require `## Setup Instructions`, `## User Guide`, `User Guide follows the interface of the Provider.`, and `version: 5.0.0`; reject_line `## Implement` and `## Use`. Assert in `.highway/library/templates/output/codify-catalog.md`: require `Rows are in acceptance order.`, `A new row is appended as the last row.`, and `version: 2.0.0`; reject `Rows are ordered by Automation ID.`. End with `PASS: codify closing guide, README headings, and catalog view`
- [X] T003 Run `bash .highway/tools/tests/codify-closing-guide.test.sh > specs/206-codify-closing-guide/probe-fail.txt 2>&1; echo "EXIT:$?" >> specs/206-codify-closing-guide/probe-fail.txt` and confirm it fails with FAIL lines and a nonzero exit (D3.6)

**Checkpoint**: The new test fails only on skill and template strings

---

## Phase 3: User Story 1 - Read a README with plain section names (Priority: P1)

**Goal**: The README is headed `## Setup Instructions` then `## User Guide`

**Independent Test**: Read the README task in `code` and the Readme block in the record template. Both name the new headings in order, and neither names `## Implement` or `## Use`

- [X] T004 [US1] In `code` of .highway/skills/highway-codify/SKILL.md, rewrite the README sentence per specs/206-codify-closing-guide/contracts/readme-headings.md: `` Head the first part `## Setup Instructions` and the second part `## User Guide`. `` Then "Setup Instructions says what is put in place…" and "User Guide says how a non-technical person starts this one automation…, using the interface of the Provider. User Guide does not ask that person to edit the generated files or read the implementation record."
- [X] T005 [P] [US1] In .highway/library/templates/output/codify-record.md, change the Readme block headings to `## Setup Instructions` and `## User Guide`, and replace the sentence after the block with `Setup Instructions is for the person who accepted the proposal. User Guide follows the interface of the Provider. User Guide does not ask that person to edit the generated files or read the implementation record.` (research R6). Bump `version: 4.0.0` to `version: 5.0.0`
- [X] T006 [US1] In .highway/tools/tests/highway-codify.test.sh, replace `'## Implement'` with `'## Setup Instructions'` and `'## Use'` with `'## User Guide'` (research R7, D3.5)

**Checkpoint**: `bash .highway/tools/tests/highway-codify.test.sh` passes

---

## Phase 4: User Story 2 - Close with where the work is and what to do next (Priority: P1)

**Goal**: When every task is done, the close is the completion message with the two paths

**Independent Test**: Read `close`. With every task done, it emits the completion message with `code/[ID]/`, `code/[ID]/README.md`, and "The automation was not run." after the knowledge-base paragraph

- [X] T007 [US2] Rewrite `### close` in .highway/skills/highway-codify/SKILL.md per specs/206-codify-closing-guide/contracts/completion-close.md. Open with the coding-standard notices that apply. Then: "When every task is done, emit:" followed by the completion message exactly as in the contract, with `` `code/[ID]/` `` and `` `code/[ID]/README.md` ``. Keep "ask highway" lowercase (research R2)
- [X] T008 [US2] In Outputs of .highway/skills/highway-codify/SKILL.md, replace the closing-message bullet with: when every task is done, the completion message naming the files path and the README path; when a task could not be finished, the stopped-task close. Both say the automation was not run

**Checkpoint**: The completion message strings in T002 are present

---

## Phase 5: User Story 3 - Keep the stopped-task close for unfinished work (Priority: P2)

**Goal**: A stopped run keeps the current block and never says the stage is complete

**Independent Test**: Read `close`. The stopped variant names the task and reason, ends with "The automation was not run.", and has no "Every task is done." alternative

- [X] T009 [US3] In `### close` of .highway/skills/highway-codify/SKILL.md, after the completion message, add "When a task could not be finished, emit:" followed by the stopped-task block from specs/206-codify-closing-guide/contracts/completion-close.md: **Automation recorded**, the record, task list, title, and implementation lines, `Task [T###] could not be finished because [reason]. The next run starts there.`, and `The automation was not run.` Remove the `[Every task is done. Or: …]` line. Confirm `### close` stays at or under 400 words

**Checkpoint**: The `[Every task is done. Or: Task` reject in T002 passes

---

## Phase 6: User Story 4 - Show the code catalog on request (Priority: P2)

**Goal**: `/highway-codify catalog` lists the five most recent automations, newest first, and writes nothing. The catalog is in acceptance order

**Independent Test**: Read Entry, `catalog`, `write`, and the catalog template. Seven accepted automations show five lines and "2 more automations are not shown." A new row is appended last

- [X] T010 [US4] In `Entry` of .highway/skills/highway-codify/SKILL.md, insert step 3 after the `configure` step: `` When the invocation is the word `catalog`, or asks to show the code catalog, go to `catalog`. Do not resume a task list or select an implementation. `` Renumber the later steps. Update the Procedure order sentence to say `configure` and `catalog` each run alone, and add a `When to use` bullet for `/highway-codify catalog`. Leave `usage` unchanged: the frontmatter lexicon rejects `catalog` and `configure`, and `When to use` names both invocations (research R3)
- [X] T011 [US4] Add `### catalog` after `### configure` in .highway/skills/highway-codify/SKILL.md per specs/206-codify-closing-guide/contracts/catalog-view.md and research R4–R5. Read accepted rows of `code/code.md`, take the last five, and emit `**[N]. [Automation title]:** [Implementation title]. [Every task is done. Or: Task [T###] is next.]` newest first, numbered from 1. Do not use an id as a label and do not list or count removed rows. With more than five, add `[N] more automations are not shown.` or `1 more automation is not shown.`, then ask `**Which automation would you like to discuss?**` and add `You can name or describe any automation.` With five or fewer, ask only the question. With none, say `No automation has been created yet.` Classify replies: a listed number, an exact title without regard to case, a description matching one, several (list matches newest first, at most five, ask again), none (say so, ask again), and `decline` (stop). A selection shows the title, `**Files:**` `` `code/[ID]/` ``, `**Setup and Usage Instructions:**` `` `code/[ID]/README.md` `` or `The instructions are not written yet.` when the README task is open, then `**What would you like to know about it?**` Write nothing. Do not enter `choose`, `suggest`, `start`, `code`, or `configure`. Confirm the section stays at or under 400 words
- [X] T012 [US4] In `write` of .highway/skills/highway-codify/SKILL.md, replace `Order the index by Automation ID.` with `Keep rows in acceptance order. Append the new row as the last row. A row whose status changes keeps its position.`
- [X] T013 [P] [US4] In .highway/library/templates/output/codify-catalog.md, replace `Rows are ordered by Automation ID.` with `Rows are in acceptance order. A new row is appended as the last row. A row whose status changes keeps its position.` Bump `version: 1.0.0` to `version: 2.0.0`

**Checkpoint**: The catalog strings in T002 are present

---

## Phase 7: Polish and Cross-Cutting Concerns

- [X] T014 Bump `version: 5.0.0` to `version: 6.0.0` in .highway/skills/highway-codify/SKILL.md
- [X] T015 In .highway/tools/tests/codify-platform-catalog.test.sh, change the highway-codify pin `version: 5.0.0` to `version: 6.0.0` and the codify-record pin `version: 4.0.0` to `version: 5.0.0` (research R7, D3.5). Leave every other assertion unchanged
- [X] T016 Add Verification bullets to .highway/skills/highway-codify/SKILL.md: the README is headed Setup Instructions then User Guide; a finished run closes with the completion message, both paths, and the not-run sentence; a stopped run closes with the stopped task and never says the stage is complete; `/highway-codify catalog` lists at most five accepted automations newest first, says how many more exist, and writes nothing; a new catalog row is appended last
- [X] T017 Run `bash .highway/tools/tests/codify-closing-guide.test.sh`, `bash .highway/tools/tests/highway-codify.test.sh`, and `bash .highway/tools/tests/codify-platform-catalog.test.sh`, and confirm each passes
- [X] T018 Measure the word count of each changed `###` section in .highway/skills/highway-codify/SKILL.md and confirm each is at or under 400 words (P7.5). Confirm 12 or fewer MUST rules (P7.4)
- [X] T019 With all permissions, run `bash .highway/tools/validate-skill.sh .highway/skills/highway-codify` (D8.1), and `bash .highway/tools/validate-library.sh` on .highway/library/templates/output/codify-record.md and .highway/library/templates/output/codify-catalog.md
- [X] T020 With all permissions, run `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-agent-adapters.sh` (D4.5–D4.7)
- [X] T021 Confirm no changed shipped file under .highway/ references `.specify/` or `specs/` (D1.1, D1.2)
- [X] T022 Run `bash .highway/tools/tests/run-all.sh` in the background with all permissions, wait for it, and confirm `0 failed` and `EXIT:0` (D3.2)
- [X] T023 Walk the manual scenarios in specs/206-codify-closing-guide/quickstart.md against the skill text

---

## Dependencies and Execution Order

### Phase Dependencies

- Setup runs first
- Foundational depends on Setup. T003 depends on T002
- US1 through US4 depend on Foundational
- Polish depends on all stories

### User Story Dependencies

- Every story edits .highway/skills/highway-codify/SKILL.md, so the skill tasks run in order: T004, T007–T009, T010–T012
- US3 rewrites the same `close` section as US2, so it follows US2
- T005 and T013 edit templates only and can run beside any skill task
- T006 edits a test only and can run once T004 is done

### Parallel Opportunities

- T005 and T013 edit different templates
- Do not parallelize two tasks that edit the same skill

---

## Parallel Example: Templates beside the skill

```text
Task: "T004 README sentence in .highway/skills/highway-codify/SKILL.md"
Task: "T005 Readme block in .highway/library/templates/output/codify-record.md"
Task: "T013 Row order in .highway/library/templates/output/codify-catalog.md"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. Stop and read the README sentence and the Readme block. Both say Setup Instructions then User Guide

### Incremental Delivery

1. User Story 1 renames the README parts
2. User Story 2 adds the completion message
3. User Story 3 keeps the stopped-task close separate
4. User Story 4 adds the catalog view and acceptance order
5. Polish bumps the version, amends two version pins, validates, regenerates, and requires a green suite

The new test passes only after all four stories and the version bump.

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to a user story for traceability
- Existing READMEs and catalogs are not rewritten
- Do not commit unless asked
