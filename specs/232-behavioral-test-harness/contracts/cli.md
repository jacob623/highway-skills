# Contract: Harness Command Line

Invocation: `npm --prefix harness run harness -- [switches]`, or `node harness/src/cli.ts [switches]`.

## Switches

| Group | Switch | Argument | Default | Usage |
|---|---|---|---|---|
| Selection | `--smoke` | — | off | Run one smoke scenario per skill |
| Selection | `--changed-since` | `<ref>` | — | Run scenarios affected by files changed since `<ref>` |
| Selection | `--paths` | `<files>` | — | Run scenarios affected by these comma-separated paths |
| Selection | `--skills` | `<ids>` | — | Run scenarios for these comma-separated skill ids |
| Agent | `--model` | `<id>` | `harness.config.json` `model` | Model for scenario sessions |
| Agent | `--judge-model` | `<id>` | the run's model | Model for the judge and reply fallback |
| Agent | `--no-judge` | — | off | Skip the judge |
| Execution | `--parallel` | `<n>` | 4 | Scenarios run at once |
| Execution | `--max-turns` | `<n>` | 40 | Turn limit per attempt |
| Execution | `--timeout` | `<minutes>` | 20 | Time limit per attempt |
| Output | `--transcripts` | `<dir>` | `harness/runs/` | Folder that receives run folders |
| Fixtures | `--promote` | `<run folder>` | — | Replace stage fixtures with a run's candidate snapshots |
| Help | `--help`, `-h` | — | — | Print this help and exit 0 |

No selection switch runs the full suite.

## Rules

- `--changed-since`, `--paths`, and `--skills` combine as a union; each scenario keeps every reason.
- `--smoke` and `--promote` are used alone: either with a targeted switch, or with each other,
  prints the conflict and exits 2 before anything runs.
- An unknown switch, a missing argument, or a non-positive number prints the error and
  `Run with --help for usage.`, and exits 2.
- Help lists the switches grouped as above, each with argument, default, and usage, then examples:
  - `node harness/src/cli.ts --smoke`
  - `node harness/src/cli.ts --changed-since origin/main`
  - `node harness/src/cli.ts --skills highway-codify`
- Switches are declared once in `harness/src/switches.ts`, one per line, and the parser and help
  both read that list.

## Exit codes

| Code | Meaning |
|---|---|
| 0 | Every gated check passed, or nothing was selected |
| 1 | A gated check failed, or a chain stage failed |
| 2 | The run could not start, a switch was invalid, or a rate limit or used-up allowance stopped it |

Exit 2 takes precedence over exit 1.

## Environment

- `GITHUB_TOKEN` or `COPILOT_GITHUB_TOKEN`, read from the environment or `harness/.env`.
