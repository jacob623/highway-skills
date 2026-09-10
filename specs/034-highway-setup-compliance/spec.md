# Feature Specification: Highway Setup Compliance Hardening

**Feature Branch**: `034-highway-setup-compliance`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "Create spec 034 to address the completeness and compliance findings for Feature 033 highway-setup."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Verify setup behavior with executable scenarios (Priority: P1)

As a Highway maintainer, I want the Feature 033 verification to execute realistic setup scenarios so that passing tests demonstrate orchestration behavior rather than only checking skill prose.

**Why this priority**: Behavioral evidence is the primary compliance gap. Without executable scenarios, the repository cannot substantiate ordered evaluation, delegation, continuation, safe stopping, or idempotence.

**Independent Test**: Run the Feature 034 verification against disposable repository states and deterministic owner-workflow doubles; each scenario records readiness reads, owner calls, output, and artifact hashes.

**Acceptance Scenarios**:

1. **Given** an empty repository, **When** setup is executed, **Then** Profile is evaluated first, no downstream area is evaluated, and the incomplete dashboard identifies Profile setup.
2. **Given** each prerequisite baseline is complete and the next baseline is absent, **When** setup is executed, **Then** the correct owner workflow is called exactly once before the next readiness evaluation.
3. **Given** an owner workflow succeeds and creates its required valid baseline, **When** setup reassesses, **Then** setup continues at the next incomplete area without re-running completed owner workflows.
4. **Given** an owner workflow declines, fails, returns malformed output, or leaves its baseline incomplete, **When** setup handles the result, **Then** setup stops, identifies the blocker, and makes no downstream owner call.
5. **Given** all baselines are complete, **When** setup is executed twice, **Then** both runs make zero owner calls and preserve every governance artifact hash.

### User Story 2 - Enforce one canonical status and output contract (Priority: P1)

As a Highway user, I want setup statuses and dashboard bytes to be unambiguous so that the same repository state produces the same actionable result across adapters.

**Why this priority**: Feature 033 currently contains a status conflict for missing NFRs and an indentation mismatch in the exact completion dashboard.

**Independent Test**: Apply the defined state transition table to missing, pending, declined, blocked, and complete NFR states, then compare emitted complete and in-progress output byte-for-byte with one canonical contract.

**Acceptance Scenarios**:

1. **Given** Controls are complete and no NFR proposal has started, **When** readiness is evaluated, **Then** NFRs are `Missing` and setup identifies the Control-owned proposal as the next action.
2. **Given** a Control-owned NFR proposal is pending author acceptance, **When** setup reports status, **Then** NFRs are `In Progress`, setup remains `In Progress`, and completion is withheld.
3. **Given** accepted valid NFR artifacts exist, **When** setup reports completion, **Then** the complete dashboard matches the canonical contract byte-for-byte, including indentation and blank lines.
4. **Given** an earlier prerequisite is incomplete, **When** setup reports status, **Then** all later areas are `Not Evaluated` and no later area is reported as `Complete`.

### User Story 3 - Measure first-time routing coverage (Priority: P1)

As a Highway maintainer, I want first-time setup routing accuracy to have a defined denominator and threshold so that the routing success claim can be independently verified.

**Why this priority**: Feature 033 declares a 95% routing outcome without defining which scenarios count or how the percentage is calculated.

**Independent Test**: Execute the complete named first-time scenario matrix and calculate successful next-owner routing divided by total applicable scenarios; the result must meet the declared threshold.

**Acceptance Scenarios**:

1. **Given** the named first-time scenario matrix, **When** all scenarios run, **Then** each scenario records its expected next owner and actual first owner call.
2. **Given** a scenario whose prerequisite is blocked or malformed, **When** setup runs, **Then** the expected result is a stop rather than a downstream owner call and it is scored accordingly.
3. **Given** the completed matrix, **When** routing coverage is calculated, **Then** the denominator, numerator, threshold, and result are recorded separately from the general suite result.

### User Story 4 - Complete ownership and completion evidence (Priority: P2)

As a governance owner, I want the ownership review and completion records to show what was tested and what remains manual so that Feature 034 cannot claim compliance from unchecked evidence.

**Why this priority**: Ownership delegation is a governance boundary; it requires explicit review in addition to automated checks.

**Independent Test**: Review the ownership checklist against the implementation, generated artifacts, and test evidence, then verify the completion record distinguishes test results, requirement coverage, and manual review status.

**Acceptance Scenarios**:

1. **Given** each foundational artifact path and owner route, **When** the ownership review is performed, **Then** the checklist records a pass or an actionable exception for each ownership boundary.
2. **Given** generated artifacts are refreshed from source, **When** completion is recorded, **Then** the record states that generated outputs were regenerated and not hand-authored.
3. **Given** automated checks, requirement coverage, and manual review have different evidence, **When** the feature is reported complete, **Then** each evidence type is reported as a separate claim.

### Edge Cases

- Controls are complete but no NFR proposal candidate exists; report NFR setup as `Missing` or `Blocked` according to the owner result and never fabricate an NFR.
- A pending NFR proposal transitions to declined; preserve `In Progress` history for the pending result and report the declined blocker without completion.
- The complete dashboard contains semantically correct content but different whitespace; treat it as nonconforming until the canonical bytes match.
- A test double reports success without changing the required baseline; treat the result as incomplete and stop.
- A test scenario cannot determine its expected owner from the matrix; fail the verification rather than counting it as a successful route.
- An ownership checklist item lacks evidence; leave it unresolved and prevent a full compliance claim.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Feature 034 verification MUST execute setup behavior against disposable repository states rather than only inspect source text.
- **FR-002**: The verification MUST record readiness evaluation order for Profile, Business Objectives, Controls, and NFRs.
- **FR-003**: The verification MUST record owner workflow calls and prove that successful delegation continues at the next incomplete area.
- **FR-004**: The verification MUST prove that declined, failed, malformed, and incomplete owner results stop setup before downstream delegation.
- **FR-005**: The verification MUST prove that repeated complete-state runs make zero owner mutations and preserve governance artifact bytes.
- **FR-006**: Feature 034 MUST define `NFRs: Missing` as the pre-proposal state and `NFRs: In Progress` as the pending-author-decision state.
- **FR-007**: Feature 034 MUST define one canonical complete dashboard and one canonical in-progress dashboard contract with byte-significant whitespace.
- **FR-008**: The verification MUST compare complete and in-progress output against the canonical contracts byte-for-byte.
- **FR-009**: Feature 034 MUST define the first-time routing scenario matrix, its denominator, its success rule, and its 95% minimum threshold.
- **FR-010**: The verification MUST report routing coverage separately from general test-suite results and requirement coverage.
- **FR-011**: The ownership review MUST record an outcome for every Profile, Objective, Control, and NFR ownership boundary.
- **FR-012**: Feature 034 MUST NOT claim full compliance while an ownership review item lacks evidence or an executable requirement remains unverified.

### Key Entities *(include if feature involves data)*

- **Behavior Fixture**: A disposable repository state, owner-workflow outcome sequence, expected evaluation order, expected calls, and observed output.
- **Canonical Output Contract**: The exact complete or in-progress dashboard bytes, including whitespace and blank lines.
- **Routing Scenario Matrix**: The finite set of first-time setup states, expected first owner route, and observed route result.
- **Ownership Review Record**: Evidence and outcome for each foundational artifact ownership boundary.
- **Compliance Result**: Separate automated checks, requirement coverage, routing coverage, and manual review outcomes.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of named readiness, delegation, continuation, failure, pending, complete, and idempotence scenarios execute through behavioral fixtures.
- **SC-002**: 100% of behavioral fixtures record the expected evaluation order and owner-call sequence.
- **SC-003**: 100% of failure and pending fixtures show no downstream owner call and no completion dashboard.
- **SC-004**: 100% of complete and in-progress dashboard fixtures match the canonical contracts byte-for-byte.
- **SC-005**: 100% of first-time routing scenarios have a declared expected owner, observed owner, and scored result.
- **SC-006**: First-time routing coverage is at least 95%, calculated as successful applicable routes divided by the declared scenario count.
- **SC-007**: 100% of repeated complete-state fixtures show zero owner mutations and unchanged governance artifact hashes.
- **SC-008**: 100% of ownership checklist items have a recorded pass or explicitly documented exception before compliance is claimed.
- **SC-009**: Completion reporting contains separate results for executable checks, requirement coverage, routing coverage, and manual ownership review.

## Assumptions

- Feature 034 strengthens the verification and contract records for Feature 033; it does not expand `highway-setup` ownership or add a second governance artifact store.
- The existing owner skills remain authoritative for Profile, Business Objectives, Controls, and NFRs.
- The routing scenario matrix is finite, versioned with the feature, and includes every first-time readiness state and owner-result class named by Feature 033.
- Byte-for-byte comparison treats line endings, indentation, blank lines, and route text as contract data.
- A routing success is counted only when the observed first owner call equals the expected owner for that scenario and the scenario’s expected stop/continue outcome also matches.
- Manual ownership review remains distinct from automated fixture execution.
- Generated catalog, adapter, and distribution artifacts remain derived outputs and are regenerated through the repository’s existing workflow.
