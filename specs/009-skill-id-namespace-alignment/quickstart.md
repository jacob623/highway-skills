# Quickstart: Skill Id Namespace Alignment

Validation scenarios for this feature. Run from repo root.

## Prerequisites

- `.highway/skills/help/SKILL.md` exists (pre-migration state) with `name: Help`,
  `metadata.version: 2.0.0`.
- `.highway/catalog/index.json` and the three generated adapters
  (`.github/skills/highway-help/SKILL.md`, `.claude/skills/highway-help/SKILL.md`,
  `.cursor/rules/highway-help.mdc`) exist, per specs/008.

## Scenario 1: Canonical directory renamed and re-validates

```bash
git mv .highway/skills/help .highway/skills/highway-help
.highway/tools/validate-skill.sh .highway/skills/highway-help
```

Confirm: exit 0 (once `name` is also updated per Scenario 2 — run after that edit); no output
referencing `.highway/skills/help` remains reachable (`test ! -d .highway/skills/help`).

## Scenario 2: Frontmatter `name` matches the new id

```bash
grep '^name:' .highway/skills/highway-help/SKILL.md
```

Confirm: `name: highway-help`, exactly matching the directory basename.

## Scenario 3: Validator rejects a mismatch

Temporarily edit `.highway/skills/highway-help/SKILL.md`'s frontmatter to `name: Help` (the old
value) and run:

```bash
.highway/tools/validate-skill.sh .highway/skills/highway-help
```

Confirm: exit 1, output contains `ERROR: [SCHEMA] frontmatter 'name' ('Help') does not match
directory-derived id 'highway-help'`. Revert the temporary edit afterward.

## Scenario 4: Catalog and adapters regenerate to the same paths, updated content

```bash
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
```

Confirm:
- `.highway/catalog/index.json` contains `"id": "highway-help"`, `"name": "highway-help"`,
  `"source_path": "skills/highway-help/SKILL.md"`, `"version": "3.0.0"`.
- `.github/skills/highway-help/SKILL.md`, `.claude/skills/highway-help/SKILL.md`,
  `.cursor/rules/highway-help.mdc` still exist at these exact paths (no move, no new/removed
  file) — `test -f .github/skills/highway-help/SKILL.md && echo "PRESENT: unchanged path"`.
- Their content reflects the renamed source (`name: highway-help`, updated `## Example`).

## Scenario 5: Self-invocation uses the fully-namespaced id

Request the `highway-help` skill's own registration details (declared identifier =
`highway-help`) and confirm the Single-Skill mode success shape:

```text
Name: highway-help
Description: Prints registration details for one named skill, or a discovery listing of every registered skill when none is named.
Dependencies: none
Version: 3.0.0
Usage: Invoke as `/highway-help` for all skills, or `/highway-help <skill-id>` for one named skill's registration details.
Example: `/highway-help highway-help`
```

Then request the declared identifier `help` (the old, pre-migration bare id) and confirm the
error shape:

```text
ERROR: no skill registered with id 'help'
```

## Scenario 6: All-Skills listing shows the fully-namespaced `Help:` line

Request help with no identifier declared and confirm the block for `highway-help` reads:

```text
Name: highway-help
Usage: Invoke as `/highway-help` for all skills, or `/highway-help <skill-id>` for one named skill's registration details.
Help: /highway-help highway-help
```

## Scenario 7: Full regression suite passes

```bash
.highway/tools/tests/run-all.sh
```

Confirm: all tests pass, including `validate-skill.test.sh`, `generate-agent-adapters.test.sh`,
`new-agent-extensibility.test.sh`, `generate-catalog.test.sh`, `authoring-standard.test.sh`,
`coverage-summary.test.sh`, `path-integrity.test.sh` (each updated, where it referenced the old
`help`/bare-id path or the old `Name:`/`Help:`/`Example:` values, to the new
`highway-help`/fully-namespaced forms).

## Scenario 8: `_authoring-standard.md` states the rule as mandatory

```bash
grep -A1 '^| `name`' .highway/skills/_authoring-standard.md
```

Confirm: the row states `name` MUST match the directory-derived id exactly, not "free-form ...
never required to match".
