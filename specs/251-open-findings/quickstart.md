# Quickstart: Open Findings

Run from the repository root. Prefer `export PATH="$HOME/.local/node/bin:$PATH"`.

## 1. Unit tests (F23 / F28 / path layout)

```bash
npm --prefix harness test
npm --prefix harness run typecheck
```

Expected: new `shows` backtick and `contains-any` case tests pass; existing suite green. See [contracts/harness-checks.md](contracts/harness-checks.md) and [contracts/path-layout.md](contracts/path-layout.md).

## 2. Skill + regenerate (F18)

After editing `skills/highway-discovery/references/options.md` and bumping version, regenerate agent trees and the plugin the same way prior skill edits do (`bash tests/run-all.sh` or the project’s generate scripts). Second regenerate is a no-op.

## 3. Bash suite

```bash
bash tests/run-all.sh
```

Expected: exit 0.

## 4. Live confirmation

See [contracts/live-runs.md](contracts/live-runs.md). Keys in `harness/.env` (`COPILOT_*` / `CURSOR_API_KEY` as configured).

## 5. Findings

Update `harness-model-findings.md` per close rules in [data-model.md](data-model.md). Optionally note Status in `rollout-plan.md`.
