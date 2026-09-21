# Feature Specification: Test Suite Runtime Recovery

**Feature Branch**: `056-test-suite-runtime-recovery`

**Created**: 2026-09-20

**Status**: Draft

**Input**: User description: "Bring the test suite run time down to the 180 second target by making the probes and the packaging work cheaper, without declaring fewer artifact classes, removing any assertion, or loosening any probe. Governance plan Phase 14."

## Context

Measured 2026-09-20 on the reference machine (macOS, Bash 3.2.57), forty test files timed
individually and serially: **286.5 seconds**, every file exiting 0. That is past the 180 second
target Phase 14 sets and past the 240 second interim ceiling Feature 042 set. Feature 042 recorded
the ceiling as held under normal conditions and breached only under load. That record is now
superseded: the ceiling is breached with the machine idle.

Three findings drive this feature.

**The suite's cost is concentrated.** Ten files hold 94% of the run; the remaining thirty hold 5.8%.
`constitution-inventory.test.sh` costs 116.5s and `distribution-packaging.test.sh` costs 59.3s.

**`constitution-inventory` is a multiplier, not a cost.** Of its 116.5s, **111.75s** is re-executing
six other test files in probe mode, serially, in fresh processes, twice per declared artifact class.
Its own constitution parsing is roughly 4.8s. Its cost is a function of the Enforcement Map, exactly
as Phase 14 states.

**One unit of work dominates.** A single `generate-distribution.sh` build costs 9.6s — 4.2s user and
6.6s system, so it is process-spawn overhead rather than computation. Packaging-related work
(`distribution-packaging`, `shipped-tree-independence`, `adapter-coverage`, each in normal mode and
in probe mode) accounts for roughly 200s of the 286.5s run.

**The growth the suite is showing is `specs/`.** The repository holds 773 files, 501 of them (65%)
under `specs/`. `specs/` is excluded by a single manifest record and can never ship, yet every
distribution build and every shipped-tree scan re-classifies each of those files individually. This
was measured directly by adding 500 throwaway files under `specs/` and re-measuring: one build moved
from 10.40s to 12.29s, and one `shipped-tree-independence` run moved from 15.33s to 23.57s. Scaled
across the suite that is roughly **+55s per 500 spec files**, or about **one second of permanent
suite runtime per new feature specification**, buying no coverage.

**A correction this feature records.** Phase 14 carries forward a count of thirteen declared artifact
classes across eight mapped test files. After Feature 044 removed four Enforcement Map rows and the
two test files they named, the Map has nine rows naming **six unique test files** declaring **ten
artifact classes**. That figure is not inferred from reading source; it was counted by executing all
twenty probe legs individually. Phase 14's number is corrected here rather than left standing.

## Clarifications

### Session 2026-09-20

- Q: May the work be made cheaper by probing fewer artifact classes, or by probing a class once
  rather than in a seeded/neutralised pair? → A: No. Phase 14 forbids trading declared scope for
  speed, and this feature adopts that refusal as a hard boundary. A change that makes a probe prove
  less is out of scope even if it meets the target.
- Q: Where must the before-change measurements and the assertion inventory be recorded so FR-006
  can be checked rather than trusted? → A: Per-class timings go in this feature's `research.md`
  under a "Measured baseline" heading, following Feature 041. The assertion inventory goes in a
  contract file under this feature's `contracts/`, following Feature 046's `required-key-proof.md`,
  because it is a fixed record a later reader must diff against rather than narrative evidence.
- Q: Under concurrency, must the suite's printed output keep today's order, or only arrive whole
  and unmixed? → A: Today's order exactly. Each leg's output is buffered and emitted in Enforcement
  Map order, so the before and after outputs can be compared by `diff` rather than by judgement,
  and a run-to-run difference always means a real change rather than scheduling noise. Live
  streaming of progress is given up in exchange.
- Q: Should the "adding specifications must not slow the suite" guarantee be enforced permanently
  or verified once? → A: Both, but not by timing. The 5-second bound is measured once as this
  feature's acceptance evidence. The standing guard is structural: a permanent check that fails if
  any classification pass enumerates paths beneath a location no manifest record can include. A
  permanent timing assertion was rejected as self-defeating — it would cost more than the budget it
  protects and would be flaky on shared hardware, and flaky tests get disabled.
- Q: What happens if the suite gets substantially faster but cannot reach 180 seconds without
  loosening a probe? → A: Ship the gains that preserve every probe, record the measured range
  honestly, and leave both the 180 second target and Feature 042's open deviation standing for a
  later feature. The target is not amended to the achieved number, and no class is dropped to
  reach it. Phase 14's instruction to stop applies to the coverage-losing route, not to correct
  work that fell short.
- Q: Does the parallel fan-out need a declared reproducible limit and a serial fallback? → A: The
  limit is derived from the machine's usable core count, and an explicit way to run the suite
  serially must exist. Because the limit varies by machine, the effective worker count and the
  core count MUST be recorded alongside every reported measurement, or the range is not
  comparable to any other machine's.

## User Scenarios & Testing

### User Story 1 - Run the suite inside the budget (Priority: P1)

A maintainer runs the full test suite before committing and it completes inside the 180 second
target, reliably rather than on a best sample, so the suite is something they run rather than
something they avoid.

**Why this priority**: A suite over its budget is the standing pressure to declare fewer artifact
classes, which is how `D4.3` became unprovable in the first place. Recovering the runtime is what
protects the coverage.

**Independent Test**: Run the full suite five consecutive times on an idle reference machine and
record every wall-clock time as a range.

**Acceptance Scenarios**:

1. **Given** an idle reference machine, **when** the full suite is run five consecutive times, **then** every run completes in 180 seconds or less and every run exits 0.
2. **Given** those five runs, **when** the result is reported, **then** it is reported as a range and a median, not as a best sample.
3. **Given** a test file that fails, **when** the suite runs, **then** the suite still exits non-zero and names the failing file exactly as it does today.

---

### User Story 2 - Keep every probe proving what it proves (Priority: P1)

A reviewer can confirm that the faster suite decides exactly what the slower one decided: the same
artifact classes are declared, the same probes still fail when their behavior is removed, and no
assertion has been dropped to buy time.

**Why this priority**: This is the whole difficulty of the phase. Making a number look right by
shrinking what the number is about is the failure mode this repository has been correcting since
Feature 039, and a runtime feature is the easiest place for it to recur.

**Independent Test**: Compare the declared artifact class inventory and the per-test assertion
inventory before and after, and run every seeded and neutralised probe leg individually.

**Acceptance Scenarios**:

1. **Given** the class inventory recorded before any change, **when** it is re-read after the change, **then** the same six mapped test files declare the same ten artifact classes.
2. **Given** each of the twenty probe legs, **when** the seeded leg runs, **then** it exits non-zero; **when** the neutralised leg runs, **then** it exits zero.
3. **Given** any test whose internals changed, **when** its assertion inventory is compared against the recorded baseline, **then** no assertion has been removed or weakened, and any change to how a probe does its work is recorded against the behavior it still proves.
4. **Given** the behavior behind any probe is removed, **when** the suite runs, **then** the suite fails and names that rule id, test file, and class.
5. **Given** the suite output recorded before the change, **when** the suite is run after it, **then** the two outputs are identical once reported durations are masked.

---

### User Story 3 - Stop the suite growing with the specification history (Priority: P2)

A maintainer adds a new feature specification and the suite does not get measurably slower, because
the suite's cost tracks what ships rather than what the repository has accumulated.

**Why this priority**: Without this the target is met once and lost again. At roughly one second per
feature, the budget recovered by this feature would be spent within about thirty features.

**Independent Test**: Measure the full suite, add five hundred files under a throwaway directory
inside `specs/`, re-measure, and remove them.

**Acceptance Scenarios**:

1. **Given** a measured suite runtime, **when** 500 additional files are placed under `specs/` and the suite is re-run, **then** total runtime increases by no more than 5 seconds.
2. **Given** a path that cannot enter the distribution under any manifest record, **when** the distribution is produced, **then** that path is not classified individually.
3. **Given** a manifest record that includes something beneath an otherwise excluded location, **when** the distribution is produced, **then** that record is still honored and the included path still ships.
4. **Given** a change that reintroduces a per-file pass over an excluded location, **when** the suite runs, **then** it fails and names that location, without measuring elapsed time.

---

### User Story 4 - Read an honest runtime record (Priority: P2)

A reader of the probe-mode contract finds the measured range for the suite as it stands, with the
deviation Feature 042 recorded closed rather than left open, and no second target surviving beside
the first.

**Why this priority**: Feature 041 claimed a budget it had measured once; Feature 042 corrected that
claim rather than the target. Leaving either the deviation or the interim ceiling in place after the
target is met would repeat the defect both features exist to remove.

**Independent Test**: Read the probe-mode contract's runtime section and confirm it states the new
measured range, no longer states an interim ceiling, and no longer records the target as knowingly
unmet.

**Acceptance Scenarios**:

1. **Given** the 180 second target is met, **when** the probe-mode contract is read, **then** it records the measured range and median from the five-run sample.
2. **Given** the target is met, **when** the contract is read, **then** the 240 second interim ceiling is removed rather than retained as a second target.
3. **Given** Phase 14's carried-forward class count, **when** the contract is read, **then** it records ten classes across six mapped test files and names the count as measured by execution.
4. **Given** 180 seconds was not reached, **when** the contract is read, **then** it states the achieved range, still states 180 seconds as the target, and still records the deviation as open.

---

### Edge Cases

- **Two probe legs mutating the same file.** `constitution-inventory`'s own `source-document` probe
  copies, perturbs and restores `generate-catalog.test.sh` in place. It cannot run at the same time
  as `generate-catalog.test.sh`'s own probe, or either result is meaningless. Any concurrency must
  declare this rather than happen to avoid it.
- **Probe legs seeding into the live tree.** `distribution-packaging`, `adapter-coverage` and
  `shipped-tree-independence` each seed probes into the real repository and name them with their own
  PID. Under concurrency the PIDs still differ, but `run-all.sh`'s opening residue sweep must not
  remove a probe another leg is currently using.
- **A run killed mid-flight.** Residue left by an interrupted concurrent run must still be
  attributable to no later run, exactly as the current sweep guarantees.
- **Interleaved failure output.** A failure reported while several legs run concurrently must still
  arrive as a complete, readable message naming its rule id, test file and class, and must appear
  in the same position in the output that it occupies today.
- **A machine with one usable core.** The suite must still complete and still exit correctly, even
  if it does not meet 180 seconds there. It runs serially in that case, by the same path the
  explicit serial mode uses. The target is stated against the reference machine.
- **A newly added agent or skill.** Adding one must not require touching whatever makes the suite
  fast, or the speed work becomes a tax on the extensibility contract Feature 007 established.

## Requirements

### Functional Requirements

> **Scope correction, 2026-09-20 — concurrency descoped.** The requirements marked **DEFERRED**
> below were designed in full but not implemented. They are recorded here as **not met**, not
> withdrawn, and are carried to `governance-plan.md` Phase 16. Two reasons, both measured. First,
> Block B reduced the legs these requirements parallelise from 111.75s to ~55s, so the saving fell
> from the planned −85s to ~32s. Second, the serialization set this feature's `research.md` D5
> recorded as a single leg pair was verified wrong on 2026-09-20: at least four legs contend over
> `.highway/catalog/index.*` and `.highway/tools/.adapter-manifest`. Implementing concurrency on a
> live tree against a known-incorrect serialization set was judged the wrong trade for 32s, and a
> separate measured finding — ~6s of suite time per added skill, addressed by Phase 15 — removes
> roughly 60% of the same work, which would erode this saving to ~15–22s if done afterwards. The
> sequencing is therefore Phase 15 first, then re-measure and decide. FR-020 governs the outcome:
> the target is **not** amended to the achieved number.

- **FR-001**: The per-class cost of every declared artifact class MUST be measured and recorded in this feature's `research.md` under a "Measured baseline" heading before any change is made, and the record MUST state the measurement as taken rather than scaled from another class.
- **FR-002**: The full suite MUST complete in 180 seconds or less across at least five consecutive runs on the reference machine, with every run exiting 0.
- **FR-003**: The measured result MUST be reported as a range and a median across those five runs, never as a best sample, and MUST record the machine's usable core count and the effective worker count the runs used. *(Met. The effective worker count is 1, because concurrency is deferred; it is recorded as measured rather than omitted.)*
- **FR-004**: Every artifact class declared before the change MUST still be declared after it, and the class inventory MUST be compared mechanically rather than by reading source.
- **FR-005**: Every seeded probe leg MUST still exit non-zero and every neutralised leg MUST still exit zero, for all ten classes across all six mapped test files.
- **FR-006**: No assertion MUST be removed or loosened. The per-test assertion inventory MUST be captured in a contract file under this feature's `contracts/` before any change is made, and any change to how a probe performs its work MUST be recorded there against the behavior that probe still proves.
- **FR-007**: Classifying repository paths for distribution MUST NOT require work proportional to the number of files that no manifest record can include.
- **FR-008**: A manifest record that includes a path beneath an otherwise excluded location MUST continue to be honored, and the resulting distribution contents MUST be byte-identical to today's.
- **FR-009**: The suite MUST NOT produce the distribution more times than its assertions require; a build MUST be reused by any assertion that does not require a freshly produced tree.
- **FR-010**: **DEFERRED to Phase 16 — not met.** Probe legs that do not mutate shared state MAY execute concurrently, up to a limit derived from the machine's usable core count. Legs that mutate a file another leg reads MUST be serialized, and that serialization MUST be declared in the test rather than left to timing. *Phase 16 must re-derive the serialization set; this feature's D5 answer is recorded as incorrect.*
- **FR-021**: **DEFERRED to Phase 16 — vacuously true.** An explicit way to run the entire suite serially MUST exist, MUST produce the same output and the same exit code as a concurrent run, and MUST be the behavior on a machine reporting one usable core. *Serial execution is the only mode that exists, so this is satisfied by there being nothing to distinguish it from — which is not the same as having been implemented.*
- **FR-011**: The suite's output MUST be identical in content and in order to today's serial output. ~~Concurrently executing legs MUST have their output buffered and emitted in Enforcement Map order~~ *(deferred to Phase 16)*, and a failure MUST still name its rule id, test file and artifact class in the exact message shape the probe-mode contract's failure table requires. *(First and last clauses met and verified by masked-output comparison against `.before.txt`.)*
- **FR-012**: Total suite runtime MUST NOT increase by more than 5 seconds when 500 additional files are added beneath `specs/`. This bound is measured once as acceptance evidence for this feature and MUST NOT become a standing timing assertion in the suite.
- **FR-019**: A standing automated check MUST fail if any classification pass enumerates paths beneath a location that no manifest record can include, and that check MUST NOT depend on wall-clock measurement.
- **FR-020**: If 180 seconds is not reached while FR-004 through FR-006 hold, the improvements that hold them MUST still be kept, the achieved range MUST be recorded as measured, the 180 second target MUST NOT be amended to the achieved number, and Feature 042's deviation and the interim ceiling MUST remain in place rather than be closed.
- **FR-013**: `run-all.sh` MUST continue to exit 0 when every test passes and non-zero when any test fails, naming each failing file.
- **FR-014**: ~~The residue sweep MUST NOT remove a probe artifact that a concurrently executing leg is still using~~ *(deferred to Phase 16 — no leg executes concurrently)*, and MUST still remove residue left by an interrupted earlier run. *(Second clause met.)*
- **FR-015**: The probe-mode contract MUST be updated to state the newly measured range and median, the deviation Feature 042 recorded MUST be closed rather than left standing, and the 240 second interim ceiling MUST be removed once 180 seconds is met.
- **FR-016**: The declared artifact class count MUST be recorded as ten classes across six mapped test files, measured by executing every leg, correcting the count Phase 14 carries forward.
- **FR-017**: No constitution rule MUST be added or amended, and neither Layer 1 nor Layer 2 MUST be touched.
- **FR-018**: Adding a new agent or a new skill MUST NOT require any change beyond what the existing extensibility contracts already require.

### Key Entities

- **Suite runtime budget**: The 180 second target, the measured range that evidences it, and the interim ceiling that is retired once the target is met.
- **Artifact class probe leg**: One `(test file, class, seeded|neutralised)` execution. Twenty exist today across ten classes and six mapped test files. Each is independently timed and independently required to behave.
- **Distribution build**: One complete production and verification of the user-facing tree. The suite's dominant unit of cost, at 9.6 seconds, mostly process-spawn overhead.
- **Path classification pass**: One walk of repository paths deciding include, exclude or unclassified for each. Today proportional to total repository size; required to become proportional to what can ship, and held there by a standing structural check rather than by a timing assertion.
- **Assertion inventory**: The per-test record of what each test decides, captured before the change as a contract file so that FR-006 can be checked rather than asserted.
- **Runtime record**: The runtime section of the probe-mode contract, which is the document a future reader consults and which must not outlive its own accuracy.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Five consecutive full-suite runs on an idle reference machine each complete in 180 seconds or less, reported as a range and a median alongside the machine's core count and the effective worker count (which is 1 — see the scope correction above).
- **SC-002**: The declared artifact class inventory is identical before and after: ten classes across six mapped test files.
- **SC-003**: All twenty probe legs behave per contract after the change — ten seeded legs exit non-zero, ten neutralised legs exit zero.
- **SC-004**: Removing the behavior behind any one probe causes the suite to fail and name that rule id, test file and class, demonstrated for every class rather than argued from source.
- **SC-005**: Adding 500 files beneath `specs/` changes total suite runtime by no more than 5 seconds, against a measured baseline of roughly 55 seconds today.
- **SC-010**: Reintroducing a per-file pass over an excluded location causes the suite to fail and name that location, demonstrated by seeding the regression rather than argued from source.
- **SC-011**: **DEFERRED to Phase 16 — unverifiable here.** A serial run and a concurrent run of the same tree produce the same exit code and the same output once reported durations are masked. *No concurrent run exists to compare against. The equivalent evidence this feature does hold is that the post-change serial run matches the pre-change serial run under the same mask.*
- **SC-006**: The distribution produced after the change is byte-identical to the one produced before it, aside from the recorded generation timestamp the Observable already excepts.
- **SC-007**: The probe-mode contract states the measured range, records no interim ceiling, and records no open runtime deviation.
- **SC-008**: `run-all.sh` exits 0 with every test passing, and exits non-zero naming the failing file when any single test is made to fail.
- **SC-009**: The suite's output after the change differs from the output before it only in reported durations; compared line by line with durations masked, the two are identical, and repeated runs produce the same order every time.

### Outcome, recorded 2026-09-20

| # | Status | Evidence |
|---|---|---|
| SC-001 | **NOT MET** | 170–287s over five runs; three inside 180s, two outside. FR-020 applies: improvements kept, target not amended. |
| SC-002 | Met | Ten classes across six mapped files, identical before and after. Nothing dropped. |
| SC-003 | Met | Twenty legs re-run individually; every contract exit code unchanged, zero violations. |
| SC-004 | Met | Demonstrated per class by the seeded/neutralised leg pairs, by execution. |
| SC-005 | Met, at the bound | +500 files cost +5s. Inside this machine's ±15s spread, so reported as at-or-below rather than as a precise figure; the structural guard is the stronger evidence. |
| SC-006 | Met | All 83 files byte-identical aside from the excepted timestamp. |
| SC-007 | **NOT MET** | The contract states the measured range, but the 240s interim ceiling is **retained** and Feature 042's runtime deviation stays **open** — because SC-001 was not met. This criterion silently assumed SC-001 would be. It is recorded as failed rather than reworded. |
| SC-008 | Met | Two seeded failures: exit 1, `Summary: 39 passed, 2 failed`, both named. |
| SC-009 | Met, with one declared addition | Empty masked diff across all pre-existing tests. The only difference is the new `classification-scope.test.sh` block and the count going 40 → 41 — an addition FR-019 required, not a drift. |
| SC-010 | Met | Seeded the regression, observed exit 1 naming the offending walker and the unpruned roots, restored. |
| SC-011 | **DEFERRED** | No concurrent run exists to compare against. |

**Eight met, two failed, one deferred.** SC-001 and SC-007 failed together and for the same
reason. Neither is amended.

## Assumptions

- The reference machine is the one the 2026-09-20 measurements were taken on: macOS with Bash 3.2.57 as `/bin/bash`, idle. Timings on other hardware are expected to differ; the target is stated against this machine, as Features 041, 042 and 046 stated theirs.
- The Declared Toolchain is unchanged. No new runtime dependency is introduced; the work stays in Bash 3.2-compatible shell, `awk`, `sed` and `grep`, consistent with every prior feature in this repository.
- `specs/` remains in the repository and remains excluded from the distribution. This feature makes its presence cheap rather than removing it.
- The Enforcement Map is the authority on which tests are probed. If a rule is added or removed during this feature, the class inventory baseline is re-taken rather than carried.
- Feature 046's precedent applies: a check may be reimplemented for speed provided its output and exit status are proved byte-identical across every target it decides. That proof is required here, not assumed.
- The thirty inexpensive test files, which validate the shipped skill content and each skill's behavioral contract, are not a target of this work. They cost 16.6 seconds combined and are left alone.
