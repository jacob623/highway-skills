# Research: Harness Failure Follow-ups

Each decision cites the transcripts in `specs/243-harness-failure-resolutions/harness/`.

## R1: A governance `close` step (F7)

**Decision**: highway-objectives, highway-controls, and highway-nfrs each get a `### close` step in
`SKILL.md`, after `review`. Every place that returns `Finished` goes to `close` instead: `review`
`accept`, `ask` `decline` in `references/proposal.md`, and a successful `write` in
`references/record.md`. `close` reads:

- When `highway-setup` delegated this skill, return `Finished` and emit nothing else.
- Otherwise emit one line. With at least one active record, it is "Your NFRs are recorded."
  (Objectives, Controls). With none, it is "No NFRs are recorded yet. Run highway-nfrs when you
  have one to add."

**Rationale**: All nine -32603 errors in spec 243's final runs came on a turn the skill leaves
empty. One step keeps the rule in one place per skill, so the three exits cannot drift apart. The
setup path is unchanged, so highway-setup's next question still follows directly.

**Alternatives considered**:
- Edit each exit line separately. Rejected: three copies of one rule per skill.
- Change only the harness so an empty final turn passes. Rejected: an empty reply also reads as a
  crash to the person. F7 keeps that as its fallback proposal if -32603 persists.

## R2: highway-codify-config's menu `decline` (F7)

**Decision**: "- `decline`: when a return step is held, go to that step in its skill. Otherwise emit
`Your platforms and coding standards are up to date.` Write nothing. Stop." Version 3.12.0.

**Rationale**: codify-config-smoke attempt 1 of the final smoke run got -32603 on exactly this
turn. The return-step clause that `configure-handoff.test.sh` pins is kept word for word.

## R3: highway-codify refusal and bare invocation (F15, F5)

**Decision**:
- The refusal line in `references/proposal.md` `revise` ends with "Then re-emit the proposal and
  stay on `revise`."
- `Entry` step 2 ends with "An invocation that names nothing is not a catalog request."
- Version 14.9.0.

**Rationale**:
- codify-controls-conflict: Luna stopped after the refusal sentence. The re-emit instruction is
  on the `edit` line, above the refusal.
- chain-codify attempt 1: a bare `/highway-codify` entered `catalog`.

The appended sentences keep the substrings that `codify-feature-wording.test.sh` and
`codify-closing-guide.test.sh` pin.

## R4: Keep every template heading and header row (F18)

**Decision**: one bullet in each write step. In highway-discovery `references/options.md` `write`
and highway-adr `references/record.md` `write`:

- "Keep every heading and table header row of `assets/[template]`, in order, even when a section
  has no content. Write `None` under a section with no content, after its table header row when it
  has one."

highway-adr's `onboarding` bullet "The record uses every section a Discovery-backed ADR uses."
becomes "The record keeps every heading of a Discovery-backed ADR, as `write` says, including
`## Decision Confidence`." Versions: discovery 5.8.0, adr 6.8.0.

**Rationale**: The template check needs every heading and header row. Luna dropped:
- the Candidate Elimination Log table, where the placeholder reads "<empty when no candidates are
  excluded>";
- the Example tables, under "…or `None`";
- the Comparison Matrix in chain-discovery;
- `## Decision Confidence` in the onboarding ADR.

Templates are fixed, so the rule goes in the skill text.

## R5: Catch-all replacement (F3)

**Decision**: per scenario, from what spec 243's passing transcripts show after the last keyed
reply:

| Scenario | Seen after the last keyed reply | Change |
| --- | --- | --- |
| adr-smoke | the write and next step, no question | remove the catch-all |
| architecture-smoke | the write and next step, no question | remove the catch-all |
| assessment-smoke | **Where would you like to go next?** | `ask: Where would you like to go next?` with `[decline] Stop here.` |
| chain-request, request-smoke | the next step, no question | remove every catch-all |
| codify-control-unmet, codify-standard-unmet | "Please choose a different action." with no question mark | `ask-pattern: different action\|explore any of these options` with `[decline] Never mind.` |
| controls-smoke, nfrs-smoke, objectives-smoke | an empty turn (F7) | remove the catch-all. The closing line ends the run. |

codify-choose is not changed. Its `[unknown]` is keyed to its own question and tests the re-ask.
adr-smoke does not key the Discovery list, so an F1 recurrence fails visibly, as F1's research
entry asks.

## R6: `contains-any` (F16)

**Decision**: a new assertion, `contains-any <glob> :: <text>`, passes when at least one matching
file holds the text. It fails with "no file among [matches] contains it". controls-smoke,
nfrs-smoke, and objectives-smoke use it for the person's addition. They add
`shows: Your Controls are recorded.` (Objectives, NFRs) to check R1 live.

**Rationale**: The `setup` fixture already holds a record. `contains` stays "every file", so no
existing check is weakened (D3.5).

**Alternatives considered**: narrow the glob to the new record. Rejected: the model picks the title,
so the id is unknown in advance.

## R7: Onboarding `Unknown` provider replies (F21) and codify-configure (F5)

**Decision**:
- onboarding-smoke, chain-implementation, and implementation-onboards-platform add two pairs of
  replies right after the capabilities edit, because two capabilities were seen with an `Unknown`
  provider (Online Commerce, Reorder Point Check):
  - `ask-pattern: unable to infer a platform` with `[unknown] I don't know.`
  - `ask-pattern: Who builds or runs` with `No one.`
- codify-configure opens with `Use highway-codify with the word configure.`, and adds
  `shows: To configure platforms and coding standards, run highway-codify-config.`

**Rationale**: Keyed replies are matched in file order among unused replies, and a key must appear
in the message. So an unused pair costs nothing when no provider is `Unknown`. "No one." is the
skill's own path to `Does not exist`, and no invented provider is scripted. The `shows` line proves
highway-codify answered, not highway-codify-config.

## R8: The fallback offers only the earliest unused reply (F3, clarified)

**Decision**: `replies.ts` adds `nextUnused(replies, used)`, which returns the lowest unused index,
or nothing. `decide`'s fallback candidates, and the driver's in-turn fallback, use it. The fallback
judge still decides whether that reply answers the question. If not, the attempt is
`unmatched-question`.

**Rationale**: adr-smoke in spec 242 spent the option reply on the Discovery list. Offering only the
next reply keeps tolerance for a reworded question without letting a later reply be spent early.

## R9: `repeated-question` (F3)

**Decision**:
- The driver records each answered question, normalized, with the reply it was given.
- When no reply is found for a question that was already answered, the outcome is
  `repeated-question`.
- The runner reports it as kind `repeated-question`, check `reply`, actual `"[question]" asked
  again after the reply "[say]"`.
- A pure helper in `replies.ts`, `spentReply(question, answered)`, does the lookup.

**Rationale**: adr-smoke attempt 1 in spec 243 asked "Which Discovery would you like to decide?"
again after "Yes, go ahead." It was reported as a plain `unmatched-question`, which hides that the
reply was spent and the skill re-asked.

## R10: Judge only the text after the last in-turn answer (F17)

**Decision**:
- The driver keeps `answeredAt`, the count of the turn's agent messages when it last answered an
  input-tool question. It is reset at each turn and on a service retry.
- At the end of the turn it judges `textAfterAnswers(turnMessages, answeredAt)`, a pure helper in
  `replies.ts`.
- The transcript and `lastMessage` still hold the whole turn.

**Rationale**: setup-smoke attempt 1 of the final smoke run answered every question in the turn
through the input tool. The driver then re-matched the objectives question in the whole turn's
text.

## R11: Final runs (FR-017)

**Decision**: one live run:

```bash
node harness/src/cli.ts --model gpt-5.6-luna --changed-since 42a0569 \
  --paths <every spec 243 failed scenario file the changed selection leaves out> \
  --transcripts specs/244-harness-failure-followups/harness/final
```

The selection is the union of both switches. The 18 scenarios are listed in the spec's
Assumptions, and `contracts/final-run-evidence.md` lists their files. `--changed-since` diffs the
working tree against `42a0569`, so the uncommitted work is selected.

**Rationale**: One run gives one run id and one comparison. Each `.scenario` path maps to its own
scenario in `path-map.sh`.
