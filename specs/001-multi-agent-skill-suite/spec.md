# Feature Specification: Multi-Agent Skill Suite

**Feature Branch**: `[001-multi-agent-skill-suite]`

**Created**: 2026-09-06

**Status**: Draft

**Input**: User description: "I want to create a suite of skills that will support n number of AI Coding agents."

## Clarifications

### Session 2026-09-06

- Q: Which AI coding agents should this suite explicitly target for its first release? (FR-010) → A: Fixed initial list — GitHub Copilot, Claude Code, and Cursor.
- Q: Should this feature deliver only the skill-authoring framework, or also a starter batch of concrete skills? (FR-011) → A: Framework only — catalog, authoring standard, and compliance checks; no specific skill topics included.
- Q: Should skills require machine-readable frontmatter for automated catalog generation, or plain Markdown only? (FR-001, FR-003) → A: Structured frontmatter (name, description, applicability) required, consistent with existing `speckit-*` skill conventions; those `speckit-*` skills are external tooling used to build this feature and are out of scope / must not be modified.
- Q: Should skill versioning be per-skill or suite-wide? (FR-007) → A: Per-skill semantic version (each skill's frontmatter carries its own MAJOR.MINOR.PATCH).
- Q: How should overlapping/duplicate skill applicability actually be detected? (FR-005) → A: Manual review within this codebase for now; a separate external application (outside this codebase) will later perform automated detection by consuming the catalog's structured metadata. That external application is out of scope for this feature.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Author a Skill Usable by Any Supported Agent (Priority: P1)

A skill author writes a single skill (purpose, applicability, instructions, verification steps)
once, and that skill can be invoked correctly by any AI coding agent in the supported set,
without the author needing to write agent-specific variants.

**Why this priority**: This is the core value proposition of the suite — write once, run across
many agents. Without this, the suite is just a collection of agent-specific instructions, which
defeats the purpose.

**Independent Test**: Can be fully tested by authoring one new skill against the suite's authoring
standard, then invoking it through at least two different AI coding agents and confirming both
produce the outcome the skill specifies.

**Acceptance Scenarios**:

1. **Given** a new skill written to the suite's authoring standard, **When** it is loaded by
   Agent A, **Then** Agent A executes the skill's guidance and produces the specified outcome.
2. **Given** the same skill, **When** it is loaded by Agent B (a different agent than Agent A),
   **Then** Agent B executes the skill's guidance and produces an equivalent outcome.
3. **Given** a skill that relies on an agent-specific feature not available in the supported set,
   **When** the skill is authored, **Then** authoring is rejected or flagged until the
   agent-specific dependency is removed or explicitly scoped as an exception.

---

### User Story 2 - Discover the Right Skill for a Task (Priority: P2)

A developer or an AI coding agent, given a task, can identify which skill in the suite (if any)
applies, without ambiguity about which skill to use or when.

**Why this priority**: A suite with many skills is only useful if the correct skill can be found
and selected reliably; otherwise skills go unused or the wrong one is applied.

**Independent Test**: Can be fully tested by presenting a set of sample tasks and confirming each
maps to exactly one applicable skill (or explicitly to none) using only each skill's stated name,
description, and applicability conditions.

**Acceptance Scenarios**:

1. **Given** a task that matches one skill's stated applicability, **When** the suite's catalog is
   searched, **Then** exactly that skill is identified as applicable.
2. **Given** a task that matches no skill, **When** the suite's catalog is searched, **Then** no
   skill is incorrectly selected.
3. **Given** two skills with overlapping applicability, **When** the catalog is reviewed, **Then**
   the overlap is flagged for consolidation per suite maintenance rules.

---

### User Story 3 - Add Support for a New Agent Without Rewriting Existing Skills (Priority: P3)

A maintainer adds support for an additional AI coding agent to the suite, and all existing skills
become usable by that new agent without modification.

**Why this priority**: The suite must scale to "n" agents over time; if every new agent requires
editing every existing skill, the suite does not scale and violates portability goals.

**Independent Test**: Can be fully tested by introducing a new (nth) agent integration and
confirming a sample of existing skills work correctly for it with zero edits to those skill files.

**Acceptance Scenarios**:

1. **Given** an existing skill authored against the suite's standard, **When** a new agent
   integration is added, **Then** the skill functions correctly for the new agent without being
   edited.
2. **Given** a new agent with a materially different invocation mechanism, **When** it is
   integrated, **Then** only the integration layer changes, not the skill content.

### Edge Cases

- What happens when an agent cannot support a construct a skill relies on (e.g., a required tool
  category is unavailable to that agent)? The skill MUST state its minimum requirements so this
  can be detected before execution rather than failing mid-task.
- How does the suite handle two skills that both claim applicability to the same task? The
  overlap MUST be surfaced rather than silently resolved by arbitrary precedence.
- What happens when a skill is updated in a way that changes its behavior for agents already
  using it? This MUST be classified and communicated as a breaking or non-breaking change before
  release.
- What happens when a new skill is proposed that duplicates an existing skill's purpose? It MUST
  be flagged during review rather than added as a near-duplicate.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The suite MUST provide a catalog (index) of all available skills, automatically
  generated/validated from each skill's structured frontmatter (name, one-line description, and
  applicability conditions), so a skill can be located without reading its full contents and the
  catalog cannot drift out of sync with the skill files it indexes.
- **FR-002**: Every skill in the suite MUST be authored to be agent-agnostic: it MUST NOT assume
  a specific agent's proprietary features unless that agent-specific behavior is explicitly
  declared as an isolated, optional extension rather than embedded in the core guidance.
- **FR-003**: Every skill MUST declare, via structured frontmatter plus a consistent body
  structure, its purpose, when to use it, when not to use it, required inputs, expected outputs,
  and how to verify successful completion.
- **FR-004**: The suite MUST support adding a new AI coding agent to the supported set by adding
  an integration layer only, without requiring edits to existing skill content.
- **FR-005**: This codebase MUST require a manual review step, for every new or changed skill,
  that explicitly checks the skill's applicability against the existing catalog and flags any
  overlap or duplication before merge. This codebase MUST expose overlap-relevant metadata
  (name, description, applicability) in a structured, machine-readable form so that a separate,
  external application (outside this codebase) can later perform automated overlap detection;
  building that external application is out of scope for this feature.
- **FR-006**: Every skill added to the suite MUST be validated against the project constitution
  (`.specify/memory/constitution.md`) before being considered complete, and any exception MUST be
  documented explicitly in the skill file.
- **FR-007**: Every skill MUST carry its own semantic version (MAJOR.MINOR.PATCH) in its
  frontmatter. A change to a skill's stated inputs, outputs, or guarantees MUST increment its
  MAJOR or MINOR version (per constitution versioning policy) so agents/consumers relying on
  that specific skill can detect when their usage may need to change, independent of other
  skills' versions.
- **FR-008**: The suite MUST be extensible to an arbitrary, growing number of skills without
  requiring a redesign of the catalog or authoring standard at each addition.
- **FR-009**: Each skill MUST specify how failures or missing preconditions during its execution
  are detected and what the invoking agent should do next (retry, abort, escalate, or fall back).
- **FR-010**: The suite's initial supported agent set MUST be exactly: GitHub Copilot, Claude
  Code, and Cursor. Adding any other agent beyond this set is out of scope for this feature and
  MUST go through the new-agent integration path defined in FR-004.
- **FR-011**: This feature MUST deliver only the skill-authoring framework (catalog, authoring
  standard, and compliance checks). It MUST NOT include any specific skill topics/capabilities;
  individual skills are proposed and added via separate, follow-on features.

### Key Entities

- **Skill**: A single, self-contained unit of guidance for an AI coding agent. Attributes:
  name, description, applicability (when to use / when not to use), required inputs, expected
  outputs, verification method, version, and any declared agent-specific extensions or
  exceptions.
- **Skill Catalog**: The indexed collection of all skills in the suite, used for discovery.
  Attributes: skill entries (name, description, applicability), overlap/duplication flags.
- **Agent Integration**: The layer that allows a specific AI coding agent to discover and invoke
  skills from the catalog. Attributes: agent identifier, invocation mechanism, supported skill
  format version.
- **Constitution**: The governing set of principles (already ratified) that every skill in the
  suite must be validated against before release.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A skill authored once can be successfully executed, without modification, by at
  least 2 distinct AI coding agents in the supported set, verified for 100% of new skills added.
- **SC-002**: Adding a new (nth) agent to the supported set requires changes only to that agent's
  integration layer, with zero edits to existing skill files, verified each time an agent is
  added.
- **SC-003**: 100% of skills in the catalog pass constitution compliance review before being
  merged into the suite.
- **SC-004**: Given a sample task, a developer or agent can identify the correct applicable skill
  (or correctly determine none applies) using only the catalog, in under 3 lookups/steps.
- **SC-005**: Zero instances of two catalogued skills having undetected overlapping applicability
  at any given time (all overlaps are flagged within one review cycle of being introduced).

## Assumptions

- "n number of AI Coding agents" means the authoring standard and catalog mechanism must not
  hard-code assumptions that block future growth, even though this feature's initial supported
  set is fixed to three named agents (GitHub Copilot, Claude Code, Cursor per FR-010); additional
  agents are added later via the FR-004 integration path.
- Skills are authored as Markdown files with structured frontmatter (name, description,
  applicability), the same convention already used by the `speckit-*` skills in this repository.
  The `speckit-*` skills themselves are tooling used to author and manage this feature (e.g., via
  `/speckit-specify`, `/speckit-clarify`) — they are not part of this suite's codebase and MUST
  NOT be modified as part of building this feature.
- The project constitution at `.specify/memory/constitution.md` is the authoritative source of
  authoring standards this suite's skills must comply with.
- This feature governs the framework for building and cataloguing skills (authoring standard,
  catalog, compliance, extensibility); it does not itself mandate the business/technical content
  of every individual skill topic, which may be defined in follow-on features.
- Automated overlap/duplication detection across the catalog will be performed by a separate
  external application outside this codebase; this feature's scope ends at exposing the
  structured metadata that application will consume.
