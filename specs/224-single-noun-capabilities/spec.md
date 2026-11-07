# Feature Specification: Single Noun Capabilities

**Feature Branch**: `224-single-noun-capabilities`

**Created**: 2026-11-07

**Status**: Draft

**Input**: User description: "create a new spec for implementing this change to a single capability based on your proposal." A capability is one noun phrase of fewer than five words. It has no "and" and names one thing. Modifiers are allowed, so Online Payments and Class Registration are capabilities, and Class and Workshop Registration is two. The static capability is replaced with "AI-Augmented Technology Development". The `establish` check on capability titles in highway-codify is removed, because a noun phrase never contains that verb.

## Clarifications

### Session 2026-11-07

- Q: When a person adds or edits a capability title that joins two things, what should the proposal do? → A: Split right away into one capability per part, and say so in the consequence sentence.
- Q: When a joined title is a set phrase that reads as one idea, such as "Research and Development", should it be split like any other joined title? → A: Yes. Split it like any other joined title. The consequence sentence explains that when one part is later done apart from the other, a joined capability compounds the effect of that change.
- Q: What is the word limit? → A: No more than five words. A title of six or more words is shortened.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Onboarding proposes one capability per item (Priority: P1)

A person onboarding their technology landscape sees a starting list of capabilities. Each item names one capability. When accepted context names two activities, such as class registration and workshop registration, each activity becomes its own capability, even when one technology supports both.

**Why this priority**: Onboarding is where compound capabilities start today. One step merges two activities that share a technology into one capability, and that merge produces titles such as Class and Workshop Registration.

**Independent Test**: Run onboarding with accepted context that names class registration and workshop registration, both supported by one platform. The starting list shows Class Registration and Workshop Registration as two items.

**Acceptance Scenarios**:

1. **Given** accepted context naming class registration and workshop registration supported by one platform, **When** the starting list is proposed, **Then** it shows two capabilities, Class Registration and Workshop Registration, and neither title contains "and".
2. **Given** those two capabilities, **When** they are mapped, **Then** both may map to the same provider, and the mapping by provider lists both under that provider.
3. **Given** the starting list, **When** the person adds "Class and Workshop Registration", **Then** the list shows Class Registration and Workshop Registration as two items, and the consequence sentence says the entry was split.
4. **Given** the starting list, **When** the person adds "Research and Development", **Then** the list shows Research and Development as two items, and the consequence sentence says that if research is later done apart from development, one joined capability would compound the effect of that change.
5. **Given** the starting list, **When** the person adds a title of six or more words, **Then** the list shows a title of five words or fewer that keeps the person's meaning, and the consequence sentence names the shortened title.
6. **Given** any proposed capability, **When** its title is read, **Then** it is one noun phrase of five words or fewer, with no "and", "or", "&", "/", "+", or comma.

---

### User Story 2 - The static capability is AI-Augmented Technology Development (Priority: P1)

A person onboarding sees AI-Augmented Technology Development as the first capability. The agent platform the session identifies is its provider.

**Why this priority**: The static capability is shown to every organization. Its current title, AI-Assisted Engineering and Planning, joins two things with "and".

**Independent Test**: Run onboarding in a session that identifies its agent platform. The first item is AI-Augmented Technology Development. Its provider is that agent platform.

**Acceptance Scenarios**:

1. **Given** a first onboarding run, **When** the starting list is shown, **Then** item 1 is **AI-Augmented Technology Development**, and AI-Assisted Engineering and Planning appears 0 times.
2. **Given** a session that identifies Cursor as its agent platform, **When** AI-Augmented Technology Development is mapped, **Then** its provider is Cursor.
3. **Given** an accepted ADR that already records AI-Augmented Technology Development for the same agent-platform name, **When** the starting list is shown, **Then** that item is left out.
4. **Given** the person removes the item before accepting, **When** the list is accepted, **Then** the capability is not queued for mapping.

---

### User Story 3 - Implementations and architectures store one capability per entry (Priority: P1)

A person reviewing an implementation proposal sees one capability per entry, and the accepted record and capability catalog keep one row per capability. A person reviewing an architecture proposal sees required capabilities with the same shape.

**Why this priority**: Implementations store capabilities, and later skills read those titles to match requests, suggest automation, and find reuse. A compound title becomes a compound catalog row.

**Independent Test**: Propose an implementation from an architecture whose realization serves class registration and workshop registration. The proposal shows two capabilities. Accept it and read the capability catalog.

**Acceptance Scenarios**:

1. **Given** a realization that serves class registration and workshop registration, **When** the implementation is proposed, **Then** Capabilities shows Class Registration and Workshop Registration as two entries, each with its own Realized by.
2. **Given** that proposal, **When** the person edits a capability to "Class and Workshop Registration", **Then** the proposal shows two capabilities, and the consequence sentence says the entry was split.
3. **Given** the accepted implementation, **When** the capability catalog is read, **Then** it has one row per capability, each with its own id, and no row title contains a joining word or symbol.
4. **Given** an architecture whose components offer class registration and workshop registration, **When** the architecture is proposed, **Then** Capabilities names each one on its own entry with its component.

---

### User Story 4 - Configuration records new capabilities with the same shape (Priority: P2)

A person configuring a platform for automation sees New Realized Capabilities. Each title is one noun phrase of five words or fewer. The implementation records only titles with that shape.

**Why this priority**: Configuration adds realized capabilities to an accepted implementation. It currently allows titles of up to five words and does not forbid "and".

**Independent Test**: Configure a platform whose documentation describes building and deploying as two automations. New Realized Capabilities lists two titles. Accept, and read the implementation's Realized Capabilities.

**Acceptance Scenarios**:

1. **Given** platform documentation that describes two automations, **When** the platform proposal is shown, **Then** New Realized Capabilities lists each as its own title of five words or fewer, with no joining word or symbol.
2. **Given** a title passed to the implementation that breaks the shape, **When** the implementation records new capabilities, **Then** that title is left out and named, and the other titles are recorded.

---

### User Story 5 - Codify suggestions no longer read establish from a capability title (Priority: P2)

A person starting codify for an accepted implementation sees suggested actions. The establish suggestion comes from the implementation title. Each capability gives one suggestion of its own.

**Why this priority**: Codify treats a capability as establishing when its title contains `establish`. A noun phrase never contains that verb, so the check can no longer match.

**Independent Test**: Start codify for an implementation with no running instance and two realized capabilities. The first suggestion is Establish [implementation title], followed by one suggestion per capability in record order.

**Acceptance Scenarios**:

1. **Given** an implementation with no running instance, **When** suggestions are shown, **Then** the first is `Establish [implementation title]`, followed by one suggestion per realized capability in Realized Capabilities order.
2. **Given** an implementation with a running instance, **When** suggestions are shown, **Then** each comes from a realized capability in Realized Capabilities order, and none is `Establish [implementation title]`.
3. **Given** an implementation with a running instance and no realized capability, **When** suggestions are shown, **Then** the only suggestion is `Run [implementation title]`.
4. **Given** any suggestion list, **When** codified actions are removed, **Then** at most five suggestions remain, dropped from the end.
5. **Given** a chosen action titled `Establish [implementation title]`, **When** the executor is chosen, **Then** the executor is still Deployed by.

---

### Edge Cases

- A hyphenated word counts as one word. AI-Augmented Technology Development is three words.
- A plural noun is still one capability. Online Payments is one capability.
- A set phrase that contains a joining word, such as Research and Development, is split like any other joined title, into Research and Development as two capabilities. It is not kept whole and not rewritten into a new phrase. The person can correct the result before accepting.
- A title that names a product or vendor is still not a capability, whatever its length.
- Two capabilities split from one entry keep the order of the original entry and take its place in the list.
- Two split capabilities may share one provider, one Realized By value, and one piece of evidence.
- A split title that matches a capability already on the list is not added twice.
- A capability catalog id is derived from the shorter title. An id that collides follows the existing collision rule.
- Requests and codify still match a realized capability title that appears in full in the person's words. Shorter titles make that match more likely. The match rule is unchanged.
- A discovery's Key Capabilities column describes product features in market research. It is not a Highway capability and is out of scope.
- Older records, catalogs, and ADRs that keep a compound title or the old static title are not rewritten.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A capability title MUST be one noun phrase of five words or fewer. A hyphenated word counts as one word. Modifiers MAY precede the noun.
- **FR-002**: A capability title MUST NOT contain "and", "or", "&", "/", "+", or a comma.
- **FR-003**: Onboarding MUST propose one capability for each business activity that accepted context names, including when two activities rely on one technology. The rule that merges two activities into one capability MUST be removed.
- **FR-004**: When the person adds or corrects a capability with a joining word or symbol, the proposal MUST split it right away into one capability for each joined part, without asking first. A set phrase MUST be split the same way. The consequence sentence MUST say the entry was split, and MUST say that when one part is later done apart from the other, a joined capability would compound the effect of that change. The person MAY correct the split before accepting.
- **FR-005**: When the person adds or corrects a capability of six or more words, the proposal MUST show a title of five words or fewer that keeps the person's meaning, and the consequence sentence MUST name it.
- **FR-006**: The static onboarding capability MUST be titled AI-Augmented Technology Development. The title AI-Assisted Engineering and Planning MUST NOT appear in the skill suite.
- **FR-007**: The rules for including, omitting, and removing the static capability, and for assigning the agent platform as its provider, MUST apply to AI-Augmented Technology Development.
- **FR-008**: The implementation proposal MUST show each realized capability as its own entry that meets FR-001 and FR-002. An edit that breaks either rule MUST be handled as FR-004 or FR-005.
- **FR-009**: The implementation record and the capability catalog MUST store one row per capability. Each title MUST meet FR-001 and FR-002.
- **FR-010**: When the implementation records new capabilities passed by configuration, it MUST leave out and name each title that breaks FR-001 or FR-002, and MUST record the rest.
- **FR-011**: Configuration MUST title each new realized capability as one noun phrase of five words or fewer that meets FR-002.
- **FR-012**: Each architecture required capability MUST meet FR-001 and FR-002, and MUST name the component that offers it.
- **FR-013**: Codify MUST NOT classify a realized capability as establishing by reading its title.
- **FR-014**: When no instance is running, the first codify suggestion MUST be `Establish [implementation title]`, followed by one suggestion per realized capability in Realized Capabilities order.
- **FR-015**: When an instance is running, codify suggestions MUST come from realized capabilities in Realized Capabilities order. When the implementation has no realized capability, the only suggestion MUST be `Run [implementation title]`.
- **FR-016**: Codify MUST still leave out codified actions and keep at most five suggestions, dropped from the end.
- **FR-017**: An action whose title contains `establish` MUST still take Deployed by as its executor. Only the check on capability titles is removed.

### Key Entities

- **Capability**: One thing technology does for the organization, titled as one noun phrase of five words or fewer with no joining word or symbol. It appears on onboarding lists, implementation records, the capability catalog, architecture required capabilities, and configuration's new realized capabilities.
- **Static capability**: AI-Augmented Technology Development, shown on the first onboarding list and provided by the session's agent platform.
- **Codify suggestion**: An action offered at the start of codify. The establish suggestion comes from the implementation title. Every other suggestion comes from one realized capability.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 0 proposed or stored capability titles contain "and", "or", "&", "/", "+", or a comma.
- **SC-002**: 100% of proposed or stored capability titles have five words or fewer.
- **SC-003**: Accepted context that names two activities supported by one technology yields 2 capabilities, not 1.
- **SC-004**: The skill suite shows AI-Augmented Technology Development as the static capability and contains AI-Assisted Engineering and Planning 0 times.
- **SC-005**: Codify reads `establish` from a capability title 0 times. With no running instance, the first suggestion is `Establish [implementation title]` every time.
- **SC-006**: An action titled `Establish [implementation title]` takes Deployed by as its executor every time.

## Assumptions

- The limit is no more than five words, matching configuration's current limit. The person changed it from fewer than five words after implementation.
- "Or" and the symbols "&", "/", "+", and a comma join two things the same way "and" does, so they are excluded too.
- A split keeps the person's words for each part and repeats a shared noun when there is one, so Class and Workshop Registration becomes Class Registration and Workshop Registration. With no shared noun, each part stands alone, so Research and Development becomes Research and Development as two capabilities.
- The static capability keeps its description: Using AI systems to assist with research, planning, and implementation of technology solutions. A description may name several activities. Only the title is limited.
- highway-request, highway-assessment, highway-adr, highway-discovery, highway-objectives, highway-nfrs, highway-controls, and highway-profile need no change.
- The `establish` check on an action title, which chooses Deployed by as the executor, stays. It reads the action, not a capability.
- Skill and template version numbers are decided in planning.
- This project is in development. Existing records, catalogs, and ADRs are not migrated.
