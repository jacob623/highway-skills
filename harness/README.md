# Highway Behavioral Test Harness

The harness runs Highway skills in real agent conversations and checks what they write. Each
scenario opens a skill in a fresh test project, answers the skill's questions from a script, and
then checks the files against the scenario's expectations, the storage contract, and an advisory
LLM judge.

The harness is a development tool. `harness/` is excluded from the distribution, and its toolchain
(Node, TypeScript, the Copilot SDK, the Cursor SDK, the Codex SDK, the Claude Agent SDK, and `git`)
is never a runtime dependency of Highway.

## How it works

### One test project per attempt

For each attempt, the runner builds a new project in a temporary folder:

1. The base, made once per run: an empty folder. The skills are not copied into the project; each
   attempt installs the Agent Plugins build, `highway-agent-plugin/`, into its own agent home,
   as a person installs the plugin. The project holds nothing from `framework/`, `tests/`,
   `harness/`, or the plugin.
2. The scenario's fixture on top: a stage snapshot from `harness/fixtures/stages/`, or an overlay
   from `harness/fixtures/overlays/` applied to its stage. `empty` adds nothing.

The project is snapshotted before the conversation starts and compared with its state afterward.

Before any scenario runs, the runner checks the plugin with
`framework/generate-agent-plugin.sh --check`. A missing or stale plugin stops the run with
`build-failed` and exit 2, so a run never tests skills older than their sources.

### Agents and drivers

The harness tests one agent per run, chosen with `--agent` or the `agent` field of
`harness/harness.config.json`. `harness/src/agents.ts` holds the registry: each entry maps an
agent id to everything the runner needs from that agent. The runner imports no driver; it takes
all of these from the selected entry.

| Field | What it supplies |
|---|---|
| `id` | The registry key, used by `--agent`, `--judge-agent`, and the `models` map |
| `service` | The service name used in the `missing-token` and `no-access` messages |
| `keys` | The key variables, read in order; the last is the one a person sets in `harness/.env` |
| `driver` | Runs one attempt; see below |
| `ask` | Optional. A one-shot question with no tools, in its own throwaway home with no plugin and no project; required of a judge agent |
| `classify` | Maps the agent's errors to failure kinds, so the shared rate-limit and service-error retries use the agent's own error text |
| `readRoots` | The folders under the attempt's agent home where the installed plugin sits; reads there are approved |
| `versions` | The SDK and runtime versions for the header and the report; `unknown` when a version cannot be read |

A driver spec adds `harness/src/drivers/<id>.ts` and one registry entry, and changes nothing else
in `harness/src/`. Its driver:

1. Starts the agent with the attempt's agent home as its configuration home and the test project
   as its working folder.
2. Installs the plugin by adapting its plugin interface to `PluginRpc` and calling the shared
   `installPlugin`, which runs the shared checks: plugin name, skill count, no warning, and
   enabled. A failed install returns outcome `error` with kind `plugin-install`.
3. Maps each native permission request to an `AccessRequest` (`read`, `write`, `shell`, `memory`,
   `url`, or `other`, with a path, command, or URL), decides it with the shared `permissionPolicy`
   and the attempt's read roots, records rejections, and maps the decision back.
4. Logs transcript entries: `user`, `agent` once at the end of each turn, `question`, `answer`,
   `permission` with the decision's summary, `skill` as `invoked <name>`, and `system`.
5. Wraps service calls in `withRateLimit` and `retryServiceError` with its classifier, and throws
   `RunStop("no-access")` when the service refuses the key.

The runner creates and removes the agent home for each attempt. `harness/test/runner.test.ts`
registers a fake second agent and runs a scenario end to end through the runner, which shows the
contract is enough.

### The Copilot driver and its permissions

The Copilot driver, `harness/src/drivers/copilot.ts`, is GitHub Copilot through
`@github/copilot-sdk`, local runtime. Each attempt gets its own client, its own temporary agent
home, and one session whose working directory is the test project. Before the session starts, the client installs `highway-agent-plugin/` into that home
with its plugin install, enabling the plugin if it is not enabled. The transcript's first
`system` entry names the plugin and the number of skills installed, and the install's deprecation
warning when it gives one. The attempt fails with `plugin-install`, and no session starts, when
the install throws, installs fewer skills than the plugin holds, reports a manifest warning, or
leaves the plugin disabled. Config discovery is on, so the session finds the installed skills the
same way the Copilot CLI does. Session storage and telemetry are off.

Every permission request is decided by a fixed policy:

| Request | Decision | Ends the attempt |
|---|---|---|
| Read inside the project | approved | no |
| Read of the installed plugin, under a read root (Copilot: `<home>/installed-plugins/`; Cursor: `<home>/.cursor/plugins/local/highway/`) | approved | no |
| Write inside the project | approved | no |
| Read anywhere else | rejected | no |
| Web (URL) access | approved when the scenario says `web: yes`, otherwise rejected | no |
| Write outside the project, including the installed plugin | rejected | yes |
| Shell command | rejected | yes |
| Memory | rejected | yes |
| Any other tool (`other`) | rejected, named by its native kind | no |

Shell, memory, and outside writes are fatal because the storage contract
(`skills/highway-experience/references/storage-contract.md`) forbids them. A rejected request that ends the attempt is a
`rejected-request` failure.

### The Cursor driver

The Cursor driver, `harness/src/drivers/cursor.ts`, uses `@cursor/sdk` on the **local** runtime
only (`--agent cursor`). Auth is `CURSOR_API_KEY` in `harness/.env`. The model is `models.cursor`
in `harness.config.json` (today `gpt-5.6-luna`, same as Copilot).

Each attempt:

1. Points `HOME` at the throwaway agent home (serialized with a mutex so parallel attempts do not
   race).
2. Copies `highway-agent-plugin/` into `<home>/.cursor/plugins/local/highway/` and runs the shared
   install checks (name `highway`, 16 skills, enabled).
3. Loads plugins with `local.settingSources: ["plugins"]` only — no personal user/project/team
   settings.
4. Offers no shell tool; home-scoped hooks deny shell and outside writes; completed forbidden
   tools fail the attempt afterward (effects-based enforcement). Cloud/remote Cursor is Phase 20,
   not this driver.
5. Maps skill activation from `tool_call` reads under `…/skills/<skill-id>/` (including
   `highway-experience/SKILL.md`), remapping `.cursor/plugins/local/highway/…` paths onto the
   install read root so workspace-rooted plugin paths still count. Does not treat the
   `highway/skills` directory name as a skill id. Commits “first output” for experience-order
   only after the turn’s `agent` log line (streamed text tokens before tools do not clear
   `skillsBeforeOutput`).

`cursorAsk` is registered. The configured judge for Phase 9+ confirmation is Cursor with Luna
(`judge.agent=cursor`).

### The Codex driver

The Codex driver, `harness/src/drivers/codex.ts`, uses `@openai/codex-sdk` (`--agent codex`). Auth
reads `OPENAI_API_KEY` then `CODEX_API_KEY` in `harness/.env`. The model is `models.codex` in
`harness.config.json` (today `gpt-5.6-luna`, or the closest Luna/GPT-5.6 id research pinned).

Each attempt:

1. Sets throwaway `CODEX_HOME` and `HOME` to the agent home via a fully controlled SDK `env` bag
   (no personal `~/.codex` or `~/.agents`). Writes harness-authored Local-mode `AGENTS.md` and
   `$CODEX_HOME/rules/default.rules` that **forbid `git` before run** (not the operator's personal
   config).
2. Copies `highway-agent-plugin/` into `<home>/plugins/highway/` (absolute local marketplace path),
   enables plugins in `<home>/config.toml`, best-effort `codex plugin marketplace add` /
   `codex plugin add` under that home (skip with `HIGHWAY_CODEX_SKIP_PLUGIN_CLI=1` in unit tests),
   and runs shared install checks (name `highway`, 16 skills, enabled). Accepts
   `.codex-plugin/plugin.json` with its `interface` block.
3. Starts threads with `sandboxMode: workspace-write`, network access off,
   `skipGitRepoCheck: true`, and `approvalPolicy: never`.
4. Enforces storage: **pre-refuse `git`** (logged, non-fatal so the attempt may continue); **effects
   backup** fails the attempt if `git` still completes; outside paths and network-facing installs
   still fail after effects. In-project reads/writes and in-project build/test shell remain allowed.
5. Maps `command_execution`, `file_change`, agent messages, and `turn.completed` usage into the
   shared transcript, skills lists (including `highway-experience/SKILL.md` path reads), and usage.

`codexAsk` is registered (no plugin, throwaway home) so `judge.agent` can be set to `codex`
later; the configured judge remains Cursor with Luna.

### The Claude Code driver

The Claude Code driver, `harness/src/drivers/claude.ts`, uses `@anthropic-ai/claude-agent-sdk`
(`--agent claude`). Auth is `ANTHROPIC_API_KEY` in `harness/.env`. The model is `models.claude` in
`harness.config.json` (pinned to current Haiku, today `claude-haiku-5-5`).

Each attempt:

1. Sets throwaway `HOME` and `CLAUDE_CONFIG_DIR` under the agent home via the SDK `env` bag, with
   auto-memory disabled and `settingSources: []` so personal Claude config does not reach the run.
   Drive sessions append Local-mode / no-Bash guidance through
   `systemPrompt: { type: "preset", preset: "claude_code", append }` so the model always receives
   it at session start. A supporting `<home>/.claude/CLAUDE.md` is still written each attempt but
   is not relied on alone (it does not load with empty setting sources). `claudeAsk` stays
   `settingSources: []` without that append.
2. Copies `highway-agent-plugin/` into `<home>/plugins/highway/` and loads it with
   `plugins: [{ type: "local", path }]`. Claude Code reads `.claude-plugin/plugin.json`. Shared
   install checks require name `highway`, 16 skills, enabled.
3. Enforces storage through `canUseTool`: project and plugin reads/writes are allowed; **every
   Bash request is denied** (Claude has Read/Write/Edit/Glob/Grep — no Codex-style in-project
   shell allow; refuse still fails the attempt as `rejected-request`); memory and out-of-project
   writes are denied. If a forbidden tool still runs, effects backup fails the attempt.
4. Resumes the same session id for each scripted reply. `AskUserQuestion` is answered from
   scripted replies when present; otherwise the reply loop handles text questions.
5. Maps assistant text, tool uses (including Skill / `/highway:…`), and result usage/cost into the
   shared transcript.

`claudeAsk` is registered (no plugin, throwaway home) so `judge.agent` can be set to `claude`
later; the configured judge remains Cursor with Luna.

### Keyed replies and the model fallback

A scenario's replies are keyed by the question the skill asks:

- `ask:` is the exact question text from the skill. It matches when it appears anywhere in the
  agent's message, ignoring `**`, case, and runs of whitespace.
- `ask-pattern:` is a regular expression for a question the skill does not spell out.

Replies are used in file order, and each is used once, so the same question can get a different
reply each time it is asked. After each agent turn, the driver sends the first unused reply whose
key appears in the message. When no key appears and the message asks something, the judge agent
and model decide, in a new session that sees only the agent's last message, whether the earliest unused
reply answers it. No later reply is offered, so a reply written for a later question is never
spent early. That pick records a **paraphrased question** warning with the expected and actual
question. When the fallback answers "none", the attempt fails as `unmatched-question`, or as
`repeated-question` when the same question was already answered in the attempt. A message that
asks nothing ends the conversation. `--no-judge` does not turn the fallback off; only a missing
judge agent key does, and the header then reads `fallback=off`.

A question the agent asks through the input tool is answered inside the turn. At the end of that
turn, only the text after the last such answer is judged, so an answered question is not matched
again.

### Checks, in order

1. **File assertions**: each `expect:` line in the scenario.
2. **Invariants**: every file the conversation changed matches a `writes:` pattern (a scenario
   with no `writes:` must write nothing), no shell, memory, or outside-write request was made, and
   highway-experience was activated before the first output the person sees. The first output is
   the first question sent to the person, or the first top-level message that requests no tool.
   An approved read of `highway-experience/SKILL.md` counts as its activation.
3. **Judge** (advisory): a one-shot question to the judge agent and model from the `judge` block
   (or `--judge-agent` and `--judge-model`), in its own throwaway home, reads the
   finished transcript, the written files, and the text of the bullets the scenario covers. It
   answers met or not met for each bullet, with a quote. A met verdict without a quote, or with a
   quote that is not in the transcript or files, counts as not met. The judge never changes the
   exit code. `--no-judge` skips it, and the result records that it was skipped.

### Retry and warnings

A failed attempt is retried once in a new project, and both attempts are kept. A pass on the
second attempt counts as a pass and records a **flaky** warning. Flaky scenarios are counted
within passed; the summary's flaky count is a subset of it. A failure on the second attempt is the
scenario's failure. Rate limits are retried inside an attempt (waits of 5, 20, and 60 seconds) and
do not count as attempts.

Warnings (paraphrased question, flaky) never change the exit code.

## Setup

1. Node 24 or later on the `PATH`.
2. Install dependencies: `npm --prefix harness ci`.
3. For live runs, put the agent key in `harness/.env`:

   ```text
   GITHUB_TOKEN=<token>
   CURSOR_API_KEY=<token>
   ANTHROPIC_API_KEY=<token>
   ```

   Copilot reads `COPILOT_GITHUB_TOKEN` then `GITHUB_TOKEN`. Cursor reads `CURSOR_API_KEY`.
   Codex reads `OPENAI_API_KEY` then `CODEX_API_KEY`. Claude reads `ANTHROPIC_API_KEY`.
   Each agent names its own key variables in the registry. `harness/.env` and
   `harness/node_modules/` are gitignored.

Unit tests and the type check need no token: `npm --prefix harness test` and
`npm --prefix harness run typecheck`.

## Running

Run from the repository root with `node harness/src/cli.ts [switches]`, or
`npm --prefix harness run harness -- [switches]`.

| Run | Example | What runs |
|---|---|---|
| Full | `node harness/src/cli.ts` | The six-stage chain, then every scenario |
| Smoke | `node harness/src/cli.ts --smoke` | One smoke scenario per skill (16) |
| Targeted | `node harness/src/cli.ts --changed-since origin/main` | Scenarios affected by changed files |
| Targeted | `node harness/src/cli.ts --paths skills/highway-codify/assets/codify-plan.md` | Scenarios affected by these paths |
| Targeted | `node harness/src/cli.ts --skills highway-codify` | Every scenario of these skills |

### Switches

| Group | Switch | Argument | Default | Usage |
|---|---|---|---|---|
| Selection | `--smoke` | — | off | Run one smoke scenario per skill |
| Selection | `--changed-since` | `<ref>` | — | Run scenarios affected by files changed since `<ref>` |
| Selection | `--paths` | `<files>` | — | Run scenarios affected by these comma-separated paths |
| Selection | `--skills` | `<ids>` | — | Run scenarios for these comma-separated skill ids |
| Agent | `--agent` | `<id>` | `harness.config.json` `agent` | Agent under test |
| Agent | `--plugin-source` | `local\|public` | `local` | Install from the local `highway-agent-plugin/` build, or from a pinned public clone of `highway-systems/agent-plugin` |
| Agent | `--plugin-ref` | `<tag\|sha>` | — | Required with `--plugin-source public`: git tag or commit to clone |
| Agent | `--model` | `<id>` | `harness.config.json` `models` entry | Model for the agent under test |
| Agent | `--judge-agent` | `<id>` | `harness.config.json` `judge.agent` | Agent for the judge and the reply fallback |
| Agent | `--judge-model` | `<id>` | `harness.config.json` `judge.model` | Model for the judge and the reply fallback |
| Agent | `--no-judge` | — | off | Skip the judge |
| Execution | `--parallel` | `<n>` | 4 | Scenarios run at once |
| Execution | `--max-turns` | `<n>` | 40 | Turn limit per attempt |
| Execution | `--timeout` | `<minutes>` | 20 | Time limit per attempt, in minutes |
| Output | `--transcripts` | `<dir>` | — | Write a run folder (transcripts, reports, candidate snapshots) under `<dir>`; the folder is required |
| Output | `--verbose` | — | off | Add approved permission requests and usage to the run log |
| Fixtures | `--promote` | `<run folder>` | — | Replace stage fixtures with a run's candidate snapshots |
| Help | `--help`, `-h` | — | — | Print the help and exit 0 |

No selection switch runs the full suite. `--changed-since`, `--paths`, and `--skills` combine as a
union, and each scenario keeps every reason it was selected. `--smoke` and `--promote` are used
alone. The chain always runs one stage at a time.

### Configuration

`harness/harness.config.json` holds the defaults the switches override for one run:

```json
{
  "agent": "copilot",
  "models": { "copilot": "gpt-5.6-luna", "cursor": "gpt-5.6-luna", "codex": "gpt-5.6-luna" },
  "judge": { "agent": "cursor", "model": "gpt-5.6-luna" },
  "parallel": 4,
  "maxTurns": 40,
  "timeoutMinutes": 20
}
```

| Field | Meaning |
|---|---|
| `agent` | The agent under test, a registered id |
| `models` | A map from agent id to model id; the selected agent needs an entry, or `--model` |
| `judge` | The agent and model for the judge and the reply fallback; the judge agent needs a one-shot question |
| `parallel`, `maxTurns`, `timeoutMinutes` | Execution defaults |

Every setting is checked before the header prints. An unregistered agent, a missing `models`
entry, a missing or empty `judge` field, an unregistered judge agent or one with no one-shot
question, or a missing judge key prints `Configuration error: ...` and the `--help` pointer, and
exits 2. The judge key is not checked under `--no-judge`, or when the judge agent is the agent
under test (that key's absence is a `missing-token` failure). A file that still holds the old
`model` field is refused with a pointer to `models`, and one that still holds `transcripts` with a
pointer to `--transcripts <dir>`.

### Exit codes

| Code | Meaning |
|---|---|
| 0 | Every gated check passed, or the selection was empty |
| 1 | A scenario failed or was blocked, or a chain stage failed |
| 2 | The run could not start or was stopped: an invalid switch or setting, a missing key, no access to the agent's service, a missing or stale plugin, a persistent rate limit, or a used-up premium-request allowance |

Exit 2 takes precedence over exit 1.

## Reading results

### The run log

Standard output carries only the run log; progress notes (`[ 3/16] start ...`, `PASS`, `FAIL`)
go to standard error. The log is small and stable enough to commit, so a spec can keep the
evidence of its own run:

```bash
node harness/src/cli.ts --smoke > specs/<spec>/harness/smoke.log
```

The path is an example, not a naming rule. The log has no color codes, and no timestamp other
than the header's start time. Paths inside the test project are relative to it, the agent home
is `<home>`, the run's work folder is `<work>`, and any other path under the system temporary
folder is `<tmp>`. Keys and tokens are redacted.

```text
HARNESS run=20261114-120000Z-smoke-a1b2c3d commit=<sha> type=smoke agent=copilot model=gpt-5.6-luna judge=copilot/gpt-5.6-luna fallback=copilot/gpt-5.6-luna sdk=1.0.30 runtime=1.0.108 started=2026-11-14T12:00:00.000Z
Selected 16 scenario(s):
  help-smoke: --smoke

== help-smoke (highway-help) attempt 1 ==
system: installed plugin highway (16 skills)
  Direct plugin installs (repos, URLs, local paths) are deprecated. ...
user: /highway-help
skill: highway-experience
skill: highway-help
denied: read <home>/config.json
agent: Highway needs setup.
  Run /highway-setup to get started.
files: out/answer.md (created)
result: pass

== summary ==
| Scenario | Skill | Status | Attempts | Turns | Summary |
|---|---|---|---|---|---|
| help-smoke | highway-help | pass | 1 | 1 | judge 2/2 met |
Passed 1, failed 0, flaky 0, blocked 0, not run 0, skipped 0
Usage: 6 model calls, 120000 input tokens, 900 output tokens
Exit code: 0
```

Each attempt prints one block, whole, when it ends. Blocks appear in selection order, then
attempt order, whatever order the attempts finish in. A block reads as the conversation, one
labeled entry per line, with continuation lines indented two spaces:

| Label | Entry |
|---|---|
| `user:` | The person's message, from the scenario |
| `agent:` | The agent's reply for the turn, in full |
| `files:` | After a reply that changed the project: each path with `(created)`, `(changed)`, or `(deleted)`; no contents |
| `skill:` | A skill the agent invoked |
| `question:` / `answer:` | A question through the input tool, and the reply sent |
| `denied:` | A rejected permission request |
| `system:` | The plugin install, a session error, or a retry |
| `warning:` | A paraphrased question the fallback answered |
| `result: pass` | The attempt passed |
| `fail:` | One per failure: kind, check, path, expected, and actual |
| `not met:` | One per bullet the judge marked not met, with its one-sentence reason |

A run-level failure (missing key, failed build, rate limit, failed chain stage) prints a
`== run ==` block with its `fail:` line and its likely cause. A scenario whose fixture fails
validation prints a `blocked` block with the fixture's problems.

The closing table has one row per selected scenario. Its Summary is the failure kind and check
for a failure, the reason for a blocked, skipped, or not-run scenario, and otherwise the met
judge verdicts, or `-` when the judge is off or covers no bullet. Counts, usage, and the exit
code follow it.

`--verbose` adds `approved:` lines for approved permission requests and a `usage:` line per
attempt, and changes nothing else.

### Run folders

Without `--transcripts`, a run writes no file outside its throwaway work folder, which it
removes. Add `--transcripts <dir>` for a deep dive into a failure the log does not explain, or to
save a full run's candidate snapshots for `--promote`. Point it outside the repository, for
example `"$TMPDIR/harness"`.

The run folder is named `<UTC start>-<run type>-<short commit>` for Copilot, for example
`20261110-153512Z-targeted-a1b2c3d`. Any other agent's id follows the run type, as in
`20261110-153512Z-targeted-cursor-a1b2c3d`.

```text
<dir>/20261110-153512Z-targeted-a1b2c3d/
  report.md            Run report: agent, versions, judge, results, warnings, verdicts, usage, coverage
  report.json          The same data as JSON
  junit.xml            JUnit XML, one test case per scenario
  selection.txt        Each selected scenario and why it was selected
  candidates/<stage>/  Full runs only: each passing chain stage's output
  <scenario id>/
    attempt-1.raw.jsonl     Every SDK event, redacted
    attempt-1.jsonl         The conversation: user, agent, question, answer, permission, skill
    attempt-1.result.json   Outcome, checks, warnings, judge verdicts, usage, agent and models
    attempt-2.*             Present when the first attempt failed
```

Tokens and keys are redacted before any file is written. A full run whose chain passes without
`--transcripts` says that no candidate snapshots were saved.

## Writing tests

### Scenario files

One file per conversation at `harness/scenarios/<skill>/<id>.scenario`. Lines are `key: value`.
Blank lines and lines starting with `#` are ignored.

```text
# The whole path: suggestion, proposal, plan review, task list, coding, and the close.
id: codify-plan-review
skill: highway-codify
fixture: implementation
web: yes
open: /highway-codify Northwind Restock Alerts
ask: Would you like to explore any of these options?
say: [select] 1
ask: What would you add, correct, or remove?
say: [accept] Looks good.
ask: Would you like to:
say: [select] 1
ask: What would you add, correct, or remove?
say: [accept] Nothing to change.
ask: Would you like to:
say: [select] 2
ask: Where would you like to go next?
say: [decline] Nothing else for now.
writes: code/**
expect: template code/*/.highway/features/001-*/codify.md :: codify-record.md
expect: contains code/*/.highway/features/001-*/codify-tasks.md :: [X] T001
expect: heading code/*/README.md :: ## Setup Instructions
covers: ded7741aec3c The menu offers Review the plan and Continue to code the solution. A feature with a plan and no task list resumes at the menu.
reaches: review
reaches: close
```

| Key | Meaning |
|---|---|
| `id` | Unique id; the file name without `.scenario` |
| `skill` | The primary skill; the file's folder |
| `through` | A skill the conversation passes through (repeatable) |
| `fixture` | A stage, an overlay name, or `empty` |
| `smoke` | `yes` for the skill's one smoke scenario |
| `web` | `yes` to allow web access |
| `chain` | Chain position, 1 to 6 |
| `open` | The opening message |
| `ask` / `ask-pattern` | The key for the next `say:` |
| `say` | The reply, optionally prefixed by a kind: `[accept]`, `[edit]`, `[question]`, `[unknown]`, `[decline]`, or `[select]` |
| `writes` | A path pattern the conversation may change (repeatable); none means it writes nothing |
| `expect` | `<assertion> <path-glob>[ :: <argument>]` (repeatable) |
| `covers` | `<hash> <bullet text>` for a bullet the scenario exercises (repeatable) |
| `reaches` | A `###` step of the skill the conversation reaches (repeatable) |
| `shows` | Text the agent must show in its messages, checked after a run that ended (repeatable); whitespace is collapsed and emphasis (`*` runs, and `_` runs at a word boundary) and backticks are not compared, superseding the exact comparison; a miss fails as `assertion` with check `shows` |

In path patterns, `*` matches within one folder and `**` across folders.

| Assertion | Argument | Passes when |
|---|---|---|
| `exists` | — | a file matches |
| `absent` | — | no file matches |
| `heading` | heading line | each match has that line |
| `field` | `Name=Value` | a line `Name: Value`, `**Name:** Value`, or `- **Name:** Value` exists |
| `row` | cell text | a table row contains the text |
| `contains` | text | the text appears in every match |
| `contains-any` | text | the text appears in at least one match (comparison ignores case) |
| `template` | template file name | the structural template check passes |

A reported "step" in results and failure blocks is the skill step of the last keyed question the
agent asked, so it can trail the step the agent was actually in.

### Fixtures and overlays

Stage fixtures are full project snapshots for the Northwind Outfitters example: `setup`,
`request`, `discovery`, `architecture`, and `implementation`. Each later stage holds every earlier
stage's files. Fixtures hold project files only: the installed plugin supplies the skills, so the
fixture check fails a fixture holding `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, or `.agents/skills/`.
A chain stage's snapshot leaves out every path the base supplies.

An overlay is a folder under `harness/fixtures/overlays/<name>/` with `overlay.txt` holding
`stage: <stage>`. Its files replace or add to the stage's files, and an optional `.delete` lists
paths to remove, one per line. Use an overlay for a variation one scenario needs, such as a record
with `Language: Needed`.

Every fixture file that `harness/fixtures/templates.map` maps to an output template must carry
that template's frontmatter keys, required headings, and table header rows. A seeded catalog maps
to its skeleton in `skills/highway-setup/assets/`, and every stage fixture holds all twelve
seeded files. A skeleton has no `## File Frontmatter`, `## Body`, or `## Catalog Structure`
section, so the check reads its parts directly: its leading frontmatter keys, each `## ` heading,
and each table header row. Check with
`bash harness/bin/fixture-check.sh [fixture...]`. A scenario whose fixture fails this check is
reported as blocked and does not run.

### Promoting candidate snapshots

A full run runs the six chain scenarios first, in order: setup, request, discovery, architecture
(through the decision), implementation, and codify. Stage 1 starts from an empty project, and
each later stage starts from the previous stage's output. When every stage passes, each stage's
output is saved under the run folder's `candidates/`, so the full run needs `--transcripts <dir>`.
Review them, then replace the stage fixtures:

```bash
node harness/src/cli.ts --transcripts "$TMPDIR/harness"
node harness/src/cli.ts --promote "$TMPDIR/harness/<run folder>"
```

Fixtures are promoted only from Copilot runs until Phase 16 (Agent hardening): a run folder named
with another agent is refused, and no fixture changes.

Nothing else changes a stage fixture. Outside a full run, chain scenarios start from their
fixtures like any other scenario.

### Covering, checking as an invariant, or waiving a bullet

Each Verification and Error Handling bullet of a skill has a 12-character hash. The inventory
reads `SKILL.md` and each flow file its flows table names, so a step or bullet keeps its hash when
it moves into a flow file. List them with:

```bash
bash harness/bin/inventory.sh highway-codify
```

A bullet is treated in one of three ways:

- **Covered**: a scenario that exercises it lists `covers: <hash> <bullet text>`. The judge
  reports a verdict for it on every run.
- **Invariant**: a line in `harness/coverage/treatments.txt`,
  `invariant: <skill> <hash> <storage|no-shell|writes-nothing> :: <bullet text>`, when a check
  every scenario runs already enforces it. `writes-nothing` needs at least one scenario of that
  skill with no `writes:`.
- **Waiver**: `waiver: <skill> <hash> <reason> :: <bullet text>`, when no scenario can exercise
  it. The reason is required.

highway-codify is gated: every one of its bullets must be treated. Other skills are reported only.

## Selection and coverage

Targeted runs map each changed path to scenarios with `harness/bin/path-map.sh`:

| Changed path | Selects |
|---|---|
| `skills/<skill>/...`, including its `assets/` record templates | Every scenario of that skill, including scenarios that pass through it |
| A shared file listed as `smoke` in `harness/selection/shared.txt`, including every file under `skills/highway-experience/` | The smoke set |
| `harness/src/`, `harness/package*.json`, `harness/harness.config.json` | The smoke set |
| A scenario file | That scenario |
| A stage fixture | Every scenario that starts from that stage, directly or through an overlay |
| An overlay | Every scenario that uses that overlay |
| Generated agent copies, `highway-agent-plugin/`, tests, specs, the catalog, `framework/`, `tests/`, and other files | Nothing |

For `--changed-since <ref>`, changed paths come from `git diff --name-status <ref>` plus untracked
files. A deleted file maps by its path, as a present one does. An empty selection
prints why and exits 0.

The path map reads every location from the framework's paths helper, `framework/lib/paths.sh`,
through `harness/bin/lib/paths.sh`, which each `harness/bin/` script sources.
`path-map.sh --location <skills|framework|plugin>` prints the skills, framework, or plugin
location, which the runner uses to find skills at a ref, to check the plugin, and to install it.
`skills/highway-help/assets/index.json`, highway-help's generated index, selects highway-help.

Coverage is printed in each run report per skill: each bullet's treatment, the reply kinds
exercised, and the steps reached and not reached. When a bullet is reworded, its hash changes.
The old tag becomes unknown, and the report and `harness-coverage.test.sh` show the new bullet
beside the old tag. Retag it by replacing the old hash and text with the new ones from
`inventory.sh`.

## Bash suite checks

`bash tests/run-all.sh` runs these harness checks. None needs Node or a token.

| Check | Fails when | How to fix |
|---|---|---|
| `harness-placement.test.sh` | `harness/` is not excluded in `framework/.distribution-manifest`, `node_modules` or `.env` is not gitignored, or the development constitution lacks the harness toolchain | Restore the manifest line, the `.gitignore` entries, or the constitution paragraph |
| `harness-path-map.test.sh` | A shipped skill asset or highway-experience file maps to no skill and is not in `harness/selection/shared.txt`, or a mapping rule changed | Move the file into the skill that reads it, or add it to `shared.txt` as `smoke` or `none` |
| `harness-fixtures.test.sh` | A fixture file lacks a part of its current template, or an overlay names no stage | Promote a fresh chain run, or fix the fixture by hand |
| `harness-coverage.test.sh` | A highway-codify bullet has no scenario tag, invariant, or waiver | Retag the reworded bullet, add a scenario, or add a treatment |
| `harness-scenarios.test.sh` | A scenario breaks the format, names an unknown skill, fixture, or step, expects a file outside its `writes:`, or a skill has no or two smoke scenarios, or a chain position is missing or repeated | Fix the line named in the message |
| `harness-switches.test.sh` | A switch in `harness/src/switches.ts` has no help text or is missing from this README | Add the usage text, or add the switch to the Switches table |

## Diagnosing failures

The run log is enough to diagnose most failures, so a captured log or a pipeline log is enough
after the runner's files are gone. Start from the closing table: its Summary names the failure
kind and check. Then read that scenario's block: the `fail:` line says what was expected and what
was found, and the conversation above it shows the exchange where it went wrong and the files
each turn touched. A `fail:` line from a scenario's `expect:` ends with the scenario line that
declared it:

```text
fail: assertion template code/*/.highway/features/001-*/plan.md: expected ## Functional Requirements; actual missing (scenario line 17)
```

When the log does not explain a failure, rerun that scenario with
`--transcripts "$TMPDIR/harness" --verbose` and read its `attempt-N.jsonl`, `attempt-N.raw.jsonl`,
and `report.md`.

### Likely causes

The likely cause comes from a fixed table, so the same failure always prints the same sentence.
A run-level failure prints its cause on the `cause:` line of its `== run ==` block, and
`report.md` gives the cause of every failure.

| Kind | Likely cause | What to check |
|---|---|---|
| `unmatched-question` | The skill's question changed, or the agent left the workflow at this step. | Compare the last `agent:` or `question:` entry with the scenario's `ask:` lines and the skill's bold question text. |
| `repeated-question` | The agent asked again a question whose reply was already spent; the skill re-asks after that reply's class. | The `fail:` line names the question and the spent reply. Key a reply the skill accepts, or find why the answer did not move the skill on. |
| `rejected-request` | The agent tried to run a shell command, use memory, or write outside the project. | The `denied:` entry and the `fail:` line name the request. Find the skill step that led the agent there. |
| `outside-writes` | The agent changed a file outside the scenario's `writes:` patterns. | The `files:` entries show the turn that wrote it; compare it with the skill's output paths and the scenario's `writes:`. |
| `experience-order` | The agent showed output before activating highway-experience. | The skills listed as actual; check that the skill's Procedure opens with the activation step. |
| `turn-limit` | The agent kept going past the turn limit, naming a repeated question when one repeats. | A repeated question usually means a reply does not satisfy that step. Check the reply's kind and text. |
| `timeout` | The attempt ran past its time limit. | The model may be slow; raise `--timeout`, or look for a stalled step in the block. |
| `assertion` | A written file is missing a required part. For check `shows`, the agent did not show the expected text. | If it is a template heading, the template changed after the fixture was promoted, or the skill skipped its template. |
| `fixture-blocked` | The fixture no longer matches its template. | Run `bash harness/bin/fixture-check.sh <fixture>`; promote a fresh chain run or fix the fixture. |
| `missing-token` | No key was found for the agent under test; for Copilot, "No Copilot token was found. Set GITHUB_TOKEN in harness/.env."; for Cursor, set `CURSOR_API_KEY`; for Codex, set `OPENAI_API_KEY` (or `CODEX_API_KEY`); for Claude, set `ANTHROPIC_API_KEY`. | Set the key variable the cause names in `harness/.env`. |
| `no-access` | The key has no access to the agent's service; for Copilot, "The GITHUB_TOKEN key has no Copilot access. Check the account's Copilot plan."; for Cursor, an invalid or refused `CURSOR_API_KEY`; for Claude, an invalid or refused `ANTHROPIC_API_KEY`. | Check the account's plan for that service. |
| `build-failed` | `highway-agent-plugin/` is missing or differs from its sources, or the base project could not be made. | The run block shows the DRIFT lines; run `framework/generate-agent-plugin.sh`. |
| `rate-limit` | Copilot kept rate limiting after 3 retries. | Lower `--parallel`, or wait and rerun. |
| `allowance` | The premium-request allowance is used up. | Wait for the reset, or raise the limit. |
| `chain-stage` | A chain stage failed, so later stages and every scenario were skipped. | Diagnose the failed stage's own blocks above it. |
| `service-error` | The Copilot service returned no response (code -32603); the turn was retried once and failed again. | Not a skill failure. A scenario whose last attempt has only this kind is `blocked`; rerun it. |
| `plugin-install` | The plugin did not install or load from `highway-agent-plugin/`. | The block's first `system:` entry names what the install reported; run `framework/validate-plugin.sh highway-agent-plugin`. |
| `unclassified` | The raw error follows. | Read the raw error; add a kind to `harness/src/failure.ts` if it recurs. |

A blocked scenario counts as a failure for the exit code. Scenarios not run because the run
stopped are listed as not run.

## Spike checklist

The first live run confirms how the Copilot SDK behaves with Highway. Record each answer here.

- [ ] `node harness/src/cli.ts --skills highway-help` passes, and the transcript shows the skill
      answered.
- [ ] `/highway-codify ...` as the opening message invokes the skill (a `skill` entry appears in
      `attempt-1.jsonl`). If it does not, the opening message names the skill in plain words.
- [ ] `node harness/src/cli.ts --paths harness/scenarios/highway-codify/codify-plan-review.scenario`
      reaches the close and writes the expected files.
- [ ] Usage events report tokens and cost, and the run report totals them.
- [ ] Skill questions arrive as ended turns, `ask_user` requests, or both, and both are answered.
- [ ] Permission requests carry the kinds and paths the policy expects.
- [ ] A smoke run (`--smoke`) runs 16 scenarios with run type `smoke`.
- [ ] A full run's chain passes, and `--promote` replaces the stage fixtures only where the
      chain's output changed.
