# Data Model: Controls and NFR Review Output Contracts

Feature 078 introduces no new persistent entity. It makes the existing disposable proposal/review state and accepted-artifact projections explicit.

## Disposable Proposal State

- **Owner:** Control onboarding.
- **Fields:** category, submitted statement, deterministic advisory Proposed Title, collection order, and review decision.
- **Identity:** session-local position; no Control identifier.
- **Valid decisions:** Accept, Modify, Replace, Remove, or undecided before completion.
- **Persistence:** no proposal content, generated title, identifier allocation, or onboarding state before successful Control `Review Complete`.
- **Empty output:** `Status: Empty`, `Entry Count: 0` when no proposed Controls exist.

## Control Review Output Entry

- **Owner:** canonical Control skill.
- **Fields:** Category, Proposed Title, Statement, and Available Decisions.
- **Decision set:** Accept, Modify, Replace, Remove.
- **Ordering:** collection order remains stable through review and re-rendering.
- **Write boundary:** successful `Review Complete` only; the approved Control set is persisted atomically.

## NFR Candidate Review Output Entry

- **Owner:** canonical NFR skill.
- **Fields:** Candidate Title, Candidate Statement, Candidate Rationale, Originating Control Identifier, Originating Control Title, and Available Decisions.
- **Decision set:** Accept, Modify, Replace, Reject.
- **Ordering:** persisted originating Control identifier, then availability, security, performance derivation order.
- **Empty output:** `Status: Empty`, `Entry Count: 0` when no candidates exist.
- **Write boundary:** successful NFR `Review Complete` only; accepted candidates persist atomically with identifier-only Control relationships.

## Readiness projection

Readiness consumes accepted governance artifacts, not transient proposals or candidates. A successful NFR `Review Complete` is reflected by later readiness evaluation. Cancellation, rejection, validation failure, allocation failure, duplicate-detection failure, and write failure leave readiness-consumed accepted artifact state unchanged.

## Duplicate-failure invariant

Existing NFR duplication is detected before NFR creation and identifier allocation. A duplicate-detection failure performs no partial NFR write and preserves candidate state, existing NFR artifacts, catalog state, and relationship state.
