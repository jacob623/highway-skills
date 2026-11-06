# Data Model: Standard Starting Point

## Standard starting-point line

- Text: `**Here is a proposed starting point for the [Language or platform] coding standards**`
- Value: [Language or platform] is the proposal's **Technology:** value.
- Shown: an add or update with no edit yet, including a re-show after `question` or `unknown`.
- Hidden: after an `edit`, and on a remove.

## Reply class order

`edit`, `decline`, `question`, `select`, `unknown`, `accept`. The first match wins. "looks good" on a proposal is `accept`.

## Carried platform name

- Source: Entry step 3.
- Handled by: `platforms` step 1, using the name bullets.
- Outcomes: update proposal after `current`, add proposal after `current`, or the onboard question.
- List: hidden until an onboard `decline`.

## Step order

`Entry`, `Classify`, `menu`, `platforms`, `current`, `use entries`, `platform proposal`, `platform written`, `standards`, `standard rules`, `standard proposal`, `standard write`, `conflicts`, `resolve`.

## Standard add or update flow

`standards` → `current` → `standard proposal` (follows `standard rules`, then `use entries`) → fill → assess conflicts → emit → `accept` → `standard write`.
