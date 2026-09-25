# Feature 092 Quickstart

## Prerequisites

Run from the repository root on macOS with the default Bash toolchain. No external service or package installation is required.

Baseline before implementation: `.highway/tools/tests/run-all.sh` passed through
`distribution-packaging.test.sh` and then stalled at `generate-agent-adapters.test.sh` without
emitting a failure assertion before the process was stopped. The baseline is therefore not a
complete pass and must be re-run after implementation.

## Validate the source contracts

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-profile
.highway/tools/validate-skill.sh .highway/skills/highway-setup
.highway/tools/validate-profile.sh .highway/library/templates/output/profile-record.md
.highway/tools/validate-library.sh .highway/library/templates/output/profile-record.md
```

The Profile validation command should be run against disposable retained fixtures when the authoritative Profile is absent.

## Run focused Feature 092 checks

```sh
bash .highway/tools/tests/run-all.sh
```

Focused checks should cover readiness response shape and classification, Setup owner routing, Profile context participation, Markdown rendering, template metadata separation, no-write/no-op mutations, schema-version matrix, runtime identifier hygiene, X2.3/X2.7-X2.10 interaction composition, and generated correspondence.

## Verify template migration

Confirm that:

- `.highway/library/templates/output/profile-record.md` exists;
- `.highway/library/templates/output/profile.md` is absent;
- `.highway/library/templates/output/profile.yaml` is absent;
- `.highway/library/knowledge/profile.md` remains the retained user-owned artifact;
- Profile and Setup contracts do not resolve the removed files as fallback inputs.

## Verify owner routing

Run fixtures for absent, valid incomplete, complete, malformed, unsupported action, malformed response, and NFR `In Progress` states. Confirm active orchestration delegates supported owner actions, status-only requests only report, and stage advancement follows a fresh terminal readiness result.

## Verify context and UX composition

Run fixtures showing that Identity, Vision, and Platform Objectives influence evidence significance without becoming organizational facts, and that required contextual acknowledgment, Decision Context, Relevant Examples, and user-relevant progress remain available without exposing internal loading or routing mechanics.

## Verify generated artifacts

Record the changed-source/dependent inventory, regenerate only identified catalogs, adapters, manifests, or distribution artifacts, and run the repository's correspondence checks. Finish with:

```sh
git diff --check
```

## Feature 092 validation evidence

The focused Feature 092 checks passed:

- `feature-092-contract.test.sh`
- `feature-092-correspondence.test.sh`
- `experience-x23-contract.test.sh`
- `setup-owner-loop-contract.test.sh`
- `profile-context-contract.test.sh`
- `profile-markdown-contract.test.sh`
- `profile-yaml.test.sh`
- `profile-migration.test.sh`
- `profile-lifecycle.test.sh`
- `runtime-contract-hygiene.test.sh`
- `constitution-profile-context.test.sh`
- `experience-standard-amendment.test.sh`
- `profile-template-migration.test.sh`
- adapter coverage, generation, packaging, shipped-tree, readiness, Setup, and UX checks

The Profile and library validators passed for the replacement template. The changed
runtime-contract hygiene scan found no prohibited development-history identifiers or unrequested
implementation-detail leakage in the Profile, Setup, or retained template paths. `git diff --check`
passed.

The fixture matrix covers all five Profile domains, valid/incomplete/bounded/empty state examples,
schema versions, owner readiness outcomes, malformed response ordering, context presence/absence and
precedence, participation declarations, no-op persistence, interaction composition, runtime hygiene,
and generated dependent correspondence.

Disposable Profile validation evidence: valid and incomplete fixtures returned success; malformed
metadata and unsupported schema `3.0.0` fixtures failed as expected. The correspondence check and
`git diff --check` both returned success.

The complete `run-all.sh` suite was run with the extended execution budget because the constitution
inventory probe harness is intentionally exhaustive. It completed successfully with 60 tests passed
and 0 failed, including the direct `constitution-inventory.test.sh` validation.
