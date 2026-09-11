# Research: Automatic Check Integrity

**Feature**: 041-auto-check-integrity | **Date**: 2026-09-10

All measurements below were taken against the working tree on 2026-09-10 and are reproducible.

---

## R1 — Where the completion register lives, and what shape it takes

**Decision**: A single Markdown table at `.specify/memory/completion-register.md`, with columns
`Feature`, `Status`, `Corrects`. `Status` is one of exactly `complete`, `incomplete`, `in-progress`.
`Corrects` is either a feature directory name or `-`.

**Rationale**:

- `.specify/` is a declared development artifact, so the register never ships and takes no `P` or
  `X` obligation. `.specify/memory/` already holds the Development Constitution, which makes it the
  established home for Layer 0 governance state.
- Placing it outside `specs/` is what keeps `D5.1` intact. The existing exception permits an update
  to `coverage.md` and a relocation of a directory; it does not permit editing 40 `spec.md` files,
  which is what a per-directory completion marker would require.
- A Markdown table is what every other governance artifact in this repository uses, is readable by
  `grep`/`awk` under Bash 3.2, and needs no new utility.
- Three status values rather than two, because the tree has all three cases today and collapsing
  them would force a false answer for at least one directory.

**Alternatives considered**:

| Alternative | Rejected because |
|---|---|
| A `Status:` field in each `spec.md` | Edits 38 completed spec files. `D5.1` forbids it and the existing exception does not reach it. |
| A `.complete` marker file per directory | A diff under a completed spec directory, same `D5.1` problem, and it scatters the declaration across 40 places against `D1.6`'s one-place shape. |
| Keep deriving from `tasks.md` and just tighten the parse | This is the defect. Any parse of an artifact the checked feature controls leaves the scope under that feature's control. |
| JSON | Adds no capability, and no utility in the Declared Toolchain parses it. |

---

## R2 — How a check is proved able to fail, without the harness enumerating defects

**The problem.** `D3.7`'s Observable requires *a seeded defect in one artifact of each declared
class producing a non-zero exit*. A harness that seeds those defects itself would need to know, per
test and per class, what defect to seed — an enumerated list inside the harness, which is the defect
Feature 016 removed one level up. A harness that reads a comment proves nothing, which is the defect
today.

**Decision**: Each registered `[auto]` test gains a **probe mode**. Invoked as
`bash <test>.test.sh --probe <artifact-class>`, the test seeds a defect in one real artifact of that
class, runs the same check function it runs against the live tree, restores the artifact, and exits
**non-zero if and only if the check reported the defect**. Invoked as
`bash <test>.test.sh --probe <artifact-class> --neutralise`, it runs the identical path with the
seeding step skipped.

`constitution-inventory.test.sh` then, for each rule in the Enforcement Map and each class the named
test declares, asserts:

1. `--probe <class>` exits **non-zero** — the check fails when the artifact is defective.
2. `--probe <class> --neutralise` exits **zero** — the failure was caused by the seeded defect and
   not by something the probe would have reported anyway.

**Why the second invocation is the load-bearing one.** The first alone is satisfiable by a probe
that always fails. The pair is a round trip, which the governance plan already argues proves more
than watching a check pass: *"A round trip proves more than watching a check pass: it shows the
check is reading the thing it claims to read."* A probe that prints a verdict rather than deriving
one passes the first assertion and fails the second.

**Recursion**: `constitution-inventory.test.sh` is itself mapped, for `D3.7`. Its probe mode must
return before reaching the harness loop, or it invokes itself without bound. The guard is a single
early return in probe mode, asserted by the harness running the inventory test's own probe.

**Alternatives considered**:

| Alternative | Rejected because |
|---|---|
| Harness seeds the defects itself | Reintroduces the enumerated list the feature exists to remove. |
| Test prints `PROBE: <class> detected` and the harness greps for it | Identical in kind to the comment grep being replaced. A printed token is not a verdict. |
| Harness re-runs the whole test in probe mode | Measured cost is prohibitive — see R3. |
| Trust the in-test probe assertions that already exist in three tests | They are real, but nothing requires them and nothing notices when they are absent. That is the state today. |

---

## R3 — The runtime budget, measured

**Measured 2026-09-10**, `run-all.sh` wall clock: **109s** for 39 tests. Per-test, for the eight
files named in the Enforcement Map:

| Test | Rules decided | Seconds |
|---|---|---|
| distribution-packaging | D1.2, D4.3 | 38 |
| shipped-tree-independence | D1.1 | 14 |
| generate-catalog | D4.2 | 10 |
| adapter-coverage | D4.5, D4.6, D4.7 | 8 |
| generate-agent-adapters | D4.1 | 7 |
| completion-coverage | D7.2, D7.4 | 7 |
| spec-record | D5.4, D5.5 | 1 |
| constitution-inventory | D3.7 | 1 |

**Consequence**: re-running each whole test twice per declared class would add roughly
`(38+14+10+8+7+7+1+1) × 3 classes × 2 invocations ≈ 516s`, taking the suite past nine minutes. That
is not a check, it is a build — the same objection the governance plan raised against proving one
probe per artifact rather than per class.

**Decision**: Probe mode runs **only the probed class's check path**, not the whole test. The
expensive setup in `distribution-packaging` (two full distribution builds, ~24s of its 38s) and in
`adapter-coverage` (a full tree copy and regeneration) is skipped unless the probed class requires
it, and where it is required the artifact is built once and reused across that test's probes.

**Budget to hold**: the suite must remain under 180s. This is a stated implementation constraint,
measured before and after, not an aspiration.

---

## R4 — Which checks currently prove nothing, and what each probe must break

Measured by reading every test named in the Enforcement Map for a seeded defect that is actually
executed:

| Test | Seeds a real defect today | Probe to write |
|---|---|---|
| shipped-tree-independence | Yes — writes a file containing a development path, confirms the scan reports it, removes it | none |
| distribution-packaging | Yes — four probe families, PID-named, swept at suite level | none |
| completion-coverage | Yes — disposable fixtures plus a missing-record probe | none |
| objective-rename-contract | Yes | none |
| spec-record | Yes | none |
| **generate-agent-adapters** | **No** | Hand-edit a generated adapter after generation; the generator must refuse (`D4.1`) |
| **generate-catalog** | **No** | Perturb one byte outside the excepted timestamp between two runs; determinism must be reported (`D4.2`) |
| **adapter-coverage** | **No** | Four probes on `highway-inquiry`: remove its catalog entry, remove an adapter, remove an adapter manifest row, remove a distribution manifest row (`D4.5`, `D4.6`); change its description without regenerating (`D4.7`) |
| **constitution-inventory** | **No** | Its own: a mapped test whose declared probe does not fail must be reported (`D3.7`) |

`highway-inquiry` is the prescribed subject, from Phase 4c: *"Because it conforms, each of the four
correspondences can be broken for it and then restored."* Confirmed still conforming on 2026-09-10.

---

## R5 — Residue discipline

**Constraint, not a preference.** The governance plan records that probe residue cost this project
time twice: *"an orphaned adapter row failed `adapter-coverage`, and an abandoned link probe failed
`distribution-packaging`, each time naming a defect that did not exist."*

**Decision**: every new probe artifact is named with `$$`, removed by the owning test's `trap ... EXIT`,
and additionally swept at suite level in `run-all.sh` lines 18–25, which already sweeps four probe
families. Sweeping only in the owning test is insufficient because tests run in name order and
residue is seen by whichever test sorts first.

**Version control must not be used to restore a probe.** `distribution-packaging.test.sh` records
why in its own header: *"Do not revert a probe with version control: during feature 010 that
discarded unrelated uncommitted work in the same file."* Independently, `git` is deliberately absent
from the Declared Toolchain. Every probe restores by saving and rewriting bytes.

---

## R6 — Amendment classification

**The rule**: MAJOR when *"a principle is removed or redefined, or an obligation is strengthened so
that previously conforming work now fails"*; MINOR when *"a principle or rule is added without
invalidating conforming work"*.

**Two changes to assess.**

1. **The `Completed spec` definition** at constitution line 239. A definition is not a principle, and
   no rule text changes. But the definition is load-bearing for `D5.1`, `D7.2` and `D7.4`, and
   changing it changes which directories those rules reach.
2. **Making `D3.7` decide what it claims.** Measured: five registered checks pass today and fail the
   moment the comment grep is replaced. That is, literally, previously conforming work failing.

**Decision**: **MINOR, conditional on the conformance work landing in the same change** — the
precedent set three times in this repository. Phase 4c: *"the extraction must happen in the same
change that turns the rule on, or the amendment is MAJOR rather than MINOR."* Phase 12 applied the
same test to `D7.4` and `D5.5`. If any of the five probes cannot be written in this change, the
classification becomes MAJOR and the rule is recorded as enabled later rather than tagged
optimistically.

**This must be measured, not assumed.** The pre-enable count of failing checks is recorded before
the probes are written, per `D3.4`.

---

## R7 — A defect looked for and not found

The governance plan's Phase 12 draft states `D7.5`'s Observable as *"The corrected feature's coverage
record carries a superseding entry naming the correcting feature"*, while
`correction_check()` inspects the **correcting** feature's own record. That reads like a second
instance of a check deciding something other than its rule.

**It is not.** The ratified text at constitution line 352 reads: *"Corrective coverage names the
originating feature, revised requirement, and superseding feature."* The check matches the ratified
rule. The plan's draft wording was superseded before ratification.

Recorded because the discrepancy is discoverable and someone will find it again. No work follows
from it, and no change is made to `D7.5`.

---

## R8 — Three directories need an explicit status, and the answer is not mechanical

Measured: `003-constitution-enforcement`, `038-readiness-verification-corrections` and
`040-historical-coverage-reconstruction` are the only directories with unchecked task boxes, and are
therefore the only ones the current mechanism excludes.

| Directory | Situation | Decision |
|---|---|---|
| 003 | Never implemented; already excluded by an explicit `-ne 3` special case in the check | `incomplete` — the special case is deleted and the register carries the fact |
| 038 | Shipped, is in the corrective set, `Status: Draft`, four tasks unchecked, and its record uses a different column set | `complete`, and the four tasks and the record are reconciled in this change. Registering it complete while its record is malformed is the state the feature exists to make visible |
| 040 | This session's work; 30 of 34 tasks done, three of the four remaining depend on an unresolved count | `complete`, with the residual requirements recorded honestly in its coverage record rather than marked satisfied |

**Feature 038 registered as `complete` is a claim, and `D7.1` applies to it.** Its four unchecked
tasks must either be completed or their coverage rows must state the shortfall. Marking it complete
and leaving the boxes unticked is the precise failure Feature 021 was written about.

---

## R9 — What `038/coverage.md` actually needs

Measured: 23 rows under the header `| Requirement | Coverage | Evidence class |`; 15 rows carry
`FR-` identifiers, matching the 15 requirement ids declared in its `spec.md`; 8 rows do not.

`coverage_rows()` matches only lines beginning `| FR-nnn |`, so the 8 non-requirement rows are
invisible to the parser and break nothing. **The only thing that fails is the header**, which
`coverage_check()` requires to match `| Requirement | Outcome | Evidence |` exactly once.

**Decision**: rename the header columns and remove the 8 non-requirement rows. The removal is not
required by the parser; it is required by `D7.4`'s "one declared column schema", since those rows use
`Evidence class` in a third sense that the renamed header would silently mislabel.

---

## R10 — Unresolved, and deliberately so

Nothing in this feature is marked `NEEDS CLARIFICATION`. Two items are recorded as decisions the
implementation must **measure rather than assume**:

- The pre-enable count of checks that fail once `D3.7` is real (R6). If it exceeds five, the extra
  ones are reported, not quietly fixed.
- The suite runtime after the probe harness lands (R3). If it exceeds 180s the probe scope is
  reduced and the reduction is recorded, rather than the budget being restated.

---

## Measured baseline (Phase 1, 2026-09-10)

**T001 — suite result before any edit.** `bash .highway/tools/tests/run-all.sh`: **39 passed, 0
failed**, wall clock **1:52.57** (112.57s user+system reported separately: 51.05s user, 80.47s
system, 116% cpu). `highway-setup-executable.test.sh` prints a `FAIL: invalid response status
'Status: Unknown'` line as part of a seeded fixture assertion it then reports `OK` for — a known
false alarm, not a real failure (recorded previously in session memory).

**T002 — every `[auto]` Enforcement Map row**, read from `.specify/memory/constitution.md`:

| Rule | Test | Declared artifact classes (test's own comment) |
|---|---|---|
| D1.1 | shipped-tree-independence.test.sh | source-document, generated-artifact, disposable-fixture |
| D1.2 | distribution-packaging.test.sh | source-document, generated-artifact, disposable-fixture |
| D4.1 | generate-agent-adapters.test.sh | source-document, generated-artifact, disposable-fixture |
| D4.2 | generate-catalog.test.sh | source-document, generated-artifact, disposable-fixture |
| D4.3 | distribution-packaging.test.sh | source-document, generated-artifact, disposable-fixture |
| D4.5 | adapter-coverage.test.sh | source-document, generated-artifact, disposable-fixture |
| D4.6 | adapter-coverage.test.sh | source-document, generated-artifact, disposable-fixture |
| D4.7 | adapter-coverage.test.sh | source-document, generated-artifact, disposable-fixture |
| D5.4 | spec-record.test.sh | source-document, generated-artifact, disposable-fixture |
| D5.5 | spec-record.test.sh | source-document, generated-artifact, disposable-fixture |
| D7.2 | completion-coverage.test.sh | source-document, generated-artifact, disposable-fixture |
| D7.4 | completion-coverage.test.sh | source-document, generated-artifact, disposable-fixture |
| D3.7 | constitution-inventory.test.sh | source-document, generated-artifact, disposable-fixture |

Every one of the 39 test files carries the identical boilerplate declaration
(`source-document, generated-artifact, disposable-fixture`) regardless of whether it probes any of
them. That boilerplate satisfies today's comment-grep and nothing else — it is itself an instance
of the defect this feature removes, one level below the five checks named in the spec.

**T003 — measured, not predicted, per mapped test file: does it seed a defect and observe the
failure, today, without a `--probe` CLI.**

| Test | Seeds a real, executed defect today | Evidence |
|---|---|---|
| shipped-tree-independence.test.sh | **Yes** | Writes a distributed-path violation and a fixture violation, greps for detection, removes both |
| distribution-packaging.test.sh | **Yes** | Six inline probes: undeclared path, dev-reference, unresolvable link, rejected-candidate cleanup, missing-governance self-validation, overwrite-guard |
| **generate-agent-adapters.test.sh** | **Yes — corrects research R4** | Appends `hand-edited line` to a generated adapter and asserts the generator refuses to overwrite it and the edit survives. `D4.1`'s Observable, executed. R4's prediction that this file "declares a probe in a comment and proves nothing" is **wrong**; it must have been added after this feature's spec was written, or was missed during specification. Recorded here rather than silently corrected, per the discipline this feature enforces on itself. |
| generate-catalog.test.sh | No | Proves determinism holds (re-run, diff, expect equal) but never seeds non-determinism and checks it is caught. No probe. |
| adapter-coverage.test.sh | No | All three of D4.5/D4.6/D4.7 are checked only as positive assertions against the live tree. No `rm`, no injected orphan, no injected staleness anywhere in the file. |
| spec-record.test.sh | **Yes** | Seeds a numbering gap and a branch-identity mismatch/placeholder in temporary trees, confirms both detected |
| completion-coverage.test.sh | Partially | Extensive `assert_fail` fixture coverage for `D7.2`/`D7.4` malformed cases (11 distinct seeded fixture defects), but none of it is reachable via an external `--probe <class>` CLI, and none of it seeds against the *live* register this feature introduces |
| constitution-inventory.test.sh | No | Both `D3.7` assertions are `grep -q` against comment text (`# Seeded failure probe:`, `# Artifact classes:`); no probe is ever invoked, no exit code observed |

**Measured count of checks needing new probe-mode work, revised from R4's prediction of five:**

- **Need a `--probe` CLI wrapped around an already-real defect** (low-risk, mechanical): D1.1, D1.2,
  D4.1, D4.3, D5.4, D5.5 — six rules across four files.
- **Need a genuinely new seeded defect authored**: D4.2 (one probe), D4.5/D4.6/D4.7 (up to five
  probes in one file, per data-model.md), D3.7 (one probe on itself). **Three files, seven rules.**
- `D7.2`/`D7.4` sit in between: real fixture defects already exist, but need a `--probe` entry point
  reachable from outside the test, and the register-specific probes (A1–A5, A8) from Phase 3 are
  new work regardless.

**T004 — amendment classification, confirmed.** All conformance work identified above is scoped
into Phases 2–5 of `tasks.md`, in the same change that enables `D3.7` for real. The classification
in `plan.md` — **MINOR** — stands, conditional on Phases 4 and 5 actually landing before Phase 8. If
`D4.2`, `D4.5`/`D4.6`/`D4.7`, or `D3.7`'s own probe cannot be completed in this change, the
classification must be revisited to MAJOR before `plan.md`'s Constitution Check is re-affirmed.

## Phase 3 (US1) observations, 2026-09-10

**T018 — each of A1/A2/A3/A4/A8 observed failing, then passing after restoration**, against
synthetic register/specs fixtures in `completion-coverage.test.sh`'s inline self-test:

| Assertion | Seeded defect | Message observed |
|---|---|---|
| A1 | A real directory has no register row | `feature directory is not in the completion register: <dir>` |
| A2 | A register row names a directory that does not exist | `completion register names a directory that does not exist: <name>` |
| A3 | A row's `Status` is `done` (not in the vocabulary) | `malformed status in completion register: <name> -> done` |
| A4 | A `Feature` value appears twice | `duplicate completion register entry: <name>` |
| A8 | The register has zero parseable rows | `no rows parsed from the completion register; the reader matched nothing` |

All five, run against the real `.specify/memory/completion-register.md` and the real `specs/`
directory once seeded and restored via `--probe source-document` / `--probe source-document
--neutralise`, produced exit 1 (seeded) and exit 0 (neutralised) as the probe-mode contract
requires; `--probe made-up` produced exit 2.

**T019 — quickstart Scenario 1**, run against `specs/033-highway-setup-orchestration/tasks.md`
(quickstart's example path predates that directory's rename and is stale): unticking `T001`'s
checkbox left `033-highway-setup-orchestration` still evaluated and passing — the checkbox has no
bearing on scope, only the register does. Restored byte-exact via `cp` from a pre-edit copy;
`diff` confirmed zero difference.

**T020 — measured, not the predicted 40.** Enabling the register-driven loop evaluates **39**
`complete`-status directories (41 total directories minus `003-constitution-enforcement`
`incomplete` minus `041-auto-check-integrity` `in-progress`), not the 40 anticipated when
`tasks.md` was written — the difference is `003`, which the previous mechanism already excluded by
a hardcoded special case and the register now excludes by a declared status instead. The overall
suite is not yet green at this checkpoint: register-driven scope newly reaches
`038-readiness-verification-corrections` (a real, pre-existing `coverage.md` header defect, R9) and
`040-historical-coverage-reconstruction` (no `coverage.md` exists yet). Both are exactly the
Phase 6/7 work items, not a defect in Phase 3's mechanism.

---

## Phase 6/7 (US5) resolution, 2026-09-10

Both defects T020 surfaced were resolved and the full suite (`run-all.sh`) is now green: 39 test
files passed, exit 0, wall clock 1:51 (under the 180s budget).

**`completion-coverage.test.sh`'s own evidence-format contract** was not obvious from the schema
alone: a `satisfied` row's `Evidence` cell must lead with a real repo- or feature-dir-relative
artifact path followed by `:`, e.g. `` `path/to/file`: description ``. An evidence cell describing
a fact in prose without a leading path (even a true one) fails `coverage_check`'s existence test.
This was discovered by trial: an initial version of `040-historical-coverage-reconstruction`'s
`coverage.md` failed all 12 rows because none led with a path. Recorded here since it is not
written down anywhere else in this feature's contracts.

**Feature 040's own coverage record**: writing it required actually performing the audit that
Feature 040's own `tasks.md` T024 was written to do and never checked off. That audit — a direct
count and inspection of the 291 `FR-` rows across the 18 records Feature 040 created — found: zero
`satisfied` rows, zero `deferred` rows, all 291 `historical` with a uniform evidence string naming
no owner. That makes Feature 040's `FR-004` through `FR-007` (all about review-dependent
properties of the rows it created) genuinely `satisfied`, not the "four residual requirements"
`tasks.md`'s T049 predicted — the prediction assumed the review would find something, or would
remain undone; instead the review was completed here and found no defect. Separately, and not
correctable in Feature 040's own `tasks.md` per `D5.1`: `tasks.md` (T002, T024, T031) each state a
"verified 309-row historical total"; the actual count is **291**. This is recorded in Feature 040's
`coverage.md` rather than silently reconciled, since Feature 040 is `complete` in the register and
only its `coverage.md` may change.

**Feature 038's remaining T030-T033**: these four unchecked tasks are pure re-run instructions
(`validate-skill`, `validate-library`, `generate-catalog`, `generate-agent-adapters`,
`adapter-coverage`, `distribution-packaging`, `shipped-tree-independence`, `run-all.sh`,
`git diff --check`), not new implementation. Every command they name was independently re-run here
and passed. Per `D5.1`, `038-readiness-verification-corrections/tasks.md` cannot be edited to check
these off; the outcome is instead recorded as a new "T030-T033 reconciliation" section appended to
`038-readiness-verification-corrections/coverage.md`.

## Phase 4 (US3) observations, 2026-09-10

Each of the five previously-unproven checks was observed failing on a seeded defect and passing on
restoration, via `--probe <class>` / `--probe <class> --neutralise`:

| Check | Class | Seeded (exit) | Message | Neutralised (exit) |
|---|---|---|---|---|
| `generate-agent-adapters.test.sh` (`D4.1`) | `generated-artifact` | 1 | hand-edited line not preserved in regenerated adapter | 0 |
| `generate-catalog.test.sh` (`D4.2`) | `generated-artifact` | 1 | two catalog snapshots differ outside `generated_at` | 0 |
| `adapter-coverage.test.sh` (`D4.5`/`D4.6`) | `generated-artifact` | 1 | `has no entry in the catalog` / `has no adapter at <rel>` / `has no adapter manifest row for <rel>` / `is not included by the distribution manifest` (whichever removal `check_skill_correspondence` reaches first) | 0 |
| `adapter-coverage.test.sh` (`D4.7`) | `source-document` | 1 | `<rel> is stale; regenerating skill 'highway-inquiry' produces a different adapter` | 0 |
| `distribution-packaging.test.sh` (dev-reference / stray-path) | `source-document`, `disposable-fixture` | 1 (each) | `development-only location` / stray path name | 0 (each) |
| `spec-record.test.sh` (numbering gap) | `disposable-fixture` | 1 | `gap between 002 and 004` | 0 |

Every case above also returned exit 2 for an undeclared `--probe` class, and every probe restored
its target (real production file, or a `mktemp` copy) byte-exact and left no residue — confirmed
directly via `diff`/`git status` in isolation (see Problem Resolution notes for the
`adapter-coverage.test.sh` byte-exact re-check and the pre-existing, unrelated `.adapter-manifest`
row-order noise ruled out during that check).

`distribution-packaging.test.sh` originally also declared and probed a third class,
`generated-artifact` (a distribution missing its governance directory fails self-validation). It is
narrowed out in Phase 5 below once the harness made the full-suite runtime cost of every declared
class visible; the underlying normal-mode check ("the self-validation check must be capable of
failing", `.highway/tools/tests/distribution-packaging.test.sh`) is unchanged and still runs — only
the CLI-probed, harness-checked surface shrank.

## Phase 5 (US2) resolution, 2026-09-10

`constitution-inventory.test.sh` now decides `D3.7` for real: `harness_run`/`harness_probe_pair`
replace the old `grep -q '^# Seeded failure probe:'` (lines 201-202) with a paired `--probe
<class>` (require non-zero) / `--probe <class> --neutralise` (require zero) invocation per
declared class, for every test named in the Development Constitution's Enforcement Map. Exit 2
(undeclared class) is reported distinctly from a check failure. A zero-pairs-exercised assertion
was added and observed failing in isolation against an empty map before being relied on against the
real one. The file's own D3.7 row is handled with a `source-document` self-probe (T038) that seeds
by breaking `generate-catalog.test.sh`'s `probe_generated_artifact` function — the same defect
quickstart Scenario 6 seeds by hand — and requires `harness_probe_pair` (the same function the
harness loop uses) to catch it; the self-probe branch sits before `harness_run` is ever reached, so
the harness loop's own row for D3.7 recurses exactly one level (the recursive child takes the
probe branch immediately) rather than without bound.

**Two correctness gaps surfaced only once the harness ran for real, not on paper:**

1. **`generate-catalog.test.sh` and `generate-agent-adapters.test.sh` each declared three artifact
   classes (`source-document, generated-artifact, disposable-fixture`) but implemented a CLI probe
   for only one.** Under the old comment-grep check this was invisible — the comment existed, so
   the check passed. Under the real harness, `--probe source-document` and `--probe disposable-fixture`
   fell through to normal-mode execution (an unrelated exit code, not 2), and the harness correctly
   reported `did not fail on a seeded defect`. Both files' declared classes are narrowed to
   `generated-artifact` — the one class each actually probes — rather than building unneeded probes
   to match an inherited, inaccurate header.

2. **Enforcement Map rows that name the same test file more than once** (`adapter-coverage.test.sh`
   for D4.5/D4.6/D4.7; `distribution-packaging.test.sh` for D1.2/D4.3; `spec-record.test.sh` for
   D5.4/D5.5; `completion-coverage.test.sh` for D7.2/D7.4) were each being probed once per row —
   three times for `adapter-coverage.test.sh` alone — for no additional guarantee, since the probe
   proves a property of the test file, not of the rule row. `harness_run` now deduplicates by test
   filename (first-seen order), probing each unique file's declared classes exactly once regardless
   of how many rules cite it. This is exactly the 041-run reduction research R3 anticipated in
   principle; measuring it here is what exposed it was not yet implemented.

**Runtime budget, measured before and after:**

| State | Full `run-all.sh` wall clock (3 runs) |
|---|---|
| Before Phase 5 lands (Phase 4 checkpoint) | 1:51 |
| After T033-T038, before dedup | did not finish measuring — single-file harness alone measured 2:27 |
| After dedup (first-seen-per-test) | 3:26, 3:02 (both over the 180s budget) |
| After narrowing `distribution-packaging.test.sh` from 3 to 2 declared classes | 3:10, 2:57, 2:55 |

The suite is close to, and inconsistently on both sides of, the 180s budget even after the
reduction above; wall-clock variance of roughly 15-20s between otherwise-identical runs on this
machine accounts for most of the remaining spread (measured `user`+`sys` CPU time is stable around
199-203s across runs, while wall clock ranges 175-206s). Per the runtime contract ("if exceeded,

probe scope is reduced and the reduction is recorded rather than the budget restated"), the
reduction actually taken is: `distribution-packaging.test.sh`'s `generated-artifact` class
(missing-governance-document) is no longer declared or CLI-probed, since neither `D1.2` nor `D4.3`
(the two rules mapped to this file) names that scenario in its own text; its normal-mode check is
unchanged. No further reduction was made — the remaining cost is the two adapter-coverage classes
(one of which, `source-document`, genuinely rebuilds a currency tree and costs roughly 16s per
paired invocation) and the two shipped-tree-independence classes (each proving the scanner reaches a
different real location, `.highway/tools/` and the fixtures directory, at roughly 7s per paired
invocation) — reducing either further would remove a real, distinct guarantee rather than a
redundant one.

