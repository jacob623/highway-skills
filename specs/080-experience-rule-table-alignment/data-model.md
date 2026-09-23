# Feature 080 Data Model

This feature has no runtime data model. It defines stable document records and validation concepts used by governance reviewers and shell checks.

## X2 Interaction Rule Row

| Field | Definition | Validation |
|---|---|---|
| `ID` | One of `X2.1` through `X2.6` | Each ID appears exactly once as a row in the X2 table. |
| `Rule` | The approved normative obligation from Feature 079 | Must not be duplicated as a second normative definition outside the table. |
| `Observable` | The approved review evidence for the rule | X2.3/X2.4 terminology agrees with the Definitions subsection. |
| `Tier` | Current enforcement tier | X2.2-X2.6 remain `[agent-checkable]`. |
| `Sample` | Existing sample count/value | Preserved from Feature 079. |

**Relationship**: Six rows form the X2 Interaction table. X2.2-X2.6 are the corrected rows; X2.1 remains unchanged.

## Workflow Definition

Named applicability terms in the Definitions subsection:

- **Interactive Workflow**: Existing definition retained.
- **Guided information-collection workflow**: An Interactive Workflow whose primary purpose is collecting user-provided evidence, answers, decisions, approvals, confirmations, or other required inputs.
- **Long-running activity**: Existing definition retained.
- **Implementation details**: Information describing workflow ownership, routing, validation logic, evaluation order, allocation logic, internal processing, orchestration, or similar internal mechanics.

**Validation rules**: A workflow may be Interactive without being guided information collection; accepting a response alone does not establish the guided class. Implementation details remain permissible when explicitly requested under X2.3.

## N/A Example

A non-normative example record with fields `Scenario` and `Example`.

**Required state**: A read-only status workflow emits no intermediate activity and records `X2.5=N5` and `X2.6=N5`. It is not placed under compliant or non-compliant headings and introduces no new verdict, rule, or condition token.

## State Transitions

None. This amendment changes document representation and validation evidence, not workflow runtime state.
