# Implementation Plan: Profile Direct Write

**Branch**: `188-profile-direct-write` | **Date**: 2026-10-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/188-profile-direct-write/spec.md`

## Summary

Profile always proposes Vision, Competitive Path, and Guiding Principles, including a thin tradeoff or principle the person can correct. The capture paragraph is removed. Accepted bullets are stored once, after Guiding Principles, at `library/knowledge/profile.md` from the repository root. An older profile under `.highway/library/knowledge/` is ignored. Skills that read the profile use the new path. Published copies are regenerated.

## Technical Context

**Language/Version**: Markdown skill sources and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-profile/SKILL.md`, `.highway/library/templates/output/profile-record.md`, `.highway/tools/lib/profile.sh`, `.highway/tools/generate-agent-adapters.sh`

**Storage**: The person's profile at `library/knowledge/profile.md` from the repository root. The skill framework tree is not a profile store.

**Testing**: Update path and profile-behavior checks under `.highway/tools/tests/`, then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target. One fewer confirmation per domain

**Constraints**: Do not add a second acceptance. Do not read or copy `.highway/library/knowledge/profile.md`. Do not ask the Vision, Competitive Path, or Guiding Principles fallback questions. Identity may still ask what the organization does. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: One skill's conversation, one output path, and the skills and helper that name the old path

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. The profile path in the Highway Skills Constitution rationale is live documentation. D6.1 requires that sentence to change in this same change. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`.
- Toolchain Gate: PASS. No new command. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the behavior change to amend a test. D3.5 requires any removed assertion to name the superseded capture or fallback. D3.2 requires the suite to pass after the last edit.
- Correspondence Gate: PASS. D4.7 requires adapter regeneration after the skill sources change. Generated adapters are not hand-edited.
- Skill Content Gate: PASS pending `validate-skill.sh` on each edited skill. D1.5 names P10.1: the profile skill keeps its Experience Standard reference and does not restate generic interaction rules. P11.1 and P11.2 require each skill that reads the profile to name the new path and its role in Inputs. D8.1 applies because `profile-record.md` is a shared template the profile skill cites.

The constitution version bump is MINOR. P11.1 and P11.2 are unchanged. The rationale path is corrected in the same change as the skills, so no skill is left conforming to the old location. The profile skill version bump is MAJOR because the confirmation sequence and the stored file path change.

No complexity exception is required.

### Post-design re-check

PASS. Phase 1 does not add a dependency, a second profile file, or a fallback question. The constitution edit is the path sentence and its Sync Impact Report.

## Project Structure

### Documentation (this feature)

```text
specs/188-profile-direct-write/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-profile/SKILL.md
.highway/skills/highway-setup/SKILL.md
.highway/skills/highway-objectives/SKILL.md
.highway/skills/highway-controls/SKILL.md
.highway/skills/highway-nfrs/SKILL.md
.highway/library/templates/output/profile-record.md
.highway/governance/constitution.md
.highway/tools/lib/profile.sh
library/knowledge/profile.md          # written at runtime, not authored here
```

**Structure Decision**: The skill sources stay under `.highway/skills/`. The retained profile is a user-owned file at the repository root. Adapters are regenerated from the edited sources.

## Complexity Tracking

> No constitution violation requires a justification table.
