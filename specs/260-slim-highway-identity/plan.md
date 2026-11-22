# Implementation Plan: Slim Highway Identity

**Branch**: `260-slim-highway-identity` | **Date**: 2026-11-21 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/260-slim-highway-identity/spec.md`

## Summary

Replace `skills/highway-experience/references/highway-identity.md` with the locked slim
agent-facing wording. Keep the same path and experience activation/direct-invoke contracts.
Update `tests/constitution-profile-context.test.sh` (and any other checks) that assert old
headings. Bump experience skill metadata MINOR. Follow plugin finish order (bump + regenerate)
because `skills/` changes. Do not change Experience Standard or storage contract.

## Technical Context

**Language/Version**: Markdown skill content; Bash 3.2.57 suite tests.

**Primary Dependencies**: `skills/highway-experience/`, `tests/experience-activation.test.sh`,
`tests/constitution-profile-context.test.sh`, plugin generate/adapters.

**Storage**: N/A (reference text only).

**Testing**: Update constitution-profile-context tokens; experience-activation file list unchanged;
full suite with finish order for plugin gen.

**Target Platform**: Coding agents loading highway-experience.

**Project Type**: Skill reference content update.

**Performance Goals**: N/A (smaller prompt load).

**Constraints**: Locked substance from spec; keep `references/highway-identity.md` path; no
Experience Standard / storage-contract edits; plugin finish order after skills change.

**Scale/Scope**: 1 reference file, 1–2 tests, experience SKILL version bump, plugin regenerate.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Skill Content Gate | experience reference + possible SKILL version | PASS: identity remains non-normative framing; Experience Standard unchanged |
| Validation Gate | test expectation update | PASS: align tokens to new headings |
| Toolchain Gate | bash tests only | PASS |
| Packaging Gate | skills/ change | PASS: finish order bump + regenerate |
| Correspondence Gate | D4.7 / D4.8 | PASS: regenerate + version bump |

### Post-design re-check

Gates hold.

## Project Structure

### Documentation (this feature)

```text
specs/260-slim-highway-identity/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/identity-slim.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/highway-experience/
├── SKILL.md                              # metadata.version MINOR; example may align
└── references/highway-identity.md        # REPLACE with slim wording

tests/constitution-profile-context.test.sh  # new heading tokens

# After bump: highway-agent-plugin/ + adapters via generators
```

**Structure Decision**: Keep separate reference file at the existing path.

## Complexity Tracking

> None
