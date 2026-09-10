# Feature Specification: Readiness Verification Corrections

**Feature Branch**: `038-readiness-verification-corrections`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "Create a corrective follow-up for Feature 037 findings: resolve the NFR Missing versus In Progress contradiction, align planning artifacts with the canonical .highway/skills source tree, and make readiness verification execute real owner fixtures rather than only static contract checks."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Reconcile NFR readiness states (Priority: P1)

As a Highway maintainer, I want one authoritative NFR readiness state model so that owner skills, Setup routing, contracts, tests, and documentation cannot disagree about when NFRs are Missing or In Progress.

**Why this priority**: The contradiction affects routing behavior and makes the readiness contract impossible to interpret consistently.

**Independent Test**: Evaluate every defined NFR state, including candidate generation with zero candidates, candidates with no accepted proposal, accepted artifacts, unavailable generation, malformed generation, and any explicitly retained Missing state. Confirm each input maps to exactly one documented status and route.

**Acceptance Scenarios**:

1. **Given** NFR candidates exist and none are accepted, **When** NFR readiness is evaluated, **Then** it returns `In Progress` and the owner next action identifies author review.
2. **Given** candidate generation succeeds with zero candidates and no accepted NFR artifacts, **When** NFR readiness is evaluated, **Then** it returns `Not Applicable` and Setup treats the state as terminal success.
3. **Given** candidate generation is unavailable, malformed, or contradictory, **When** NFR readiness is evaluated, **Then** it returns `Blocked` with a non-empty blocking reason and Setup does not report completion.
4. **Given** the state model does not require an NFR `Missing` state, **When** contracts and routing are reviewed, **Then** no owner contract, Setup route, fixture, or coverage record requires that unreachable state.

### User Story 2 - Keep planning artifacts aligned with source ownership (Priority: P1)

As a Highway maintainer, I want Feature 038 planning records to identify `.highway/skills` as the canonical source and generated adapter trees as outputs so that implementation tasks and compliance review point to the files that actually own behavior.

**Why this priority**: Incorrect source paths can cause future edits to bypass the generator and recreate the Feature 037 source/generated confusion.

**Independent Test**: Inspect the Feature 038 plan and task artifacts for canonical source paths, absence of unresolved template placeholders, explicit generated-output handling, and a documented relationship to Feature 037.

**Acceptance Scenarios**:

1. **Given** the canonical source tree is `.highway/skills`, **When** the plan and tasks are read, **Then** all behavior-owning skill paths point to `.highway/skills` and generated paths are identified separately.
2. **Given** a new corrective feature is created, **When** its plan is reviewed, **Then** no template instructions, placeholder complexity rows, or unresolved action-required markers remain.
3. **Given** Feature 037 remains historical, **When** Feature 038 describes its correction, **Then** it names the affected findings without modifying Feature 037's completed spec record.

### User Story 3 - Verify owner behavior with executable fixtures (Priority: P1)

As a Highway maintainer, I want readiness tests to exercise real owner inputs and outputs so that passing static text checks cannot be mistaken for proof of runtime behavior.

**Why this priority**: The previous evidence validated response-shaped strings and documentation, but did not demonstrate that each owner computes the claimed state from artifact fixtures.

**Independent Test**: Run owner-specific fixtures that create disposable Profile, Objective, Control, and NFR inputs, invoke the documented readiness behavior, capture the exact four-field response, compare artifact hashes before and after, and repeat unchanged cases to verify deterministic output.

**Acceptance Scenarios**:

1. **Given** a valid Profile, Objective baseline, Control baseline, or accepted NFR baseline fixture, **When** its owner readiness action is exercised, **Then** the response is `Complete` with `Next Action: None` and `Blocking Reason: None`.
2. **Given** missing, malformed, empty, whitespace-only, contradictory, pending, or zero-candidate fixtures, **When** owner readiness is exercised, **Then** the response matches the authoritative owner state table and no fixture artifact or identifier changes.
3. **Given** an unchanged fixture is evaluated at least three times, **When** the responses and artifact hashes are compared, **Then** all response fields and hashes are identical.
4. **Given** Setup receives captured owner responses, **When** ordered routing is exercised, **Then** it stops at the first non-complete prerequisite, preserves downstream non-inspection, and routes NFR `In Progress`, `Blocked`, and `Not Applicable` distinctly.

### Edge Cases

- A candidate result reports zero candidates while also containing candidate entries; the result is `Blocked`, not `Not Applicable`.
- An NFR candidate set exists before author review begins; the selected state remains the explicitly documented state and is not inferred from proposal activity.
- A malformed owner response has the right field names but an unknown status or an inconsistent blocking reason; Setup reports deterministic `Blocked` orchestration.
- A fixture has valid-looking content but a missing catalog, invalid next identifier, duplicate identifier, or inconsistent relationship; the owning readiness result is `Blocked`.
- Generated adapters are stale or manually changed after source edits; verification reports correspondence failure without silently treating the adapter as source.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The authoritative NFR readiness state model MUST define exactly one status and next action for every supported candidate-generation and accepted-artifact input state.
- **FR-002**: The authoritative NFR readiness state model MUST either define an executable `Missing` state with its input condition and fixture or explicitly exclude `Missing` from NFR owner and Setup routing contracts.
- **FR-003**: All Feature 038 contracts, plan text, tasks, tests, and coverage records MUST use the same NFR state vocabulary and transition rules.
- **FR-004**: Feature 038 planning artifacts MUST identify `.highway/skills/` as the canonical source tree and generated agent adapter trees as outputs.
- **FR-005**: The Feature 038 plan MUST contain no unresolved template instructions, placeholder rows, or `ACTION REQUIRED` markers.
- **FR-006**: Feature 038 MUST preserve Feature 037 as an immutable historical spec record and record each corrected finding in the new feature's scope.
- **FR-007**: Owner verification MUST create disposable fixtures for Profile, Objectives, Controls, and NFRs that represent every required complete, missing, blocked, pending, and not-applicable state applicable to each owner.
- **FR-008**: Owner verification MUST invoke the documented readiness behavior against fixture inputs and parse the emitted four-field response rather than validating only canned response strings.
- **FR-009**: Owner verification MUST compare fixture artifact and identifier hashes before and after each readiness evaluation and fail on mutation.
- **FR-010**: Owner verification MUST repeat unchanged fixture evaluations at least three times and fail when any response field or artifact hash differs.
- **FR-011**: Setup verification MUST feed captured owner responses in Profile, Objectives, Controls, NFR order and verify first-non-complete short-circuiting and downstream non-inspection.
- **FR-012**: Setup verification MUST assert distinct routing for each retained NFR non-complete state and successful completion for `Complete` and `Not Applicable`.
- **FR-013**: Static contract checks MUST remain separate from executable owner behavior, Setup routing, and generated-artifact checks in the final evidence report.
- **FR-014**: Generated adapters and catalogs MUST be regenerated from canonical source inputs and checked for correspondence without hand-editing generated outputs.
- **FR-015**: Feature 038 documentation MUST report implementation checks, requirement coverage, generated-artifact checks, and any limitation separately.

### Key Entities *(include if feature involves data)*

- **Authoritative NFR State Model**: The single ordered mapping from candidate-generation and accepted-artifact inputs to NFR status, summary, next action, and blocking reason behavior.
- **Owner Fixture**: A disposable artifact tree and input state used to exercise one owner readiness action.
- **Readiness Evidence Record**: The captured four-field response plus before/after hashes, repeat-run comparisons, selected route, and evidence category.
- **Canonical Source Map**: The documented distinction between `.highway/skills/` source files and generated GitHub, Claude, Cursor, catalog, and distribution outputs.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of NFR state rows in the authoritative state model appear exactly once across the owner contract, Setup contract, executable fixtures, and requirement coverage record.
- **SC-002**: The Feature 038 plan contains zero unresolved template markers and 100% of behavior-owning skill paths resolve to `.highway/skills/`.
- **SC-003**: 100% of required owner fixture categories execute a documented readiness behavior and produce a parsed four-field response.
- **SC-004**: 100% of owner fixture evaluations preserve artifact and identifier hashes before and after readiness evaluation.
- **SC-005**: At least three repeated runs for every unchanged owner fixture produce identical response fields and artifact hashes.
- **SC-006**: Setup routing verification covers every retained NFR non-complete state, stops at the first non-complete prerequisite in 100% of ordered cases, and evaluates no later owner after short-circuiting.
- **SC-007**: Generated adapter, catalog, and distribution correspondence checks pass after regeneration from canonical source inputs.
- **SC-008**: The final evidence report contains separate executable behavior, Setup routing, static contract, generated-artifact, coverage, and limitation results.

## Assumptions

- Feature 037 remains the historical record; Feature 038 adds corrections rather than rewriting it.
- The repository's existing Markdown skill conventions, Bash 3.2-compatible utilities, validators, and generators remain available.
- Readiness remains a derived read-only result and does not introduce a persistent readiness artifact.
- Owner readiness actions can be exercised in disposable fixture trees without changing user-owned repository artifacts.
- If a direct runtime invocation of a natural-language skill is not available to the test harness, the fixture harness will execute the owner decision logic through a deterministic test adapter that is explicitly documented as evidence of behavior, not as a replacement for the skill contract.
- No external service or new runtime dependency is required.
