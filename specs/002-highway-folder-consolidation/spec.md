# Feature Specification: Consolidate Skill Suite Support Files into `.highway/`

**Feature Branch**: `002-highway-folder-consolidation`

**Created**: 2026-09-06

**Status**: Draft

**Input**: User description: "Aside from the coding agent skill folders, I want all of the files and folders that support this skill suite to be contained within a .highway folder."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Clean, single-purpose repository root (Priority: P1)

As a maintainer or new contributor, when I list the repository root, I want a single folder
that holds everything the skill-authoring framework needs internally (authored skill sources,
generation tooling, and the generated catalog), so that the only other top-level folders I see
are the ones each coding agent actually reads (`.github/skills/`, `.claude/skills/`,
`.cursor/rules/`).

**Why this priority**: This is the entire point of the feature — without it, nothing else
matters. It delivers the organizational value on its own.

**Independent Test**: Can be fully tested by listing the repository root after the change and
confirming that `skills/`, `tools/`, and `catalog/` no longer exist there, and that a single
`.highway/` directory contains equivalent content.

**Acceptance Scenarios**:

1. **Given** the repository root, **When** a maintainer lists its top-level contents, **Then**
   the only skill-suite-related entries are `.highway/`, `.github/skills/`, `.claude/skills/`,
   and `.cursor/rules/` (plus files unrelated to the skill suite, e.g. root `README.md`, `.git/`).
2. **Given** the relocated framework, **When** a maintainer inspects `.highway/`, **Then** they
   find the authored skill sources, the generation tooling, and the generated catalog, each in
   their own clearly named subfolder.

---

### User Story 2 - Author, validate, and regenerate from the new location (Priority: P1)

As a skill author, I want to author a skill, validate it, regenerate the catalog, and regenerate
the per-agent adapters using the exact same commands and workflow as before (only the base path
changes), so that relocating the framework does not disrupt my day-to-day authoring workflow.

**Why this priority**: The relocation is worthless if the tooling breaks; this proves the move
is purely structural and the framework still works end-to-end.

**Independent Test**: Can be fully tested by authoring a sample skill under the new skill
sources location, running the validation, catalog-generation, and adapter-generation tooling
from their new location, and confirming identical success/failure behavior and outputs to before
the move.

**Acceptance Scenarios**:

1. **Given** a valid skill authored under the new skill sources location, **When** the
   validation tool is run against it, **Then** it reports success exactly as it did before the
   relocation.
2. **Given** the relocated tooling, **When** the catalog-generation tool is run, **Then** it
   produces a catalog inside `.highway/` with the same shape and content rules as before the
   move.
3. **Given** the relocated tooling, **When** the adapter-generation tool is run, **Then** it
   still writes into `.github/skills/`, `.claude/skills/`, and `.cursor/rules/` (unchanged
   locations) with byte-identical output to before the move for the same source skill.

---

### User Story 3 - Accurate documentation after the move (Priority: P2)

As a contributor reading the project's documentation, I want every doc that mentions a
skill-suite file path to reflect the new `.highway/`-relative path, so that I never follow a
stale instruction that points at a folder that no longer exists.

**Why this priority**: Important for usability and trust in the docs, but the framework is
already fully functional (per US1/US2) even before every doc reference is fixed.

**Independent Test**: Can be fully tested by searching all tracked documentation for the old
top-level paths (`skills/`, `tools/`, `catalog/`) and confirming zero remaining references
outside of historical/spec records of this migration itself.

**Acceptance Scenarios**:

1. **Given** the repository's documentation (root `README.md` and the framework's own internal
   docs), **When** a contributor searches for references to the old paths, **Then** none remain
   (aside from this feature's own spec/plan/tasks records, which intentionally describe the
   migration).

---

### Edge Cases

- What happens to files that existed at both the old and new conceptual locations during the
  move? The migration MUST NOT leave a duplicate copy behind at the old path once complete.
- What happens if `.highway/` already contains a file at a target path? Not expected in the
  current repository state (assumed empty/absent before migration); this is out of scope to
  design for since it does not apply here.
- What happens to files that are not part of the skill suite but happen to live in the
  repository root (e.g. the root `README.md`, `.gitignore`)? These are unaffected — they either
  are not skill-suite-support files, or (in the case of `.gitignore`) must remain at the root to
  keep applying repository-wide.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST relocate the authored skill sources directory (currently
  `skills/`) to `.highway/skills/`, preserving its internal structure and contents.
- **FR-002**: The system MUST relocate the generation tooling directory (currently `tools/`) to
  `.highway/tools/`, preserving its internal structure and contents.
- **FR-003**: The system MUST relocate the generated catalog directory (currently `catalog/`) to
  `.highway/catalog/`, preserving its internal structure and contents.
- **FR-004**: The system MUST NOT relocate or rename the three per-agent adapter output
  directories (`.github/skills/`, `.claude/skills/`, `.cursor/rules/`); these remain exactly
  where each coding agent expects to find them.
- **FR-005**: All generation and validation tooling MUST continue to operate correctly after the
  move, reading skill sources from and writing the catalog to their new `.highway/`-relative
  locations, while continuing to write agent adapters to their unchanged locations.
- **FR-006**: The relocation MUST NOT change the content or behavior of anything the tooling
  generates — adapters written to `.github/skills/`, `.claude/skills/`, and `.cursor/rules/`
  MUST be byte-identical to what they were before the move, for the same source skill content.
- **FR-007**: The automated test suite for the skill-authoring framework MUST pass, unmodified in
  its assertions (only its own location and internal path references may change), after the
  relocation.
- **FR-008**: All documentation that references the old top-level `skills/`, `tools/`, or
  `catalog/` paths (including the root `README.md` and the framework's own internal docs) MUST
  be updated to reference the new `.highway/`-relative paths.
- **FR-009**: The migration MUST be a one-time, complete move: no duplicate copies of skill
  sources, tooling, or the catalog may remain at the old top-level paths once the migration is
  complete.

### Key Entities

- **`.highway/` directory**: The single top-level container for everything that supports the
  skill-authoring framework but is not itself an agent-facing output — holds the authored skill
  sources, the generation/validation tooling, and the generated catalog.
- **Agent Adapter Directories**: The three existing, unchanged, per-agent output locations
  (`.github/skills/`, `.claude/skills/`, `.cursor/rules/`) that each coding agent reads directly;
  explicitly out of scope for relocation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Listing the repository root shows exactly one folder (`.highway/`) containing all
  skill-suite support content, alongside the three unchanged agent adapter folders — zero other
  skill-suite-related top-level folders remain.
- **SC-002**: 100% of the existing automated test suite passes after the relocation.
- **SC-003**: For an identical source skill, the bytes written to `.github/skills/`,
  `.claude/skills/`, and `.cursor/rules/` are identical before and after the relocation.
- **SC-004**: Zero remaining references to the old `skills/`, `tools/`, or `catalog/` top-level
  paths exist in any tracked documentation, other than the historical record of this migration
  itself.

## Assumptions

- "This skill suite" refers to the Multi-Agent Skill Suite framework's own deliverables (skill
  sources, generation/validation tooling, and the generated catalog) — i.e., the `skills/`,
  `tools/`, and `catalog/` directories delivered by the prior feature. It does not include the
  spec-kit process directories (`.specify/`, `specs/`), since those are spec-kit's own workflow
  scaffolding with fixed, non-configurable path conventions relied upon by the spec-kit tooling
  itself (used to author this very feature) — relocating them would break spec-kit, not the
  skill suite.
- The root `.gitignore` is unaffected: it is a generic, repository-wide mechanism file (not
  specific to the skill suite) and must remain at the repository root to keep applying
  repository-wide.
- The root `README.md` stays at the repository root (it is the repository's entry point, not a
  skill-suite support file) but has its internal links updated to the new paths.
- No CI configuration currently references the old paths, since none exists in this repository
  yet.
- This is a structural relocation only; no functional or behavioral changes to validation rules,
  the catalog schema, or adapter transforms are in scope.
