---

description: "Task list for Multi-Agent Harness Groundwork (rollout Phase 5)"
---

# Tasks: Multi-Agent Harness Groundwork

**Input**: Design documents from `specs/247-multi-agent-harness-groundwork/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required. FR-030, FR-031, and Development Constitution D3.3, D3.5, and D3.6 make tests
part of the work. Each new test is observed failing before the code that makes it pass. Each
replaced assertion names what supersedes it.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run the baseline `bash tests/run-all.sh` and `npm --prefix harness test` before the first code edit (D3.1); record the totals in Notes.

## Phase 2: Foundational (blocks every story)

- [X] T002 Move the Copilot code out of `harness/src/driver.ts` into `harness/src/drivers/copilot.ts`: `copilotDriver`, the plugin RPC use, `usageFrom`, and `skillName` stay with it. Move `copilotAsk` from `harness/src/judge.ts`, `sdkVersions` from `harness/src/runner.ts`, and `classifyError` from `harness/src/failure.ts` (as `classifyCopilotError`), each unchanged.
- [X] T003 In `harness/src/driver.ts`, add `AccessRequest` and `AccessDecision` (data-model.md), and change `permissionPolicy` to take an `AccessRequest` and return an `AccessDecision` with identical summaries, rejections, and feedback (research R3). Add `toAccessRequest` and `toPermissionResult` to `harness/src/drivers/copilot.ts`.
- [X] T004 In `harness/src/driver.ts` and `harness/src/failure.ts`, make `withRateLimit` and `retryServiceError` take a classifier argument; rename `DriveOptions.copilotHome` to `agentHome` and `token` to `key`, and add `readRoots`.
- [X] T005 Create `harness/src/agents.ts` with the `Agent` type, `AGENTS` holding the `copilot` entry (contracts/agent-registry.md), `keyOf`, and `agentIds`.

**Checkpoint**: the harness type-checks with the registry in place, and the driver tests pass on the neutral request.

## Phase 3: User Story 1 - Copilot runs behave exactly as before (P1)

**Goal**: Copilot's decisions, install checks, retries, and exit codes are unchanged.

**Independent test**: `npm --prefix harness test`. The policy and install tests pass on the neutral request.

- [X] T006 [US1] Update `harness/test/driver.test.ts` to build `AccessRequest`s through `toAccessRequest` and assert the same results as before. Add a table test that every Copilot request kind (read, write, shell, memory, url, and an unknown kind) maps to the same decision and feedback as before (SC-004).
- [X] T007 [US1] Update `harness/test/failure.test.ts`: the classifier tests call `classifyCopilotError` from `harness/src/drivers/copilot.ts`, and `retryServiceError` takes it as an argument.

## Phase 4: User Story 2 - A maintainer selects the agent and its model (P1)

**Goal**: `--agent`, `models`, and their errors.

**Independent test**: the configuration tests in `harness/test/config.test.ts`.

- [X] T008 [US2] Write `harness/test/config.test.ts`, observed failing first, covering:
  - the default agent and model;
  - `--agent` and `--model` overrides;
  - an unregistered agent naming the registered ones;
  - a missing `models` entry;
  - the old `model` field;
  - the old `transcripts` field;
  - a missing or empty `agent`.
- [X] T009 [US2] Add `--agent`, `--judge-agent`, and `--verbose` to `harness/src/switches.ts` and `harness/src/args.ts`. Change the `--model`, `--judge-model`, and `--transcripts` defaults and usage (contracts/cli-and-config.md).
- [X] T010 [US2] Rewrite `readFileConfig` and `resolveConfig` in `harness/src/config.ts` for `agent`, `models`, and `judge`, with validation in research R6 order. Update `harness/harness.config.json`.

## Phase 5: User Story 3 - The judge is configured independently (P2)

**Goal**: the judge block, the switches, validation, and the fallback.

**Independent test**: the judge cases in `harness/test/config.test.ts` and `harness/test/judge.test.ts`.

- [X] T011 [US3] Add the judge cases to `harness/test/config.test.ts`:
  - each switch overriding the block;
  - a missing block, or an empty field;
  - an unregistered judge agent;
  - a judge agent with no ask;
  - a missing judge key;
  - `--no-judge` skipping the key check;
  - a judge agent the same as the agent under test, needing one key.

  Update the judge-model test in `harness/test/judge.test.ts`, whose default now comes from `judge.model`, not the run's model.
- [X] T012 [US3] Make `makeFallbackPicker` in `harness/src/judge.ts` accept no ask, and pick nothing then. Record the judge agent and model on each `AttemptResult`, and the judge and fallback on `Run`.

## Phase 6: User Story 4 - A new driver plugs in without changing the runner (P2)

**Goal**: the runner is registry-driven. Keys, errors, and redaction are per agent.

**Independent test**: the fake-driver test in `harness/test/runner.test.ts`.

- [X] T013 [US4] Write `harness/test/agents.test.ts`, covering the registry entry fields, `keyOf` order, and Copilot's read roots. Add redaction tests for `cursor_` and `AIza` keys to `harness/test/redact.test.ts`. Observe both failing first.
- [X] T014 [US4] Add the `cursor_` and `AIza` patterns to `harness/src/redact.ts`.
- [X] T015 [US4] Change `harness/src/runner.ts` to take everything agent-specific from `deps.agents[config.agent]`:
  - the driver, keys, read roots, and versions;
  - the judge and fallback asks.

  Replace `deps.driver`, `deps.makeAsk`, and `deps.versions` with `deps.agents`. Name the key variables and service in `missing-token` and `no-access` failures. Add `service` and `key` to `Failure`, and make `likelyCause` use them in `harness/src/failure.ts`.
- [X] T016 [US4] In `harness/test/runner.test.ts`, register a fake second agent, `fake`, with its own driver mapping its own requests through `permissionPolicy`. Run a scenario end to end with `--agent fake`, and assert:
  - the runner used `fake`'s driver, keys, and read roots;
  - the folder name carries `fake`.

## Phase 7: User Story 5 - Reports, run folders, and fixtures carry the agent (P3)

**Goal**: agent and versions in the reports. The agent id in non-Copilot folder names. `--promote` limited to Copilot runs.

**Independent test**: `harness/test/report.test.ts` and `harness/test/chain.test.ts`.

- [X] T017 [US5] Tests, observed failing first:
  - `runId` with and without an agent;
  - `report.md` naming the agent, SDK, runtime, and judge agent;
  - `promote` refusing a folder named with another agent, while accepting an old name and a Copilot name.
- [X] T018 [US5] Update `harness/src/report.ts` (`Run` and `AttemptResult` fields, `runId`, `renderReportMd`) and `harness/src/chain.ts` (`promote` reads the agent from the folder name; `runChain` saves candidates only when given a folder).

## Phase 8: User Story 6 - Each run prints a concise log that can be committed (P2)

**Goal**: the run log on stdout, progress on stderr, and `--transcripts` opt-in.

**Independent test**: `harness/test/runlog.test.ts` and the run-log cases in `harness/test/runner.test.ts`.

- [X] T019 [US6] Write `harness/test/runlog.test.ts`, observed failing first, covering:
  - block rendering for each label, with continuation indents;
  - `files:` placement and its omission for a turn with no changes;
  - `denied:` and hidden approvals, and `--verbose` showing `approved:` and `usage:`;
  - `fail:` and `not met:` lines and `result: pass`;
  - path rewriting of the project, its real path, the home, and the work root;
  - the closing table for pass, flaky, fail, blocked, skipped, and not run;
  - the judge count;
  - `OrderedLog` printing in selection order when completion is out of order.
- [X] T020 [US6] Create `harness/src/runlog.ts` (contracts/run-log.md): `renderBlock`, `renderRunBlock`, `renderSummary`, `pathRewriter`, and `OrderedLog`.
- [X] T021 [US6] Rewire `harness/src/runner.ts`:
  - the header line;
  - per-turn snapshots on `agent` entries;
  - blocks through `OrderedLog`;
  - run-level failures as `== run ==` blocks;
  - progress lines to `deps.err` (stderr);
  - the closing table in place of `summaryText`;
  - no run folder, attempt files, reports, or candidates without `config.transcripts`, and the missing-snapshots note.

  Remove `formatFailure` and `failureJson` from `harness/src/failure.ts`, and `summaryText` from `harness/src/report.ts`.
- [X] T022 [US6] Update `harness/test/runner.test.ts`:
  - replace each assertion on a `==== FAILURE` block, `HARNESS-FAILURE` JSON, or the old summary with the run-log line that supersedes it (D3.5);
  - add tests that a run without `--transcripts` writes no folder;
  - add a test that stdout holds no progress line and stderr holds no log line;
  - add a test that two runs with identical turns produce logs differing only in the header's run id and start time (SC-009).

  Update `harness/test/failure.test.ts` and `harness/test/report.test.ts` for the removed functions, recording the superseded behavior.
- [X] T023 [US6] Retire `harness/runs/` (FR-029a):
  - remove its line from `.gitignore`;
  - remove its entry from `tests/harness-placement.test.sh`, recording that test's verdict before and after (D3.4);
  - remove the `-path harness/runs` prune from `tests/self-contained-skills.test.sh`;
  - delete the folder if present;
  - change the spec 242 affected-run note in `harness-model-findings.md` to say its transcripts were not kept.

## Phase 9: User Story 7 - A live Copilot smoke run proves the groundwork (P3)

**Goal**: one live smoke run, with its log saved in the spec folder.

**Independent test**: quickstart step 4.

- [X] T024 [US7] After T026 and T027 pass, run `node harness/src/cli.ts --agent copilot --smoke > specs/247-multi-agent-harness-groundwork/harness/smoke.log` with no `--transcripts`. Check the log's size, that it holds no secrets or temporary paths, the install lines, and `git status`.
- [X] T025 [US7] Match every failure in `smoke.log` to a finding in `harness-model-findings.md`, adding a Runs line for this run. Treat a new failure kind caused by this change as blocking: fix it and rerun.

## Phase 10: Polish and cross-cutting

- [X] T026 [P] Update `harness/README.md`:
  - the registry and what a new driver supplies;
  - the switches table;
  - the configuration fields;
  - the run log and stderr progress;
  - `--transcripts` with no default, and how a spec can capture a log;
  - the removal of `harness/runs/` mentions;
  - the Diagnosing failures section, rewritten for the log;
  - the likely-cause rows for `missing-token` and `no-access`.
- [X] T027 Run `npm --prefix harness run typecheck`, `npm --prefix harness test`, and `bash tests/run-all.sh` (D3.2); record the totals in Notes.
- [X] T028 Mark Phase 5 complete in `rollout-plan.md`'s phase table, naming this spec's folder, and add a Status paragraph recording what was done beyond its items, including the run log (FR-035).

## Dependencies

- Phase 2 blocks every story.
- US1 (T006 and T007) follows T002 to T004.
- US2 and US3 share `config.ts`: T008 to T012 run in order.
- US4's T015 needs US2's config. T016 needs T015.
- US5's T018 is used by T021's folder handling.
- US6 needs US4's registry runner (T015).
- US7 runs last, after T026 and T027.

## Parallel opportunities

- T013 and T014 (redaction) can run alongside T008 to T012.
- T017 can run alongside T019.
- T026 can be written alongside T021.

## Implementation strategy

Foundational first, then US1 to prove Copilot is unchanged, then configuration (US2 and US3), the
registry runner (US4), reports (US5), and the run log (US6). Run the full suite, then the live
smoke run (US7).

## Notes

- Baseline (T001), 2026-11-14, before the first code edit:
  - `bash tests/run-all.sh` passed 87 of 87, with 0 failed.
  - `npm --prefix harness test` passed 102 of 102.
  - Both run outside the sandbox. Inside it, `distribution-packaging`, `adapter-coverage`, and `constitution-inventory` fail because they cannot write under the system temporary folder; that failure has nothing to do with the code.
- Observed failing first (D3.6): `config.test.ts`, `agents.test.ts`, and `runlog.test.ts` failed to load before their modules existed. The new `redact`, `chain`, and `args` cases failed before the code changes. With the tracked `harness/src` changes stashed, 30 of the 37 rewritten runner, driver, failure, judge, and report tests failed.
- Superseded assertions (D3.5):
  - The `==== FAILURE` block, the `HARNESS-FAILURE` JSON line, and its `Where:`, `What:`, `Recent:`, `Rejected:`, and `Likely cause:` lines are replaced by the block's `fail:` lines and the `== run ==` block's `cause:` line (FR-020, FR-024). The runner tests now assert those lines.
  - The `summaryText` tests are replaced by the `renderSummary` tests, which cover the closing table (FR-023).
  - The `formatFailure` redaction and capping tests are replaced by the `failLines` cap test in `runlog.test.ts` and the runner's redaction tests over the whole log.
  - The test that the judge model defaults to the scenario's model is replaced by the judge-block tests (FR-014): the judge's agent and model come from `judge`, and not from the agent under test.
  - The `classifyError` tests now call `classifyCopilotError`, with the same cases and results.
  - `harness-placement.test.sh` no longer requires `harness/runs/` to be gitignored, because the folder is retired (FR-029a).
- Placement test verdict (D3.4): `harness-placement.test.sh` passed at baseline, and passes after its `harness/runs/` entry was removed.
- Final (T027), 2026-11-14, after the last code and README edit, outside the sandbox:
  - `npm --prefix harness run typecheck` is clean.
  - `npm --prefix harness test` passed 145 of 145.
  - `bash tests/run-all.sh` passed 87 of 87, with 0 failed.
  - An earlier attempt is void: two suite runs overlapped and changed the same temporary fixtures, so `bundled-files` and `distribution-packaging` failed. With one run, both pass.
- Smoke run 1 (T024), `20261114-115258Z-smoke-40844ce`: passed 16 of 16. Its log held four raw `/var/folders/…` paths in `denied:` lines. Luna had dropped the `T/highway-harness-…` segment (finding F20), so the path was under none of the rewritten roots. This breaks FR-025 and was caused by this change. Fix: `pathRewriter` also rewrites the temporary folder (and, on macOS, its per-user parent) to `<tmp>`, matching whole path segments only. Two `runlog.test.ts` tests were observed failing first.
- After the fix: typecheck clean; `npm --prefix harness test` 147 of 147; `bash tests/run-all.sh` 87 of 87.
- Smoke run 2 (T024), `20261114-121007Z-smoke-40844ce`, saved as `harness/smoke.log`:
  - passed 15 of 16 (2 flaky), with 1 failed;
  - the log is 70 KB, with no token, no temporary path, and no color code;
  - 19 of 19 attempts installed the plugin with 16 skills;
  - `git status` shows only this spec folder as new.
- Findings (T025): discovery-smoke and codify-smoke attempt 1 match F18, and onboarding-smoke attempt 1 matches F21. The rejected reads match F20. No failure was caused by this change; each matched finding has a Runs line, and `harness-model-findings.md` has a section for both runs.
