# Quickstart: Validate Codex Support

Run these from the repository root after implementation. The skill file shape is in
[contracts/codex-skill-contract.md](./contracts/codex-skill-contract.md). The guidance file shape
is in [contracts/codex-guidance-contract.md](./contracts/codex-guidance-contract.md). Field rules
are in [data-model.md](./data-model.md).

## Prerequisites

- Bash and the repository's existing utilities. Nothing to install.
- `.highway/tools/tests/run-all.sh` exits 0 before the first edit (allow up to 240 seconds).

## 1. Codex skills match the canonical skills

```sh
.highway/tools/generate-agent-adapters.sh; echo "exit=$?"
```

Expect exit 0. Then, for each id under `.highway/skills/`:

```sh
cmp -s ".highway/skills/$id/SKILL.md" ".agents/skills/$id/SKILL.md" && echo "$id"
```

Expect one line per Highway skill, 12 lines. No path under `.agents/skills/` contains `speckit-`.
A second run leaves `git status` for `.agents/skills` and `.highway/tools/.adapter-manifest`
unchanged apart from row order that sorts to the same rows.

## 2. Repository guidance matches the other agents

```sh
.highway/tools/generate-instructions.sh; echo "exit=$?"
cmp -s AGENTS.md .claude/CLAUDE.md && echo AGENTS-MATCHES-CLAUDE
cmp -s AGENTS.md .github/copilot-instructions.md && echo AGENTS-MATCHES-COPILOT
grep -n '^# Highway Agent Context$' AGENTS.md
```

Expect exit 0, both comparisons, and the heading. Run the publisher again and expect the same
`git status` for `AGENTS.md` and `.highway/tools/.instruction-manifest`.

## 3. A hand edit is refused

In a temporary copy, append a line to `.agents/skills/highway-help/SKILL.md` and run
`generate-agent-adapters.sh`. Expect exit 1, that path named, and the line still present.

In a temporary copy, append a line to `AGENTS.md` and run `generate-instructions.sh`. Expect
exit 1, `AGENTS.md` named, and the line still present.

## 4. Existing skills and speckit files are untouched

Confirm no file under `.highway/skills/` differs from its pre-change bytes except
`.highway/skills/_authoring-standard.md`, whose compatibility list now includes `codex`.
Checksums of `.cursor/skills/speckit-*/SKILL.md` and `.github/skills/speckit-*/SKILL.md` are
unchanged by both publishers.

## 5. Tests

```sh
.highway/tools/tests/generate-agent-adapters.test.sh
.highway/tools/tests/new-agent-extensibility.test.sh
.highway/tools/tests/generate-instructions.test.sh
.highway/tools/tests/instruction-coverage.test.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/highway-new.test.sh
.highway/tools/tests/distribution-packaging.test.sh
.highway/tools/tests/shipped-tree-independence.test.sh
```

Each exits 0.

## 6. Distribution

```sh
D=$(mktemp -d)/dist
.highway/tools/generate-distribution.sh "$D"; echo "exit=$?"
test -d "$D/.agents/skills/highway-help" && echo CODEX-SKILL-SHIPPED
cmp -s "$D/AGENTS.md" AGENTS.md && echo AGENTS-SHIPPED
find "$D" -path '*speckit-*' | wc -l    # 0
```

Expect exit 0 and the distribution script's existing verifications. The distribution contains no
`speckit-*` path.

## 7. Seen in Codex

Open the repository in Codex. Highway Agent Context is present from `AGENTS.md` without a skill
being attached, and the Highway skills appear as Codex skills. This step is observed by a person.
If Cursor also shows that guidance from `AGENTS.md` as well as from its rule, record the
observation. It does not fail this feature.
