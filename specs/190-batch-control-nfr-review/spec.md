# Feature Specification: Batch Control and NFR Review

**Feature Branch**: `190-batch-control-nfr-review`

**Created**: 2026-10-22

**Status**: Draft

**Input**: User description: "Update highway-controls and highway-nfrs review to utilize the batch review implemented for highway-objectives."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review the whole queue at once (Priority: P1)

A person who has selected Controls, or who has selected NFRs, sees every queued item in one review. Each item shows its title and statement, then why it matters. A line separates one item from the next. The person accepts or corrects the set once.

**Why this priority**: Controls and NFRs still stop once per item after the person has already chosen the titles. Objectives already reviews the whole queue in one step.

**Independent Test**: Queue three Controls and ask to review them. All three appear in one message, separated by a line, with one correction question. Repeat with three NFRs. Neither skill holds the second item back until the first is accepted.

**Acceptance Scenarios**:

1. **Given** two or more queued Controls, **When** the person asks to review them, **Then** every queued Control appears in that message, in queue order, with a line between Controls.
2. **Given** two or more queued NFRs, **When** the person asks to review them, **Then** every queued NFR appears in that message, in queue order, with a line between NFRs.
3. **Given** either review, **When** it is shown, **Then** each item shows a bold title with its statement, then **Why it matters:** and the rationale on that same line.
4. **Given** a Control review, **When** it is shown, **Then** it opens with **Here's what I've captured as your controls:** and ends with one question asking what to add, correct, or remove.
5. **Given** an NFR review, **When** it is shown, **Then** it opens with **Here's what I've captured as your NFRs:** and ends with the same question.
6. **Given** one queued Control or one queued NFR, **When** the person asks to review it, **Then** that item uses the same shape and there is no separator line.

---

### User Story 2 - Accept once, then store the set (Priority: P2)

The person accepts the whole Control review once, or the whole NFR review once. Every item still in the set is stored. They are not asked to accept each item, and they are not asked to review the stored records.

**Why this priority**: The review is the acceptance. A second pass over the written records adds a stop after the decision is already made.

**Independent Test**: Accept a three-Control review without edits. All three are stored, the stored statement and rationale match the review, and no further review prompt appears. The same is true for three NFRs.

**Acceptance Scenarios**:

1. **Given** the full Control review, **When** the person says it is accurate, **Then** every Control in the set is stored and the person is not asked to accept another Control.
2. **Given** the full NFR review, **When** the person says it is accurate, **Then** every NFR in the set is stored and the person is not asked to accept another NFR.
3. **Given** a stored Control or NFR, **When** it is read, **Then** its statement is the statement from the review and its rationale is the "why it matters" line from the review.
4. **Given** a successful store, **When** the write finishes, **Then** the person sees no further prompt and is not shown the stored records for another review.
5. **Given** a correction to one Control or one NFR, **When** the person describes that change, **Then** the whole set is shown again with that change applied, and acceptance still covers every item that remains.

---

### User Story 3 - Reopen stored records in the same shape (Priority: P3)

When Controls or NFRs are already stored, opening them shows the same card used in the queue review. The person still accepts or corrects that existing set once.

**Why this priority**: Objectives uses one card for the queue and for records already stored. Controls and NFRs should match that review.

**Independent Test**: Open a catalog that already has two active Controls. Both use the title-and-statement line, the why-it-matters line, and a separator between them, followed by one correction question. Repeat for two active NFRs.

**Acceptance Scenarios**:

1. **Given** stored active Controls, **When** Controls opens, **Then** each active Control uses the batch card, with a line between Controls and one correction question for the set.
2. **Given** stored active NFRs, **When** NFRs opens, **Then** each active NFR uses the batch card, with a line between NFRs and one correction question for the set.
3. **Given** that stored review, **When** the person says it is accurate, **Then** the review finishes and the person is not shown the records again.

---

### Edge Cases

- The queue has one Control or one NFR. The review shows that item and the same single acceptance. No separator line is added.
- The person removes one item while correcting the set. The revised review omits it, and acceptance stores only the items that remain.
- The person removes every item before accepting. No item from that set is stored, and they are not asked to accept an empty review.
- The person asks a question or gives a reply that does not accept or correct the set. The same full review is shown again.
- A title in the set conflicts with an existing title. The existing title-change prompt still happens before anything is stored, and the stored set uses the accepted title.
- An NFR has no accepted evidence for a measurable bound. Its statement does not invent one.
- A stored catalog has no active Controls, or no active NFRs. The person sees the current empty message for that catalog.
- Choosing recommendations and adding them to the queue stays as it is. The batch review starts when the person asks to review the selected items.
- Objectives is unchanged.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: When the person asks to review the selected Controls, Controls MUST show every queued Control in one review, in queue order.
- **FR-002**: When the person asks to review the selected NFRs, NFRs MUST show every queued NFR in one review, in queue order.
- **FR-003**: Each Control and each NFR in a review MUST use this shape: a bold title with its statement, then **Why it matters:** and the rationale on the same line.
- **FR-004**: A review MUST NOT include a success-measures block.
- **FR-005**: A line separator MUST appear between items. It MUST NOT appear after the last item.
- **FR-006**: The Control review MUST open with **Here's what I've captured as your controls:**. The NFR review MUST open with **Here's what I've captured as your NFRs:**.
- **FR-007**: Each review MUST close with **What would you add, correct, or remove?** and the reassurance that the person can say the review is accurate.
- **FR-008**: Controls and NFRs MUST NOT ask the person to accept items one at a time, and MUST NOT show a bridge into a next item.
- **FR-009**: One acceptance MUST store every item still in the set. The person MUST NOT be prompted to review the stored records.
- **FR-010**: The stored statement MUST be the statement shown with the title. The stored rationale MUST be the line shown with **Why it matters:**.
- **FR-011**: A Control statement MUST say what must remain true. An NFR statement MUST say how a solution must behave, and MUST include a measurable bound only when accepted evidence supports that bound.
- **FR-012**: A correction MUST be applied to the named item, the whole set MUST be shown again, and a later acceptance MUST cover the revised set.
- **FR-013**: Removing an item during correction MUST leave it out of the stored set. Removing every item MUST store none of that set.
- **FR-014**: A question or an unclear reply MUST show the same full review again.
- **FR-015**: Opening stored active Controls, or stored active NFRs, MUST show those records in the same card, with a separator between records and one correction question.
- **FR-016**: Recommendation and queue building MUST stay as they are, except that asking to review the queue opens this single review.
- **FR-017**: Objectives MUST remain unchanged.

### Key Entities *(include if feature involves data)*

- **Queued Control**: A safeguard the person has selected and has not yet accepted in the batch review. It has a title.
- **Queued NFR**: An operational expectation the person has selected and has not yet accepted in the batch review. It has a title.
- **Batch review**: One message containing every queued item, a separator between items, and one acceptance question for the set.
- **Stored Control or NFR**: The record written from an accepted item. Its statement and rationale are the text the person accepted.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A queue of 3 Controls is reviewed in 1 message, with 2 separators and 1 acceptance question. A queue of 3 NFRs meets the same count.
- **SC-002**: Accepting either review stores all 3 items and produces 0 further acceptance prompts.
- **SC-003**: For each stored item, the statement and rationale match the review text, and the review contains 0 success-measures blocks.
- **SC-004**: A correction to 1 item redisplays all remaining items before any of them are stored.
- **SC-005**: Opening 2 stored active Controls, or 2 stored active NFRs, shows both in the batch card with 1 separator and 1 correction question.

## Assumptions

- The statement beside the title is one sentence. A Control sentence says what must remain true. An NFR sentence says how a solution must behave.
- The rationale is one line, shown as **Why it matters:** [Rationale].
- The separator between items is a markdown horizontal rule.
- Acceptance wording stays "If this is accurate, just say so."
- "Looks good" on the batch review accepts the whole set.
- Title conflicts are still resolved before the set is stored, using the current title-change prompt.
- The stored record keeps its current sections: statement and rationale. This change fills those sections from the batch review.
- Removed catalog rows stay omitted from the stored review. An empty active catalog keeps its current empty message.
- Setup still receives completion after a successful store, and the person does not see that internal completion word.
- No closing line is added after the store.
