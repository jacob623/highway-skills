# Data Model: Guided Flow Refinements

No stored record changes. These are the shapes of emitted messages.

## Profile starting-point item

| Part | Rule |
|---|---|
| Label | Bold, on its own bullet line |
| Gap | One blank line |
| Content | Indented under the same bullet |
| Applies to | Vision: Future Direction, Desired Impact, Future State. Competitive Path: Primary Approach, Strategic Advantage, Important Tradeoff. Guiding Principles: each principle name |

## Recommendation set

| Part | Rule |
|---|---|
| Intro | Unchanged for each variant |
| Items | Numbered from 1. Each item is a bold title and one sentence |
| Size | 3 to 5, or fewer when fewer are grounded |
| Close | The skill's question, then its select line, then the additional-suggestions line |

## Selection reply

| Reply | Meaning |
|---|---|
| Titles | `select` those titles |
| Numbers | `select` those items in the current recommendation set |
| Numbers in a queue message | Refer to the recommendation set, not the queue list |

## Exhaustion message

| Part | Rule |
|---|---|
| Lead | Unchanged "Additional suggestions at this stage…" line |
| Question | Unchanged ready-to-review question |
| Follow | The skill's add-another line |

## NFR recommendation source

| State | Allowed sources |
|---|---|
| An accepted Control is not yet reflected | Accepted Controls, refined by Profile and Objectives. The two operating limits in the first set |
| Every accepted Control is reflected | Accepted Profile, Objectives, Controls, or an uncovered area that would reasonably benefit the organization |

A Control is reflected when a queued, shown, or captured NFR reflects it. One NFR may reflect more than one Control.
