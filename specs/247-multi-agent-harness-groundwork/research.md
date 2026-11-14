# Research: Multi-Agent Harness Groundwork

No item in the Technical Context was left open. Each decision below settles a design point the spec
leaves to planning.

## R1. Where the registry lives and what an entry holds

- **Decision**: `harness/src/agents.ts` exports `AGENTS`, a map from agent id to an `Agent`:
  - `id` and `service`, the display name used in messages ("Copilot");
  - `keys`, the key variables, read in order;
  - `driver`;
  - `ask`, an optional one-shot ask factory;
  - `classify`, the error classifier;
  - `readRoots(home)`;
  - `versions()`.

  `RunnerDeps.agents` holds the registry, so tests pass a registry with a fake agent.
- **Rationale**: one place names every agent-specific piece (FR-006). Injecting the registry
  replaces today's separate `driver`, `makeAsk`, and `versions` dependencies with one.
- **Alternatives considered**: a class per agent. It adds inheritance for what is a record of
  functions.

## R2. The install call

- **Decision**: a driver supplies its native install as a `PluginRpc` (install, enable, list) and
  calls the shared `installPlugin(rpc, plugin, projectDir)`, which holds the checks (FR-010). The
  registry entry's driver is the install call's owner, because Copilot installs through the same
  client the session uses.
- **Rationale**: separating the install from the session would start a second Copilot client per
  attempt and change Copilot's behavior (FR-005). The shared checks still run in one place for
  every driver.
- **Alternatives considered**: a registry-level `install(home, project, plugin)` called by the
  runner before the driver. Rejected for the second client start.

## R3. The neutral permission request

- **Decision**: `AccessRequest = { kind: "read" | "write" | "shell" | "memory" | "url" | "other";
  path?; command?; url?; detail?; tool? }`. `permissionPolicy(request, projectDir, web, readRoots)`
  returns `{ approved, feedback?, rejection?, summary }`.
  - Copilot's `toAccessRequest` maps:
    - read: `resolvedPath ?? path`;
    - write: `resolvedPath ?? fileName`;
    - shell: `fullCommandText ?? intention`;
    - memory: `fact ?? intention`;
    - url: `url ?? intention`;
    - any other kind: `other`, with `tool` set to the native kind and `detail` to
      `toolName ?? intention ?? kind`.
  - Copilot's `toPermissionResult` maps the decision back to `approve-once` or `reject` with the
    feedback.
- **Rationale**: every summary, rejection kind, and feedback string stays identical (FR-008,
  SC-004). `tool` keeps today's rejection kind for an unknown tool, which is the native kind.
- **Alternatives considered**: passing the native request through. Rejected, because it ties the
  policy to one SDK.

## R4. Keys and the classifier

- **Decision**:
  - Copilot's keys are `["COPILOT_GITHUB_TOKEN", "GITHUB_TOKEN"]`, read in that order as today,
    and its service is "Copilot".
  - `missing-token` and `no-access` failures carry `service` and `key`. Their causes read "No
    Copilot token was found. Set GITHUB_TOKEN in harness/.env." and "The GITHUB_TOKEN key has no
    Copilot access. Check the account's Copilot plan." `key` is the last key in the list, the one
    a person sets.
  - `classifyError` moves to `drivers/copilot.ts` as `classifyCopilotError`, unchanged.
    `withRateLimit` and `retryServiceError` take a classifier argument.
- **Rationale**: FR-011 and FR-012. The Copilot texts stay as they are.
- **Alternatives considered**: a generic classifier in `failure.ts` with per-agent extras. Rejected,
  because -32603 and the premium-request text are Copilot's.

## R5. Redaction patterns

- **Decision**: add `/cursor_[A-Za-z0-9_-]{20,}/g` and `/AIza[0-9A-Za-z_-]{35}/g`.
- **Rationale**: FR-013. A Google API key is `AIza` plus 35 characters. A Cursor key is matched by
  its prefix and a length floor, like the GitHub patterns.

## R6. Configuration shape and validation order

- **Decision**: the new `harness.config.json`:

  ```json
  {
    "agent": "copilot",
    "models": { "copilot": "gpt-5.6-luna" },
    "judge": { "agent": "copilot", "model": "gpt-5.6-luna" },
    "parallel": 4,
    "maxTurns": 40,
    "timeoutMinutes": 20
  }
  ```

  `readFileConfig` rejects a `model` field (use `models`), a `transcripts` field (use
  `--transcripts <dir>`), a missing or empty `agent`, a `models` that is not an object of
  non-empty strings, and a missing `judge` block or an empty `judge.agent` or `judge.model`.

  `resolveConfig(options, file, env, agents)` then checks, in order:

  1. the agent is registered;
  2. the agent has a model;
  3. the judge agent is registered;
  4. the judge agent has a one-shot ask;
  5. the judge key is present, unless `--no-judge`, or the judge agent is the agent under test.

  Every error exits 2 with `Configuration error: ...` and the `--help` pointer.
- **Rationale**: FR-001 to FR-004 and FR-014 to FR-016. When the judge agent is the agent under
  test, the agent's own `missing-token` failure names the key, as today, so the existing
  missing-token behavior holds.
- **Alternatives considered**: checking the judge key after the header. Rejected, because FR-016
  requires the check before any scenario starts.

## R7. Reply fallback under `--no-judge`

- **Decision**: the fallback is built when the judge agent's key is present, whether or not the
  judge runs. Without it, `makeFallbackPicker(undefined, ...)` picks nothing, and the header shows
  `fallback=off`.
- **Rationale**: FR-017, keeping today's behavior.

## R8. Run log rendering and order

- **Decision**: `harness/src/runlog.ts` renders an attempt's block from its transcript entries,
  turn file changes, failures, and verdicts. An `OrderedLog` holds one slot per selected scenario.
  When a scenario's attempts are done, its slot is filled, and every filled slot from the first
  unprinted one is printed. At the end, the rest is flushed. Scenarios with no attempt fill their
  slot empty.
- **Rationale**: FR-023. Blocks stream as soon as order allows, and an interrupted run keeps what
  was printed.
- **Alternatives considered**: printing every block at the end. Rejected for the interrupted-run
  edge case.

## R9. Files per turn

- **Decision**: the runner snapshots the project when it receives an `agent` entry, which a driver
  logs at the end of each turn. It diffs that snapshot against the previous one and records
  `created`, `changed`, and `deleted` for the turn. The first comparison is against the
  pre-conversation snapshot.
- **Rationale**: driver-neutral, so it needs no driver change. It uses the existing `snapshot` and
  `diffSnapshots`.
- **Alternatives considered**: a driver hook per turn. Rejected, because every driver would repeat
  it.

## R10. Path rewriting

- **Decision**: each block line passes through a rewriter that replaces:
  - the project folder, and its real path, followed by `/`, with nothing, and the folder alone
    with `.`;
  - the agent home with `<home>`;
  - the run's work root with `<work>`.

  Redaction runs after rewriting.
- **Rationale**: FR-025 and SC-009. On macOS the temporary folder has two spellings, `/var/...`
  and `/private/var/...`, so both are replaced.

## R11. Stdout failure blocks

- **Decision**: `formatFailure` and the `HARNESS-FAILURE` line are removed, along with the stdout
  summary text. Each failure becomes a `fail:` entry in its attempt block. Run-level failures,
  such as `missing-token`, `build-failed`, a rate-limit or allowance stop, and `chain-stage`, print
  as a `== run ==` block with `fail:` and `cause:` entries. The closing table replaces the summary
  (FR-026). `report.md`, `report.json`, and `junit.xml` keep every failure field when
  `--transcripts` is given.
- **Rationale**: FR-022 limits standard output to the log. A pipeline (Phase 3) reads
  `report.json` or `junit.xml` from a run folder.
- **Alternatives considered**: keeping `HARNESS-FAILURE` lines in the log. Rejected: each repeats
  its failure as JSON, roughly tripling a failed attempt's size.

## R12. Run folders and promotion

- **Decision**:
  - `Config.transcripts` is optional, and `Run.folder` is set only with it. Without a folder:
    - attempts keep their transcript in memory only;
    - no `result.json` or reports are written;
    - `runChain` gets no candidates folder, so it saves none, and the log prints the
      missing-snapshots note.
  - `runId(start, type, commit, agent)` adds the agent id after the type for any agent but
    `copilot`.
  - `--promote` reads the agent from the folder name, using the same pattern, and exits 2 for any
    agent but Copilot. An old name has no agent part and is a Copilot run.
- **Rationale**: FR-020, FR-021, and FR-026.

## R13. Retiring `harness/runs/`

- **Decision**:
  - remove the `.gitignore` line;
  - remove the `harness/runs/` entry in `tests/harness-placement.test.sh`;
  - remove the `-path harness/runs` prune in `tests/self-contained-skills.test.sh`;
  - remove every README mention;
  - change the spec 242 affected-run note in `harness-model-findings.md` to say its transcripts
    were not kept.
- **Rationale**: FR-029a.
