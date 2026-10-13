# Implementation Plan: Objective Portfolio Continuity

**Branch**: `164-objective-portfolio-continuity` | **Date**: 2026-10-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/164-objective-portfolio-continuity/spec.md`

## Summary

Add optional, concise, post-capture portfolio synthesis guidance to `highway-objectives` so queued, collection, and setup transitions acknowledge accepted Objective coverage before the next relevant activity. Preserve the Feature 163 ownership model, Feature 162 lifecycle, existing detailed portfolio assessment, user authority, persistence, and all protected Objective contracts. Validate with a focused static contract test, regenerated identity-copy adapters, adjacent Objective contracts, and the full repository suite.

## Technical Context

**Language/Version**: Markdown guidance and Bash 3.2-compatible contract tests

**Primary Dependencies**: Existing Highway skill generator and shell test harness

**Storage**: N/A; no persisted data or portfolio artifact changes

**Testing**: Focused Feature 164 static contract test, existing Objective contracts, full repository suite

**Target Platform**: Repository documentation consumed by generated agent adapters

**Project Type**: Internal guidance and adapter generator repository

**Performance Goals**: N/A; static documentation validation

**Constraints**: Preserve Feature 162 lifecycle, Feature 163 section ownership, source-first adapter distribution, Bash 3.2 compatibility, optional synthesis, post-capture timing, and all protected Objective behavior

**Scale/Scope**: One source skill, four generated adapters, one focused contract test, and existing regression suites

## Constitution Check

Process gates:

- **D1.1/D1.2**: PASS. Feature artifacts use the active pointer and required Spec Kit structure.
- **D2.1/D2.2**: PASS. The plan uses existing repository tools and introduces no dependency or storage change.
- **D3.1/D3.2/D3.3/D3.4/D3.5**: PASS. Focused, adjacent, and full executable checks will run after edits.
- **D4.1/D4.2/D4.3/D4.4/D4.5/D4.6/D4.7**: PASS. Source-first generation, deterministic adapters, and identity checks remain in force.
- **D5.3**: PASS. No constitution amendment or competing governance text is proposed.

Skill Content Gate: **PASS**, delegated to the Highway Skills Constitution. The source skill and
four generated adapters are modified, so implementation must preserve identity-copy integrity,
user authority, post-capture boundaries, deterministic generation, and protected Objective contracts.

## Project Structure

```text
.highway/
├── skills/highway-objectives/SKILL.md       # source guidance edited by Feature 164
└── tools/
    ├── generate-agent-adapters.sh            # source-to-adapter generator
    └── tests/
        ├── feature-164-objective-portfolio-continuity.test.sh
        ├── feature-159-objectives-advisory.test.sh
        ├── feature-161-objectives-synthesis-lifecycle.test.sh
        ├── objective-management.test.sh
        └── run-all.sh

.github/skills/highway-objectives/SKILL.md    # generated identity copy
.claude/skills/highway-objectives/SKILL.md    # generated identity copy
.cursor/skills/highway-objectives/SKILL.md    # generated identity copy
.agents/skills/highway-objectives/SKILL.md    # generated identity copy
```

**Structure Decision**: Keep the existing source skill, generator, adapter trees, and shell contract-test layout. Feature design artifacts remain under the active Feature 164 directory. No `contracts/` directory is needed because the repository exposes no external API or runtime interface for this documentation-only change.

## Implementation Approach

1. Add the focused Feature 164 contract test for post-capture synthesis ownership, timing, examples, advisory boundaries, protected contracts, and adapter identity.
2. Update the source skill's Objective Portfolio Assessment and relevant queued, collection, and setup transition guidance without replacing the detailed assessment or lifecycle mechanics.
3. Regenerate all Objective adapters from the source.
4. Run the focused test, adjacent Objective contracts, and full repository suite.

## Design Artifacts

- [research.md](research.md): decisions and resolved unknowns.
- [data-model.md](data-model.md): transient synthesis entities and protected invariants.
- [quickstart.md](quickstart.md): focused, adjacent, and full validation commands.

## Complexity Tracking

No constitution violations require justification.
