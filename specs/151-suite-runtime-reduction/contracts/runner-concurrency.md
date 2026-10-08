# Contract: Runner Concurrency

**Feature**: 151 | **Interface**: `.highway/tools/tests/run-all.sh` CLI and output

## Command surface

```text
run-all.sh
run-all.sh --serial
run-all.sh --jobs <n>
```

| Element | Before | After |
|---|---|---|
| No arguments | runs every test serially | runs the exclusive pool serially and the parallel pool concurrently |
| Exit 0 when all pass | yes | unchanged |
| Exit non-zero when any fails | yes | unchanged |
| Final summary line | `Summary: N passed, M failed` | unchanged in shape |
| Per-test line | `PASS: <name>` / `FAIL: <name>` | unchanged in shape |
| `--serial` | absent | new; forces one-at-a-time execution (FR-011) |
| `--jobs <n>` | absent | new; sets concurrency. `--jobs 1` is equivalent to `--serial` |

## Behavioral contract

| ID | Obligation |
|---|---|
| RC-1 | The set of passing and failing test names MUST equal the set a serial run produces on the same tree. |
| RC-2 | No two tests in the exclusive pool MUST run at the same time. |
| RC-3 | No test in the parallel pool MUST run while any exclusive test is running. |
| RC-4 | Each test's output MUST be emitted as one uninterrupted block attributed to that test. |
| RC-5 | The probe residue sweep MUST complete before any test starts. |
| RC-6 | `readiness-executable.test.sh` and `highway-setup-executable.test.sh` MUST run last, as they do today. |
| RC-7 | Exclusive-pool membership MUST be declared in exactly one place in the file. |
| RC-8 | A discovered test absent from the exclusive declaration MUST run in the parallel pool. |
| RC-9 | The exit code MUST be non-zero if any test fails, regardless of pool or completion order. |

## Exclusive pool, initial membership

Declared from observed behavior. A test is listed because it writes into the live repository tree,
reads the whole live tree, or re-executes other test files.

```text
constitution-inventory.test.sh      re-executes other whole test files
distribution-packaging.test.sh      seeds probes at the repository root
adapter-coverage.test.sh            seeds probes; regenerates and diffs the live tree
shipped-tree-independence.test.sh   seeds cliprobe files under tools/ and tests/fixtures/
generate-instructions.test.sh       writes into the live tree
output-template.test.sh             writes into the live tree
profile-behavior.test.sh            writes into the live tree
profile-lifecycle.test.sh           writes into the live tree
profile-markdown-contract.test.sh   writes into the live tree
validate-skill.test.sh              writes into the live tree
feature-092-contract.test.sh        writes into the live tree
```

This list is a starting point, not a finding. A task verifies it by running the suite concurrently
several times and investigating any test that fails only under concurrency — such a failure is
evidence of real coupling and is resolved by adding the test to this list with a note, never by
loosening the test.

## Ordering guarantees deliberately not offered

The order in which parallel-pool results are printed is not specified beyond RC-4. Nothing in the
suite depends on the order of `PASS:` lines, and promising one would constrain the implementation
for no reader benefit.
