# Contract: Experience Standard Rule Inventory

**Feature**: 150 | **Date**: 2026-10-07

The exact text to be written into `.highway/governance/experience-standard.md`. Word counts exclude
the table pipes and the Observable column. `MUST NOT` is one keyword.

## Amended rules

### X2.7 — Observable only

| Field | Value |
|---|---|
| Rule | *unchanged* |
| Observable | `Accepted organizational or repository context grounds the recommendation; an ungrounded option is marked speculative where it appears; external sources are used only when declared.` |

Reason: without this, X2.7 and X2.54 contradict. See research §5.

### X2.37 — replaces the self-assessed trigger

| Field | Value |
|---|---|
| Rule | `An Interactive Workflow MUST provide a Contribution Opportunity before convergence when the person has made no Substantive Contribution to the active subject.` (22 words) |
| Observable | `Before the Converged Proposal the person has added, changed, corrected, removed, redirected, or qualified the subject's substance; approval and selection alone do not count.` |

Superseded: `When Highway materially shaped a Working Idea, the person MUST receive a Contribution
Opportunity before convergence unless prior interaction already provided one.` The trigger no
longer depends on Highway assessing its own interpretation (FR-029), and the prior-opportunity
exemption is gone (FR-008).

### X2.41 — restated as a factual condition

| Field | Value |
|---|---|
| Rule | `An Interactive Workflow MUST NOT present a Converged Proposal for a subject to which the person has made no Substantive Contribution.` (21 words) |
| Observable | `The candidate follows at least one response in which the person added, changed, corrected, removed, redirected, or qualified that subject's substance.` |

### X2.21 — unchanged

Retained verbatim. The capture heading and the single acceptance request stay; X2.49 governs the
form of that request.

### X2.22 — unchanged

Retained byte-identical. Its reference to X2.41 reads correctly against the new condition, and the
short path is preserved by construction. See research §3.

## New rules

| ID | Rule | Observable | Words |
|---|---|---|---|
| X2.42 | An Interactive Workflow MUST NOT present a complete candidate as a Converged Proposal while grounded non-redundant reasoning could materially improve the relevant Working Idea. | Available useful relationships, implications, distinctions, alternatives, assumptions, tensions, opportunities, concerns, challenges, recommendations, corrections, combinations, narrowings, or redirections keep development active; optional detail, repetition, unsupported speculation, manufactured disagreement, ceremony, or low-value detail alone does not. | 24 |
| X2.43 | A Contribution Opportunity MUST NOT be presented as a candidate for acceptance. | No capture heading and no acceptance request appear with it. | 12 |
| X2.44 | A Contribution Opportunity MUST end with an invitation to change its substance. | The closing line asks what to add, correct, or remove. | 13 |
| X2.45 | An exploratory move MUST name the person's own words that prompted it. | The move restates or quotes what the person said before extending it. | 12 |
| X2.46 | An exploratory move MUST target something a later decision depends on. | Its answer changes a downstream domain; a question about wording alone does not. | 12 |
| X2.47 | Grounded possibilities offered for reaction MUST be distinguished from a recommendation set. | They are presented as material to react to rather than choices to select among. | 13 |
| X2.48 | An Interactive Workflow MUST state that no grounded possibility exists rather than manufacture one. | When accepted evidence supports none, the response says so and asks instead. | 14 |
| X2.49 | An acceptance request MUST ask what is wrong rather than whether the content is right. | The question cannot be satisfied by agreement alone. | 15 |
| X2.50 | A partial acceptance MUST be resolved by asking which part is wrong. | The workflow asks rather than inferring which part the person meant. | 13 |
| X2.51 | Content the person explicitly confirmed MUST NOT be presented for review again. | No second review of the same confirmed substance appears. | 13 |
| X2.52 | Domain vocabulary or a substantive claim Highway introduces MUST be attributed where it is used. | The term or claim carries an inline statement of whose it is; ordinary paraphrase of the person's meaning does not. | 15 |
| X2.53 | An attributed term the person has not adopted MUST NOT appear in a Converged Proposal. | The candidate uses the person's own vocabulary and terms they adopted. | 15 |
| X2.54 | A recommendation not grounded in accepted evidence MUST be marked speculative where it appears. | The recommendation states that nothing accepted supports it. | 15 |
| X2.55 | An amendment to accepted content MUST preserve the accepted text unchanged. | Only the added or corrected material differs from the accepted version. | 12 |
| X2.56 | An amended candidate MUST present its change distinguishably. | The changed material is visibly marked within otherwise unchanged text. | 9 |
| X2.57 | A repeated Contribution Opportunity for the same subject MUST NOT occur without newly available substance. | A second opportunity appears only when the person's response opened substance not previously available. | 15 |

**Count**: 33 existing + 16 new = **49**.

## New definitions

Inserted into `### Definitions`, after **Contribution Opportunity**:

> **Exploratory Move**: A development of a Working Idea that extends what the person said toward
> something a later decision depends on. A question about wording alone is not one.

> **Grounded Possibility**: A direction traceable to accepted material, offered for the person to
> react to rather than to select from.

> **Attribution**: An inline statement, at the point of use, that a term or claim originated with
> Highway rather than the person.

## Amended definition

**Contribution Opportunity** gains one sentence and loses none:

> A meaningful opportunity to add, correct, remove, or extend a Working Idea before it becomes a
> Converged Proposal. It is not acceptance, persistence, or a recurring ritual. Its substance is
> not a candidate, and nothing in it can be accepted.

The clause `Highway materially shaped` is removed from the definition, because the trigger is no
longer a judgement about Highway's own interpretation.

## Amended prose

### `## Contribution Opportunity`

Replaced in full:

> Give a distinct opportunity whenever the person has not yet added, changed, corrected, removed,
> redirected, or qualified the substance under development. Approving a candidate or selecting
> from a set is not such a contribution. Someone who supplies a domain-complete statement has
> already made one, so no separate opportunity is owed and the short path stands. The opportunity
> carries provisional substance under no capture heading, asks for change rather than approval, and
> never independently authorizes persistence. It is not a recurring "anything else?" ritual, and it
> is not repeated for the same subject unless the person's response opens substance that was not
> available before.

### `## Constructive Advisory`

One paragraph added after the existing example pair:

> Mark the vocabulary and the claims that are yours. When Highway introduces a domain or industry
> term the person has not used, or asserts something they did not say, name it as Highway's where
> it appears, so the person can reject the framing rather than only the conclusion. Ordinary
> paraphrase of what they meant needs no marking; marking everything makes the marking worthless.
> An unadopted term stays out of the captured record.

### `## Interaction Boundaries`

Exactly five rows before and after. The `Contribution Opportunity` row's Compliant cell is
replaced:

| Field | Value |
|---|---|
| Scenario | `Contribution Opportunity` *(unchanged)* |
| Non-compliant | `Repeats a final artifact and asks for both contribution and acceptance as a ritual.` *(unchanged)* |
| Compliant | `Presents provisional substance under no capture heading, invites change, and synthesizes only after the person contributes.` |

### Interaction Model

Step 9 is replaced:

> 9. Present a Converged Proposal only after owner completeness, conversational convergence, and a
>    Substantive Contribution from the person.

Steps 7 and 8 are unchanged — `grounded reasoning materially improves it` is asserted by
`experience-standard-convergence.test.sh` and must survive.

## Version block

| Location | Before | After |
|---|---|---|
| Line 3 | ``**Layer 2 - Experience.** Version `9.1.0`.`` | ``**Layer 2 - Experience.** Version `10.0.0`.`` |
| Provenance | ``**Version**: `9.1.0` \| **Ratified**: 2026-09-08 \| **Last Amended**: 2026-10-06`` | ``**Version**: `10.0.0` \| **Ratified**: 2026-09-08 \| **Last Amended**: 2026-10-07`` |

The provenance paragraph gains one sentence naming this amendment. It retires no identifier.
