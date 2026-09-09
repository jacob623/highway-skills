# Tasks: Repository Controls

**Feature**: 019-repository-controls | **Date**: 2026-09-08

**Input**: [spec.md](spec.md), [plan.md](plan.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/controls-skill.md](contracts/controls-skill.md), [quickstart.md](quickstart.md)

**Tests**: One new test for the containment boundary. The skill itself is Markdown and is decided
by the validator, not by a new harness.

---

## Phase 1: Setup & Baseline

- [X] T001 Run `.highway/tools/tests/run-all.sh` and record the pass count; 0 failed before any edit, per `D3.1`
- [X] T002 Record the working tree state with `git status --porcelain`
- [X] T003 [P] Record the current `MUST`-level counts for both existing skills, as the reference point for the `P7.4` budget this feature must stay inside

---

## Phase 2: Foundational — the containment boundary

**Purpose**: The boundary must exist before anything writes user content, not after. This is the
requirement that was not in the original draft and is the reason the location decision holds.

**⚠️ No Control may be written until T009 is complete.**

- [X] T004 Pre-evaluate the tightened path rule against every library fixture and record each expected verdict before changing anything, per `D3.4`
- [X] T005 Change `.highway/tools/validate-library.sh` to decline any file outside its **framework root**. Scope to `.highway/`, **not** to `.highway/library/` — fixtures live at `.highway/tools/tests/fixtures/library/` and the narrower reading declines all of them
- [X] T006 Confirm the decline message names the file and says it is outside the framework root, rather than reporting a rule violation
- [X] T007 Add `.highway/tools/tests/library-containment.test.sh` asserting a file outside the framework root is declined by **both** relative and absolute path forms
- [X] T008 **Proof B1** — create a Control-shaped file at `library/governance/`, confirm it is declined by both path forms, remove it
- [X] T009 **Proof B2** — confirm every existing library fixture is still classified and `validate-library.test.sh` passes unchanged, per `D3.5`

**Checkpoint**: User content cannot be judged by Highway's rules, whatever path form is used.

---

## Phase 3: User Story 1 — A stated policy becomes a governable Control (P1)

**Goal**: Add produces a file, a stable identifier, and an index entry.

**Independent test**: Add one Control from a plain sentence; confirm all three exist.

- [X] T010 [US1] Create `.highway/skills/highway-controls/SKILL.md` with the eight required sections, a single-sentence Purpose per `P7.1`, and the Add action
- [X] T011 [US1] Define the Control file shape in Outputs: identifier, title, statement, rationale, status, and an empty `nfrs` field. State it as **description**, not as `MUST` rules — the `P7.4` budget is spent on obligations, not on shape
- [X] T012 [US1] Define the catalog in Outputs: an index, the baseline version, the next identifier, and a statement that Controls are managed through the skill
- [X] T013 [US1] State that the catalog carries **no timestamp**, so an unchanged baseline regenerates identically, per `X6.1` and the `highway-inquiry` precedent
- [X] T014 [US1] State where Controls live — `library/governance/`, a sibling of `.highway/` — and that a missing `.highway/` is an abort-and-ask condition rather than a guess
- [X] T015 [US1] **Measure the `MUST` count** after the first action is written, and record it against the cap of 12

**Checkpoint**: A Control can be added, and the budget is being watched rather than discovered.

---

## Phase 4: User Story 2 — A user's governance is never judged (P1)

**Goal**: Highway writes the files and governs none of their content.

**Independent test**: Write a baseline that would fail Highway's authoring rules; the suite stays green.

- [X] T016 [US2] **Proof C1** — create 30 Controls, each with an uppercase keyword and each over 25 words, and confirm the suite passes. Both conditions fail `P7.4` and `P1.3` when the same content sits under `.highway/library/`
- [X] T017 [US2] **Proof C2** — run every generator and confirm no Control appears in any Highway catalog
- [X] T018 [US2] Confirm no Highway rule identifier is ever reported against a Control's content
- [X] T019 [US2] Remove the probe Controls and confirm the tree is clean

**Checkpoint**: The Layer 3 boundary is demonstrated, not just designed.

---

## Phase 5: User Story 3 — Nothing is destroyed unseen (P1)

**Goal**: Every loss is named before it happens.

**Independent test**: Attempt a Set that drops Controls; confirm each is named before anything is written.

- [X] T020 [US3] State the Remove action: name the Control by identifier **and** title, confirm, then delete
- [X] T021 [US3] State the Set action: name **every** Control that would be lost before writing anything
- [X] T022 [US3] State that a count alone is not sufficient notice, and why — a user cannot decide from a number
- [X] T023 [US3] State that withheld confirmation leaves every file unchanged
- [X] T024 [US3] State the version rules: Add is MINOR, a non-breaking edit is PATCH, **Remove and Set are MAJOR**, and exactly one increment happens per action
- [X] T025 [US3] **Measure the `MUST` count again.** The confirmation obligations are the heaviest block; this is where an overflow will first show

**Checkpoint**: The destructive actions are safe by contract.

---

## Phase 6: User Story 4 — An identifier means one thing forever (P2)

- [X] T026 [US4] State the identifier format and that it is allocated once, never reused, never changed
- [X] T027 [US4] State that the next identifier is **recorded in the catalog**, not derived from the files present
- [X] T028 [US4] State that Update preserves the identifier and any metadata it does not change
- [X] T029 [US4] **Proof I1** — add, remove the highest-numbered Control, add again, and confirm the identifier is not reused
- [X] T030 [US4] State that an absent catalog with Control files present is an abort-and-ask condition, because the next identifier cannot be recovered safely from the files

---

## Phase 7: User Story 5 — Advise without overruling (P2)

- [X] T031 [US5] State that the skill assesses whether a Control states an enforceable requirement rather than an outcome, and says what is wrong where it does not
- [X] T032 [US5] State that it offers at least one improved alternative
- [X] T033 [US5] State that it **MUST NOT refuse** a Control the user still wants, and why: a skill that overrules its user gets bypassed, and the files are then edited by hand
- [X] T034 [US5] State that a resembling Control is named specifically rather than reported as a duplicate in the abstract
- [X] T035 [US5] State the ambiguity conditions: undecidable action, undecidable target, update-or-replace, and a referenced Control that does not exist — each aborts and asks rather than choosing

---

## Phase 8: Registration and regeneration

**⚠️ This is the list feature 015 got wrong. `D4.5` now catches it, but do it deliberately.**

- [X] T036 **Decision point — `P7.4`.** Measure the final `MUST` count. If it exceeds 12 after artifact-shape requirements have been moved into Outputs as description, split along the **Set** seam and record the split with its reason. **Do not resolve an overflow by weakening an obligation into a suggestion**
- [X] T037 Validate the skill and confirm `OK ... 0 unchecked`, watching `P7.5` on the longest section
- [X] T038 Cite the `X` rules the skill satisfies in its Outputs section, per the feature 017 precedent
- [X] T039 Name in its Verification section the `X` rules its self-check exercises, per the feature 018 precedent
- [X] T040 Add three **distribution manifest** rows so the adapters reach a user. Without these the skill ships its source while its adapters are silently dropped
- [X] T041 Regenerate the catalog and all adapters, discharging the Correspondence Gate per `D4.7`
- [X] T042 Run `adapter-coverage.test.sh` and confirm the skill has a catalog entry, three adapters, adapter manifest rows, and included distribution rows

---

## Phase 9: Polish & Cross-Cutting

- [X] T043 [P] Confirm `shipped-tree-independence.test.sh` passes — the skill names no development-only path
- [X] T044 [P] Confirm the skill contains no relative link target, per `P8.7`
- [X] T045 Run the full suite twice; both pass and the tree is unmodified after each
- [X] T046 Walk [quickstart.md](quickstart.md) end to end and correct any step whose expected output differs from actual
- [X] T047 Update `governance-plan.md`: record Phase 7 as partially delivered — `highway-controls` exists, `highway-nfrs` does not — with the measured `MUST` count and whether the skill was split

---

## Dependencies

```text
Phase 1 (Setup)
      │
      ▼
Phase 2 (Containment) ──── must precede any user content being written
      │
      ▼
Phase 3 (US1: Add) ──── establishes the artifacts every other action operates on
      │
      ├──────────────┬──────────────┬──────────────┐
      ▼              ▼              ▼              ▼
Phase 4 (US2)   Phase 5 (US3)  Phase 6 (US4)  Phase 7 (US5)
      │              │              │              │
      └──────────────┴──────┬───────┴──────────────┘
                            ▼
                  Phase 8 (Registration)
                            │
                            ▼
                     Phase 9 (Polish)
```

**Critical path**: T005 → T009 → T010 → T036 → T041.

**Why Phase 2 blocks**: writing user content before the boundary exists means the first Controls
are created in a repository where Highway's rules can still reach them.

**Why Phase 3 blocks Phases 4–7**: Add creates the catalog and the identifier record that Remove,
Set, and Update all depend on.

**The `MUST` count is measured three times** — T015, T025, T036 — because an overflow found at the
end is a rewrite, and found early is a paragraph moved into Outputs.

## Parallel Opportunities

| Tasks | Why parallel-safe |
|---|---|
| T003 with T001–T002 | Reads different files, writes nothing |
| Phases 4, 6 and 7 | Independent behaviours, though all edit one file — coordinate or sequence |
| T043 with T044 | Independent checks, neither modifies the tree |

Phases 5–7 all edit `SKILL.md`. They are logically independent but physically adjacent, so
sequential is safer.

## Implementation Strategy

**MVP**: Phases 1, 2 and 3. That delivers the containment boundary and a working Add — a baseline
can be started, and the guarantee that Highway will not judge it is real rather than intended.

**Then**: Phase 5 makes the destructive actions safe, which is the highest-risk behaviour. Phases 6
and 7 are the guarantees that make the baseline trustworthy over time.

**The failure this list is shaped to avoid**: a governance skill that refuses its user. `FR-026`
and T033 exist because the moment this skill overrules someone, they edit the files by hand — and
that loses the identifiers, the versioning, and the catalog together. Every other guarantee here
depends on the skill remaining the path of least resistance.

## Task Summary

| Phase | Tasks | Story |
|---|---|---|
| 1 Setup | T001–T003 | — |
| 2 Containment | T004–T009 | — |
| 3 Add | T010–T015 | US1 (P1) |
| 4 Not judged | T016–T019 | US2 (P1) |
| 5 Destructive | T020–T025 | US3 (P1) |
| 6 Identifiers | T026–T030 | US4 (P2) |
| 7 Advisory | T031–T035 | US5 (P2) |
| 8 Registration | T036–T042 | — |
| 9 Polish | T043–T047 | — |

**Total**: 47 tasks. Five are failure proofs — T008, T009, T016, T017, T029 — and one, T036, is a
decision point that may split the skill.
