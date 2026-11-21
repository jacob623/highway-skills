# Harness Findings: GPT-5.6 Luna Smoke Baseline

Status: open. It was recorded on 2026-11-12, during spec 242 (Phase 14, Progressive Disclosure),
before any skill changed. This document holds enough to research the failures or to fill a new
spec. It is development-only and excluded from the distribution.

## Summary

On GPT-5.6 Luna, the smoke set passes 6 of 16 scenarios, and 3 of those 6 pass only on retry.

The failures are not caused by a skill change: the run used the skills at commit `49ab958`,
unmodified. Most failures share one mechanism:
- Luna follows a skill's procedure literally.
- It takes a branch the scenario script does not expect: a list to choose from, a fallback
  question, or an extra review round.
- The harness then answers that question with a catch-all or an out-of-order reply.
- The conversation falls out of step, and the run ends on an `unmatched-question` or a missing
  file.

Some failures point at gaps in the skill text, some at scenario scripts written for a more lenient
model, and two at the Copilot service.

## Run

| Field | Value |
| --- | --- |
| Run id | `20261112-162017Z-smoke-49ab958` |
| Commit | `49ab958c618f6be1d2c79a67a2a290566e035639` (main, skills unmodified) |
| Model and judge | `gpt-5.6-luna` (listed by Copilot `listModels()` as "GPT-5.6 Luna") |
| Copilot | SDK 1.0.30, CLI 1.0.108 |
| Settings | `harness/harness.config.json`: parallel 4, maxTurns 40, timeoutMinutes 20 |
| Usage | 314 model calls, 9,182,251 input tokens, 72,364 output tokens |
| Transcripts | `specs/242-standard-alignment-progressive-disclosure/harness/pre-smoke/20261112-162017Z-smoke-49ab958/` |

Reproduce from the repository root, with a token in `harness/.env`:

```bash
node harness/src/cli.ts --smoke --transcripts <folder>
node harness/src/cli.ts --skills highway-adr --model gpt-5.6-luna      # one skill, every scenario
```

Each scenario folder holds `attempt-N.jsonl` (the dialogue), `attempt-N.raw.jsonl` (SDK events),
and `attempt-N.result.json` (failures with recent turns).

## Results

| Scenario | Status | Attempt 1 | Attempt 2 | Findings |
| --- | --- | --- | --- | --- |
| adr-smoke | fail | unmatched-question | unmatched-question | F1, F3 |
| architecture-smoke | pass (flaky) | unmatched-question | pass | F1, F3 |
| assessment-smoke | pass | pass | | |
| codify-config-smoke | fail | unmatched-question | unmatched-question | F3, F4 |
| codify-smoke | pass (flaky) | assertion | pass | F6 |
| controls-smoke | fail | assertion | service error | F7, F8 |
| discovery-smoke | fail | unmatched-question | unmatched-question | F1, F3, F5 |
| experience-smoke | pass | pass | | |
| help-smoke | pass | pass | | |
| implementation-smoke | fail | assertion | assertion | F6, F9 |
| nfrs-smoke | fail | assertion | unmatched-question | F5, F7 |
| objectives-smoke | fail | assertion | service error | F8, F10 |
| onboarding-smoke | fail | unmatched-question | unmatched-question | F3, F4 |
| profile-smoke | fail | unmatched-question | unmatched-question | F2, F3, F4 |
| request-smoke | pass (flaky) | assertion | pass | F6 |
| setup-smoke | fail | assertion | assertion | F2 |

## Findings

Each finding gives:
- **Evidence**: where it shows up in the transcripts.
- **Skill text**: the instructions involved.
- **Owner**: where a fix most likely belongs: a skill, a scenario, the harness, or the service.

### F1: A name in the opening is not used to pick the record

**Evidence**:
- adr-smoke opens with `/highway-adr Weekly Order Restock Alerts Options`, a Discovery *title*.
  Both attempts list Discoveries and ask "Which Discovery would you like to decide?"
- architecture-smoke attempt 1 opens with an ADR title and asks "Which ADR would you like to turn
  into a Reference Architecture?"
- discovery-smoke attempt 1 opens with a Request title and asks "Which would you like to work on?"
- In the post-change run, implementation-smoke opens with `/highway-implementation Scheduled
  Restock Alert Service. …`, a Reference Architecture *title*. Both attempts list architectures
  and ask "Which Reference Architecture would you like to realize?" The catch-all
  `[unknown] I don't know.` re-emits the list (F3). highway-implementation `Entry` step 3 reads
  only an id, the same wording as highway-adr. The baseline run resolved the title anyway.

**Skill text**: highway-adr `Entry` step 1 reads "Read the invocation for one Discovery id and one
option id", and step 2 says "When neither is present, go to `choose-discovery`." A title is not an
id, so the literal path is the list. `choose-discovery` accepts a title only as a reply to the
list. The architecture and discovery `Entry` steps are worded the same way (to confirm).

**Owner**: skill or scenario. Either `Entry` resolves a title that matches exactly one waiting
record, or the scenarios open with an id, or they script the list question.

## Questions for research

1. Does the previous model (`claude-sonnet-4.5`) pass these scenarios at the same commit? If so,
   which failures does Luna alone show?
2. Should scenarios be model-portable, with no reliance on a model inferring past the text?

## Possible spec scope

- **Skill clarity**: keep the Example Realization Matrix header row when it has no rows (F18).
- **Scenario portability**: keep the onboarding capability list to the capability the opening
  names, so no `Unknown` provider is proposed (F21).
- **Harness**: `shows:` ignores inline code backticks, as it ignores bold (F23).
- **Model behavior to watch**: the occasional missed title (F1); the onboarding `orchestrate`
  announcement (F19); absolute paths that lose the temporary folder (F20); a proposal shown
  without its question (F22); a shell command after the session ends (F24); a question the skill
  does not ask, put through the input tool (F25).
- **Exit criterion**: the smoke set passes on GPT-5.6 Luna and on the previous model.

## Baseline for spec 242

This run is the baseline for spec 242. The skill split there must do no worse. The post-change
smoke run on `gpt-5.6-luna` must, scenario by scenario:
- keep every scenario that passed here passing (flaky counts as passing);
- show no new failure kind in a scenario that failed here.

A scenario's failure kind or step may change only when the transcript shows the same finding
listed above, and not a regression from the split.

## Post-change run for spec 242

Run `20261112-170628Z-smoke-49ab958`, after all twelve splits, on `gpt-5.6-luna`. Transcripts are
under `specs/242-standard-alignment-progressive-disclosure/harness/post-smoke/`. It passes 6 of
16, the same six as the baseline, none of them flaky. The token value appears in no transcript.

| Scenario | Baseline | Post-change attempt 1 | Post-change attempt 2 | Findings | Verdict |
| --- | --- | --- | --- | --- | --- |
| adr-smoke | fail | unmatched-question | unmatched-question | F1, F3 | no worse |
| architecture-smoke | pass (flaky) | pass | | | no worse |
| assessment-smoke | pass | pass | | | no worse |
| codify-config-smoke | fail | unmatched-question | unmatched-question | F3, F4 | no worse |
| codify-smoke | pass (flaky) | pass | | | no worse |
| controls-smoke | fail | service error | service error | F8 | no worse |
| discovery-smoke | fail | unmatched-question | unmatched-question | F1, F3, F5 | no worse |
| experience-smoke | pass | pass | | | no worse |
| help-smoke | pass | pass | | | no worse |
| implementation-smoke | fail | unmatched-question | unmatched-question | F1, F3 | no worse; kind changed (see below) |
| nfrs-smoke | fail | experience-order and assertion | service error | F10, F11, F8 | new kind F11 (see below) |
| objectives-smoke | fail | service error | assertion | F8, F10 | no worse |
| onboarding-smoke | fail | unmatched-question | unmatched-question | F3, F4 | no worse |
| profile-smoke | fail | unmatched-question | unmatched-question | F2, F3, F4 | no worse |
| request-smoke | pass (flaky) | pass | | | no worse |
| setup-smoke | fail | assertion | assertion | F2, F3, F4 | no worse |

- **implementation-smoke** changed from `assertion` to `unmatched-question`. The step where it
  fails, `choose`, stayed in `SKILL.md` unchanged. The model takes the literal path F1 describes:
  the opening has a title, and `Entry` reads only an id.
- **nfrs-smoke** attempt 1 fails on F10 at `Entry` (a `glob` result reported a present record
  missing). It also shows `experience-order`, a kind no baseline attempt shows (F11). The
  activation line and `Entry` are unchanged in `SKILL.md`. Attempt 2 read both nfrs flow files
  and wrote the record, then hit F8.
- The flow files are reached. Each split skill's smoke transcripts name that skill's flow files.
  The failure reports show the agent reading them with `view`: proposal and record files for
  controls, nfrs, and objectives; `explore.md` for discovery; `standards.md` and `conflicts.md`
  for codify-config; and the proposal and record files for implementation.

## Affected run for spec 242 (Option B)

Run `20261112-171321Z-targeted-49ab958`, `--changed-since main`, on `gpt-5.6-luna`. Its
transcripts were not kept: spec 247 retired the default run folder and deleted it. It selected 50 scenarios. 33 passed (7 of them flaky) and 17 failed.
Only the 16 smoke scenarios have a baseline. For the rest, each failing attempt is matched to a
finding.

| Scenario | Attempt 1 | Attempt 2 | Findings |
| --- | --- | --- | --- |
| chain-architecture | unmatched-question (asks for a purpose title) | same | F5, F3 |
| chain-codify | unmatched-question (extra review) | pass | F4 |
| chain-discovery | unmatched-question (explore question) | same | F5, F3 |
| chain-implementation | assertion (onboarding map review loops on an Unknown provider) | assertion (false Oops) | F3, F4, F6 |
| chain-request | experience-order | pass | F11 |
| chain-setup | unmatched-question (objectives recommendations and a queue) | same | F5 |
| codify-config-smoke | unmatched-question | same | F3, F4 |
| codify-configure | unmatched-question (invokes highway-codify-config and shows its menu) | same | F5 |
| codify-integration | rejected-request (`find`) | pass | F12 |
| codify-named-platform | unmatched-question (an unscripted clarifying question) | pass | F3 |
| codify-needed-language | unmatched-question ("Would you like to return and provide these details now?") | same | F9 |
| codify-no-governance | unmatched-question (extra review) | pass | F4 |
| codify-plan-review | assertion (no task list) | rejected-request (`ruby`) | S1, F12 |
| codify-standards | unmatched-question (an unscripted clarifying question) | pass | F3 |
| controls-smoke | experience-order, assertion (no write after accepting) | assertion (record judged missing) | F11, F7, F10 |
| discovery-smoke | unmatched-question | same | F5, F3 |
| implementation-onboards-platform | assertion (no onboarding handoff) | assertion (the handoff instruction printed as text) | F9 |
| implementation-smoke | unmatched-question | pass | F1, F3 |
| nfrs-smoke | assertion | assertion | F7, F10 |
| objectives-smoke | assertion | service error | F7, F8 |
| onboarding-smoke | unmatched-question | same | F3, F4 |
| profile-smoke | unmatched-question | rejected-request (`mkdir`), unmatched-question | F2, F3, F4, F12 |
| request-setup-needed | assertion (the message without bold) | same | F13 |
| setup-smoke | assertion | assertion | F2, F4 |

S1 is the one failure the split causes. Every other failing attempt shows a model, scenario, or
service finding, at a step whose text the split did not change, or after the agent read the flow
file that holds it.

## Rerun after the S1 fix for spec 242

Two targeted runs, `--skills highway-codify,highway-discovery` on `gpt-5.6-luna`, at the same
commit. Transcripts are under
`specs/242-standard-alignment-progressive-disclosure/harness/s1-rerun/`. Run 1 is
`20261112-181837Z-targeted-49ab958`: 26 passed (5 flaky), 4 failed. Run 2 is
`20261112-182131Z-targeted-49ab958`: 25 passed (3 flaky), 5 failed.

| Scenario | Option B | Run 1 | Run 2 | Findings |
| --- | --- | --- | --- | --- |
| codify-plan-review | fail | pass | pass | S1 fixed |
| codify-needed-language | fail | pass (flaky) | pass | |
| codify-configure | fail | fail | pass | F5 |
| chain-discovery | fail | fail | fail | F5, F3 |
| discovery-smoke | fail | fail | fail | F1, F5, F3, F6 |
| codify-code-project | pass | fail | pass (flaky) | F6 |
| codify-not-running | pass | pass | fail | F11, F14 |
| codify-platform-no-row | pass | pass (flaky) | fail | F14 |
| codify-controls-conflict | pass | pass | fail | F15 |

Every other codify and discovery scenario passes in both runs. No scenario fails both runs that
passed in Option B. discovery-smoke attempt 1 of run 1 runs `analyze` through `write` and on to
`start` in one turn, writes the Discovery, and shows the option list. That is the path merged
into `references/options.md`.

## Final runs for spec 243

Three runs on `gpt-5.6-luna` after every spec 243 change, the full suite (86 of 86), and two
generator runs with no change. Transcripts are under
`specs/243-harness-failure-resolutions/harness/`, which is gitignored. The token value appears
in none of the 285 captured files.

| Run | Selection | Passed | Flaky | Failed | Blocked |
| --- | --- | --- | --- | --- | --- |
| `20261113-051531Z-smoke-fe522b4` | `--smoke` (16) | 11 | 2 | 4 | 1 |
| `20261113-052407Z-targeted-fe522b4` | `--changed-since main` (48) | 38 | 7 | 9 | 1 |
| `20261113-054508Z-targeted-fe522b4` | `--skills highway-request` (3) | 3 | 0 | 0 | 0 |

Smoke went from 6 of 16 passing (spec 242 post-change) to 11 of 16. The affected run went from
33 of 50 to 38 of 48. Every failing attempt is matched to a finding below.

| Scenario | Run | Attempt 1 | Attempt 2 | Findings |
| --- | --- | --- | --- | --- |
| controls-smoke | smoke | service-error | service-error (blocked) | F7 |
| discovery-smoke | smoke, changed | assertion (Candidate and Example tables dropped) | same | F18 |
| nfrs-smoke | smoke, changed | service-error or assertion (`contains` on the fixture's NFR) | assertion, same | F7, F16 |
| objectives-smoke | smoke | service-error | assertion (`contains` on the fixture's objective) | F7, F16 |
| objectives-smoke | changed | service-error | service-error (blocked) | F7 |
| setup-smoke | smoke | unmatched-question (an answered in-turn question re-matched) | assertion (asset reads at a wrong absolute path) | F17, F20 |
| setup-smoke | changed | assertion (Identity block shown without its question) | rejected-request (catalog write at a wrong absolute path) | F22, F20 |
| onboarding-smoke | smoke | unmatched-question (accept on an `Unknown` provider re-emits) | pass | F21 |
| onboarding-smoke | changed | assertion (onboarding ADR drops `## Decision Confidence`) | same | F18 |
| controls-smoke | changed | service-error | assertion (`contains` on the fixture's control) | F7, F16 |
| chain-discovery | changed | assertion (Comparison Matrix dropped) | assertion (Example table dropped) | F18 |
| chain-implementation | changed | assertion (stops after the orchestrate line) | same | F19 |
| implementation-onboards-platform | changed | unmatched-question (provider question) | assertion (stops after the orchestrate line) | F21, F19 |
| codify-configure | changed | unmatched-question | same | F5 |

Flaky first attempts: adr-smoke (listed Discoveries despite the exact title, F1; its `\?` catch-all
then drew the same question again, F3, the only F3 case in these runs), codify-config-smoke (F7),
codify-controls-conflict (F15), codify-no-architecture (the plan menu, which the script does not
key), codify-needed-language and codify-no-governance (an unscripted clarifying question),
codify-folder-taken (showed the "plan is complete" menu without writing the plan), and chain-codify
(a bare `/highway-codify` entered `catalog` instead of `choose`, F5). None of the
unscripted-question attempts involved a catch-all reply.

## Final runs for spec 244

One run on `gpt-5.6-luna` after every spec 244 change, the full suite (87 of 87), the harness
unit tests (94 of 94), and two generator runs with no change. It selected
`--changed-since 42a0569` plus, with `--paths`, the 18 scenarios that failed an attempt in spec
243's final runs. The harness driver changed, so the selection was all 49 scenarios. Transcripts
are under `specs/244-harness-failure-followups/harness/`, which is gitignored. The token value
appears in none of the 186 captured files.

| Run | Selection | Passed | Flaky | Failed | Blocked |
| --- | --- | --- | --- | --- | --- |
| `20261113-064237Z-targeted-42a0569` | `--changed-since 42a0569` and `--paths` (49) | 45 | 3 | 4 | 0 |
| `20261113-070538Z-targeted-42a0569` | `--paths` codify-open-plan (1) | 1 | 0 | 0 | 0 |
| `20261113-070734Z-targeted-42a0569` | `--paths` codify-open-plan (1) | 1 | 0 | 0 | 0 |

Spec 243's changed run passed 38 of 48 with one blocked; this run passes 45 of 49 with none
blocked, and no -32603 error appears. Scenario by scenario, against spec 243's three final runs:

| Scenario | Spec 243 | Attempt 1 | Attempt 2 | Findings |
| --- | --- | --- | --- | --- |
| adr-smoke | pass; flaky | pass | | |
| chain-codify | flaky | pass | | |
| chain-discovery | fail | pass | | |
| chain-implementation | fail | pass | | |
| codify-config-smoke | flaky; pass | pass | | |
| codify-configure | fail | assertion (the line shown with the skill name in backticks) | same | F23 |
| codify-controls-conflict | flaky | rejected-request (plan write at a wrong absolute path) | pass | F20 |
| codify-folder-taken | flaky | pass | | |
| codify-needed-language | flaky | unmatched-question ("Is this accurate?" through the input tool) | pass | F25 |
| codify-no-architecture | flaky | pass | | |
| codify-no-governance | flaky | pass | | |
| controls-smoke | blocked; fail | pass | | |
| discovery-smoke | fail; fail | assertion (Example Realization Matrix written as `None` without its header row) | same | F18 |
| implementation-onboards-platform | fail | pass | | |
| nfrs-smoke | fail; fail | pass | | |
| objectives-smoke | fail; blocked | pass | | |
| onboarding-smoke | flaky; fail | rejected-request (`test -f` after the session ended) | repeated-question (a third `Unknown` provider) | F24, F21 |
| setup-smoke | fail; fail | pass | | |

Two scenarios outside the baseline failed an attempt:

| Scenario | Spec 243 | Attempt 1 | Attempt 2 | Findings |
| --- | --- | --- | --- | --- |
| chain-architecture | pass | rejected-request (record write at a wrong absolute path) | pass | F20 |
| codify-open-plan | pass | unmatched-question (product title not used; "already codified") | same | F1 |

codify-open-plan failed both attempts on unchanged `Entry` step 4 text, then passed both reruns,
so it is counted under F1 and not as a regression. Every other failing attempt is matched to a
finding above.

## Plugin install smoke for spec 246

Two smoke runs on `gpt-5.6-luna`, from the Agent Plugins build. Each attempt installed
`highway-agent-plugin/` into its own Copilot home through the client's plugin install, and the
test project held no skill folder. Before them, the full suite passed 87 of 87 and the harness
unit tests 102 of 102. Transcripts are under `specs/246-agent-plugins-package/harness/`, which is
gitignored. The token value appears in none of the 128 captured files.

| Run | Selection | Passed | Flaky | Failed | Blocked |
| --- | --- | --- | --- | --- | --- |
| `20261113-141852Z-smoke-be6a1d0` | `--smoke` (16) | 15 | 3 | 1 | 0 |
| `20261113-142757Z-smoke-be6a1d0` | `--smoke` (16) | 13 | 1 | 3 | 0 |

Passed includes flaky. No load failure occurred. All 40 attempts installed the plugin with 16
skills, every skill reported `source: plugin`, and no attempt failed with `plugin-install`.
Every install gave Copilot's notice that direct installs from a local path are deprecated. The
harness records it and does not fail on it.

The first run found one harness defect from this spec. A rejected read still said "Reads outside
the project are not available in this session." even though reads of the installed plugin are
allowed. In setup-smoke, after three reads at a wrongly copied plugin path were rejected, Luna
asked to `cat` the files instead. The message now reads "Reads are available inside the project
and the installed plugin only. Check that the path was copied exactly." In the second run, 16
reads at a wrongly copied plugin path were rejected. No attempt turned to the shell after them,
and most of those attempts passed.

| Scenario | Run 1 attempt 1 | Run 1 attempt 2 | Run 2 attempt 1 | Run 2 attempt 2 | Findings |
| --- | --- | --- | --- | --- | --- |
| adr-smoke | unmatched-question ("If this proposal is accurate, should I accept it?" through the input tool) | pass | pass | | F25 |
| codify-smoke | pass | | unmatched-question (a "no restock needed" email question through the input tool) | rejected-request (write at `/var/folders/…/0000gn/code/…`) | F25, F20 |
| discovery-smoke | assertion (Example Realization Matrix without its header row) | same | same, and the constraint table without its header row | Example Realization Matrix only | F18 |
| implementation-smoke | pass | | unmatched-question (lists the Reference Architectures for an exact title) | same, and experience-order | F1, F27 |
| objectives-smoke | pass | | assertion (`contains-any … :: repeat` against "Grow Repeat Customers") | pass | F28 |
| onboarding-smoke | assertion (no capability proposed but AI-Augmented; no record written) | pass | pass | | F26 |
| setup-smoke | rejected-request (`cat` of plugin files after wrongly copied reads) | pass | pass | | F20 |

Every other scenario passed its first attempt in both runs.

## Groundwork smoke for spec 247

Two smoke runs on `gpt-5.6-luna`, after the harness split into a shared runner and a Copilot
driver. Before each, the full suite passed 87 of 87 and the harness unit tests passed (145, then
147). Neither run used `--transcripts`, so no run folder was written. The second run's log is
committed at `specs/247-multi-agent-harness-groundwork/harness/smoke.log`. It is 70 KB and holds
no token and no temporary path.

| Run | Selection | Passed | Flaky | Failed | Blocked |
| --- | --- | --- | --- | --- | --- |
| `20261114-115258Z-smoke-40844ce` | `--smoke` (16) | 16 | 0 | 0 | 0 |
| `20261114-121007Z-smoke-40844ce` | `--smoke` (16) | 15 | 2 | 1 | 0 |

Passed includes flaky. All 35 attempts installed the plugin with 16 skills, and no attempt failed
with `plugin-install`.

The first run found one defect from this spec. Four rejected reads printed a raw `/var/folders/…`
path, because Luna had dropped the `T/highway-harness-…/` segment (F20) and the path was under
none of the project, the agent home, or the work root. The log now rewrites any other path under
the temporary folder to `<tmp>`. The first run's log was replaced by the second.

| Scenario | Run 2 attempt 1 | Run 2 attempt 2 | Findings |
| --- | --- | --- | --- |
| codify-smoke | assertion (`plan.md` without `## Decisions`) | pass | F18 |
| discovery-smoke | assertion (Example Realization Matrix without its header row) | same | F18 |
| onboarding-smoke | repeated-question (a third `Unknown` provider, Customer Support Management) | pass | F21 |

Every other scenario passed its first attempt in both runs. Each run had 9 rejected reads at a
path with a dropped segment (F20), all in attempts that passed. In both runs the judge marked 6
of codify-smoke's 7 bullets not met. The judge is advisory and did not fail the scenario.

## Agent manifests smoke for spec 248

One smoke run on `gpt-5.6-luna`, after the plugin gained a manifest for Claude Code, Codex,
Cursor, Antigravity, and Gemini CLI beside its root `plugin.json`. Before it, the full suite passed
87 of 87 and the harness unit tests 147 of 147. The run used no `--transcripts`. Its log is
committed at `specs/248-agent-manifests/harness/smoke.log`; it is 63 KB and holds no token and no
temporary path.

| Run | Selection | Passed | Flaky | Failed | Blocked |
| --- | --- | --- | --- | --- | --- |
| `20261114-203043Z-smoke-557dddb` | `--smoke` (16) | 14 | 1 | 2 | 0 |

Passed includes flaky. All 19 attempts reported `installed plugin highway (16 skills)`, so Copilot
still reads the root `plugin.json` with the other manifests present, and no attempt failed with
`plugin-install`.

| Scenario | Attempt 1 | Attempt 2 | Findings |
| --- | --- | --- | --- |
| discovery-smoke | assertion (Example Realization Matrix without its header row) | same | F18 |
| onboarding-smoke | assertion (ADR without `## Decision Confidence`) | unmatched-question (a Continue or Stop choice the skill does not ask) | F18, F25 |
| setup-smoke | rejected-request (write to `requests/requests.md` with the temporary folder segment dropped) | pass | F20 |

Every other scenario passed its first attempt. Five reads were rejected at a path with a dropped
segment (F20), all in attempts that passed. The judge marked 6 of codify-smoke's 7 bullets not
met, as in spec 247; it is advisory and did not fail the scenario.

## Cursor driver smoke for spec 249

Three live runs on Cursor local runtime (`@cursor/sdk` 1.4.0) with `models.cursor` =
`gpt-5.6-luna` (same as Copilot). Judge stayed Copilot/`gpt-5.6-luna`. Before the runs, the full
suite passed 87 of 87 and the harness unit tests 157 of 157. No `--transcripts`. Logs:

| Log | Run id | Bytes |
| --- | --- | --- |
| `specs/249-cursor-driver/harness/smoke-1.log` | `20261116-140947Z-smoke-cursor-8fe482f` | 108 KB |
| `specs/249-cursor-driver/harness/smoke-2.log` | `20261116-144422Z-smoke-cursor-8fe482f` | 110 KB |
| `specs/249-cursor-driver/harness/codify.log` | `20261116-151541Z-targeted-cursor-8fe482f` | 160 KB |

No token or `CURSOR_API_KEY` appears. A few fail lines still name a `/var/folders/…` path inside
an outside-write detail (F20). Logs sit slightly over the 100 KB guidance because Cursor turn
text is longer than Copilot's; Phase 18 can tighten size rules.

| Run | Selection | Passed | Flaky | Failed | Blocked |
| --- | --- | --- | --- | --- | --- |
| smoke-1 | `--agent cursor --smoke` (16) | 0 | 0 | 16 | 0 |
| smoke-2 | `--agent cursor --smoke` (16) | 1 | 0 | 15 | 0 |
| codify | `--agent cursor --skills highway-codify` (28) | 4 | 1 | 24 | 0 |

Passed includes flaky. Every attempt that reached install reported `installed plugin highway (16
skills)` (32, 31, and 53 install lines respectively). No `plugin-install` failure.

Smoke map (both smoke runs; smoke-2 notes in parentheses when different):

| Scenario | Failure | Findings |
| --- | --- | --- |
| adr-smoke | experience-order | F27, F29 |
| architecture-smoke | experience-order | F27, F29 |
| assessment-smoke | experience-order | F27, F29 |
| codify-config-smoke | experience-order | F27, F29 |
| codify-smoke | experience-order | F27, F29 |
| controls-smoke | experience-order | F27, F29 |
| discovery-smoke | experience-order | F27, F29 |
| experience-smoke | experience-order (smoke-2: pass) | F27, F29 |
| help-smoke | experience-order | F27, F29 |
| implementation-smoke | experience-order | F27, F29 |
| nfrs-smoke | experience-order | F27, F29 |
| objectives-smoke | unclassified / experience-order | F29 |
| onboarding-smoke | experience-order | F27, F29 |
| profile-smoke | experience-order | F27, F29 |
| request-smoke | experience-order | F27, F29 |
| setup-smoke | experience-order | F27, F29 |

Codify: `codify-catalog`, `codify-no-architecture`, `codify-no-implementations` (flaky), and
`codify-standards` passed. Most other scenarios failed `experience-order` (F27, F29).
`codify-existing-product` and `codify-folder-taken` failed `unmatched-question` (script/model
drift, not a new Cursor finding). `codify-code-project` had an unclassified session error once.

## Cursor experience-order fix for spec 250

Three confirmation runs after the Cursor driver mapped skill ids from `/skills/<id>/` reads,
normalized `.cursor/plugins/local/highway/…` paths onto the install read root, and deferred
`outputSeen` until the turn’s agent log (so streamed text tokens no longer emptied
`skillsBeforeOutput`). Before the runs: suite 87/87, harness tests 161/161. Logs:

| Log | Run id | Bytes |
| --- | --- | --- |
| `specs/250-cursor-experience-order/harness/smoke-1.log` | `20261116-183431Z-smoke-cursor-db3d54c` | 59 KB |
| `specs/250-cursor-experience-order/harness/smoke-2.log` | `20261116-185430Z-smoke-cursor-db3d54c` | 61 KB |
| `specs/250-cursor-experience-order/harness/codify.log` | `20261116-191450Z-targeted-cursor-db3d54c` | 110 KB |

No token or `CURSOR_API_KEY`. Zero attempts across all three logs failed experience-order with
`actual no skill` (F29 close gate). Zero `fail: experience-order` lines in any of the three logs.

| Run | Selection | Passed | Flaky | Failed | Blocked |
| --- | --- | --- | --- | --- | --- |
| smoke-1 | `--agent cursor --smoke` (16) | 14 | 0 | 2 | 0 |
| smoke-2 | `--agent cursor --smoke` (16) | 15 | 1 | 1 | 0 |
| codify | `--agent cursor --skills highway-codify` (28) | 25 | 4 | 3 | 0 |

Passed includes flaky. Remaining smoke failures: discovery-smoke (both runs) on F18 (Example
Realization Matrix header row); request-smoke (smoke-1) wrote no request file after a nested
project-path denial (F20). Codify failures: chain-codify, codify-code-project, and
codify-plan-review — missing expected files / assertions, not experience-order; not tagged to an
open finding beyond F20-style path noise where present.

## Open findings confirmation for spec 251

Four confirmation runs after F18 skill wording, F23/F28 harness check fixes, and F20 shorter
attempt paths (`hh-` / `h/` / `p/`, short labels). Before the runs: suite 87/87, harness tests
163/163. Logs:

| Log | Run id | Bytes |
| --- | --- | --- |
| `specs/251-open-findings/harness/smoke-copilot.log` | `20261117-140730Z-smoke-a214fd7` | 56 KB |
| `specs/251-open-findings/harness/smoke-cursor-1.log` | `20261117-141239Z-smoke-cursor-a214fd7` | 63 KB |
| `specs/251-open-findings/harness/smoke-cursor-2.log` | `20261117-143234Z-smoke-cursor-a214fd7` | 67 KB |
| `specs/251-open-findings/harness/targeted-cursor.log` | `20261117-145426Z-targeted-cursor-a214fd7` | 23 KB |

No token or `CURSOR_API_KEY`. Committed logs hold no raw temporary absolute paths.

| Run | Selection | Passed | Flaky | Failed | Blocked |
| --- | --- | --- | --- | --- | --- |
| smoke-copilot | `--smoke` (16) | 16 | 0 | 0 | 0 |
| smoke-cursor-1 | `--agent cursor --smoke` (16) | 14 | 1 | 2 | 0 |
| smoke-cursor-2 | `--agent cursor --smoke` (16) | 13 | 0 | 3 | 0 |
| targeted-cursor | five scenarios (discovery, codify-configure, objectives, request, setup) | 5 | 2 | 0 | 0 |

Passed includes flaky.

**Closed here:**

- **F18**: Skill text names the empty Example Realization Matrix header row. No confirmation run
  failed the template check for that missing header when a Discovery file was written. Copilot
  discovery-smoke passed; Cursor smoke-1 flaky-pass (attempt 2 template OK); targeted discovery
  passed. Cursor smoke-2 discovery failed for a different reason (F30).
- **F23 / F28**: Unit tests and README; targeted `codify-configure` and `objectives-smoke` passed.
- **F20**: Shorter layout landed. Collapsed-path `denied:` counts on these Cursor runs are fewer
  than the cited groundwork baseline of nine rejected reads per smoke (smoke-cursor-1/2 each had
  four `denied:` lines total, not all collapsed-path). Close per clarify (any confirmed reduction).

Cursor smoke failures that remain (adr-smoke, codify-smoke on smoke-1; adr-smoke and discovery on
smoke-2) are missing-file / template-structure misses other than the F18 header case, or F30.

# Harness Failures

Outstanding findings only. Earlier resolved findings (including F1, F18–F29 except as listed
below) were removed after they stopped matching the confirmation evidence or were closed by a
resolving spec. Run tables above keep historical ids. Each resolution is in the resolving spec's
`research.md`. Spec 251 closed F18, F20, F23, and F28.

## Codex driver smoke for spec 252

Three confirmation runs after the Codex driver, storage-contract MINOR 1.3.0, judge Cursor/Luna,
and effects-based shell enforcement. Before the runs: suite 87/87, harness tests 175/175. Logs:

| Log | Run id | Bytes |
| --- | --- | --- |
| `specs/252-codex-driver/harness/smoke-1.log` | `20261118-143908Z-smoke-codex-130aaf8` | 57 KB |
| `specs/252-codex-driver/harness/smoke-2.log` | `20261118-144703Z-smoke-codex-130aaf8` | 63 KB |
| `specs/252-codex-driver/harness/codify.log` | `20261118-145347Z-targeted-codex-130aaf8` | 127 KB |

Every attempt printed `installed plugin highway (16 skills)`. Model `gpt-5.6-luna`; judge
`cursor/gpt-5.6-luna`. No API key material in the logs.

| Run | Selection | Passed | Failed |
| --- | --- | --- | --- |
| smoke-1 | `--agent codex --smoke` (16) | 0 | 16 |
| smoke-2 | `--agent codex --smoke` (16) | 0 | 16 |
| codify | `--agent codex --skills highway-codify` (28) | 0 | 28 |

Dominant failure: Codex wraps exploration in `/bin/zsh -lc '… git …'` (status/log/diff). Effects
enforcement fails the attempt (F31). Secondary: experience-order when highway-experience is not
activated before first agent text; unmatched-question when Codex does not load Highway skills as
slash commands.

## F30: Cursor looks for skill assets under the project instead of the plugin

**Skill**: highway-discovery (observed); may affect other skills that read `assets/`

**Runs**:

- Spec 251 Cursor smoke-2 `20261117-143234Z-smoke-cursor-a214fd7`: discovery-smoke (both attempts)

**Category**: Model

**Confirmed**: Yes

**Basis**: Both discovery-smoke attempts installed the plugin (16 skills) then stopped without
writing, saying `assets/discovery-record.md` was missing from the repository. The template lives
in the installed plugin skill tree, not the throwaway project. Copilot smoke and the Cursor
targeted run wrote Discoveries successfully on the same skill text. This is not the F18 header-row
miss.

**Proposed resolution**: No skill change yet. Watch whether Cursor keeps resolving skill `assets/`
against the project root. If it recurs, consider harness or install layout guidance so the model
sees the plugin asset path clearly; do not move templates into the project fixture.

## Codex smoke recovery for spec 253

Three confirmation runs after git pre-refuse, throwaway Local-mode guidance, and Codex plugin
marketplace/CLI load fixes. Before the runs: suite 87/87, harness tests 179/179. Logs:

| Log | Run id | Bytes |
| --- | --- | --- |
| `specs/253-codex-smoke-failures/harness/smoke-1.log` | `20261118-175613Z-smoke-codex-eea091c` | ~72 KB |
| `specs/253-codex-smoke-failures/harness/smoke-2.log` | `20261118-180232Z-smoke-codex-eea091c` | ~62 KB |
| `specs/253-codex-smoke-failures/harness/codify.log` | `20261118-180721Z-targeted-codex-eea091c` | ~129 KB |

Every attempt printed `installed plugin highway (16 skills)` and
`codex plugin marketplace add` / `plugin add highway@highway-local: ok`. Model `gpt-5.6-luna`;
judge `cursor/gpt-5.6-luna`.

| Run | Selection | Passed | Failed |
| --- | --- | --- | --- |
| smoke-1 | `--agent codex --smoke` (16) | 15 | 1 |
| smoke-2 | `--agent codex --smoke` (16) | 14 | 2 |
| codify | `--agent codex --skills highway-codify` (28) | 21 | 7 |

Git-driven storage fails dropped from Phase 9 baseline (~40 git shell rejects on smoke-1) to ~0 on
confirming smokes. Remaining fails are mostly outside-path probes of `<work>`/`<tmp>`, assertion
template misses, or unmatched-question — see F32.

## F31: Codex explores with `git` through the shell — closed

**Skill**: all (observed on smoke and highway-codify)

**Runs**:

- Spec 252 smoke-1 / smoke-2 / codify (`--agent codex`, model `gpt-5.6-luna`) — open basis
- Spec 253 smoke-1 / smoke-2 (≥9/16 each: 15/16 and 14/16) — closed

**Category**: Model + enforcement

**Confirmed**: Yes (Phase 9); resolved in spec 253

**Basis**: Phase 9: after install, Codex typically ran `/bin/zsh -lc "… git …"` and effects
enforcement failed the attempt. Spec 253: throwaway `$CODEX_HOME/rules/default.rules` forbids
`git` before run; harness treats non-completed git as logged non-fatal pre-refuse and completed
git as fatal; Local-mode `AGENTS.md` ships in the throwaway home. Confirming smokes meet FR-005
and show far fewer git-driven fails than the Phase 9 baseline.

**Resolution**: Closed. Keep forbidding completed `git` (FR-001); pre-refuse remains the primary
lever.

## F32: Codex still probes `<work>` / `<tmp>` outside the project

**Skill**: intermittent on smoke (request) and highway-codify

**Runs**:

- Spec 253 smoke-1 request-smoke; smoke-2 discovery-smoke / request-smoke; several codify fails

**Category**: Model + enforcement

**Confirmed**: Yes

**Basis**: With git pre-refuse in place, some attempts still shell into the harness work root or
OS temp (`outside-write: <work>` / `<tmp>`), which effects enforcement fails. Separate residual
fails are assertion template misses or unmatched-question when Codex does not follow a scripted
reply.

**Proposed resolution**: Watch whether stronger cwd guidance or denying work-root path tokens
without weakening in-project shell-as-file-tool use is needed; not a reopen of F31.

## Claude Code driver for spec 254

Three confirmation runs after the Claude Code driver (`@anthropic-ai/claude-agent-sdk`), Haiku
pin `claude-haiku-5-5`, judge Cursor/Luna, and `canUseTool` deny-all-Bash. Before the runs: suite
87/87, harness tests 193/193. Logs:

| Log | Run id | Bytes |
| --- | --- | --- |
| `specs/254-claude-code-driver/harness/smoke-1.log` | `20261118-213144Z-smoke-claude-e809308` | ~110 KB |
| `specs/254-claude-code-driver/harness/smoke-2.log` | `20261118-214040Z-smoke-claude-e809308` | ~113 KB |
| `specs/254-claude-code-driver/harness/codify.log` | `20261118-214817Z-targeted-claude-e809308` | ~285 KB |

Every attempt printed `installed plugin highway (16 skills)`. Model `claude-haiku-5-5`; judge
`cursor/gpt-5.6-luna`. No API key material in the logs. No numeric pass floor this phase.

| Run | Selection | Passed | Failed |
| --- | --- | --- | --- |
| smoke-1 | `--agent claude --smoke` (16) | 13 | 3 |
| smoke-2 | `--agent claude --smoke` (16) | 13 | 3 |
| codify | `--agent claude --skills highway-codify` (28) | 18 | 10 |

Dominant failure: Claude explores with `Bash` (`ls`/`cat`/`find`/`grep` pipelines) even though
Read/Write/Edit are available. `canUseTool` denies every Bash request; the storage invariant then
fails the attempt as `rejected-request` (F33). Secondary: assertion template misses on profile /
setup / some codify scenarios; intermittent experience-order and unmatched-question on codify.

## Claude Bash guidance for spec 255

Three confirmation runs after throwaway-home Local-mode / no-Bash guidance
(`prepareClaudeAgentHome` → `<home>/.claude/CLAUDE.md`, drive `settingSources: ["user"]`,
optional `CLAUDE_BASH_DENY_MESSAGE`). Before the runs: suite 87/87, harness tests 194/194.
Model `claude-haiku-5-5`; judge `cursor/gpt-5.6-luna`. Logs under
`specs/255-claude-bash-failures/harness/`. Smoke 12/16 and 11/16; Bash denials 8 / 10 (not
fewer than Phase 8). Codify 18/28. F33 stayed open; next lever was session-start delivery.

## Claude session-start guidance for spec 256

Three confirmation runs after drive `systemPrompt: { type: "preset", preset: "claude_code",
append: CLAUDE_LOCAL_GUIDANCE }` with `settingSources: []` (supporting home file still written).
Before the runs: suite 87/87, harness tests 194/194. Model `claude-haiku-5-5`; judge
`cursor/gpt-5.6-luna`. Logs:

| Log | Bytes |
| --- | --- |
| `specs/256-claude-bash-prompt/harness/smoke-1.log` | ~85 KB |
| `specs/256-claude-bash-prompt/harness/smoke-2.log` | ~90 KB |
| `specs/256-claude-bash-prompt/harness/codify.log` | ~217 KB |

Every attempt printed `installed plugin highway (16 skills)`. No API key material in the logs.
Smoke bar ≥14/16 met on both runs. Codify has no numeric floor.

| Run | Selection | Passed | Failed | `denied: shell` |
| --- | --- | --- | --- | --- |
| smoke-1 | `--agent claude --smoke` (16) | 16 | 0 | 0 |
| smoke-2 | `--agent claude --smoke` (16) | 16 | 0 | 0 |
| codify | `--agent claude --skills highway-codify` (28) | 27 | 1 | 0 |

Bash-driven fails dropped vs Phase 8 (F33 closed). Remaining codify fail: assertion template on
`codify-code-project` (skill-behavior noise; not Bash).

## F33: Claude explores with Bash despite file tools — closed

**Skill**: was intermittent on smoke and highway-codify under Phase 8 / Spec 255

**Runs**:

- Spec 254 smoke-1 / smoke-2 / codify — baseline 13/16, 13/16, 18/28; `denied: shell` 5 / 5
- Spec 255 after throwaway-home CLAUDE.md + `settingSources: ["user"]` — 12/16, 11/16, 18/28;
  `denied: shell` 8 / 10 (did not close)
- Spec 256 after session-start `systemPrompt` append + `settingSources: []` — smoke **16/16** and
  **16/16** (0 Bash denials); codify **27/28** (0 Bash denials; remaining fail is assertion
  template on `codify-code-project`, skill-behavior noise). Logs under
  `specs/256-claude-bash-prompt/harness/`.

**Category**: Model

**Confirmed**: Yes (closed)

**Basis**: Phase 8 Haiku explored with Bash; deny-all-Bash correctly refused and failed attempts
as `rejected-request`. Spec 255 home-file guidance did not reduce Bash fails. Spec 256 appends
the same Local-mode / no-Bash text via `systemPrompt` preset `claude_code` append so it reaches
session start; confirming smokes met ≥14/16 with **fewer** Bash-driven fails than Phase 8
(zero vs five denials per smoke). Deny-all-Bash remains; refuse stays fatal if Bash is requested.

**Resolution**: Closed by Spec 256 session-start guidance. Do not reopen for assertion /
unmatched-question codify noise unless a new Bash-driven pattern appears.

## Public-install smoke for spec 257

Four `--plugin-source public --plugin-ref v0.1.0` smoke runs after publishing
`highway-systems/agent-plugin` at tag `v0.1.0`. Every attempt printed
`installed plugin highway (16 skills)` (no `plugin-install` / `build-failed`). Logs under
`specs/257-publish-public-install/harness/public-smoke-*.log`.

| Agent | Exit | Passed | Failed | Install |
| --- | --- | --- | --- | --- |
| copilot | 1 | 15 | 1 (onboarding assertion template; setup flaky) | 16 skills each attempt |
| cursor | 1 | 14 | 2 (codify / onboarding assertion template) | 16 skills each attempt |
| claude | 0 | 16 | 0 | 16 skills each attempt |
| codex | 1 | 14 | 2 (architecture unclassified session; codify assertion) | 16 skills each attempt |

Skill-behavior fails match existing residual patterns (assertion template / F18-family,
unclassified session / F32-adjacent). They do not block Phase 10 (FR-014). No new finding
opened for public-source install itself.

