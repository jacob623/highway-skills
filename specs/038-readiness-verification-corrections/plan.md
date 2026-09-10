# Implementation Plan: Readiness Verification Corrections

**Branch**: `038-readiness-verification-corrections` | **Date**: 2026-09-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/038-readiness-verification-corrections/spec.md`

## Summary

Resolve the Feature 037 readiness-model and evidence gaps without editing Feature 037. The implementation
will make the NFR state table authoritative, remove the unreachable NFR `Missing` route, align all planning
records with `.highway/skills/` as source of truth, and replace static-only readiness assertions with
disposable executable fixtures that capture owner responses, hashes, and repeat-run determinism.

## Technical Context

**Language/Version**: Markdown skill specifications; Bash 3.2-compatible test scripts

**Primary Dependencies**: Existing Highway skills, artifact templates, validators, shell utilities, and generators

**Storage**: Disposable fixture trees containing existing Profile YAML, Objective/Control/NFR records, catalogs, and candidate inputs; no new persistent artifact

**Testing**: Executable owner fixture tests, Setup routing tests, static contract tests, validators, full suite, and generated-artifact correspondence checks

**Target Platform**: macOS and Linux-compatible Bash environments

**Project Type**: Markdown-based skill library with shell validation and generated agent adapters

**Performance Goals**: Fixture evaluation remains local and completes without network access or persistent writes; no latency threshold is introduced

**Constraints**: Existing four-field response contract; deterministic owner state mapping; Bash 3.2 portability; canonical sources under `.highway/skills/`; generated outputs remain generator-owned

**Scale/Scope**: Four owner readiness models, one Setup route, five retained NFR outcomes, disposable fixture matrices, and the existing adapter/catalog/distribution outputs

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The change adds a new spec directory and plans changes under `.highway/tools/tests/` and `.highway/skills/`.

| Gate | Trigger | Verdict | Evidence / action |
|---|---|---|---|
| Packaging | Generated and distributed skill outputs remain in scope | PASS | Distribution generation and shipped-tree independence checks are required. |
| Toolchain | Test files under `.highway/tools/tests/` change | PASS | Use existing Bash 3.2-compatible utilities and run the full suite. |
| Generator | Generator scripts are not changed | N/A | Existing generators are invoked only for correspondence verification. |
| Correspondence | Canonical skill inputs change | PASS | Regenerate catalog and adapters; verify source/output correspondence. |
| Validation | Executable and static tests change | PASS | Separate owner behavior, Setup routing, static contract, and generated checks. |
| Spec Record | Feature 038 is a new sequential spec directory | PASS | Feature 037 remains untouched as historical record. |
| Skill Content | Canonical skill files may be modified during implementation | PASS | Apply the Highway Skills Constitution to changed skills and generated outputs. |

No constitution violation or complexity exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/038-readiness-verification-corrections/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
```text
.highway/skills/
├── highway-profile/SKILL.md
├── highway-objectives/SKILL.md
├── highway-controls/SKILL.md
├── highway-nfrs/SKILL.md
└── highway-setup/SKILL.md
.highway/tools/tests/
├── readiness-ownership.test.sh
├── readiness-owner-states.test.sh
├── readiness-contract.test.sh
└── highway-setup.test.sh
.github/skills/ .claude/skills/ .cursor/rules/
└── generated adapters, never hand-edited
specs/038-readiness-verification-corrections/
├── contracts/
├── data-model.md
├── quickstart.md
├── research.md
├── spec.md
└── tasks.md
```

**Structure Decision**: Modify canonical owner and Setup skill sources under `.highway/skills/`, extend
the existing Bash fixture harness under `.highway/tools/tests/`, and regenerate adapter/catalog outputs.
Feature 037 remains unchanged; Feature 038 owns the corrective design and evidence artifacts.

## Complexity Tracking

No violations.
