# Implementation Plan: Experience Profile Presentation Rhythm

**Branch**: `123-experience-profile-presentation-rhythm` | **Date**: 2026-10-01 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Amend the shipped Experience Standard from 7.1.0 to 7.2.0 with global rule X2.36, then update the canonical `highway-profile` skill to present Vision, Competitive Path, and Guiding Principles as plain-language subjects with grounded recommendations and validation. Keep the existing Profile record, schema 3.0.0, accepted-evidence boundary, readiness states, persistence ordering, canonical fallbacks, and completion behavior unchanged. Update focused contract tests and regenerate derived adapters from the canonical skill source.

## Technical Context

**Language/Version**: Markdown governance and skill documents; Bash 3.2.57-compatible contract tests

**Primary Dependencies**: Existing Highway Experience Standard, Highway Identity, Highway Skills Constitution, Profile skill, shell test suite, and adapter/catalog generators; no new dependency

**Storage**: Existing Markdown Profile record only; no schema, migration, or retained-field change

**Testing**: Focused Experience Standard/Profile contract tests, adapter correspondence checks, skill validation, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree and supported agent adapter trees on macOS/Linux shell environments

**Project Type**: Repository-distributed governance and interactive skill suite

**Performance Goals**: None; deterministic document validation and adapter generation

**Constraints**: X2.36 is globally owned by the Experience Standard and cited rather than duplicated in Profile. Protected rules and artifacts remain unchanged. Generated adapters are never hand-edited. Shipped documents must contain no development-only references. Existing user-facing Profile headings and retained-output headings remain distinct.

**Scale/Scope**: Two shipped source documents, existing Profile and Experience contract tests, derived Profile adapters/catalog outputs, and Feature 123 development artifacts

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | The changed governance and skill documents already ship; no `.specify/` or `specs/` reference will enter shipped paths, and all shipped citations remain resolvable. |
| Toolchain Gate (D2.1-D2.4) | PASS | Existing Bash contract tests and generators are reused; no new utility, interpreter, package, or non-portable shell construct is planned. |
| Generator Gate (D4.1-D4.4) | PASS | No generator script is changed. The Profile source is changed and all generated adapters/catalog outputs are refreshed through the declared generators. |
| Correspondence Gate (D4.5-D4.7) | PASS | `highway-profile` remains present in the catalog, adapter manifest, distribution manifest, and all declared agent trees; regeneration is part of implementation. |
| Validation Gate (D3.4-D3.5) | PASS | Existing fixture expectations are preserved; new assertions are added for X2.36 and subject rhythm, with superseded assertions explicitly identified rather than weakened. |
| D3.1 | PASS | Implementation begins only after `.highway/tools/tests/run-all.sh` exits 0. |
| D3.2 | PASS | The same full suite must exit 0 after all source, test, and generated-artifact changes. |
| D3.3 | PASS | Behavioral/document-contract changes include amendments to focused files under `.highway/tools/tests/`. |
| D3.6 | PASS | New X2.36, subject-heading, acknowledgment, and no-narration assertions are observed failing before implementation is marked complete. |
| D6.1 | PASS | The Experience Standard and Profile skill are updated together with their focused checks. |
| D8.1 | PASS | Shared Experience Standard changes trigger re-validation of all existing citing skills and the full suite. |

### Highway Skills Constitution

| Rule | Verdict | Evidence |
|---|---|---|
| P1.1-P1.4 | PASS | The skill remains a single authoritative Profile owner and continues to cite shared governance rather than creating a competing contract. |
| P7.1-P7.3 | PASS | The existing Profile version, purpose, semantic version, and Experience Standard ownership remain valid; generic narration behavior is cited from X2.36. |
| P8.1-P8.4 | PASS | The skill keeps its ordered acquisition, enrichment, operations, verification, and error-handling guidance; implementation tasks will preserve explicit failure and next-action behavior. |
| P9.1-P9.5 | PASS | User-visible output remains aligned with the Experience Standard, accepted evidence, user ownership, and focused checks. |

**Gate status**: PASS for planning. Recheck after research and design artifacts are complete.

## Project Structure

### Documentation (this feature)

```text
specs/123-experience-profile-presentation-rhythm/
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
├── governance/experience-standard.md
├── skills/highway-profile/SKILL.md
└── tools/tests/
  ├── experience-standard-amendment.test.sh
  ├── profile-behavior.test.sh
  ├── profile-structure.test.sh
  ├── profile-lifecycle.test.sh
  └── run-all.sh

.github/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.cursor/skills/highway-profile/SKILL.md
.agents/skills/highway-profile/SKILL.md

specs/123-experience-profile-presentation-rhythm/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

**Structure Decision**: Keep behavior in the two canonical shipped documents, focused verification in the existing shell test suite, and generated Profile adapters as derived outputs. Use development-only design artifacts for the presentation contract and validation matrix. No external API contract is needed; the exposed interface is the existing Profile skill interaction.

## Phase 0: Research

Resolve the existing Experience Standard amendment conventions, Profile ownership and transient-boundary contract, and adapter regeneration requirements. Record the decisions in `research.md`, including why no schema or runtime dependency change is required.

## Phase 1: Design and Contracts

Create `data-model.md` for the unchanged Profile evidence/readiness entities, `contracts/experience-profile-presentation.md` for the subject rhythm and narration boundary, and `quickstart.md` with focused and full-suite validation commands. Re-evaluate the constitution gates after these artifacts are complete.

## Complexity Tracking

No constitution violation or complexity exception is required. The feature reuses existing documents, tests, generators, and Profile storage boundaries.
