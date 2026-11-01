# Contract: Provider and Diagram

## Draft

The Provider is the one platform that executes the automation. Every task names that same Provider. The implementation being automated is a target.

Choose it in this order:

1. The platform the person named.
2. This implementation, when it has a catalog row.
3. The first catalog row.
4. When the catalog is empty and the person named none, leave the Provider unset.

A named platform that is not in the catalog stays the Provider. Before the proposal, say: "[Platform] is not included as a platform that can start automation. To add it, run /highway-codify configure."

When the Provider is unset, the proposal says: "A platform that can start automation is needed. Run /highway-codify configure." Accept stays on `propose`. The person and the target are not the Provider.

Removed sentence: "The executor and each provider are the person, or something the accepted architecture or the implementation names in Realized By, Technology Choice, or Runtime Components."

Removed when-not-to-use sentence: "Do not invent a means that no accepted architecture describes."

## align

Correct the method, library, module, or pattern. Do not replace the Provider. When no correction keeps the action, emit `[Standard title] cannot be met for **[Action title]**.` and return to `suggest`.

## Diagram

The proposal Diagram and the saved record use one logical flow. Both arrows leave the Provider.

```flowchart
flowchart TB
  P["[Provider]"] -->|[First action]| T1["[First target]"]
  P -->|[Next action]| T2["[Next target]"]
```

An arrow from one target to the next is rejected. A target is not shown performing the next action. There is no executor node.

An edit that changes the Provider sets that platform on every task and in the diagram, then goes to `align`.

## Files

`[Executor]` and `executor/` stay the tag and folder for the Provider's files. The README Use part follows the interface of the Provider.
