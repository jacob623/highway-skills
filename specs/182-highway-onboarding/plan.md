# Implementation Plan: Highway Onboarding

**Branch**: `182-highway-onboarding` | **Date**: 2026-10-16 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/182-highway-onboarding/spec.md`

## Summary

Add a proposal-first `highway-onboarding` workflow that reuses accepted repository context, proposes business capabilities in business language, accepts many-to-many capability-to-platform mappings, and directly creates validated pre-existing ADR records from the shared ADR output templates. Preserve `highway-adr` as the separate Discovery-based ADR workflow. After successful ADR persistence, orchestrate Architecture and Implementation in order, retrying a failed downstream owner up to three times before offering manual resume from that boundary.

## Technical Context

**Language/Version**: Markdown skill contracts and POSIX-compatible Bash 3.2 test scripts

**Primary Dependencies**: Highway Experience Standard, Highway Skills Constitution, existing ADR/Architecture/Implementation owner contracts, shared output templates, and generator scripts; no new external dependency

**Storage**: Existing ADR, Architecture, and Implementation owner artifacts and catalogs; no onboarding-specific inventory or parallel artifact family

**Testing**: New `highway-onboarding` and ADR onboarding-mode contract tests, existing owner tests, generated-adapter correspondence, canonical validators, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Git-native Highway distribution on macOS Bash 3.2 and declared agent adapter trees

**Project Type**: Governance skill suite with generated agent adapters and Markdown interaction/output contracts

**Performance Goals**: No new latency target; proposal review must reuse available evidence, avoid duplicate questions, and bound downstream retries at three attempts

**Constraints**: Preserve existing ADR Discovery/option behavior; onboarding directly owns its ADR acceptance and persistence path using shared templates; keep onboarding findings provisional until validation; use one scalar `request: onboarding` value and one scalar `discovery: highway` value; support manual website/imported material only in v1; never create fake Request, Discovery, DISC, inventory, or alternate ADR artifacts; stop and resume at failed owner boundaries

**Scale/Scope**: One new canonical onboarding skill, four generated onboarding adapters, an ADR onboarding-mode amendment and its adapters/tests, catalog and manifest regeneration, and focused design/test artifacts; no live enterprise integrations

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The applicable process gates are:

- **D3.1/D3.2/D3.3/D3.5/D3.6**: establish a baseline, add focused contract tests, preserve existing assertions, observe seeded failures before implementation, and finish with the full suite.
- **D4.1/D4.4/D4.5/D4.6/D4.7**: modify canonical sources only, regenerate catalogs and all declared adapters, and verify source/generated correspondence.
- **D6.1/D6.2**: keep source skills, contracts, templates, and governance references current and resolvable.
- **D8.1**: revalidate every changed skill against shared library artifacts it cites.

The applicable Highway Skills Constitution gates are **P1.1-P1.4**, **P6.4**, **P7.3-P7.5**, **P8.3/P8.7**, **P9.1-P9.8**, **P11.1-P11.5**, and **P12.5/P12.13-P12.15**. All pass by design: onboarding owns its direct ADR mutation path and orchestration, `highway-adr` retains the separate Discovery-based path, generated output is derived from canonical sources, all decision criteria are bounded, and failure/resume behavior is explicit. No complexity exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/182-highway-onboarding/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-onboarding/SKILL.md
.highway/tools/tests/highway-onboarding.test.sh
.highway/tools/tests/highway-adr.test.sh
.highway/tools/tests/fixtures/highway-onboarding/
.github/skills/highway-onboarding/SKILL.md
.claude/skills/highway-onboarding/SKILL.md
.cursor/skills/highway-onboarding/SKILL.md
.agents/skills/highway-onboarding/SKILL.md
.github/skills/highway-adr/SKILL.md
.claude/skills/highway-adr/SKILL.md
.cursor/skills/highway-adr/SKILL.md
.agents/skills/highway-adr/SKILL.md
.highway/catalog/
.highway/tools/.adapter-manifest
```

**Structure Decision**: Add one canonical onboarding skill and its generated adapters. Keep the canonical ADR skill on its existing Discovery-based path, use the shared ADR output structures directly from onboarding, and regenerate all derived catalogs/adapters/manifests. No new runtime service, database, or landscape catalog is introduced.

**Post-design Constitution Check**: PASS. The design preserves owner boundaries, makes provenance and retry behavior explicit, keeps provisional onboarding content transient until owner acceptance, and defines focused static/behavioral contract tests plus generated correspondence checks. No gate requires a complexity exception.

## Complexity Tracking

> No violations. The feature uses the existing skill, owner, generator, and test architecture.
