---

description: "Task list for codify feature wording, governance, and plan"
---

# Tasks: Codify Feature Wording, Governance, and Plan

**Input**: Design documents from `/specs/213-codify-feature-wording/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Pins move with D3.5 reasons in research R7.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US6)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` in the background with all permissions, wait for it, and copy the `Summary:` and `EXIT:` lines into specs/213-codify-feature-wording/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/codify-feature-wording.test.sh (mode 644, static-document-contract header, PASS line `PASS: codify plans the feature before coding`). It reads .highway/skills/highway-codify/SKILL.md and the templates codify-record.md, codify-tasks.md, and codify-plan.md. It requires the step order `### align`, `### govern`, `### project`, then `### index`, `### plan`, `### check`, `### menu`, `### tasks`, `### code`. It requires the phrases in contracts/feature-steps.md: the codify feature heading, `Highway will use this specification to build out the solution.`, `**Controls and NFRs:**`, `**Conflicts:**`, `No Control or NFR applies.`, `library/governance/controls.md`, `library/governance/nfrs.md`, `apply the Control`, `stays in effect`, `The plan is complete for feature <number>-<action>.`, `1. Review the plan?`, `2. Continue to code the solution?`, the building sentence, and the new Code Catalog sentence. It rejects `for your automation:**` and `just ask highway to show your code catalog`. It requires codify `version: 11.0.0`, record `version: 9.0.0`, tasks `version: 6.0.0`, and plan `version: 1.0.0`. It counts every `###` section of highway-codify and fails when any exceeds 400 words. It rejects should, consider, prefer, usually, and where appropriate inside the five new steps.
- [X] T003 Run the new test, observe it fail, and save its output to specs/213-codify-feature-wording/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - The proposal says what it is for (Priority: P1) 🎯 MVP

**Goal**: The proposal is a codify feature and ends with the specification sentence

**Independent Test**: `propose` shows the new heading, and the specification sentence follows `If this is accurate, just say so.`

- [X] T004 [US1] In .highway/skills/highway-codify/SKILL.md, change the `propose` heading to `**Here is a proposed starting point for your codify feature:**` and add `Highway will use this specification to build out the solution.` after `If this is accurate, just say so.`

---

## Phase 4: User Story 2 - Acceptance says building has started (Priority: P1)

**Goal**: The building sentence appears once when the person continues

**Independent Test**: `tasks` emits the building sentence once, before the task list is written, and not on retry

- [X] T005 [US2] Covered by T016: the `tasks` step opens with the building sentence and says not to emit it again after a failed write

---

## Phase 5: User Story 3 - The close says how to come back (Priority: P2)

**Goal**: The completion message points to the Code Catalog

**Independent Test**: Under **Questions?** is the new sentence. The two old sentences are absent

- [X] T006 [US3] In `close` of .highway/skills/highway-codify/SKILL.md, replace the two sentences under **Questions?** with the sentence in contracts/feature-steps.md

---

## Phase 6: User Story 4 - Every solution abides by Controls and NFRs (Priority: P1)

**Goal**: Controls and NFRs correct the draft, are listed and saved, refuse a breaking edit, and are read during coding

**Independent Test**: `govern` sits between `align` and `project`. `propose` lists Controls and NFRs and any Conflicts. `revise` refuses a breaking edit. `code` reads each listed active one

- [X] T007 [US4] Add `### govern` from contracts/feature-steps.md to .highway/skills/highway-codify/SKILL.md after `align`. Route `align` to `govern`. Add the Controls and NFRs catalogs to Inputs
- [X] T008 [US4] Add **Controls and NFRs:** and **Conflicts:** to `propose` before **Proposed project:**, and the refusal line to `revise`, in .highway/skills/highway-codify/SKILL.md
- [X] T009 [P] [US4] Update .highway/library/templates/output/codify-record.md to version 9.0.0 with **Controls and NFRs:** and **Conflicts:** after Tasks
- [X] T010 [US4] In `write` of .highway/skills/highway-codify/SKILL.md, save Controls and NFRs and Conflicts after Tasks. In `code`, read each listed Control and NFR whose row is active before writing a task's files, and skip a removed one

---

## Phase 7: User Story 5 - A plan breaks the work out before coding (Priority: P1)

**Goal**: Acceptance writes the plan, the check asks only necessary questions, the menu offers review or continue, and continue writes the task list

**Independent Test**: `write` does not write `codify-tasks.md`. `index` goes to `plan`. `plan`, `check`, `menu`, and `tasks` follow. Entry and `project` resume a feature with no task list at `menu`

- [X] T011 [P] [US5] Create .highway/library/templates/output/codify-plan.md version 1.0.0 with Stories, Edge cases, Functional requirements, and Decisions, plus conditional Data and Interface, per data-model.md Feature plan
- [X] T012 [P] [US5] Update .highway/library/templates/output/codify-tasks.md to version 6.0.0: lines grouped under a story heading with its independent test; executor lines first and the README last; line shape unchanged
- [X] T013 [US5] In .highway/skills/highway-codify/SKILL.md, make `write` say `codify-tasks.md` is not written there. In `index`, treat a feature with no task list as open and go to `plan` on success
- [X] T014 [US5] Add `### plan`, `### check`, and `### menu` from contracts/feature-steps.md after `index` in .highway/skills/highway-codify/SKILL.md
- [X] T015 [US5] Route Entry step 5 and `project` step 2 to `menu` when the open feature has a plan and no task list. Keep `project` at or under 400 words. Update the `catalog` progress line for a feature with no task list
- [X] T016 [US5] Add `### tasks` from contracts/feature-steps.md after `menu` in .highway/skills/highway-codify/SKILL.md. Update Outputs, the order sentence, Inputs, Verification, and Error Handling. Set `metadata.version` to 11.0.0

---

## Phase 8: User Story 6 - The new instructions stay deterministic (Priority: P1)

**Goal**: Every new or changed step is a numbered instruction under 400 words

**Independent Test**: The word count and the banned-word check in the new test pass

- [X] T017 [US6] Run the word count from plan.md on .highway/skills/highway-codify/SKILL.md, confirm every `###` section is at or under 400 words, and confirm the five new steps contain none of should, consider, prefer, usually, or where appropriate

---

## Phase 9: Polish

- [X] T018 [P] Move the pins in research R7 across codify-file-layout, codify-config-skill, codify-platform-catalog, codify-closing-guide, codify-write-refactor, propose-edit-lines, codify-products, and highway-codify under .highway/tools/tests/. Keep the onboarding pin in codify-platform-catalog.test.sh
- [X] T019 Run `validate-skill.sh` on highway-codify, and `validate-library.sh` on codify-record.md, codify-tasks.md, and codify-plan.md (D8.1)
- [X] T020 Regenerate with `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`
- [X] T021 Run the full suite in the background, copy `Summary:` and `EXIT:` into specs/213-codify-feature-wording/final.txt, and require 0 failed (D3.2)
- [X] T022 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T009, T011, and T012 edit separate templates and can run together
- T004, T006, T007, T008, T010, T013 through T016 edit highway-codify, in task order
- T018 follows T016, because the pins name the new versions
- Phase 9 depends on every story

## Parallel Example

```text
T009 record, T011 plan template, T012 task template
T018 version pins beside T019 validation, after the versions are set
```

## Implementation Strategy

The MVP is US1: the proposal reads as a codify feature. US4 adds Controls and NFRs before the proposal. US5 adds the plan, the check, the menu, and the task list on continue, which also places the US2 sentence. US3 changes the close. US6 is verified by the word count. The suite runs once at the start and once at the end.
