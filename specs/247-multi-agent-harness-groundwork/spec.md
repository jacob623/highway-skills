# Feature Specification: Multi-Agent Harness Groundwork

**Feature Branch**: `247-multi-agent-harness-groundwork`

**Created**: 2026-11-14

**Status**: Draft

**Input**: User description: "create a new spec for implementing Phase 5 in rollout-plan.md."

Phase 5 of `rollout-plan.md`: the behavioral test harness in `harness/` can run more than one agent. Today it drives only GitHub Copilot, and the Copilot specifics run through the runner, the configuration, the permission policy, the plugin install, the error handling, and the report. This spec separates what every agent shares from what belongs to Copilot. Each later driver spec (Cursor, Claude Code, Codex, Antigravity, Gemini CLI) can then add one driver without changing the runner. Copilot stays the only driver, and its results do not change. The spec also makes each run print a concise log to standard output, so every spec can commit the record of its live runs.

Out of scope: any new driver (Phases 7 to 11), the agent manifests (Phase 6), any skill change, and the pipeline (Phase 3).

## Clarifications

### Session 2026-11-14

- Q: What should the run log show from the judge? → A: The closing table shows a count of met verdicts, such as `judge 2/7 met`. Each attempt block lists only the bullets judged not met, one line each with the judge's one-sentence reason, without the quoted evidence.
- Q: Should each attempt block list the project files the attempt created, changed, or deleted, and how should the block read? → A: Yes, as relative paths without contents. The block reads as a plain conversation: each entry is one line starting with a lowercase label, such as `user: <words>`, `agent: <words>`, and `files: <file> (created), <file> (changed), <file> (deleted)`. A `files:` line follows the agent reply of each turn that changed the project, and is left out when nothing changed.
- Q: How should a spec name its committed log files when it captures more than one run? → A: No rule for now. Each spec names its own logs; `smoke.log` is an example, not a convention. Running the harness for every spec is `rollout-plan.md` Phase 18, which sets the rule.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Copilot runs behave exactly as before (Priority: P1)

A maintainer who runs the harness on Copilot after this change gets the same behavior as before: the same scenarios, the same plugin install, the same permission decisions, the same checks, the same retries, and the same exit codes. The configuration file and the report name the agent, but nothing about how Copilot is driven changes.

**Why this priority**: The groundwork is only safe if the one working driver keeps working. Every later driver spec builds on a Copilot baseline that this spec must not disturb.

**Independent Test**: Run the existing runner tests and the full bash suite, then a Copilot smoke run, and compare the outcome with the latest Copilot smoke runs from spec 246.

**Acceptance Scenarios**:

1. **Given** the existing runner tests, **When** they run after this change, **Then** every one passes, with changes limited to renamed fields and the new run log output.
2. **Given** a harness run with no `--agent`, **When** it starts, **Then** it drives Copilot with the model configured for Copilot, as before.
3. **Given** a Copilot attempt, **When** the agent asks to read, write, run a shell command, use memory, or fetch a URL, **Then** each request gets the same decision and the same feedback text as before this change.
4. **Given** a Copilot smoke run after the full suite passes, **When** it ends, **Then** every attempt installed the plugin with all 16 skills, and every failure matches an existing finding in `harness-model-findings.md`.

---

### User Story 2 - A maintainer selects the agent and its model (Priority: P1)

A maintainer picks which agent a run drives with `--agent <id>`, or with an `agent` field in `harness.config.json`. Each agent has its own model in the configuration, so switching agents does not mean editing the model too.

**Why this priority**: Agent selection is the entry point every later driver uses. Without a per-agent model, a run on one agent would try to use another agent's model.

**Independent Test**: Run the harness with each combination of configuration and switches, using a fake second agent registered only in the tests, and check which agent and model each run uses, or which error it prints.

**Acceptance Scenarios**:

1. **Given** a configuration with `"agent": "copilot"` and `"models": { "copilot": "gpt-5.6-luna" }`, **When** a run starts with no switches, **Then** it drives Copilot on `gpt-5.6-luna`.
2. **Given** that configuration, **When** a run starts with `--model <id>`, **Then** the selected agent uses that model and the configuration file is unchanged.
3. **Given** a selected agent with no entry in `models` and no `--model`, **When** the run starts, **Then** it exits 2 and names the missing `models` entry.
4. **Given** `--agent` with an id that has no registered driver, **When** the run starts, **Then** it prints the error and a pointer to `--help`, and exits 2.
5. **Given** a configuration that still has the old `model` field, **When** the run starts, **Then** it exits 2 and says to use `models`.
6. **Given** `--help`, **When** it prints, **Then** it lists `--agent` with its argument, default, and one-line usage, and the harness README lists it too.

---

### User Story 3 - The judge is configured independently of the agent under test (Priority: P2)

A maintainer sets which agent and model judge the results, and answer paraphrased questions, in a `judge` block in `harness.config.json`. The judge stays the same whichever agent is under test, so verdicts stay comparable across agents.

**Why this priority**: Today the judge uses the run's model. Once a run's agent and the judge's agent differ, that stops working. It matters from the first non-Copilot driver, so it belongs in the groundwork.

**Independent Test**: Start runs with the `judge` block alone, with each switch overriding it, and with each invalid setting, and check the judge agent and model recorded, or the error printed.

**Acceptance Scenarios**:

1. **Given** `"judge": { "agent": "copilot", "model": "gpt-5.6-luna" }`, **When** a run starts, **Then** the judge and the reply fallback use Copilot on `gpt-5.6-luna`, and the report header and each result name that agent and model.
2. **Given** that block, **When** a run starts with `--judge-agent <id>` or `--judge-model <id>`, **Then** the switch overrides the matching field for that run only.
3. **Given** a missing `judge` block, or one with an empty agent or model, **When** the run starts, **Then** it exits 2 before any scenario starts and names the field.
4. **Given** a judge agent that is not registered, or whose driver offers no one-shot question, **When** the run starts, **Then** it exits 2 before any scenario starts.
5. **Given** a judge agent whose key is not in the environment, **When** the run starts without `--no-judge`, **Then** it exits 2 and names the key variable.
6. **Given** `--no-judge`, **When** the run starts, **Then** no verdicts are produced, the judge key check is skipped, and the reply fallback still works when the judge agent's key is present.
7. **Given** a judge call, **When** it runs, **Then** it uses its own throwaway agent home, with no plugin installed and no project.

---

### User Story 4 - A new driver plugs in without changing the runner (Priority: P2)

A developer writing the Cursor driver (Phase 7) adds one driver and one registry entry. The runner, the permission policy, the plugin install checks, the key and error handling, and the report already take what they need from the registry and a neutral request shape.

**Why this priority**: This is the point of the groundwork. If a driver spec has to change the runner, Phases 7 to 11 each repeat this work and risk breaking Copilot.

**Independent Test**: Register a fake second driver in the tests that maps its own request and event shapes. Run a scenario end to end through the runner with it, and confirm the runner, the policy, and the install checks needed no change.

**Acceptance Scenarios**:

1. **Given** the registry, **When** the runner starts an attempt, **Then** it takes the driver, the key variable, the install call, the error classifier, the read roots, and the optional one-shot question from the selected agent's entry, and imports no driver directly.
2. **Given** a native permission request from any driver, **When** the driver maps it to the neutral request (`read`, `write`, `shell`, `memory`, `url`, or `other`, with a path, a command, or a URL), **Then** the policy decides it and the driver maps the decision back.
3. **Given** a driver's install call, **When** it returns, **Then** the shared checks run: the plugin is named `highway`, its skill count matches the build, it reports no warning, and it is enabled. Any failure is the `plugin-install` failure kind.
4. **Given** a selected agent whose key variable is missing, or whose service refuses the key, **When** the run starts, **Then** the `missing-token` or `no-access` message names that agent's key variable and service.
5. **Given** an error from a driver, **When** it is classified, **Then** that driver's classifier decides it, so Copilot's service error and rate-limit text stay Copilot's.
6. **Given** a captured transcript containing a key in the Cursor (`cursor_`) or Google (`AIza`) format, **When** it is written, **Then** the key is redacted, as Anthropic, OpenAI, and GitHub keys already are.

---

### User Story 5 - Reports, run folders, and fixtures carry the agent (Priority: P3)

A maintainer comparing runs can tell which agent and versions produced each one. A run on another agent never overwrites the stage fixtures, which come only from Copilot until agent hardening (Phase 16).

**Why this priority**: Once several agents run, a report or a run folder that does not name the agent is ambiguous. Fixtures promoted from an agent that has not been hardened would change every later run.

**Independent Test**: Run the fake second driver and Copilot, then read each report header, each result, and each run folder name, and try `--promote` on the fake driver's run.

**Acceptance Scenarios**:

1. **Given** any run, **When** its report header and results are read, **Then** they name the agent, its SDK version, and its runtime version as reported by the driver, in place of the fixed Copilot SDK and CLI line.
2. **Given** a Copilot run, **When** its folder is created, **Then** the name keeps today's shape: UTC start time, run type, and commit.
3. **Given** a run on any other agent, **When** its folder is created, **Then** the agent id follows the run type, such as `20261113-141852Z-smoke-cursor-be6a1d0`.
4. **Given** a run folder from an agent other than Copilot, **When** `--promote` names it, **Then** the harness exits 2, says fixtures are promoted only from Copilot runs until Phase 16, and changes no fixture.

---

### User Story 6 - Each run prints a concise log that can be committed (Priority: P2)

A maintainer redirects a run's standard output to a file in the spec folder, such as `> specs/<spec>/harness/smoke.log`, and commits it. The log holds enough to judge each conversation and, when something failed, to see what happened and where: the run header, each attempt's back and forth, and a closing table of scenario, status, and summary. Live progress goes to standard error, so it shows in the terminal but stays out of the file. `--verbose` adds detail to the log. For a deep dive, `--transcripts <dir>` also writes the full run folder (transcripts, raw events, reports, and candidate snapshots) under that folder. Without it, the run writes nothing to disk, and there is no default run folder.

**Why this priority**: Today a spec keeps the evidence of its live runs in a run folder of about 55 MB per smoke run, nearly all raw event logs, so it stays out of version control. Of the readable transcripts, 58% is approved file reads with temporary paths. A filtered log of a smoke run is small enough to commit with the spec that ran it.

**Independent Test**: Run a scenario set with the fake second driver that passes one scenario, fails one, and blocks one. Capture standard output and standard error separately, and compare standard output with the expected log. Then run it again with `--verbose` and check the added entries.

**Acceptance Scenarios**:

1. **Given** any run that starts, **When** standard output is captured, **Then** it holds the run header (run id, commit, run type, agent, model, judge, SDK and runtime versions, start time), the selected scenarios, one block per attempt, and a closing table, and nothing else.
2. **Given** scenarios that run at the same time, **When** each attempt ends, **Then** its block is printed whole, and blocks appear in selection order, then attempt order, whatever order the attempts finished in.
3. **Given** an attempt's block, **When** it is read, **Then** it reads as a plain conversation, one labeled entry per line (`user:`, `agent:`, `files:`, and so on): the person's message, the agent's reply, the project files that turn created, changed, or deleted, skill invocations, questions and their answers, denied permission requests, system entries such as the plugin install and session errors, each failure with its kind, check, expected, and actual values, and each bullet the judge marked not met with its one-sentence reason.
4. **Given** the default output, **When** it is read, **Then** it holds no approved permission request, no timestamp other than the header's start time, no temporary folder path (project paths are relative to the project and agent home paths start with `<home>/`), no color codes, and no secret or token.
5. **Given** a run that ends, **When** the closing table prints, **Then** it has one row per selected scenario with its skill, status, attempts, turns, and a one-line summary: the failure kind and check for a failure, the reason for a blocked or skipped scenario, and otherwise the count of met judge verdicts such as `judge 2/7 met`, or `-` when the judge is off. Totals, usage, and the exit code follow the table, then the run folder path when `--transcripts` was given.
6. **Given** a running harness, **When** an attempt starts or ends, **Then** a one-line progress note goes to standard error, never to standard output.
7. **Given** `--verbose`, **When** the run ends, **Then** standard output also holds approved permission requests and per-attempt usage, and everything else is unchanged.
8. **Given** a configuration, selection, or promotion error, **When** the run stops, **Then** the error prints to standard output as today, so a captured log shows why the run stopped.
9. **Given** a run without `--transcripts`, **When** it ends, **Then** no run folder, transcript, report, or candidate snapshot was written anywhere, and the throwaway projects and agent homes were removed as today.
10. **Given** `--transcripts <dir>`, **When** the run ends, **Then** the run folder is under that folder with the same contents as today. **Given** `--transcripts` with no folder, **Then** the run exits 2 before any scenario starts.
11. **Given** a configuration file that still holds `transcripts`, **When** the run starts, **Then** it exits 2 and says to use `--transcripts <dir>`.

---

### User Story 7 - A live Copilot smoke run proves the groundwork (Priority: P3)

After the full suite and the runner tests pass, the maintainer runs the Copilot smoke set once and captures its concise log in this spec's folder. The run writes no run folder unless a deep dive needs one. Every failure is matched to a finding.

**Why this priority**: Unit tests with a fake driver prove the seams. One live run proves the real Copilot driver still works through them, and its log is the first committed record of a live run.

**Independent Test**: Confirm the smoke log sits in this spec's folder, holds no secret, and that every failing scenario in it is matched to an existing finding.

**Acceptance Scenarios**:

1. **Given** the full suite and the runner tests pass, **When** `--agent copilot --smoke` runs with standard output redirected to `specs/247-multi-agent-harness-groundwork/harness/smoke.log`, **Then** the log is written there, no run folder is written, and the log is the only new file `git status` lists.
2. **Given** a failure the log does not explain, **When** the maintainer reruns that scenario with `--transcripts <dir>` outside the repository, **Then** the run folder holds the full transcripts, and nothing from it is copied into the spec folder.
3. **Given** the smoke run, **When** it ends, **Then** every attempt installed the plugin, and no failure kind appears that was not seen in the spec 246 smoke runs.
4. **Given** a failure that matches an existing finding, **When** the findings are updated, **Then** a Runs line for this run is added to that finding.
5. **Given** a failure caused by this change, **When** it is found, **Then** this spec is not complete until the cause is fixed and the smoke run is repeated.

---

### Edge Cases

- `--agent` names a known future agent, such as `cursor`, before its driver exists. It is rejected like any unregistered id, and the error lists the registered agents.
- `--model` is given with no `--agent`. It overrides the model of the agent the configuration selects.
- `--judge-model` is given with `--no-judge`. The judge is off, but the model still applies to the reply fallback.
- The judge agent is the agent under test, as it is for Copilot today. The run needs only that agent's key, and the judge still uses its own throwaway home.
- A driver's native request matches none of the neutral kinds. It maps to `other`, which the policy rejects, so an unknown request never passes by default.
- A driver reports no SDK or runtime version. The report records `unknown` rather than failing the run.
- A driver has no one-shot question. It can still be the agent under test; it cannot be the judge agent.
- An old run folder, created before this change, is passed to `--promote`. It has no agent in its name and was a Copilot run, so promotion works as before.
- A key appears in a transcript in a format the redaction does not know. Variables whose names hold KEY, TOKEN, or SECRET are still redacted by value, as today.
- An attempt times out or reaches the turn limit. Its block shows the turns up to that point, then the failure.
- A scenario is blocked by a failed earlier chain stage, or skipped, and never runs. It has no attempt block; its table row gives the reason.
- An agent reply is very long. The default log prints it in full; the size measured in the live check decides whether a later spec caps passing replies.
- The run is interrupted. The blocks already printed stay in the log, and the closing table is missing, which shows the run did not finish.
- Standard output is a terminal rather than a file. The log is the same; the progress notes on standard error interleave with it on screen.
- A full run passes every chain stage without `--transcripts`. No candidate snapshots are saved, and the log says to rerun with `--transcripts <dir>` to get snapshots for `--promote`.
- `--transcripts` names a folder inside the repository. The harness writes there as asked; keeping it out of version control is the maintainer's choice, since no folder is gitignored for run output.

## Requirements *(mandatory)*

### Functional Requirements

**Agent selection and models**

- **FR-001**: The harness MUST accept `--agent <id>` to select the agent under test. `harness.config.json` MUST hold an `agent` field, `copilot` in this spec, which the switch overrides for one run.
- **FR-002**: `harness.config.json` MUST replace `model` with `models`, a map from agent id to model id, holding `{ "copilot": "gpt-5.6-luna" }` in this spec. `--model <id>` MUST override the selected agent's model for one run.
- **FR-003**: A selected agent with no `models` entry and no `--model` MUST exit 2 before any scenario starts and name the missing entry. A configuration that still holds `model` MUST exit 2 and say to use `models`.
- **FR-004**: Only agents with a registered driver MUST be accepted. Any other id MUST print the error, the registered agents, and a pointer to `--help`, and exit 2.

**Driver split and registry**

- **FR-005**: What every driver shares MUST stay in one shared module: the transcript entry, the attempt result, usage, the reply loop helpers, rate-limit retries, and the permission policy. The Copilot driver MUST move to its own file under `harness/src/drivers/`, with its behavior unchanged.
- **FR-006**: A registry MUST map each agent id to its driver, key variables, install call, error classifier, read roots, version report, and optional one-shot question. The runner MUST take all of these from the registry and MUST NOT import a driver directly.

**Neutral permission request**

- **FR-007**: The permission policy MUST decide a neutral request: a kind (`read`, `write`, `shell`, `memory`, `url`, or `other`) with an optional path, command, or URL. Each driver MUST map its native requests to that shape and map the decision back.
- **FR-008**: The policy's decisions and feedback text MUST NOT change. A request of kind `other` MUST be rejected.

**Agent home and plugin install**

- **FR-009**: The per-attempt agent home MUST be agent-neutral in name and handling. Each driver MUST name its read roots, the folders under that home where its installed plugin sits. Copilot's is `installed-plugins/` under the home.
- **FR-010**: The shared install checks MUST stay in one place and run after every driver's install call: plugin name `highway`, skill count equal to the build's, no warning, and enabled. Any install failure MUST be the `plugin-install` failure kind.

**Keys, errors, and redaction**

- **FR-011**: Each agent MUST name its key variables. The `missing-token` and `no-access` failures MUST name the selected agent's key variable and service. Copilot MUST keep `COPILOT_GITHUB_TOKEN` and `GITHUB_TOKEN`.
- **FR-012**: Error classification MUST use the selected driver's classifier, so Copilot's service error and rate-limit text stay Copilot's. The shared retry and stop rules MUST NOT change.
- **FR-013**: Redaction MUST add the value formats of the planned agents' keys: Cursor's `cursor_` and Google's `AIza`. The existing redaction of Anthropic and OpenAI (`sk-`), GitHub (`gh*_`, `github_pat_`) keys, and of variables whose names hold KEY, TOKEN, or SECRET MUST stay.

**Judge and reply fallback**

- **FR-014**: `harness.config.json` MUST hold a `judge` block naming the judge's agent and model, `{ "agent": "copilot", "model": "gpt-5.6-luna" }` in this spec. The judge and the reply fallback MUST both use it.
- **FR-015**: `--judge-agent <id>` and `--judge-model <id>` MUST each override the matching field for one run. A switch MUST take precedence over the configuration file.
- **FR-016**: Before any scenario starts, a run MUST exit 2 when the `judge` block is missing or has an empty field (naming it), when the judge agent is not registered or offers no one-shot question, or when the judge agent's key is not in the environment (naming the key variable). `--no-judge` MUST skip the key check.
- **FR-017**: With `--no-judge`, the run MUST produce no verdicts. The reply fallback MUST still use the `judge` block when the judge agent's key is present. When it is absent, the run MUST start without the fallback, and the log header, and the report when one is written, MUST say so.
- **FR-018**: Each judge call MUST run in its own throwaway agent home, with no plugin installed and no project. Each result and the report header MUST record the judge's agent and model.

**Report, run folder, and fixtures**

- **FR-019**: Each result and the report header MUST record the agent, its SDK version, and its runtime version, as the driver reports them, replacing the fixed Copilot SDK and CLI line. A version the driver does not report MUST be recorded as `unknown`.
- **FR-020**: The harness MUST write a run folder only when `--transcripts <dir>` is given, and `<dir>` MUST be required: `--transcripts` alone exits 2. There MUST be no default run folder. `harness.config.json` MUST drop its `transcripts` field, and a configuration file that still holds it MUST exit 2 and say to use `--transcripts <dir>`. Without `--transcripts`, the run MUST write no transcript, report, or candidate snapshot anywhere. When a run folder is written, a Copilot run folder name MUST keep today's shape, and any other agent's MUST carry the agent id after the run type.
- **FR-021**: `--promote` MUST accept only a Copilot run folder until Phase 16 (Agent hardening). Any other agent's run MUST exit 2, say why, and change no fixture.

**Run log**

- **FR-022**: Standard output MUST carry only the run log: the run header (run id, commit, run type, agent, model, judge agent and model or `off`, SDK and runtime versions, start time), the selected scenarios with their reasons, one block per attempt, and the closing table. Configuration, selection, and promotion errors MUST also print there, as today. Progress notes MUST go to standard error.
- **FR-023**: Each attempt's block MUST print whole when the attempt ends. Blocks MUST appear in selection order, then attempt order, regardless of the order attempts finish in.
- **FR-024**: By default a block MUST read as a plain conversation, in turn order, with each entry starting on its own line with a lowercase label and a colon: `user:` for the person's message, `agent:` for the agent's reply in full, `files:` for the project files that turn created, changed, or deleted, `skill:` for skill invocations, `question:` and `answer:` for questions and their answers, `denied:` for denied permission requests, and `system:` for system entries (plugin install, session errors, retries). Continuation lines of a multi-line entry MUST be indented two spaces. A `files:` line MUST follow the agent reply of each turn that changed the project, list relative paths each followed by `(created)`, `(changed)`, or `(deleted)`, separated by commas, and MUST be left out when the turn changed nothing. File contents MUST NOT appear. It MUST end with `result: pass`, or one `fail:` entry per failure with its kind, check, expected value, and actual value, followed by one `not met:` entry per bullet the judge marked not met, with its bullet text and the judge's one-sentence reason. It MUST NOT show approved permission requests, per-attempt usage, met verdicts, or the judge's quoted evidence.
- **FR-025**: The log MUST hold no timestamp other than the header's start time, no color codes, and no temporary folder path: project paths MUST be relative to the project, and agent home paths MUST start with `<home>/`. Every line MUST pass through the run's redaction.
- **FR-026**: The closing table MUST have one row per selected scenario: scenario, skill, status, attempts, turns, and a one-line summary (the failure kind and check for a failure, the reason for a blocked or skipped scenario, otherwise the count of met judge verdicts such as `judge 2/7 met`, or `-` when the judge is off or covers no bullet). The run's counts, usage, and exit code MUST follow it, then the run folder path when one was written. A full run that passes every chain stage without `--transcripts` MUST say that no candidate snapshots were saved and how to get them. The table MUST replace today's summary text.
- **FR-027**: `--verbose` MUST add `approved:` entries for approved permission requests and a `usage:` entry per attempt to each block, and change nothing else. It MUST NOT write a run folder; only `--transcripts` does.

**Help and documentation**

- **FR-028**: `--help`, the switch test, and `harness/README.md` MUST list `--agent`, `--judge-agent`, and `--verbose`, the changed meaning of `--model`, `--judge-model`, and `--transcripts` (no default; the folder is required), and the `agent`, `models`, and `judge` configuration fields.
- **FR-029**: `harness/README.md` MUST describe the registry and what a new driver supplies, so a driver spec can follow it. It MUST also describe the run log, standard error progress, how a spec can capture its log, with `> specs/<spec>/harness/smoke.log` as an example rather than a naming rule, and when to add `--transcripts <dir>`.
- **FR-029a**: `harness/runs/` MUST be retired: the folder and its contents deleted where present, its line removed from `.gitignore`, `tests/harness-placement.test.sh` no longer requiring that line, and no harness file, test, or README naming it. `harness-model-findings.md` MUST stop saying the spec 242 affected run's transcripts are under `harness/runs/`, and say they were not kept.

**Tests**

- **FR-030**: Unit tests MUST cover: agent selection and its errors, including a selected agent missing from `models` and the old `model` field; the registry; each judge setting (configuration only, each switch overriding it, a missing or empty field, an unregistered judge agent, one with no one-shot question, a missing judge key, and `--no-judge`); mapping native Copilot requests to the neutral shape and back; the `other` kind rejected; redaction of each key format; the run folder name with and without the agent; no run folder without `--transcripts`, `--transcripts` with no folder, and a configuration still holding `transcripts`; `--promote` refused for another agent; and the run log (block contents, block order under parallel attempts, path rewriting, the closing table for pass, fail, flaky, blocked, and skipped scenarios, the missing-snapshots note, `--verbose`, and nothing but progress on standard error).
- **FR-031**: A fake second driver, registered only in the tests, MUST run a scenario end to end through the runner, proving a driver plugs in without a runner change.

**Live check and findings**

- **FR-032**: After the full suite and the runner tests pass, one `--agent copilot --smoke` run MUST complete without `--transcripts`, with its standard output saved to `specs/247-multi-agent-harness-groundwork/harness/smoke.log`. The log is meant to be committed. A deep-dive rerun with `--transcripts` MUST write outside the repository. No secret or token MUST appear in the log.
- **FR-033**: Every failure in the smoke run MUST be matched to a finding in `harness-model-findings.md` in its existing format. A match adds a Runs line to the existing finding. A failure caused by this change MUST block completion and MUST be fixed in this spec.

**Unchanged**

- **FR-034**: No skill, template, fixture, or scenario MUST change. The bash suite MUST pass unchanged, apart from the switch and README checks that list the new switches.
- **FR-035**: When the work is done, `rollout-plan.md` MUST mark Phase 5 complete in its phase table, naming this spec's folder, and add a Status paragraph recording what was done beyond its items, including the run log.

### Key Entities

- **Agent**: an id (`copilot` in this spec) with a registered driver, key variables, an install call, an error classifier, read roots, a version report, and an optional one-shot question.
- **Driver registry**: the map from agent id to agent. The runner's only source of agent-specific behavior.
- **Neutral permission request**: a kind (`read`, `write`, `shell`, `memory`, `url`, `other`) with an optional path, command, or URL. The policy's only input.
- **Agent home**: the agent's configuration folder made for one attempt or one judge call, holding only what that attempt needs. Removed with the attempt.
- **Judge setting**: the judge's agent and model, from the `judge` block or the switches. Used by the judge and the reply fallback.
- **Run record**: the report header and each result, naming the agent, its SDK and runtime versions, the model, and the judge's agent and model.
- **Run log**: the run's standard output: header, selection, one block per attempt in selection order, and the closing table. Small enough to commit with the spec that ran it.
- **Attempt block**: one attempt's turns as labeled lines (`user:`, `agent:`, `files:`, and the rest), filtered and with rewritten paths, ending in `result: pass` or its `fail:` entries, then its `not met:` entries.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every existing runner test passes, with changes limited to renamed fields and the new run log output, and the full bash suite passes.
- **SC-002**: A fake second driver runs a scenario end to end with 0 changes to the runner, the policy, or the install checks.
- **SC-003**: Each invalid setting (unknown agent, missing `models` entry, old `model` field, missing or empty judge field, unregistered judge agent, judge agent with no one-shot question, missing judge key) exits 2 before any scenario starts and names what is wrong.
- **SC-004**: For every request kind Copilot sends today, the policy's decision and feedback text are identical before and after the change.
- **SC-005**: A Copilot smoke run installs the plugin with all 16 skills in every attempt, shows 0 failure kinds not seen in the spec 246 smoke runs, and every failure is matched to a finding.
- **SC-006**: The smoke log is the only file the smoke run adds to the repository, and a search finds no key, token, or temporary folder path in it.
- **SC-007**: A Copilot run given `--transcripts` writes a folder whose name and report differ from before only in the added agent and judge fields. A run without it writes 0 files outside its throwaway work folder.
- **SC-008**: The smoke log is under 100 KB, at least 99% smaller than spec 246's 55 MB smoke run folder, and a maintainer can name the failing check, the exchange where it went wrong, and the files each turn touched, for every failed attempt, from the log alone.
- **SC-009**: Two runs of the fake driver with the same turns produce logs that differ only in the header's run id and start time.

## Assumptions

- Spec 246 is complete: the harness installs `highway-agent-plugin/` into a throwaway Copilot home per attempt, the suite passes 87 tests, and the harness has 102 runner unit tests.
- The live smoke run uses the configured Copilot model, `gpt-5.6-luna`, with the token in `harness/.env`. The token is never printed.
- The reply fallback today works under `--no-judge`. This spec keeps that, where `rollout-plan.md` Phase 5 item 7 would have left the fallback off. With only Copilot registered, the judge agent and the agent under test share one key, so Copilot runs behave as today.
- Run folders keep today's name for Copilot, so existing tooling and the promotion of older run folders are unaffected. "Default agent" in `rollout-plan.md` Phase 5 item 8 is read as Copilot.
- The run log is part of this spec at the maintainer's request, though `rollout-plan.md` Phase 5 does not list it. The size estimate comes from spec 246's smoke run `20261113-142757Z-smoke-be6a1d0`: a 55 MB run folder whose readable transcripts total 142 KB, of which 82 KB are approved permission requests. `report.md` and its Coverage section are unchanged and stay in the run folder.
- At the maintainer's request, run folders are written only with `--transcripts <dir>`, and `harness/runs/` is retired as part of this spec (FR-029a). On the maintainer's machine the folder's only run, the spec 242 affected run `20261112-171321Z-targeted-49ab958`, was already deleted while this spec was drafted. Its findings and the summaries in specs 242 and 243 stand without it. This spec needs no `.gitignore` line for its own folder. Spec 246's run folders and its `.gitignore` line are left as they are.
- A pipeline that needs `junit.xml` or `report.json` (Phase 3) passes `--transcripts <dir>`.
- Specs are not required to run the harness or commit a log. This spec does, for its live check. Naming logs and running the harness for every spec belong to `rollout-plan.md` Phase 18, "Harness runs on every spec".
- No new runtime or SDK is added, so the development constitution's Harness Toolchain is unchanged and no amendment is needed.
- The open Harness Failures F23 and F28 (harness check bugs) are not fixed here. They belong to Phase 3. A smoke failure that matches them is recorded, not fixed.
- Constraints carried from earlier work: do not commit unless asked; secrets and tokens are redacted; `rollout-plan.md` stays gitignored and excluded from the distribution; MINOR version bumps only; no backward compatibility; use `mv`, not `git mv`.
