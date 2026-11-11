# Feature Specification: Behavioral Test Harness

**Feature Branch**: `232-behavioral-test-harness`

**Created**: 2026-11-10

**Status**: Draft

**Input**: User description: "create a new spec for implementing phase 2 of rollout-plan.md". Phase 2 builds a behavioral test harness that runs real GitHub Copilot agent sessions against Highway skills, headless, on a laptop or in a pipeline. It covers: a runner in a top-level `harness/` folder kept out of the public distribution; stage snapshot fixtures and edge-case overlays; one scenario file per conversation with keyed replies, expected files, and covered bullets; coverage measured against each skill's Verification and Error Handling bullets; full, smoke, and targeted runs, with targeted runs selected by skill, path, or git diff; file assertions, invariants, and an advisory LLM judge; transcripts saved per run and scenario; and a help switch listing every switch. The pipeline check is a later spec. Exit: highway-codify reaches full coverage, a targeted codify run passes, a full run regenerates the stage snapshots, and a diff on `codify-plan.md` selects the codify scenarios and says why.

## Clarifications

### Session 2026-11-10

- Q: When the agent words a question differently from the skill, how should the harness pick the reply? → A: Exact question text first, then a model as fallback. A fallback match passes with a "paraphrased question" warning. Only a question no reply fits fails.
- Q: How should the harness check the files a scenario writes? → A: Structural assertions: the file exists, matches its template's required headings and fields, holds the expected field values and table rows, and contains specific text where the scenario says so. No byte-for-byte comparison.
- Q: Which command should run the suite checks that need no agent (fixtures, coverage gate, smoke count, path map)? → A: The existing bash suite. Scenario files use a plain line-based format bash can read.
- Q: When a scenario fails, should the harness automatically run it again before counting it as a failure? → A: One automatic retry for any failure, keeping both attempts. A pass on the retry counts as a pass, with a "flaky" warning in the result and run report.
- Q: Does a new context with the same model give the judge an unbiased enough answer? → A: Yes for this phase, since the judge is advisory. The judge runs in a new session that sees only the finished transcript, the files, and the bullet text. Each bullet is a true/false verdict that quotes its evidence, and a "met" with no quote counts as not met. `--judge-model <id>` defaults to the run's model.
- Q: In a full run, if one chain stage fails, should the scenarios still run from the existing snapshots? → A: No. The run stops at the failed stage, skips every scenario, and exits 1.
- Q: When a targeted run selects almost every scenario, should it switch to a full run? → A: No. A targeted run runs exactly what it selected.
- Q: If Copilot rate-limits the harness or the premium-request allowance runs out mid-run, what should happen? → A: On a rate limit, retry the same request up to 3 times with growing waits, without using the scenario's retry. If it persists, or the allowance is used up, start no new scenarios, mark the rest "not run", print the failure block, and exit 2.
- Q: Should the judge run on every run by default, or only when asked? → A: By default, with `--no-judge` to skip it.
- Q: Which model picks the reply when the agent rewords a question, and what does it see? → A: The judge model, in its own short session that sees only the agent's last message and the scenario's replies with their questions, and can answer "none".
- Q: How should the full run's chain stages be defined? → A: Six ordinary scenario files, each with a `chain:` position (1–6). In a full run, stage 1 starts from an empty project and each later stage from the previous stage's output. They count toward coverage and run on their own from fixtures in targeted runs.
- Q: What happens when switches that pick what to run are combined? → A: `--changed-since`, `--paths`, and `--skills` combine as a union, keeping each scenario's reasons. `--smoke` and `--promote` must be used alone; mixing either with a selection switch exits 2.
- Q: What defaults should `--parallel`, `--max-turns`, and `--timeout` use? → A: 4 scenarios at a time, 40 turns, and 20 minutes per attempt.
- Q: How should a scenario say which files the agent may change inside the test project? → A: Each scenario lists `writes:` path patterns. Its expected files must match them, and any other changed file fails the storage check.
- Q: Which model should a run use when `--model` isn't passed? → A: A pinned default model id in a committed harness config file. `--model` overrides it, and the run header and results record which was used.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Run one scenario headless and get its result and transcript (Priority: P1)

A maintainer runs one command on a laptop. The harness builds a fresh test project from the files Highway ships, starts a GitHub Copilot session in it, sends the scenario's opening message, answers each of the agent's questions from the scenario's keyed replies, then checks the files the session wrote. The maintainer gets a pass or fail, a transcript, and the reason for any failure, without answering anything by hand.

**Why this priority**: Every other story depends on one scenario running end to end. This story is also the spike: it shows whether a `/highway-codify ...` message invokes the skill, whether project instructions load, and how usage is reported.

**Independent Test**: Run a single codify scenario from the implementation stage fixture and confirm a result file, both transcripts, and a correct exit code.

**Acceptance Scenarios**:

1. **Given** a scenario and its fixture, **When** the maintainer runs it, **Then** the harness builds a new test project from the distribution output plus the fixture, and no file outside that project changes.
2. **Given** a running session, **When** the agent finishes a turn with a question, **Then** the harness sends the keyed reply whose exact question text appears in the agent's message, or, when none does, the reply the judge model picks from only the agent's last message and the scenario's replies, and the run never waits on a person.
3. **Given** a reply chosen by the model fallback, **When** the scenario ends, **Then** its result and the run report carry a "paraphrased question" warning naming the expected and actual question, and the warning does not change the exit code.
4. **Given** a session, **When** the agent requests a shell command, memory, or a write outside the test project, **Then** the request is rejected, recorded in the transcript, and the storage invariant fails.
5. **Given** a finished session, **When** the checks run, **Then** each expected file result passes or fails on its structure (presence, template headings and fields, field values, table rows, named text), with a message naming the file and the failed assertion. Wording differences elsewhere in the file do not fail it.
6. **Given** a finished run, **When** the maintainer opens the run folder, **Then** it is named by UTC start time, run type, and commit, and holds one folder per scenario named by the scenario, with each attempt's raw transcript, normalized transcript, and result.
7. **Given** any transcript or result, **When** it is written, **Then** API keys and tokens are redacted.
8. **Given** every gated check passes, **When** the run ends, **Then** it exits 0. **Given** any gated check fails, **Then** it exits 1. **Given** the run could not start, such as a missing token, **Then** it exits 2.
9. **Given** `--help`, **When** it runs, **Then** it prints every switch with its argument, default, and one-line usage, grouped by purpose, plus example commands, runs nothing, and exits 0.
10. **Given** an unknown or malformed switch, **When** it runs, **Then** it prints the error and a pointer to `--help`, and exits 2.
11. **Given** a scenario whose first attempt fails, **When** the run continues, **Then** it runs once more in a new test project, keeps both attempts, and counts a passing second attempt as a pass with a "flaky" warning in the result and run report.
12. **Given** any failure, **When** it happens, **Then** stdout shows a failure block naming the scenario, attempt, turn, step, failed check with expected and actual values, covered bullets, recent turns, and a likely cause, plus one `HARNESS-FAILURE` JSON line, all without the run folder.

---

### User Story 2 - Run only the scenarios a change affects (Priority: P1)

A maintainer changes `codify-plan.md` and runs the harness with `--changed-since main`. The harness lists the changed files, picks the highway-codify scenarios because that skill names the template, and reports why each scenario was picked. The same selection works from `--paths` or `--skills`.

**Why this priority**: It keeps routine runs short, and the later pull request check depends on it.

**Independent Test**: Change `codify-plan.md` on a branch, run `--changed-since main`, and confirm the highway-codify scenarios run with the reason "highway-codify names `codify-plan.md`".

**Acceptance Scenarios**:

1. **Given** a changed `SKILL.md`, **When** selection runs, **Then** every scenario tagged with that skill runs, including scenarios that pass through it.
2. **Given** a changed template, **When** selection runs, **Then** every scenario for each skill that names the template runs.
3. **Given** a changed shared file (Experience Standard, Highway identity, storage contract, or agent context), or a change to the harness runner or a driver, **When** selection runs, **Then** the smoke set runs.
4. **Given** a changed scenario or fixture, **When** selection runs, **Then** that scenario, or every scenario starting from that fixture, runs.
5. **Given** only generated copies, tests, generators, validators, the constitution, or specs changed, **When** selection runs, **Then** nothing runs and the run says so.
6. **Given** a deleted or renamed path, **When** selection runs, **Then** it resolves against the target branch's map.
7. **Given** a selection of any size, **When** selection runs, **Then** exactly the selected scenarios run, the chain does not, and the run type stays `targeted`.
8. **Given** any targeted run, **When** it ends, **Then** the run folder records why each scenario was selected.
9. **Given** `--skills highway-codify --paths <a template another skill names>`, **When** selection runs, **Then** both skills' scenarios run, and a scenario selected by both lists both reasons.
10. **Given** `--smoke` or `--promote` with any selection switch, **When** it runs, **Then** it prints the conflict and exits 2 without running anything.

---

### User Story 3 - Know exactly what highway-codify's scenarios cover (Priority: P1)

A maintainer opens the coverage report and sees every highway-codify Verification and Error Handling bullet marked as covered by a scenario, checked as an invariant, or waived with a written reason. A bullet reworded since the last tag shows as uncovered, with its old and new text side by side. The bash suite fails while any codify bullet is uncovered.

**Why this priority**: "Every workflow scenario" needs a measurable boundary. highway-codify is the Phase 2 gate.

**Independent Test**: Remove one scenario's tag for a codify bullet and confirm the bash suite fails naming that bullet. Restore it and confirm the suite passes.

**Acceptance Scenarios**:

1. **Given** the shipped skills, **When** the coverage inventory is built, **Then** it lists each skill's steps, Verification bullets, and Error Handling bullets, each bullet identified by a hash of its text.
2. **Given** highway-codify, **When** the coverage check runs, **Then** every bullet is a scenario, an invariant, or a waiver with a reason, and the check passes.
3. **Given** a reworded codify bullet, **When** the coverage check runs, **Then** it fails, naming the new bullet as uncovered and the old tag as unknown, with both texts side by side.
4. **Given** highway-codify, **When** the report is read, **Then** each reply kind (accept, edit, question, unknown, decline) is exercised at least once, and each step is reached at least once or listed as not reached.
5. **Given** any skill other than highway-codify, **When** the coverage check runs, **Then** its coverage is reported and does not fail the suite.

---

### User Story 4 - Smoke-test every skill quickly (Priority: P2)

A maintainer runs `--smoke` after upgrading the agent SDK. One short scenario per skill runs, each reaching that skill's first accepted write, or its answer for highway-help.

**Why this priority**: A cheap check across all fifteen skills, used before a full run and after shared changes.

**Independent Test**: Run `--smoke` and confirm fifteen scenarios run, one per skill.

**Acceptance Scenarios**:

1. **Given** the scenario set, **When** the bash suite runs, **Then** it fails if any skill has no smoke scenario or more than one.
2. **Given** `--smoke`, **When** the run ends, **Then** the run folder uses the run type `smoke` and holds one scenario folder per skill.

---

### User Story 5 - Run the full chain and refresh the stage snapshots (Priority: P2)

A maintainer runs the harness with no selection switch. It runs the chain from an empty project through setup, request, discovery, architecture, and implementation to codify, then every scenario. Passing stage outputs become candidate snapshots. After review, the maintainer promotes them, and the next run's fixtures start from them.

**Why this priority**: Fixtures go stale as skills change. The chain keeps them real.

**Independent Test**: Run the full suite, promote the candidates, and confirm the stage fixtures changed only where the chain's output changed.

**Acceptance Scenarios**:

1. **Given** no selection switch, **When** the run starts, **Then** the chain runs first, then every scenario.
2. **Given** the six chain scenarios, **When** the chain runs, **Then** stage 1 starts from an empty project built from the distribution output, and each later stage starts from the previous stage's output instead of its fixture.
3. **Given** a targeted or smoke run that selects a chain scenario, **When** it runs, **Then** it starts from its fixture like any other scenario.
4. **Given** a passing chain, **When** it ends, **Then** each stage's output is saved as a candidate snapshot in the run folder. No fixture changes yet.
5. **Given** candidate snapshots, **When** the maintainer runs `--promote <run folder>`, **Then** the stage fixtures are replaced by those candidates.
6. **Given** a chain stage that fails after its retry, **When** the run ends, **Then** later stages and every scenario are skipped, no candidate is saved for any stage, the report lists them as skipped by the failed stage, and the run exits 1.
7. **Given** any fixture, **When** the bash suite runs, **Then** it is validated against its current template, and a stale fixture fails the suite.

---

### User Story 6 - See the judge's view of each scenario (Priority: P3)

After the file checks, an LLM judge in a new session, separate from the one that ran the scenario, reads the finished transcript and files and marks each covered bullet as met or not met, quoting its evidence, with a one-sentence reason. Its verdicts are reported and do not gate.

**Why this priority**: Many bullets describe conversation, not files. The judge reads those, but its variance is unknown, so it reports first.

**Independent Test**: Run a scenario and confirm the result holds one judge verdict per covered bullet.

**Acceptance Scenarios**:

1. **Given** a finished scenario, **When** the judge runs, **Then** it evaluates only the bullets that scenario covers.
2. **Given** a judge verdict of not met, **When** the run ends, **Then** it is reported, and the exit code is unchanged.
3. **Given** a finished scenario, **When** the judge runs, **Then** it uses a new session that holds only the finished transcript, the scenario's files, and the covered bullets' text, never the scenario's session history.
4. **Given** a verdict of met with no quoted evidence, **When** it is recorded, **Then** it counts as not met.
5. **Given** `--judge-model <id>`, **When** the judge runs, **Then** it uses that model. **Given** no `--judge-model`, **Then** it uses the run's model. The result records the judge model.
6. **Given** `--no-judge`, **When** a scenario finishes, **Then** no judge runs, and the result and run report say the judge was skipped.

---

### Edge Cases

- The agent rewords a skill's question: the model fallback picks the reply, the run continues, and the result carries a "paraphrased question" warning.
- The agent asks a question neither the exact text nor the model fallback matches to a keyed reply: the scenario fails at that turn, naming the unmatched question.
- A session loops or stalls: `--max-turns` or `--timeout` stops it and records the attempt as failed, and the retry runs.
- A scenario fails, then passes on its retry: it counts as a pass with a "flaky" warning.
- The agent requests a URL in a scenario that does not allow web access: the request is rejected and recorded.
- A scenario's fixture fails template validation: the scenario does not run and is reported as blocked by its fixture.
- Two parallel scenarios: each has its own test project and Copilot home, so neither sees the other.
- The distribution build fails: the run exits 2 before any session starts.
- The Copilot token is missing or has no Copilot access: the run exits 2 and names the problem.
- Copilot rate-limits a request: it is retried up to 3 times with growing waits. If the limit persists or the premium-request allowance is used up, unstarted scenarios are marked "not run" and the run exits 2.
- A bullet hash changes because only whitespace changed: whitespace is normalized before hashing, so the tag holds.
- A skill is added: its bullets appear as uncovered and it has no smoke scenario, so the bash suite fails until both exist.
- A change touches only `specs/` or tests: the targeted run selects nothing and exits 0.

## Requirements *(mandatory)*

### Functional Requirements

**Placement and toolchain**

- **FR-001**: The harness MUST live in a top-level `harness/` folder.
- **FR-002**: The distribution manifest MUST exclude `harness/`, so no harness file reaches the distribution.
- **FR-003**: The development constitution MUST record the harness toolchain (Node, TypeScript, and the Copilot SDK) as dev-only. The bash suite's toolchain rules stay unchanged.
- **FR-004**: `harness/runs/` and `.env` MUST be gitignored.

**Test projects and driver**

- **FR-005**: Each scenario attempt MUST run in a new temporary project built from the distribution output plus the scenario's fixture.
- **FR-006**: The first driver MUST be GitHub Copilot through the Copilot SDK, local runtime.
- **FR-007**: Each attempt MUST use a new session, a temporary Copilot home, and no session store, so no personal skill, memory, or saved approval reaches it.
- **FR-008**: The driver MUST approve reads and writes inside the test project and reject shell commands, memory, and writes elsewhere. URL fetches MUST be approved only for scenarios that declare web access.
- **FR-009**: The driver MUST answer each agent question, whether ended turn or `ask_user` request, from the scenario's keyed replies. A reply's key is the exact question text the skill defines, or a pattern for a question the skill does not spell out. When no key appears in the agent's message, the judge model (FR-030) MUST pick the fitting reply in its own new session that holds only the agent's last message and the scenario's replies with their questions. It MAY answer "none". `--no-judge` does not turn this fallback off. When it picks a reply, the result and run report MUST record a "paraphrased question" warning with the expected and actual question. The warning MUST NOT change the exit code. The driver MUST fail the scenario when no key matches and the fallback answers "none".
- **FR-010**: The model MUST default to a pinned model id in a committed harness config file. `--model` MUST override it. The run header and each result MUST record the model used.
- **FR-011**: The Copilot token MUST come from the environment, such as a gitignored `.env`.

**Fixtures and scenarios**

- **FR-012**: Stage snapshot fixtures MUST exist for setup, request, discovery, architecture, and implementation.
- **FR-013**: Overlay fixtures MUST express edge cases on top of a stage, such as `Language: Needed` or a platform with no row.
- **FR-014**: The bash suite MUST validate every fixture against its current template.
- **FR-015**: Each scenario MUST be one file naming its starting fixture, its primary skill and the skills it passes through, its opening message, its keyed replies, its expected file results, its `writes:` path patterns, its covered bullets, whether it is the skill's smoke scenario, whether it needs web access, and, for the six chain scenarios, its `chain:` position from 1 to 6. The format MUST be plain and line-based, one `key: value` per line with repeated keys for lists, so the bash suite and the runner read the same file.
- **FR-015a**: The bash suite MUST run the fixture, coverage, smoke, and path-map checks (FR-014, FR-019, FR-020, FR-025) without Node or any agent session. It MUST also fail when a scenario's expected file matches none of its `writes:` patterns.

**Coverage**

- **FR-016**: The harness MUST build a coverage inventory of every skill's steps, Verification bullets, and Error Handling bullets. A bullet is identified by a hash of its whitespace-normalized text.
- **FR-017**: Each bullet MUST be covered by a scenario, an invariant, or a waiver with a written reason.
- **FR-018**: The coverage report MUST show, per skill, each bullet's treatment, each reply kind exercised, and each step reached or not reached. A reworded bullet MUST show its old and new text side by side.
- **FR-019**: The bash suite MUST fail on an uncovered bullet in a gated skill. highway-codify is the only gated skill in this phase.
- **FR-020**: The bash suite MUST fail when a skill has no smoke scenario or more than one.

**Selection and run types**

- **FR-021**: No selection switch MUST run the full suite: the chain, then every scenario. The chain MUST be the six scenarios with a `chain:` position, run in order: stage 1 from an empty project, each later stage from the previous stage's output. Chain scenarios count toward coverage like any scenario, and outside a full run they start from their fixtures. The bash suite MUST fail unless positions 1 to 6 each appear exactly once. When a chain stage fails after its retry, the run MUST stop, skip later stages and every scenario, save no candidate snapshot, and exit 1.
- **FR-022**: `--smoke` MUST run the smoke set.
- **FR-023**: `--changed-since <ref>`, `--paths <files>`, and `--skills <ids>` MUST each select a targeted run. Used together, they MUST select the union of their scenarios, and each scenario MUST keep every reason that selected it.
- **FR-023a**: `--smoke` and `--promote` MUST each be used without `--changed-since`, `--paths`, `--skills`, or each other. Any such mix MUST print the conflict and exit 2 before anything runs. `--promote` runs no session.
- **FR-024**: Path selection MUST follow the map in User Story 2. The map MUST be built from the `.highway/` paths each `SKILL.md` names, plus a list of shared files.
- **FR-025**: The bash suite MUST fail on a shipped path that maps to no skill and is not a shared file.
- **FR-026**: A run MUST record why each scenario was selected.
- **FR-027**: A passing chain MUST save candidate snapshots in the run folder. `--promote <run folder>` MUST replace the stage fixtures with them. Nothing else changes a fixture.

**Checks**

- **FR-028**: File assertions and invariants MUST run first and decide the exit code. File assertions MUST be structural: a file exists or is absent, matches its template's required headings and fields, holds expected field values and table rows, and contains text the scenario names. No assertion compares a whole file byte for byte.
- **FR-029**: Every scenario MUST check the storage invariant: no rejected shell, memory, or outside write request, and no file created, changed, or deleted in the test project unless it matches one of the scenario's `writes:` patterns. The failure MUST name each offending file.
- **FR-030**: The LLM judge MUST evaluate only the bullets a scenario covers and MUST NOT change the exit code. It MUST run in a new session that holds only the finished transcript, the scenario's files, and the covered bullets' text. Each verdict MUST be met or not met, with quoted evidence from the transcript or a file and a one-sentence reason. A met verdict without quoted evidence MUST count as not met. The judge MUST use `--judge-model` when given, otherwise the run's model, and the result MUST record it. The judge MUST run by default. `--no-judge` MUST skip it, and the result and run report MUST record that it was skipped.

**Output and execution**

- **FR-031**: Run folders MUST be named `<UTC start>-<run type>-<short commit>`, using `YYYYMMDD-HHMMSSZ`. Scenario folders MUST be named by scenario. Each attempt MUST keep `attempt-N.raw.jsonl`, `attempt-N.jsonl`, and `attempt-N.result.json`.
- **FR-032**: The run folder MUST hold a run report, JUnit XML, and the selection reasons.
- **FR-033**: `--transcripts <dir>` MUST set the output folder. The default is `harness/runs/`.
- **FR-034**: Keys and tokens MUST be redacted before any file is written.
- **FR-035**: Each result MUST record the usage the SDK reports, and the run report MUST total it.
- **FR-036**: Exit codes MUST be 0 when every gated check passes, 1 when any fails, and 2 when the run cannot start, a switch is invalid, or the run stops on a rate limit or used-up allowance (FR-036b). Exit 2 takes precedence over exit 1.
- **FR-036a**: A failed attempt MUST be retried once in a new test project. Both attempts MUST be kept. A passing second attempt MUST count as a pass and MUST record a "flaky" warning in the result and run report. A failing second attempt counts as the scenario's failure. The warning MUST NOT change the exit code.
- **FR-036b**: A rate-limited request MUST be retried up to 3 times with growing waits, without counting as an attempt. When the limit persists, or Copilot reports the premium-request allowance used up, the run MUST start no new scenario, let running scenarios end, mark every unstarted scenario "not run", print the failure block, and exit 2.
- **FR-037**: `--parallel <n>`, `--max-turns <n>`, `--timeout <minutes>`, `--model <id>`, `--judge-model <id>`, and `--no-judge` MUST be supported. Defaults: `--parallel 4`, `--max-turns 40`, and `--timeout 20`, with the turn and time limits applying per attempt. The chain MUST run its stages one at a time whatever `--parallel` is.
- **FR-038**: `--help` and `-h` MUST print every switch with its argument, default, and usage, grouped by purpose, plus examples, and exit 0. The help MUST be built from the same switch definitions the parser uses. A harness test MUST fail when a switch has no help line.
- **FR-039**: Local output MUST show one progress line per scenario, then a summary with the run folder path.
- **FR-039a**: Stdout MUST be enough to diagnose any failure without the run folder. The run MUST print one header line with the run id, commit, run type, model, judge model, and the Copilot SDK and CLI versions.
- **FR-039b**: Each failure MUST print a block to stdout as it happens, holding:
  - **Where**: the scenario name and file path, the chain stage if any, the attempt, the turn, and the skill step reached.
  - **What**: the failed check with expected and actual values, and the scenario file line that declared it.
  - **Covered bullets**: the text and hash of each bullet the scenario covers.
  - **Recent history**: the last turns, capped at about 20 lines, and any rejected permission requests.
  - **Likely cause**: one sentence from a fixed table keyed by failure kind (FR-039c).
- **FR-039c**: The likely cause MUST come from a fixed table of failure kinds, not a model, so the same failure always prints the same cause. The table MUST cover at least:
  - unmatched question;
  - rejected shell, memory, or outside write;
  - a file changed in the test project outside the scenario's `writes:` patterns;
  - turn limit or timeout, naming the repeated question when one repeats;
  - a failed structural assertion, such as a missing template heading;
  - a fixture blocked by template validation;
  - each exit-2 cause: missing token, no Copilot access, a failed distribution build with the tail of its output, a persistent rate limit, and a used-up premium-request allowance.

  An unlisted failure MUST print "unclassified" with the raw error.
- **FR-039d**: Each failure MUST also print one line starting with `HARNESS-FAILURE ` followed by a single-line JSON object holding the same fields, so a pipeline can parse failures from the log.
- **FR-039e**: The final summary MUST list every failure and skipped scenario in one place, each with its likely cause.
- **FR-039f**: All stdout MUST be redacted (FR-034) and length-capped, so no transcript floods the log or leaks a key.

**Content**

- **FR-040**: highway-codify MUST reach full coverage.
- **FR-041**: Every skill MUST have one smoke scenario.
- **FR-042**: No shipped skill, template, or governance file changes in this phase, except the distribution manifest and development constitution in FR-002 and FR-003.
- **FR-043**: `harness/README.md` MUST explain how the harness works and how to use it. It MUST cover:
  - **How it works**: the test project built per attempt, the Copilot driver and its permissions, keyed replies and the model fallback, the checks in order (file assertions, invariants, judge), the retry, and the "paraphrased question" and "flaky" warnings.
  - **Setup**: the Node version, installing dependencies, and the Copilot token in `.env`.
  - **Running**: full, smoke, and targeted runs, with an example command for each; every switch; and the exit codes.
  - **Reading results**: the run folder layout, the attempt files, the run report, JUnit XML, and selection reasons.
  - **Writing tests**: the scenario file format with one complete example, fixtures and overlays, promoting candidate snapshots, and covering, checking as an invariant, or waiving a bullet.
  - **Selection and coverage**: the path map, and how a reworded bullet appears and is retagged.
  - **Bash suite checks**: which harness checks the bash suite runs, and how to fix each failure.
  - **Diagnosing failures**: the stdout failure block, the `HARNESS-FAILURE` line, and the likely-cause table with what to check for each cause.
- **FR-044**: A harness test MUST fail when a switch the parser defines does not appear in `harness/README.md`.

### Key Entities

- **Test project**: A temporary folder built from the distribution output and one fixture. One per attempt.
- **Fixture**: A stage snapshot or an overlay on one. Validated against current templates.
- **Scenario**: One conversation: fixture, skills, opening message, keyed replies, expected files, `writes:` patterns, covered bullets, smoke flag, web flag, and an optional chain position. Stored as a plain `key: value` file read by both bash and the runner.
- **Keyed reply**: A reply sent when its key, the skill's exact question text or a pattern, appears in the agent's message, or when the model fallback picks it.
- **Coverage item**: A step, Verification bullet, or Error Handling bullet of one skill. Bullets carry a text hash and one treatment: scenario, invariant, or waiver.
- **Run**: One harness invocation. Has a type (full, smoke, targeted), a folder, a report, JUnit XML, and selection reasons.
- **Attempt**: One try of one scenario. Has a raw transcript, a normalized transcript, a result, and usage.
- **Candidate snapshot**: A passing chain stage's output, held in the run folder until promoted.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of highway-codify's Verification and Error Handling bullets are a scenario, an invariant, or a waiver with a reason.
- **SC-002**: A targeted run on highway-codify passes from fixtures.
- **SC-003**: A full run passes and produces a candidate snapshot for each of the 5 stages, and promotion replaces exactly those 5 fixtures.
- **SC-004**: A `--changed-since` run on a change to `codify-plan.md` selects every highway-codify scenario and no other skill's scenarios, and states the reason for each.
- **SC-005**: A smoke run executes exactly 15 scenarios, one per skill.
- **SC-006**: 0 runs wait for a person.
- **SC-007**: 0 files outside the test project change during any run, other than the run folder.
- **SC-008**: 0 keys or tokens appear in any saved transcript or result.
- **SC-009**: Every switch appears in `--help`, and the harness test that checks this passes.
- **SC-010**: The bash suite passes with no failures, including the new fixture, coverage, smoke, and path-map checks.
- **SC-011**: A maintainer new to the harness can install it, run a smoke run, and add a scenario using only `harness/README.md`, and every switch appears in it.
- **SC-012**: For every failure kind in the likely-cause table, a seeded failure prints its block, its `HARNESS-FAILURE` line, and its cause to stdout, and the failure can be diagnosed with the run folder deleted.

## Assumptions

- The pipeline is a later spec: the pull request check, the full suite before merge, and artifact upload. This spec keeps the harness ready for it: headless runs, exit codes, JUnit XML, and `--changed-since`.
- The spike in User Story 1 confirms that a `/highway-codify ...` message invokes the skill through the Copilot SDK. If it does not, the opening message names the skill in plain words, and that finding is recorded for Phase 3.
- Usage is recorded as the SDK reports it (premium requests, tokens, or both). A cost cap is out of scope until that is known.
- The chain runs setup, request, discovery, architecture, implementation, then codify. Profile, objectives, controls, NFRs, assessment, ADR, onboarding, and codify-config are reached through scenarios from fixtures, not the chain.
- VS Code's chat agent is not driven. Its behavior is still checked by hand.
- Scenarios are written by hand. Converting a captured interactive transcript into keyed replies is a later convenience.
- Fixed bullet ids are out of scope unless retagging after rewording becomes a burden.
- Other agent drivers come in Phase 3.
