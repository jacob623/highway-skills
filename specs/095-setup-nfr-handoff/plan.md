# Implementation Plan: Highway Setup NFR Handoff

**Branch**: `095-setup-nfr-handoff` | **Date**: 2026-09-27 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/095-setup-nfr-handoff/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Change only the `highway-setup` orchestration contract so it presents a Setup-owned transition
when it is about to begin the first NFR-owned interaction and replaces the terminal completion
dashboard with the specified forward-looking conclusion. Preserve Profile, Objectives, Controls,
NFR owner authority, readiness semantics, and New interaction resume behavior. The implementation
will update the canonical Setup skill, its generated adapters, focused contract tests, and generated
indexes/manifests as required by correspondence checks; it will not change NFR-owner UX.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts; Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing `highway-setup`, `highway-controls`, and `highway-nfrs` owner contracts; Highway Experience Standard; existing governance test harness and adapter generators

**Storage**: No new retained storage; Setup transition is non-persisted presentation state and existing owner artifacts remain authoritative

**Testing**: Focused Setup contract and executable routing tests, Setup/UX alignment checks, skill validation, adapter correspondence, Feature 092 correspondence, and full `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS Bash and supported GNU-like shell environments

**Project Type**: Repository-distributed agent skill suite with Markdown contracts and shell validation

**Performance Goals**: No additional runtime or network work; handoff and conclusion are bounded user-visible output decisions within the existing Setup interaction

**Constraints**: Modify only Setup behavior and directly required tests/generated representations; do not inspect NFR internals; do not persist transition state; preserve exact owner output and field ordering; remain compatible with Bash 3.2.57; regenerate derived artifacts after canonical changes

**Scale/Scope**: One Setup skill, three generated agent adapters, focused Setup contract coverage, and existing repository-wide governance validation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | Canonical Setup changes remain under `.highway/`; packaged-tree and path validation are required. |
| Toolchain Gate (D2.1-D2.4) | PASS | Tests remain Bash 3.2.57-compatible and use the repository's declared shell/tooling. |
| Generator Gate (D4.1-D4.4) | N/A | No generator script is changed; generated outputs will be regenerated after source changes. |
| Correspondence Gate (D4.5-D4.7) | PASS | Setup is a generator input; adapters and catalogs must match fresh generation. |
| Validation Gate (D3.4-D3.5) | PASS | Focused tests will cover initial, existing-Controls, resumed, blocked, and terminal no-interaction paths without weakening existing assertions. |

### Skill content gates

| Rule | Verdict | Evidence |
|---|---|---|
| P5.1-P5.5 | PASS | Setup retains explicit failure handling and preserves owner state on failed or non-terminal paths. |
| P6.1/P6.6 | PASS | Handoff and conclusion branches use explicit owner states and deterministic ordering. |
| P8.3/P8.4 | PASS | Verification will name focused checks for both Controls-to-NFR paths, resume behavior, conclusion gating, and ownership boundaries. |
| P10.1/P10.2 | PASS | The amended Setup skill will undergo the required Constitution and Experience Standard review. |

No gate is unresolved; no complexity exception is required.

### Post-design re-check

PASS. The design introduces no retained Setup state, no new dependency, no NFR-owner behavior,
and no new generator. The contract, data model, and quickstart preserve owner authority, explicit
failure handling, deterministic resume behavior, and generated-artifact correspondence.

## Project Structure

### Documentation (this feature)

```text
specs/095-setup-nfr-handoff/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/
├── skills/highway-setup/SKILL.md
├── tools/tests/highway-setup.test.sh
├── tools/tests/highway-setup-executable.test.sh
├── tools/tests/highway-ux-alignment.test.sh
├── tools/tests/feature-092-contract.test.sh
├── tools/generate-agent-adapters.sh
└── catalog/
.github/skills/highway-setup/SKILL.md
.claude/skills/highway-setup/SKILL.md
.cursor/rules/highway-setup.mdc
specs/095-setup-nfr-handoff/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/setup-handoff-contract.md
```

**Structure Decision**: Extend the existing canonical `highway-setup` Markdown contract and its
focused Bash tests under `.highway/`; regenerate the three distributed adapters and affected
catalog/manifests. Document the observable handoff and conclusion contract in this feature's
`contracts/` directory. No application source tree or new runtime component is introduced.

## Complexity Tracking

No constitution violations or complexity exceptions.
