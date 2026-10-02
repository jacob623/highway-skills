# Implementation Plan: Profile Collaborative Development

**Branch**: `128-profile-collaborative-development` | **Date**: 2026-10-02 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/128-profile-collaborative-development/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Update the `highway-profile` skill so its domain-specific interaction guidance implements the
shared Working Idea / Converged Proposal lifecycle. Keep the Profile record contract unchanged:
schema `3.0.0`, four readiness domains, three readiness states, accepted-narrative-only
persistence, organizational website scope, and existing operations. Replace immediate
recommendation acceptance and acknowledgment sequencing with collaborative development and
contextual re-evaluation. Directly affected Profile contract checks will be synchronized, and
generated skill artifacts will be regenerated when required by repository correspondence rules.

## Technical Context

**Language/Version**: Markdown skill contract; Bash 3.2-compatible repository checks

**Primary Dependencies**: Highway Skills Constitution, Highway Identity, Experience Standard,
shared Profile record template, existing Profile validation scripts

**Storage**: Existing Markdown Profile artifact; no storage or schema change

**Testing**: Existing `.highway/tools/tests/profile-*.test.sh`, Experience Standard/UX alignment
contracts, generated-artifact correspondence checks, and full `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and POSIX/Bash 3.2-compatible Highway development and distribution trees

**Project Type**: Governance skill and documentation contract

**Performance Goals**: No new runtime performance path; preserve existing interaction and readiness behavior

**Constraints**: Do not change `profile-record.md`, schema `3.0.0`, four readiness domains, readiness
states, website boundary, persistence ordering, or shared governance documents. Keep shared guidance
centralized rather than copying it into Profile. Preserve generated-artifact correspondence.

**Scale/Scope**: One Profile skill contract, directly affected Profile checks, and any generated
artifacts required by repository generators; no other domain skill behavior changes

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The following gates apply:

- **Packaging Gate: PASS** — the changed shipped skill remains within the distributed `.highway/`
  tree; references must resolve and the skill must remain valid for packaging.
- **Skill Content Gate: PASS** — the change is judged against the Highway Skills Constitution,
  especially owner-controlled completion, accepted knowledge boundaries, no workflow narration,
  and skill ownership rules.
- **Correspondence Gate: PASS WITH VALIDATION** — changing a skill input requires confirming
  catalog, adapters, manifests, and other generated outputs remain synchronized. Regenerate only
  the artifacts owned by the repository generators when the source change requires it.
- **Validation Gate: PASS** — directly affected Profile contracts and the full suite must pass;
  no validation rule is removed merely to accommodate the new wording.
- **Toolchain and Generator Gates: N/A** — no generator or toolchain script is modified.

No gate violation requires a complexity exception.

## Project Structure

### Documentation (this feature)

```text
specs/128-profile-collaborative-development/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command)
```

### Source Code (repository root)
```text
.highway/skills/highway-profile/SKILL.md       # behavior contract to update
.highway/library/templates/output/profile-record.md  # protected retained-record schema
.highway/library/knowledge/highway-identity.md      # shared behavioral guidance
.highway/governance/constitution.md                 # governing owner and knowledge rules
.highway/governance/experience-standard.md          # shared interaction contract
.highway/tools/tests/profile-*.test.sh              # Profile contract checks
.highway/tools/tests/highway-ux-alignment.test.sh   # shared UX alignment check
.highway/tools/tests/run-all.sh                     # full validation suite
```

**Structure Decision**: This is a documentation-only skill change in the existing Highway tree.
The shipped behavior owner is `highway-profile/SKILL.md`; the Profile template and shared
governance documents are read-only dependencies. Tests remain under `.highway/tools/tests/`.

No `contracts/` directory is generated because this feature exposes no API, command schema, or
new persisted data interface; its user-visible contract is covered by the Profile skill and
existing executable checks.

## Post-Design Constitution Check

- **Packaging Gate: PASS** — the planned shipped skill path remains package-resolvable.
- **Skill Content Gate: PASS** — the design preserves owner-controlled mutation, accepted
  knowledge boundaries, transient reasoning context, and the shared interaction contract.
- **Correspondence Gate: PASS PENDING IMPLEMENTATION** — implementation must regenerate and verify
  declared generated outputs after the Profile skill source changes.
- **Validation Gate: PASS** — focused Profile contracts, UX alignment, correspondence checks, and
  the full suite are required; no existing meaningful check is removed.
- **Toolchain and Generator Gates: N/A** — no generator or toolchain script is planned to change.

The design introduces no constitution violation and requires no complexity exception.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature uses the existing Profile skill and validation structure. |
