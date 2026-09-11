# Feature Specification: Automatic Check Integrity

**Feature Branch**: `041-auto-check-integrity`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "I want every registered [auto] check to decide the rule it is named for, rather than assert the presence of a token that the checked artifact controls. Verified 2026-09-10 across the tree as it stands. First: completion-coverage.test.sh derives its own scope from the artifact it checks — a feature directory is in scope only if its tasks.md holds no unchecked box — so a completed feature can leave itself out of D7.2 and D7.4 by not ticking a box, and three directories do exactly that today. The condition is not a shortcut the script invented; it is the Development Constitution's own definition of a completed spec. Second: D3.7 requires a registered [auto] check to be able to fail for every class of artifact in its declared scope, and constitution-inventory.test.sh decides it by grepping each test file for the comment strings '# Seeded failure probe:' and '# Artifact classes:'. It never runs a probe and never observes a non-zero exit, so five registered [auto] checks — generate-agent-adapters.test.sh for D4.1, generate-catalog.test.sh for D4.2, adapter-coverage.test.sh for D4.5, D4.6 and D4.7, and constitution-inventory.test.sh for D3.7 itself — declare a probe in a comment and prove nothing. Third: completion-coverage.test.sh decides D7.5's corrective set from a hardcoded list of eight feature names written into the script, which is the enumerated-list defect Feature 016 removed one level up. Replace the derived scope with a single declared completion register held outside specs/, so that whether a feature is complete is stated once by a maintainer rather than inferred from a checkbox inside the artifact being checked, and derive both the coverage scope and the D7.5 corrective set from that one declaration. Amend the Completed spec definition in the Development Constitution so the rule text and the check agree. Replace the two comment greps in constitution-inventory.test.sh with an assertion that each declared probe is executed and observed producing a non-zero exit. Write the missing probes for D4.1, D4.2, D4.5, D4.6, D4.7 and D3.7, using highway-inquiry as the subject the way Phase 4c prescribes, each probe named with the running process id and swept at suite level in run-all.sh, because test residue has already cost this project time twice. Normalise specs/038-readiness-verification-corrections/coverage.md, which uses the columns Requirement, Coverage and Evidence class and carries nine non-requirement prose rows, onto the declared schema. Write specs/040-historical-coverage-reconstruction/coverage.md, which does not exist. Record in the governance plan that Phase 12's Done-when claiming every completed feature directory from 021 onward holds coverage.md in the declared schema was not met, rather than editing the claim away. Evaluate every rule against the tree before enabling it, per D3.4, and classify the amendment honestly: it is MINOR only if the conformance work lands in the same change, and MAJOR otherwise. Do not introduce a second enforcement mechanism, do not automate the D7.5 corrective judgment as a heuristic, and amend neither the Highway Skills Constitution nor the Experience Standard. Begin and end from a passing .highway/tools/tests/run-all.sh."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A check's scope is declared, not inferred (Priority: P1)

As a Highway maintainer, I want the set of features subject to the completion rules to be stated in one declared place, so that a feature cannot remove itself from enforcement through the same file the enforcement reads.

**Why this priority**: This is the root defect. Every other finding in this feature is an instance of a check reading something the checked artifact controls, and this instance is the one that silently narrows the scope of two ratified rules.

**Independent Test**: Add an unchecked task box to a registered completed feature and confirm the completion check still evaluates it; remove a feature from the register and confirm the check no longer evaluates it and says so.

**Acceptance Scenarios**:

1. **Given** a feature directory registered as complete, **When** an unchecked task box is added to its `tasks.md`, **Then** the completion check still evaluates it and still enforces the coverage rules against it.
2. **Given** a feature directory that exists under `specs/` but has no entry in the register, **When** the completion check runs, **Then** it exits non-zero and names the unregistered directory.
3. **Given** a register entry naming a directory that does not exist, **When** the completion check runs, **Then** it exits non-zero and names the entry.
4. **Given** the register is complete and every registered feature conforms, **When** the completion check runs, **Then** it passes.
5. **Given** the Development Constitution's definition of a completed spec, **When** it is read against the completion check, **Then** the definition and the check agree on what makes a spec complete.

### User Story 2 - A registered check proves it can fail (Priority: P1)

As a Highway maintainer, I want the rule that requires every automatic check to prove its own failure path to be decided by running that proof, so that declaring a probe in a comment is no longer sufficient.

**Why this priority**: The rule exists, is tagged `[auto]`, and is named in the Enforcement Map, while the check that decides it inspects comment text. That is the exact shape of dishonesty that Features 013, 014 and 039 were each written to remove, reproduced in the rule written to prevent it.

**Independent Test**: Change a test file so its declared probe no longer causes a failure, and confirm the inventory check rejects it; restore the probe and confirm it passes.

**Acceptance Scenarios**:

1. **Given** a registered `[auto]` check that declares a probe, **When** the inventory check runs, **Then** the declared probe is executed and its non-zero exit is observed rather than its comment being matched.
2. **Given** a registered `[auto]` check whose declared probe does not produce a failure, **When** the inventory check runs, **Then** it exits non-zero and names that check.
3. **Given** a registered `[auto]` check that declares no probe for one of its declared artifact classes, **When** the inventory check runs, **Then** it exits non-zero and names the class.
4. **Given** every registered `[auto]` check, **When** the inventory check runs, **Then** each is proved to fail for one artifact of each class it declares.

### User Story 3 - The unproven checks are given real probes (Priority: P1)

As a Highway maintainer, I want the five registered checks that currently prove nothing to seed a defect and observe it being caught, so that the enforcement claimed for six rules is the enforcement actually performed.

**Why this priority**: Once the inventory check is real, these five fail. Bringing them to conformance in the same change is what keeps the amendment MINOR and is the discipline this repository already applied in Phases 4c, 11 and 12.

**Independent Test**: For each of the six affected rules, break the property it states, confirm the named check fails, restore, and confirm it passes.

**Acceptance Scenarios**:

1. **Given** a generated adapter that has been hand-edited after generation, **When** its check runs, **Then** it exits non-zero.
2. **Given** a generator run twice against unchanged inputs, **When** a difference beyond the excepted timestamp is seeded, **Then** its check exits non-zero.
3. **Given** a skill whose catalog entry, adapter, adapter manifest row, or distribution manifest row is removed, **When** the coverage check runs, **Then** it exits non-zero and names the missing correspondence.
4. **Given** an orphaned entry naming a skill with no source directory, **When** the coverage check runs, **Then** it exits non-zero.
5. **Given** a skill description changed without regeneration, **When** the currency check runs, **Then** it exits non-zero.
6. **Given** any probe seeded into the live tree, **When** the run ends, whether normally or not, **Then** the suite removes every probe artifact before the next run reads the tree.

### User Story 4 - The corrective set is declared rather than enumerated in code (Priority: P2)

As a Highway maintainer, I want the set of features that correct an earlier feature to be read from the same declaration as the completion status, so that recording a new correction does not require editing a test script.

**Why this priority**: A list of eight feature names inside a script is the enumerated-list defect this project has removed twice before, and it goes stale the moment a ninth correction ships.

**Independent Test**: Declare a new correction in the register and confirm the check enforces the corresponding superseding entry without any change to the check itself.

**Acceptance Scenarios**:

1. **Given** a correction declared in the register, **When** the completion check runs, **Then** it requires the corrected feature's coverage record to carry a superseding entry naming the correcting feature.
2. **Given** a corrected feature whose record carries no such entry, **When** the completion check runs, **Then** it exits non-zero.
3. **Given** a new correction is recorded, **When** it is enforced, **Then** no file under `.highway/tools/tests/` is edited to enumerate it.
4. **Given** the semantic judgment of whether one feature corrects another, **When** the register is written, **Then** that judgment is made by a maintainer and recorded, not inferred by the check.

### User Story 5 - The records the rules already demand are brought to conformance (Priority: P2)

As a Highway maintainer, I want the two coverage records that do not conform to be corrected and the falsified completion claim to be recorded, so that widening the check does not simply turn an unreported gap into a failing suite.

**Why this priority**: Feature 038's record uses a different column set and Feature 040 has none. Both are invisible today only because of the defect this feature removes.

**Independent Test**: Run the completion check over the full register and confirm every entry conforms.

**Acceptance Scenarios**:

1. **Given** Feature 038's coverage record, **When** it is reviewed, **Then** it uses the declared columns and carries one row per declared requirement identifier and no others.
2. **Given** Feature 040's directory, **When** it is reviewed, **Then** it holds a conforming coverage record.
3. **Given** the governance plan's Phase 12 Done-when asserting that every completed feature directory from 021 onward holds a conforming record, **When** the record is reviewed, **Then** the unmet criterion is recorded as unmet rather than removed or reworded.

### Edge Cases

- A feature directory is registered as complete while its `tasks.md` still holds unchecked boxes; the register decides, and the discrepancy is a matter for the maintainer rather than a silent exclusion.
- A directory exists under `specs/` that is neither complete nor incomplete in any recorded sense; the register must still carry an explicit status for it.
- The register itself is a checked artifact, so the check that reads it must be able to fail for a malformed register.
- A probe seeded into the live tree is left behind by an interrupted run; the next run must not attribute it to whichever test sorts first.
- Two probes run in the same suite invocation and collide on a filename; process-id naming must make that impossible.
- A declared artifact class has no reachable defect to seed; that must be reported rather than passed over.
- A check declares more classes than it probes, or probes a class it does not declare; both are rejections.
- Making the inventory check real causes five previously passing tests to fail; the conformance work must land in the same change or the amendment is not MINOR.
- The register is placed under `specs/`; that would put a frequently edited file inside the append-only spec record and is rejected.
- A correction is declared against a feature that never shipped the requirement it names; the check rejects it.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A single completion register MUST declare, for every feature directory under `specs/`, whether that feature is complete, and MUST be the only place that status is stated.
- **FR-002**: The register MUST NOT live under `specs/`, and enabling it MUST NOT require an edit to any completed feature's `spec.md`, `plan.md`, or `tasks.md`.
- **FR-003**: The completion check MUST derive its in-scope feature set from the register, and MUST NOT derive it from task checkbox state or from any other file inside the directory it is checking.
- **FR-004**: The completion check MUST reject a feature directory that has no register entry, and MUST reject a register entry naming no existing directory.
- **FR-005**: The Development Constitution's definition of a completed spec MUST be amended so that it agrees with the mechanism the completion check uses.
- **FR-006**: The register MUST declare which features correct an earlier feature, and the completion check MUST derive its corrective set from that declaration rather than from a list enumerated in a test script.
- **FR-007**: The corrective declaration MUST remain a recorded maintainer judgment; the feature MUST NOT introduce a heuristic that infers a correction relationship.
- **FR-008**: The check that decides the probe rule MUST execute each declared probe and observe a non-zero exit, and MUST NOT decide the rule by matching a comment string in a test file.
- **FR-009**: The check that decides the probe rule MUST reject a test whose declared probe does not produce a failure, and MUST reject a declared artifact class with no probe.
- **FR-010**: Every registered `[auto]` check MUST be proved to fail for one artifact of each artifact class it declares, including the check that decides the probe rule itself.
- **FR-011**: The checks for hand-edit refusal, generator determinism, generated-artifact coverage, orphan rejection, and input currency MUST each seed a defect and observe it being caught.
- **FR-012**: Every probe seeded into the live tree MUST be named with the running process identifier and MUST be removed by the suite-level sweep, so no residue is attributed to an unrelated test.
- **FR-013**: Feature 038's coverage record MUST be normalised onto the declared column schema, carrying exactly one row per declared requirement identifier and no non-requirement rows.
- **FR-014**: Feature 040 MUST be given a conforming coverage record.
- **FR-015**: The governance plan MUST record that Phase 12's Done-when requiring every completed feature directory from 021 onward to hold a conforming coverage record was not met, without deleting or rewording the original claim.
- **FR-016**: Every rule change MUST be evaluated against the tree before it is enabled, and the amendment MUST be classified MINOR only if the conformance work lands in the same change; otherwise it MUST be classified MAJOR.
- **FR-017**: The feature MUST NOT introduce a second mechanism that decides a property an existing registered check already decides.
- **FR-018**: The feature MUST NOT amend the Highway Skills Constitution or the Experience Standard, and MUST NOT edit a completed spec file other than the coverage record the existing exception permits.
- **FR-019**: Every new assertion MUST be observed failing for the behaviour it claims before the work it covers is marked complete.
- **FR-020**: The implementation MUST begin and end with `.highway/tools/tests/run-all.sh` passing.

### Key Entities

- **Completion register**: The single declared artifact recording, per feature directory, whether it is complete and which earlier feature it corrects.
- **Declared artifact class**: A named category of artifact within a check's scope, each of which must have one probe proving the check can fail for it.
- **Probe**: A defect seeded into a real artifact for the duration of a run, whose purpose is to make a check fail and then be restored.
- **Registered automatic check**: A test named in the Enforcement Map as deciding a rule tagged `[auto]`.
- **Corrective declaration**: A recorded maintainer judgment that one feature corrects a defect shipped by an earlier one.
- **Coverage record**: The per-feature artifact mapping each declared requirement identifier to a bounded outcome and its evidence.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Adding an unchecked task box to any registered completed feature changes nothing about which features the completion check evaluates.
- **SC-002**: Every feature directory under `specs/` has exactly one register entry, and every register entry names an existing directory.
- **SC-003**: No test file under `.highway/tools/tests/` contains an enumerated list of feature names used to decide which features a rule applies to.
- **SC-004**: Every registered `[auto]` check declares its artifact classes and is observed exiting non-zero for a seeded defect in one artifact of each declared class.
- **SC-005**: The six rules currently decided by a comment match or by no probe at all — hand-edit refusal, generator determinism, generated-artifact coverage, orphan rejection, input currency, and the probe rule itself — each have a probe that has been observed failing and then passing again after restoration.
- **SC-006**: A run interrupted after a probe is seeded leaves no artifact that causes an unrelated test to report a defect that does not exist.
- **SC-007**: Every register entry marked complete holds a coverage record in the declared schema; no record uses an alternate column set, an alternate filename, or a non-requirement row.
- **SC-008**: The Development Constitution's definition of a completed spec and the completion check's scope mechanism state the same thing.
- **SC-009**: The amendment's classification is recorded together with the pre-enable measurement that justifies it, and the count of checks that failed before the conformance work is reported rather than omitted.
- **SC-010**: The governance plan records Phase 12's unmet Done-when in the same form Phase 10's unmet criterion was recorded.
- **SC-011**: No rule is added to or amended in the Highway Skills Constitution or the Experience Standard, and no new principle is opened.
- **SC-012**: `.highway/tools/tests/run-all.sh` exits successfully before and after the change.

## Assumptions

- The schema, bounded outcome vocabulary, and coverage obligations established by Feature 039 are authoritative and are not reopened here.
- Whether a feature is complete is a maintainer judgment. This feature moves where that judgment is recorded; it does not attempt to compute it.
- The register is a governance artifact of the development tree and never ships, so it takes no `P` or `X` obligation.
- Placing the register outside `specs/` is what keeps the existing no-edit rule for completed spec directories intact; the existing exception covers the coverage record only and is not stretched.
- The amendment is expected to be MINOR on the same reasoning Phases 4c, 11 and 12 used — the conformance work lands in the change that enables the rule — and is to be reclassified MAJOR if any check cannot be brought to conformance in this change.
- Three directories currently carry unchecked task boxes and are therefore invisible to the completion check today; their register status is an explicit decision this feature must make and record rather than infer.
- `highway-inquiry` remains the subject of the generated-artifact probes, as the plan already prescribes, because it conforms and can be broken and restored.
- Probes seed into the live tree rather than a copy where the property under test reads the real tree; this is the existing pattern and the reason the suite-level sweep exists.
- Scripts remain constrained to Bash 3.2.57 and the Declared Toolchain, which excludes version control, so no probe may rely on a repository to restore what it changed.
- Making the probe rule real may reveal further unproven checks beyond the five measured; any such finding is reported and brought to conformance or the classification changes.
