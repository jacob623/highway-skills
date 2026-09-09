# Implementation Plan: Highway Organizational Profile

**Branch**: `024-highway-profile` | **Date**: 2026-09-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from [spec.md](spec.md)

## Summary

Add the distributed `highway-profile` skill and `.highway/profile.yaml` artifact. The skill will
provide read-only help/view actions, questionnaire-driven setup, and confirmation-gated profile
mutations. The profile follows the `requirements-inquiry.md` model: Highway governs structure,
placement, and validation; repository owners own the values; the profile remains contextual and
does not become a governance, NFR, or Control baseline.

## Technical Context

**Language/Version**: Bash 3.2.57-compatible shell scripts and Markdown/YAML governance artifacts

**Primary Dependencies**: Existing skill validator, library/distribution validators, catalog and adapter generators, and shell test harness

**Storage**: `.highway/profile.yaml` plus source skill and generated catalog/adapter/distribution artifacts

**Testing**: Focused profile/skill shell tests, `.highway/tools/validate-skill.sh`, a profile structure validator, library containment checks, adapter correspondence checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and GNU/Linux environments supporting the declared Bash-compatible toolchain

**Project Type**: Packaged agent-skill framework with shell governance tooling and distributed YAML context

**Performance Goals**: Preserve deterministic O(n) listing/inspection behavior and complete validation within the existing suite envelope

**Constraints**: No runtime dependency additions; preserve user wording and order; no timestamps/random/environment-derived values; no writes before confirmation; no semantic judgment of profile values; profile remains compatible with future sections

**Scale/Scope**: One new skill, one distributed YAML artifact, one structural validator or validation extension, generated catalogs/adapters/manifests, and focused regression coverage for four user stories

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Development gates

| Gate | Rules | Verdict | Reason |
|---|---|---|---|
| Layer separation and shippability | D1.1, D1.2, D1.5, D1.6 | PASS | The new skill/profile are distributed artifacts, the plan records the Layer 1 check, and the declared distribution path remains authoritative. |
| Toolchain and dependency discipline | D2.1-D2.4 | PASS | No runtime dependency is planned; implementation remains within the declared shell/toolchain constraints. |
| Verification | D3.1-D3.6 | PASS | The feature adds focused behavioral and structural tests, evaluates fixtures before enabling new checks, and requires pre/post full-suite runs. |
| Generated artifact integrity | D4.1-D4.7 | PASS | Source skill/profile changes are followed by all declared catalog, adapter, library, and distribution regeneration/correspondence checks. |
| Specification integrity | D5.1-D5.4 | PASS | Feature 024 is a new sequential record and prior completed specifications remain untouched. |
| Documentation and completion integrity | D6.1-D6.2, D7.1-D7.3 | PASS | The plan names current documentation impacts and implementation will record task/artifact and requirement coverage separately from checks. |

### Skill and artifact gates

| Rule area | Verdict | Evidence planned |
|---|---|---|
| P7.1, P7.2 | PASS after implementation | `highway-profile` will have one Purpose and a valid semantic version. |
| P9.1 / X1.1-X1.5 | PASS after design review | The skill's retained profile output will declare a complete structure and the implementation will resolve whether the distributed profile uses a shared output skeleton or the established library-artifact model before enabling the skill. |
| X2.1, X4.1, X5.1-X5.2, X6.1 | PASS after implementation | Destructive actions require confirmation, structural errors are surfaced, output is useful, and operations are deterministic. |
| D8.1 | N/A at planning time | No existing shared library artifact is changed; the profile introduces a new distributed artifact and its citing skill together. |

### Post-design re-check

Phase 0 research resolves the validator boundary, ownership model, and deterministic mutation strategy. Phase 1 introduces no unresolved clarification or complexity exception. The P9.1/X1 output review remains an implementation gate because the profile is a retained YAML artifact rather than an existing Markdown output skeleton.

## Project Structure

### Documentation (this feature)

```text
specs/024-highway-profile/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/requirements.md
└── tasks.md                 # Phase 2 output; not created by /speckit-plan
```

### Source and distributed paths

```text
.highway/
├── profile.yaml                         # distributed user-owned context
├── skills/highway-profile/SKILL.md      # source skill
├── catalog/                             # generated skill/library catalogs
├── tools/
│   ├── validate-profile.sh              # structural profile validation
│   ├── generate-catalog.sh
│   ├── generate-library-catalog.sh
│   ├── generate-distribution.sh
│   └── tests/                           # focused and full validation

.github/skills/highway-profile/SKILL.md  # generated adapter
.claude/skills/highway-profile/SKILL.md  # generated adapter
.cursor/rules/highway-profile.mdc        # generated adapter
```

**Structure Decision**: Extend the existing distributed skill, catalog, adapter, manifest, and
test paths. Add profile-specific structural validation rather than forcing YAML into the Markdown
library validator. No external API contract directory is needed; the user-facing contract is the
skill's command and output behavior documented in the feature records.

## Complexity Tracking

No constitution violations require justification. A dedicated profile validator is warranted by
the artifact's YAML format and distinct semantic boundary; reusing the Markdown library validator
would either reject the requested file or incorrectly apply governance-content checks to user-owned
values.
