# Implementation Plan: Objectives Deduplication Pass
**Branch**: `163-objectives-deduplication-pass` | **Date**: 2026-10-12 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `specs/163-objectives-deduplication-pass/spec.md`
## Summary
Refactor the `highway-objectives` skill so each concept has one authoritative section. Preserve
the Feature 162 lifecycle and all protected Objective contracts, remove duplicated lifecycle and
acceptance instructions from neighboring sections, replace them with canonical cross-references,
regenerate identity-copy adapters, and add focused static ownership checks.
**Language/Version**: Markdown guidance and Bash 3.2-compatible contract tests
**Primary Dependencies**: Existing Highway skill generator and shell test harness
**Storage**: N/A; no persisted data changes
**Testing**: Focused static shell contract test, existing Objective contracts, full repository suite
**Target Platform**: Repository documentation consumed by generated agent adapters
**Project Type**: Internal guidance and adapter generator repository
**Performance Goals**: N/A; static documentation validation
**Constraints**: Preserve Feature 162 lifecycle, source-first adapter distribution, Bash 3.2 compatibility, and all protected Objective behavior
**Scale/Scope**: One source skill, four generated adapters, one focused contract test, and existing regression suites
## Constitution Check
Process gates:

- **D1.1/D1.2**: PASS. Planning artifacts use the repository's required structure and active feature pointer.
- **D2.1/D2.2**: PASS. The plan is based on the approved Feature 163 specification and preserves its scope.
- **D3.1/D3.2/D3.3/D3.4/D3.5**: PASS. The implementation will validate before and after edits using focused and full test suites.
- **D4.1/D4.2/D4.3/D4.4/D4.5/D4.6/D4.7**: PASS. Source-first generation, deterministic outputs, and adapter identity checks remain in force.
- **D5.3**: PASS. No constitution amendment is proposed.

Skill Content Gate: **PASS**, delegated to the Highway Skills Constitution. The source skill and
generated adapters are modified, so the implementation must preserve ownership, identity-copy,
determinism, user authority, non-capture, and protected Objective contracts.
## Project Structure
```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```
**Structure Decision**: Keep the existing source skill, generator, adapter trees, and shell
contract-test layout. Feature design artifacts live under the active Feature 163 directory.

## Implementation Approach

1. Edit the source skill's mixed sections so lifecycle mechanics remain only in the canonical
  lifecycle and other owners retain only their declared concerns.
2. Add the focused Feature 163 static contract test, including adapter identity and protected
  wording checks.
3. Regenerate all agent adapters from the source generator.
4. Run the focused test, adjacent Objective tests, and the full repository suite.

No contracts directory is generated because this repository exposes no external API or runtime
interface for the documentation-only change.

## Phase 0 and Phase 1 Artifacts

- [research.md](research.md): decisions and resolved unknowns.
- [data-model.md](data-model.md): documentation ownership entities and protected invariants.
