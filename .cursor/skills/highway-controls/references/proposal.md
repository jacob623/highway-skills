# Proposal

### recommend

Build one set from the accepted Profile and accepted Objectives.

1. Derive specific safeguards from the accepted Profile and accepted Objectives first.
2. Check coverage across Identity and Access, Information Protection, Change and Operations, Resilience, and Monitoring and Accountability. Do not name those areas.
3. Add a safeguard from an uncovered area only when it would reasonably benefit this organization. Adapt it to the accepted Profile and accepted Objectives.
4. Do not add a safeguard only to fill an area.
5. Omit a title already queued, already shown, or already captured.
6. Emit 3 to 5 recommendations. Emit fewer when fewer are grounded. Go to `ask` when none are grounded.

Each recommendation is a bold title and one sentence. Number every recommendation in the set, starting at 1. Do not say which source produced it.

When the queue is empty, emit:

Based on [Name]'s profile and accepted business objectives, here are recommended safeguards that connect directly to [two or three accepted themes]:

1. **[Title]:** [One sentence.]

**Which of these safeguards would you like to establish, or what would you like to focus on?**

You can select some, all or provide your own safeguards.

If you'd like additional suggestions, just say so.

When the queue already has Controls, emit:

Looking across [the uncovered area, in the person's terms] alongside your accepted profile and objectives, here are additional safeguards tailored to [Name]:

1. **[Title]:** [One sentence.]

**Would you like to select any of these safeguards, modify them, or are you ready to review the selected Controls?**

You can select some, all or provide your own safeguards.

If you'd like additional suggestions, just say so.

- `select-all`: add every title in the set to the queue, in displayed order. Go to `queue`.
- `select`: add the named titles to the queue. Go to `queue`.
- `own`: add the person's safeguard to the queue. Go to `queue`.
- `edit`: emit one consequence sentence. Re-emit this set with the edit applied. Stay on `recommend`.
- `more`: go to `more`.
- `review-now`: go to `capture` of every queued Control. When the queue is empty, stay on `recommend`.
- `question`: answer in one sentence. Re-emit this set. Stay on `recommend`.
- `unknown`: re-emit this set. Stay on `recommend`.

### more

Build the next set with the `recommend` rules. When at least one grounded recommendation remains, emit that set and stay on `recommend`.

When none remain, emit no bullets. Emit:

Additional suggestions at this stage would largely overlap or subdivide these safeguards.

**Are you ready to review the selected Controls?**

If you'd like to add another safeguard first, just say so.

Stay on `queue` for the reply.

### queue

Emit the titles just added:

The [count just added] recommendations have been added to the active Control queue:

1. **[Title]**

Number every title just added.

When the queue already had titles, continue with the full queue:

The queue now contains [total] selected safeguards:

1. **[Title]**

[One sentence naming the areas the queue covers.]

When grounded non-duplicate recommendations remain, emit them in the same message. Build the set with the `recommend` rules. Emit:

Based on [Name]'s profile and accepted objectives, here are additional recommended safeguards that connect directly to [two or three accepted themes]:

1. **[Title]:** [One sentence.]

**Would you like to select any of these safeguards, modify them, or are you ready to review the selected Controls?**

You can select some, all or provide your own safeguards.

If you'd like additional suggestions, just say so.

Do not ask whether to explore more safeguards. A number in the reply refers to the recommendation set, not the queue list.

- `select-all`: add every title in this new set to the queue. Emit `queue` again.
- `select`: add the named titles. Emit `queue` again.
- `own`: add the person's safeguard. Emit `queue` again.
- `edit`: emit one consequence sentence. Re-emit the queue list and this set with the edit applied. Stay on `queue`.
- `more`: build another set that omits every title already shown. When one remains, emit it with the additional-recommendation intro above. Stay on `queue`.
- `review-now`: go to `capture` of every queued Control. Do not add the unselected set.
- `question`: answer in one sentence. Re-emit the queue message. Stay on `queue`.
- `unknown`: re-emit the queue message. Stay on `queue`.

When no grounded non-duplicate recommendation remains, emit no recommendation bullets. After the queue list, emit:

Additional suggestions at this stage would largely overlap or subdivide these safeguards.

**Are you ready to review the selected Controls?**

If you'd like to add another safeguard first, just say so.

- `review-now` or `accept`: go to `capture` of every queued Control.
- `own`: append that safeguard and emit `queue` again.
- `more`: re-emit this message.
- `question`: answer in one sentence. Re-emit this message.
- `unknown`: re-emit this message.

Do not write a file from `queue`. After `review-now`, do not return to `recommend`.

### ask

Emit this only when no grounded recommendation is available:

**What concerns should future technology decisions take into account?**

If you're not sure, just say "I don't know," and we'll work through it together.

- `own` or `edit`: add that safeguard to the queue. Go to `queue`.
- `unknown`: re-emit this template. Stay on `ask`.
- `question`: answer in one sentence. Re-emit this template. Stay on `ask`.
- `decline`: write the empty catalog described in `write`. Go to `close`.

### capture

Develop every queued Control in queue order. Emit them in one message. One queued Control has no separator.

The title is the queued title unless the person changes it. The statement is one sentence stating what must remain true. The rationale is one line grounded in the accepted Profile and accepted Objectives.

**Here's what I've captured as your controls:**

1. **[Title]:** [Statement]

   **Why it matters:** [Rationale]

---

Number every Control in the review, starting at 1, in queue order. Indent each Control's rationale under its number. Put `---` between Controls. Do not put `---` after the last Control. A number in the reply refers to the Control with that number in the review just shown.

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Apply the edit to the named Control. An added Control joins the set. A removed Control leaves the set. Re-emit every Control that remains. When none remain, go to `write` and do not show an empty review. Stay on `capture` when any remain.
- `accept`: hold each remaining title, statement, and rationale. Go to `identifier`, then `write`.
- `decline`: drop every queued Control. Go to `write`. Do not show an empty review.
- `unknown`: re-emit this capture. Stay on `capture`.
- `question`: answer in one sentence. Re-emit this capture. Stay on `capture`.

Do not develop one Control at a time. Do not emit a bridge.

## Verification

- "Looks good" on a recommendation set adds that set to the queue and does not start capture.
- A queue message lists the titles just added, then includes the next recommendation set when grounded recommendations remain.
- Once the queue holds a title, every recommendation set asks whether to select, modify, or review the selected Controls.
- A queue message does not ask whether to explore more safeguards.
- Capture starts when the person asks to review the queue.
- A capture shows every queued Control in one message, with `---` between Controls and one acceptance question.
- A capture does not accept Controls one at a time.
