# Data Model: Suite Runtime Reduction

**Feature**: 151 | **Date**: 2026-10-08

This feature introduces no persistent application data. The entities below are transient
build-time state and scheduling metadata.

## Validation Record

Evidence that one state of one skill has already passed validation under one state of the
validator.

| Field | Meaning | Source |
|---|---|---|
| `skill_hash` | Content hash of the skill's `SKILL.md` | `sha256sum` of the file |
| `environment_hash` | Content hash of everything else validation depends on | `sha256sum` over `validate-skill.sh`, `tools/lib/*.sh`, both governance documents, and every file under `.highway/library/`, in sorted path order |
| `key` | `sha256` of `skill_hash` concatenated with `environment_hash` | derived |

**Representation**: an empty file named `<key>` under the cache directory. Presence means
"validated successfully". No content is stored, so there is nothing to parse and nothing that can
be partially written.

**Validation rules**

- A record is written only after a validation that exited 0.
- A failed validation writes no record, so a defective skill is re-validated and re-reported on
  every invocation (FR-002).
- A record is never read when `--no-cache` is in effect (FR-011's analogue for validation).

**State transitions**

```text
absent ──validate exits 0──▶ present
absent ──validate exits non-zero──▶ absent
present ──skill edited──▶ key changes ──▶ absent for the new content
present ──validator or governance edited──▶ environment_hash changes ──▶ absent for every skill
```

The last transition is the important one: editing a governance document or a validator library
invalidates every record at once, because `environment_hash` is shared. That is correct — a
constitution change can turn a previously valid skill invalid.

## Cache Directory

| Property | Value |
|---|---|
| Location | `${TMPDIR:-/tmp}/highway-validation-cache/` |
| Lifetime | Until the operating system clears the temporary directory |
| Repository presence | None. Never created inside the tree, so FR-005 holds without a gitignore entry |
| Distribution presence | None. It is not a path in the distribution manifest |

**Concurrency**: records are created with distinct names and no content. Two processes writing the
same key write the same empty file, so there is no interleaving hazard and no lock is required.

## Test File

The unit of scheduling and of pass/fail reporting.

| Field | Meaning |
|---|---|
| `path` | Absolute path to a discovered `*.test.sh` |
| `pool` | `exclusive` or `parallel` |
| `output_path` | Temporary file holding that test's captured output |
| `exit_code` | Recorded for the summary |

## Pool

| Pool | Membership rule | Execution |
|---|---|---|
| `exclusive` | The test writes into the live repository tree, reads the whole live tree, or re-executes other test files | Serially, one at a time |
| `parallel` | Everything else | Concurrently under `xargs -P` |
| `last` | `readiness-executable.test.sh`, `highway-setup-executable.test.sh` | Serially, after both pools, preserving today's ordering |

**Validation rules**

- Membership of `exclusive` is declared in exactly one place in `run-all.sh`.
- A test not named in that declaration is `parallel`. A test whose isolation is unproven must be
  added to the declaration rather than left to default.
- Every discovered test belongs to exactly one pool.

## Relationships

```text
Skill ──1:1──▶ Validation Record (per environment state)
Validator Environment ──1:N──▶ Validation Record
Test File ──N:1──▶ Pool
Test File ──1:1──▶ captured output
```
