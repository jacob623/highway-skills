# Contract: Codify and Request Close

## Choosing an implementation

Lists the person uses to choose show a title and the implementation summary. They do not use an id as the label. A supplied id selects the matching accepted implementation, and the title is what the person sees after that.

| Invocation | Result |
|---|---|
| Exact title | That accepted implementation |
| Description fitting one or more | At most five, in the order in research.md |
| Nothing, and one to five accepted implementations | Every one, numbered. A number, title, or description selects one |
| Nothing, and more than five | No list. Ask for a title or description, then at most five |
| No accepted implementation, or no match | Say so. Write nothing |

## Proposal

The proposal step emits `Here is a proposed starting point for your automation:` and then the current state, one action, Day 1 or Day 2, and the architecture title used as the means. It asks what the person would add, correct, or remove, and says that if this is accurate, they can say so.

A reply is classified before the next action. A second action stays out of the proposal, and the reply says it waits for another run. A means that is not an accepted architecture is not added. Declining writes nothing. Accepting is the only confirmation.

When the start carries an action from an accepted request, that action is the proposal. The day still follows the running-instance reading. When no action is carried, the action follows the no-request rule in the data model.

## Procedure shape

`highway-codify` uses the same section order as the implementation skill: Purpose, When to use, When not to use, Inputs, Outputs, Procedure, Verification, Error Handling, Example. The procedure emits only the active step and follows `choose` when no implementation is named, otherwise `start`, then `identifier`, `title` when needed, `write`, and `close`. Instructions are imperative steps.

## Request close

The request is written before the close. The close does not rewrite it.

| Matches | Message |
|---|---|
| One | Name the implementation by title. Tell the person to run `/highway-codify` for that title to do the one action. Do not mention discovery. Do not state the day |
| Two to five | List them by title and short description. After a pick, use the one-match message and say the others wait for another run |
| More than five | List none. The person can give a title or a description. Then suggest at most five |
| None | Tell the person to run `/highway-discovery` with the request id |

A finding-seeded request uses the implementations named by that finding's accepted evidence as the match set. Assessment still continues into `highway-request` at `start` and does not start codify.

## Skill boundaries

Codify does not create a skill per means, and it does not put lifecycle activities on the implementation record. The request skill still does not write an implementation, an architecture, or a discovery.
