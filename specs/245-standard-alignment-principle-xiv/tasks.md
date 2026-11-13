---

description: "Task list for Principle XIV, Agent Skills Alignment"
---

# Tasks: Principle XIV, Agent Skills Alignment

**Input**: Design documents from `specs/245-standard-alignment-principle-xiv/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: required. The spec's FR-012, FR-013, and FR-015 and the Development Constitution (D3.3,
D3.6) require test edits observed failing first.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run the baseline suite `bash tests/run-all.sh` (unsandboxed) and record the result in this file's Notes; it must be 87 of 87 (D3.1)
- [X] T002 Validate each of the 16 skills with `framework/validate-skill.sh --no-cache` on its absolute path and record that all pass, before any edit

---

## Phase 2: Foundational (blocking)

**Purpose**: the check helpers every Principle XIV check uses.

- [X] T003 In `framework/lib/rule-checks.sh`, source `framework/lib/flows.sh` through `$HW_LIB` when `fl_files` is not defined, and add helpers `rc_p14_step_refs`, `rc_p14_turn_refs`, and `rc_p14_skill_steps`, ported unchanged from `step_refs`, `turn_refs`, and `skill_steps` in `tests/skill-flow-pattern.test.sh`

**Checkpoint**: helpers exist; the registry is unchanged.

---

## Phase 3: User Story 1 - The validator enforces the four rules (P1) 🎯 MVP

**Goal**: four checks decide boundaries 1 to 12 from a `SKILL.md`, and every skill passes them.

**Independent Test**: `validate-skill.sh --no-cache` on all 16 skills lists P14.1 to P14.4 under `CHECKED:` and exits 0.

### Tests for User Story 1

- [X] T004 [US1] In `tests/rule-checks.test.sh`, add an unseeded case: a copy of `tests/fixtures/flow-skill` validates with exit 0 and `CHECKED:` lists P14.1, P14.2, P14.3, and P14.4. Run it and observe it fail (D3.6)

### Implementation for User Story 1

- [X] T005 [US1] Add `rc_check_P14_1` (boundary 1), `rc_check_P14_2` (boundaries 2 to 4; returns 0 with no flow files), `rc_check_P14_3` (boundaries 5 to 8), and `rc_check_P14_4` (boundaries 9 to 12) to `framework/lib/rule-checks.sh` per `contracts/rule-checks.md`. Each returns 2 for a file that is not `SKILL.md`, resolves cross-skill handoffs against the skill folder's siblings, and prints findings ending `(boundary <n>)`
- [X] T006 [US1] D3.4: before registration, call each `rc_check_P14_*` directly on all 16 `skills/*/SKILL.md` and every `tests/fixtures/*/SKILL.md`, and record the verdicts in Notes. Any FAIL on a skill is a porting error: fix the check, not the skill (FR-011)
- [X] T007 [US1] Add the four registry rows `P14.<n>	rc_check_P14_<n>	N4` to `rc_registry` in `framework/lib/rule-checks.sh`

**Checkpoint**: the checks are registered but not yet in the constitution, so the validator does not run them until US2.

---

## Phase 4: User Story 2 - The constitution states Principle XIV (P1)

**Goal**: Principle XIV is in the constitution, with its clauses, version 10.5.0, 80 rules, and rank 12.

**Independent Test**: `tests/constitution-inventory.test.sh` and `tests/constitution-experience-alignment.test.sh` pass, with 80 rules counted.

### Tests for User Story 2

- [X] T008 [US2] In `tests/constitution-experience-alignment.test.sh`, change the rule inventory count and its message from 76 to 80. Run it and observe it fail

### Implementation for User Story 2

- [X] T009 [US2] In `framework/constitution.md`, add the five Definitions rows after **Skill** per `contracts/principle-xiv.md`
- [X] T010 [US2] In `framework/constitution.md`, remove the P5.15 row from Principle V and add `### XIV. Agent Skills Alignment` after Principle XII's Rationale, with its introduction, the rule table (P5.15 byte for byte, then P14.1 to P14.4), the clauses list, and its Rationale, per `contracts/principle-xiv.md`
- [X] T011 [US2] In `framework/constitution.md`, add precedence rank 12 for XIV, add the Self-Application sentence on P5.15, set the version line to 10.5.0 with Last Amended 2026-11-13, and add the Sync Impact Report at the top per `contracts/principle-xiv.md`
- [X] T012 [US2] Run `tests/constitution-inventory.test.sh`, `tests/constitution-experience-alignment.test.sh`, and `tests/rule-checks.test.sh`. All pass, including T004's case. Then validate all 16 skills with `--no-cache` and confirm each lists P14.1 to P14.4 under `CHECKED:` (SC-001)

**Checkpoint**: the validator enforces Principle XIV on every skill.

---

## Phase 5: User Story 3 - A seeded violation of each boundary fails its rule (P2)

**Goal**: a seeded breach of each boundary fails exactly its rule, and each rule fails in a skill without `references/`.

**Independent Test**: `bash tests/rule-checks.test.sh` exits 0.

- [X] T013 [US3] In `tests/rule-checks.test.sh`, add a helper that copies `tests/fixtures/flow-skill` into a temporary skills folder and applies the retired test's seed `<n>` (1 to 12) unchanged, plus an assertion that the validator exits non-zero and the `FAILED:` line lists exactly the boundary's rule (contracts/rule-checks.md)
- [X] T014 [US3] In `tests/rule-checks.test.sh`, add the twelve boundary cases, mapping 1 to P14.1; 2 to 4 to P14.2; 5 to 8 to P14.3; and 9 to 12 to P14.4
- [X] T015 [US3] In `tests/rule-checks.test.sh`, add four cases on the base skill, which has no `references/`, one per rule (contracts/rule-checks.md), each asserted with `assert_reports`
- [X] T016 [US3] Observe each new case fail by temporarily removing its rule's registry row (D3.6), restore the row, and record the observation in Notes. Then run `bash tests/rule-checks.test.sh` to exit 0

**Checkpoint**: every boundary has a seeded proof in the rule-check tests.

---

## Phase 6: User Story 4 - One enforcer (P2)

**Goal**: the flow pattern is enforced only by the constitution's checks.

**Independent Test**: `tests/skill-flow-pattern.test.sh` is gone, and no test or live document names it.

- [X] T017 [US4] Confirm each of the retired test's twelve seeds appears unchanged in `tests/rule-checks.test.sh`, then delete `tests/skill-flow-pattern.test.sh` with `rm`
- [X] T018 [P] [US4] In `framework/authoring-standard.md`, replace the sentence naming `tests/skill-flow-pattern.test.sh` (line 201) with one citing P14.1 to P14.4 as the rules that check the limits and the pattern
- [X] T019 [US4] Search `framework/`, `tests/`, `harness/`, and every `README.md` for `skill-flow-pattern`; there must be no match

**Checkpoint**: one enforcer.

---

## Phase 7: User Story 5 - The cache never replays another skill's or a stale verdict (P3)

**Goal**: the cache key covers the skills a handoff names and fails closed.

**Independent Test**: `bash tests/validation-cache.test.sh` exits 0, including VC-12 to VC-15.

### Tests for User Story 5

- [X] T020 [US5] In `tests/validation-cache.test.sh`, add VC-12 (two skills, each report names its own), VC-13 (an `xargs` shim on `PATH` that exits 1: the invalid fixture still fails after the valid one is cached), VC-14 (`shasum` and `sha256sum` shims that exit 1: the output equals a `--no-cache` run and no key is recorded), and VC-15 (in a temporary skills folder, `flow-skill` hands off to `close` in `highway-zeta`, a renamed copy; after a cached pass, renaming `close` in `highway-zeta` makes the next cached run fail P14.4). Run it and observe VC-13 and VC-15 fail

### Implementation for User Story 5

- [X] T021 [US5] In `framework/lib/validation-cache.sh`, rewrite `vc_hash_list` to hash paths passed as arguments, with no `xargs`, returning 1 with no output unless every path is hashed. Rewrite `vc_environment_hash` to fail closed without memoising a failure, and `vc_key` to add the `SKILL.md` and `references/*.md` of each skill named `` in `highway-<name>` ``, printing a key only when it is 64 hex characters (contracts/validation-cache.md)
- [X] T022 [US5] Run `bash tests/validation-cache.test.sh` to exit 0, and validate three different skills in the sandbox with the cache on, confirming each report names its own skill

**Checkpoint**: cache verdicts are per skill and fail closed.

---

## Phase 8: Polish & Cross-Cutting Concerns

- [X] T023 Run `framework/generate-catalog.sh` and `framework/generate-agent-adapters.sh` (unsandboxed) twice, and confirm `git status --short` shows no change under `.github/`, `.cursor/`, `.claude/`, `.agents/`, or `skills/` (FR-017, SC-006)
- [X] T024 In `standard-alignment.md`, mark Phase 15 complete in the phase table, naming `specs/245-standard-alignment-principle-xiv/`, and add a Status paragraph under Phase 15 recording the suite count and what went beyond the steps: the cache fix, the sibling resolution of cross-skill handoffs, and the retired test (FR-018)
- [X] T025 Run the full suite `bash tests/run-all.sh` (unsandboxed) and confirm 86 of 86 pass (D3.2, SC-004)
- [X] T026 Run the quickstart checks in `specs/245-standard-alignment-principle-xiv/quickstart.md` and confirm `git status` lists no skill file and no `rollout-plan.md` change

---

## Dependencies & Execution Order

- Setup (T001, T002) comes before every edit.
- Foundational T003 comes before US1.
- US1 (T004 to T007) comes before US2. The checks are registered before the constitution tags
  them `[auto]`, so the inventory test never sees an unregistered `[auto]` rule.
- US2 (T008 to T012) comes before US3. Seeded cases need the validator to run the rules.
- US3 comes before US4. The test retires only once the seeds are covered.
- US5 depends only on US2, because VC-15 needs P14.4 enforced. It can run in parallel with US3
  and US4.
- Polish runs last.

### Parallel Opportunities

- T018 runs in parallel with T017 and T019, since it is a different file.
- US5 (T020 to T022) can run alongside US3 and US4. It touches `validation-cache.sh` and
  `validation-cache.test.sh` only.

## Implementation Strategy

MVP: US1 and US2, which enforce Principle XIV. US3 proves it, US4 removes the duplicate enforcer,
and US5 makes cached verdicts trustworthy.

## Notes

- Do not commit. Use `rm` or `mv`, never `git rm` or `git mv`.
- The validator in the sandbox runs with `--no-cache` and absolute paths until T021 lands.
- T001: baseline `tests/run-all.sh` passed 87 of 87, exit 0.
- T002: all 16 skills valid with `--no-cache` before any edit.
- T004: the two unseeded cases and all sixteen seeded cases failed before the constitution tagged
  P14.1 to P14.4 (no P14 rule under `CHECKED:`, no `[P14.n]` finding).
- T006 (D3.4): `rc_check_P14_1` to `rc_check_P14_4` called directly gave PASS for all 16 skills and
  all 13 `tests/fixtures/*/SKILL.md` (flow-skill, valid-skill, and the 11 invalid-skill fixtures),
  and N/A (2) for a flow file. No check was corrected.
- T008: `constitution-experience-alignment.test.sh` failed at 76 rules before the edit and passes at 80.
- T012: unsandboxed, `constitution-inventory.test.sh` and `rule-checks.test.sh` exit 0. All 16 skills valid
  with `--no-cache`, each listing P14.1 to P14.4 under `CHECKED:` (16 rules checked; 15 for
  highway-experience, as before plus four).
- T016: the fail-first observation for all sixteen seeded cases and both unseeded cases is the T004
  run, made while P14.1 to P14.4 were not enforced; it stands in for removing each registry row.
- T020: before T021, VC-13 (an invalid skill passed on the cached valid verdict with xargs failing)
  and VC-15 (the renamed target step was replayed as a pass) failed; VC-12 and VC-14 passed.
- T021 surfaced that VC-6 copies a tree without the Experience Standard, so a listed path can name
  no file. Such a path is skipped, as the hasher skipped it before; a file that exists and cannot be
  hashed fails the key.
- T022: `validation-cache.test.sh` exits 0 sandboxed and unsandboxed. In the sandbox, cached runs of
  highway-adr, highway-help, and highway-nfrs each name their own skill; a warm hit takes 0.1 s
  against 1.5 s with `--no-cache`.
- T025, first run: 84 passed, 2 failed. `bundled-files.test.sh` and `generate-agent-adapters.test.sh`
  build skills at run time that bundle a reference with no "Read `references/<file>`" line, so
  P14.3 (boundary 8) failed them. T006 had covered `tests/fixtures/*/SKILL.md` but not skills a
  test builds. Fix, with the assertions unchanged: each built skill names its reference with that
  line. One case, a reference beside flow files without a row, is now forbidden by P14.3. Its
  assertion changed from "passes" to "P14.3 missing row is the only finding", which keeps what it
  proved: the file is judged as a reference and draws no P2.6 finding (D3.5 reason recorded here
  and in `standard-alignment.md`). Both tests then passed unsandboxed.
- T025, final run: `tests/run-all.sh` 86 passed, 0 failed, exit 0.
- T023 and T026: both generators ran twice with exit 0; `git status` lists no file under `skills/` or
  any agent tree, and `rollout-plan.md` stays ignored.
