# Quickstart: Validate Always-On Agent Instructions

Run these from the repository root after implementation. Contracts are in
[contracts/instruction-source-contract.md](./contracts/instruction-source-contract.md) and
[contracts/instruction-output-contract.md](./contracts/instruction-output-contract.md). The field
rules are in [data-model.md](./data-model.md).

## Prerequisites

- Bash and the repository's existing utilities. Nothing to install.
- `.highway/tools/tests/run-all.sh` exits 0 before the first edit (allow up to 240 seconds).

## 1. The first instruction is published

```sh
.highway/tools/generate-instructions.sh; echo "exit=$?"
```

Expect exit 0. Then:

```sh
# Body starts at the heading in every output.
for f in .highway/instructions/highway-agent-context.md \
         .cursor/rules/highway-agent-context.mdc \
         .claude/CLAUDE.md \
         .github/copilot-instructions.md; do
  grep -n '^# Highway Agent Context$' "$f"
done
cmp -s .claude/CLAUDE.md .github/copilot-instructions.md && echo MERGED-IDENTICAL
grep -c '^alwaysApply: true$' .cursor/rules/highway-agent-context.mdc    # 1
grep -c '^globs:' .cursor/rules/highway-agent-context.mdc                # 0
```

The heading line is present in all four files. The two merged files are identical. The Cursor file has `alwaysApply: true` and no `globs`.

Extract the body below the closing `---` of the source and of the Cursor file and `cmp` them. Both merged files `cmp` equal to that same body, because there is only one instruction.

## 2. A second run changes nothing

```sh
.highway/tools/generate-instructions.sh
git status --short .highway/instructions .cursor/rules .claude/CLAUDE.md .github/copilot-instructions.md .highway/tools/.instruction-manifest
```

Run the generator again and compare `git status`. Expect the same listing both times, and identical checksums of the three outputs.

## 3. Invalid source writes nothing

In a temporary copy of the tree, set `name` in the instruction to something other than `highway-agent-context`. Run the generator. Expect exit 1, the file named in the error, and no change to the three outputs or the manifest. Repeat with an added `alwaysApply` key and with an empty body.

## 4. Hand edit is refused

Append a line to `.claude/CLAUDE.md` in a temporary copy. Run the generator. Expect exit 1, that path named, and the appended line still present. Restore the file before any later step.

## 5. Skills and speckit files are untouched

```sh
for f in .cursor/skills/speckit-*/SKILL.md .github/skills/speckit-*/SKILL.md; do
  shasum -a 256 "$f"
done | sort > /tmp/098-speckit.txt
.highway/tools/generate-instructions.sh
for f in .cursor/skills/speckit-*/SKILL.md .github/skills/speckit-*/SKILL.md; do
  shasum -a 256 "$f"
done | sort | diff - /tmp/098-speckit.txt && echo SPECKIT-UNCHANGED
```

Also confirm `.highway/tools/.adapter-manifest` has no row beginning `.cursor/rules/`, and that `generate-agent-adapters.sh` does not modify `.claude/CLAUDE.md`, `.github/copilot-instructions.md`, or `.instruction-manifest`.

## 6. Tests

```sh
.highway/tools/tests/generate-instructions.test.sh
.highway/tools/tests/instruction-coverage.test.sh
.highway/tools/tests/generate-agent-adapters.test.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/distribution-packaging.test.sh
.highway/tools/tests/shipped-tree-independence.test.sh
```

Each exits 0. `generate-agent-adapters.test.sh` still fails a `highway-*.mdc` file that has no instruction-manifest row.

## 7. Distribution

```sh
D=$(mktemp -d)/dist
.highway/tools/generate-distribution.sh "$D"; echo "exit=$?"
cmp -s "$D/.claude/CLAUDE.md" .claude/CLAUDE.md && echo CLAUDE-SHIPPED
cmp -s "$D/.github/copilot-instructions.md" .github/copilot-instructions.md && echo COPILOT-SHIPPED
test -f "$D/.cursor/rules/highway-agent-context.mdc" && echo CURSOR-SHIPPED
find "$D" -path '*speckit-*' | wc -l    # 0
```

Expect exit 0 and all three verifications reported by the distribution script. The distribution contains no `speckit-*` path.

## 8. Seen on load

Open the repository in Cursor, Claude Code, and Copilot. Highway Agent Context is present without being attached: an always-applied Cursor rule, and the repository instruction file for the other two. This step is observed by a person.
