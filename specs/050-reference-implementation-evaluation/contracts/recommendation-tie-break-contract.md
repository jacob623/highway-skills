# Recommendation Tie-Break Contract

## Trigger

Apply this contract only when two or more Candidate Solution Options have identical Recommendation scores.

## Ordered Criteria

Evaluate criteria in this exact order:

1. Reference Architecture Match
2. Reference Implementation Count
3. Lowest Discovery-scoped `OPT` identifier

The earlier criterion wins. Stop immediately when a criterion selects one option. Do not evaluate later criteria after resolution.

## Reference Implementation Count Rule

For an option with multiple matched Reference Architectures, use the highest unique Reference Implementation Count among those matches. If the authoritative catalog is absent or unreadable, every count is zero.

## Invariants

- Recommendation score values remain unchanged.
- Recommendation confidence remains unchanged.
- Recommendation rationale remains advisory and does not become an ADR decision.
- ADR exclusively owns selected and rejected options, acceptance, rationale, consequences, decisions, and implementation authorization.
- Equal counts use the lower `OPT` identifier.

## Determinism

Identical Requests, Discovery inputs, governance context, Reference Architecture baselines, and Reference Implementation baselines produce identical tie-break outcomes.
