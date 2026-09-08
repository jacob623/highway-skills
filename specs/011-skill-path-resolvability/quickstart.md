# Quickstart: Skill Path Resolvability Rule

Validation scenarios for this feature. Run from the repository root.

## Prerequisites

- `.highway/governance/constitution.md` exists at version `2.0.1` with rules `P1.1`–`P8.6`.
- `.highway/tools/tests/run-all.sh` exits 0.
- No skill contains a Markdown link.
- The constitution's change report carries four follow-up entries.

## Scenario 1: The rule exists and is well formed

```bash
grep -n '^| P8.7 |' .highway/governance/constitution.md
```

Confirm: one row, carrying a rule, an Observable, and a tier tag, in the same shape as its
siblings. Confirm it names no location that exists only during development.

## Scenario 2: The amendment is recorded and classified

```bash
grep -n '^\*\*Version\*\*' .highway/governance/constitution.md
sed -n '1,60p' .highway/governance/constitution.md | grep -n -i 'P8.7\|version change'
```

Confirm: the version has incremented by one minor step from `2.0.1`, and the change report names
`P8.7` as added with the classification reasoning. Confirm the reasoning cites the versioning
policy rather than a previous amendment.

## Scenario 3: The check is registered and dispatched

```bash
grep -n 'P8.7' .highway/tools/lib/rule-checks.sh
.highway/tools/validate-skill.sh .highway/skills/highway-help | grep -E '^(CHECKED|FAILED)'
```

Confirm: a registry row and a check function exist, and `P8.7` appears in the `CHECKED` group of
the validator's output — not in `UNCHECKED`, and not absent.

## Scenario 4: A relative link fails, naming what failed

```bash
.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/invalid-skill-relative-link
echo "exit=$?"
```

Confirm: exit 1; the output names `P8.7`, the offending target, and its location; and the failure
count is exactly one, so no unrelated rule was tripped by the fixture.

## Scenario 5: A command example does not fail

```bash
.highway/tools/validate-skill.sh .highway/skills/highway-help
echo "exit=$?"
```

Confirm: exit 0. That skill's body contains several command examples naming paths. None is treated
as a reference.

## Scenario 6: An absolute URL is permitted

Temporarily add `[spec](https://example.org/spec)` to a fixture body, validate, and remove it.

Confirm: no `P8.7` failure. An absolute URL resolves identically from every location a skill is
read.

## Scenario 7: No existing verdict changed

```bash
for f in .highway/tools/tests/fixtures/*/; do
  printf '%s ' "$(basename "$f")"
  .highway/tools/validate-skill.sh "$f" >/dev/null 2>&1 && echo "exit=0" || echo "exit=1"
done
```

Confirm: every fixture's exit status matches its status before this feature, and every fixture
expected to produce exactly one failure still produces exactly one. This is the check required
before the new check is enabled.

## Scenario 8: The author can read the rule

```bash
grep -n 'P8.7' .highway/skills/_authoring-standard.md
```

Confirm: the standard makes the constraint discoverable and cites `P8.7` by identifier. Confirm it
restates no rule text — the sentence in the constitution appears nowhere in the standard.

## Scenario 9: The rule is reachable from the front page

```bash
grep -n -i 'governance\|constitution' README.md
```

Confirm: a section names and links both the constitution and the authoring standard, and both
links resolve.

## Scenario 10: The follow-up list describes only outstanding work

```bash
grep -n 'TODO(' .highway/governance/constitution.md
```

Confirm: exactly one entry remains, for automatic-tier enforcement. Confirm the change report
records, for each removed entry, the evidence that its work was already complete.

## Scenario 11: The rule does not restate an existing one

Read `P8.7` and the development constitution's rule on documentation cross-references side by side.

Confirm: neither reproduces the other's sentence, and each names an artifact class the other does
not — one governs a document that exists in one place, the other a skill that exists in four.

## Scenario 12: Full regression

```bash
.highway/tools/tests/run-all.sh
```

Confirm: every test passes, with no test removed or weakened, including the new fixture assertions
and the seeded `P8.7` case in the rule-check test.

## Scenario 13: Nothing was regenerated

```bash
git status --short .highway/catalog .github/skills .claude/skills .cursor/rules
```

Confirm: no output. No skill content changed, so no catalog entry, adapter, or manifest row should
differ.
