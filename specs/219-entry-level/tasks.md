---

description: "Task list for entry level and consequence under each entry"
---

# Tasks: Entry Level

**Input**: Design documents from `/specs/219-entry-level/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Pins and moved assertions are in research R5.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US4)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/219-entry-level/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/entry-level.test.sh (mode 644). It requires every sentence in contracts/config-steps.md in its step, the heading order `current`, `entry level`, `use entries`, `platform proposal`, the entry form with its blank line in both proposal shapes, and version 3.2.2. It rejects the lines the contract lists, and the banned words in `entry level` and `use entries`. It fails when `entry level` or `use entries` exceeds 250 words, or either proposal exceeds 400. The PASS line is `PASS: config proposals offer classes of automation with each consequence under its entry`
- [X] T003 Run the new test, observe it fail, and save its output to specs/219-entry-level/probe-fail.txt (D3.6)

---

## Phase 3: User Stories 1 and 4 - Classes of automation in one step (Priority: P1) 🎯 MVP

**Goal**: An add proposes one to four classes per list from `entry level`, for platforms and coding standards

**Independent Test**: `### entry level` holds the nine steps between `current` and `use entries`. `use entries` step 2 follows it on an add, and step 4 has no example list

- [X] T004 [US1] [US4] In .highway/skills/highway-codify-config/SKILL.md, add `### entry level` after `current`, and replace `use entries` steps 2 and 4 per contracts/config-steps.md

---

## Phase 4: User Story 2 - Saved entries kept (Priority: P2)

**Goal**: An update keeps saved entries and rewrites only those that break the form

**Independent Test**: `use entries` step 7 matches the contract

- [X] T005 [US2] In .highway/skills/highway-codify-config/SKILL.md, replace `use entries` step 7 per contracts/config-steps.md

---

## Phase 5: User Story 3 - Consequence under each entry (Priority: P1)

**Goal**: Both shapes put a blank line, then **Why it matters:** as the entry's consequence, and drop **Consequences:**

**Independent Test**: Both shapes show the entry form. Neither contains `**Consequences:**`. `standard rules` step 6 and `standard proposal` step 6 match the contract

- [X] T006 [US3] In .highway/skills/highway-codify-config/SKILL.md, replace `use entries` step 9, update both proposal shapes, remove both **Consequences:** sections, and replace `standard rules` step 6 and `standard proposal` step 6 per contracts/config-steps.md

---

## Phase 6: Polish

- [X] T007 Update the two Verification bullets per contracts/config-steps.md
- [X] T008 Set `metadata.version` to 3.2.2
- [X] T009 [P] Move the pins and assertions in research R5
- [X] T010 Run the word count and `validate-skill.sh` on the skill (D8.1)
- [X] T011 Regenerate with `generate-catalog.sh` and `generate-agent-adapters.sh`
- [X] T012 Run the full suite and copy `Summary:` and `EXIT:` into specs/219-entry-level/final.txt. Require 0 failed (D3.2)
- [X] T013 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 through T008 edit the same file and run in order
- T009 edits tests only and follows T008
- Phase 6 depends on every story

## Parallel Example

```text
T009 test pins, beside T007 Verification, after T008
```

## Implementation Strategy

`entry level` is the MVP the request named. The update path keeps a person's entries. The consequence moves under each entry and the Consequences section leaves both shapes. The suite runs once at the start and once at the end.
