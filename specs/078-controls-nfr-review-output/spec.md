# Feature Specification: Controls and NFR Review Output Contracts

**Feature Branch**: `078-controls-nfr-review-output`

**Created**: 2026-09-23

**Status**: Draft

**Input**: User description: "Make the Control and NFR onboarding skills explicitly declare their review output structures, proposal-state boundaries, existing-baseline routing, deterministic candidate ordering, readiness-state ownership, and duplicate-failure preservation."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Explicit Control Review Output (Priority: P1)

As a repository maintainer reviewing proposed Controls, I want the Control skill to declare exactly what each review entry contains and which decisions are available so that I can evaluate every proposal consistently.

**Why this priority**: Control Review is the write-authorizing boundary for onboarding. An explicit output contract prevents the review experience from being underspecified while preserving the existing workflow.

**Independent Test**: Inspect the canonical Control skill and its focused contract test, then exercise a review with proposals and an empty proposal set. Verify that every entry has the four required fields and that an empty review is explicit.

**Acceptance Scenarios**:

1. **Given** one or more proposed Controls exist, **When** Control Review emits its output, **Then** each entry contains Category, Proposed Title, Statement, and Available Decisions: Accept, Modify, Replace, Remove.
2. **Given** no proposed Controls exist, **When** Control Review emits its output, **Then** it emits an explicit empty-review result rather than an omitted or ambiguous response.
3. **Given** a generated Proposed Title exists before review completion, **When** the proposal is displayed, **Then** the title is identified as proposal-state content and no proposal content, title, identifier, or onboarding state is persisted before successful Review Complete.
4. **Given** a valid Control baseline already exists, **When** setup or configure is invoked, **Then** the output reports the existing baseline, displays no onboarding collection prompts, creates no onboarding proposal state, and routes to existing add, update, remove, or view actions.

### User Story 2 - Explicit NFR Review and Readiness Output (Priority: P1)

As a repository maintainer reviewing Control-derived NFR candidates, I want the NFR skill to declare the complete candidate display and decision structure so that accepted, rejected, cancelled, and failed reviews have predictable outcomes.

**Why this priority**: NFR Review is the second ownership boundary in onboarding. Its output must make candidate provenance, decision choices, duplicate failures, and readiness updates auditable.

**Independent Test**: Inspect the canonical NFR skill and focused tests, then exercise a review with candidates and without candidates. Verify the complete entry shape, explicit empty-review behavior, and the stated readiness and duplicate-failure rules.

**Acceptance Scenarios**:

1. **Given** one or more NFR candidates exist, **When** NFR Review emits its output, **Then** each entry contains Candidate Title, Candidate Statement, Candidate Rationale, Originating Control Identifier, Originating Control Title, and Available Decisions: Accept, Modify, Replace, Reject.
2. **Given** no NFR candidates exist, **When** NFR Review emits its output, **Then** it emits an explicit empty-review result.
3. **Given** candidates are being reviewed, **When** the review advances or is re-rendered, **Then** candidate ordering remains unchanged and identical inputs produce identical ordering.
4. **Given** Review Complete succeeds, **When** NFR readiness is later evaluated, **Then** the successful outcome is reflected by readiness.
5. **Given** review cancellation, rejection, validation failure, allocation failure, duplicate detection failure, or write failure occurs, **When** readiness is later evaluated, **Then** readiness-consumed accepted artifact state is unchanged.
6. **Given** an existing NFR duplicates an accepted candidate, **When** duplicate detection runs, **Then** it runs before NFR creation and identifier allocation, preserves candidate, NFR, catalog, and relationship state, and performs no partial NFR write.

### User Story 3 - Consistent Deterministic Review Presentation (Priority: P2)

As a governance maintainer, I want Control and NFR review output contracts to be located with their owning output and review sections so that the two skills remain readable, deterministic, and aligned with the Experience Standard.

**Why this priority**: Clear placement reduces ambiguity for maintainers and makes generated or static contract validation less fragile without changing ownership or persistence behavior.

**Independent Test**: Compare the canonical Control and NFR skill sections against the declared output contracts and run the focused routing, onboarding, readiness, and candidate-review tests. Verify that review fields and ordering rules are stated once in the appropriate owner section.

**Acceptance Scenarios**:

1. **Given** the Control skill documents Control Review, **When** a maintainer reads Outputs and the review contract, **Then** the emitted fields, empty-review behavior, and available decisions are discoverable without inferring them from a separate paragraph.
2. **Given** the NFR skill documents candidate review, **When** a maintainer reads Outputs and the review contract, **Then** the emitted fields, empty-review shape, provenance, and available decisions are discoverable without inferring them from a separate paragraph.
3. **Given** identical candidate inputs are reviewed repeatedly, **When** the output is compared, **Then** candidate ordering and field ordering are deterministic and contain no timestamp, randomness, environment value, or session state.

### Edge Cases

- Control Review receives an empty proposal set after collection or after all proposals are removed.
- NFR Review receives an empty candidate set because no derivation rule matched.
- A valid existing Control baseline is present when setup or configure is invoked.
- A generated title exists in proposal state but review is cancelled or fails before persistence.
- Candidate inputs are identical across repeated review renders.
- Duplicate detection fails before allocation, or a later write fails after validation.
- Accepted artifacts exist from an earlier successful review while a later review is cancelled or rejected.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The canonical Control skill Outputs section MUST declare that Control Review emits one entry per proposed Control.
- **FR-002**: Each Control Review entry MUST contain Category, Proposed Title, Statement, and Available Decisions: Accept, Modify, Replace, Remove.
- **FR-003**: When no proposed Controls exist, Control Review MUST emit:
	- `Status: Empty`
	- `Entry Count: 0`
- **FR-004**: The Control onboarding contract MUST state that generated Proposed Titles exist only in proposal state until successful Review Complete.
- **FR-005**: Before successful Review Complete, Control onboarding MUST persist no proposal content, generated title, identifier allocation, or onboarding state.
- **FR-006**: Control Outputs MUST state that a valid existing baseline causes setup or configure to report the baseline, display no collection prompts, create no proposal state, and route to existing add, update, remove, or view actions.
- **FR-007**: The NFR candidate review contract MUST declare that Candidate Review emits Candidate Title, Candidate Statement, Candidate Rationale, Originating Control Identifier, and Originating Control Title.
- **FR-009**: The canonical NFR skill Outputs section MUST declare that NFR Review emits one entry per candidate.
- **FR-010**: Each NFR Review entry MUST contain Candidate Title, Candidate Statement, Candidate Rationale, Originating Control Identifier, Originating Control Title, and Available Decisions: Accept, Modify, Replace, Reject.
- **FR-011**: When no NFR candidates exist, NFR Review MUST emit:
	- `Status: Empty`
	- `Entry Count: 0`
- **FR-012**: NFR candidate ordering MUST remain unchanged throughout the review workflow.
- **FR-013**: Identical candidate inputs MUST produce identical review ordering.
- **FR-014**: Successful NFR Review Complete outcomes MUST be reflected by subsequent readiness evaluation.
- **FR-015**: Cancelled reviews, rejected candidates, failed validation, failed allocation, duplicate detection failures, and failed writes MUST NOT change readiness-consumed accepted artifact state.
- **FR-016**: Existing NFR duplication MUST be detected before NFR creation and before identifier allocation.
- **FR-017**: Duplicate detection failure MUST preserve candidate state, existing NFR artifacts, catalog state, and relationship state.
- **FR-018**: Duplicate detection failure MUST perform no partial NFR write.
- **FR-019**: Control and NFR review output contracts MUST remain owned by their respective canonical skills and remain synchronized with the existing workflow contracts.
- **FR-020**: Review output and ordering MUST not depend on timestamps, randomness, environment values, filesystem ordering, or user-session state.
- **FR-021**: Focused tests MUST verify populated and empty Control Review output, populated and empty NFR Review output, proposal-state non-persistence, existing-baseline routing, ordering stability, readiness ownership, and duplicate-failure preservation.

### Key Entities *(include if feature involves data)*

- **Proposal State**: Temporary onboarding content held before successful Control Review Complete, including generated titles and submitted statements.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of populated Control Review fixtures expose all four required fields and all four available decisions for every proposal.
- **SC-002**: 100% of empty Control Review fixtures emit `Status: Empty` and `Entry Count: 0`.
- **SC-003**: 100% of populated NFR Review fixtures expose all six required fields and all four available decisions for every candidate.
- **SC-004**: 100% of empty NFR Review fixtures emit `Status: Empty` and `Entry Count: 0`.
- **SC-005**: 100% of pre-completion Control onboarding fixtures preserve proposal, identifier, and onboarding-state bytes unchanged.
- **SC-006**: 100% of valid existing-baseline fixtures suppress collection prompts and proposal state and route to existing actions.
- **SC-007**: 100% of repeated identical candidate-input fixtures produce identical review ordering.
- **SC-008**: 100% of successful NFR Review Complete fixtures are reflected by subsequent readiness evaluation.
- **SC-009**: 100% of cancellation, rejection, validation, allocation, duplicate, and write-failure fixtures leave readiness-consumed accepted artifact state unchanged.
- **SC-010**: 100% of duplicate-detection failure fixtures preserve candidate, NFR, catalog, and relationship bytes and create no partial NFR write.
- **SC-011**: Focused Feature 078 tests pass with zero failures, and the full repository suite reports no Feature 078-specific failure.
- **SC-012**: 100% of Control Review and NFR Review fixtures expose every declared review field, decision option, empty-review behavior, write boundary, and readiness ownership rule from the canonical skill contracts.

## Assumptions

- Feature 077 remains the authoritative behavioral baseline for onboarding state transitions, transaction boundaries, identifiers, and relationships.
- This feature changes explicit contract visibility and focused evidence; it does not introduce a new runtime command or change ownership between Controls, NFRs, readiness, or setup.
- Feature 078 clarifies existing review contracts and review-output obligations.
- Feature 078 does not introduce new persistence models, workflow stages, identifier schemes, readiness states, governance artifacts, or ownership boundaries.
- Existing Control and NFR templates, catalogs, and validation rules remain authoritative.
- `Review Complete` remains the only successful persistence boundary for Control and NFR onboarding.
- The existing four-field readiness output shape remains authoritative; this feature clarifies which successful or failed review outcomes are reflected by subsequent readiness evaluation.
- Empty-review results are presentation outcomes and do not create placeholder governance artifacts.
- User-owned governance records remain outside `.highway` at the established root-level governance paths.
- No new dependency, timestamp, randomness, environment value, or session state is required.
