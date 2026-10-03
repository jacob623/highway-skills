# Implementation Plan: Profile Contribution Opportunity

**Branch**: `134-profile-contribution-opportunity` | **Date**: 2026-10-03 | **Spec**: [spec.md](spec.md)

## Summary

Make `highway-profile` the proving owner for the shared Contribution Opportunity established by X2.37. Profile will keep substantive development transient, offer a substantive opportunity before convergence when Profile materially shaped Vision, Competitive Path, or Guiding Principles, preserve mature/direct convergence and Identity accuracy behavior, and keep the existing Converged Proposal acceptance and persistence boundaries unchanged.

Implementation is a narrow skill-document synchronization plus focused contract coverage. The skill source will be updated, generated adapters and catalogs will be refreshed through the repository generators, and Profile-specific assertions will verify applicability, exemptions, response handling, domain coverage, one-question discipline, and protected boundaries.

## Technical Context

**Language/Version**: Markdown skill contracts and Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing Highway Experience Standard, Highway Skills Constitution, Profile record template, Profile helper/validator tools, and repository generator scripts

**Storage**: Existing Markdown Profile artifact only; no new retained state

**Testing**: Focused Profile contract tests, existing Profile lifecycle/behavior/UX contracts, generator checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and distributed Highway skill trees using the declared shell/toolchain

**Project Type**: Git-native governance and skill-document repository

**Performance Goals**: No new runtime performance requirement; validation remains deterministic and completes within the existing repository suite expectations

**Constraints**: Change only `highway-profile` and its required generated artifacts, its focused tests, and Feature 134 planning artifacts; do not modify Experience Standard, Constitution, Profile record template, Setup, Objectives, Controls, or NFRs

**Scale/Scope**: Four Profile domains, with primary proving coverage for Vision, Competitive Path, and Guiding Principles and an Identity exemption path

## Constitution Check

### Process gates

- **Packaging Gate**: PASS. The shipped Profile skill changes, so D1.1, D1.2, and D6.2 will be rechecked; no development-only path is added to shipped content.
- **Toolchain Gate**: PASS. The focused validation script will remain Bash 3.2-compatible and use only the declared toolchain.
- **Generator Gate**: N/A. No `generate-*.sh` script is modified.
- **Correspondence Gate**: PASS. Existing generators will be rerun after changing the Profile skill input, satisfying D4.5-D4.7 and preventing adapter/catalog drift.
- **Validation Gate**: PASS. A focused contract test will be added without weakening existing assertions; D3.4-D3.5 apply to the validation change.
- **Skill Content Gate**: PASS. The Profile skill will cite shared Experience Standard behavior rather than restating generic rule text, preserve owner boundaries, and retain its existing output contract under D1.5.

### Rule-specific design commitments

- D3.1/D3.2: record a passing baseline before implementation and require the full suite to pass after the final edit.
- D3.3/D3.6: add focused contract assertions and observe the new assertions fail before the Profile wording is complete.
- D6.1/D6.2: update the Profile source and generated dependents together; all references resolve.
- D8.1: revalidate every generated Profile adapter and every skill contract that cites the changed shared/profile library paths.
- D1.3/D1.4: cite X2.37 and the Experience Standard by name; do not copy generic rule sentences into the Profile contract.

**Gate status**: PASS. No unresolved clarification or justified violation remains.

## Project Structure

### Documentation (this feature)

```text
specs/134-profile-contribution-opportunity/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/requirements.md
└── tasks.md
```

### Source and validation paths

```text
.highway/skills/highway-profile/SKILL.md
.highway/tools/tests/feature-134-profile-contribution-opportunity.test.sh
.highway/tools/tests/feature-122-profile-experience-synchronization.test.sh
.highway/tools/tests/profile-behavior.test.sh
.highway/tools/tests/profile-lifecycle.test.sh
.highway/tools/tests/highway-ux-alignment.test.sh
.highway/tools/generate-agent-adapters.sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-library-catalog.sh
.highway/tools/generate-instructions.sh
.github/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.cursor/rules/highway-profile.mdc
.highway/catalog/
```

**Structure Decision**: This is a documentation-contract change in the existing single Highway skill tree. The source of truth remains `.highway/skills/highway-profile/SKILL.md`; generated adapter and catalog outputs are refreshed rather than hand-edited. No new runtime module, persisted field, API, or external contract is needed.

## Complexity Tracking

No constitution violations require justification.
