# Feature Specification: Highway Objective

**Feature Branch**: `027-highway-objective`

**Created**: 2026-09-09

**Status**: Draft

**Input**: User description: "/speckit.specify highway-objectives"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Inspect the objective baseline (Priority: P1)

As a Highway user, I want to view the current Business Objective baseline so that I can understand the repository's active business direction and its traceability starting points.

**Why this priority**: Reading the baseline is the safest and most fundamental use of the skill, and downstream work depends on knowing which objectives exist.

**Independent Test**: Invoke the skill with no action and with `view`, `show`, and `describe`; verify that each read-only action reports the baseline version, objective count, identifiers, titles, and statuses without changing any file bytes.

**Acceptance Scenarios**:

1. **Given** a repository with zero or more objective records, **When** the user invokes `view`, `show`, or `describe`, **Then** the skill displays the current version, count, identifiers, titles, and statuses without writing files.
2. **Given** a request with an unsupported or ambiguous action, **When** the skill processes the request, **Then** it stops and asks the user to clarify without writing files.
3. **Given** a repository with no objective baseline, **When** the user requests a read-only action, **Then** the skill reports the absence and does not create an artifact.

### User Story 2 - Create and maintain user-owned objectives (Priority: P1)

As a Highway user, I want to add and update Business Objectives through a guided workflow so that each objective has durable identity, measurable success criteria, and a user-approved rationale.

**Why this priority**: Objective records provide the business justification that future Highway artifacts will reference.

**Independent Test**: Run the add/new/setup interview, confirm one or more proposed objectives, and verify that records are created under `library/objectives`, identifiers are permanent, and the catalog is regenerated deterministically.

**Acceptance Scenarios**:

1. **Given** an add, new, or setup action, **When** the user answers the three separate prompts and confirms the proposed rationale, **Then** the skill allocates the next unused identifier, creates the objective record, regenerates the catalog, and reports the resulting version.
2. **Given** an add, new, or setup action, **When** the user declines or replaces the proposed rationale, **Then** the skill preserves the user's final rationale and performs no write until the complete proposal is confirmed.
3. **Given** a confirmed objective creation, **When** the skill asks whether another objective should be created, **Then** an affirmative response repeats the same guided process and a negative response ends without an additional record.
4. **Given** an update request, **When** the user confirms changes to title, statement, success measures, rationale, or status, **Then** the identifier remains unchanged and the catalog reflects the updated record.

### User Story 3 - Safely remove or reset objectives (Priority: P1)

As a Highway user, I want destructive objective operations to show their impact and require confirmation so that declined or aborted changes cannot damage user-owned content.

**Why this priority**: Objective records are durable user-owned artifacts, so destructive operations must be reviewable and reversible by refusal.

**Independent Test**: Run remove and reset against a fixture baseline, inspect the proposed affected records, decline confirmation, and verify that all tracked bytes remain unchanged; repeat with confirmation to verify the expected baseline version increment.

**Acceptance Scenarios**:

1. **Given** an existing objective, **When** the user invokes remove, **Then** the skill shows the identifier and title, requests confirmation, and writes nothing when confirmation is not received.
2. **Given** one or more existing objectives, **When** the user invokes reset, **Then** the skill lists every objective that would be removed, requests confirmation, and writes nothing when confirmation is not received.
3. **Given** a confirmed remove or reset, **When** the operation completes, **Then** the affected records and catalog are updated and the baseline version increments exactly once according to the version policy.

### Edge Cases

- An action outside `setup`, `configure`, `view`, `show`, `describe`, `add`, `new`, `update`, `remove`, and `reset` must stop for clarification and perform no write.
- Objective identifiers are never reused after removal, including after a reset.
- A duplicate identifier, missing catalog target, invalid `next_id`, or record outside `library/objectives` must fail validation without overwriting user-owned content.
- A declined, ambiguous, malformed, or aborted operation must leave all affected files byte-for-byte unchanged.
- Empty objective collections and a missing baseline must be representable without creating an artifact during read-only actions.
- Catalog generation must remain deterministic and must not emit timestamps, random identifiers, or environment-derived values.
- Future Capability records must be able to reference objective identifiers through the reserved relationship field without requiring a schema rewrite.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST provide exactly the actions `setup`, `configure`, `view`, `show`, `describe`, `add`, `new`, `update`, `remove`, and `reset` for Business Objective management.
- **FR-002**: The system MUST stop and request clarification for an action outside the supported action set.
- **FR-003**: The system MUST store user-owned objective records under `library/objectives` and MUST NOT write objective records beneath `.highway`.
- **FR-004**: The system MUST allocate each objective a permanent `OBJ` identifier that is never changed or reused after removal.
- **FR-005**: The system MUST provide read-only status output containing the baseline version, objective count, identifiers, titles, and statuses.
- **FR-006**: The system MUST ask three separate prompts during setup, configure, add, and new: objective description, success measures, and rationale review.
- **FR-007**: The system MUST preserve the user's accepted, edited, or replaced rationale as user-owned content.
- **FR-008**: The system MUST create or update an objective record with statement, success measures, rationale, status, and reserved `capabilities: []` relationship data.
- **FR-009**: The system MUST regenerate `library/governance/objectives.md` after a confirmed objective mutation.
- **FR-010**: The system MUST include baseline version, next identifier, objective index, titles, statuses, ownership statement, and direct-edit warning in the catalog.
- **FR-011**: The system MUST generate identical catalog bytes from identical objective inputs.
- **FR-012**: The system MUST NOT emit timestamps, random identifiers, or environment-derived values in objective records, catalogs, or mutation reports.
- **FR-013**: The system MUST show the affected identifier and title before a remove confirmation.
- **FR-014**: The system MUST list every objective that would be removed before a reset confirmation.
- **FR-015**: The system MUST leave all affected files unchanged when a mutation is declined, ambiguous, malformed, or aborted.
- **FR-016**: The system MUST increment the baseline version exactly once per confirmed action: MINOR for add/new, PATCH for update, and MAJOR for remove/reset.
- **FR-017**: The system MUST produce a mutation report containing action, file, summary, affected entries, confirmation status, and resulting version.
- **FR-018**: The system MUST verify that every objective record exists in the objective directory, every identifier is unique, every catalog entry resolves to a record, and `next_id` is greater than all allocated identifiers.
- **FR-019**: The system MUST expose objective identifiers as stable references suitable for future Capability relationships.

### Key Entities

- **Business Objective**: A user-owned record with a permanent identifier, title, status, statement, success measures, rationale, and reserved capability relationship data.
- **Objective Baseline**: The complete set of objective records and its semantic version.
- **Objective Catalog**: A deterministic index containing the baseline version, next identifier, objective summaries, ownership statement, and direct-edit warning.
- **Mutation Report**: The result of a confirmed, declined, ambiguous, malformed, or aborted operation, including affected files and version outcome.
- **Objective Identifier**: A permanent `OBJ` reference allocated once and never reused, intended for future traceability links.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can inspect the objective baseline through each supported read-only action without any file-byte changes.
- **SC-002**: A confirmed add, update, remove, or reset operation produces the expected record and catalog changes with exactly one version increment.
- **SC-003**: Every objective identifier remains unique and stable across at least 100 sequential create, update, and remove operations, with no identifier reuse.
- **SC-004**: Identical objective inputs produce byte-identical catalogs across repeated generation runs.
- **SC-005**: 100% of declined, ambiguous, malformed, and aborted mutation scenarios leave affected files byte-for-byte unchanged.
- **SC-006**: Every catalog entry resolves to an existing objective record and `next_id` remains greater than every allocated identifier in the baseline.
- **SC-007**: No emitted objective artifact contains a timestamp, random identifier, or environment-derived value.
- **SC-008**: A future Capability record can reference an objective through its stable identifier without changing the objective identifier format.

## Assumptions

- The skill follows the existing Highway skill packaging, validation, catalog, adapter, and distribution conventions.
- The authoritative source skill is `.highway/skills/highway-objectives/SKILL.md`; user-owned objective records and the objective catalog are outside `.highway` at the paths specified above.
- The first prompt's objective description supplies the source text from which a deterministic human-readable title is derived; no fourth title prompt is added.
- Newly created objectives default to status `active` unless the user changes the status during an update.
- The objective record uses Markdown with YAML frontmatter, matching the existing user-owned artifact conventions.
- The reserved `capabilities: []` field remains empty until Capability records are implemented.
- Version changes apply only after a confirmed mutation and successful writes; declined or failed operations preserve the prior version and bytes.
- The current repository branch is not used to infer the feature directory; the next sequential spec directory is authoritative.
