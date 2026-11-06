# Feature Specification: Group Realized Capabilities

**Feature Branch**: `220-group-realized-capabilities`

**Created**: 2026-11-06

**Status**: Draft

**Input**: User description: "Group New Realized Capabilities by the automation. The title names the capability. A product name and a handoff, such as a pull request, stay in the evidence."

## Clarifications

### Session 2026-11-06

- Q: How long should the title of a new realized capability be? → A: One noun phrase, five words or fewer, the same limit as a When to use entry.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - One capability per automation (Priority: P1)

A person adds or updates a platform. Documentation describes several features that perform the same automation. The proposal lists that automation once. The title names the automation. The evidence names the documented features and the handoff.

**Why this priority**: Each accepted capability is recorded on the implementation. One automation recorded three times, once per feature, fills that record with the same work.

**Independent Test**: Add a platform whose documentation describes three features that review a change and hand it off through a pull request. New Realized Capabilities lists one review capability. The title does not name a product or a pull request. The evidence names the features and the pull request.

**Acceptance Scenarios**:

1. **Given** two documented features that perform the same automation, **When** the proposal is shown, **Then** New Realized Capabilities lists that automation once.
2. **Given** that capability, **When** its row is read, **Then** the title is one noun phrase of five words or fewer naming the automation, and the evidence names each documented feature and the handoff.
3. **Given** a handoff such as a pull request, a comment, or a ticket, **When** the proposal is shown, **Then** the handoff appears in the evidence and is not its own capability.

---

### User Story 2 - Different work stays separate (Priority: P1)

A person reads the same proposal. Features that do different work stay separate capabilities.

**Why this priority**: Grouping by meaning still has to keep a scheduled run distinct from a review, and a review of one change distinct from a scan that is not that review.

**Independent Test**: Add a platform whose documentation describes a scheduled run, a scripted run, an agent proposing a change, a review of that change, and a scan that is not a review of one change. The proposal lists five capabilities.

**Acceptance Scenarios**:

1. **Given** documentation that describes a scheduled or event-triggered run, a scripted run, proposing a change, and reviewing a change, **When** the proposal is shown, **Then** each of those is its own capability.
2. **Given** a scan that is not a review of one change, **When** the proposal is shown, **Then** the scan is its own capability.
3. **Given** one feature whose description covers two different automations, **When** the proposal is shown, **Then** each automation is its own capability, and the feature is named in both evidence lines.

---

### User Story 3 - An existing capability is not proposed again (Priority: P2)

A person updates a platform. The implementation already records a capability that means the same automation, under a different title. The proposal does not list it again.

**Why this priority**: A new title for an automation the implementation already records adds a duplicate to the record.

**Independent Test**: Update a platform whose Realized Capabilities already mean "automated review of a change," under another title. The documentation describes a review feature. New Realized Capabilities does not list that review.

**Acceptance Scenarios**:

1. **Given** an implementation capability that means the same automation as a grouped capability, **When** the proposal is shown, **Then** that capability is not listed under New Realized Capabilities.
2. **Given** a grouped capability the implementation does not already mean, **When** the proposal is shown, **Then** it is listed.
3. **Given** no new capability, **When** the proposal is shown, **Then** New Realized Capabilities shows `None`.

---

### User Story 4 - The grouping is ordered steps (Priority: P1)

A maintainer reads `current`. The grouping is numbered conditions and actions, and `current` stays within 400 words.

**Why this priority**: `current` already captures each capability and marks the new ones. The grouping has to sit in that step, in order, or the two rules disagree.

**Independent Test**: Read `current`. The grouping steps follow the capture step and precede the step that goes to the proposal. `current` has 400 words or fewer.

**Acceptance Scenarios**:

1. **Given** `current`, **When** it is read, **Then** capture comes first, then grouping by meaning, then the title and evidence rule, then marking what the implementation does not already mean.
2. **Given** a new or changed step, **When** it is read, **Then** it is a numbered condition and action, and it contains no so that, because, in order to, should, consider, prefer, usually, or where appropriate.
3. **Given** the change, **When** `current` is counted, **Then** it has 400 words or fewer, excluding its heading.

---

### Edge Cases

- When the documentation cannot be read, no capability is marked new, as today.
- A capability the documentation no longer describes is not proposed, as today.
- A standard proposal has no New Realized Capabilities section. This change does not add one.
- A platform remove leaves out New Realized Capabilities, as today.
- A product name inside a title is evidence, so the title is rewritten to the automation before the proposal is shown.
- A title longer than five words is rewritten to one noun phrase of five words or fewer before the proposal is shown. A hyphenated word counts as one word.
- Two features that share a handoff and do different work stay two capabilities. The shared handoff appears in both evidence lines.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `current` MUST group captured platform capabilities that perform the same automation, judged by meaning, before it marks any of them new.
- **FR-002**: The title of a new realized capability MUST be one noun phrase of five words or fewer naming the automation. A hyphenated word counts as one word. A product name and a handoff, such as a pull request, a comment, or a ticket, MUST go in the evidence and MUST NOT be a capability of their own.
- **FR-003**: `current` MUST mark a grouped capability new only when the implementation's Realized Capabilities do not already mean that automation. That match is by meaning.
- **FR-004**: Features that do different work MUST stay separate capabilities. A scheduled or event-triggered run, a scripted run, proposing a change, and reviewing a change stay separate when the documentation describes each. A scan that is not a review of one change stays its own capability.
- **FR-005**: One documented feature that describes two automations MUST yield two capabilities, and the feature MUST be named in both evidence lines.
- **FR-006**: `current` MUST replace its present steps 4 through 7 with these steps, keeping steps 1 through 3:

  4. Group captured platform capabilities that perform the same automation. Judge sameness by meaning.
  5. Name that automation in the title, as one noun phrase of five words or fewer. Count a hyphenated word as one word. Put a product name and a handoff, such as a pull request, a comment, or a ticket, in the evidence.
  6. For a platform, mark each grouped capability that the implementation's Realized Capabilities do not already mean as a new realized capability. Judge that by meaning.
  7. Do not propose a capability the documentation no longer describes.
  8. When the documentation cannot be read, say: The current documentation could not be read. Add no capability as current. Mark no new realized capability. Continue from the accepted implementation and the catalogs already present.
  9. Then go to the proposal named with this step.

- **FR-007**: `current` MUST stay at 400 words or fewer, excluding its heading. Every new or changed step MUST be a numbered condition and action, and MUST NOT contain so that, because, in order to, should, consider, prefer, usually, or where appropriate.
- **FR-008**: `highway-codify-config` MUST move from 3.2.2 to 3.2.3.
- **FR-009**: A standard proposal MUST NOT gain a New Realized Capabilities section. A platform remove MUST still leave that section out. Step 2 of `current`, the standard capture, MUST stay as it is.

### Key Entities

- **New realized capability**: one automation the current documentation describes and the implementation does not already mean. Its title is one noun phrase of five words or fewer naming the automation. Its evidence names the documented features and the handoff.
- **Handoff**: the way a feature presents its result, such as a pull request, a comment, or a ticket. It is evidence, not a capability.
- **Existing realized capability**: a capability already on the implementation. A grouped capability with the same meaning is not proposed again.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Features that perform one automation produce one New Realized Capabilities row, and the row's title is one noun phrase of five words or fewer naming that automation.
- **SC-002**: A pull request, a comment, a ticket, or a product name appears in the evidence and is not a separate capability.
- **SC-003**: A scheduled run, a scripted run, proposing a change, reviewing a change, and a scan that is not a review of one change are separate rows when the documentation describes each.
- **SC-004**: An automation the implementation already means is absent from New Realized Capabilities.
- **SC-005**: `current` has 400 words or fewer.
- **SC-006**: The existing suite passes with 0 failures after the change.

## Assumptions

- Sameness is the same test `conflicts` already uses: meaning, not the wording of a title or a product name.
- The proposal shape stays `**[Title]:** Realized By: [Platform]. Evidence: [What the current documentation describes.]`. This spec changes what `current` puts in the title and the evidence. The title uses the same five-word count as a When to use entry, including a hyphenated word as one word.
- The four-way split in the request, scheduled runs, scripted runs, proposing a change, and reviewing a change, is an example of different work. It is not a closed list of capabilities every platform must have.
- After acceptance, recording still follows `highway-implementation` with the return step `platform written`. This spec does not change that handoff.
- The version change is PATCH, 3.2.2 to 3.2.3. Grouping changes which capabilities are proposed. It does not change the catalog format.
- Tests that pin `current` steps 4 through 7 move with reasons recorded in planning. Step 4's "do not list" match becomes a match by meaning, and "Then go to the proposal named with this step." becomes step 9.
- Coding standards are out of this change. Their rules and their When to use entries stay as spec 219 left them.
