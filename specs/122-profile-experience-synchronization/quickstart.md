# Feature 122 Quickstart

## Prerequisites

Run from the repository root on macOS. No package installation or external service is required. The authoritative implementation surface is `.highway/skills/highway-profile/SKILL.md`; the shared Profile template is read-only.

The working tree may contain unrelated user changes. Review changed paths before interpreting protected-scope checks.

## Baseline

Record the current Profile skill version, schema version, four readiness domains, shared Experience sentence, accuracy-oriented validation prompts, canonical fallback prompts, website scope, and persistence-before-result behavior before editing.

```sh
grep -n 'version:' .highway/skills/highway-profile/SKILL.md
grep -nE 'schema_version|identity:|vision:|competitive_path:|guiding_principles:' .highway/library/templates/output/profile-record.md
grep -n 'User-visible interaction follows the Highway Experience Standard.' .highway/skills/highway-profile/SKILL.md
```

## Focused Validation

Run the Profile contracts that cover the changed and preserved behavior:

```sh
bash .highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-lifecycle.test.sh
bash .highway/tools/tests/profile-structure.test.sh
bash .highway/tools/tests/profile-markdown-contract.test.sh
bash .highway/tools/tests/profile-template-migration.test.sh
bash .highway/tools/tests/feature-092-contract.test.sh
bash .highway/tools/tests/feature-092-correspondence.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

Expected focused results:

- The Profile skill contains one rationalized Enrichment model.
- Optional acknowledgment wording, decision-only advisory wording, stale contextualization wording, and local brevity quotas are absent.
- X2.8 applicability is preserved without duplicating its full rule.
- Identity, Vision, Competitive Path, and Guiding Principles grounding and validation wording remain present.
- Transient conversational context is not promoted to retained Profile evidence.
- The shared Profile template remains schema 3.0.0 with four readiness domains.
- Website and brownfield scope, canonical fallback, persistence ordering, completion synthesis, and shared Experience ownership remain intact.

## Scope Review

Review the final changed paths:

```sh
git diff --name-only
git diff --check
```

The intended implementation diff contains the Profile skill and directly affected Profile-specific checks plus Feature 122 design artifacts. It must not contain:

- `.highway/library/templates/output/profile-record.md`;
- `.highway/library/knowledge/profile.md`;
- `.highway/library/knowledge/highway-identity.md`;
- `.highway/governance/experience-standard.md`;
- any skill other than `highway-profile`;
- Setup, Objectives, Controls, NFRs, or unrelated governance artifacts.

## Full Validation

```sh
bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: no Feature 122 regression. Any failure caused by a pre-existing unrelated worktree modification must be recorded separately from Feature 122 results and must not be fixed by reverting user work.

## Acceptance Review

Review the Feature 122 requirements against the implementation and contracts:

- FR-001 through FR-011: Profile ownership, one Enrichment model, X2.8 applicability, advisory breadth, and transient-versus-retained separation.
- FR-012 through FR-018: Identity preservation and Vision, Competitive Path, Guiding Principles grounding, validation, and natural recommendation prose.
- FR-019 through FR-024: canonical fallback, acquisition order, first-time introduction, website scope, and completion synthesis.
- FR-025 through FR-033: shared Experience boundary, schema/readiness/persistence preservation, verification coverage, version preservation, and protected scope.

## Version and Schema Review

Confirm `highway-profile` remains version 5.1.0 and `profile-record.md` remains schema version 3.0.0. Conversational synchronization must not add retained fields or workflow states.

## Feature 122 Evidence

- The test-first Feature 122 contract failed before the Profile edit on stale optional-acknowledgment, decision-only advisory, contextualization, and completion wording; it passes after implementation.
- Focused validation passed: `feature-122-profile-experience-synchronization.test.sh`, all Profile behavior/lifecycle/structure/markdown/template contracts, Feature 092 contracts, correspondence, and UX alignment.
- Derived Profile adapters were regenerated with `.highway/tools/generate-agent-adapters.sh`; adapter coverage passes.
- `constitution-inventory.test.sh` passes after adding the required instrument and artifact metadata to the Feature 122 contract.
- `run-all.sh` passes all Feature 122 and Profile contracts. Two unrelated worktree-sensitive checks remain red: `constitution-profile-context.test.sh` reports missing behavioral guidance in the pre-existing user-modified `.highway/library/knowledge/highway-identity.md`, and `experience-standard-amendment.test.sh` reports the intentional `.highway/skills/highway-profile/SKILL.md` implementation change as protected. Neither failure was changed or reverted.
- `git diff --check` passes. The changed paths are the Profile skill, its four generated adapters and adapter manifest, directly affected Profile verification, the Feature 122 design artifacts, and no protected template, retained Profile, Experience Standard, or unrelated skill.
