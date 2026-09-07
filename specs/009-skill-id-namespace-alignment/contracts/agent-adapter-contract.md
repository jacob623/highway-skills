# Agent Adapter Contract (Namespace-at-Source)

**Supersedes**: `specs/008-help-output-namespacing/contracts/agent-adapter-contract.md` and
`specs/007-highway-skill-namespace/contracts/agent-adapter-contract.md`, for the target-path
template construction and the stale-artifact-removal mechanism only. The `identity-copy` /
`mdc-transform` transform semantics, the manifest-based drift-safety mechanism
(`check_no_drift`, hand-edit refusal), and the "no partial adapter set on any validation failure"
guarantee are carried forward unchanged and re-stated here for a single authoritative reference.

Defines what `.highway/tools/generate-agent-adapters.sh` MUST produce once a skill's own
directory name is already the full, agent-facing identifier (this feature), rather than a bare
id requiring prefix injection (specs/007/008's approach).

## Target path construction

- Each agent's target path template MUST resolve to `<agent-root>/<id>/SKILL.md` (or
  `<agent-root>/<id>.mdc` for Cursor), where `<id>` is the skill's own directory name, taken
  as-is — **no static namespace prefix is injected by the template**.
- `AGENT_TARGET_TEMPLATES` MUST read:
  - `.github/skills/%s/SKILL.md`
  - `.claude/skills/%s/SKILL.md`
  - `.cursor/rules/%s.mdc`
- For the `highway-help` skill, this resolves to `.github/skills/highway-help/SKILL.md`,
  `.claude/skills/highway-help/SKILL.md`, `.cursor/rules/highway-help.mdc` — byte-identical to
  the paths specs/008 already produced (research.md R2), since the id itself now carries the
  `highway-` segment the template used to inject.

## Retired mechanism

- `AGENT_OLD_TARGET_TEMPLATES` and the `check_stale_removable` / `remove_stale_target` functions
  (added by specs/008 to clean up specs/007's dot-separated duplicates) are removed. No call
  site in `generate-agent-adapters.sh` references them. Rationale: research.md R3 — that cleanup
  already completed and confirmed zero dot artifacts remain; this feature introduces no new path
  shape requiring an equivalent cleanup pass.

## Carried forward unchanged

- **Transforms**: `identity-copy` (github-copilot, claude-code) copies the skill's `SKILL.md`
  byte-for-byte. `mdc-transform` (cursor) emits frontmatter containing only `description`
  (verbatim) and `alwaysApply: false`, with the body copied verbatim beneath it.
- **Drift safety**: `check_no_drift` refuses to overwrite a target whose current hash does not
  match the last-recorded hash in `.highway/tools/.adapter-manifest`, naming the file and
  instructing manual resolution. Unchanged.
- **All-or-nothing validation**: every skill under `.highway/skills/` is validated before any
  adapter is written; one invalid skill (including a `name`/id mismatch, per
  skill-authoring-contract.md) aborts generation for all skills, with no partial adapter set
  written. Unchanged.
- **Manifest**: `.highway/tools/.adapter-manifest` continues to record `rel_path`, `skill_id`,
  `skill_version`, and content hash per generated target, one row per target, latest write wins.
  Only the `skill_id` column's value changes (from `help` to `highway-help`) on the next
  generation run after this feature's migration — the `rel_path` values do not change (R2).
