# Feature Specification: Completion Claim Accountability

**Feature Branch**: `021-completion-claim-accountability`

**Created**: 2026-09-08

**Status**: Draft

**Input**: User description: I want a completion claim to be accountable, because today a task is marked complete by asserting it and nothing objects. Feature 020 demonstrated that passing checks and completed task checkboxes can coexist with unimplemented requirements, unrun scenarios, and unreferenced fixtures.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A test claim is evidenced before completion (Priority: P1)

As a maintainer, I want a test claimed by an implementation task to have a recorded failing observation before the implementation passes it, so that a green result demonstrates the intended behavior rather than an assertion that was green from birth.

**Why this priority**: A test that was never observed failing may not exercise the missing behavior. This is the smallest control that distinguishes a real red-to-green implementation loop from a static contract check that was never discriminating.

**Independent Test**: Add a temporary test and task to an isolated feature fixture, record no failing observation, and verify the completion review identifies the missing evidence. Add the failing observation and verify the same fixture is accepted.

**Acceptance Scenarios**:

1. **Given** a task claims a test covers a behavior, **When** no pre-implementation failing result is recorded, **Then** the task cannot be accepted as complete.
2. **Given** a test has a recorded failure naming the uncovered behavior and the later implementation makes it pass, **When** completion is reviewed, **Then** the test-evidence requirement is satisfied.
3. **Given** a prose-contract test is appropriate because the subject is agent instructions, **When** completion is reviewed, **Then** the test is not rejected merely because it is static.

---

### User Story 2 - Completed tasks correspond to their artifacts (Priority: P1)

As a maintainer, I want each completed task to be checked against the artifact path and change it names, so that a checked task cannot claim work absent from the repository.

**Why this priority**: Feature 020 marked tasks complete whose described assertions and skill clauses were absent. Task-level correspondence is the direct boundary between an implementation record and the files it claims to have changed.

**Independent Test**: Create isolated task fixtures with one accurate completed task and one task whose named artifact lacks the described change; verify the first is accepted and the second is identified as incomplete.

**Acceptance Scenarios**:

1. **Given** a completed task names an existing artifact and a change present in that artifact, **When** completion is reviewed, **Then** the task passes artifact correspondence review.
2. **Given** a completed task names a missing artifact, **When** completion is reviewed, **Then** the task fails and names the missing path.
3. **Given** a completed task names an existing artifact but describes a change absent from it, **When** completion is reviewed, **Then** the task fails rather than relying on the checkbox alone.
4. **Given** a task is intentionally deferred, **When** the feature is reported, **Then** it remains unchecked and is not counted as completed work.

---

### User Story 3 - Every requirement has an explicit coverage outcome (Priority: P1)

As a maintainer, I want a completed feature to record each requirement exactly once against a satisfying artifact or an explicit deferral, so that passing tests are not mistaken for complete requirements.

**Why this priority**: A test suite can validate tooling, registration, or correspondence while missing a feature requirement. Requirement coverage makes the feature claim independently auditable.

**Independent Test**: Create completed-feature fixtures with complete, duplicated, missing, satisfied, and deferred requirement mappings; verify only the complete mapping passes the mechanical coverage check.

**Acceptance Scenarios**:

1. **Given** every requirement ID in `spec.md` appears exactly once in the coverage record, **When** the coverage check runs, **Then** the feature passes the coverage rule.
2. **Given** a requirement ID is missing from the coverage record, **When** the coverage check runs, **Then** the feature fails and names the missing ID.
3. **Given** a requirement ID appears more than once, **When** the coverage check runs, **Then** the feature fails and names the duplicate ID.
4. **Given** a requirement is not implemented, **When** the feature is reported, **Then** its coverage entry states a deferral rather than claiming satisfaction.
5. **Given** a requirement is satisfied, **When** the feature is reported, **Then** its coverage entry names the artifact that satisfies it.

---

### User Story 4 - Completion reports separate evidence from coverage (Priority: P2)

As a maintainer, I want a completion report to distinguish check results from requirement coverage, so that a green suite is reported as evidence and not as proof that every requirement was implemented.

**Why this priority**: Feature 020's final report presented passing checks and completion as though they were equivalent. Separating the claims makes residual gaps visible without weakening existing validation gates.

**Independent Test**: Review reports with only test results, only requirement coverage, both separated, and both conflated; verify only the report with distinct sections is compliant.

**Acceptance Scenarios**:

1. **Given** a completion report lists passing commands, **When** it is reviewed, **Then** it also has a separately identifiable requirement-coverage result.
2. **Given** a feature has deferred requirements, **When** the completion report is written, **Then** the deferrals are visible in the coverage section and are not hidden by the test summary.
3. **Given** a report claims the feature is complete, **When** any requirement is deferred or any task remains incomplete, **Then** the report uses a qualified status rather than an unqualified completion claim.

### Edge Cases

- A test may be static when the behavior under test is agent instructions; static form alone does not invalidate its evidence.
- A test may have a recorded failure from an unrelated assertion; the evidence must identify the claimed behavior, not merely contain a red exit code.
- A task may name multiple artifacts; each named artifact must be present and relevant to the described change.
- A requirement may be satisfied by more than one artifact, but its coverage record must still contain one authoritative entry.
- A requirement may be explicitly deferred; a deferral is an honest coverage outcome, not satisfaction.
- A completed feature may have all checks passing while requirements remain deferred; the report must preserve that distinction.
- A feature directory may contain historical spec artifacts that must not be edited after completion; coverage belongs in the new feature's completion record or a designated companion artifact.
- A malformed coverage record, unknown requirement ID, or unknown artifact path must fail rather than being silently ignored.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Development Constitution MUST require that a test claimed by an implementation task is observed failing for the claimed behavior before that task is marked complete.
- **FR-002**: The test-evidence rule MUST allow static prose-contract tests when the artifact under test is agent instructions, while still requiring a behavior-specific failing observation.
- **FR-003**: The Development Constitution MUST require that a completed task's named artifact contains the change described by the task.
- **FR-004**: The task-accountability review MUST report a missing named artifact or an absent described change rather than treating `[X]` as sufficient evidence.
- **FR-005**: The feature completion record MUST contain a requirement-coverage mapping for every requirement ID in its `spec.md`.
- **FR-006**: Each requirement ID MUST appear exactly once in the coverage mapping.
- **FR-007**: Each coverage entry MUST identify either a satisfying artifact or an explicit deferral with a reason.
- **FR-008**: The coverage check MUST report missing, duplicated, unknown, and malformed requirement mappings without silently repairing them.
- **FR-009**: The requirement-coverage check MUST be registered as the automatic check for the new automatic Development Constitution rule.
- **FR-010**: The new automatic check MUST be evaluated against every existing completed feature before it is enabled, with each feature's verdict recorded.
- **FR-011**: The new automatic check MUST have a demonstrated failing case caused by removing a requirement ID from an otherwise valid coverage record, followed by a passing result after restoration.
- **FR-012**: A completion report MUST present test/check results and requirement coverage as separate claims.
- **FR-013**: A completion report MUST distinguish satisfied requirements from explicitly deferred requirements.
- **FR-014**: An unqualified complete status MUST NOT be reported when any requirement is deferred or any implementation task remains incomplete.
- **FR-015**: The feature MUST add D3.6 to Principle III and create Principle VII with D7.1, D7.2, and D7.3 in the Development Constitution as a MINOR amendment, preserving the D namespace, Observables, tier declarations, and amendment history.
- **FR-016**: D7.2 MUST be tagged `[auto]`; D3.6, D7.1, and D7.3 MUST remain `[agent-checkable]` because their semantic judgments cannot be honestly reduced to a proxy check.
- **FR-017**: The feature MUST NOT require tests to be behavioral rather than static when a static prose-contract test is the appropriate instrument.
- **FR-018**: The existing Feature 020 gaps MUST be recorded as explicit coverage outcomes or deferred follow-up work rather than being represented as satisfied requirements.

### Key Entities *(include if feature involves data)*

- **Completion claim**: The assertion that a task or feature is complete, supported by task state, artifacts, checks, and requirement coverage.
- **Test evidence record**: A behavior-specific record that a claimed test failed before implementation and passed after implementation.
- **Task correspondence record**: The relationship between a completed task, its named artifact path, and the described change found there.
- **Requirement-coverage mapping**: One entry for each requirement ID, identifying a satisfying artifact or an explicit deferral and reason.
- **Completion report**: A maintainer-facing summary with separate check results, requirement coverage, residual deferrals, and status.
- **Completed feature**: A numbered feature directory whose implementation record is being assessed for completion integrity.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every completed task fixture with a missing artifact or absent described change is rejected by the task-accountability review, while an accurate fixture passes.
- **SC-002**: Every completed feature fixture has exactly one coverage entry per requirement ID, or is rejected with the missing, duplicate, unknown, or malformed mapping named.
- **SC-003**: The automatic coverage check fails when one requirement ID is removed from a valid coverage record and passes again when that ID is restored.
- **SC-004**: Every existing completed feature is assessed by the coverage check before it is enabled, with no feature silently omitted from the recorded verdicts.
- **SC-005**: A completion report with passing checks but deferred requirements is classified as qualified rather than unqualified complete.
- **SC-006**: The Development Constitution contains D3.6 and D7.1-D7.3 with the specified tiers, Observables, and amendment record, and no new proxy check is introduced for semantic rules.
- **SC-007**: At least one valid static prose-contract test fixture is accepted when it has behavior-specific red-to-green evidence.
- **SC-008**: Feature 020's five known unimplemented requirements are visible as unsatisfied or deferred in its coverage record, rather than being counted as satisfied by the passing suite.

## Assumptions

- The existing Spec Kit feature directory numbering is sequential, so this feature is numbered 021 after Feature 020.
- The Development Constitution remains the authoritative home for rules governing specs, tasks, tests, and completion reports.
- The automatic coverage check compares requirement IDs and coverage entries mechanically; artifact satisfaction and semantic task correspondence remain reviewable rather than being forced into unreliable proxies.
- Existing completed features may not have coverage records yet; the pre-enable evaluation must record their verdicts and classify missing records honestly instead of fabricating coverage.
- Feature 020's completed spec artifacts remain historical records. Its residual implementation gaps will be addressed by a later numbered feature rather than editing Feature 020 after completion.
- Existing suite commands and generated-artifact correspondence checks remain in force; this feature adds accountability rather than replacing them.

## Out of Scope

- Automatically deciding whether an artifact semantically satisfies a requirement.
- Requiring every test to be executable or forbidding static contract tests.
- Rewriting completed feature specs or silently changing their task history.
- Treating a passing test suite as equivalent to complete requirement coverage.
- Automatically marking tasks complete or fabricating failing observations.
- Implementing the five residual Feature 020 requirements; this feature records them as evidence for the accountability rules.
