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

### F3: A catch-all reply loops on a re-ask

**Evidence**:
- Many scenarios end with `ask-pattern: \?` and a catch-all such as `[unknown] I don't know.` or
  `[accept] Yes, go ahead.`
- When Luna asks a question the script does not name, the catch-all answers it.
- The skills classify that reply as `unknown`, or as not an answer, and re-emit the same question.
- The harness has no other reply left and fails with `unmatched-question`.
- Seen in adr, architecture, codify-config, discovery, onboarding, and profile.

In adr-smoke, the harness also answered the Discovery list with `1`, the reply scripted for the
*option* question. That reply was then used up, and the real option question had no answer
(turn 3).

**Skill text**: most choice and review steps re-emit on `unknown`, for example "`unknown`:
re-emit this list. Stay on `choose-discovery`."

**Owner**: scenario and harness. Questions to settle:
- Should a catch-all ever be `[unknown]` when the skill's answer is to re-ask?
- Should the harness model fallback be allowed to spend a reply keyed to a different question?

### F5: The model starts on a different branch than the script

**Evidence**:
- discovery-smoke attempt 2 skips "Would you like to analyze the Request, or explore the
  Discovery?" and proposes options at once.
- nfrs-smoke attempt 2 opens with recommendations and a queue ("Which would you like to focus
  on?") instead of the review the script expects.

**Owner**: skill or scenario. Find the `Classify` branch the fixture state should select, and
whether the skill text makes it deterministic for that state.

**Diagnosis (spec 243)**: each failing scenario's fixture state was compared with the text that
selects its first branch.

| Scenario | Category | Diagnosis | Resolution |
| --- | --- | --- | --- |
| discovery-smoke | Scenario, after F1 | The script expects the analyze-or-explore question, which `choose` asks only when both ids are supplied, and a review that `start` does not have. | Script: decline at `start`'s option question. |
| chain-discovery | Scenario | The same two expectations. Luna listed the Request, analyzed it, wrote it, and reached `start`. | Script: select 1, then decline at `start`. |
| chain-architecture | Scenario | The fixture's ADR title is its Selected Option, so `identifier` asks **What should this architecture be called?**. The script has no reply. | Script: answer the purpose question. |
| chain-setup | Skill | Governance `queue` asked the empty-queue question while `recommend` asked the queue-has-titles question for the same state. The script also had one Profile review where Profile asks four. | Skill: `queue` asks the queue-has-titles question in objectives, controls, and nfrs. Script: four Profile accepts. |
| nfrs-smoke | Service (F10) | `glob` reported `library/governance/nfrs.md` missing, so `review` was skipped. | Exact paths are read, not searched (F10). |
| codify-configure | Model | Copilot invoked highway-codify-config directly for "/highway-codify configure". highway-codify was never loaded. | Recorded. Scenario unchanged. |

### F7: An empty reply after accepting

**Evidence**: controls-smoke attempt 1 and nfrs-smoke attempt 1 reply "Looks good." to the final
review, and the agent's turn-3 reply is empty. No record holding the person's addition is written,
so `expect: contains … two-factor` and `… two seconds` fail.

**Owner**: skill and harness. Spec 243's final runs show the empty reply is what `review`
`accept` asks for, and that Copilot answers it with -32603. See F7 under Harness Failures.

### F15: A refused edit does not re-show the proposal

**Evidence**: codify-controls-conflict, both attempts of rerun `20261112-182131Z-targeted-49ab958`.
After "Send it by email instead.", Luna says the Control stays in effect and stops. It does not
re-show the proposal, so the script's second "What would you add, correct, or remove?" never
comes and nothing is written. The run before it, and Option B, pass.

**Skill text**: `revise` in codify's `references/proposal.md`. The `edit` class says to re-emit the
proposal. The refusal, "An edit that would break a listed Control or NFR is not applied. Say: …",
sits below it as a separate line and does not say to re-emit.

**Owner**: skill (highway-codify). Say that a refused edit still re-emits the proposal.

## Questions for research

1. Does the previous model (`claude-sonnet-4.5`) pass these scenarios at the same commit? If so,
   which failures does Luna alone show?
2. Should scenarios be model-portable, with no reliance on a model inferring past the text? Should
   catch-all replies be restricted (F3)?
3. Does Copilot return -32603 for every turn whose correct reply is empty (F7)?

## Possible spec scope

- **Skill clarity**: a closing line where a skill now emits nothing (F7); keep every template
  heading and table header row (F18); the onboarding `orchestrate` announcement (F19); a refused
  edit re-shows the proposal (F15); a bare `/highway-codify` reaches `choose` (F5).
- **Scenario portability**: remove the remaining catch-alls (F3); `contains` on a pattern with a
  fixture record (F16); replies for an `Unknown` provider (F21).
- **Harness**: judge only the text after the last in-turn answer (F17); stop reporting an empty
  final turn as a service block (F7).
- **Model behavior to watch**: the occasional missed title (F1); Copilot routing for
  codify-configure (F5); absolute paths that lose the temporary folder (F20); a proposal shown
  without its question (F22).
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

# Harness Failures

Resolved findings are removed: S1 in spec 242, and F2, F4, F6, F9, F10, F11, F12, F13, and F14 in
spec 243. F8 is reopened and merged into F7: its -32603 errors come from turns the skill leaves
empty. The run tables above keep their ids as a record. Each resolution is in spec 243's `research.md`;
the confirming run ids are in the final runs section above.

## F3: A catch-all reply loops on a re-ask

**Skill**: highway-adr, highway-architecture, highway-codify, highway-codify-config, highway-discovery, highway-implementation, highway-onboarding, highway-profile

**Runs**:

- Baseline smoke `20261112-162017Z-smoke-49ab958`: adr-smoke, architecture-smoke, codify-config-smoke, discovery-smoke, onboarding-smoke, profile-smoke
- Post-change smoke `20261112-170628Z-smoke-49ab958`: adr-smoke, codify-config-smoke, discovery-smoke, implementation-smoke, onboarding-smoke, profile-smoke, setup-smoke
- Affected run, Option B `20261112-171321Z-targeted-49ab958`: chain-architecture, chain-discovery, chain-implementation, codify-config-smoke, codify-named-platform, codify-standards, discovery-smoke, implementation-smoke, onboarding-smoke, profile-smoke
- S1 rerun 1 `20261112-181837Z-targeted-49ab958`: chain-discovery, discovery-smoke
- S1 rerun 2 `20261112-182131Z-targeted-49ab958`: chain-discovery, discovery-smoke
- Final changed `20261113-052407Z-targeted-fe522b4`: adr-smoke attempt 1

**Category**: Scenario

**Confirmed**: Yes

**Basis**: The catch-all reply is one the skill answers by asking again. Spec 243 removed the
catch-all from the 13 scenarios it rewrote. In the final runs it looped once: adr-smoke's
`ask-pattern: \?` answered "Which Discovery would you like to decide?" with "Yes, go ahead.", and
the list came back.

**Proposed resolution**: Remove the catch-all from the 11 scenarios that still hold one:
adr-smoke, architecture-smoke, assessment-smoke, chain-request, codify-choose,
codify-control-unmet, codify-standard-unmet, controls-smoke, nfrs-smoke, objectives-smoke, and
request-smoke. Key each reply to the question the script expects. In the harness, never spend a
reply keyed to another question on the fallback, and report a question repeated after a
catch-all as its own failure kind that names the question.

## F5: The model starts on a different branch than the script

**Skill**: highway-codify

**Runs**:

- Baseline smoke `20261112-162017Z-smoke-49ab958`: discovery-smoke, nfrs-smoke
- Post-change smoke `20261112-170628Z-smoke-49ab958`: discovery-smoke
- Affected run, Option B `20261112-171321Z-targeted-49ab958`: chain-architecture, chain-discovery, chain-setup, codify-configure, discovery-smoke
- S1 rerun 1 `20261112-181837Z-targeted-49ab958`: chain-discovery, codify-configure, discovery-smoke
- S1 rerun 2 `20261112-182131Z-targeted-49ab958`: chain-discovery, discovery-smoke
- Final changed `20261113-052407Z-targeted-fe522b4`: codify-configure (both attempts), chain-codify attempt 1

**Category**: Model

**Confirmed**: Yes

**Basis**: Spec 243 diagnosed each case (the table under F5 in Findings) and fixed the skill and
script cases; chain-setup and chain-architecture now pass. Two cases remain:
- codify-configure: Copilot invokes highway-codify-config directly for "/highway-codify configure",
  so highway-codify's `Entry` step 1 never runs. Skill text cannot change that.
- chain-codify attempt 1: a bare `/highway-codify` should reach `choose` (`Entry` step 9). Luna
  entered `catalog` instead, which `Entry` step 2 reserves for the word `catalog` or a request to
  show the code catalog, and `catalog` correctly asked nothing.

**Proposed resolution**: For codify-configure, retire the scenario or open it with prose that names
highway-codify, so Copilot loads it. For a bare invocation, say in `Entry` step 2 that an
invocation naming nothing is not a catalog request.

## F7: An empty reply after accepting, reported as a service error (reopens F8)

**Skill**: highway-controls, highway-nfrs, highway-objectives, highway-codify-config

**Runs**:

- Baseline smoke `20261112-162017Z-smoke-49ab958`: controls-smoke, nfrs-smoke, objectives-smoke
- Post-change smoke `20261112-170628Z-smoke-49ab958`: controls-smoke, nfrs-smoke, objectives-smoke
- Affected run, Option B `20261112-171321Z-targeted-49ab958`: controls-smoke, nfrs-smoke, objectives-smoke
- Final smoke `20261113-051531Z-smoke-fe522b4`: codify-config-smoke attempt 1, controls-smoke, nfrs-smoke, objectives-smoke
- Final changed `20261113-052407Z-targeted-fe522b4`: controls-smoke, nfrs-smoke, objectives-smoke

**Category**: Skill

**Confirmed**: Yes

**Basis**: F8 is merged here. Each governance skill's `review` says, for `accept`: "return
`Finished`. Emit nothing else." So the empty turn after "Looks good." is what the skill asks for.
The record holding the person's addition is written on the edit, in turn 2, as `review` says; the
`contains` failure that follows is F16. All nine -32603 errors ("No response was returned") in the
final runs came on a turn the skill leaves empty: eight governance `accept`s, and one
highway-codify-config `decline` ("stop. Write nothing."). The harness resend never produced a reply,
because the correct reply is still empty. So -32603 here is Copilot's answer to an empty reply,
not an outage, and spec 243's `blocked` report hides that.

**Proposed resolution**: Fix in the skill. When no caller holds a return step, `review` `accept`
and highway-codify-config's `decline` emit one closing line, such as "Your NFRs are recorded.", so
the turn is never empty. Keep "Emit nothing else" for the return to highway-setup. Then confirm
that -32603 stops. If it does not, revisit the harness retry and the `blocked` report.

## F15: A refused edit does not re-show the proposal

**Skill**: highway-codify

**Runs**:

- S1 rerun 2 `20261112-182131Z-targeted-49ab958`: codify-controls-conflict

**Category**: Model

**Confirmed**: Yes

**Basis**: `edit` says to re-show the proposal, and Luna stops after the refusal. The refusal line could repeat it.

**Proposed resolution**: Fix in the skill, in highway-codify `references/proposal.md`. End the refusal line with "Then re-emit the proposal and stay on `revise`", so the instruction sits where Luna stops reading.

## F16: `contains` on a pattern checks the fixture's own record

**Skill**: highway-controls, highway-nfrs, highway-objectives

**Runs**:

- Final smoke `20261113-051531Z-smoke-fe522b4`: nfrs-smoke, objectives-smoke
- Final changed `20261113-052407Z-targeted-fe522b4`: controls-smoke, nfrs-smoke

**Category**: Scenario

**Confirmed**: Yes

**Basis**: `contains` requires every file matching its pattern to hold the text. The `setup` fixture already holds one record, such as `NFRe124ce38.md`. The skill writes the added item as a new record, as it should, so the fixture's record never holds the new text. The new record's title is chosen by the model, so no fixed text identifies it in the catalog.

**Proposed resolution**: Fix in the harness. Add an assertion that passes when any file matching the pattern holds the text, and use it in the three scenarios. Keep `contains` meaning every file, so no existing check is weakened.

## F17: A question answered inside the turn is matched again at the end

**Skill**: highway-setup, through highway-objectives

**Runs**:

- Final smoke `20261113-051531Z-smoke-fe522b4`: setup-smoke attempt 1

**Category**: Harness

**Confirmed**: Yes

**Basis**: Luna asked every question of the turn through the input tool, and the harness answered each one. The turn ended with "Understood.", but the driver judges the whole turn's text, and it found the objectives question it had already answered, with its reply used.

**Proposed resolution**: Fix in the harness. At the end of a turn, judge only the text after the last question answered inside that turn.

## F18: A required section or table is dropped from the record

**Skill**: highway-discovery, highway-adr (through highway-onboarding)

**Runs**:

- Final smoke `20261113-051531Z-smoke-fe522b4`: discovery-smoke
- Final changed `20261113-052407Z-targeted-fe522b4`: chain-discovery, discovery-smoke, onboarding-smoke

**Category**: Model

**Confirmed**: Yes

**Basis**: The template check requires every heading and table header row. Luna drops them in two ways:
- Where there is no content. The Discovery template's placeholders read "<empty when no candidates are excluded>" and "…or `None`". Luna writes "No candidates were eliminated." or `None` and drops the table. The onboarding ADR, where Discovery Confidence is `None`, drops `## Decision Confidence`, although highway-adr says the record uses every section.
- Where there is content. chain-discovery attempt 1 dropped the Candidate Solution Comparison Matrix table, which scores each option.

**Proposed resolution**: Fix in the skill. In the write step of highway-discovery and highway-adr, say to keep every template heading and table header row, and to write `None` under one that has no content.

## F21: An accept on an `Unknown` provider has no scripted reply

**Skill**: highway-onboarding

**Runs**:

- Final smoke `20261113-051531Z-smoke-fe522b4`: onboarding-smoke attempt 1
- Final changed `20261113-052407Z-targeted-fe522b4`: implementation-onboards-platform attempt 1

**Category**: Scenario

**Confirmed**: Yes

**Basis**: Onboarding sometimes proposes a capability whose provider is `Unknown`, such as Online Commerce or Reorder Point Check. `accept` re-emits that block, so generic accepts loop (onboarding-smoke). In implementation-onboards-platform, Luna asked the new provider question on an `accept`, which the skill reserves for an `unknown` reply, and the script has no reply for it.

**Proposed resolution**: Fix the scenarios. Before the generic accepts, add `ask-pattern: unable to infer a platform` with `[unknown] I don't know.`, then `ask-pattern: Who builds or runs` with "No one.", so the provider becomes `Does not exist`. Do not script a provider name the scenario has no basis for.

# Research Harness Failures

These need more evidence before a fix is chosen: an investigation, or more runs to see whether
they recur.

## F1: A name in the opening is not used to pick the record

**Skill**: highway-adr, highway-architecture, highway-discovery, highway-implementation

**Runs**:

- Baseline smoke `20261112-162017Z-smoke-49ab958`: adr-smoke, architecture-smoke, discovery-smoke
- Post-change smoke `20261112-170628Z-smoke-49ab958`: adr-smoke, discovery-smoke, implementation-smoke
- Affected run, Option B `20261112-171321Z-targeted-49ab958`: implementation-smoke
- S1 rerun 1 `20261112-181837Z-targeted-49ab958`: discovery-smoke
- Final changed `20261113-052407Z-targeted-fe522b4`: adr-smoke attempt 1

**Category**: Model

**Confirmed**: Yes

**Basis**: Spec 243 added the exact-title step to `Entry` in all four skills. In the final runs,
adr-smoke, architecture-smoke, and implementation-smoke pass, and discovery-smoke reaches `start`.
adr-smoke attempt 1 of the changed run still listed the Discoveries for the exact title
"Weekly Order Restock Alerts Options", then attempt 2 selected it.

**Proposed resolution**: No skill change. The text already says what to do; one attempt in the
final runs ignored it. Watch for it in later runs, and keep the titles in the scenarios.

## F19: Onboarding stops after its announcement

**Skill**: highway-onboarding

**Runs**:

- Final changed `20261113-052407Z-targeted-fe522b4`: chain-implementation (both attempts), implementation-onboards-platform attempt 2

**Category**: Model

**Confirmed**: Yes

**Basis**: Luna emits `orchestrate`'s "Highway will now create your decision, reference architecture and implementation records." and ends the turn before any handoff. `orchestrate` says to emit nothing else until every provider has its records. onboarding-smoke continued past the same line in both runs.

**Proposed resolution**: Investigate before changing the skill. Try placing the handoff instruction before the announcement in `orchestrate`, so the line is not the last thing the step says, and compare the two runs.

## F20: An absolute path loses its temporary folder

**Skill**: highway-setup

**Runs**:

- Final smoke `20261113-051531Z-smoke-fe522b4`: setup-smoke attempt 2
- Final changed `20261113-052407Z-targeted-fe522b4`: setup-smoke attempt 2

**Category**: Model

**Confirmed**: Yes

**Basis**: The session starts with the correct project path. The wrong path, `/var/folders/…/projects/setup-smoke-2-…/` without the `T/highway-harness-…/` segment, first appears in the model's own tool arguments. The harness rejected the reads of setup's assets and the write of `requests/requests.md` as outside the project, so `library/knowledge/storage.md` and the catalogs were not written. The storage contract already says "Every path is relative to the repository root."

**Proposed resolution**: No skill or harness change. Luna broke an existing rule, and the harness rejection is correct. Watch for it in later runs.

## F22: A proposal is shown without its question

**Skill**: highway-profile, through highway-setup

**Runs**:

- Final changed `20261113-052407Z-targeted-fe522b4`: setup-smoke attempt 1

**Category**: Model

**Confirmed**: Yes

**Basis**: Luna showed the Identity proposal and ended the turn without "What would you add, correct, or remove?". A message with no question ends the conversation, so no Profile was written. Every other Profile proposal in the final runs carried the question.

**Proposed resolution**: No change yet. Watch for it in later runs.
