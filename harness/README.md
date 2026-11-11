# Highway Behavioral Test Harness

The harness runs Highway skills in real agent conversations and checks what they write. Each
scenario opens a skill in a fresh test project, answers the skill's questions from a script, and
then checks the files against the scenario's expectations, the storage contract, and an advisory
LLM judge.

The harness is a development tool. `harness/` is excluded from the distribution, and its toolchain
(Node, TypeScript, the Copilot SDK, and `git`) is never a runtime dependency of Highway.

## How it works

### One test project per attempt

For each attempt, the runner builds a new project in a temporary folder:

1. The distribution output from `framework/generate-distribution.sh`, built once per run. It
   supplies `.highway/`, `.github/skills/`, `.github/copilot-instructions.md`, `.claude/`,
   `.agents/`, and `AGENTS.md`, exactly as a user's repository would have them.
2. The scenario's fixture on top: a stage snapshot from `harness/fixtures/stages/`, or an overlay
   from `harness/fixtures/overlays/` applied to its stage. `empty` adds nothing.

The project is snapshotted before the conversation starts and compared with its state afterward.

### The Copilot driver and its permissions

The driver is GitHub Copilot through `@github/copilot-sdk`, local runtime. Each attempt gets its
own client, its own temporary Copilot home, and one session whose working directory is the test
project. Config discovery is on, so the session finds the project's skills and instructions the
same way the Copilot CLI does. Session storage and telemetry are off.

Every permission request is decided by a fixed policy:

| Request | Decision | Ends the attempt |
|---|---|---|
| Read inside the project | approved | no |
| Write inside the project | approved | no |
| Read outside the project | rejected | no |
| Web (URL) access | approved when the scenario says `web: yes`, otherwise rejected | no |
| Write outside the project | rejected | yes |
| Shell command | rejected | yes |
| Memory | rejected | yes |
| Any other tool | rejected | no |

Shell, memory, and outside writes are fatal because the storage contract
(`.highway/governance/storage.md`) forbids them. A rejected request that ends the attempt is a
`rejected-request` failure.

### Keyed replies and the model fallback

A scenario's replies are keyed by the question the skill asks:

- `ask:` is the exact question text from the skill. It matches when it appears anywhere in the
  agent's message, ignoring `**`, case, and runs of whitespace.
- `ask-pattern:` is a regular expression for a question the skill does not spell out.

Replies are used in file order, and each is used once, so the same question can get a different
reply each time it is asked. After each agent turn, the driver sends the first unused reply whose
key appears in the message. When no key appears and the message asks something, the judge model
picks the fitting reply in a new session that sees only the agent's last message and the unused
replies. That pick records a **paraphrased question** warning with the expected and actual
question. When the fallback answers "none", the attempt fails as `unmatched-question`. A message
that asks nothing ends the conversation. `--no-judge` does not turn the fallback off.

### Checks, in order

1. **File assertions**: each `expect:` line in the scenario.
2. **Invariants**: every file the conversation changed matches a `writes:` pattern (a scenario
   with no `writes:` must write nothing), and no shell, memory, or outside-write request was made.
3. **Judge** (advisory): a new session with the same model, or `--judge-model`, reads the
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
3. For live runs, a GitHub token with Copilot access in `harness/.env`:

   ```text
   GITHUB_TOKEN=<token>
   ```

   `COPILOT_GITHUB_TOKEN` is read first when both are set. `harness/.env`, `harness/runs/`, and
   `harness/node_modules/` are gitignored.

Unit tests and the type check need no token: `npm --prefix harness test` and
`npm --prefix harness run typecheck`.

## Running

Run from the repository root with `node harness/src/cli.ts [switches]`, or
`npm --prefix harness run harness -- [switches]`.

| Run | Example | What runs |
|---|---|---|
| Full | `node harness/src/cli.ts` | The six-stage chain, then every scenario |
| Smoke | `node harness/src/cli.ts --smoke` | One smoke scenario per skill (15) |
| Targeted | `node harness/src/cli.ts --changed-since origin/main` | Scenarios affected by changed files |
| Targeted | `node harness/src/cli.ts --paths .highway/library/templates/output/codify-plan.md` | Scenarios affected by these paths |
| Targeted | `node harness/src/cli.ts --skills highway-codify` | Every scenario of these skills |

### Switches

| Group | Switch | Argument | Default | Usage |
|---|---|---|---|---|
| Selection | `--smoke` | — | off | Run one smoke scenario per skill |
| Selection | `--changed-since` | `<ref>` | — | Run scenarios affected by files changed since `<ref>` |
| Selection | `--paths` | `<files>` | — | Run scenarios affected by these comma-separated paths |
| Selection | `--skills` | `<ids>` | — | Run scenarios for these comma-separated skill ids |
| Agent | `--model` | `<id>` | `harness.config.json` `model` | Model for scenario sessions |
| Agent | `--judge-model` | `<id>` | the run's model | Model for the judge and the reply fallback |
| Agent | `--no-judge` | — | off | Skip the judge |
| Execution | `--parallel` | `<n>` | 4 | Scenarios run at once |
| Execution | `--max-turns` | `<n>` | 40 | Turn limit per attempt |
| Execution | `--timeout` | `<minutes>` | 20 | Time limit per attempt, in minutes |
| Output | `--transcripts` | `<dir>` | `harness/runs/` | Folder that receives run folders |
| Fixtures | `--promote` | `<run folder>` | — | Replace stage fixtures with a run's candidate snapshots |
| Help | `--help`, `-h` | — | — | Print the help and exit 0 |

No selection switch runs the full suite. `--changed-since`, `--paths`, and `--skills` combine as a
union, and each scenario keeps every reason it was selected. `--smoke` and `--promote` are used
alone. Defaults for the model, parallelism, limits, and transcript folder come from
`harness/harness.config.json`. The chain always runs one stage at a time.

### Exit codes

| Code | Meaning |
|---|---|
| 0 | Every gated check passed, or the selection was empty |
| 1 | A scenario failed or was blocked, or a chain stage failed |
| 2 | The run could not start or was stopped: an invalid switch, a missing token, no Copilot access, a failed distribution build, a persistent rate limit, or a used-up premium-request allowance |

Exit 2 takes precedence over exit 1.

## Reading results

Each run writes a folder under `harness/runs/` (or `--transcripts`), named
`<UTC start>-<run type>-<short commit>`, for example `20261110-153512Z-targeted-a1b2c3d`.

```text
harness/runs/20261110-153512Z-targeted-a1b2c3d/
  report.md            Run report: results, warnings, judge verdicts, usage totals, coverage
  report.json          The same data as JSON
  junit.xml            JUnit XML, one test case per scenario
  selection.txt        Each selected scenario and why it was selected
  candidates/<stage>/  Full runs only: each passing chain stage's output
  <scenario id>/
    attempt-1.raw.jsonl     Every SDK event, redacted
    attempt-1.jsonl         The conversation: user, agent, question, answer, permission, skill
    attempt-1.result.json   Outcome, checks, warnings, judge verdicts, usage, models
    attempt-2.*             Present when the first attempt failed
```

Tokens and keys are redacted before any file is written and from all stdout. Usage reported by
the SDK is recorded per attempt and totaled in the run report.

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

In path patterns, `*` matches within one folder and `**` across folders.

| Assertion | Argument | Passes when |
|---|---|---|
| `exists` | — | a file matches |
| `absent` | — | no file matches |
| `heading` | heading line | each match has that line |
| `field` | `Name=Value` | a line `Name: Value`, `**Name:** Value`, or `- **Name:** Value` exists |
| `row` | cell text | a table row contains the text |
| `contains` | text | the text appears |
| `template` | template file name | the structural template check passes |

A reported "step" in results and failure blocks is the skill step of the last keyed question the
agent asked, so it can trail the step the agent was actually in.

### Fixtures and overlays

Stage fixtures are full project snapshots for the Northwind Outfitters example: `setup`,
`request`, `discovery`, `architecture`, and `implementation`. Each later stage holds every earlier
stage's files. Fixtures hold project files only. `.highway/` comes from the distribution.

An overlay is a folder under `harness/fixtures/overlays/<name>/` with `overlay.txt` holding
`stage: <stage>`. Its files replace or add to the stage's files, and an optional `.delete` lists
paths to remove, one per line. Use an overlay for a variation one scenario needs, such as a record
with `Language: Needed`.

Every fixture file that `harness/fixtures/templates.map` maps to an output template must carry
that template's frontmatter keys, required headings, and table header rows. Check with
`bash harness/bin/fixture-check.sh [fixture...]`. A scenario whose fixture fails this check is
reported as blocked and does not run.

### Promoting candidate snapshots

A full run runs the six chain scenarios first, in order: setup, request, discovery, architecture
(through the decision), implementation, and codify. Stage 1 starts from an empty project, and
each later stage starts from the previous stage's output. When every stage passes, each stage's
output is saved under the run folder's `candidates/`. Review them, then replace the stage
fixtures:

```bash
node harness/src/cli.ts --promote harness/runs/<run folder>
```

Nothing else changes a stage fixture. Outside a full run, chain scenarios start from their
fixtures like any other scenario.

### Covering, checking as an invariant, or waiving a bullet

Each Verification and Error Handling bullet of a skill has a 12-character hash. List them with:

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
| `skills/<skill>/...` | Every scenario of that skill, including scenarios that pass through it |
| A template, governance, library, or instruction file a skill names | Every scenario of each skill whose `SKILL.md` contains the full path |
| A shared file listed as `smoke` in `harness/selection/shared.txt` | The smoke set |
| `harness/src/`, `harness/package*.json`, `harness/harness.config.json` | The smoke set |
| A scenario file | That scenario |
| A stage fixture | Every scenario that starts from that stage, directly or through an overlay |
| An overlay | Every scenario that uses that overlay |
| Generated agent copies, `AGENTS.md`, tests, specs, the catalog, `framework/`, `tests/`, and other files | Nothing |

For `--changed-since <ref>`, changed paths come from `git diff --name-status <ref>` plus untracked
files. A deleted skill file is resolved against the skill list at `<ref>`. An empty selection
prints why and exits 0.

The path map reads every location from the framework's paths helper, `framework/lib/paths.sh`,
through `harness/bin/lib/paths.sh`, which each `harness/bin/` script sources.
`path-map.sh --location <skills|framework>` prints the skills or framework location, which the runner uses
to find skills at a ref and to build the distribution.

Coverage is printed in each run report per skill: each bullet's treatment, the reply kinds
exercised, and the steps reached and not reached. When a bullet is reworded, its hash changes.
The old tag becomes unknown, and the report and `harness-coverage.test.sh` show the new bullet
beside the old tag. Retag it by replacing the old hash and text with the new ones from
`inventory.sh`.

## Bash suite checks

`bash tests/run-all.sh` runs these harness checks. None needs Node or a token.

| Check | Fails when | How to fix |
|---|---|---|
| `harness-placement.test.sh` | `harness/` is not excluded in `framework/.distribution-manifest`, run output, `node_modules`, or `.env` is not gitignored, or the development constitution lacks the harness toolchain | Restore the manifest line, the `.gitignore` entries, or the constitution paragraph |
| `harness-path-map.test.sh` | A shipped template, governance, library, or instruction file maps to no skill and is not in `harness/selection/shared.txt`, or a mapping rule changed | Name the file in the skill that reads it, or add it to `shared.txt` as `smoke` or `none` |
| `harness-fixtures.test.sh` | A fixture file lacks a part of its current template, or an overlay names no stage | Promote a fresh chain run, or fix the fixture by hand |
| `harness-coverage.test.sh` | A highway-codify bullet has no scenario tag, invariant, or waiver | Retag the reworded bullet, add a scenario, or add a treatment |
| `harness-scenarios.test.sh` | A scenario breaks the format, names an unknown skill, fixture, or step, expects a file outside its `writes:`, or a skill has no or two smoke scenarios, or a chain position is missing or repeated | Fix the line named in the message |
| `harness-switches.test.sh` | A switch in `harness/src/switches.ts` has no help text or is missing from this README | Add the usage text, or add the switch to the Switches table |

## Diagnosing failures

Everything needed to diagnose a failure is printed to stdout, so a pipeline log is enough after
the runner's files are gone.

The run prints one header line with the run id, commit, run type, model, judge model, and the
Copilot SDK and CLI versions, then one progress line per attempt. Each failure prints a block as
it happens:

```text
==== FAILURE codify-smoke (attempt 2 of 2) ====
Where:   harness/scenarios/highway-codify/codify-smoke.scenario; stage -; turn 6; step menu
What:    expect template code/*/.highway/features/001-*/plan.md :: codify-plan.md
         expected: ## Functional Requirements; actual: missing
         declared at line 17
Covers:  f840f259ec7b An exact title selects that accepted implementation, and the title is what the person sees.
Recent:  (last turns, at most 20 lines of 200 characters, redacted)
Rejected: none
Likely cause: A written file is missing a required part. ...
HARNESS-FAILURE {"run":"...","scenario":"codify-smoke","attempt":2,"kind":"assertion",...}
```

The `HARNESS-FAILURE` line holds the same fields as one line of JSON, so a pipeline can parse
failures from the log. The final summary lists every failure and skipped scenario with its likely
cause, then the run folder.

### Likely causes

The likely cause comes from a fixed table, so the same failure always prints the same sentence.

| Kind | Likely cause | What to check |
|---|---|---|
| `unmatched-question` | The skill's question changed, or the agent left the workflow at this step. | Compare the last question in Recent with the scenario's `ask:` lines and the skill's bold question text. |
| `rejected-request` | The agent tried to run a shell command, use memory, or write outside the project. | The Rejected line names the request. Find the skill step that led the agent there. |
| `outside-writes` | The agent changed a file outside the scenario's `writes:` patterns. | The path in What; compare it with the skill's output paths and the scenario's `writes:`. |
| `turn-limit` | The agent kept going past the turn limit, naming a repeated question when one repeats. | A repeated question usually means a reply does not satisfy that step. Check the reply's kind and text. |
| `timeout` | The attempt ran past its time limit. | The model may be slow; raise `--timeout`, or look for a stalled step in Recent. |
| `assertion` | A written file is missing a required part. | If it is a template heading, the template changed after the fixture was promoted, or the skill skipped its template. |
| `fixture-blocked` | The fixture no longer matches its template. | Run `bash harness/bin/fixture-check.sh <fixture>`; promote a fresh chain run or fix the fixture. |
| `missing-token` | No Copilot token was found. | Set `GITHUB_TOKEN` in `harness/.env`. |
| `no-access` | The token has no Copilot access. | Check the account's Copilot plan. |
| `build-failed` | The distribution build failed. | The block shows the last lines of `generate-distribution.sh` output. |
| `rate-limit` | Copilot kept rate limiting after 3 retries. | Lower `--parallel`, or wait and rerun. |
| `allowance` | The premium-request allowance is used up. | Wait for the reset, or raise the limit. |
| `chain-stage` | A chain stage failed, so later stages and every scenario were skipped. | Diagnose the failed stage's own block above it. |
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
- [ ] A smoke run (`--smoke`) runs 15 scenarios with run type `smoke`.
- [ ] A full run's chain passes, and `--promote` replaces the stage fixtures only where the
      chain's output changed.
