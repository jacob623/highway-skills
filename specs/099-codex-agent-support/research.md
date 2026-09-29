# Research: Add Codex as a Supported Agent

Decisions for [spec.md](./spec.md). Codex product locations were checked against
[Codex customization](https://developers.openai.com/codex/concepts/customization) on 2026-09-29.

## 1. Skill path and transform

**Decision**: Agent id `codex`. Target `.agents/skills/%s/SKILL.md`. Transform `identity-copy`.

**Rationale**: Codex discovers repository skills in `.agents/skills` and reads `name` and
`description` from `SKILL.md`. Highway skills already have that shape. The other three agents
already receive an identity copy, and the spec requires the Codex file to match them.

**Alternatives considered**: `.codex/skills/` appears in older third-party guides and is not the
repository location in the current Codex documentation. A Codex-specific transform, or an
`agents/openai.yaml` beside each skill, would make the Codex file differ from the canonical skill.

## 2. Where the agent row is added

**Decision**: Append `codex` to the three one-line arrays in
`.highway/tools/generate-agent-adapters.sh`: `AGENT_IDS`, `AGENT_TARGET_TEMPLATES`,
`AGENT_TRANSFORMS`.

**Rationale**: `new-agent-extensibility.test.sh` rewrites each array with a single `sed`
substitution that matches one line. A wrapped line would make that test fail and would hide a
real fourth-agent row.

**Alternatives considered**: A separate Codex publisher. That duplicates drift refusal, the
manifest, and validation that the skill publisher already performs.

## 3. Repository guidance

**Decision**: `generate-instructions.sh` writes the merged-body bytes to `AGENTS.md` at the
repository root, in addition to `.claude/CLAUDE.md` and `.github/copilot-instructions.md`. The
instruction-manifest row uses the same id field as those two files: the comma-joined source ids
in filename order, or `-` when there are no instructions. Zero instructions write one newline.
Drift refusal matches the other merged files. The publisher does not delete Codex skill files.

**Rationale**: Codex loads `AGENTS.md` before work starts. The spec requires those bytes to match
the guidance Claude Code and Copilot already load. Authors keep one instruction source.

**Alternatives considered**: A Codex-specific heading or frontmatter wrapper. That would make
`AGENTS.md` differ from the other merged files. Nested `AGENTS.md` files are out of scope; Codex
uses the root file for repository-wide guidance.

## 4. Distribution

**Decision**: `exclude` `.agents`. `include` `.agents/skills/highway-<id>` for each of the 12
Highway skills already included for the other agents:
`highway-objectives`, `highway-help`, `highway-controls`, `highway-inquiry`, `highway-nfrs`,
`highway-profile`, `highway-relationships`, `highway-setup`, `highway-new`, `highway-discovery`,
`highway-clarify`, `highway-adr`. `include` `AGENTS.md`. Do not include the whole `.agents` tree.

**Rationale**: An unclassified path fails packaging. The exclude-then-include pattern is how
`.github`, `.claude`, and `.cursor` keep `speckit-*` and hand-written neighbors out while the
Highway copies ship.

**Alternatives considered**: Including `.agents/skills` as a directory. That would ship any
non-Highway skill later placed beside the generated ones.

## 5. Compatibility token

**Decision**: Add `codex` to the `compatibility` enum in `.highway/tools/.frontmatter-contract`
and to the same list in `.highway/skills/_authoring-standard.md`. Do not edit any `SKILL.md`.
Publishing does not filter on the compatibility value.

**Rationale**: Every current skill says `all`, which already means every supported agent. The
validator reads the enum from the frontmatter contract. The authoring standard is the live
document that lists the same values. Filtering would be a new behavior the other three agents do
not have.

**Alternatives considered**: Leaving the enum unchanged. Then `compatibility: codex` would be
rejected, and the supported-agent name would exist only as a generated directory.

## 6. Correspondence

**Decision**: In `adapter-coverage.test.sh`, add `.agents/skills/$id` and
`.agents/skills/$id/SKILL.md` beside the three existing adapter paths. Recognize
`.agents/skills/*` when a distribution include is checked for an orphan skill, and recognize
`.agents/*` when an adapter-manifest path is checked on disk. Extend fixture cleanup in
`generate-agent-adapters.test.sh`, `new-agent-extensibility.test.sh`, and `run-all.sh` so a
temporary skill does not leave `.agents/skills/test-*` behind.

**Rationale**: D4.5 and D4.6 are enforced by those path lists. A fourth declared tree that the
test does not name would ship without being checked, or a fixture row would fail the next run.

**Alternatives considered**: A separate Codex coverage test. The existing test is already the
D4.5 and D4.6 enforcement, and a second test would drift from it.

## 7. Constitution amendment

**Decision**: MINOR, 2.1.0 → 2.2.0. Add `codex` to the declared agent trees. The sync impact
report lists the version line, the last-amended date, and that sentence. Do not edit D4.5 or
D4.6 rule text. Generate the Codex copies before that sentence is treated as enabled.

**Rationale**: The obligation is unchanged: every skill has an adapter in each declared tree.
The tree list gains a name. The copies that satisfy the new name are in the same change, which
is the condition this constitution has used to keep an amendment MINOR.

**Alternatives considered**: MAJOR, on the theory that yesterday's tree lacks Codex adapters.
That tree is not the tree in which the sentence is enabled.

## 8. Cursor overlap

**Decision**: Keep `AGENTS.md` at the repository root. Do not suppress it when Cursor is also a
supported agent. A person records whether Cursor shows Highway Agent Context from both its rule
and `AGENTS.md`. That observation does not fail the publish.

**Rationale**: The root file is the location Codex documents. The text is the same guidance the
Cursor rule already carries.

**Alternatives considered**: Writing Codex guidance under `.agents/` only. Codex would not load
that path as repository guidance.
