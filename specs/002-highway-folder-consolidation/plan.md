# Implementation Plan: Consolidate Skill Suite Support Files into `.highway/`

**Branch**: `002-highway-folder-consolidation` | **Date**: 2026-09-06 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/002-highway-folder-consolidation/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Relocate the three directories the Multi-Agent Skill Suite feature delivered — `skills/`,
`tools/`, and `catalog/` — into a single new top-level `.highway/` directory
(`.highway/skills/`, `.highway/tools/`, `.highway/catalog/`), with no change to their internal
structure or content. The three per-agent adapter output directories
(`.github/skills/`, `.claude/skills/`, `.cursor/rules/`) and the spec-kit process directories
(`.specify/`, `specs/`) are explicitly out of scope and stay exactly where they are. The
relocated tooling must be updated to resolve two distinct roots — the `.highway/` framework
root (for reading skills/writing the catalog) and the true repository root (for writing agent
adapters) — since these are no longer the same directory once the move is complete. All
documentation referencing the old paths must be updated, and the full existing test suite must
pass, unmodified in its assertions, after the move.

## Technical Context

**Language/Version**: Bash (POSIX-compatible shell scripting), unchanged from the existing
`tools/*.sh` implementation. No new language or version is introduced by this feature.

**Primary Dependencies**: None beyond what the existing tooling already uses (`awk`, `sed`,
`grep`, `mkdir`, `mv`/`cp`, `sha256sum`/`shasum`). No new dependency is introduced.

**Storage**: N/A — this feature is a filesystem directory/file relocation plus documentation
updates. No database, no new persisted format.

**Testing**: The existing `tools/tests/*.test.sh` suite (run via `tools/tests/run-all.sh`),
relocated to `.highway/tools/tests/` and updated only where it hardcodes the old base paths.
Assertions themselves (what counts as pass/fail) MUST NOT change.

**Target Platform**: Same as the existing framework — any POSIX developer machine or CI runner
(macOS/Linux). MUST remain compatible with macOS's default `/bin/bash` (3.2.57), which does not
support associative arrays and raises "unbound variable" when expanding an empty array under
`set -u` — a constraint already accounted for in the existing tooling and preserved here.

**Project Type**: Single project — a repository-restructuring change to an existing
content-plus-lightweight-tooling repository (no client/server split).

**Performance Goals**: N/A — a one-time structural change to a set of files, not a runtime
system with a performance profile.

**Constraints**: MUST NOT change the byte content of anything written to `.github/skills/`,
`.claude/skills/`, or `.cursor/rules/` (FR-006). MUST NOT modify `.specify/` or `specs/` (fixed,
non-configurable spec-kit path conventions). MUST NOT leave duplicate copies of `skills/`,
`tools/`, or `catalog/` content at their old top-level paths once complete (FR-009). MUST NOT
introduce network calls or new external dependencies.

**Scale/Scope**: Exactly 3 directories relocated (`skills/`, `tools/`, `catalog/`) into
`.highway/`; path-resolution logic updated in the 3 generator/validator scripts plus their test
scripts; documentation updated in the root `README.md`, `tools/README.md`, `catalog/README.md`,
and `skills/_authoring-standard.md` (all likewise relocating with their parent directory, except
the root `README.md`, which stays at the repository root).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature changes repository file organization and internal tooling path resolution; it does
not author or amend any `SKILL.md` content, so most Core Principles (which govern skill
*content*) are not directly engaged. Applicability is assessed below.

| Principle | Check | Result |
|---|---|---|
| I. Unambiguous, Actionable Directives | N/A — no skill content is authored or amended by this feature | N/A |
| II. Technology-Agnostic Portability | N/A — no skill content is authored or amended by this feature | N/A |
| III. Best-Practice Grounding, Not Preference | N/A — no skill content is authored or amended by this feature | N/A |
| IV. Measurable Quality Gates | The relocation's success is verified by pass/fail checks: full test suite passes (SC-002), byte-identical adapter output (SC-003), zero stale doc references (SC-004) | PASS |
| V. Reusable Patterns & Robust Error Handling | Relocated scripts continue to use the existing validate-before-write / abort-with-no-partial-output pattern; no new untested error path is introduced | PASS |
| VI. Deterministic, Explicit Decision Criteria | The old→new path mapping is a fixed, explicit table (see data-model.md); no discretionary judgment is required to perform or verify the move | PASS |
| VII. Long-Term Maintainability | Consolidating framework-internal files under one directory reduces root-level clutter and makes the framework/agent-output boundary self-evident, improving maintainability | PASS |
| VIII. Reliability, Predictability, Repeatability | The move is a one-time, fully-specified operation with an explicit "done" state (old paths absent, new paths present, tests green); quickstart.md documents how to verify it | PASS |

No violations identified. Complexity Tracking is not required.

## Project Structure

### Documentation (this feature)

```text
specs/002-highway-folder-consolidation/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md         # Phase 1 output (/speckit-plan command)
├── quickstart.md         # Phase 1 output (/speckit-plan command)
└── tasks.md              # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

No `contracts/` directory is produced by this feature: it relocates existing directories without
changing any interface (the frontmatter schema, catalog schema, and adapter transform contracts
from `specs/001-multi-agent-skill-suite/contracts/` remain unchanged and still apply verbatim at
their new source location).

### Source Code (repository root)

```text
.highway/
├── skills/
│   └── _authoring-standard.md       # unchanged content, new location
├── tools/
│   ├── validate-skill.sh            # updated: resolves HIGHWAY_ROOT and REPO_ROOT separately
│   ├── generate-catalog.sh          # updated: reads/writes catalog under HIGHWAY_ROOT
│   ├── generate-agent-adapters.sh   # updated: reads skills under HIGHWAY_ROOT, writes adapters under REPO_ROOT
│   ├── README.md                    # updated: new paths
│   ├── lib/
│   │   ├── frontmatter.sh
│   │   └── schema-validate.sh
│   ├── .adapter-manifest            # relocates with tools/; still tracks agent-adapter targets (REPO_ROOT-relative paths)
│   └── tests/
│       ├── validate-skill.test.sh
│       ├── generate-catalog.test.sh
│       ├── generate-agent-adapters.test.sh
│       ├── new-agent-extensibility.test.sh
│       ├── run-all.sh
│       └── fixtures/
└── catalog/
    ├── README.md                    # updated: new paths
    ├── index.json                   # generated, unchanged shape
    └── index.md                     # generated, unchanged shape

.github/skills/<skill-name>/SKILL.md   # UNCHANGED location: generated adapter for GitHub Copilot
.claude/skills/<skill-name>/SKILL.md   # UNCHANGED location: generated adapter for Claude Code
.cursor/rules/<skill-name>.mdc         # UNCHANGED location: generated adapter for Cursor

README.md                              # stays at repo root; internal links updated to .highway/ paths
.specify/                              # UNCHANGED: spec-kit's own scaffolding, out of scope
specs/                                 # UNCHANGED: spec-kit's own scaffolding, out of scope
```

**Structure Decision**: Everything that is internal to the skill-authoring framework itself —
authored skill sources, generation/validation tooling (including its tests and the
drift-detection manifest), and the generated catalog — moves as-is under a single new
`.highway/` directory, one level deeper than before, with no internal restructuring within each
of the three directories. Nothing that a coding agent reads directly (`.github/skills/`,
`.claude/skills/`, `.cursor/rules/`) moves. Because `tools/` moving one level deeper changes the
relationship between "the tooling's own root" and "the true repository root" (they were
previously the same directory's parent; now they are one level apart), every script's root-
resolution logic is updated to compute both explicitly rather than assuming they coincide.

## Complexity Tracking

*No violations — table intentionally omitted.*
