# Feature Specification: Help Description Listing

**Feature Branch**: `023-help-description-listing`

**Created**: 2026-09-09

**Status**: Draft

**Input**: User description: "/speckit.specify when a user runs the highway-help skill without a parameter, I want the skill to show the Description as opposed to the Usage. Remove Usage and add Description in its place."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Discover Skill Descriptions (Priority: P1)

As a user who invokes `highway-help` without a skill identifier, I want each registered skill's description shown in the listing so I can understand what each skill does before choosing one.

**Why this priority**: The no-argument listing is the primary discovery workflow, and descriptions communicate purpose more directly than invocation syntax.

**Independent Test**: Invoke `/highway-help` against a non-empty catalog and verify each catalog entry produces one listing block with its name, description, and copyable help command.

**Acceptance Scenarios**:

1. **Given** a catalog containing registered skills, **When** the user invokes `/highway-help` without a parameter, **Then** each entry is listed in catalog order with `Name:`, `Description:`, and `Help: /highway-help <id>` lines.
2. **Given** a catalog containing registered skills, **When** the listing is rendered, **Then** no `Usage:` line appears in any All-Skills block.

### User Story 2 - Preserve Named Skill Details (Priority: P1)

As a user who requests one named skill, I want the existing detailed response to remain unchanged so that the single-skill contract stays compatible.

**Why this priority**: Named help is a separate established workflow and must not regress while the discovery listing changes.

**Independent Test**: Invoke `/highway-help highway-nfrs` and verify the response still has exactly six labeled lines in the documented order, including `Usage:`.

**Acceptance Scenarios**:

1. **Given** a registered skill identifier, **When** the user invokes `/highway-help <skill-id>`, **Then** the response contains the existing six fields in their existing order, including `Usage:`.
2. **Given** an unknown skill identifier, **When** the user invokes `/highway-help <unknown-id>`, **Then** the existing exact error response is returned and no All-Skills listing is shown.

### Edge Cases

- An empty catalog continues to return exactly `No skills are registered yet.`.
- A catalog entry with a non-blank description uses that description verbatim in its `Description:` line.
- The number of All-Skills blocks remains exactly equal to the number of catalog entries.
- Help commands remain copyable and use each entry's resolved catalog identifier.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: In All-Skills mode, `highway-help` MUST label each catalog entry's descriptive text `Description:` instead of `Usage:`.
- **FR-002**: In All-Skills mode, `highway-help` MUST omit the `Usage:` label from every listing block.
- **FR-003**: In All-Skills mode, `highway-help` MUST preserve one block per catalog entry, catalog order, each resolved `Name:`, and each `Help: /highway-help <id>` command.
- **FR-004**: In Single-Skill mode, `highway-help` MUST retain the existing six-field contract, including the `Usage:` field and its order.
- **FR-005**: Empty-catalog behavior and unknown-identifier error behavior MUST remain unchanged.
- **FR-006**: The output MUST use the catalog entry's description without replacing it with invocation syntax or another derived value.

### Key Entities

- **Catalog entry**: A registered skill record providing the resolved identifier, description, and usage metadata used by help output.
- **All-Skills listing block**: The three-line discovery record containing `Name:`, `Description:`, and `Help:` for one catalog entry.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of non-empty All-Skills listing blocks contain a `Description:` line and 0% contain a `Usage:` line.
- **SC-002**: The All-Skills listing contains exactly one block for every catalog entry and preserves catalog order.
- **SC-003**: 100% of Single-Skill responses retain their six existing fields, including `Usage:`, with no change to unknown-identifier or empty-catalog behavior.
- **SC-004**: Every All-Skills `Help:` line remains directly copyable as `/highway-help <id>` for the corresponding catalog entry.

## Assumptions

- The generated catalog remains the authoritative source for registered skill identifiers and descriptions.
- This feature changes only the All-Skills presentation label; it does not change catalog data, skill registration metadata, or Single-Skill output.
- Existing validation and test fixtures can exercise both no-argument and named-identifier modes.
