# Quickstart: Harness Failure Resolutions

## Prerequisites

- Run from the repository root.
- Node: `/Applications/Cursor.app/Contents/Resources/app/resources/helpers/node`, or Node 24.
- `harness/node_modules` is installed.
- `harness/.env` holds the Copilot token. Never print it.

## Static checks

```bash
bash tests/harness-failure-resolutions.test.sh      # skill text (contracts/skill-text.md)
bash tests/code-project.test.sh                     # record check rule 2
bash tests/skill-flow-pattern.test.sh               # router and flow pattern still hold
bash tests/run-all.sh                               # full suite: 86 tests
(cd harness && node --test "test/*.test.ts" && npx tsc -p tsconfig.json)
```

Expected: every check passes. The new test fails before the skill text changes (D3.6).

## Regeneration

```bash
bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh
bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh
git status --short   # the second run adds no change
```

## Live runs (last)

Follow [contracts/final-run-evidence.md](contracts/final-run-evidence.md). Expected:

- Smoke: every scenario passes, or its failure is F3, F7, F15, a service block, or a new finding.
  The baseline was 6 of 16.
- 0 false setup-needed messages, 0 present records reported missing, 0 shell rejections, and 0
  experience-order failures after a `SKILL.md` read (SC-003, SC-004).
