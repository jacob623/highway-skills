# Feature Specification: Review Presentation Refinements

**Feature Branch**: `196-review-presentation-refinements`

**Created**: 2026-10-29

**Status**: Draft

**Input**: User description: "Present captured objectives, controls, and NFRs as ordered lists. Shorten the AI-Assisted Engineering and Planning description in onboarding. In assessment, give each listed finding a title, rename Complexity to Solution Complexity, and let the person dismiss findings from the list and from a finding's details. In request, merge the starting point and the capture into one step in the capture format, show Solution Constraints with readable names, and show none instead of unknown."

## Clarifications

### Session 2026-10-29

- Q: In the numbered capture reviews for objectives, controls, and NFRs, should the `---` line between items stay? → A: Keep `---` between numbered items, as today.
- Q: When the person says "none" for a Solution Constraints field, what should the request record store? → A: Existing Platforms Required, Existing Platforms Preferred, and Known Systems store an empty list `[]`. Allowed Solution Classes and the four restriction fields store `unknown`.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Refer to a captured item by number (Priority: P2)

A person reviewing captured objectives, controls, or NFRs sees them as a numbered list, so they can name one by its number.

**Why this priority**: Recommendations are already numbered. The capture review is not, so the person has to repeat a title to correct one item.

**Independent Test**: Capture two objectives, two controls, and two NFRs. Each capture review shows the items numbered 1 and 2, with each item's details under its number.

**Acceptance Scenarios**:

1. **Given** two or more queued objectives, **When** the capture review is shown, **Then** each objective is a numbered item, starting at 1, in queue order.
2. **Given** two or more queued controls, **When** the capture review is shown, **Then** each control is a numbered item, starting at 1.
3. **Given** two or more queued NFRs, **When** the capture review is shown, **Then** each NFR is a numbered item, starting at 1.
4. **Given** a capture review, **When** the person corrects an item by its number, **Then** that item is the one changed.

---

### User Story 2 - Read a shorter AI-assisted capability description (Priority: P3)

A person reviewing onboarding capabilities sees a shorter description for AI-Assisted Engineering and Planning.

**Why this priority**: A wording change with no change to flow.

**Independent Test**: Start onboarding. The AI-Assisted Engineering and Planning item reads "Using AI systems to assist with research, planning, and implementation of technology solutions."

**Acceptance Scenarios**:

1. **Given** the first capability list, **When** it is shown, **Then** the AI-Assisted Engineering and Planning item uses the new description and not the old one.

---

### User Story 3 - Scan and prune findings (Priority: P1)

A person running an assessment sees a title for each listed finding and its solution complexity, and can dismiss findings straight from the list or from a finding's details.

**Why this priority**: The literal **Finding:** label repeats on every item and says nothing. Dismissing a finding currently requires opening it, and the person is not told dismissal is possible.

**Independent Test**: Run an assessment with at least six grounded findings. Each listed finding opens with a bold title drawn from its finding text, then its summary, then **Solution Complexity:**. The dismiss-or-more line appears. Dismissing a finding by number removes it from the list.

**Acceptance Scenarios**:

1. **Given** a listed finding, **When** the list is shown, **Then** the item opens with a bold title based on the finding's text, not the literal word "Finding".
2. **Given** a listed finding, **When** the list is shown, **Then** its complexity label reads **Solution Complexity:**.
3. **Given** more findings remain than are shown, **When** the list is shown, **Then** the question is followed by "If you'd like to dismiss any of these or see additional findings, just say so."
4. **Given** no more findings remain than are shown, **When** the list is shown, **Then** the question is followed by "If you'd like to dismiss any of these, just say so."
5. **Given** the list, **When** the person dismisses one or more findings by number or title, **Then** each is set to Dismissed and the list is shown again without them.
6. **Given** a finding's details, **When** they are shown, **Then** they end with "If you'd like to dismiss this finding or go back to the list of findings, just say so."

---

### User Story 4 - Accept a request proposal once (Priority: P1)

A person creating a request sees one proposal in the captured-request format, with readable Solution Constraints names and "None" in place of "unknown", and accepts it once.

**Why this priority**: The person currently accepts a starting point, then accepts the same content again in a different format.

**Independent Test**: Run `/highway-request` with a business description. One proposal appears with a title heading and a section heading for each domain. Solution Constraints use readable names and show "None" where nothing is known. One acceptance writes the request.

**Acceptance Scenarios**:

1. **Given** an invocation with a business description, **When** the proposal is shown, **Then** it uses the captured-request format: a title heading, then a heading for each of the seven domains with its content.
2. **Given** the proposal, **When** the person accepts it, **Then** the request is written without a second review.
3. **Given** the proposal, **When** Solution Constraints are shown, **Then** each field uses a readable name, such as "Allowed Solution Classes" for `allowed_solution_classes`.
4. **Given** a Solution Constraints field with no known value, **When** it is shown, **Then** it reads "None", not "unknown".
5. **Given** an assessment finding is explored, **When** the request flow continues, **Then** it opens at the single proposal step.

---

### Edge Cases

- One captured objective, control, or NFR. It is shown as item 1.
- The person dismisses every listed finding and no other finding remains. The assessment goes to its summary.
- The person dismisses a finding from the list and more findings remain. The list is topped back up to five.
- The person names a number in the list that does not exist. The list is shown again.
- A Solution Constraints field has an empty list. It reads "None".
- The person says "none" for a Solution Constraints field. It is recorded per FR-017a and still reads "None".
- A **No system hosting** or **Direct purchase** NFR fills a Solution Constraints field. That statement is shown, not "None".
- The person edits the request proposal. The proposal is shown again with the edit applied, and acceptance still writes the request once.

## Requirements *(mandatory)*

### Functional Requirements

#### Objectives, Controls, and NFRs

- **FR-001**: The objectives capture review MUST present each objective as a numbered item, starting at 1, in queue order. The item's statement, success measures, and rationale stay under its number.
- **FR-002**: The controls capture review MUST present each control as a numbered item, starting at 1, in queue order. The item's statement and rationale stay under its number.
- **FR-003**: The NFRs capture review MUST present each NFR as a numbered item, starting at 1, in queue order. The item's statement and rationale stay under its number.
- **FR-004**: A number in a capture-review reply MUST refer to the item with that number in the review just shown.

#### Onboarding

- **FR-005**: The AI-Assisted Engineering and Planning description MUST read "Using AI systems to assist with research, planning, and implementation of technology solutions." in place of "Using AI systems to assist with research, architecture, planning, governance, or implementation activities."

#### Assessment

- **FR-006**: Each listed finding MUST open with a bold title, with a colon, based on that finding's text in the findings file, in place of the literal **Finding:** label. The one-sentence summary follows the title, after a blank line.
- **FR-007**: The **Complexity:** label in the list MUST read **Solution Complexity:**.
- **FR-008**: When no more findings remain than are shown, the question MUST be followed by "If you'd like to dismiss any of these, just say so."
- **FR-009**: When more findings remain than are shown, the question MUST be followed by "If you'd like to dismiss any of these or see additional findings, just say so." This replaces "If you'd like to see additional findings, just say so."
- **FR-010**: From the list, the person MUST be able to dismiss one or more findings by number or title. Each is set to Dismissed, then the list is shown again without them, topped up to at most five.
- **FR-011**: In the finding details, "If you'd like to go back to the list of findings, just say so." MUST be replaced with "If you'd like to dismiss this finding or go back to the list of findings, just say so." Dismissing still sets the finding to Dismissed and returns to the list.
- **FR-012**: The finding title MUST NOT be written to the findings file. The findings file, its columns, identifiers, and the finding details format stay unchanged.

#### Request

- **FR-013**: The request starting point and the capture MUST be one step. It shows the proposal in the capture format: the lead-in "**Here is a proposed starting point for your request:**", the title as a level-1 heading, and each of the seven domains as a level-2 heading with its content.
- **FR-014**: Accepting that proposal MUST continue to the identifier and write without a second acceptance.
- **FR-015**: The merged step MUST keep the starting point's grounding rules: every slot is filled from the invocation and accepted context, including the **No system hosting** and **Direct purchase** rules, and the person is not asked to originate a slot the proposal can fill.
- **FR-016**: When Solution Constraints are shown, each field MUST use a readable name: each word capitalized and underscores replaced with spaces. For example, `allowed_solution_classes` is shown as "Allowed Solution Classes".
- **FR-017**: When a Solution Constraints value is unknown or an empty list, the person MUST see "None" in place of "unknown" or an empty list. This changes only what the person sees. The request record keeps `unknown` and `[]` as the record template defines them.
- **FR-017a**: When the person says "none" for a Solution Constraints field, Existing Platforms Required, Existing Platforms Preferred, and Known Systems MUST be recorded as an empty list `[]`. Allowed Solution Classes, Hosting Restrictions, Vendor Restrictions, Procurement Constraints, and Regulatory Restrictions MUST be recorded as `unknown`.
- **FR-018**: The request record's Solution Constraints field names and shapes MUST stay as the record template defines them.
- **FR-019**: The assessment hand-off to the request flow MUST open at the merged step.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of capture reviews for objectives, controls, and NFRs show numbered items.
- **SC-002**: A person creating a request accepts the proposal once, down from twice.
- **SC-003**: Solution Constraints shown to the person contain 0 snake-case field names and 0 occurrences of "unknown".
- **SC-004**: Listed findings contain 0 literal **Finding:** labels.
- **SC-005**: A person can dismiss any listed finding in one reply, from the list or from its details.

## Assumptions

- The ordered-list change applies to the capture review only. Recommendation sets are already numbered.
- The `---` separator between captured items stays, between numbered items. No `---` follows the last item.
- The finding title is short and derived each time the list is shown. It is not stored.
- Dismissing from the list uses the same status update as dismissing from the details.
- "When findings are exhausted" means no more findings remain beyond those shown.
- The merged request step keeps the name `start`, so the assessment hand-off and intake still lead to it.
- The merged step keeps the starting point's lead-in, "**Here is a proposed starting point for your request:**". The capture's lead-in is removed.
- A Solution Constraints value the person sees as "None" is still written as `unknown` or `[]`, so Discovery keeps reading an unknown Allowed Solution Classes as no class filter.
- The merged step keeps the starting point's guidance line, including the "I don't know" sentence, because the step still handles an unknown reply.
- Under the Solution Constraints heading, each field is shown as its own bold readable name with its value, in the record's field order.
- "None" applies to Solution Constraints values only. The seven domains' own `Unknown` handling is unchanged.
