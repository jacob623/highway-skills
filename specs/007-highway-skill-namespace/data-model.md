# Data Model: Highway Skill Namespace

This feature adds no new persisted entity and no new field to any existing entity. It changes
only the destination *path* used when materializing one already-existing entity. Entities below
are documented for completeness, cross-referencing spec.md's Key Entities section.

## Skill (source)

- **Location**: `.highway/skills/<id>/SKILL.md`.
- **Fields relevant here**: `<id>` (directory name, kebab-case, e.g. `help`).
- **Change in this feature**: None. `<id>` and the file's frontmatter/body are byte-for-byte
  unaffected (FR-004).

## Catalog Entry

- **Location**: `.highway/catalog/index.json`, one entry per skill.
- **Fields relevant here**: `id`, `source_path`.
- **Change in this feature**: None (FR-003). Both fields remain the plain, unprefixed,
  directory-derived id.

## Generated Adapter Artifact

- **Produced by**: `.highway/tools/generate-agent-adapters.sh`, one per (skill, agent) pair.
- **Fields/attributes**:
  | Attribute | Before this feature | After this feature |
  |---|---|---|
  | `agent_id` | `github-copilot` \| `claude-code` \| `cursor` | unchanged |
  | target path (github-copilot) | `.github/skills/<id>/SKILL.md` | `.github/skills/highway.<id>/SKILL.md` |
  | target path (claude-code) | `.claude/skills/<id>/SKILL.md` | `.claude/skills/highway.<id>/SKILL.md` |
  | target path (cursor) | `.cursor/rules/<id>.mdc` | `.cursor/rules/highway.<id>.mdc` |
  | file content (github-copilot, claude-code) | byte-identical copy of source `SKILL.md` | unchanged: still byte-identical copy |
  | file content (cursor) | `description` + `alwaysApply: false` + body | unchanged transform |
  | manifest key (`.highway/tools/.adapter-manifest` row 1) | old rel_path | new rel_path (old row pruned, per research.md R3) |
- **Relationships**: One Skill (source) produces exactly 3 Generated Adapter Artifacts (one per
  `agent_id`), each keyed in the manifest by its own target rel_path.
- **Validation rules**: Same as before — every artifact must validate against
  `validate-skill.sh` pre-generation (unchanged, FR-003); drift detection (`check_no_drift`)
  still guards every write, now also guarding the new stale-old-path removal step (research.md
  R3).
- **State transition**: `<id>`-named artifact (pre-feature) → removed, replaced by
  `highway.<id>`-named artifact (post-feature), on the first `generate-agent-adapters.sh` run
  after this feature ships. No intermediate state; the transition is atomic per (skill, agent)
  pair within one script invocation.
