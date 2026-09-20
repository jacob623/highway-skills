# Recommendation Tie-Break Contract

## Trigger

Apply this contract only when two or more Candidate Solution Options have identical Recommendation
scores after score calculation and Reference Architecture evaluation.

## Ordered Criteria

Evaluate criteria in this exact order:

1. Reference Architecture Match
2. Reference Implementation Count
3. Lowest Discovery-scoped `OPT` identifier

Options with one or more Reference Architecture matches outrank options with no matches. Stop
immediately when a criterion selects one option; do not evaluate later criteria.

## Count Rule

For an option with multiple matched Reference Architectures, use the highest unique Reference
Implementation Count among those matches. If implementation data is absent or unreadable, every
affected count is zero.

## Invariants

- Recommendation score values remain unchanged.
- Recommendation confidence remains unchanged.
- Recommendation rationale remains advisory and does not become an ADR decision.
- ADR exclusively owns selected and rejected options, acceptance, rationale, consequences,
  decisions, and implementation authorization.
- Identical declared inputs and baselines produce identical tie-break outcomes.
