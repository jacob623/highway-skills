# Implementation Plan: Distribute Always-On Agent Instructions from One Source

**Branch**: `098-agent-instruction-framework` | **Date**: 2026-09-29 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/098-agent-instruction-framework/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Add `.highway/instructions/<id>.md` as the only place an always-on repository instruction is
authored, and add `generate-instructions.sh` to publish it. Each body is copied unchanged into
`.cursor/rules/<id>.mdc` (`alwaysApply: true`) and, in filename order, into `.claude/CLAUDE.md`
and `.github/copilot-instructions.md`. The first source is `highway-agent-context.md`, whose body
is the Highway Agent Context text in the spec. The skill generator is not extended. The skill-suite
leftover-rule check is narrowed so an instruction-owned `highway-*.mdc` file is allowed. Every
instruction ships; there is no per-instruction exclude flag.

## Technical Context

**Language/Version**: Bash 3.2.57-compatible scripts; Markdown documents

**Primary Dependencies**: Existing `lib/frontmatter.sh` (`fm_block`, `fm_body`, `fm_get`) and the declared toolchain (`awk`, `cp`, `grep`, `mkdir`, `mktemp`, `mv`, `sort`, `sha256sum`/`shasum`). No new dependency.

**Storage**: `.highway/instructions/<id>.md` sources; `.highway/tools/.instruction-manifest` (path, id, sha256); distribution rows in the existing `.distribution-manifest`

**Testing**: New Bash tests under `.highway/tools/tests/`; the existing suite via `run-all.sh` (up to 240 seconds) before the first edit and after the last

**Target Platform**: macOS and GNU-like shells; consumed by Cursor, Claude Code, and GitHub Copilot

**Project Type**: Repository-distributed agent skill suite with shell tooling

**Performance Goals**: One pass over the instruction set. No network and no new per-request work.

**Constraints**: Body bytes are identical in every output. The skill generator stays a three-way identity copy and never writes `.cursor/rules/`. Instruction ids may start with `highway-`. Merged files have no per-instruction exclude. Bash 3.2 only. No `specs/` or `.specify/` string in a shipped instruction body.

**Scale/Scope**: One generator, one manifest, one first instruction, three generated outputs, two new tests, one narrowed guard, one constitution list edit, and the live docs that describe publishing

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature adds a generator, an instruction source, and generated files. It does not modify
`.highway/skills/` or `.highway/library/`.

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | Every instruction ships through the existing distribution manifest. A body containing `.specify/` or `specs/` fails the existing distribution verification. New include rows are added for the three outputs. |
| Toolchain Gate (D2.1–D2.4) | PASS | The generator reuses `lib/frontmatter.sh` and the declared toolchain. No runtime dependency is added. |
| Generator Gate (D4.1–D4.4) | PASS | Validate-then-write, refuse-to-overwrite, and byte-stable output match the skill generator. Outputs are regenerated after the generator exists. |
| Correspondence Gate (D4.5–D4.7) | PASS | D4.5 and D4.6 stay skill-specific and are not rewritten. D4.7 gains `generate-instructions.sh` on the declared-generator list, and `adapter-coverage.test.sh` runs it in the same temporary-tree regeneration it already performs for the other declared generators. Instruction presence and orphans are checked by a new test, not by stretching D4.5. |
| Validation Gate (D3.4, D3.5) | PASS | The leftover-rule assertion is narrowed, with the superseded behavior recorded. New checks are seeded to fail before the generator writes. |
| Skill Content Gate | N/A | No file under `.highway/skills/` or `.highway/library/` is created or modified. |

Process result: PASS. The constitution amendment is MINOR, 2.0.0 → 2.1.0. It adds one name to the
declared-generator list and does not redefine a principle. The outputs that make D4.7 pass are
committed in the same change. D1.3, D1.4, and D5.3 are recorded in the sync impact report: the only
changed elements are the version line, the last-amended date, the declared-generator list, and the
D4.7 enforcement-map cell that names the added generator.

**Post-design re-check**: PASS. Phase 1 added no dependency, no skill-content edit, and no second
distribution manifest. Empty-output bytes and the manifest columns are decided in
[research.md](./research.md).

## Project Structure

### Documentation (this feature)

```text
specs/098-agent-instruction-framework/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── instruction-source-contract.md
│   └── instruction-output-contract.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/
├── instructions/highway-agent-context.md
├── tools/
│   ├── generate-instructions.sh
│   ├── .instruction-manifest
│   ├── .distribution-manifest          # three new include rows
│   ├── README.md
│   └── tests/
│       ├── generate-instructions.test.sh
│       ├── instruction-coverage.test.sh
│       ├── generate-agent-adapters.test.sh   # leftover-rule guard narrowed
│       ├── adapter-coverage.test.sh          # currency run includes the new generator
│       └── run-all.sh                        # sweep for abandoned instruction fixtures
.cursor/rules/highway-agent-context.mdc
.claude/CLAUDE.md
.github/copilot-instructions.md
.specify/memory/constitution.md         # declared-generator list, version 2.1.0
README.md
```

**Structure Decision**: A second generator, parallel to `generate-agent-adapters.sh`, with its own
manifest. Instructions are not skills and are not identity copies, because Claude Code and Copilot
each have one always-on file. The skill pipeline is left as it is.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | A separate generator is the smaller change. Extending the skill generator would break its identity-copy promise. |
