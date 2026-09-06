# Contract: Agent Adapter Generation

This contract governs `tools/generate-agent-adapters.sh`: what it MUST produce for each of the 3
in-scope agents (FR-010), so that adding a 4th agent later only means extending this contract and
the generator, never editing files under `skills/` (FR-004).

## Per-agent target and transform

| `agent_id` | Target path pattern | Transform | Guarantee |
|---|---|---|---|
| `github-copilot` | `.github/skills/<id>/SKILL.md` | `identity-copy` | Byte-identical to `skills/<id>/SKILL.md`. |
| `claude-code` | `.claude/skills/<id>/SKILL.md` | `identity-copy` | Byte-identical to `skills/<id>/SKILL.md`. |
| `cursor` | `.cursor/rules/<id>.mdc` | `mdc-transform` | Deterministic re-encoding, see below. |

## `identity-copy` transform

The generator copies `skills/<id>/SKILL.md` verbatim to the target path. No field is renamed,
reordered, added, or removed. This is valid because both GitHub Copilot and Claude Code read
`SKILL.md` files using the same portable frontmatter subset defined in
`skill-frontmatter.schema.json`.

## `mdc-transform` transform (Cursor)

The generator MUST map the canonical frontmatter to Cursor's `.mdc` frontmatter schema
deterministically:

| Canonical field | Cursor field | Mapping rule |
|---|---|---|
| `description` | `description` | Copied verbatim. |
| (none — always agent-selected) | `alwaysApply` | MUST always be set to `false`. This suite never generates an always-applied Cursor rule; skills are agent-selected by description, matching the "Apply Intelligently" behavior. |
| (none) | `globs` | MUST be omitted, so the rule is included only when Cursor's Agent judges the `description` relevant — never auto-attached by file pattern, since canonical skills declare no file-glob applicability. |

The skill body (everything after the frontmatter) MUST be copied verbatim below the transformed
frontmatter block.

## Idempotency and drift detection

- Re-running `tools/generate-agent-adapters.sh` with unchanged `skills/` content MUST produce
  zero-diff output across all three target locations.
- The generator MUST refuse (non-zero exit, explicit error naming the file) to overwrite a target
  file that has been hand-edited outside the generator — detected by comparing the target file's
  content against what a fresh regeneration from its recorded `generated_from` skill/version
  would produce.
- Existing `speckit-*` folders under `.github/skills/` MUST NOT be read, written, or otherwise
  referenced by this generator.

## Failure handling

If any canonical skill fails `skill-frontmatter.schema.json` validation, the generator MUST skip
adapter generation entirely (no partial adapter set) and exit non-zero, naming the failing skill.
