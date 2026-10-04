# Feature 120 Quickstart

## Prerequisites

Run from the repository root on macOS. No package installation or external service is required. The authoritative source is `.highway/governance/experience-standard.md`.

This amendment must not modify Profile, Objectives, Controls, NFRs, Setup, Highway Identity, or `.highway/library/templates/output/profile-record.md`.

## Baseline Checks

Before implementation, run the existing affected contracts:

```sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/feature-092-contract.test.sh
```

Record the current Experience Standard version, X2.8 wording, rule count, and baseline result before changing the source.

## Focused Feature Checks

The implementation should verify:

- Conversational Voice appears after Contextual Guidance and before Constructive Advisory.
- First-person examples are explicitly non-normative and use “me,” “I,” or “we” for immediate interaction while product and governance references retain “Highway.”
- X2.8 remains `[agent-checkable]` with its identifier stable and its obligation/Observable strengthened.
- The former acknowledgment-restriction wording is absent from the source and affected checks.
- Contextual Guidance distinguishes required acknowledgment from optional Constructive Advisory.
- The Interaction model acknowledges meaningful accepted changes before recommendation evaluation and preserves one-question behavior.
- Constructive Advisory and continuous-conversation guidance remain non-normative.
- The recommendation-set example uses non-transactional accuracy language.
- X1.7, X2.4, X2.7, X2.9, X2.13, X2.33, X2.34, and X2.35 remain intact.
- Profile, Objectives, Controls, NFRs, Setup, Highway Identity, and shared output templates have no diff.

## Version and Self-Application Checks

Confirm the authoritative source currently reports `6.0.0`; then verify the amendment record classifies the X2.8 redefinition as MAJOR and the footer becomes `7.0.0`. Confirm the rule inventory remains 39, X2.8 remains stable, and the required self-application review is present.

## Full Validation

```sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/feature-092-contract.test.sh
bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: all affected contracts and the full suite pass with zero failures, and no whitespace errors are reported.

## Scope Review

Review the final diff. It should contain the authoritative Experience Standard, directly affected Experience Standard checks/fixtures/examples/snapshots/version records, and Feature 120 design artifacts only. Do not regenerate or edit individual skill contracts as part of this amendment.

## Feature 120 Execution Evidence

- Baseline focused contracts passed before implementation: Experience Standard amendment, UX alignment, and Feature 092 compatibility.
- Test-first checkpoint: new Feature 120 assertions failed before the source amendment on missing Conversational Voice, strengthened X2.8, continuity, and 7.0.0 metadata.
- Focused implementation contracts pass: Experience Standard amendment, UX alignment, Feature 092 compatibility, and the preserved X2.3 interaction contract.
- X2.8 remains stable at 39 rules and `[agent-checkable]`, with the acknowledgment obligation and Observable redefined for meaningful accepted changes.
- First-person Conversational Voice, optional Constructive Advisory, continuous-conversation guidance, non-normative examples, and less-transactional recommendation wording are covered.
- Preserved behavior checks pass for one-question interaction, Decision Context, grounding, recommendation ordering, completion synthesis, machine-result suppression, and Profile compatibility.
- Protected paths remain unchanged: individual skills, Highway Identity, and `profile-record.md`.
- No external contracts or runtime storage were introduced; no `contracts/` directory is required.
- Final full suite result: `62 passed, 0 failed`.
- Final scope and whitespace checks pass with `git diff --check`.
