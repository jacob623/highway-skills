# Feature Specification: Help Skill

**Feature Branch**: `006-help-skill`

**Created**: 2026-09-07

**Status**: Draft

**Input**: User description: "I would like to create a help skill. Every skill that is created
or updated must register its name, description, version and usage guidance with an example
that can be copied. The help skill will accept an optional skill as input. If a specific skill
is declared, only show the help for that skill. If a skill is not declared, show help for all
skills. The output format to the terminal/chat must be consistent.

Single Skill format:
Name:
Description:
Dependencies:
Version:
Usage:
Example:

Multi Skill format:
Name:
Usage:
Help: (copy-able help command for the specific skill)"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Get help for one named skill (Priority: P1)

An author or an agent knows (or suspects) the identifier of one skill and wants its full,
consistent registration in one place — what it does, what it depends on, its version, and how
to use it — without opening the skill's file directly.

**Why this priority**: This is the primary reason the help skill exists: turning a skill's
buried registration details into a single, predictable, on-demand answer.

**Independent Test**: Can be fully tested by requesting help for one existing, fully registered
skill and confirming the response contains exactly the six labeled fields (Name, Description,
Dependencies, Version, Usage, Example), each populated, in the same order every time.

**Acceptance Scenarios**:

1. **Given** a registered skill with usage guidance, a copy-able example, and no declared
   dependencies, **When** help is requested for that skill by identifier, **Then** the response
   shows Name, Description, Dependencies (explicitly "none"), Version, Usage, and Example, in
   that order, with no field blank or missing.
2. **Given** a registered skill that declares one or more dependencies, **When** help is
   requested for that skill, **Then** the Dependencies field lists each declared dependency.
3. **Given** an identifier that does not match any registered skill, **When** help is requested
   for it, **Then** the response is a clear error naming the unrecognized identifier, and it does
   **not** fall back to showing every skill.

---

### User Story 2 - Discover all registered skills at once (Priority: P1)

An author or an agent does not know which skills exist yet, or wants a quick reminder of what is
available, and wants a single, scannable list rather than opening every skill's file.

**Why this priority**: Equally core to the feature's value — discovery without a target
identifier is the other half of "help", and both modes share one consistent, predictable output
contract.

**Independent Test**: Can be fully tested by requesting help with no skill declared and
confirming the response lists every currently registered skill, each showing exactly Name,
Usage, and a copy-able Help command, in that order, with one entry per skill and none omitted.

**Acceptance Scenarios**:

1. **Given** three registered skills, **When** help is requested with no skill declared, **Then**
   the response lists all three, each showing Name, Usage, and a Help command that names that
   skill specifically (not a generic template).
2. **Given** the Help command shown for one listed skill, **When** it is copied and run verbatim,
   **Then** it produces that same skill's single-skill help output (User Story 1's format).
3. **Given** zero skills are currently registered, **When** help is requested with no skill
   declared, **Then** the response clearly states that no skills are registered yet, rather than
   showing an empty or blank list.

---

### User Story 3 - Registration is enforced when a skill is created or updated (Priority: P2)

A skill author creates a new skill or edits an existing one, and the repository's existing
validation step confirms the skill still registers everything the help skill depends on —
before the author ever runs the help skill itself.

**Why this priority**: Without this enforcement, User Story 1 and User Story 2 could surface
blank or missing fields for a skill an author forgot to fully document. It is lower priority
than the two help-consuming stories because it is a quality gate, not a new capability an author
directly asks for — but it is what keeps the help output trustworthy.

**Independent Test**: Can be fully tested by validating a skill that omits usage guidance or a
copy-able example and confirming validation fails, naming the specific missing field, without
needing the help skill to be invoked at all.

**Acceptance Scenarios**:

1. **Given** a new or edited skill missing usage guidance, **When** it is validated, **Then**
   validation fails, naming the missing usage guidance specifically.
2. **Given** a new or edited skill missing a copy-able example, **When** it is validated, **Then**
   validation fails, naming the missing example specifically.
3. **Given** a skill that registers its name, description, version, usage guidance, and a
   copy-able example, **When** it is validated, **Then** validation of these registration fields
   passes.

---

### Edge Cases

- An identifier is declared but matches no registered skill: an error naming that identifier is
  shown; the full listing is never shown as a fallback (User Story 1, Acceptance Scenario 3).
- Zero skills are registered at all: the all-skills response says so explicitly rather than
  rendering nothing (User Story 2, Acceptance Scenario 3).
- A skill declares no dependencies: the single-skill response states this explicitly (e.g.
  "none") rather than omitting the Dependencies field.
- Two skills have similar or identical display names: matching for the single-skill request is
  by each skill's existing unique identifier, not its display name, so there is no ambiguity.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Every skill, when created or when updated, MUST register a name, a description, a
  version, usage guidance, and one copy-able example, in addition to any registration already
  required of it.
- **FR-002**: System MUST reject (fail validation for) a skill that is missing usage guidance or
  a copy-able example, naming the specific missing field, the same way it already rejects a
  skill missing a name, description, or version.
- **FR-003**: System MUST provide a way to request help for exactly one registered skill,
  identified unambiguously.
- **FR-004**: When help is requested for one specific, existing skill, the response MUST contain
  exactly these fields, in this order: Name, Description, Dependencies, Version, Usage, Example.
- **FR-005**: When help is requested for one specific skill that declares no dependencies, the
  Dependencies field MUST explicitly state that there are none, rather than being blank or
  omitted.
- **FR-006**: When help is requested with no skill declared, the response MUST list every
  currently registered skill, each showing exactly these fields, in this order: Name, Usage,
  Help (a command that, run verbatim, produces that skill's own single-skill response).
- **FR-007**: When help is requested for an identifier that matches no registered skill, the
  response MUST be a clear error naming that identifier, and MUST NOT show the all-skills
  listing as a fallback.
- **FR-008**: When help is requested with no skill declared and zero skills are currently
  registered, the response MUST state clearly that no skills are registered, rather than
  rendering an empty list.
- **FR-009**: The field labels and field order for a given response type (single-skill vs.
  all-skills) MUST be identical every time that response type is produced, regardless of which
  skill(s) are shown.
- **FR-010**: The help skill itself MUST satisfy FR-001 like any other skill, and MUST appear in
  the all-skills listing (User Story 2) the same way any other registered skill does.

### Key Entities

- **Skill Registration**: The declared facts about one skill that this feature reads and (for
  usage guidance and the example) newly requires: identifier, name, description, version,
  declared dependencies (if any), usage guidance, and one copy-able example.
- **Help Request**: One optional input — a skill identifier. Present means single-skill mode;
  absent means all-skills mode.
- **Single-Skill Response**: Name, Description, Dependencies, Version, Usage, Example — one
  instance, for one skill.
- **All-Skills Response**: Zero or more rows, each Name, Usage, Help — one row per currently
  registered skill.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Requesting help for any one registered, fully-compliant skill returns all six
  single-skill fields populated (none blank or missing), 100% of the time.
- **SC-002**: Requesting help with no skill declared returns exactly one row per currently
  registered skill, with zero skills omitted and zero duplicate rows.
- **SC-003**: Copying the Help command shown for any one skill in the all-skills response and
  running it verbatim produces that same skill's single-skill response, for every registered
  skill.
- **SC-004**: A skill missing usage guidance or a copy-able example fails validation, naming the
  specific missing field, in a single validation run — 100% of such attempts are caught before
  merge.
- **SC-005**: An unrecognized skill identifier produces a clear, specific error (not the
  all-skills listing) in 100% of attempts.
- **SC-006**: Field labels and field order are identical across every observed single-skill
  response, and separately identical across every observed all-skills response.

## Assumptions

- "Skill" means an entry under this repository's existing skill catalog (the same skills
  `validate-skill.sh` and `generate-catalog.sh` already validate and list) — not the separate,
  internal Spec-Kit workflow commands used to build this framework.
- The single-skill request matches by each skill's existing unique identifier (already the sole
  canonical identifier per the authoring standard), not by its free-form display name, so
  similar or duplicate display names cannot cause ambiguity.
- "Dependencies" refers to a skill's existing declared dependencies on shared library files
  (introduced by an earlier feature); a skill declaring none shows an explicit "none".
- Usage guidance and the copy-able example are authored by the skill's author as registration
  content, the same way its description already is — they are not mechanically derived from
  other parts of the skill, since they must be able to say something a machine cannot already
  infer.
- The help skill is itself a registered skill, added by this feature, and is therefore subject
  to the same registration requirements and appears in its own all-skills listing.
- Exact command syntax for issuing a help request or for the copy-able Help command is a
  presentation detail decided during planning, not this specification.
