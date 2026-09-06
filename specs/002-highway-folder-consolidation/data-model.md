# Phase 1 Data Model: Consolidate Skill Suite Support Files into `.highway/`

This feature relocates directories rather than introducing new runtime data entities. The
"entities" below are the path/location concepts the relocated tooling and documentation must
agree on.

## Entity: Relocation Mapping

The fixed, explicit old→new path mapping this feature performs. Deterministic and total — every
row is either moved or explicitly marked unchanged; there are no ambiguous or partial mappings.

| Old path | New path | Change |
|---|---|---|
| `skills/` | `.highway/skills/` | Moved, contents unchanged |
| `tools/` | `.highway/tools/` | Moved, contents unchanged except path-resolution logic (see `HIGHWAY_ROOT` below) |
| `catalog/` | `.highway/catalog/` | Moved, contents unchanged |
| `tools/.adapter-manifest` | `.highway/tools/.adapter-manifest` | Moved, format and recorded (`REPO_ROOT`-relative) paths unchanged |
| `.github/skills/<id>/SKILL.md` | *(unchanged)* | Not moved — agent-facing adapter output |
| `.claude/skills/<id>/SKILL.md` | *(unchanged)* | Not moved — agent-facing adapter output |
| `.cursor/rules/<id>.mdc` | *(unchanged)* | Not moved — agent-facing adapter output |
| `.specify/` | *(unchanged)* | Not moved — spec-kit's own fixed-path scaffolding |
| `specs/` | *(unchanged)* | Not moved — spec-kit's own fixed-path scaffolding |
| `README.md` (root) | *(unchanged location)* | Content updated (internal links only), file itself stays at repo root |

## Entity: Root Variables (tooling concept)

Introduced by Decision 1 in research.md. Every script under `.highway/tools/` MUST resolve both:

- **`HIGHWAY_ROOT`**: the `.highway/` directory. Used as the base for reading skill sources
  (`$HIGHWAY_ROOT/skills`), reading/writing the catalog (`$HIGHWAY_ROOT/catalog`), and
  reading/writing the drift-detection manifest (`$HIGHWAY_ROOT/tools/.adapter-manifest`).
- **`REPO_ROOT`**: the true repository root (`$HIGHWAY_ROOT/..`). Used as the base for the three
  agent adapter target paths only (`.github/skills/`, `.claude/skills/`, `.cursor/rules/`).

Validation rule: any path expression in `.highway/tools/*.sh` that targets `.github/`,
`.claude/`, or `.cursor/` MUST be rooted at `REPO_ROOT`; every other path expression MUST be
rooted at `HIGHWAY_ROOT`. A script that mixes these up either fails to find its own skill
sources or writes agent adapters to a nonexistent nested path — both are caught by the existing
test suite (relocated, per FR-007) and by the quickstart walkthrough.

## Entity: Documentation Reference

A (file, old-path-substring) pair that must be updated to its `.highway/`-relative equivalent.
Tracked here so the migration can be verified exhaustively (SC-004):

| File | References to update |
|---|---|
| `README.md` (root) | Links to `skills/_authoring-standard.md`, `tools/README.md`, `tools/generate-catalog.sh`, `tools/generate-agent-adapters.sh`, `tools/tests/run-all.sh` |
| `.highway/tools/README.md` | Any self-referential paths under `tools/`, `skills/`, `catalog/` |
| `.highway/catalog/README.md` | Any self-referential paths under `catalog/`, `skills/` |
| `.highway/skills/_authoring-standard.md` | Any self-referential paths under `skills/`, `tools/`, `catalog/` |

`specs/001-multi-agent-skill-suite/*` is excluded from this table per research.md Decision 4
(left as an unmodified historical record).
