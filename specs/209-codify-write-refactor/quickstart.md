# Quickstart: Codify Write Refactor

## Static checks

1. Run `bash .highway/tools/tests/codify-write-refactor.test.sh`. Expect a PASS line.
2. Run `bash .highway/tools/validate-skill.sh .highway/skills/highway-codify`. Expect `OK`.
3. Run the full suite with `bash .highway/tools/tests/run-all.sh`. Expect 0 failed.

## Behavior walkthrough

1. In a project where implementation "Worker" has accepted automations "Establish the worker" and "Restart the worker", run `/highway-codify Worker`.
   - The list does not show either title. A later capability fills the place.
2. Add a capability whose suggestion is "establish the worker".
   - It is left out without opening a record, because case is ignored.
3. Add a capability whose suggestion is "Bring the worker back up".
   - Highway reads `code/<Restart id>/codify.md`. It is left out because the record is that action.
4. Mark "Restart the worker" removed in `code/code.md`.
   - It can be suggested again.
5. Accept a new automation.
   - The task list follows `codify-tasks.md`, the same as before. See [contracts/write-step.md](contracts/write-step.md).
