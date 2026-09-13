---

description: "Task list for Contract Proof and Lexicon Speed"
---

# Tasks: Contract Proof and Lexicon Speed

**Input**: Design documents from `specs/046-contract-proof-and-lexicon-speed/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/)

**Tests**: Test tasks are included and are not optional here. This feature exists to add a missing
test and to change code whose only correctness standard is that its output does not move.

**Organization**: Tasks are grouped by user story. The two stories are genuinely independent — they
touch different files and neither reads the other's work.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2)
- Exact file paths appear in every task

## Path Conventions

Shell tooling at `.highway/tools/`, tests at `.highway/tools/tests/`, fixtures at
`.highway/tools/tests/fixtures/`. All paths below are repository-relative.

---

## Phase 1: Setup

**Purpose**: Establish the preconditions both stories depend on. No production code changes here.

- [X] T001 Confirm the starting suite is green by running `.highway/tools/tests/run-all.sh` and recording the exit status and wall-clock runtime in the task notes below (D3.1) — **exit 0, 37 passed, 272s**
- [X] T002 [P] Confirm the target shell is Bash 3.2.57 by running `/bin/bash -c 'echo $BASH_VERSION'` and record the value; every construct later added to `.highway/tools/lib/frontmatter-lexicon.sh` must be verified against this shell, not whichever `bash` is first in `PATH` — **3.2.57(1)-release**
- [X] T003 [P] Record the current lexicon cost baseline by timing `fl_check_field` against `.highway/skills/highway-setup/SKILL.md` description and usage over three iterations, sourcing `.highway/tools/lib/frontmatter-lexicon.sh`; expected near 0.237s — **0.2314s measured**

---

## Phase 2: Foundational

**Purpose**: Capture the immutable baseline. This blocks User Story 2 and must not be deferred —
once `.highway/tools/lib/frontmatter-lexicon.sh` is edited the original output is unobservable and
the equivalence check becomes unfalsifiable (research Decision 8).

**⚠️ CRITICAL**: T004 must complete before any edit to `.highway/tools/lib/frontmatter-lexicon.sh`.

- [X] T004 Capture complete validator output for all 8 skills under `.highway/skills/` and every fixture under `.highway/tools/tests/fixtures/` into `/tmp/046-baseline/`, one file per target plus a recorded exit status for each, using `.highway/tools/validate-skill.sh`; store outside the repository tree so it cannot be mistaken for a deliverable — **21 targets captured** (fixtures without a `SKILL.md` are not validator targets and were skipped)
- [X] T005 Verify the baseline in `/tmp/046-baseline/` is non-empty and that its recorded exit statuses match expectations — the 8 real skills exit 0 and the `invalid-skill-*` fixtures under `.highway/tools/tests/fixtures/` exit non-zero — so a corrupt baseline cannot silently validate a broken change — **0 empty files; 8 skills exit 0; 12 invalid fixtures exit 1**

**Checkpoint**: Baseline captured. Both user stories may now proceed independently.

---

## Phase 3: User Story 1 — The contract's load-bearing property is defended by a check (Priority: P1)

**Goal**: Convert Feature 045's one-off manual demonstration into a permanent executed-behaviour
test, so that a validator which stops deriving required keys from the manifest fails the suite.

**Independent Test**: Seed a defect that makes the validator derive required keys from anywhere other
than the manifest. The suite must fail. Remove the defect; the suite must pass. This requires nothing
from User Story 2.

### Tests for User Story 1

- [X] T006 [US1] Create `.highway/tools/tests/frontmatter-contract-required-keys.test.sh` that copies `.highway/tools/.frontmatter-contract` to a `mktemp` location, appends one TAB-delimited required row at **top** scope naming a key no skill or fixture declares, points the validator at the copy via `FRONTMATTER_CONTRACT_FILE`, runs `.highway/tools/validate-skill.sh` against `.highway/tools/tests/fixtures/valid-skill`, and asserts a finding of the form `ERROR: [SCHEMA] missing required field '<key>'` naming that key (RK-1, RK-2)
- [X] T007 [US1] Extend `.highway/tools/tests/frontmatter-contract-required-keys.test.sh` with the **positive** assertion: `.highway/tools/tests/fixtures/valid-skill` validated against an unmodified copy of the manifest exits 0 and emits no missing-field finding for that key, so a validator that rejected everything could not pass (RK-3)
- [X] T008 [US1] Extend `.highway/tools/tests/frontmatter-contract-required-keys.test.sh` to repeat both assertions for a required row at **metadata** scope, so an enforcement path covering only top-level keys fails (RK-4)
- [X] T009 [US1] Add cleanup to `.highway/tools/tests/frontmatter-contract-required-keys.test.sh` that removes every temporary file on success and on failure, using a trap so an assertion that exits early still cleans up (RK-6)
- [X] T010 [US1] Verify the test never writes the tracked manifest by running it and then confirming `git diff --stat .highway/tools/.frontmatter-contract` is empty, including after forcing a mid-test failure (RK-5, FR-005)
- [X] T011 [US1] Verify `.highway/tools/tests/frontmatter-contract-required-keys.test.sh` does not depend on which artifact it validates by confirming the chosen key is absent from every `SKILL.md` under `.highway/skills/` and `.highway/tools/tests/fixtures/`, and record in the test's header comment why a fixture rather than a real skill is the target (RK-7, research Decision 7)

### Seeded-defect verification for User Story 1

- [X] T012 [US1] Run the new test alone and record that it passes against the current `.highway/tools/lib/schema-validate.sh`
- [X] T013 [US1] Seed a defect in `.highway/tools/lib/schema-validate.sh` that restricts `sv_validate_required_keys` to keys having bespoke checks — the pre-045 behaviour — then run the test and record the exact failure message (RK-8, D3.6)
- [X] T014 [US1] Confirm the seeded failure from `.highway/tools/tests/frontmatter-contract-required-keys.test.sh` is for the right reason: the recorded message must report the expected missing-field finding was absent, not a crash or an unrelated error
- [X] T015 [US1] Seed the opposite defect in `.highway/tools/lib/schema-validate.sh`, making the validator reject `.highway/tools/tests/fixtures/valid-skill` unconditionally, and confirm `.highway/tools/tests/frontmatter-contract-required-keys.test.sh` **still fails** — proving the positive assertion in T007 is load-bearing and the test is not vacuous
- [X] T016 [US1] Remove both seeded defects, confirm `git diff .highway/tools/lib/schema-validate.sh` is empty, and re-run the test to confirm it passes

**Checkpoint**: The manifest's authority over required keys is now defended by an automated check
that has been observed failing for the right reason and observed rejecting a vacuous pass.

---

## Phase 4: User Story 2 — The lexicon check stops paying a process per word (Priority: P2)

**Goal**: Remove the per-word and per-token subprocess cost from the lexicon check without altering
a single byte of its output.

**Independent Test**: Diff complete validator output for every skill and fixture against the Phase 2
baseline. Byte-identical output at measurably lower cost is the whole result. Requires nothing from
User Story 1.

**Prerequisite**: Phase 2 (T004) must be complete.

### Implementation for User Story 2

- [X] T017 [US2] Add a lexicon blob loader to `.highway/tools/lib/frontmatter-lexicon.sh` that populates `FL_LEX_BLOB` once per process via `$(<file)` with a leading and trailing newline, and is idempotent so a second call neither re-reads nor appends a second copy (data-model: Lexicon Blob)
- [X] T018 [US2] Rewrite `fl_word_in_lexicon` in `.highway/tools/lib/frontmatter-lexicon.sh` to test `[[ "$FL_LEX_BLOB" == *$'\n'"$word"$'\n'* ]]` with the word operand **quoted**, spawning no subprocess; an unquoted operand is a verified glob-injection hazard (research Decisions 1 and 2, FR-007)
- [X] T019 [US2] Add a lazy rule-id blob loader to `.highway/tools/lib/frontmatter-lexicon.sh` that populates `FL_RULE_BLOB` via `cat` of the two shipped governing documents piped to `sed -n`, guarded by a separate `FL_RULE_LOADED` flag so an empty result is not re-read on every token (research Decisions 4 and 5, data-model: Rule ID Blob)
- [X] T020 [US2] Rewrite `fl_resolve_rule_id` in `.highway/tools/lib/frontmatter-lexicon.sh` to trigger the lazy load only for tokens matching the rule-id shape and then test membership against `FL_RULE_BLOB`, keeping the `^[A-Z][0-9]+\.[0-9]+$` acceptance rule unchanged (FR-008)
- [X] T021 [US2] Add a builtin lowercaser to `.highway/tools/lib/frontmatter-lexicon.sh` that maps characters through two constant alphabet strings, returns via a global rather than command substitution, and short-circuits when the token contains no uppercase character; `${v,,}` is a `bad substitution` on 3.2.57 and `${var^^}` is banned by D2.1 (research Decision 3)
- [X] T022 [US2] Replace the `sed` punctuation stripping in `fl_check_field` in `.highway/tools/lib/frontmatter-lexicon.sh` with expansion loops for leading and trailing non-alphanumerics, and `${lower//[^a-z0-9-]/ }` then `${words//-/ }` for splitting, without enabling `extglob` (research Decision 6, FR-009)
- [X] T023 [US2] Rewire `fl_check_field` in `.highway/tools/lib/frontmatter-lexicon.sh` to use the new helpers while preserving the existing resolution order — rule id, then skill id, then lexicon words — and per-word individual reporting naming the originating field (contracts/lexicon-library-interface.md, FR-010)
- [X] T024 [US2] Confirm `fl_validate_lexicon` in `.highway/tools/lib/frontmatter-lexicon.sh` is unchanged and still runs, so a missing or malformed lexicon is still reported rather than silently changing what is checked (FR-011)

### Verification for User Story 2

- [X] T025 [US2] Re-capture validator output for all 8 skills and every fixture and `diff` against `/tmp/046-baseline/`; any difference in text, order, or exit status is a defect (SC-004, FR-010)
- [X] T026 [US2] Confirm `D1.1` still does not resolve as a rule id and that `P6.4` and `X1.4` still do, by running the assertions in `.highway/tools/tests/frontmatter-lexicon.test.sh`
- [X] T027 [US2] Verify glob safety of `.highway/tools/lib/frontmatter-lexicon.sh` directly by passing `fl_check_field` a value containing `*` and confirming it produces an unrecognised-word finding rather than silently passing (research Decision 2)
- [X] T028 [US2] Amend `.highway/tools/tests/frontmatter-lexicon.test.sh` with an assertion that the lexicon check spawns no subprocess per word, expressed as an observable the suite can enforce rather than a comment (FR-007)
- [X] T029 [US2] Measure the cost of `fl_check_field` in `.highway/tools/lib/frontmatter-lexicon.sh` for each of the 8 skills under `.highway/skills/` from a fresh process state and confirm each is at or below 0.025s, down from 0.237s; prototype measured 0.0126–0.0145s (SC-006)
- [X] T030 [US2] Run `.highway/tools/tests/run-all.sh` three times, record the median wall-clock runtime, and record the lexicon's contribution as having fallen at least 90%; note total runtime against the 240 second interim ceiling as an **observation**, not a gate (SC-005, FR-012)

**Checkpoint**: The lexicon check is fast and its output has not moved.

---

## Phase 5: Polish & Cross-Cutting Concerns

- [X] T031 Run `.highway/tools/tests/shipped-tree-independence.test.sh` and confirm exit 0; the new test file at `.highway/tools/tests/frontmatter-contract-required-keys.test.sh` ships, so it must contain neither prohibited development path token (D1.1)
- [X] T032 [P] Confirm `UNCHECKED:` is empty for all 8 skills by running `.highway/tools/validate-skill.sh` against each; a faster checker that quietly checks less would pass every other check and fail here (FR-016, SC-007)
- [X] T033 [P] Confirm `git diff --stat .highway/library/knowledge/frontmatter-lexicon.txt .highway/tools/.frontmatter-contract .highway/governance/` is empty — no lexicon word added, no manifest row changed, no rule added, removed, or retagged (FR-013, FR-014, SC-003)
- [X] T034 [P] Scan `.highway/tools/lib/frontmatter-lexicon.sh` and `.highway/tools/tests/frontmatter-contract-required-keys.test.sh` for constructs banned by D2.1 — associative arrays, `mapfile`, `readarray`, `${var^^}`, `${var,,}`, `&>>` — and confirm none are present
- [X] T035 Update `governance-plan.md` with the measured runtime outcome and, if total suite runtime remains above 240 seconds, record the residue as outstanding work owned by Phase 14 (D6.1, FR-012)
- [X] T036 Run `.highway/tools/tests/run-all.sh` a final time and confirm exit 0 with the test file count grown by exactly one (D3.2, SC-007)
- [X] T037 Walk [quickstart.md](quickstart.md) end to end and confirm every "Expected" outcome holds as written; correct the document if any step's stated expectation does not match observed behaviour

---

## Dependencies & Execution Order

```text
Phase 1: Setup (T001–T003)
        │
        ▼
Phase 2: Foundational (T004–T005)  ← blocks US2 only; must precede any lexicon edit
        │
        ├─────────────────────────┬─────────────────────────┐
        ▼                         ▼                         │
Phase 3: US1 (T006–T016)   Phase 4: US2 (T017–T030)         │
   P1 — independent            P2 — independent             │
        │                         │                         │
        └─────────────┬───────────┘                         │
                      ▼                                     │
Phase 5: Polish (T031–T037) ◄───────────────────────────────┘
```

**Story independence**: US1 touches `.highway/tools/tests/` and reads
`.highway/tools/lib/schema-validate.sh`. US2 touches
`.highway/tools/lib/frontmatter-lexicon.sh` and `.highway/tools/tests/frontmatter-lexicon.test.sh`.
No file is written by both. Either can ship alone.

**Ordering constraints that are not negotiable**:

- T004 before any task in Phase 4. The baseline cannot be reconstructed after the fact.
- T013 before T016. A test not observed failing has not been observed (D3.6).
- T015 before T016. Vacuity must be ruled out while the test is still suspect.
- T025 before T029. Prove correctness before celebrating speed; a fast wrong answer is worse than a
  slow right one.

## Parallel Execution Examples

**Phase 1** — T002 and T003 are independent of each other and of T001's result:

```text
T002 (shell version check)  ║  T003 (lexicon cost baseline)
```

**Phases 3 and 4** — the two stories run fully in parallel once T004 lands:

```text
T006 → T007 → T008 → T009 → T010 → T011 → T012 → T013 → T014 → T015 → T016   [US1]
        ║
T017 → T018 → T019 → T020 → T021 → T022 → T023 → T024 → T025 → ...           [US2]
```

Within US2 the implementation tasks are sequential: T017–T024 all edit
`.highway/tools/lib/frontmatter-lexicon.sh` and cannot be parallelised.

**Phase 5** — T032, T033 and T034 are read-only checks over different files:

```text
T032 (UNCHECKED empty)  ║  T033 (tracked files clean)  ║  T034 (banned constructs)
```

## Implementation Strategy

**MVP scope: User Story 1 alone (T001–T016, plus T031 and T036).** It closes a correctness gap that
is invisible when it regresses, and it is the smaller change. Shipping it alone leaves the suite slow
but honest, which is the right order — a slow suite is visible and annoying, a silently inert manifest
is invisible and total.

**Increment 2: User Story 2 (T017–T030).** Purely a cost reduction, verifiable by diff against a
baseline. Ship once US1 is green.

**Do not** collapse the seeded-defect tasks (T013–T015) into a single step. They prove three distinct
things: that the test can fail, that it fails for the right reason, and that it cannot pass vacuously.
Feature 045's gap existed precisely because the first was demonstrated once and the other two never
were.

## Notes

- All verification must run under `/bin/bash`, not whichever `bash` is first in `PATH`. A construct
  that works under 5.x and fails under 3.2.57 will otherwise pass every check here and break for
  users.
- Record measurements from runs. Two defects in this feature's own specification came from deriving a
  number arithmetically from an earlier number instead of measuring it.
