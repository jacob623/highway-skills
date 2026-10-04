# Implementation Plan: Profile Contribution-First Synchronization

**Branch**: `131-profile-contribution-precedence` | **Date**: 2026-10-02 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Update the existing `highway-profile` guidance so it consumes the shared
`Converged Proposal -> useful Working Idea -> focused unresolved question` precedence
without duplicating X2.13 or changing Profile persistence, readiness, schema, or domain
ownership. Directly affected Profile contract assertions may be synchronized with the
new wording; no other shipped skill or shared governance artifact changes.

## Technical Context

**Language/Version**: Markdown skill guidance; Bash 3.2-compatible repository checks

**Primary Dependencies**: Highway Experience Standard, Highway Identity, Profile record template

**Storage**: Existing Markdown Profile persistence; unchanged

**Testing**: Existing Profile contract matrix, UX alignment contract, schema validator, and full repository suite

**Target Platform**: Distributed Highway skill tree on macOS/Linux-compatible shell environments

**Project Type**: Multi-agent documentation and governance skill suite

**Performance Goals**: No new runtime or persistence path; existing validation suite remains deterministic

**Constraints**: Change Profile guidance and directly affected assertions only; preserve schema 3.0.0, four domains, readiness states, acceptance boundary, and shared-rule ownership

**Scale/Scope**: One Profile skill, its focused contract assertions, and four domain-specific precedence applications

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Verdict | Basis |
|---|---|---|
| Packaging / Layer Separation (D1.1-D1.6) | PASS | The shipped implementation remains confined to the existing Profile skill; no new artifact tree or dependency is introduced. |
| Security Gate (P4.5-P4.6) | PASS | Profile retains existing website/file-write behavior; this amendment changes guidance and verification wording only, while existing safe failure handling remains required. |
| Verification Gate (D3.1-D3.5) | PASS | Focused Profile contracts and the full repository suite will run before and after the change. |
| Correspondence Gate (D4.5-D4.7) | PASS | Profile source changes require regenerated distributed adapters; adapter coverage and currency checks pass. No catalog or generator-input redesign is introduced. |
| Documentation Currency (D6.1-D6.2) | PASS | The Profile skill and directly affected contract assertions stay aligned with the authoritative shared Experience Standard. |
| Shared-library dependent validation (D8.1) | N/A | No shared library artifact changes. |

No constitution violations or complexity exceptions are required.

## Project Structure

### Documentation (this feature)

```text
specs/131-profile-contribution-precedence/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/skills/highway-profile/SKILL.md                 # sole shipped implementation target
.github/skills/highway-profile/SKILL.md                  # generated adapter, regenerated
.claude/skills/highway-profile/SKILL.md                  # generated adapter, regenerated
.cursor/skills/highway-profile/SKILL.md                  # generated adapter, regenerated
.agents/skills/highway-profile/SKILL.md                  # generated adapter, regenerated
.highway/tools/tests/
├── feature-092-contract.test.sh                        # directly affected Profile contract
├── feature-122-profile-experience-synchronization.test.sh
└── profile-behavior.test.sh

.highway/library/templates/output/profile-record.md      # protected, unchanged
.highway/governance/experience-standard.md               # protected, unchanged
```

**Structure Decision**: This is a narrow existing-skill documentation amendment. The shipped
implementation is `.highway/skills/highway-profile/SKILL.md`; directly affected static contract
assertions may be updated to reflect the new shared precedence. The Profile record template,
Experience Standard, other skills, generated artifacts, and schemas remain unchanged.

## Complexity Tracking

No constitution violations. No complexity exception is required.
