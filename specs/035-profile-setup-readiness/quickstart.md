# Feature 035 Quickstart

## Prerequisites

- Run from the repository root.
- Bash 3.2-compatible shell is available.
- Existing Profile, Setup, Controls, and NFR skills and their validators are present.
- Feature 035 source and focused test paths are available.

## Baseline

Before editing source skills or tests, run:

```sh
.highway/tools/tests/run-all.sh
```

Record the passing result separately from Feature 035 coverage.

Baseline recorded for this implementation: `.highway/tools/tests/run-all.sh` passed with 33 tests and 0 failures before Feature 035 edits.

Expected failing-before-passing evidence: the initial Feature 035 Profile assertions failed because organization identity ownership was absent from `highway-profile`; the assertions passed after the Profile owner contract was updated. Setup workflow and candidate-state assertions are added and must show the same failing-before-passing sequence.

## Profile Readiness Validation

Run the focused Profile checks:

```sh
.highway/tools/tests/profile-structure.test.sh
.highway/tools/tests/profile-behavior.test.sh
.highway/tools/validate-profile.sh .highway/library/templates/output/profile.yaml
```

Verify absent, empty, whitespace-only, supplied, declined, and malformed organization identity states. Declined or malformed states must preserve Profile bytes.

## Setup Workflow Integrity

Run the focused Setup check:

```sh
PATH=/usr/bin:/bin:/usr/sbin:/sbin bash .highway/tools/tests/highway-setup.test.sh
```

Verify that Setup steps are numbered 1 through 10, unique, contiguous, and that every `Step N` reference resolves. Verify Setup consumes Profile-owner readiness without defining a second organization-name rule.

## NFR Candidate Validation

Exercise the candidate outcomes in [Feature 036 candidate-results.md](../036-feature-036/contracts/candidate-results.md):

- zero candidates -> `NFRs: Not Applicable`, terminal completion, no NFR write;
- available candidates -> proposal handling;
- pending proposal -> `NFRs: In Progress`;
- accepted artifacts -> `NFRs: Complete`;
- unavailable or malformed result -> `NFRs: Blocked`.

## Final Validation

After source changes, regenerate catalogs and adapters with the repository generators. The distribution generator requires a disposable target directory:

```sh
target_dir="$(mktemp -d "${TMPDIR:-/tmp}/highway-distribution.XXXXXX")"
.highway/tools/generate-distribution.sh "$target_dir"
rm -rf "$target_dir"
```

Then run:

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-profile
.highway/tools/validate-skill.sh .highway/skills/highway-setup
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/run-all.sh
git diff --check
```

Report separately:

1. Profile checks.
2. Setup workflow integrity.
3. Zero-candidate and other NFR outcome coverage.
4. Requirement coverage.
5. Generated-artifact and full-suite results.

Static contract-text assertions must be reported separately from executable fixture results. Negative workflow checks use temporary copies and must preserve the canonical Setup bytes.

## Requirement Traceability

| Requirements | Implementation tasks | Verification tasks |
|---|---|---|
| FR-001 through FR-005 | T008, T009, T012 | T010, T011, T013 |
| FR-006 through FR-009 | T014, T015 | T016, T017, T018, T019 |
| FR-010 through FR-014 | T020, T021 | T022, T023, T024, T025 |
| SC-001 through SC-002 | T008-T013 | T010-T013 |
| SC-003 | T014-T019 | T016-T019 |
| SC-004 through SC-007 | T020-T025 | T022-T025 |

## Implementation Results

- Profile structure, behavior, YAML, migration, skill, and Profile artifact validators: PASS.
- Setup workflow and NFR outcome matrix: PASS; routing coverage 20/20.
- Generated distribution verification: PASS; no development-only references, 7 cross-references resolved, 8 skills validated.
- Adapter correspondence: PASS.
- Full repository suite: 33 passed, 0 failed.
- `git diff --check`: PASS.
- `requirements.md`: 16 checked, 0 unchecked.
