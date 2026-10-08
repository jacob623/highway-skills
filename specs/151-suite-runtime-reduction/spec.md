# Feature Specification: Suite Runtime Reduction

**Feature Branch**: `feature/test-cleanup-spec151`

**Created**: 2026-10-08

**Status**: Draft

**Input**: User description: "create a new spec for the generator revalidation and parallelism"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Generation stops re-validating unchanged skills (Priority: P1)

A developer runs the test suite. Today the four most expensive tests spend most of
their time re-proving something already proven: every generation run validates all
twelve skill sources from scratch, and the tests invoke generation six to thirteen
times each. Nothing about the skills changes between those invocations. The developer
waits for the same twelve validations to be repeated up to thirteen times in a single
test file.

After this story, a generation run validates a skill source only when that source has
not already been validated in its current state. The validation still happens — a
defective skill source is still rejected — but it is not repeated against an unchanged
input.

**Why this priority**: It is the largest removable cost in the suite and it is pure
repetition. Measured: validating one skill costs 372 ms, twelve skills cost roughly
4.5 s, and a full generation run costs 8.1 s — so over half of every generation run is
revalidation. It also cascades: the most expensive test re-executes the generation
tests, so it pays the same tax several times over. This story removes the largest block
of time without touching a single assertion, which makes it both the highest payoff and
the lowest risk.

**Independent Test**: Run the four generation-dependent tests before and after. Wall
time drops substantially while the pass/fail result of every one of them is unchanged.
Separately, seed a defect into a skill source and confirm generation still refuses to
proceed.

**Acceptance Scenarios**:

1. **Given** a tree whose skill sources are unchanged, **When** generation is invoked
   repeatedly, **Then** each skill source is validated no more than once per unchanged
   state and the generated output is byte-identical to the output produced today.
2. **Given** a skill source that violates the authoring contract, **When** generation is
   invoked, **Then** generation fails and reports the same validation error it reports
   today, whether or not that source was validated earlier in the session.
3. **Given** a skill source that is modified after an earlier successful validation,
   **When** generation is invoked again, **Then** the modified source is validated
   again rather than treated as still-valid.

---

### User Story 2 - The suite runs tests concurrently (Priority: P2)

The runner executes 74 test files strictly one after another on a multi-core machine.
Most of those tests only read files. A developer waiting on the suite is waiting on
scheduling, not on work.

After this story, tests that do not contend for shared state run concurrently, and the
developer gets the same pass/fail summary sooner.

**Why this priority**: It compounds with Story 1 rather than overlapping it — Story 1
removes work, Story 2 removes waiting. It is second because it carries real
interference risk that Story 1 does not, so it should land on an already-faster suite
where a regression is easier to isolate.

**Independent Test**: Run the suite three times. The set of passing and failing tests
is identical across all three runs and identical to the serial result, and wall time is
materially lower.

**Acceptance Scenarios**:

1. **Given** the full suite, **When** it is run concurrently, **Then** the pass/fail
   outcome of every test file matches the outcome of a serial run of the same tree.
2. **Given** tests that write probes into the live repository tree, **When** the suite
   runs, **Then** those tests do not run at the same time as any test that reads the
   state they mutate.
3. **Given** a failing test, **When** the suite runs concurrently, **Then** the summary
   attributes the failure to the correct test file and that test's output is not
   interleaved with another test's output.
4. **Given** a run that is interrupted part-way, **When** the suite is next run,
   **Then** residue from the interrupted run is swept before any test executes, as it
   is today.

---

### Edge Cases

- A skill source is edited between two generation invocations inside one test. The
  edited source must be revalidated; treating it as still-valid would let a defective
  source through and silently weaken four tests at once.
- Two concurrent tests both create working trees. Each must be isolated; a shared or
  colliding path would make failures depend on timing.
- A concurrent run is killed. The existing sweep already handles residue from the two
  tests that seed probes into the live tree; concurrency must not introduce new residue
  that the sweep does not know about.
- A test fails only when run concurrently. This is a real finding about hidden coupling
  between tests, not a reason to return that test to serial execution without recording
  why.
- The suite runs on a single-core or heavily loaded machine. Concurrency must not make
  the suite slower or less reliable than serial execution.
- Two tests invoke generation at the same time against the same tree. Generated output
  must not be corrupted by interleaved writes.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Generation MUST NOT revalidate a skill source whose content has not
  changed since that source was last validated successfully.
- **FR-002**: Generation MUST validate a skill source whose content has changed since it
  was last validated, and MUST fail on a defective source with the same error it
  reports today.
- **FR-003**: Generated artifacts MUST be byte-identical to the artifacts produced
  before this change for the same inputs.
- **FR-004**: Any record of prior validation MUST be derived from the content of the
  validated source, so that an edit invalidates it without requiring a manual reset.
- **FR-005**: Any record of prior validation MUST NOT be committed to the repository
  and MUST NOT appear in the distribution.
- **FR-006**: The runner MUST execute independent test files concurrently.
- **FR-007**: The runner MUST prevent concurrent execution of test files that contend
  for the same mutable state in the live repository tree.
- **FR-008**: The runner MUST report the same pass/fail result for every test file as a
  serial run of the same tree.
- **FR-009**: The runner MUST attribute each failure to the test file that produced it
  and MUST NOT interleave the output of concurrently running tests.
- **FR-010**: The runner MUST continue to sweep probe residue before any test executes.
- **FR-011**: The runner MUST allow concurrency to be reduced to serial execution, so a
  suspected interference failure can be distinguished from a genuine one.
- **FR-012**: This feature MUST NOT delete, skip, or weaken any existing test
  assertion. Runtime is reduced by removing repeated work and idle waiting, not by
  reducing coverage.

### Key Entities

- **Skill source**: An authored `SKILL.md` under the Highway skills directory. The unit
  that validation accepts or rejects, and the unit whose unchanged state makes
  revalidation redundant.
- **Validation record**: Evidence that a specific state of a specific skill source has
  already passed validation. Transient, derived from content, never shipped.
- **Test file**: A discovered `*.test.sh`. The unit of scheduling and of pass/fail
  reporting.
- **Contended state**: Any path in the live repository tree that a test writes and
  another test reads. Determines which test files cannot run at the same time.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Full suite wall time is at most **250 s**, down from a measured baseline of
  377 s at 74 passed and 0 failed.

  > **Amended 2026-10-08, after US1 was implemented and measured.** The original target was
  > 180 s. That figure was inherited from Phase 14 of `governance-plan.md`, where it was set
  > against a suite of 36 test files; this suite now has 75. It is not reachable through the
  > two causes this feature put in scope, and the amendment records that rather than leaving
  > a target the spec cannot hit.
  >
  > The reason is structural and was measured at the US1 decision gate.
  > `constitution-inventory.test.sh` (80 s) and `distribution-packaging.test.sh` (53 s) hold
  > 133 s of a 240 s run. Both are exclusive-pool tests, so concurrency cannot overlap them,
  > and `constitution-inventory` cannot benefit from a content-addressed cache at all: it
  > mutates the governance documents on every probe, which is precisely what invalidates a
  > content-addressed key. Reaching 180 s requires restructuring that harness, which this
  > spec placed out of scope and which Phase 14 already owns.
  >
  > The achieved figure is **242 s**, from US1 alone. 250 s is stated as the ceiling rather
  > than 242 s because 242 s is a single sample, and Phase 14 requires a range across five
  > consecutive runs before a runtime claim is made. This feature does not supply that range.
- **SC-002**: Every test file that passes before this change passes after it, and no
  test file is deleted, skipped, or has an assertion removed.
- **SC-003**: Three consecutive full runs produce an identical set of passing and
  failing test files.
- **SC-004**: A deliberately defective skill source is still rejected by generation,
  observed failing before the change is accepted.
- **SC-005**: Generated artifacts after this change are byte-identical to the artifacts
  generated before it.
- **SC-006**: A developer can reproduce any failure serially, so an interference
  failure can be told apart from a genuine one.

## Assumptions

- The baseline is 371.8 s of wall time for a full `run-all.sh` run reporting 74 passed
  and 0 failed. An earlier figure of 695 s came from a cold first run and overstated
  every test; it is superseded and is not the reference point for SC-001.
- The warm cost is concentrated differently than the cold measurement suggested. Measured
  per test: `constitution-inventory` 88.9 s, `distribution-packaging` 45.2 s,
  `generate-agent-adapters` 33.7 s, `generate-catalog` 20.6 s, `adapter-coverage` 17.6 s,
  `validate-skill` 15.8 s, `generate-library-catalog` 12.4 s. Those seven are roughly 63%
  of the suite.
- Scope is the two causes named in the request: repeated validation inside generation,
  and serial execution of independent tests. Redesigning the meta-harness in
  `constitution-inventory.test.sh` is **out of scope**. Its cost is nonetheless expected
  to fall within this feature, because it re-executes the generation tests and inherits
  their saving — it is addressed indirectly, not restructured.
- Pruning redundant and obsolete test content is a maintenance concern, not a runtime
  one. It is **out of scope** for this feature and belongs in its own specification.
- SC-001 assumes that saving does cascade into the meta-harness. If it does not, the
  slowest single test sets the floor for any concurrent run and SC-001 is unreachable
  without bringing that harness into scope. This is the feature's main risk.

  > **Resolved 2026-10-08: the risk materialised.** The saving did not cascade.
  > `constitution-inventory.test.sh` went from 88.9 s to 80 s, within variance. SC-001 was
  > amended rather than the harness brought into scope.

- **US2 is descoped, 2026-10-08.** With the exclusive pool holding 133 s of a 240 s run,
  concurrency has little left to overlap, and its ceiling no longer justifies the
  interference risk it carries. FR-006 through FR-011 are unimplemented and are recorded as
  such rather than deleted. Nothing in US1 forecloses US2 being built later.
- Scripts run under bash 3.2.57, the macOS default. Concurrency must work there.
- The development constitution continues to bind: the suite must be green before the
  first edit and after the final edit, no test may be weakened without a recorded
  superseded-behavior reason, and a probe must be observed failing before the change is
  claimed complete. FR-012 exists so this feature does not quietly trade coverage for
  speed.
- Six test files are named in the development constitution's rule mapping. Five of them
  are among the slowest. This feature changes how they run, not whether they run, so the
  mapping is unaffected.
