# Implementation Plan: Simplify the Profile Skill

**Branch**: `103-simplify-profile-skill` | **Date**: 2026-09-29 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/103-simplify-profile-skill/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Rewrite `.highway/skills/highway-profile/SKILL.md` from 3.0.0 to 4.0.0 so Profile behavior is the four readiness domains, optional Markdown context, canonical questions, and internal enrichment categories. The skill cites the Highway Experience Standard and the common failure model. It does not restate them, name a validator, or require a post-write byte check.

Update `.highway/library/templates/output/profile-record.md` from schema 2.0.0 to 3.0.0. Remove Highway Role. Schema 2.0.0 is unsupported and is left unchanged. Structural classification in `.highway/tools/lib/profile.sh` and `.highway/tools/validate-profile.sh` follows the new record. The skill does not name that script.

Tests and fixtures that still require five domains, Highway Role, schema 2.0.0 as valid, the validator as a skill instruction, or persist-and-verify are updated in the same change. Generated skill copies and the library catalog are regenerated from the new sources.

The record and the skill behavior are in [contracts/profile-record.md](./contracts/profile-record.md) and [contracts/profile-skill.md](./contracts/profile-skill.md).

## Technical Context

**Language/Version**: Markdown skill and template. Existing Bash 3.2 helpers. No new dependency.

**Primary Dependencies**: The Highway Experience Standard, the Skills Constitution common failure model, the Skill Versioning Policy, and the existing Profile helper library. No new retrieval package.

**Storage**: One source skill, one shared Markdown template, and the retained Profile at `.highway/library/knowledge/profile.md` when a repository has one. Optional context is Markdown in the record body. Domain outcomes stay in frontmatter.

**Testing**: `.highway/tools/tests/run-all.sh` exits 0 before the first edit and after the final edit, run with unrestricted filesystem access. Updated tests are observed failing before the skill and template edits that make them pass. Replaced assertions name the superseded behavior.

**Target Platform**: The shipped Highway tree. The skill and the template already ship.

**Project Type**: Skill and retained-record contract change

**Performance Goals**: None. This is a skill and template change.

**Constraints**: Skill version 4.0.0. Schema 3.0.0. Schema 2.0.0 is unsupported and is not migrated. The skill stays within the existing size limits by reduction. It does not copy a constitution rule sentence. It does not contain `.specify/` or `specs/`. The Experience Standard and the Skills Constitution stay unchanged. Other skills stay unchanged. Bash 3.2 only.

**Scale/Scope**: One major skill version and one major Profile schema. Four readiness domains. Optional context does not affect readiness.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature rewrites the Profile skill, the shared Profile template, the Profile structural helper, and the tests and fixtures that still encode the five-domain record. It regenerates agent copies and the library catalog. It does not edit a generator script, the Experience Standard, the Skills Constitution, or another skill.

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | The skill and the template already ship. The amendment must not introduce `.specify/` or `specs/`. Citations point at the Experience Standard, the shared template, and the three declared context documents. |
| Toolchain Gate (D2.1–D2.4) | PASS | Helper and test edits stay in the existing shell toolchain. No new dependency or non-portable construct is added. |
| Generator Gate (D4.1–D4.4) | N/A | No `generate-*.sh` script is edited. Generated copies are regenerated, not hand-edited. |
| Correspondence Gate (D4.5–D4.7) | PASS | The Profile skill and the shared template are generator inputs. Declared generators are re-run so adapter copies and the library catalog match the sources. |
| Validation Gate (D3.4, D3.5) | PASS | The structural check changes from schema 2.0.0 and five domains to schema 3.0.0 and four domains. Existing fixtures are recorded against that check before the new rule is enabled. Replaced assertions name the superseded five-domain and 2.0.0 behavior. |
| D3.1 | PASS | The suite exits 0 before the first edit of this feature. |
| D3.2 | PASS | The suite exits 0 after the final edit. |
| D3.3 | PASS | The Profile contract tests and fixtures under `.highway/tools/tests/` are edited. |
| D3.6 | PASS | Each updated test is observed failing on the current five-domain text before the skill or template edit that makes it pass. |
| D6.1 | PASS | The skill, the template, and the structural helper stop describing five domains, Highway Role, schema 2.0.0 as current, and persist-and-verify. |
| D8.1 | PASS | The shared template changes. highway-profile is the citing skill and is rewritten against that template in the same change. No other skill cites the template. |

Process result: PASS. No gate is left as an exception.

### Skill content gates

The Skill Content Gate triggers because `.highway/skills/highway-profile/SKILL.md` and `.highway/library/templates/output/profile-record.md` are edited.

| Rule | Verdict | Evidence |
|---|---|---|
| P7.3 | PASS | The skill cites the Experience Standard, the common failure model, and the shared template. It does not copy their rule sentences. |
| P7.4, P7.5, P7.6 | PASS | The rewrite removes restated interaction prose, the eight-step workflow, and the failure table so the skill stays inside the existing size limits. |
| P5.14 | PASS | Failure handling records only the three Profile exceptions. |
| P8.2 | PASS | Ordering is stated only for context acquisition, acceptance, mutation, and readiness. |
| P9.2, P9.3, P9.4, P9.7 | PASS | Outputs name the readiness fields, the retained record shape, the empty result, and the Profile path. |
| P9.5 | PASS | The example does not repeat a version that disagrees with metadata 4.0.0. |
| P10.1 | PASS | The Experience section names the Highway Experience Standard. |
| P11.1 | PASS | Declared context remains Highway Identity, Highway Vision, and Highway Platform Objectives, each with its Profile role. |

**Post-design re-check**: PASS. The record shape, the skill citations, the schema 2.0.0 refusal, and the test boundary are fixed in the contracts and in [research.md](./research.md).

## Project Structure

### Documentation (this feature)

```text
specs/103-simplify-profile-skill/
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
.highway/tools/lib/profile.sh
.highway/tools/validate-profile.sh
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/feature-092-contract.test.sh
.highway/tools/tests/profile-structure.test.sh
.highway/tools/tests/profile-migration.test.sh
.highway/tools/tests/profile-markdown-contract.test.sh
.highway/tools/tests/profile-lifecycle.test.sh
.highway/tools/tests/profile-behavior.test.sh
.highway/tools/tests/highway-ux-alignment.test.sh
.highway/tools/tests/fixtures/profile-092/
```

Generated adapter copies of the skill, and the library catalog entry for the template, are regenerated. They are not hand-edited.

**Structure Decision**: The Profile skill and the shared template are the sources. The helper library classifies a record as usable or not. The skill states the readiness outcome of that classification and does not name the helper script. Tests and fixtures follow schema 3.0.0 and four domains.

## Complexity Tracking

No constitution gate is violated. Tests, fixtures, and the structural helper are in this change, so the verification and documentation gates pass without a compatibility path for schema 2.0.0.
