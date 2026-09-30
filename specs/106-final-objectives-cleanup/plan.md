# Implementation Plan: Final Objectives Cleanup

**Branch**: `106-final-objectives-cleanup` | **Date**: 2026-09-29 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/106-final-objectives-cleanup/spec.md`

## Summary

Complete the existing `highway-objectives` 3.0.0 contract. Correct Profile-owned Blocked wording, remove remaining legacy discovery terminology, make Business Objective and Success the required review boundary, synthesize Rationale from accepted evidence, and preserve the exact Objective review. Recommendation-created Objectives use only the recommendation and its grounding evidence, with no redundant confirmation or separate Rationale question.

The skill remains version 3.0.0. `.highway/library/templates/output/objective-record.md` remains unchanged at version 1.0.0 because Statement, Success Measures, and Rationale remain the retained structure.

## Technical Context

**Language/Version**: Markdown skill text. Existing Bash 3.2 tests. No new dependency.

**Primary Dependencies**: Highway Experience Standard for shared interaction and recommendation acceptance; Skills Constitution for common failure and context rules; accepted Profile evidence for organizational grounding; existing Objective record and catalog templates.

**Storage**: Existing user-owned Objective records and catalog. Rationale remains persisted under `## Rationale`; Highway Relevance remains non-persisted.

**Testing**: Existing `.highway/tools/tests/run-all.sh`, focused Objective contract tests, `validate-skill.sh`, and generated adapter correspondence checks. Updated assertions must fail before the source edit that makes them pass.

**Target Platform**: Shipped Highway tree and supported agent adapters.

**Project Type**: Markdown skill contract correction with Bash test updates.

**Performance Goals**: None.

**Constraints**: Keep `highway-objectives` at 3.0.0. Keep `objective-record.md` unchanged. Do not edit the Experience Standard, Skills Constitution, development constitution, Profile skill, or Objective catalog template. Do not add `.specify/` or `specs/` references to shipped skill text. Preserve duplicate detection, overlap handling, identifier non-reuse, catalog determinism, and atomic mutation.

**Scale/Scope**: One source skill, focused Objective tests, generated Objective adapters, and catalogs whose Objective version entry changes only as a consequence of the existing 3.0.0 source.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | The Objective skill already ships. The source skill will continue to cite only shipped contracts and will not include development-only paths. |
| Toolchain Gate (D2.1–D2.4) | PASS | Existing Bash 3.2 tests are amended without new runtime dependencies. |
| Generator Gate (D4.1–D4.4) | N/A | No generator is modified. |
| Correspondence Gate (D4.5–D4.7) | PASS | The source Objective skill is regenerated into every declared adapter tree and the second generation is byte-stable. |
| Validation Gate (D3.4, D3.5) | N/A | No new validator is introduced. Existing assertions are replaced only where they encode superseded wording, with comments recording the change. |
| D3.1 | PASS | The existing suite passed before the preceding Objectives rewrite; the implementation must establish and record a green baseline before source edits. |
| D3.2 | PASS | The full suite must pass after all cleanup edits. |
| D3.3 | PASS | Focused Objective, UX, and Experience tests are amended for the corrected contract. |
| D3.6 | PASS | New and replaced assertions are observed failing against the current legacy wording before source edits. |
| D6.1 | PASS | Any live check quoting the corrected Objective behavior is updated with the skill. |
| D8.1 | N/A | No shared library artifact is changed. |

### Skill content gates

The Skill Content Gate applies because `.highway/skills/highway-objectives/SKILL.md` is modified.

| Rule | Verdict | Evidence |
|---|---|---|
| P7.3 | PASS | The skill cites the Experience Standard and shared Objective record rather than copying their generic contracts. |
| P7.4, P7.5, P7.6 | PASS | The cleanup removes legacy and duplicated prose; no new uppercase MUST obligations are needed beyond the existing concise contract. |
| P7.7 | PASS | Version remains 3.0.0 because this completes the already-planned contract rather than introducing a new contract revision. |
| P8.2 | PASS | The review-ready decision order is stated because Highway Relevance can change whether the next action is a question or review. |
| P9.1 | PASS | The skill names the unchanged Objective record template and does not repeat its generic skeleton. |
| P9.2, P9.3, P9.4, P9.7 | PASS | Outputs continue to declare readiness, mutation, and retained-record paths and shapes. |
| P10.1 | PASS | The skill continues to cite the Experience Standard and keeps recommendation selection as acceptance without restating its generic rules. |
| P11.1 | PASS | Inputs continue to identify Profile and Highway framing sources with their Objective-specific roles. |

**Post-design re-check**: PASS. Research resolves the only design question: Rationale is synthesized from accepted evidence in a deterministic precedence order, while Highway Relevance remains optional and non-persisted.

## Project Structure

### Documentation (this feature)

```text
specs/106-final-objectives-cleanup/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── objectives-skill.md
│   └── objectives-record.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-objectives/SKILL.md
.highway/tools/tests/objective-management.test.sh
.highway/tools/tests/highway-ux-alignment.test.sh
.highway/tools/tests/experience-x23-contract.test.sh
```

Generated Objective adapter copies and catalog metadata are regenerated, never hand-edited. The Objective record template and catalog template remain unchanged.

**Structure Decision**: The Objective skill owns evidence routing, review readiness, Rationale synthesis, recommendation capture, and verification wording. The retained template continues to own the stored record shape.

## Complexity Tracking

No constitution gate is violated. This is a corrective completion of the 3.0.0 contract and does not add a new persisted field, dependency, or version.
