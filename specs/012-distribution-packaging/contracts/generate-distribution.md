# Contract: `generate-distribution.sh`

**Feature**: `012-distribution-packaging` | **Date**: 2026-09-08

This is a command-line contract. Output format and exit codes are binding, matching the precedent
set for `validate-skill.sh` in feature 003: a change to anything below is a behavioral change and
requires a test amendment under D3.3.

---

## Invocation

```text
.highway/tools/generate-distribution.sh <target-directory>
```

| Argument | Required | Meaning |
|---|---|---|
| `<target-directory>` | Yes | Where the distribution is produced. Created if absent. |

No options. No environment variables are read. In particular, `CONSTITUTION_FILE` is **not**
honored during verification, because an override would supply from outside the very thing the
verification exists to prove is inside.

---

## Exit codes

| Code | Meaning |
|---|---|
| `0` | Distribution produced and every verification passed |
| `1` | Verification failed, or the manifest is invalid, or the step refused to overwrite |

There is no third code and no warning state. FR-011 requires a verification failure to prevent a
distribution, not to annotate one.

---

## Output format

Progress lines are written to stdout, errors to stderr.

### Success

```text
producing distribution at <target>
  included <n> paths from .highway/tools/.distribution-manifest
verifying
  PASS: no distributed file references a development-only location
  PASS: <n> cross-references resolve within the distribution
  PASS: skill validator succeeded against <n> skills using only distribution contents
distribution accepted: <target>
```

### Failure

Each failure names the file and the specific problem, per FR-010:

```text
verifying
  FAIL: distributed files reference a development-only location
    .highway/tools/README.md:12: see specs/010-constitution-relocation/spec.md
distribution rejected; target removed
```

```text
  FAIL: cross-references do not resolve within the distribution
    README.md:8: link target CONTRIBUTING.md does not exist in the distribution
```

```text
  FAIL: the distribution's own validator did not succeed
    ERROR: [P7.1] skills/highway-help/SKILL.md: no Purpose section
```

### Refusal

```text
ERROR: '<target>' exists and is not tracked by .distribution-record -- refusing to
overwrite a directory this generator did not produce. Remove it manually if it is safe.
```

```text
ERROR: '<target>/README.md' was modified outside generate-distribution.sh -- refusing to
overwrite. Restore it from the generator's output or remove it manually.
```

The wording deliberately mirrors `generate-agent-adapters.sh`, so a user who has seen one refusal
recognizes the other.

---

## Behavioral guarantees

| # | Guarantee | Requirement |
|---|---|---|
| C1 | One invocation produces the distribution; no manual selection | FR-001 |
| C2 | The path set is read from the manifest, never hard-coded | FR-004 |
| C3 | A repository path matching no manifest record is reported and the run fails | FR-006 |
| C4 | Artifacts are copied, never regenerated | FR-012 |
| C5 | Two runs from the same repository state produce byte-identical trees | FR-012 |
| C6 | A target not produced by this step is never overwritten | FR-013 |
| C7 | A rejected candidate is removed, never left behind | FR-011 |
| C8 | Verification uses only what the distribution contains | FR-009a |

### On C5 and the production record

The record is written after the tree is populated and is excluded from byte-comparison of two
runs, because it contains hashes of files that are themselves identical. Comparing two runs
therefore compares everything except a file whose content is a function of the rest.

---

## Toolchain

Uses only: `awk`, `basename`, `cat`, `cp`, `dirname`, `find`, `grep`, `mkdir`, `mktemp`, `rm`,
`sed`, `sha256sum`/`shasum`, `sort`, `tr`. All appear in the constitution's Declared Toolchain, so
D2.2 and D2.4 hold. No version-control command is invoked — the step must work in a tree that is
not a repository.
