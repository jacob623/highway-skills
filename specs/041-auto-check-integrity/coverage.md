# Feature 041 Coverage Record

| Requirement | Outcome | Evidence |
|---|---|---|
| FR-001 | satisfied | `.specify/memory/completion-register.md`: sole `Status` source; `register_rows`/`register_problems` derive scope, rejecting an unregistered directory (A1) or an entry naming no directory (A2) |
| FR-002 | satisfied | `.specify/memory/completion-register.md`: lives outside `specs/`; no completed feature's `spec.md`/`plan.md`/`tasks.md` was edited to enable it |
| FR-003 | satisfied | `.highway/tools/tests/completion-coverage.test.sh`: `register_rows`/`register_problems` read only the register file, never task-checkbox state |
| FR-004 | satisfied | `.highway/tools/tests/completion-coverage.test.sh`: assertions A1 and A2 reject an unregistered directory and an orphan register entry, exercised in the self-test block |
| FR-005 | satisfied | `.specify/memory/constitution.md`: `D7.2`/`D7.4`/`D7.5` already state the register-driven mechanism, ratified by Feature 039 |
| FR-006 | satisfied | `.highway/tools/tests/completion-coverage.test.sh`: `correction_check` loop is driven from `register_rows` filtered to a non-`-` `Corrects` value, not an enumerated list |
| FR-007 | satisfied | `.specify/memory/completion-register.md`: `Corrects` values are hand-written; assertion A5 validates shape only (exists, strictly lower-numbered, not self), inferring no new relationship |
| FR-008 | satisfied | `.highway/tools/tests/constitution-inventory.test.sh`: `harness_probe_pair`/`harness_run` execute each mapped test's declared `--probe <class>` and `--probe <class> --neutralise`, replacing the old comment-grep check |
| FR-009 | satisfied | `.highway/tools/tests/constitution-inventory.test.sh`: `harness_probe_pair` reports a probe that does not fail, and `harness_run` reports an empty `# Artifact classes:` declaration |
| FR-010 | satisfied | `.highway/tools/tests/constitution-inventory.test.sh`: thirteen Enforcement Map `[auto]` rows across eight unique test files were exercised per declared class, including this check's own `source-document` self-probe branch. Corrected by Feature 042: this row previously read "all twelve Enforcement-Map-mapped checks were proved to fail per declared class" — twelve was miscounted, and "proved to fail" overstated what executing a probe per class establishes, since four of the thirteen rules were reached by no leg at all |
| FR-011 | satisfied | `.highway/tools/tests/generate-agent-adapters.test.sh`: hand-edit refusal, generator determinism, generated-artifact coverage, and orphan/stray-path rejection each seed a defect via `--probe` and are observed caught |
| FR-012 | satisfied | `.highway/tools/tests/run-all.sh`: every probe fixture is named with `$$` and removed by its owning test's `trap ... EXIT` plus the suite-level sweep; confirmed no residue via `git status` after runs |
| FR-013 | satisfied | `specs/038-readiness-verification-corrections/coverage.md`: header `| Requirement | Outcome | Evidence |` with exactly 15 rows, one per declared requirement id |
| FR-014 | satisfied | `specs/040-historical-coverage-reconstruction/coverage.md`: exists with one row per its 12 declared requirements |
| FR-015 | satisfied | `governance-plan.md`: Phase 12 section carries an appended note after its Done-when list naming the two unmet conditions; original Done-when text unchanged |
| FR-016 | satisfied | `.specify/memory/constitution.md`: no amendment was made by this feature; the rules it enforces were already ratified by Feature 039 |
| FR-017 | satisfied | `.highway/tools/tests/completion-coverage.test.sh`: no new script or `lib/` module was added; `D7.2` and `D3.7` remain decided solely by this file and `constitution-inventory.test.sh` |
| FR-018 | satisfied | `.highway/governance/constitution.md`: no diff; this feature's edits are confined to test files, the completion register, `governance-plan.md`, and its own spec directory |
| FR-019 | satisfied | `.highway/tools/tests/constitution-inventory.test.sh`: the zero-pairs branch, self-probe recursion guard, and register assertion A5 cases were each observed failing before being relied on |
| FR-020 | satisfied | `.highway/tools/tests/run-all.sh`: exits 0 both before this feature's work began and now |
