# Quickstart: Help Skill

Validation scenarios proving the feature works end-to-end. Run from the repository root.

## Prerequisites

- Bash (macOS default `/bin/bash`, 3.2.57, is sufficient — no newer bash required).
- `.highway/skills/help/SKILL.md` authored (registration fields: `name`, `description`,
  `usage`, `metadata.version`, `metadata.dependencies` if any; body sections including the new
  `## Example`).
- `.highway/tools/lib/schema-validate.sh` and `.highway/tools/generate-catalog.sh` updated per
  research.md R7/R4 (usage + `## Example` enforcement; `usage` carried into the catalog).

## 1. The new skill validates cleanly

```bash
.highway/tools/validate-skill.sh .highway/skills/help
```

**Expected**: exit 0, `OK: skill 'help' is valid (...)`, zero `ERROR:` lines.

## 2. Registration enforcement catches a missing field

```bash
.highway/tools/tests/run-all.sh
```

**Expected**: includes assertions (in `validate-skill.test.sh`) that a fixture skill missing
`usage` fails naming `usage`, and a fixture skill missing `## Example` fails naming
`'## Example'` — both exit non-zero. Full suite exit 0.

## 3. Catalog carries the new skill and the new field

```bash
.highway/tools/generate-catalog.sh
grep -A2 '"id": "help"' .highway/catalog/index.json
```

**Expected**: exit 0; the `help` entry's JSON block includes a non-empty `"usage"` value.

## 4. All three supported agents receive the skill

```bash
.highway/tools/generate-agent-adapters.sh
test -f .github/skills/help/SKILL.md && echo "github-copilot: OK"
test -f .claude/skills/help/SKILL.md && echo "claude-code: OK"
test -f .cursor/rules/help.mdc && echo "cursor: OK"
.highway/tools/generate-agent-adapters.sh   # re-run: must report no drift, not overwrite errors
```

**Expected**: all three `OK` lines print; both generator runs exit 0.

## 5. Single-Skill mode

Invoke the help skill with an existing skill's id (e.g. `help` itself):

```text
/help help
```

**Expected**: exactly six lines, in order — `Name:`, `Description:`, `Dependencies:`,
`Version:`, `Usage:`, `Example:` — per
[contracts/help-output-contract.md](./contracts/help-output-contract.md). `Dependencies:` reads
`none` if the `help` skill declares no `metadata.dependencies`.

## 6. Single-Skill mode: unrecognized identifier

```text
/help not-a-real-skill
```

**Expected**: a single `ERROR: no skill registered with id 'not-a-real-skill'` line; no
all-skills listing follows.

## 7. All-Skills mode

```text
/help
```

**Expected**: one `Name:`/`Usage:`/`Help:` block per entry in `catalog/index.json` (including
`help` itself), each `Help:` line reading `/help <id>`. Copying and running any one of those
`Help:` lines verbatim reproduces that skill's step-5 output.

## 8. All-Skills mode: zero skills registered (regression guard, not the shipped state)

Temporarily point at an empty skills directory (or verify by code inspection / a dedicated
test fixture, not by emptying the real `.highway/skills/`) and confirm the output is exactly
`No skills are registered yet.` — never an empty table.

## 9. Full suite, one more time

```bash
.highway/tools/tests/run-all.sh
```

**Expected**: exit 0, every test passes, including the updated
`generate-catalog.test.sh`/`generate-agent-adapters.test.sh`/`validate-skill.test.sh` assertions
from steps 2-4.
