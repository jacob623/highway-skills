# Data Model: Multi-Agent Harness Groundwork

## Agent (`harness/src/agents.ts`)

| Field | Type | Rule |
|---|---|---|
| `id` | string | Registry key; lowercase; `copilot` in this spec |
| `service` | string | Name used in messages; `Copilot` |
| `keys` | string[] | Key variables, read in order; the last is the one a person sets |
| `driver` | `Driver` | Runs one attempt |
| `ask` | `(key, model) => Ask`, optional | One-shot question with no tools, in its own throwaway home; required of a judge agent |
| `classify` | `(error) => FailureKind` | Used by the shared retries and the driver's error handling |
| `readRoots` | `(home) => string[]` | Folders under the agent home where the installed plugin sits |
| `versions` | `() => { sdk, runtime }` | `unknown` for a version it cannot read |

The registry (`AGENTS`) holds one entry, `copilot`. `keyOf(agent, env)` returns the first non-empty
key value, or `undefined` when none is set.

## AccessRequest and AccessDecision (`harness/src/driver.ts`)

| Field | Type | Rule |
|---|---|---|
| `kind` | `read`, `write`, `shell`, `memory`, `url`, `other` | A native request that fits none of the others is `other` |
| `path` | string, optional | For `read` and `write` |
| `command` | string, optional | For `shell` |
| `url` | string, optional | For `url` |
| `detail` | string, optional | For `memory` and `other` |
| `tool` | string, optional | For `other`: the native kind, used as the rejection kind |

`AccessDecision`: `approved` (boolean), `feedback` (the rejection text), `rejection`
(`{ kind, detail, fatal }`), and `summary` (`approved read: <path>` or `rejected <kind>: <detail>`).
Each mapping is identical to today's for every kind (SC-004).

## DriveOptions changes

- `copilotHome` becomes `agentHome`.
- `token` becomes `key`.
- `readRoots` is added: the registry's roots for the attempt's home.

`DriveResult` is unchanged.

## FileConfig and Config (`harness/src/config.ts`)

`FileConfig`:

- `agent`: string;
- `models`: a map from agent id to model id;
- `judge`: `{ agent, model }`;
- `parallel`, `maxTurns`, and `timeoutMinutes`.

`model` and `transcripts` are errors.

`Config`:

- `agent`, `model`, and `key?`: the agent under test, its model, and its key;
- `judgeAgent`, `judgeModel`, `judge` (`false` with `--no-judge`), and `judgeKey?`;
- `parallel`, `maxTurns`, and `timeoutMs`;
- `transcripts?`: an absolute folder, set only by `--transcripts`;
- `verbose`;
- `env`.

## Run and AttemptResult (`harness/src/report.ts`)

`Run` gains `agent`, `judgeAgent` (null when the judge is off), and `runtimeVersion`, which
replaces `cliVersion`. `folder` becomes optional, and `fallback` (`<agent>/<model>` or `off`) is
added.

`AttemptResult` gains `agent` and `judgeAgent`, and keeps `model`, `judgeModel`, and every other
field.

Run id: `<UTC start>-<type>-<short commit>` for Copilot, and
`<UTC start>-<type>-<agent>-<short commit>` for any other agent.

## Attempt block (`harness/src/runlog.ts`)

Input:

- the scenario id and skill, and the attempt number;
- the transcript entries;
- the turn file changes (`{ afterIndex, created, changed, deleted }`, where `afterIndex` is the
  `agent` entry's position);
- the failures, the verdicts, and the warnings;
- `verbose`, the usage, and the path rewriter.

Output: the block's lines, as given in [contracts/run-log.md](contracts/run-log.md).

## Failure changes (`harness/src/failure.ts`)

`Failure` gains `service?` and `key?`, used by `likelyCause` for `missing-token` and `no-access`.
`formatFailure`, `failureJson`, and `classifyError` are removed.
