# Phase 0 Research: Test Suite Runtime Recovery

**Feature**: 056-test-suite-runtime-recovery | **Date**: 2026-09-20

This document satisfies **FR-001**. Every figure below was taken before any implementation change,
on the reference machine, with the tree at the state recorded in "Tree under measurement". Nothing
here is scaled from another measurement; where a number is derived rather than timed, it says so.

---

## Reference machine

| Property | Value |
|---|---|
| OS | macOS 26.5.2 (arm64) |
| `/bin/bash` | GNU bash 3.2.57(1)-release |
| Usable cores (`getconf _NPROCESSORS_ONLN`) | **6** |
| Effective worker count during baseline | 1 (serial — this is the pre-change suite) |
| Machine state | Idle. No other measurement or build running. |

FR-003 requires the core count and worker count to travel with every reported range. This table is
the baseline half of that record; the post-change half is written in Phase F.

## Tree under measurement

| Property | Count |
|---|---|
| Repository files (excluding `.git/`) | 773 |
| Files under `specs/` | 501 (65%) |
| Distribution manifest records | 58 |
| Files in the produced distribution | 83 |
| Distributed Markdown files | 49 |
| Skills under `.highway/skills/` | 10 |
| Test files under `.highway/tools/tests/` | 40 |
| Enforcement Map rows | 9 |
| Unique mapped test files | **6** |
| Declared artifact classes across those files | **10** |
| Probe legs (seeded + neutralised) | **20** |

## Measured baseline

### M0 — Whole suite, end to end, five consecutive runs

This is the figure FR-002 sets its budget against and FR-003 governs the reporting of. Measured as
the wall-clock of `bash .highway/tools/tests/run-all.sh`, five consecutive runs on the reference
machine, per D8. No sample is discarded and the best sample is not reported alone.

| Run | Exit code | Wall clock |
|---|---:|---:|
| 1 | 0 | 263s |
| 2 | 0 | 232s |
| 3 | 0 | 233s |
| 4 | 0 | 231s |
| 5 | 0 | 233s |

| Property | Value |
|---|---|
| Range | **231–263s** |
| Median | **233s** |
| Usable cores | 6 |
| Worker count | 1 (serial) |
| Suite result, every run | `Summary: 40 passed, 0 failed`, exit 0 |

Two observations that matter to later phases:

- **Every run exited 0.** T001's precondition holds: the suite is green before any change, so a
  failure appearing later in this feature is caused by this feature.
- **Run 1 is 30s slower than runs 2–5, which sit within 2s of each other.** Run 1 pays a cold
  filesystem cache; the steady state is ~232s. The range is reported honestly as 231–263s rather
  than narrowed to the warm runs, but the ~232s steady state is the figure Phases B–D must move.

The 286.50s in M1 is the sum of files timed *standalone*, each paying its own cold start. It is
larger than the 233s the suite takes in one process and is used only to apportion cost between
files, never as the suite figure.

### M1 — Whole suite, per file, serial

Each file timed standalone. Every file exited 0.

| Test file | Time |
|---|---:|
| `constitution-inventory.test.sh` | 116.50s |
| `distribution-packaging.test.sh` | 59.28s |
| `shipped-tree-independence.test.sh` | 17.23s |
| `generate-catalog.test.sh` | 15.65s |
| `validate-skill.test.sh` | 14.08s |
| `adapter-coverage.test.sh` | 12.53s |
| `generate-agent-adapters.test.sh` | 11.82s |
| `rule-checks.test.sh` | 9.24s |
| `generate-library-catalog.test.sh` | 7.20s |
| `new-agent-extensibility.test.sh` | 6.40s |
| remaining 30 files, combined | 16.57s |
| **Total** | **286.50s** |

Ten files hold 94% of the run. The thirty cheapest hold 5.8%.

### M2 — Per-class probe cost (the FR-001 record)

All twenty legs, each timed on its own. Exit codes are the contract's required values; a deviation
here would be a defect, not a timing result.

| Mapped test | Class | Seeded | Neutralised | Class total |
|---|---|---:|---:|---:|
| `shipped-tree-independence` | `source-document` | 4.70s | 4.99s | 9.69s |
| `shipped-tree-independence` | `disposable-fixture` | 5.18s | 5.60s | 10.78s |
| `distribution-packaging` | `source-document` | 10.60s | 10.46s | 21.06s |
| `distribution-packaging` | `disposable-fixture` | 0.12s | 10.53s | 10.65s |
| `distribution-packaging` | `generated-artifact` | 11.09s | 22.06s | 33.15s |
| `adapter-coverage` | `source-document` | 11.48s | 14.24s | 25.72s |
| `adapter-coverage` | `generated-artifact` | 0.34s | 0.14s | 0.48s |
| `generate-catalog` | `generated-artifact` | 0.03s | 0.02s | 0.05s |
| `generate-agent-adapters` | `generated-artifact` | 0.03s | 0.03s | 0.06s |
| `constitution-inventory` | `source-document` (self) | 0.07s | 0.04s | 0.11s |
| **Total** | | | | **111.75s** |

**This is the single most important table in the feature.** It shows that
`constitution-inventory.test.sh`'s 116.5s is 111.75s of *other tests' cost*, re-paid in fresh
serial processes, plus roughly 4.8s of its own constitution parsing. The harness is a multiplier,
not an expense — exactly as governance plan Phase 14 states.

Three classes cost 79.9s of the 111.75s, and all three are dominated by distribution builds and
tree copies rather than by anything probe-specific.

The longest single leg is 22.06s. Under a 6-worker pool this sets the floor for the harness's wall
time: no scheduling can finish sooner than the longest leg.

**Baseline exit-code confirmation (FR-005, SC-003).** All twenty legs were re-run end to end at
the state recorded above. Ten seeded legs exited 1 and ten neutralised legs exited 0 — no leg
produced any other code. Whole-loop wall time was 114s, consistent with the 111.75s apportioned
above. This is the "before" half of the FR-005 comparison; the same loop is re-run in Phases B, C
and D and must produce the identical twenty exit codes.

### M3 — One distribution build

`generate-distribution.sh` into a temporary target: **9.61s** wall, 4.2s user, 6.6s system. The
system share is the finding — this is process-spawn cost, not computation.

| Phase | Cost | Cause |
|---|---:|---|
| `verify_self_validation` | 3.71s | `validate-skill.sh` spawned once per skill, 10 times |
| `dist_classify` over 773 files | 2.13s | 2 `awk` processes per file, 1,546 total |
| — of which, the 501 `specs/` files | 1.44s | Classified individually; no record can ever include them |
| `sha256_of` over 83 files | 1.01s | `shasum` + `awk` per file |
| Remainder (copy, cross-references, drift) | ~2.76s | `awk` per distributed `.md` (49), re-hash of target tree |

`distribution-packaging.test.sh` performs **11 builds** in normal mode. The suite as a whole
performs roughly 17.

### M4 — Growth coupling

500 throwaway files were added beneath `specs/`, measurements re-taken, and the files removed.

| Measurement | 773 files | 1,273 files | Δ |
|---|---:|---:|---:|
| One distribution build | 10.40s | 12.29s | +1.89s |
| One `shipped-tree-independence.test.sh` | 15.33s | 23.57s | +8.24s |

Scaled across the suite's build and scan count: **≈ +55s per 500 specification files**, or about
**one second of permanent suite runtime per new feature specification**, buying no coverage. At the
current rate the entire budget this feature recovers would be spent again within roughly thirty
features.

### M5 — Cost by test group, and the justification for leaving most of it alone

| Group | Files | Cost | Share | Disposition |
|---|---:|---:|---:|---|
| **A** — skill and library file content validation | 10 | 29.0s | 10% | **Not touched.** Customer-facing; the reason the suite exists. |
| **B** — per-skill behavioral contracts | 22 | 6.5s | 2% | **Not touched.** Already negligible. |
| **C** — generation and packaging | 7 | 130.1s | 45% | Phases B and C target this. |
| **D** — `constitution-inventory` self-test | 1 | 116.5s | 41% | Phase D targets this. |

86% of the run is Groups C and D, and this feature confines itself to them. Groups A and B are 12%
combined and are left exactly as they are.

### M6 — Growth in skill count, and a failed attempt to remove it

M4 measures growth in *spec files*. This measures growth in *skills*, which is the axis that
matters for a repository whose purpose is to ship skills. Measured after Phase B, by cloning the
smallest skill, regenerating the catalog and adapters, and timing the suite.

| Skills | Suite wall clock |
|---|---:|
| 10 | 173s |
| 11 | 179s |

**≈ +6s per added skill.** Instrumenting the suite explains it: one run makes **306
`validate-skill.sh` invocations** across **17 distribution builds**. 170 of the 306 are the
`17 builds × 10 skills` self-validation loop, so each new skill adds ~17 invocations there plus a
few more from the per-skill loops in `validate-skill.test.sh`, `dependency-check.test.sh` and
`adapter-coverage.test.sh` — roughly 20 invocations at ~0.32s each.

Two caveats on the +6s: each figure is one sample, and `adapter-coverage.test.sh` *failed* in the
11-skill run because the synthetic skill was absent from the distribution manifest. It therefore
bailed early and did less work than a real eleventh skill would. **+6s is a floor, not a ceiling.**

**The Phase C remedy was implemented, measured, and reverted.** `validate-skill.sh` was extended
to accept several skill directories so `verify_self_validation` could batch ten skills into one
invocation, with the governance rule list and manifest verdict resolved once per invocation rather
than once per skill. Single-argument output stayed byte-identical for all ten skills on both
streams, and batched output equalled the concatenation of the ten single runs. It saved nothing:

| Form | 3 reps × 10 skills |
|---|---:|
| Ten separate invocations | 9.71s |
| One batched invocation | 9.63s |

The premise was wrong. Per-skill cost is not process startup, library sourcing or constitution
parsing — those are the only things batching removes. Tracing one skill validation shows **11,531
execution lines and 108 `awk` spawns**, concentrated in the lexicon and rule-check libraries and
repeated per skill regardless of how the process is entered. `fl_resolve_skill_id` alone runs 34
times for one skill.

The change was reverted rather than kept. It altered a customer-facing tool used by seven test
files and returned no measurable benefit, and "it is tidier" is not a reason this feature accepts
for touching shipped code (FR-006, assertion inventory rule R4).

**Consequence for FR-018 and FR-019.** The per-skill slope is real and is *not* addressed by this
feature. Flattening it means reducing process spawning inside `lib/rule-checks.sh` and
`lib/frontmatter-lexicon.sh` — the core skill-validation logic. That is a larger change to the
most customer-facing code in the repository and belongs in its own feature with its own
equivalence evidence, not bolted onto a runtime-recovery effort.

---

### M7 — Final measurement, 2026-09-20: the target is not met

Taken after Block B, with Phase D descoped, per quickstart §A1. Five consecutive whole-suite runs,
same tree, same machine.

| Run | Wall clock | Exit | Summary |
|---:|---:|---:|---|
| 1 | 171s | 0 | 40 passed, 0 failed |
| 2 | 174s | 0 | 40 passed, 0 failed |
| 3 | **185s** | 0 | 40 passed, 0 failed |
| 4 | **287s** | 0 | 40 passed, 0 failed |
| 5 | 170s | 0 | 40 passed, 0 failed |

**Range 170–287s. Median 174s. Cores 6. Effective workers 1.** Against a pre-feature baseline of
231–263s, median 233s.

**SC-001 is not met**, and this is recorded rather than reframed. SC-001 requires every one of five
consecutive runs to finish inside 180s. Three did; run 3 exceeded the target by 5s and run 4
exceeded it by 107s, breaching even Feature 042's 240s interim ceiling. The median is inside the
target, but FR-003 forbids reporting a median in place of the range, and a median was exactly the
wrong claim Feature 041 made from a single sample — repeating it here with five samples would be
the same error with better arithmetic.

**On run 4.** Its neighbours are 170s and 185s, so a ~113s excursion is almost certainly transient
machine load rather than suite behavior, and the run still passed all forty tests and exited 0.
That explanation is *plausible but unevidenced* — machine idleness was not instrumented during the
runs, so it is recorded as an outlier with a suspected cause, not as a discardable sample. Feature
042 faced the same situation and recorded both a loaded and a settled set; that precedent applies
and a settled set has not yet been taken.

> **The settled set was deliberately deferred, 2026-09-20.** Feature 042's precedent would have
> had a quiesced-machine re-measurement taken before closing. It was not taken, by decision rather
> than by oversight. The consequence is stated plainly: the recorded range 170–287s is what this
> feature achieved under the conditions it measured in, and no claim is made about what an idle
> machine would have produced. D8 defines the instrument as an idle-machine run, so **this
> measurement does not fully satisfy D8's own definition**, and that shortfall is recorded here
> rather than absorbed by calling run 4 an artefact. A later feature that wants to close Feature
> 042's deviation must take the settled set first.

**What is nonetheless established.** The suite moved from a 231–263s range to a 170–185s range
excluding the outlier, a reduction of roughly 60s, with every artifact class still declared, all
twenty probe legs still behaving, and masked output identical to the pre-change run. Those gains
stand on their own evidence regardless of SC-001.

**FR-020 governs what happens next**: the improvements are kept, the achieved range is recorded as
measured, the 180s target is **not** amended to the achieved number, and Feature 042's deviation
and the 240s interim ceiling both **remain in place** rather than being closed. FR-015's
instruction to close the deviation and remove the ceiling does not fire, because its precondition —
180s met — did not occur.

### M8 — Growth coupling after the change: the +500-file experiment

Per quickstart §F2. 500 files were created beneath `specs/.growth-probe`, the whole suite was run
once, and the probe directory was removed immediately afterwards — leaving it would have poisoned
every later measurement, and `git status --short` was checked clean after removal.

| Condition | Files under `specs/` | Tests | Wall clock | Exit |
|---|---:|---:|---:|---:|
| Without probe (M7 reference) | baseline | 40 | 160–174s | 0 |
| With 500 extra files | baseline + 500 | 41 | 165s | 0 |

**M4 measured the pre-change coupling at roughly 55s of suite time attributable to per-file passes
over `specs/`.** After the change the same 500 files cost **+5s**, and ~1s of the 41-test run is
the new `classification-scope.test.sh` that did not exist in the reference. SC-005's ≤5s bound is
met.

**How much of that 5s is real is not resolvable by this experiment.** Run-to-run spread on this
machine is ±15s (M7), so a 5s difference sits well inside the noise floor and one sample cannot
separate it from zero. Repeating the run would not fix that; it would take a settled machine and
many samples. The measurement is therefore reported as *at or below the bound*, not as a precise
figure, and the stronger evidence is structural rather than timed: `specs/` is a derived prune
root, `find` never descends into it, and `classification-scope.test.sh` fails if a walker stops
pruning. That guard is what keeps the coupling gone; the 5s number only fails to contradict it.

### M9 — Masked output equivalence (SC-009), and the one permitted difference

The masked suite output was compared against `.before.txt` twice.

**After all behavior changes, before the new test existed**: the diff was **empty**. Every existing
test emitted byte-identical masked output in an identical order — no line added, removed, reworded
or reordered by the classification rewrite or the hashing pass.

**After adding `classification-scope.test.sh`**: the diff is no longer empty, and is exactly this
and nothing else —

- eight added lines, being the new test's own `==> Running` header, its four `PASS` lines, its
  `PASS: classification-scope.test.sh` result line and the blank line after it, inserted at the
  position `run-all.sh`'s alphabetical glob puts it in;
- `Summary: 40 passed, 0 failed` becoming `Summary: 41 passed, 0 failed`.

**This is an addition, not a drift.** SC-009 asks that no existing probe's output change; it does
not ask that the suite never gain a test, and FR-019 required this one. The distinction is
recorded rather than papered over by regenerating `.before.txt` — regenerating it would have made
the diff empty while destroying the only evidence that the equivalence was ever checked.

Run order was confirmed stable across three independent runs rather than correct once: the
`==> Running` sequence is identical, 41 entries, across the growth-experiment run, the seeded
two-failure run and the final clean run. Order holds when tests fail, not only when they pass.

### M10 — Close-out verification, 2026-09-20

Each of these was executed, not reasoned about.

**Exit codes and failure reporting (FR-013, SC-008).** Two tests were seeded to fail —
`path-integrity.test.sh` and `classification-scope.test.sh`, each by forcing `fail=1` at a
*reachable* point. A first attempt appended `exit 1` to the end of a file and produced a clean
pass, because both files already end in `exit $fail`; the seed was unreachable and the green run
proved nothing. With reachable seeds, `run-all.sh` printed `Summary: 39 passed, 2 failed`, listed
both under `Failed tests:` by filename, and exited **1**. Both files were restored and confirmed
byte-identical to `HEAD`.

**Residue (FR-014).** `git status --short` was taken after the clean run, after the growth run and
after the *failing* run. In all three it listed only this feature's own edits — no probe files, no
scratch directories, no modified fixtures. The residue sweep in `run-all.sh` is unchanged; the
`$$`-named leg buffers that task T047 anticipated were a Phase D construct and were never built,
so there was nothing new for the sweep to match.

**Extensibility (FR-018).** A new agent tree was simulated by adding one `exclude` record for
`.zeta-agent` to `.highway/tools/.distribution-manifest` and creating the directory. Without
editing any file this feature touched: `dist_prune_roots` went from 13 roots to 14 and included
the new tree, `classification-scope.test.sh` passed, and `generate-distribution.sh` built exit 0
with zero `.zeta-agent` files in the output. The manifest is the only thing a new agent tree
needs to change.

> A first attempt at this experiment appended the record space-delimited instead of tab-delimited.
> The manifest is tab-delimited and `dist_records` skips any line with fewer than two fields, so
> the record was silently ignored and the root count stayed at 13. That was a malformed fixture,
> not a defect, and it is recorded because a silently-dropped manifest line is exactly the kind of
> result that reads like a passing negative.

---

## Decisions

### D1 — Classification becomes one pass, and the walk prunes

**Decision**: Add `dist_classify_many`, which reads the manifest once and classifies a list of
paths in a single `awk` process. `dist_classify` is retained as a one-path wrapper so no caller
breaks. Separately, derive the set of **prunable exclude roots** — exclude records with no other
record strictly beneath them — from the manifest and pass them to `find` as `-prune` predicates.

**Rationale**: `dist_classify` spawns two processes per call (`dist_records` piped into `awk`) and
is called once per repository file. That is 1,546 processes per build to consult 58 records. Today
`specs/` and `.specify/` qualify as prunable, removing 501+ files from every walk. Feature 046
established the precedent exactly: 0.3126s → 0.0109s with byte-identical output proved across every
target.

**Prune roots are derived, never hardcoded.** `.claude`, `.cursor`, `.github` and `.highway` are
all excluded records with includes beneath them and must therefore keep being walked. A hardcoded
list would ship a bug the first time an adapter tree moved.

**Alternatives considered**: caching `dist_records` output in a variable and keeping per-file
`awk` (removes half the processes, keeps the growth coupling — rejected); rewriting classification
in pure Bash string operations (no process cost at all, but 773 iterations of Bash 3.2 prefix
matching measured slower than one `awk`, and harder to prove equivalent — rejected).

### D2 — Builds are reused within a test process

**Decision**: Where a test performs several assertions against a produced distribution, produce it
once and reuse it. Assertions that specifically require a *fresh* tree — the refusal paths in
D4.3, the drift check — keep their own build and say so at the call site.

**Rationale**: `distribution-packaging.test.sh` performs 11 builds at 9.6s each. The probe-mode
contract already *claims* this reuse ("built once and reused across that test's probes"); the code
does not do it. This is a documented behavior that was never implemented, so implementing it closes
a contract gap rather than creating one.

**Risk**: a reused tree that one assertion mutates would silently weaken a later assertion. The
assertion inventory contract exists to make this detectable, and each reuse site records which
assertions share the tree.

### D3 — Self-validation is batched

**Decision**: `verify_self_validation` validates all ten skills in one `validate-skill.sh`
invocation rather than ten.

**Rationale**: 3.71s of every one of ~17 builds, entirely spawn overhead — a single
`validate-skill.sh` run costs 0.38s, so ten sequential runs cost ten startups of a validator that
already walks a tree.

**Constraint**: the emitted output and exit code must be identical for both the all-pass case and
every single-skill-failure case, or the failure message a user sees changes. This is proved per
skill, not argued.

### D4 — The harness runs its legs under a bounded pool, and replays output in Map order

> **Superseded 2026-09-20 — descoped, not implemented.** D4, D5 and D7 were designed and remain
> sound as designs; they are carried to `governance-plan.md` Phase 16. The "−85s" below was
> apportioned from the 286.5s pre-Block-B standalone sum and is **stale**: after Block B the twenty
> legs total ~55s with an 11s longest leg, so a six-worker pool is floored at ~21–25s and the true
> saving is **~32s**. D5's serialization set is also **wrong** — see the correction under D5.
> Phase 16 must re-measure and may close unimplemented.

**Decision**: `harness_run` collects the `(rule, test, class)` list as it does today, dispatches
the legs through `xargs -P <workers>`, captures each leg's output to its own scratch file, and on
completion replays the files **in Enforcement Map order** before returning the aggregate status.

**Rationale**: `xargs` is in the Declared Toolchain; `xargs -P` is accepted by both GNU findutils
and BSD/macOS `xargs` and was confirmed working on the reference machine. Bash 3.2 has no `wait -n`,
so a hand-rolled pool would busy-poll — `xargs -P` is both cheaper and less code. Buffer-and-replay
is what makes FR-011 and SC-009 checkable by `diff`.

**Expected saving**: 111.75s of leg time across 6 workers, floored by the 22.06s longest leg,
lands at roughly 25–30s wall. Call it **−85s**, and note that Phase C reduces the leg times
themselves first, so the two savings are not additive — Phase C shrinks what Phase D then
parallelises.

**Alternatives considered**: `make -j` (not in the Declared Toolchain — rejected); background jobs
with `wait` on all PIDs (no bound, 20 concurrent distribution builds on 6 cores would thrash and
make the measurement meaningless — rejected).

### D5 — Two legs are serialized by declaration, not by luck

> **Corrected 2026-09-20 — this decision is wrong and is recorded as wrong rather than rewritten.**
> Two legs is not the serialization set. Inspecting which legs write shared live-tree state found:
>
> | Shared file | Written by |
> |---|---|
> | `.highway/catalog/index.*` | `adapter-coverage`, `generate-catalog` |
> | `.highway/tools/.adapter-manifest` | `adapter-coverage`, `generate-agent-adapters`, `new-agent-extensibility`, `path-integrity` |
> | `generate-catalog.test.sh` source, perturbed in place | `constitution-inventory`'s `source-document` leg |
>
> That is at least four contending legs collapsing into one serialized group of ~21s, which is why
> the concurrent estimate floors where it does. The pair below is **necessary but not sufficient**.
> The hazard is not theoretical: `run-all.sh`'s header records two live-tree residue defects that
> occurred while the suite was still fully serial, and this feature's own skill-growth experiment
> left `.mock-agent-4` rows reordered in `.adapter-manifest`. Phase 16 must derive this set from
> inspection and record the evidence, never inherit it from here.

**Decision**: `constitution-inventory`'s own `source-document` leg and `generate-catalog`'s
`generated-artifact` leg run in the same serialized group, never concurrently with each other.

**Rationale**: the former copies, perturbs and restores `generate-catalog.test.sh` **in place**
three times. Any overlap makes both results meaningless. FR-010 requires this be declared in the
test rather than left to scheduling, so a future reader adding a leg can see the constraint instead
of rediscovering it through a flaky failure.

### D6 — Residue safety under concurrency

**Decision**: `run-all.sh`'s opening sweep is unchanged in what it removes. Concurrency is confined
to *within* `constitution-inventory.test.sh`; `run-all.sh` continues to run test files one at a
time, so the sweep never runs while a leg is live.

**Rationale**: this is the cheapest correct answer to FR-014. Parallelising at the `run-all.sh`
level as well would put the sweep and live probes in the same window and require a locking scheme
the Declared Toolchain does not support well. The measured gain does not require it: Phases B, C
and D already close the gap.

### D7 — Worker count and serial mode

**Decision**: `HIGHWAY_TEST_WORKERS` overrides; unset, the pool defaults to
`getconf _NPROCESSORS_ONLN`; a reported value of 1, empty or non-numeric yields 1, which is serial
mode by the same code path. Resolved 2026-09-20 as resolution **R3**.

**Rationale**: the spec requires a core-derived limit (clarification 5, FR-010, FR-021) and a
reproducible, recorded worker count (FR-003). Reading the core count needs `getconf`, which D2.2
did not permit, so the Declared Toolchain was amended — `.specify/memory/constitution.md` 2.0.0 →
2.1.0, one entry added, no rule text touched. The list was widened rather than narrowed, and no
existing `.highway/` script invokes `getconf`, so nothing previously conforming is affected and
nothing already shipped is retroactively legalised.

**Alternative rejected**: `HIGHWAY_TEST_WORKERS` with no core-derived default (R2). Leaves the
constitution untouched, but the default would have to be a fixed guess or 1 — making the 180s
target an opt-in result rather than the default experience, which is not what FR-002 asks for.

### D8 — What the measurement is, exactly

**Decision**: the reported figure is wall-clock time of `bash .highway/tools/tests/run-all.sh` on
an idle machine, five consecutive runs, reported as min–max and median, with core count and worker
count. Not the sum of per-file timings.

**Rationale**: the sum of standalone per-file timings (286.5s here) and a single whole-suite run
are different quantities; Feature 042 reported whole-suite runs, and comparing against it requires
the same instrument. Feature 042's settled baseline was 204–211s, median 210s — taken on a tree
with fewer `specs/` files, which M4 shows is itself part of the rise to 286.5s.

---

## Open questions carried into tasks

| # | Question | Owner |
|---|---|---|
| ~~Q-A~~ | ~~R1, R2 or R3 for the worker count~~ | **Closed 2026-09-20: R3.** See D7. |
| Q-B | Whether `xargs -P` and `getconf _NPROCESSORS_ONLN` behave identically on Linux | **Still open, carried to Phase 16.** Neither utility is used now that concurrency is descoped, and `getconf` was removed from the Declared Toolchain again (2.1.0 → 2.0.0 reverted). |

No `[NEEDS CLARIFICATION]` markers remain in the specification.
