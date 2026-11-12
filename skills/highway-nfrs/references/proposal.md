# Proposal

### recommend

Build one set from the accepted Profile, accepted Objectives, and accepted Controls.

1. Derive each recommendation from an accepted Control that no queued or captured NFR reflects yet. A shown recommendation the person did not select does not reflect its Control. Use the accepted Profile and accepted Objectives to refine its scope, priority, and wording. One NFR may reflect more than one Control.
2. While any accepted Control is unreflected, the set contains only recommendations derived from Controls, plus **No system hosting** and **Direct purchase** in the first set. An unreflected Control is a remaining grounded recommendation.
3. After every accepted Control is reflected, check coverage across Reliability, Availability, Performance, Scalability, Security, Compliance, Maintainability, and Operability. Do not name those areas. Add an expectation grounded in the accepted Profile or accepted Objectives, or from an uncovered area, only when it would reasonably benefit this organization.
4. Do not add an expectation only to fill an area.
5. Omit a title already queued or already captured. Omit a title already shown, unless it reflects an accepted Control that no queued or captured NFR reflects.
6. Emit 3 to 5 recommendations. Emit fewer when fewer are grounded. Go to `ask` when none are grounded.

Include **No system hosting** and **Direct purchase** in the first recommendation set. Omit one already queued, already shown, or already captured. They count toward the 3 to 5. Do not include them again in a later set. Do not ask a question in place of either limit.

When accepted material states who hosts the systems, or that the organization will not host them, use that material for **No system hosting**. Otherwise use the default below. When accepted material describes a buying process or a vendor requirement, use that material for **Direct purchase**. Otherwise use the default below.

**No system hosting:** Solutions are delivered as managed services the organization does not host or operate.

**Why it matters:** The owner runs the business and its technology.

**Direct purchase:** The owner buys the service directly from the vendor that operates it.

**Why it matters:** No proposal, approval board, or mandated vendor stands between the owner and the service.

A limit the person does not select is not queued and does not apply.

Each recommendation is a bold title, one sentence, and an indented **Why it matters:** line. Number every recommendation in the set, starting at 1. In the set, **No system hosting** and **Direct purchase** each show their title, statement, and **Why it matters:** line. Do not say which source produced it. Include a measurable bound in the sentence only when accepted evidence supports that bound.

An NFR that reflects one accepted Control has this rationale: **Enforces your Safeguard, [Control title],** by [how the expectation keeps that Control true]. An NFR that reflects more than one accepted Control has this rationale: **Enforces your Safeguards, [Control titles],** by [how the expectation keeps those Controls true]. Name two Controls as `[A] and [B]`. Name three or more as `[A], [B], and [C]`. Use each accepted Control title as written. Any other rationale is one line grounded in the accepted Profile and accepted Objectives.

When the queue is empty, emit:

Based on [Name]'s profile, accepted objectives, and accepted controls, here are recommended operational expectations that connect directly to [two or three accepted themes]:

1. **[Title]:** [One sentence.]

   **Why it matters:** [Rationale]

**Which of these operational expectations would you like to establish, or what would you like to focus on?**

You can select some, all or provide your own operational expectation.

If you'd like additional suggestions, just say so.

When the queue already has NFRs, emit:

Looking across [the uncovered area, in the person's terms] alongside your accepted profile, objectives, and controls, here are additional operational expectations tailored to [Name]:

1. **[Title]:** [One sentence.]

   **Why it matters:** [Rationale]

**Would you like to select any of these operational expectations, modify them, or are you ready to review the selected NFRs?**

You can select some, all or provide your own operational expectation.

If you'd like additional suggestions, just say so.

- `select-all`: add every title in the set to the queue, in displayed order. Go to `queue`.
- `select`: add the named titles to the queue. Go to `queue`.
- `own`: add the person's expectation to the queue. Go to `queue`.
- `edit`: emit one consequence sentence. Re-emit this set with the edit applied. Stay on `recommend`.
- `more`: go to `more`.
- `review-now`: go to `capture` of every queued NFR. When the queue is empty, stay on `recommend`.
- `question`: answer in one sentence. Re-emit this set. Stay on `recommend`.
- `unknown`: re-emit this set. Stay on `recommend`.

### more

Build the next set with the `recommend` rules. Omit every title in the set just shown. When at least one grounded recommendation remains, emit that set and stay on `recommend`.

When none remain, emit no bullets. Emit:

Additional suggestions at this stage would largely overlap or subdivide these operational expectations.

**Are you ready to review the selected NFRs?**

If you'd like to add another operational expectation first, just say so.

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

1. **[Title]:** [One sentence.]

   **Why it matters:** [Rationale]

**Which of these operational expectations would you like to establish, or what would you like to focus on?**

You can select some, all or provide your own operational expectation.

If you'd like additional suggestions, just say so.

Do not ask whether to explore more operational expectations. A number in the reply refers to the recommendation set, not the queue list.

- `select-all`: add every title in this new set to the queue. Emit `queue` again.
- `select`: add the named titles. Emit `queue` again.
- `own`: add the person's expectation. Emit `queue` again.
- `edit`: emit one consequence sentence. Re-emit the queue list and this set with the edit applied. Stay on `queue`.
- `more`: build another set that omits every title already shown. When one remains, emit it with the additional-recommendation intro above. Stay on `queue`.
- `review-now`: go to `capture` of every queued NFR. Do not add the unselected set.
- `question`: answer in one sentence. Re-emit the queue message. Stay on `queue`.
- `unknown`: re-emit the queue message. Stay on `queue`.

When no grounded non-duplicate recommendation remains, emit no recommendation bullets. After the queue list, emit:

Additional suggestions at this stage would largely overlap or subdivide these operational expectations.

**Are you ready to review the selected NFRs?**

If you'd like to add another operational expectation first, just say so.

- `review-now` or `accept`: go to `capture` of every queued NFR.
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

Develop every queued NFR in queue order. Emit them in one message. One queued NFR has no separator.

The title is the queued title unless the person changes it. The statement is one sentence stating how a solution must behave. Include a measurable bound only when accepted evidence supports it. The rationale is the **Why it matters:** line shown with that recommendation. Write the rationale of the person's own expectation with the `recommend` rationale rule. Keep a rationale the person edits as written.

**Here's what I've captured as your NFRs:**

1. **[Title]:** [Statement]

   **Why it matters:** [Rationale]

---

Number every NFR in the review, starting at 1, in queue order. Indent each NFR's rationale under its number. Put `---` between NFRs. Do not put `---` after the last NFR. A number in the reply refers to the NFR with that number in the review just shown.

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Apply the edit to the named NFR. An added NFR joins the set. A removed NFR leaves the set. Re-emit every NFR that remains. When none remain, go to `write` and do not show an empty review. Stay on `capture` when any remain.
- `accept`: hold each remaining title, statement, and rationale. Go to `identifier`, then `write`.
- `decline`: drop every queued NFR. Go to `write`. Do not show an empty review.
- `unknown`: re-emit this capture. Stay on `capture`.
- `question`: answer in one sentence. Re-emit this capture. Stay on `capture`.

Do not develop one NFR at a time. Do not emit a bridge.

## Verification

- "Looks good" on a recommendation set adds that set to the queue and does not start capture.
- A queue message lists the titles just added, then includes the next recommendation set when grounded recommendations remain.
- A queue message does not ask whether to explore more operational expectations.
- Capture starts when the person asks to review the queue.
- A capture shows every queued NFR in one message, with `---` between NFRs and one acceptance question.
- **No system hosting** and **Direct purchase** are recommendations. A limit the person does not select is not captured.
- Each recommendation shows its title, one sentence, and a **Why it matters:** line.
- An NFR that reflects accepted Controls has a rationale that opens with **Enforces your Safeguard, [Control title],** or **Enforces your Safeguards, [Control titles],** and continues with "by".
- A shown recommendation the person did not select does not reflect its Control. A later set offers that Control again.
- A rationale the person edits is kept as written.
- A capture does not accept NFRs one at a time.
