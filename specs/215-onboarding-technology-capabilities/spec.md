# Feature Specification: Onboarding Technology Capabilities

**Feature Branch**: `215-onboarding-technology-capabilities`

**Created**: 2026-11-05

**Status**: Draft

**Input**: User description: "Create a new spec to implement the following in highway-onboarding: Replace 'What we'll do together' and 'This is where Highway helps you navigate your technology landscape.' with 'Let's get to know your technology landscape'. The model should be proposing technology-related capabilities. Currently, I'm getting capabilities unrelated to technology."

## Clarifications

### Session 2026-11-05

- Q: Should the overview bullet "**Identify important business capabilities** your organization relies on." change so it names technology capabilities? → A: Change it to "**Identify the technology capabilities** that support your business."
- Q: When accepted context names a business activity but no system that supports it, should Highway still propose the technology capability that activity relies on? → A: Yes. Propose the technology capability the activity relies on, name no system, and let `map` ask for the provider.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The starting point lists technology capabilities (Priority: P1)

A person starts onboarding. The capabilities Highway proposes are each something software, a platform, a service, or infrastructure delivers for the organization, named for what that technology does. When context names a business activity and no system, Highway still proposes the technology capability that activity relies on and names no system. An activity that no technology supports is not proposed.

**Why this priority**: Onboarding brings existing platforms into Highway. Each accepted capability is mapped to a provider and becomes a decision, an architecture, and an implementation. A capability that no technology delivers produces records with nothing to map.

**Independent Test**: Run onboarding on a repository whose accepted Profile describes business activities, some with the systems that support them and some without. Each proposed capability names what a technology does. An activity with no named system still yields its technology capability. An activity that no technology supports does not appear.

**Acceptance Scenarios**:

1. **Given** accepted context that names a business activity and the system that supports it, **When** the starting point is built, **Then** the capability is named for what that system does, such as Online Payments, not for the business function, such as Sales.
2. **Given** accepted context that names a business activity and no system, **When** the starting point is built, **Then** the technology capability that activity relies on is proposed, and no system is named. `map` asks for the provider.
3. **Given** accepted context that names an activity no technology supports, **When** the starting point is built, **Then** that activity is not proposed.
4. **Given** a proposed capability, **When** it is shown, **Then** its description says what the technology does for the organization.
5. **Given** the first capability list, **When** it is shown, **Then** AI-Assisted Engineering and Planning is still included under its existing rule.

---

### User Story 2 - The overview opens with the new heading (Priority: P2)

The overview opens with the level-3 heading "Let's get to know your technology landscape". The previous heading and the sentence that followed it are gone. The first onboarding bullet names technology capabilities. The rest of the overview stays as written.

**Why this priority**: The heading sets what onboarding is about. It is a wording change, so it ranks below the capability rule.

**Independent Test**: Start onboarding. The overview's first line is the level-3 heading "Let's get to know your technology landscape". Neither "What we'll do together" nor "This is where Highway helps you navigate your technology landscape." appears. The next line is the sentence about connecting existing capabilities.

**Acceptance Scenarios**:

1. **Given** the first onboarding turn, **When** the overview is shown, **Then** it opens with the level-3 heading "Let's get to know your technology landscape".
2. **Given** the overview, **When** it is read, **Then** "What we'll do together" and "This is where Highway helps you navigate your technology landscape." are absent.
3. **Given** the overview, **When** it is read, **Then** the first onboarding bullet is "**Identify the technology capabilities** that support your business."
4. **Given** the overview, **When** it is read, **Then** every other line stays as written, including the line naming the organization.

---

### Edge Cases

- The person adds or corrects a capability that names a business function. Their wording is kept, as it is today.
- Accepted context names only business activities and no systems. The starting point holds the technology capability each activity relies on, and `map` asks for every provider.
- Accepted context names no activity that technology supports. The starting point holds only AI-Assisted Engineering and Planning, when its rule includes it, and the person adds the rest.
- Two business activities rely on the same technology. One capability is proposed for that technology.
- Context joins two technology activities in one capability. Each is proposed as its own item, as it is today.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `overview` MUST emit "Let's get to know your technology landscape" as its level-3 heading, in place of "What we'll do together".
- **FR-002**: `overview` MUST NOT emit "This is where Highway helps you navigate your technology landscape."
- **FR-003**: Every other overview line MUST stay as written, except as FR-008 decides.
- **FR-004**: `capabilities` MUST propose only capabilities that software, a platform, a service, or infrastructure delivers, grounded in an activity or system that accepted context names.
- **FR-005**: Each proposed capability MUST be named for what that technology does for the organization, not for the business function it supports.
- **FR-006**: When accepted context names a business activity, `capabilities` MUST propose the technology capability that activity relies on, whether or not context names the system. It MUST NOT name a system the context does not name. It MUST leave out an activity that no technology supports. `map` asks for an unnamed provider as it does today.
- **FR-007**: The capability description in `capabilities` and in `map` MUST say what the technology does for the organization, in place of "[What the organization does.]". Business Purpose in `map` stays.
- **FR-008**: The overview line "- **Identify important business capabilities** your organization relies on." MUST become "- **Identify the technology capabilities** that support your business."
- **FR-009**: The AI-Assisted Engineering and Planning line, the person's own wording on an edit or addition, and one capability per item MUST stay as they are.
- **FR-010**: Verification MUST state the new heading and the technology rule.
- **FR-011**: `highway-onboarding` MUST move to version 10.0.0, because the capabilities it proposes are narrowed.

### Key Entities

- **Technology capability**: Something software, a platform, a service, or infrastructure delivers for the organization. Its title names what that technology does. Its description says what it does for the organization. It is mapped to a provider in `map`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In a run grounded in context with business activities, every proposed capability other than one the person adds names what a technology does.
- **SC-002**: An activity that no technology supports is proposed in 0 runs. A system the context does not name is shown on the starting point in 0 runs.
- **SC-003**: The overview's first line is the new heading in every run, its first bullet names technology capabilities, and the replaced lines appear in 0 runs.
- **SC-004**: Every existing onboarding check other than those this feature replaces still passes.

## Assumptions

- The new heading replaces both the old heading and the sentence after it. "We'll connect existing capabilities so future recommendations align with [Name]'s target direction." follows the heading.
- Accepted context means accepted Profile, Objectives, Controls, NFRs, ADRs, architectures, implementations, or material the person supplies, as the step reads today.
- The person owns the capability list. A business function they add is kept and mapped as today.
- `map`, `mapping`, `orchestrate`, and the providers it allows (platforms, services, processes, or people) stay as they are.
- The capability catalog and the implementation record still call the row title the business capability. That wording is outside this feature.
- The mapping transition sentence "We've identified the capabilities that matter to your organization." stays.
- Installed agent copies are regenerated from the skill.
