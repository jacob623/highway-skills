# Quickstart: Codify Coding Standards and Task List

Validate this change after implementation. Do not treat this file as the implementation steps.

## Prerequisites

- Branch `201-codify-coding-standards`

## Confirm the standards folder

1. Compare `library/coding-standards/` with [contracts/coding-standards.md](contracts/coding-standards.md).
2. The catalog has one row, and its Standard Path exists.
3. `terraform.md` has Scope, Rules, and Tests, and the first Tests line says whether tests are required.
4. `.highway/tools/.distribution-manifest` includes `library/coding-standards`.

## Confirm the task list

1. Compare `.highway/library/templates/output/codify-tasks.md` and the codify `write` step with [contracts/task-list.md](contracts/task-list.md).
2. Each task line has a checkbox, a number, a component, a file, and a standard or `No coding standard applies.`
3. The README task is last.

## Confirm the coding flow

1. Compare the codify `code` step, resume handling, and close with [contracts/coding-flow.md](contracts/coding-flow.md).
2. No question is asked between acceptance and the first task.
3. A task that cannot be finished stops the run and is named in the close.

## Confirm the suite

Run `.highway/tools/validate-library.sh` on `.highway/library/templates/output/codify-tasks.md`, `.highway/tools/validate-skill.sh` on `.highway/skills/highway-codify`, and `.highway/tools/tests/run-all.sh`. Each is expected to exit 0.
