# Coverage — Feature 042: Probe Reachability Correction

Every requirement id declared in `spec.md` appears below exactly once.

| Requirement | Outcome | Evidence |
|---|---|---|
| FR-001 | satisfied | .highway/tools/tests/distribution-packaging.test.sh: `generated-artifact` added to the `# Artifact classes:` header and to `DECLARED_CLASSES`, the two in agreement |
| FR-002 | satisfied | .highway/tools/tests/distribution-packaging.test.sh: the `generated-artifact` probe branch builds once and seeds both refusals, with `$$`-named artifacts and `trap` restoration |
| FR-003 | satisfied | .highway/tools/tests/distribution-packaging.test.sh: `assert_refusal_names` captures the generator's output instead of discarding it and requires the refusal to name its target |
| FR-004 | satisfied | .highway/tools/tests/distribution-packaging.test.sh: the untracked-directory guard calls `assert_refusal_names` rather than redirecting to /dev/null |
| FR-005 | satisfied | .highway/tools/tests/distribution-packaging.test.sh: the seeded leg exits 1 only when both refusals are observed, so removing either makes it exit 0 |
| FR-006 | satisfied | .highway/tools/tests/distribution-packaging.test.sh: measured `--probe nope` exit 2, unchanged |
| FR-007 | satisfied | specs/042-probe-reachability-correction/contracts/rule-probe-map.md: the D3.7 harness exercises the new classes; removing D7.2 made it announce `D7.2 probe for disposable-fixture`, removing D4.3 made it announce the distribution-packaging pair |
| FR-008 | satisfied | specs/042-probe-reachability-correction/contracts/probe-mode.md: supersedes Feature 041's contract in this feature's own directory, with a Replaces table |
| FR-009 | satisfied | specs/042-probe-reachability-correction/contracts/probe-mode.md: Runtime contract states two five-run samples and per-leg costs measured after every class was in place |
| FR-010 | satisfied | specs/042-probe-reachability-correction/contracts/probe-mode.md: 180s retained as target, recorded knowingly unmet, governance plan Phase 14 named |
| FR-011 | satisfied | specs/041-auto-check-integrity/coverage.md: the FR-010 row states thirteen rows across eight unique test files; counted 13 and 8 against the Enforcement Map |
| FR-012 | satisfied | specs/042-probe-reachability-correction/coverage.md: this record; see the note below on D7.5 provenance |
| FR-013 | satisfied | .highway/tools/tests/completion-coverage.test.sh: the corrective-set loop filters on `status == complete` before reading `Corrects` |
| FR-014 | satisfied | .specify/memory/completion-register.md: Feature 042's row declares `041-auto-check-integrity` in its `Corrects` column |
| FR-015 | satisfied | .specify/memory/constitution.md: byte-identical across this feature; no Feature 041 assertion was removed or loosened, only added to |
| FR-016 | satisfied | .highway/tools/tests/run-all.sh: exit 0 measured before the first edit and after the last |
| FR-017 | satisfied | .highway/tools/tests/distribution-packaging.test.sh: a normal-mode assertion modifies a recorded file in a built target and requires the refusal naming it — a path asserted in no mode before |
| FR-018 | satisfied | .highway/tools/tests/distribution-packaging.test.sh: `assert_refusal_names` fails when the refusal does not name its target |
| FR-019 | satisfied | specs/042-probe-reachability-correction/contracts/rule-probe-map.md: each of the three parts of D4.3's note was removed in turn and each removal failed the suite |
| FR-020 | satisfied | specs/042-probe-reachability-correction/contracts/probe-mode.md: the 240s interim ceiling is stated, and its status recorded as held under normal conditions and breached under load |
| FR-021 | satisfied | .highway/tools/tests/spec-record.test.sh: `identity_problems` hoisted above the probe block and the leg seeds a numbering gap and an identity mismatch, failing if either enforcement is removed |
| FR-022 | satisfied | .highway/tools/tests/completion-coverage.test.sh: the `disposable-fixture` leg seeds a missing row and a non-canonical header into the checked-in fixture and decides both through `coverage_check` |
| FR-023 | satisfied | specs/042-probe-reachability-correction/contracts/rule-probe-map.md: thirteen rows, one per `[auto]` rule, each naming the detecting leg |
| FR-024 | satisfied | specs/042-probe-reachability-correction/contracts/rule-probe-map.md: the mapping is derived by thirteen remove-run-restore cycles over the full suite, not by reading probe source |
| FR-025 | satisfied | .highway/tools/tests/adapter-coverage.test.sh: the `generated-artifact` leg seeds eight defects one at a time and requires each to be reported |
| FR-026 | satisfied | .highway/tools/tests/adapter-coverage.test.sh: D4.6's four orphan loops extracted into `orphan_problems()`, called by both normal mode and the probe |
| FR-027 | satisfied | .highway/tools/tests/constitution-inventory.test.sh: `pair_case` asserts each of `harness_probe_pair`'s three reports by message in normal mode; removing line 44, 47 or 50 each fails the suite |

## A note on D7.5 provenance, recorded rather than worked around

`FR-012` requires this record to name Feature 041 as the originating feature for each corrected
requirement, per `D7.5`. `correction_check` implements `D7.5` by requiring a corrective feature's
coverage record to hold at least one row with outcome `deferred` carrying
`Originating Feature NNN ... superseded by Feature NNN`.

No requirement of this feature is deferred. Every one of the twenty-seven is satisfied, and marking
one `deferred` to satisfy the shape of the check would be a false record of this feature's outcome —
the precise failure mode this feature exists to correct.

What Feature 042 corrects are Feature 041's *claims*, not Feature 041's requirements: the coverage
row at `specs/041-auto-check-integrity/coverage.md` FR-010, corrected under `FR-011` above, and the
runtime claim in Feature 041's probe-mode contract, superseded under `FR-008`. Both corrections are
recorded in the artifacts they concern, and both name Feature 041.

**This is an unresolved tension, not a satisfied requirement of `D7.5`'s current implementation.**
While Feature 042's register row reads `in-progress`, the `FR-013` filter added by this feature keeps
`correction_check` from running against it. When the row is marked `complete`, `correction_check`
will fail with `corrective record has no deferred rows`. That failure is real and should be resolved
by deciding what `D7.5` means for a corrective feature that defers nothing — not by adding a
deferred row here. It is flagged here so that whoever marks the row `complete` meets a recorded
question rather than a surprise.
