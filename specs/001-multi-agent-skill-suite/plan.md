# Implementation Plan: Multi-Agent Skill Suite

**Branch**: `001-multi-agent-skill-suite` | **Date**: 2026-09-06 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-multi-agent-skill-suite/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Build the skill-authoring **framework** for this repository: a canonical, agent-agnostic
Markdown+frontmatter format for skills, a generated catalog for discovery, and a per-agent
adapter/generation mechanism so the same canonical skill works unmodified on GitHub Copilot and
Claude Code, and is deterministically transformed for Cursor. No concrete skill topics are
authored as part of this feature (FR-011); this feature ships the mechanism only.

## Technical Context

**Language/Version**: Bash (POSIX-compatible shell scripting), consistent with the existing
`.specify/scripts/bash/` tooling already in this repository. Skills themselves are plain
Markdown files with YAML frontmatter — no compiled language is introduced.

**Primary Dependencies**: None beyond POSIX shell tools already relied on elsewhere in this repo
(e.g., `awk`/`sed`/`grep`) plus a YAML-frontmatter reader (exact tool selection recorded in
research.md). No new language runtime or package manager is introduced.

**Storage**: N/A — flat files only (canonical skills, generated catalog, generated per-agent
adapters), all committed to the repository. No database.

**Testing**: Shell-based validation/test scripts that assert: (a) a skill's frontmatter conforms
to the schema in `contracts/skill-frontmatter.schema.json`, (b) catalog generation is
deterministic (same inputs → byte-identical `catalog/index.json`), and (c) each generated
per-agent adapter matches its canonical source per `contracts/agent-adapter-contract.md`.

**Target Platform**: Any POSIX developer machine or CI runner (macOS/Linux) for the
authoring/validation tooling. The generated adapters run inside GitHub Copilot, Claude Code, and
Cursor respectively (the three agents in scope per FR-010).

**Project Type**: Single project — a content-plus-lightweight-tooling repository (no
client/server split).

**Performance Goals**: Catalog generation and validation complete in low single-digit seconds for
on the order of 100 skills; this is authoring-time tooling, not a runtime-performance-sensitive
system.

**Constraints**: MUST NOT modify any existing `speckit-*` skill file (per spec Clarifications).
MUST NOT introduce network calls in the validation/generation tooling. Every generated per-agent
adapter MUST be fully regenerable from the canonical `skills/` source with zero manual edits, so
there is never a hand-maintained fork to drift out of sync.

**Scale/Scope**: Framework only, for exactly 3 named agents at launch (FR-010: GitHub Copilot,
Claude Code, Cursor) and 0 concrete skills at launch (FR-011). Designed so adding a 4th+ agent or
the Nth skill requires no redesign of the catalog or authoring standard (FR-008).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Result |
|---|---|---|
| I. Unambiguous, Actionable Directives | Authoring standard is a machine-checkable JSON Schema (`contracts/skill-frontmatter.schema.json`), not prose guidance alone | PASS |
| II. Technology-Agnostic Portability | Canonical skill content uses only the cross-platform Agent Skills open-standard frontmatter fields; agent-specific behavior is isolated to the generation/adapter layer, never the canonical skill body | PASS |
| III. Best-Practice Grounding, Not Preference | Adopts the existing, published Agent Skills open standard (agentskills.io) rather than a bespoke schema; reuses this repo's existing Bash tooling convention | PASS |
| IV. Measurable Quality Gates | Every gate (schema validity, catalog determinism, adapter parity) is a pass/fail shell check, not subjective review | PASS |
| V. Reusable Patterns & Robust Error Handling | `validate-skill.sh` and `generate-*.sh` must define explicit failure output and next-step guidance for missing/invalid frontmatter (detailed in data-model.md) | PASS |
| VI. Deterministic, Explicit Decision Criteria | Catalog and adapter generation are pure functions of `skills/` content — same input always yields the same output | PASS |
| VII. Long-Term Maintainability | Single canonical source (`skills/`) with generated, never hand-edited, per-agent copies eliminates drift | PASS |
| VIII. Reliability, Predictability, Repeatability | Regeneration is idempotent and verifiable (quickstart.md documents the verification steps) | PASS |

No violations identified. Complexity Tracking is not required.

## Project Structure

### Documentation (this feature)

```text
specs/001-multi-agent-skill-suite/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md         # Phase 1 output (/speckit-plan command)
├── contracts/            # Phase 1 output (/speckit-plan command)
└── tasks.md              # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
skills/                          # canonical, agent-agnostic skill sources (this suite's own content)
├── _authoring-standard.md       # human-readable authoring standard (mirrors contracts/skill-frontmatter.schema.json)
└── <skill-name>/
    └── SKILL.md                 # canonical skill: YAML frontmatter + body (added by follow-on features, not this one)

tools/
├── validate-skill.sh            # validates one skill's frontmatter/body against the schema
├── generate-catalog.sh          # builds catalog/index.json + catalog/index.md from skills/*/SKILL.md frontmatter
├── generate-agent-adapters.sh   # regenerates .github/skills/, .claude/skills/, .cursor/rules/ from skills/
└── tests/
    ├── validate-skill.test.sh
    ├── generate-catalog.test.sh
    └── generate-agent-adapters.test.sh

catalog/
├── index.json                   # machine-readable catalog (generated, not hand-edited)
└── index.md                     # human-readable catalog (generated, not hand-edited)

.github/skills/<skill-name>/SKILL.md   # generated adapter for GitHub Copilot (existing speckit-* folders untouched)
.claude/skills/<skill-name>/SKILL.md   # generated adapter for Claude Code
.cursor/rules/<skill-name>.mdc         # generated adapter for Cursor (transformed frontmatter)
```

**Structure Decision**: A single canonical `skills/` directory holds agent-agnostic skill
sources. `tools/` holds the Bash validation/generation scripts (this feature's only executable
code). `catalog/` holds generated, machine- and human-readable indexes. Per-agent adapters are
generated (never hand-authored) into each agent's native discovery location
(`.github/skills/`, `.claude/skills/`, `.cursor/rules/`), keeping existing `speckit-*` skill
folders untouched. This feature creates the mechanism and (per FR-011) leaves `skills/` itself
empty of concrete skill topics.

## Complexity Tracking

> No Constitution Check violations were identified; this section is intentionally empty.
