# Implementation Plan: Multi-Agent Harness Groundwork

**Branch**: `247-multi-agent-harness-groundwork` | **Date**: 2026-11-14 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/247-multi-agent-harness-groundwork/spec.md`

## Summary

The harness gains an agent registry, `harness/src/agents.ts`. Each entry names the agent's driver,
its key variables and service, its error classifier, its read roots, its version report, and an
optional one-shot ask. The runner takes everything agent-specific from the selected entry.
Copilot's code moves to `harness/src/drivers/copilot.ts`: the driver, `copilotAsk`, the SDK
version reader, and the Copilot error classifier. `driver.ts` keeps what every driver shares:

- the transcript and result types and usage;
- the neutral permission request and the policy that decides it;
- the shared install checks;
- rate-limit and service-error retries, now taking the driver's classifier.

`harness.config.json` replaces `model` and `transcripts` with `agent`, `models`, and a `judge`
block. New switches: `--agent`, `--judge-agent`, and `--verbose`. `--transcripts <dir>` becomes the
only way to write a run folder.

Standard output becomes the run log:

- a header;
- one block per attempt in selection order, written as labeled lines (`user:`, `agent:`,
  `files:`, ...);
- a closing table.

Progress goes to standard error. The stdout failure blocks and `HARNESS-FAILURE` lines are
replaced by `fail:` entries. `harness/runs/` is retired.

After the full suite and `npm test` pass, one Copilot smoke run's log is saved to
`specs/247-multi-agent-harness-groundwork/harness/smoke.log`.

## Technical Context

**Language/Version**: TypeScript on Node 24 for `harness/`. Bash 3.2.57 with the Declared Toolchain
for the two changed tests under `tests/`.

**Primary Dependencies**: `@github/copilot-sdk` 1.0.30 (CLI 1.0.108), unchanged. No new dependency.

**Storage**: Files. `harness/harness.config.json` changes shape. Run folders are written only
under `--transcripts <dir>`.

**Testing**: `npm --prefix harness test` (`node:test`), `npm --prefix harness run typecheck`, and
`bash tests/run-all.sh`. Live: `node harness/src/cli.ts --agent copilot --smoke`.

**Target Platform**: macOS and Linux, local runtime.

**Project Type**: A skill framework with a bash test suite and a behavioral harness (CLI).

**Performance Goals**: Snapshotting the project after each agent turn, for the `files:` line, adds
under 100 ms per turn on a stage fixture of about 100 files. A smoke run's log is under 100 KB
(SC-008).

**Constraints**:

- No commit.
- No skill, template, fixture, or scenario change (FR-034).
- Secrets are redacted, and the token is never printed.
- Edits use `mv`, not `git mv`.
- No backward compatibility: the old `model` and `transcripts` fields fail.

**Scale/Scope**: About 18 harness source files and 14 test files. One registered agent.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution 3.6.0)

| Gate | Trigger | Rules | Verdict |
| --- | --- | --- | --- |
| Packaging Gate | No shipped path changes. `harness/` is excluded from the distribution | D1.1, D1.2, D6.2 | N/A |
| Toolchain Gate | `tests/harness-placement.test.sh` and `tests/self-contained-skills.test.sh` change | D2.1 to D2.5 | PASS: each edit removes a `harness/runs/` entry from a list and adds no utility, flag, or path construction |
| Generator Gate | No `generate-*.sh` changes | D4.1 to D4.4 | N/A |
| Correspondence Gate | No change under `skills/` or to a generator input | D4.5 to D4.7 | N/A |
| Validation Gate | `harness-placement.test.sh` stops requiring the `harness/runs/` ignore line | D3.4, D3.5 | PASS: the removed assertion is recorded with its superseded behavior (no default run folder exists to ignore, FR-029a). Its verdict on the current tree is recorded before and after (tasks) |
| Skill Content Gate | No file under `skills/` changes | Delegated (D1.5) | N/A |

Verification rules:

- D3.1 is the baseline run before the first edit, and D3.2 the final run.
- D3.3: `tests/harness-placement.test.sh` changes, and harness unit tests are added.
- D3.5: each replaced runner-test assertion on the old stdout format names the new run-log line that
  supersedes it.
- D3.6: each new unit test is observed failing before the code that makes it pass.
- D6.1: `harness/README.md` and `harness-model-findings.md` are updated in this change.
- D7.3: the report states suite results and requirement coverage separately.

The Harness Toolchain is unchanged: no new SDK or runtime, so no amendment.

### Skill content gates

N/A: Skill Content Gate not triggered.

### Post-design re-check

Re-evaluated after Phase 1. The contracts add files only under `harness/` and the spec folder, no
utility to the Declared Toolchain, and no skill edit. All gates hold.

## Project Structure

### Documentation (this feature)

```text
specs/247-multi-agent-harness-groundwork/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── cli-and-config.md
│   ├── agent-registry.md
│   └── run-log.md
├── checklists/requirements.md
├── harness/smoke.log       # the live check's run log, meant to be committed
└── tasks.md
```

### Source Code (repository root)

```text
harness/
├── harness.config.json      # agent, models, judge; no model or transcripts
├── src/
│   ├── agents.ts            # new: the registry, key lookup, Agent type
│   ├── drivers/copilot.ts   # new: copilotDriver, copilotAsk, versions, classifier, request mapping
│   ├── driver.ts            # shared: types, neutral request and policy, install checks, retries
│   ├── runlog.ts            # new: block rendering, path rewriting, ordered printer, closing table
│   ├── config.ts            # agent, models, judge block validation; transcripts optional
│   ├── args.ts, switches.ts # --agent, --judge-agent, --verbose; --transcripts without default
│   ├── runner.ts            # registry-driven; log to stdout, progress to stderr; no default folder
│   ├── judge.ts             # makeFallbackPicker accepts no ask
│   ├── report.ts            # agent, judge agent, runtime version; runId with agent; no summaryText
│   ├── failure.ts           # no formatFailure or classifyError; key and service in causes
│   ├── chain.ts             # candidates only with a folder; promote refuses other agents
│   └── redact.ts            # cursor_ and AIza patterns
└── test/                    # agents, runlog, config tests; updated runner, driver, judge, report, failure, args, redact, chain
tests/harness-placement.test.sh       # drops the harness/runs/ ignore line
tests/self-contained-skills.test.sh   # drops the harness/runs prune
.gitignore                            # drops harness/runs/
harness-model-findings.md             # spec 242 run note; Runs lines for the smoke run
rollout-plan.md                       # Phase 5 complete (gitignored)
```

**Structure Decision**: the existing `harness/src/` layout is kept. Agent-specific code moves into
`harness/src/drivers/`, one file per agent, so each later driver spec adds one file and one
registry entry.

## Complexity Tracking

No violations to justify.
