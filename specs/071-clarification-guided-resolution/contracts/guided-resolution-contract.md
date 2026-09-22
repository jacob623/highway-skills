# Guided Resolution Contract

## Command Surface

The existing command forms remain authoritative:

- `/highway-clarify <ARTIFACT-ID>` generates guidance.
- `/highway-clarify update <ARTIFACT-ID>` records selection or an explicitly accepted response.
- `/highway-clarify inspect <ARTIFACT-ID>` reports status and counts without writing.
- `/highway-clarify read <ARTIFACT-ID>` returns the complete validated record without writing.
- `/highway-clarify status <ARTIFACT-ID>` returns the lightweight consumer response without writing.

## Finding Guidance Output

Every finding exposes the existing identity, state, evidence, summary, and response fields plus:

- `Question`
- `Why It Matters`
- `Recommended Option`
- `Recommended Rationale`
- `Alternative Option B` and rationale
- `Alternative Option C` and rationale
- `Custom Option`
- `Selected Option`, default `None`
- deterministic evidence-source traceability

Generated option order is exactly A Recommended, B Alternative, C Alternative, D Custom.

## Recommendation Rules

Evaluate only the declared artifact-specific sources in global precedence order. The first
available precedence level supports the recommendation. If no evidence is available, recommend
`Unknown` with an evidence-gap rationale. If multiple values conflict at the highest available
precedence, recommend `Unknown / Escalate for Decision`, record the conflicting source references,
place the values in B and C, explain the conflict, and require explicit selection A, B, C, or D.
Do not use semantic similarity, model preference, external knowledge, architectural taste,
unstated assumptions, or filesystem ordering.

## Update Rules

`Selected Option` accepts only A, B, C, D, or None and is informational. A selection, generated
option, or Custom candidate never resolves a finding. An explicitly accepted response may perform
only `open -> resolved`; resolved findings cannot reopen. All guidance and history remain retained.

## Failure and Ownership Rules

Invalid records, unsupported states, count mismatches, invalid selections, privacy violations,
conflicts, and validation failures write nothing. Source artifacts are byte-for-byte unchanged.
Clarification does not select for the user, mutate source artifacts, approve governance or
architecture, select recommendations, or decide ADR outcomes.
