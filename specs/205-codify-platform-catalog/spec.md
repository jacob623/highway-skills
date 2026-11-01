# Feature Specification: Codify Platform Catalog

**Feature Branch**: `205-codify-platform-catalog`

**Created**: 2026-11-01

**Status**: Draft

**Input**: User description: "highway-implementation keeps a catalog of platforms that can start automation. Include a platform when its implementation is accepted, and say it is included and that /highway-codify configure removes it. configure shows the catalog and asks what to add, correct, or remove. A store or other target is not included. Onboarding uses the same inclusion. The Provider is the codify platform executing the automation. The diagram is a logical flow that includes that provider."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Include a platform that can start automation (Priority: P1)

A person accepts an implementation for a platform that can start automation, such as Cursor, a pipeline, an orchestrator, a self-service platform, or a desired-state or GitOps tool. The platform is included in the catalog. The person is told it is included and how to remove it. They are not asked a question. A platform that is only a target of automation, such as Shopify, Notion, Flodesk, or Time Machine, is not included and produces no such message.

**Why this priority**: The catalog is what later automations are allowed to use as a means. Inclusion has to happen when the implementation is accepted, without a second decision.

**Independent Test**: Accept an implementation of Cursor that starts work as an agent. The catalog contains Cursor once, and the message names Cursor and `/highway-codify configure`. Accept an implementation of Shopify. The catalog does not gain Shopify, and that message is not shown.

**Acceptance Scenarios**:

1. **Given** an accepted implementation of Cursor whose realization is an agent that starts the work, **When** the implementation is recorded, **Then** Cursor is in the catalog once and the person is told "Cursor is included as a platform that can start automation. To remove it, run /highway-codify configure."
2. **Given** an accepted implementation of a pipeline, an orchestrator, a self-service platform such as Backstage or ServiceNow, or a desired-state or GitOps tool, **When** the implementation is recorded, **Then** that platform is included once and the same two sentences name it.
3. **Given** an accepted implementation of Shopify, Notion, Flodesk, or Time Machine, **When** the implementation is recorded, **Then** the catalog is unchanged and the inclusion message is not shown.
4. **Given** Cursor is already in the catalog, **When** that implementation is opened, **Then** the catalog stays as it was and the inclusion message is not shown.
5. **Given** the person removed Cursor from the catalog, **When** that implementation is accepted again, **Then** Cursor is included again and the two sentences are shown again.
6. **Given** onboarding records an implementation that can start automation, **When** that implementation is written, **Then** the platform is included and the same two sentences are shown. No question is asked.

---

### User Story 2 - Change the catalog from codify (Priority: P1)

A person runs `/highway-codify configure`. They see the catalog and are asked what they would add, correct, or remove. Adding a system keeps it as theirs. Removing Cursor takes Cursor out. Correcting a row replaces that row. This path does not start an automation, a suggestion list, or a proposal.

**Why this priority**: Inclusion is automatic. The person needs one place to take a platform out or to name a system of their own.

**Independent Test**: With Cursor in the catalog, run `/highway-codify configure`, remove Cursor, and add a pipeline the person names. The catalog no longer contains Cursor and does contain that pipeline. No automation is written.

**Acceptance Scenarios**:

1. **Given** the catalog lists Cursor, **When** the person runs `/highway-codify configure`, **Then** the catalog is shown and they are asked "What would you add, correct, or remove?"
2. **Given** that question is showing, **When** the person removes Cursor, **Then** Cursor is no longer in the catalog and no automation record changes.
3. **Given** that question is showing, **When** the person adds a system of their own, **Then** the catalog contains that system, marked as one they added.
4. **Given** that question is showing, **When** the person corrects a row, **Then** that row is replaced and the other rows stay.
5. **Given** the catalog is empty, **When** the person runs `/highway-codify configure`, **Then** they are told nothing is included yet and asked the same question.
6. **Given** the person declines, **When** configure ends, **Then** the catalog is unchanged and no automation is started.
7. **Given** the invocation is `/highway-codify configure`, **When** an implementation titled with that word also exists, **Then** configure still opens the catalog and does not select that implementation.

---

### User Story 3 - Use an included platform for a different implementation (Priority: P1)

A person codifies an action for Shopify and wants Cursor to carry it out. Cursor is in the catalog because its own implementation can start automation. Cursor is the Provider on every task, because Cursor is the platform executing the automation. Shopify is a target of those tasks, not the Provider. The diagram is one logical flow: Cursor performs each action on its target, in task order. The proposal does not refuse Cursor for being absent from the Shopify records.

**Why this priority**: This is the refusal the person does not want. The platform that executes the automation has to be the Provider, including when the target's records do not name it.

**Independent Test**: With Cursor in the catalog, propose an automation for Shopify. Every task's Provider is Cursor. The diagram shows Cursor performing each action on its target. It does not say Cursor cannot be the Provider because the Shopify records omit it.

**Acceptance Scenarios**:

1. **Given** Cursor is in the catalog and the person is proposing an automation for Shopify, **When** the proposal is shown, **Then** every task's Provider is Cursor and Shopify is a target.
2. **Given** that proposal has two tasks, **When** the diagram is shown, **Then** it is one logical flow in which Cursor performs the first action on the first target and the second action on the second target, in task order.
3. **Given** the person edits the proposal to name another catalog platform, **When** the proposal is shown again, **Then** that platform is the Provider on every task and the diagram shows it performing each action.
4. **Given** the person names a platform that is not in the catalog, **When** the proposal is shown again, **Then** that platform is the Provider, and one sentence says it is not included and that `/highway-codify configure` can add it.
5. **Given** the catalog is empty and the person names no platform, **When** the proposal is shown, **Then** it says a platform that can start automation is needed, points to `/highway-codify configure`, and does not use the person or Shopify as the Provider.
6. **Given** an automation was already saved, **When** the person removes its platform from the catalog, **Then** that saved automation is unchanged.

---

### Edge Cases

- A platform already in the catalog is accepted again. The catalog still has one row for it, and the two inclusion sentences are shown again.
- The person removes a platform that is not in the catalog. They are told it is not included. Nothing else is written.
- The person corrects a row that is not in the catalog. They are told it is not included. Nothing else is written.
- Two included platforms can execute automation. The proposal uses one of them as the Provider on every task. The person can correct which platform.
- A task's target is the thing the action changes. The Provider is the platform executing the action. The same proposal does not give one task a different Provider from the next.
- The diagram shows the Provider performing each action. It does not show a target performing the next action, and it does not add a separate executor node.
- The person adds a system that matches an included platform's name. The existing row is kept and they are told it is already included.
- Onboarding records a target such as Shopify. The catalog is unchanged.
- Opening an accepted implementation does not include it and does not show the inclusion message.
- Declining configure writes nothing.
- Existing implementations are not scanned. A platform already accepted is included when that implementation is accepted again, or when the person adds it from configure.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: When an implementation is accepted, the platform MUST be included in the catalog only when that realization can start automation. The qualifying cases are a pipeline, an orchestrator, a self-service platform, a desired-state or GitOps tool, and an agent that starts the work.
- **FR-002**: A platform that is only a target of automation MUST NOT be included. Accepting it MUST NOT show the inclusion message.
- **FR-003**: Inclusion MUST add one row for that platform. The row names the platform and the implementation it came from. A second inclusion of the same implementation MUST NOT add a second row.
- **FR-004**: On inclusion the person MUST be told "[Platform] is included as a platform that can start automation. To remove it, run /highway-codify configure." No question is asked.
- **FR-005**: Opening an accepted implementation MUST NOT change the catalog and MUST NOT show the inclusion message. Accepting that implementation again MUST include it again, including after the person removed it.
- **FR-006**: Onboarding MUST apply the same inclusion after it writes an implementation that can start automation, and MUST show the same two sentences. It MUST NOT ask a question.
- **FR-007**: `/highway-codify configure` MUST be handled before an implementation is chosen. It MUST show the catalog and ask "What would you add, correct, or remove?" It MUST NOT start a suggestion list, a proposal, or an automation.
- **FR-008**: Adding a system MUST keep it in the catalog as one the person added. Removing a listed platform MUST drop that row. Correcting a row MUST replace that row and leave the others. Declining MUST leave the catalog unchanged.
- **FR-009**: The Provider MUST be the one codify platform that executes the automation. Every task MUST name that same platform as its Provider. The implementation being automated is a target and MUST NOT be the Provider. Absence of that platform from the architecture or the implementation being automated MUST NOT refuse it.
- **FR-010**: A platform the person names that is not in the catalog MUST stay the Provider. The proposal MUST say it is not included and that `/highway-codify configure` can add it.
- **FR-011**: When the catalog lists platforms and the person names none, the proposal MUST use one included platform as the Provider. When the catalog is empty and the person names none, the proposal MUST say a platform that can start automation is needed, point to `/highway-codify configure`, and MUST NOT use the person or the target as the Provider.
- **FR-012**: Changing the catalog MUST NOT change an automation that is already saved, and MUST NOT change the implementation, the architecture, or the decision.
- **FR-013**: The proposal diagram MUST be one logical flow of the automation. The Provider MUST appear in that flow. Each task MUST appear, in order, as an action that Provider performs on the task's target. The flow MUST NOT start from a separate executor, and a target MUST NOT be shown performing the next action.

### Key Entities

- **Platform catalog**: The organization's list of platforms that can start automation. Each row is a platform included from an accepted implementation, or a system the person added. A target of automation has no row.
- **Included platform**: A pipeline, orchestrator, self-service platform, desired-state or GitOps tool, or agent that starts the work, recorded from its implementation.
- **Person's system**: A row the person added from configure. It has no implementation of its own. It can be the Provider when the person names it.
- **Provider**: The one codify platform that executes the automation. Every task names it. The diagram shows it performing each action.
- **Target**: The platform, object, or API a task changes. The implementation being automated is a target. It is not the Provider.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Accepting Cursor, a pipeline, an orchestrator, a self-service platform, or a desired-state or GitOps tool adds 1 catalog row and shows the inclusion message 1 time. Accepting Shopify adds 0 rows and shows that message 0 times.
- **SC-002**: Opening an included implementation changes the catalog 0 times. Accepting it again after a removal adds the row 1 time.
- **SC-003**: `/highway-codify configure` shows the catalog and the question 1 time, and starts 0 automations. A removal drops 1 row. An added system appears 1 time, marked as the person's.
- **SC-004**: A Shopify proposal whose Provider is Cursor shows Cursor as the Provider on every task 1 time, shows Cursor performing each action in the diagram 1 time, and refuses Cursor for being absent from the Shopify records 0 times.
- **SC-005**: Removing a platform changes already saved automations 0 times.
- **SC-006**: A proposal with 2 tasks shows 2 actions leaving the Provider in the diagram and shows a target performing the next action 0 times.

## Assumptions

- The catalog is organization knowledge at `library/knowledge/codify-platforms.md` from the repository root. It is not a roster of every accepted implementation. Profile, onboarding, and assessment continue to create no technology inventory.
- `highway-implementation` includes a qualifying platform when it records the implementation. `/highway-codify configure` is the only place that adds, removes, or corrects rows after that.
- "Can start automation" is judged from the accepted implementation. A store, a newsletter, a records product, or a backup does not qualify. An agent qualifies only when it starts the work, which is why Cursor qualifies and Shopify does not.
- The inclusion message uses the platform's implementation title. For Cursor the two sentences are exactly "Cursor is included as a platform that can start automation. To remove it, run /highway-codify configure."
- Configure uses the established question "What would you add, correct, or remove?"
- The Provider is the platform executing the automation, not the person and not the target the tasks change. A platform the person names is kept as that Provider even when the catalog does not list it yet. Configure is how it becomes reusable.
- When several included platforms could execute the automation, the proposal uses one as the Provider on every task, and the person can correct it.
- The diagram is a logical flow of the work. The Provider is in the flow, and each task is an action that platform performs on one target, in task order. The saved diagram matches the accepted proposal.
- Already accepted implementations are not scanned and are not backfilled. The person can add one from configure, or include it by accepting that implementation again.
- Existing automations, implementations, architectures, and decisions are not rewritten.
- Onboarding writes implementations itself, so it performs this inclusion itself. It still does not ask the implementation skill's questions.
