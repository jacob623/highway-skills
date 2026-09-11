# Feature Specification: Historical Coverage Reconstruction

**Feature Branch**: `040-historical-coverage-reconstruction`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "I want every completed feature below 021 to carry a coverage record, so that D7.4's scope becomes the whole project history rather than only the features built after the rule existed. Feature 039 enforced D7.4 from Feature 021 onward plus Feature 020, added the coverage.md schema with the Requirement, Outcome and Evidence columns, and added a third outcome, historical, valid only for Features 001 through 020. This feature is the only consumer of that outcome and after it there should never be another. Verified 2026-09-10: nineteen completed features sit below 021, Feature 003 is incomplete and out of scope, they hold 309 functional requirements between them, and not one has a coverage record. Write a coverage.md for each of Features 001, 002, 004 through 019 under its existing spec directory, using the schema Feature 039 established, with one row for every functional requirement id declared in that feature's spec.md, no duplicates and no unknown ids. Mark a requirement satisfied only when a named artifact that satisfies it can be pointed at in the tree as it stands today; mark it deferred only when a later feature demonstrably corrected it, naming that feature; and mark it historical in every other case, with evidence naming the completion record the claim is carried forward from. A predominantly satisfied result is a defect in this feature, not a success: manufacturing green rows is the exact failure that Features 021 and 039 exist to prevent, and doing it at this scale while completing their work would be the worst version of it. Do not mark any row satisfied on the strength of the suite being green or the feature having shipped. Then widen completion-coverage.test.sh's declared scope from Features 021 onward plus 020 to Features 001 onward, keep every assertion Feature 039 added, and add an assertion that the historical outcome appears only in Features 001 through 020 so it cannot become an escape hatch for new work. Add no new constitution rule, open no new principle, amend neither the Highway Skills Constitution nor the Experience Standard, and do not edit any completed spec file other than the coverage record that Feature 039's D5.1 exception already permits. Begin and end from a passing .highway/tools/tests/run-all.sh."

## Clarifications

### Session 2026-09-10

- Q: Should Feature 040 treat the “19 completed features below 021” as the combined set of Features 001, 002, 004–019 plus the already-covered Feature 020? -> A: Yes. Feature 040 creates 18 new records; Feature 020 is already covered by Feature 039.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Reconstruct pre-021 coverage honestly (Priority: P1)

As a Highway maintainer, I want each completed feature before 021 to have a complete coverage record so that the project's historical completion claims are explicit without inventing evidence.

**Why this priority**: Features 001 through 019 predate the coverage rule, and their records cannot be treated as complete merely because the features shipped or the suite is currently green.

**Independent Test**: Inspect every target `coverage.md`, compare its requirement identifiers with that feature's `spec.md`, and review the outcome and evidence for each row against the current repository tree and later corrective features.

**Acceptance Scenarios**:

1. **Given** a completed target feature from 001, 002, or 004 through 019, **When** its coverage record is reviewed, **Then** it exists under that feature's existing directory with exactly the `Requirement`, `Outcome`, and `Evidence` columns.
2. **Given** a functional requirement has a currently verifiable satisfying artifact, **When** its row is recorded, **Then** the row is `satisfied` and names that artifact.
3. **Given** a later feature demonstrably corrected the requirement, **When** its originating historical row is recorded, **Then** the row is `deferred` and names the correcting feature.
4. **Given** neither a current satisfying artifact nor a demonstrated later correction can be established, **When** the row is recorded, **Then** the row is `historical` and names the completion record whose claim is carried forward.
5. **Given** the completed feature's current tests pass, **When** a requirement has no other qualifying evidence, **Then** the row is not marked `satisfied` solely because the tests pass.

### User Story 2 - Enforce coverage across the project history (Priority: P1)

As a Highway maintainer, I want the completion check to inspect every completed feature from 001 onward so that missing or malformed historical coverage cannot remain invisible.

**Why this priority**: Feature 039 established the schema and outcome vocabulary but intentionally stopped at Feature 020 plus 021 onward; this feature closes the remaining scope without introducing another governance rule.

**Independent Test**: Remove a target coverage record, remove a requirement row, add a duplicate or unknown identifier, and place `historical` in a feature numbered 021 or above; each state must fail, while the restored repository must pass.

**Acceptance Scenarios**:

1. **Given** the target records are present and valid, **When** the completion check runs, **Then** it evaluates all completed features from 001 onward while excluding incomplete Feature 003.
2. **Given** a target feature has no `coverage.md`, **When** the completion check runs, **Then** it exits non-zero and identifies the missing record.
3. **Given** a coverage row uses `historical` for a feature numbered 021 or above, **When** the completion check runs, **Then** it exits non-zero.
4. **Given** all target records are restored, **When** the completion check runs, **Then** it passes without weakening the assertions established by Feature 039.

### User Story 3 - Preserve governance boundaries (Priority: P2)

As a Highway maintainer, I want this historical reconstruction to remain a records-and-check scope change so that it does not silently create new governance obligations or rewrite completed feature history.

**Why this priority**: The historical rows are permitted accounting updates; substantive spec content and the two shipping governance documents must remain unchanged.

**Independent Test**: Review the change set and confirm that only the permitted coverage records and completion-check scope are changed, with no constitution amendment, new principle, or Experience Standard change.

**Acceptance Scenarios**:

1. **Given** a completed target feature directory, **When** the reconstruction is applied, **Then** no file other than its newly created `coverage.md` is edited.
2. **Given** the Development Constitution, Highway Skills Constitution, and Experience Standard, **When** the change is reviewed, **Then** none receives a new rule, principle, or amendment.
3. **Given** the full test suite passes before the change, **When** the reconstruction is complete, **Then** it also passes after the change.

### Edge Cases

- Feature 003 has incomplete tasks and remains outside the completed-feature coverage scope.
- A feature's requirement numbering is non-contiguous; the coverage record follows the identifiers declared in `spec.md`, not an assumed numeric range.
- A later corrective feature addresses only some requirements from an earlier feature; only those rows are `deferred`.
- A current artifact exists but does not actually satisfy the requirement; its existence alone does not justify `satisfied`.
- A completion record is available as historical provenance but no current satisfying artifact or corrective feature exists; the row is `historical` without implying an owner.
- A malformed or alternate coverage filename exists; only `coverage.md` satisfies the required record path.
- A row contains a duplicate or unknown requirement identifier; the check rejects the feature rather than silently normalizing it.
- A historical outcome appears in a feature numbered 021 or above; the check rejects it as an escape hatch for new work.
- The resulting records are predominantly `satisfied`; this is treated as a review signal for manufactured evidence, not as success.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The feature MUST create `coverage.md` under each completed feature directory for Features 001, 002, and 004 through 019, and MUST leave incomplete Feature 003 outside the scope.
- **FR-002**: Each created coverage record MUST use exactly the columns `Requirement`, `Outcome`, and `Evidence` in that order.
- **FR-003**: Each coverage record MUST contain exactly one row for every functional requirement identifier declared in its feature's `spec.md`, with no duplicate and no unknown identifiers.
- **FR-004**: A row MAY use `satisfied` only when its evidence names a current repository artifact that can be pointed at as satisfying that requirement.
- **FR-005**: A row MUST use `deferred` only when a later feature demonstrably corrected that requirement, and its evidence MUST name the correcting feature.
- **FR-006**: A row MUST use `historical` when neither a current satisfying artifact nor a demonstrated later correction can be established, and its evidence MUST name the completion record whose claim is carried forward without implying an owner.
- **FR-007**: No row MUST be marked `satisfied` solely because the feature shipped, the current suite is green, or the original completion record asserted completion.
- **FR-008**: The completion check MUST widen its completed-feature coverage scope from Feature 020 plus Features 021 onward to every completed feature from 001 onward, while continuing to exclude incomplete Feature 003.
- **FR-009**: The completion check MUST retain Feature 039's checks for the required file, exact headers, allowed outcomes, evidence, requirement identity, duplicate rows, unknown rows, missing rows, and satisfying-artifact existence.
- **FR-010**: The completion check MUST reject a `historical` outcome in any feature numbered 021 or above.
- **FR-011**: The feature MUST NOT add or amend a constitution rule, open a constitution principle, amend the Highway Skills Constitution, amend the Experience Standard, or edit a completed spec file other than its permitted `coverage.md` record.
- **FR-012**: The implementation MUST begin and end with `.highway/tools/tests/run-all.sh` passing.

### Key Entities

- **Historical coverage record**: The `coverage.md` artifact that maps one pre-021 feature requirement to `satisfied`, `deferred`, or `historical` evidence.
- **Current satisfying artifact**: A repository artifact that exists now and substantively satisfies the requirement named by a coverage row.
- **Corrective feature**: A later feature that demonstrably addressed a requirement from an earlier feature and therefore may be named by a `deferred` row.
- **Carried-forward completion record**: The earlier feature record named by a `historical` row when the original claim is preserved without re-asserting current satisfaction.
- **Completed feature scope**: Features 001, 002, and 004 through 019 for this reconstruction, plus the already-enforced Feature 020 and Features 021 onward; incomplete Feature 003 is excluded.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 18 newly targeted feature records for Features 001, 002, and 004 through 019 have a `coverage.md` file; together with Feature 020's existing record, this accounts for all 19 completed features below 021, while Feature 003 remains excluded.
- **SC-002**: The 309 functional requirements in the verified pre-021 scope are represented exactly once across the new coverage records, with zero duplicate or unknown identifiers.
- **SC-003**: Every `satisfied` row names an artifact that exists in the repository at completion, every `deferred` row names a demonstrated correcting feature, and every remaining row is `historical` with a named carried-forward completion record.
- **SC-004**: A review of the outcome distribution reports the count and proportion of `satisfied`, `deferred`, and `historical` rows, and treats a predominantly satisfied result as a defect requiring correction rather than as a success signal.
- **SC-005**: The completion check evaluates every completed feature from 001 onward, excludes incomplete Feature 003, and rejects every seeded missing-record, malformed-schema, duplicate, unknown, missing-evidence, absent-artifact, and out-of-range-historical state.
- **SC-006**: No `historical` outcome appears in any feature numbered 021 or above.
- **SC-007**: No constitution or Experience Standard file is amended, no new principle is introduced, and no completed spec file other than the permitted coverage records is changed.
- **SC-008**: `.highway/tools/tests/run-all.sh` exits successfully before and after the change.

## Assumptions

- Feature 039's `coverage.md` schema and bounded outcome vocabulary are authoritative for this feature.
- The verified baseline is 18 newly targeted completed features plus already-covered Feature 020, for 19 completed features below 021 and 309 functional requirements in the stated historical scope; Feature 003 is incomplete and excluded.
- A current artifact must be substantively relevant to the requirement, not merely present, for a row to be `satisfied`.
- Later corrective features are named as `deferred` owners only where the repository provides demonstrable evidence of correction; otherwise the row is `historical`.
- Historical provenance names the originating feature's completion record and does not create new work ownership.
- The permitted Feature 039 exception allows adding `coverage.md` records to completed feature directories without changing their substantive spec content.
- Feature numbering and existing directory names remain unchanged by this feature.
- No new constitution rule is needed because Feature 039 already established the schema, vocabulary, and enforcement obligations.
- The current Bash-compatible test toolchain remains sufficient; no runtime dependency is introduced.
