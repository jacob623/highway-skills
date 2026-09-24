# Data Model: Seed Library Context Documents

## Seed Source Document

A temporary Markdown file at the repository root supplied for this feature.

| Field | Value |
|---|---|
| Identity | Exact filename at repository root |
| Allowed values | `highway-identity.md`, `highway-platform-objectives.md`, `highway-vision.md` |
| Lifecycle | Present before the copy; preserved by implementation; manually deleted by the maintainer afterward |
| Ownership | Repository maintainer |

## Library Context Document

A retained copy of one seed source document under the shared knowledge library.

| Field | Value |
|---|---|
| Identity | Same filename under `.highway/library/knowledge/` |
| Content | Byte-for-byte equal to its source document |
| Lifecycle | Created or converged during implementation; retained after root-source cleanup |
| Ownership | Repository maintainer and Highway knowledge library |

## Copy Mapping

The mapping is one-to-one and same-named:

| Source | Destination |
|---|---|
| `highway-identity.md` | `.highway/library/knowledge/highway-identity.md` |
| `highway-platform-objectives.md` | `.highway/library/knowledge/highway-platform-objectives.md` |
| `highway-vision.md` | `.highway/library/knowledge/highway-vision.md` |

## Invariants

- All three source files must be present before a complete copy is claimed.
- Every destination must compare byte-for-byte equal to its mapped source.
- Source bytes remain unchanged by the implementation.
- A destination with different bytes must converge to the source bytes or cause a clear failure; it must not remain mismatched after successful completion.
- Files outside the three mapped destinations are not modified.
- Deleting the root sources after success does not affect the library copies.

## State Transitions

```text
Source set present
  -> Preflight accepted
  -> Library copies created or converged
  -> Byte verification passed
  -> Root sources manually deleted later
  -> Library copies retained
```

If preflight finds a missing source, the flow stops before successful completion. If byte verification fails, the flow is unsuccessful and must report the affected mapping.
