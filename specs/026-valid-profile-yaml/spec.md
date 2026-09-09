# Feature Specification: Valid Profile YAML

**Feature Branch**: `026-valid-profile-yaml`

**Created**: 2026-09-09

**Status**: Draft

**Input**: User description: "/speckit.specify the profile.yaml file is not valid yaml. Fix the yaml and create a test that validates that it is valid yaml."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Consume the profile with a standard YAML parser (Priority: P1)

As a profile consumer, I want the canonical profile file to be valid YAML so that standard YAML tooling can parse it without syntax errors.

**Why this priority**: Invalid syntax prevents consumers and tools from reliably reading the repository profile.

**Independent Test**: Parse the canonical profile with a standard YAML parser and verify parsing succeeds without errors.

**Acceptance Scenarios**:

1. **Given** the canonical profile file, **When** a standard YAML parser reads it, **Then** parsing succeeds.
2. **Given** the canonical profile file, **When** it is parsed, **Then** its required profile sections and values remain available with the existing structure.

### User Story 2 - Prevent regression of YAML validity (Priority: P2)

As a maintainer, I want an automated test for YAML syntax so that future edits cannot silently reintroduce invalid indentation or other parser errors.

**Why this priority**: A regression test makes the validity requirement repeatable and visible in the normal verification workflow.

**Independent Test**: Run the focused profile YAML test and verify it passes for the canonical profile.

**Acceptance Scenarios**:

1. **Given** a valid canonical profile, **When** the focused YAML test runs, **Then** it exits successfully.
2. **Given** a profile with invalid YAML syntax, **When** the validation logic evaluates it, **Then** the check reports failure rather than accepting the file.

### Edge Cases

- YAML indentation must use syntax accepted by standard parsers; tab characters used as indentation must not cause parsing failure.
- The syntax correction must not remove, reorder, or alter the required profile sections and default values.
- A parser failure must identify the profile validation as failed and return a non-success result.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The canonical profile file MUST be accepted by a standard YAML parser.
- **FR-002**: The canonical profile file MUST preserve the existing required sections, section order, metadata values, and empty default mappings while its syntax is corrected.
- **FR-003**: The project MUST provide an automated test that parses the canonical profile and fails when parsing fails.
- **FR-004**: The automated YAML validity test MUST run as part of the focused profile validation workflow.
- **FR-005**: The correction MUST NOT restore the former profile path or reintroduce the removed Markdown profile template.

### Key Entities

- **Canonical profile**: The repository-wide organizational profile stored at `.highway/library/templates/output/profile.yaml`.
- **YAML validity check**: An automated verification that reports whether the canonical profile can be parsed as YAML.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A standard YAML parser accepts the canonical profile with zero syntax errors.
- **SC-002**: The focused profile validation test passes consistently on supported development environments.
- **SC-003**: The corrected profile retains all 11 required top-level sections in their existing order and preserves the existing metadata and default mappings.
- **SC-004**: A deliberately malformed YAML fixture is rejected by the validation check.

## Assumptions

- The canonical profile path established by Feature 025 remains authoritative.
- Existing profile schema and semantic validation remain in force; this feature addresses parser validity and regression coverage.
- The project’s supported shell and test tooling remain available in the development environment.
