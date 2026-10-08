# Research: Suite Runtime Reduction

**Feature**: 151 | **Date**: 2026-10-08

All measurements below were taken on the current tree, macOS, bash 3.2.57.

## 0. Baseline correction

**Decision**: The baseline is **371.8 s** wall for `run-all.sh`, reporting 74 passed, 0 failed.

**Rationale**: An earlier measurement of 695 s was a cold first run. Re-measured warm, every
expensive test was far cheaper, and the ranking changed:

| Test | Cold (superseded) | Warm (baseline) |
|---|---:|---:|
| constitution-inventory | 111.6 s | 88.9 s |
| distribution-packaging | 65.8 s | 45.2 s |
| generate-agent-adapters | 236.1 s | 33.7 s |
| generate-catalog | 102.6 s | 20.6 s |
| adapter-coverage | 19.1 s | 17.6 s |
| validate-skill | 23.6 s | 15.8 s |
| generate-library-catalog | 31.3 s | 12.4 s |

The cold figure for `generate-agent-adapters` was wrong by 7×. Recording this because the
original plan of attack was derived from it and would have optimised the wrong test first.

**Alternatives considered**: Keeping the cold number as a conservative target. Rejected — a
target derived from an inflated baseline is met on day one by doing nothing, which makes the
success criterion worthless as evidence.

## 1. Where the generation time actually goes

**Decision**: Revalidation is the dominant removable cost inside generation.

**Rationale**: Measured directly.

- `validate-skill.sh` on one skill: **372 ms**
- Skills present: **12** → **~4.5 s** per generation run
- One `generate-agent-adapters.sh` run: **8.1 s** → revalidation is **~55%**
- `generate-agent-adapters.test.sh` invokes the generator 4 times → ~18 s of its 33.7 s
- `sha256sum` is present at `/sbin/sha256sum`; 48 spawns cost 567 ms (~7%) — already the fast
  path and not worth attacking

Generators that validate every skill before generating: `generate-agent-adapters.sh` (line 114),
`generate-catalog.sh` (line 38). `generate-distribution.sh` and `validate-library.sh` invoke the
validator differently and are in scope only insofar as they call the same script.

## 2. How to avoid revalidating unchanged skills

**Decision**: A content-addressed validation cache, shared across processes, stored outside the
repository.

**Rationale**: The generator is a fresh process on every invocation, so an in-memory memo cannot
help across the 4–13 invocations a single test makes. The cache must outlive the process.

Key = hash of the skill's own content combined with a hash of the **validator environment**:
`validate-skill.sh`, `tools/lib/*.sh` (11 files), both governance documents, and every file under
`.highway/library/` (21 files). Measured cost of hashing that whole environment: **35 ms**. So a
35 ms computation replaces 4.5 s of work.

Only successful validations are recorded. A failure is never cached, so FR-002's error message is
produced by a real validation run every time.

**Alternatives considered**:

- **A `--skip-validation` flag for test callers.** Rejected, and this is the important rejection.
  Several tests deliberately seed a defect into a skill and require the generator to reject it —
  `generate-agent-adapters.test.sh` asserts exactly this for D4.1. A blanket skip would make those
  tests pass while proving nothing. A content-addressed cache handles the same case correctly: a
  seeded defect changes the content, so the key misses and the skill is validated and rejected.
- **Timestamp-based invalidation (`mtime`).** Rejected. D2.2's declared toolchain excludes `stat`,
  and a test that writes a file twice inside the same second would get a false hit.
- **Caching inside the repository tree.** Rejected. It would need a gitignore entry to satisfy
  FR-005 and would risk being swept into the distribution. Keeping it under `TMPDIR` satisfies
  FR-005 structurally rather than by convention.

## 3. Concurrency mechanism

**Decision**: `xargs -P`.

**Rationale**: `xargs` is in the Declared Toolchain, so D2.2 and D2.4 are satisfied with no new
dependency. `-P` is accepted by both BSD/Apple and GNU `xargs`, satisfying D2.3; verified on this
machine. Bash 3.2.57 has no `wait -n`, which rules out a hand-rolled job-slot loop that reaps
completions as they finish.

**Alternatives considered**:

- **Background jobs with `&` and a bare `wait`.** Works on bash 3.2 but only in fixed batches —
  the whole batch waits for its slowest member. With one 89 s test present, batching wastes most
  of the benefit.
- **GNU `parallel`.** Rejected under D2.4; not present on the target platform by default.
- **`make -j`.** Rejected; `make` is not in the Declared Toolchain.

## 4. Which tests may not run concurrently

**Decision**: Two pools. An **exclusive pool** runs serially; everything else runs under `xargs -P`.
Membership is declared in one place in `run-all.sh`, and a test is exclusive until proven isolated.

**Rationale**: The hazard is not probe-name collision — `run-all.sh`'s header records that the
probing tests already name probes by PID. The hazard is that a test which reads the *whole* live
tree can observe another test's probe mid-flight and report a defect in the wrong file. The header
records this happening twice already, from residue rather than concurrency.

Tests observed writing into the live tree: `adapter-coverage`, `feature-092-contract`,
`generate-instructions`, `output-template`, `profile-behavior`, `profile-lifecycle`,
`profile-markdown-contract`, `validate-skill`. The sweep list in `run-all.sh` adds
`distribution-packaging` and `shipped-tree-independence`. `constitution-inventory` re-executes
other whole test files and must therefore be exclusive regardless.

`readiness-executable.test.sh` and `highway-setup-executable.test.sh` already run last by name and
keep that position.

**Consequence, recorded because it bounds the result**: most of the expensive tests land in the
exclusive pool. Concurrency alone therefore buys relatively little; the suite's floor is the
serial sum of the exclusive pool. This is why Story 1 is P1 and Story 2 is P2 — the cache shrinks
the exclusive pool itself, including the meta-harness that re-runs the generation tests.

**Alternatives considered**: Giving every test its own copy of the tree so all 74 could run
concurrently. Rejected as out of proportion — it would rewrite the setup of 28 tests that already
build `mktemp` trees and 10 that deliberately test against the real tree, to save time the cache
removes more cheaply.

## 5. Failure attribution under concurrency

**Decision**: Capture each test's output to its own temporary file and print it whole, in a
deterministic order, after that test completes.

**Rationale**: FR-009 requires both correct attribution and no interleaving. Concurrent writers to
one stream interleave at arbitrary boundaries, which would corrupt the PASS/FAIL lines the summary
is built from.

## 6. Reaching SC-001

**Decision**: Treat SC-001 (≤180 s) as achievable but not assured, and measure after each phase
rather than at the end.

**Rationale**: Estimated from the measurements above — the cache removes roughly 4.5 s per
generation invocation across the generation tests and cascades into `constitution-inventory`,
which re-executes them. If that cascade does not materialise, `constitution-inventory` alone
remains an 89 s floor and no amount of concurrency reaches 180 s. That is the feature's main risk
and it is recorded in the spec's Assumptions rather than discovered at the end.
