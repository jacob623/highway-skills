# Proposal

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

**Would you like to select any of these outcomes, modify them, or are you ready to review the selected objectives?**

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
- `decline`: write the empty catalog described in `write`. Go to `close`.

### capture

Develop every queued Objective in queue order. Emit them in one message. One queued Objective has no separator.

The title is the queued title unless the person changes it. The statement is one sentence. Emit one observable success measure. Emit a second when the accepted Profile supports it. The rationale is one line grounded in the accepted Profile.

**Here's what I've captured as your objectives:**

1. **[Title]:** [Statement]

   **Success looks like:**
   - [Success measure]

   **Why it matters:** [Rationale]

---

Number every Objective in the review, starting at 1, in queue order. Indent each Objective's other lines under its number. Put `---` between Objectives. Do not put `---` after the last Objective. A number in the reply refers to the Objective with that number in the review just shown.

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Apply the edit to the named Objective. An added outcome joins the set. A removed outcome leaves the set. Re-emit every Objective that remains. When none remain, go to `write` and do not show an empty review. Stay on `capture` when any remain.
- `accept`: hold each remaining title, statement, success measures, and rationale. Go to `identifier`, then `write`.
- `decline`: drop every queued Objective. Go to `write`. Do not show an empty review.
- `unknown`: re-emit this capture. Stay on `capture`.
- `question`: answer in one sentence. Re-emit this capture. Stay on `capture`.

Do not develop one Objective at a time. Do not emit a bridge.

## Verification

- "Looks good" on a recommendation set adds that set to the queue and does not start capture.
- A queue message lists the titles just added, then includes the next recommendation set when grounded recommendations remain.
- Once the queue holds a title, every recommendation set asks whether to select, modify, or review the selected objectives.
- A queue message does not ask whether to explore more outcomes.
- Capture starts when the person asks to review the queue.
- A capture shows every queued Objective in one message, with `---` between Objectives and one acceptance question.
- A capture does not accept Objectives one at a time.
