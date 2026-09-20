# Implementation Plan: Request Solution Constraints

**Branch**: `053-request-solution-constraints` | **Date**: 2026-09-20 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/053-request-solution-constraints/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Extend the existing `highway-new` Request intake and shared Request record contract with a
Solution Constraints evidence domain. Use an extensible `allowed_solution_classes` list, separate
required and preferred platforms, preserve procurement and known-system context, and distinguish
empty arrays from `unknown`. Keep Discovery and ADR behavior unchanged. Research confirms that the
existing source skill, shared templates, Bash-focused tests, validators, generators, and adapters
are the correct implementation surfaces.

## Technical Context

**Language/Version**: Markdown skill instructions; repository tooling must remain Bash 3.2.57-compatible.

**Primary Dependencies**: Existing `.highway/tools/validate-skill.sh`, `validate-library.sh`, focused Request test, catalog generator, adapter generator, and correspondence tests; no new runtime dependency.

**Storage**: Plain Markdown source/template files and user-owned `requests/` records; no new storage.

**Testing**: Existing `highway-new.test.sh`, skill/library validators, adapter coverage, distribution checks, and `run-all.sh`, extended with Solution Constraints cases.

**Target Platform**: macOS and Linux repository environments; generated adapters target GitHub Copilot, Claude Code, and Cursor.

**Project Type**: Internal agent skill and repository governance tooling.

**Performance Goals**: One natural-language question per intake turn; no independent service latency or throughput target.

**Constraints**: Preserve deterministic Request behavior, privacy exclusion, transactional no-partial-write behavior, shared-template authority, generated correspondence, and Request-only ownership boundaries.

**Scale/Scope**: One Request conversation at a time against one catalog; seven evidence domains; eight Solution Constraints fields; no external service scale requirement.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Rule | Requirement | How this feature satisfies it |
|---|---|---|
| P1.1-P1.5 | Normative skill rules are atomic, bounded, dependency-declared, and non-vague | The implementation will state the ordered domain, eight named fields, value states, ownership boundaries, and bounded validation behavior explicitly. |
| P2.1-P2.5 | Skill remains technology-agnostic and labels technical examples | The Request captures business constraints and context without selecting technologies, architectures, or implementation patterns. |
| P3.1-P3.5 | MUST rules cite approved authority sources | The authoritative source skill will cite the shared Request templates and repository validators according to existing conventions. |
| P4.1-P4.6 | Quality and privacy claims have checks; no verification bypass | Focused tests will cover field states, privacy, completeness, transaction preservation, and boundary exclusions. |
| P5.1-P5.6 | Workflow steps have failure actions and bounded retries | Existing Request failure handling and catalog retry behavior remain unchanged; malformed constraint values receive bounded replacement handling. |
| P6.1-P6.5 | Decisions are ordered, exhaustive, and deterministic | Field order, question order, empty-versus-unknown semantics, and neutral absence behavior are explicit. |
| P7.1-P7.6 | Required sections, rule limits, and skill versioning | Existing skill structure and versioning remain the baseline; changes are limited to the Request skill and its dependent output contract. |
| P8.1-P8.7 | Ordered workflow, verification, configuration, and link rules | The plan names real source, template, test, generator, and adapter paths and keeps verification executable. |
| P9.1 | File-emitting skill cites complete shared templates | The source skill continues to cite the shared Request record and catalog templates rather than duplicating their complete structure. |
| D1.1-D1.2 | Shipped artifacts remain independent of development artifacts | Source skill and templates will not reference `specs/` or `.specify/`. |
| D1.5 | Skill/library changes require a development Constitution Check | This plan records the check and implementation validation gates. |
| D2.1-D2.4 | Existing toolchain and platform discipline | No package, runtime, or shell feature outside the declared Bash 3.2-compatible toolchain is introduced. |
| D3.1-D3.3 | Baseline, final suite, and behavioral tests | The focused Request test and full suite will be run, with existing baseline failures reported separately. |
| D4.4-D4.7 | Regenerate and verify generated artifacts | Catalog and adapter generators plus correspondence checks will run after source changes. |
| D6.1-D6.2 | Keep live documentation and references current | The shared contracts and quickstart will describe the updated Request contract and validation paths. |
| D7.3 | Separate requirement coverage from check results | Completion reporting will distinguish design coverage from executable validation outcomes. |

Result: PASS. No unjustified violations.

## Project Structure

### Documentation (this feature)

```text
specs/053-request-solution-constraints/
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
├── skills/highway-new/SKILL.md                         # authoritative source skill
├── library/templates/output/request-record.md          # shared Request record contract
├── tools/tests/highway-new.test.sh                     # focused Request behavior test
├── tools/validate-skill.sh                             # source skill validation
├── tools/validate-library.sh                           # shared template validation
├── tools/generate-catalog.sh                           # catalog regeneration
└── tools/generate-agent-adapters.sh                    # adapter regeneration

.github/skills/highway-new/SKILL.md                     # generated adapter
.claude/skills/highway-new/SKILL.md                     # generated adapter
.cursor/rules/highway-new.mdc                           # generated adapter
specs/053-request-solution-constraints/                  # design artifacts
```

**Structure Decision**: Extend the existing authoritative `highway-new` source skill, shared
Request output template, focused test, and generated adapters. Feature 053 adds no runtime
service, new package, or separate persistence layer. User-owned Request output remains outside
the framework tree.

## Phase 0: Research Summary

Research is complete in [research.md](research.md). Decisions resolved:

- Extend the existing Request intake and shared record contract.
- Use an extensible allowed-solution-class list rather than fixed booleans.
- Preserve required, preferred, absent, and unknown evidence states separately.
- Keep procurement constraints and known systems as Request-owned context.
- Reuse the existing validation, generation, adapter, privacy, and transaction toolchain.

## Phase 1: Design Summary

Design artifacts:

- [data-model.md](data-model.md) defines the seven-domain Request record and eight Solution Constraints fields.
- [contracts/request-solution-constraints-intake-contract.md](contracts/request-solution-constraints-intake-contract.md) defines the conversational intake behavior.
- [contracts/request-solution-constraints-record-contract.md](contracts/request-solution-constraints-record-contract.md) defines the ordered output and validation contract.
- [quickstart.md](quickstart.md) defines runnable validation scenarios and boundary checks.

No separate external API contract is required; the two Markdown contracts document the user-facing
skill conversation and durable Request artifact because both are repository-owned interfaces.

## Post-Design Constitution Re-check

| Gate | Result | Evidence planned |
|---|---|---|
| P9.1 shared output contract | PASS | The source skill continues to cite the complete shared Request templates; library and skill validators run. |
| P6 deterministic decisions | PASS | Field order, question behavior, value states, neutrality, and completeness are explicit and focused cases are planned. |
| P5 failure handling | PASS | Existing privacy, allocation retry, validation, transaction, and no-write behavior is preserved and retested. |
| D3 behavioral evidence | PASS | `highway-new.test.sh` will exercise populated, empty, unknown, preference, procurement, and known-system cases. |
| D4 generated correspondence | PASS | Catalog and adapter generation plus correspondence tests run after the source change. |
| D1 shippability | PASS | Shipped-tree checks confirm no development-path dependency is introduced. |

**Post-design result**: PASS. No new constitution amendment is required.

## Complexity Tracking

No constitution violations require justification; no additional complexity is introduced.
