# Research: Completion Claim Accountability

**Feature**: 021-completion-claim-accountability
**Date**: 2026-09-08

## Decision 1: Store requirement coverage with the feature record

**Decision**: Use `specs/<feature>/coverage.md` as the authoritative completion coverage record.

**Rationale**: The mapping belongs to the feature it evaluates, must remain available after the
implementation session, and must not edit a completed `spec.md` or `tasks.md`. A feature-local
Markdown record also fits the repository's existing spec artifact conventions and can name either
a satisfying artifact or an explicit deferral.

**Alternatives considered**:

- Put coverage in `governance-plan.md`: rejected because that document is a phase-level narrative,
  not a complete record for every feature requirement.
- Put coverage in `tasks.md`: rejected because task history should remain focused on implementation
  work and D5.1/D5.2 protect completed spec records.
- Use an opaque data file: rejected because maintainers need a readable, reviewable record.

## Decision 2: Store red-to-green evidence as a feature-local record

**Decision**: Use `specs/<feature>/test-evidence.md` for behavior-specific failing observations
and their corresponding passing observations.

**Rationale**: D3.6 requires evidence to exist before completion, while the evidence must survive
outside the transient conversation. A single feature-local record can identify the test, claimed
behavior, failing result, passing result, and the task that relies on it. It supports static
prose-contract tests without requiring executable tests.

**Alternatives considered**:

- Rely on terminal history: rejected because it is not a durable feature artifact.
- Require every test to be executable: rejected by the specification; static instruction-contract
  tests are valid when they have behavior-specific evidence.
- Store evidence in the test file: rejected because test source should remain executable or
  assertion-oriented, while evidence is a process record.

## Decision 3: Extend the existing test and Enforcement Map patterns

**Decision**: Add one feature-level coverage check under `.highway/tools/tests/` and register it in
the Development Constitution Enforcement Map for D7.2. Keep D7.1, D3.6, and D7.3 agent-checkable.

**Rationale**: Existing tests use fixture-based failure proofs, and every automatic Development
Constitution rule has one Enforcement Map row. D7.2 is a mechanical set comparison; the other
rules require semantic judgment and must not receive a proxy check that can pass without deciding
the intended claim.

**Alternatives considered**:

- Extend `validate-skill.sh`: rejected because it validates shipped skill artifacts, not feature
  specs, tasks, or completion records.
- Add a second rule inventory or coverage-summary mechanism: rejected because the existing
  Enforcement Map is the established Layer 0 pattern.
- Make all new rules automatic: rejected because task/artifact meaning and report honesty are
  semantic.

## Decision 4: Pre-enable evaluation reports missing coverage honestly

**Decision**: Evaluate every existing completed feature before enabling D7.2 and record each verdict;
features without coverage records are reported as missing coverage, not backfilled or treated as
satisfied.

**Rationale**: Existing completed features predate D7.2. Fabricating records would alter history
and violate the feature's explicit no-rewrite boundary. A missing record is a useful, honest verdict
and lets the amendment distinguish a new rule from a retroactive claim that old work complied.

**Alternatives considered**:

- Add synthetic coverage records to every old feature: rejected because it would create unsupported
  historical claims and touch completed spec directories.
- Enable the check without pre-evaluation: rejected by D3.4 and the repository's established
  failure-proof practice.
- Treat missing records as PASS: rejected because it would hide the exact defect the rule addresses.

## Decision 5: Feature 020 is evidence, not a target for historical repair

**Decision**: Record Feature 020's five unsatisfied requirements in Feature 021's initial coverage
record or assessment fixture, while leaving Feature 020's completed spec artifacts unchanged.

**Rationale**: D5.1 and D5.2 make completed spec directories append-only. The accountability feature
must expose the prior false completion claim without rewriting it. Residual implementation work can
be planned in a later numbered feature.

**Alternatives considered**:

- Edit Feature 020's spec or tasks: rejected because it destroys the historical completion record.
- Mark the five requirements satisfied because the suite passed: rejected because test results and
  requirement coverage are separate claims.
- Ignore Feature 020: rejected because it supplies the verified failure case for this feature.
