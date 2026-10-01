# Quickstart: Amend Experience Standard

Validate the amended Experience Standard and its repository review. This does not exercise a live Setup conversation. Skill alignment is a later change.

## Prerequisites

- Repository root is the Highway skills repository.
- No implementation edit has been made yet, or the implementation is ready for a full review.
- `.highway/tools/tests/run-all.sh` can write temporary directories.

## Before editing

Run the full suite and confirm it exits 0:

```sh
.highway/tools/tests/run-all.sh
```

Update the three review files in [contracts/repository-review-checks.md](./contracts/repository-review-checks.md) before editing `.highway/governance/experience-standard.md`. Then run:

```sh
.highway/tools/tests/highway-ux-alignment.test.sh
.highway/tools/tests/experience-standard-amendment.test.sh
.highway/tools/tests/feature-092-contract.test.sh
```

Expected before the standard is amended: each updated assertion fails because the document still has the 4.0.0 contract. Record that failure before continuing.

## After editing

Confirm the shipped document matches [contracts/experience-standard-amendment.md](./contracts/experience-standard-amendment.md):

- Version footer is `5.0.0`, ratified `2026-09-08`, last amended `2026-10-01`.
- One Sync Impact Report records `4.0.0 → 5.0.0 (MAJOR)`.
- X1.7 and X2.9 use the question-before-explanation contract.
- X2.13 and X2.25 keep their rule sentences and use the new observables.
- X2.32 through X2.35 are present and `[agent-checkable]`.
- Preserved rows named in [data-model.md](./data-model.md) are unchanged.
- The document does not contain `.specify/` or `specs/`.
- No skill, output template, or other governance baseline differs.

Re-run the three review commands. Expected: each exits 0.

Re-run:

```sh
.highway/tools/tests/run-all.sh
```

Expected: exit 0. The passing baseline is the 5.0.0 contract, not the superseded 4.0.0 contract.

## Failure signs

- A review still requires `3.0.0 → 4.0.0 (MAJOR)` or the former X1.7 or X2.9 sentence.
- A review accepts both the old and new X1.7, X2.9, or X2.13 wording.
- The Experience Standard or a skill references a review test as a runtime dependency.
- A skill `version: 4.0.0` assertion was changed even though the skill was not part of this amendment.
