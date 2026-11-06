---

description: "Task list for configure handoff"
---

# Tasks: Configure Handoff

**Input**: Design documents from `/specs/216-configure-handoff/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Pins and moved assertions are in research R5.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US4)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/216-configure-handoff/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/configure-handoff.test.sh (mode 644). It requires every sentence in contracts/handoff-steps.md, the order `### lineage`, `### configure`, `### summary`, and the three versions. It rejects the three lines the contract lists, and the banned words in `configure`, implementation `platforms`, configuration Entry, and configuration `menu`. It fails when `configure` exceeds 250 words. The PASS line is `PASS: onboarding and implementation hand off to configuration and return`
- [X] T003 Run the new test, observe it fail, and save its output to specs/216-configure-handoff/probe-fail.txt (D3.6)

---

## Phase 3: User Story 3 - Leaving configuration returns only when someone is waiting (Priority: P1)

**Goal**: Configuration holds a return step and its menu decline goes there

**Independent Test**: Entry holds the return step. The menu decline goes to it, or stops with none held

- [X] T004 [US3] In .highway/skills/highway-codify-config/SKILL.md, add Entry step 2 and renumber, replace the `menu` decline, and add the Verification bullet per contracts/handoff-steps.md

---

## Phase 4: User Story 1 - Onboarding configures the platform, then closes (Priority: P1) 🎯 MVP

**Goal**: Onboarding hands off each agreed platform after the records and closes once

**Independent Test**: `configure` sits between `lineage` and `summary` with four steps. The configure pointer is absent. The finish-adding line stays

- [X] T005 [US1] In .highway/skills/highway-onboarding/SKILL.md, update the procedure order, the `orchestrate` sentences, and `lineage`, add `### configure`, remove the pointer from `summary`, and replace the Verification pointer bullet per contracts/handoff-steps.md

---

## Phase 5: User Story 2 - A new implementation does the same (Priority: P1)

**Goal**: Implementation hands off on a yes and returns to `close`

**Independent Test**: The `accept` branch hands off with the return step `close`. The onboarding path returns after the write. The pointer is absent

- [X] T006 [US2] In .highway/skills/highway-implementation/SKILL.md, add the onboarding-path sentence to `platforms`, replace the `accept` branch, and replace the Verification pointer per contracts/handoff-steps.md

---

## Phase 6: User Story 4 - Each skill states the handoff as steps (Priority: P1)

**Goal**: Every new or changed step is conditions and actions with named next steps

**Independent Test**: The new test's banned-word and word-count checks pass

- [X] T007 [US4] Read each new and changed sentence in the three skills. Rewrite any sentence that explains, justifies, or describes the flow as a condition and an action

---

## Phase 7: Polish

- [X] T008 Set `metadata.version` to 10.1.0, 7.1.0, and 3.1.0 in the three skills
- [X] T009 [P] Move the pins and assertions in research R5
- [X] T010 Run `validate-skill.sh` on the three skills (D8.1)
- [X] T011 Regenerate with `generate-catalog.sh` and `generate-agent-adapters.sh`
- [X] T012 Run the full suite and copy `Summary:` and `EXIT:` into specs/216-configure-handoff/final.txt. Require 0 failed (D3.2)
- [X] T013 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004, T005, and T006 edit different files and follow T003
- T007 follows T004 through T006
- T009 follows T008, because the pins name the new versions
- Phase 7 depends on every story

## Parallel Example

```text
T004 configuration, T005 onboarding, and T006 implementation, after T003
```

## Implementation Strategy

US3 comes first because the return is what US1 and US2 land on. US1 is the MVP the request names. US2 applies the same handoff to implementation. US4 holds the form. The suite runs once at the start and once at the end.
