---

description: "Task list for single noun capabilities"
---

# Tasks: Single Noun Capabilities

**Input**: Design documents from `/specs/224-single-noun-capabilities/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Moved pins are in research R6.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/224-single-noun-capabilities/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test and the shared rule)

- [X] T002 Write .highway/tools/tests/single-noun-capabilities.test.sh (mode 644). It requires the lines in contracts/title-rule.md, contracts/onboarding.md, and contracts/codify-rank.md, rejects the replaced text, and requires versions 7.4.0, 10.3.0, 5.1.0, 3.4.0, 12.2.0, capability catalog 2.1.0, and architecture record 2.2.0. The PASS line is `PASS: a capability is one noun phrase of five words or fewer`
- [X] T003 Run the new test, observe it fail, and save its output to specs/224-single-noun-capabilities/probe-fail.txt (D3.6)
- [X] T004 Add the Title rule to .highway/library/templates/output/capability-catalog.md and set its version to 2.1.0 per contracts/title-rule.md
- [X] T005 Add `### capability title` before `### start` in .highway/skills/highway-implementation/SKILL.md per contracts/title-rule.md

---

## Phase 3: User Story 1 - Onboarding proposes one capability per item (Priority: P1) 🎯 MVP

**Goal**: Two activities on one technology are two capabilities, and a joined edit is split with the compounding explanation

**Independent Test**: The onboarding `capabilities` lines in the new test pass, and the merge sentence is absent

- [X] T006 [US1] In .highway/skills/highway-onboarding/SKILL.md `capabilities`, replace the merge sentence, follow `capability title`, and route `edit` through it per contracts/onboarding.md

---

## Phase 4: User Story 2 - The static capability is AI-Augmented Technology Development (Priority: P1)

**Goal**: The static capability is renamed everywhere it appears

**Independent Test**: `AI-Augmented Technology Development` is present and `AI-Assisted Engineering and Planning` is absent in the onboarding skill

- [X] T007 [US2] Rename every `AI-Assisted Engineering and Planning` to `AI-Augmented Technology Development` in .highway/skills/highway-onboarding/SKILL.md and add the verification line per contracts/onboarding.md
- [X] T008 [P] [US2] Rename the static capability strings in .highway/tools/tests/static-highway-capability.test.sh (R6)

---

## Phase 5: User Story 3 - Implementations and architectures store one capability per entry (Priority: P1)

**Goal**: The implementation proposal, record, catalog, and architecture required capabilities follow the Title rule

**Independent Test**: The implementation and architecture lines in the new test pass

- [X] T009 [US3] In .highway/skills/highway-implementation/SKILL.md, call `capability title` from `start` and its `edit`, and cite the Title rule in `write` and the verification list per contracts/title-rule.md
- [X] T010 [P] [US3] In .highway/skills/highway-architecture/SKILL.md, add the two inputs, follow `capability title` from `start` and its `edit`, and cite the Title rule in `write` and verification per contracts/title-rule.md
- [X] T011 [P] [US3] Change the Capability placeholder in .highway/library/templates/output/architecture-record.md and set its version to 2.2.0

---

## Phase 6: User Story 4 - Configuration records new capabilities with the same shape (Priority: P2)

**Goal**: New realized capabilities are titled under the rule and a title that breaks it is left out

**Independent Test**: `current` step 5 and `add capabilities` step 4 lines in the new test pass

- [X] T012 [P] [US4] In .highway/skills/highway-codify-config/SKILL.md, add the input, rewrite `current` step 5, and update its verification line per contracts/title-rule.md
- [X] T013 [US4] In .highway/skills/highway-implementation/SKILL.md `add capabilities`, rewrite step 4 per contracts/title-rule.md

---

## Phase 7: User Story 5 - Codify suggestions no longer read establish from a capability title (Priority: P2)

**Goal**: Establish comes from the implementation title, and each capability gives one suggestion

**Independent Test**: The `rank` lines in the new test pass, the capability-title check is absent, and the `provider` check remains

- [X] T014 [P] [US5] Rewrite `rank` and its verification line in .highway/skills/highway-codify/SKILL.md per contracts/codify-rank.md

---

## Phase 8: Polish

- [X] T015 Set versions to 7.4.0, 10.3.0, 5.1.0, 3.4.0, and 12.2.0 in the five SKILL.md files
- [X] T016 Move the pins listed in specs/224-single-noun-capabilities/research.md R6
- [X] T017 Run the word count and `validate-skill.sh` on the five skills
- [X] T018 Regenerate with `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`
- [X] T019 Run the full suite and copy `Summary:` and `EXIT:` into specs/224-single-noun-capabilities/final.txt. Require 0 failed (D3.2)
- [X] T020 Confirm no shipped file of this change references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 and T005 come before every story, since each story cites the rule or the step
- T006 and T007 edit `highway-onboarding` in that order
- T009 and T013 edit `highway-implementation` in that order, after T005
- T010, T011, T012, and T014 edit different files and can run beside each other
- T015 through T020 follow every story

## Parallel Example

```text
T008 static test, T010 architecture skill, T011 architecture template, T012 config skill, T014 codify skill
```

## Implementation Strategy

MVP is User Story 1 with the shared rule from Phase 2: onboarding stops proposing joined capabilities. User Stories 2 and 3 complete the stored shape. User Stories 4 and 5 follow the same suite run. No migration.
