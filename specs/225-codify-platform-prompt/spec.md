# Feature Specification: Codify Platform Prompt

**Feature Branch**: `225-codify-platform-prompt`

**Created**: 2026-11-07

**Status**: Draft

**Input**: User description: "replace the following in highway-onboarding: **[Platform] is included as a platform that can start automation.** **Would you like to configure [Platform] for automation?** with: **[Platform] is included as a platform highway can use in highway-codify proposals** **Would you like to configure how highway-codify uses [Platform]?**" Added the same day: "replace the following in highway-codify-config: **Here is a proposed starting point for configuring [Platform] as a platform capable of executing automation** with: **Here is a proposed starting point for configuring how highway-codify uses [Platform]**"

## Clarifications

### Session 2026-11-07

- Q: highway-implementation's `platforms` step shows the identical two lines outside onboarding. Should they change too? → A: Yes. Both skills use the new wording.
- Q: When the person says yes, should the line that starts configuration also change from "Let's configure [Platform] for automation." to "Let's configure how highway-codify uses [Platform]."? → A: Yes, in both highway-onboarding and highway-implementation.
- Q: Should the highway-codify-config menu option "View or Update Platforms highway considers for automation and self-service." change to match the new wording? → A: Yes. It becomes "View or Update Platforms highway-codify can use in proposals."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Onboarding says what an included platform is for (Priority: P1)

A person onboarding a provider whose implementation can start automation is told that the platform is included, and is asked whether to configure it. Today both lines speak of "automation" in general. The person does not learn that the platform is now one highway-codify can propose, or that configuring it shapes how highway-codify uses it.

**Why this priority**: The question decides whether the person enters highway-codify-config. A person who does not know what the platform is included for cannot judge whether to configure it.

**Independent Test**: Onboard a provider whose implementation is a pipeline. Read the two lines shown after the platform row is written.

**Acceptance Scenarios**:

1. **Given** onboarding writes a platforms catalog row for GitHub Pipeline, **When** the included line is shown, **Then** it reads **GitHub Pipeline is included as a platform highway can use in highway-codify proposals**.
2. **Given** that included line, **When** the question follows, **Then** it reads **Would you like to configure how highway-codify uses GitHub Pipeline?**
3. **Given** the new question, **When** the person says yes, no, or does not know, **Then** onboarding behaves as it does today: a yes adds the platform to the platforms to configure, and every answer continues onboarding.
4. **Given** a yes for GitHub Pipeline, **When** onboarding starts configuring it after lineage, **Then** it emits "Let's configure how highway-codify uses GitHub Pipeline."
5. **Given** onboarding's text, **When** it is read, **Then** none of "is included as a platform that can start automation.", "Would you like to configure [Platform] for automation?", or "Let's configure [Platform] for automation." remains.

---

### User Story 2 - Implementation asks the same question (Priority: P1)

A person accepting an implementation directly through highway-implementation sees the same included line and question after the platform row is written, in the same wording as onboarding.

**Why this priority**: The same platform can be included through either skill. Different wording for one event would describe it two ways.

**Independent Test**: Accept an implementation whose technology is an agent that starts the work, outside onboarding. Read the two lines shown after the platform row is written.

**Acceptance Scenarios**:

1. **Given** highway-implementation writes a platforms catalog row for Cursor outside onboarding, **When** the included line and question are shown, **Then** they match the wording in User Story 1 with Cursor as the platform.
2. **Given** that question, **When** the person answers, **Then** highway-implementation behaves as it does today: a yes goes to highway-codify-config for that platform, and a no or an unknown goes to `close`.
3. **Given** a yes for Cursor, **When** highway-implementation hands off to highway-codify-config, **Then** it emits "Let's configure how highway-codify uses Cursor."
4. **Given** highway-implementation's text, **When** it is read, **Then** none of "is included as a platform that can start automation.", "Would you like to configure [Platform] for automation?", or "Let's configure [Platform] for automation." remains.

---

### User Story 3 - The configuration proposal names what it configures (Priority: P1)

A person who said yes to the question enters highway-codify-config and sees the platform proposal. Its heading speaks of the platform as "capable of executing automation", which does not match the question they just answered. The heading names what the proposal configures: how highway-codify uses that platform.

**Why this priority**: The heading is the first line after the yes. It continues the question's wording, so the person sees that the proposal answers the question they were asked.

**Independent Test**: Add GitHub Pipeline as a platform in highway-codify-config, then update it. Read the heading above each proposal before any edit.

**Acceptance Scenarios**:

1. **Given** an add of GitHub Pipeline with no edit yet, **When** the platform proposal is shown, **Then** its heading reads **Here is a proposed starting point for configuring how highway-codify uses GitHub Pipeline**.
2. **Given** an update of GitHub Pipeline with no edit yet, **When** the platform proposal is shown, **Then** it shows the same heading.
3. **Given** a remove, or a proposal re-shown after an edit, **When** it is shown, **Then** it has no heading, as today.
4. **Given** a person who opens highway-codify-config without naming a platform, **When** the menu is shown, **Then** its platforms option reads "**View or Update Platforms** highway-codify can use in proposals."
5. **Given** highway-codify-config's text, **When** it is read, **Then** neither "as a platform capable of executing automation" nor "highway considers for automation and self-service" remains.

---

### Edge Cases

- A platform that cannot start automation, such as a store or a backup, gets no row, no included line, and no question. This is unchanged.
- When highway-codify-config started this onboarding for a platform, onboarding does not ask the question for that platform. This is unchanged.
- The new included line has no closing period, as the person supplied it. The new question ends with a question mark.
- The new proposal heading has no closing period, as the person supplied it.
- A person who opens highway-codify-config directly, without the question, sees the same heading.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Onboarding MUST show the included line as **[Platform] is included as a platform highway can use in highway-codify proposals**, in bold, with no closing period.
- **FR-002**: Onboarding MUST ask **Would you like to configure how highway-codify uses [Platform]?**, in bold, after the included line.
- **FR-003**: Onboarding MUST NOT contain "is included as a platform that can start automation." or "Would you like to configure [Platform] for automation?".
- **FR-004**: The answers to the question MUST keep their current effect: a yes adds the platform to the platforms to configure in the order asked, and every answer continues onboarding.
- **FR-005**: When and for which platforms onboarding shows the two lines MUST NOT change.
- **FR-006**: highway-implementation's `platforms` step MUST show the same included line and question as FR-001 and FR-002, and MUST NOT contain the replaced wording.
- **FR-007**: The answers to highway-implementation's question MUST keep their current effect: a yes goes to highway-codify-config for that platform, and a no or an unknown goes to `close`.
- **FR-008**: highway-codify-config's platform proposal MUST show the heading **Here is a proposed starting point for configuring how highway-codify uses [Platform]**, in bold, with no closing period, on an add or update with no edit yet.
- **FR-009**: highway-codify-config MUST NOT contain "as a platform capable of executing automation".
- **FR-010**: When the platform proposal shows the heading MUST NOT change: an add or update with no edit yet shows it, and a remove or a re-shown proposal does not.
- **FR-011**: When a yes starts configuration, highway-onboarding and highway-implementation MUST emit "Let's configure how highway-codify uses [Platform]." and MUST NOT contain "Let's configure [Platform] for automation.".
- **FR-012**: highway-codify-config's menu MUST show its platforms option as "**View or Update Platforms** highway-codify can use in proposals." and MUST NOT contain "highway considers for automation and self-service". The option's position and what choosing it does are unchanged.

### Key Entities

- **Included line**: The bold statement shown after a platform row is written to the platforms catalog. It names the platform and what highway can now do with it.
- **Configure question**: The bold question after the included line. A yes leads to highway-codify-config for that platform.
- **Proposal heading**: The bold line above highway-codify-config's platform proposal on an add or update with no edit yet. It names the platform and what the proposal configures.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of onboarding and implementation runs that show the question, the person sees the new included line and the new question, with the platform's name in both.
- **SC-002**: 0 occurrences of the replaced wording, including "Let's configure [Platform] for automation." and "highway considers for automation and self-service", remain in highway-onboarding, highway-implementation, or highway-codify-config.
- **SC-003**: The share of yes, no, and unknown answers that continue onboarding is unchanged: 100%.
- **SC-004**: A person reading the two lines can say, without further explanation, that configuring the platform affects highway-codify proposals.
- **SC-005**: In 100% of platform proposals for an add or update with no edit yet, the heading names how highway-codify uses the platform, and 0% describe the platform as capable of executing automation.

## Assumptions

- In highway-onboarding and highway-implementation, only the two bold lines and the line that starts configuration change. The step that writes the row, the platforms-to-configure list, the order of `configure`, and `summary` are unchanged.
- In highway-codify-config, only the proposal heading and the menu's platforms option change. The proposal's fields, its consequence sentence, its edit lines, and the other menu options are unchanged.
- The wording is used exactly as supplied, including the missing period on the included line and the proposal heading.
- Backward compatibility is not required. Existing records and catalogs are not touched, since the change affects only what is shown.
- Tests that pin the replaced wording move to the new wording in the same change.
