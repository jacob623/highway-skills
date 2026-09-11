# Tasks: Specification-Record Governance Removal

**Input**: Design documents from `/specs/044-spec-governance-removal/`
**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md),
[data-model.md](./data-model.md), [contracts/removal-inventory.md](./contracts/removal-inventory.md),
[quickstart.md](./quickstart.md)

**Tests**: Not requested. This feature removes tests rather than adding them; verification is by
running the existing suite and by the inline checks below, per quickstart.md.

**Organization**: Tasks are grouped by user story from spec.md to enable independent verification.
Ordering inside Foundational is a correctness constraint, not a convenience — see research.md §5:
Enforcement Map rows must be removed before the test files they name, or `constitution-inventory`
fails against a missing file.

## Phase 1: Setup

- [X] T001 Record the `D3.1` baseline: run `.highway/tools/tests/run-all.sh` three times, log exit
      code and wall-clock seconds each run, into `/tmp/044-baseline-runall.log`. Per
      quickstart.md "Before you start".
- [X] T002 Record the `validate-skill.sh` rule-to-skill decision baseline (expected 93 of 480) into
      `/tmp/044-baseline-coverage.log`, with the exact command used alongside the number.
- [X] T003 Obtain and record the `D3.5` human sign-off on removing
      `.highway/tools/tests/completion-coverage.test.sh`, `spec-record.test.sh` and
      `feature-038-plan.test.sh`, using the per-test verdicts in
      [research.md](./research.md) §2. Do not proceed past T010 without it.

**Checkpoint**: Baseline captured, sign-off obtained. Nothing has been edited yet.

## Phase 2: Foundational (blocking prerequisites)

**Purpose**: Relocate the two surviving rules and remove the Enforcement Map rows before any rule
text or test file is touched, per the dependency chain in data-model.md ("Relationships").

- [X] T004 In `.specify/memory/constitution.md`, relocate `D5.3` (Rule and Observable
      byte-identical) from `### V. Specification Record Integrity` into
      `### III. Verification Before and After`. Per contracts/removal-inventory.md §B.
- [X] T005 In `.specify/memory/constitution.md`, relocate `D7.3` (Rule and Observable
      byte-identical) from `### VII. Completion Integrity` into
      `### III. Verification Before and After`. Per contracts/removal-inventory.md §B.
- [X] T006 Verify both relocations: `grep -c '^| D5\.3 |' .specify/memory/constitution.md` and
      `grep -c '^| D7\.3 |' .specify/memory/constitution.md` each return 1, and each still contains
      its original Rule/Observable text unchanged.
- [X] T007 In `.specify/memory/constitution.md`, remove the four Enforcement Map rows for `D5.4`,
      `D5.5`, `D7.2`, `D7.4`. Per contracts/removal-inventory.md §D. Do not remove the rule rows or
      test files yet.
- [X] T008 Run `.highway/tools/tests/run-all.sh` and confirm exit 0. This is the isolated
      verification point called out in plan.md — no Enforcement Map row has been removed before, and
      `constitution-inventory.test.sh` derives its work from that map. If this fails, stop and
      diagnose here rather than proceeding.
      **Correction discovered during execution**: this failed as predicted in plan.md's Risks
      section — `constitution-inventory.test.sh` fails once the Enforcement Map rows are gone but
      the rules are still tagged `[auto]`, because the two removals cannot be sequenced
      independently. Fixed by performing T010 (rule removal) immediately before re-running the
      suite, i.e. T007 and T010 landed as one atomic edit. Re-verified passing at T016.
- [X] T009 Record `constitution-inventory.test.sh`'s new timing from the T008 run, for comparison
      against the 97.2s baseline in research.md §1.1.

**Checkpoint**: Map shrunk from 13 to 9 rows, suite green, two rules safely relocated. Foundation is
ready for rule removal and record closure to proceed independently.

## Phase 3: User Story 1 - The development constitution governs only what ships (Priority: P1) 🎯 MVP

**Goal**: No remaining rule's Observable names a `specs/`-tree artifact or the completion register.

**Independent Test**: Read the amended constitution; confirm no rule's Observable names a feature
directory, coverage record, `spec.md`/`plan.md`/`tasks.md`, or the completion register, and that
`D1.1`/`D1.2` are untouched.

- [X] T010 [US1] In `.specify/memory/constitution.md`, remove rules `D5.1`, `D5.2`, `D5.4`, `D5.5`,
      `D7.1`, `D7.2`, `D7.4`, `D7.5`. Per contracts/removal-inventory.md §A. Requires the T003
      sign-off.
- [X] T011 [US1] In `.specify/memory/constitution.md`, remove the now-empty
      `### V. Specification Record Integrity` and `### VII. Completion Integrity` sections,
      including their rationale paragraphs. Per contracts/removal-inventory.md §C.
      Also removed (discovered during implementation, not itemized in the contract): the orphaned
      "Completed spec" Definitions row, Principle Precedence ranks 5/7, and the "Spec Record Gate"
      Quality Gate row — each named a rule or concept this task just removed.
- [X] T012 [US1] In `.specify/memory/constitution.md`, bump the version `1.6.0` → `2.0.0` (MAJOR,
      per the document's own Versioning Policy — a principle is removed) and write the amendment
      entry: removed rule ids, relocated rule ids, new rule count (30), new tier counts, and the
      self-application review against `D1.3`, `D1.4`, `D5.3`. Per contracts/removal-inventory.md §E.
      Do not edit any existing version-history entry.
- [X] T013 [P] [US1] In `.highway/tools/tests/run-all.sh`, remove `feature-038-plan.test.sh` from
      the skip `case` statement and from the ordered tail list.
- [X] T014 [P] [US1] In `.highway/tools/tests/feature-038-evidence-report.sh`, remove the
      `feature-038-plan.test.sh` invocation from the `static contract` category. Leave
      `feature-038-helpers.sh` untouched — `readiness-executable.test.sh` and
      `highway-setup-executable.test.sh` both source it. Per research.md §6.
- [X] T015 [US1] Delete `.highway/tools/tests/completion-coverage.test.sh`,
      `.highway/tools/tests/spec-record.test.sh`, `.highway/tools/tests/feature-038-plan.test.sh`.
      Depends on T013 and T014 being complete first.
- [X] T016 [US1] Run `.highway/tools/tests/run-all.sh` and confirm exit 0 with 36 tests reported
      where there were 39. **Correction**: the planning-time count of "43 → 40" was wrong; the
      measured actual is 39 → 36 (`ls .highway/tools/tests/*.test.sh | wc -l`). Result: exit 0,
      36 passed, 0 failed, 179s.
- [X] T017 [US1] Verify no dangling reference:
      `grep -rn 'completion-coverage\|spec-record\|feature-038-plan' .highway/ .specify/` returns no
      output.
- [X] T018 [US1] Verify SC-001 through SC-004: no surviving rule's Observable names a `specs/`
      artifact; the Enforcement Map holds 9 rows and every named file exists; `D5.3`/`D7.3` are
      byte-identical to pre-change text; `D1.1`/`D1.2` are byte-identical to pre-change text.

**Checkpoint**: The development constitution governs only shipped files. This is independently
verifiable and independently valuable even if US2 and US3 were never done.

## Phase 4: User Story 2 - Feature 042 is recorded complete and Feature 043 is withdrawn (Priority: P1)

**Goal**: Close both features in the same change that removed their shared subject.

**Independent Test**: Feature 042's register row reads `complete`, its coverage record is unchanged,
and Feature 043's spec Status reads `Withdrawn` naming Feature 044.

- [X] T019 [US2] Rewrite the header of `.specify/memory/completion-register.md` so it no longer
      asserts that `D7.2`, `D7.4` or `D7.5` read it, and states plainly that it is a
      maintainer-kept index no check consumes. Add `withdrawn` to the stated `Status` vocabulary.
      Per FR-018, FR-019.
- [X] T020 [US2] In `.specify/memory/completion-register.md`, change the
      `042-probe-reachability-correction` row's status to `complete`.
- [X] T021 [US2] In `.specify/memory/completion-register.md`, change the
      `043-corrective-provenance-honesty` row's status to `withdrawn`.
- [X] T022 [US2] In `specs/043-corrective-provenance-honesty/spec.md`, change only the `**Status**`
      line from `Draft` to `Withdrawn`, naming Feature 044 and stating that its subject —
      `correction_check` and `D7.5` — no longer exists. Change nothing else in the file.
- [X] T023 [US2] Verify Feature 042's coverage record is unchanged: 27 rows `satisfied`, 0 rows
      `deferred`, via
      `grep -cE '^\| FR-[0-9]+ \| satisfied \|' specs/042-probe-reachability-correction/coverage.md`
      and the same for `deferred`.
- [X] T024 [US2] Verify Feature 043's requirement count is unchanged (17 FRs) via
      `grep -c '^- \*\*FR-' specs/043-corrective-provenance-honesty/spec.md`, and that its directory
      and clarifications are otherwise intact.
- [X] T025 [US2] Run `.highway/tools/tests/run-all.sh` and confirm exit 0 with Feature 042's row
      `complete`. Result: exit 0, 36 passed, 0 failed, 182s.

**Checkpoint**: Both blocked features are closed honestly — 042 by removing the obstruction, 043 by
recording that its subject is gone.

## Phase 5: User Story 3 - The removal is recorded as a scope decision, not disguised as an improvement (Priority: P1)

**Goal**: A later reader cannot mistake this deletion for tests being dropped because they were
inconvenient.

**Independent Test**: research.md names each removed test, the rules it decided, the behaviour that
becomes unchecked, states the reason is scope rather than weakness, carries an explicit `D3.5`
verdict, and the completion report separates the measured runtime from any justification.

- [X] T026 [US3] Confirm [research.md](./research.md) §2 already names, per removed test: the rules
      it decided, the behaviour that becomes unchecked, and why that behaviour no longer matters.
      No further edit expected — this task is a verification that the design artifact satisfies the
      requirement, not new authoring.
- [X] T027 [US3] Confirm research.md §2.4 carries the `D3.5` verdict obtained in T003, stating the
      reason is scope departure and not test weakness, and naming the two self-critical facts (the
      042 unblocking incentive, and the rejected runtime justification).
- [X] T028 [US3] Draft the completion report's runtime section: state the T001 before-measurement and
      a fresh after-measurement (three runs, reported as a range) as a **measured side effect**, and
      explicitly do not present it as the reason for the change. Per FR-022.
      Written as research.md §8: before 201s/217s/202s, after 179s/182s/177s, coverage ratio
      unchanged at 93/480.

**Checkpoint**: The record of *why* survives independently of the deletion itself.

## Phase 6: Polish & Cross-Cutting Concerns

- [X] T029 Re-measure the `validate-skill.sh` rule-to-skill decision count and confirm it is
      unchanged at 93 of 480 against the T002 baseline (SC-010). A different number means an
      unintended edit occurred — investigate before reporting complete.
      Result: 93/480, unchanged.
- [X] T030 Work through every line of contracts/removal-inventory.md §J (Verification checklist) and
      confirm each is satisfied.
- [X] T031 [P] Confirm `governance-plan.md` contains no active or deferred phase whose subject is the
      `specs/` tree (FR-023) — already amended in the prior session; this is a final re-check.
      Confirmed: Phases 7, 8, 9, 14, 17 remain; none governs the specs/ tree. Phase 14 references
      the two now-deleted test files in its cost breakdown — flagged to the user as stale content
      for whoever scopes that phase next; out of this feature's task scope to rewrite.
- [X] T032 Update `.specify/memory/completion-register.md` to mark
      `044-spec-governance-removal` `complete`, and run `.highway/tools/tests/run-all.sh` one final
      time to confirm exit 0 (`D3.2`). Result: exit 0, 36 passed, 0 failed, 175s.

---

## Dependencies & Execution Order

- **Setup (T001–T003)** blocks everything — the baseline and sign-off must exist first.
- **Foundational (T004–T009)** blocks all three user-story phases — it is the shared relocation
  and Enforcement Map shrink every later phase depends on.
- **User Story 1 (T010–T018)** must complete before User Story 2, because US2's register-header
  rewrite (T019) asserts that the rules removed in T010 no longer read the register.
- **User Story 2 (T019–T025)** depends on US1.
- **User Story 3 (T026–T028)** depends only on Foundational and on the sign-off from T003; it can run
  in parallel with US1/US2 since it verifies design artifacts rather than editing code, but is
  ordered last here because its final task (T028) needs a post-change runtime sample.
- **Polish (T029–T032)** requires all of US1, US2 and US3 complete.

Within Phase 3, T013 and T014 are marked `[P]` — different files, no dependency on each other — but
both must precede T015.

## Implementation Strategy

**MVP = User Story 1 alone.** It is independently valuable: even without closing 042/043, a
constitution that governs only shipped files is the stated goal of this feature. User Stories 2 and
3 depend on US1 having landed and are not separable from it in practice, since US2's register rewrite
references rules US1 removes — but each still has its own independent test per spec.md, and each
checkpoint above can be verified in isolation before proceeding.

Recommended order: Setup → Foundational → US1 → US2 → US3 → Polish, matching the plan.md ten-step
sequence, because the Enforcement Map / rule-removal ordering constraint in research.md §5 is real
and reordering risks a suite failure whose cause is then harder to isolate.
