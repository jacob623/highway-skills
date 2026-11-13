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

Run `20261112-171321Z-targeted-49ab958`, `--changed-since main`, on `gpt-5.6-luna`. Transcripts
are under `harness/runs/`. It selected 50 scenarios. 33 passed (7 of them flaky) and 17 failed.
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

# Harness Failures

Resolved findings are removed: S1 in spec 242; F2, F4, F6, F9, F10, F11, F12, F13, and F14 in
spec 243; and F3, F5, F7 (with F8), F15, F16, and F17 in spec 244. Spec 244 removed the catch-all
from 10 scenarios (codify-choose's is intentional, not 11 as F3 listed). The run tables above
keep their ids as a record. Each resolution is in the resolving spec's `research.md`; the
confirming run ids are in the final runs sections above.

## F18: A required section or table is dropped from the record

**Skill**: highway-discovery, highway-adr (through highway-onboarding)

**Runs**:

- Final smoke `20261113-051531Z-smoke-fe522b4`: discovery-smoke
- Final changed `20261113-052407Z-targeted-fe522b4`: chain-discovery, discovery-smoke, onboarding-smoke
- Spec 244 final `20261113-064237Z-targeted-42a0569`: discovery-smoke (both attempts)

**Category**: Skill

**Confirmed**: Yes

**Basis**: The template check requires every heading and table header row. Spec 244 added to the write step of highway-discovery and highway-adr: "Keep every heading and table header row of `assets/<template>`, in order, even when a section has no content. Write `None` under a section with no content, after its table header row when it has one." In its final run, chain-discovery and the onboarding ADR keep every section, and the Comparison Matrix is kept. One case remains: both discovery-smoke attempts wrote `## Example Realization Matrix` as `None` alone, with no `| Product | Purpose | Key Capabilities | Estimated Cost |` row. The template's own placeholder above that table reads "<optional advisory comparison of available examples, or `None`>", which Luna reads as replacing the table. Templates are fixed, so the skill text has to name it.

**Proposed resolution**: Fix in the skill, in highway-discovery `references/options.md`. After the keep-every-heading bullet, name the case: "Under `## Example Realization Matrix`, keep its header row even when there are no examples. Write `None` after it."

## F21: An accept on an `Unknown` provider has no scripted reply

**Skill**: highway-onboarding

**Runs**:

- Final smoke `20261113-051531Z-smoke-fe522b4`: onboarding-smoke attempt 1
- Final changed `20261113-052407Z-targeted-fe522b4`: implementation-onboards-platform attempt 1
- Spec 244 final `20261113-064237Z-targeted-42a0569`: onboarding-smoke attempt 2

**Category**: Scenario

**Confirmed**: Yes

**Basis**: Onboarding sometimes proposes a capability whose provider is `Unknown`. `accept` re-emits that block, so generic accepts loop. Spec 244 added two `unable to infer a platform` and `Who builds or runs` reply pairs to onboarding-smoke, chain-implementation, and implementation-onboards-platform; the two implementation scenarios now pass. But how many `Unknown` capabilities Luna proposes varies. In onboarding-smoke, attempt 1 proposed only the GitHub Actions capability. Attempt 2 proposed Online Storefront, Order Management, Warehouse Operations, and Customer Support from the Profile, three of them with an `Unknown` provider. The two pairs answered the first two, and the third, Warehouse Operations, re-emitted on "Looks good." until the harness reported `repeated-question`. No fixed number of pairs fits every run.

**Proposed resolution**: Fix the scenarios. Answer the capability list with an edit that keeps only the capability the opening names, such as "Keep only Repository Build, Deployment, and Scheduled Job Automation. Remove the rest.", so no `Unknown` provider is proposed. Then remove the reply pairs from the three scripts. Do not script a provider name the scenario has no basis for.

## F23: `shows:` does not ignore inline code formatting

**Skill**: highway-codify

**Runs**:

- Spec 244 final `20261113-064237Z-targeted-42a0569`: codify-configure (both attempts)

**Category**: Harness

**Confirmed**: Yes

**Basis**: Spec 244 opened codify-configure with prose, "Use highway-codify with the word configure.", and Copilot now loads highway-codify, which ends F5 for this scenario. Both attempts emitted `Entry` step 1's line, but with the skill name as inline code: "To configure platforms and coding standards, run `highway-codify-config`." `showsFailures` in `harness/src/checks.ts` strips `*` and `_` emphasis before comparing, but not backticks, so the check reports the line as not shown.

**Proposed resolution**: Fix in the harness. In `showsFailures`, strip backticks along with `*` and `_`, with a unit test that a backticked skill name matches its plain `shows:` text. Do not change the skill to forbid formatting.

# Research Harness Failures

These need more evidence before a fix is chosen: an investigation, or more runs to see whether
they recur.

## F1: A name in the opening is not used to pick the record

**Skill**: highway-adr, highway-architecture, highway-codify, highway-discovery, highway-implementation

**Runs**:

- Baseline smoke `20261112-162017Z-smoke-49ab958`: adr-smoke, architecture-smoke, discovery-smoke
- Post-change smoke `20261112-170628Z-smoke-49ab958`: adr-smoke, discovery-smoke, implementation-smoke
- Affected run, Option B `20261112-171321Z-targeted-49ab958`: implementation-smoke
- S1 rerun 1 `20261112-181837Z-targeted-49ab958`: discovery-smoke
- Final changed `20261113-052407Z-targeted-fe522b4`: adr-smoke attempt 1
- Spec 244 final `20261113-064237Z-targeted-42a0569`: codify-open-plan (both attempts)

**Category**: Model

**Confirmed**: Yes

**Basis**: Spec 243 added the exact-title step to `Entry` in all four skills. In the final runs,
adr-smoke, architecture-smoke, and implementation-smoke pass, and discovery-smoke reaches `start`.
adr-smoke attempt 1 of the changed run still listed the Discoveries for the exact title
"Weekly Order Restock Alerts Options", then attempt 2 selected it. Spec 244's final run did not
show it in those four skills. It showed it in highway-codify: codify-open-plan opens with
`/highway-codify Restock Alerts`, the exact title of a product in `code/code.md` whose open feature
has a plan and no task list. `Entry` step 4 says to go to `menu`. Both attempts listed the
`features` folder without opening feature 002, took the implementation path, and said "Each
action grounded in this implementation is already codified." Step 4 did not change in spec 244,
and two reruns on the same text, `20261113-070538Z-targeted-42a0569` and
`20261113-070734Z-targeted-42a0569`, passed.

**Proposed resolution**: No skill change. The text already says what to do, and the reruns follow
it. Watch for it in later runs, and keep the titles in the scenarios. If codify-open-plan fails
again, investigate whether `Entry` step 4 should say to read the open feature's folder before
step 5.

## F19: Onboarding stops after its announcement

**Skill**: highway-onboarding

**Runs**:

- Final changed `20261113-052407Z-targeted-fe522b4`: chain-implementation (both attempts), implementation-onboards-platform attempt 2

**Category**: Model

**Confirmed**: Yes

**Basis**: Luna emits `orchestrate`'s "Highway will now create your decision, reference architecture and implementation records." and ends the turn before any handoff. `orchestrate` says to emit nothing else until every provider has its records. onboarding-smoke continued past the same line in both runs.

Not seen in spec 244's final runs: chain-implementation and implementation-onboards-platform pass, and onboarding-smoke continued past the line.

**Proposed resolution**: Investigate before changing the skill. Try placing the handoff instruction before the announcement in `orchestrate`, so the line is not the last thing the step says, and compare the two runs.

## F20: An absolute path loses its temporary folder

**Skill**: highway-setup, highway-architecture, highway-codify

**Runs**:

- Final smoke `20261113-051531Z-smoke-fe522b4`: setup-smoke attempt 2
- Final changed `20261113-052407Z-targeted-fe522b4`: setup-smoke attempt 2
- Spec 244 final `20261113-064237Z-targeted-42a0569`: chain-architecture attempt 1, codify-controls-conflict attempt 1

**Category**: Model

**Confirmed**: Yes

**Basis**: The session starts with the correct project path. The wrong path, `/var/folders/…/projects/setup-smoke-2-…/` without the `T/highway-harness-…/` segment, first appears in the model's own tool arguments. The harness rejected the reads of setup's assets and the write of `requests/requests.md` as outside the project, so `library/knowledge/storage.md` and the catalogs were not written. The storage contract already says "Every path is relative to the repository root." In spec 244's final run it moved to other skills: chain-architecture wrote its record to `/var/folders/…/0000gnT/projects/chain-architecture-1-…/architectures/RA64140b32.md` (the `/T/highway-harness-…` segment collapsed), and codify-controls-conflict wrote its plan to `/var/folders/…/0000gn/code/northwind-restock-alerts/…` (the whole project prefix dropped). Both passed attempt 2.

**Proposed resolution**: No skill or harness change. Luna broke an existing rule, and the harness rejection is correct. Watch for it in later runs. It now shows once or twice per run across skills; if it keeps that rate, investigate whether the harness can give the session a shorter project path.

## F22: A proposal is shown without its question

**Skill**: highway-profile, through highway-setup

**Runs**:

- Final changed `20261113-052407Z-targeted-fe522b4`: setup-smoke attempt 1

**Category**: Model

**Confirmed**: Yes

**Basis**: Luna showed the Identity proposal and ended the turn without "What would you add, correct, or remove?". A message with no question ends the conversation, so no Profile was written. Every other Profile proposal in the final runs carried the question.

Not seen in spec 244's final runs: setup-smoke and chain-setup pass, and every Profile proposal carried its question.

**Proposed resolution**: No change yet. Watch for it in later runs.

## F24: A shell command after the session ends

**Skill**: highway-onboarding

**Runs**:

- Spec 244 final `20261113-064237Z-targeted-42a0569`: onboarding-smoke attempt 1

**Category**: Model

**Confirmed**: Yes

**Basis**: Onboarding wrote every record, and the person declined at "Where would you like to go next?" with "Nothing else for now." Luna then asked to run `test -f adrs/adrs.md && test -f architectures/architectures.md && … && echo seeded-files-present` and replied "Understood." The harness rejected the shell request, as it should. Spec 243 already added "Run a shell command." to what a skill does not do in the storage contract (F12), and no skill step asks to check files after the session ends.

**Proposed resolution**: No skill or harness change. Luna broke an existing rule after the work was done. Watch for it in later runs; if it recurs, investigate whether the storage contract's rule should sit where the closing step is.

## F25: A question the skill does not ask, put through the input tool

**Skill**: highway-codify, highway-implementation (through highway-codify)

**Runs**:

- Final changed `20261113-052407Z-targeted-fe522b4`: codify-needed-language attempt 1, codify-no-governance attempt 1
- Spec 244 final `20261113-064237Z-targeted-42a0569`: codify-needed-language attempt 1

**Category**: Model

**Confirmed**: Yes

**Basis**: Luna sometimes writes its own question and sends it through the input tool with choices, instead of the skill's question. In spec 243: "What coding standard should Language use for Northwind Restock Alerts?" (codify-needed-language) and "should the workflow send an empty restock email or skip the email?" (codify-no-governance). In spec 244, codify-needed-language asked "Is this accurate?" with "Yes, set these details (Recommended)", "I want to correct a field", and "Leave the details unset", where highway-implementation's proposal asks "What would you add, correct, or remove?". The script has no reply, so the attempt fails with `unmatched-question`. Each case passed attempt 2.

**Proposed resolution**: Investigate before changing anything. Check whether highway-experience's experience standard says a skill's question is asked in its own words and not through a choice list. If it does, this is a model rule break to watch. If it does not, decide whether it should.
