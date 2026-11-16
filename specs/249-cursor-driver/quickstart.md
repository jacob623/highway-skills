# Quickstart: Cursor Driver

Run from the repository root. Prefer `export PATH="$HOME/.local/node/bin:$PATH"`.

## 1. Install harness deps and unit tests

```bash
npm --prefix harness install
npm --prefix harness test
npm --prefix harness run typecheck
```

Expected: Cursor unit tests cover event mapping, policy/hooks decisions, install checks, question →
reply-loop path, one-shot ask, and error classification; Copilot tests still pass. Contract:
[contracts/cursor-driver.md](contracts/cursor-driver.md).

## 2. Bash suite

```bash
bash tests/run-all.sh
```

Expected: exit 0.

## 3. Registry acceptance

```bash
node harness/src/cli.ts --agent cursor --help >/dev/null
node harness/src/cli.ts --agent not-an-agent --smoke; echo "exit $?"
```

Expected: Cursor is listed once registered; unknown agent exits 2.

## 4. Live runs (`CURSOR_API_KEY` in `harness/.env`)

```bash
mkdir -p specs/249-cursor-driver/harness
node harness/src/cli.ts --agent cursor --smoke > specs/249-cursor-driver/harness/smoke-1.log
node harness/src/cli.ts --agent cursor --smoke > specs/249-cursor-driver/harness/smoke-2.log
node harness/src/cli.ts --agent cursor --skills highway-codify > specs/249-cursor-driver/harness/codify.log
```

Expected: see [contracts/live-runs.md](contracts/live-runs.md). Map failures in
`harness-model-findings.md`.

## 5. Docs check

`harness/README.md` names Cursor’s key, model, install, policy notes, and likely-cause rows.
Constitution Harness Toolchain lists `@cursor/sdk`. `rollout-plan.md` Phase 7 has Status; Phase 20
exists for cloud.
