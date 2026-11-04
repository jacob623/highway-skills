# Quickstart: Codify File Layout

1. `bash .highway/tools/tests/codify-file-layout.test.sh` passes.
2. `test ! -e library/coding-standards/coding-standards.md && test ! -e library/coding-standards/terraform.md` succeeds.
3. `bash .highway/tools/validate-skill.sh` passes for `highway-codify` and `highway-codify-config`.
4. `bash .highway/tools/validate-library.sh` passes for `coding-standard.md`, `codify-tasks.md`, and `codify-record.md`.
5. Run `/highway-codify-config`, then option 2, and add a standard. The proposal shows **File and Folder Structure:**. Accept with it empty: nothing is written. Fill it and accept: the standard file and the catalog both exist.
6. Run `/highway-codify` with that standard in use. Each task shows **Files:**. The task list groups lines by feature, and no line names `executor/` or `task-N/`.
7. `bash .highway/tools/tests/run-all.sh` reports 0 failed.
