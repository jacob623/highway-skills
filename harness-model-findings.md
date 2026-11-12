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

### F2: Pasted material with an unreachable URL falls back to asking

**Evidence**:
- profile-smoke and setup-smoke answer the offer question with an overview paragraph containing
  `https://northwind.example`.
- Luna then asks "What does northwind-highway do?", which the paragraph already answered.
- In setup-smoke, the catch-all reply is `[decline] Let's stop setup here for now.`, so setup
  stops. No file is written, and every `expect: template` fails.

**Skill text**: highway-profile `offer` has branches for "A URL or document", "The person has
nothing", and "Retrieval is unavailable: go to `identity.ask`". There is no branch for an overview
pasted as text. The fictional URL cannot be retrieved, so the literal path is `identity.ask`, even
though the same step says "Use supplied material across every later domain. Do not ask the person
to repeat it."

**Owner**: skill (add an inline-text branch, or say which branch wins when a URL fails but text
was supplied). Possibly the scenario too (use text without a URL).

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

### F4: More review rounds than the script expects

**Evidence**:
- codify-config-smoke: after declining standards, Luna shows a `### Platforms` entry review with
  "What would you add, correct, or remove?" The script has no reply for it.
- onboarding-smoke: the script answers three review questions. Luna asks a fourth, on the
  per-capability map (both attempts).
- profile-smoke: Luna reviews domain by domain; the script runs out after two reviews.

**Owner**: to investigate.
- Compare the skill text with the number of reviews each step requires.
- If the skill requires these reviews, the scripts are short.
- If not, the model is adding rounds, and the skill text should make the count explicit.

### F5: The model starts on a different branch than the script

**Evidence**:
- discovery-smoke attempt 2 skips "Would you like to analyze the Request, or explore the
  Discovery?" and proposes options at once.
- nfrs-smoke attempt 2 opens with recommendations and a queue ("Which would you like to focus
  on?") instead of the review the script expects.

**Owner**: skill or scenario. Find the `Classify` branch the fixture state should select, and
whether the skill text makes it deterministic for that state.

### F6: A false "Oops... we need to setup your repository"

**Evidence**: codify-smoke attempt 1, request-smoke attempt 1, and implementation-smoke attempt 2
reply only with "Oops... we need to setup your repository. … Run highway-setup to get started."
Each starts from a seeded fixture where setup is complete. The other attempt of codify and
request passes.

**Skill text**: the readiness check in highway-experience's storage contract, and each skill's
`Entry`.

**Owner**: skill (highway-experience). Find which file or condition Luna judged missing.
`attempt-N.raw.jsonl` shows the files it read before deciding. The failure is nondeterministic,
which suggests the condition is ambiguous.

### F7: An empty reply after accepting

**Evidence**: controls-smoke attempt 1 and nfrs-smoke attempt 1 reply "Looks good." to the final
review, and the agent's turn-3 reply is empty. No record holding the person's addition is written,
so `expect: contains … two-factor` and `… two seconds` fail.

**Owner**: to investigate.
- Check `attempt-1.raw.jsonl` for tool calls after the reply.
- Find whether the write was attempted and failed, or never attempted.
- Check whether the turn ended early (`maxTurns`, timeout, or the model stopping).

### F8: Copilot service errors

**Evidence**: controls-smoke attempt 2 and objectives-smoke attempt 2 end with "session error: No
response was returned. Send your message again to retry. (code -32603)" right after the final
"Looks good."

**Owner**: service. Retry, or check whether a long final write (catalog plus records) pushes a
response past a service limit. It may share a cause with F7.

### F9: Procedure text shown to the person, and a stricter field check

**Evidence**:
- implementation-smoke attempt 1 ends its first reply with the skill's reply classes, shown to
  the person ("- `unknown`: re-emit this block. Stay on `start`. - `question`: answer, then
  re-emit this block…").
- After "Looks good.", Luna answers "Deployed by and Managed by are still **Needed**" instead of
  asking "Would you like to return and provide these details now?" as the script expects.

**Owner**: skill.
- Make the reply-class lists unmistakably instructions, not output.
- Check what `start` says to do when the person accepts a proposal that has `Needed` fields.

### F10: Objectives catalog judged to point at a missing record

**Evidence**: objectives-smoke attempt 1 replies "The Objectives could not be read because the
catalog references a missing record for **Ship Orders Within One Day**." The record exists at
`library/objectives/OBJ27e16808.md` in `harness/fixtures/stages/setup`.

**Skill text**: highway-objectives reads `library/governance/objectives.md` and writes records to
`library/objectives/[ID].md`. Controls and NFRs keep their records under `library/governance/`
(`library/governance/controls/*.md`, `library/governance/nfrs/*.md`).

**Owner**: skill or storage layout. The likely cause is the model guessing
`library/governance/objectives/` by analogy. Confirm in `attempt-1.raw.jsonl`, then decide between
aligning the layout and naming the record path in the read step.

**Post-change run**: objectives-smoke attempt 2 says "`library/objectives/OBJ27e16808.md` is
missing". nfrs-smoke attempt 1 says "active entry `NFRe124ce38` has no readable record under
`library/governance/nfrs/`". In nfrs, `attempt-1.raw.jsonl` shows the cause. Copilot's `glob` tool,
called with pattern `library/governance/nfrs/NFR*.md` and an absolute `paths`, returned "No files
matched the pattern." The record exists, and attempt 2 read it with `view`. So F10 is at least
partly a tool result the model trusts over the catalog. It is not only a guessed path.

### F11: highway-experience read as a file, not activated

**Evidence**: nfrs-smoke attempt 1 of the post-change run. The model invoked `highway-nfrs`, then
opened `.github/skills/highway-experience/SKILL.md` and its references with the `view` tool. It
never invoked the `highway-experience` skill. The harness check "highway-experience activated before
the first output" failed (kind `experience-order`). No baseline attempt shows this.

**Skill text**: the first Procedure line of every skill, "Activate the highway-experience skill
before any output the person sees, …", unchanged by spec 242.

**Owner**: to investigate. Decide whether reading the skill's files counts as activation. If it
does, the harness check should accept it. If not, the line should name the skill tool.

The affected run below shows it again in controls-smoke attempt 1 and chain-request attempt 1.

**Decision for spec 242**: accepted as model behavior, not a split regression. nfrs-smoke counts
as no worse.

### F12: Shell commands despite the storage contract

**Evidence**: affected run `20261112-171321Z-targeted-49ab958`:
- codify-integration attempt 1 runs `find . -maxdepth 4 -type f | sort | sed -n '1,160p'`.
- codify-plan-review attempt 2 finishes the whole path, then runs `ruby -e 'require "yaml"; …'` to
  check the workflow file it wrote.
- profile-smoke attempt 2 runs `mkdir -p library/knowledge`.

The harness rejects each one (`rejected-request`).

**Skill text**: highway-experience's storage contract allows four operations and no shell.

**Owner**: skill (highway-experience) or harness. Check whether the contract says plainly enough
that the agent may not run a shell to list, verify, or create folders.

### F13: An exact message loses its formatting

**Evidence**: request-setup-needed, both attempts, shows "Oops... we need to setup your
repository." without the bold markers. The check expects
`**Oops... we need to setup your repository.**`, so it fails.

**Owner**: scenario or skill. Decide whether the check compares the formatting, or whether the
skill marks the line as exact including its emphasis.

### F14: A scenario has no reply for the decline's return question

**Evidence**: rerun `20261112-182131Z-targeted-49ab958`. codify-platform-no-row (both attempts)
and codify-not-running (attempt 2) follow highway-implementation's `delivery decline`. It asks
"Would you like to return and provide these details now?", as its text says. Neither script has a
reply for it, so the run fails. In rerun `20261112-181837Z-targeted-49ab958`, platform-no-row
attempt 1 fails the same way. The attempts that pass skip the question.

**Skill text**: `delivery decline` in highway-implementation's `references/amend.md`, which this
change did not alter.

**Owner**: scenario. Add a `[decline]` reply for the return question, or decide that a decline
from highway-codify returns without asking.

### F15: A refused edit does not re-show the proposal

**Evidence**: codify-controls-conflict, both attempts of rerun `20261112-182131Z-targeted-49ab958`.
After "Send it by email instead.", Luna says the Control stays in effect and stops. It does not
re-show the proposal, so the script's second "What would you add, correct, or remove?" never
comes and nothing is written. The run before it, and Option B, pass.

**Skill text**: `revise` in codify's `references/proposal.md`. The `edit` class says to re-emit the
proposal. The refusal, "An edit that would break a listed Control or NFR is not applied. Say: …",
sits below it as a separate line and does not say to re-emit.

**Owner**: skill (highway-codify). Say that a refused edit still re-emits the proposal.

### S1: A handoff inside one turn crosses into a flow file the model does not open

This one comes from the spec 242 split, not from the model alone.

**Evidence**: codify-plan-review attempt 1. After the person accepts, the model runs `identifier`,
`write`, and `index` from `references/record.md`. `index` ends "On success, go to `plan` without
asking a question." `plan`, `check`, `menu`, and `review` are in `references/plan.md`, which the
model never opens. It writes `plan.md` from the template, skips `check` and the menu, and closes
with "The proposal and plan are saved. The automation was not run." The script's
"Would you like to:" never comes, so no task list is written. Attempt 2 opens `plan.md` and
follows the menu.

**Skill text**: the router's "Before a step in this table, read its file and follow it to the
end." A handoff that crosses files *between* turns works in every transcript. This one crosses
files *within* a turn, with no question in between.

**Owner**: spec 242. Options include keeping a turn-internal handoff inside one flow file (move
`plan`, `check`, `menu`, and `review` into `record.md`, or `index` into `plan.md`), or naming the
file at the handoff. The second breaks boundary 9 as written.

**Resolution**: steps one turn runs through now share a flow file or live in `SKILL.md`. A new
boundary 12 in `tests/skill-flow-pattern.test.sh` fails on any flow file handoff, outside a reply
line, into another flow file. An audit of all 12 split skills found five such handoffs:
- codify: `index` to `plan`. `plan`, `check`, `menu`, and `review` moved into `record.md`.
- codify: `code project` to `draft`, and `align` and `govern` to `suggest`. `suggest.md` and
  `proposal.md` hand off to each other and exceed 20,000 characters together. So `rank`,
  `codified`, `code project`, and `suggest` went back into `SKILL.md`.
- discovery: `analyze` to `identifier`, and `write` to `start`. Its three flow files merged
  into `references/options.md`.

## Questions for research

1. Does the previous model (`claude-sonnet-4.5`) pass these scenarios at the same commit? If so,
   which failures does Luna alone show?
2. For each F1, F2, F4, and F5 case, does the skill text say what Luna did? If it does, the
   scenario is wrong; if not, the skill is ambiguous.
3. Should scenarios be model-portable, with no reliance on a model inferring past the text? Should
   catch-all replies be restricted (F3)?
4. Is F6 one ambiguous readiness condition, and which one?
5. Are F7 and F8 one problem, a final turn too long for the service?

## Possible spec scope

- **Skill clarity**: title resolution in `Entry` (F1); pasted material in `offer` (F2); the
  `Classify` branch for each fixture state (F5); the readiness condition (F6); reply-class lists
  as instructions (F9); the objectives record path (F10).
- **Scenario portability**: open with ids or script the list questions (F1); match review counts
  to the skills (F4); no catch-all that a skill answers by re-asking (F3).
- **Harness**: the model fallback must not spend a reply keyed to another question (F3); a clearer
  report for an empty agent turn (F7).
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
