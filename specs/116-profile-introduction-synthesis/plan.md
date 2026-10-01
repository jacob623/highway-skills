# Implementation Plan: Profile Introduction and Synthesis

**Branch**: `116-profile-introduction-synthesis` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/116-profile-introduction-synthesis/spec.md`

**Note**: This plan covers the Profile contract, its focused verification, generated copies, and repository validation. It does not change the retained Profile schema or shared interaction standards.

## Summary

Update the Profile skill from 5.0.0 to 5.1.0 with a one-time first-time setup introduction and cohesive paragraph recommendations for Vision, Competitive Path, and Guiding Principles. Preserve Identity discovery, recommendation-first sequencing, save-before-result persistence, completion synthesis, four readiness domains, and retained schema 3.0.0. Implement the contract in the authoritative Markdown skill, amend focused Bash verification, synchronize distributed copies and catalogs, and validate the complete repository suite.

## Technical Context

**Language/Version**: Markdown skill contracts and Bash 3.2-compatible verification scripts

**Primary Dependencies**: Existing Highway Experience Standard 5.0.0, Highway Constitution 6.0.0, repository test helpers, and existing generation scripts; no new dependency

**Storage**: Markdown retained Profile at `.highway/library/knowledge/profile.md`; template schema 3.0.0 remains unchanged

**Testing**: Focused Profile Bash contract tests, generated-copy and catalog checks, `.highway/tools/tests/run-all.sh`, and `git diff --check`

**Target Platform**: Distributed Highway skill trees consumed by supported agents; checks must run on macOS Bash 3.2 and the declared toolchain

**Project Type**: Internal governance skill/documentation repository with Bash validation tooling

**Performance Goals**: Deterministic, repository-local validation; no runtime latency target

**Constraints**: Preserve four readiness domains and domain states, schema 3.0.0, canonical questions, persistence ordering, and completion synthesis; do not restate generic Experience Standard rules; add no runtime dependencies; keep generated copies synchronized; preserve Bash 3.2 compatibility

**Scale/Scope**: One authoritative Profile skill, four distributed copies, generated catalog entries, existing Profile validators/tests, and no changes to unrelated governance skills or stale follow-up documents

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The plan modifies a shipped skill and its focused verification, so the following gates apply:

- **D1.3/D1.4**: Cite the Highway Skills Constitution and Experience Standard by reference; do not copy their rule sentences into Profile or this plan.
- **D1.5**: Record the applicable constitution rule IDs for the skill and library change.
- **D2.1-D2.4**: Keep verification scripts Bash 3.2-compatible, use the declared toolchain, preserve portable utility flags, and add no runtime dependency.
- **D3.1-D3.5**: Start from a passing suite, amend focused tests for the behavioral change, evaluate existing fixtures before enabling new assertions, do not weaken unrelated assertions, and finish with the full suite passing.
- **D4.5-D4.7**: Synchronize every generated Profile copy and catalog artifact after changing the skill input.
- **D6.1-D6.2**: Update live documentation invalidated by the changed contract and keep references resolvable.
- **D8.1**: Re-validate every skill that cites a changed shared library artifact; this feature does not change the shared library artifact.

**Gate status before Phase 0**: PASS. No violation or complexity exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/116-profile-introduction-synthesis/
├── plan.md              # This file
├── research.md          # Phase 0 decisions
├── data-model.md        # Phase 1 retained Profile and recommendation model
├── quickstart.md        # Phase 1 validation guide
└── tasks.md             # Phase 2 output; created by /speckit-tasks
```

### Source Code (repository root)

```text
.highway/
├── skills/highway-profile/SKILL.md
├── catalog/index.md
├── catalog/index.json
└── tools/
  ├── generate-agent-adapters.sh
  ├── generate-catalog.sh
  └── tests/
    ├── profile-behavior.test.sh
    ├── profile-structure.test.sh
    ├── profile-context-contract.test.sh
    ├── profile-template-migration.test.sh
    ├── feature-092-contract.test.sh
    └── run-all.sh

.github/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.cursor/skills/highway-profile/SKILL.md
.agents/skills/highway-profile/SKILL.md
```

**Structure Decision**: This is a distributed documentation-and-verification change. The authoritative Profile skill is maintained under `.highway/skills`; the four agent-tree copies and catalog entries are generated outputs. Existing Bash validators and tests own contract verification. No external API or runtime service is exposed, so no `contracts/` directory is needed.

## Complexity Tracking

No constitution violations or additional architectural complexity identified.
