# Quickstart: Validating the Highway Skill Namespace

Prerequisites: this feature's tooling change is implemented in
`.highway/tools/generate-agent-adapters.sh` per
[contracts/agent-adapter-contract.md](./contracts/agent-adapter-contract.md); the `help` skill
already exists at `.highway/skills/help/SKILL.md`.

## 1. Generate namespaced adapters

```sh
.highway/tools/generate-agent-adapters.sh
```

**Expected**: exit 0, and output lines naming the three new namespaced targets, e.g.
`Generated .github/skills/highway.help/SKILL.md (github-copilot, identity-copy)`.

## 2. Confirm the namespaced files exist and the old ones are gone

```sh
test -f .github/skills/highway.help/SKILL.md && echo "PRESENT: new github-copilot target"
test -f .claude/skills/highway.help/SKILL.md && echo "PRESENT: new claude-code target"
test -f .cursor/rules/highway.help.mdc && echo "PRESENT: new cursor target"
test ! -e .github/skills/help/SKILL.md && echo "ABSENT: old github-copilot target"
test ! -e .claude/skills/help/SKILL.md && echo "ABSENT: old claude-code target"
test ! -e .cursor/rules/help.mdc && echo "ABSENT: old cursor target"
```

**Expected**: all six lines print (SC-001, research.md R3).

## 3. Confirm the source and catalog are untouched

```sh
grep -q '^name: Help$' .highway/skills/help/SKILL.md && echo "unchanged source name field"
grep '"id"' .highway/catalog/index.json | grep -q '"help"' && echo "catalog id still bare 'help'"
```

**Expected**: both lines print — no `highway.` prefix leaks into source or catalog (FR-003,
FR-004).

## 4. Confirm the `speckit-*` skills are untouched

```sh
test -f .github/skills/speckit-tasks/SKILL.md && echo "speckit-tasks left in place, unprefixed"
```

**Expected**: line prints (FR-009).

## 5. Confirm idempotency (no drift on immediate re-run)

```sh
.highway/tools/generate-agent-adapters.sh
```

**Expected**: exit 0, no error about drift or refused overwrite, for every one of the three
namespaced targets (FR-006, SC-004).

## 6. Run the full test suite

```sh
.highway/tools/tests/run-all.sh
```

**Expected**: exit 0, same pass count as before this feature, no regression (FR-008, SC-003).
