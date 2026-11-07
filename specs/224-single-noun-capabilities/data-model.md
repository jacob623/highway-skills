# Data Model: Single Noun Capabilities

## Capability title

Stated once in `capability-catalog.md`. Applies to every place below.

| Rule | Value |
|---|---|
| Shape | One noun phrase. Modifiers may precede the noun |
| Length | Five words or fewer. A hyphenated word counts as one word |
| Excluded | `and`, `or`, `&`, `/`, `+`, a comma |
| Joined title | Two capabilities, one per part. Each part keeps its words and repeats a shared noun when there is one |

## Where titles appear

| Place | Owner | Change |
|---|---|---|
| Onboarding starting list | `highway-onboarding` | Follows `capability title`. Two activities on one technology are two capabilities |
| Static capability | `highway-onboarding` | AI-Augmented Technology Development. Description unchanged |
| Implementation Capabilities and Realized Capabilities | `highway-implementation` | Follows `capability title` |
| Capability catalog row | `highway-implementation` | One row per capability. Title under the rule |
| New realized capabilities from configuration | `highway-codify-config` | Titled under the rule. `add capabilities` leaves out a title that breaks it |
| Architecture Required Capabilities | `highway-architecture` | Follows `capability title`. Capability is a title, not advisory text |

## Edit outcome

| Edit | Result | Consequence sentence |
|---|---|---|
| Joins two things | One capability per part, in place | `[Entry] is now [Part] and [Part]. If one is later done apart from the other, one joined capability would compound the effect of that change.` |
| Six or more words | A title of five words or fewer | `[Entry] is now [Title].` |
| Part already listed | Left out | None |

## Codify suggestion

| Instance | First | Others |
|---|---|---|
| Not running | `Establish [implementation title]` | One per realized capability, in record order |
| Running | One per realized capability, in record order | `Run [implementation title]` only when there is no realized capability |

A title from a realized capability does not start with `Establish`. At most five suggestions remain after codified actions are removed.
