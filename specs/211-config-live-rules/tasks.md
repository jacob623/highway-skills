---

description: "Task list for current proposal rules"
---

# Tasks: Current Proposal Rules

**Input**: Design documents from `/specs/211-config-live-rules/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Three version pins move, with D3.5 reasons in research R6.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` in the background with all permissions, wait for it, and copy the `Summary:` and `EXIT:` lines into specs/211-config-live-rules/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/config-live-rules.test.sh (mode 644, static-document-contract header). It reads .highway/skills/highway-codify-config/SKILL.md and .highway/library/templates/output/coding-standard.md and requires the phrases in contracts/proposal-rules.md: `### current` before `### platform proposal`, `The current documentation could not be read.`, `**Why it matters:**`, `the word must`, `encoded or encrypted credentials`, `go to \`menu\``, `does not run \`current\``, skill `version: 3.0.0`, and template `version: 3.0.0`. It rejects `each an imperative a reviewer can check` and `Otherwise go to \`standards\``. It counts `### current`, `### platform proposal`, and `### standard proposal` and fails when any exceeds 400 words.
- [X] T003 Run the new test, observe it fail, and save its output to specs/211-config-live-rules/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - A proposal reflects current capabilities (Priority: P1) 🎯 MVP

**Goal**: An add or update reads the current documentation before the proposal

**Independent Test**: `### current` stands before `### platform proposal`. An add or update goes there. A removal does not.

- [X] T004 [US1] Add `### current` from contracts/proposal-rules.md to .highway/skills/highway-codify-config/SKILL.md immediately before `### platform proposal`. Route an add or update in `platforms` and `standards` through `current`. Leave a removal on the proposal.

---

## Phase 4: User Story 2 - Each use rule is deterministic (Priority: P1)

**Goal**: Each use entry is one sentence, with Why it matters only on the proposal

**Independent Test**: The procedure states the use-rule shape, and both proposal openings name `current` without saving Why it matters

- [X] T005 [US2] Add the use-rule paragraph from contracts/proposal-rules.md to the procedure in .highway/skills/highway-codify-config/SKILL.md. Do not add a Why it matters line under **What would you add or correct?**
- [X] T006 [US2] Replace the opening of `platform proposal` in .highway/skills/highway-codify-config/SKILL.md with the paragraph in contracts/proposal-rules.md

---

## Phase 5: User Story 3 - Every coding rule is a must (Priority: P1)

**Goal**: Each coding rule contains the word must, including the credential rule

**Independent Test**: The standard proposal and `coding-standard.md` both require the word must and the credential rule, at most ten rules

- [X] T007 [US3] Replace the opening of `standard proposal` in .highway/skills/highway-codify-config/SKILL.md with the paragraph in contracts/proposal-rules.md
- [X] T008 [P] [US3] Update .highway/library/templates/output/coding-standard.md to version 3.0.0 and the Rules text in contracts/proposal-rules.md

---

## Phase 6: User Story 4 - A saved standard returns to the menu (Priority: P2)

**Goal**: A coding standard saved with no conflicts states its consequence and returns to the menu

**Independent Test**: `standard write` step 3 goes to `menu` when the proposal listed no conflicts. The platform write is unchanged

- [X] T009 [US4] Replace the no-conflict branch of `standard write` in .highway/skills/highway-codify-config/SKILL.md with the sentence in contracts/proposal-rules.md. Set `metadata.version` to 3.0.0. Add the four Verification bullets from that contract.

---

## Phase 7: Polish

- [X] T010 Confirm `### current`, `### platform proposal`, and `### standard proposal` are each at or under 400 words, then run `validate-skill.sh` on highway-codify-config and `validate-library.sh` on coding-standard.md
- [X] T011 [P] Move the pins in research R6: `version: 2.0.0` to `version: 3.0.0` for highway-codify-config in .highway/tools/tests/codify-config-skill.test.sh and .highway/tools/tests/codify-file-layout.test.sh, and for coding-standard.md in .highway/tools/tests/codify-file-layout.test.sh
- [X] T012 Regenerate with `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`
- [X] T013 Run the full suite in the background, copy `Summary:` and `EXIT:` into specs/211-config-live-rules/final.txt, and require 0 failed (D3.2)
- [X] T014 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 through T007 and T009 edit the same skill, in that order
- T008 edits the template and can run beside T007
- T011 follows T008 and T009, because the pins name the new versions
- Phase 7 depends on all four stories

## Parallel Example

```text
T008 coding-standard.md beside T007 standard proposal
T011 version pins beside T010 validation, after the versions are set
```

## Implementation Strategy

The MVP is US1: `current` runs before an add or update. US2 shapes the use rules. US3 makes each coding rule a must, including credentials. US4 returns a clean standard write to the menu. The suite runs once at the start and once at the end.
