# Feature 036 Quickstart

## Prerequisites

Run from the repository root with a Bash 3.2-compatible shell. Confirm the active feature pointer resolves to `specs/036-feature-036`.

## Baseline

```sh
.highway/tools/tests/run-all.sh
```

Record the baseline separately before changing Feature 035 tests. The existing baseline was 33 passed and 0 failed.

## Profile Evidence

Run the focused Profile checks:

```sh
.highway/tools/tests/profile-structure.test.sh
.highway/tools/tests/profile-behavior.test.sh
bash .highway/tools/tests/profile-yaml.test.sh
bash .highway/tools/tests/profile-migration.test.sh
```

The remediated behavior checks must execute absent, empty, whitespace-only, valid, declined, malformed, and repeated-input fixture states. Report observed status, write/no-write behavior, before/after hashes, and deterministic output separately from static contract-text assertions.

## Workflow Variant Evidence

Run the Setup test:

```sh
.highway/tools/tests/highway-setup.test.sh
```

The test must validate the canonical workflow and temporary variants for missing, duplicate, non-sequential, and dangling step defects. Confirm the canonical skill hash is unchanged afterward.

## Candidate-Result Evidence

Run the candidate-result matrix through the Setup decision boundary. Verify:

- zero candidates -> `NFRs: Not Applicable`, Setup Complete, no NFR artifact;
- available candidates -> Missing or In Progress according to proposal state;
- accepted artifacts -> Complete;
- unavailable or malformed results -> Blocked and no fabricated artifact;
- three repeated identical runs -> identical outcomes.

## Distribution Documentation Check

Use a disposable target directory because the generator requires one positional argument:

```sh
target_dir="$(mktemp -d "${TMPDIR:-/tmp}/highway-distribution.XXXXXX")"
.highway/tools/generate-distribution.sh "$target_dir"
rm -rf "$target_dir"
```

A pre-created non-empty target not owned by the generator is expected to be rejected.

## Final Validation

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-profile
.highway/tools/validate-skill.sh .highway/skills/highway-setup
.highway/tools/validate-profile.sh .highway/library/templates/output/profile.yaml
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/run-all.sh
git diff --check
```

Report separately:

1. Executable Profile behavior evidence.
2. Canonical and malformed workflow-variant evidence.
3. Candidate-result-driven NFR evidence.
4. Static contract and validator results.
5. Generated-artifact and distribution results.
6. Remaining limitations.

## Feature 035 Documentation Updates

Update [Feature 035 plan](../035-profile-setup-readiness/plan.md) to list `.highway/tools/tests/test-helpers.sh` and `.highway/tools/tests/fixtures/feature-035/README.md`. Keep generator commands target-aware and distinguish checked-in manifest status from disposable distribution validation.

## Implementation Results

- Requirements checklist: 16 checked, 0 unchecked.
- Profile executable fixtures and focused Profile validators: PASS.
- Setup canonical workflow plus four malformed temporary variants: PASS; canonical bytes preserved.
- Candidate-result matrix, including contradictory zero-count input: PASS; routing coverage 20/20.
- Disposable distribution generation: PASS.
- Adapter correspondence: PASS.
- Full repository suite: 33 passed, 0 failed.
- `git diff --check`: PASS.

Evidence is reported by type: executable fixture behavior, static contract assertions, generated-artifact checks, and remaining limitations. The repository exposes Profile and NFR behavior as instruction contracts, so the executable tests use deterministic owner-compatible fixture evaluators rather than claiming to invoke a nonexistent runtime engine.
