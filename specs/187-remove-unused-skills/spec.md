# Feature Specification: Remove Unused Skills

**Feature Branch**: `187-remove-unused-skills`

**Created**: 2026-10-21

**Status**: Draft

**Input**: User description: "Remove highway-clarify, highway-inquiry, highway-relationships, and highway-new. Clean up related catalogs, record templates, tests, and any other orphaned files. highway-new was renamed to highway-request and the two skills share the same output template, so do not delete that output template."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Stop offering the unused skills (Priority: P1)

A person working in a Highway repository can no longer invoke clarification, the requirements inquiry, relationship repair, or the reserved new-request name. Request work remains available through the request skill.

**Why this priority**: These four skills are no longer needed. Leaving them available keeps unused behavior in front of the person.

**Independent Test**: Look for each removed skill by name. None is offered. Invoking the request skill still describes a business request and writes it with the shared request templates.

**Acceptance Scenarios**:

1. **Given** the four unused skills, **When** the removal is complete, **Then** none of them can be invoked and none appears in the list of available skills.
2. **Given** the request skill, **When** the person invokes it, **Then** it still collects one business request and writes the request record and request catalog from the shared templates.
3. **Given** a published copy of a removed skill, **When** the removal is complete, **Then** that copy is gone from every place Highway offers skills.

---

### User Story 2 - Remove files that only those skills used (Priority: P2)

The maintainer is not left with catalogs, record templates, tests, or other files whose only purpose was one of the removed skills.

**Why this priority**: An orphaned template or test still claims a skill exists and will fail or confuse the next change.

**Independent Test**: Search for each removed skill name and for the clarification and inquiry templates. The only remaining mentions are historical notes that do not offer the skill or require its files.

**Acceptance Scenarios**:

1. **Given** the clarification record template and clarification catalog, **When** the removal is complete, **Then** both are gone because no remaining skill owns them.
2. **Given** the requirements-inquiry template, **When** the removal is complete, **Then** it is gone because no remaining skill owns it.
3. **Given** the shared request record template and request catalog, **When** the removal is complete, **Then** both remain and the request skill still cites them.
4. **Given** a test whose only purpose is one of the removed skills, **When** the removal is complete, **Then** that test is gone and the remaining checks still pass.

---

### Edge Cases

- A file mentions a removed skill only to say the name is no longer used. That mention may stay. A file that still offers the skill or requires its template may not.
- Discovery may still read an existing clarification when one is already present. This removal does not rewrite Discovery and does not delete a person's existing clarification records.
- Relationship words inside Objectives, Controls, or Non-Functional Requirements stay. Only the relationship-repair skill and files that exist only for it are removed.
- The request skill and the removed new-request name shared templates. Removing the name does not remove those templates.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The repository MUST no longer offer highway-clarify, highway-inquiry, highway-relationships, or highway-new.
- **FR-002**: Every published copy, catalog entry, and distribution inclusion of those four skills MUST be removed.
- **FR-003**: The clarification record template and clarification catalog MUST be removed.
- **FR-004**: The requirements-inquiry template MUST be removed.
- **FR-005**: The request record template and request catalog MUST remain, and highway-request MUST still use them.
- **FR-006**: Tests, checks, and other files that exist only for a removed skill or a removed template MUST be removed.
- **FR-007**: A file that a remaining skill still needs MUST stay, even if a removed skill also used it.
- **FR-008**: Profile, Objectives, Controls, Non-Functional Requirements, Setup, Request, Discovery, Decision, Reference Architecture, Reference Implementation, Onboarding, Assessment, and Help MUST remain and keep their current behavior.
- **FR-009**: The Highway constitution, the Spec Kit constitution, and the experience standard MUST remain unchanged.
- **FR-010**: After the removal, the repository checks that remain MUST pass.

### Key Entities *(include if feature involves data)*

- **Removed skill**: One of clarification, requirements inquiry, relationship repair, or the reserved new-request name. It is no longer offered.
- **Owned template**: A catalog or record template whose only owning skill is being removed. It is deleted with that skill.
- **Shared request template**: The request record template and request catalog. They stay because the request skill still writes them.
- **Orphaned file**: A test or other file that would refer to a removed skill or removed template after the skill is gone. It is deleted or updated so the reference is gone.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Zero of the four named skills can be invoked, and zero published copies of them remain.
- **SC-002**: The clarification record template, clarification catalog, and requirements-inquiry template are absent.
- **SC-003**: The request record template and request catalog are still present, and the request skill still cites both.
- **SC-004**: A search for the four removed skill names finds no file that offers the skill or requires its template.
- **SC-005**: The checks that remain after the cleanup all pass.
- **SC-006**: The twelve skills that stay are unchanged in behavior, and the three governance documents are unchanged.

## Assumptions

- highway-request is the request skill. It already replaced the behavior that highway-new used to reserve, and it already cites the shared request templates.
- Clarification templates are owned only by highway-clarify. The requirements-inquiry template is owned only by highway-inquiry. Relationship repair has no separate output template of its own.
- Discovery may mention an existing clarification as optional evidence. That mention is not a reason to keep the clarification templates or the clarification skill.
- Help remains and will simply stop listing the removed skills once they are gone.
- Published copies are every agent offer of a skill. They are removed with the source skill rather than left behind.
- This removal does not change the promoted skill interaction from the previous promotion.
