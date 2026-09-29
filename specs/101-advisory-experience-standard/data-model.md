# Data Model: Revise the Runtime Experience Standard

## Experience Standard

Runtime authority for what a person sees and how Highway interacts with that person.

| Field | After this amendment |
|---|---|
| Version | 3.0.0 |
| Ratified | 2026-09-08 |
| Last amended | 2026-09-29 |
| Change class | Major |
| Current rule rows | X1.6, X1.7, X2.1 through X2.31, X5.1, X5.2 |
| Retired current rows | X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, X6.1 |
| Row shape | Identifier, rule, observable, tier |
| Tier of current rows | `[agent-checkable]` |
| Removed current sections | Interactive Workflow UX Contract, N/A token table, Sample column, development-constitution runtime dependency |

A retired identifier may remain inside an older sync report. It is not a current rule row.

## Skills Constitution output rules

Principle IX gains seven rules. Principle rank and the precedence table stay as they are.

| Field | After this amendment |
|---|---|
| Version | 4.1.0 |
| Ratified | 2026-09-06 |
| Last amended | 2026-09-29 |
| Change class | Minor |
| Added rows | P9.2, P9.3, P9.4, P9.5, P9.6, P9.7, P9.8 |
| Row shape | Identifier, rule, observable, tier |
| Tier of added rows | P9.5 is `[auto]`. P9.2, P9.3, P9.4, P9.6, P9.7, and P9.8 are `[agent-checkable]`. |
| Unchanged neighbors | P9.1, P10.1, P10.2, P12.5 through P12.12, precedence ranks |

## Moved obligation

A skill-file or retained-artifact obligation that leaves the Experience Standard and is stated again under a new constitution identifier.

| Former | Successor | Obligation |
|---|---|---|
| X1.1 | P9.2 | Declare the shape of what a skill emits. |
| X1.2 | P9.3 | Emit content in that declared shape. |
| X1.3 | P9.4 | Give an empty result a declared form. |
| X1.4 | P9.5 | A specimen agrees with the metadata it repeats. |
| X1.5 | P9.6 | A retained file includes frontmatter. |
| X4.1 | P9.7 | A skill that writes a file declares its path. |
| X6.1 | P9.8 | A retained artifact derives its content from declared inputs. |

The successor does not reuse the former identifier. The former identifier is not reused for a new experience rule.

## Interaction concepts

| Concept | Meaning in the amended standard |
|---|---|
| Accepted context | Information the person or the applicable acceptance boundary has already accepted. |
| Grounded recommendation | A distinct actionable proposal based on context the owning workflow declares. It stays a proposal until selected or otherwise accepted. |
| Material interpretation | Highway infers, classifies, synthesizes, or transforms input into a retained category the person did not explicitly provide. |
| Inferred-content review | The review for material interpretation. It begins with "Here's what I've captured as your [category]:", shows the proposal, and puts one acceptance request at the bottom. |
| Direct capture | Storing an explicit selection or a direct statement without that review. |
| Recommendation set | At most 5 distinct choices, with a user-authored alternative still available. |

## Rule states

| State | Meaning |
|---|---|
| Active | A current row whose obligation is unchanged. |
| Redefined | The same identifier, with the obligation in the experience contract. |
| Retired | No current row. The identifier stays unused. |
| Moved | Retired from the Experience Standard and active in the Skills Constitution under the successor identifier. |
| Added | A new identifier for an obligation that had no current row. |
