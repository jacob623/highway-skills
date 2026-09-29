# Feature Specification: Distribute Always-On Agent Instructions from One Source

**Feature Branch**: `098-agent-instruction-framework`

**Created**: 2026-09-29

**Status**: Draft

**Input**: User description: "create a new spec for implementing the rules framework. I want the first rule to be: Highway Agent Context (consult highway identity and the experience standard, treat them as authoritative, do not copy their contracts, and defer workflow to an applicable Highway skill)."

## Background

Highway skills are authored once under `.highway/skills/<id>/SKILL.md` and generated into each
supported coding agent. Skills load when a task calls for them. They do not ground an agent when a
repository is first opened.

Cursor, Claude Code, and GitHub Copilot each have a separate always-on location that loads with
the repository. Those locations differ in shape. Cursor wants one rule file per instruction.
Claude Code and Copilot each want a single repository-instruction file. An author who maintains
the three by hand will drift.

This feature adds a second canonical source, `.highway/instructions/`, and a generator that
publishes every instruction into the three always-on locations. The instruction body is the
reusable artifact. The generator adds only the wrapper each agent requires.

## Clarifications

### Session 2026-09-29

- Q: Can an instruction live in `.highway/instructions/` if it must not be included in the distributed Highway tree? → A: No. Every instruction ships. An instruction that mentions a development-only path fails the distribution. Maintainer-only notes stay out of this directory.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Author an instruction once (Priority: P1)

As a Highway maintainer, I want to add a repository instruction by creating one markdown file, so
that Cursor, Claude Code, and Copilot all receive that instruction without a second copy.

**Why this priority**: Without a single authoring location, the three agent files drift and the
framework does not exist.

**Independent Test**: Add one valid file under `.highway/instructions/`, run the instruction
generator, and confirm the instruction body appears unchanged in the Cursor rule and in both
merged repository files.

**Acceptance Scenarios**:

1. **Given** a valid `.highway/instructions/<id>.md`, **When** the generator runs, **Then** it
   writes `.cursor/rules/<id>.mdc` whose body is the source body unchanged, with `alwaysApply:
   true` and the source `description`, and writes no `globs`.
2. **Given** one or more valid instructions, **When** the generator runs, **Then**
   `.claude/CLAUDE.md` and `.github/copilot-instructions.md` each contain every source body in
   filename order, separated by a blank line, with no heading added by the generator.
3. **Given** unchanged sources, **When** the generator runs a second time, **Then** every
   generated file is byte-identical to the first run.
4. **Given** a generated file that a person has edited by hand, **When** the generator runs,
   **Then** it exits non-zero, names the file, and leaves the edit in place.

---

### User Story 2 - Highway Agent Context is the first instruction (Priority: P1)

As an agent opening a Highway repository, I want one always-on instruction that points me at
Highway identity and the experience standard, so that I treat those documents as authoritative
and leave workflow decisions to the applicable skill.

**Why this priority**: The framework is the means. This instruction is the governance the
repository needs on load.

**Independent Test**: After generation, read the three agent outputs and confirm each contains
the Highway Agent Context body exactly, and confirm the two cited documents are the files that
exist in the repository.

**Acceptance Scenarios**:

1. **Given** the repository after this feature, **When** a maintainer lists
   `.highway/instructions/`, **Then** `highway-agent-context.md` is present and its body is the
   Highway Agent Context text in this specification, byte for byte.
2. **Given** generated outputs, **When** they are read, **Then** the Cursor rule, the Claude Code
   file, and the Copilot file each contain that body unchanged.
3. **Given** the instruction, **When** an agent follows it, **Then** it consults
   `.highway/library/knowledge/highway-identity.md` and
   `.highway/governance/experience-standard.md` rather than a copy of either document inside the
   instruction.

---

### User Story 3 - Instructions stay separate from skills (Priority: P1)

As a maintainer, I want the instruction generator and the skill generator to leave each other's
files alone, so that publishing instructions cannot turn a skill into a rule or rewrite a skill
adapter.

**Why this priority**: Feature 097 just made Cursor skills identical copies and forbade the skill
generator from writing `.cursor/rules/`. A new writer of that directory has to be unmistakable.

**Independent Test**: Run the instruction generator with skills and `speckit-*` files present, and
confirm no file under `.highway/skills/`, `.github/skills/`, `.claude/skills/`, or
`.cursor/skills/` changed. Run the skill generator afterward and confirm no instruction output
changed.

**Acceptance Scenarios**:

1. **Given** both trees populated, **When** the instruction generator runs, **Then** it reads and
   writes only `.highway/instructions/` and its own outputs, plus its own manifest.
2. **Given** an instruction id and a skill id that differ, **When** both generators have run,
   **Then** the instruction's Cursor file is `.cursor/rules/<id>.mdc` and the skill's Cursor file
   remains `.cursor/skills/<skill-id>/SKILL.md`.
3. **Given** the existing skill-suite check that fails when a `highway-*.mdc` rule file is
   present, **When** `highway-agent-context.mdc` exists as an instruction output, **Then** that
   check still passes, because the file is an instruction and not a leftover skill rule.
4. **Given** `speckit-*` files under `.cursor/skills/` or `.github/skills/`, **When** either
   generator runs, **Then** those files are unchanged.

---

### User Story 4 - Generated instructions ship, or are refused, on purpose (Priority: P2)

As a recipient of the Highway distribution, I want the always-on instruction included, so that an
agent opening the distributed tree gets the same grounding as an agent opening this repository.

**Why this priority**: An instruction that exists only in development does not ground the
distributed product. It is required for completion and does not change the authoring model.

**Independent Test**: Produce a distribution and confirm the three agent outputs are present, the
instruction body is intact, and the distribution's existing verifications pass.

**Acceptance Scenarios**:

1. **Given** a successful generation, **When** a distribution is produced, **Then** it contains
   `.cursor/rules/highway-agent-context.mdc`, `.claude/CLAUDE.md`, and
   `.github/copilot-instructions.md`, and does not contain `speckit-*` skills.
2. **Given** an instruction body that names `.specify/` or `specs/`, **When** a distribution is
   produced, **Then** the distribution is refused. There is no per-instruction exception. The
   Highway Agent Context body names neither, so it ships with the rest.
3. **Given** the live documentation that describes how skills are published, **When** this feature
   is complete, **Then** it also describes how an instruction is authored and published, and every
   path it names exists.

---

### Edge Cases

- An instruction's `name` does not equal its filename: the generator rejects that instruction and
  writes nothing.
- The frontmatter omits `description`, or the body is empty: the generator rejects it and writes
  nothing.
- Two instructions exist: both merged files contain the bodies in filename order, and Cursor has
  two rule files.
- No instructions exist: the generator exits 0, writes both merged files with no instruction
  body, and writes no Cursor rule file.
- A Cursor rule file exists that this generator did not produce: the generator does not modify or
  delete it. If its path collides with an instruction id, the generator refuses and names the file.
- An instruction is removed from the source: the generator does not delete the outputs it
  previously wrote. The correspondence check reports the orphan.
- The skill generator and the instruction generator are run in either order: each refuses only
  its own drifted files.
- An instruction is meant only for maintainers of this repository: it does not belong in
  `.highway/instructions/`. Putting it there publishes it, and a development-only path in its
  body fails the distribution.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Instructions MUST be authored only as `.highway/instructions/<id>.md`. One
  instruction is one file. Authors MUST NOT append instructions to a shared source file.
- **FR-002**: Each instruction MUST have frontmatter containing only `name` and `description`.
  `name` MUST equal `<id>`. `description` MUST be a non-empty single line. The body MUST be
  non-empty markdown. The source MUST NOT contain `alwaysApply`, `globs`, `paths`, or `applyTo`.
- **FR-003**: The generator MUST copy each instruction body unchanged into every agent output. It
  MUST NOT add a heading of its own. In the two merged files, bodies MUST appear in filename order,
  separated by one blank line.
- **FR-004**: For each instruction, the generator MUST write `.cursor/rules/<id>.mdc` with
  `alwaysApply: true`, the source `description`, no `globs`, and the source body below that
  frontmatter.
- **FR-005**: The generator MUST write every instruction body into `.claude/CLAUDE.md` and into
  `.github/copilot-instructions.md`.
- **FR-006**: The generator MUST validate every instruction before writing any output. One invalid
  instruction MUST abort the run with no partial output written.
- **FR-007**: The generator MUST record each output path, instruction id, and content hash in its
  own manifest, separate from the skill adapter manifest. It MUST refuse to overwrite an output
  whose content differs from the recorded hash or that has no manifest row, and it MUST name the
  file. It MUST NOT delete files.
- **FR-008**: Two consecutive runs on unchanged inputs MUST produce identical output files.
- **FR-009**: The repository MUST contain `.highway/instructions/highway-agent-context.md` whose
  body is exactly the Highway Agent Context text below. Its `name` MUST be
  `highway-agent-context`. Its `description` MUST be "Ground an agent in Highway identity and the
  experience standard, and leave workflow to the applicable skill."
- **FR-010**: The instruction generator MUST NOT read or write skill sources, skill adapters, or
  `speckit-*` files. The skill generator MUST NOT read or write instruction sources or instruction
  outputs.
- **FR-011**: The skill-suite check that reports a leftover Cursor rule MUST NOT fail because
  `.cursor/rules/highway-agent-context.mdc` exists as an instruction output.
- **FR-012**: Every instruction MUST have a Cursor rule, a presence in both merged files, a
  manifest row for each output, and an include classification for that output. An output that
  names an instruction with no source MUST fail that check.
- **FR-013**: Every instruction MUST ship. The distribution MUST include `.cursor/rules/<id>.mdc`
  for each instruction, plus `.claude/CLAUDE.md` and `.github/copilot-instructions.md`, and MUST
  exclude `speckit-*`. An instruction body that names `.specify/` or `specs/` MUST fail the
  distribution. There MUST be no per-instruction flag to keep one out. A produced distribution
  MUST pass its existing verifications.
- **FR-014**: Live documentation MUST describe authoring an instruction under
  `.highway/instructions/` and publishing it with the instruction generator, in the same change
  that adds the generator.
- **FR-015**: The instruction generator MUST be a declared generator, distinct from
  `generate-agent-adapters.sh`. Adding it MUST follow the constitution's versioning policy for a
  change to the declared-generator list.

### Highway Agent Context body

This body is the first instruction. The heading is part of the body. The generator copies it
unchanged.

```markdown
# Highway Agent Context

When operating within a Highway repository or acting on behalf of a Highway capability:

- Consult `.highway/library/knowledge/highway-identity.md` for Highway identity,
  behavioral guidance, and decision framing.
- Consult `.highway/governance/experience-standard.md` for applicable user-visible
  interaction and output requirements.
- Treat these files as authoritative for their respective concerns.
- Do not reproduce, reinterpret, or create competing copies of their contracts.
- When a Highway skill applies, defer domain workflow, artifact ownership, inputs,
  outputs, persistence behavior, and decisions to that skill.
- Do not treat Highway identity or experience guidance as organizational facts or
  as substitutes for workflow-specific inputs.
```

### Key Entities

- **Instruction source**: `.highway/instructions/<id>.md`. Agent-neutral frontmatter plus the body
  that every agent receives.
- **Cursor rule**: One generated `.cursor/rules/<id>.mdc` per instruction, always applied.
- **Claude Code repository file**: The single generated `.claude/CLAUDE.md`, containing every
  instruction body.
- **Copilot repository file**: The single generated `.github/copilot-instructions.md`, containing
  the same bodies in the same order.
- **Instruction manifest**: The record of each generated path, its instruction id, and its
  content hash. Not the skill adapter manifest.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of instruction bodies, including Highway Agent Context, are byte-identical
  across the source, the Cursor rule, and the matching section of both merged files.
- **SC-002**: An agent opening the repository in any of the three supported agents receives
  Highway Agent Context without a person attaching it. Cursor shows it as an always-applied rule.
  Claude Code and Copilot load it with the repository.
- **SC-003**: Adding a second instruction requires one new source file and one generator run. It
  requires zero hand edits to the three agent locations.
- **SC-004**: A second generator run on unchanged sources produces 0 byte differences.
- **SC-005**: 0 skill adapters and 0 `speckit-*` files change when the instruction generator runs.
- **SC-006**: The full automated test suite passes before the first edit and after the last.
- **SC-007**: A produced distribution contains the three Highway Agent Context outputs, contains
  0 `speckit-*` skills, and passes all of its existing verifications on the first run.

## Assumptions

- The first version publishes always-on instructions only. Path-scoped instructions, and Cursor's
  "apply when relevant" mode, are out of scope. Every instruction loads with the repository.
- Every instruction in `.highway/instructions/` is part of the distributed tree. Maintainer-only
  notes are written elsewhere. A body that names `.specify/` or `specs/` fails distribution
  rather than being filtered out of the merged files.
- Claude Code reads `.claude/CLAUDE.md` as project instructions, the same as a root `CLAUDE.md`.
  The generated file is `.claude/CLAUDE.md` so it stays under the tree the distribution manifest
  already classifies.
- Copilot reads `.github/copilot-instructions.md` as repository-wide instructions on every request.
- Cursor loads a `.cursor/rules/<id>.mdc` file in every session when `alwaysApply` is true.
- The instruction body is the reusable artifact. `name` and `description` exist so the generator
  can identify the file and fill Cursor's `description` field. They are not copied into the Claude
  or Copilot files as frontmatter.
- The Highway Agent Context `description` above is the specified one-line summary of the body the
  user supplied. The body itself is quoted, not summarized.
- Instruction ids may begin with `highway-`. The skill-suite leftover-rule check has to be limited
  to skill adapters so `highway-agent-context.mdc` is allowed.
- The generator does not delete outputs when a source is removed. Orphans are reported, matching
  the skill generator.
- The two documents the first instruction cites already exist and already ship:
  `.highway/library/knowledge/highway-identity.md` and `.highway/governance/experience-standard.md`.
  This feature does not change their text.
- Dependencies: the skill generator's validate-then-write and refuse-to-overwrite behavior, the
  single distribution manifest (D1.6), generated-artifact correspondence (D4.1–D4.7), and
  documentation currency (D6.1, D6.2). Declaring the new generator amends the development
  constitution's generator list.
