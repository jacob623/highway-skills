# Feature 089 Data Model

This feature has no runtime database or external API. Its data model is the set of governed document concepts and review records.

## Retained Output

- **Fields**: declared artifact or repository state; declared location or persisted-state condition; output-state contract.
- **Relationships**: owned by a skill workflow; covered by zero or one Completion Claim; checked by Persistence Verification.
- **Validation**: a Verified Completion Claim covers only outputs that pass verification. A workflow with no Retained Output records persistence rules as N/A under N6.

## Persistence Verification

- **Fields**: post-write verification result; covered Retained Output; evidence of declared location or persisted-state condition.
- **Relationships**: occurs after owner mutation and before a Verified Completion Claim; failure produces a non-success outcome.
- **Validation**: every Retained Output covered by one claim must pass. Failure names the unverified output.

## Completion Claim and Verified Completion Claim

- **Completion Claim**: a user-visible or machine-consumable successful-completion statement.
- **Verified Completion Claim**: a Completion Claim permitted only after every covered Retained Output passes Persistence Verification.
- **State transitions**: owner mutation -> verification -> verified claim or non-success result -> orchestrator consumes the owner result.

## Informed Experience Concepts

- **Decision Context**: concise explanation of a downstream recommendation, decision, artifact, governance interpretation, or workflow action.
- **Relevant Example**: illustrative response-form guidance that does not constrain user-owned content.
- **Presentation Label**: short label identifying the meaning or role of an adjacent value in Structured Information.
- **Structured Information**: two or more named fields, properties, statuses, relationships, options, or values presented together for review or decision-making.
- **Contextual Acknowledgment**: concise continuation guidance governed by X2.8 when information has Material Influence.

## Review Conditions

- **N6**: no Retained Output; registered only in the Constitution and applied per persistence obligation.
- **N7**: no Decision Context trigger or the implication was just established.
- **N8**: no Relevant Example clarifies response form.
- **N9**: no Structured Information is emitted.

N/A conditions are review records, not runtime data. The Constitution is the authoritative registry for N6-N9; the Experience Standard references IDs only.
