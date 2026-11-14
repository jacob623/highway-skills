# Quickstart: Multi-Agent Harness Groundwork

Validation steps, run from the repository root.

## 1. Unit tests and type check (no token)

```bash
npm --prefix harness test
npm --prefix harness run typecheck
```

Expected: every test passes, including:

- the registry and fake-driver tests (FR-031);
- the configuration errors (SC-003);
- the policy mapping (SC-004);
- the run-log tests (FR-022 to FR-027, SC-009).

## 2. Bash suite

```bash
bash tests/run-all.sh
```

Expected: exit 0. `harness-switches.test.sh` finds `--agent`, `--judge-agent`, and `--verbose` in
the README, and `harness-placement.test.sh` no longer requires `harness/runs/`.

## 3. Configuration errors

```bash
node harness/src/cli.ts --agent cursor --smoke; echo "exit $?"
node harness/src/cli.ts --transcripts; echo "exit $?"
```

Expected: both exit 2. The first names `cursor` and the registered agents, and ends with the
`--help` pointer.

## 4. Live smoke run (token in `harness/.env`)

```bash
mkdir -p specs/247-multi-agent-harness-groundwork/harness
node harness/src/cli.ts --agent copilot --smoke > specs/247-multi-agent-harness-groundwork/harness/smoke.log
```

Expected:

- progress shows on the terminal;
- the log holds a header, 16 or more attempt blocks, and the closing table;
- no run folder is written;
- `git status` lists the log as the only new file;
- the log is under 100 KB, and a search finds no `ghp_`, `github_pat_`, `/var/folders`, or `/tmp/`;
- every attempt's first `system:` line reads `installed plugin highway (16 skills)`;
- every failure matches a finding in `harness-model-findings.md`.

For a failure the log does not explain, rerun that scenario outside the repository:

```bash
node harness/src/cli.ts --skills <skill> --transcripts "$TMPDIR/harness-247" --verbose
```
