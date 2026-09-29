# Contract: Codex Skill Output

Defines the Codex row of `.highway/tools/generate-agent-adapters.sh`. Behavior shared with the
existing three agents is not restated except where the Codex path differs.

## Row

The three arrays stay one line each:

```text
AGENT_IDS=(github-copilot claude-code cursor codex)
AGENT_TARGET_TEMPLATES=(".github/skills/%s/SKILL.md" ".claude/skills/%s/SKILL.md" ".cursor/skills/%s/SKILL.md" ".agents/skills/%s/SKILL.md")
AGENT_TRANSFORMS=(identity-copy identity-copy identity-copy identity-copy)
```

`<id>` is the skill directory name. The publisher adds no prefix and no extra file.

## File

`.agents/skills/<id>/SKILL.md` is a byte-for-byte copy of `.highway/skills/<id>/SKILL.md`.

The adapter manifest gains one row: path, skill id, version, sha256. The version is the same
value recorded for the other three copies of that skill.

## Refusal

A present Codex skill file with no adapter-manifest row, or whose hash differs from its row, is
named and left unchanged. That refusal writes no partial set for the run. The publisher does not
delete a Codex file when the source skill is removed.

## Boundaries

The publisher does not create, modify, or remove `speckit-*` files. It does not write `AGENTS.md`.
It does not write under a home directory. It does not read `compatibility` to skip a skill.

## Distribution and correspondence

Each Highway skill has an `include` row for `.agents/skills/<id>`. `.agents` stays excluded, so a
non-Highway neighbor is not shipped.

For every skill directory under `.highway/skills/`:

- `.agents/skills/<id>/SKILL.md` exists and matches the source.
- The adapter manifest has a row for that path.
- The distribution classifies `.agents/skills/<id>` as `include`.

A distribution include or an adapter-manifest row under `.agents/skills/` whose id has no source
directory is a failure.
