# Feature Specification: Highway Organizational Profile

**Feature Branch**: `024-highway-profile`

**Created**: 2026-09-09

**Status**: Draft

**Input**: User description: "/speckit.specify Create a Highway skill named /highway-profile that manages a repository-wide organizational profile at .highway/profile.yaml. The profile follows the ownership and governance model of .highway/library/templates/requirements-inquiry.md."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Discover and Inspect Profile Context (Priority: P1)

As a downstream agent or repository user, I want to read the profile skill's help and current profile without changing files, so I can understand the available context before making decisions.

**Why this priority**: Read-only discovery is the safest and most frequent entry point, and it establishes the distinction between organizational context and governance baselines.

**Independent Test**: Invoke `/highway-profile`, then invoke any of `/highway-profile view`, `/highway-profile show`, or `/highway-profile describe` against an absent, default, and populated profile, and confirm that no file changes occur.

**Acceptance Scenarios**:

1. **Given** no action parameter, **When** the user invokes `/highway-profile`, **Then** the skill displays its purpose, supported actions, usage examples, setup guidance, and current profile status without changing `.highway/profile.yaml`.
2. **Given** an existing profile, **When** the user invokes `view`, `show`, or `describe`, **Then** each command displays the current profile contents and makes no file changes.
3. **Given** the profile is absent, **When** the user invokes a read-only view command, **Then** the skill identifies the absence and offers setup rather than guessing or writing a profile.

### User Story 2 - Configure an Initial Profile (Priority: P1)

As a repository owner, I want an interactive setup questionnaire to collect organizational context and preview a proposed profile, so I can establish useful context without an unreviewed write.

**Why this priority**: Initial setup is the primary path for creating the profile and must protect user ownership through explicit confirmation.

**Independent Test**: Run `/highway-profile setup` and `/highway-profile configure` in a controlled workspace, answer the questionnaire, inspect the proposed YAML, decline once, and confirm the file is unchanged; then repeat and confirm the file is written only after approval.

**Acceptance Scenarios**:

1. **Given** no profile exists, **When** the user invokes `setup` or `configure`, **Then** the questionnaire collects organization, deployment, cloud, compliance, residency, platform, database, infrastructure-as-code, CI/CD, container, and technology-restriction context.
2. **Given** questionnaire answers, **When** setup prepares a proposal, **Then** it displays the resulting profile before asking for confirmation and emits only the required metadata plus non-empty user-supplied sections.
3. **Given** the user declines setup confirmation, **When** setup ends, **Then** `.highway/profile.yaml` is not created or modified.
4. **Given** the user confirms setup, **When** the write completes, **Then** `.highway/profile.yaml` exists with metadata first, `metadata.version`, `metadata.description`, and no generated timestamp or random identifier.

### User Story 3 - Make Confirmed Profile Changes (Priority: P1)

As a repository owner, I want to add, update, remove, and reset profile values with an explicit preview and confirmation, so downstream guidance reflects organizational realities without silent changes.

**Why this priority**: Profile maintenance is the core ongoing value, and confirmation protects user-owned context from accidental or ambiguous mutation.

**Independent Test**: Against a populated profile, exercise representative `add`, `update`, `remove`, and `reset` requests, verify the inferred action/current state/proposed state/ramifications preview, decline each operation once, and confirm each accepted operation updates only the intended node.

**Acceptance Scenarios**:

1. **Given** a resolvable category and value, **When** the user requests `add`, **Then** the skill shows the inferred category and insertion location, requests confirmation, and adds the value only after approval.
2. **Given** an existing value, **When** the user requests `update`, **Then** the skill shows the action, current state, proposed state, downstream impact, and confirmation prompt before replacing the value.
3. **Given** an existing value, **When** the user requests `remove`, **Then** the skill identifies the exact item and ramifications, requests confirmation, and removes it only after approval.
4. **Given** a selected profile node, **When** the user requests `reset`, **Then** the skill lists every value that would be removed, explains ramifications, and waits for confirmation before clearing that node.
5. **Given** confirmation is withheld, **When** any mutation ends, **Then** the profile remains byte-for-byte unchanged.

### User Story 4 - Preserve Profile Structure and Distribution Semantics (Priority: P2)

As a Highway maintainer, I want the profile artifact and skill to preserve structure, determinism, and distribution boundaries, so downstream consumers can rely on stable context without treating it as governance.

**Why this priority**: Stable structure and correct ownership prevent profile data from being confused with the NFR or Control baselines and support future schema growth.

**Independent Test**: Validate the distributed default profile and skill, rewrite an unchanged populated profile, and compare outputs and metadata ordering while confirming no empty sections or timestamps are introduced.

**Acceptance Scenarios**:

1. **Given** a fresh Highway distribution, **When** the shipped profile is inspected, **Then** `.highway/profile.yaml` contains only the required metadata with version `1.0.0` and the specified contextual description.
2. **Given** an unchanged profile, **When** the skill rewrites it, **Then** the output is byte-for-byte identical, with `metadata` first and empty sections omitted.
3. **Given** profile values, **When** downstream guidance consumes them, **Then** the profile is treated as contextual input and never as a governance rule, NFR baseline, or Control baseline.
4. **Given** future schema sections are added, **When** existing profile structures are read or updated, **Then** the current metadata/constraints/strategic_directions/preferences organization remains compatible.

### Edge Cases

- `setup` and `configure` are equivalent; `view`, `show`, and `describe` are equivalent.
- A missing profile is handled by offering setup; read-only actions do not create it.
- A malformed profile aborts with the malformed section identified and does not overwrite the file.
- An action or category that cannot be uniquely resolved aborts and displays the possible interpretations or candidates.
- `add`, `update`, `remove`, and `reset` never write before confirmation; a declined prompt leaves the file unchanged.
- Empty profile sections are omitted, while the required metadata block remains.
- User wording, capitalization, value order, and existing grouping are preserved unless the user explicitly requests a change.
- Identical inputs produce identical output with no timestamps, random identifiers, or environment-derived values.
- Requests to change NFR or Control baselines are routed to `/highway-nfrs` or `/highway-controls` rather than being recorded in the profile.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The distribution MUST include a Highway skill named `highway-profile` and the retained profile artifact at `.highway/profile.yaml`, following the distributed artifact model of `.highway/library/templates/requirements-inquiry.md`.
- **FR-002**: The profile's structure MUST be governed by `.highway/governance/constitution.md` and the Highway library validation model, while its values MUST remain user-owned contextual guidance and MUST NOT be treated as the Control baseline, NFR baseline, or governance constitution.
- **FR-003**: The no-parameter help response MUST display the profile purpose, supported actions, usage examples, setup guidance, and current profile status without changing any file.
- **FR-004**: `setup` and `configure` MUST launch equivalent interactive questionnaires covering all fourteen requested organizational and technology-context questions.
- **FR-005**: Setup MUST display a proposed profile and MUST require confirmation before creating or modifying `.highway/profile.yaml`.
- **FR-006**: `view`, `show`, and `describe` MUST be equivalent read-only actions that display current profile contents without changing files.
- **FR-007**: `add` MUST resolve the intended category, preview the insertion location and inferred change, and apply it only after confirmation.
- **FR-008**: `update` MUST display the inferred action, current value, replacement value, downstream impact, and confirmation prompt before applying a replacement.
- **FR-009**: `remove` MUST identify the exact value and ramifications and apply the deletion only after confirmation.
- **FR-010**: `reset` MUST list every value under the selected profile node, explain ramifications, and clear the node only after confirmation.
- **FR-011**: Every mutation response MUST report `Action`, `File`, `Summary`, `Affected Entries`, and `Confirmation Status`.
- **FR-012**: The profile MUST preserve the ordered top-level structure `metadata`, `constraints`, `strategic_directions`, `preferences`, omit empty sections, and require only `metadata.version` and `metadata.description`.
- **FR-013**: The distributed default profile MUST contain version `1.0.0`, the specified contextual description, and no additional seeded content.
- **FR-014**: Profile management MUST preserve user wording, capitalization, grouping, and value order unless the user explicitly requests a change, and MUST prefer append operations.
- **FR-015**: Profile output MUST be deterministic for identical inputs and MUST NOT generate timestamps, random identifiers, or environment-specific values.
- **FR-016**: Missing, malformed, ambiguous, or unresolvable profile/action/category inputs MUST abort safely with an actionable explanation and MUST NOT overwrite user content.
- **FR-017**: The skill MUST support future sections including `business_context`, `architecture_principles`, `approved_technologies`, `prohibited_technologies`, `operating_model`, and `vendor_strategy` without redesigning existing structures.
- **FR-018**: Requests that are specifically about NFR or Control baselines MUST be routed to `/highway-nfrs` or `/highway-controls` and MUST NOT be written to the profile.
- **FR-019**: The source skill, distributed profile artifact, generated catalog, adapters, and distribution manifests MUST remain correspondingly validated after the feature is added, while user-provided profile values remain outside semantic governance validation.

### Key Entities

- **Organizational profile**: Distributed YAML context at `.highway/profile.yaml`, structurally governed like `.highway/library/templates/requirements-inquiry.md` while its metadata and optional constraint, strategic-direction, and preference values remain user-owned.
- **Profile node**: A resolvable category and nested location within the profile, such as `preferences.cloud.preferred`.
- **Questionnaire response**: User-provided answers used to construct a proposed profile without adding unprovided facts.
- **Mutation preview**: The inferred action, current/proposed state, affected entries, ramifications, and confirmation status shown before a write.
- **Downstream consumer**: Research, ADR, architecture, capability, NFR, Control, reference implementation, or self-service generation that may use the profile as contextual guidance.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of supported help, view, and setup-readiness interactions complete without modifying `.highway/profile.yaml` before an explicit confirmation.
- **SC-002**: 100% of accepted setup and mutation operations produce a confirmation preview containing the required action, state, impact, and status information before writing.
- **SC-003**: 100% of declined setup, add, update, remove, and reset operations leave the profile byte-for-byte unchanged.
- **SC-004**: 100% of valid profiles preserve metadata-first ordering, required metadata fields, omitted empty sections, and user-provided wording and value ordering.
- **SC-005**: Rewriting an unchanged profile produces byte-for-byte identical output in repeated runs, with zero timestamps, random identifiers, or environment-derived values.
- **SC-006**: The distributed default contains exactly the required metadata content and no additional seeded profile values.
- **SC-007**: 100% of requests targeting NFR or Control baselines are routed to the owning skill without profile mutation.
- **SC-008**: All current profile operations remain compatible with the six named future schema sections without changing existing top-level ordering.

## Assumptions

- `.highway/profile.yaml` is distributed and structurally governed like `.highway/library/templates/requirements-inquiry.md`: the Highway Constitution and library validation model govern its shape and placement, while the user owns its values and Highway does not judge their semantic correctness.
- The existing Highway skill authoring, catalog, adapter, and distribution mechanisms are reused for `highway-profile`.
- The questionnaire may collect free-form values where the prompt lists examples; the skill records supplied wording rather than inferring values.
- Confirmation is an interactive user decision and is required for every operation that can create, modify, or delete profile content.
- The initial profile version is `1.0.0`; later schema or behavior changes follow the repository's normal skill and artifact versioning rules.
- The profile's contextual guidance may influence downstream recommendations but never overrides a Control, NFR, or governance rule.
