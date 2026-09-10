# Implementation Plan: Objectives Skill Rename

**Branch**: `028-objectives-rename-cleanup` | **Date**: 2026-09-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/028-objectives-rename-cleanup/spec.md`

## Summary

Rename the shipped Business Objective skill from the singular identity to `highway-objectives`,
remove every stale singular source or generated path, update tracked documentation and prompt
artifacts, regenerate catalogs and adapters from canonical sources, and verify the maintained
distribution declaration. The work deliberately does not address the previously identified behavioral-test or
output-determinism gaps; those are deferred to a later specification.

## Technical Context

**Language/Version**: Markdown skill contracts and Bash 3.2.57-compatible repository tooling

**Primary Dependencies**: Existing skill/library validators, catalog generators, adapter generator,
distribution generator, adapter-coverage test, distribution-packaging test, and full test suite

**Storage**: Repository-tracked source and generated files; root-level user-owned objective paths
remain outside the migration and must not be created or modified

**Testing**: Exact-token migration scan, stale-path scan, skill/library validators, catalog and
adapter generation, adapter correspondence, distribution packaging, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and GNU/Linux development environments using the distributed Highway tree

**Project Type**: Repository skill and generated-artifact distribution

**Performance Goals**: Complete within the existing generator and test-suite execution envelope

**Constraints**: No old singular identifier in active tracked paths; generated outputs must be
regenerated rather than hand-edited; preserve the maintained `.highway/tools/.distribution-manifest`
declaration; preserve Feature 027 as a separate spec record; preserve
unrelated worktree changes and root-level user-owned objective bytes; use existing Bash 3.2-compatible
tooling; do not implement deferred behavioral or deterministic-output work

**Scale/Scope**: One skill identity rename, three agent adapter targets, skill and library catalogs,
adapter/distribution manifests, tracked tests/docs/prompt artifacts, and stale-path verification

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Verdict | Evidence |
|---|---|---|
| Packaging Gate | PASS | Source, adapters, catalogs, and distribution paths are regenerated or verified against the maintained distribution manifest. |
| Toolchain Gate | PASS | The plan uses existing Bash 3.2-compatible scripts and no new dependency. |
| Correspondence Gate | PASS | Source rename requires catalog, adapter, adapter-manifest, distribution-manifest, and packaging correspondence checks. |
| Validation Gate | PASS | Exact-token, stale-path, validator, adapter, packaging, and full-suite checks are required. |
| Spec Record Gate | PASS | Feature 028 is a new sequential spec and Feature 027 remains a separate record. |
| Documentation Currency Gate | PASS | Feature 027 implementation references and tracked prompt artifacts are explicitly included in the cleanup scan. |

Applicable development constitution rules: D1.1-D1.6, D3.1-D3.6, D4.1-D4.7, D5.1-D5.4, D6.1-D6.2,
and D7.1-D7.3. Applicable Highway Skills Constitution rules are evaluated by the existing
skill/library validators and correspondence tests; no new governance rule is introduced.

## Phase 0: Research Summary

- Existing generators derive catalog and adapter content from source paths and frontmatter; source
  identity must be renamed before regeneration.
- The adapter manifest is generated and path-sensitive; the distribution manifest is maintained and
  path-sensitive. Both must contain only plural rows after the old rows and generated files are removed.
- Generated artifacts must not be hand-edited; regeneration is the source of truth.
- The migration allowlist is empty. Any old singular token found in tracked active or historical
  content is a failure, not an allowed exception.

## Project Structure

### Documentation

```text
specs/028-objectives-rename-cleanup/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── contracts/rename-workflow.md
├── quickstart.md
├── checklists/requirements.md
└── tasks.md                         # created by /speckit.tasks
```

### Source and Generated Paths

```text
.highway/skills/highway-objectives/SKILL.md
.highway/library/templates/output/objective-record.md
.highway/catalog/index.json
.highway/catalog/index.md
.highway/catalog/library-index.json
.highway/catalog/library-index.md
.highway/tools/.adapter-manifest
.highway/tools/.distribution-manifest
.github/skills/highway-objectives/SKILL.md
.claude/skills/highway-objectives/SKILL.md
.cursor/rules/highway-objectives.mdc
.highway/tools/tests/objective-management.test.sh
.highway/tools/tests/output-template.test.sh
```

Historical Feature 027 records remain under `specs/027-highway-objective/` and are not reused as
the active feature directory. Their tracked implementation references are updated only to remove
the old identity; their feature number and record structure remain unchanged.

**Structure Decision**: Keep the existing Highway source, generated adapter, catalog, manifest, and
test layout. Rename the source skill directory and generated adapter paths, update tracked references,
then regenerate the derived catalogs and adapters and verify the maintained distribution manifest.
Root-level `library/objectives/` and
`library/governance/objectives.md` are outside the source/distribution tree and remain untouched.

## Implementation Sequence

1. Capture the old-name reference inventory and verify root-level objective paths are absent or
   byte-snapshotted before edits.
2. Rename the source skill and test identifiers to plural names; update source frontmatter,
   commands, examples, path references, and tracked Feature 027/prompt references.
3. Remove stale singular generated adapter directories/files and manifest rows.
4. Update distribution classifications and any test expectations to the plural paths.
5. Run the canonical catalog, library-catalog, and adapter generators; do not describe the
  distribution manifest as generated.
6. Run skill/library validators, exact-token and stale-path scans, adapter correspondence, packaging,
   and the full suite.
7. Confirm root-level user-owned objective bytes are unchanged and no migration allowlist exception
   was used.

## Complexity Tracking

No constitution violations or new abstractions are required. The work is a path and identity
migration using the existing generators and tests.
