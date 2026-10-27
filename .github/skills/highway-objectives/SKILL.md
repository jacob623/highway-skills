---
name: highway-objectives
description: "Manages the repository-wide business objective baseline and its stable traceability references."
usage: "Invoke as /highway-objectives."
compatibility: all
metadata:
  version: 7.0.0
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

- Project root containing `.highway/`.
- `library/knowledge/profile.md` when present.
- `library/governance/objectives.md` when present.
- `library/objectives/OBJ*.md` when present.
- `.highway/library/templates/output/objective-record.md`.
- `.highway/library/templates/output/objective-catalog.md`.
- `.highway/governance/experience-standard.md`.
- Delegation from `highway-setup`.

## Outputs

The complete structure is `.highway/library/templates/output/objective-record.md` and `.highway/library/templates/output/objective-catalog.md`.

- Updated Objective records and catalog after a review edit.
- New Objective records and catalog after the guided flow writes them.
- `Finished` returned to `highway-setup` after review acceptance or a successful guided write.
- `Finished` is not shown to the person.

## Procedure

User-visible interaction follows the Highway Experience Standard. Repository ownership stays with the person.

Emit only the active template. Follow this order: `review` when the catalog exists; otherwise `recommend`, then `queue` or `ask`, then `capture`, then `identifier`, `title` when needed, and `write`. Follow `.highway/governance/experience-standard.md` for attribution and acceptance wording. Use the accepted Organization Name from the Profile. Use Repository Name when no Organization Name is accepted. Do not ask for Profile facts already accepted.

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

### recommend

Build one set from the accepted Profile.

1. Derive specific outcomes from the accepted Profile first.
2. Check coverage across Growth, Operations, Customer, and Capability. Do not name those families.
3. Add an outcome from an uncovered family only when it would reasonably benefit this organization. Adapt it to the accepted Profile.
4. Do not add an outcome only to fill a family.
5. Omit a title already queued, already shown, or already captured.
6. Emit 3 to 5 recommendations. Emit fewer when fewer are grounded. Go to `ask` when none are grounded.

Each recommendation is a bold title and one sentence. Number every recommendation in the set, starting at 1. Do not say which source produced it.

When the queue is empty, emit:

Based on [Name]'s profile, here are recommended business outcomes that connect directly to [two or three accepted Profile themes]:

1. **[Title]:** [One sentence.]

**Which of these outcomes would you like to pursue, or what would you like to focus on?**

You can select some, all or provide your own outcome.

If you'd like additional suggestions, just say so.

When the queue already has Objectives, emit:

Looking across [the uncovered area, in the person's terms] alongside your accepted profile, here are additional outcomes tailored to [Name]:

1. **[Title]:** [One sentence.]

**Would you like to select any of these outcomes, modify them, or are you ready to review the selected objectives?**

You can select some, all or provide your own outcome.

If you'd like additional suggestions, just say so.

- `select-all`: add every title in the set to the queue, in displayed order. Go to `queue`.
- `select`: add the named titles to the queue. Go to `queue`.
- `own`: add the person's outcome to the queue. Go to `queue`.
- `edit`: emit one consequence sentence. Re-emit this set with the edit applied. Stay on `recommend`.
- `more`: go to `more`.
- `review-now`: go to `capture` of every queued Objective. When the queue is empty, stay on `recommend`.
- `question`: answer in one sentence. Re-emit this set. Stay on `recommend`.
- `unknown`: re-emit this set. Stay on `recommend`.

### more

Build the next set with the `recommend` rules. When at least one grounded recommendation remains, emit that set and stay on `recommend`.

When none remain, emit no bullets. Emit:

Additional suggestions at this stage would largely overlap or subdivide these priorities.

**Are you ready to review the selected objectives?**

If you'd like to add another outcome first, just say so.

Stay on `queue` for the reply.

### queue

Emit the titles just added:

The [count just added] recommendations have been added to the active objective queue:

1. **[Title]**

Number every title just added.

When the queue already had titles, continue with the full queue:

The queue now contains [total] selected outcomes:

1. **[Title]**

[One sentence naming the areas the queue covers.]

When grounded non-duplicate recommendations remain, emit them in the same message. Build the set with the `recommend` rules. Emit:

Based on [Name]'s profile, here are additional recommended business outcomes that connect directly to [two or three accepted Profile themes]:

1. **[Title]:** [One sentence.]

**Which of these outcomes would you like to pursue, or what would you like to focus on?**

You can select some, all or provide your own outcome.

If you'd like additional suggestions, just say so.

Do not ask whether to explore more outcomes. A number in the reply refers to the recommendation set, not the queue list.

- `select-all`: add every title in this new set to the queue. Emit `queue` again.
- `select`: add the named titles. Emit `queue` again.
- `own`: add the person's outcome. Emit `queue` again.
- `edit`: emit one consequence sentence. Re-emit the queue list and this set with the edit applied. Stay on `queue`.
- `more`: build another set that omits every title already shown. When one remains, emit it with the additional-recommendation intro above. Stay on `queue`.
- `review-now`: go to `capture` of every queued Objective. Do not add the unselected set.
- `question`: answer in one sentence. Re-emit the queue message. Stay on `queue`.
- `unknown`: re-emit the queue message. Stay on `queue`.

When no grounded non-duplicate recommendation remains, emit no recommendation bullets. After the queue list, emit:

Additional suggestions at this stage would largely overlap or subdivide these priorities.

**Are you ready to review the selected objectives?**

If you'd like to add another outcome first, just say so.

- `review-now` or `accept`: go to `capture` of every queued Objective.
- `own`: append that outcome and emit `queue` again.
- `more`: re-emit this message.
- `question`: answer in one sentence. Re-emit this message.
- `unknown`: re-emit this message.

Do not write a file from `queue`. After `review-now`, do not return to `recommend`.

### ask

Emit this only when no grounded recommendation is available:

**What's an important outcome you'd like to achieve?**

If you're not sure, just say "I don't know," and we'll work through it together.

- `own` or `edit`: add that outcome to the queue. Go to `queue`.
- `unknown`: re-emit this template. Stay on `ask`.
- `question`: answer in one sentence. Re-emit this template. Stay on `ask`.
- `decline`: write the empty catalog described in `write`. Return `Finished`. Emit nothing else.

### capture

Develop every queued Objective in queue order. Emit them in one message. One queued Objective has no separator.

The title is the queued title unless the person changes it. The statement is one sentence. Emit one observable success measure. Emit a second when the accepted Profile supports it. The rationale is one line grounded in the accepted Profile.

**Here's what I've captured as your objectives:**

**[Title]:** [Statement]

**Success looks like:**
- [Success measure]

**Why it matters:** [Rationale]

---

Put `---` between Objectives. Do not put `---` after the last Objective.

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Apply the edit to the named Objective. An added outcome joins the set. A removed outcome leaves the set. Re-emit every Objective that remains. When none remain, go to `write` and do not show an empty review. Stay on `capture` when any remain.
- `accept`: hold each remaining title, statement, success measures, and rationale. Go to `identifier`, then `write`.
- `decline`: drop every queued Objective. Go to `write`. Do not show an empty review.
- `unknown`: re-emit this capture. Stay on `capture`.
- `question`: answer in one sentence. Re-emit this capture. Stay on `capture`.

Do not develop one Objective at a time. Do not emit a bridge.

### identifier

Derive each id from its title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `OBJ` plus those eight hex digits.

Compare that id with the catalog, including removed rows, and with the other held titles in this write.

- The same title already has that id: use the existing record. Do not write a second one.
- The id is taken for a different title: go to `title`.
- The id is free: use it.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing Objective Title, **[Existing title]** and this new Objective Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

**[New title]**

**What would you add, correct, or remove?**

If this is accurate, just say so.

The new title is a small change the person can recognize. Its derived id must be free. Do not mention identifiers, hex, sampling, or the catalog.

- `accept`: replace the held title with the new title. Return to `identifier` for that Objective.
- `edit`: use the person's title. Return to `identifier` for that Objective.
- `question`: answer in one sentence. Re-emit this message.
- `unknown`: re-emit this message.

Do not write until every held Objective has a free id or reuses its existing record.

### write

Resolve every id in `identifier` before writing. Write the held Objectives and the catalog together. Write no record until this step. A failed write leaves the baseline as it was before the step. Say what failed in terms the person can act on. Stay on `write`. Do not return `Finished`.

On success, emit nothing. Return `Finished`.

For each held Objective, write `library/objectives/[ID].md` in the shape required by `.highway/library/templates/output/objective-record.md`.

- `id` is the derived `OBJ` id.
- Keep an existing id when the title is unchanged.
- `title` is the accepted title.
- `status` is `active`.
- `capabilities` is `[]`.
- `## Statement` is the statement shown with the title.
- `## Success Measures` are the measures shown under **Success looks like:**.
- `## Rationale` is the line shown with **Why it matters:**.
- Do not show the stored records. Do not add a closing line.

Write `library/governance/objectives.md` in the shape required by `.highway/library/templates/output/objective-catalog.md`.

- Order the index by identifier.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- A review that adds a record increments the minor version.
- A review that changes a record increments the patch version.
- A review that removes a record increments the major version.
- Emit no timestamp, random value, or environment value.
- An empty held set writes the catalog with version `1.0.0` and no index rows.
- A removed Objective keeps its catalog row with status `removed`.

No Objective record is written beneath `.highway`.

## Verification

- An existing readable catalog is shown with **What would you add, correct, or remove?**
- Acceptance of that review returns `Finished` and emits nothing else.
- A review edit rewrites the affected record and catalog, then shows the updated Objectives with the same question.
- An absent catalog and a readable Profile begin with a recommendation set.
- "Looks good" on a recommendation set adds that set to the queue and does not start capture.
- A queue message lists the titles just added, then includes the next recommendation set when grounded recommendations remain.
- A queue message does not ask whether to explore more outcomes.
- Capture starts when the person asks to review the queue.
- A capture shows every queued Objective in one message, with `---` between Objectives and one acceptance question.
- A capture does not accept Objectives one at a time.
- Records and the catalog are written once, after the set is accepted or declined.
- Each id is `OBJ` plus eight hex digits derived from the title.
- A taken id for a different title names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A successful guided write returns `Finished`, emits nothing else, and does not show the stored records.
- Written records match `.highway/library/templates/output/objective-record.md`.
- The written catalog matches `.highway/library/templates/output/objective-catalog.md`.
- Setup receives `Finished` and the person does not see that word.

## Error Handling

- An unreadable catalog or record stops the skill, leaves every file unchanged, and does not return `Finished`.
- A failed review rewrite leaves every file unchanged, says what failed in terms the person can act on, and stays on `review`.
- A failed guided write leaves the baseline unchanged, says what failed in terms the person can act on, and stays on `write`.
- An absent or unreadable Profile uses `ask` and does not invent organizational facts.

## Example

`/highway-setup`
