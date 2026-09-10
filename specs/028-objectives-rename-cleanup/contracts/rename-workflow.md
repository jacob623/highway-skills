# Contract: Objectives Skill Rename Workflow

## Canonical Identity

The only accepted skill identity is `highway-objectives`.

| Surface | Required value |
|---|---|
| Source directory | `.highway/skills/highway-objectives/` |
| Source file | `.highway/skills/highway-objectives/SKILL.md` |
| Command | `/highway-objectives` |
| GitHub adapter | `.github/skills/highway-objectives/SKILL.md` |
| Claude adapter | `.claude/skills/highway-objectives/SKILL.md` |
| Cursor adapter | `.cursor/rules/highway-objectives.mdc` |
| Skill catalog ID | `highway-objectives` |
| Adapter manifest ID | `highway-objectives` |
| Distribution manifest paths | Plural source and adapter paths only |

## Migration Sequence

1. Record the old-name inventory and snapshot existing root-level user-owned objective bytes.
2. Rename the canonical source directory and update source identity, command examples, and tracked references.
3. Remove singular generated adapters, catalog rows, manifest rows, and stale test/path references.
4. Regenerate catalogs and adapters from canonical source files.
5. Generate and validate the distribution.
6. Run exact-token and stale-path scans.
7. Compare user-owned objective snapshots and report unchanged bytes.

## Zero-Reference Rule

The migration allowlist is empty. A successful scan must find no exact legacy token or singular
legacy path in repository-tracked source, generated artifacts, tests, manifests, distribution
metadata, Feature 027 records, prompt artifacts, or live documentation.

The scan must distinguish the singular token from the valid plural token; substring matching is not
sufficient.

## Generated Artifact Contract

Generated files must be produced by:

- `.highway/tools/generate-catalog.sh`
- `.highway/tools/generate-library-catalog.sh`
- `.highway/tools/generate-agent-adapters.sh`
- `.highway/tools/generate-distribution.sh` when packaging is validated

Hand-editing generated catalogs, adapters, or hashes is not a conforming implementation.

## User Data Contract

The migration must not create, delete, or rewrite:

- `library/objectives/`
- `library/governance/objectives.md`

If either path exists, its files must be byte-identical before and after validation, generation, and
packaging. If absent, it must remain absent.

## Completion Contract

Completion requires:

- Plural source and all plural generated adapters present.
- Singular source and generated paths absent.
- Catalog, adapter manifest, and distribution manifest contain plural identity only.
- Feature 027 and tracked prompt artifacts contain no exact singular token.
- Skill/library validators, adapter correspondence, packaging, and full suite pass.
- `git diff --check` passes.
