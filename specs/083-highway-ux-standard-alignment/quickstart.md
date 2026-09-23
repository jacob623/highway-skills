# Quickstart: Highway UX Standard Alignment

## Prerequisites

Run from the repository root with macOS Bash 3.2-compatible shell tooling available. No new package or runtime dependency is required.

## Focused UX alignment test

After implementation, run:

```sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
```

Expected result: the test exits `0` and reports that the single Experience Standard contract, all eight in-scope skill references, applicable progress fields, outcome/resume vocabulary, ownership boundaries, and negative duplicate-authority probes pass.

## Full repository validation

```sh
.highway/tools/tests/run-all.sh
git diff --check
```

Expected result: the full test suite exits `0`; whitespace validation exits `0`; no generated catalog, adapter, or distribution-manifest correspondence failure is reported.

## Manual contract review

1. Read the Interactive Workflow UX Contract in `.highway/governance/experience-standard.md` and confirm X2.2-X2.6 normative text is unchanged.
2. Inspect the eight skill files listed in [plan.md](plan.md) and confirm each has a valid direct contract reference and only applicable workflow fields.
3. Confirm Profile, Objectives, Controls, NFRs, New, and Clarify expose one unresolved collection question or decision at a time.
4. Confirm Discovery and ADR retain their non-wizard/domain-specific behavior and use activity-focused messages where applicable.
5. Confirm Help and Relationships have not acquired guided-collection requirements.
6. Confirm each in-scope skill declares one Resume Applicability state and distinguishes User Exits from Owner Outcomes.

## Failure interpretation

- A contract uniqueness failure indicates a second authoritative copy or a missing Experience Standard section.
- A missing-field failure indicates that a skill's domain-specific progress contract is incomplete.
- An outcome/resume failure indicates unsupported persistence or category collision in user-facing wording.
- A correspondence failure requires following the repository's existing generator workflow before considering the feature complete.
