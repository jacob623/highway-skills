# Discovery Option Review Contract

## Scope

This contract defines the user-facing and persistence behavior added to the Discovery workflow. It
extends Discovery analysis without changing the ADR decision boundary.

## Supported interactions

```text
Describe OPT000001
Review OPT000001
Compare OPT000001 and OPT000002
Show implementation examples for OPT000001
Show implementation costs for OPT000001
```

Equivalent natural-language requests are supported only when they resolve to the same unambiguous
intent and option identifiers.

## Option review response

A valid one-option review MUST contain these sections in this order:

```text
Summary
Request Alignment
Objective Alignment
Control Alignment
NFR Alignment
Benefits
Risks
Assumptions
Dependencies
```

The response MUST identify the reviewed `OPT######`, state that it is advisory, and distinguish
accepted alignment evidence from unavailable evidence.

## Comparison response

A valid comparison MUST:

- resolve exactly two distinct options from the same Discovery;
- preserve the existing option evidence and comparison meaning;
- identify both options clearly;
- remain advisory;
- avoid recalculating or changing candidate scores, ranking, recommendation, or tie-breaking.

A duplicate, malformed, unavailable, or cross-Discovery option reference MUST be rejected without
mutation.

## Implementation evidence

When evidence exists, Discovery may present:

```text
Example Reference Implementations
Example Realization Matrix
Example Cost Considerations
```

The realization matrix may use:

```text
| Product | Purpose | Key Capabilities | Estimated Cost |
```

Costs MUST be `Low`, `Medium`, `High`, a bounded range, or `Unknown`. Examples and costs MUST be
labeled advisory and MUST NOT imply procurement, implementation, architecture approval, or ADR
selection.

## Completion response

After initial Discovery analysis, completion guidance MUST include the recommendation and rationale,
state that the recommendation is advisory, and offer review actions such as:

```text
Describe OPT000001
Describe OPT000002
Compare OPT000001 and OPT000002
Show implementation examples for OPT000001
Show estimated costs for OPT000001
```

The guidance MUST state that the person evaluates options in Discovery and selects an option in ADR.

## No-write invariant

For every supported exploration interaction, before and after bytes remain unchanged for:

- the Discovery record;
- the Discovery catalog;
- all identifier counters;
- Request, Clarification, Profile, Objective, Control, NFR, and Reference Architecture inputs;
- ADR records and catalogs.

No identifier is allocated. No ADR is created or modified. No Discovery decision state is created.

## Advisory scoring invariant

Adding, removing, or reviewing implementation examples and cost considerations MUST NOT change:

- candidate generation;
- candidate scores;
- recommendation scores;
- option ranking;
- recommendation tie-breaking;
- ADR option selection.

Implementation evidence MAY be cited in Recommendation Rationale when it materially improves
explainability, but the Recommendation remains advisory.

## Ownership boundary

Discovery owns candidate generation, comparison, scoring, recommendation, option review,
implementation example exploration, and cost exploration. ADR owns explicit option selection,
decision rationale, consequences, and architecture commitment.
