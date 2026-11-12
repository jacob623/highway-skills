---
name: highway-objectives
description: "Manages the repository-wide business objective baseline and its stable traceability references. Use when highway-setup delegates the objective baseline, after Profile finishes or when setup runs again."
license: Apache-2.0
metadata:
  version: 8.6.0
  usage: "Run highway-objectives."
---

# highway-objectives

## Purpose

Collects business objectives when setup delegates this skill.

## When to use

- `highway-setup` delegates this skill after Profile returns `Finished`.
- `highway-setup` delegates this skill when setup runs again.

## When not to use

Do not create Controls, NFRs, Capabilities, or governance rules.
Do not treat a recommendation or a queued title as a captured Objective.
Do not report Status, Summary, Next Action, Blocking Reason, Missing, Complete, or Blocked.
Do not emit Setup's outcome transition. Setup already emitted it.

## Inputs

- `library/knowledge/profile.md` when present.
- `library/governance/objectives.md` when present.
- `library/objectives/OBJ*.md` when present.
- `assets/objective-record.md`.
- `assets/objective-catalog.md`.
- The highway-experience skill, activated first.
- Delegation from `highway-setup`.

## Outputs

The complete structure is `assets/objective-record.md` and `assets/objective-catalog.md`.

- Updated Objective records and catalog after a review edit.
- New Objective records and catalog after the guided flow writes them.
- `Finished` returned to `highway-setup` after review acceptance or a successful guided write.
- `Finished` is not shown to the person.

## Procedure

Activate the highway-experience skill before any output the person sees, and follow it for Highway's identity, the Experience Standard, and the storage contract.

User-visible interaction follows the Highway Experience Standard. Repository ownership stays with the person.

Emit only the active template. Follow this order: `review` when the catalog exists; otherwise `recommend`, then `queue` or `ask`, then `capture`, then `identifier`, `title` when needed, and `write`. Follow the Highway Experience Standard for attribution and acceptance wording. Use the accepted Organization Name from the Profile. Use Repository Name when no Organization Name is accepted. Do not ask for Profile facts already accepted.

Before a step in this table, read its file and follow it to the end.

| File | Steps |
| --- | --- |
| `references/proposal.md` | `recommend`, `more`, `queue`, `ask`, `capture` |
| `references/record.md` | `identifier`, `title`, `write` |

### Entry

1. Read `library/governance/objectives.md` and each record it indexes.
2. If the catalog and every indexed record are present and readable, go to `review`.
3. If the catalog is absent, go to `recommend` when `profile.md` is readable. Otherwise go to `ask`.
4. If the catalog or an indexed record is unreadable, or a catalog row has no record, stop. Say the Objectives could not be read. Leave every file unchanged. Do not return `Finished`.

### Classify

Classify the latest reply before any other action.

- `select-all`: affirms every recommendation in the current set and adds no separate outcome.
- `select`: names one or more recommendations in the current set, by title or by number.
- `own`: supplies an outcome that is not a displayed title.
- `more`: asks for more suggestions.
- `review-now`: asks to review the queue, or affirms a queue prompt that asks whether to review.
- `edit`: adds, removes, corrects, splits, combines, or replaces substance.
- `accept`: affirms the current capture or review body and adds no fact.
- `unknown`: the person says they do not know.
- `question`: the person asks for an explanation.
- `decline`: the person explicitly drops the active set.

On a recommendation set, "looks good" is `select-all`. On a queue prompt that asks whether to review, "looks good" and "let's review" are `review-now`. On a capture or on `review`, "looks good" is `accept`.

### review

Show every Objective in catalog order. Omit frontmatter and omit the catalog. For each Objective emit:

**[Title]:** [Statement]

**Success looks like:**
- [Success measure]

**Why it matters:** [Rationale]

---

Put `---` between Objectives. Do not put `---` after the last Objective.

When the catalog has no records, emit: No objectives are recorded yet.

Then emit the validation block.

- `edit`: emit one consequence sentence. Apply the edit to the named Objective. Preserve every Objective the person left unchanged. An added outcome becomes a new record. A removed outcome deletes that record file and keeps its catalog row with status `removed`, so the id stays taken. Derive the id before writing. When the id is taken for a different title, go to `title` and do not write yet. Otherwise rewrite the affected records and the catalog. Show the updated Objectives and emit the validation block. Stay on `review`.
- `accept`: return `Finished`. Emit nothing else.
- `unknown`: show the Objectives and emit the validation block. Stay on `review`.
- `question`: answer in one sentence. Show the Objectives and emit the validation block. Stay on `review`.

Validation block:

**What would you add, correct, or remove?**

If this is accurate, just say so.

## Verification

- An existing readable catalog is shown with **What would you add, correct, or remove?**
- Acceptance of that review returns `Finished` and emits nothing else.
- A review edit rewrites the affected record and catalog, then shows the updated Objectives with the same question.
- An absent catalog and a readable Profile begin with a recommendation set.
- Records and the catalog are written once, after the set is accepted or declined.
- Written records match `assets/objective-record.md`.
- The written catalog matches `assets/objective-catalog.md`.
- Setup receives `Finished` and the person does not see that word.

## Error Handling

- An unreadable catalog or record stops the skill, leaves every file unchanged, and does not return `Finished`.
- A failed review rewrite leaves every file unchanged, says what failed in terms the person can act on, and stays on `review`.
- A failed guided write leaves the baseline unchanged, says what failed in terms the person can act on, and stays on `write`.
- An absent or unreadable Profile uses `ask` and does not invent organizational facts.

## Example

`/highway-setup`
