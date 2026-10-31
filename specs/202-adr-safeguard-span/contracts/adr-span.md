# Contract: ADR Safeguard Span

Applies to `.highway/skills/highway-adr/SKILL.md` and the templates `adr-record.md`, `adr-catalog.md`, and `architecture-catalog.md`. See [data-model.md](../data-model.md) for the span rules.

## start: which proposal is shown

| Matches | Proposal |
|---|---|
| None | Stands on its own. A new architecture will follow. Unchanged |
| Exactly one | Replace-or-beside question. Unchanged |
| More than one, and the span applies | Span proposal. No single-architecture question |
| More than one, and the span does not apply | **Which architecture should this decision use?** Unchanged |

## Span proposal: Architecture line

**Architecture:** This decision runs beside the current decision of each of these architectures. None of those decisions is replaced, and no new architecture will follow.
- [Architecture title]

One bullet per architecture in the set, in id order, with no cap. After the Consequences, before **What would you add, correct, or remove?**, the proposal says in plain text:

If you'd like to leave out any of these architectures, just say so.

## Span proposal: replies

| Reply | Result |
|---|---|
| Removes architectures, two or more remain | One consequence sentence. Span proposal again with the smaller set |
| Removes architectures, one remains | One consequence sentence. The single-architecture proposal with **Does this decision replace [decision], or run beside it?** |
| Names an architecture that did not match | Not added. Span proposal again |
| `accept` | Go to `identifier` |
| `decline` | Stop. Write nothing |

## write

All of these are written together, or none:

1. `adrs/[ADR id].md`, with the span values in [data-model.md](../data-model.md).
2. The `adrs/adrs.md` row, whose Architecture ID lists every RA id in the set.
3. Each architecture record's `## Current Decisions`, with this ADR id added.
4. Each `architectures/architectures.md` ADR ID cell in the set, with this ADR id added.

No decision is superseded. No architecture is created.

## Entry

Case 4: when the Discovery already has an ADR, show it and write nothing. When its Architecture ID cell names more than one architecture, go to `close`.

## close for a span

The heading and fields stay as they are. Then:

- Name each architecture in the set that has no current implementation as not yet implemented.
- Then exactly one of:

| Situation | Emit |
|---|---|
| No current implementation in the set | Run `/highway-implementation [first RA id]` to create the Reference Implementation for **[Architecture title]**. |
| Every current implementation is covered | Every implementation in this decision already has an automation for **[Decision title]**. No codify step |
| One uncovered | Run `/highway-codify` for **[Implementation title]** to **[Decision title]**. |
| Two to five uncovered | `**1. [Implementation title]**` lines, then **Which implementation would you like to codify first?** |
| More than five uncovered | No list. **Which implementation would you like to codify first?** and a plain-text line saying they can give its title |

A picked or named uncovered implementation gives the one-uncovered line for it. A name outside the uncovered set is not offered, and the question is asked again.

## Templates

| Template | Change |
|---|---|
| `adr-catalog.md` | Architecture ID may list several RA ids, in id order, separated by a comma and a space, when one decision spans several architectures. `None` still means a new architecture will follow |
| `adr-record.md` | `Reference Architecture` lists the same ids as the catalog cell for a span |
| `architecture-catalog.md` | Keeps "An ADR id appears on at most one row." and adds that a span decision appears on the row of each architecture it names |

## Unchanged

- The non-span proposals, questions, and closes.
- One Discovery has one ADR.
- Discovery owns options, scores, and matches.
