---
description: "Task list for the behavioral test harness"
---

# Tasks: Behavioral Test Harness

**Input**: Design documents from `specs/232-behavioral-test-harness/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required. The spec names bash suite checks (FR-014, FR-015a, FR-019, FR-020, FR-021,
FR-025, FR-038, FR-044), and D3.3 and D3.6 require a failing test before each behavior.

**Organization**: Tasks are grouped by user story. Bash checks live in `.highway/tools/tests/`;
runner unit tests live in `harness/test/`.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run the full bash suite and record the result in specs/232-behavioral-test-harness/baseline.txt (D3.1)
- [X] T002 Create harness/package.json, harness/tsconfig.json, and harness/harness.config.json, and install @github/copilot-sdk and typescript into harness/node_modules with harness/package-lock.json
- [X] T003 [P] Add `exclude	harness	-` to .highway/tools/.distribution-manifest and add harness/runs/, harness/node_modules/, harness/.env, and .env to .gitignore
- [X] T004 [P] Amend .specify/memory/constitution.md to 2.3.0 with a development-only Harness Toolchain declaration and a Sync Impact Report

---

## Phase 2: Foundational

- [X] T005 Write .highway/tools/tests/harness-placement.test.sh (manifest excludes harness, .gitignore entries, constitution declares the Harness Toolchain) and observe it fail before T003 and T004 land
- [X] T006 [P] Write harness/bin/lib/scenario.sh: a Bash 3.2 reader that lists scenario files and prints a key's values for a file
- [X] T007 [P] Write harness/bin/inventory.sh: print `<skill>\t<kind>\t<id>\t<text>` for every step, Verification bullet, and Error Handling bullet, hashing whitespace-normalized bullet text
- [X] T008 [P] Write harness/src/scenario.ts: parse the scenario format in contracts/scenario-format.md into a typed Scenario with line numbers
- [X] T009 [P] Write harness/src/redact.ts and harness/test/redact.test.ts
- [X] T010 [P] Write harness/src/switches.ts (one switch per line) and harness/src/args.ts (parser, conflicts, help) with harness/test/args.test.ts
- [X] T011 Write harness/src/config.ts: read harness.config.json and harness/.env, and resolve the model, judge model, and token

**Checkpoint**: shared readers, switch table, and redaction exist and are tested.

---

## Phase 3: User Story 1 - Run one scenario headless (P1) 🎯 MVP

**Goal**: One scenario runs end to end with keyed replies, structural checks, the storage invariant, retry, redacted transcripts, and stdout failure blocks.

**Independent Test**: `node harness/src/cli.ts --paths harness/scenarios/highway-codify/codify-plan-review.scenario` with a token; without a token, exit 2 with a missing-token block.

- [X] T012 [P] [US1] Write harness/test/replies.test.ts for ordered exact-text matching, patterns, emphasis and case normalization, and the fallback decision, then harness/src/replies.ts
- [X] T013 [P] [US1] Write harness/test/checks.test.ts for exists, absent, heading, field, row, contains, template, and the writes-pattern storage invariant, then harness/src/checks.ts
- [X] T014 [P] [US1] Write harness/test/failure.test.ts for every failure kind's likely cause, the block shape, and the HARNESS-FAILURE JSON line, then harness/src/failure.ts
- [X] T015 [US1] Write harness/src/project.ts: build the distribution once per run with .highway/tools/generate-distribution.sh, then copy it plus the fixture or overlay into a temporary project per attempt; snapshot hashes before and after
- [X] T016 [US1] Write harness/src/driver.ts: CopilotClient with a temporary baseDirectory and token, a session with the permission policy, onUserInputRequest, sendAndWait turns, max turns, timeout, rate-limit retries, and raw and normalized transcripts
- [X] T017 [US1] Write harness/src/judge.ts: the reply fallback session and the advisory judge, each in a new session with only its permitted inputs, with JSON parsing and the no-evidence rule
- [X] T018 [US1] Write harness/src/report.ts with harness/test/report.test.ts: attempt result files, report.md, report.json, junit.xml, and the summary
- [X] T019 [US1] Write harness/src/runner.ts and harness/src/cli.ts: header line, progress lines, attempts with one retry and the flaky warning, the paraphrased-question warning, parallelism, rate-limit stop with exit 2, and exit-code precedence
- [X] T020 [US1] Verify `--help`, an unknown switch, a conflict, and a missing token from the command line, and record the output in specs/232-behavioral-test-harness/quickstart-results.txt

**Checkpoint**: a single scenario can run headless; without a token the run exits 2 with a diagnosable block.

---

## Phase 4: User Story 2 - Run only the scenarios a change affects (P1)

**Goal**: `--changed-since`, `--paths`, and `--skills` select a union with reasons.

**Independent Test**: `--paths .highway/library/templates/output/codify-plan.md` selects only highway-codify scenarios with the reason naming the template.

- [X] T021 [US2] Write .highway/tools/tests/harness-path-map.test.sh (codify-plan.md maps to highway-codify; shared files map to smoke; specs and tests map to nothing; every shipped template and governance file maps) and observe it fail before T022
- [X] T022 [US2] Write harness/bin/path-map.sh and harness/selection/shared.txt
- [X] T023 [US2] Write harness/src/select.ts with harness/test/select.test.ts: full, smoke, targeted union with reasons, git diff for --changed-since, deleted paths resolved with git show against the ref, and the empty selection exiting 0

**Checkpoint**: targeted selection works offline.

---

## Phase 5: User Story 3 - Know exactly what highway-codify's scenarios cover (P1)

**Goal**: Every highway-codify bullet is a scenario, an invariant, or a waiver; the bash suite gates it.

**Independent Test**: Remove one codify `covers:` line; harness-coverage.test.sh fails naming the bullet.

- [X] T024 [US3] Write .highway/tools/tests/harness-coverage.test.sh (codify gated; unknown tags shown beside uncovered bullets; other skills reported only) and observe it fail with codify bullets uncovered
- [X] T025 [US3] Write .highway/tools/tests/harness-fixtures.test.sh and harness/fixtures/templates.map, and observe it fail before fixtures exist
- [X] T026 [US3] Write the five stage fixtures under harness/fixtures/stages/ from the output templates for the Northwind Outfitters example
- [X] T027 [US3] Write the highway-codify overlays under harness/fixtures/overlays/ (code project, needed language, platform with no row, more than five implementations, existing product, open plan, open task, controls and NFRs, no coding standards)
- [X] T028 [US3] Write the highway-codify scenarios under harness/scenarios/highway-codify/ with covers, reaches, and reply kinds
- [X] T029 [US3] Write harness/coverage/treatments.txt with invariants and waivers for the remaining highway-codify bullets
- [X] T030 [US3] Write harness/src/coverage.ts: call inventory.sh and build the per-skill coverage report section

**Checkpoint**: harness-coverage.test.sh passes with highway-codify fully treated.

---

## Phase 6: User Story 4 - Smoke-test every skill quickly (P2)

**Goal**: One smoke scenario per skill.

**Independent Test**: harness-scenarios.test.sh passes; `--smoke` selects 15 scenarios.

- [X] T031 [US4] Write .highway/tools/tests/harness-scenarios.test.sh (format lint, unique ids, known skills and fixtures, expect paths within writes, exactly one smoke scenario per skill, chain positions 1–6 once each) and observe it fail
- [X] T032 [US4] Write one smoke scenario for each of the other 14 skills under harness/scenarios/<skill>/

---

## Phase 7: User Story 5 - Run the full chain and refresh the stage snapshots (P2)

**Goal**: The chain runs in order, saves candidates only when it all passes, and `--promote` replaces the stage fixtures.

**Independent Test**: harness/test/chain.test.ts with a fake driver: a stage failure skips everything and saves nothing; promote replaces exactly five fixtures.

- [X] T033 [US5] Write the six chain scenarios (setup, request, discovery, architecture, implementation, codify) with `chain:` positions
- [X] T034 [US5] Write harness/src/chain.ts with harness/test/chain.test.ts: ordering, starting from the previous stage, candidate snapshots, stop on failure, and promote

---

## Phase 8: User Story 6 - See the judge's view of each scenario (P3)

- [X] T035 [US6] Write harness/test/judge.test.ts for verdict parsing, the no-evidence rule, `--no-judge`, and judge-model defaulting, and adjust harness/src/judge.ts until it passes

---

## Phase 9: Polish and cross-cutting concerns

- [X] T036 Write .highway/tools/tests/harness-switches.test.sh (every switch in switches.ts has help text and appears in harness/README.md) and observe it fail before the README exists
- [X] T037 Write harness/README.md covering every FR-043 section, including the likely-cause table and the spike checklist
- [X] T038 Run `npm --prefix harness test` and `npm --prefix harness run typecheck`, and record the results in specs/232-behavioral-test-harness/quickstart-results.txt
- [X] T039 Update rollout-plan.md Phase 2 with what landed and what waits on the live spike
- [X] T040 Run the full bash suite and record the result in specs/232-behavioral-test-harness/final.txt (D3.2)

---

## Dependencies and Execution Order

- Setup (T001–T004) → Foundational (T005–T011) → User Story 1 (T012–T020).
- User Stories 2, 3, and 4 depend on Foundational and can proceed in parallel with User Story 1's
  driver work; their bash checks need no Node.
- User Story 5 depends on User Story 1 (runner) and User Story 3 (fixtures).
- User Story 6 depends on T017.
- Polish runs last.

## Parallel Opportunities

- T003 and T004; T006–T010; T012–T014; T021, T024, T025, and T031 (different test files).

## Implementation Strategy

1. MVP: Phases 1–3 give a headless single-scenario run with diagnosable failures.
2. Add selection (Phase 4) and codify coverage (Phase 5), which gate Phase 2 of the rollout plan.
3. Add smoke and chain (Phases 6–7), then the judge tests (Phase 8).
4. Live verification (the spike, SC-002, SC-003, SC-005) needs a Copilot token and is run by hand.
