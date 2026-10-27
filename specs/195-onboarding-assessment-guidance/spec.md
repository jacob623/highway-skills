# Feature Specification: Onboarding and Assessment Guidance

**Feature Branch**: `195-onboarding-assessment-guidance`

**Created**: 2026-10-27

**Status**: Draft

**Input**: User description: "Add an onboarding overview before the first capability list, present one capability per numbered item with the title and description on separate lines, replace the static Highway capability with AI-Assisted Engineering and Planning, add a transition before mapping, and separate each mapping label from its value. In assessment, add an opening heading, a numbered list of up to five findings the person can choose from, and a way back to that list from a finding."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Understand onboarding before it starts (Priority: P1)

A person starting onboarding sees what onboarding will do before the first capability list appears.

**Why this priority**: Onboarding currently starts with a capability list. The person does not know the four parts of onboarding or that they need nothing documented in advance.

**Independent Test**: Run onboarding. The overview in FR-001 appears once, before the first capability list. An edit to the list does not repeat it.

**Acceptance Scenarios**:

1. **Given** onboarding starts, **When** the first capability list is shown, **Then** the overview in FR-001 comes before it, with "What we'll do together" as a level-3 heading.
2. **Given** the overview was shown, **When** the person edits the capability list, **Then** only the list is shown again.
3. **Given** the capabilities step, **When** it opens, **Then** the old heading "This is where Highway helps you navigate your technology landscape" and its sentence no longer appear there.

---

### User Story 2 - Review one capability per numbered item (Priority: P1)

A person reviewing proposed capabilities sees each one as its own numbered item, with its title and description on separate lines, so they can add, remove, or correct one by number.

**Why this priority**: Combined capabilities such as "E-Commerce Storefront & Order Management" force the person to split them, and they cannot easily refer to one item.

**Independent Test**: Run onboarding with context that supports two related capabilities. They appear as two numbered items, each with a bold title, a blank line, and the description.

**Acceptance Scenarios**:

1. **Given** context supports a storefront and order management, **When** capabilities are proposed, **Then** "E-Commerce Storefront" and "Order Management" are separate numbered items.
2. **Given** a capability item, **When** it is shown, **Then** the bold title is followed by a blank line and then the description.
3. **Given** the first capability list, **When** it is shown, **Then** it includes **AI-Assisted Engineering and Planning** with "Using AI systems to assist with research, architecture, planning, governance, or implementation activities." and does not include the **Highway:** line.

---

### User Story 3 - Know what mapping will do (Priority: P2)

After accepting capabilities, the person is told that onboarding now looks at how each capability is provided, and each mapping shows its labels and values on separate lines.

**Why this priority**: The move from capabilities to providers is currently unannounced, and the mapping block runs labels and values together.

**Independent Test**: Accept a capability list. The transition in FR-007 appears once, before the first capability mapping. Each mapping shows the title, Business Purpose, and Provider labels in bold, each followed by a blank line and its value.

**Acceptance Scenarios**:

1. **Given** the capability list was accepted, **When** the first mapping is shown, **Then** the transition in FR-007 comes before it.
2. **Given** a later capability on the queue, **When** its mapping is shown, **Then** the transition does not appear again.
3. **Given** a mapping, **When** it is shown, **Then** each bold label is followed by a blank line and its value.
4. **Given** the capability **AI-Assisted Engineering and Planning**, **When** the session names the agent platform, **Then** that name is its provider.

---

### User Story 4 - Choose which finding to explore (Priority: P1)

A person running an assessment sees an opening, then a numbered list of up to five findings with a one-sentence summary and complexity for each. They choose one to see its details, and can go back to the list from there.

**Why this priority**: Findings currently arrive one at a time, so the person cannot see what is available or choose where to start.

**Independent Test**: Run an assessment with at least six grounded findings. The opening appears, then five numbered findings, the selection question, and the additional-findings line. Choosing a number shows that finding's details. Asking to go back shows the list again.

**Acceptance Scenarios**:

1. **Given** an assessment starts, **When** the first findings are shown, **Then** the heading "Let's see what your repository may be telling us." comes first, as a level-3 heading, followed by its paragraph.
2. **Given** grounded findings exist, **When** the list is shown, **Then** up to five appear as numbered items, each with **Finding:** and its summary, then **Complexity:** and Low, Medium, or High, each label followed by a blank line and its value.
3. **Given** more than five grounded findings exist, **When** the list is shown, **Then** it ends with "If you'd like to see additional findings, just say so." after the question.
4. **Given** the list, **When** the person chooses a finding, **Then** that finding's details are shown in the existing finding format.
5. **Given** a finding's details, **When** the person asks to go back, **Then** the list of findings is shown again.
6. **Given** Open findings from earlier runs and new grounded findings, **When** the list is shown, **Then** the earlier Open findings come first, then new findings, up to five in total. Each new finding is written as Open before the list is shown.
7. **Given** a finding's details, **When** the person saves it for later or discards it, **Then** its status is updated as today and the list of findings is shown again.

---

### Edge Cases

- Context describes a capability with "&" or "and" joining two distinct activities. Each activity is proposed as its own capability.
- An accepted ADR already records **AI-Assisted Engineering and Planning** for the same agent-platform name. The line is omitted from the first list.
- An accepted ADR from an earlier onboarding records the **Highway** capability. It does not count as the new capability. Backward compatibility is not required while the project is in development.
- Five or fewer grounded findings exist. The additional-findings line does not appear.
- No grounded finding exists. The assessment goes to its summary, as today.
- The person asks for additional findings. The next set of up to five is shown in the same numbered form.

## Requirements *(mandatory)*

### Functional Requirements

#### Onboarding

- **FR-001**: Onboarding MUST emit the overview below once, before the first capability list. "What we'll do together" is a level-3 heading. Every other line is emitted as written. [Name] is the accepted Organization Name, or the Repository Name when none is accepted.

  ```markdown
  What we'll do together

  This is where Highway helps you navigate your technology landscape.

  We'll connect existing capabilities so future recommendations align with [Name]'s target direction.

  During onboarding we'll:

  - **Identify important business capabilities** your organization relies on.
  - **Understand the platforms and processes** that support those capabilities today.
  - **Validate Highway's understanding** before any architecture knowledge is created.
  - **Capture accepted knowledge** as connected architecture and implementation context.

  You don't need to have everything documented in advance. We'll build that understanding together, one capability at a time.

  Now, let's get started.

  ---
  ```

- **FR-002**: The capabilities step MUST no longer emit the heading "This is where Highway helps you navigate your technology landscape" or the sentence "We'll connect existing capabilities so future recommendations align with [Name]'s target direction."
- **FR-003**: Each proposed capability MUST describe one capability. Combined activities MUST be proposed as separate capabilities.
- **FR-004**: Each proposed capability MUST be a numbered item: the bold title with a colon, a blank line, then what the organization does.
- **FR-005**: The **Highway:** line MUST be replaced with **AI-Assisted Engineering and Planning** and "Using AI systems to assist with research, architecture, planning, governance, or implementation activities." on the first capability list.
- **FR-006**: The inclusion rule MUST read: "Include the AI-Assisted Engineering and Planning line on the first capability list. Omit it when an accepted ADR already records this capability for the same agent-platform name. The person may correct or remove the line before accept. A removed AI-Assisted Engineering and Planning line is not placed on the capability queue."
- **FR-007**: Before the first capability mapping, onboarding MUST emit this once:

  ```markdown
  **We've identified the capabilities that matter to your organization. Now let's look at how those capabilities are provided today.**

  For each capability, we'll identify the platforms, services, processes, or people that help deliver it.

  ---
  ```

- **FR-008**: Each mapping MUST show **[Capability title]:**, **Business Purpose:**, and **Provider:** each followed by a blank line and its value.
- **FR-009**: When the capability title is AI-Assisted Engineering and Planning and the session identifies the agent platform by name, that name MUST be the provider. The existing unknown-provider prompt, correction, and scope rules stay unchanged.

#### Assessment

- **FR-010**: Before the first findings are shown, assessment MUST emit "Let's see what your repository may be telling us." as a level-3 heading, then a blank line, then: "Highway will review accepted knowledge, surface observations that may be worth your attention, and suggest opportunities, improvements, or next steps where they may create value."
- **FR-011**: A new list of findings MUST come before the finding details. It opens with **Based on what Highway knows, these may be worth visiting:**, then up to five numbered findings. Findings whose status is Open from earlier runs come first, then new grounded findings. The separate list of earlier Open findings is replaced by this list.
- **FR-011a**: Each new finding in the list MUST be written to the findings file with status Open before the list is shown. A failed write leaves that finding out of the list.
- **FR-012**: Each listed finding MUST show **Finding:**, a blank line, a one-sentence summary, then **Complexity:**, a blank line, and Low, Medium, or High.
- **FR-013**: The list MUST ask **Would you like to explore any of these findings in more detail?**
- **FR-014**: When more grounded findings exist than are shown, the list MUST follow the question with "If you'd like to see additional findings, just say so." A request for more shows the next set of up to five.
- **FR-015**: Choosing a finding, by number or by its summary, MUST show that finding's details in the existing finding format.
- **FR-016**: In the finding details, "If you want to save this for later, or discard it entirely, just say so." MUST be replaced with "If you'd like to go back to the list of findings, just say so." Asking to go back MUST show the list of findings again.
- **FR-016a**: Save for later and discard MUST stay available from the finding details when the person asks, though the details no longer mention them. Each updates the finding's status as today, then shows the list of findings again.
- **FR-017**: Exploring a solution, the findings file, identifiers, and the summary MUST stay unchanged except as this feature requires.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The onboarding overview appears exactly once per onboarding run, before the first capability list.
- **SC-002**: 100% of proposed capabilities describe a single capability and appear as numbered items.
- **SC-003**: The first capability list contains **AI-Assisted Engineering and Planning** and 0 occurrences of the **Highway:** line.
- **SC-004**: The mapping transition appears exactly once per run, before the first mapping.
- **SC-005**: An assessment list never shows more than 5 findings at a time.
- **SC-006**: A person can reach any listed finding's details in one reply, and return to the list in one reply.

## Assumptions

- The overview takes over the two lines removed from the capabilities step. The capabilities step keeps its starting-point heading and question.
- The AI-Assisted Engineering and Planning item uses the same numbered form as other capabilities, with a colon after the bold title.
- "AI-Assisted Engineering" in the supplied provider rule refers to the full capability title, AI-Assisted Engineering and Planning.
- "Based on what highway knows" in the supplied copy uses "Highway", as everywhere else.
- "If you'd like see additional findings" in the supplied copy is a typo for "If you'd like to see additional findings".
- The assessment opening appears once per run, before the list of findings.
- A finding saved or discarded leaves the list. The list shows the remaining findings, topped up with new grounded findings to at most five.
- The finding details keep their current opening, possible solutions, complexity, cost range, and explore question.
