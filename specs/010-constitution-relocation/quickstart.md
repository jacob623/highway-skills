# Quickstart: Constitution Relocation and Shipped-Tree Independence

Validation scenarios for this feature. Run from the repository root.

## Prerequisites

- `.specify/memory/constitution.md` exists and holds the Highway Skills Constitution v2.0.1.
- `.highway/governance/` does not exist.
- `.highway/tools/tests/run-all.sh` exits 0.
- `.highway/skills/highway-help/SKILL.md` is at version `3.0.0`.

## Scenario 1: The constitution is reachable at its new location

```bash
test -f .highway/governance/constitution.md && echo "PRESENT: relocated"
grep -c '^| P[0-9]' .highway/governance/constitution.md
```

Confirm: the file exists, and the rule count matches the pre-move document. No rule text changed.

## Scenario 2: Validation resolves the constitution without an override

```bash
unset CONSTITUTION_FILE
.highway/tools/validate-skill.sh .highway/skills/highway-help
echo "exit=$?"
```

Confirm: exit 0, with the same verdict groups reported before the move. No `CONSTITUTION_FILE`
was set, so the new fallback was used.

## Scenario 3: Validation succeeds with development directories absent

This is the defect the feature exists to fix. Before the change, this scenario fails.

```bash
tmp="$(mktemp -d)"
cp -R .highway "$tmp/.highway"
cd "$tmp" && .highway/tools/validate-skill.sh .highway/skills/highway-help
echo "exit=$?"
```

Confirm: exit 0. No `.specify/` and no `specs/` directory exists in the copied tree, and the
validator still resolves its governance document.

## Scenario 4: The override still takes precedence

```bash
CONSTITUTION_FILE=/nonexistent/path.md .highway/tools/validate-skill.sh .highway/skills/highway-help
echo "exit=$?"
```

Confirm: non-zero, failing on the overridden path rather than silently falling back. The override
branch is still evaluated first.

## Scenario 5: No distributed file references a development location

```bash
grep -rn "specs/\|\.specify" \
  .highway/ \
  .github/skills/highway-* \
  .claude/skills/highway-* \
  .cursor/rules/highway-* \
  | grep -v 'shipped-tree-independence.test.sh'
```

Confirm: no output. The single exclusion is the check itself, which necessarily contains the
strings it searches for.

## Scenario 6: Provenance survives in name-only form

```bash
grep -rn "feature [0-9][0-9][0-9] (" .highway/tools/ .highway/catalog/ .highway/skills/ | head
```

Confirm: design records are still cited, in the form `feature NNN (short-name)`, with no path and
no link. Spot-check that the form is identical across files.

## Scenario 7: The check detects a deliberately seeded violation

```bash
printf '\n# see specs/001-multi-agent-skill-suite/spec.md\n' >> .highway/catalog/README.md
.highway/tools/tests/shipped-tree-independence.test.sh
echo "exit=$?"
git checkout .highway/catalog/README.md
```

Confirm: non-zero exit, and the output names `.highway/catalog/README.md` with a line number and
the matched text. Then confirm the file is restored.

## Scenario 8: A development artifact is not flagged

```bash
.highway/tools/tests/shipped-tree-independence.test.sh
echo "exit=$?"
```

Confirm: exit 0, even though `governance-plan.md`, `specs/`, and `.specify/memory/constitution.md`
all contain the prohibited tokens. They are development artifacts and outside the declared path
set.

## Scenario 9: The placeholder keeps the development workflow usable

```bash
test -f .specify/memory/constitution.md && echo "PRESENT: placeholder"
grep -c '^| P[0-9]' .specify/memory/constitution.md
```

Confirm: the file exists, and the rule count is zero. It records the relocation and states no
rule, so nothing can cite it by accident.

## Scenario 10: Generated artifacts are current and correct

```bash
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
git diff --stat .highway/catalog .github/skills/highway-help .claude/skills/highway-help .cursor/rules/highway-help.mdc
```

Confirm: no diff. Every generated copy already carries the corrected references and version
`3.0.1`, proving the generators were run after the source edits rather than before.

## Scenario 11: Full regression

```bash
.highway/tools/tests/run-all.sh
```

Confirm: every test passes, with no test removed or weakened. The suite now includes
`shipped-tree-independence.test.sh`.

## Scenario 12: The help skill's behaviour is unchanged

Request the help skill's own registration details and confirm the six-field output is identical to
before this feature, except that `Version:` reads `3.0.1`.

Confirm: no field is added, removed, or reordered, and no value other than the version differs.
This is what makes the increment a PATCH rather than a MAJOR.
