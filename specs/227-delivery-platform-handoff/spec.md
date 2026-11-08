# Feature Specification: Delivery Platform Handoff

**Feature Branch**: `227-delivery-platform-handoff`

**Created**: 2026-11-08

**Status**: Draft

**Input**: User description: "When highway-codify needs a preferred delivery platform and the implementation record does not list one, tell the person and let them set the platforms on the implementation or name one for this run. Announce each hand-off between highway-codify and highway-implementation."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - An empty delivery platform stops the proposal (Priority: P1)

A person starts a highway-codify run for a product whose implementation does not list the delivery platform that run needs. They see why Codify cannot propose yet, and they do not see a proposal.

The message is:

**[Product Title]'s implementation record does not list preferred delivery platforms.**

Without these, Codify is unable to make proposals for [Product title].

**Would you like to set the preferred delivery platforms now?**

If you'd prefer to name the delivery platform for this single codify run, just say so. Future highway-codify runs for [Product title] will result in this same message.

**Why this priority**: A proposal with no delivery platform names a platform the person never chose.

**Independent Test**: Start highway-codify for an implementation whose needed delivery platform is empty. Read the message. Confirm no proposal appears.

**Acceptance Scenarios**:

1. **Given** an establishing action whose Deployed by is empty, **When** highway-codify reaches the point of choosing a delivery platform, **Then** it shows the message above and no proposal.
2. **Given** any other action whose Managed by is empty, **When** highway-codify reaches that point, **Then** it shows the same message and no proposal.
3. **Given** the needed delivery platform is already listed, **When** highway-codify reaches that point, **Then** it does not show this message.
4. **Given** Language is none and both delivery platforms are listed, **When** highway-codify reaches that point, **Then** it does not show this message.
5. **Given** an implementation written while bringing an existing platform into Highway, **When** that record is stored, **Then** Deployed by and Managed by are empty and Language is none.

---

### User Story 2 - Setting the platforms updates the implementation (Priority: P1)

A person who answers yes is told they are going to set the platforms, sees a short view of the implementation, and is told when control returns to the highway-codify run. The accepted platforms are stored on that implementation, so a later run does not ask again.

**Why this priority**: The record is the place those platforms are kept. The person needs to know they have left highway-codify and when they are back.

**Independent Test**: Answer yes on the message. Read the hand-off, the view, and the return hand-off. Read the stored implementation and start a second highway-codify run.

**Acceptance Scenarios**:

1. **Given** the message in User Story 1, **When** the person says yes and names no platform, **Then** the next line is "Let's set the preferred delivery platforms for [Product Title]." and the implementation view opens.
2. **Given** that view, **When** it is shown, **Then** it shows Product Title, Architecture Reference, Deployed by, Managed by, and Language, then asks what to add, correct, or remove.
3. **Given** that view, **When** the person accepts a Deployed by and a Managed by, **Then** those three fields are stored on the existing implementation, no second implementation is created, and the next line is "The preferred delivery platforms for [Product Title] are set. Picking up your highway-codify run."
4. **Given** that return, **When** highway-codify continues, **Then** the proposal uses the stored delivery platform and the empty-platform message is not shown.
5. **Given** that view, **When** the person declines, **Then** the record is unchanged and the next line is "Leaving the preferred delivery platforms for [Product Title] unset. Picking up your highway-codify run." The empty-platform message is shown again.
6. **Given** that view with Deployed by or Managed by still empty, **When** the person accepts, **Then** the empty field is named and the view stays open.

---

### User Story 3 - A named platform lasts for one run (Priority: P1)

A person who names a delivery platform uses it for this highway-codify run only. The implementation record stays as it was. The next run shows the same message.

**Why this priority**: The person can finish one run without changing the record that later runs will read.

**Independent Test**: Reply to the message with a platform name. Finish the run. Read the implementation record. Start highway-codify again for the same product.

**Acceptance Scenarios**:

1. **Given** the message in User Story 1, **When** the person names a listed delivery platform, **Then** this run uses it, the implementation record is unchanged, and no implementation view opens.
2. **Given** that run completed, **When** highway-codify starts again for the same product, **Then** the empty-platform message is shown again.
3. **Given** the message, **When** the person says they want to name a platform and does not name one, **Then** they are asked which platform, and the proposal stays hidden.
4. **Given** a name that is an accepted implementation with no delivery-platform row, **When** the person names it for this run, **Then** configuration of that platform happens first, the product implementation record stays unchanged, and this run uses the platform after configuration.
5. **Given** a name with no accepted implementation, **When** the person names it for this run, **Then** onboarding of that platform happens first, the product implementation record stays unchanged, and this run uses the platform after onboarding.
6. **Given** a yes that also names a platform, **When** the reply is read, **Then** the named platform is used for this run and the implementation view does not open.

---

### Edge Cases

- The needed platform is empty, and the other delivery platform is already listed: the message still appears, and the view shows both fields as they are stored.
- The person names a platform that is not a delivery platform and not a coding standard: the name is not used, and the empty-platform message is shown again.
- The person names a coding standard: it applies to Language for this run only. The needed delivery platform stays empty, so the message is shown again.
- Configuration or onboarding for a this-run name is declined: the product implementation record stays unchanged, and the empty-platform message is shown again.
- An implementation does not use its own row as its delivery platform.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: When the delivery platform an action needs is empty or names a platform that is not listed, highway-codify MUST show the User Story 1 message and MUST NOT show a proposal.
- **FR-002**: An establishing action needs Deployed by. Every other action needs Managed by.
- **FR-003**: Language being none MUST NOT by itself show the message.
- **FR-004**: An implementation written while bringing an existing platform into Highway MUST store Deployed by and Managed by as empty and Language as none.
- **FR-005**: A yes that names no platform MUST emit "Let's set the preferred delivery platforms for [Product Title]." and open the implementation view.
- **FR-006**: The implementation view MUST show Product Title, Architecture Reference, Deployed by, Managed by, and Language, then ask what to add, correct, or remove.
- **FR-007**: Acceptance of that view MUST store Deployed by, Managed by, and Language on the existing implementation and MUST NOT create another implementation.
- **FR-008**: After that acceptance, the next line MUST be "The preferred delivery platforms for [Product Title] are set. Picking up your highway-codify run." The proposal then uses the stored delivery platform.
- **FR-009**: A decline of that view MUST leave the record unchanged, emit "Leaving the preferred delivery platforms for [Product Title] unset. Picking up your highway-codify run.", and show the User Story 1 message again.
- **FR-010**: Acceptance of that view MUST stay open and name the field while Deployed by or Managed by is empty.
- **FR-011**: A platform named in reply to the User Story 1 message MUST be used for that highway-codify run only. The implementation record MUST stay unchanged.
- **FR-012**: The next highway-codify run for that product MUST show the User Story 1 message again when the record is unchanged.
- **FR-013**: A reply that asks to name a platform without naming one MUST ask which platform and MUST NOT show a proposal.
- **FR-014**: A this-run name that needs configuration or onboarding MUST complete that first. The product implementation record stays unchanged. After it completes, this run uses the platform.
- **FR-015**: A yes that also names a platform MUST use the named platform for this run and MUST NOT open the implementation view.
- **FR-016**: Each hand-off line is shown to the person. The person is not told about an internal return step.

### Key Entities

- **Preferred delivery platform**: Deployed by or Managed by on an implementation. Each is a listed platform, or empty.
- **Language**: The coding standard on an implementation, or none. It is not a delivery platform.
- **This-run platform**: A platform the person names for one highway-codify run. It is not stored on the implementation.
- **Implementation view**: Product Title, Architecture Reference, and the three fields above.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of highway-codify runs whose needed delivery platform is empty show the User Story 1 message before any proposal.
- **SC-002**: 100% of yes replies that name no platform show the leaving-codify line, the five-part view, and, after acceptance, the return line.
- **SC-003**: 100% of named-platform replies leave the implementation record unchanged and use that platform for that run only.
- **SC-004**: A second highway-codify run after a named-platform reply shows the User Story 1 message again. A second run after the platforms were set does not.
- **SC-005**: A person can tell which skill they are in at each hand-off without being told about an internal return step.

## Assumptions

- Empty means the stored value is missing or the word Needed. A platform that is not listed is treated the same way.
- A this-run name supplies the one delivery platform this action needs. It does not fill the other delivery platform.
- A this-run name that is a listed coding standard sets Language for this run only and does not satisfy the missing delivery platform.
- Setting the platforms reuses the existing rules for replacing Deployed by, Managed by, and Language, including configuration and onboarding when a name has no row.
- An implementation is not selected as its own delivery platform.
- Bringing an existing platform into Highway does not ask the person to fill these fields at that time.
- The hand-off sentences are used exactly as written in User Story 2.
- A no to the message stops the highway-codify run and writes nothing.
