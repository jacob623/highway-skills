# Quickstart: Claude Bash Failures

Run from the repository root. Prefer `export PATH="$HOME/.local/node/bin:$PATH"`.

## 1. Harness unit tests

```bash
npm --prefix harness test
npm --prefix harness run typecheck
```

Expected: Claude tests cover throwaway-home `.claude/CLAUDE.md` guidance,
`settingSources: ["user"]` on drive sessions, and Bash still denied. Contract:
[contracts/claude-guidance.md](contracts/claude-guidance.md).

## 2. Bash suite

```bash
bash tests/run-all.sh
```

Expected: exit 0.

## 3. Live runs (API key in `harness/.env`)

```bash
mkdir -p specs/255-claude-bash-failures/harness
node harness/src/cli.ts --agent claude --smoke > specs/255-claude-bash-failures/harness/smoke-1.log
node harness/src/cli.ts --agent claude --smoke > specs/255-claude-bash-failures/harness/smoke-2.log
node harness/src/cli.ts --agent claude --skills highway-codify > specs/255-claude-bash-failures/harness/codify.log
```

Expected: see [contracts/live-runs.md](contracts/live-runs.md) — each smoke ≥14/16; codify has
no numeric floor; redact logs; update F33 in `harness-model-findings.md`.

## 4. Docs check

`harness/README.md` Claude section names throwaway-home Local-mode / no-Bash guidance beside
deny-all-Bash. `rollout-plan.md` Phase Status updated from evidence.
