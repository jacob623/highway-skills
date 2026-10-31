# Feature Specification: Multiple Reference Implementations

**Feature Branch**: `198-multiple-reference-implementations`

**Created**: 2026-10-29

**Status**: Draft

**Input**: User description: "Implement the agreed updates. Allow more than one reference implementation for a reference architecture. Keep one decision per decision record and one reference architecture for that decision. The decision names the architecture. Each implementation names that architecture. The decision does not hold a single implementation id. Address the architecture record findings: state what is fixed and what may vary, state the responsibilities and the information, give each component a boundary, and make the written record match the skeleton. Address the implementation record findings: record the variation choice, the limitations, and conformance to the architecture's responsibilities, and make that written record match its skeleton. At discovery, surface an existing implementation of a matched architecture. When a later decision selects a different option for that architecture, ask whether it replaces the existing decision or runs beside it, and close with the matching next step."

## Clarifications

### Session 2026-10-29

- Q: When a second decision reuses an architecture, which decision does that architecture record name? → A: The architecture lists every current decision that names it. The catalogs stay in sync with that list, including one-to-many relationships.
- Q: When the closing message says this option already has an implementation, what ties that implementation to the option just selected? → A: The existing decision selected an option with the same exact title, and its architecture has a current implementation.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Add another implementation (Priority: P1)

A person who already has a reference implementation for an architecture can add another one for that same architecture. The first implementation remains. The architecture and the decision stay as they were.

**Why this priority**: One implementation per architecture is what blocks a reusable architecture. Kafka and SQS are two realizations of one queue architecture, not two decisions.

**Independent Test**: Start from an architecture that already has one implementation. Add a second and accept it. Both implementations exist, both name that architecture, and the decision and the architecture are unchanged.

**Acceptance Scenarios**:

1. **Given** an architecture has one current implementation, **When** the person creates and accepts another for that architecture, **Then** both implementations exist and both name that architecture.
2. **Given** the person names an architecture that already has implementations, **When** creation starts, **Then** those implementations are shown and a new one can still be proposed.
3. **Given** the person does not name an architecture, **When** they choose one, **Then** every accepted architecture can be chosen, including one that already has implementations, and the choice shows how many current implementations it has.
4. **Given** a new implementation is proposed, **When** the person declines it, **Then** nothing is written and the existing implementations stay as they were.
5. **Given** a second implementation is written, **When** the decision and the architecture are read, **Then** the decision statement, rationale, selected option, status, and architecture are unchanged.

---

### User Story 2 - Find the implementations of an architecture (Priority: P1)

A reader can see every current implementation of an architecture. The decision names its architecture and does not name an implementation. An architecture with no implementation is not presented as having one.

**Why this priority**: A single implementation id on the decision becomes wrong as soon as a second implementation exists. The implementations already name the architecture they realize.

**Independent Test**: Read a decision whose architecture has two implementations, a decision whose architecture has one, and a decision whose architecture has none. The decision names the architecture in every case where the architecture exists, and it names no implementation. The two implementations are both found from the architecture they name.

**Acceptance Scenarios**:

1. **Given** an architecture has two current implementations, **When** a reader looks for its implementations, **Then** both are found, and the decision does not name either of them.
2. **Given** an architecture exists and has no implementation, **When** the decision is read, **Then** it names that architecture and has no implementation entry.
3. **Given** no architecture exists yet, **When** the decision handoff is read, **Then** the architecture is None.
4. **Given** an implementation record, **When** it is read, **Then** it names the architecture it realizes.

---

### User Story 3 - Keep one architecture for the decision (Priority: P2)

A decision still has one reference architecture. A second implementation does not create a second architecture or a second decision. Onboarding still creates one implementation for the provider it adopts.

**Why this priority**: Allowing many implementations must not turn one decision into many architectures. Onboarding is a product decision and still produces one implementation.

**Independent Test**: Finish onboarding for one provider, and try to create a second architecture for a decision that already has one. Onboarding has one decision, one architecture, and one implementation. The second architecture is refused. The decision names the architecture and does not name the implementation.

**Acceptance Scenarios**:

1. **Given** a decision already has an architecture, **When** a second architecture is requested for it, **Then** the existing architecture is shown and no second architecture is written.
2. **Given** onboarding adopts one provider, **When** it finishes, **Then** that provider has one decision, one architecture, and one implementation, and the implementation names the architecture.
3. **Given** that onboarding decision, **When** it is read, **Then** it names the architecture and does not name the implementation.
4. **Given** onboarding wrote the architecture and the implementation cannot be written, **When** the records are read, **Then** the decision names the architecture and no implementation exists for it.

---

### User Story 4 - Conform to the architecture (Priority: P1)

A person reading an architecture can see what every implementation must keep, what an implementation may choose, which responsibilities it includes, what information it handles, and the boundary of each component. A realization covers those responsibilities. It does not invent new ones.

**Why this priority**: Many implementations of one architecture are only useful when the architecture says what they share. A purpose line is not something a second implementation can conform to.

**Independent Test**: Read one architecture and do not open an implementation. The fixed parts, the variation points, the responsibilities, the information, and each component's responsibility and interface are in the architecture. An implementation of it covers those responsibilities or marks one not applicable.

**Acceptance Scenarios**:

1. **Given** an accepted architecture, **When** a person reads it, **Then** it states what every implementation must keep and what an implementation may choose.
2. **Given** an accepted architecture, **When** a person reads it, **Then** it states the responsibilities it includes, the information it handles, who owns that information, and what crosses a trust boundary.
3. **Given** a component, **When** it is read, **Then** it has its responsibility and the interface other components rely on.
4. **Given** an implementation of that architecture, **When** its coverage is read, **Then** each stated responsibility is covered or marked not applicable, and no responsibility is added that the architecture does not state.
5. **Given** nothing may vary, or the architecture handles no information, **When** that part is read, **Then** it says None.

---

### User Story 5 - Read a finished architecture record (Priority: P2)

A finished architecture record uses the same identifier and status the catalog uses. It says when the architecture applies, why its style was chosen, and what it carries from the decision. Relationship links use one named type. It does not ask for a technology it then forbids naming.

**Why this priority**: The skeleton currently describes a record the writer does not produce. A reader cannot tell the finished record from the sketch.

**Independent Test**: Read one finished architecture. Its identifier starts with RA, its status is accepted, and the catalog lists the same current decisions. Context states applicability and what is left open. The style has a rationale. Every current decision that names it is listed. Relationship lines use their one type. There is no Key Technologies section.

**Acceptance Scenarios**:

1. **Given** a finished architecture, **When** its identifier and status are read, **Then** the identifier is an RA id, the status is accepted, and a removed catalog row still has no record file.
2. **Given** a finished architecture, **When** Context and Architecture Style are read, **Then** Context states when the architecture applies and what it leaves open, and the style states why it was chosen.
3. **Given** a finished architecture, **When** its decisions are read, **Then** every current decision that names it is listed, and no decision statement is copied a second time.
4. **Given** the architecture advances an objective, is bound by a control, or satisfies an operational expectation, **When** that section is read, **Then** the link uses advances, bound by, or satisfies. An empty section says None.
5. **Given** a finished architecture, **When** it is read, **Then** it has no Key Technologies section, it names no product, and each required capability names the component that offers it. No capability has an identifier.

---

### User Story 6 - See what this realization chose (Priority: P1)

A person reading an implementation can see which free choices it took, how it covers the architecture's responsibilities, the interface it realized, how conformance was shown, and what this realization does not claim. A technology choice is stated once.

**Why this priority**: Two implementations of one architecture differ by the choices they took and the limits they accept. A fixed list of categories cannot show that difference.

**Independent Test**: Read one implementation and its architecture. Each variation the architecture left free has a choice on the implementation. Coverage lists the architecture's responsibilities and no others. The realized interface and the conformance evidence are in the implementation. Limitations are stated, or None. The technology choice appears once.

**Acceptance Scenarios**:

1. **Given** the architecture left a choice free, **When** the implementation is read, **Then** it states the choice it made for that variation.
2. **Given** an implementation, **When** its coverage is read, **Then** the rows are the architecture's stated responsibilities, each covered or not applicable, and the conformance result agrees with those rows.
3. **Given** a component interface on the architecture, **When** the implementation is read, **Then** it states the realized interface, and it states how conformance was shown or None.
4. **Given** an accepted implementation, **When** it is read, **Then** it states the limitations of this realization, or None.
5. **Given** a technology choice, **When** the implementation is read, **Then** its intent, reason, and evidence appear once.

---

### User Story 7 - Read a finished implementation record (Priority: P2)

A finished implementation uses the same identifier, parent, and status the catalog uses. Conformance is part of the record. A compatible record does not carry a gap result or a conflict result. The architecture is named once.

**Why this priority**: The skeleton currently describes a proposed record whose parent is not the identifier the catalog uses. A reader cannot tell a compatible realization from an incomplete one.

**Independent Test**: Read one compatible implementation. Its identifier is an RI id, its parent is an RA id, and its status is accepted. The conformance result is present. Gap and conflict results are absent. The architecture is named once.

**Acceptance Scenarios**:

1. **Given** a finished implementation, **When** its identifier, parent, and status are read, **Then** the identifier is an RI id, the parent is an RA id, and the status is accepted.
2. **Given** a compatible implementation, **When** it is read, **Then** the conformance result is present and there is no gap result and no conflict result.
3. **Given** a stated responsibility is uncovered, **When** the implementation is read, **Then** the conformance result is incomplete and the gap is stated.
4. **Given** a realization conflicts with the architecture, **When** acceptance is attempted, **Then** nothing is written.
5. **Given** a finished implementation, **When** the architecture is read on it, **Then** the architecture is named once.
6. **Given** onboarding finishes, **When** its implementation is read, **Then** it uses these same sections.

---

### User Story 8 - See an existing implementation during discovery (Priority: P1)

A person exploring options for a new request is told when a matched architecture already has a current implementation. The notice names that implementation, the architecture, and the decision it came from. It does not ask the person to confirm it.

**Why this priority**: A later request for the same kind of capability should show what is already implemented before a new decision is made.

**Independent Test**: Complete a decision, architecture, and implementation for one option. Start discovery for a later request that matches that architecture by an exact link. The option list names the existing implementation before the options. A request that only resembles it in wording does not.

**Acceptance Scenarios**:

1. **Given** a matched architecture has a current implementation, **When** the option list is shown, **Then** the list names that implementation, the architecture, and the decision it came from before the options.
2. **Given** the later request shares no identifier, exact title, capability, objective, control, or operational expectation with that architecture, **When** the option list is shown, **Then** the existing implementation is not surfaced.
3. **Given** the notice was shown, **When** the person continues, **Then** they can still explore every option. The notice does not require its own confirmation.
4. **Given** the person selects an option whose exact title is the selected option of a current decision for that architecture, and that decision has a current implementation, **When** the proposed decision is shown, **Then** it says this uses that implementation and that architecture, and it does not ask whether the decision replaces or runs beside another.

---

### User Story 9 - Replace a decision or run beside it (Priority: P1)

A person who selects a different option for an architecture that already has a decision is asked, in the proposed decision, whether this decision replaces that one or runs beside it. The architecture outcome and the suggested next step follow that answer. Accepting the decision is the only confirmation.

**Why this priority**: Selecting SQS after Kafka is a decision about the existing record. The next step is wrong if it always creates a new architecture.

**Independent Test**: With one architecture already implemented, select a different option that matches that architecture. The proposed decision asks replace or beside and states the architecture consequence. Accepting it closes with one next step. Selecting the original option does not ask the question.

**Acceptance Scenarios**:

1. **Given** no existing decision matches, **When** the proposed decision is shown, **Then** it says this decision stands on its own and a new architecture will follow. The closing message suggests creating the reference architecture for this decision.
2. **Given** the person chooses to replace one matched decision, **When** the proposal is shown, **Then** it names that decision and says it will be marked superseded when this one is accepted, and it says whether that architecture is kept.
3. **Given** the person chooses to run beside a matched decision, **When** the proposal is shown, **Then** it says both decisions stay in force and names the architecture this decision will use. The closing message suggests creating the reference implementation for that architecture and says a new architecture is not required.
4. **Given** two architectures match, **When** the proposal is shown, **Then** it lists only those architectures. After the person picks one, the proposal is shown again with that architecture named and one consequence sentence.
5. **Given** the person changes the relationship or the architecture, **When** the proposal is shown again, **Then** it includes one consequence sentence. There is no separate confirmation of the notice.
6. **Given** a current decision for the reused architecture selected an option with the same exact title and has a current implementation, **When** this decision is accepted, **Then** the closing message names that implementation and does not suggest creating an architecture or another implementation. A different option title is not treated as already implemented.

---

### Edge Cases

- An architecture with one implementation remains valid. A second implementation is allowed, not required.
- The person declines the proposed implementation. Existing implementations are unchanged.
- A removed implementation does not count as a current implementation and does not prevent a new one for that architecture.
- Two current implementations of one architecture stay distinct records. The existing title distinction still applies when their titles would otherwise collide.
- Writing an implementation fails. The architecture and every other implementation of it remain, and the decision is unchanged.
- The architecture is written and the decision cannot be updated to name it. The architecture remains, the decision stays unchanged, and the decision-to-architecture link is not complete until a later update names the architecture.
- Onboarding creates one implementation. A person may later add another for that same architecture. Onboarding does not create that later one.
- A decision with no architecture yet still shows the architecture as None.
- An existing decision file is not rewritten by this feature. An existing architecture file is not rewritten either.
- Nothing may vary. The variation list says None. The fixed parts are still stated.
- The architecture handles no information of its own. The information section says None.
- No other component relies on a component. That component's interface says None.
- No objective, control, or operational expectation applies. That relationship section says None.
- No capability applies. Required Capabilities says None.
- A variation point says what kind of choice is free. It does not name a product, platform, or vendor.
- Onboarding writes the same architecture sections as any other architecture, and the same implementation sections as any other implementation.
- Nothing was left free to vary. The implementation's variation choices say None.
- An accepted realization has no limitations. That section says None.
- Conformance was not shown. The implementation says None for how it was shown.
- The architecture names no interface. The realized interface says None.
- A compatible implementation has no gap result and no conflict result.
- An existing implementation file is not rewritten by this feature.
- A later request only resembles an existing architecture in wording. Discovery does not surface its implementation, and the decision does not ask whether to replace or run beside it.
- The person selects an option whose exact title matches the selected option of a current decision for the matched architecture, and that decision has a current implementation. The new decision uses that implementation and that architecture. It does not ask the replace-or-beside question. A different option title is treated as not yet implemented.
- No architecture matches. The closing message suggests creating a reference architecture and does not suggest an implementation.
- The replaced decision keeps its file. Its status becomes superseded when the new decision is accepted. It leaves the architecture's list of current decisions, and the architecture catalog is updated in that same write.
- A decision that runs beside an existing one is added to that architecture's current-decision list. The earlier decision stays on the list. The architecture catalog shows both.
- Onboarding does not ask whether a decision replaces or runs beside another. It has no discovery options.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: An accepted reference architecture MUST be allowed to have more than one current reference implementation.
- **FR-002**: Creating an implementation for an architecture that already has one MUST leave every existing implementation of that architecture in place.
- **FR-003**: Creating an implementation MUST NOT change the decision statement, the rationale, the selected option, the status, or the architecture record. The decision MUST NOT be updated to name the implementation.
- **FR-004**: The decision handoff MUST name the reference architecture once that architecture exists, and MUST say None before it exists. The handoff MUST NOT contain an implementation entry.
- **FR-005**: Each implementation MUST name the one architecture it realizes. A reader MUST be able to find every current implementation of an architecture from that relationship.
- **FR-006**: A person who names an architecture that already has implementations MUST be shown those implementations and MUST still be able to propose a new one.
- **FR-007**: A person who does not name an architecture MUST be able to choose any accepted architecture, including one that already has current implementations. The choice MUST show how many current implementations that architecture has.
- **FR-008**: A proposed implementation MUST be accepted before it is written. Declining it MUST write nothing.
- **FR-009**: One decision MUST still have at most one reference architecture. A second architecture for that decision MUST be refused and the existing architecture shown.
- **FR-010**: Onboarding MUST still create one implementation for the architecture of the provider it adopts. That implementation MUST name the architecture. The decision MUST name the architecture and MUST NOT name the implementation.
- **FR-011**: When an implementation cannot be written, the architecture and any other implementations of it MUST remain, and the decision MUST stay unchanged.
- **FR-012**: A removed implementation MUST NOT count as a current implementation and MUST NOT prevent another implementation of that architecture.
- **FR-013**: When the architecture is written and the decision cannot be updated to name it, the architecture MUST remain, the decision MUST stay unchanged, and the decision-to-architecture link MUST NOT be treated as complete until a later update names the architecture.
- **FR-014**: This feature MUST NOT add a second decision for a second implementation, and MUST NOT require an architecture to have more than one implementation.
- **FR-015**: The architecture MUST state what every implementation must keep, and what an implementation may choose. When nothing may vary, the choices MUST be None. A variation MUST NOT name a product, platform, or vendor.
- **FR-016**: The architecture MUST state the responsibilities it includes. A realization's coverage list MUST be those stated responsibilities. Each one MUST be covered or not applicable. The realization MUST NOT add a responsibility the architecture does not state, and the coverage MUST NOT be a fixed category list.
- **FR-017**: The architecture MUST state the information it handles, who owns that information, and what crosses a trust boundary, or None when it handles none.
- **FR-018**: Each component MUST state its responsibility and the interface other components rely on, or None when no other component relies on it.
- **FR-019**: Context MUST state when the architecture applies and what it leaves open.
- **FR-020**: The architecture MUST state why its style was chosen.
- **FR-021**: A finished architecture identifier MUST be an RA id. Its status MUST be accepted. The catalog status MUST remain accepted or removed, and a removed row MUST still have no record file. The record MUST NOT use an ARCH identifier or status proposed.
- **FR-022**: An objective link MUST use the type advances. A control link MUST use the type bound by. An operational-expectation link MUST use the type satisfies. A section with no link MUST say None.
- **FR-023**: The architecture MUST list every current decision that names it. It MUST state what it carries from those decisions and MUST NOT copy a decision statement a second time. A superseded or removed decision MUST NOT be in that list.
- **FR-024**: The architecture MUST NOT contain a Key Technologies section. It MUST NOT name a product, platform, or vendor.
- **FR-025**: Each required capability MUST name the component that offers it. A capability MUST NOT have an identifier. When no capability applies, the section MUST say None.
- **FR-026**: Onboarding MUST write these same architecture sections.
- **FR-027**: This feature MUST NOT add an implementation plan, tasks, source code, infrastructure definitions, deployment authorization, a clock timestamp, a second copy of the decision, a second copy of the architecture, a capability identifier, or a viewpoint catalog. It MUST NOT change Controls or NFRs.
- **FR-028**: For each thing the architecture left free to vary, the implementation MUST state the choice it made. When nothing may vary, the choices MUST be None.
- **FR-029**: The implementation MUST state the limitations of this accepted realization, or None.
- **FR-030**: A finished implementation MUST include a conformance result that agrees with its coverage. When every stated responsibility is covered or not applicable, the result is compatible and the record MUST NOT include a gap result or a conflict result. When a stated responsibility is uncovered, the result is incomplete and the gap MUST be stated.
- **FR-031**: The implementation MUST state the realized interface for each architecture interface, or None when the architecture names none. It MUST state how conformance was shown, or None when it was not shown.
- **FR-032**: A technology choice MUST be stated once, with its intent, its reason, and its evidence.
- **FR-033**: The architecture MUST be named once on the implementation.
- **FR-034**: A finished implementation identifier MUST be an RI id. Its parent MUST be an RA id. Its status MUST be accepted. The record MUST NOT use an ARCH parent or status proposed.
- **FR-035**: A realization that conflicts with the architecture MUST NOT be written.
- **FR-036**: Onboarding MUST write these same implementation sections.
- **FR-037**: A match MUST be an exact link by identifier, exact title, capability, objective, control, or operational expectation. A wording resemblance MUST NOT count as a match.
- **FR-038**: When a matched architecture has a current implementation, the discovery option list MUST name that implementation, that architecture, and the decision it came from before the options. The notice MUST NOT require its own confirmation.
- **FR-039**: An option already has an implementation only when a current decision for the matched architecture selected an option with the same exact title and that decision's architecture has a current implementation. The proposed decision MUST then say it uses that implementation and that architecture, and MUST NOT ask whether the decision replaces or runs beside another. A different option title MUST NOT be treated as already implemented.
- **FR-040**: The replace-or-beside choice MUST appear only when a different option is selected and that option matches an architecture that already has a decision. It MUST be part of the proposed decision, before acceptance.
- **FR-041**: When no decision matches, the proposal MUST say this decision stands on its own and a new architecture will follow. When the person replaces a matched decision, the proposal MUST name it and say it will be marked superseded on acceptance, and MUST say whether its architecture is kept. When the person runs beside a matched decision, the proposal MUST say both decisions stay in force and MUST name the architecture this decision will use.
- **FR-042**: When more than one architecture matches, the proposal MUST list only those architectures. After one is picked, the proposal MUST be shown again with that architecture named and one consequence sentence. A change to the relationship or the architecture MUST re-show the proposal with one consequence sentence. Accepting the decision MUST be the only confirmation.
- **FR-043**: One decision MUST still name at most one architecture. More than one current decision MAY name the same architecture. A reused architecture MUST be named on the new decision, and that decision MUST be added to the architecture's current-decision list. A new architecture MUST NOT be created for that decision. The architecture record and the architecture catalog MUST be updated together so both show the same current decisions.
- **FR-044**: The closing message MUST suggest one next step. No architecture to reuse suggests creating the reference architecture for this decision. A reused architecture whose selected option has no current decision with the same exact title and a current implementation suggests creating the reference implementation for that architecture and says a new architecture is not required. When that exact-title decision and its current implementation exist, the closing message names that implementation and does not suggest creating an architecture or another implementation.
- **FR-045**: Replacing a decision MUST set that decision to superseded when the new decision is accepted, and the replaced record MUST remain. Onboarding MUST NOT ask the replace-or-beside question.
- **FR-046**: The architecture catalog MUST be able to show more than one current decision for one architecture. The implementation catalog MUST be able to show more than one current implementation for one architecture. A decision catalog row MUST show that decision's one architecture. A write that changes any of these relationships MUST update the affected records and catalogs together.

### Key Entities

- **Decision record**: One architecture decision for one specific option. It names at most one reference architecture, which may already exist and may also be named by another current decision. It does not name an implementation. It may supersede one earlier decision.
- **Reference architecture**: The conceptual architecture named by one or more current decisions. It lists those current decisions. It states what is fixed, what may vary, its responsibilities, its information, and each component's boundary. It can have many current implementations.
- **Architecture catalog**: The index of architectures. One architecture can list many current decisions. That list matches the architecture record.
- **Reference implementation**: One realization of one reference architecture. It names that architecture, records the variation choices it took, covers the architecture's stated responsibilities, and states its limitations.
- **Variation point**: One choice an implementation may make. It names the kind of choice. It does not name a product.
- **Implementation catalog**: The index of implementations. More than one current row may name the same architecture.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: An architecture can have 2 or more current implementations, and creating the second leaves the first in place.
- **SC-002**: A reader can find every current implementation of an architecture. The decision contains 0 implementation ids.
- **SC-003**: A decision names exactly one architecture once that architecture exists, and a second architecture for that decision is refused.
- **SC-004**: An architecture with 0 current implementations is not presented as having one. A removed implementation is not counted as current.
- **SC-005**: Onboarding for one provider produces 1 decision, 1 architecture, and 1 implementation. The implementation names the architecture, and the decision does not name the implementation. That architecture uses the same sections as any other.
- **SC-006**: A reader can find what is fixed, what may vary, the responsibilities, the information, and each component's responsibility and interface in the architecture, without opening an implementation.
- **SC-007**: A finished architecture uses an RA identifier and status accepted. It contains 0 ARCH identifiers, 0 proposed statuses, and 0 Key Technologies sections. Each decision statement appears once. The architecture and its catalog list the same current decisions. Every relationship link uses the one type for its section.
- **SC-008**: A reader can find, on the implementation, each variation choice, the conformance result, the realized interface, how conformance was shown, and the limitations. Each technology choice appears once. Coverage rows are the architecture's responsibilities.
- **SC-009**: A finished implementation uses an RI identifier, an RA parent, and status accepted. A compatible record contains 0 gap results and 0 conflict results. The architecture is named once.
- **SC-010**: When a matched architecture has a current implementation, the discovery option list names that implementation, the architecture, and its decision before the options. A request that only resembles the architecture in wording does not.
- **SC-011**: Selecting an option with the same exact title as a current decision that already has an implementation asks 0 replace-or-beside questions. Selecting a different option title that matches the same architecture asks that question once, inside the proposed decision.
- **SC-012**: One accepted decision produces exactly one closing next step: create the reference architecture, create the reference implementation, or the name of the implementation that already exists.

## Assumptions

- A second implementation uses the same proposal and acceptance the first one uses. This feature does not create several implementations in one acceptance.
- Onboarding still creates one implementation because it adopts one provider. Nothing later forbids another implementation of that architecture.
- The architecture stays conceptual. This feature does not put a product name on it.
- A current implementation is one whose record exists and whose catalog row is not removed.
- Records already written keep their current text. This feature changes later writes. Existing implementation files are not rewritten.
- The existing rule that separates two records with colliding titles is unchanged.
- The decision-to-architecture link from the current decision record stays. Only the single implementation id is removed from that record.
- Relationship types match the decision record: advances, bound by, and satisfies.
- A realization's coverage is the architecture's stated responsibilities, not a fixed category list. A conflict with the architecture still refuses the write. A limitation is not a conflict.
- The architecture stays a conceptual record. Applicability, variation, responsibilities, information, and component boundaries are stated in prose. They are not a viewpoint catalog.
- A decision selects a specific option. Two decisions name the same architecture when an implementer could satisfy either option and still conform to that architecture. Similar wording is not that test.
- The discovery match used for the notice and for the replace-or-beside choice is the exact match discovery already records. The model does not infer a match from prose similarity.
- The notice and the architecture consequence are information in the proposal. They are not a separate confirmation.
- A current decision is an accepted decision that has not been superseded and has not been removed. The architecture's decision list and the architecture catalog both use that meaning.
