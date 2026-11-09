# Feature Specification: Storage Contract

**Feature Branch**: `230-storage-contract`

**Created**: 2026-11-09

**Status**: Draft

**Input**: User description: "create a new spec for implementing Phase 1 in rollout-plan.md". Phase 1 reads: put every repository read and write behind one owned definition, so later modes touch one file. Add `.highway/governance/storage.md` defining four operations (read a file, check a file exists, list a folder, write a group of files together), fill the Local column with today's behavior, and mark the Remote (Option A) and Chat (Option B) columns "not supported yet". Add a constitution rule that a skill touches the repository only through those four operations, with no script runs, no `git`, no absolute paths, and no file timestamps. Point `highway-agent-context` at `storage.md` with one sentence. Reduce folder listing where an index already holds the answer: codify reads the next feature number from an index instead of listing `code/<folder>/.highway/features/`. Tests cover the new rule applied to every skill, and the full suite passes. Exit: no skill wording depends on a local filesystem beyond the four operations.

## Clarifications

### Session 2026-11-09

- Q: Where should highway-codify keep each product's last feature number? → A: In a Features table in the product's `code/<folder>/.highway/metadata.md`, one row per accepted feature: ID (`001`), feature folder name, automation title from `codify.md`, and summary from `codify.md`. Title and summary are copied at acceptance. No status column. The next number is the last row's ID plus one. The table also gives a model the product's feature history without reading each feature or the code. There is no backward compatibility handling, because the suite is under development.
- Q: Does the new rule limit only what the agent itself does while following a skill, or also what the files a skill writes may contain? → A: Only the agent's own actions. The agent runs no script or `git`, uses no absolute path, and reads no file timestamp. Files a skill writes, such as product code, pipelines, and READMEs, may contain anything.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - One storage contract defines every repository operation (Priority: P1)

A maintainer adding a new storage mode opens one file, `.highway/governance/storage.md`, and finds the four operations a skill may use, what each one does today in local mode, and which modes are not supported yet. Nothing else in the suite has to change for a later mode to fill its column.

**Why this priority**: Every later rollout phase (remote mode, chat mode) fills a column of this file. Without it, each mode would edit every skill.

**Independent Test**: Read `storage.md` and confirm it names exactly four operations, each with a Local, Remote, and Chat entry, and that only Local is supported.

**Acceptance Scenarios**:

1. **Given** the shipped governance folder, **When** a maintainer opens `storage.md`, **Then** it defines exactly four operations: read a file, check a file exists, list a folder, and write a group of files together.
2. **Given** `storage.md`, **When** each operation is read, **Then** it has a Local entry that states today's behavior, a Remote (Option A) entry reading "not supported yet", and a Chat (Option B) entry reading "not supported yet".
3. **Given** `storage.md`, **When** paths are read, **Then** every operation takes a path relative to the repository root.
4. **Given** the Local column, **When** write a group of files together is read, **Then** it states that every file in the group is written to the person's working tree and that the person handles any git step.
5. **Given** the distribution build, **When** it runs, **Then** `storage.md` ships with the rest of `.highway/governance/`.

---

### User Story 2 - Every skill touches the repository only through the four operations (Priority: P1)

A maintainer authors or amends a skill. The skills constitution holds a rule that the skill reaches the repository only through the operations in `storage.md`. The skill validator fails a skill whose wording runs a script, calls `git`, names an absolute path, or reads a file's timestamp.

**Why this priority**: The contract only protects later modes if no skill steps around it.

**Independent Test**: Run the skill validator on every shipped skill and see each pass. Seed a skill with a script instruction and see the validator fail it.

**Acceptance Scenarios**:

1. **Given** the skills constitution, **When** a maintainer reads it, **Then** it holds a rule, with an ID, one keyword, an Observable, and a Tier, that a skill reaches the repository only through the operations `storage.md` declares.
2. **Given** a skill that instructs the agent to run a script under `.highway/tools/`, **When** the validator runs, **Then** the skill fails with that rule's ID.
3. **Given** a skill that instructs the agent to run a `git` command, **When** the validator runs, **Then** the skill fails with that rule's ID.
4. **Given** a skill that names a path starting at the filesystem root or the home folder, **When** the validator runs, **Then** the skill fails with that rule's ID.
5. **Given** a skill whose decision depends on a file's modified or created time, **When** the validator runs, **Then** the skill fails with that rule's ID.
6. **Given** a skill that names a slash-command invocation such as `/highway-help`, **When** the validator runs, **Then** the invocation is not treated as an absolute path.
7. **Given** every shipped skill after this change, **When** the validator runs, **Then** every skill passes.
8. **Given** a skill that writes a file whose content runs a script or a `git` step, such as a codify pipeline, **When** the validator runs, **Then** the skill passes.

---

### User Story 3 - Each product keeps a Features table that codify numbers from (Priority: P2)

A person accepts a second action for an existing product. highway-codify adds a row to the Features table in the product's `.highway/metadata.md` and numbers the new feature from the table's last row, not by listing the product's features folder. The table lists every accepted feature in order, so the number is never reused, and a model can read the product's history in one file.

**Why this priority**: Listing a folder is the operation that costs most in a remote or chat mode. This is the only place a skill lists a folder to compute a value.

**Independent Test**: Accept three actions for one product, where a finished feature's entry is removed from the `code/code.md` Features cell. Read each feature number and the Features table.

**Acceptance Scenarios**:

1. **Given** a new product, **When** its first feature is accepted, **Then** `metadata.md` is written with a Features table holding one row: `001`, the feature folder name, the automation title, and the summary from that feature's `codify.md`.
2. **Given** a product whose Features table's last row is `003`, **When** a new feature is accepted, **Then** its number is `004`, and a `004` row is appended.
3. **Given** a feature whose entry was removed from the `code/code.md` Features cell, **When** the product's Features table is read, **Then** that feature's row is still there.
4. **Given** highway-codify, **When** its numbering step is read, **Then** it reads the Features table and does not list `code/<folder>/.highway/features/`.
5. **Given** an accepted feature, **When** `metadata.md` is written, **Then** it is written in the same group as `codify.md` and the `code/code.md` row.

---

### User Story 4 - Agents learn the contract, and no message points at a development script (Priority: P3)

An agent working in a Highway repository reads the always-on instructions and learns where the storage contract lives. A person whose skill catalog is missing gets an error that names the missing file, not a script that a future plugin install would not ship.

**Why this priority**: The pointer makes the contract discoverable. The help message is the one shipped instruction to run a development script.

**Independent Test**: Read the generated always-on instructions for each agent and find the storage pointer. Read highway-help's missing-catalog error.

**Acceptance Scenarios**:

1. **Given** `highway-agent-context`, **When** it is read, **Then** it has one sentence pointing to `.highway/governance/storage.md` for how a skill reads and writes the repository.
2. **Given** the generated always-on instructions for each supported agent, **When** they are regenerated, **Then** each carries that sentence.
3. **Given** a missing or unreadable `.highway/catalog/index.json`, **When** highway-help runs, **Then** it stops and names the missing file. It does not tell anyone to run a script.
4. **Given** highway-help's Inputs, **When** they are read, **Then** they do not name a `.highway/tools/` script.

---

### Edge Cases

- A product written before this change has no Features table: not handled. The suite is under development and has no backward compatibility requirement.
- A finished feature leaves the `code/code.md` Features cell: its row stays in the product's Features table.
- A Local write of a group fails partway: the agent names the files written and the file that failed. Local mode does not roll back.
- A slash-command invocation, such as `/highway-codify`, or a URL is not an absolute path.
- A codify proposal writes a pipeline that runs `git` or a build script, or a README that says how to build: allowed. The rule covers the agent's own actions, not the content it writes.
- `.highway/skills/_authoring-standard.md` is maintainer guidance, not a skill. It may keep naming `.highway/tools/` scripts.
- Remote or Chat mode is requested before it is supported: no mode setting exists in this phase, so every run uses Local.

## Requirements *(mandatory)*

### Functional Requirements

**Storage contract**

- **FR-001**: The suite MUST ship `.highway/governance/storage.md` as the single definition of how a skill reaches the repository.
- **FR-002**: `storage.md` MUST define exactly four operations: read a file, check a file exists, list a folder, and write a group of files together.
- **FR-003**: Each operation MUST take paths relative to the repository root.
- **FR-004**: Each operation MUST have three entries: Local, Remote (Option A), and Chat (Option B).
- **FR-005**: Each Local entry MUST state today's behavior. Write a group of files together MUST state that each file is written to the working tree, that nothing is committed, and that the person handles any git step.
- **FR-006**: Each Remote and Chat entry MUST read "not supported yet".
- **FR-007**: The Local entry for write a group of files together MUST state that a failed write names the files already written and the file that failed.

**Constitution rule**

- **FR-008**: The skills constitution MUST gain a rule that a skill reaches the repository only through the operations `storage.md` declares. The rule follows the constitution's row shape: ID, one keyword, Observable, and Tier.
- **FR-009**: The rule's Observable MUST cover four violations by the agent while following the skill: running a script, calling `git`, naming an absolute path, and deciding from a file's timestamp.
- **FR-009a**: The rule MUST NOT restrict the content of files a skill writes. Product code, pipelines, and READMEs may contain scripts, `git` steps, and build commands.
- **FR-010**: The skill validator MUST check the rule automatically for every skill under `.highway/skills/`, excluding `_authoring-standard.md`.
- **FR-011**: The validator MUST NOT treat a slash-command invocation or a URL as an absolute path.
- **FR-012**: Every shipped skill MUST pass the rule after this change.

**Folder listing**

- **FR-013**: A skill MUST NOT list a folder to compute a value that an index or record already holds.
- **FR-014**: The product's `code/<folder>/.highway/metadata.md` MUST hold a Features table with one row per accepted feature, in acceptance order. The columns are ID, Folder, Title, and Summary.
- **FR-015**: ID MUST be the three-digit feature number. Folder MUST be the feature folder name, `<number>-<action>`. Title MUST be the feature's `codify.md` automation title. Summary MUST be its `codify.md` Summary sentence. Title and Summary are copied at acceptance.
- **FR-016**: highway-codify MUST number a new feature as the next integer after the table's last ID, and `001` for a new product. It MUST NOT list `code/<folder>/.highway/features/`.
- **FR-017**: highway-codify MUST append the new row when a feature is accepted, in the same write group as `codify.md` and the `code/code.md` row. A row is never removed, so no number is reused.
- **FR-017a**: The Features table MUST NOT hold a status column. Task progress stays in `codify-tasks.md`.
- **FR-017b**: The codify metadata template MUST describe the file as the product's identity and feature index, rewritten when a feature is accepted. Its version increments.

**Pointers and messages**

- **FR-018**: `highway-agent-context` MUST gain one sentence pointing to `.highway/governance/storage.md` for how a skill reads and writes the repository.
- **FR-019**: The generated always-on instructions for every supported agent MUST carry that sentence.
- **FR-020**: highway-help's missing-catalog error MUST name `.highway/catalog/index.json` and MUST NOT tell anyone to run a script.
- **FR-021**: highway-help's Inputs MUST NOT name a `.highway/tools/` script.

**No other change**

- **FR-022**: Every person-visible output MUST stay unchanged, except the Features table in FR-014 through FR-017b and the help message in FR-020.
- **FR-023**: A test MUST pin the rule, the four operations, the three columns, the codify numbering, the agent-context sentence, and the help message. The full suite MUST pass.

### Key Entities

- **Storage contract**: `.highway/governance/storage.md`. Four operations, each with a Local, Remote, and Chat entry.
- **Operation**: One of read a file, check a file exists, list a folder, or write a group of files together. It takes repository-relative paths.
- **Mode column**: Local (the person handles git), Remote (Option A: a local clone that Highway commits and pushes), or Chat (Option B: git host API calls). Only Local is supported in this phase.
- **Features table**: The product's feature index in `code/<folder>/.highway/metadata.md`. One row per accepted feature with ID, Folder, Title, and Summary. Rows are appended and never removed. The last row's ID is the product's last feature number.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: `storage.md` defines exactly 4 operations, each with exactly 3 mode entries. Exactly 4 are supported, all of them Local.
- **SC-002**: 100% of shipped skills pass the new rule, and 0 shipped skills name a `.highway/tools/` script, a `git` command, an absolute path, or a file timestamp as a decision input.
- **SC-003**: A seeded violation of each of the 4 kinds fails the validator 4 out of 4 times.
- **SC-004**: 0 skill steps list a folder to compute a value an index holds.
- **SC-005**: Across 3 accepted features for a new product, including one whose `code/code.md` Features entry was removed, the numbers are 001, 002, and 003 with no reuse, and the Features table holds 3 rows.
- **SC-006**: The full suite passes with no failures.

## Assumptions

- The shipped skills constitution at `.highway/governance/constitution.md` holds the new rule. The development constitution does not change except where its own amendment rules require it.
- `storage.md` sits in `.highway/governance/` beside the Experience Standard, so it ships through the existing `.highway/governance` include in the distribution manifest.
- `codify.md` is not rewritten after acceptance, so the copied Title and Summary do not drift. The plan confirms this.
- The `code/code.md` Features cell keeps its pruning rule and its template version. Its overlap with the Features table is revisited later.
- There is no backward compatibility handling. Products written before this change are not migrated.
- "Today's behavior" for Local is what the skills already do: read and write files in the working tree at repository-relative paths, with git left to the person.
- Each skill already uses the operations in practice. Only highway-codify's feature numbering and highway-help's script references need wording changes.
- No mode setting is added. `highway-setup` asks for the mode in Phase 4 (remote mode).
- Templates and tests pin version numbers. Bumps follow the existing versioning policy.
