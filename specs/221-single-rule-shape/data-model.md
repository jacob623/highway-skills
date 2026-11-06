# Data Model: Single Rule Shape

## Rule

- Text: one condition, the word must once, and one outcome.
- Length: eight words or fewer. A path, a hyphenated word, and a placeholder each count as one word.
- A second outcome joined by and, or, or a comma is a separate rule. A slash inside a path is part of that one word.
- A rule that lacks must, passes eight words, or combines rules is rewritten before the proposal is presented.

## Suggestion

- A rule the model proposes from the documentation.
- An add has at most fifteen suggestions. An update keeps every conforming saved rule and adds at most fifteen further suggestions.
- The credentials rule is one suggestion. A storage way the documentation names is another. When no way is named, that suggestion is absent and the credentials rule names no product.
- A suggestion past fifteen is left out. A rule the person provided is not left out.

## Opening consequence sentence

- One sentence before the proposal.
- It names each rewrite and each suggestion left out by the fifteen-suggestion cap.
- On a remove it says the standard file remains and is no longer used.

## Why it matters

- One sentence under the rule on the proposal, after a blank line.
- It states the consequence of that rule. It names no customer, product, or decision of this organization.
- The saved standard, the catalog cell, and a conflict quote keep the rule only.

## Order

`standard rules` follows `rule shape`, writes the rules it returned, then returns to `standard proposal`. A remove does not run `standard rules`.
