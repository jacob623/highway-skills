# Quickstart: Harness Failure Follow-ups

## Prerequisites

- Run from the repository root.
- Node: `/Applications/Cursor.app/Contents/Resources/app/resources/helpers/node`, or Node 24.
- `harness/node_modules` is installed.
- `harness/.env` holds the Copilot token. Never print it.

## Static checks

```bash
bash tests/harness-failure-followups.test.sh        # skill text and scripts (contracts/skill-text.md, scenario-scripts.md)
bash tests/configure-handoff.test.sh                # codify-config menu decline
bash tests/harness-scenarios.test.sh                # scenario grammar, contains-any
bash tests/skill-flow-pattern.test.sh               # router and flow pattern still hold
bash tests/run-all.sh                               # full suite: 87 tests
(cd harness && node --test "test/*.test.ts" && node node_modules/typescript/bin/tsc -p tsconfig.json)
```

Expected: every check passes. The new test and the new unit tests fail before their changes (D3.6).

## Regeneration

```bash
bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh
bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh
git status --short   # the second run adds no change
```

## Live run (last)

Follow [contracts/final-run-evidence.md](contracts/final-run-evidence.md). Expected:

- Every scenario passes on either attempt, or its failure is recorded as a finding.
- 0 empty final turns after a governance accept or a codify-config decline run on its own.
- 0 Discoveries or ADRs missing a template heading or header row.
