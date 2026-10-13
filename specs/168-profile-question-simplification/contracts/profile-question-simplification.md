# Contract: Profile Question-Bias Simplification

This contract describes the static source-document properties required by Feature 168. It does not claim to prove runtime conversational behavior.

## Source Guidance

The authoritative Profile skill must:

- direct grounded advisory reasoning into an active Discovery Contribution Opportunity's structured starting point;
- reserve advisory questions for unsupported starting points or unresolved consequential ambiguity;
- preserve canonical fallback questions and direct ambiguity clarification;
- remove the instruction to use advisory additions to explain an additional question;
- retain the Contribution in practice section and its unsupported-reasoning counter-example;
- remove the three question-centric worked examples;
- express structure, implications, tradeoffs, and possibilities inside the proposed starting point when one is active;
- permit reaction through the active Discovery Contribution Opportunity without requiring an extra closing question;
- state the proposal-first interpretation preference in Interpretation Confidence.

## Protected Boundaries

The contract must continue to preserve:

- the shared `**What would you add, correct, or remove?**` reaction invitation;
- provisional status before convergence;
- existing domain convergence and acceptance boundaries;
- Profile persistence, readiness, ownership, attribution, and retained schema behavior;
- no new lifecycle state, persisted artifact, readiness dimension, or runtime service.

## Generated Correspondence

Each generated Profile adapter must compare byte-for-byte with `.highway/skills/highway-profile/SKILL.md`. Catalog and adapter-manifest artifacts must be regenerated after the source change.
