# Research: Batch Control and NFR Review

## Decision: Replace per-item capture with one review of the queue

- **Decision**: `capture` in Controls and in NFRs emits every queued item in queue order, then one correction question. `review-now` enters that review instead of the first item. The bridge "Next we'll develop **[next title]**." is deleted in both skills. Acceptance holds every item still in the set and goes to `identifier`, then `write`.
- **Rationale**: The person already selected the titles. Objectives already reviews a queue once. The spec requires the same step for Controls and for NFRs.
- **Alternatives considered**: Keeping a per-item confirmation after a summary was rejected. The review is the acceptance.

## Decision: Use the title line and the rationale line, with no success measures

- **Decision**: Each item is a bold title with its statement, then **Why it matters:** and one rationale line. A markdown horizontal rule separates items and does not follow the last one. Controls opens with **Here's what I've captured as your controls:**. NFRs opens with **Here's what I've captured as your NFRs:**. Neither review includes **Success looks like:**.
- **Rationale**: Controls and NFRs store a statement and a rationale. They do not store success measures. The agreed card keeps those two fields and leaves the Objectives success block out.
- **Alternatives considered**: Copying the Objectives success-measures block was rejected. Keeping the statement under its own label was rejected because the title line carries the statement.

## Decision: Use the same card for stored active records

- **Decision**: The stored-record `review` in each skill emits the same card for every active record, with the separator between records and one correction question. Removed rows stay omitted. The current empty messages stay.
- **Rationale**: Objectives uses one card for the queue and for records already stored. The spec requires that match.
- **Alternatives considered**: Leaving the stored review on separate Title and Statement labels was rejected.

## Decision: Keep the current record templates and Objectives

- **Decision**: `write` still fills the statement and rationale sections of the current Control and NFR record templates. The statement is the text shown with the title. The rationale is the shown line. A Control statement says what must remain true. An NFR statement says how a solution must behave and includes a measurable bound only when accepted evidence supports it. `.highway/skills/highway-objectives/SKILL.md` is not edited.
- **Rationale**: The spec stores the accepted review text in the current record sections and leaves Objectives unchanged. Leaving the templates unchanged avoids a shared-template review of every skill that cites them.
- **Alternatives considered**: Showing the written files after acceptance was rejected. Adding a closing line after the write was rejected.

## Decision: Corrections redraw the whole set before anything is stored

- **Decision**: An edit to a named item, an added item, or a removed item redraws every item that remains. Removing the last item does not show an empty review and follows the current empty held-set write. A question or an unclear reply redraws the same set. `decline` drops the whole set. A title conflict still uses the current title prompt before any record is written.
- **Rationale**: The correction question invites an addition, a correction, or a removal. Storage waits until one acceptance of the remaining set.
- **Alternatives considered**: Accepting one corrected item and continuing through the rest one at a time was rejected.

## Decision: Replace the singular Control heading assertion

- **Decision**: `.highway/tools/tests/output-template.test.sh` stops requiring **Here's what I've captured as your Control:** and a separate `Statement:` label. It requires the plural heading and **Why it matters:**. A new contract check covers both skills, including the absence of the one-at-a-time heading, the bridge, and a success-measures block. The superseded heading is named in `specs/190-batch-control-nfr-review/retirements.md`.
- **Rationale**: D3.3 requires a test change for the new behavior. D3.5 requires the removed assertion to name what it no longer enforces.
- **Alternatives considered**: Leaving the singular heading assertion in place was rejected because the new review would fail it.
