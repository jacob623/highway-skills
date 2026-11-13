# Tasks: Harness Failure Follow-ups

**Input**: Design documents from `specs/244-harness-failure-followups/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required. FR-014 needs each assertion observed failing before its change (D3.6).

**Rule**: Edit skill source under `skills/` only. The agent trees are regenerated in Phase 8.

## Phase 1: Setup

- [X] T001 Add the line `specs/244-harness-failure-followups/harness/*` to `.gitignore`, next to spec 243's line (FR-019)

## Phase 2: Foundational

- [X] T002 Create `tests/harness-failure-followups.test.sh` with the header (instrument class, artifact classes, seeded failure probe), the `require_in`, `reject_in`, `require_file`, and `version_is` helpers over `fl_skill_text_file`, and a final PASS line. Later tasks add its assertions.

**Checkpoint**: The new test runs and passes with no assertions.

## Phase 3: User Story 1, a finished review ends with a reply (P1)

**Goal**: F7. **Independent test**: the US1 assertions, and `tests/configure-handoff.test.sh`.

- [X] T003 [US1] Add assertions for the governance `close` step, the order sentence, `review` `accept`, the Outputs and Verification lines, `ask` `decline`, `write` success and its Verification line, and the rejected lines from `contracts/skill-text.md`, for all three governance skills, with versions. Add the codify-config `menu` `decline` line and version 3.12.0. Amend `tests/configure-handoff.test.sh` to pin the new `decline` line. Run both and record the failures.
- [X] T004 [P] [US1] Add `close` and update `skills/highway-objectives/SKILL.md`, `references/proposal.md`, and `references/record.md`. Bump to 8.8.0.
- [X] T005 [P] [US1] Add `close` and update `skills/highway-controls/SKILL.md`, `references/proposal.md`, and `references/record.md`. Bump to 8.8.0.
- [X] T006 [P] [US1] Add `close` and update `skills/highway-nfrs/SKILL.md`, `references/proposal.md`, and `references/record.md`. Bump to 9.9.0.
- [X] T007 [P] [US1] Update the `menu` `decline` in `skills/highway-codify-config/SKILL.md`. Bump to 3.12.0.
- [X] T008 [US1] Run the new test, `tests/configure-handoff.test.sh`, and `tests/skill-flow-pattern.test.sh`. All pass.

## Phase 4: User Story 2, records keep every template section (P1)

**Goal**: F18. **Independent test**: the US2 assertions.

- [X] T009 [US2] Add assertions for the two write-step lines and the highway-adr `onboarding` line, and reject the old onboarding line, with versions discovery 5.8.0 and adr 6.8.0. Run and record the failures.
- [X] T010 [P] [US2] Add the write-step line in `skills/highway-discovery/references/options.md`. Bump `skills/highway-discovery/SKILL.md` to 5.8.0.
- [X] T011 [P] [US2] Add the write-step line in `skills/highway-adr/references/record.md`, and replace the `onboarding` bullet in `skills/highway-adr/SKILL.md`. Bump to 6.8.0.
- [X] T012 [US2] Run the new test. The US2 assertions pass.

## Phase 5: User Story 3, highway-codify edges (P2)

**Goal**: F15 and F5. **Independent test**: the US3 assertions, `tests/codify-feature-wording.test.sh`, and `tests/codify-closing-guide.test.sh`.

- [X] T013 [US3] Add assertions for the refusal line and `Entry` step 2, with version 14.9.0. Run and record the failures.
- [X] T014 [US3] Update the refusal line in `skills/highway-codify/references/proposal.md` and `Entry` step 2 in `skills/highway-codify/SKILL.md`. Bump to 14.9.0.
- [X] T015 [US3] Run the new test, `tests/codify-feature-wording.test.sh`, and `tests/codify-closing-guide.test.sh`. All pass.

## Phase 6: User Story 5, harness (P2)

**Goal**: F3 (fallback, `repeated-question`), F17, and F16 (`contains-any`). **Independent test**: the harness unit tests. It comes before US4, because the scripts use `contains-any`.

- [X] T016 [US5] Add unit tests from `contracts/harness-behavior.md`:
  - `harness/test/replies.test.ts`: `nextUnused`, the fallback offering only the earliest unused reply, `spentReply`, and `textAfterAnswers`.
  - `harness/test/checks.test.ts`: `contains-any` passes on one file and fails on none, and `contains` still needs every file.
  - `harness/test/scenario.test.ts`: `contains-any` parses and needs an argument.
  - `harness/test/failure.test.ts`: `repeated-question` has a cause.
  - `harness/test/runner.test.ts`: a `repeated-question` outcome is reported with its kind, question, and reply.

  Add `contains-any` to `ASSERTIONS` in `tests/harness-scenarios.test.sh`. Run them and record the failures.
- [X] T017 [US5] Implement `nextUnused`, `spentReply`, and `textAfterAnswers`, and use `nextUnused` in `decide`, in `harness/src/replies.ts`
- [X] T018 [US5] Add `repeated-question` and its cause in `harness/src/failure.ts`. Add `contains-any` to `ASSERTIONS` in `harness/src/scenario.ts`, and to `runExpectation` in `harness/src/checks.ts`.
- [X] T019 [US5] In `harness/src/driver.ts`: the in-turn fallback uses `nextUnused`; record each answered question; return `repeated-question` with `respent`; track `answeredAt`, and judge the end of a turn with `textAfterAnswers`
- [X] T020 [US5] In `harness/src/runner.ts`, report the `repeated-question` outcome
- [X] T021 [US5] Update `harness/README.md`: the `contains-any` row, the `repeated-question` row, and the fallback and end-of-turn sentence
- [X] T022 [US5] Run `node --test "test/*.test.ts"` and `tsc -p tsconfig.json` in `harness/`, and `tests/harness-scenarios.test.sh`. All pass.

## Phase 7: User Story 4, every reply answers its question (P2)

**Goal**: F3, F16, F21, and F5 scripts (`contracts/scenario-scripts.md`). **Independent test**: the US4 assertions, `tests/harness-scenarios.test.sh`, and `tests/harness-coverage.test.sh`.

- [X] T023 [US4] Add assertions to the new test: no catch-all key in any `.scenario` file; the governance smokes use `contains-any` and the closing `shows:`; the three onboarding scripts hold the `Unknown` provider replies; codify-configure's opening and `shows:`. Run and record the failures.
- [X] T024 [P] [US4] Update `harness/scenarios/highway-adr/adr-smoke.scenario`, `harness/scenarios/highway-architecture/architecture-smoke.scenario`, `harness/scenarios/highway-assessment/assessment-smoke.scenario`, `harness/scenarios/highway-request/chain-request.scenario`, and `harness/scenarios/highway-request/request-smoke.scenario`
- [X] T025 [P] [US4] Update `harness/scenarios/highway-codify/codify-control-unmet.scenario`, `harness/scenarios/highway-codify/codify-standard-unmet.scenario`, and `harness/scenarios/highway-codify/codify-configure.scenario`
- [X] T026 [P] [US4] Update `harness/scenarios/highway-controls/controls-smoke.scenario`, `harness/scenarios/highway-nfrs/nfrs-smoke.scenario`, and `harness/scenarios/highway-objectives/objectives-smoke.scenario`
- [X] T027 [P] [US4] Update `harness/scenarios/highway-onboarding/onboarding-smoke.scenario`, `harness/scenarios/highway-implementation/chain-implementation.scenario`, and `harness/scenarios/highway-implementation/implementation-onboards-platform.scenario`
- [X] T028 [US4] Run the new test, `tests/harness-scenarios.test.sh`, `tests/harness-coverage.test.sh`, and `tests/harness-fixtures.test.sh`. All pass.

## Phase 8: Polish, final run, and findings (US6)

- [X] T029 Regenerate with `framework/generate-catalog.sh` and `framework/generate-agent-adapters.sh`. Run them again and confirm no change.
- [X] T030 Validate each changed skill, then run `bash tests/run-all.sh` (87 tests), the harness unit tests, and `tsc`. All pass.
- [X] T031 Run the final live run on `--model gpt-5.6-luna`, with `--changed-since 42a0569` and `--paths` for the spec 243 failures (`contracts/final-run-evidence.md`)
- [X] T032 Confirm the capture in `specs/244-harness-failure-followups/harness/final/`: `git check-ignore`, no `git status` entry under it, and 0 token matches
- [X] T033 [US6] Build the comparison table against spec 243's final runs, and attribute every failing attempt to a finding
- [X] T034 [US6] Update `harness-model-findings.md` per FR-020: remove resolved findings and name them, update open ones and their Proposed resolution, add new findings to the right section, note research findings not seen, correct F3's list to 10, and add a "Final runs for spec 244" section
- [X] T035 Mark all tasks `[X]`. Do not commit.

## Dependencies

- Phase 2 comes before every story. Every story adds to the new test file, so run their assertion
  tasks in order. Within a story, the skill or script edits marked [P] are parallel.
- US5 comes before US4: the scripts use `contains-any`, which the scenario parser and
  `harness-scenarios.test.sh` must accept first.
- US1, US2, and US3 are independent of each other and of US5.
- Phase 8 comes last. T031 follows T029 and T030. T033 and T034 follow T031.

## Parallel examples

- US1: T004, T005, T006, and T007 edit different skills.
- US2: T010 and T011.
- US4: T024 to T027.
- US5 can run beside US1 to US3.

## Implementation strategy

The MVP is US1 plus US2. They remove the most frequent failures in spec 243's final runs: the
empty turn behind every -32603, and dropped template sections. Then US3, US5, and US4, then one
regeneration and one final run, then the findings.
