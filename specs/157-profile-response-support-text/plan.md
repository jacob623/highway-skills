# Implementation Plan: Profile Response Support Text

**Branch**: `157-profile-response-support-text` | **Date**: 2026-10-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/157-profile-response-support-text/spec.md`

## Summary

Centralize Profile's Validation Question, Acceptance Reassurance, Discovery Reassurance, and Combined Reassurance in one Profile-owned section. Replace duplicated behavioral definitions with canonical labels while retaining literal examples, add static document-contract coverage, regenerate adapters, and leave the Experience Standard and Profile reasoning behavior unchanged.

## Technical Context

**Language/Version**: Markdown source and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: Existing Profile skill, static test helpers, and adapter generator

**Storage**: N/A; no persisted schema changes

**Testing**: `.highway/tools/tests/feature-157-profile-response-support-text.test.sh` and `.highway/tools/tests/run-all.sh`

**Target Platform**: Git-native Highway distribution on macOS and GNU-compatible environments

**Project Type**: Git-native agent-skill and governance documentation suite

**Performance Goals**: No runtime performance change; focused static validation remains deterministic.

**Constraints**: Preserve Profile domain behavior, Experience Standard ownership, literal examples, generated adapter correspondence, and Bash 3.2.57 compatibility for tests.

**Scale/Scope**: One source skill, four generated adapters, one focused static test, and the full existing verification suite.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Design Gate

- **D1.5**: PASS. The plan records the relevant Highway Skills Constitution review for the Profile skill change; no generic Experience Standard change is planned.
- **D3.1**: PASS. Baseline `.highway/tools/tests/run-all.sh` result: 80 passed, 0 failed.
- **D3.3**: PASS by plan. The behavioral/document contract change will add or amend a test under `.highway/tools/tests/`.
- **D3.8**: PASS by design. The focused check will identify itself as a static-document-contract check and will not be presented as runtime conversational evidence.
- **D4.7**: PASS by plan. Changing the Profile skill input will be followed by `generate-agent-adapters.sh` and adapter correspondence validation.
- **D6.1/D6.2**: PASS by plan. The feature specification and validation guide are updated in the same development change and all referenced repository paths will be checked.

No Packaging, Toolchain, Generator, Validation, or Correspondence gate is triggered by the design artifacts alone. The Correspondence Gate will be evaluated after the Profile source and generated adapters are changed.

### Post-Design Gate

- **D1.5**: PASS. The design keeps Profile-specific support text in the Profile skill and does not alter the generic Experience Standard.
- **D3.2**: PENDING implementation validation.
- **D3.3**: PASS once the focused Feature 157 test is added.
- **D3.8**: PASS once the test declares its static-document instrument class and separates runtime evidence.
- **D4.7**: PENDING adapter regeneration and correspondence validation.
- **D6.1/D6.2**: PASS subject to final path and documentation review.

## Project Structure

### Documentation (this feature)

```text
specs/157-profile-response-support-text/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
```text
.highway/
├── skills/highway-profile/SKILL.md
├── tools/generate-agent-adapters.sh
└── tools/tests/
  ├── feature-157-profile-response-support-text.test.sh
  └── run-all.sh
.github/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.cursor/skills/highway-profile/SKILL.md
.agents/skills/highway-profile/SKILL.md
specs/157-profile-response-support-text/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md
```

**Structure Decision**: Modify the authoritative Profile Markdown skill, add one focused Bash static-document test beside the existing Feature 152-156 checks, regenerate the four identity-copy adapters, and keep all feature design artifacts under the active Feature 157 directory. No `contracts/` directory is needed because the feature has no external interface.

## Complexity Tracking

No constitution violations require justification.
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
