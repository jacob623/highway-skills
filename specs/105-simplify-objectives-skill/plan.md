# Implementation Plan: Simplify the Objectives Skill

**Branch**: `105-simplify-objectives-skill` | **Date**: 2026-09-29 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/105-simplify-objectives-skill/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Rewrite `.highway/skills/highway-objectives/SKILL.md` around Objective behavior. Discovery uses Business Objective, Success, and Highway Relevance. The retained record stays Statement, Success Measures, and Rationale. Grounded recommendations come from accepted Profile evidence before a broad question, and a displayed selection is captured without a second confirmation. During setup and configure, a selection of several Objectives is captured together and the continuation question is asked once. The Experience section becomes exactly `User-visible interaction follows the Highway Experience Standard.` Persistence is successful atomic persistence, without a post-write byte check. The skill version moves from 2.0.0 to 3.0.0.

`.highway/library/templates/output/objective-record.md` stays at 1.0.0. `.highway/skills/highway-setup/SKILL.md` is edited only to drop the quoted sentence that tells the person to ask for suggestions. The Experience Standard, the Skills Constitution, and the Profile skill stay unchanged.

The skill behavior is in [contracts/objectives-skill.md](./contracts/objectives-skill.md). The retained record is in [contracts/objectives-record.md](./contracts/objectives-record.md).

## Technical Context

**Language/Version**: Markdown skill text. Existing Bash 3.2 tests. No new dependency.

**Primary Dependencies**: The Highway Experience Standard for shared interaction, the Skills Constitution for the common failure model and context precedence, accepted Profile evidence for recommendations, and the existing Objective record and catalog templates.

**Storage**: User-owned Objective records and the Objective catalog stay where the skill already writes them. Highway Relevance is not stored. The Objective record template is not edited.

**Testing**: `.highway/tools/tests/run-all.sh` exits 0 before the first edit and after the final edit, run with unrestricted filesystem access. Updated tests are observed failing before the skill edit that makes them pass. Replaced assertions name the superseded behavior.

**Target Platform**: The shipped Highway tree. The Objectives skill already ships.

**Project Type**: Skill contract rewrite

**Performance Goals**: None. This is a skill-text change.

**Constraints**: Skill version becomes 3.0.0. The Objective record template stays 1.0.0. The skill does not copy a constitution rule sentence and does not contain `.specify/` or `specs/`. Bash 3.2 only. Setup orchestration is not redesigned. Other skills are not edited except the quoted Objectives opening in highway-setup.

**Scale/Scope**: One skill rewrite, one quoted opening in Setup, and the tests that still require Outcome, Significance, the suggestion sentence, persist-and-verify, or the current Experience restatements.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature edits the Objectives skill, the quoted Objectives opening in Setup, and the tests that still encode the old discovery and verification contract. It regenerates agent copies. It does not edit a generator, the Objective record template, the Experience Standard, the Skills Constitution, or the Profile skill.

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | Both skills already ship. The amendment must not introduce `.specify/` or `specs/`. The Objectives skill cites the Experience Standard and the Objective record template. |
| Toolchain Gate (D2.1–D2.4) | PASS | Test edits stay in the existing shell toolchain. No new dependency or non-portable construct is added. |
| Generator Gate (D4.1–D4.4) | N/A | No `generate-*.sh` script is edited. Generated copies are regenerated, not hand-edited. |
| Correspondence Gate (D4.5–D4.7) | PASS | The Objectives skill body and version are generator inputs. Declared generators are re-run. The catalog entry for highway-objectives changes from 2.0.0 to 3.0.0. Other entry fields stay. A second adapter run is byte-stable. |
| Validation Gate (D3.4, D3.5) | N/A | No validation check is added or modified. |
| D3.1 | PASS | The suite exits 0 before the first edit of this feature. |
| D3.2 | PASS | The suite exits 0 after the final edit. |
| D3.3 | PASS | `.highway/tools/tests/objective-management.test.sh`, `.highway/tools/tests/highway-ux-alignment.test.sh`, `.highway/tools/tests/experience-x23-contract.test.sh`, and `.highway/tools/tests/highway-setup.test.sh` are edited. |
| D3.6 | PASS | Each updated test is observed failing on the current skill text before the edit that makes it pass. |
| D6.1 | PASS | The Objectives skill and the Setup quotation of its opening are updated in the same change. The Objective record template is not invalidated. |
| D8.1 | N/A | No shared library artifact is edited. |

Process result: PASS. No gate is left as an exception.

### Skill content gates

The Skill Content Gate triggers because `.highway/skills/highway-objectives/SKILL.md` and `.highway/skills/highway-setup/SKILL.md` are edited.

| Rule | Verdict | Evidence |
|---|---|---|
| P7.3 | PASS | Objectives cites the Experience Standard, the Constitution's common failure model by leaving generic failures there, and the Objective record template. It does not copy their rule sentences. |
| P7.4, P7.5, P7.6 | PASS | Restated interaction and context prose is removed. The rewritten skill stays within 12 MUST-level rules and 400 words per normative section. New behavior is written without adding uppercase MUST. |
| P5.14 | PASS | Error Handling lists only the malformed baseline, the unresolved update or remove target, and destructive removal or reset. |
| P7.7 | PASS | Discovery, acceptance, recommendations, continuation, and verification break the current contract, so the skill moves from 2.0.0 to 3.0.0. Setup's own version stays. |
| P8.2 | PASS | Continuation branches and the discovery evaluation order are stated because they change what happens next. Other workflow steps are not numbered. |
| P9.1 | PASS | Outputs name `objective-record.md` and the retained locations. The skill does not repeat the template skeleton or add a Highway Relevance field. |
| P9.2, P9.3, P9.4, P9.7 | PASS | Outputs keep the four readiness fields, the retained paths, and the Missing and Blocked results. |
| P9.5 | PASS | The example does not repeat a version. Metadata becomes 3.0.0. |
| P10.1 | PASS | The Experience section names the Highway Experience Standard and does not restate its interaction rules. |
| P11.1 | PASS | Inputs name Profile, existing Objectives, Identity, Highway Vision, and Highway Platform Objectives, each with its Objective role. |

**Post-design re-check**: PASS. The version bump, the unchanged record, the one-time continuation question, and the Setup quotation boundary are fixed in the contracts and in [research.md](./research.md).

## Project Structure

### Documentation (this feature)

```text
specs/105-simplify-objectives-skill/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── objectives-skill.md
│   └── objectives-record.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/skills/highway-objectives/SKILL.md
.highway/skills/highway-setup/SKILL.md
.highway/tools/tests/objective-management.test.sh
.highway/tools/tests/highway-ux-alignment.test.sh
.highway/tools/tests/experience-x23-contract.test.sh
.highway/tools/tests/highway-setup.test.sh
```

Generated adapter copies of the edited skills are regenerated. They are not hand-edited. `.highway/library/templates/output/objective-record.md` and `.highway/library/templates/output/objective-catalog.md` stay as they are.

**Structure Decision**: The Objectives skill owns discovery, recommendations, review, continuation, readiness, and persistence behavior. The shared record template keeps Statement, Success Measures, and Rationale. Setup keeps its orchestration and updates only the quoted Objectives opening.

## Complexity Tracking

No constitution gate is violated. The record template stays at 1.0.0, so this change does not add a stored Highway Relevance field or a second record version.
