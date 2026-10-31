# Contract: Suggestion List

## When the list appears

The list appears after an accepted implementation is selected and the invocation names no action. It appears once, before any proposal.

When the invocation already names one action, the list is not shown. The proposal opens on that action.

## What is shown

The list opens with this bold line:

**Based on the current state of this implementation, these may be worth visiting:**

Each item is numbered from 1.

1. **[Title]:**

   [One-sentence summary.]

The list contains at most five items. It does not use an id as a label.

Then:

**Would you like to explore any of these options?**

You can also provide your own.

## Order

Establishing suggestions are those whose title contains `establish`. All others run, change, or recover. The kind that fits the current state comes first. Within a kind, the order is the order of Realized Capabilities. A missing leading kind adds `Establish [implementation title]` or `Run [implementation title]`. Items past five are dropped from the end.

An empty list says no suggestion is grounded and that the person can provide their own. Nothing is written.

## Replies

| Reply | Result |
|---|---|
| Number, title, or summary on the list | That one suggestion. Go to the proposal |
| The person's own automation | That automation, even if they also name a listed item |
| Two actions | Keep one. Say the other waits for another run |
| A number that is not on the list | Ask again. Write nothing |
| Decline | Stop. Write nothing |
