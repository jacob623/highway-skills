# Implementation Plan: Contribution Opportunity Before Convergence

**Branch**: `133-contribution-opportunity` | **Date**: 2026-10-02 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/133-contribution-opportunity/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Add a shared, transient Contribution Opportunity to the Experience Standard for cases where Highway
materially shaped a Working Idea before convergence. The guidance must distinguish substantive
participation from final artifact acceptance, preserve direct and mature-contribution exemptions,
maintain one-question discipline, and leave all owner-specific workflows and retained artifacts unchanged.
The implementation source is the shared Experience Standard; its focused static contract must be kept
aligned with the new rule inventory and protected-boundary assertions.

## Technical Context

**Language/Version**: Markdown governance document; Bash 3.2-compatible validation scripts

**Primary Dependencies**: `.highway/governance/experience-standard.md`, existing X2 rules, Constitution, and Experience Standard contracts

**Storage**: None; Contribution Opportunity remains transient Working Idea guidance

**Testing**: `.highway/tools/tests/experience-standard-amendment.test.sh`, UX alignment contract, rule checks, and full repository suite

**Target Platform**: Distributed Highway governance and skill consumers on macOS/Linux-compatible shells

**Project Type**: Shared governance and interaction-standard documentation

**Performance Goals**: No runtime behavior or performance path; deterministic document contracts remain green

**Constraints**: Add the next unused X2 rule without renumbering; preserve X2.2, X2.13, X2.18, X2.21, X2.22, X2.25, X2.36, acceptance semantics, adaptive depth, and all owner boundaries; do not add persisted state

**Scale/Scope**: One shared standard, one new X2 rule, supporting non-normative guidance/examples, one focused contract adjustment, and no owner implementation changes

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Verdict | Basis |
|---|---|---|
| Layer Separation and Shippability (D1.1-D1.6) | PASS | The amendment is confined to the shared governance document; no spec or owner artifact is shipped as implementation. |
| Environment and Dependency Discipline (D2.1-D2.4) | PASS | No dependency or runtime script is added; existing Bash 3.2-compatible checks are used. |
| Verification Before and After (D3.1-D3.5) | PASS | Existing Experience Standard contracts and the full suite will run before and after the amendment. |
| Generated Artifact Integrity (D4.1-D4.7) | N/A | `experience-standard.md` has no distributed adapter generation path. |
| Documentation Currency (D6.1-D6.2) | PASS | The standard, version record, rule inventory, and focused contract will remain synchronized. |
| Shared-library dependent validation (D8.1) | N/A | No shared output library or template changes. |

No constitution violations or complexity exceptions are expected.

## Project Structure

### Documentation (this feature)

```text
specs/133-contribution-opportunity/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/governance/experience-standard.md       # shared implementation source
.highway/tools/tests/experience-standard-amendment.test.sh
.highway/tools/tests/highway-ux-alignment.test.sh
.highway/tools/tests/rule-checks.test.sh
.highway/library/templates/output/profile-record.md # protected dependency
.highway/skills/highway-profile/SKILL.md            # protected owner skill
```

**Structure Decision**: This is a shared governance-document amendment. The standard is the only
shipped implementation surface. Existing static contracts may need their rule-count or exact-anchor
expectations updated to reflect the new X2 rule; no owner skill, template, or retained artifact changes.

## Complexity Tracking

No constitution violations. No complexity exception is required.
