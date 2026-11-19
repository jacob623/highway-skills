# Quickstart: Claude Bash Prompt

Run from the repository root. Prefer `export PATH="$HOME/.local/node/bin:$PATH"`.

## 1. Harness unit tests

```bash
npm --prefix harness test
npm --prefix harness run typecheck
```

Expected: Claude tests cover drive `systemPrompt` append + `settingSources: []` and Bash still
denied. Contract: [contracts/claude-session-guidance.md](contracts/claude-session-guidance.md).

## 2. Bash suite

```bash
bash tests/run-all.sh
```

Expected: exit 0.

## 3. Live runs (API key in `harness/.env`)

```bash
mkdir -p specs/256-claude-bash-prompt/harness
node harness/src/cli.ts --agent claude --smoke > specs/256-claude-bash-prompt/harness/smoke-1.log
node harness/src/cli.ts --agent claude --smoke > specs/256-claude-bash-prompt/harness/smoke-2.log
node harness/src/cli.ts --agent claude --skills highway-codify > specs/256-claude-bash-prompt/harness/codify.log
```

Expected: see [contracts/live-runs.md](contracts/live-runs.md) — each smoke ≥14/16; codify has
no numeric floor; redact logs; update F33.

## 4. Docs check

`harness/README.md` Claude section names session-start Local-mode / no-Bash guidance (and any
supporting throwaway-home file) beside deny-all-Bash. `rollout-plan.md` Status updated from
evidence.
