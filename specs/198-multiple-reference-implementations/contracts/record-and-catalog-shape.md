# Contract: Records and Catalogs

## Decision handoff

```markdown
## Reference Architecture Handoff

Architecture Direction: <direction, or `None`>
Required Architecture Work: <work list, or `None`>
Reference Architecture: <RA id, or `None`>
Authorization to Proceed: Proceed to Reference Architecture; do not implement.
```

No implementation entry. The decision catalog row includes Architecture ID.

## Architecture additions

```markdown
## Current Decisions

- ADRXXXXXX

## Information

<what this architecture handles, who owns it, and what crosses a trust boundary, or `None`>

## Variation

Must Keep: <what every implementation must keep>
May Choose: <what an implementation may choose, or `None`>

## Responsibilities

- <a responsibility a realization covers or marks not applicable>
```

Each logical component has `Responsibility` and `Interface`. Context has applicability and what is left open. Style has why it was chosen. Relationship lines are `- OBJXXXXXX: advances`, `- CTLXXXXXX: bound by`, and `- NFRXXXXXX: satisfies`. There is no `Key Technologies` section and no `ARCH` id. Status is `accepted`.

The architecture catalog ADR ID cell is `ADR11111111, ADR22222222` in id order, or one id when only one current decision names it.

## Implementation additions

```markdown
## Variation Choices

- <what the architecture left free>: <the choice this implementation made>

## Coverage

| Responsibility | Status |
|---|---|
| <architecture responsibility> | covered or not applicable |

Conformance: compatible or incomplete

## Realized Interfaces

- <architecture interface>: <realized interface>

Conformance Evidence: <how conformance was shown, or `None`>

## Limitations

<limitations of this accepted realization, or `None`>
```

The parent id is an `RA` id. Status is `accepted`. The architecture is named once. A technology choice appears once. A compatible record has no gap section and no conflict section.

The implementation catalog allows the same Architecture ID on more than one row.
