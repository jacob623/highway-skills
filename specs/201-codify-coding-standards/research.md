# Research: Codify Coding Standards and Task List

## Decision: Standards live at the repository root

- **Decision**: The catalog and standards live in `library/coding-standards/` at the repository root, beside `library/governance/controls/` and `library/knowledge/profile.md`.
- **Rationale**: Standards are organization content that the organization edits. `validate-library.sh` judges every file under `.highway/library/` against Highway's authoring rules, and `generate-library-catalog.sh` refuses to write the library index when any file fails. A real standard can hold far more than twelve MUST-level rules, which would fail P7.4 and block the index. `library-containment.test.sh` already states that Highway's validator must not judge user-owned files.
- **Alternatives considered**: A new `.highway/library/coding-standards/` library type. Rejected: it changes two generators' inputs and the validator, and it subjects organization rules to Highway's authoring rules. Putting standards under `.highway/library/knowledge/`. Rejected for the same reason and because the request names `library/coding-standards/`.

## Decision: The sample is Terraform

- **Decision**: Highway ships `library/coding-standards/terraform.md` as the one sample standard.
- **Rationale**: Terraform is the first technology the request names, and provisioning is a common codify automation. One sample is enough to show the shape and to exercise the standard-to-task path end to end.
- **Alternatives considered**: Python or Go. Either works. Terraform also shows a file-pattern list with more than one pattern (`*.tf`, `*.tfvars`).

## Decision: Shipping through the distribution manifest

- **Decision**: Add `include	library/coding-standards	-` to `.highway/tools/.distribution-manifest`.
- **Rationale**: D1.6 requires the shipped path set to be declared once. A new root folder that is not classified fails the distribution run.
- **Alternatives considered**: Seeding the folder from a script at setup. Rejected: it adds a second place that declares what ships.

## Decision: Matching a file to a standard by file pattern

- **Decision**: Each catalog row lists file patterns, such as `*.tf, *.tfvars`. A task's file uses the first row whose pattern matches the file name. A technology listed in two rows uses the first row, and the close names the duplicate.
- **Rationale**: A file pattern is something the person can check and codify can apply the same way every time. It realizes the spec's "Terraform for a `.tf` file" rule.
- **Alternatives considered**: Matching by technology name only. Rejected: codify would have to guess the technology of each file.

## Decision: A standard states whether it asks for tests

- **Decision**: Each standard has a `## Tests` section. Its first line is `Tests: required` or `Tests: not required`. When required, the section says what a test file is named and where it goes.
- **Rationale**: The clarified rule adds a test task only when the standard asks for tests. A fixed first line makes that reading unambiguous.
- **Alternatives considered**: A frontmatter field. Rejected: organization content does not need Highway's frontmatter conventions, and a body line is easier for a person to see.

## Decision: Task list shape

- **Decision**: `codify-tasks.md` follows `.highway/library/templates/output/codify-tasks.md`. Each task is one line: `- [ ] T001 [component] Description. File: \`path\`. Standard: \`path\`.` or `Standard: No coding standard applies.` Tasks run in component order from the accepted proposal. Within a component, a file comes before files that rely on it, and a test task directly follows its file. The README task is last. Tasks are not grouped into phases.
- **Rationale**: It matches the speckit-tasks checklist line that the request points to. One line per task keeps marking a task done a single-character change.
- **Alternatives considered**: Phases per component as in speckit-tasks. Rejected: each automation is one action with a few components, so phases add headings without adding order.

## Decision: What is written together, and what is written task by task

- **Decision**: `write` writes `codify.md`, `codify-tasks.md`, and the `code/code.md` row together, all or nothing. A new `code` step then writes each task's file and marks the task done. Files written by finished tasks stay in place when a run stops.
- **Rationale**: The spec keeps the all-or-nothing write for the record, task list, and catalog, and requires completed work to survive a stop so a later run can resume.
- **Alternatives considered**: Writing all code before marking anything. Rejected: a stop would leave no record of what is finished.

## Decision: Resume

- **Decision**: When the invocation names an automation in `code/code.md` by title or id, or when `identifier` finds the same title already recorded, and its task list has an open task, codify goes to `code` and starts at the first open task. When every task is done, codify goes to `close`.
- **Rationale**: Resuming should not require accepting the proposal again.
- **Alternatives considered**: Resume only through a new proposal. Rejected: the proposal is already accepted and saved.

## Decision: Close wording avoids status labels

- **Decision**: The close says in sentences whether every task is done, names the task that could not be finished and why, and names any missing catalog, missing standard file, or duplicate technology row. It does not use Status, Missing, Complete, or Blocked as labels.
- **Rationale**: `highway-codify` already forbids reporting those labels. The information the spec requires fits in plain sentences.
- **Alternatives considered**: A status table. Rejected for the same reason.
