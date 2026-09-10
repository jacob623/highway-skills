# Research: Objectives Skill Rename

## Decision: Rename canonical source first, then regenerate derived artifacts

**Decision**: Move the source skill directory and update its frontmatter/commands to
`highway-objectives` before running catalog and adapter generators. Remove old generated paths and
manifest rows as part of the same migration.

**Rationale**: Catalog and adapter generators derive identity from the source directory and
frontmatter. Regenerating after the source rename prevents stale singular outputs from being
recreated and makes generated files authoritative.

**Alternatives considered**:

- Hand-edit generated adapters and catalogs: rejected because generated artifacts are governed by
  manifests and correspondence checks.
- Keep a compatibility alias: rejected because the specification requires one canonical identity
  and zero old references.

## Decision: Use an empty migration allowlist

**Decision**: No active, shipped, generated, test, manifest, historical, or live documentation path
may retain the singular token.

**Rationale**: The requested outcome is a complete cleanup, and the old identifier has no required
compatibility or archival value. An allowlist would make stale references easy to hide.

**Alternatives considered**:

- Allow the old name in Feature 027 history: rejected because those records contain implementation
  references and are repository-tracked documentation that must remain current.
- Allow the old name in the new spec: rejected because a literal-zero scan is clearer and the spec
  can describe the superseded identity without reproducing it.

## Decision: Protect root-level user-owned objective data by snapshot and exclusion

**Decision**: Rename validation snapshots any existing `library/objectives/` and
`library/governance/objectives.md` bytes, never writes those paths, and verifies their bytes after
packaging and generation.

**Rationale**: The rename concerns the shipped skill identity, not user-owned objective content.

**Alternatives considered**:

- Rebuild the user catalog during rename: rejected because that changes user-owned governance
  content outside the feature scope.

## Decision: Verify both token and path absence

**Decision**: The migration uses exact-token scans plus explicit stale-path checks for singular source,
adapter, catalog, manifest, and test paths.

**Rationale**: A token scan can miss renamed or encoded paths, while a path-only scan can miss
commands and prose. Both are needed to prove the canonical identity is singular and complete.

**Alternatives considered**:

- Rely only on full-suite tests: rejected because existing tests can pass while stale documentation
  or orphaned generated files remain.
