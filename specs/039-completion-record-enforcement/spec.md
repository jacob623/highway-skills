# Feature Specification: Completion Record Enforcement

**Feature Branch**: `039-completion-record-enforcement`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "I want the completion record that Feature 021 introduced to be enforceable, because today D7.2 is tagged [auto], is named in the Enforcement Map, and has never failed for any feature but the one that created it. Verified 2026-09-10 across Features 022 through 038. First: completion-coverage.test.sh hard-asserts coverage only for feature 021 and its checked-in fixtures; for every other feature it prints a PRE_ENABLE MISSING_COVERAGE line that never reaches the fail variable, and the script exits 0 with twenty-five such lines. Second: nine features completed after D7.2 was ratified have no coverage record at all -- 025, 026, 027, 028, 029, 032, 035, 036 and 037 -- and feature 032, which exists to add coverage records to 030 and 031, has none of its own. Third: three incompatible column schemas are in use, Requirement/Outcome/Evidence in 021, 030 and 031, Requirement/Satisfying-artifact/Evidence in 022, 023, 024, 033 and 034, and a third meaning in 038, so six records put a file path where the parser reads satisfied or deferred and would be rejected if the check ever ran on them. Fourth: the filename is not fixed either, 037 uses requirements-coverage.md and 032 uses test-evidence.md. Fifth: eight of the seventeen features reviewed exist only to correct the previous one, 025 and 026 correcting 024, 028 correcting 027, 029 correcting 028, 032 correcting 030 and 031, 034 correcting 033, 036 correcting 035 and 038 correcting 037, and in every case the corrected feature's own record still reads as fully satisfied. Sixth: specs/036-feature-036 is a placeholder directory whose own spec.md declares the branch 036-strengthen-035-evidence, and specs/033-highway-setup declares 033-highway-setup-orchestration. Add five rules to the Highway Development Constitution at .specify/memory/constitution.md as a MINOR amendment, all Layer 0 because they constrain a coverage record, a test file, a spec.md and a feature directory, none of which ship, and open no new principle. D3.7 in the existing Principle III: a registered [auto] check MUST be able to fail for every artifact in its declared scope, observable as the check declaring its scope and a seeded defect in each in-scope artifact producing a non-zero exit, tagged [auto]; this generalises the probe that D1.1's enforcement entry already seeds to prove it can fail. D3.8 in Principle III: a static document-contract test MUST NOT be recorded as the evidence satisfying a behavioral requirement, observable as each test declaring its instrument class and a coverage row for a runtime-behavior requirement naming a test of the executed-behavior class, tagged [agent-checkable]; this does not outlaw static prose-contract tests, which remain the correct instrument for authoring rules against a SKILL.md, it only forbids counting one as evidence for behavior -- the gap that Features 034, 036 and 038 each rediscovered independently. D7.4 in the existing Principle VII: a coverage record MUST use one declared path and one declared column schema, observable as every completed feature directory holding coverage.md with columns Requirement, Outcome and Evidence and every Outcome being exactly satisfied or deferred, tagged [auto]. D7.5 in Principle VII: a feature that corrects a defect in a completed feature MUST record that defect against the feature that shipped it, observable as the corrected feature's coverage record carrying a superseding entry naming the correcting feature and the requirement it revises, tagged [agent-checkable] because deciding whether one change corrects another's defect is semantic. D5.5 in the existing Principle V: a feature directory name MUST name the feature, observable as the segment after the number equalling the Feature Branch value in that directory's spec.md and not being a placeholder restating the number, tagged [auto]. Amend D5.1's Observable to except the coverage record from its no-diff-under-a-completed-spec-directory rule, because both the back-fill and every D7.5 superseding entry are literally such a diff; the exception covers the coverage record only and permits no edit to any other file in the directory, and D5.2 is untouched. Because enabling D7.4 fails fifteen of the seventeen reviewed features and D5.5 fails two directories, do the retroactive conformance work in the same change that enables the rules, per D3.4: write the nine missing coverage records, normalise the six divergent ones onto the declared schema, rename specs/036-feature-036 to match its declared branch, and reconcile specs/033-highway-setup. Back-filled records must be honest -- where a requirement was in fact corrected by a later feature, its outcome is deferred with the superseding feature named, not satisfied. Convert completion-coverage.test.sh's PRE_ENABLE reporting into assertions and prove D3.7 against it by seeding a defect into each in-scope feature. Do not add any rule requiring every test to be executable, do not add any rule mandating an assessment ritual before a feature, and do not amend the Highway Skills Constitution or the Experience Standard -- no rule in this phase constrains a SKILL.md."

## Clarifications

### Session 2026-09-10

- Q: Should the enforced coverage scope include every completed feature from 001 onward, or only Feature 021 onward? -> A: Every completed feature from 001 onward, reached across two features: this one enforces 021 onward plus Feature 020, and Feature 040 reconstructs 001 through 019.
- Q: Does D3.7's proof obligation cover only the completion check, or every registered automatic check? -> A: Every registered automatic check, proved once per declared artifact class rather than once per artifact.
- Q: How is a pre-021 requirement recorded when the historical record cannot evidence it? -> A: With a third outcome, `historical`, valid only for Features 001 through 020.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Enforce complete coverage records (Priority: P1)

As a Highway maintainer, I want every completed feature to have one machine-checkable coverage record so that a green completion check means the feature's requirements were accounted for.

**Why this priority**: The current D7.2 check validates only Feature 021 and its fixtures, allowing later completed features to omit coverage or use incompatible formats without failing the suite.

**Independent Test**: Run the completion check against every completed feature in its declared scope, then remove a required record, alter an outcome, duplicate a requirement, and restore the valid records; each invalid state fails and the restored repository passes.

**Acceptance Scenarios**:

1. **Given** a completed feature directory in the declared scope, **When** the completion check runs, **Then** it requires `coverage.md` with exactly the declared requirement, outcome, and evidence columns.
2. **Given** a coverage record with a missing, duplicate, unknown, or malformed requirement entry, **When** the check runs, **Then** it exits non-zero and identifies the affected requirement or feature.
3. **Given** a coverage record with an outcome other than `satisfied` or `deferred`, **When** the check runs, **Then** it exits non-zero rather than treating an artifact path as an outcome.
4. **Given** all completed feature records conform to the declared schema, **When** the check runs, **Then** it exits zero without emitting a non-enforcing pre-enable notice.

### User Story 2 - Preserve honest correction history (Priority: P1)

As a reviewer, I want corrective features to identify the requirements they supersede so that a completed feature's coverage claim remains historically understandable rather than silently appearing complete forever.

**Why this priority**: Features 025, 026, 028, 029, 032, 034, 036, and 038 correct earlier features, but their current records do not preserve those relationships or distinguish deferred historical requirements from satisfied ones.

**Independent Test**: Inspect each corrective feature's coverage record and confirm that every corrected requirement names the originating feature, the superseding feature, and the deferred or satisfied disposition.

**Acceptance Scenarios**:

1. **Given** a feature corrects a defect in an earlier completed feature, **When** its coverage record is reviewed, **Then** the record names the earlier feature and the requirement being revised.
2. **Given** a historical requirement was not satisfied by the original feature but was addressed later, **When** the back-filled record is reviewed, **Then** its outcome is `deferred` and its evidence names the superseding feature rather than falsely claiming satisfaction.
3. **Given** Feature 020's previously unmet requirements, **When** its coverage record is added, **Then** FR-002, FR-020, FR-024, FR-027, and FR-032 are recorded as deferred with corrective ownership identified.

### User Story 3 - Prove checks and evidence are trustworthy (Priority: P1)

As a Highway maintainer, I want registered automatic checks to demonstrate their failure paths and behavioral claims to use appropriate evidence so that passing static checks cannot mask missing runtime behavior.

**Why this priority**: Features 034, 036, and 038 independently found that static prose-contract assertions were being treated as proof of behavior, while the completion check itself could report missing coverage without failing.

**Independent Test**: Seed a defect into each artifact in the declared scope of every registered automatic check, observe a non-zero result, restore the artifact, and verify that coverage rows for runtime behavior identify executed-behavior evidence separately from static contract evidence.

**Acceptance Scenarios**:

1. **Given** any registered `[auto]` check and an in-scope artifact with a seeded defect, **When** the check runs, **Then** it exits non-zero and identifies the defect.
2. **Given** a requirement about runtime behavior, **When** its coverage evidence is reviewed, **Then** it identifies executed behavior rather than only a static document-contract assertion.
3. **Given** a requirement about the content of a `SKILL.md`, **When** its coverage evidence is reviewed, **Then** a static prose-contract test remains permitted and is not incorrectly classified as runtime behavior evidence.
4. **Given** the repository is restored after a seeded defect, **When** the registered checks run again, **Then** the checks pass and the original artifacts are unchanged.
5. **Given** a rule cannot be brought to conformance in this change, **When** the pre-enable assessment is recorded, **Then** the rule is enabled later rather than tagged as enforced.

### User Story 4 - Keep feature records and names consistent (Priority: P2)

As a Highway maintainer, I want feature directories and branch declarations to agree so that feature records can be located and referenced unambiguously.

**Why this priority**: Feature 036 uses a placeholder directory name that does not match its declared branch, and Feature 033 uses a different branch suffix than its directory.

**Independent Test**: Compare every feature directory name with its `Feature Branch` declaration and verify that the renamed Feature 036 record preserves its contents and references.

**Acceptance Scenarios**:

1. **Given** a feature directory, **When** its name and `Feature Branch` declaration are compared, **Then** the numeric and descriptive portions agree.
2. **Given** the placeholder Feature 036 directory, **When** it is renamed to its declared branch name, **Then** no spec content is modified and references resolve to the new path.
3. **Given** Feature 033 has a descriptive branch suffix mismatch, **When** reconciliation is performed, **Then** the chosen canonical name is recorded without rewriting the completed feature's substantive artifacts.
4. **Given** Features 001 and 005 declare bracketed branch values, **When** identity is evaluated, **Then** the bracket characters are reconciled so the declared value equals the directory name.

### Edge Cases

- A feature has no `coverage.md` but has a differently named coverage artifact; the check reports the required record as missing rather than silently accepting the alternate filename.
- A coverage table contains duplicate or unknown requirement identifiers.
- A coverage table uses the right headings but places an artifact path in the Outcome column.
- A completed feature has deferred requirements and must not be reported as fully satisfied without qualification.
- A corrective feature names more than one originating feature or corrects multiple requirements.
- A seeded defect affects a fixture that is intentionally exempt; the declared scope and exemption must be explicit and bounded.
- A directory rename leaves stale references, generated artifacts, or migration records.
- A static test and an executed-behavior test both exist for one requirement; the evidence identifies their separate roles.
- A requirement outside the enforced scope belongs to Feature 040; the check names that owner rather than silently ignoring the feature.
- A `historical` outcome appears in a feature numbered 021 or above; the check rejects it so the outcome cannot become an escape hatch for new work.
- A registered automatic check has no artifact class that can carry a seeded defect; its declared scope states why, rather than the probe being silently skipped.
- A rule cannot be brought to conformance within this change; it is recorded as enabled later rather than tagged as enforced.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The completion check MUST declare the set of completed feature directories it evaluates as Features 021 onward plus Feature 020, and MUST name Feature 040 as the owner of Features 001 through 019.
- **FR-002**: Every completed feature directory from Feature 021 onward, plus Feature 020, MUST contain a file named `coverage.md`.
- **FR-003**: Every `coverage.md` MUST use the columns `Requirement`, `Outcome`, and `Evidence` in that order.
- **FR-004**: Every coverage row MUST contain exactly one requirement identifier declared by the feature's `spec.md`, with no duplicate or unknown identifiers.
- **FR-005**: Every coverage outcome MUST be exactly `satisfied`, `deferred`, or `historical`, and every row MUST contain non-empty evidence.
- **FR-006**: A satisfying coverage row MUST identify an existing artifact; a deferred row MUST identify the reason and the feature or work that owns the deferral; a historical row MUST identify the completion record its claim carries forward from and MUST NOT imply an owner.
- **FR-007**: The completion check MUST fail for missing records, invalid schemas, malformed outcomes, missing evidence, duplicate requirements, unknown requirements, and absent satisfying artifacts.
- **FR-008**: The completion check MUST retain a passing assertion for Feature 021 and its existing valid fixtures while extending enforcement to every feature in scope.
- **FR-009**: Corrective feature coverage records MUST identify the originating completed feature and each requirement whose disposition is revised.
- **FR-010**: Back-filled coverage records MUST represent requirements corrected by later work as `deferred` and MUST name the superseding feature in evidence.
- **FR-011**: Feature 020 MUST receive a coverage record that identifies FR-002, FR-020, FR-024, FR-027, and FR-032 as deferred with corrective ownership.
- **FR-012**: Every registered `[auto]` check MUST declare its artifact scope as a set of artifact classes and MUST include a seeded failure probe for one artifact of each class, producing a non-zero result when that artifact is defective.
- **FR-013**: Coverage evidence for runtime-behavior requirements in Features 021 onward MUST identify executed-behavior evidence separately from static document-contract evidence.
- **FR-014**: Static prose-contract tests for requirements about `SKILL.md` content MUST remain permitted and MUST NOT be classified as runtime-behavior evidence.
- **FR-015**: The feature directory name MUST match the numeric and descriptive value declared by its `Feature Branch` field.
- **FR-016**: The Feature 036 directory MUST be renamed to match `036-strengthen-035-evidence` without modifying its completed spec contents.
- **FR-017**: The Feature 033 naming discrepancy MUST be reconciled and its chosen canonical path MUST be recorded without rewriting completed substantive artifacts.
- **FR-018**: The bracketed `Feature Branch` values in Features 001 and 005 MUST be reconciled so each declared value equals its directory name.
- **FR-019**: The Development Constitution MUST receive D3.7 and D3.8 in Principle III, D7.4 and D7.5 in Principle VII, and D5.5 in Principle V as a MINOR amendment with observables and tiers, recorded in its Sync Impact Report.
- **FR-020**: D5.5 and D7.4 MUST each appear in the Development Constitution Enforcement Map naming the test that decides them.
- **FR-021**: Every test in the suite MUST declare its instrument class, satisfying the first clause of D3.8's observable.
- **FR-022**: D3.7 and D3.8 MUST each be measured against the repository before being enabled, and any rule that cannot reach conformance in this change MUST be recorded as enabled later rather than tagged as enforced.
- **FR-023**: D5.1's Observable MUST be amended so that the coverage record is exempt from its no-diff rule and relocating a completed spec directory is not an edit to it; no other file's content may change under either exception, and D5.2 MUST remain unchanged.
- **FR-024**: The Development Constitution MUST NOT receive a new principle, and the Highway Skills Constitution and Experience Standard MUST remain unchanged.
- **FR-025**: The completion check MUST replace non-enforcing `PRE_ENABLE` reporting with assertions that can make the run fail.
- **FR-026**: The retroactive conformance work MUST be completed in the same change that enables the new rules, and the final verification suite MUST pass.
- **FR-027**: The `historical` outcome MUST be valid only for Features 001 through 020, and the completion check MUST reject it in any feature numbered 021 or above.

### Key Entities *(include if feature involves data)*

- **Coverage Record**: The required `coverage.md` mapping each feature requirement to an allowed outcome and evidence.
- **Requirement Coverage Row**: One unique requirement identifier, one allowed outcome, and evidence of satisfaction or deferral.
- **Corrective Feature Link**: A record connecting a later feature to the completed feature and requirement it corrects.
- **Declared Check Scope**: The completed feature set and artifact set against which an automatic check must enforce and prove failure.
- **Feature Record Identity**: The relationship between a feature directory name and its `Feature Branch` declaration.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of completed feature directories in the declared scope contain a conforming `coverage.md` record, with zero alternate coverage filenames used as substitutes.
- **SC-002**: 100% of requirement identifiers in every in-scope completed feature appear exactly once in its coverage record, with no malformed outcomes.
- **SC-003**: The completion check exits non-zero for each seeded missing-record, malformed-schema, invalid-outcome, duplicate-requirement, unknown-requirement, missing-evidence, and absent-artifact fixture, and exits zero after restoration.
- **SC-004**: 100% of registered `[auto]` checks declare their artifact classes and exit non-zero for a seeded defect in one artifact of each class.
- **SC-005**: 100% of corrective feature records identify the originating feature and revised requirement for each deferred historical requirement.
- **SC-006**: Feature 020's five identified residual requirements are recorded as deferred with corrective ownership.
- **SC-007**: Every feature directory from 001 onward matches its declared `Feature Branch` identity after reconciliation, with no placeholder directory names remaining.
- **SC-008**: Every new constitution rule has the specified principle, observable, tier, and MINOR amendment record, while no new principle or Layer 1/2 amendment is added.
- **SC-009**: Every `[auto]` rule appears in the Enforcement Map naming an existing test, and `constitution-inventory.test.sh` passes.
- **SC-010**: The full Highway test suite passes after retroactive conformance work, and no non-enforcing `PRE_ENABLE` line remains.
- **SC-011**: Zero `historical` outcomes appear in any feature numbered 021 or above, and zero coverage rows are recorded as `satisfied` without a resolvable artifact.

## Assumptions

- Feature numbering remains sequential and Feature 039 is the next available feature number.
- Coverage enforcement covers Features 021 onward plus Feature 020; feature-identity enforcement covers every directory from 001 onward. A feature whose tasks are incomplete is not a completed feature.
- The coverage record is a development artifact and may be updated only under the narrow D5.1 exceptions introduced by this feature; all other completed spec file content remains immutable.
- Features 001 through 019 hold 309 requirements with no re-derivable disposition; they are owned by Feature 040 under Phase 13, so that work is a separate change rather than a larger one here.
- Feature 020 is handled here rather than deferred, because Feature 021 already identified exactly which of its requirements are unsatisfied.
- This feature defines the `historical` outcome and bounds it to Features 001 through 020; Feature 040 is its only consumer.
- `satisfied` and `deferred` are the only valid coverage outcomes; deferred requirements are honest historical records, not test failures.
- Existing Feature 021 coverage behavior and fixtures are the baseline for extending the check's scope.
- Static prose-contract tests remain appropriate for requirements that constrain natural-language skill content.
- The declared artifact scope for automatic checks can be represented without adding a runtime dependency or requiring version control in the packaged toolchain.
- Feature 033's naming discrepancy can be reconciled through a recorded canonical choice without rewriting its substantive completed record.
- No user-owned Layer 3 content, shipped skill content, Skills Constitution rule, or Experience Standard rule is part of this feature.
