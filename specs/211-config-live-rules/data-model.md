# Data Model: Current Proposal Rules

No new saved artifact. The catalogs keep the fields they have. Why it matters is proposal text and is dropped on write.

## Current check

Read before a platform add or update, and before a coding standard add or update. Not read for a removal.

| Outcome | What the proposal may claim |
|---|---|
| Documentation read | A capability it describes. For a platform, only when the accepted implementation realizes it |
| Documentation read | Nothing it no longer describes |
| Documentation not read | Nothing added as current. Say `The current documentation could not be read.` Continue from the accepted implementation and the catalogs already present |

The check writes nothing.

## Use rule

One When to use entry or one When not to use entry.

- One sentence. It names a condition and the required outcome.
- It does not say should, consider, prefer, usually, or where appropriate.
- The next proposal line is `**Why it matters:**` and one sentence.
- The saved cell, the catalog view, and a conflict quote keep the sentence only. Lists stay joined with `; `.

## Must rule

One numbered rule in a coding standard proposal and in the standard file written from `coding-standard.md`.

- Contains the word must.
- Names a condition and the required outcome.
- At most ten rules.
- One of them keeps encoded or encrypted credentials outside the files that standard covers. When the documentation names a supported way to encrypt or store them, the rule requires that way. When it names none, the rule names no product. The rule appears once.

When the current file has ten rules and lacks the credential rule, the proposal leaves out the last rule the documentation no longer describes, or the last rule when every current rule is still described, and names that omitted rule in Consequences.

## After a coding standard write

| Proposal conflicts | Next |
|---|---|
| None | One sentence stating the consequence of the accepted change, then `menu` |
| One or more | `**Would you like help resolving these conflicts?**` An accept goes to `conflicts` |

A failed write stays on the proposal. A platform write keeps its current follow-up.
