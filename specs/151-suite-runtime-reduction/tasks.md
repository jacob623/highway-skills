# Tasks: Suite Runtime Reduction

**Input**: Design documents from `/specs/151-suite-runtime-reduction/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/)

**Tests**: Required, not optional. D3.3 obliges a behavioral change to add or amend a test, and
D3.6 obliges each new assertion to be observed failing before the implementation that makes it
pass. Test tasks here are constitutional, not stylistic.

**Organization**: Grouped by user story. US1 (validation cache) and US2 (runner concurrency) are
independently deliverable — either alone reduces runtime and leaves the suite green.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: US1 or US2
- Exact file paths are given in every task

## Path Conventions

Shell toolchain at `.highway/tools/`, tests at `.highway/tools/tests/`. Paths are
repository-relative.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the measurement floor the whole feature is judged against.

- [X] T001 Confirm a clean baseline: run `.highway/tools/tests/run-all.sh`, record wall time, pass count, and exit code in `specs/151-suite-runtime-reduction/coverage.md` under a "Baseline" heading. Required by D3.1. Run it twice and record the second number; the first recorded baseline for this feature was a cold run and overstated every test by up to 7×.
- [X] T002 [P] Record per-test warm timings for the ten slowest tests into `specs/151-suite-runtime-reduction/coverage.md`, invoking each as `bash <file>` rather than `./<file>` — several test files are not executable and `./` yields exit 126 and a near-zero time that looks like a fast pass.
- [X] T003 [P] Capture a reference copy of the current generated artifacts for the FR-003 byte-identity comparison: copy `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, `.agents/skills/`, and `.highway/catalog/` into a `mktemp -d` tree and record the path in `specs/151-suite-runtime-reduction/coverage.md`.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The cache key derivation, which US1 depends on entirely and which US2 does not.

**⚠️ CRITICAL**: T004–T006 block US1. US2 may begin without them.

- [X] T004 Create `.highway/tools/lib/validation-cache.sh` with the environment-hash function: hash `validate-skill.sh`, every `.highway/tools/lib/*.sh`, both files in `.highway/governance/`, and every file under `.highway/library/`, in sorted path order, using the existing `sha256sum`/`shasum` fallback pattern from `.highway/tools/generate-agent-adapters.sh` lines 42–48. Measured cost of this hash is 35 ms; if the implementation exceeds ~100 ms the design has gone wrong and the saving shrinks.
- [X] T005 Add the composite key function to `.highway/tools/lib/validation-cache.sh`: `sha256` of the skill's `SKILL.md` hash concatenated with the environment hash, per [data-model.md](data-model.md) "Validation Record".
- [X] T006 Add cache directory resolution to `.highway/tools/lib/validation-cache.sh` using `${TMPDIR:-/tmp}/highway-validation-cache/`, creating it with `mkdir -p` and degrading silently to "no cache" when creation fails, per contract VC-8. The path must never resolve inside the repository tree (VC-9).

**Checkpoint**: Key derivation exists and is callable. No behavior has changed yet.

---

## Phase 3: User Story 1 - Generation stops re-validating unchanged skills (Priority: P1) 🎯 MVP

**Goal**: A generation run validates a skill only when that skill's content, or the validator's
own environment, has changed since the last successful validation.

**Independent Test**: A second consecutive `generate-agent-adapters.sh` run drops from ~8.1 s to
under 4 s, while a skill with a seeded defect is still rejected with its original error text.

### Tests for User Story 1 ⚠️

> Write these FIRST and observe each failing before T012. D3.6.

- [X] T007 [P] [US1] Create `.highway/tools/tests/validation-cache.test.sh` declaring `# Instrument class: executed-behavior` and `# Artifact classes: source-document` in its header, matching the convention in `.highway/tools/tests/feature-150-collaborative-convergence.test.sh`.
- [X] T008 [US1] Add assertions to `.highway/tools/tests/validation-cache.test.sh` for VC-1 through VC-3: a cold validation exits 0 and writes exactly one key; a second validation of the same unchanged skill exits 0; the recorded key file exists under the resolved cache directory.
- [X] T009 [US1] Add the assertion that matters most to `.highway/tools/tests/validation-cache.test.sh` — VC-4: populate the cache for a skill, append a violating line to a copy of that skill, and require a non-zero exit with the original error text on stderr. This is the test that proves the cache is not masking defects; a feature that passes everything except this one is worse than no feature.
- [X] T010 [US1] Add VC-5 and VC-6 assertions to `.highway/tools/tests/validation-cache.test.sh`: editing the skill changes its key, and touching any file in `.highway/governance/` or `.highway/tools/lib/` changes the key of every skill.
- [X] T011 [US1] Add VC-7, VC-8, and VC-9 assertions to `.highway/tools/tests/validation-cache.test.sh`: `--no-cache` validates fully and records nothing; an unwritable or absent cache directory still exits 0; no cache path resolves under the repository root.
- [X] T012 [US1] Run `bash .highway/tools/tests/validation-cache.test.sh`, observe it failing, and record each failing assertion and its message in `specs/151-suite-runtime-reduction/coverage.md`. D3.6 is not satisfied by asserting that it would fail.

### Implementation for User Story 1

- [X] T013 [US1] Wire lookup and record into `.highway/tools/validate-skill.sh`: source `lib/validation-cache.sh`, return 0 early on a key hit, and write the key only after a validation that exited 0. A non-zero validation must write nothing (VC-4).
- [X] T014 [US1] Add `--no-cache` argument parsing to `.highway/tools/validate-skill.sh` ahead of the existing `skill_dir="${1%/}"` handling at line 36, leaving the existing single-argument usage and its error text at line 32 unchanged.
- [X] T015 [US1] Run `bash .highway/tools/tests/validation-cache.test.sh` and confirm it now passes.
- [X] T016 [US1] Verify FR-003: regenerate every artifact and `diff -r` against the T003 reference tree. Any difference other than a recorded generation timestamp is a defect, not an acceptable variation. Satisfies D4.4.
- [X] T017 [US1] Verify D3.4: validate all 12 skills under `.highway/skills/` cold and warm, and record in `specs/151-suite-runtime-reduction/coverage.md` that every verdict is identical across both. The cache is a new behavior in a validation path, so every existing fixture gets an explicit recorded verdict before it is relied on.
- [X] T018 [US1] Run `.highway/tools/tests/run-all.sh` and confirm 74 passed plus the new test, 0 failed. Record the wall time.
- [X] T019 [US1] **Decision gate.** Time `bash .highway/tools/tests/constitution-inventory.test.sh` against its 88.9 s baseline and record the result. If it has not fallen materially, it alone is the floor for any concurrent run, SC-001 is unreachable, and the correct next action is to amend the spec to bring the meta-harness into scope — not to proceed to US2 and discover this at the end.

**Checkpoint**: Generation is faster, every artifact is byte-identical, defects are still caught,
and the suite is green. US1 is independently shippable here.

---

## Phase 4: User Story 2 - The suite runs tests concurrently (Priority: P2)

**Goal**: Independent tests run at the same time; contended tests do not.

**Independent Test**: Three consecutive full runs produce an identical set of passing and failing
test names, matching a `--serial` run, at materially lower wall time.

### Tests for User Story 2 ⚠️

> Write these FIRST and observe each failing before T025. D3.6.

- [~] T020 [P] [US2] Create `.highway/tools/tests/runner-concurrency.test.sh` declaring `# Instrument class: executed-behavior` and its artifact classes in the header.
- [~] T021 [US2] Add RC-1 and RC-9 assertions to `.highway/tools/tests/runner-concurrency.test.sh` against a small fixture pool rather than the real 74-file suite: the concurrent result set equals the serial result set, and a deliberately failing fixture test yields a non-zero suite exit.
- [~] T022 [US2] Add RC-4 assertions to `.highway/tools/tests/runner-concurrency.test.sh`: with fixture tests that emit multi-line output concurrently, no emitted line contains two results spliced together and every test's output appears as one contiguous block.
- [~] T023 [US2] Add RC-6, RC-7, and RC-8 assertions to `.highway/tools/tests/runner-concurrency.test.sh`: the two executable tests still run last; the exclusive list appears exactly once in `.highway/tools/tests/run-all.sh`; a discovered test absent from that list runs in the parallel pool.
- [~] T024 [US2] Run `bash .highway/tools/tests/runner-concurrency.test.sh`, observe it failing, and record each failing assertion and its message in `specs/151-suite-runtime-reduction/coverage.md`.

### Implementation for User Story 2

- [~] T025 [US2] Add `--serial` and `--jobs <n>` argument parsing to `.highway/tools/tests/run-all.sh`, with `--jobs 1` equivalent to `--serial`, per [contracts/runner-concurrency.md](contracts/runner-concurrency.md). Satisfies FR-011.
- [~] T026 [US2] Declare the exclusive-test list exactly once in `.highway/tools/tests/run-all.sh`, seeded with the eleven files named in [contracts/runner-concurrency.md](contracts/runner-concurrency.md), each with a one-line reason. A test absent from the list runs in the parallel pool.
- [~] T027 [US2] Replace the single discovery loop at `.highway/tools/tests/run-all.sh` line 64 with pool partitioning, leaving the residue sweep at lines 19–32 ahead of all execution (RC-5, FR-010) and the trailing two-test block at lines 70–73 intact (RC-6).
- [~] T028 [US2] Run the exclusive pool serially and the parallel pool under `xargs -P` in `.highway/tools/tests/run-all.sh`, capturing each test's output to its own `mktemp` file and emitting it whole after that test completes (RC-2, RC-3, RC-4). Use indexed loops, not `wait -n`, which bash 3.2.57 does not have (D2.1).
- [~] T029 [US2] Run `bash .highway/tools/tests/runner-concurrency.test.sh` and confirm it passes.
- [~] T030 [US2] Run `.highway/tools/tests/run-all.sh` three times, sort the `PASS:`/`FAIL:` lines of each, and confirm all three are identical (SC-003). Record the three wall times.
- [~] T031 [US2] Run `.highway/tools/tests/run-all.sh --serial` and confirm the result set matches the concurrent result set (SC-006, RC-1).
- [~] T032 [US2] Resolve any test that passes serially and fails concurrently by adding it to the exclusive list in `.highway/tools/tests/run-all.sh` with a recorded reason. Such a failure is evidence of real coupling between tests; it is never resolved by loosening the test (D3.5, FR-012).

**Checkpoint**: The suite is concurrent, reproducible, and attributable, with a serial escape
hatch.

---

## Phase 5: Polish & Cross-Cutting Concerns

> **Markers**: `[X]` done · `[ ]` open · `[~]` **descoped or moot — deliberately not done, with
> the reason stated on the task.** A `[~]` is a decision, not an omission.

- [X] T033 [P] Update `.highway/tools/README.md` to describe `--no-cache` and the validation cache, including that the cache lives outside the repository and that a miss performs full validation. D6.1.
- [~] T034 [P] Update `.highway/tools/tests/README.md` to describe the two pools, `--serial`, `--jobs`, and the rule that a test is exclusive until proven isolated. D6.1. **Moot: US2 descoped, `run-all.sh` unchanged, so there is nothing new to document. Documenting a `--serial` flag that does not exist would be the D6.1 defect this task exists to prevent.**
- [X] T035 Confirm D6.2: every path referenced by the two updated READMEs resolves inside the distributed tree.
- [X] T036 Confirm D1.1 and D1.2: no new or edited file under `.highway/` contains the string `.specify/` or `specs/`, and `validate-skill.sh` still exits 0 against a copy of the tree with `.specify/` and `specs/` removed.
- [X] T037 Confirm D2.1 and D2.2 against the three edited or added scripts: no associative array, `mapfile`, `readarray`, `${var^^}`, `&>>`, or `wait -n`, and every external command invoked appears in the Declared Toolchain.
- [X] T038 Confirm D3.7 is undisturbed: run `bash .highway/tools/tests/constitution-inventory.test.sh` and confirm every mapped test's probe still fails when seeded and passes when neutralised. The runner changed; the probes invoke tests directly and should be unaffected, but "should be" is not evidence.
- [~] T039 Run the full [quickstart.md](quickstart.md) end to end and record each part's outcome in `specs/151-suite-runtime-reduction/coverage.md`. **Not run: the quickstart's US2 sections exercise `--serial` and `--jobs`, which were never built. Running it as written would fail for reasons unrelated to what shipped. The quickstart needs revision before it can serve as evidence.**
- [X] T040 Verify FR-012 and SC-002 explicitly: `git diff -- .highway/tools/tests/` shows no assertion removed, skipped, or loosened in any pre-existing test, and the test file count has not decreased. State this as its own finding rather than letting a green suite imply it.
- [X] T041 Write the completion report in `specs/151-suite-runtime-reduction/coverage.md` with the suite result and the requirement coverage as two separate claims, and the measured wall time against SC-001's baseline. D7.3.

---

## Dependencies

```text
Phase 1 (T001-T003)
   │
   ├──────────────────────────────┐
   ▼                              ▼
Phase 2 (T004-T006)          Phase 4 / US2 (T020-T032)
   ▼                              │
Phase 3 / US1 (T007-T019)         │
   │                              │
   └──────────────┬───────────────┘
                  ▼
         Phase 5 (T033-T041)
```

- **US1 and US2 are independent.** Either can ship alone. US2 does not require the cache.
- **Recommended order is US1 first** anyway: it shrinks the exclusive pool that bounds US2's
  benefit, and T019's decision gate may change US2's scope.
- Within US1, T007–T011 are sequential edits to one file; T012 gates T013.
- Within US2, T020–T023 are sequential edits to one file; T024 gates T025.

## Parallel Opportunities

- **Phase 1**: T002 and T003 are independent of each other.
- **Phase 3 / Phase 4**: T007 and T020 create different files and may be written concurrently if
  two people are working.
- **Phase 5**: T033 and T034 edit different READMEs.
- Everything else is sequential, mostly because US1's tasks edit one test file and then one
  script, in order.

## Implementation Strategy

**MVP is US1 alone** — T001 through T019. It delivers the larger saving, carries no interference
risk, and ends at a green suite with byte-identical artifacts.

**Stop at T019 if the decision gate fails.** If `constitution-inventory.test.sh` has not fallen
materially from 88.9 s, SC-001 is unreachable through the two causes in scope, and the honest next
step is to amend the spec rather than to add concurrency and report a target as missed.

**US2 is the second increment.** It is riskier — concurrency can surface hidden coupling between
tests — which is exactly why T032 treats such a discovery as a finding to record, not a failure to
suppress.
