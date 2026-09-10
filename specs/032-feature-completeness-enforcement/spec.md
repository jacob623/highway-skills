# Feature Specification: Feature Completeness and Behavioral Evidence Enforcement

**Feature Branch**: `032-feature-completeness-enforcement`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "Address the completeness and compliance findings for Features 030 and 031 by restoring requirement coverage evidence, adding behavioral validation for the promised Control-derived NFR and relationship-integrity workflows, defining atomic failure behavior and relationship edge-case semantics, and reconciling feature lifecycle status."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Record complete requirement coverage (Priority: P1)

As a governance maintainer, I want completed feature records to map every requirement to evidence so that completion claims are auditable rather than inferred from checked task boxes.

**Why this priority**: Missing coverage records are a direct completion-accountability failure and make it impossible to distinguish documented intent from verified behavior.

**Independent Test**: Run the completion-coverage check against Features 030 and 031 and verify that each functional requirement appears exactly once with a satisfying artifact or an explicit deferral.

**Acceptance Scenarios**:

1. **Given** Feature 030 is marked complete, **When** its coverage record is checked, **Then** all 16 functional requirements each appear exactly once with a linked artifact and evidence status.
2. **Given** Feature 031 is marked complete, **When** its coverage record is checked, **Then** all 20 functional requirements each appear exactly once with a linked artifact and evidence status.
3. **Given** a requirement has only prose evidence or no behavioral evidence, **When** coverage is recorded, **Then** the record states that limitation instead of claiming executable satisfaction.

### User Story 2 - Verify Control-derived NFR behavior (Priority: P1)

As a governance author, I want the Control-derived NFR workflow exercised against representative baselines so that candidate generation, review, allocation, traceability, and rejection safety are proven before completion is claimed.

**Why this priority**: Feature 030 promises user-visible decisions and governed writes; static wording checks cannot establish that those decisions or writes occur correctly.

**Independent Test**: Run the workflow against isolated valid and invalid baselines, exercise every review decision, and compare resulting records and catalogs with expected outcomes.

**Acceptance Scenarios**:

1. **Given** a Control title and statement match the documented derivation rules, **When** proposal generation runs, **Then** candidates are produced in the documented deterministic order without modifying the baseline.
2. **Given** a proposal is accepted, modified, or replaced with author-approved wording, **When** the decision is confirmed, **Then** exactly one new NFR is allocated and both relationship fields contain the immutable identifiers.
3. **Given** a proposal is rejected or cancelled, **When** the workflow ends, **Then** no NFR, relationship, catalog, or unrelated record changes.
4. **Given** the baseline is invalid or an allocation/write step cannot complete safely, **When** the workflow runs, **Then** it stops before leaving a partial change.
5. **Given** a direct NFR is authored without a Control, **When** it is validated, **Then** `controls: []` remains valid and no Control is inferred.

### User Story 3 - Verify relationship integrity behavior (Priority: P1)

As a governance author, I want relationship inspection, repair, and impact analysis executed against representative baselines so that traceability repairs are reviewable, selective, deterministic, and safe.

**Why this priority**: Feature 031 claims to manage existing Control-to-NFR relationships without changing governance intent; that contract requires executable proof of both read-only and write paths.

**Independent Test**: Run inspection, repair planning, approved subset repair, declined repair, and destructive impact analysis against isolated baselines containing valid, asymmetric, orphaned, malformed, duplicate, and blocked records.

**Acceptance Scenarios**:

1. **Given** a baseline containing valid, asymmetric, orphaned, malformed, duplicate, and blocked relationships, **When** inspection runs, **Then** every finding is classified deterministically and no file changes.
2. **Given** an asymmetric relationship, **When** a repair proposal is generated and approved, **Then** only the missing reciprocal identifier is added.
3. **Given** an orphaned relationship, **When** its repair is approved, **Then** only the invalid reference is removed and non-relationship content is preserved.
4. **Given** multiple proposed repairs, **When** the author approves only a subset, **Then** only that subset is applied and all other findings remain unchanged.
5. **Given** a duplicate relationship, **When** repair is approved, **Then** the workflow applies the documented canonical membership rule without changing valid identifiers or record content.
6. **Given** a repair write fails after confirmation, **When** the operation ends, **Then** all affected records and catalogs remain in their pre-operation state.
7. **Given** a removal or baseline replacement is proposed, **When** impact is analyzed, **Then** every affected identifier and title is listed before confirmation and a declined operation changes nothing.

### User Story 4 - Keep completion claims and contracts aligned (Priority: P2)

As a repository reviewer, I want feature lifecycle status and evidence language to agree so that Draft specifications are not presented as fully implemented without an explicit explanation.

**Why this priority**: Inconsistent lifecycle metadata weakens trust in planning artifacts even when structural checks pass.

**Independent Test**: Review the status fields, tasks, coverage records, and validation evidence for Features 030 and 031 and verify that their state is consistent and explainable.

**Acceptance Scenarios**:

1. **Given** all implementation and evidence work is complete, **When** the feature records are reviewed, **Then** their status and completion claims use the repository's completed-state convention.
2. **Given** behavioral evidence remains unavailable, **When** a feature remains Draft, **Then** its tasks and coverage record do not claim full behavioral completion.
3. **Given** the remediation feature is complete, **When** repository validation runs, **Then** the coverage check reports no missing coverage for Features 030 and 031.

### Edge Cases

- A requirement is represented by multiple artifacts; coverage records exactly one primary evidence row and may link supporting evidence without duplicating the requirement.
- A behavior is documented but not executable; coverage reports it as documentation-only or deferred rather than satisfied by a static phrase assertion.
- Candidate generation produces no candidates; the workflow reports that state and performs no allocation or write.
- Two derivation rules produce equivalent candidates; deterministic deduplication preserves the documented rule order.
- A relationship field contains duplicate valid identifiers; repair normalizes membership according to the documented rule while preserving the artifact and identifier.
- A baseline replacement removes an artifact that has relationships on both sides; impact analysis lists each affected source, target, identifier, and title once in canonical order.
- A failure occurs after one file is staged but before the complete approved set is committed; the operation restores the original bytes and reports the blocking failure.
- Existing unrelated user-owned records and catalog entries contain arbitrary content; remediation preserves them byte-for-byte.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The repository MUST provide a coverage record for Feature 030 that maps all 16 functional requirements exactly once to a satisfying artifact or an explicit deferral.
- **FR-002**: The repository MUST provide a coverage record for Feature 031 that maps all 20 functional requirements exactly once to a satisfying artifact or an explicit deferral.
- **FR-003**: Each coverage record MUST distinguish executable behavioral evidence, structural validation, documentation-only evidence, and deferred work.
- **FR-004**: Feature 030 validation MUST execute deterministic candidate generation for each documented derivation rule and verify proposal ordering and no-write behavior.
- **FR-005**: Feature 030 validation MUST exercise Accept, Modify, Replace, Reject, and Cancel decisions and verify the resulting writes or zero-write outcomes.
- **FR-006**: Feature 030 validation MUST verify safe identifier allocation, two-sided relationship write-back, direct NFR empty relationships, invalid-baseline stopping, and preservation of unrelated content.
- **FR-007**: Feature 031 validation MUST execute graph inspection and classify valid, broken, asymmetric, orphaned, malformed, duplicate, and blocked findings.
- **FR-008**: Feature 031 validation MUST execute repair proposal generation and verify that every proposal includes affected artifact, current state, proposed state, reason, and impact.
- **FR-009**: Feature 031 validation MUST exercise explicit confirmation, cancellation, rejection, incomplete confirmation, and independent subset decisions with the required write outcomes.
- **FR-010**: Feature 031 validation MUST define and verify canonical duplicate relationship handling without changing identifiers or non-relationship content.
- **FR-011**: Feature 031 validation MUST define and verify the input, comparison, and output rules for removal and baseline-replacement impact analysis.
- **FR-012**: Approved Feature 031 repairs MUST be applied atomically so a validation, staging, or write failure leaves all affected records and catalogs byte-identical to their pre-operation state.
- **FR-013**: Feature 030 accepted writes MUST be applied atomically so a validation, allocation, or write failure leaves all affected records and catalogs byte-identical to their pre-operation state.
- **FR-014**: Both feature validation suites MUST compare repeated runs over byte-identical baselines and verify byte-identical reports, proposals, ordering, and resulting relationship fields.
- **FR-015**: Both feature validation suites MUST use isolated disposable baselines and MUST remove all temporary probes after positive and negative cases.
- **FR-016**: Feature 030 and Feature 031 task, plan, specification, coverage, and validation language MUST not claim behavioral completion where only static contract evidence exists.
- **FR-017**: Feature 030 and Feature 031 lifecycle status MUST follow one consistent repository convention for Draft, implemented, and complete states.
- **FR-018**: Remediation MUST preserve existing identifiers, titles, statements, rationales, statuses, unrelated records, and unrelated catalog content byte-for-byte unless a requirement explicitly authorizes a relationship-only change.
- **FR-019**: Remediation MUST preserve the existing Control-to-NFR relationship fields and MUST NOT create a second relationship store or infer new governance intent.
- **FR-020**: Repository validation MUST report no missing completion coverage for Features 030 and 031 and MUST pass the focused behavioral checks and full suite with zero failures.

### Key Entities

- **Requirement Coverage Record**: A one-to-one mapping from a feature requirement identifier to its primary evidence artifact and evidence status.
- **Behavioral Evidence Case**: An isolated input baseline, operation, expected result, and preservation assertion for a promised workflow behavior.
- **Atomic Operation Result**: The complete approved change set or the unchanged pre-operation state plus a blocking failure explanation.
- **Lifecycle Status**: The feature state used to align specification, task, implementation, coverage, and validation claims.
- **Integrity Finding and Repair Decision**: The classified relationship condition and its independently reviewable approval, rejection, cancellation, or incomplete outcome.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Completion coverage reports exactly one evidence row for every FR in Features 030 and 031, with zero missing, duplicate, or unexplained requirement identifiers.
- **SC-002**: Feature 030 behavioral validation covers 100% of documented candidate rules and all five review decisions, with zero unexpected writes in rejection, cancellation, invalid-baseline, and no-candidate cases.
- **SC-003**: Feature 031 behavioral validation covers 100% of documented finding classes, repair decisions, and destructive-impact paths, with zero unexpected writes in read-only or declined cases.
- **SC-004**: 100% of injected mid-operation failures leave all affected records and catalogs byte-identical to their pre-operation state.
- **SC-005**: Repeated validation over identical baselines produces byte-identical reports, proposals, ordering, and approved outputs in 100% of comparison runs.
- **SC-006**: 100% of duplicate relationship cases produce the documented canonical result while preserving identifiers and non-relationship fields.
- **SC-007**: 100% of destructive-impact cases list each affected identifier and title individually before confirmation.
- **SC-008**: The full repository suite and focused behavioral checks complete with zero failures, and no temporary probe files remain afterward.
- **SC-009**: Feature status, task completion, coverage evidence, and validation results are mutually consistent for Features 030 and 031.
- **SC-010**: Existing unrelated user-owned records and catalogs remain byte-identical in 100% of remediation validation runs.

## Assumptions

- Features 030 and 031 remain the scope of remediation; no new governance artifact types are introduced.
- Existing Control and NFR records and their `nfrs` and `controls` fields remain authoritative.
- The repository's existing completion-coverage convention remains the source of truth for requirement mapping.
- Behavioral validation may use disposable repository trees and deterministic fixtures, but completion claims require execution evidence rather than phrase presence alone.
- Atomicity means that an operation either commits its complete approved change set or leaves every affected byte unchanged.
- Duplicate relationship handling will canonicalize identifier membership without reordering unrelated record content or changing immutable identifiers.
- Feature status will use the repository convention established by neighboring completed features.
- No user-owned governance record or catalog is created solely to validate remediation.
