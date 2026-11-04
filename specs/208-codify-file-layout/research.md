# Research: Codify File Layout

## R1. Where the layout lives

- **Decision**: Add `## File and Folder Structure` to the standard file, between Scope and Rules, as an ordered list of relative paths. Placeholders such as `<module>` and `<name>` are allowed. The catalog gains no column.
- **Rationale**: One standard describes one component. File Patterns still decide whether a standard applies to a file. The layout decides where a new file goes.
- **Alternatives considered**: A catalog column. Rejected by FR-004, because a layout does not fit in one cell.

## R2. Tests section

- **Decision**: `Tests: required`, then one sentence, then `Test path: \`<relative path>\``, where that path appears in the structure. Or `Tests: not required` alone.
- **Rationale**: Codify needs the test path to place the test line. It must be in the layout so the test sits beside what it tests.

## R3. Proposal checks in `highway-codify-config`

- **Decision**: The standard proposal shows **File and Folder Structure:** after **File Patterns:**, as an ordered list. `accept` stays on the proposal, says what is needed, and writes nothing in three cases:
  - The structure is empty.
  - A path begins with `/` or `code/`.
  - Tests are required and the test path is outside the structure.
- **Rationale**: These checks are deterministic, so a standard missing its layout is never stored (SC-001).
- **Implementation note**: The checks and both writes moved to a new `### standard write` step, which `accept` enters, so `standard proposal` stays within 400 words (P7.5).

## R4. Catalog creation

- **Decision**: `accept` writes the standard file first. When `library/coding-standards/coding-standards.md` is absent, the skill then creates it from `coding-standards-catalog.md` with this row only, creating `library/coding-standards/` when needed. A failed standard write creates no catalog.
- **Rationale**: FR-006, and the existing write order.

## R5. Removing the seeds

- **Decision**: Delete `library/coding-standards/coding-standards.md` and `library/coding-standards/terraform.md`. Remove `include library/coding-standards -` from the distribution manifest. Keep `exclude library -`, and reword its comment to say Highway seeds no organization library.
- **Rationale**: The distribution walks files, so a manifest line for an absent path is harmless. Keeping the exclude means a developer's own `library/` never ships.

## R6. Task list organized by feature

- **Decision**: The task list holds one group per proposal task, in proposal order, tagged `[Task N]`. A file the Provider needs that no feature writes, such as a shared entry point, is a `[Executor]` line before the groups. The `[README]` line is last. A line has this shape: `- [ ] T### [Task N] <work>. Files: \`<path>\`, \`<path>\`. Standards: \`library/coding-standards/<a>.md\`.`
  - A feature's lines name only the files it creates or changes.
  - A path from the structure that no feature delivers has no line.
  - When the feature's first standard says `Tests: required`, the feature's first line is its test, at the test path.
  - A later feature that does not change that behavior adds no test line.
- **Rationale**: This is Speckit's shape: phase per story, files per task, tests first inside the story. A line can be coded from the layout and its own files.
- **Kept strings**: The template keeps the `[Executor]` and `[Task N]` tags, `- [ ] T001`, and the sentence "The Provider is the first node of the accepted diagram." Existing tests pin them, and they still describe the list.
- **Alternatives considered**: One line per structure path. Rejected in clarification, because it turns the layout into a task inventory.

## R7. Placement in codify

- **Decision**: A new `### layout` section runs after `align` and before `propose`. For each task:
  1. Place each file from the first standard on its list whose structure has a path for that kind of file.
  2. Fill placeholders from the task.
  3. Use an inherited language standard's file names only where the platform standard names none.
  4. A called component, such as a Terraform module, uses its own standard.
  5. A task with no standard names files at the automation root, from the task.
  6. A listed standard with no structure is treated as no structure, and the proposal says so and points to `/highway-codify-config`.

  The proposal task shows **Files:** as an ordered list. An edit to Files changes only that automation.
- **Rationale**: `propose` and `write` are near 400 words. A separate section keeps the placement rules in one place.

## R8. Reading during coding

- **Decision**: `code` step 1 reads every standard the line names, including its File and Folder Structure, and the files the line names that already exist. It reads no other automation file.
- **Rationale**: The performance goal and FR-008.

## R9. Replaced assertions (D3.5)

- `highway-codify.test.sh`:
  - Its three requirements on the seeded catalog and the Terraform standard become checks that both files are absent.
  - The manifest `include library/coding-standards` requirement becomes a rejection.
  - Reason: the seeds are removed.
- `codify-config-skill.test.sh`:
  - The seeded-catalog header check becomes an absence check.
  - The version pins move: codify 8.0.0, record 7.0.0, tasks 4.0.0, codify-config 2.0.0.
  - Reason: the seed is removed, and the versions are bumped.
- `codify-platform-catalog.test.sh`: the codify, record, and tasks pins move to 8.0.0, 7.0.0, and 4.0.0. Reason: MAJOR bumps only.
- `codify-closing-guide.test.sh`: the codify and record pins move to 8.0.0 and 7.0.0. Reason: MAJOR bumps only.

## R10. Completion message

- **Decision**: Unchanged. It names `code/[ID]/` and `code/[ID]/README.md`, as fixed by spec 206.
- **Rationale**: FR-011 only requires the folder to appear in the completion message. SC-002 covers standard proposals and task lists.
