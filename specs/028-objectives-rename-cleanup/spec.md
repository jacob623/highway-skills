# Feature Specification: Objectives Skill Rename

**Feature Branch**: `028-objectives-rename-cleanup`

**Created**: 2026-09-09

**Status**: Draft

**Input**: User description: "/speckit.specify Rename the singular objective skill to highway-objectives and remove all references to the old skill name."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Rename the skill and eliminate legacy references (Priority: P1)

As a Highway user, I want the plural `highway-objectives` skill to be the only canonical name so that commands, generated adapters, catalogs, manifests, tests, and documentation do not point to a removed skill.

**Why this priority**: A partial rename would leave stale commands, orphaned generated artifacts, or distribution paths that users cannot invoke consistently.

**Independent Test**: Regenerate all derived artifacts, build the distribution, and scan the repository's active source, generated, test, manifest, and documentation paths for the superseded singular skill identifier; the scan must return zero matches and no old artifact path may remain.

**Acceptance Scenarios**:

1. **Given** the current singular skill source and generated artifacts, **When** the rename is applied and generators run, **Then** the source directory, command, adapter directories/files, catalog entries, manifest rows, and test paths use `highway-objectives`.
2. **Given** an unchanged or freshly generated repository, **When** adapter, catalog, and packaging correspondence checks run, **Then** no orphaned singular adapter, catalog entry, manifest row, or stale documentation reference remains.
3. **Given** historical Feature 027 design records and prompt artifacts contain the superseded name, **When** the cleanup is complete, **Then** those repository-tracked references are updated or removed according to the migration allowlist, and the final active-tree scan is zero.

## Edge Cases

- A repository contains an old generated adapter or manifest row after the source rename; correspondence checks must fail and identify the orphan.
- A legacy-name occurrence appears in an allowlisted migration-history note; the scan must distinguish the explicitly allowed migration record from active artifacts.
- A generated artifact exists at the old singular path while the plural source exists; cleanup must remove the orphan rather than preserve both names.
- A historical Feature 027 document or prompt artifact contains the old name; it must be rewritten or removed, not silently excluded from the scan.
- Root-level user-owned objective records and catalogs must remain untouched during rename validation and packaging.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST make `highway-objectives` the sole canonical skill identifier, command name, source directory name, adapter name, catalog identifier, and manifest identifier.
- **FR-002**: The system MUST remove the superseded singular skill identifier from all active source, generated, test, manifest, distribution, and live documentation paths after migration.
- **FR-003**: The system MUST remove or regenerate every old adapter, catalog entry, manifest row, fixture reference, and prompt/documentation reference so no stale singular artifact remains.
- **FR-004**: The system MUST preserve the objective record template's required fields and update every citation, command example, and path to use the canonical plural skill name.
- **FR-005**: The system MUST regenerate catalogs and adapters from canonical source files rather than hand-editing generated outputs; `.highway/tools/.distribution-manifest` remains a canonical maintained packaging declaration consumed by the distribution generator.
- **FR-006**: The system MUST update Feature 027 implementation references and any repository-tracked prompt artifacts that use the superseded skill name.
- **FR-007**: The system MUST define and test a migration allowlist containing no shipped, active, generated, test, manifest, or live documentation path.
- **FR-008**: The system MUST preserve root-level user-owned objective records and catalogs during rename validation and packaging.
- **FR-009**: The system MUST pass skill, library, adapter, packaging, and full-suite validation after migration.

### Key Entities

- **Canonical Skill Identity**: The plural skill name, command, source path, adapter paths, catalog identity, and manifest identity that must remain consistent.
- **Migration Allowlist**: The narrowly scoped set of explanatory references permitted during the rename, with no shipped or active artifact permitted.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A repository-wide exact-token scan reports zero occurrences of the superseded singular skill identifier and zero old adapter/source/manifest paths after migration.
- **SC-002**: Regenerated catalogs, adapters, manifests, and distribution metadata contain only the canonical plural identity and pass correspondence checks with 0 failures.
- **SC-003**: Every Feature 027 implementation reference and prompt artifact is updated or removed, and no stale command example remains.
- **SC-004**: Root-level user-owned objective records and catalogs remain byte-for-byte unchanged, or remain absent, after rename validation and packaging.
- **SC-005**: Skill, library, adapter, packaging, and full-suite validation pass with 0 failures after migration.

## Assumptions

- Feature 028 is a new sequential specification and does not reuse or replace the Feature 027 directory; Feature 027 may be updated only where required to remove stale repository references.
- The canonical skill keeps the existing objective record schema and user-owned root-level storage boundary.
- Generated adapters and catalogs remain authoritative outputs of the existing repository generators; `.highway/tools/.distribution-manifest` remains the canonical maintained packaging declaration consumed by the distribution generator.
- The migration allowlist is empty for active, shipped, generated, test, manifest, and live documentation paths.
- Existing unrelated user changes and completed Feature 024–026 behavior remain preserved.
