# Wording Contract: highway-nfrs

## `recommend` rule 1

Replaced:

`1. Derive each recommendation from an accepted Control that no queued, shown, or captured NFR reflects yet. Use the accepted Profile and accepted Objectives to refine its scope, priority, and wording. One NFR may reflect more than one Control.`

New:

`1. Derive each recommendation from an accepted Control that no queued or captured NFR reflects yet. A shown recommendation the person did not select does not reflect its Control. Use the accepted Profile and accepted Objectives to refine its scope, priority, and wording. One NFR may reflect more than one Control.`

## `recommend` rule 5

Replaced: `5. Omit a title already queued, already shown, or already captured.`

New: `5. Omit a title already queued or already captured. Omit a title already shown, unless it reflects an accepted Control that no queued or captured NFR reflects.`

## `recommend` set lines

Replaced: `Each recommendation is a bold title and one sentence.`

New: `Each recommendation is a bold title, one sentence, and an indented **Why it matters:** line.`

Replaced: `In the set, **No system hosting** and **Direct purchase** each show their title and statement.`

New: `In the set, **No system hosting** and **Direct purchase** each show their title, statement, and **Why it matters:** line.`

New paragraph after those lines:

```text
An NFR that reflects one accepted Control has this rationale: **Enforces your Safeguard, [Control title],** by [how the expectation keeps that Control true]. An NFR that reflects more than one accepted Control has this rationale: **Enforces your Safeguards, [Control titles],** by [how the expectation keeps those Controls true]. Name two Controls as `[A] and [B]`. Name three or more as `[A], [B], and [C]`. Use each accepted Control title as written. Any other rationale is one line grounded in the accepted Profile and accepted Objectives.
```

## Set templates (`recommend` twice, `queue` once)

After each `1. **[Title]:** [One sentence.]`, add a blank line and:

`   **Why it matters:** [Rationale]`

## `more`

New sentence after `Build the next set with the `recommend` rules.`: `Omit every title in the set just shown.`

## `capture`

Replaced: `The rationale is one line grounded in the accepted Profile, accepted Objectives, and accepted Controls.`

New: `The rationale is the **Why it matters:** line shown with that recommendation. Write the rationale of the person's own expectation with the `recommend` rationale rule. Keep a rationale the person edits as written.`

## `review` edit

After `An added expectation becomes a new record.`, add: `Write its rationale with the `recommend` rationale rule.`

## `write`

Replaced: `` `controls` lists the accepted Control ids that influenced this expectation. Use `[]` when none did. ``

New: `` `controls` lists the accepted Control ids that influenced this expectation, including every Control its rationale names. Use `[]` when none did. ``

## Verification (new lines)

- `Each recommendation shows its title, one sentence, and a **Why it matters:** line.`
- `An NFR that reflects accepted Controls has a rationale that opens with **Enforces your Safeguard, [Control title],** or **Enforces your Safeguards, [Control titles],** and continues with "by".`
- `A shown recommendation the person did not select does not reflect its Control. A later set offers that Control again.`
- `A rationale the person edits is kept as written.`

## Version

`version: 9.0.0` becomes `version: 9.1.0`.
