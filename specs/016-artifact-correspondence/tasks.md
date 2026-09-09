# Tasks: Generated Artifact Correspondence

**Feature**: 016-artifact-correspondence | **Date**: 2026-09-08

**Input**: [spec.md](spec.md), [plan.md](plan.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/correspondence-check.md](contracts/correspondence-check.md), [quickstart.md](quickstart.md)

**Tests**: This feature *is* tests. The "implementation" is assertions added to
`adapter-coverage.test.sh`, and each is paired with a round-trip proof that it can fail.

---

## Phase 1: Setup & Baseline

**Purpose**: Establish the starting state, per `D3.1`.

- [X] T001 Run `.highway/tools/tests/run-all.sh` and record the pass count; it must be 0 failed before any edit
- [X] T002 Record the current working tree state with `git status --porcelain`, so any file this feature touches unintentionally is visible later
- [X] T003 [P] Record the current tier counts in `.specify/memory/constitution.md` — `[auto]`, `[agent-checkable]`, `[human-review]` — so the amendment's effect on them can be stated precisely

---

## Phase 2: Foundational

**Purpose**: Blocking prerequisites. The repair must land before `D4.7` is enabled, or the
amendment is MAJOR rather than MINOR.

**⚠️ No user-story phase may begin until T009 is complete.**

### The repair

- [X] T004 Confirm the live violation still stands: `.highway/catalog/library-index.json` omits `requirements-inquiry`, added by feature 015. Record the before-state.
- [X] T005 Regenerate the library catalog by copying `.highway/` to a temp tree, running `generate-library-catalog.sh` there, and copying the two `library-index.*` files back — or by running it in place and verifying only intended content changed
- [X] T006 Verify the repair: regenerate into a temp tree and confirm no diff against the committed `library-index.json` and `library-index.md`, ignoring `generated_at`
- [X] T007 Verify `D4.7` now passes for **all three** in-scope generators — catalog, library catalog, adapters — because the MINOR classification in FR-005 depends on it. If any still differs, stop and re-classify the amendment before continuing.

### The amendment

- [X] T008 Amend `.specify/memory/constitution.md` under Principle IV: add `D4.5`, `D4.6`, `D4.7`, each with rule text, an Observable, and the `[auto]` tier, using the wording in spec FR-001 through FR-003
- [X] T009 Add three Enforcement Map rows to `.specify/memory/constitution.md`, each naming `adapter-coverage.test.sh` and stating what that test asserts for that rule; update the Sync Impact Report with the MINOR bump `1.1.0 → 1.2.0`, the reasoning, and the confirmation from T007

**Checkpoint**: The rules are readable and the tree conforms to them. Checks can now be written.

---

## Phase 3: User Story 1 — A skill added reaches the people who need it (P1)

**Goal**: A skill present in the source but missing a catalog entry, an adapter, or a distribution
row fails the suite by name.

**Independent test**: Add a skill directory without regenerating; the suite fails naming it.

- [X] T010 [US1] Pre-evaluate the catalog-entry assertion against every existing fixture before enabling it, per `D3.4`, and record each fixture's expected verdict
- [X] T011 [US1] Add the catalog-entry assertion to `.highway/tools/tests/adapter-coverage.test.sh`: every skill under `.highway/skills/` has an entry in `.highway/catalog/index.json`, iterating the skills present rather than any list
- [X] T012 [US1] Add the adapter-file assertion to the same file: every skill has a file at each of the three declared adapter paths
- [X] T013 [US1] Confirm the existing distribution-row assertion still passes unchanged and its message is preserved verbatim, so this feature adds messages without altering existing ones
- [X] T014 [US1] **Proof P1** — remove `highway-inquiry` from `.highway/catalog/index.json`, confirm exit 1 naming the missing entry, restore, confirm exit 0
- [X] T015 [US1] **Proof P2** — move `.cursor/rules/highway-inquiry.mdc` aside, confirm exit 1 naming that path, restore, confirm exit 0

**Checkpoint**: An added skill can no longer be silently invisible.

---

## Phase 4: User Story 2 — A removed skill leaves nothing behind (P1)

**Goal**: No catalog entry, adapter file, or manifest row names a skill with no source.

**Independent test**: Remove a skill directory; the suite fails naming every orphan.

- [X] T016 [US2] Pre-evaluate the orphan assertions against every existing fixture before enabling, per `D3.4`
- [X] T017 [US2] Add the orphan assertion for catalog entries: no entry in `.highway/catalog/index.json` names a skill with no directory under `.highway/skills/`
- [X] T018 [US2] Add the orphan assertion for adapter files: no file at a declared adapter path names a skill with no source directory
- [X] T019 [US2] Add the orphan assertions for both manifests: no row in `.adapter-manifest` or `.distribution-manifest` names a skill with no source directory. Ignore `.mock-agent-4/` fixture rows and do not depend on row order, per FR-011
- [X] T020 [US2] **Proof P3** — remove `highway-inquiry`'s rows from `.adapter-manifest`, run the check, and **record the verdict rather than assume it**: removing a row for a skill that still exists is a `D4.5` gap, not a `D4.6` orphan. Decide deliberately which rule owns it and note the decision
- [X] T021 [US2] **Proof P6** — move `.highway/skills/highway-inquiry/` aside, confirm exit 1 with orphans named across the catalog, adapters, and both manifests, restore, confirm exit 0

**Checkpoint**: No orphaned adapter can reach a distribution.

---

## Phase 5: User Story 3 — A changed skill does not report stale information (P2)

**Goal**: Editing a skill without regenerating fails the suite. This is the case nothing detected
before this feature.

**Independent test**: Change a description without regenerating; the suite fails.

- [X] T022 [US3] Pre-evaluate the currency assertion against every existing fixture before enabling, per `D3.4`
- [X] T023 [US3] Add the currency check to `.highway/tools/tests/adapter-coverage.test.sh`: create a temp directory, copy `.highway/` into it, and run the three in-scope generators from inside the copy. The real tree must never be written to
- [X] T024 [US3] Compare the regenerated catalogs and adapter files against the committed ones, ignoring `generated_at`. **Exclude `.adapter-manifest`** from this comparison, per research R4
- [X] T025 [US3] Remove the temp directory on exit, including on failure, so a failing run leaves no residue
- [X] T026 [US3] **Proof P5** — change `highway-inquiry`'s description without regenerating, confirm exit 1 naming the stale catalog, restore, confirm exit 0. Note that before this feature the same break produced exit 0
- [X] T027 [US3] **Verify G1** — capture `git status --porcelain` before and after a check run, both passing and failing, and confirm they are identical
- [X] T028 [US3] **Verify G3** — run the check both before and after a full suite run and confirm the verdict is the same, proving independence from `.adapter-manifest` ordering churn

**Checkpoint**: Silent misinformation is now detectable.

---

## Phase 6: User Story 4 — The obligation is readable (P2)

**Goal**: A contributor finds the rule by reading, not by failing.

- [X] T029 [US4] Verify all three rules appear under Principle IV with an Observable and a tier, and that the Enforcement Map names the deciding test for each
- [X] T030 [US4] Verify `D4.7` does not restate `D4.1`, per `D1.3` and `D1.4` — the rule texts must state different obligations even though the Observables overlap
- [X] T031 [US4] Verify the tier-honesty guard in `constitution-inventory.test.sh` still passes with three new `[auto]` rules present, since it asserts every `[auto]` rule has an Enforcement Map row

---

## Phase 7: Polish & Cross-Cutting

- [X] T032 [P] Verify `shipped-tree-independence.test.sh` passes — the test file must contain no literal development-path token; assemble at runtime if needed, per the precedent from features 012 and 014
- [X] T033 [P] Verify the vacuity guard: run the check against a temp tree with no skills and confirm it fails rather than passing silently, per FR-013
- [X] T034 Confirm every skill present conforms, naming `highway-help` and `highway-inquiry` explicitly, per FR-016
- [X] T035 Run the full suite twice in succession; both runs pass and the tree is unmodified after each, per SC-004
- [X] T036 Update the Phase 4c entry in `governance-plan.md` to complete, recording the task count, final test count, and the stale-library-catalog finding as a lesson carried forward
- [X] T037 Walk [quickstart.md](quickstart.md) end to end and correct any step whose expected output differs from actual

---

## Dependencies

```text
Phase 1 (Setup)
      │
      ▼
Phase 2 (Foundational) ── repair MUST precede the amendment's MINOR classification
      │
      ├──────────────┬──────────────┐
      ▼              ▼              ▼
Phase 3 (US1)   Phase 4 (US2)  Phase 5 (US3)
      │              │              │
      └──────────────┴──────────────┘
                     │
                     ▼
              Phase 6 (US4)
                     │
                     ▼
              Phase 7 (Polish)
```

**Critical path**: T004 → T007 → T008 → T009, then any user story phase.

**Why Phase 2 blocks everything**: T007 decides whether the amendment is MINOR or MAJOR. Writing
checks before that is wasted work if the classification changes.

**Ordering within Phase 5**: T023 must precede T024, and T025 must be written as part of T023
rather than bolted on afterwards — a cleanup step added later tends to miss the failure path.

## Parallel Opportunities

| Tasks | Why parallel-safe |
|---|---|
| T003 with T001–T002 | Reads a different file, writes nothing |
| Phases 3, 4 and 5 | Independent assertions in the same file; parallel only if edits are coordinated, otherwise sequential is safer |
| T032 with T033 | Different concerns, neither modifies the tree |

The three user-story phases touch one file, `adapter-coverage.test.sh`. They are logically
independent but physically adjacent, so running them sequentially avoids edit conflicts for little
lost time.

## Implementation Strategy

**MVP**: Phase 1 + Phase 2 + Phase 3. That delivers the repair, the three stated rules, and
detection for the case that has already occurred once.

**Then**: Phase 4 closes the most severe case, the shipped ghost. Phase 5 closes the case that is
hardest to notice.

**A note on what proves anything**: every phase pairs an assertion with a round trip that breaks the
thing and restores it. Watching a check pass proves nothing — feature 013's checks reported every
fixture passing while the whole program was failing to run, and feature 014's extended guard passed
without iterating a single rule. A check that has never been observed failing is indistinguishable
from one that matches nothing.

## Task Summary

| Phase | Tasks | Story |
|---|---|---|
| 1 Setup | T001–T003 | — |
| 2 Foundational | T004–T009 | — |
| 3 Added skill | T010–T015 | US1 (P1) |
| 4 Removed skill | T016–T021 | US2 (P1) |
| 5 Changed skill | T022–T028 | US3 (P2) |
| 6 Readable rules | T029–T031 | US4 (P2) |
| 7 Polish | T032–T037 | — |

**Total**: 37 tasks. 6 are failure proofs, which are the only tasks that establish the checks work.
