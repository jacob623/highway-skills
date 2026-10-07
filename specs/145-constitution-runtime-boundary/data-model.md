# Data Model: Constitution Runtime Boundary

## Governance Layer

- **Layer 0**: Highway Development Constitution; governs how the Highway project is built, tested, packaged, generated, and separated from runtime artifacts.
- **Layer 1**: Highway Skills Constitution; validates the design and validity of shipped skills and shared runtime contracts during development.
- **Layer 2**: Highway Experience Standard; governs runtime user-visible interaction.
- **Relationship**: dependencies flow from Layer 0 to Layer 1 to Layer 2 and skills for validation/context, with no runtime dependency from Layer 2 or skills back to Layer 1.

## Shipped Runtime Contract

- **Purpose**: A skill contract or shared runtime contract validated by the Layer 1 Constitution.
- **Attributes**: owning skill or workflow, declared inputs, outputs, domain semantics, operational behavior, persistence boundary, failure behavior, and applicable Experience rules.
- **Validation**: the Constitution checks that ownership and delegation are explicit; the runtime owner executes the contract without loading the Constitution.

## Determinism Classification

- **Contractual/authoritative**: state, mutation, persistence, ownership, routing, readiness/domain state where specified, identifiers, artifact structure, output contracts, destructive actions, declared outcomes, and contractually deterministic generated/persisted content.
- **Advisory/non-authoritative**: interpretations, connections, implications, possibilities, alternatives, tradeoffs, challenges, concerns, recommendations, explanations, examples, and conversational phrasing.
- **Validation**: the first class requires deterministic criteria where the contract requires it; the second permits bounded adaptive variation.

## Context Declaration

- **Purpose**: The set of declared information sources that can influence a shipped skill.
- **Attributes**: source path, role, ownership, availability behavior, and precedence against workflow/user input.
- **Validation**: `highway-identity.md` is contextual and non-normative; retired Vision and Platform Objectives sources are not Constitution dependencies; user-owned or accepted artifacts remain owner-controlled.

## Downstream Runtime Reference

- **Purpose**: An existing artifact that still relies on Constitution-owned runtime behavior or retired context sources.
- **Attributes**: artifact path, referenced concept, current owner, required follow-up owner, and migration status.
- **Validation**: references are reported for follow-up; this feature does not rewrite the downstream artifact or create a replacement shared runtime contract.

## Amendment Record

- **Purpose**: The Constitution's Sync Impact Report and self-application evidence.
- **Attributes**: old/new version, classification, changed principles/rules/definitions, retired rule IDs, preserved IDs, validator impact, and self-application results.
- **Validation**: the record accounts for every removed or redefined rule and preserves stable surviving identifiers.
