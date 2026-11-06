---

description: "Task list for onboarding technology capabilities"
---

# Tasks: Onboarding Technology Capabilities

**Input**: Design documents from `/specs/215-onboarding-technology-capabilities/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. The moved pin and assertions are in research R4.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/215-onboarding-technology-capabilities/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/onboarding-technology-capabilities.test.sh (mode 644). It requires the overview heading instruction, the heading line, and the new bullet from contracts/onboarding-capabilities.md. It requires the four `capabilities` sentences, "Do not include a provider.", and the new placeholder in `capabilities` and `map`. It rejects the four lines listed in the contract. It requires `version: 10.0.0`. The PASS line is `PASS: onboarding proposes technology capabilities`
- [X] T003 Run the new test, observe it fail, and save its output to specs/215-onboarding-technology-capabilities/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - The starting point lists technology capabilities (Priority: P1) 🎯 MVP

**Goal**: Each proposed capability names what a technology does

**Independent Test**: `capabilities` states the four rule sentences. Both placeholders read `[What the technology does for the organization.]`

- [X] T004 [US1] In `capabilities` of .highway/skills/highway-onboarding/SKILL.md, add the four sentences from contracts/onboarding-capabilities.md after "Do not ask the person to invent the list." and replace "Include a capability when that context supports it."
- [X] T005 [US1] Replace `[What the organization does.]` with `[What the technology does for the organization.]` in `capabilities` and `map` of .highway/skills/highway-onboarding/SKILL.md

---

## Phase 4: User Story 2 - The overview opens with the new heading (Priority: P2)

**Goal**: The overview opens with the new heading and names technology capabilities

**Independent Test**: The heading instruction and line are new. The removed sentence is absent. The first bullet names technology capabilities

- [X] T006 [US2] In `overview` of .highway/skills/highway-onboarding/SKILL.md, replace the heading instruction and the heading line, remove the sentence after it, and replace the first bullet per contracts/onboarding-capabilities.md

---

## Phase 5: Polish

- [X] T007 Update Verification in .highway/skills/highway-onboarding/SKILL.md per the contract, and set `metadata.version` to 10.0.0
- [X] T008 [P] Move the pin and assertions in research R4 across .highway/tools/tests/codify-platform-catalog.test.sh and .highway/tools/tests/onboarding-assessment-guidance.test.sh
- [X] T009 Confirm `capabilities` is at or under 400 words and the new sentences contain none of should, consider, prefer, usually, or where appropriate
- [X] T010 Run `validate-skill.sh` on highway-onboarding (D8.1)
- [X] T011 Regenerate with `generate-catalog.sh` and `generate-agent-adapters.sh`
- [X] T012 Run the full suite and copy `Summary:` and `EXIT:` into specs/215-onboarding-technology-capabilities/final.txt. Require 0 failed (D3.2)
- [X] T013 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 through T007 edit highway-onboarding, in task order
- T008 follows T007, because the pins name the new text and version
- Phase 5 depends on both stories

## Parallel Example

```text
T008 test pins beside T009 word count, after T007
```

## Implementation Strategy

The MVP is US1: the capability rule. US2 changes the overview wording. The suite runs once at the start and once at the end.
