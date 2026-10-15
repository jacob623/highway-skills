# ADR Explicit Selection Contract

## Invocation

Creation requires exactly:

```text
/highway-adr DISC000001 OPT000001
```

The Discovery identifier must match `DISC######`. The option identifier must match `OPT######` and must exist within that Discovery. More than one Discovery or option identifier is invalid.

## Missing option

For a valid Discovery without an option, ADR returns:

```text
Architecture Decision Required

Discovery:
DISC000001

Available Options

OPT000001
<summary>

OPT000002
<summary>

Recommended:
OPT000001

Which option would you like to select?
```

The recommendation is advisory. This response allocates no ADR identifier and writes no ADR or catalog bytes.

## Unsupported option

If the option does not exist within the supplied Discovery, ADR aborts before allocation and publication. Existing ADR, catalog, Discovery, and governance bytes remain unchanged.

## Successful selection

The retained ADR records:

```text
Selected Option: OPT000001
Selection Source: User-provided explicit selection
```

The selected option may differ from the Discovery recommendation. ADR retains recommendation evidence as advisory context and does not recompute scores, rank options, or select a fallback.

## Ownership boundary

Discovery owns candidate generation, scoring, comparison, recommendation, and recommendation rationale. ADR owns explicit option selection, decision rationale, consequences, and architecture commitment.

## No-write invariant

Missing, malformed, ambiguous, unsupported, duplicate, unavailable, or non-accepted input stops before identifier allocation and preserves every pre-operation byte.
