# Implementation Plan: Suite Runtime Reduction

**Branch**: `feature/test-cleanup-spec151` | **Date**: 2026-10-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/151-suite-runtime-reduction/spec.md`

## Summary

Cut suite wall time from a measured 371.8 s by removing repeated work and idle waiting, without
removing any assertion. Two changes: a content-addressed validation cache so generation stops
revalidating twelve unchanged skills on every one of its 4–13 invocations per test, and a
two-pool runner so tests that do not contend for the live tree run concurrently under `xargs -P`.

The cache is the primary lever and is expected to cascade — `constitution-inventory.test.sh`, the
single most expensive test at 88.9 s, is expensive because it re-executes the generation tests.

## Technical Context

**Language/Version**: Bash 3.2.57 (macOS default). No associative arrays, `mapfile`, `readarray`,
`${var^^}`, `&>>`, or `wait -n`.

**Primary Dependencies**: Declared Toolchain only. This change uses `find`, `sort`, `xargs`,
`sha256sum`/`shasum`, `mkdir`, `rm`, `cat` — all already declared.

**Storage**: Validation cache as files under `${TMPDIR:-/tmp}`. Never in the repository, never in
the distribution.

**Testing**: `.highway/tools/tests/run-all.sh`, 74 test files.

**Target Platform**: macOS (Apple/BSD utilities) and Linux (GNU coreutils). `xargs -P` verified
accepted on this machine; accepted by both variants.

**Project Type**: Shell toolchain for a skills distribution.

**Performance Goals**: Suite wall time ≤ 180 s, from 371.8 s. Generation run from 8.1 s to under
4 s when skills are unchanged.

**Constraints**: No assertion deleted, skipped, or loosened (FR-012). Generated artifacts
byte-identical (FR-003). Concurrency must be reducible to serial on demand (FR-011).

**Scale/Scope**: 12 skills, 4 adapter trees, 74 test files, 5 generators.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design — verdicts unchanged.*

### Process gates

**Packaging Gate** — TRIGGERED (the change touches `.highway/tools/`, which is distributed).

| Rule | Verdict | Basis |
|---|---|---|
| D1.1 | PASS | The cache path is derived from `TMPDIR` at runtime. No new file references `.specify/` or `specs/`. |
| D1.2 | PASS | The cache is optional by construction: a miss performs full validation, so the validator still exits 0 in a tree with development directories absent. |
| D6.2 | PASS | Tool documentation naming the runner's behavior is updated in the same change (D6.1), and its references resolve inside the distributed tree. |

**Toolchain Gate** — TRIGGERED (the change touches files under `.highway/tools/`).

| Rule | Verdict | Basis |
|---|---|---|
| D2.1 | PASS | No bash 4 construct. The two-pool runner uses indexed loops and `xargs -P`, not `wait -n` or associative arrays. |
| D2.2 | PASS | Every utility used is in the Declared Toolchain: `find`, `sort`, `xargs`, `sha256sum`, `shasum`, `mkdir`, `rm`, `cat`. |
| D2.3 | PASS | `xargs -P` is accepted by both the Apple/BSD and GNU variants; verified on this machine. |
| D2.4 | PASS | No package manager, interpreter, or binary is introduced. |

**Generator Gate** — TRIGGERED (the change touches `generate-agent-adapters.sh` and
`generate-catalog.sh`).

| Rule | Verdict | Basis |
|---|---|---|
| D4.1 | PASS | Hand-edit refusal is untouched; the cache governs validation only, not target writing. |
| D4.2 | PASS | FR-003 requires byte-identical output, and a task verifies it against artifacts generated before the change. |
| D4.3 | PASS | Overwrite refusal is untouched. |
| D4.4 | PASS | A task regenerates every artifact after the generator edits and confirms no diff. |

**Validation Gate** — TRIGGERED (the change modifies `validate-skill.sh`).

| Rule | Verdict | Basis |
|---|---|---|
| D3.4 | PASS | The cache is evaluated against every existing skill before it is relied on: each of the 12 skills is validated cold and warm, and the verdicts are recorded as identical. |
| D3.5 | PASS | FR-012 forbids weakening any assertion. No test is deleted, skipped, or loosened; this feature changes how tests are scheduled and how generation avoids repeat work, not what anything asserts. |

**Correspondence Gate** — N/A. The change adds, removes, and modifies no directory under
`.highway/skills/`, and alters no generator input.

### Always-applicable verification rules

| Rule | Verdict | Basis |
|---|---|---|
| D3.1 | PASS | Baseline recorded before the first edit: 74 passed, 0 failed, exit 0, 371.8 s. |
| D3.2 | PLANNED | The suite must exit 0 after the final edit. |
| D3.3 | PLANNED | This is a behavioral change to the runner and the generators; new test files are added and assert the new behavior. |
| D3.6 | PLANNED | Each new assertion is observed failing before the implementation that makes it pass — in particular, a seeded defect must still be rejected on the cache path. |
| D3.7 | PASS | No new `[auto]` rule is registered. Existing mapped tests keep their probes; a task confirms `constitution-inventory.test.sh` still passes. |
| D3.8 | PLANNED | The new tests are executed-behavior, not static document contracts. Their evidence is a measured runtime and an observed rejection, not a `grep`. |
| D7.3 | PLANNED | The completion report states the suite result and the requirement coverage as two separate claims. |

### Skill content gates

N/A: Skill Content Gate not triggered. No file under `.highway/skills/` or `.highway/library/` is
created or modified, so D1.5 does not apply.

**No FAIL. The plan proceeds to tasks.**

## Project Structure

### Documentation (this feature)

```text
specs/151-suite-runtime-reduction/
├── plan.md
├── spec.md
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/
│   └── requirements.md
├── contracts/
│   ├── validation-cache.md
│   └── runner-concurrency.md
└── tasks.md            # /speckit-tasks output, not created here
```

### Source Code (repository root)

```text
.highway/tools/
├── validate-skill.sh              # gains cache lookup and record; --no-cache escape hatch
├── lib/
│   └── validation-cache.sh        # new: key derivation, lookup, record
├── generate-agent-adapters.sh     # call site unchanged, now cheap on a hit
├── generate-catalog.sh            # call site unchanged, now cheap on a hit
└── tests/
    ├── run-all.sh                 # two pools; exclusive list declared once
    ├── validation-cache.test.sh   # new: cache correctness and defect rejection
    └── runner-concurrency.test.sh # new: pool isolation and attribution
```

**Structure Decision**: The cache lives in a new `lib/validation-cache.sh` sourced by
`validate-skill.sh`, rather than inside each generator. The generators' call sites stay as they
are, so the saving reaches every caller — including `generate-distribution.sh` and
`validate-library.sh` — without four separate edits that could drift apart.

The exclusive-test list is declared once in `run-all.sh`, mirroring D1.6's single-declaration
discipline for the distributed path set, so a future test cannot be added to one of two lists.

## Phasing

| Phase | Content | Exit measurement |
|---|---|---|
| 1 | Validation cache behind `--no-cache`, generators unchanged | Generation run time; suite still 74/0 |
| 2 | Two-pool runner | Suite wall time; three runs produce identical results |

Measure after each phase. If Phase 1 does not cascade into `constitution-inventory.test.sh`, the
89 s floor stands and SC-001 is unreachable without an amendment bringing the meta-harness into
scope. That decision point belongs at the end of Phase 1, not at the end of the feature.

## Complexity Tracking

No Constitution Check violations. Table not required.
