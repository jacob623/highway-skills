# Implementation Plan: Add Codex as a Supported Agent

**Branch**: `099-codex-agent-support` | **Date**: 2026-09-29 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/099-codex-agent-support/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Add `codex` as a fourth supported agent. Skill publishing writes an identity copy to
`.agents/skills/<id>/SKILL.md`. Instruction publishing writes the same merged bytes already
written to `.claude/CLAUDE.md` and `.github/copilot-instructions.md` into `AGENTS.md` at the
repository root. Existing skill files are not edited. The compatibility enum and the declared
agent list gain `codex`. The Highway Codex skill directories and `AGENTS.md` ship. Personal Codex
directories are not written.

## Technical Context

**Language/Version**: Bash 3.2.57-compatible scripts; Markdown documents

**Primary Dependencies**: The existing skill publisher `generate-agent-adapters.sh` and instruction publisher `generate-instructions.sh`. No new dependency and no new generator.

**Storage**: Adapter rows stay in `.highway/tools/.adapter-manifest`. Instruction rows stay in `.highway/tools/.instruction-manifest`. Distribution rows stay in `.highway/tools/.distribution-manifest`. The compatibility enum stays in `.highway/tools/.frontmatter-contract`.

**Testing**: Extend the existing publisher and coverage tests. `run-all.sh` before the first edit and after the last (allow up to 240 seconds).

**Target Platform**: macOS and GNU-like shells; consumed by Codex, in addition to GitHub Copilot, Claude Code, and Cursor

**Project Type**: Repository-distributed agent skill suite with shell tooling

**Performance Goals**: One extra identity copy per skill and one extra copy of the merged guidance file. No network.

**Constraints**: Codex skill bytes match the canonical skill. `AGENTS.md` bytes match the other two merged files. The three agent-config arrays in `generate-agent-adapters.sh` stay one line each. Bash 3.2 only. No skill body edit. No file deletion. No `specs/` or `.specify/` string added to `.highway/DISTRIBUTION.md`.

**Scale/Scope**: One new agent id, 12 existing Highway skills, one guidance file, the distribution rows for those outputs, the compatibility token, and the declared-agent-list amendment

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature publishes into a new agent tree and amends the declared-agent list. It does not
modify any `SKILL.md` or any file under `.highway/library/`.

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | `exclude` `.agents`, then `include` each `.agents/skills/highway-<id>` and `AGENTS.md`. `speckit-*` stays out. Existing distribution verifications still scan shipped files for `.specify/` and `specs/`. |
| Toolchain Gate (D2.1–D2.4) | PASS | Both publishers already use the declared toolchain. No runtime dependency is added. |
| Generator Gate (D4.1–D4.4) | PASS | Codex skills use the existing identity-copy and drift refusal. `AGENTS.md` uses the existing instruction drift refusal. Both publishers are re-run after the paths exist. |
| Correspondence Gate (D4.5–D4.7) | PASS | `codex` is added to the declared agent trees. `adapter-coverage.test.sh` expects `.agents/skills/<id>/SKILL.md`, an adapter-manifest row, and a distribution include. The currency regeneration already runs both publishers and will compare the new outputs. D4.7's generator list is unchanged. |
| Validation Gate (D3.4, D3.5) | PASS | No unconditional new check is added against artifacts that do not yet exist. The Codex expectations are enabled in the same change as the generated files. |
| Documentation Gate (D6.1) | PASS | `README.md`, `.highway/tools/README.md`, `.highway/DISTRIBUTION.md`, and `.highway/skills/_authoring-standard.md` name Codex in the same change. |

Process result: PASS. The constitution amendment is MINOR, 2.1.0 → 2.2.0. It adds `codex` to the
declared agent trees. The Codex copies that make D4.5 pass are produced in the same change, so the
tree conforms when the sentence is enabled. The sync impact report names the version line, the
last-amended date, and the declared-agent-trees sentence. D4.5 and D4.6 rule text stay as they
are; their enforcement map cells already say "each declared agent tree."

### Skill content gates

The Skill Content Gate triggers because `.highway/skills/_authoring-standard.md` is edited. No
`SKILL.md` is edited.

| Rule | Verdict | Evidence |
|---|---|---|
| P7.3 | PASS | The edit adds `codex` to the documented compatibility list. It cites no Highway Skills Constitution rule text and restates none. |

Skill content result: PASS.

**Post-design re-check**: PASS. Phase 1 added no third publisher, no skill-body edit, and no
second manifest. The Codex path and the `AGENTS.md` byte rule are fixed in
[research.md](./research.md).

## Project Structure

### Documentation (this feature)

```text
specs/099-codex-agent-support/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── codex-skill-contract.md
│   └── codex-guidance-contract.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/tools/generate-agent-adapters.sh          # one codex row, arrays stay one line
.highway/tools/generate-instructions.sh            # AGENTS.md is a third copy of the merged bytes
.highway/tools/.adapter-manifest                   # one row per Codex skill file
.highway/tools/.instruction-manifest               # one AGENTS.md row
.highway/tools/.distribution-manifest              # exclude .agents; include 12 skill dirs and AGENTS.md
.highway/tools/.frontmatter-contract               # enum gains codex
.highway/tools/tests/adapter-coverage.test.sh      # fourth adapter path; orphan and on-disk cases
.highway/tools/tests/generate-agent-adapters.test.sh
.highway/tools/tests/new-agent-extensibility.test.sh
.highway/tools/tests/generate-instructions.test.sh
.highway/tools/tests/instruction-coverage.test.sh
.highway/tools/tests/highway-new.test.sh
.highway/tools/tests/run-all.sh
.highway/skills/_authoring-standard.md             # compatibility list only
.agents/skills/highway-<id>/SKILL.md               # 12 generated copies
AGENTS.md
.specify/memory/constitution.md                    # declared agent trees, version 2.2.0
README.md
.highway/tools/README.md
.highway/DISTRIBUTION.md
```

**Structure Decision**: Codex reuses the two publishers already in the tree. Skills stay an
identity copy. Repository guidance stays one merged body, written to one more path. A Codex-specific
transform or a fourth authoring directory is not added.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | One row on the existing skill publisher and one extra copy on the existing instruction publisher are the smaller change. |
