# Feature Specification: Seed Library Context Documents

**Feature Branch**: `087-seed-library-context`

**Created**: 2026-09-24

**Status**: Draft

**Input**: User description: "Create a new spec to implement the following: I have seeded highway-identity.md, highway-platform-objectives.md, and highway-vision.md in the repository root. Copy these files byte-for-byte to .highway/library. Once this spec is complete, I will delete the root files manually so no residue remains."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Seed foundational Highway context in the library (Priority: P1)

As a Highway maintainer, I want the three foundational context documents currently provided at the repository root to be copied into `.highway/library/knowledge/`, so that Highway workflows can consume the repository-owned context from its shared library location before the temporary root files are removed.

**Why this priority**: The library copies are the entire purpose of the feature and must exist before the root seed files are manually deleted.

**Independent Test**: Starting with the three source files present, run the implementation and confirm that each same-named file exists under `.highway/library/knowledge/`, has identical bytes to its source, and leaves each source file unchanged.

**Acceptance Scenarios**:

1. **Given** all three named source files exist at the repository root, **when** the feature is implemented, **then** `.highway/library/knowledge/highway-identity.md`, `.highway/library/knowledge/highway-platform-objectives.md`, and `.highway/library/knowledge/highway-vision.md` exist.
2. **Given** the three library files have been created, **when** each source file is compared with its corresponding library file, **then** every pair is byte-for-byte identical, including line endings and final-byte content.
3. **Given** the source files are present before the copy, **when** the feature is implemented, **then** the source files remain unchanged so the maintainer can delete them manually afterward.
4. **Given** one or more required source files are missing, **when** the feature is attempted, **then** it fails clearly and does not claim successful completion for the missing copy.
5. **Given** a destination file already exists with different bytes, **when** the feature is attempted, **then** the implementation does not silently report success while leaving stale or conflicting library content.

### Edge Cases

- The source file is named `highway-identity.md`; similarly named files are not part of this feature's source set.
- `.highway/library/knowledge/` already exists as the destination for shared knowledge documents. The three context documents belong directly under that directory.
- A source file is empty, has unusual line endings, or lacks a final newline. The copy must preserve its exact bytes rather than normalize formatting.
- The root source files are deleted after successful completion. The library copies must remain independently usable after those deletions.
- An unrelated file already exists under `.highway/library/knowledge/`. It must remain untouched.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The feature MUST copy the following root files to `.highway/library/knowledge/` using the same filenames: `highway-identity.md`, `highway-platform-objectives.md`, and `highway-vision.md`.
- **FR-002**: Each destination file MUST be byte-for-byte identical to its corresponding source file, including content, ordering, whitespace, line endings, and final-newline state.
- **FR-003**: The feature MUST preserve the three root source files unchanged; deleting those source files remains a separate manual action outside this feature.
- **FR-004**: The feature MUST place the copied documents directly in `.highway/library/knowledge/` and MUST NOT move or duplicate them into another library directory as part of this feature.
- **FR-005**: The feature MUST detect a missing required source file and report the missing filename rather than producing an incomplete successful result.
- **FR-006**: The feature MUST detect an existing destination whose bytes differ from the source and MUST either replace it with the exact source bytes or fail clearly; it MUST NOT leave a known mismatch while claiming success.
- **FR-007**: The feature MUST leave unrelated existing files under `.highway/library/knowledge/` unchanged.
- **FR-008**: The implementation MUST resolve the `highway-identity.md` source by that exact name and MUST NOT silently substitute another similarly named file.
- **FR-009**: After successful completion, the three library copies MUST remain valid when the root source files are subsequently deleted manually.

### Key Entities

- **Seed source document**: One of the three temporary Markdown files supplied at the repository root for this feature.
- **Library context document**: The byte-for-byte copy stored directly under `.highway/library/knowledge/` and retained as repository-owned Highway context.
- **Copy mapping**: The fixed same-filename relationship between each root source document and its `.highway/library/knowledge/` destination.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 3 of 3 required source files produce corresponding files directly under `.highway/library/knowledge/` after successful implementation.
- **SC-002**: 100% of the three source/destination pairs compare byte-for-byte equal immediately after the copy.
- **SC-003**: 100% of the three root source files have unchanged bytes immediately after implementation.
- **SC-004**: A missing-source test identifies the exact missing filename and does not report a complete successful copy.
- **SC-005**: After the three root files are manually deleted, 3 of 3 library copies remain present and byte-for-byte complete.
- **SC-006**: 100% of unrelated pre-existing files under `.highway/library/knowledge/` retain their original bytes.

## Assumptions

- The requested source files are temporary seed inputs and are intentionally not deleted by this feature.
- The destination filenames are identical to the source filenames and are stored directly under `.highway/library/knowledge/`.
- `.highway/library/knowledge/` is already the repository's shared knowledge location; no new library taxonomy or catalog entry is required for these copies.
- No transformation, parsing, frontmatter validation, content merge, or generated artifact is required by this feature.

## Out of Scope

- Deleting the three root source files; the maintainer will perform that manual cleanup after successful verification.
- Editing the contents of any source or destination document.
- Changing `.highway/library/` discovery, catalog generation, governance rules, or skill behavior beyond making these files available at the requested path.
- Copying any other root-level files into `.highway/library/`.
