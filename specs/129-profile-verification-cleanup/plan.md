# Implementation Plan: Profile Verification Cleanup

**Branch**: `129-profile-verification-cleanup` | **Date**: 2026-10-02 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/129-profile-verification-cleanup/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Update only the Verification section of `.highway/skills/highway-profile/SKILL.md` to reflect the
existing Working Idea / Converged Proposal lifecycle, contextual re-evaluation, transient Active
Reasoning Context, and accepted-evidence boundaries. Remove the duplicate final Experience section.
Preserve all other Profile behavior, the retained record schema, and shared governance authorities.

## Technical Context

**Language/Version**: Markdown skill contract; Bash 3.2-compatible repository checks

**Primary Dependencies**: Highway Skills Constitution, Highway Identity, Experience Standard,
existing Profile skill, protected Profile record template, and current Profile contract checks

**Storage**: Existing Markdown Profile artifact; no storage or schema change

**Testing**: Focused Profile contract checks, correspondence checks, Grow Creative setup, and the
full repository test suite

**Target Platform**: macOS and POSIX/Bash 3.2-compatible Highway development and distribution trees

**Project Type**: Governance skill and documentation contract

**Performance Goals**: No new runtime path; focused verification remains within existing test-suite timing

**Constraints**: Do not change Acquisition, Enrichment, Operations, readiness, persistence, completion
synthesis, error handling, Profile schema, protected template, shared governance, or other skills.
Remove only stale Verification wording and the duplicate final Experience section.

**Scale/Scope**: One Profile skill Verification section, directly affected Profile checks, and any
generated Profile correspondence required by source synchronization; no new persisted data or interface

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Packaging Gate: PASS** — the changed shipped skill remains within `.highway/skills/highway-profile/`
  and its generated correspondence remains package-resolvable.
- **Skill Content Gate: PASS** — the change preserves owner-controlled completion, accepted knowledge
  boundaries, transient reasoning, and the shared interaction contract.
- **Correspondence Gate: PASS WITH VALIDATION** — a changed skill source requires regeneration and
  verification of declared adapters, catalogs, and manifests.
- **Validation Gate: PASS** — focused Profile checks, Grow Creative setup, correspondence checks, and
  the full suite are required; no meaningful coverage is removed.
- **Toolchain and Generator Gates: N/A** — no generator or toolchain script is modified.

## Project Structure

### Documentation (this feature)

```text
specs/129-profile-verification-cleanup/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
```text
.highway/
├── skills/highway-profile/SKILL.md
├── library/templates/output/profile-record.md       # protected dependency
├── governance/constitution.md                       # protected authority
├── governance/experience-standard.md                # protected authority
├── library/knowledge/highway-identity.md            # protected authority
└── tools/tests/profile-*.test.sh                    # focused checks
```

**Structure Decision**: This is a documentation-only change in the existing Highway tree. The Profile
skill owns the Verification behavior; the Profile template and shared authorities remain read-only
dependencies. No external contract artifact is needed because the feature exposes no API, command
schema, or new persisted interface.

## Post-Design Constitution Check

- **Packaging Gate: PASS** — the source and generated Profile skill paths remain package-resolvable.
- **Skill Content Gate: PASS** — Verification is aligned to the existing collaborative model without
  copying or changing shared governance guidance.
- **Correspondence Gate: PASS PENDING IMPLEMENTATION** — regenerate and verify Profile adapters,
  catalogs, manifests, and distribution correspondence after the source edit.
- **Validation Gate: PASS** — focused checks, Grow Creative setup, correspondence, and full-suite
  validation remain required.
- **Toolchain and Generator Gates: N/A** — no generator or toolchain script is planned to change.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature uses the existing Profile skill, checks, and correspondence workflow. |
