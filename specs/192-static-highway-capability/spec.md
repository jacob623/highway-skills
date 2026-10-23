# Feature Specification: Static Highway Capability

**Feature Branch**: `192-static-highway-capability`

**Created**: 2026-10-22

**Status**: Draft

**Input**: User description: "Add this static Highway capability to highway-onboarding."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See Highway on the capability list (Priority: P1)

A person starting onboarding sees Highway as one capability, with the other capabilities Highway believes they have. They can keep it, correct it, or remove it before the list is accepted.

**Why this priority**: The person is using an agent platform to run Highway for the business. Onboarding currently records only observed business platforms, so that work never becomes a capability.

**Independent Test**: Start onboarding. The capability list includes one Highway line with the agreed sentence. Removing that line leaves the other capabilities in place.

**Acceptance Scenarios**:

1. **Given** a new capability list, **When** it is shown, **Then** it includes **Highway:** Connect accepted business goals, decisions, architecture, and implementation work into a single traceable system of knowledge.
2. **Given** that list, **When** the person removes the Highway line and accepts the rest, **Then** Highway is not mapped and does not receive a decision.
3. **Given** other capabilities on the list, **When** the Highway line is included, **Then** those other capabilities keep their own descriptions and are not renamed to Highway.

---

### User Story 2 - Name the agent platform as the provider (Priority: P2)

When the Highway capability is mapped, its provider is the agent platform the person is using. The person can correct that name. Other capabilities are not assigned that platform unless they are work the platform actually performs.

**Why this priority**: Highway is the work. Cursor, VS Code, Claude, or Codex is where that work runs. The platform must be recorded on this capability only.

**Independent Test**: Accept a capability list that includes Highway. The mapping shows the agent platform as Highway's provider. A capability such as invoicing keeps its own provider.

**Acceptance Scenarios**:

1. **Given** Highway was accepted and the agent platform is known, **When** Highway is mapped, **Then** the provider is that platform.
2. **Given** the agent platform is not known, **When** Highway is mapped, **Then** the person is asked to name the platform, using the same prompt used when any other provider cannot be inferred.
3. **Given** a mapped Highway provider, **When** the person corrects the name, **Then** the corrected name is the provider that continues.
4. **Given** another capability that the agent platform does not operate, **When** that capability is mapped, **Then** its provider is not replaced by the agent platform.

---

### Edge Cases

- The person removes Highway before accepting the capability list. It is not mapped, and no decision, architecture, or implementation is created for it.
- The person accepts Highway. It is mapped and then follows the existing onboarding path for a provider: one decision, one reference architecture, and one reference implementation.
- An accepted Highway provider already exists. Onboarding does not add a second Highway capability for the same platform.
- The session being open is not a reason to assign the agent platform to every capability.
- Onboarding does not authorize the agent platform to act on its own.
- The Highway sentence stays the agreed sentence unless the person edits it.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The capability starting point MUST include this line: **Highway:** Connect accepted business goals, decisions, architecture, and implementation work into a single traceable system of knowledge.
- **FR-002**: The person MUST be able to correct or remove that line before accepting the capability list.
- **FR-003**: A removed Highway line MUST NOT be mapped and MUST NOT receive a decision, reference architecture, or reference implementation.
- **FR-004**: When Highway is accepted and the agent platform is known, its mapped provider MUST be that platform.
- **FR-005**: When the agent platform is not known, mapping MUST ask the person to name it, using the same prompt used for any other capability whose provider cannot be inferred.
- **FR-006**: A corrected provider name MUST be the provider that continues for Highway.
- **FR-007**: The agent platform MUST NOT replace the provider of a capability it does not operate.
- **FR-008**: An accepted Highway provider MUST NOT be added a second time for the same platform.
- **FR-009**: Onboarding MUST NOT authorize the agent platform to act on its own.
- **FR-010**: Other capabilities MUST keep their own descriptions.

### Key Entities *(include if feature involves data)*

- **Highway capability**: The static capability on the starting point. Its sentence is the agreed sentence unless the person edits it.
- **Agent platform**: The provider for that capability, such as Cursor, VS Code, Claude, or Codex. It is where Highway runs.
- **Other capability**: Work the organization already does. It keeps its own provider.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A new capability list shows the Highway line once, with the agreed sentence.
- **SC-002**: Removing that line produces 0 Highway mappings and 0 Highway decisions.
- **SC-003**: When the agent platform is known, Highway's mapped provider matches that platform, and 0 other unrelated capabilities are reassigned to it.
- **SC-004**: A second onboarding pass does not add a second Highway capability for a platform that already has an accepted Highway provider.

## Assumptions

- The capability title is **Highway**. The sentence is exactly: Connect accepted business goals, decisions, architecture, and implementation work into a single traceable system of knowledge.
- The line is part of the capability starting point. Onboarding accepts that whole list unless the person removes or corrects a line.
- "Known" means the session identifies the agent platform by name. When it does not, the person names the provider. Onboarding does not guess a product name.
- After the mapping is accepted, Highway follows the existing provider path. This feature does not change how a decision, reference architecture, or reference implementation is written.
- The agent platform is not treated as the provider of invoicing, customers, or any other capability it does not operate.
