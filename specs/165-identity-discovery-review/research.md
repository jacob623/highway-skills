# Research: Identity Discovery Contribution Opportunity

## Decision 1: Keep `highway-profile` as the behavior owner

The existing source skill already owns Identity acquisition, evidence handling, Contribution Opportunity,
convergence, acceptance, persistence, and readiness. Feature 165 extends that local contract rather than
moving behavior into Setup, Discovery, Clarify, or shared governance.

**Consequence**: Edit `.highway/skills/highway-profile/SKILL.md` and regenerate adapters. Do not change
neighboring skills or shared governance documents.

## Decision 2: Make the review transient

The review is a proposed interpretation of discovery evidence. Findings, corrections, additions,
removals, combinations, and splits remain transient until the user accepts the normal Identity Converged
Proposal. The review is not a second retained Profile artifact and does not add a schema field.

**Consequence**: The existing accepted-narrative-only persistence and Profile readiness contract remain
unchanged.

## Decision 3: Use a correction and re-synthesis loop

The initial review is presented as a Contribution Opportunity. A meaningful correction changes the
proposed evidence, after which Profile re-synthesizes and re-presents the updated review. Profile stays
in review while meaningful changes continue and transitions only after the review is stable. A stable
review then enters the existing convergence and acceptance flow.

**Consequence**: The implementation must distinguish review, correction, re-synthesis, stability, and
final proposal instead of treating the first review as a Converged Proposal.

## Decision 4: Add focused static contract coverage

The repository validates documentation-defined behavior with Bash contract tests. A new
`.highway/tools/tests/feature-165-identity-discovery-review.test.sh` will assert the required headings,
examples, correction-loop terms, protected persistence boundary, setup repository-name guidance, and
byte-identical generated adapters.

**Consequence**: No runtime harness or external API contract is needed. The new test must remain Bash
3.2-compatible and be included by the existing test runner convention.

## Decision 5: Regenerate, never hand-edit, adapters

`.highway/skills/highway-profile/SKILL.md` is the source consumed by
`.highway/tools/generate-agent-adapters.sh`. The generated copies under `.github`, `.claude`, `.cursor`,
and `.agents` are derived outputs.

**Consequence**: Run the generator after the source and focused test changes; validate correspondence in
the focused and full suites.

## Non-decisions

- No new external API, CLI wire format, service, package, schema, or durable review store.
- No change to the Experience Standard, Highway Identity, Constitution, Profile template, Setup, or
  retained Profile artifact.
- No separate `contracts/` directory because the behavior is an internal skill-document contract.
