# Direct Invocation Guard Contract

Feature 177 defines the entry contract for the two existing source-producing workflows. It does not replace their architecture or implementation output contracts.

## Architecture Invocation

```text
/highway-architecture ADR000001
```

The invocation MUST contain exactly one explicit uppercase `ADR######` identifier.

When the identifier is missing, emit exactly this request shape before processing:

```text
Next Action: Provide the Architecture Decision Record to use.

Which ADR would you like to convert into a Reference Architecture?

Examples:
- ADR000001
- ADR000002
```

The missing-input path allocates no identifier, creates no Reference Architecture, and selects no ADR automatically.

Before processing an explicit identifier, validate identifier format, artifact existence, unique resolution, canonical completeness, and canonical readiness. Invalid, missing, duplicate, ambiguous, malformed, incomplete, or not-ready sources stop without writes and identify the blocking source condition.

## Implementation Invocation

```text
/highway-implementation ARCH000001
```

The invocation MUST contain exactly one explicit uppercase `ARCH######` identifier.

When the identifier is missing, emit exactly this request shape before processing:

```text
Next Action: Provide the Reference Architecture to implement.

Which Reference Architecture would you like to use?

Examples:
- ARCH000001
- ARCH000002
```

The missing-input path allocates no identifier, creates no Reference Implementation, and selects no architecture automatically.

Before processing an explicit identifier, validate identifier format, artifact existence, unique resolution, canonical completeness, and canonical readiness. Invalid, missing, duplicate, ambiguous, malformed, incomplete, or not-ready sources stop without writes and identify the blocking source condition.

## Shared Prohibitions

Neither guard may select a source using:

- newest or only available record
- filesystem order
- timestamps
- recency
- context inference
- environment state
- session memory

Both guards preserve the available `REQ -> DISC -> ADR -> ARCH -> RI` traceability chain and leave every pre-operation source, output, and catalog byte unchanged on failure.

## Ownership Boundary

After a valid source passes the guard, the existing owning workflow continues. Architecture still owns conceptual architecture creation; implementation still owns implementation realization. Feature 177 does not create plans, tasks, executable source code, infrastructure definitions, deployment authorization, or productization artifacts.
