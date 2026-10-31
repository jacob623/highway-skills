# Feature Specification: ADR Record Completeness

**Feature Branch**: `197-adr-record-completeness`

**Created**: 2026-10-29

**Status**: Draft

**Input**: User description: "Update the ADR record so a later reader can understand the decision without reopening the research, can see the architecture and implementation it produced, and can tell a current decision from a superseded one. Onboarding decisions use the same record. Leave out named deciders, a second scoring of options, an implementation plan, and a clock timestamp."

## Clarifications

### Session 2026-10-29

- Q: Should the alternatives list include the chosen option, or only the options that were not chosen? → A: The alternatives list includes the chosen option with outcome Selected. The handoff and the research section do not copy it again. Recommendation Override is the only other place it is stated as the decision.
- Q: If the architecture record is written but the ADR cannot be updated to name it, what should happen? → A: Keep the architecture. The ADR stays unchanged. The chain is not complete until a later update names the architecture on the ADR. The same rule applies to the implementation record.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Read the decision on its own (Priority: P1)

A person opening an ADR later can read the problem, the forces, what was decided, what else was considered, what the decision leaves open, and what should cause it to be reopened. They do not have to open the Discovery to learn those things.

**Why this priority**: The record is already strong on traceability and weak on the prose a later reader needs. This is the gap that makes the file hard to trust on its own.

**Independent Test**: Read one Discovery-backed ADR and do not open its Discovery. The problem, the forces, each alternative's definition and reason, the boundary, and the revisit condition are all in the ADR. The duplicate status field is gone. The chosen option is in the Decision and in the alternatives list with outcome Selected. The architecture matches are in the Discovery Reference. The handoff copies neither.

**Acceptance Scenarios**:

1. **Given** an accepted ADR, **When** a person reads Context, **Then** it states the problem and the forces in prose.
2. **Given** an alternative, **When** it is read, **Then** it has its definition, one outcome of Selected, Rejected, or Evaluated, and a reason. It has no second status field.
3. **Given** an accepted ADR, **When** a person reads it, **Then** it states what the decision covers, what it leaves open, and the condition that should cause it to be reopened.
4. **Given** a Discovery-backed ADR, **When** the sections are read, **Then** the chosen option is in the Decision and in the alternatives list with outcome Selected. The architecture matches are in the Discovery Reference. The handoff does not copy the chosen option or the matches.
5. **Given** the person selected the recommended option, **When** the ADR is written, **Then** it has no Recommendation Override section.

---

### User Story 2 - See what the decision produced (Priority: P1)

After the reference architecture and the reference implementation exist, the ADR names them. Before they exist, those places say None.

**Why this priority**: The record currently ends at permission to proceed. Highway's chain is decision, architecture, implementation.

**Independent Test**: Accept an ADR, then create its architecture, then create its implementation. The ADR names the architecture after the first of those, and names both after the second. The decision text is unchanged by those later writes.

**Acceptance Scenarios**:

1. **Given** an ADR was just accepted and no architecture exists yet, **When** the handoff is read, **Then** the architecture and the implementation are None.
2. **Given** the reference architecture for that ADR now exists and the ADR update succeeded, **When** the ADR is read, **Then** it names that architecture, and the implementation is None until it exists.
3. **Given** the reference implementation now exists and the ADR update succeeded, **When** the ADR is read, **Then** it names that implementation.
4. **Given** either later record is written, **When** the ADR is updated, **Then** the decision statement, rationale, selected option, and status stay as they were.
5. **Given** the reference architecture was written and the ADR update failed, **When** the records are read, **Then** the architecture remains, the ADR is unchanged, and the chain is not complete. The same holds for the reference implementation.

---

### User Story 3 - Record an onboarding decision in the same shape (Priority: P1)

An ADR created during onboarding uses the same sections as a Discovery-backed ADR. Where onboarding has no Discovery option, recommendation, or comparison, the record says None. It does not invent option ids.

**Why this priority**: The record allows an onboarding decision in its header and then requires Discovery fields the onboarding decision does not have. The two writers produce two different documents.

**Independent Test**: Finish onboarding for one provider. The ADR has every shared section. Discovery-only values are None. The alternatives are named in words. The architecture and implementation ids are filled when those records are written.

**Acceptance Scenarios**:

1. **Given** onboarding creates a decision, **When** the ADR is read, **Then** it has the same sections as a Discovery-backed ADR.
2. **Given** that onboarding decision, **When** Discovery-only values are read, **Then** the recommendation, the candidate options, the comparison, and the architecture matches are None.
3. **Given** that onboarding decision, **When** alternatives are read, **Then** each one is headed by a name, with a definition, an outcome, and a reason, and the record contains no option id.
4. **Given** onboarding finishes the architecture and the implementation, **When** the ADR is read, **Then** it names both. **Given** the implementation could not be written, **When** the ADR is read, **Then** it names the architecture and the implementation is None.

---

### User Story 4 - Tell a current decision from a superseded one (Priority: P2)

A person looking at the catalog can tell a decision that is still in force from one that has been replaced and from one that was removed.

**Why this priority**: A replaced decision can keep the same accepted status as a current one. Removed already means the file is gone, so replacement needs its own status.

**Independent Test**: Set one ADR's superseded-by field to another ADR. Its status and its catalog row say superseded, and the file remains. A removed row still has no file.

**Acceptance Scenarios**:

1. **Given** an ADR names a replacing ADR, **When** the record and the catalog are read, **Then** both say superseded and the record file remains.
2. **Given** an ADR names no replacing ADR, **When** it is current, **Then** its status is accepted.
3. **Given** a catalog row is removed, **When** the catalog is read, **Then** that row says removed and has no record file.

---

### User Story 5 - See the typed governance links (Priority: P2)

A person reading the ADR can see which objectives the decision advances, which controls it is bound by, and which operational expectations it satisfies. Each link uses one named type.

**Why this priority**: The three relationship sections ask for a typed list and never name the types, so two writers can record the same link differently.

**Independent Test**: Read an ADR that has one objective, one control, and one NFR. Each link shows the identifier and the one allowed type for that section. An empty section says None.

**Acceptance Scenarios**:

1. **Given** the decision advances an objective, **When** Objective Relationships is read, **Then** the link is that objective's identifier and the type advances.
2. **Given** the decision is bound by a control, **When** Control Relationships is read, **Then** the link is that control's identifier and the type bound by.
3. **Given** the decision satisfies an operational expectation, **When** NFR Relationships is read, **Then** the link is that expectation's identifier and the type satisfies.
4. **Given** a section has no link, **When** it is read, **Then** it says None.

---

### Edge Cases

- The person selected the recommended option. Recommendation Override is omitted.
- The person selected a different option. Recommendation Override names both options and the override rationale. That is the only other statement of the decision. The alternatives list still includes the chosen option with outcome Selected.
- No revisit condition is known. The revisit section says None.
- No objective, control, or operational expectation applies. That relationship section says None.
- The reference architecture is written and the reference implementation cannot be written. The ADR names the architecture, the implementation stays None, and the decision text is unchanged.
- The reference architecture is written and the ADR cannot be updated to name it. The architecture remains, the ADR stays unchanged, and the chain is not complete. The same holds when the reference implementation is written and the ADR cannot be updated to name it.
- Onboarding has no weaker alternative to name. The alternatives list contains the adopted provider with outcome Selected, and no other alternative.
- A superseded ADR is not treated as removed. The file stays, and the id stays taken.
- Clearing the replacing ADR, so superseded-by is None again, returns the status to accepted.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Context MUST state the problem this decision responds to, and the forces that make the decision necessary, in prose.
- **FR-002**: Each alternative MUST include its definition, one outcome, and a reason. The outcome is exactly Selected, Rejected, or Evaluated. Evaluated means viable and not selected. Rejected means unsuitable. The duplicate status field is removed.
- **FR-003**: A Discovery-backed alternative MUST be headed by its option id. An onboarding alternative MUST be headed by its name and MUST NOT use an option id.
- **FR-004**: The ADR MUST state what the decision covers and what it leaves open.
- **FR-005**: The ADR MUST state the condition that should cause the decision to be reopened, or None when no condition is known.
- **FR-006**: The chosen option MUST be stated in the Decision, and the alternatives list MUST include it with outcome Selected. The handoff and the Discovery Reference MUST NOT copy it. It MUST be stated again as the decision only in Recommendation Override, and only when it differs from the Discovery recommendation. That section names both options and the override rationale. It is omitted when they are the same, and when there is no Discovery recommendation.
- **FR-007**: Reference architecture matches MUST be stated in the Discovery Reference and MUST NOT be copied into the handoff.
- **FR-008**: The handoff MUST name the reference architecture and the reference implementation once each record exists, and MUST say None for a record that does not exist yet.
- **FR-009**: A later write that records the architecture id or the implementation id MUST NOT change the decision statement, the rationale, the selected option, or the status.
- **FR-009a**: When the reference architecture is written and the ADR cannot be updated to name it, the architecture MUST remain, the ADR MUST stay unchanged, and the chain MUST NOT be treated as complete. The same rule applies when the reference implementation is written and the ADR cannot be updated to name it.
- **FR-010**: An onboarding ADR MUST use the same sections as a Discovery-backed ADR. The recommendation, candidate options, comparison, and reference architecture matches MUST be None. The record MUST contain no option id.
- **FR-011**: When onboarding has written the reference architecture and the reference implementation, the ADR MUST name both. When the implementation cannot be written, the ADR MUST name the architecture and leave the implementation None.
- **FR-012**: When an ADR names a replacing ADR, its status MUST be superseded in the record and in the catalog, and the record file MUST remain. When it names no replacing ADR, a current ADR's status MUST be accepted.
- **FR-013**: A removed catalog row MUST still have no record file. Superseded and removed MUST stay different.
- **FR-014**: An objective link MUST use the type advances. A control link MUST use the type bound by. An operational-expectation link MUST use the type satisfies. A section with no link MUST say None.
- **FR-015**: This feature MUST NOT add named deciders, a second scoring of options, an implementation plan, or a clock timestamp. Authorization MUST stay as it is: proceed to the reference architecture, and do not implement.

### Key Entities

- **ADR record**: One accepted architecture decision. It holds the problem and forces, the decision and its boundary, the alternatives, the revisit condition, the research it came from, the governance links, and the architecture and implementation it produced.
- **Alternative**: One considered option or onboarding alternative, including the chosen one. It has a definition, one outcome, and a reason. The chosen one has outcome Selected.
- **Governance link**: One objective, control, or operational expectation, with the single type allowed for that section.
- **Catalog row**: The index entry for one ADR. Its status is accepted, superseded, or removed.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A reader can find the problem, the forces, every alternative's definition and reason, the boundary, and the revisit condition in the ADR without opening another record.
- **SC-002**: The chosen option is stated in the Decision and once in the alternatives list with outcome Selected. It is stated again as the decision only when Recommendation Override is present. The handoff and the Discovery Reference do not copy it. Architecture matches appear once. The duplicate status field appears 0 times.
- **SC-003**: When the ADR update succeeds, the ADR names each later record that exists. Before either exists, both places say None. When an update fails, that later record remains, the ADR is unchanged, and the chain is not complete.
- **SC-004**: An onboarding ADR uses the shared sections and contains 0 option ids.
- **SC-005**: A replaced ADR shows superseded in the record and the catalog, and the file remains. A removed row has no file.
- **SC-006**: Every governance link uses the one type named for its section.

## Assumptions

- The decision boundary and the revisit condition are their own sections. The existing authorization sentences stay in the Decision and the handoff.
- The alternatives entry is the comparison. It is not a second statement of the decision. Recommendation Override is the only other statement of the decision.
- One type per relationship section is enough. The section already says whether the link is an objective, a control, or an operational expectation. The types are advances, bound by, and satisfies.
- This feature defines what superseded means. It does not add a new conversation for choosing a replacement. A writer that sets the replacing ADR also sets the status.
- Onboarding still decides to adopt a provider for the capabilities that provider serves. That decision is recorded in the shared sections, including the problem, the forces, the boundary, and the revisit condition.
- The architecture record's own relationship sections stay as they are.
- No acceptance date is added. The existing rule against a clock timestamp stays.
