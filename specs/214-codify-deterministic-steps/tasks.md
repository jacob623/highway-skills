---

description: "Task list for codify deterministic steps"
---

# Tasks: Codify Deterministic Steps

**Input**: Design documents from `/specs/214-codify-deterministic-steps/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required by D3.3 and D3.6. One new static test is written and observed failing before any source edit. Pins and moved assertions are in research R8 and R9.

**Organization**: Tasks are grouped by user story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1 through US7)

---

## Phase 1: Setup

- [X] T001 Run `bash .highway/tools/tests/run-all.sh` and copy the `Summary:` and `EXIT:` lines into specs/214-codify-deterministic-steps/baseline.txt. Stop if any test fails (D3.1)

---

## Phase 2: Foundational (failing test)

- [X] T002 Write .highway/tools/tests/codify-deterministic-steps.test.sh (mode 644). It requires the step order `### rank`, `### codified`, `### suggest`, `### draft`, `### provider`, then `### govern`, `### resume`, `### join`, `### folder`. It requires the phrases in contracts/step-matches.md for the named platform, the entry appearing on its own, the file-pattern candidate, the shared-name Control match, one story per proposal task, the story title as the action, the first five gaps, and the line under the story whose title is that action. It rejects `The accepted proposal is not copied.`, `the story it delivers`, and `change the most stories`. It requires `version: 12.0.0` on highway-codify and `version: 2.0.0` on codify-plan.md. It counts `rank`, `suggest`, `draft`, `provider`, `resume`, `join`, and `folder` and fails when any exceeds 250 words, and fails when any `###` section exceeds 400. The PASS line is `PASS: codify matches rows and stories by name`.
- [X] T003 Run the new test, observe it fail, and save its output to specs/214-codify-deterministic-steps/probe-fail.txt (D3.6)

---

## Phase 3: User Story 1 - The plan shows one story per task (Priority: P1) 🎯 MVP

**Goal**: The plan has one story per proposal task, titled with that action

**Independent Test**: `plan` states the story rule. The plan template states the same rule at version 2.0.0. "The accepted proposal is not copied" is absent

- [X] T004 [P] [US1] Update .highway/library/templates/output/codify-plan.md to version 2.0.0 with the story rule in contracts/step-matches.md
- [X] T005 [US1] In `plan` of .highway/skills/highway-codify/SKILL.md, replace the copy sentence and step 1 with the story rule in contracts/step-matches.md

---

## Phase 4: User Story 2 - A catalog row matches the entries that appear (Priority: P1)

**Goal**: A named platform stays. The entry match replaces only the fit test. File patterns and technology still choose standard candidates

**Independent Test**: `provider` keeps a named platform and matches other rows on the action and the method. `standards` drops a candidate only after the file-pattern or technology test

- [X] T006 [US2] Add `### provider` from contracts/step-matches.md to .highway/skills/highway-codify/SKILL.md and point `draft` at it. Keep the not-included and platform-needed lines
- [X] T007 [US2] Replace the fit test in `standards` of .highway/skills/highway-codify/SKILL.md with the candidate and entry-match steps in contracts/step-matches.md. Keep inheritance order

---

## Phase 5: User Story 3 - A Control or NFR matches a shared name (Priority: P1)

**Goal**: A Control or NFR applies only when its statement shares a target, a file, or a mechanism

**Independent Test**: `govern` uses the shared-name test. `layout` adds a match for a placed path and drops none

- [X] T008 [US3] Replace the cover test in `govern` of .highway/skills/highway-codify/SKILL.md with the shared-name test in contracts/step-matches.md
- [X] T009 [US3] At the end of `layout` in .highway/skills/highway-codify/SKILL.md, apply that match to each placed path, add a new match, and drop none

---

## Phase 6: User Story 4 - The check asks the first gaps (Priority: P1)

**Goal**: The person is asked the first five gaps of the three kinds, in order

**Independent Test**: `check` names the three gaps, asks the first five, and records the rest as assumptions. "change the most stories" is absent

- [X] T010 [US4] Replace the question selection in `check` of .highway/skills/highway-codify/SKILL.md with the gap rules in contracts/step-matches.md

---

## Phase 7: User Story 5 - Each task sits under its own story (Priority: P1)

**Goal**: Each proposal task's line sits under the story titled with its action

**Independent Test**: `tasks` places a line by story title. "the story it delivers" is absent

- [X] T011 [US5] Replace the placement sentence in `tasks` of .highway/skills/highway-codify/SKILL.md with the title rule in contracts/step-matches.md

---

## Phase 8: User Story 6 - Each long decision is its own step (Priority: P2)

**Goal**: Ranking, replies, the draft, the Provider, resume, join, and the folder name are separate steps at or under 250 words

**Independent Test**: Those seven steps exist in order, each at or under 250 words, and the old decisions still happen

- [X] T012 [US6] Split `suggest` into `rank` and `suggest` in .highway/skills/highway-codify/SKILL.md per contracts/step-matches.md. `codified` returns to `rank`. The "means" test stays
- [X] T013 [US6] Split `start` into `draft` and `provider` in .highway/skills/highway-codify/SKILL.md. Point Entry and `choose` at `draft` or `rank`
- [X] T014 [US6] Split `project` into `resume`, `join`, and `folder` in .highway/skills/highway-codify/SKILL.md. Point `govern` at `resume`. The "means" tests stay
- [X] T015 [US6] Update the procedure order in .highway/skills/highway-codify/SKILL.md and set `metadata.version` to 12.0.0

---

## Phase 9: User Story 7 - The closing checks do not repeat the steps (Priority: P2)

**Goal**: Verification states a rule only when no step states it

**Independent Test**: A sentence that a step states is absent from Verification. A rule that no step states remains

- [X] T016 [US7] In the Verification section of .highway/skills/highway-codify/SKILL.md, delete each bullet whose rule a step already states. Point any test that required the moved sentence at that step (R9)

---

## Phase 10: Polish

- [X] T017 [P] Move the version pins in research R8 and the assertions in R9 across the tests named there
- [X] T018 Confirm `rank`, `suggest`, `draft`, `provider`, `resume`, `join`, and `folder` are each at or under 250 words, and every `###` section is at or under 400. Confirm those seven steps contain none of should, consider, prefer, usually, or where appropriate
- [X] T019 Run `validate-skill.sh` on highway-codify and `validate-library.sh` on codify-plan.md (D8.1)
- [X] T020 Regenerate with `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`
- [X] T021 Run the full suite and copy `Summary:` and `EXIT:` into specs/214-codify-deterministic-steps/final.txt. Require 0 failed (D3.2)
- [X] T022 Confirm no shipped file references `.specify/` or `specs/`, and mark every task `[X]`

---

## Dependencies & Execution Order

- Phase 1, then T002 and T003, before any source edit
- T004 edits the plan template and can run beside the later skill edits only after T003
- T005 through T016 edit highway-codify, in task order
- T017 follows T016, because the pins and assertions name the new steps and versions
- Phase 10 depends on every story

## Parallel Example

```text
T004 plan template beside the skill edits, after the failing test
T017 version pins beside T018 word counts, after the versions are set
```

## Implementation Strategy

The MVP is US1: the plan shows one story per task. US2, US3, US4, and US5 replace the fit, cover, and placement judgments. US6 splits the long steps that hold those rules. US7 removes the second copy. The suite runs once at the start and once at the end.
