# Feature Specification: Batch Objective Acceptance

**Feature Branch**: `189-batch-objective-acceptance`

**Created**: 2026-10-22

**Status**: Draft

**Input**: User description: "Update highway-objectives, replacing the iterative acceptance with a single acceptance of all items in the queue."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review the whole queue at once (Priority: P1)

A person who has selected objectives sees every queued objective in one review. Each objective shows its title and one sentence, its success measures, and why it matters. A line separates one objective from the next. The person accepts or corrects the set once.

**Why this priority**: Accepting objectives one at a time repeats the same stop for every title the person already chose. One review is the decision.

**Independent Test**: Queue three objectives and ask to review them. All three appear in one message, separated by a line, with one correction question at the bottom. No second objective is held back until the first is accepted.

**Acceptance Scenarios**:

1. **Given** two or more queued objectives, **When** the person asks to review them, **Then** every queued objective appears in that message, in queue order, with a line between objectives.
2. **Given** that review, **When** it is shown, **Then** each objective shows a bold title with one sentence, success measures on their own lines under that title, and a rationale on its own line after the measures.
3. **Given** that review, **When** it is shown, **Then** it opens with the captured-objectives heading and ends with one question asking what to add, correct, or remove, plus the reassurance that the person can say it is accurate.
4. **Given** one queued objective, **When** the person asks to review it, **Then** that objective uses the same shape and there is no separator line.

---

### User Story 2 - Accept once, then store the set (Priority: P2)

The person accepts the whole review once. Every objective still in the set is stored. They are not asked to accept each objective, and they are not asked to review the stored records.

**Why this priority**: The review is the acceptance. A second pass over the written records adds a stop after the decision is already made.

**Independent Test**: Accept a three-objective review without edits. All three are stored, the stored statement, success measures, and rationale match the review, and no further review prompt appears.

**Acceptance Scenarios**:

1. **Given** the full review, **When** the person says it is accurate, **Then** every objective in the set is stored and the person is not asked to accept another objective.
2. **Given** a stored objective, **When** it is read, **Then** its statement is the one sentence from the review, its success measures are the measures from the review, and its rationale is the "why it matters" line from the review.
3. **Given** a successful store, **When** the write finishes, **Then** the person sees no further prompt and is not shown the stored records for another review.
4. **Given** a correction to one objective, **When** the person describes that change, **Then** the whole set is shown again with that change applied, and acceptance still covers every objective that remains.

---

### Edge Cases

- The queue has one objective. The review shows that objective and the same single acceptance. No separator line is added.
- The person removes one objective while correcting the set. The revised review omits it, and acceptance stores only the objectives that remain.
- The person removes every objective before accepting. No objective from that set is stored, and they are not asked to accept an empty review.
- The person asks a question or gives a reply that does not accept or correct the set. The same full review is shown again.
- A title in the set conflicts with an existing objective title. The existing title-change prompt still happens before anything is stored, and the stored set uses the accepted title.
- Objectives already stored from an earlier run keep their current review. This change applies to accepting a queue, not to reopening stored objectives.
- Choosing recommendations and adding them to the queue stays as it is. The batch review starts when the person asks to review the selected objectives.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: When the person asks to review the selected objectives, Objectives MUST show every queued objective in one review, in queue order.
- **FR-002**: Each objective in that review MUST use this shape: a bold title with one sentence, then **Success looks like:** on its own line with the success measures beneath it, then a blank line, then **Why it matters:** and the rationale.
- **FR-003**: A line separator MUST appear between objectives. It MUST NOT appear after the last objective.
- **FR-004**: The review MUST open with **Here's what I've captured as your objectives:** and MUST close with **What would you add, correct, or remove?** and the reassurance that the person can say the review is accurate.
- **FR-005**: Objectives MUST NOT ask the person to accept objectives one at a time, and MUST NOT show a bridge into a next objective.
- **FR-006**: One acceptance MUST store every objective still in the set. The person MUST NOT be prompted to review the stored records.
- **FR-007**: After a successful store, Objectives MUST NOT add a closing statement about viewing the objectives later.
- **FR-008**: The stored statement MUST be the one sentence shown with the title. The stored success measures MUST be the measures shown under **Success looks like:**. The stored rationale MUST be the line shown with **Why it matters:**.
- **FR-009**: A correction MUST be applied to the named objective, the whole set MUST be shown again, and a later acceptance MUST cover the revised set.
- **FR-010**: Removing an objective during correction MUST leave it out of the stored set. Removing every objective MUST store none of that set.
- **FR-011**: A question or an unclear reply MUST show the same full review again.
- **FR-012**: Recommendation, queue building, and review of objectives already stored MUST stay as they are, except that asking to review the queue opens this single review.

### Key Entities *(include if feature involves data)*

- **Queued objective**: An outcome the person has selected and has not yet accepted in the batch review. It has a title.
- **Batch review**: One message containing every queued objective, a separator between objectives, and one acceptance question for the set.
- **Stored objective**: The record written from an accepted objective. Its statement, success measures, and rationale are the text the person accepted in the batch review.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A queue of 3 objectives is reviewed in 1 message, with 2 separators and 1 acceptance question.
- **SC-002**: Accepting that review stores all 3 objectives and produces 0 further acceptance prompts.
- **SC-003**: For each stored objective, the statement, success measures, and rationale match the review text with no added claim.
- **SC-004**: A correction to 1 objective redisplays all remaining objectives before any of them are stored.
- **SC-005**: A person who only wants to reopen objectives stored earlier still sees the existing stored-objective review.

## Assumptions

- The one sentence beside the title is the objective statement. It is the same sentence style already used when an outcome is recommended.
- Each objective shows at least one observable success measure. More than one measure is allowed when the accepted profile supports it. Measures are bullets under **Success looks like:**.
- The rationale is one line grounded in the accepted profile, shown as **Why it matters:** [Rationale].
- The separator between objectives is a markdown horizontal rule.
- Acceptance wording stays "If this is accurate, just say so."
- "Looks good" on the batch review accepts the whole set.
- Title conflicts are still resolved before the set is stored, using the current title-change prompt.
- The stored record keeps its current sections: statement, success measures, and rationale. This change fills those sections from the batch review.
- Setup still receives completion after a successful store, and the person does not see that internal completion word.
- No closing line is added after the store. The earlier idea of telling the person they can ask to see their objectives later is out of scope.
