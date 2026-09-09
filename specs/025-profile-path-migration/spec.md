# Feature Specification: Highway Profile Path Migration

**Feature Branch**: `025-profile-path-migration`

**Created**: 2026-09-09

**Status**: Draft

**Input**: User description: "Move the Highway organizational profile to its canonical output-template path without leaving orphaned files, tests, fixtures, generated artifacts, or distribution metadata."

## Required Profile Schema

The migrated profile MUST use this pure-YAML shape, including the listed empty mappings and the
`organization` section:

```yaml
metadata:
	version: 1.0.0
	description: >
		Repository-wide organizational context,
		architectural constraints,
		strategic directions,
		and technology preferences.

organization:
	name: ""
	industry: ""

constraints: {}

strategic_directions: {}

preferences: {}

business_context: {}

architecture_principles: {}

approved_technologies: {}

prohibited_technologies: {}

operating_model: {}

vendor_strategy: {}
```

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Migrate the Profile Artifact (Priority: P1)

As a Highway maintainer, I want the organizational profile moved from its former path to the canonical output-template path, so the distributed artifact has one authoritative location.

**Why this priority**: A split or ambiguous profile location can cause users, tools, and generated distributions to read or ship different artifacts.

**Independent Test**: Run the migration checks and confirm the canonical profile exists, the former path is absent, and all repository references resolve to the canonical path.

**Acceptance Scenarios**:

1. **Given** the profile exists at the former path, **When** the migration is applied, **Then** the profile exists at `.highway/library/templates/output/profile.yaml` and the former path is absent.
2. **Given** source skills, validators, tests, fixtures, generated catalogs, adapters, manifests, or distribution metadata refer to the former path, **When** the migration is applied, **Then** each affected artifact is updated or removed so no reference remains orphaned.
3. **Given** the migration is complete, **When** the repository is packaged, **Then** distribution metadata includes the canonical profile path and does not include the former path.

### User Story 2 - Verify a Clean Repository Migration (Priority: P1)

As a Highway maintainer, I want an explicit orphan audit, so the path move cannot appear complete while stale files or generated references remain.

**Why this priority**: Generated and packaging artifacts can preserve obsolete paths even after the primary source file has moved.

**Independent Test**: Run the focused migration audit and confirm it reports zero former-path files, tests, fixtures, catalog entries, adapters, manifest rows, and distribution-metadata references.

**Acceptance Scenarios**:

1. **Given** the repository has completed the move, **When** the clean-migration audit runs, **Then** it finds zero artifacts or references at the former path.
2. **Given** an orphaned former-path artifact is introduced, **When** the audit runs, **Then** it fails and identifies the stale artifact or reference.

### User Story 3 - Maintain Profile Version Integrity (Priority: P1)

As a repository owner, I want profile version changes to reflect confirmed content changes, so consumers can distinguish compatible maintenance from resets and schema-breaking releases.

**Why this priority**: Version history communicates the impact of profile changes and must not advance when a requested operation is declined or fails.

**Independent Test**: Exercise confirmed and declined `add`, `update`, `remove`, and `reset` operations, then verify the prescribed version increment occurs only after confirmed writes; verify schema-breaking changes use a MAJOR increment.

**Acceptance Scenarios**:

1. **Given** a confirmed `add`, `update`, or `remove`, **When** the profile write completes, **Then** the version increments by PATCH.
2. **Given** a confirmed `reset`, **When** the profile write completes, **Then** the version increments by MINOR.
3. **Given** a schema-breaking change, **When** the release is prepared, **Then** the version increments by MAJOR.
4. **Given** an operation is declined or aborts before writing, **When** the operation ends, **Then** the profile and version remain byte-for-byte unchanged.

## Edge Cases

- The former profile file is absent before migration; the migration remains idempotent and still produces a clean audit.
- A stale test, fixture, catalog entry, adapter, adapter-manifest row, distribution-manifest row, or other distribution metadata reference fails the audit even when the canonical profile exists.
- Generated artifacts are regenerated from updated sources rather than retaining obsolete path references.
- Migration does not alter user-owned profile values beyond the required path move.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The profile MUST have exactly one repository-authoritative location at `.highway/library/templates/output/profile.yaml`.
- **FR-002**: The former profile path MUST be absent after migration.
- **FR-003**: Source skills, validators, tests, fixtures, generated catalogs, adapters, adapter-manifest rows, distribution-manifest rows, and other distribution metadata MUST be updated or removed so none refer to the former path.
- **FR-004**: Distribution packaging MUST include the canonical profile path and MUST exclude the former path.
- **FR-005**: The migration MUST preserve user-owned profile values and MUST NOT introduce unrelated content changes.
- **FR-006**: The repository MUST provide a repeatable clean-migration audit that fails when any former-path artifact or reference remains.
- **FR-007**: The migrated profile MUST be a pure YAML document with no Markdown or YAML frontmatter delimiters and MUST preserve the ordered top-level sections `metadata`, `organization`, `constraints`, `strategic_directions`, `preferences`, `business_context`, `architecture_principles`, `approved_technologies`, `prohibited_technologies`, `operating_model`, and `vendor_strategy`.
- **FR-008**: The migrated default profile MUST use version `1.0.0`, the specified folded description, empty `organization.name` and `organization.industry` values, and empty mappings for every other required section, with no additional seeded content.
- **FR-009**: Profile version maintenance MUST increment PATCH for confirmed `add`, `update`, and `remove` operations, increment MINOR for a confirmed `reset`, and increment MAJOR for a schema-breaking change.
- **FR-010**: A profile version increment MUST occur only after the corresponding confirmed content change is written; declined, malformed, ambiguous, or aborted operations MUST leave the profile and version unchanged.

## Key Entities

- **Canonical profile artifact**: The authoritative profile at `.highway/library/templates/output/profile.yaml`.
- **Former profile path**: The pre-migration profile location that must no longer exist or be referenced.
- **Orphaned migration artifact**: A stale file, test, fixture, generated entry, manifest row, or distribution metadata item that remains tied to the former path.
- **Clean-migration audit**: The repeatable verification that finds zero orphaned migration artifacts or former-path references.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The canonical profile exists and the former profile path has zero files after migration.
- **SC-002**: A repository-wide search finds zero former-path references in source, tests, fixtures, catalogs, adapters, manifests, or distribution metadata.
- **SC-003**: The clean-migration audit passes with zero orphaned profile files, tests, fixtures, catalog entries, adapters, manifest rows, or distribution-metadata references.
- **SC-004**: Packaging includes the canonical profile exactly once and excludes the former path.
- **SC-005**: User-owned profile values are unchanged except for the artifact location.
- **SC-006**: The canonical migrated profile is directly parseable as pure YAML, has no frontmatter delimiters, and matches the exact required schema and top-level ordering.
- **SC-007**: The distributed default profile contains version `1.0.0`, the specified description, empty organization fields, and no additional seeded values.
- **SC-008**: 100% of confirmed profile mutations apply the prescribed semantic-version increment, while declined or aborted operations leave the version byte-for-byte unchanged.
- **SC-009**: Schema-breaking profile changes are released with a MAJOR version increment.

## Assumptions

- The profile's interactive behavior and semantic-version policy are defined by Feature 024; this feature governs the schema-preserving repository-wide relocation and its verification.
- The former path is `.highway/profile.yaml`.
- Source, test, fixture, generated, manifest, and distribution updates are treated as one coordinated migration.
- Existing catalog, adapter, distribution, and test tooling is reused where it can verify the move without introducing unrelated behavior.
- The initial profile version is `1.0.0`; version maintenance follows the PATCH/MINOR/MAJOR policy defined in FR-009, and version updates are committed only with confirmed profile writes.