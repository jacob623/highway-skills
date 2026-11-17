# Contract: Live confirmation (FR-010)

Run from repository root after suite + harness unit tests pass. Prefer `export PATH="$HOME/.local/node/bin:$PATH"`.

## Sequence

1. `node harness/src/cli.ts --smoke` → `specs/251-open-findings/harness/smoke-copilot.log`
2. `node harness/src/cli.ts --agent cursor --smoke` → `smoke-cursor-1.log`
3. `node harness/src/cli.ts --agent cursor --smoke` → `smoke-cursor-2.log`
4. Cursor targeted (same scenario set once):

```bash
node harness/src/cli.ts --agent cursor --paths \
  harness/scenarios/highway-discovery/discovery-smoke.scenario \
  harness/scenarios/highway-codify/codify-configure.scenario \
  harness/scenarios/highway-objectives/objectives-smoke.scenario \
  harness/scenarios/highway-request/request-smoke.scenario \
  harness/scenarios/highway-setup/setup-smoke.scenario \
  > specs/251-open-findings/harness/targeted-cursor.log
```

(Adjust `--paths` form to whatever the CLI accepts if it takes scenario ids instead of file paths.)

## Pass conditions for findings

| Finding | Evidence |
| --- | --- |
| F18 | No discovery-smoke failure for missing Example Realization Matrix header in Copilot smoke and both Cursor smokes |
| F23 / F28 | Unit tests (already green); may also appear in targeted |
| F20 | Fewer collapsed-path denials than cited baseline across these runs, or document leave-open |

## Log hygiene

Committed logs: no API tokens, no raw `/var/folders/…` (or other tmp) absolute paths.
