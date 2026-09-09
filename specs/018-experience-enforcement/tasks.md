# Tasks: Enforce the Experience Standard

**Feature**: 018-experience-enforcement | **Date**: 2026-09-08

**Input**: [spec.md](spec.md), [plan.md](plan.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/merged-inventory.md](contracts/merged-inventory.md), [quickstart.md](quickstart.md)

**Tests**: This feature modifies validation tooling, so `D3.4` applies to every new check —
evaluate against all fixtures before enabling, and observe each failing before trusting it.

---

## Phase 1: Setup & Baseline

- [X] T001 Run `.highway/tools/tests/run-all.sh` and record the pass count; 0 failed before any edit, per `D3.1`
- [X] T002 Record the current coverage summary for both skills, so the change in group membership can be stated exactly
- [X] T003 [P] Record `validate-library.sh`'s current verdict on the questionnaire template, as the before-state for the scoping proof in T014

---

## Phase 2: Foundational — the loader reads both documents

**Purpose**: This alone delivers User Story 1's inventory. Research R5 confirmed the grouping logic
needs no change: once `X` rules are returned, `[agent-checkable]` ones land in `DEFERRED`.

**⚠️ No check may be registered until T009 is complete.**

- [X] T004 Widen the rule-id pattern in `.highway/tools/lib/constitution.sh` so `con_rules()` accepts `X` as well as `P`. Do not change its signature — it already takes the document as an argument
- [X] T005 Make `.highway/tools/validate-skill.sh` iterate a declared list of governance documents, loading the Skills Constitution and the Experience Standard
- [X] T006 Leave `.highway/tools/validate-library.sh` loading the Skills Constitution only, and state that scoping decision in a comment where the list is declared — library content emits nothing, so `X` rules must never reach it
- [X] T007 Confirm all eight `X` rules now appear in the coverage summary for both skills, all in `DEFERRED`, with `UNCHECKED` still empty
- [X] T008 Confirm every existing caller that passes a single document behaves identically, per `FR-003`
- [X] T009 **Prove the library validator is unaffected**: run it against the questionnaire template and confirm zero `X` rule ids in its output, matching the before-state from T003

**Checkpoint**: Every `X` rule is inventoried. No check has been written yet.

---

## Phase 3: User Story 1 — No X rule can silently go unenforced (P1)

**Goal**: The inventory test asserts every `X` rule lands in exactly one coverage group.

**Independent test**: Add a rule to the standard without accounting for it; the suite fails.

- [X] T010 [US1] Extend `.highway/tools/tests/constitution-inventory.test.sh` to cover the Experience Standard, asserting every `X` rule appears in exactly one coverage group
- [X] T011 [US1] Add the **vacuity assertion**: the test fails if its reader matched no rule from a document it claims to cover. Feature 014's first extended guard passed while iterating nothing, and this feature modifies that same parser
- [X] T012 [US1] Make each failure name the offending rule and the document it came from
- [X] T013 [US1] **Proof V1** — break the rule-id pattern so it matches nothing, confirm the test fails citing that it matched no rules, restore, confirm it passes. A guard that cannot detect its own vacuity is worth nothing
- [X] T014 [US1] **Proof V2** — append a rule to the standard tagged `[auto]` with no registered check, confirm the test fails naming it, remove it, confirm it passes

**Checkpoint**: A rule added to the standard cannot be ignored.

---

## Phase 4: User Story 2 — The automatable rules are decided automatically (P1)

**Goal**: Where a script can honestly decide a rule, it does, reported under its own rule id.

**⚠️ The count here is measured, not targeted. Research R3 assessed it at one, plus one partial.**

### The added rule

- [X] T015 [US2] Add one rule to `.highway/governance/experience-standard.md` in the `X1` family: a specimen agrees with the metadata it repeats. Observable: every value the Example shares with the skill's frontmatter matches it. Tier `[auto]`
- [X] T016 [US2] Record the amendment as MINOR, `1.0.0 → 1.1.0`, with its reasoning and a restatement review against the `P` and `D` inventories
- [X] T017 [US2] Update the standard's rule count, tier counts, and the note stating no rule carries `[auto]` — that claim is now false and must be corrected rather than left standing

### Repair before enabling

- [X] T018 [US2] Repair `highway-help`'s Example: it shows `Version: 3.0.1` against a frontmatter of `3.0.2`, drift introduced by feature 017. Repair precedes enabling, per `FR-020` and the ordering lesson feature 016 recorded
- [X] T019 [US2] Confirm no other specimen disagrees with its metadata before the check is enabled, so the amendment stays MINOR rather than MAJOR

### The check

- [X] T020 [US2] Pre-evaluate the new check against every existing fixture and record each expected verdict before wiring it in, per `D3.4`
- [X] T021 [US2] Register the check in `.highway/tools/lib/rule-checks.sh` alongside the `P` checks, with an `N/A` condition for a skill whose Example repeats no metadata value
- [X] T022 [US2] **Proof C1** — set the Example version to a wrong value, confirm the validator fails naming the rule id, the field, and both values; restore; confirm it passes
- [X] T023 [US2] **Proof C2** — confirm `highway-inquiry` records `N/A` rather than failing, since its Example repeats no metadata value
- [X] T024 [US2] Confirm the rule now appears under `CHECKED` or `FAILED`, never `UNCHECKED`, for both skills

**Checkpoint**: One rule is genuinely enforced, and it earned the tag.

---

## Phase 5: User Story 3 — A specimen check for emitted shape (P2)

**Goal**: Where a skill's Outputs section declares labelled fields, its Example is checked against
that declaration.

**⚠️ Evidence-dependent. Research R3 rated this partial. If it cannot be made to fail meaningfully,
do not ship it — a check that passes everything occupies a rule id and reports `CHECKED` falsely.**

- [X] T025 [US3] Determine whether the shape a skill's Outputs section declares can be extracted mechanically for `highway-help`'s labelled field block, and record the finding
- [X] T026 [US3] If extractable, write the check comparing the Example's labels and their order against the declaration; record `N/A` where the Outputs section declares a file shape rather than fields
- [X] T027 [US3] Pre-evaluate against every fixture before enabling, per `D3.4`
- [X] T028 [US3] **Proof S1** — remove a declared field from the Example, confirm the check fails naming it, restore, confirm it passes
- [X] T029 [US3] **Decision point** — if the check cannot be made to fail on a genuine defect, abandon it, leave the rule `[agent-checkable]`, and record why. Shipping it anyway is prohibited by `FR-010`

**Checkpoint**: Either a second rule is honestly enforced, or it is honestly not.

---

## Phase 6: User Story 4 — Each skill names its declared coverage (P2)

**Goal**: The rules no script decides are claimed at a named place.

- [X] T030 [US4] Add to `.highway/skills/highway-help/SKILL.md` Verification section the `X` rules its self-check exercises
- [X] T031 [US4] Add the same to `.highway/skills/highway-inquiry/SKILL.md`
- [X] T032 [US4] Confirm every named id exists in the standard and no skill claims a rule its self-check does not exercise
- [X] T033 [US4] Increment both skills' versions, classified against the Skill Versioning Policy — PATCH expected
- [X] T034 [US4] Validate both skills, watching `P7.5` — the Verification sections gain a line
- [X] T035 [US4] **Discharge the Correspondence Gate**: regenerate the catalog and all adapters, per `D4.7`, then confirm `adapter-coverage.test.sh` reports no stale artifact

---

## Phase 7: Polish & Cross-Cutting

- [X] T036 [P] Confirm `UNCHECKED` is empty for both skills, per `FR-013`
- [X] T037 [P] Confirm no second enforcement mechanism was introduced — the rule-check library remains the only one, per `FR-009`
- [X] T038 **Report the automated count as measured**, per `SC-002`: state how many `X` rules a script decides and how many remain `[agent-checkable]`, without adjusting a check to improve the figure
- [X] T039 Confirm every rule in the standard is decided by a script, a specimen, or a named self-check, and that a reader can tell which, per `SC-006`
- [X] T040 Run the full suite twice; both pass and the tree is unmodified after each
- [X] T041 Walk [quickstart.md](quickstart.md) end to end and correct any step whose expected output differs from actual
- [X] T042 Update `governance-plan.md`: mark Phase 6 complete with the task count, the measured automated count, and the findings worth carrying into Phase 7

---

## Dependencies

```text
Phase 1 (Setup)
      │
      ▼
Phase 2 (Loader) ──── delivers the inventory; blocks all check registration
      │
      ├──────────────┬───────────────┐
      ▼              ▼               ▼
Phase 3 (US1)   Phase 4 (US2)   Phase 6 (US4)
                     │
                     ▼
               Phase 5 (US3)  ── evidence-dependent; may end in abandonment
                     │
                     ▼
              Phase 7 (Polish)
```

**Critical path**: T004 → T005 → T009 → T010 → T013.

**Why Phase 2 blocks check registration**: a check registered before the loader returns `X` rules
would never run, and would report nothing while appearing to work.

**Why T018 precedes T021**: enabling a rule against a tree that violates it is a strengthening,
which the versioning policy classifies MAJOR. Repairing first keeps the amendment MINOR.

**Why Phase 5 can end in abandonment**: its value depends on a finding not yet made. T029 makes
stopping an explicit, recorded outcome rather than a quiet omission.

## Parallel Opportunities

| Tasks | Why parallel-safe |
|---|---|
| T003 with T001–T002 | Reads a different validator, writes nothing |
| Phase 6 with Phases 3–5 | Touches skill files rather than tooling |
| T036 with T037 | Independent reads |

## Implementation Strategy

**MVP**: Phases 1, 2 and 3. That delivers the inventory — every `X` rule accounted for, and a
guard that fails when one is not. Research R5 established this needs no check written at all, which
makes it both the smallest and the most durable slice.

**Then**: Phase 4 adds the one rule that earns automatic enforcement. Phase 6 covers the rest by
declaration. Phase 5 is genuinely optional.

**The failure this list is shaped to avoid**: a feature named "enforce" that reports six rules
`CHECKED` on the strength of proxies that cannot fail. T013 proves the guard is not vacuous, T029
permits abandoning a weak check, and T038 requires the count to be reported as measured. Every one
of those exists because this repository has produced the opposite at least once — feature 013's
checks reported every fixture passing while the program failed to run, and feature 014's guard
passed without iterating a single rule.

## Task Summary

| Phase | Tasks | Story |
|---|---|---|
| 1 Setup | T001–T003 | — |
| 2 Loader | T004–T009 | — |
| 3 Inventory | T010–T014 | US1 (P1) |
| 4 Automated rule | T015–T024 | US2 (P1) |
| 5 Specimen shape | T025–T029 | US3 (P2) |
| 6 Declared coverage | T030–T035 | US4 (P2) |
| 7 Polish | T036–T042 | — |

**Total**: 42 tasks. Six are failure proofs — T013, T014, T022, T023, T028 and T009 — and one,
T029, is permission to stop.
