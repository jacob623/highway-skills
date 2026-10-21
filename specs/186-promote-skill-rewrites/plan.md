# Implementation Plan: Promote Rewritten Skills

**Branch**: `186-promote-skill-rewrites` | **Date**: 2026-10-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/186-promote-skill-rewrites/spec.md`

## Summary

Replace twelve Highway skills and their shared catalog templates with the reviewed drafts in the sibling folder `highway-skills-v2`. Retire checks that only lock the previous interaction, naming each superseded behavior. Keep both constitutions, the experience standard, skill authoring, and the adapter generators. Add invariant checks for identifier derivation, one Decision per Discovery, a conceptual Reference Architecture, and the allowed catalog statuses. Regenerate every published skill copy from the new sources.

## Technical Context

**Language/Version**: Markdown skill sources and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: Sibling draft suite `highway-skills-v2`; `.highway/skills/_authoring-standard.md`; `.highway/tools/validate-skill.sh`; declared generators `generate-catalog.sh`, `generate-library-catalog.sh`, `generate-agent-adapters.sh`, and `generate-instructions.sh`

**Storage**: Git-native Markdown skills under `.highway/skills/` and shared output templates under `.highway/library/templates/output/`

**Testing**: Existing shell harness `.highway/tools/tests/run-all.sh`, plus new invariant checks under `.highway/tools/tests/`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill suite

**Performance Goals**: No runtime latency target. Publishing is a repository regeneration, not a service

**Constraints**: Do not redesign the drafted interaction. Do not edit the Highway constitution, the Spec Kit constitution, or the experience standard. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`. A retired check must name the behavior it no longer enforces

**Scale/Scope**: Twelve skill replacements, one new `highway-request` skill, one reserved `highway-new` name, nine catalog or findings templates brought into agreement with the drafts, and the published copies in the four declared agent trees

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. Promoted skills are shipped artifacts. D1.1, D1.2, and D6.2 require that no shipped file references `.specify/` or `specs/`, and that documentation changed by the promotion is updated in the same change.
- Toolchain Gate: PASS. New checks stay inside the declared toolchain under D2.1 through D2.4.
- Validation Gate: PASS. D3.1 requires a passing `.highway/tools/tests/run-all.sh` before the first edit. D3.5 allows a check to be removed only when the removal names the superseded behavior. D3.6 requires the new invariant checks to be observed failing before the promoted behavior is treated as complete. D3.2 requires the suite to pass after the last edit. D3.8 keeps a static document check from standing in for executed behavior.
- Correspondence Gate: PASS. D4.5 through D4.7 require every source skill, including `highway-request`, to receive generated catalog and adapter artifacts, and require regeneration after the sources change. Generated files are not hand-edited.
- Skill Content Gate: PASS, enforced during implementation by `.highway/tools/validate-skill.sh`. D1.5 requires this plan to name the Highway Skills Constitution rules the edited skills must satisfy. Those rules are P1.1, P1.2, P1.3, P1.5, P5.6, P5.13, P7.1, P8.3, and P8.7, as applied by the authoring standard's required sections. A validator failure is repaired only to satisfy the reported rule. The repair does not redesign the interaction. D8.1 requires every skill that cites a changed output template to be re-checked against that template.

Highway Skills Constitution rules cited above are not restated here.

No complexity exception is required before research.

### Post-design re-check

PASS. Phase 1 does not add a runtime dependency, a shipped development path, a hand-edited adapter, or a constitution edit. The retirement register and the template updates stay inside the gates above.

## Project Structure

### Documentation (this feature)

```text
specs/186-promote-skill-rewrites/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
highway-skills-v2/                         # source drafts; not shipped
.highway/skills/highway-*/SKILL.md         # promoted sources
.highway/skills/highway-new/SKILL.md       # name reserved; does not collect a request
.highway/skills/highway-request/SKILL.md   # new source
.highway/library/templates/output/         # catalog and record templates brought into agreement
.highway/tools/tests/                      # obsolete interaction checks retired; invariant checks added
.github/skills/                            # generated
.claude/skills/                            # generated
.cursor/skills/                            # generated
.agents/skills/                            # generated
```

**Structure Decision**: This is a single git-native skill repository. Drafts stay outside the shipped tree. Sources live under `.highway/skills/` and `.highway/library/templates/output/`. The four declared agent trees receive generated copies only.

## Complexity Tracking

> No constitution violation requires a justification table. Retiring an obsolete check is permitted when the retirement names the superseded behavior.
