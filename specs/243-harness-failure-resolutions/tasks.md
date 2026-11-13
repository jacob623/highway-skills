# Tasks: Harness Failure Resolutions

**Input**: Design documents from `specs/243-harness-failure-resolutions/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required. FR-020 needs each assertion observed failing before its change (D3.6).

**Rule**: Edit skill source under `skills/` only. The agent trees are regenerated in Phase 8.

## Phase 1: Setup

- [X] T001 Add the line `specs/243-harness-failure-resolutions/harness/*` to `.gitignore`, next to spec 242's line (FR-025)

## Phase 2: Foundational

- [X] T002 Create `tests/harness-failure-resolutions.test.sh` with the header (instrument class, artifact classes, seeded failure probe), the `require_in`, `reject_in`, and `section` helpers over `fl_skill_text_file`, and a final PASS line. Later tasks add its assertions.

**Checkpoint**: The new test runs and passes with no assertions.

## Phase 3: User Story 1, title selection and pasted material (P1)

**Goal**: F1 and F2. **Independent test**: the US1 assertions in the new test.

- [X] T003 [US1] Add assertions for the four F1 `Entry` lines and the F2 `offer` and Verification lines from `contracts/skill-text.md`, and reject the old "Retrieval is unavailable" bullet, in `tests/harness-failure-resolutions.test.sh`. Run it and record the failures.
- [X] T004 [P] [US1] Rewrite `Entry` step 1 in `skills/highway-adr/SKILL.md` and bump to 6.7.0
- [X] T005 [P] [US1] Rewrite `Entry` step 1 in `skills/highway-architecture/SKILL.md` and bump to 5.8.0
- [X] T006 [P] [US1] Rewrite `Entry` step 1 in `skills/highway-discovery/SKILL.md` and bump to 5.7.0
- [X] T007 [P] [US1] Rewrite `Entry` step 3 in `skills/highway-implementation/SKILL.md` (the bump is T019)
- [X] T008 [P] [US1] Rewrite `offer` and its Verification bullet in `skills/highway-profile/SKILL.md` and bump to 14.5.0
- [X] T009 [US1] Run the new test. The US1 assertions pass.

## Phase 4: User Story 2, storage contract and governance reads (P1)

**Goal**: F6, F10, and F12. **Independent test**: the US2 assertions and `tests/storage-contract.test.sh`.

- [X] T010 [US2] Add assertions for storage contract `1.2.0`, its exact-path and folder lines, its two new "does not do" items, highway-experience version `1.2.0`, and the three governance `Entry` step 1 lines. Run them and record the failures.
- [X] T011 [US2] Update `skills/highway-experience/references/storage-contract.md` to `1.2.0`, and `skills/highway-experience/SKILL.md` `metadata.version` to `1.2.0`
- [X] T012 [P] [US2] Rewrite `Entry` step 1 in `skills/highway-objectives/SKILL.md` (the bump is T017)
- [X] T013 [P] [US2] Rewrite `Entry` step 1 in `skills/highway-controls/SKILL.md` (the bump is T017)
- [X] T014 [P] [US2] Rewrite `Entry` step 1 in `skills/highway-nfrs/SKILL.md` (the bump is T017)
- [X] T015 [US2] Run the new test and `tests/storage-contract.test.sh`. Both pass.

## Phase 5: User Story 3, skill fixes for F4, F5, and F9 (P1)

**Goal**: onboarding, codify, the governance `queue`, and highway-implementation.
**Independent test**: the US3 assertions and `tests/code-project.test.sh`.

- [X] T016 [US3] Add assertions for the governance `queue` questions (and reject the empty-queue question in `### queue`), onboarding `map` (GitHub Copilot, the new `unknown` and provider question, and reject the old `unknown`), codify `check` step 5, `Classify the reply:` before each of the six implementation reply lists, implementation `field` steps 2 and 3, and the `start` `accept`. Amend `tests/code-project.test.sh` to pin the full rule-2 line. Run both and record the failures.
- [X] T017 [P] [US3] Change the `### queue` question in `skills/highway-objectives/references/proposal.md`, `skills/highway-controls/references/proposal.md`, and `skills/highway-nfrs/references/proposal.md`. Bump objectives to 8.7.0, controls to 8.7.0, and nfrs to 9.8.0.
- [X] T018 [P] [US3] Update `map` in `skills/highway-onboarding/references/proposal.md` and bump `skills/highway-onboarding/SKILL.md` to 10.13.0
- [X] T019 [P] [US3] Add `Classify the reply:` lines, split `field` steps 2 and 3, and rewrite the `start` `accept` across `skills/highway-implementation/SKILL.md` and `skills/highway-implementation/references/{proposal,record,amend}.md`. Bump to 7.16.0.
- [X] T020 [P] [US3] Update `check` step 5 in `skills/highway-codify/references/record.md` and `record check` rule 2 in `skills/highway-codify/SKILL.md`. Bump to 14.8.0.
- [X] T021 [US3] Run the new test, `tests/code-project.test.sh`, and `tests/skill-flow-pattern.test.sh`. All pass.
- [X] T022 [US3] Record the F5 per-scenario diagnosis (research R7) under F5 in `harness-model-findings.md` (FR-009)

## Phase 6: User Story 4, harness (P2)

**Goal**: F8, F11, and F13. **Independent test**: the harness unit tests.

- [X] T023 [US4] Add unit tests in `harness/test/failure.test.ts` (`service-error` kind and cause, `classifyError` on -32603, `retryServiceError` retrying once and rethrowing otherwise), `harness/test/checks.test.ts` (`shows` ignores emphasis; `isExperienceSkillRead`), and `harness/test/runner.test.ts` (an attempt failing only with `service-error` is `blocked`). Run them and record the failures.
- [X] T024 [US4] Implement `service-error`, its cause, the pattern, and `retryServiceError` in `harness/src/failure.ts`
- [X] T025 [US4] Implement emphasis stripping in `showsFailures` and `isExperienceSkillRead` in `harness/src/checks.ts`
- [X] T026 [US4] In `harness/src/driver.ts`, wrap `sendAndWait` with `retryServiceError`, and count an approved read of the experience `SKILL.md` before output as activation
- [X] T027 [US4] In `harness/src/runner.ts`, return `blocked` when the last attempt's failures are all `service-error`
- [X] T028 [US4] Update `harness/README.md`: the `service-error` kind row, and the `shows` row's emphasis note (D3.5)
- [X] T029 [US4] Run `node --test "test/*.test.ts"` and `tsc -p tsconfig.json` in `harness/`. Both pass.

## Phase 7: User Story 5, scenario scripts (P2)

**Goal**: scripts match the skills (`contracts/scenario-scripts.md`). **Independent test**:
`tests/harness-scenarios.test.sh` and `tests/harness-coverage.test.sh`.

- [X] T030 [P] [US5] Update `harness/scenarios/highway-profile/profile-smoke.scenario`, `harness/scenarios/highway-setup/setup-smoke.scenario`, and `harness/scenarios/highway-setup/chain-setup.scenario`
- [X] T031 [P] [US5] Update `harness/scenarios/highway-codify-config/codify-config-smoke.scenario`
- [X] T032 [P] [US5] Update `harness/scenarios/highway-onboarding/onboarding-smoke.scenario`, `harness/scenarios/highway-implementation/chain-implementation.scenario`, and `harness/scenarios/highway-implementation/implementation-onboards-platform.scenario`
- [X] T033 [P] [US5] Update `harness/scenarios/highway-implementation/implementation-smoke.scenario`, `harness/scenarios/highway-codify/codify-needed-language.scenario`, and `harness/scenarios/highway-codify/codify-platform-no-row.scenario`
- [X] T034 [P] [US5] Update `harness/scenarios/highway-discovery/discovery-smoke.scenario`, `harness/scenarios/highway-discovery/chain-discovery.scenario`, and `harness/scenarios/highway-architecture/chain-architecture.scenario`
- [X] T035 [US5] Run `tests/harness-scenarios.test.sh`, `tests/harness-coverage.test.sh`, and `tests/harness-fixtures.test.sh`. All pass.

## Phase 8: Polish and final runs

- [X] T036 Regenerate with `framework/generate-catalog.sh` and `framework/generate-agent-adapters.sh`. Run them again and confirm no change.
- [X] T037 Validate each changed skill, then run `bash tests/run-all.sh` (86 tests) and the harness unit tests and `tsc`. All pass.
- [X] T038 Final live runs on `--model gpt-5.6-luna`: `--smoke`, `--changed-since main`, and request-setup-needed and chain-request if left out (`contracts/final-run-evidence.md`)
- [X] T039 Copy each final run to `specs/243-harness-failure-resolutions/harness/{smoke,changed,extra}/`. Confirm `git check-ignore`, no `git status` entry under it, and 0 token matches.
- [X] T040 Update `harness-model-findings.md`: the resolution and confirming run for each in-scope finding (FR-026), and new findings for unexplained failures (FR-027). Leave F3, F7, and F15 unchanged.
- [X] T041 Mark all tasks `[X]`. Do not commit.

## Dependencies

- Phase 2 comes before every story. US1, US2, and US3 all edit the new test file, so run them in
  order: US1, then US2, then US3. Their skill edits within a story are parallel.
- T007 and T019 both edit highway-implementation; T019 owns the bump. T012–T014 and T017 edit the
  same governance skills; T017 owns the bumps.
- US4 is independent of US1 to US3. US5 depends on US1 to US3, because scripts follow the new
  text.
- Phase 8 comes last. T038 follows T036 and T037. T040 follows T038.

## Parallel examples

- US1: T004, T005, T006, T007, and T008 edit different files.
- US3: T017, T018, T019, and T020.
- US5: T030 to T034.
- US4 can run beside US5.

## Implementation strategy

MVP is US1 plus US2, which remove most false starts and false setup messages. Then US3, US4, and
US5, then one regeneration and one set of final runs.
