---

description: "Task list for platform starting point and automation grounding"
---

# Tasks: Platform Starting Point and Automation Grounding

**Input**: Design documents from `/specs/217-platform-starting-point/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Pins and moved assertions are in research R7.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US8)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/217-platform-starting-point/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/platform-starting-point.test.sh (mode 644). It requires every sentence in contracts/config-steps.md, the Why it matters line under each `1. [Entry]` in both proposal shapes, and the two versions. It rejects the three lines the contract lists, and the banned words in the steps it names. It fails when `use entries` or `add capabilities` exceeds 250 words, or `current`, `platform proposal`, or `standard proposal` exceeds 400. The PASS line is `PASS: config proposals start from automation best practice and record new capabilities`
- [X] T003 Run the new test, observe it fail, and save its output to specs/217-platform-starting-point/probe-fail.txt (D3.6)

---

## Phase 3: User Stories 1 and 2 - Starting-point line (Priority: P1, P2) 🎯 MVP

**Goal**: The line appears on an unedited add or update proposal only

**Independent Test**: The shape carries the bracketed line after the consequence sentence. The `edit` branch re-emits without it. A remove follows step 2

- [X] T004 [US1] [US2] In .highway/skills/highway-codify-config/SKILL.md, add the `platform proposal` opening steps, the bracketed starting-point line, and the `edit` wording per contracts/config-steps.md

---

## Phase 4: User Stories 3, 4, 6, and 7 - Use entries (Priority: P1)

**Goal**: Entries come from automation best practice, five words or fewer, with Why it matters beneath

**Independent Test**: `use entries` holds the ten steps. Both shapes show Why it matters under each entry. The Procedure paragraph is gone

- [X] T005 [US3] [US4] [US6] [US7] In .highway/skills/highway-codify-config/SKILL.md, remove the Procedure use-entry paragraph, add `### use entries` after `standard write`, add the `standard proposal` opening sentence, and add the Why it matters lines to both proposal shapes

---

## Phase 5: User Story 5 - New realized capabilities (Priority: P2)

**Goal**: `current` captures automation capabilities, the proposal lists the new ones, and `highway-implementation` records them and returns

**Independent Test**: `current` is seven numbered steps. The proposal shows New Realized Capabilities. `accept` hands off with the return step `platform written`. `add capabilities` records without a question

- [X] T006 [US5] In .highway/skills/highway-codify-config/SKILL.md, rewrite `current`, add New Realized Capabilities and its sentence, replace the `accept` after-write text, add `### platform written`, and add `highway-implementation` to Inputs
- [X] T007 [P] [US5] In .highway/skills/highway-implementation/SKILL.md, add Entry step 1 and renumber, add `### add capabilities` after `close`, and update Purpose, When to use, Outputs, and the Procedure order

---

## Phase 6: User Story 8 - Ordered steps (Priority: P1)

**Goal**: Every new or changed step is numbered conditions and actions

**Independent Test**: The new test's banned-word and word-count checks pass

- [X] T008 [US8] Read each new and changed step in both skills. Rewrite any sentence that explains, justifies, or describes the flow as a condition and an action

---

## Phase 7: Polish

- [X] T009 Update Verification in both skills for the starting-point line, `use entries`, new realized capabilities, and `add capabilities`
- [X] T010 Set `metadata.version` to 3.2.0 and 7.2.0
- [X] T011 [P] Move the pins and the assertion in research R7
- [X] T012 Run `validate-skill.sh` on both skills (D8.1)
- [X] T013 Regenerate with `generate-catalog.sh` and `generate-agent-adapters.sh`
- [X] T014 Run the full suite and copy `Summary:` and `EXIT:` into specs/217-platform-starting-point/final.txt. Require 0 failed (D3.2)
- [X] T015 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004, T005, and T006 edit the same file and run in order
- T007 edits a different file and can run beside T004 through T006
- T008 follows T004 through T007
- T011 follows T010, because the pins name the new versions
- Phase 7 depends on every story

## Parallel Example

```text
T007 implementation, beside T004 through T006 configuration, after T003
```

## Implementation Strategy

The starting-point line is the MVP the request named. Use entries follow, since both proposals depend on them. New realized capabilities add the handoff and `add capabilities`. Ordered steps hold the form. The suite runs once at the start and once at the end.
