# Implementation Plan: Organize Profile Context

**Branch**: `104-profile-context-structure` | **Date**: 2026-09-29 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/104-profile-context-structure/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Reorganize `.highway/skills/highway-profile/SKILL.md` so Profile model, Acquisition, Enrichment, and Operations replace the single Evidence section. Remove the restated Experience Standard interaction rules from those sections. The Experience section becomes exactly `User-visible interaction follows the Highway Experience Standard.` The skill version stays 4.0.0.

Extend `.highway/library/templates/output/profile-record.md` so it owns the optional Context skeleton: `## Context` and the four child sections. Those headings are omitted when no accepted value exists. Template version and `schema_version` stay 3.0.0. The four readiness domains and the structural helper stay as they are.

The skill cites the template for that skeleton and does not repeat it. Checks that still require the authority sentence or the former sibling headings are updated in the same change. Agent copies are regenerated. The Experience Standard, the Skills Constitution, and other skills stay unchanged.

The record and the skill behavior are in [contracts/profile-record.md](./contracts/profile-record.md) and [contracts/profile-skill.md](./contracts/profile-skill.md).

## Technical Context

**Language/Version**: Markdown skill and template. Existing Bash 3.2 tests. No new dependency.

**Primary Dependencies**: The Highway Experience Standard for interaction rules, the shared Profile template for record structure, and the Skill Versioning Policy. No new retrieval package.

**Storage**: One source skill and one shared Markdown template. Optional Context is body Markdown after readiness narratives. Domain outcomes stay in frontmatter. A record with no accepted optional context omits Context.

**Testing**: `.highway/tools/tests/run-all.sh` exits 0 before the first edit and after the final edit, run with unrestricted filesystem access. Updated tests are observed failing before the skill and template edits that make them pass. Replaced assertions name the superseded behavior.

**Target Platform**: The shipped Highway tree. The skill and the template already ship.

**Project Type**: Skill reorganization and shared-record structure change

**Performance Goals**: None. This is a skill and template change.

**Constraints**: Skill version stays 4.0.0. Template version and schema stay 3.0.0. The skill does not copy a constitution rule sentence. It does not contain `.specify/` or `specs/`. The Experience Standard and the Skills Constitution stay unchanged. Other skills stay unchanged. Bash 3.2 only. No technology inventory is added to Profile.

**Scale/Scope**: One skill, one template, and the tests that still encode the old Experience citation or the old optional headings. Four readiness domains are unchanged.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature edits the Profile skill, the shared Profile template, and the tests that still require the old Experience citation or the sibling optional headings. It regenerates agent copies. It does not edit a generator, the structural helper, the Experience Standard, the Skills Constitution, or another skill.

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | The skill and the template already ship. The amendment must not introduce `.specify/` or `specs/`. The skill cites the Experience Standard and the shared template. |
| Toolchain Gate (D2.1–D2.4) | PASS | Test edits stay in the existing shell toolchain. No new dependency or non-portable construct is added. |
| Generator Gate (D4.1–D4.4) | N/A | No `generate-*.sh` script is edited. Generated copies are regenerated, not hand-edited. |
| Correspondence Gate (D4.5–D4.7) | PASS | The Profile skill body is a generator input. Declared generators are re-run so adapter copies match the source. Catalog timestamps may change; entries do not, because the skill version and the template version stay put. |
| Validation Gate (D3.4, D3.5) | N/A | No validation check is added or modified. The existing structural check already accepts a 3.0.0 four-domain record, and Context is not a domain. |
| D3.1 | PASS | The suite exits 0 before the first edit of this feature. |
| D3.2 | PASS | The suite exits 0 after the final edit. |
| D3.3 | PASS | `.highway/tools/tests/feature-092-contract.test.sh` and `.highway/tools/tests/output-template.test.sh` are edited. |
| D3.6 | PASS | Each updated test is observed failing on the current skill or template text before the edit that makes it pass. |
| D6.1 | PASS | The skill and the template are updated in the same change. No current Highway Profile Intent Summary is present to update. |
| D8.1 | PASS | The shared template changes. highway-profile is the only citing skill and is updated against that template in the same change. |

Process result: PASS. No gate is left as an exception.

### Skill content gates

The Skill Content Gate triggers because `.highway/skills/highway-profile/SKILL.md` and `.highway/library/templates/output/profile-record.md` are edited.

| Rule | Verdict | Evidence |
|---|---|---|
| P7.3 | PASS | The skill cites the Experience Standard and the shared template. It does not copy their rule sentences. |
| P7.4, P7.5, P7.6 | PASS | Restated interaction prose is removed. The four behavior sections stay inside the existing size limits. |
| P5.14 | PASS | Error Handling stays the three Profile exceptions. |
| P8.2 | PASS | The eight-step acquisition order is stated because that order changes what happens next. Other workflow steps are not numbered. |
| P9.1 | PASS | Outputs name the template and the retained path. The skill does not repeat the Context heading skeleton. |
| P9.2, P9.3, P9.4, P9.7 | PASS | Outputs keep the readiness fields, the retained path, and the absent-Profile result. |
| P9.5 | PASS | The example does not repeat a version. Metadata stays 4.0.0. |
| P10.1 | PASS | The Experience section names the Highway Experience Standard and does not restate its interaction rules. |
| P11.1 | PASS | Declared context remains Highway Identity, Highway Vision, and Highway Platform Objectives. |

**Post-design re-check**: PASS. The Experience sentence, the Context skeleton, the unchanged schema, and the test boundary are fixed in the contracts and in [research.md](./research.md).

## Project Structure

### Documentation (this feature)

```text
specs/104-profile-context-structure/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── profile-record.md
│   └── profile-skill.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/skills/highway-profile/SKILL.md
.highway/library/templates/output/profile-record.md
.highway/tools/tests/feature-092-contract.test.sh
.highway/tools/tests/output-template.test.sh
```

Generated adapter copies of the skill are regenerated. They are not hand-edited. `.highway/tools/lib/profile.sh` and `.highway/tools/validate-profile.sh` stay as they are.

**Structure Decision**: The Profile skill owns behavior. The shared template owns the Context skeleton in its structural guidance, and a record omits that skeleton when nothing has been accepted. The structural helper is unchanged because Context is not a readiness domain.

## Complexity Tracking

No constitution gate is violated. The structural helper stays on schema 3.0.0 and four domains, so this change does not add a second validation rule or a version bump.
