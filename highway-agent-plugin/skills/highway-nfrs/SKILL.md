---
name: highway-nfrs
description: "Manages the repository-wide nfr baseline. Use when highway-setup delegates the nfr baseline, after Controls finish or when setup runs again."
license: Apache-2.0
metadata:
  version: 9.9.0
  usage: "Run highway-nfrs."
---

# highway-nfrs

## Purpose

Collects nfrs when setup delegates this skill.

## When to use

- `highway-setup` delegates this skill after Controls returns `Finished`.
- `highway-setup` delegates this skill when setup runs again.

## When not to use

Do not create Objectives, Controls, Capabilities, or governance rules.
Do not treat a recommendation or a queued title as a captured NFR.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.
Do not emit Setup's operational-expectation transition. Setup already emitted it.

## Inputs

- `library/knowledge/profile.md` when present.
- `library/governance/objectives.md` and `library/objectives/` when present.
- `library/governance/controls.md` and `library/governance/controls/` when present.
- `library/governance/nfrs.md` when present.
- `library/governance/nfrs/NFR*.md` when present.
- `assets/nfr-record.md`.
- `assets/nfr-catalog.md`.
- The highway-experience skill, activated first.
- Delegation from `highway-setup`.

## Outputs

The complete structure is `assets/nfr-record.md` and `assets/nfr-catalog.md`.

- Updated NFR records and catalog after a review edit.
- New NFR records and catalog after the guided flow writes them.
- `Finished` returned to `highway-setup` after review acceptance or a successful guided write.
- `Finished` is not shown to the person.
- One closing line after review acceptance or a successful guided write, when the person ran this skill directly.

## Procedure

Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

User-visible interaction follows the Highway Experience Standard. Repository ownership stays with the person.

Emit only the active template. Follow this order: `review` when the catalog exists; otherwise `recommend`, then `queue` or `ask`, then `capture`, then `identifier`, `title` when needed, and `write`. Both paths end at `close`. Follow the Highway Experience Standard for attribution and acceptance wording. Use the accepted Organization Name from the Profile. Use Repository Name when no Organization Name is accepted. Do not ask for Profile, Objective, or Control facts already accepted.

An NFR is an operational expectation: how a solution needs to behave. Do not write an enforceable safeguard, an Objective, or an implementation plan.

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/proposal.md` | `recommend`, `more`, `queue`, `ask`, `capture` |
| `references/record.md` | `identifier`, `title`, `write` |

### Entry

1. Read `library/governance/nfrs.md`. Then read each active record it indexes at `library/governance/nfrs/[ID].md`, with "Read a file".
2. If the catalog is present and readable, and every active row has a readable record, go to `review`.
3. If the catalog is absent, go to `recommend` when `profile.md`, `library/governance/objectives.md`, and `library/governance/controls.md` are readable. Otherwise go to `ask`.
4. If the catalog is unreadable, or an active row has no readable record, stop. Say the NFRs could not be read. Leave every file unchanged. Do not return `Finished`.

A removed row has no record file. Do not treat that as unreadable.

### Classify

Classify the latest reply before any other action.

- `select-all`: affirms every recommendation in the current set and adds no separate expectation.
- `select`: names one or more recommendations in the current set, by title or by number.
- `own`: supplies an expectation that is not a displayed title.
- `more`: asks for more suggestions.
- `review-now`: asks to review the queue, or affirms a queue prompt that asks whether to review.
- `edit`: adds, removes, corrects, splits, combines, or replaces substance.
- `accept`: affirms the current capture or review body and adds no fact.
- `unknown`: the person says they do not know.
- `question`: the person asks for an explanation.
- `decline`: the person explicitly drops the active set.

On a recommendation set, "looks good" is `select-all`. On a queue prompt that asks whether to review, "looks good" and "let's review" are `review-now`. On a capture or on `review`, "looks good" is `accept`.

### review

Show every active NFR in catalog order. Omit frontmatter, omit the catalog, and omit removed rows. For each NFR emit:

**[Title]:** [Statement]

**Why it matters:** [Rationale]

---

Put `---` between NFRs. Do not put `---` after the last NFR.

When no active NFR is recorded, emit: No operational expectations are recorded yet.

Do not insert **No system hosting** or **Direct purchase** when that title is absent. A removed limit stays removed.

Then emit the validation block.

- `edit`: emit one consequence sentence. Apply the edit to the named NFR. Preserve every NFR the person left unchanged. An added expectation becomes a new record. Write its rationale with the `recommend` rationale rule. A removed NFR deletes that record file and keeps its catalog row with status `removed`, so the id stays taken. Derive the id before writing. When the id is taken for a different title, go to `title` and do not write yet. Otherwise rewrite the affected records and the catalog. Show the updated NFRs and emit the validation block. Stay on `review`.
- `accept`: go to `close`.
- `unknown`: show the NFRs and emit the validation block. Stay on `review`.
- `question`: answer in one sentence. Show the NFRs and emit the validation block. Stay on `review`.

Validation block:

**What would you add, correct, or remove?**

If this is accurate, just say so.

### close

When `highway-setup` delegated this skill, return `Finished`. Emit nothing else.

Otherwise emit one line and stop. When at least one NFR is active, emit:

Your NFRs are recorded.

When no NFR is active, emit:

No NFRs are recorded yet. Run highway-nfrs when you have one to add.

## Verification

- An existing readable catalog is shown with **What would you add, correct, or remove?**
- Acceptance of that review goes to `close`.
- Run by `highway-setup`, `close` returns `Finished` and emits nothing else. Run directly, it emits one closing line and no question.
- A review edit rewrites the affected record and catalog, then shows the updated NFRs with the same question.
- An absent catalog and readable Profile, Objectives, and Controls begin with a recommendation set.
- Records and the catalog are written once, after the set is accepted or declined.
- Written records match `assets/nfr-record.md`.
- The written catalog matches `assets/nfr-catalog.md`.
- Setup receives `Finished` and the person does not see that word.

## Error Handling

- An unreadable catalog or active record stops the skill, leaves every file unchanged, and does not return `Finished`.
- A failed review rewrite leaves every file unchanged, says what failed in terms the person can act on, and stays on `review`.
- A failed guided write leaves the baseline unchanged, says what failed in terms the person can act on, and stays on `write`.
- An absent or unreadable Profile, Objectives catalog, or Controls catalog uses `ask` and does not invent organizational facts.

## Example

`/highway-setup`