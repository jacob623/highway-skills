# Implementation Plan: Visible Profile Structure

**Branch**: `138-visible-profile-structure` | **Date**: 2026-10-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/138-visible-profile-structure/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Make the retained Organizational Profile structure visible in the shared Profile record template, and shorten highway-profile by removing duplicated structure and generic collaboration text without removing Profile capabilities. The template keeps retained schema `3.0.0` and gains template metadata `3.1.0`. Section headings are `## File Frontmatter` and `## Body`, matching the other record templates. The skill baseline is `6.0.0`; the Competitive Path projection rule narrows an existing guarantee and Verification is replaced, so the skill version becomes `7.0.0`. The retained artifact stays `.highway/library/knowledge/profile.md`.

## Technical Context

**Language/Version**: Markdown skill and library contracts with POSIX-compatible Bash 3.2 test scripts

**Primary Dependencies**: Highway Experience Standard, Highway Skills Constitution Skill Versioning Policy, existing Profile contract tests, declared generators

**Storage**: Retained Markdown Profile at `.highway/library/knowledge/profile.md`; shared template at `.highway/library/templates/output/profile-record.md`. No retained schema change.

**Testing**: Focused Profile and template contract tests, then `bash .highway/tools/tests/run-all.sh`

**Target Platform**: Highway distributed skill tree on macOS and POSIX-like shells

**Project Type**: Documentation-defined agent skill suite with a shared output template and generated adapters

**Performance Goals**: Deterministic static contract validation; no runtime performance target

**Constraints**: Do not modify the Experience Standard, constitution, setup skill, objectives, controls, or NFRs. Do not change retained `schema_version` from `3.0.0`. Do not relocate the retained Profile. Do not add retained fields, provenance sections, or workflow instructions to the template. Do not add MUST or SHOULD keywords to highway-profile. Do not restore post-write persistence verification. Tests that copy the template as a valid Profile must stop doing so once the template becomes a skeleton document.

**Scale/Scope**: One output template, one source skill, generated adapters and catalog metadata for that skill, the library catalog entry for the template, and Profile contract tests whose assertions lock superseded template or skill wording.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates:

- **Packaging Gate** (shipped skill and library paths): D1.1, D1.2, and D6.2 pass if the skill and template cite repository paths they own and do not cite `.specify/` or `specs/`.
- **Toolchain Gate** (test edits under `.highway/tools/`): D2.1 through D2.4 pass if amended tests stay in the existing Bash 3.2 style and the declared toolchain.
- **Generator Gate**: N/A. No `generate-*.sh` script is modified.
- **Correspondence Gate** (source skill input changes): D4.5 through D4.7 pass only after the declared generators are re-run and adapter copies match the source.
- **Validation Gate** (test edits): D3.4 is N/A for fixture-wide verdict changes because the new checks read the template and skill text, not every existing fixture. D3.5 requires each superseded assertion to name the behavior it no longer locks. The assertion that `profile-record.md` itself is a valid retained Profile is superseded because the template becomes a skeleton, not a retained artifact. Retained-profile validity remains covered by fixtures.
- **D3.1, D3.2, D3.3, D3.6, D3.8, D5.3, D7.3**: Implementation must start from a passing suite, add or amend a test, observe the new check fail before the source text satisfies it, and report requirement coverage separately from the suite result.
- **D8.1**: After the template changes, re-validate highway-profile, the only skill that cites `profile-record.md`. Its emitted retained frontmatter and body must still match the template's retained skeleton.

Skill Content Gate:

- **P7.1, P7.2, P7.7**: Keep one Purpose sentence. Publish skill version `7.0.0` because the projection rule narrows an existing guarantee and Verification is replaced.
- **P7.3, P7.4, P7.5, P7.6**: Cite the Experience Standard and template by reference. Do not add MUST-level keywords. Deduplication must reduce, not expand, long sections.
- **P8.2, P8.3, P8.4**: Keep Profile-specific acquisition, persistence, and readiness order. Keep a non-empty Verification section with checkable outcomes.
- **P9.1, P9.2, P9.4, P9.7**: Cite the shared template and the retained path. Do not copy the retained heading skeleton into the skill.
- **P12.13, P12A.1 through P12A.4**: Persist an accepted mutation before any dependent result. Keep Working Ideas, expression guidance, and unaccepted acquisition evidence transient.

No violations require complexity tracking.

## Project Structure

### Documentation (this feature)

```text
specs/138-visible-profile-structure/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── profile-record.md
│   └── profile-skill.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/
├── library/templates/output/profile-record.md
├── library/knowledge/profile.md
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

**Structure Decision**: The template edit is `.highway/library/templates/output/profile-record.md`. The skill edit is `.highway/skills/highway-profile/SKILL.md`. Generated adapters and catalogs are refreshed from those sources. Verification stays in `.highway/tools/tests`. No validator rewrite and no retained-schema migration are introduced.

## Complexity Tracking

No constitution violations. No complexity exceptions are required.

## Post-Design Constitution Check

PASS. The design separates template guidance from the retained skeleton, keeps schema `3.0.0`, and keeps the retained path. It does not add fields, provenance sections, or workflow instructions. The skill cites the template and Experience Standard instead of restating them, and the projection and persistence replacements are specified as exact sentences. Tests that treated the template file as a valid Profile are redirected to a retained fixture, with the superseded assertion recorded. Protected governance and neighboring skills stay outside the implementation scope.
