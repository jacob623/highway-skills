---

description: "Task list for NFR safeguard coverage"
---

# Tasks: NFR Safeguard Coverage

**Input**: Design documents from `/specs/226-nfr-safeguard-coverage/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. The moved pin is in research R4.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/226-nfr-safeguard-coverage/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/nfr-safeguard-rationale.test.sh (mode 644). It requires every new line in contracts/wording.md, requires `   **Why it matters:** [Rationale]` at least 4 times, rejects every replaced line, and requires `version: 9.1.0`. The PASS line is `PASS: every safeguard gets an operational expectation that names it`
- [X] T003 Run the new test, observe it fail, and save its output to specs/226-nfr-safeguard-coverage/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - Every safeguard has an operational expectation (Priority: P1) 🎯 MVP

**Goal**: A shown, unselected recommendation no longer covers its safeguard, so later sets offer it again

**Independent Test**: The coverage lines in the new test pass, and the replaced rule 1 and rule 5 lines are absent

- [X] T004 [US1] In .highway/skills/highway-nfrs/SKILL.md, replace `recommend` rules 1 and 5 and add the `more` sentence per contracts/wording.md

---

## Phase 4: User Story 2 - A safeguard-based rationale names the safeguard (Priority: P1)

**Goal**: Every recommendation shows **Why it matters:**, and a Control-derived rationale opens with **Enforces your Safeguard**

**Independent Test**: The rationale lines in the new test pass, and the replaced set, capture, and write lines are absent

- [X] T005 [US2] In .highway/skills/highway-nfrs/SKILL.md, replace the two set lines, add the rationale paragraph, and add the **Why it matters:** line to the three set templates per contracts/wording.md
- [X] T006 [US2] In .highway/skills/highway-nfrs/SKILL.md, replace the `capture` rationale line, add the `review` edit sentence, and replace the `write` `controls` line per contracts/wording.md
- [X] T007 [US2] In .highway/skills/highway-nfrs/SKILL.md, add the four verification lines per contracts/wording.md

---

## Phase 5: Polish

- [X] T008 Set `version: 9.1.0` in .highway/skills/highway-nfrs/SKILL.md
- [X] T009 Move the pin listed in specs/226-nfr-safeguard-coverage/research.md R4 in .highway/tools/tests/guided-flow-refinements.test.sh
- [X] T010 Run `validate-skill.sh` on .highway/skills/highway-nfrs and the quickstart checks
- [X] T011 Regenerate with `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`
- [X] T012 Run the full suite and copy `Summary:` and `EXIT:` into specs/226-nfr-safeguard-coverage/final.txt. Require 0 failed (D3.2)
- [X] T013 Confirm no shipped file of this change references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 through T007 edit the same file and run in order
- T008 through T013 follow every story

## Parallel Example

```text
T009 test pin move can run beside T004 through T008
```

## Implementation Strategy

MVP is User Story 1: an uncovered safeguard keeps being offered. User Story 2 adds the named rationale and lands in the same suite run.
