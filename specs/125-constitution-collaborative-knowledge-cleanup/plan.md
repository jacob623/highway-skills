# Implementation Plan: Constitution Collaborative Knowledge Cleanup

**Branch**: `125-constitution-collaborative-knowledge-cleanup` | **Date**: 2026-10-02 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/125-constitution-collaborative-knowledge-cleanup/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Reposition and rename the collaborative knowledge section in the canonical Constitution from
`XII-A` to `XIII` without changing its P12A rule identifiers or protected semantics. Simplify only
the P12A.2 Observable, reorder the lower precedence rows so accepted Repository Context outranks
transient collaborative reasoning, and preserve Constitution version `6.1.0`, the owner-controlled
completion rules, lifecycle, governance wording, and definitions. Implementation is restricted to
`.highway/governance/constitution.md`.

## Technical Context

**Language/Version**: Markdown edited with POSIX/Bash-compatible repository tooling

**Primary Dependencies**: Canonical Constitution and existing repository validation scripts; no new dependencies

**Storage**: One existing Markdown governance file; no schema or new artifact type

**Testing**: Targeted text/order/diff validation and `.highway/tools/tests/run-all.sh`

**Target Platform**: Repository development on macOS/Linux

**Project Type**: Governance/documentation maintenance

**Performance Goals**: Deterministic validation with no runtime performance change

**Constraints**: Modify only `constitution.md`; preserve version `6.1.0`, P12A identifiers, P12.5-P12.15,
the persistence boundary, lifecycle, definitions, governance wording, and ranks 1-10

**Scale/Scope**: One Constitution section move, one Observable simplification, and three lower precedence-row updates

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Authority and ownership**: PASS. The change preserves accepted-context authority and existing owner-controlled mutation and orchestration rules.
- **Determinism**: PASS. The requested section order, exact Observable, exact precedence reasons, and version are mechanically reviewable.
- **Maintainability**: PASS. The cleanup removes a misleading sub-principle placement without renumbering stable P12A rule IDs.
- **Experience boundary**: PASS. Acceptance wording is removed from P12A.2 and remains owned by the Experience Standard.
- **Scope boundary**: PASS. Implementation changes only `.highway/governance/constitution.md`; specs and tests are validation inputs, not implementation targets.
- **Versioning**: PASS. Version `6.1.0` remains unchanged because the user explicitly identifies these as cleanup edits within the unreleased amendment.

## Project Structure

### Documentation (this feature)

```text
specs/125-constitution-collaborative-knowledge-cleanup/
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
└── governance/
  └── constitution.md
```

**Structure Decision**: This is a one-file governance cleanup. The Constitution remains the only
implementation target; the feature artifacts under `specs/125-constitution-collaborative-knowledge-cleanup/`
describe and validate the change but are not modified by implementation.

## Protected Boundaries

- Move the complete collaborative section as one unit after the acceptance-to-owner-result boundary.
- Rename the heading and current principle references to `XIII` while retaining P12A.1-P12A.4.
- Keep P12A.1, P12A.3, P12A.4, their Observables, all definitions, lifecycle text, and governance wording unchanged.
- Simplify only the P12A.2 Observable to the specified sentence.
- Keep P12.5-P12.15, the persistence boundary, version `6.1.0`, and precedence ranks 1-10 unchanged.
- Add no evolution-aware guidance or conversational technique.

## Implementation Phases

1. Capture the existing Constitution anchors and verify the requested target strings.
2. Move the collaborative section, rename it, simplify P12A.2, and update the two precedence reasons/ranks.
3. Validate exact protected content, section order, version, and one-file diff scope.
4. Run the repository validation suite without changing any test or generated artifact.

## Test Strategy

Use focused checks for heading order, exact P12A rule and Observable text, precedence rows, version,
protected owner rules, and changed-file scope. Then run `.highway/tools/tests/run-all.sh` to detect
regressions in Constitution parsing, coverage, routing, and generated-tree assumptions.

## Versioning Assessment

Keep version `6.1.0`. The user defines this work as cleanup within the still-unreleased amendment,
and the requested changes do not add, remove, or strengthen a governed obligation; they reposition
the section, clarify precedence, and remove wording owned by the Experience Standard.

## Complexity Tracking

No Constitution gate violations are identified; no complexity exception is required.
