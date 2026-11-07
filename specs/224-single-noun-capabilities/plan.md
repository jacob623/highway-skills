# Implementation Plan: Single Noun Capabilities

**Branch**: `224-single-noun-capabilities` | **Date**: 2026-11-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/224-single-noun-capabilities/spec.md`

## Summary

A capability title is one noun phrase of five words or fewer, with no joining word or symbol. The capability catalog template owns that Title rule. One new `capability title` step in `highway-implementation` applies it, splits a joined title, and shortens a long one. Onboarding and architecture follow that step. Configuration titles new realized capabilities under the same rule. The static capability becomes AI-Augmented Technology Development. Codify stops reading `establish` from a capability title.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `highway-implementation`, `highway-onboarding`, `highway-architecture`, `highway-codify-config`, `highway-codify`. Templates `capability-catalog.md` and `architecture-record.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`

**Storage**: `implementations/capabilities.md`, Realized Capabilities on the implementation record, and Required Capabilities on the architecture record

**Testing**: New `.highway/tools/tests/single-noun-capabilities.test.sh`, observed failing first. Moved pins in [research.md](research.md) R6. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: The new `capability title` step stays at or under 250 words. `rank` stays at or under 250. No section exceeds 400. The skill body does not gain MUST or SHOULD. No shipped path references `.specify/` or `specs/`. No migration of older records

**Scale/Scope**: Five skills, two templates, one new test, one amended static test, the pins in R6

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog, the adapters, and the library catalog are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with the recorded moves in R6 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: `capability-catalog.md` is cited by `highway-implementation`, and after this change by `highway-onboarding` through that skill, `highway-architecture`, and `highway-codify-config`. `architecture-record.md` is cited by `highway-architecture` and `highway-onboarding`. `validate-skill.sh` runs on all five skills.

Skill content gates, from `.highway/governance/constitution.md`:

- P7.3: the Title rule is stated once, in the shared capability catalog template. Skills cite it. The split and shorten behavior is stated once, in `capability title`, and the other skills follow that step.
- P9.1: no skill repeats the capability catalog structure.
- PASS pending `validate-skill.sh`. Each new behavior is an ordered step.

Version bumps:

- `highway-implementation` 7.3.0 to 7.4.0. MINOR. Adds `capability title`.
- `highway-onboarding` 10.2.0 to 10.3.0. MINOR. One capability per activity and the renamed static capability.
- `highway-architecture` 5.0.0 to 5.1.0. MINOR. Required capabilities follow the Title rule.
- `highway-codify-config` 3.3.0 to 3.4.0. MINOR. New realized capabilities follow the Title rule.
- `highway-codify` 12.1.0 to 12.2.0. MINOR. Suggestions no longer read `establish` from a capability title.
- `capability-catalog.md` 2.0.0 to 2.1.0. MINOR. Adds the Title rule.
- `architecture-record.md` 2.1.0 to 2.2.0. MINOR. Capability is a title.

No complexity exception is required.

### Post-design re-check

PASS. [contracts/title-rule.md](contracts/title-rule.md), [contracts/onboarding.md](contracts/onboarding.md), and [contracts/codify-rank.md](contracts/codify-rank.md) name the lines the tests pin. R6 names every moved pin. No step in the design exceeds its word limit.

## Project Structure

### Documentation (this feature)

```text
specs/224-single-noun-capabilities/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── title-rule.md
│   ├── onboarding.md
│   └── codify-rank.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/library/templates/output/capability-catalog.md
.highway/library/templates/output/architecture-record.md
.highway/skills/highway-implementation/SKILL.md
.highway/skills/highway-onboarding/SKILL.md
.highway/skills/highway-architecture/SKILL.md
.highway/skills/highway-codify-config/SKILL.md
.highway/skills/highway-codify/SKILL.md
.highway/tools/tests/single-noun-capabilities.test.sh
.highway/tools/tests/static-highway-capability.test.sh
```

**Structure Decision**: The capability catalog template owns the Title rule. `highway-implementation` owns the step that applies it. Generated catalogs and adapters are refreshed after the version bumps.

## Complexity Tracking

No constitution violation requires a justification.
