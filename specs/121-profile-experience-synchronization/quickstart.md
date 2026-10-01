# Feature 121 Quickstart

## Prerequisites

Run from the repository root on macOS. No package installation or external service is required. The authoritative source is `.highway/governance/experience-standard.md`.

This amendment must not modify individual skills, Profile or other domain artifacts, Highway Identity, shared output templates, or runtime files.

## Baseline

Before implementation, record the current 7.0.0 source and run the affected contracts:

```sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/experience-x23-contract.test.sh
bash .highway/tools/tests/feature-092-contract.test.sh
```

Confirm X2.8 rule text and Observable, all named preserved X-rule text and Observables, the current Conversational Voice heading, and the protected-scope baseline before editing.

## Focused Validation Scenarios

1. **Conversational section hierarchy**
   - Confirm `#### Conversational Voice (Non-Normative Guidance)` is a peer of `#### Conversational Presence (Non-Normative Guidance)` and `#### Constructive Advisory (Non-Normative Guidance)`.
   - Confirm Presence appears immediately after Voice and before Constructive Advisory.

2. **Conversational Presence**
   - Confirm guidance permits useful explanation, reflection, acknowledgment, connected ideas, multiple short paragraphs, and natural conclusion without requiring a question, recommendation, decision, or next action.
   - Confirm guidance adapts to complexity and requested detail without paragraph, sentence, word-count, or verbosity quotas.
   - Confirm filler, repetition, performative enthusiasm, unrelated commentary, and implementation detail remain discouraged.

3. **Conceptual distinction and interaction model**
   - Confirm Voice governs perspective, Presence governs conversational room, and Constructive Advisory governs intellectual contribution.
   - Confirm the interaction model permits the sequence to stop at any earlier point and states that one-question constraints do not require every response to contain a question.
   - Confirm Contextual Guidance includes acknowledgment when X2.8 applies, natural response, optional advisory contribution, and later workflow elements only when needed.

4. **Preservation**
   - Compare X2.8 and its Observable, X1.7, X2.3, X2.4, X2.5, X2.6, X2.9, X2.26, X2.33, X2.34, and X2.35 against the baseline.
   - Confirm the conversational-continuity example still shows contribution, acknowledgment, optional useful observation, and grounded continuation.
   - Confirm individual skills and protected shared artifacts have no diff.

## Full Validation

```sh
bash .highway/tools/tests/experience-standard-amendment.test.sh
bash .highway/tools/tests/highway-ux-alignment.test.sh
bash .highway/tools/tests/experience-x23-contract.test.sh
bash .highway/tools/tests/feature-092-contract.test.sh
bash .highway/tools/tests/run-all.sh
git diff --check
```

Expected result: all Feature 121-focused contracts pass and no whitespace errors are reported. The full suite currently reports 60 passed and 2 failures caused by the pre-existing protected `highway-identity.md` worktree modification; no Feature 121 contract fails.

## Version Review

The current authoritative version is 7.0.0. Because this feature adds and rationalizes non-normative guidance without changing existing normative rules or Observables, apply the existing Versioning Policy's applicable MINOR increment and update Last Amended metadata. If implementation changes a normative rule or Observable, stop and reclassify before proceeding.

## Scope Review

The final diff should contain `.highway/governance/experience-standard.md`, directly affected Experience Standard checks or version records, and Feature 121 design artifacts only. Do not update Profile, Objectives, Controls, NFRs, Setup, Highway Identity, shared output templates, or individual skills in this amendment.

## Implementation Evidence

- The authoritative Experience Standard is 7.1.0 MINOR with the Presence guidance, three-concept distinction, natural-conclusion guidance, and preserved X2.8 and named rule contracts.
- `experience-standard-amendment.test.sh`: the amendment assertions pass; the protected-scope assertion reports only the pre-existing `.highway/library/knowledge/highway-identity.md` modification.
- `highway-ux-alignment.test.sh`: PASS.
- `experience-x23-contract.test.sh`: PASS.
- `feature-092-contract.test.sh`: PASS.
- `run-all.sh`: 60 passed, 2 failed; both failures are attributable to the pre-existing Highway Identity modification (`constitution-profile-context.test.sh` and the protected-path check in `experience-standard-amendment.test.sh`).
- `git diff --check`: PASS.
- Final changed paths are the Experience Standard, its two directly affected test contracts, and Feature 121 design artifacts; no individual skill, Profile record, shared template, or new runtime contract was added.
