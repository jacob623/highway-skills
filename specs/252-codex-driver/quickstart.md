# Quickstart: Codex Driver

Run from the repository root. Prefer `export PATH="$HOME/.local/node/bin:$PATH"`.

## 1. Install harness deps and unit tests

```bash
npm --prefix harness install
npm --prefix harness test
npm --prefix harness run typecheck
```

Expected: Codex unit tests cover event mapping, effects classification (read/write/build-test /
outside/git/network-install), install checks, question → reply-loop path, one-shot ask, and error
classification; Copilot and Cursor tests still pass. Contract:
[contracts/codex-driver.md](contracts/codex-driver.md).

## 2. Bash suite

```bash
bash tests/run-all.sh
```

Expected: exit 0 (includes regenerated plugin after storage-contract MINOR).

## 3. Registry acceptance

```bash
node harness/src/cli.ts --agent codex --help >/dev/null
node harness/src/cli.ts --agent not-an-agent --smoke; echo "exit $?"
```

Expected: Codex is listed once registered; unknown agent exits 2.

## 4. Live runs (API key in `harness/.env`)

```bash
mkdir -p specs/252-codex-driver/harness
node harness/src/cli.ts --agent codex --smoke > specs/252-codex-driver/harness/smoke-1.log
node harness/src/cli.ts --agent codex --smoke > specs/252-codex-driver/harness/smoke-2.log
node harness/src/cli.ts --agent codex --skills highway-codify > specs/252-codex-driver/harness/codify.log
```

Expected: see [contracts/live-runs.md](contracts/live-runs.md). Map failures in
`harness-model-findings.md`.

## 5. Docs check

`harness/README.md` names Codex’s key(s), model, install, enforcement notes, and likely-cause
rows. Constitution Harness Toolchain lists `@openai/codex-sdk`. `rollout-plan.md` Phase 9 has
Status. Storage contract Local wording mentions shell-as-file-tool agents.
