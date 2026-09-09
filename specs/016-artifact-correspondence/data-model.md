# Data Model: Generated Artifact Correspondence

**Feature**: 016-artifact-correspondence | **Date**: 2026-09-08

This feature introduces no persistent data. The entities below are the artifacts the checks read
and the relationships they assert between them.

## Entities

### Skill source

The authority on which skills exist. Everything else is derived from it.

| Field | Source | Notes |
|---|---|---|
| `id` | directory name under `.highway/skills/` | The join key for every relationship below |
| `description` | `SKILL.md` frontmatter | Copied into the catalog; the field that went stale in the case D4.7 covers |
| `version` | `SKILL.md` frontmatter | Copied into the catalog and the adapter manifest |

A directory counts as a skill only if it contains `SKILL.md`. `_authoring-standard.md` sits
alongside the skill directories and is a file, so it is naturally excluded.

### Catalog entry

One record per skill in `.highway/catalog/index.json`, with a rendered twin in `index.md`.
Generated. Carries `generated_at`, which is excluded from every comparison.

### Library catalog entry

One record per library artifact in `.highway/catalog/library-index.json`. Generated. **Not
per-skill** — it indexes templates, not skills — so it participates in D4.7 currency but not in the
D4.5/D4.6 per-skill correspondences.

### Agent adapter

One file per skill per declared agent tree:

| Agent | Path template |
|---|---|
| `github-copilot` | `.github/skills/<id>/SKILL.md` |
| `claude-code` | `.claude/skills/<id>/SKILL.md` |
| `cursor` | `.cursor/rules/<id>.mdc` |

Generated, and never pruned — the reason a removed skill leaves orphans.

### Adapter manifest row

One row per generated adapter in `.highway/tools/.adapter-manifest`, recording path, skill id,
version, and content hash. Contains fixture rows under `.mock-agent-4/` left by
`new-agent-extensibility.test.sh`, and its row order is not stable across a suite run.

Participates in **D4.6** by the skill id it names. Excluded from **D4.7** byte comparison.

### Distribution manifest row

One row per path in `.highway/tools/.distribution-manifest`, classifying it `include` or
`exclude`. **Hand-maintained**, not generated — so no regeneration keeps it current, and it can
only be reached by a correspondence obligation.

## Relationships the checks assert

```text
                        ┌──────────────────┐
                        │   Skill source   │  ← the authority
                        │  .highway/skills │
                        └────────┬─────────┘
                                 │
        ┌────────────┬───────────┼────────────┬──────────────┐
        ▼            ▼           ▼            ▼              ▼
  Catalog entry  Adapter ×3  Adapter     Distribution   Library catalog
                             manifest    manifest row   (not per-skill)
                             row

  D4.5: source → artifact must exist        (missing artifact = invisible skill)
  D4.6: artifact → source must exist        (missing source  = shipped ghost)
  D4.7: artifact content = regenerated      (stale content   = silent misinformation)
```

### Cardinality

| Relationship | Expected | Failure if violated |
|---|---|---|
| skill → catalog entry | exactly 1 | D4.5 |
| skill → adapter | exactly 3, one per declared tree | D4.5 |
| skill → distribution row | exactly 3, one per adapter, all `include` | D4.5 |
| catalog entry → skill | exactly 1 | D4.6 |
| adapter file → skill | exactly 1 | D4.6 |
| adapter manifest row → skill | ≥ 1 | D4.6 |
| distribution row → skill | ≥ 1 | D4.6 |

## Derived values, not stored

| Value | Derivation |
|---|---|
| Set of skills | `basename` of each directory under `.highway/skills/` containing `SKILL.md` |
| Expected adapter paths | skill id substituted into the three path templates |
| Currency verdict | regenerate into a temp tree, compare ignoring `generated_at` |

Nothing here is written to disk by the checks. The only file this feature modifies outside the
test and the constitution is the library catalog, and that is a one-time repair rather than an
ongoing behaviour.

## Excluded from comparison

| Item | Why |
|---|---|
| `generated_at` in either catalog | Written fresh on every run; D4.2 already carries this exception |
| `.adapter-manifest` byte content | Fixture rows plus unstable ordering; integrity owned by D4.3 |
| `.mock-agent-4/` paths | Test fixtures, not a declared agent tree |
| The distribution output tree | Written outside the repository; no committed artifact to compare |
