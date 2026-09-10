# Feature Specification: Profile Setup Readiness and Zero-NFR Completion

**Feature Branch**: `035-profile-setup-readiness`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "Resolve Profile ownership, workflow numbering, and zero-NFR candidate gaps across the Highway governance workflow."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Establish Profile-owned organization readiness (Priority: P1)

As a Highway maintainer, I want the Profile skill to own organization identity and Profile completeness so that every downstream workflow consumes one authoritative readiness definition.

**Why this priority**: Profile context is the first prerequisite in the governance sequence. Ambiguous ownership currently allows Setup and Profile to disagree about whether a repository is ready.

**Independent Test**: Run Profile setup and verification against absent, empty, supplied, declined, and malformed organization identity states; verify only the Profile owner determines completion.

**Acceptance Scenarios**:

1. **Given** a Profile is absent or `organization.name` is empty, **When** Profile setup/configure runs, **Then** it asks for a user-supplied organization identity and does not report Profile Complete.
2. **Given** a user supplies a non-empty organization identity, **When** Profile setup/configure completes, **Then** the Profile owner reports a valid Complete Profile state.
3. **Given** the user declines or omits organization identity, **When** Profile setup/configure handles the response, **Then** it aborts completion, identifies `organization.name`, and performs no write.
4. **Given** a malformed Profile, **When** Profile readiness is evaluated, **Then** the Profile owner reports the malformed field or section and preserves the existing bytes.
5. **Given** identical supplied answers, **When** Profile setup/configure is repeated, **Then** it produces identical Profile content without inferred organization values.

### User Story 2 - Consume Profile readiness and enforce numbered Setup workflow (Priority: P1)

As a Highway maintainer, I want Setup to consume Profile-owned readiness and use a numbered workflow so that orchestration references are valid, traceable, and free of duplicated Profile rules.

**Why this priority**: Setup currently embeds Profile field validation and references numbered steps from an unnumbered workflow, creating both ownership drift and constitution non-compliance.

**Independent Test**: Inspect the Setup workflow and run its structural checks against all numbered steps and references; verify Setup delegates Profile validity to the Profile owner rather than defining `organization.name` semantics.

**Acceptance Scenarios**:

1. **Given** the Profile owner reports Complete or incomplete, **When** Setup evaluates readiness, **Then** Setup consumes that result without independently defining Profile field requirements.
2. **Given** the Setup workflow is loaded, **When** workflow integrity is checked, **Then** every step is sequentially numbered, unique, and referenced step numbers resolve to existing steps.
3. **Given** a Profile is incomplete, **When** Setup runs, **Then** it invokes the Profile owner workflow and does not duplicate Profile completeness rules as Setup-owned requirements.
4. **Given** every prerequisite is complete, **When** Setup emits completion, **Then** its numbered workflow reaches the dashboard step without an invalid reference.

### User Story 3 - Complete valid repositories with zero NFR candidates (Priority: P1)

As a Highway user, I want a valid repository with Controls that generate zero NFR candidates to reach a stable terminal state so that Setup never requires artificial governance artifacts.

**Why this priority**: A valid Control baseline can legitimately produce no NFR candidates. Treating that state as permanently incomplete creates an impossible onboarding path.

**Independent Test**: Run Setup against complete Profile, Objective, and Control fixtures with zero candidates, pending candidates, accepted NFRs, and malformed candidate results; verify deterministic terminal or blocking states.

**Acceptance Scenarios**:

1. **Given** Profile, Objectives, and Controls are complete, no accepted NFRs exist, and zero NFR candidates are generated, **When** Setup runs, **Then** it reports `NFRs: Not Applicable`, emits a terminal completion dashboard, and creates no NFR artifact.
2. **Given** Profile, Objectives, and Controls are complete and one or more NFR candidates are generated without accepted NFRs, **When** Setup runs, **Then** it reports NFR setup as `Missing` or `In Progress` according to the proposal state and withholds completion.
3. **Given** accepted generated NFRs exist, **When** Setup runs, **Then** it reports NFRs Complete and emits the normal completion dashboard.
4. **Given** candidate generation is malformed or contradictory, **When** Setup runs, **Then** it reports NFRs Blocked and does not fabricate an NFR or claim completion.
5. **Given** identical repository state and candidate results, **When** Setup runs repeatedly, **Then** it selects the same terminal or blocking state every time.

### Edge Cases

- `organization.name` contains only whitespace; treat it as empty and request a user-supplied value.
- A user supplies an organization name but declines the final Profile confirmation; preserve the original Profile bytes.
- A Profile contains an organization mapping but no `name` key; Profile remains incomplete and identifies the missing field.
- Setup receives a Profile owner response that claims success while Profile readiness remains incomplete; Setup stops without downstream evaluation.
- The Setup workflow references a missing, duplicate, or non-sequential step number; structural verification fails.
- Controls are valid, no NFR candidates are generated, and an old empty NFR directory exists; report `Not Applicable` without creating a placeholder NFR.
- Zero candidates later become non-zero after a Control change; the next Setup run deterministically re-enters NFR proposal handling.
- Candidate generation is unavailable or returns malformed output; report Blocked rather than treating the state as zero candidates.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Profile owner MUST define `organization.name` as a required, user-supplied Profile completion field.
- **FR-002**: Profile setup/configure MUST ask an explicit organization identity question before proposing completion.
- **FR-003**: Profile setup/configure MUST reject absent, empty, or whitespace-only `organization.name` values.
- **FR-004**: Profile setup/configure MUST preserve existing Profile bytes when organization identity is declined, absent, or malformed.
- **FR-005**: Profile verification MUST prove that an empty `organization.name` cannot produce a Complete Profile result.
- **FR-006**: Setup MUST consume Profile-owner readiness and MUST NOT define an independent Profile field-completeness rule.
- **FR-007**: Setup MUST use sequentially numbered, unique workflow steps.
- **FR-008**: Every Setup workflow step reference MUST resolve to an existing numbered step.
- **FR-009**: Setup verification MUST detect missing, duplicate, or non-sequential workflow step numbers.
- **FR-010**: Setup MUST classify complete Profile, Objective, and Control baselines with zero generated NFR candidates as `NFRs: Not Applicable`.
- **FR-011**: `NFRs: Not Applicable` MUST be a deterministic terminal readiness state that emits completion guidance without creating an NFR artifact.
- **FR-012**: Setup MUST distinguish zero candidates from unavailable, malformed, pending, or accepted candidate results.
- **FR-013**: Setup verification MUST cover missing organization identity, valid organization identity, zero candidates, and accepted generated NFRs.
- **FR-014**: Setup MUST preserve deterministic outcomes for identical repository state and candidate-generation results.

### Key Entities *(include if feature involves data)*

- **Profile Readiness**: The Profile owner's Complete, Missing, Blocked, or Not Evaluated result, including the organization identity evidence.
- **Organization Identity**: The user-supplied non-empty value stored at `organization.name`.
- **Numbered Workflow Step**: A unique sequential Setup step and its references to later steps.
- **NFR Candidate Result**: The owner-provided result distinguishing zero candidates, available candidates, pending proposal, accepted artifacts, and malformed or unavailable generation.
- **Terminal Setup State**: A deterministic completion or blocking state, including `NFRs: Not Applicable`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of Profile readiness fixtures agree with the Profile owner's organization identity rule.
- **SC-002**: 100% of Profile setup/configure attempts with absent, empty, or whitespace-only organization identity avoid Complete status and direct writes.
- **SC-003**: 100% of Setup workflow references resolve to one unique sequentially numbered step.
- **SC-004**: 100% of zero-candidate fixtures reach the same `NFRs: Not Applicable` terminal state without creating NFR artifacts.
- **SC-005**: 100% of unavailable, malformed, pending, and accepted candidate fixtures produce their defined non-zero-candidate outcomes without false completion.
- **SC-006**: 100% of required readiness paths are covered by executable tests for missing organization identity, valid organization identity, zero candidates, and accepted generated NFRs.
- **SC-007**: 100% of repeated identical inputs produce the same Profile readiness, workflow route, NFR state, and completion result.

## Assumptions

- `highway-profile` remains the sole owner of Profile content, organization identity collection, Profile completeness, and Profile mutation confirmation.
- `highway-setup` remains an orchestration and dashboard skill and does not author Profile, Objective, Control, or NFR artifacts.
- `highway-controls` remains authoritative for determining whether Control-derived NFR candidates exist and for owning the proposal path.
- `NFRs: Not Applicable` is the selected terminal state for a valid completed prerequisite chain with zero generated candidates.
- A zero-candidate result is distinct from candidate-generation failure or malformed output and must be explicitly reported by the owner workflow.
- Existing generated catalogs, adapters, and manifests remain derived artifacts and are regenerated after source skill changes.
- Relationships, Help, and Questionnaire remain administration routes rather than prerequisites for Setup completion.
