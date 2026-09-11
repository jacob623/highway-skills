---

description: "Task list for feature 041 implementation"
---

# Tasks: Automatic Check Integrity

**Input**: Design documents from `/specs/041-auto-check-integrity/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/)

**Tests**: This feature *is* test work. Every implementation task below edits a file under
`.highway/tools/tests/`, so there is no separate test phase — a task that adds an assertion and the
task that proves it are the same task.

**Organization**: Grouped by user story. Both P1 stories are ordered by dependency rather than by
priority, and the reason is recorded under Dependencies.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5)
- Every task names an exact file path

## Path Conventions

- Tests: `.highway/tools/tests/`
- Governance: `.specify/memory/`
- Spec records: `specs/<nnn>-<name>/coverage.md`

---

## Phase 1: Setup — Measure before changing anything

**Purpose**: `D3.4` requires a new check to be evaluated against the tree *before* it is enabled.
These numbers decide the amendment classification and cannot be reconstructed afterwards.

- [X] T001 Run `bash .highway/tools/tests/run-all.sh`, confirm exit 0, and record the pass/fail counts and wall clock in `specs/041-auto-check-integrity/research.md` under a new "Measured baseline" section
- [X] T002 [P] Enumerate every Enforcement Map row tagged `[auto]` in `.specify/memory/constitution.md` and record the rule id, test filename, and declared artifact classes for each in `specs/041-auto-check-integrity/research.md`
- [X] T003 Determine, per registered `[auto]` test, whether it seeds a defect that is actually executed, and record the pass/fail split in `specs/041-auto-check-integrity/research.md`; research R4 predicts five failures, and **if the measured count differs, record the measured count rather than the prediction** — measured: `generate-agent-adapters.test.sh` already has a real D4.1 probe, correcting R4's prediction
- [X] T004 Using T003's measured count, confirm or revise the MINOR classification recorded in `specs/041-auto-check-integrity/plan.md`; if any check in the count cannot be brought to conformance in this change, change the classification to MAJOR and record which rule is enabled later — MINOR confirmed, conditional on Phases 4–5 landing

**Checkpoint**: The pre-enable evidence exists. No behaviour has changed.

---

## Phase 2: Foundational — Shared mechanism

**Purpose**: The probe-mode convention, the residue sweep, and the constitution definition every
later phase depends on. **Blocking: no user story phase may start until this phase completes.**

- [X] T005 Amend the `Completed spec` definition at line 239 of `.specify/memory/constitution.md` to name the completion register instead of task completion state
- [X] T006 Update the `D7.4` Enforcement Map note in `.specify/memory/constitution.md` so "every in-scope feature" names the register as the source of scope
- [X] T007 Bump `.specify/memory/constitution.md` to 1.6.0 and record the amendment, its classification from T004, and the superseded definition in the Sync Impact Report at lines 2 and 12
- [X] T008 Add `--probe <class>` and `--probe <class> --neutralise` argument parsing plus an `EXIT` trap to `.highway/tools/tests/shipped-tree-independence.test.sh`, wrapping the real probe it already seeds, as the reference implementation of [contracts/probe-mode.md](contracts/probe-mode.md)
- [X] T009 Verify T008's contract by hand: `--probe source-document` exits non-zero, `--probe source-document --neutralise` exits 0, `--probe made-up-class` exits 2, and a plain run still exits 0
- [X] T010 Extend the probe sweep at lines 18–25 of `.highway/tools/tests/run-all.sh` to cover every probe family this feature adds, so residue from an interrupted run is not attributed to whichever test sorts first

**Checkpoint**: One test implements probe mode and the convention is proven. The constitution's
definition now describes the mechanism the rest of the feature builds.

---

## Phase 3: User Story 1 — A check's scope is declared, not inferred (P1)

**Goal**: The set of features subject to `D7.2` and `D7.4` is stated once by a maintainer, outside
the directories being checked.

**Independent Test**: Add an unchecked task box to a registered complete feature and confirm the
completion check still evaluates it; remove a register entry and confirm the check names the gap.

- [X] T011 [US1] Create `.specify/memory/completion-register.md` with the header, the explanatory prose, and the table columns `Feature`, `Status`, `Corrects` per [contracts/completion-register.md](contracts/completion-register.md)
- [X] T012 [US1] Populate one row for every directory matching `specs/[0-9][0-9][0-9]-*`, marking `003-constitution-enforcement` as `incomplete`, `041-auto-check-integrity` as `in-progress`, and the rest `complete` per research R8; leave `Corrects` as `-` for now
- [X] T013 [US1] Add a register reader to `.highway/tools/tests/completion-coverage.test.sh` that parses `name<TAB>status<TAB>corrects` rows with `awk`, using a newline-delimited string rather than an associative array, per the Bash 3.2 constraint in `plan.md`
- [X] T014 [US1] Add assertion A8 to `.highway/tools/tests/completion-coverage.test.sh` — fail when the register reader matches zero rows — and observe it failing by commenting out every table row before wiring anything else to the reader
- [X] T015 [US1] Replace the eligibility block at lines 294–306 of `.highway/tools/tests/completion-coverage.test.sh` with a register lookup, deleting the `tasks.md` checkbox condition and the `feature_number -ne 3` special case
- [X] T016 [US1] Add assertions A1–A4 to `.highway/tools/tests/completion-coverage.test.sh`: unregistered directory, entry naming no directory, malformed status, duplicate entry — each with the failure message shape given in [contracts/completion-register.md](contracts/completion-register.md)
- [X] T017 [US1] Add a `--probe source-document` mode to `.highway/tools/tests/completion-coverage.test.sh` that seeds each of A1–A4 and A8 against the real register and restores it byte-exactly, following T008's reference implementation
- [X] T018 [US1] Observe each of A1–A4 and A8 failing, then passing after restoration, and record the failing messages in `specs/041-auto-check-integrity/research.md` per `D3.6`
- [X] T019 [US1] Run quickstart Scenario 1 from [quickstart.md](quickstart.md) — un-tick a task box in `specs/033-highway-setup/tasks.md`, confirm the check still evaluates the feature, restore the box
- [X] T020 [US1] Run `bash .highway/tools/tests/completion-coverage.test.sh` and confirm exit 0 with 40 directories evaluated rather than 37 — measured: exit 0, but **39** directories evaluated, not 40 as predicted here. The register has 41 rows; `003-constitution-enforcement` (`incomplete`) and `041-auto-check-integrity` (`in-progress`) are excluded, leaving 39 `complete`-status directories. Recorded as measured, not corrected to match the prediction, per this feature's own discipline.

**Checkpoint**: US1 is independently verifiable. A feature can no longer exclude itself from the
completion rules through the file those rules read.

---

## Phase 4: User Story 3 — The unproven checks are given real probes (P1)

**Goal**: The five checks that currently prove nothing seed a defect and observe it caught.

**Ordering**: US3 precedes US2 deliberately. Wiring the harness first turns five tests red and
leaves the suite failing for every subsequent task, which violates `D3.1`. See Dependencies.

**Independent Test**: For each of the six affected rules, break the property it states, confirm the
named check fails, restore, confirm it passes.

- [X] T021 [P] [US3] Add a `generated-artifact` probe to `.highway/tools/tests/generate-agent-adapters.test.sh` that appends a byte to a generated adapter after generation and requires the `D4.1` hand-edit refusal to report it — measured: `--probe generated-artifact` seeded exit=1, `--neutralise` exit=0, undeclared exit=2, plain exit=0, no residue
- [X] T022 [P] [US3] Add a `generated-artifact` probe to `.highway/tools/tests/generate-catalog.test.sh` that perturbs one byte outside the excepted `generated_at` field between two runs and requires the `D4.2` determinism check to report it — measured: seeded exit=1, neutralised exit=0, undeclared exit=2, plain exit=0
- [X] T023 [US3] Add a `generated-artifact` probe to `.highway/tools/tests/adapter-coverage.test.sh` that removes `highway-inquiry`'s catalog entry and requires `D4.5` to name the missing correspondence — measured: the shared `check_skill_correspondence` seed removes the catalog line for `highway-inquiry`; probe fails with "has no entry in the catalog" naming the skill
- [X] T024 [US3] Extend the `.highway/tools/tests/adapter-coverage.test.sh` probe to remove `highway-inquiry`'s adapter from one agent tree and require `D4.6` to name the tree and the skill — measured: same probe also deletes the real `.github/skills/highway-inquiry/SKILL.md`; failure message "has no adapter at $rel" names both the tree-relative path and the skill id
- [X] T025 [US3] Extend the `.highway/tools/tests/adapter-coverage.test.sh` probe to remove `highway-inquiry`'s adapter manifest row and its distribution manifest row, requiring `D4.6` and `D4.5` respectively to name the manifest — measured: same probe strips both rows via `grep -v`; failures "has no adapter manifest row for $rel" and "is not included by the distribution manifest" both fire; `--probe generated-artifact` (seeded, bundling T023-T025) exit=1, `--neutralise` exit=0
- [X] T026 [US3] Add a `source-document` probe to `.highway/tools/tests/adapter-coverage.test.sh` that changes `highway-inquiry`'s description in `.highway/skills/highway-inquiry/SKILL.md` without regenerating and requires the `D4.7` currency check to report staleness — measured: `--probe source-document` seeded exit=1 (~7s) with "is stale; regenerating skill 'highway-inquiry' produces a different adapter", neutralised exit=0 (~8.5s), real source file restored byte-exact via trap (diff-confirmed)
- [X] T027 [US3] Build `adapter-coverage`'s expensive tree copy once and reuse it across its five probes, per the runtime contract in [contracts/probe-mode.md](contracts/probe-mode.md) — measured: T023-T025 share one seed/check pass under the `generated-artifact` class (one invocation, no rebuild per sub-probe); the `source-document` class builds its `mktemp -d` currency tree exactly once per invocation and reuses it for the single currency comparison; declared classes narrowed to `source-document generated-artifact` (no unused `disposable-fixture`)
- [X] T028 [US3] Add probe mode to `.highway/tools/tests/distribution-packaging.test.sh` around its four existing probe families, reusing its two distribution builds rather than rebuilding per class — measured: 3 declared classes each mapped to one existing probe family (`source-document`→dev-reference, `disposable-fixture`→undeclared-repository-path, `generated-artifact`→missing-governing-document); all 3×(seeded+neutralised)+undeclared = 7 cases measured with correct exit codes 1/0/2; plain re-run exit=0; no residue found
- [X] T029 [P] [US3] Add probe mode to `.highway/tools/tests/spec-record.test.sh` around its existing probe, covering the classes it declares — measured: declared classes narrowed to `disposable-fixture` (the only class this file's checks actually probe, matching the established narrowing pattern); reused the existing `numbering_problems()` against a `mktemp -d` synthetic tree; seeded (gap) exit=1, neutralised (contiguous) exit=0, undeclared exit=2, plain exit=0
- [X] T030 [US3] Confirm every probe added in T021–T029 names its artifacts with `$$`, restores by rewriting bytes, and **uses no version control** — research R5 records why — measured: audited all 5 files; every on-disk probe artifact is named with `$$` (`agent-adapter-probe-$$.md`, `distribution-devref-probe-$$.md`, `distribution-probe-$$.md`) or lives under a self-cleaning `mktemp -d`/`mktemp` (adapter-coverage's backup dir and currency tree, spec-record's probe_root); every branch restores via `cp`/`mv`/`sed` from a backup or simply discards a `mktemp` tree — none invoke `git`; `run-all.sh`'s residue sweep already covers the `$$`-suffixed filename patterns
- [X] T031 [US3] Observe each of the five previously unproven checks failing on its seeded defect and passing on restoration, recording the failing messages in `specs/041-auto-check-integrity/research.md` per `D3.6` — done, see "Phase 4 (US3) observations" section in research.md
- [X] T032 [US3] Run quickstart Scenario 8 from [quickstart.md](quickstart.md) and confirm no probe residue remains anywhere under `.highway/` or `specs/` — measured: `git status --porcelain` after exercising every T021-T029 probe shows only pre-existing uncommitted work from prior features; no stray file matches any probe naming pattern (`*-probe-*`, `agent-adapter-probe-*`); full `run-all.sh` still green (39 passed, 0 failed) at 1:54 total

**Checkpoint**: All six rules named in FR-011 now have probes that run. The harness can be turned on
without turning the suite red.

---

## Phase 5: User Story 2 — A registered check proves it can fail (P1)

**Goal**: `D3.7` is decided by running each declared probe, not by matching a comment.

**Independent Test**: Break a test's declared probe so it no longer fails, confirm the inventory
check rejects it, restore, confirm it passes.

- [X] T033 [US2] Replace the `# Seeded failure probe:` grep at lines 201–202 of `.highway/tools/tests/constitution-inventory.test.sh` with a paired invocation: `--probe <class>` must exit non-zero and `--probe <class> --neutralise` must exit zero — done via `harness_run`/`harness_probe_pair`, replacing the old grep entirely
- [X] T034 [US2] Replace the `# Artifact classes:` grep at line 222 of `.highway/tools/tests/constitution-inventory.test.sh` with a read of the declaration that exercises each class named — done: `harness_run` reads each mapped test's `# Artifact classes:` line and exercises every class named via `harness_probe_pair`; the generic per-file presence check at the bottom of the file is unchanged and untouched since it covers non-mapped files too
- [X] T035 [US2] Add the undeclared-class rejection to `.highway/tools/tests/constitution-inventory.test.sh`: exit 2 from a probed test means a declaration mismatch, reported distinctly from a check failure — done: `harness_probe_pair` reports `FAIL: <rule> test probes a class it does not declare` distinctly from the did-not-fail/fails-without-defect messages
- [X] T036 [US2] Add the zero-pairs assertion to `.highway/tools/tests/constitution-inventory.test.sh` — fail when no rule/class pair was exercised — and observe it failing before relying on it — measured: an isolated repro of the exact zero-pairs branch against an empty map printed `FAIL: no rule/class pairs were exercised; the harness matched nothing` and returned exit 1, before the real `dev_map` (which is never empty) was relied on
- [X] T037 [US2] Add the probe-mode early return to `.highway/tools/tests/constitution-inventory.test.sh` so its own probe returns before the harness loop, and confirm by running its probe that it does not recurse — measured: `--probe source-document` and `--neutralise` both return promptly (no hang, no runaway recursion); the probe branch sits before `source .../constitution.sh` and before `harness_run` is ever called
- [X] T038 [US2] Add a `source-document` probe to `.highway/tools/tests/constitution-inventory.test.sh` that makes a mapped test's declared probe stop failing, satisfying `D3.7` for the check that decides `D3.7` — measured: seeded exit=1, neutralised exit=0, undeclared exit=2; seeds by breaking `generate-catalog.test.sh`'s `probe_generated_artifact` (the same defect Scenario 6 seeds by hand) via backup/`trap`-restore, never git; real file confirmed byte-restored after each run
- [X] T039 [US2] Run quickstart Scenarios 5 and 6 from [quickstart.md](quickstart.md) and confirm the neutralised invocation is what rejects a probe that always fails — measured: Scenario 5 gave SEEDED_EXIT=1, NEUTRAL_EXIT=0; Scenario 6 gave EXIT=1 naming `D4.2 probe for generated-artifact fails without a seeded defect` (and, correctly, `D3.7`'s own self-probe for the same reason) — the neutralised half of the pair is what a probe that always fails cannot satisfy
- [X] T040 [US2] Update the `D3.7` Enforcement Map note in `.specify/memory/constitution.md` so it describes an executed probe rather than a declared one — confirmed accurate as written: "Executes each mapped test's declared probe per artifact class and requires a non-zero exit; requires a zero exit when the same probe is invoked neutralised" now matches `harness_run`'s real behavior

**Checkpoint**: US2 is independently verifiable. A comment is no longer evidence.

---

## Phase 6: User Story 4 — The corrective set is declared, not enumerated (P2)

**Goal**: `D7.5`'s corrective set comes from the register, and recording a ninth correction needs no
edit to a test script.

**Independent Test**: Declare a new correction in the register and confirm the check enforces the
superseding entry with no change to the check.

- [X] T041 [US4] Populate the `Corrects` column in `.specify/memory/completion-register.md` for the eight corrective features currently hardcoded at lines 333–342 of `.highway/tools/tests/completion-coverage.test.sh` — done: mapped each corrective feature to its originating directory read from its own `coverage.md` "Originating Feature N; superseded by Feature M" text (025,026→024; 028→027; 029→028; 032→030; 034→033; 036→035; 038→037).
- [X] T042 [US4] Delete the eight-name array from `.highway/tools/tests/completion-coverage.test.sh` and drive `correction_check()` from the register's `Corrects` column — done: the `for corrective_feature in ...` hardcoded list is replaced with a loop over `register_rows` filtered to rows with a non-`-` `Corrects` value.
- [X] T043 [US4] Add assertion A5 to `.highway/tools/tests/completion-coverage.test.sh`: a `Corrects` value must resolve to an existing directory with a strictly lower number, and must not be a self-reference — done: added to `register_problems`, using `10#` prefixes to avoid bash octal parsing of zero-padded numbers (caught live: `028`/`038` raised "value too great for base" before the fix).
- [X] T044 [US4] Extend the register probe from T017 to seed an unresolvable `Corrects` value and a self-reference, observing both rejected — done: two new probe cases added (using 034/033 as the fixture pair, not 025, to avoid colliding with Scenario 4's eight-name grep check); verified `does not resolve to an existing directory` and `self-reference` messages both fire.
- [X] T045 [US4] Run quickstart Scenario 4 from [quickstart.md](quickstart.md) and confirm `grep -c` for the eight feature names in `.highway/tools/tests/completion-coverage.test.sh` returns 0 — done: both sed/run/restore/run cycles exited 0, and `grep -c 'profile-path-migration\|valid-profile-yaml\|objectives-rename-cleanup' .highway/tools/tests/completion-coverage.test.sh` returned `0`.

**Checkpoint**: US4 is independently verifiable. The judgment stays with the maintainer; only its
storage moved.

---

## Phase 7: User Story 5 — The demanded records are brought to conformance (P2)

**Goal**: The two non-conforming coverage records are corrected and the falsified completion claim
is recorded.

**Independent Test**: Run the completion check over the full register and confirm every entry
conforms.

- [X] T046 [US5] Rename the header of `specs/038-readiness-verification-corrections/coverage.md` to `| Requirement | Outcome | Evidence |` and map each row's existing value onto the declared outcome vocabulary — done; header renamed, all 15 rows already used the valid `deferred` outcome
- [X] T047 [US5] Remove the 8 non-requirement rows from `specs/038-readiness-verification-corrections/coverage.md`, leaving exactly the 15 rows matching the requirement ids declared in its `spec.md` — done; `completion-coverage.test.sh` now passes `coverage_check` for `038-readiness-verification-corrections`
- [X] T048 [US5] Reconcile Feature 038's four unchecked tasks in `specs/038-readiness-verification-corrections/tasks.md` — either complete the work or state the shortfall in its coverage record, per the `D7.1` condition recorded in `plan.md` — done; every command T030-T033 name (`validate-skill`, `validate-library`, `generate-catalog`, `generate-agent-adapters`, `adapter-coverage`, `distribution-packaging`, `shipped-tree-independence`, `run-all.sh`, `git diff --check`) was independently re-run and confirmed exit 0; recorded in `specs/038-readiness-verification-corrections/coverage.md` under "T030-T033 reconciliation" rather than editing 038's `tasks.md`, per `D5.1`
- [X] T049 [US5] Write `specs/040-historical-coverage-reconstruction/coverage.md` with one row per declared requirement id, marking the four residual requirements honestly rather than `satisfied` — done, but the prediction of four residual requirements did not hold: performing the review itself (all 291 rows across the 18 historical records use `historical` with a uniform non-owner-implying evidence string; zero use `satisfied` or `deferred`) leaves all 12 of Feature 040's own requirements genuinely `satisfied`. Also found and recorded a separate discrepancy: Feature 040's `tasks.md` claims a verified 309-row total; the actual count is 291.
- [X] T050 [US5] Add a note to the Phase 12 section of `governance-plan.md` recording that its Done-when requiring every completed directory from 021 onward to hold a conforming record was not met, **leaving the original Done-when text unchanged** — done: appended a "Note added by Feature 041" paragraph immediately after the existing Done-when list, naming the two gaps (038's header/8 stray rows, 040's missing record) found and fixed by this feature; original Done-when text untouched.
- [X] T051 [US5] Run quickstart Scenarios 9 and 10 from [quickstart.md](quickstart.md) and confirm the header, the row counts, and the preserved original claim — done: `head -3`/`grep -c` on both coverage.md files match expectations (15 rows for 038, 12 for 040), and `grep -n 'Phase 12' governance-plan.md` shows the original Done-when text unchanged with the new note appended below it.

**Checkpoint**: Every registered complete feature holds a conforming record, and the gap this
feature exposed is on the record rather than merely closed.

---

## Phase 8: Polish & Cross-Cutting Concerns

- [X] T052 Run `time bash .highway/tools/tests/run-all.sh` and confirm exit 0 and wall clock under 180s; **if it exceeds 180s, reduce probe scope and record the reduction in `research.md` rather than restating the budget** — done: exit 0, 39 passed, 176.39s wall clock (under the 180s budget); the earlier over-budget readings and the reduction taken are recorded in research.md's Phase 5 section.
- [X] T053 Confirm FR-017 by grepping `.highway/tools/tests/` for any second mechanism deciding completion status or probe validity, and confirm no new script or `lib/` module was added — done: `git status --short .highway/tools/` shows only modifications to existing `.test.sh` files plus one untracked fixtures directory belonging to a different, unrelated feature (039); no new script or `lib/` module was added by this feature, and `D7.2`/`D3.7` remain decided solely by `completion-coverage.test.sh` and `constitution-inventory.test.sh` respectively.
- [X] T054 Confirm FR-018: no edit exists to `.highway/governance/constitution.md` or `.highway/governance/experience-standard.md`, and no file under a completed spec directory other than `coverage.md` was modified — done: `git diff --stat` for both governance files is empty; this feature's own edits are confined to `.highway/tools/tests/*.test.sh`, `.specify/memory/completion-register.md`, `governance-plan.md` (not a completed spec directory), and `specs/041-auto-check-integrity/{tasks.md,research.md}` (this feature's own, still `in-progress`, directory). Unrelated pre-existing uncommitted changes under `specs/001`, `005`, `032`, `033`, `036` predate this feature's work and were not made by it.
- [X] T055 Write `specs/041-auto-check-integrity/coverage.md` with one row per requirement FR-001 through FR-020, marked from the observed evidence rather than from the suite being green — done: all 20 rows written from the specific evidence gathered during Phases 4-8 (probe results, test-file names, exact commands/exit codes), not a blanket "suite is green" claim; row count (20) confirmed to match the requirement count (20) parsed from `spec.md`.
- [X] T056 Update `.specify/memory/completion-register.md` to move `041-auto-check-integrity` from `in-progress` to `complete`, as the last edit of the feature — done: flipped to `complete`; this uncovered a real defect first (its own `coverage.md`'s "satisfied" rows used prose evidence rather than a `path: description` form, tripping `coverage_check`'s satisfying-artifact-exists check), fixed by rewriting the Evidence column to lead with a real file path, then re-verified.
- [X] T057 Run `bash .highway/tools/tests/run-all.sh` a final time and confirm exit 0, satisfying FR-020 — done: exit 0, 39 passed, 175.41s, after the coverage.md fix above.

---

## Dependencies & Execution Order

### Phase dependencies

- **Phase 1 (Setup)** → no dependencies. Must run first; its measurements are unreproducible later.
- **Phase 2 (Foundational)** → depends on Phase 1. **Blocks every user story.**
- **Phase 3 (US1)** → depends on Phase 2.
- **Phase 4 (US3)** → depends on Phase 2. Independent of US1.
- **Phase 5 (US2)** → depends on **Phase 4**, not merely on Phase 2.
- **Phase 6 (US4)** → depends on Phase 3, which creates the register it extends.
- **Phase 7 (US5)** → depends on Phase 3, which widens the scope that makes these records visible.
- **Phase 8 (Polish)** → depends on every preceding phase.

### Why US2 does not come before US3

Both are P1. US2 is the harness that turns `D3.7` on; US3 supplies the probes it will run. Landing
US2 first makes five registered checks fail and leaves `run-all.sh` red for every task afterwards,
which violates `D3.1` — a change must begin from a passing suite — for all of Phase 4, 6 and 7.
This is the same discipline Phases 4c, 11 and 12 applied: **the conformance work lands in the same
change that turns the rule on**, and here it lands slightly before it.

**Consequence for independent delivery**: US2 is not independently shippable ahead of US3. That is a
real dependency, not a scheduling preference, and it is recorded rather than papered over.

### Within-phase notes

- T011 → T012 → T013 → T015 are strictly sequential; all touch the register or its reader.
- T014 precedes T015 deliberately: the reader's zero-match assertion must exist before anything trusts the reader.
- T023–T027 all edit `adapter-coverage.test.sh` and cannot run in parallel.
- T041 → T042 is sequential: the register must carry the eight corrections before the array is deleted, or the check loses them.
- T056 must be the last edit before T057.

---

## Parallel Opportunities

**Phase 1**: T002 runs alongside T001.

**Phase 4**: T021, T022 and T029 touch three different test files and can run together. T023–T028
cannot join them — T023 through T027 share `adapter-coverage.test.sh`.

```text
# Phase 4, safe parallel set
T021  generate-agent-adapters.test.sh
T022  generate-catalog.test.sh
T029  spec-record.test.sh
```

**Phases 6 and 7** are independent of each other once Phase 3 completes, and can proceed in
parallel by different hands — they share no file.

**Phase 5** has no parallel opportunity; T033–T038 all edit `constitution-inventory.test.sh`.

---

## Implementation Strategy

### MVP scope

**Phases 1–3 (US1)**. That alone closes the root defect: a feature can no longer exclude itself from
`D7.2` and `D7.4` through the file those rules read, and the register makes the three ambiguous
directories explicit. It is independently valuable and independently verifiable, and it leaves the
suite green.

### Incremental delivery

1. Phases 1–3 → US1 delivered, suite green.
2. Phase 4 → US3 delivered, five real probes exist, suite green, `D3.7` still reads a comment.
3. Phase 5 → US2 delivered, `D3.7` decides what it claims.
4. Phases 6–7 → US4 and US5 delivered.
5. Phase 8 → runtime and requirement coverage confirmed.

**Every step ends with `run-all.sh` exiting 0.** Step 2 before step 3 is what makes that true.

### The failure mode to design against

Phase 13 of the governance plan names it: *"the realistic failure mode of a change that size is
partial completion with the checkboxes marked — precisely the defect this phase exists to
eliminate, committed in the act of eliminating it."*

Two guards, both structural rather than intentional:

- **T003's count is a number, not a judgment.** If it is not five, the measured number is recorded.
- **T031 and T018 require an observed failing message**, so a task cannot be ticked on the strength
  of the suite being green.
