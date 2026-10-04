# Implementation Plan: Simplify Profile Domain Meaning

**Branch**: `137-simplify-profile-domains` | **Date**: 2026-10-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/137-simplify-profile-domains/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Amend the highway-profile skill from baseline 5.3.0 so Identity, Vision, Competitive Path, and Guiding Principles keep simple meanings, existing organizational material can start acquisition, organizational expression stays transient, and accepted domains are saved before any dependent result. The amendment is a breaking change under the Skill Versioning Policy, so the skill version becomes 6.0.0. The retained Profile schema stays 3.0.0. Update the source skill, refresh generated adapters and catalog metadata, and retarget static contract tests whose assertions lock superseded wording.

## Technical Context

**Language/Version**: Markdown skill contract with POSIX-compatible Bash 3.2 test scripts

**Primary Dependencies**: Highway Experience Standard interaction behavior, Profile record template schema 3.0.0, Highway Skills Constitution Skill Versioning Policy, existing Profile contract tests and declared generators

**Storage**: Markdown Profile at `.highway/library/knowledge/profile.md`; no schema change

**Testing**: Focused Profile contract tests followed by `bash .highway/tools/tests/run-all.sh`

**Target Platform**: Highway distributed skill tree on macOS and POSIX-like shells

**Project Type**: Documentation-defined agent skill suite with generated agent adapters

**Performance Goals**: Deterministic static contract validation; no runtime performance target

**Constraints**: Do not modify the Profile record template, Experience Standard, Setup, Controls, NFRs, or Constitution. Do not add retained acquisition, expression, facet, dimension, safeguard, or reasoning fields. Do not add a post-write read-back. Do not introduce MUST or SHOULD keywords that would make the already long Profile sections normative under the 400-word section limit. Do not ask safeguard questions during Competitive Path. Volunteered downstream detail may inform the broad path but must not be developed or retained as a safeguard, NFR, architecture, or implementation requirement.

**Scale/Scope**: One source skill, its generated adapters and catalog metadata, and focused Profile contract assertions covering acquisition, expression, four domain boundaries, persistence, and protected paths.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates:

- **Packaging Gate** (shipped skill path): D1.1, D1.2, and D6.2 pass if the skill cites repository paths it already owns and does not cite `.specify/` or `specs/`.
- **Toolchain Gate** (test edits under `.highway/tools/`): D2.1 through D2.4 pass if new tests stay in the existing Bash 3.2 style and the declared toolchain.
- **Generator Gate**: N/A. No `generate-*.sh` script is modified.
- **Correspondence Gate** (source skill input changes): D4.5 through D4.7 pass only after declared generators are re-run and adapter copies match the source.
- **Validation Gate** (test edits): D3.4 is N/A for fixture-wide verdict changes because the new checks read the Profile skill text, not every existing fixture. D3.5 requires each superseded assertion to name the behavior it no longer locks.
- **D3.1, D3.2, D3.3, D3.6, D3.8, D5.3, D7.3**: Implementation must start from a passing suite, add or amend a test, observe the new check fail before the skill text satisfies it, and report requirement coverage separately from the suite result.

Skill Content Gate:

- **P7.1, P7.2, P7.7**: Keep one Purpose sentence. Publish semantic version 6.0.0 because the amendment removes, narrows, and redefines existing behavioral guarantees.
- **P7.3, P7.4, P7.5**: Cite the Experience Standard and Constitution by reference. Do not add MUST-level keywords. The current skill has no normative keyword lines; introducing them would subject the long Enrichment and Verification sections to the 400-word limit.
- **P8.2, P8.3, P8.4**: State acquisition and persistence order only where order changes behavior. Keep a non-empty Verification section with checkable outcomes.
- **P9.1, P9.2, P9.4**: Continue citing the shared Profile record template. Do not copy its skeleton or add retained fields.
- **P12.13, P12A.1 through P12A.4**: Persist an accepted mutation before any dependent result. Keep Working Ideas, expression guidance, and unaccepted acquisition evidence transient, and re-evaluate accepted knowledge before later Profile behavior.

No violations require complexity tracking.

## Project Structure

### Documentation (this feature)

```text
specs/137-simplify-profile-domains/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── profile-skill.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/
├── skills/highway-profile/SKILL.md
├── catalog/
├── tools/generate-agent-adapters.sh
├── tools/generate-catalog.sh
├── tools/generate-library-catalog.sh
├── tools/generate-instructions.sh
└── tools/tests/
.agents/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.github/skills/highway-profile/SKILL.md
.cursor/skills/highway-profile/SKILL.md
```

**Structure Decision**: The authoritative edit is `.highway/skills/highway-profile/SKILL.md`. Generated adapters and catalog metadata are refreshed from that source. Verification stays in `.highway/tools/tests`. No application source tree or new retained schema is introduced.

## Complexity Tracking

No constitution violations. No complexity exceptions are required.

## Post-Design Constitution Check

PASS. The design adds no retained fields, no external API, and no generator edits. It keeps the source skill as the single authoring surface and requires generated adapter and catalog refresh. Verification covers the simplified domain boundaries, acquisition and expression limits, the persistence boundary, and protected-path integrity. Superseded test assertions are updated with a recorded reason rather than weakened without explanation. Protected governance, setup, controls, NFR, and Profile record artifacts remain outside the implementation scope.
