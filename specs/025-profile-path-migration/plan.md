# Implementation Plan: Highway Profile Path Migration

**Branch**: `025-profile-path-migration` | **Date**: 2026-09-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from [spec.md](spec.md)

## Summary

Move the organizational profile from `.highway/profile.yaml` to the authoritative pure-YAML output-template path `.highway/library/templates/output/profile.yaml`. Preserve the exact schema and user-owned values, remove all former-path artifacts and generated references, add a repeatable orphan audit, and enforce the PATCH/MINOR/MAJOR version policy only after confirmed writes.

## Technical Context

**Language/Version**: Bash 3.2.57-compatible shell scripts and Markdown/YAML governance artifacts

**Primary Dependencies**: Existing profile helper and validator, library/distribution validators, catalog and adapter generators, distribution manifests, and shell test harness

**Storage**: `.highway/library/templates/output/profile.yaml`; former `.highway/profile.yaml` must be absent

**Testing**: Focused profile structure, migration-audit, version-maintenance, packaging, correspondence, and full-suite shell tests

**Target Platform**: macOS and GNU/Linux environments supporting the declared portable Bash/toolchain constraints

**Project Type**: Packaged agent-skill framework with shell governance tooling and distributed YAML context

**Performance Goals**: Complete migration and orphan audit within the existing validation-suite envelope; repeated audits are deterministic

**Constraints**: Preserve user wording and value order; retain exact metadata-first schema and empty mappings; no frontmatter; no timestamps or random values; no writes before confirmation; no external runtime dependency; preserve user changes in edited manifest/test files

**Scale/Scope**: One profile path move, one pure-YAML structural validation path, focused skill/helper/test updates, regenerated catalogs/adapters/manifests, and distribution correspondence coverage

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Rules | Verdict | Reason |
|---|---|---|---|
| Layer separation and shippability | D1.1, D1.2, D1.5, D1.6 | PASS | The canonical profile, skill, validators, and generated outputs remain distributed artifacts; planning records stay under `specs/`. |
| Toolchain and dependency discipline | D2.1-D2.4 | PASS | The implementation reuses Bash 3.2-compatible scripts and existing tools without runtime dependency additions. |
| Verification | D3.1-D3.6 | PASS | Focused migration, schema, version, packaging, correspondence, and full-suite checks are planned before and after implementation. |
| Generated artifact integrity | D4.1-D4.7 | PASS | Source changes will be followed by generator runs and correspondence checks; generated files will not be hand-edited. |
| Specification integrity | D5.1-D5.4 | PASS | Feature 025 is a new sequential spec record and Feature 024 remains unchanged. |
| Completion integrity | D7.1-D7.3 | PASS | Tasks will map to artifacts and requirements, with checks reported separately from coverage. |
| Shared output contract | P9.1, X1.1-X1.5, D8.1 | PASS after design | `profile.yaml` is the complete shared pure-YAML output template; Markdown-only library validation is extended or bypassed through a dedicated structural validator, and citing/dependent artifacts are revalidated together. |

No complexity exception is required.

## Phase 0: Research Summary

Research decisions are recorded in [research.md](research.md). The key design choices are:

- Keep the canonical YAML profile as the authoritative output template and validate it structurally without Markdown frontmatter.
- Make the migration audit explicit and fail on any former-path file or reference across source, tests, fixtures, generated artifacts, manifests, and distribution metadata.
- Keep version changes transactional: compute the new version as part of the proposed state and write it only with a confirmed content change.
- Regenerate catalogs, adapters, and distribution outputs from source inputs after the move.

## Phase 1: Design Summary

- [data-model.md](data-model.md) defines the canonical artifact, schema, migration audit, version state, and mutation transition rules.
- [contracts/profile-migration.md](contracts/profile-migration.md) defines the user-visible migration and audit contract.
- [quickstart.md](quickstart.md) defines focused validation and end-to-end packaging checks.

## Project Structure

### Documentation (this feature)

```text
specs/025-profile-path-migration/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── profile-migration.md
├── checklists/
│   └── requirements.md
└── tasks.md                 # Phase 2 output; not created by /speckit-plan
```

### Source and distributed paths

```text
.highway/
├── library/templates/output/profile.yaml   # canonical pure-YAML artifact
├── skills/highway-profile/SKILL.md         # source skill contract
├── tools/
│   ├── lib/profile.sh                      # profile mutation/version helper
│   ├── validate-profile.sh                 # structural profile validator
│   ├── validate-library.sh                 # library boundary, if extended
│   ├── generate-catalog.sh
│   ├── generate-library-catalog.sh
│   ├── generate-agent-adapters.sh
│   ├── generate-distribution.sh
│   └── tests/                              # focused and full validation
├── catalog/                                # generated catalogs
└── tools/.distribution-manifest            # user-maintained distribution inputs

.github/skills/highway-profile/SKILL.md     # generated adapter
.claude/skills/highway-profile/SKILL.md     # generated adapter
.cursor/rules/highway-profile.mdc           # generated adapter
```

**Structure Decision**: Treat the canonical YAML profile as a retained shared output artifact with dedicated structural validation. Keep the skill, source helpers, tests, generated catalogs/adapters, and distribution metadata aligned through the existing generator and manifest mechanisms. Do not retain a second authoritative profile or stale Markdown output skeleton for the migrated artifact.

## Post-Design Constitution Re-check

| Gate | Verdict | Evidence |
|---|---|---|
| D1-D2 | PASS | Scope remains within distributed artifacts and declared shell tooling. |
| D3 | PASS | Quickstart and focused tests cover clean migration, exact schema, version transitions, no-write behavior, and packaging. |
| D4 | PASS | Regeneration and correspondence checks are explicit; canonical profile appears once in distribution inputs. |
| D5/D7 | PASS | Feature 025 owns migration requirements and planned artifacts; tasks will carry exact FR/SC coverage. |
| P9.1/X1.5/D8.1 | PASS after implementation | The YAML template is the complete output contract, its validator is structural rather than Markdown-frontmatter-based, and all affected citing/dependent artifacts are revalidated. |
