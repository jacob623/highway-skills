# Feature Specification: Probe Reachability Correction

**Feature Branch**: `042-probe-reachability-correction`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "Feature 041 made `D3.7` execute a real probe for every registered `[auto]` check instead of grepping for a declaration comment, and that mechanism works — it caught two test files declaring three artifact classes while implementing one, and it caught Feature 041's own coverage record. An assessment of the completed feature against the tree found three defects it shipped anyway. First, `D4.3`'s Enforcement Map row promises that `distribution-packaging.test.sh` asserts refusal to overwrite an untracked directory and a modified file, naming each. That guard exists and runs in normal mode, but the file declares only the artifact classes `source-document` and `disposable-fixture`, and neither probe reaches the guard, so no probe proves `D4.3`'s enforcement is capable of failing. The file passes `D3.7` on a technicality: it proves the classes it declares, and declares none covering `D4.3`'s behavior. Second, Feature 041's task record marked the runtime budget met on a single favourable sample of 176.39 seconds against a 180 second budget, when six measured runs of the same suite gave 206, 190, 176, 175, 175 and 185 seconds and an independent post-merge run gave 185.75 — the budget is straddled, not met, and the completion claim was made against the best sample rather than the known distribution. Third, Feature 041's `coverage.md` states under `FR-010` that all twelve Enforcement-Map-mapped checks were proved to fail per declared class, where the measured figure is thirteen rows across eight unique test files; twelve was carried forward from a forecast in the governance plan and never counted. Close the first defect by declaring a third artifact class on `distribution-packaging.test.sh` that reaches the overwrite-refusal guard, so `D4.3`'s enforcement is provable rather than assumed. Record the runtime consequence honestly rather than restating the budget: the seeded leg of that probe costs 0.06 seconds because the generator refuses before it copies anything, the neutralised leg costs 7.86 seconds because it is a full build, and adding roughly eight seconds to a suite already measured between 175 and 206 seconds means the 180 second target is knowingly exceeded, not met. Supersede Feature 041's probe-mode contract rather than editing it, because that file sits in a completed spec directory. Correct the twelve to the measured thirteen rows across eight files. Add no constitution rule, amend no rule, and do not weaken any assertion Feature 041 added."

## Clarifications

### Session 2026-09-10

- Q: Should this feature close all three parts of the `D4.3` promise, or only make the existing untracked-directory assertion probe-reachable? → A: Option B — close all three: assert the modified-file refusal, assert both messages name the target, and make both reachable from declared classes.
- Q: Should both refusal paths sit under one declared artifact class, or should each get its own class? → A: Option A — one class (`generated-artifact`), whose seeded probe builds one target and asserts both refusals, so removing either from the generator still fails the probe.
- Q: What should the probe-mode contract state as the runtime obligation while the suite is knowingly over its 180-second target? → A: Option B — keep 180s as the target, record it as knowingly unmet, and add an interim ceiling the suite must not exceed, with Phase 14 owning the return to 180.
- Q: Is `D4.3` the only Enforcement Map rule its mapped test's probes fail to reach? → A: No — measured 2026-09-10, `spec-record.test.sh` reaches `D5.4` but not `D5.5`, and `completion-coverage.test.sh` reaches neither `D7.2` nor `D7.4`. Option C — correct all three tests, and add the missing class-to-rule join as a requirement of this feature so the next mapped rule cannot repeat it.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - `D4.3`'s enforcement is provable, not assumed (Priority: P1)

As a Highway maintainer, I want the check that enforces `D4.3` to be able to demonstrate that it
fails when the generator stops refusing to overwrite a target it did not produce, so that the
Enforcement Map's promise about that check is something the suite verifies rather than something a
reader takes on trust.

**Why this priority**: This is the only one of the defects that leaves a real protection undefended.
`generate-distribution.sh` writes a tree into a caller-supplied directory; its refusal to overwrite
a target it did not produce is what stands between a mistyped argument and a destroyed directory of
hand-written files. `D4.3`'s Enforcement Map note promises refusal for an untracked directory *and*
a modified file, naming each. Measured 2026-09-10: the untracked-directory half is asserted but
unprobed, the modified-file half is asserted nowhere in any mode, and neither refusal message is
inspected because the generator's output is discarded. All three could be deleted and the suite
would pass while `D3.7` reported every mapped check proved.

**Independent Test**: Probe each declared class seeded and neutralised and confirm the exit codes;
remove each refusal path from the generator in turn and confirm the corresponding probe stops
detecting it.

**Acceptance Scenarios**:

1. **Given** `distribution-packaging.test.sh` declares a `generated-artifact` class covering both
   refusal paths, **When** it is probed seeded, **Then** the test exits non-zero.
2. **Given** that class, **When** it is probed with `--neutralise`, **Then** the test exits zero.
3. **Given** the generator's refusal to overwrite an untracked directory is removed, **When** the
   seeded probe for that path runs, **Then** it no longer exits non-zero, demonstrating the probe
   is bound to the behavior rather than to a fixture.
4. **Given** the generator's refusal to overwrite a modified file inside a target it did produce is
   removed, **When** the seeded probe for that path runs, **Then** it no longer exits non-zero.
5. **Given** either refusal fires, **When** the assertion evaluates it, **Then** it requires the
   message to name the offending path, rather than accepting any non-zero exit.
6. **Given** `constitution-inventory.test.sh` executes each mapped test's declared probe per class,
   **When** the suite runs, **Then** every newly declared class is among those it executes.
7. **Given** the probe has run to completion or failed part-way, **When** the tree is inspected,
   **Then** no probe artifact remains anywhere under the repository.

---

### User Story 2 - The suite's runtime is recorded as measured, not as targeted (Priority: P2)

As a Highway maintainer, I want the recorded runtime of the test suite to reflect the distribution
of measured runs rather than the most favourable one, so that a timing claim in a completion record
is the same kind of evidence as every other claim the project now demands.

**Why this priority**: The defect is in the record rather than in the behavior, but it is the
precise failure mode Feature 041 exists to eliminate, committed while completing Feature 041. A
project that enforces evidence for coverage rows and accepts a hand-picked sample for a timing
budget has a rule it applies selectively.

**Independent Test**: Read the superseding contract and confirm it states a measured range with the
number of runs behind it, and that no document in this feature claims the 180 second target is met.

**Acceptance Scenarios**:

1. **Given** the superseding probe-mode contract, **When** it is read, **Then** it states the
   measured runtime as a range across a stated number of runs, not as a single figure.
2. **Given** this feature adds probe work, **When** the runtime consequence is recorded, **Then**
   the added cost is stated as measured per leg rather than estimated.
3. **Given** the 180 second target is exceeded, **When** the record is written, **Then** it says so
   and names the follow-up that is expected to recover the time, rather than revising the target to
   match the measurement.

---

### User Story 3 - Feature 041's coverage record states a counted figure (Priority: P3)

As a Highway maintainer, I want Feature 041's coverage record to state the number of enforced
checks that was counted rather than the number that was forecast, so that a coverage record is not
itself a place where an unverified number survives.

**Why this priority**: Lowest impact of the three — the claim is directionally right and no
behavior depends on it. It is in scope because `D5.1` permits a completed feature's `coverage.md`
to be corrected in place, so leaving a known-wrong figure standing is a choice rather than a
constraint.

**Independent Test**: Count the `[auto]` rows in the Enforcement Map and the unique test files they
name, and confirm the corrected record states both figures.

**Acceptance Scenarios**:

1. **Given** Feature 041's `coverage.md`, **When** `FR-010`'s evidence is read, **Then** it states
   thirteen Enforcement Map rows across eight unique test files.
2. **Given** the correction, **When** the completion coverage check runs, **Then** it still passes
   and every other row in that record is unchanged.

---

### User Story 4 - Declaring what a feature corrects does not require it to be finished (Priority: P3)

As a Highway maintainer, I want to declare in the register which feature a new corrective feature
supersedes at the moment I create it, so that traceability is stated when the intent is formed
rather than only once the work is done.

**Why this priority**: Found while registering this feature, not by review. The corrective set
`D7.5` is decided against is derived from the register's `Corrects` column with no filter on
`Status`, so declaring a corrected feature before completion demands a completion record that
cannot exist yet. Feature 041 introduced this when it replaced a hardcoded list of eight feature
names with a register-driven derivation; every name on that list was already complete, so the
missing filter had nothing to fail against.

**Independent Test**: Register a feature as `in-progress` with a populated `Corrects` value and
confirm the completion check passes; mark the same entry `complete` without provenance and confirm
it fails.

**Acceptance Scenarios**:

1. **Given** a register entry recorded `in-progress` with a `Corrects` value, **When** the
   completion check runs, **Then** it does not require a coverage record from that feature.
2. **Given** a register entry recorded `complete` with a `Corrects` value and no corrective
   provenance in its coverage record, **When** the completion check runs, **Then** it still fails
   and names the feature.
3. **Given** this feature is implemented, **When** its own register entry is read, **Then** its
   `Corrects` column names `041-auto-check-integrity`.

---

### User Story 5 - Every mapped rule is reached by the probe that claims to prove it (Priority: P1)

As a Highway maintainer, I want each `[auto]` rule in the Enforcement Map to be reached by a probe
belonging to the test that is named as deciding it, so that `D3.7`'s report that every mapped check
was proved means every mapped *rule* was proved.

**Why this priority**: `D4.3` is an instance, not the defect. `D3.7`'s Observable binds probes to
artifact *classes*; the Enforcement Map binds tests to *rules*; nothing joins the two. A test that
decides several rules satisfies `D3.7` by proving any one of them. Measured 2026-09-10, all three
multi-rule tests fall through that gap, and every probe still exits non-zero, so the harness reports
success in each case.

**Independent Test**: For each `[auto]` rule, name the probe leg that fails when that rule's
enforcement is removed from the tree, and confirm the removal is detected.

**Acceptance Scenarios**:

1. **Given** `spec-record.test.sh` decides `D5.4` and `D5.5`, **When** its declared probes run,
   **Then** one of them fails when the directory-name-versus-`Feature Branch` comparison is
   removed — which today none does, because the probe builds bare directories containing no
   `spec.md` for that comparison to read.
2. **Given** `completion-coverage.test.sh` decides `D7.2` and `D7.4`, **When** its declared probes
   run, **Then** at least one reaches `coverage_check` — which today none does, because all six
   seeded defects are decided by `register_problems`.
3. **Given** the full set of `[auto]` rules, **When** the mapping from each rule to the probe leg
   proving it is recorded, **Then** every rule names one and no rule is unaccounted for.
4. **Given** a rule whose enforcement is removed from the tree, **When** the suite runs, **Then**
   it fails, for every `[auto]` rule rather than for a subset.

---

### Edge Cases

- What happens when the new probe class runs on a machine where the distribution target path
  already exists from an interrupted earlier run? The probe must name its artifacts with the
  running process id and create its own temporary target, so two concurrent runs cannot collide and
  a stale directory from a previous run cannot make the probe pass or fail spuriously.
- What happens when the generator's refusal fires for the wrong reason — for example because the
  target path is unwritable rather than because it is untracked? The probe must match the refusal
  message that names the offending path, not merely a non-zero exit, or it will report success
  when the guard it claims to prove has been removed.
- How is a modified-file refusal seeded at all? It requires a target the generator *did* produce,
  so the probe must first run a full build to create a tracked target, then modify a recorded file
  inside it. That makes this the most expensive probe in the feature, and the cost must be measured
  rather than assumed.
- How does the neutralised leg avoid becoming a second full-build cost with no diagnostic value?
  It cannot: proving the check passes when nothing is seeded requires the generator to run to
  completion. The cost is accepted and recorded rather than engineered away in this feature.
- What happens if a future change removes the `D4.3` guard from the normal-mode path but leaves the
  probe branch intact? Both paths must decide the behavior through the same assertion, so that a
  guard which exists only to satisfy a probe cannot drift from the one that runs normally.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `distribution-packaging.test.sh` MUST declare one additional artifact class,
  `generated-artifact`, whose seeded probe exercises both refusal paths `D4.3`'s Enforcement Map
  note promises: an untracked directory, and a file modified inside a target the generator did
  produce.
- **FR-002**: That class's seeded probe MUST exit non-zero, and the same class invoked with
  `--neutralise` MUST exit zero.
- **FR-019**: The seeded probe MUST fail if *either* refusal path is removed from the generator,
  so consolidating both behaviors under one class does not reduce what is proved.
- **FR-003**: Each assertion MUST require the generator's refusal message to name the offending
  path, rather than accepting a non-zero exit code alone.
- **FR-017**: Normal mode MUST assert the modified-file refusal, which is currently asserted in no
  mode despite the Enforcement Map note promising it.
- **FR-018**: Assertions on refusal behavior MUST capture the generator's output for inspection
  rather than discarding it to `/dev/null`.
- **FR-004**: The probe branch and the normal-mode guard MUST decide the behavior through the same
  assertion, so neither can pass while the other is broken.
- **FR-005**: The probe MUST name every artifact it creates with the running process id, restore
  the tree byte-exactly on every exit path including failure, and MUST NOT invoke version control
  to do so.
- **FR-006**: The declared class list in the file's `# Artifact classes:` declaration and in its
  runtime class validation MUST agree, and an undeclared class MUST continue to exit 2.
- **FR-007**: `constitution-inventory.test.sh` MUST execute each newly declared class as part of
  deciding `D3.7`, with no change to how it decides any existing class.
- **FR-021**: `spec-record.test.sh` MUST declare a class whose seeded probe reaches `D5.5`'s
  comparison of a directory name against its `Feature Branch` value, including the placeholder
  rejection. Its present probe seeds a numbering gap into a tree of bare directories holding no
  `spec.md`, so `D5.5` is unreachable in principle rather than merely unprobed.
- **FR-022**: `completion-coverage.test.sh` MUST declare a class whose seeded probe reaches
  `coverage_check`, so that `D7.2` and `D7.4` are proved. Its present probe seeds six defects, every
  one decided by `register_problems`, which decides neither rule.
- **FR-023**: Every test named in the Enforcement Map MUST declare at least one artifact class whose
  seeded probe reaches each rule mapped to that test, and this feature MUST record the mapping from
  each `[auto]` rule to the probe leg that proves it.
- **FR-024**: The recorded mapping MUST be derived by measurement — removing each rule's enforcement
  and observing the suite fail — rather than by reading the probe source and inferring reach.
- **FR-025**: A probe leg that seeds more than one defect MUST fail if any one of the enforcements
  it exercises is removed, which requires seeding and deciding each defect separately rather than
  all at once. `adapter-coverage.test.sh` seeded four defects together, so deleting any one of its
  four `D4.5` checks left the leg still failing on the other three.
- **FR-026**: Checks that decide a rule MUST be reachable from probe mode, which means they MUST NOT
  live only in a test's inline normal-mode body. `D4.6`'s four orphan loops did, so no declared
  class reached them.
- **FR-027**: Where a rule's enforcement carries that rule's own verdict — `harness_probe_pair`'s
  `seeded_exit` branch decides whether a probe leg's exit 0 is reported as a failure — its removal
  MUST be detected outside the probe channel, because the report that would announce its absence is
  the thing removed. The detection MUST assert the report's message and not only its return code.
- **FR-008**: This feature MUST supersede Feature 041's probe-mode contract in its own `contracts/`
  directory, naming every element it changes, rather than editing the file under
  `specs/041-auto-check-integrity/`.
- **FR-009**: The superseding contract MUST state the suite runtime as a measured range across a
  stated number of runs, and MUST state the per-leg cost this feature adds as measured. The
  measurement MUST be taken after every class this feature adds is in place, not scaled from the
  `D4.3` class alone.
- **FR-010**: The superseding contract MUST retain 180 seconds as the target, record it as
  knowingly unmet, and name the follow-up phase expected to recover the time, rather than revising
  the target to match the measurement.
- **FR-020**: The superseding contract MUST state an interim ceiling of 240 seconds that the suite
  must not exceed while the 180-second target is unmet, so further drift remains distinguishable
  from the deviation this feature knowingly introduces.
- **FR-011**: Feature 041's `coverage.md` MUST state under `FR-010` the counted figure of thirteen
  Enforcement Map rows across eight unique test files, with no other row in that record changed.
- **FR-012**: This feature's own coverage record MUST name Feature 041 as the originating feature
  for each corrected requirement, per `D7.5`.
- **FR-013**: The corrective set `D7.5` is decided against MUST be scoped to features the register
  records `complete`, so that a feature which declares what it corrects before it finishes is not
  required to hold a completion record it cannot yet have.
- **FR-014**: Once `FR-013` holds, this feature's own register entry MUST declare
  `041-auto-check-integrity` in its `Corrects` column.
- **FR-015**: This feature MUST add no constitution rule, amend no rule text, Observable or tier,
  and MUST NOT remove or loosen any assertion Feature 041 added.
- **FR-016**: `.highway/tools/tests/run-all.sh` MUST exit 0 before the first edit and after the
  last.

### Key Entities

- **Artifact class**: A named category of artifact a check declares itself able to fail for. `D3.7`
  is decided by executing one probe per declared class. A class that is declared but unreachable
  makes the check pass while proving nothing; a behavior that no class covers makes the check pass
  while defending nothing.
- **Probe leg**: One invocation of a check in probe mode, either seeded or neutralised. Measured
  2026-09-10 for the `D4.3` class: an untracked-directory refusal costs 0.06s, a modified-file
  refusal costs 0.07s but requires a 7.82s build first to produce a tracked target, and a
  neutralised full build costs 7.86s. Consolidating both refusals under one class means one build
  serves both, so that class costs roughly 16s across its two legs rather than the 24s two classes
  would cost. The classes `FR-021` and `FR-022` add are not yet measured; the total this feature
  adds is therefore an open figure that `FR-009` closes by measurement.
- **Class-to-rule join**: The correspondence between the artifact classes a test declares and the
  Enforcement Map rules that test is named as deciding. `D3.7` constrains the first, the Enforcement
  Map constrains the second, and nothing today requires them to meet — which is why a test deciding
  several rules can satisfy `D3.7` by proving one of them.
- **Superseding contract**: The copy of Feature 041's probe-mode contract held under this feature,
  carrying every unchanged element forward and naming each changed one, as `D5.3` requires.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Removing the overwrite-refusal logic from `generate-distribution.sh` causes the suite
  to fail, where today it does not.
- **SC-002**: Every `[auto]` rule in the Enforcement Map is decided by a check with at least one
  declared artifact class that reaches the behavior the rule's Enforcement Map note describes; the
  count of rules for which this is not true falls to zero.

  > **Corrected 2026-09-10, after measurement.** This criterion originally read "falls from four —
  > `D4.3`, `D5.5`, `D7.2` and `D7.4`, measured 2026-09-10 — to zero". Four was the sample the
  > Feature 041 audit had suspected and T003 measured, not the population. The first exhaustive
  > removal pass over all thirteen rows (T015) found three further unreached rules — `D4.5`, `D4.6`
  > and `D3.7` — so the measured fall is from **seven** to zero. All seven are corrected in this
  > feature; see `contracts/rule-probe-map.md`.

- **SC-010**: `adapter-coverage.test.sh`'s `generated-artifact` leg fails if any one of the eight
  `D4.5`/`D4.6` checks it exercises stops reporting, rather than only if all eight do.
- **SC-011**: Each of `harness_probe_pair`'s three reports fails the suite when removed, and the
  assertion that proves the branch carrying `D3.7`'s own verdict runs outside the probe channel,
  because that branch cannot report its own absence.
- **SC-009**: For every `[auto]` rule, removing its enforcement from the tree makes the suite fail,
  and the recorded rule-to-probe-leg mapping names the leg that detected it.
- **SC-003**: All four probe-mode exit conditions hold for the newly declared class: seeded
  non-zero, neutralised zero, undeclared class exit 2, no arguments unchanged.
- **SC-008**: Each of the three parts of `D4.3`'s Enforcement Map note — untracked-directory
  refusal, modified-file refusal, and each message naming its target — fails the suite when removed
  from the generator; today none of the three does.
- **SC-004**: No probe artifact remains under the repository after the suite runs, on the passing
  path and on a deliberately failed path.
- **SC-005**: The recorded suite runtime is a range derived from at least five runs, the recorded
  added cost of this feature is the sum of separately measured legs, and the 240-second interim
  ceiling is met or the breach is reported with the conditions under which it occurred.

  > **Corrected 2026-09-10, after measurement.** This criterion originally required that "every
  > measured run falls under the 240-second interim ceiling". Ten runs were taken; eight fell in
  > 204–211s and two — 245s and 277s — were taken while the machine was still loaded from the
  > forty-minute removal campaign and exceeded the ceiling. Rewording the criterion to admit the
  > breach is preferred to discarding the two runs, which would be selecting the sample to fit the
  > claim. See `research.md` R5.
- **SC-006**: Feature 041's `coverage.md` states thirteen rows across eight files, and a count
  performed against the Enforcement Map agrees.
- **SC-007**: A register entry that is `in-progress` and declares a corrected feature does not fail
  the completion check, while a `complete` entry declaring one without provenance still does.

## Assumptions

- The overwrite-refusal guard already present in `distribution-packaging.test.sh` is correct and
  needs to become reachable from a declared class, not to be rewritten. Only if making it reachable
  from both paths requires shared logic does it move.
- The measured 7.86 second cost of the neutralised leg is representative; it is a full distribution
  build, which the suite already performs elsewhere at comparable cost.
- The 180 second target is a target rather than a ratified rule. No constitution rule states it, so
  exceeding it is a recorded deviation from a contract this feature supersedes, not a rule
  violation. The 240-second interim ceiling is set the same way and carries the same standing: it
  exists so that drift stays distinguishable from the known deviation, not to become a second
  target that outlives Phase 14.
- Recovering the exceeded time is out of scope here and belongs to the follow-up phase that
  examines the existing probes' cost, principally `adapter-coverage.test.sh`, whose
  `source-document` probe was measured at roughly 16 seconds.
- Three of the four unreached rules are nevertheless asserted in normal mode, measured 2026-09-10:
  `spec-record.test.sh` seeds a branch mismatch and a placeholder name and requires
  `identity_problems` to detect both, and `completion-coverage.test.sh` drives `coverage_check`
  through eleven assertions. Only `D4.3`'s modified-file refusal is asserted in no mode at all. The
  gap this feature closes is therefore provability for three of them and enforcement for one, and
  reporting all four as unenforced would repeat the class of over-claim being corrected.
- Feature 041 remains registered `complete`. Its `coverage.md` is corrected in place under `D5.1`'s
  stated exception; no other file under its directory is touched.
- This feature's register entry carries `-` in its `Corrects` column until `FR-013` is implemented.
  That is a consequence of the defect `FR-013` names, not a claim that this feature corrects
  nothing, and `FR-014` closes it within this feature rather than leaving the register understated.
