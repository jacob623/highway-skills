# Feature 157 Data Model

This feature does not add persisted data or change a runtime schema. The model below describes the reusable interaction elements and their relationships in the Profile guidance.

## Response Support Elements

| Entity | Meaning | Required content | Relationship |
|---|---|---|---|
| Validation Question | The emphasized request used when reviewing a candidate or Converged Proposal. | Default asks what to add, correct, or remove; a sharper question may replace it only if it keeps that purpose. | Appears beneath the candidate and before applicable reassurance. |
| Acceptance Reassurance | Support for confirming a candidate or Converged Proposal. | `If this is accurate, just say so.` | Used beneath the Validation Question when the person is reacting to a candidate or Working Idea and uncertainty is unnatural. |
| Discovery Reassurance | Support for originating unresolved organizational information. | `If you don't know, say "I don't know" and we'll work through it together.` | Used only when no meaningful starting point has been supplied for reaction. |
| Combined Reassurance | Support for interactions where confirmation and uncertainty are both reasonable. | Acceptance Reassurance followed by Discovery Reassurance. | Selected when both outcomes are reasonable. |

## Context Entities

| Entity | Meaning | Validation rule |
|---|---|---|
| Candidate / Converged Proposal | Profile material presented for review under the existing capture heading. | The Validation Question is beneath it; the question is the only emphasized element in the review block. |
| Working Idea | Transient accepted-context reasoning or possibility available for reaction before acceptance. | A grounded Working Idea counts as a meaningful starting point and suppresses Discovery Reassurance when the person is reacting to it. |
| Meaningful Starting Point | Grounded material already supplied for reaction. | Includes grounded possibilities, interpretations, distinctions, implications, connections, tensions, tradeoffs, recommendations, and other Working Ideas. |
| User Substantive Contribution | User information that changes active understanding. | Imported website evidence does not qualify as one. Its absence alone does not select Discovery Reassurance. |

## Relationships and Selection Rules

1. A candidate or Converged Proposal is rendered under its existing capture heading.
2. The Validation Question follows the candidate.
3. Exactly one applicable reassurance follows the Validation Question: Acceptance, Discovery, or Combined.
4. Discovery Reassurance is eligible only when the person is originating unresolved information and no meaningful starting point exists.
5. Acceptance Reassurance is preferred when the person is reacting to a candidate or Working Idea and `I don't know` would be unnatural.
6. Combined Reassurance is eligible when both confirmation and uncertainty are reasonable outcomes.
7. Existing advisory reasoning, structure-revealing contributions, possibility lists, convergence, acceptance boundaries, and domain reasoning remain outside this model and unchanged.
