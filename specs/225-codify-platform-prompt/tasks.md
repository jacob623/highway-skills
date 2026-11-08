---

description: "Task list for codify platform prompt"
---

# Tasks: Codify Platform Prompt

**Input**: Design documents from `/specs/225-codify-platform-prompt/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Moved pins are in research R3.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/225-codify-platform-prompt/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/codify-platform-prompt.test.sh (mode 644). It requires every new line in contracts/wording.md in its skill, rejects every replaced line, and requires versions 10.4.0, 7.5.0, and 3.5.0. The PASS line is `PASS: platform prompts name how highway-codify uses the platform`
- [X] T003 Run the new test, observe it fail, and save its output to specs/225-codify-platform-prompt/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - Onboarding says what an included platform is for (Priority: P1) 🎯 MVP

**Goal**: Onboarding's included line, question, and configure line name highway-codify

**Independent Test**: The onboarding lines in the new test pass, and the replaced lines are absent

- [X] T004 [US1] In .highway/skills/highway-onboarding/SKILL.md, replace the included line and question in `orchestrate`, `configure` step 3, and the two verification lines per contracts/wording.md

---

## Phase 4: User Story 2 - Implementation asks the same question (Priority: P1)

**Goal**: Implementation's `platforms` step uses the same three lines

**Independent Test**: The implementation lines in the new test pass, and the replaced lines are absent

- [X] T005 [P] [US2] In .highway/skills/highway-implementation/SKILL.md, replace the included line, question, and accept line in `platforms`, and the verification line per contracts/wording.md

---

## Phase 5: User Story 3 - The configuration proposal names what it configures (Priority: P1)

**Goal**: The platform proposal heading and menu option name how highway-codify uses the platform

**Independent Test**: The codify-config lines in the new test pass, and the replaced lines are absent

- [X] T006 [P] [US3] In .highway/skills/highway-codify-config/SKILL.md, replace the menu option and the `platform proposal` heading per contracts/wording.md

---

## Phase 6: Polish

- [X] T007 Set versions to 10.4.0, 7.5.0, and 3.5.0 in the three SKILL.md files
- [X] T008 Move the pins listed in specs/225-codify-platform-prompt/research.md R3
- [X] T009 Run `validate-skill.sh` on the three skills and the quickstart grep
- [X] T010 Regenerate with `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`
- [X] T011 Run the full suite and copy `Summary:` and `EXIT:` into specs/225-codify-platform-prompt/final.txt. Require 0 failed (D3.2)
- [X] T012 Confirm no shipped file of this change references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004, T005, and T006 edit different files and can run beside each other
- T007 through T012 follow every story

## Parallel Example

```text
T004 onboarding skill, T005 implementation skill, T006 codify-config skill
```

## Implementation Strategy

MVP is User Story 1: onboarding names highway-codify. User Stories 2 and 3 complete the same wording in the other two skills and land in the same suite run.
