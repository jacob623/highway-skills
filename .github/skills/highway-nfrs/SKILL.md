---
name: highway-nfrs
description: "Manages the repository-wide nfr baseline."
usage: "Invoke as /highway-nfrs."
compatibility: all
metadata:
  version: 5.1.0
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

- Project root containing `.highway/`.
- `library/knowledge/profile.md` when present.
- `library/governance/objectives.md` and `library/objectives/` when present.
- `library/governance/controls.md` and `library/governance/controls/` when present.
- `library/governance/nfrs.md` when present.
- `library/governance/nfrs/NFR*.md` when present.
- `.highway/library/templates/output/nfr-record.md`.
- `.highway/library/templates/output/nfr-catalog.md`.
- `.highway/governance/experience-standard.md`.
- Delegation from `highway-setup`.

## Outputs

The complete structure is `.highway/library/templates/output/nfr-record.md` and `.highway/library/templates/output/nfr-catalog.md`.

- Updated NFR records and catalog after a review edit.
- New NFR records and catalog after the guided flow writes them.
- `Finished` returned to `highway-setup` after review acceptance or a successful guided write.
- `Finished` is not shown to the person.

## Procedure

User-visible interaction follows the Highway Experience Standard. Repository ownership stays with the person.

Emit only the active template. Follow this order: `review` when the catalog exists; otherwise `recommend`, then `queue` or `ask`, then `capture`, then `identifier`, `title` when needed, and `write`. Follow `.highway/governance/experience-standard.md` for attribution and acceptance wording. Use the accepted Organization Name from the Profile. Use Repository Name when no Organization Name is accepted. Do not ask for Profile, Objective, or Control facts already accepted.

An NFR is an operational expectation: how a solution needs to behave. Do not write an enforceable safeguard, an Objective, or an implementation plan.

### Entry

1. Read `library/governance/nfrs.md` and each active record it indexes.
2. If the catalog is present and readable, and every active row has a readable record, go to `review`.
3. If the catalog is absent, go to `recommend` when `profile.md`, `library/governance/objectives.md`, and `library/governance/controls.md` are readable. Otherwise go to `ask`.
4. If the catalog is unreadable, or an active row has no readable record, stop. Say the NFRs could not be read. Leave every file unchanged. Do not return `Finished`.

A removed row has no record file. Do not treat that as unreadable.

### Classify

Classify the latest reply before any other action.

- `select-all`: affirms every recommendation in the current set and adds no separate expectation.
- `select`: names one or more recommendations in the current set.
- `own`: supplies an expectation that is not a displayed title.
- `more`: asks for more suggestions.
- `review-now`: asks to review the queue, or affirms a queue prompt that asks whether to review.
- `edit`: adds, removes, corrects, splits, combines, or replaces substance.
- `accept`: affirms the current capture or review body and adds no fact.
- `unknown`: the person says they do not know.
- `question`: the person asks for an explanation.
- `decline`: the person explicitly drops the active NFR.

On a recommendation set, "looks good" is `select-all`. On a queue prompt that asks whether to review, "looks good" and "let's review" are `review-now`. On a capture or on `review`, "looks good" is `accept`.

### review

Show every active NFR in catalog order. Omit frontmatter, omit the catalog, and omit removed rows. For each NFR emit:

**Title:**
[Title]

**Statement:**
[Statement]

**Why it matters:**
[Rationale]

When no active NFR is recorded, emit: No operational expectations are recorded yet.

Then emit the validation block.

- `edit`: emit one consequence sentence. Apply the edit to the named NFR. Preserve every NFR the person left unchanged. An added expectation becomes a new record. A removed NFR deletes that record file and keeps its catalog row with status `removed`, so the id stays taken. Derive the id before writing. When the id is taken for a different title, go to `title` and do not write yet. Otherwise rewrite the affected records and the catalog. Show the updated NFRs and emit the validation block. Stay on `review`.
- `accept`: return `Finished`. Emit nothing else.
- `unknown`: show the NFRs and emit the validation block. Stay on `review`.
- `question`: answer in one sentence. Show the NFRs and emit the validation block. Stay on `review`.

Validation block:

**What would you add, correct, or remove?**

If this is accurate, just say so.

### recommend

Build one set from the accepted Profile, accepted Objectives, and accepted Controls.

1. Derive specific operational expectations from the accepted Profile, accepted Objectives, and accepted Controls first.
2. Check coverage across Reliability, Availability, Performance, Scalability, Security, Compliance, Maintainability, and Operability. Do not name those areas.
3. Add an expectation from an uncovered area only when it would reasonably benefit this organization. Adapt it to the accepted Profile, accepted Objectives, and accepted Controls.
4. Do not add an expectation only to fill an area.
5. Omit a title already queued, already shown, or already captured.
6. Emit 3 to 5 recommendations. Emit fewer when fewer are grounded. Go to `ask` when none are grounded.

Each recommendation is a bold title and one sentence. Do not say which source produced it. Include a measurable bound in the sentence only when accepted evidence supports that bound.

When the queue is empty, emit:

Based on [Name]'s profile, accepted objectives, and accepted controls, here are recommended operational expectations that connect directly to [two or three accepted themes]:

- **[Title]:** [One sentence.]

If none of these fit, feel free to suggest your own operational expectation.

**Which of these operational expectations would you like to establish, or what would you like to focus on?**

When the queue already has NFRs, emit:

Looking across [the uncovered area, in the person's terms] alongside your accepted profile, objectives, and controls, here are additional operational expectations tailored to [Name]:

- **[Title]:** [One sentence.]

If none of these fit, feel free to suggest your own operational expectation. If you'd like additional suggestions, just let me know.

**Would you like to select any of these operational expectations, modify them, or are you ready to review the selected NFRs?**

- `select-all`: add every title in the set to the queue, in displayed order. Go to `queue`.
- `select`: add the named titles to the queue. Go to `queue`.
- `own`: add the person's expectation to the queue. Go to `queue`.
- `edit`: emit one consequence sentence. Re-emit this set with the edit applied. Stay on `recommend`.
- `more`: go to `more`.
- `review-now`: go to `capture` of the first queued NFR. When the queue is empty, stay on `recommend`.
- `question`: answer in one sentence. Re-emit this set. Stay on `recommend`.
- `unknown`: re-emit this set. Stay on `recommend`.

### more

Build the next set with the `recommend` rules. When at least one grounded recommendation remains, emit that set and stay on `recommend`.

When none remain, emit no bullets. Emit:

Additional suggestions at this stage would largely overlap or subdivide these operational expectations.

**Are you ready to review the selected NFRs?**

Stay on `queue` for the reply.

### queue

Emit the titles just added:

The [count just added] recommendations have been added to the active NFR queue:

1. **[Title]**

Number every title just added.

When the queue already had titles, continue with the full queue:

The queue now contains [total] selected operational expectations:

1. **[Title]**

[One sentence naming the areas the queue covers.]

When grounded non-duplicate recommendations remain, emit them in the same message. Build the set with the `recommend` rules. Emit:

Based on [Name]'s profile, accepted objectives, and accepted controls, here are additional recommended operational expectations that connect directly to [two or three accepted themes]:

- **[Title]:** [One sentence.]

If none of these fit, feel free to suggest your own operational expectation.

**Which of these operational expectations would you like to establish, or what would you like to focus on?**

Do not ask whether to explore more operational expectations.

- `select-all`: add every title in this new set to the queue. Emit `queue` again.
- `select`: add the named titles. Emit `queue` again.
- `own`: add the person's expectation. Emit `queue` again.
- `edit`: emit one consequence sentence. Re-emit the queue list and this set with the edit applied. Stay on `queue`.
- `more`: build another set that omits every title already shown. When one remains, emit it with the additional-recommendation intro above. Stay on `queue`.
- `review-now`: go to `capture` of the first queued NFR. Do not add the unselected set.
- `question`: answer in one sentence. Re-emit the queue message. Stay on `queue`.
- `unknown`: re-emit the queue message. Stay on `queue`.

When no grounded non-duplicate recommendation remains, emit no recommendation bullets. After the queue list, emit:

Additional suggestions at this stage would largely overlap or subdivide these operational expectations.

**Are you ready to review the selected NFRs?**

- `review-now` or `accept`: go to `capture` of the first queued NFR.
- `own`: append that expectation and emit `queue` again.
- `more`: re-emit this message.
- `question`: answer in one sentence. Re-emit this message.
- `unknown`: re-emit this message.

Do not write a file from `queue`. After `review-now`, do not return to `recommend`.

### ask

Emit this only when no grounded recommendation is available:

**Are there any qualities or operational expectations you'd like future solutions to meet?**

If you're not sure, just say "I don't know," and we'll work through it together.

- `own` or `edit`: add that expectation to the queue. Go to `queue`.
- `unknown`: re-emit this template. Stay on `ask`.
- `question`: answer in one sentence. Re-emit this template. Stay on `ask`.
- `decline`: write the empty catalog described in `write`. Return `Finished`. Emit nothing else.

### capture

Develop the first queued NFR that is not yet accepted or declined.

The title is the queued title unless the person changes it. The statement is one paragraph stating how a solution must behave. Include a measurable bound only when accepted evidence supports it. The rationale is one paragraph grounded in the accepted Profile, accepted Objectives, and accepted Controls.

**Here's what I've captured as your NFR:**

**Title:**
[Title]

**Statement:**
[Statement]

**Why it matters:**
[Rationale]

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Re-emit this capture with the edit applied. Stay on this NFR.
- `accept`: hold the title, statement, and rationale. When another queued NFR remains, emit the bridge below and the next capture in the same message. When none remain, go to `write`.
- `decline`: drop this NFR. Continue to the next queued NFR. When none remain, go to `write`.
- `unknown`: re-emit this capture. Stay on this NFR.
- `question`: answer in one sentence. Re-emit this capture. Stay on this NFR.

Bridge, emitted only between captures:

Your accepted NFRs now cover [short phrases for the held NFRs].

Next we'll develop **[next title]**.

### identifier

Derive each id from its title.

1. Lowercase the title. Remove hyphens and apostrophes. Split the rest into words.
2. Take eight letters: the first two of word 1, the first two of word 2, the first two of word 3, and the last two of the last word. When the title has only two words, the third sample is the first two of the last word.
3. When a word is shorter than two letters, continue into the next word. A one-word title repeats until there are eight letters.
4. Map each letter. Digits stay as they are.

a 0, b 1, c 2, d 3, e 4, f 5, g 6, h 7, i 8, j 9, k a, l b, m c, n d, o e, p f, q 0, r 1, s 2, t 3, u 4, v 5, w 6, x 7, y 8, z 9.

5. The id is `NFR` plus those eight hex digits.

Compare that id with the catalog, including removed rows, and with the other held titles in this write.

- The same title already has that id: use the existing record. Do not write a second one.
- The id is taken for a different title: go to `title`.
- The id is free: use it.

### title

Name each conflicting title. Say that a title change is appropriate. Then show the new title for acceptance.

The existing NFR Title, **[Existing title]** and this new NFR Title, **[this title]**, are too similar. A title change is appropriate. I would recommend:

**[New title]**

**What would you add, correct, or remove?**

If this is accurate, just say so.

The new title is a small change the person can recognize. Its derived id must be free. Do not mention identifiers, hex, sampling, or the catalog.

- `accept`: replace the held title with the new title. Return to `identifier` for that NFR.
- `edit`: use the person's title. Return to `identifier` for that NFR.
- `question`: answer in one sentence. Re-emit this message.
- `unknown`: re-emit this message.

Do not write until every held NFR has a free id or reuses its existing record.

### write

Resolve every id in `identifier` before writing. Write the held NFRs and the catalog together. Write no record until this step. A failed write leaves the baseline as it was before the step. Say what failed in terms the person can act on. Stay on `write`. Do not return `Finished`.

On success, emit nothing. Return `Finished`.

For each held NFR, write `library/governance/nfrs/[ID].md` in the shape required by `.highway/library/templates/output/nfr-record.md`.

- `id` is the derived `NFR` id.
- Keep an existing id when the title is unchanged.
- `title` is the accepted title.
- `status` is `active`.
- `controls` lists the accepted Control ids that influenced this expectation. Use `[]` when none did.
- The statement is the accepted statement.
- The rationale is the accepted rationale.

Write `library/governance/nfrs.md` in the shape required by `.highway/library/templates/output/nfr-catalog.md`.

- Order the index by identifier.
- Do not allocate from `Next ID`.
- The first catalog version is `1.0.0`.
- A review that adds a record increments the minor version.
- A review that changes a record increments the patch version.
- A review that removes a record increments the major version.
- Emit no timestamp, random value, or environment value.
- An empty held set writes the catalog with version `1.0.0` and no index rows.
- A removed NFR keeps its catalog row with status `removed`.

No NFR record is written beneath `.highway`.

## Verification

- An existing readable catalog is shown with **What would you add, correct, or remove?**
- Acceptance of that review returns `Finished` and emits nothing else.
- A review edit rewrites the affected record and catalog, then shows the updated NFRs with the same question.
- An absent catalog and readable Profile, Objectives, and Controls begin with a recommendation set.
- "Looks good" on a recommendation set adds that set to the queue and does not start capture.
- A queue message lists the titles just added, then includes the next recommendation set when grounded recommendations remain.
- A queue message does not ask whether to explore more operational expectations.
- Capture starts when the person asks to review the queue.
- A capture contains a title, one statement, a rationale, and the acceptance reassurance only.
- Records and the catalog are written once, after every queued NFR is accepted or declined.
- Each id is `NFR` plus eight hex digits derived from the title.
- A taken id for a different title names the conflicting titles, says a title change is appropriate, and shows a new title. The write waits until the person accepts that title.
- That message does not mention identifiers, hex, sampling, or the catalog.
- A successful guided write returns `Finished` and emits nothing else.
- Written records match `.highway/library/templates/output/nfr-record.md`.
- The written catalog matches `.highway/library/templates/output/nfr-catalog.md`.
- Setup receives `Finished` and the person does not see that word.

## Error Handling

- An unreadable catalog or active record stops the skill, leaves every file unchanged, and does not return `Finished`.
- A failed review rewrite leaves every file unchanged, says what failed in terms the person can act on, and stays on `review`.
- A failed guided write leaves the baseline unchanged, says what failed in terms the person can act on, and stays on `write`.
- An absent or unreadable Profile, Objectives catalog, or Controls catalog uses `ask` and does not invent organizational facts.

## Example

`/highway-setup`