# Feature Specification: Delivery Platform Proposal

**Feature Branch**: `228-delivery-platform-proposal`

**Created**: 2026-11-08

**Status**: Draft

**Input**: User description: "highway-implementation: I want delivery platforms to make a proposal for the needed fields based on the same criteria as the normal proposal."

## Clarifications

### Session 2026-11-08

- Q: When the delivery platforms view opens and Language is stored as `None`, should it also show the coding standard the normal proposal would pick? → A: Yes. A stored `None` Language shows the matching coding standard, or `None` when nothing matches.
- Q: If Deployed by or Managed by names a platform that has no row in the platforms catalog, should the view propose a replacement? → A: Yes. It is unset: propose a replacement by the normal rules, or show `Needed` when there is no candidate.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Setting the platforms starts from a proposal (Priority: P1)

A person who answers yes to the message reaches the highway-implementation view. Each field the record leaves unset is already filled with the platform or coding standard the normal implementation proposal would choose. The person accepts it as shown or corrects it.

**Why this priority**: The person sees a ready answer instead of `Needed`, so they can accept it in one reply.

**Independent Test**: Seed a platforms catalog with a pipeline row and a self-service row and a coding standard that matches the implementation's Technology Choice. Store an implementation with Deployed by and Managed by `Needed` and Language `None`. Answer yes on the highway-codify message. Read the view.

**Acceptance Scenarios**:

1. **Given** Deployed by is `Needed` and the platforms catalog has a candidate for it, **When** the view opens, **Then** Deployed by shows the platform the normal implementation proposal would choose.
2. **Given** Managed by is `Needed` and the catalog has a candidate for it, **When** the view opens, **Then** Managed by shows the platform the normal implementation proposal would choose.
3. **Given** Language is `None` and a listed coding standard matches the implementation's Technology Choice, **When** the view opens, **Then** Language shows that coding standard.
4. **Given** Deployed by or Managed by stores a platform that has a platforms-catalog row, or Language stores a coding standard, **When** the view opens, **Then** that field shows the stored value.
5. **Given** Deployed by or Managed by stores a platform with no platforms-catalog row, **When** the view opens, **Then** that field shows the proposed replacement, or `Needed` when there is no candidate.
6. **Given** no candidate exists for Deployed by or Managed by, **When** the view opens, **Then** that field shows `Needed`.
7. **Given** the view shows proposed values, **When** the person accepts, **Then** the shown values are stored and the return line follows.
8. **Given** the view shows proposed values, **When** the person declines, **Then** the record is unchanged and the decline line follows.

---

### Edge Cases

- The person edits a field, leaves for configuration or onboarding, and returns to the view: the edited value stays, and fields the person did not edit keep the proposal rules.
- Every catalog row has a blank Kind: no platform is a candidate, and Deployed by and Managed by show `Needed`.
- The implementation being set has its own platforms-catalog row: it is not proposed as its own delivery platform.
- No coding standard matches the Technology Choice: Language shows `None`.
- No platforms catalog and no coding-standards catalog exist: the view shows `Needed`, `Needed`, and `None`.
- A stored Deployed by or Managed by whose platforms-catalog row was removed: the view proposes a replacement, so accepting does not store the platform highway-codify rejected.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: When the highway-implementation delivery platforms view opens, each field the record leaves unset MUST show the value the normal implementation proposal would choose for it.
- **FR-002**: Deployed by and Managed by are unset when they are `Needed`, empty, or name a platform with no platforms-catalog row. Language is unset when it is `None` or empty.
- **FR-003**: A Deployed by or Managed by that names a platforms-catalog row MUST show the stored value. A Language that names a coding standard MUST show the stored value.
- **FR-004**: A Deployed by or Managed by with no candidate MUST show `Needed`. A Language with no matching standard MUST show `None`.
- **FR-005**: The implementation being set MUST NOT be proposed as its own delivery platform.
- **FR-006**: Nothing MUST be written until the person accepts the view. Acceptance stores the shown values.
- **FR-007**: A field the person edits MUST keep the person's value for the rest of that visit, including after configuration or onboarding returns to the view.
- **FR-008**: The view's fields, order, question, replies, and hand-off lines MUST stay as they are.

### Key Entities

- **Unset field**: Deployed by or Managed by that is `Needed`, empty, or names a platform with no platforms-catalog row, or Language that is `None` or empty.
- **Proposed value**: The platform or coding standard the normal implementation proposal would choose for an unset field.
- **Stored value**: A platform or coding standard already written to the implementation's Execution.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of delivery platforms views show a proposed value for each unset field that has a candidate.
- **SC-002**: With a candidate for each field, a person sets all three fields with one accepting reply.
- **SC-003**: 100% of stored values and edited values are shown as they are.

## Assumptions

- The highway-codify preferred delivery platforms message stays as it is.
- The normal implementation proposal's criteria are the existing rules that pick Deployed by, Managed by, and Language when a new implementation is proposed.
- A proposed value is shown in place of `Needed` or `None`, with no extra marker.
- Accepting a view where Deployed by or Managed by still shows `Needed` keeps the existing behavior: the field is named and the view stays open.
