# Quickstart: Claude Code Driver

Run from the repository root. Prefer `export PATH="$HOME/.local/node/bin:$PATH"`.

## 1. Install harness deps and unit tests

```bash
npm --prefix harness install
npm --prefix harness test
npm --prefix harness run typecheck
```

Expected: Claude unit tests cover event mapping, permission decisions (including Bash always
denied), install checks, AskUserQuestion / reply-loop path, one-shot ask, and error
classification; Copilot, Cursor, and Codex tests still pass. Contract:
[contracts/claude-driver.md](contracts/claude-driver.md).

## 2. Bash suite

```bash
bash tests/run-all.sh
```

Expected: exit 0.

## 3. Registry acceptance

```bash
node harness/src/cli.ts --agent claude --help >/dev/null
node harness/src/cli.ts --agent not-an-agent --smoke; echo "exit $?"
```

Expected: Claude is listed once registered; unknown agent exits 2.

## 4. Live runs (API key in `harness/.env`)

```bash
mkdir -p specs/254-claude-code-driver/harness
node harness/src/cli.ts --agent claude --smoke > specs/254-claude-code-driver/harness/smoke-1.log
node harness/src/cli.ts --agent claude --smoke > specs/254-claude-code-driver/harness/smoke-2.log
node harness/src/cli.ts --agent claude --skills highway-codify > specs/254-claude-code-driver/harness/codify.log
```

Expected: see [contracts/live-runs.md](contracts/live-runs.md). Map failures in
`harness-model-findings.md`.

## 5. Docs check

`harness/README.md` names Claude’s key, model (`claude-haiku-5-5`), install, policy notes
(Bash always rejected), and likely-cause rows. Constitution Harness Toolchain lists
`@anthropic-ai/claude-agent-sdk`. `rollout-plan.md` Phase 8 has Status.
