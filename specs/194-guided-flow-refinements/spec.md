# Feature Specification: Guided Flow Refinements

**Feature Branch**: `194-guided-flow-refinements`

**Created**: 2026-10-24

**Status**: Draft

**Input**: User description: "Bold the Profile starting-point labels with a new line after each. Present Objectives, Controls, and NFRs recommendations as an ordered list, replace the closing prompt, and add a line after the ready-to-review question. Derive NFR recommendations primarily from Controls, with at least a 1:1 mapping of Controls to NFRs."

## Clarifications

### Session 2026-10-24

- Q: When the queue already has items, should the extra recommendation set's "If none of these fit…" line be updated too? → A: Yes. Replace that line with the two new lines and keep that set's own question, shown first.
- Q: Once every accepted Control is reflected, may later NFR sets suggest expectations grounded only in Profile, Objectives, or an uncovered area? → A: Yes. Control-derived recommendations come first. After every accepted Control is reflected, grounded Profile, Objectives, or uncovered-area expectations may follow.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Read Profile starting points clearly (Priority: P1)

A person reviewing a Profile starting point sees each label in bold, with its content on the next line, so the label and its content do not run together.

**Why this priority**: The labels and their content currently render on one line, which makes each starting point harder to scan.

**Independent Test**: Run Profile. Each Vision and Competitive Path label, and each Guiding Principles name, appears in bold, with its content on its own line beneath it.

**Acceptance Scenarios**:

1. **Given** the Vision starting point, **When** it is shown, **Then** **Future Direction**, **Desired Impact**, and **Future State** are bold, and each one's content starts on the next line.
2. **Given** the Competitive Path and Guiding Principles starting points, **When** they are shown, **Then** each label is bold and its content starts on the next line.

---

### User Story 2 - Choose recommendations from a numbered list (Priority: P1)

A person reviewing Objectives, Controls, or NFRs recommendations sees them numbered. The closing prompt asks the question first, then says they can select some, all, or their own, and that they can ask for more suggestions.

**Why this priority**: Numbered recommendations are easier to refer to, and the new closing copy states every option the person has.

**Independent Test**: Run Objectives, Controls, and NFRs. Each recommendation set is a numbered list, and each closing prompt matches the copy in FR-005.

**Acceptance Scenarios**:

1. **Given** a recommendation set, **When** it is shown, **Then** each recommendation is a numbered item with a bold title and one sentence.
2. **Given** the first recommendation set, **When** it closes, **Then** it shows the skill's question, then "You can select some, all or provide your own …", then "If you'd like additional suggestions, just say so."
3. **Given** a numbered set, **When** the person answers with numbers, **Then** those recommendations are selected.

---

### User Story 3 - Add one more item before review (Priority: P2)

When no further recommendations remain, the ready-to-review question is followed by a line telling the person they can still add their own item first.

**Why this priority**: The person may want to add one more item and should not have to guess that they can.

**Independent Test**: Exhaust the recommendations in each skill. The ready-to-review question is followed by that skill's add-another line from FR-006.

**Acceptance Scenarios**:

1. **Given** no grounded recommendation remains, **When** the ready-to-review question is shown, **Then** the skill's add-another line follows it.
2. **Given** that line, **When** the person supplies their own item, **Then** it is added to the queue as today.

---

### User Story 4 - NFRs that follow from Controls (Priority: P2)

A person reaching NFRs sees operational expectations that come mainly from their accepted Controls. Profile and Objectives refine scope, priority, and wording. Every accepted Control is reflected by at least one recommended NFR.

**Why this priority**: Controls state what must remain true. NFRs state how solutions behave to keep it true. Recommendations that do not trace to Controls leave safeguards without an operational expectation.

**Independent Test**: With accepted Controls, run NFRs and continue through the recommendation sets. Each accepted Control is reflected by at least one recommended NFR.

**Acceptance Scenarios**:

1. **Given** accepted Controls not yet reflected, **When** NFR recommendations are built, **Then** each recommendation comes from at least one accepted Control, except **No system hosting** and **Direct purchase**.
2. **Given** accepted Controls, **When** the person continues through the recommendation sets, **Then** each accepted Control is reflected by at least one recommendation. Each set keeps the 3 to 5 limit. A Control not yet reflected carries into the next set.
3. **Given** accepted Profile and Objectives, **When** a recommendation is worded, **Then** they shape its scope, priority, and wording.
4. **Given** every accepted Control is reflected, **When** a later set is built, **Then** it may include expectations grounded in the accepted Profile or Objectives, or in an uncovered area that would reasonably benefit the organization.

---

### Edge Cases

- A queue message shows the numbered queue list and a numbered recommendation set together. A number in the reply refers to the recommendation set, not the queue list.
- **No system hosting** and **Direct purchase** appear as numbered items in the first NFR set, each a bold title and one sentence like every other recommendation, and still count toward the set's limit. Their rationale is used when they are captured.
- When no Controls are accepted, NFRs keep today's path to `ask`.
- A Control already reflected by a queued, shown, or captured NFR does not need another recommendation.
- Profile's Guiding Principles labels are the inferred principle names. Each is bolded the same way.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Vision starting point MUST show **Future Direction**, **Desired Impact**, and **Future State** in bold, each with its content on the next line.
- **FR-002**: The same formatting MUST apply to the Competitive Path labels (**Primary Approach**, **Strategic Advantage**, **Important Tradeoff**) and to each Guiding Principles principle name.
- **FR-003**: Objectives, Controls, and NFRs MUST show every recommendation set as a numbered list. Each item is a bold title and one sentence.
- **FR-004**: A reply that names numbers MUST select the recommendations with those numbers in the current set.
- **FR-005**: Wherever a set closes with the skill's "If none of these fit…" line followed by its question, that pair MUST be replaced with the copy below:

  Objectives:

  ```markdown
  **Which of these outcomes would you like to pursue, or what would you like to focus on?**

  You can select some, all or provide your own outcome.

  If you'd like additional suggestions, just say so.
  ```

  Controls:

  ```markdown
  **Which of these safeguards would you like to establish, or what would you like to focus on?**

  You can select some, all or provide your own safeguards.

  If you'd like additional suggestions, just say so.
  ```

  NFRs:

  ```markdown
  **Which of these operational expectations would you like to establish, or what would you like to focus on?**

  You can select some, all or provide your own operational expectation.

  If you'd like additional suggestions, just say so.
  ```

- **FR-005a**: The set shown when the queue already has items MUST drop its "If none of these fit, feel free to suggest your own … If you'd like additional suggestions, just let me know." line. It MUST show its own question first, unchanged, then the skill's "You can select some, all or provide your own …" line from FR-005, then "If you'd like additional suggestions, just say so."
- **FR-006**: Wherever the skill emits its ready-to-review question after recommendations run out, the matching line MUST follow it:
  - Objectives: after **Are you ready to review the selected objectives?**, add: If you'd like to add another outcome first, just say so.
  - Controls: after **Are you ready to review the selected Controls?**, add: If you'd like to add another safeguard first, just say so.
  - NFRs: after **Are you ready to review the selected NFRs?**, add: If you'd like to add another operational expectation first, just say so.
- **FR-007**: NFR recommendations MUST be derived primarily from accepted Controls. Accepted Profile and Objectives MUST refine scope, priority, and wording.
- **FR-008**: Each accepted Control MUST be reflected by at least one recommended NFR, in addition to the two static limits. Each set keeps the 3 to 5 limit. A Control not yet reflected by a queued, shown, or captured NFR carries into the next set, and recommendations stay available until every accepted Control is reflected.
- **FR-008a**: Until every accepted Control is reflected, each set MUST contain only Control-derived recommendations, plus the two static limits in the first set. After every accepted Control is reflected, a set MAY include expectations grounded in the accepted Profile or Objectives, or in an uncovered area that would reasonably benefit the organization.
- **FR-009**: The batch review, capture, write, and stored-review formats MUST stay unchanged.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of Profile starting-point labels named in FR-001 and FR-002 appear bold, with content on the following line.
- **SC-002**: 100% of recommendation sets in Objectives, Controls, and NFRs are numbered.
- **SC-003**: 0 occurrences of "If none of these fit, feel free to suggest your own …" remain in Objectives, Controls, or NFRs.
- **SC-004**: Each ready-to-review question shown after recommendations run out is followed by its add-another line, every time.
- **SC-005**: With N accepted Controls, the recommended NFRs reflect all N Controls.

## Assumptions

- The requested Mission labels correspond to Competitive Path, and the requested Values label corresponds to Guiding Principles. Profile's starting points keep their current names.
- "Add a new line after each" means the label is on its own line and the content starts on the next line, rather than running into the label.
- The closing-prompt replacement applies to every place the replaced pair appears in each skill: the first set when the queue is empty, and the additional set shown with the queue.
- The add-another line follows the ready-to-review question in both places that question appears: the `more` exhaustion message and the queue message when recommendations run out.
- "operational expection" in the supplied NFR copy is a typo for "operational expectation".
- "Ideally, at least a 1:1 mapping" is treated as a requirement that every accepted Control is reflected. One NFR may reflect more than one Control.
