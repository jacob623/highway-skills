# Research: Harness Failure Resolutions

Each decision names what was chosen, why, and what else was considered. The evidence is spec
242's captured runs: the baseline smoke `20261112-162017Z-smoke-49ab958`, the post-change smoke
`20261112-170628Z-smoke-49ab958`, the Option B run `20261112-171321Z-targeted-49ab958`, and the
S1 reruns `20261112-181837Z-targeted-49ab958` and `20261112-182131Z-targeted-49ab958`.

## R1: A title in the opening selects the record (F1)

**Decision**: Extend `Entry` step 1 of highway-adr, highway-architecture, and highway-discovery,
and step 3 of highway-implementation. When the invocation has no id and contains the exact title
of one record in the state that skill's list shows, that record's id counts as present. Compare
without regard to case. The state is the one each skill's list step already defines:

| Skill | State | Defined in |
| --- | --- | --- |
| highway-adr | a waiting Discovery | `choose-discovery` |
| highway-architecture | a waiting ADR | `choose` |
| highway-discovery | a Discovery ready to explore, then a Request ready to analyze | `choose` |
| highway-implementation | an accepted architecture | `choose` |

highway-discovery tests Discovery titles first, because a Discovery title, `Options for [request
title]`, contains its Request's title.

**Rationale**: The id then flows through the existing cases unchanged, so no case is renumbered
and no `follow Entry from case N` reference moves. "Compare without regard to case" follows
highway-codify `Entry` step 6.

**Alternatives considered**: A new numbered step. This renumbers every later case and the
cross-references to them. Rejected.

## R2: Pasted text is supplied material (F2)

**Decision**: Rewrite highway-profile `offer` as a list from what the person supplied to a branch:
nothing; text, with or without a link; a link or document alone; a link alone when retrieval is
unavailable. For text, a link that cannot be read is named once and the skill continues with the
text. Update the matching Verification bullet.

**Rationale**: Luna took the literal "Retrieval is unavailable" branch for pasted text with an
unreachable link. A list keyed by what was supplied gives one branch per state (F5's principle).
The no-retrieval case keeps its rule of not mentioning the missing capability.

**Alternatives considered**: Only adding a pasted-text bullet. This leaves "Retrieval is
unavailable" matching the same input. Rejected.

## R3: The storage contract decides absence by exact path (F6, F10, F12)

**Decision**: Storage contract `1.1.0` becomes `1.2.0`, and highway-experience `SKILL.md`
`metadata.version` goes from `1.1.0` to `1.2.0`. After the operations table, add:

- "Read a file" and "Check a file exists" act on the exact path. A search or pattern tool does
  not decide whether a file exists. A file is absent only when one of those two operations
  reports it absent at its path.
- A folder is created by writing a file in it.

"What a skill does not do" gains "Run a shell command." and "Decide that a file is absent from a
search or pattern result."

**Rationale**: In nfrs-smoke baseline attempt 2, `glob` reported `library/governance/nfrs.md`
missing, and Luna took the `recommend` branch. In the Option B run it said an indexed NFR record
was unreadable. Every F6 and F10 instance traces to `glob`. P2.6 exempts bundled files, so the
contract may name these acts.

**Alternatives considered**: Naming a tool, such as "do not use glob". The contract is agent
neutral. Rejected.

## R4: Governance records are read at their paths (F10)

**Decision**: `Entry` step 1 of each governance skill names the record path and the operation:

- highway-objectives: "Read `library/governance/objectives.md`. Then read each record it indexes
  at `library/objectives/[ID].md`, with "Read a file"."
- highway-controls and highway-nfrs: the same, for each active record, at
  `library/governance/controls/[ID].md` and `library/governance/nfrs/[ID].md`.

The objectives records stay in `library/objectives/`, per clarification 1.

**Rationale**: The path comes from the catalog and the record template, so nothing is searched.

## R5: Onboarding `unknown` leads forward (F4)

**Decision**: In highway-onboarding `references/proposal.md` `map`:

- The names line becomes "Cursor, VS Code, GitHub Copilot, Claude, and Codex".
- `unknown` on an `Unknown` provider asks **Who builds or runs [Capability title] today?** and
  offers to mark the provider `Does not exist`. A named provider replaces `Unknown`. "No one", or
  a second `unknown`, sets `Does not exist`. Both re-emit the block with the new provider.

**Rationale**: The unable-to-infer line promises "we'll work through it together", and the old
`unknown` re-emitted the same block forever. Two answers now always leave `Unknown`.

**Alternatives considered**: Changing `accept` on `Unknown`. A person who accepts an unknown
provider has not named one, so `accept` still re-emits the block. Kept.

## R6: Codify `check` and `record check` (F4, F14)

**Decision**: In `references/record.md` `check` step 5: "When none qualify, go to `menu`. Do not
show the plan until the person selects 1. Do not say the check ran." In `SKILL.md` `record
check` rule 2: append "Language `None` names no standard and is complete." Amend
`tests/code-project.test.sh` to pin the full new line.

## R7: F5 diagnosis

Each failing scenario's fixture state was compared with the text that selects its first branch.

| Scenario | Category | Diagnosis | Resolution |
| --- | --- | --- | --- |
| discovery-smoke | Scenario, after F1 | The script expects "Would you like to analyze the Request, or explore the Discovery?", which `choose` asks only when both ids are supplied, and a "What would you add, correct, or remove?" review that `start` does not have. | Script: the title opening goes to `analyze`; decline at `start`'s option question. |
| chain-discovery | Scenario | The same two expectations. Luna listed the Request, analyzed it, wrote it, and reached `start`. | Script: select 1, then decline at `start`. |
| chain-architecture | Scenario | The fixture's ADR title is its Selected Option, so `identifier` has no purpose and asks **What should this architecture be called?**. The script has no reply. | Script: answer the purpose question. |
| chain-setup | Skill | After `select`, objectives `queue` asks the empty-queue question **Which of these outcomes would you like to pursue…?**. `recommend` asks **Would you like to select any of these outcomes, modify them, or are you ready to review…?** when the queue has titles. One state, two questions. The same text is in controls and nfrs. The script also had one Profile review where Profile asks four. | Skill: `queue` asks the queue-has-titles question in objectives, controls, and nfrs. Script: four Profile accepts. |
| nfrs-smoke | Service (F10) | `glob` reported `library/governance/nfrs.md` missing, so `review` was skipped. | R3. |
| codify-configure | Model | Copilot invoked highway-codify-config directly for "/highway-codify configure". highway-codify was never loaded, so no highway-codify wording can select `Entry` step 1. | Recorded under F5 and FR-027. Scenario unchanged. |

**Rationale for including highway-controls**: chain-setup reaches the same `queue` text through
highway-controls, and FR-009 requires one branch per state.

## R8: Implementation procedure text and the field check (F9)

**Decision**:

- Introduce each reply list in highway-implementation with the line `Classify the reply:`. There
  are six: `choose`, and `start`, `title`, `platforms`, `delivery platforms`, and
  `delivery decline` in its flow files. The `### Classify` definitions already open with an
  instruction line, and keep it.
- `field` steps 2 and 3 quote the sentence to emit and put the handoff in its own sentence:
  `emit "Let's onboard [Platform]." Then follow highway-onboarding …`. The Option B run showed
  Luna printing "Follow `highway-onboarding` for Jenkins, with the return step…" and not
  onboarding.
- `start` `accept` on a Needed field, or on an uncovered responsibility, names it and re-emits the
  block. Luna named the field with no question, so the conversation ended.
- implementation-smoke moves to the `implementation` stage fixture, which has a GitHub Actions
  platform row, so `execution` fills Deployed by and Managed by. The `architecture` fixture has
  no row, so writing there needs onboarding, which implementation-onboards-platform and
  chain-implementation cover.

## R9: Harness changes (F8, F11, F13)

**Decision**:

- F8: `failure.ts` gains the kind `service-error`, a likely cause naming the Copilot service, a
  `classifyError` pattern `/-32603|no response was returned/`, and `retryServiceError(call,
  onRetry)`. The driver wraps `sendAndWait` in it, which resends the same prompt once. The runner
  reports a scenario `blocked` when its last attempt's failures are all `service-error`.
- F11: `checks.ts` gains `isExperienceSkillRead(path)`. The driver's permission handler adds
  `highway-experience` to the skills before output when it approves a read of
  `…/highway-experience/SKILL.md` before any output.
- F13: `showsFailures` removes Markdown emphasis (`*`, `**`, `_`, `__` used as emphasis) from
  both sides before comparing. Per D3.5, the harness README's `shows` row records that emphasis
  is no longer compared.

**Rationale**: The SDK error reads "No response was returned. Send your message again to retry.
(code -32603)", so a resend is the documented recovery. The runner already reports `blocked`, and
JUnit counts it with failures, so a service block is visible but not a skill failure.

## R10: Script keys

Replies are matched by the first unused key, in file order, whose text appears anywhere in the
message (`replies.ts`). Scripts therefore put specific keys, such as `If you'd like to cancel`,
before the generic **What would you add, correct, or remove?**. They carry enough generic
accepts for the variable number of onboarding `map` blocks (Luna proposed one to three GitHub
Actions capabilities), because an unused reply never fails a run. Rewritten scripts drop the
trailing `[unknown]` catch-all, which F3 shows only feeds loops.

## R11: Tests

- One new bash test, `tests/harness-failure-resolutions.test.sh`, pins every skill-text change
  from R1 to R8. It reads flow files through `fl_skill_text_file`. Seeded failure probe:
  restoring any pinned line fails it.
- `tests/code-project.test.sh` is amended for R6.
- Harness unit tests: `failure.test.ts` (kind, cause, classify, retry), `checks.test.ts`
  (emphasis, experience read), and `runner.test.ts` (a service-error attempt is blocked).
- No bash test pins any text being changed, except `code-project.test.sh` rule 2, as a
  substring, so it stays green, and `establish-from-record.test.sh`'s `return step \`execution\``,
  which is kept.
- Each new assertion is run and observed failing before its change (D3.6).
- The suite grows from 85 to 86 tests.
