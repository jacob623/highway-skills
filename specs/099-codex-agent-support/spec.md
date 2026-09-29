# Feature Specification: Add Codex as a Supported Agent

**Feature Branch**: `099-codex-agent-support`

**Created**: 2026-09-29

**Status**: Draft

**Input**: User description: "create a new spec for adding codex to the supported agents using the plan you've provided."

## Background

Highway skills are authored once and published to GitHub Copilot, Claude Code, and Cursor.
Always-on repository instructions are authored once and published to each of those agents'
repository-load locations. Codex is not one of those agents today, so a person opening this
repository in Codex does not receive the Highway skills or Highway Agent Context.

Codex loads repository skills from `.agents/skills/<id>/SKILL.md` and repository guidance from
`AGENTS.md` at the repository root. Those are the locations this feature fills. Personal copies
under a home directory are out of scope.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Codex receives every Highway skill (Priority: P1)

As a person using Codex in this repository, I want the Highway skills available as Codex skills,
so that I can run the same skills the other supported agents already have.

**Why this priority**: Without the skills, Codex cannot perform Highway workflows. This is the
minimum useful addition.

**Independent Test**: Publish skills, then compare each Codex skill file with the canonical skill
and with the copy already published for one of the existing agents. They match, and no canonical
skill file changed.

**Acceptance Scenarios**:

1. **Given** the current set of Highway skills, **When** skills are published, **Then** Codex has
   `.agents/skills/<id>/SKILL.md` for each skill the other three agents already receive, and that
   file is byte-identical to the canonical skill and to the other agents' copies.
2. **Given** a successful publish, **When** the same publish is run again with no skill changes,
   **Then** the Codex skill files are unchanged.
3. **Given** `speckit-*` skills that this repository does not author, **When** skills are
   published, **Then** no `speckit-*` skill is created under `.agents/skills/`.
4. **Given** a Codex skill file that was edited after it was published, **When** skills are
   published again, **Then** the publish stops, names that file, and leaves the edit in place.

---

### User Story 2 - Codex receives repository guidance (Priority: P1)

As a person opening this repository in Codex, I want Highway Agent Context present before I
attach a skill, so that Codex is grounded the same way the other agents are.

**Why this priority**: Skills do not load merely because the repository opened. Codex's
repository guidance does. Both are required for Codex to match the other agents.

**Independent Test**: Publish instructions, then compare `AGENTS.md` with
`.claude/CLAUDE.md` and with `.github/copilot-instructions.md`. All three match, and
`# Highway Agent Context` is in `AGENTS.md`.

**Acceptance Scenarios**:

1. **Given** the current instruction sources, **When** instructions are published, **Then**
   `AGENTS.md` at the repository root is byte-identical to `.claude/CLAUDE.md` and to
   `.github/copilot-instructions.md`.
2. **Given** no instruction sources, **When** instructions are published, **Then** `AGENTS.md`
   is a single newline, the same as the other two merged files, and no Codex skill file is
   removed.
3. **Given** a hand-edited `AGENTS.md`, **When** instructions are published, **Then** the
   publish stops, names `AGENTS.md`, and leaves the edit in place.
4. **Given** a second instruction added as its own source file, **When** instructions are
   published, **Then** `AGENTS.md` contains both bodies in the same order as the other merged
   files, with no hand edit to `AGENTS.md`.

---

### User Story 3 - Codex output ships (Priority: P2)

As a recipient of the Highway distribution, I want the Codex skills and `AGENTS.md` included,
so that Codex opened on the distributed tree is grounded the same way as Codex opened on this
repository.

**Why this priority**: Skills and guidance that exist only in development do not reach a
recipient. Shipping does not change how they are authored.

**Independent Test**: Produce a distribution. It contains each `.agents/skills/highway-<id>`
directory and `AGENTS.md`, contains no `speckit-*` path, and passes the distribution's existing
verifications.

**Acceptance Scenarios**:

1. **Given** a successful publish of skills and instructions, **When** a distribution is
   produced, **Then** it contains the Codex skill directories for the Highway skills and
   `AGENTS.md`, and the files match this repository.
2. **Given** that distribution, **When** its existing verifications run, **Then** they pass,
   including the refusal of a body that names a development-only path.
3. **Given** `speckit-*` skills beside the Highway skills, **When** a distribution is produced,
   **Then** those skills are absent from the distribution.

---

### User Story 4 - Codex is a named supported agent (Priority: P2)

As a Highway maintainer, I want Codex named alongside GitHub Copilot, Claude Code, and Cursor,
so that a skill can declare Codex and the repository's supported-agent list includes it, without
rewriting any existing skill.

**Why this priority**: The copies in User Stories 1 and 2 are useful before the name is recorded.
Recording the name keeps the supported-agent list and the published copies from drifting apart.

**Independent Test**: Every existing skill file is unchanged. The allowed compatibility values
include `codex`. The declared agent list includes `codex`. The live documents that describe the
supported agents also name Codex and the two locations it reads.

**Acceptance Scenarios**:

1. **Given** the skills that already say they apply to all agents, **When** Codex is added,
   **Then** those skill files are not edited, and Codex still receives them.
2. **Given** the list of allowed compatibility values, **When** Codex is added, **Then** `codex`
   is an allowed value and `all` still means every supported agent, including Codex.
3. **Given** the declared agent list, **When** Codex is added, **Then** the list names `codex`
   and the change follows the constitution's versioning policy for adding an agent without
   invalidating work that already conforms.
4. **Given** the live documents that tell a maintainer how skills and instructions are published,
   **When** this feature is complete, **Then** those documents name Codex, `.agents/skills/<id>/SKILL.md`,
   and `AGENTS.md`.

---

### Edge Cases

- A Codex skill file or `AGENTS.md` already exists and was not produced by the publisher: the
  publish refuses, names the file, and writes nothing else for that run.
- A Highway skill is removed from the source: the publisher does not delete the Codex copy it
  wrote earlier. The existing correspondence check reports the orphan.
- An instruction is removed from the source: `AGENTS.md` drops that body on the next successful
  publish, together with the other merged files. The publisher does not delete skill files.
- Cursor may also read a root `AGENTS.md` in addition to its own always-on rule. The file stays
  at the Codex location. The text is the same Highway Agent Context the Cursor rule already
  carries. Whether Cursor shows it twice is observed by a person and is not a reason to choose
  a different Codex path.
- A skill whose compatibility names one existing agent and not `all`: Codex still receives the
  same set the other three agents receive. This feature does not start filtering copies by the
  compatibility value.
- Personal Codex files under a home directory are never written or shipped.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Codex MUST be a supported agent with the id `codex`, alongside `github-copilot`,
  `claude-code`, and `cursor`.
- **FR-002**: Publishing skills MUST write `.agents/skills/<id>/SKILL.md` for every Highway skill
  the other three agents already receive. Each file MUST be byte-identical to the canonical skill.
- **FR-003**: Publishing skills MUST NOT edit any file under the canonical skill sources, and MUST
  NOT create, modify, or remove `speckit-*` skills.
- **FR-004**: Publishing instructions MUST write `AGENTS.md` at the repository root with the same
  bytes as `.claude/CLAUDE.md` and `.github/copilot-instructions.md`, including Highway Agent
  Context.
- **FR-005**: A second publish of unchanged skills or unchanged instructions MUST produce no byte
  differences in the Codex outputs.
- **FR-006**: The publisher MUST refuse to overwrite a Codex skill file or `AGENTS.md` that has no
  publication record or whose content differs from that record, MUST name the file, and MUST NOT
  delete files.
- **FR-007**: The distribution MUST include each Highway Codex skill directory and `AGENTS.md`,
  and MUST exclude `speckit-*`. The existing distribution verifications MUST still pass.
- **FR-008**: The allowed compatibility values MUST include `codex`. Existing skills that apply to
  all agents MUST remain unchanged and MUST still be published to Codex.
- **FR-009**: The declared agent list MUST include `codex`. Adding it MUST follow the
  constitution's versioning policy. The Codex copies MUST exist in the same change, so work that
  already matched the previous agent list still matches.
- **FR-010**: Live documentation MUST name Codex and both of its repository locations in the same
  change that adds the agent.
- **FR-011**: Personal Codex locations under a home directory MUST NOT be written or shipped.

### Key Entities

- **Codex skill**: The published `.agents/skills/<id>/SKILL.md` for one Highway skill. Same text
  as the canonical skill.
- **Codex repository guidance**: The published `AGENTS.md` at the repository root. Same text as
  the other agents' merged instruction files.
- **Supported agent**: One of `github-copilot`, `claude-code`, `cursor`, and `codex`. The
  compatibility value `all` covers every member of this list.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the Highway skills the other agents already receive are present for Codex,
  and each Codex copy matches the canonical skill. The current set is 12 skills.
- **SC-002**: 0 canonical skill files change when Codex is added.
- **SC-003**: `AGENTS.md` matches both existing merged instruction files, and it contains Highway
  Agent Context.
- **SC-004**: A second publish of unchanged sources produces 0 byte differences in the Codex
  skill files and in `AGENTS.md`.
- **SC-005**: A produced distribution contains the Codex Highway skills and `AGENTS.md`, contains
  0 `speckit-*` paths, and passes its existing verifications.
- **SC-006**: The full automated test suite passes before the first edit and after the last.
- **SC-007**: A person opening the repository in Codex sees Highway Agent Context without
  attaching it, and sees the Highway skills as Codex skills. This observation is made by a person.

## Assumptions

- Codex's repository skill directory is `.agents/skills/<id>/SKILL.md`, and its repository
  guidance file is `AGENTS.md` at the repository root. Those locations are taken from Codex's
  current product documentation, checked on 2026-09-29.
- The skill text Codex needs is the same text the other agents already receive, so Codex skills
  are copies rather than a Codex-specific rewrite.
- `AGENTS.md` is a third copy of the merged instruction body. It is not a separate authoring
  file. Authors still add an instruction as one source file.
- Adding a declared agent, once the new copies exist in the same change, does not make previously
  conforming work fail. The version increase is MINOR. The working tree's development
  constitution is 2.1.0 from the instruction framework; this feature amends that version.
- Compatibility is a declaration an author may make. Publishing still sends every Highway skill
  to every supported agent, which is what the other three agents already do.
- Cursor may also read `AGENTS.md`. The Codex path stays the documented one. Duplicate display in
  Cursor is recorded if a person sees it, and is not treated as a failed publish.
- The publisher does not remove files when a source disappears. Correspondence reports orphans,
  as it does for the existing agents.
