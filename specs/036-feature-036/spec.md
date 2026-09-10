# Feature Specification: Strengthen Feature 035 Behavioral Evidence

**Feature Branch**: `036-strengthen-035-evidence`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "Address Feature 035 assessment findings by adding executable Profile behavior coverage, real negative workflow fixtures, candidate-result-driven Setup tests, correcting the distribution-generator invocation documentation, and updating the implementation plan structure."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Prove Profile behavior with executable fixtures (Priority: P1)

As a Highway maintainer, I want Profile readiness tests to execute real fixture states so that passing contract text checks cannot mask incorrect organization identity, completion, or no-write behavior.

**Why this priority**: Profile readiness is the first prerequisite in Setup, and weak evidence here can incorrectly allow every downstream workflow to proceed.

**Independent Test**: Run Profile behavior fixtures against absent, empty, whitespace-only, valid, declined, malformed, and repeated-input states and compare status, bytes, and generated content to explicit expected results.

**Acceptance Scenarios**:

1. **Given** no Profile or an empty or whitespace-only `organization.name`, **When** Profile readiness is evaluated, **Then** the result is not Complete and no artifact is written.
2. **Given** a valid supplied organization name, **When** Profile setup is confirmed, **Then** the resulting Profile is Complete and contains the supplied value without inference.
3. **Given** a declined proposal or malformed Profile, **When** readiness is evaluated, **Then** the result identifies the blocking condition and preserves the original bytes.
4. **Given** identical valid inputs, **When** Profile setup is evaluated twice, **Then** status and resulting bytes are identical.

---

### User Story 2 - Prove Setup rejects invalid workflow variants (Priority: P1)

As a Highway maintainer, I want Setup workflow tests to run against copied malformed variants so that missing, duplicate, non-sequential, and dangling step references are demonstrably rejected.

**Why this priority**: Numbering and reference integrity is a constitution requirement and a broken route can silently misdirect onboarding.

**Independent Test**: Generate temporary workflow variants from the current Setup workflow, introduce one numbering or reference defect at a time, and verify each variant fails structural validation while the unmodified workflow passes.

**Acceptance Scenarios**:

1. **Given** the canonical workflow, **When** structural validation runs, **Then** steps 1 through 10 are unique and contiguous and every `Step N` reference resolves.
2. **Given** a missing, duplicate, non-sequential, or dangling step variant, **When** structural validation runs, **Then** it fails and identifies the invalid step or reference.

---

### User Story 3 - Drive NFR outcomes from candidate results (Priority: P1)

As a Highway maintainer, I want Setup tests to consume candidate-result inputs rather than assign expected states directly so that zero, pending, accepted, unavailable, and malformed outcomes prove the actual routing decision.

**Why this priority**: The zero-candidate branch is the feature's terminal behavior, and false confidence here can create either artificial NFR artifacts or permanent onboarding loops.

**Independent Test**: Feed candidate-result fixtures into the Setup decision path and verify status, terminal/in-progress/blocking route, artifact behavior, and repeatability for every defined outcome.

**Acceptance Scenarios**:

1. **Given** complete prerequisites and a successful candidate result with count zero, **When** Setup evaluates NFR readiness, **Then** it reports `NFRs: Not Applicable`, completes, and creates no NFR artifact.
2. **Given** available candidates without acceptance, **When** Setup evaluates readiness, **Then** it remains Missing or In Progress according to proposal state.
3. **Given** accepted artifacts, **When** Setup evaluates readiness, **Then** it reports Complete.
4. **Given** unavailable or malformed candidate results, **When** Setup evaluates readiness, **Then** it reports Blocked and does not fabricate completion or an artifact.
5. **Given** identical candidate-result inputs, **When** Setup evaluates readiness repeatedly, **Then** it returns the same state and route.

---

### Edge Cases

- A Profile fixture contains a valid-looking mapping but no `name` key; readiness remains incomplete and identifies the missing field.
- A malformed workflow variant has both a duplicate and a dangling reference; validation reports failure without mutating the canonical workflow.
- A candidate result declares count zero but contains candidate entries; the result is malformed, not Not Applicable.
- A candidate result is unavailable while an old empty NFR directory exists; Setup remains Blocked and creates no placeholder artifact.
- The distribution generator is invoked without a target directory; documentation must show the required target argument and a disposable target pattern.
- The implementation plan is reviewed after new files are added; its structure must include all changed source and fixture paths.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Profile behavior verification MUST execute fixture states for absent, empty, whitespace-only, valid, declined, malformed, and repeated organization identity inputs.
- **FR-002**: Profile behavior verification MUST assert readiness status, write/no-write behavior, and byte preservation rather than only searching for contract text.
- **FR-003**: Profile behavior verification MUST assert that identical valid inputs produce identical resulting Profile content.
- **FR-004**: Workflow verification MUST validate the canonical Setup workflow and temporary variants independently.
- **FR-005**: Workflow verification MUST fail for missing, duplicate, non-sequential, and dangling step definitions or references.
- **FR-006**: Workflow verification MUST preserve the canonical workflow bytes while testing malformed variants.
- **FR-007**: NFR verification MUST consume candidate-result inputs through a decision function or owner-compatible interface rather than assigning expected statuses directly from fixture labels.
- **FR-008**: NFR verification MUST cover zero, available-pending, accepted, unavailable, malformed, and contradictory candidate results.
- **FR-009**: Zero candidates MUST produce `NFRs: Not Applicable`, terminal Setup completion, and no NFR artifact.
- **FR-010**: Unavailable or malformed candidate results MUST produce `NFRs: Blocked` without fabricated artifacts or completion.
- **FR-011**: Repeated identical candidate-result inputs MUST produce identical statuses, routes, and artifact behavior.
- **FR-012**: The implementation documentation MUST show the required target-directory argument when invoking the distribution generator and use a disposable target for verification.
- **FR-013**: The Feature 035 implementation plan MUST list the shared helper and Feature 035 fixture paths that were added during implementation.
- **FR-014**: Feature 036 verification MUST distinguish passing executable behavior evidence from static contract-text checks and report any remaining gaps explicitly.

### Key Entities

- **Profile Fixture State**: A controlled Profile input and its expected readiness, write, and byte-preservation outcome.
- **Workflow Variant**: A temporary copy of the Setup workflow with one structural defect introduced for negative testing.
- **Candidate Result**: The input consumed by NFR routing, including generation success, candidate count, proposal state, accepted artifacts, and malformed or unavailable conditions.
- **Evidence Record**: A test result identifying the behavior exercised, observed result, and whether the canonical artifact was preserved.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the seven required Profile fixture categories produce an observed status and write/byte result from executable behavior checks.
- **SC-002**: 100% of the four malformed workflow variant categories fail validation, while the canonical workflow passes unchanged.
- **SC-003**: 100% of the six candidate-result categories produce the defined NFR and Setup outcome from candidate-result-driven checks.
- **SC-004**: Zero-candidate verification creates zero NFR artifacts across at least three repeated identical runs.
- **SC-005**: Repeated identical Profile and candidate inputs produce identical status, route, and output bytes across at least three runs.
- **SC-006**: The implementation plan and quickstart contain an executable distribution-generator command with a target directory and list every Feature 035 source, test, and fixture path changed by remediation.
- **SC-007**: The final report separates executable behavioral evidence, static contract validation, generated-artifact checks, and remaining limitations.

## Assumptions

- Feature 036 remediates evidence and documentation gaps in Feature 035; it does not change the intended Profile ownership or zero-candidate semantics.
- The canonical Profile and Setup skill artifacts remain the source of truth; temporary copies are used only for negative structural tests.
- Existing Bash-compatible test conventions and repository generators remain available.
- The distribution generator requires a target directory; tests may use a disposable temporary directory and must not alter the checked-in distribution manifest unless source regeneration requires it.
- The Feature 035 implementation plan and quickstart are development records and may be updated to reflect the actual changed paths and commands.
