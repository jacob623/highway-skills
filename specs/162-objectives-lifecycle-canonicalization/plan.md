# Implementation Plan: Objectives Lifecycle Canonicalization

**Branch**: `162-objectives-lifecycle-canonicalization` | **Date**: 2026-10-12 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/162-objectives-lifecycle-canonicalization/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Canonicalize the `highway-objectives` development guidance around one Objective Development Lifecycle and one authoritative Converged Objective proposal definition. The implementation edits the source skill, regenerates its four adapters, updates the focused static contract test, and runs the full repository suite. Objective records, persistence, identifiers, acceptance mechanics, and other protected contracts remain unchanged.

## Technical Context

**Language/Version**: Markdown and POSIX/macOS-compatible Bash 3.2 test scripts

**Primary Dependencies**: Highway skill documents, generated agent adapters, repository shell test harness

**Storage**: Markdown guidance and specification artifacts; no runtime or persistent data changes

**Testing**: `.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh` and `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway repository distribution across `.highway`, `.github`, `.claude`, `.cursor`, and `.agents`

**Project Type**: Internal documentation and shell-contract test suite

**Performance Goals**: No runtime performance change; static checks complete within the existing repository suite expectations

**Constraints**: Preserve source/adapters byte identity, macOS Bash 3.2 compatibility, existing Objective ownership and persistence contracts, and the exact canonical lifecycle terminology

**Scale/Scope**: One source skill, four generated adapters, one focused contract test, and the repository-wide test suite

## Constitution Check

*GATE: PASS. The change is confined to shippable skill guidance, generated copies, and verification artifacts. It does not add a runtime dependency, persistent schema, external integration, or new ownership boundary. Source-first generation and post-edit verification preserve the repository's generated-artifact and verification requirements. No constitution violation requires a complexity exception.*

[Gates determined based on constitution file]

## Project Structure

### Documentation (this feature)

```text
specs/162-objectives-lifecycle-canonicalization/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
.highway/skills/highway-objectives/SKILL.md                    # source guidance
.github/skills/highway-objectives/SKILL.md                     # generated adapter
.claude/skills/highway-objectives/SKILL.md                     # generated adapter
.cursor/skills/highway-objectives/SKILL.md                     # generated adapter
.agents/skills/highway-objectives/SKILL.md                     # generated adapter
.highway/tools/tests/feature-161-objectives-synthesis-lifecycle.test.sh  # focused contract
.highway/tools/tests/run-all.sh                                # full regression suite
```

**Structure Decision**: Preserve the existing source skill plus generated adapter structure. The implementation edits the source, regenerates adapters through the repository's existing instruction-generation path, updates the focused document contract, and validates the complete suite. No `contracts/` directory is needed because this repository exposes no external API or machine protocol for Objective guidance.

## Complexity Tracking

No constitution violations. No complexity exception is required.
