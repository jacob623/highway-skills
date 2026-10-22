# Data Model: Batch Control and NFR Review

## Queued item

A Control or an NFR the person selected and has not yet accepted in the batch review.

| Field | Rule |
|---|---|
| Title | The queued title, unless the person changes it |
| Order | Queue order |
| Kind | Control or NFR. The two queues are separate |

A queued item is not a stored record.

## Batch review

One message for every queued item of one kind.

| Field | Rule |
|---|---|
| Heading | **Here's what I've captured as your controls:** or **Here's what I've captured as your NFRs:** |
| Item block | Bold title and statement, then **Why it matters:** and one rationale line |
| Separator | A horizontal rule between blocks, never after the last block |
| Question | **What would you add, correct, or remove?** followed by the reassurance that the person can say the review is accurate |
| Acceptance | One reply accepts every item still in the set |

An edit, addition, or removal replaces the set and shows the review again. Nothing is stored during that redraw. The review has no success-measures block.

## Stored record

The record written from an accepted block. The record template is unchanged.

| Field | Source |
|---|---|
| Title | Accepted title |
| Statement | The statement shown with the title |
| Rationale | The line shown with **Why it matters:** |
| Status | Active, as the current write requires |

A Control statement says what must remain true. An NFR statement says how a solution must behave. A measurable bound appears only when accepted evidence supports it.

The catalog is written with the records, once. An empty remaining set writes no record from that review.

## Stored review

Opening active stored records uses the same item block and separator. Removed rows are omitted. An empty active catalog keeps its current empty message.

## State

1. Queue holds titles.
2. Review shows the whole queue.
3. Correction returns to review with the revised set.
4. Acceptance stores the remaining set.
5. A later opening of stored records uses the same card.
