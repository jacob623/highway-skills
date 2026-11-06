# Feature Specification: Configure Handoff

**Feature Branch**: `216-configure-handoff`

**Created**: 2026-11-05

**Status**: Draft

**Input**: User description: "During highway-onboarding, if the user chooses to accept a platform for automation, once all of the records have been created, notify the user they are transitioning to configure the platform for automation, and then hand off directly to highway-codify-config to configure the platform for automation. The user may also choose, while in highway-codify-config, to configure coding standards. Once the user has completed highway-codify-config, send them back to the final highway-onboarding closing. Remove 'Run /highway-codify-config Cursor to configure it for automation.' from the highway-onboarding closing. Include the same for highway-implementation."

## Clarifications

### Session 2026-11-05

- Q: Is the handoff written as deterministic instructions or as prose? → A: Deterministic instructions. Each new or changed step is numbered conditions and actions. Each branch names the next step. The return is a named step the caller passes and configuration holds. No sentence explains, justifies, or describes the flow.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Onboarding configures the platform, then closes (Priority: P1)

A person accepts a platform for automation during onboarding. After every provider's records exist, onboarding tells them it is moving on to configure that platform, and the configuration conversation begins. They can also configure coding standards before they leave. When they leave configuration, they see onboarding's closing, and that closing does not tell them to run the configuration command.

**Why this priority**: The person already said yes. The closing currently asks them to start the same work again by name.

**Independent Test**: Accept one platform for automation and finish the records. The next thing shown is the transition for that platform, then its configuration. Leave configuration from its menu. Onboarding's closing appears, with no line that says to run the configuration command for automation.

**Acceptance Scenarios**:

1. **Given** the person agreed to configure one platform, **When** every provider's records exist, **Then** onboarding emits "Let's configure [Platform] for automation." and follows `highway-codify-config` for that platform before the closing.
2. **Given** configuration was entered from onboarding, **When** the person configures coding standards and then leaves the configuration menu, **Then** onboarding emits its closing.
3. **Given** the onboarding closing, **When** it is read, **Then** it does not contain "Run `/highway-codify-config [Platform]` to configure it for automation."
4. **Given** the person agreed to configure two platforms, **When** the records exist, **Then** each platform gets its own transition and configuration, in the order the person was asked, and the closing is emitted once after the last return.
5. **Given** the person agreed to configure no platform, **When** the records exist, **Then** the closing is emitted with no transition and no configuration.

---

### User Story 2 - A new implementation does the same (Priority: P1)

A person accepts configuration at the end of a reference implementation. They are told the move, configure that platform, and can configure coding standards. Leaving the configuration menu returns them to that implementation's close. The close does not tell them to run the configuration command.

**Why this priority**: Implementation asks the same question and today ends with the same kind of pointer.

**Independent Test**: Accept an implementation that can start automation and agree to configure it. The transition is shown, configuration follows, and leaving the configuration menu shows the implementation close. The sentence "Run `/highway-codify-config [Platform]` to configure it." is absent.

**Acceptance Scenarios**:

1. **Given** a yes to configure the implementation's platform, **When** the platform row has been written, **Then** implementation emits "Let's configure [Platform] for automation." and follows `highway-codify-config` for that platform.
2. **Given** configuration was entered from implementation, **When** the person leaves the configuration menu, **Then** implementation emits its close.
3. **Given** a no, **When** the question is answered, **Then** implementation emits its close with no transition and no configuration.
4. **Given** the implementation close, **When** it is read, **Then** it does not contain "Run `/highway-codify-config [Platform]` to configure it."

---

### User Story 3 - Leaving configuration returns only when someone is waiting (Priority: P1)

Configuration started on its own still ends when the person leaves its menu. Configuration started by onboarding or implementation returns to that skill instead. While they are there, declining a platform, a standard, or a conflict returns to the configuration menu, so coding standards stay available.

**Why this priority**: The return is what makes the handoff finish in the right place. A direct visit has nobody to return to.

**Independent Test**: Start configuration directly and leave its menu. The conversation stops. Start it from onboarding, open coding standards, return to the menu, and leave the menu. Onboarding's closing appears.

**Acceptance Scenarios**:

1. **Given** a direct visit to configuration, **When** the person leaves the menu, **Then** configuration stops and writes nothing further.
2. **Given** a visit started by onboarding or implementation, **When** the person leaves the menu, **Then** control returns to that skill.
3. **Given** a platform, standard, or conflict in progress, **When** the person declines it, **Then** they return to the configuration menu.

---

### User Story 4 - Each skill states the handoff as steps (Priority: P1)

A maintainer reads the three skills and finds the handoff as numbered steps. Each step is a condition, then one action, and names the step that follows. The return is a named step. Two agents reading the same skill take the same path.

**Why this priority**: The handoff crosses three skills. A described flow leaves each agent to decide when to hand off, when to return, and where to land.

**Independent Test**: Read `configure` in onboarding, `platforms` in implementation, and Entry and `menu` in configuration. Every new sentence is a condition and an action or a named next step. No new sentence explains why. The exact step sentences in the contract are present.

**Acceptance Scenarios**:

1. **Given** onboarding, **When** it is read, **Then** `configure` is its own step between `lineage` and `summary`, with numbered steps that end in `Go to \`summary\`.` or the handoff.
2. **Given** a handoff sentence, **When** it is read, **Then** it names the platform, the caller, and the return step.
3. **Given** configuration's Entry and `menu`, **When** they are read, **Then** Entry holds the return step and the menu decline goes to that step, or stops when none is held.
4. **Given** the new and changed steps, **When** they are read, **Then** none contains so that, because, in order to, should, consider, prefer, usually, or where appropriate, and none gains MUST or SHOULD.

---

### Edge Cases

- The person leaves the configuration menu immediately. The caller goes to its return step, and no configuration is written.
- Onboarding was itself started by configuration for a platform. Onboarding does not ask the configure question for that platform, so it is not handed off. The closing still ends with "Run `/highway-codify-config [Platform]` to finish adding [Platform]." Any other platform the person agreed to configure is handed off.
- Onboarding writes a platform row by following `platforms` in `highway-implementation`. Implementation's question and handoff do not run on that path. Onboarding asks its own question.
- A platform that cannot start automation is not offered configuration and is not handed off.
- The person reviews records from the onboarding closing after they have returned. Review behaves as it does today.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `highway-onboarding` MUST add a step `configure` after `lineage` and before `summary`. `lineage` MUST go to `configure`. The procedure order MUST name it.
- **FR-002**: `configure` MUST state, in order: (1) when no platform to configure remains, go to `summary`; (2) take the first platform to configure and remove it from the list; (3) emit `Let's configure [Platform] for automation.`; (4) follow `highway-codify-config` for [Platform], with the return step `configure` in `highway-onboarding`.
- **FR-003**: `summary` MUST NOT contain "Run `/highway-codify-config [Platform]` to configure it for automation." `summary` and `review` otherwise stay as they are.
- **FR-004**: In `orchestrate`, when `highway-codify-config` started this onboarding for [Platform], onboarding MUST NOT ask the configure question for [Platform]. The closing line "Run `/highway-codify-config [Platform]` to finish adding [Platform]." MUST stay.
- **FR-005**: In `platforms` of `highway-implementation`, `accept` MUST emit `Let's configure [Platform] for automation.` and follow `highway-codify-config` for [Platform], with the return step `close` in `highway-implementation`. `decline` and `unknown` MUST go to `close`.
- **FR-006**: `highway-implementation` MUST NOT contain "Run `/highway-codify-config [Platform]` to configure it."
- **FR-007**: In Entry of `highway-codify-config`, before any other routing, a return step named by the invocation MUST be held for the rest of the visit.
- **FR-008**: In `menu` of `highway-codify-config`, `decline` MUST go to the held return step. With no held return step, it MUST stop and write nothing.
- **FR-009**: Every other `decline` in `highway-codify-config` MUST still go to `menu`. The platform write MUST still ask whether to configure coding standards for [Platform] when the platform works with code or configuration files.
- **FR-010**: A handoff MUST name the platform, so Entry opens that platform's add or update without showing the menu, as it does today.
- **FR-011**: Each new or changed step MUST be numbered conditions and actions, or a single condition and action. Each branch MUST name its next step. No new sentence explains, justifies, or describes the flow. No new sentence contains so that, because, in order to, should, consider, prefer, usually, or where appropriate. The skill bodies MUST NOT gain MUST or SHOULD.
- **FR-012**: Each new or changed step MUST be at or under 250 words, excluding the heading.
- **FR-013**: `highway-onboarding` MUST move to version 10.1.0, `highway-implementation` to 7.1.0, and `highway-codify-config` to 3.1.0.

### Key Entities

- **Platform to configure**: A platform the person agreed can start automation. Onboarding keeps the list in the conversation, in the order asked. Implementation has one, the implementation just written.
- **Configuration visit**: A run of configuration started by a caller, or started directly. A visit started by a caller returns to that caller when its menu is left. A direct visit stops.
- **Return step**: A skill and one of its step names, such as `configure` in `highway-onboarding` or `close` in `highway-implementation`. The caller names it in the handoff. Configuration holds it from Entry until the menu is left.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In a run where the person agrees to configure N platforms, they see N transition sentences and N configuration visits before one onboarding closing.
- **SC-002**: The onboarding closing contains the automation-configuration command in 0 runs. The finish-adding line still appears when configuration started that onboarding.
- **SC-003**: An implementation yes reaches the implementation close only after configuration is left. An implementation no reaches the close with no configuration visit.
- **SC-004**: A direct configuration visit ends on leaving the menu in every run. A visit started by onboarding or implementation returns to that skill in every run.
- **SC-005**: A static check finds every step sentence in the contract, the step order `lineage`, `configure`, `summary`, and none of the banned words in the new or changed steps.

## Assumptions

- "Let's configure [Platform] for automation." is the transition sentence, emitted once per platform immediately before that platform's visit.
- Leaving the configuration menu is the existing menu decline. That is what "completed highway-codify-config" means.
- After the platform write, configuration goes to coding standards on a yes, or to the platform list. Declining the list goes to `menu`. These routes exist today.
- The platform already has its row, so the visit opens that platform's update.
- When configuration starts onboarding for a new platform and that onboarding hands off a different platform, that inner visit holds `configure` in `highway-onboarding` as its return step. The outer visit's return is unchanged.
- `highway-setup` is unchanged. Its delegation of Profile, Objectives, Controls, and NFRs is the pattern this feature follows, and this feature does not modify it.
- The question "Would you like to configure [Platform] for automation?" stays where it is asked today.
