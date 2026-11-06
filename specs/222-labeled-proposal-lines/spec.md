# Feature Specification: Labeled Proposal Lines

**Feature Branch**: `222-labeled-proposal-lines`

**Created**: 2026-11-06

**Status**: Draft

**Input**: User description: "I want both Recommendation under Conflicts and Evidence under New Realized Capabilities to appear like **Why it matters:** under When to use/When not to use - in bold and with a preceding empty line. The Conflict Recommendation updates should be for both Platform and Coding standards."

## Clarifications

### Session 2026-11-06

- Q: Should the separate conflicts list, the one shown when you choose to resolve conflicts, also put **Recommendation:** on its own bold line, the same as the platform and coding standard proposals? → A: Yes. The platform proposal, the coding standard proposal, and the `conflicts` list all show **Recommendation:** on its own bold line.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A conflict shows its recommendation on its own labeled line (Priority: P1)

A person reads a platform proposal or a coding standard proposal that lists conflicts. Under each conflict, after a blank line, they read **Recommendation:** and the one change that removes it. The `conflicts` list shows each conflict the same way.

**Why this priority**: The recommendation is what the person acts on. In the same sentence as the description it reads as part of the description.

**Independent Test**: Read the conflict line in the platform proposal shape, the standard proposal shape, and the `conflicts` list. Each shows the conflict and its description, a blank line, then an indented **Recommendation:** line.

**Acceptance Scenarios**:

1. **Given** a platform proposal with conflicts, **When** a conflict is shown, **Then** it reads `1. **[Conflict]:** [Description quoting both entries and naming both records.]`, then a blank line, then `   **Recommendation:** [One change that removes it.]`.
2. **Given** a coding standard proposal with conflicts, **When** a conflict is shown, **Then** it has the same form as the platform proposal.
3. **Given** the `conflicts` list, **When** a conflict is shown, **Then** it reads `1. **[Conflict]:** [Description.]`, then a blank line, then `   **Recommendation:** [One change that removes it.]`.
4. **Given** any of those three shapes, **When** it is read, **Then** the text `] Recommendation: [` does not appear.

---

### User Story 2 - A new realized capability shows its evidence on its own labeled line (Priority: P1)

A person reads New Realized Capabilities on a platform proposal. Under each capability, after a blank line, they read **Evidence:** and what the current documentation describes.

**Why this priority**: Evidence is why the capability is proposed. It reads the same way as **Why it matters:** under an entry.

**Independent Test**: Read New Realized Capabilities in the platform proposal shape. Each capability shows its title and Realized By, a blank line, then an indented **Evidence:** line.

**Acceptance Scenarios**:

1. **Given** a platform proposal with new realized capabilities, **When** a capability is shown, **Then** it reads `1. **[Title]:** Realized By: [Platform].`, then a blank line, then `   **Evidence:** [What the current documentation describes.]`.
2. **Given** that shape, **When** it is read, **Then** the text `. Evidence: [` does not appear.
3. **Given** a platform proposal with no new realized capability, **When** it is shown, **Then** New Realized Capabilities shows `None`, as it does today.

---

### Edge Cases

- A proposal with no conflicts shows `None` under **Conflicts:**. No **Recommendation:** line appears.
- A remove of a platform leaves out New Realized Capabilities, as it does today. No **Evidence:** line appears.
- The conflict count, the conflict description, and the Realized By value are unchanged. Only the line the recommendation or evidence sits on, and its bold label, change.
- `resolve` still starts from the selected conflict's recommendation.
- The capabilities passed to `highway-implementation` keep Title, Realized By, and Evidence. The record that skill writes keeps its format.
- When to use, When not to use, and the coding rules keep their **Why it matters:** lines unchanged.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `platform proposal` shape MUST show each conflict in this form, blank line included:

  ```markdown
  1. **[Conflict]:** [Description quoting both entries and naming both records.]

     **Recommendation:** [One change that removes it.]
  ```

- **FR-002**: The `standard proposal` shape MUST show each conflict in the FR-001 form.
- **FR-003**: The `conflicts` list MUST show each conflict in this form, blank line included:

  ```markdown
  1. **[Conflict]:** [Description.]

     **Recommendation:** [One change that removes it.]
  ```

- **FR-004**: The `platform proposal` shape MUST show each new realized capability in this form, blank line included:

  ```markdown
  1. **[Title]:** Realized By: [Platform].

     **Evidence:** [What the current documentation describes.]
  ```

- **FR-005**: A shape in `highway-codify-config` MUST NOT keep `Recommendation:` or `Evidence:` on the same line as the conflict description or the Realized By value.
- **FR-006**: The `**Recommendation:**` and `**Evidence:**` lines MUST be indented three spaces under their list item, the same indent **Why it matters:** uses.
- **FR-007**: The step text, the conflict rules, the capability rules, `resolve`, and the handoff to `highway-implementation` MUST stay as they are.
- **FR-008**: `platform proposal` and `standard proposal` MUST each stay at 400 words or fewer, excluding the heading. `conflicts` MUST stay at 250 words or fewer, excluding the heading.
- **FR-009**: `highway-codify-config` MUST move from 3.2.4 to 3.2.5.

### Key Entities

- **Conflict line**: the bold conflict name and its description on the list item. A blank line and an indented **Recommendation:** line follow it.
- **Capability line**: the bold title and its Realized By value on the list item. A blank line and an indented **Evidence:** line follow it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All three conflict shapes, in the platform proposal, the standard proposal, and the `conflicts` list, show a blank line, then a bold **Recommendation:** line indented under the conflict.
- **SC-002**: The New Realized Capabilities shape shows a blank line, then a bold **Evidence:** line indented under the capability.
- **SC-003**: No shape keeps `Recommendation:` or `Evidence:` inline with its description or Realized By value.
- **SC-004**: The existing suite passes with 0 failures after the change.

## Assumptions

- "Like **Why it matters:**" means the label is bold, the line follows one blank line, and it is indented three spaces under the list item.
- The `conflicts` list carries the same Recommendation as the two proposals and serves both platforms and coding standards. It changes with them, per the clarification.
- This is a change to how proposals are shown. No catalog, record, or saved file changes. The version change is PATCH, 3.2.4 to 3.2.5.
- The test that pins the inline capability line in `platform proposal` moves, with its reason recorded in planning.
- Realized By stays on the title line. The request names only Evidence.
