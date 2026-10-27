# Feature Specification: Setup Welcome Overview

**Feature Branch**: `193-setup-welcome-overview`

**Created**: 2026-10-24

**Status**: Draft

**Input**: User description: "Update the Welcome message provided to the user in highway-setup. Replace the separator and 'Let's get started.' with an overview of what setup will do."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Know what setup will cover before it starts (Priority: P1)

A person running setup for the first time reads the welcome, then sees what setup will do: learn about the organization, identify business outcomes, establish safeguards, and define operational expectations. They are told they do not need everything figured out, and setup then begins.

**Why this priority**: The current welcome ends with "Let's get started." and moves straight into questions. The person does not know what the four parts of setup are or that the answers can be refined later.

**Independent Test**: Run setup in a repository with no accepted profile. The welcome shows the existing heading, tagline, and ownership statement, then the overview below, then the profile conversation begins.

**Acceptance Scenarios**:

1. **Given** no accepted profile, **When** setup starts, **Then** the welcome ends with the overview in the Welcome Overview section below instead of a separator and "Let's get started."
2. **Given** that overview, **When** it is shown, **Then** it lists the four parts of setup in the same order setup delegates them: Profile, Objectives, Controls, NFRs.
3. **Given** the overview, **When** it ends, **Then** the profile conversation begins without another welcome or transition.
4. **Given** an accepted profile already exists, **When** setup starts, **Then** the welcome and the overview are not shown.

---

### Edge Cases

- Setup is run again after a profile exists. The welcome, including the overview, is skipped as it is today.
- The heading, tagline, ownership heading, and ownership paragraph above the replaced text stay unchanged.
- The overview is shown once per first run. It is not repeated before Objectives, Controls, or NFRs.
- The existing transitions before Objectives, Controls, and NFRs stay unchanged.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The welcome MUST replace the separator and "Let's get started." with the Welcome Overview text exactly as written below.
- **FR-002**: The text above the replaced lines MUST stay unchanged: the Welcome to Highway heading, the tagline, **Your context stays yours.**, and the ownership paragraph.
- **FR-003**: The overview MUST be shown only when the welcome is shown, which is when no accepted profile exists.
- **FR-004**: After the overview, setup MUST delegate Profile with no additional transition.
- **FR-005**: The transitions before Objectives, Controls, and NFRs MUST stay unchanged.

### Welcome Overview

```markdown
---

### During setup we'll:

- **Learn about your organization**, where you'd like to go, how you plan to get there, and what principles guide decisions.
- **Identify important business outcomes** worth pursuing.
- **Establish safeguards** that future technology decisions should respect.
- **Define operational expectations** for how future solutions should behave.

You don't need to have everything figured out in advance. We'll build this foundation together, and you can refine it over time as your organization evolves.

Now, let's get started.

---
```

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A first setup run shows the overview once, with all 4 setup parts listed, before the first profile question.
- **SC-002**: A setup run with an existing profile shows the overview 0 times.
- **SC-003**: The welcome contains 0 occurrences of the standalone line "Let's get started." outside the overview's "Now, let's get started."
- **SC-004**: The text above the overview is unchanged character for character.

## Assumptions

- "During setup we'll:" is a level-3 heading, as written.
- The two horizontal rules in the overview frame it, and the closing rule separates the welcome from Profile.
- Profile's own first heading and question follow the closing rule unchanged.
- No other skill emits this welcome.
