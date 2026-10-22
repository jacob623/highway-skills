# Research: Batch Objective Acceptance

## Decision: Replace per-objective capture with one review of the queue

- **Decision**: `capture` emits every queued objective in queue order, then one correction question. `review-now` enters that review instead of the first objective. The bridge "Next we'll develop **[next title]**." is deleted. Acceptance holds every objective still in the set and goes to `identifier`, then `write`.
- **Rationale**: The person already selected the titles. A second stop per title repeats the same decision. The spec requires one message and one acceptance.
- **Alternatives considered**: Keeping a per-objective confirmation after the batch summary was rejected. The review is the acceptance.

## Decision: Use the compact objective shape, including rationale

- **Decision**: Each objective is a bold title with one sentence, then **Success looks like:** on its own line with the measures beneath it, then a blank line, then **Why it matters:** and one rationale line. A markdown horizontal rule separates objectives and does not follow the last one. The review opens with **Here's what I've captured as your objectives:**.
- **Rationale**: That is the shape agreed for the queue review. The one sentence is the statement. The rationale is visible, so the stored rationale is text the person accepted.
- **Alternatives considered**: Omitting the rationale was rejected after it was added back to the review. A paragraph statement and a paragraph rationale were rejected because they are the current one-at-a-time capture.

## Decision: Keep the current record template and the stored-objective review

- **Decision**: `write` still fills `## Statement`, `## Success Measures`, and `## Rationale` in `.highway/library/templates/output/objective-record.md`. The statement is the one sentence, the measures are the shown bullets, and the rationale is the shown line. The `review` section for an existing catalog is not rewritten.
- **Rationale**: The spec stores the accepted review text in the current record sections and leaves reopening stored objectives unchanged. Leaving the template unchanged avoids a shared-template review of every skill that cites it.
- **Alternatives considered**: Showing the written files after acceptance was rejected. Adding a line that tells the person they can ask to see their objectives later was rejected.

## Decision: Corrections redraw the whole set before anything is stored

- **Decision**: An edit to a named objective, an added outcome, or a removed objective redraws every objective that remains, with the same heading, separators, and question. Removing the last objective does not show an empty review. It follows the current empty held-set write, which applies only because this path runs when no catalog exists yet. A question or an unclear reply redraws the same set. `decline` drops the whole set and uses that empty write. A title conflict still uses the current title prompt before any record is written.
- **Rationale**: The correction question already invites an addition, a correction, or a removal. Storage waits until one acceptance of the remaining set. The first-run path is the only path that reaches this review.
- **Alternatives considered**: Accepting one corrected objective and continuing through the rest one at a time was rejected. Returning an added outcome to the recommendation queue was rejected because the person is already in the review.
