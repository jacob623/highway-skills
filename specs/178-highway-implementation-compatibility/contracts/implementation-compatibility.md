# Implementation Compatibility Contract

Feature 178 adds a compatibility gate to the direct implementation workflow.

## Invocation Inputs

The workflow receives:

```text
/highway-implementation ARCH######
Implementation Selections: 1..N
```

The `ARCH######` source remains explicit and accepted. Implementation Selections are user-owned and may be named components, services, frameworks, databases, products, middleware, infrastructure, provider services, or other building blocks.

Missing selections require a user-facing request and cause no allocation or RI write. The workflow must not infer selections from the newest, only, most common, or contextual technology.

## Assessment Contract

The workflow evaluates architecture-derived requirements before RI generation and emits exactly one result:

```text
Architecture Compatibility Assessment
Result: Compatible | Incomplete | Incompatible
```

The assessment includes a deterministic Coverage Summary for applicable categories:

```text
Compute | Messaging | Persistence | Identity | Networking
Security | Observability | Recovery | Deployment | Operations
```

Each category is `Satisfied`, `Unsatisfied`, or `Not Applicable`.

## Compatible

`Compatible` requires:

- all required architecture responsibilities are realizable;
- no selection contradicts explicit architecture intent;
- required Controls and NFR realization concerns are covered;
- every selection maps to one or more responsibilities or is explicitly resolved.

Only this result may continue to RI proposal generation.

## Incomplete

`Incomplete` means selections do not contradict architecture intent but required responsibilities remain unresolved. Each gap includes:

```text
Missing Capability
Why It Matters
Suggested Realization
Recommendation Confidence
```

The owner may accept a grounded recommendation, substitute an alternative, or add selections. A recommendation is `Unknown` where evidence is insufficient. No RI is generated until reassessment produces `Compatible`.

## Incompatible

`Incompatible` means at least one selection directly contradicts an explicit architecture requirement. Each conflict includes:

```text
Architecture Requirement
Implementation Selection
Conflict Explanation
```

The only available paths are:

```text
Resolve Implementation
Revisit Architecture
```

No RI is generated while the conflict remains unresolved. Architecture and ADR authority are never silently changed.

## Output Contract

A compatible RI record includes:

- Architecture Compatibility Assessment
- Coverage Summary
- Implementation Gaps
- Implementation Conflicts
- Implementation Selections
- Technology Realization Rationale

Technology Realization Rationale records each selected component, architecture responsibility, reason selected, and supporting evidence. Available `REQ -> DISC -> ADR -> ARCH -> RI` traceability is preserved.

## Failure Contract

Missing selections, unresolved gaps, conflicts, invalid source or selection data, failed assessment, validation, allocation, or persistence produce no new RI and preserve all pre-operation source, RI, and catalog bytes.

Identical declared inputs and source state produce identical result, ordering, coverage, recommendations, conflicts, gaps, and traceability.
