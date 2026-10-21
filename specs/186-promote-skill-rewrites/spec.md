# Feature Specification: Promote Rewritten Skills

**Feature Branch**: `186-promote-skill-rewrites`

**Created**: 2026-10-21

**Status**: Draft

**Input**: User description: "Create a new spec for implementing the proposed migration of the new skills to the main repository. Promote the rewritten skills as the behavior, retire checks that only lock the previous interaction, keep the constitutions, the experience standard, the skill authoring and publishing machinery, and the shared output templates, and add a small set of invariant checks."

## Clarifications

### Session 2026-10-21

- Q: Where should this promotion take the rewritten skill texts from? → A: The draft suite in the sibling folder `highway-skills-v2`.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Use the rewritten skills (Priority: P1)

A person working in a Highway repository invokes the rewritten skills and receives the interaction those rewrites already define. The published skill and every copy offered to an agent are the same skill.

**Why this priority**: The rewritten interaction is the product. Until it replaces the current skills, the person is still using the previous suite.

**Independent Test**: Invoke each rewritten skill with no prior record identifier. The skill offers the reviewed interaction, including a numbered list of actionable records when an identifier is required and was not supplied. Each line shows the identifier and its title.

**Acceptance Scenarios**:

1. **Given** the rewritten Profile, Objectives, Controls, Non-Functional Requirements, and Setup skills, **When** the person runs Setup, **Then** those skills guide the foundational context and Setup advances only when each owning skill finishes.
2. **Given** a completed Request, **When** the person runs Discovery without naming a record, **Then** Discovery lists complete Requests that do not already have a Discovery and accepted Discoveries that can be explored, numbered in one sequence, each with its identifier and title.
3. **Given** an accepted Discovery with no Decision, **When** the person runs the Decision skill without naming a record, **Then** the skill lists only Discoveries that do not already have a Decision, numbered, each with its identifier and title, and then lists that Discovery's options the same way.
4. **Given** an accepted Decision with no Reference Architecture, **When** the person runs the architecture skill without naming a record, **Then** the skill lists only those Decisions and creates a conceptual Reference Architecture that names no platform, product, vendor, or specific technology.
5. **Given** an accepted Reference Architecture with no Reference Implementation, **When** the person runs the implementation skill without naming a record, **Then** the skill lists only those architectures and records the realization, including who provides each capability.
6. **Given** accepted foundational context and current landscape records, **When** the person runs Onboarding or Assessment, **Then** those skills follow the reviewed rewritten interaction.
7. **Given** any rewritten skill, **When** it is published for each supported agent, **Then** every published copy matches the source skill.

---

### User Story 2 - Retire obsolete interaction checks (Priority: P2)

The maintainer can change the rewritten skills without a check forcing the previous wording, readiness reports, sequential identifiers, or the previous architecture identifier prefix. Checks that protect the constitution, the experience standard, skill authoring, and shared output templates remain.

**Why this priority**: The previous checks would reject the rewritten skills. Removing them is what makes the promotion sustainable. Keeping the governance checks is what keeps the repository honest.

**Independent Test**: Compare the check suite before and after the promotion. Every removed check names the superseded behavior. A check that protects the constitution, the experience standard, authoring, or a shared output template still passes. The constitution text and the experience standard text are unchanged.

**Acceptance Scenarios**:

1. **Given** a check whose only purpose is to require the previous skill interaction, **When** the promotion is complete, **Then** that check is gone and the retirement names the behavior it no longer enforces.
2. **Given** the Highway constitution, the Spec Kit constitution, and the experience standard, **When** the promotion is complete, **Then** their text is unchanged and their checks still pass.
3. **Given** a shared output template the rewritten skills still use, **When** a rewritten skill needs a column or status the template does not allow, **Then** the template is updated to that skill's catalog and every skill that uses the template still agrees with it.
4. **Given** a skill that was not part of the rewrite, **When** the promotion is complete, **Then** that skill and its checks remain.

---

### User Story 3 - Confirm the lasting invariants (Priority: P3)

The maintainer can confirm a small set of invariants without locking a transcript of each skill. The same title yields the same identifier. A removed record keeps its identifier taken. One Discovery has at most one Decision. A Reference Architecture stays conceptual.

**Why this priority**: These are the rules that must survive further wording changes. They are separate from the full interaction, which already lives in the rewritten skills.

**Independent Test**: Create or inspect records for each invariant and confirm the check fails when the invariant is broken and passes when it holds.

**Acceptance Scenarios**:

1. **Given** a new record title, **When** its identifier is derived, **Then** the identifier is the record prefix plus eight hexadecimal digits from that title, contains no person-identifying fragment, and does not come from a clock or a local program.
2. **Given** an existing identifier for a different title, including a removed record, **When** a new record would reuse it, **Then** the skill asks for a title change and does not explain the derivation.
3. **Given** a Discovery that already has a Decision, **When** another Decision is proposed for it, **Then** the existing Decision is shown and no second Decision is written.
4. **Given** a Reference Architecture, **When** it is read, **Then** it names no platform, product, vendor, or specific technology. Those names remain on the Decision or the Reference Implementation.
5. **Given** an Objectives, Controls, or Non-Functional Requirements catalog, **When** it is read, **Then** its status is active or removed. **Given** a Request, Discovery, Decision, Reference Architecture, or Reference Implementation catalog, **When** it is read, **Then** its status is accepted or removed.

---

### Edge Cases

- The name used by the previous request skill stays reserved. The rewritten request skill is offered under the new request name.
- Onboarding records a Decision, a Reference Architecture, and a Reference Implementation without a Request or a Discovery. Those records remain valid and trace to onboarding.
- A numbered choice list is empty. The skill says nothing is waiting and writes nothing.
- A removed catalog row still occupies its identifier. That record is not offered as actionable work.
- The person supplies an identifier and a number is unnecessary. The skill uses the supplied identifier and does not replace it with a list.
- Both a Request and a Discovery are supplied to Discovery. The person is asked which one to use.
- An edit during architecture review names a platform, product, vendor, or specific technology. The skill keeps that name out of the architecture and says it belongs on the Reference Implementation.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The repository MUST offer the rewritten Profile, Objectives, Controls, Non-Functional Requirements, Setup, Request, Discovery, Decision, Reference Architecture, Reference Implementation, Onboarding, and Assessment skills as the skills a person invokes.
- **FR-002**: The rewritten skill text in the sibling folder `highway-skills-v2` MUST be the behavior for each of those skills, including the catalog drafts in that folder. This promotion MUST NOT restate or redesign that interaction.
- **FR-003**: Every published copy of a promoted skill MUST match its source skill.
- **FR-004**: The previous request-skill name MUST remain reserved. Request work MUST be offered only as the rewritten request skill.
- **FR-005**: A skill that requires one or more existing records, and is invoked without them, MUST list the actionable records in catalog order, numbered from 1. Each line MUST show the identifier and its title. A stated number MUST select that record.
- **FR-006**: An actionable record MUST be one the skill can still act on. A record that already has the downstream record, including a removed downstream row, MUST stay off that list.
- **FR-007**: Checks whose only purpose is to enforce the previous skill interaction MUST be removed. Each removal MUST name the superseded behavior. A check MUST NOT be loosened while still claiming to enforce that previous behavior.
- **FR-008**: The Highway constitution, the Spec Kit constitution, and the experience standard MUST remain unchanged. Their checks MUST still pass.
- **FR-009**: Skill authoring rules and shared output templates MUST remain. A template MUST change only to agree with a promoted skill's catalog. Every skill that cites a changed template MUST still agree with it.
- **FR-010**: Skills that were not rewritten MUST remain, including clarification, help, and relationship repair.
- **FR-011**: Record identifiers MUST stay the record prefix plus eight hexadecimal digits derived from the title. The same title MUST reuse its identifier. A collision with a different title MUST ask for a title change without explaining the derivation.
- **FR-012**: One Discovery MUST have at most one Decision.
- **FR-013**: A Reference Architecture MUST stay conceptual. It MUST NOT name a platform, product, vendor, or specific technology.
- **FR-014**: Objectives, Controls, and Non-Functional Requirements catalogs MUST use active or removed. Request, Discovery, Decision, Reference Architecture, and Reference Implementation catalogs MUST use accepted or removed.
- **FR-015**: The promotion MUST add checks for FR-011, FR-012, FR-013, and FR-014, and those checks MUST be seen failing before the promoted behavior is treated as complete.

### Key Entities *(include if feature involves data)*

- **Rewritten skill**: One of the twelve skills in the sibling folder `highway-skills-v2` whose reviewed text replaces the current skill. That text, and its catalog draft, is the authority for that skill's interaction.
- **Actionable record**: A catalog row the invoked skill can still act on, shown with its identifier and title.
- **Retired check**: A check that exists only to enforce an interaction the rewritten skills replace. Its retirement names that superseded behavior.
- **Governance document**: The Highway constitution, the Spec Kit constitution, or the experience standard. These stay in force and are not rewritten by this promotion.
- **Invariant**: A lasting rule checked without locking a skill transcript: identifier derivation, one Decision per Discovery, a conceptual Reference Architecture, and the allowed catalog statuses.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 12 rewritten skills are the skills a person can invoke, and each published copy matches its source.
- **SC-002**: Invoking any of Discovery, Decision, Reference Architecture, or Reference Implementation without an identifier produces a numbered list of only the actionable records, and each line includes the identifier and the title.
- **SC-003**: The person can select any listed record by saying its number, without typing the full identifier.
- **SC-004**: Zero checks remain whose only job is to require the previous skill interaction. Every removed check names the behavior it no longer enforces.
- **SC-005**: The Highway constitution, the Spec Kit constitution, and the experience standard remain the same documents they are now, and their existing checks pass.
- **SC-006**: A second Decision for the same Discovery is refused, and a Reference Architecture that names a platform, product, vendor, or specific technology is refused.
- **SC-007**: A person can finish Setup, Onboarding, and Assessment using the rewritten skills without being asked for a readiness state, a sequential identifier, or the previous architecture identifier prefix.

## Assumptions

- The draft suite in the sibling folder `highway-skills-v2` is the source for this promotion, including its skill texts and catalog drafts. Those drafts already contain the interaction, the catalogs, and the statuses. This spec does not reopen those choices.
- The maintainer is the only current user of the suite, and the suite is still under development. Transcript locks are deferred until the wording settles.
- Clarification, help, and relationship repair were not part of the rewrite and stay as they are.
- Shared output templates stay. Their columns stay aligned with the catalogs the rewritten skills name. Status values follow FR-014.
- A removed catalog row keeps its identifier taken and is not actionable work.
- Onboarding may create a Decision, a Reference Architecture, and a Reference Implementation without a Request or a Discovery. That path is part of the rewritten Onboarding skill.
- Publishing a skill means every agent offer of that skill matches the source. Hand-maintained copies are not an acceptable result.
- The constitution rule that a behavioral change includes a new or amended check, and that a test is observed failing before the behavior is complete, applies to the new invariant checks. It does not require the retired interaction checks to be rewritten in place.
