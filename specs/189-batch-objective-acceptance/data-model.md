# Data Model: Batch Objective Acceptance

## Queued objective

An outcome the person selected and has not yet accepted in the batch review.

| Field | Rule |
|---|---|
| Title | The queued title, unless the person changes it |
| Order | Queue order |

A queued objective is not a stored record.

## Batch review

One message for every queued objective.

| Field | Rule |
|---|---|
| Heading | **Here's what I've captured as your objectives:** |
| Objective block | Bold title and one sentence, then **Success looks like:** and its measures, then **Why it matters:** and one rationale line |
| Separator | A horizontal rule between blocks, never after the last block |
| Question | **What would you add, correct, or remove?** followed by the reassurance that the person can say the review is accurate |
| Acceptance | One reply accepts every objective still in the set |

An edit, addition, or removal replaces the set and shows the review again. Nothing is stored during that redraw.

## Stored objective

The record written from an accepted block. The record template is unchanged.

| Field | Source |
|---|---|
| Title | Accepted title |
| Statement | The one sentence shown with the title |
| Success measures | The bullets shown under **Success looks like:** |
| Rationale | The line shown with **Why it matters:** |
| Status | Active, as the current write requires |

The catalog is written with the records, once. An empty remaining set writes no objective from that review.

## State

1. Queue holds titles.
2. Review shows the whole queue.
3. Correction returns to review with the revised set.
4. Acceptance stores the remaining set.
5. A later request to see stored objectives uses the existing catalog review, which this feature does not change.
