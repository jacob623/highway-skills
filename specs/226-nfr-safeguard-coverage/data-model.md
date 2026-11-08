# Data Model: NFR Safeguard Coverage

No stored shape changes. `nfr-record.md` and `nfr-catalog.md` stay at their current versions.

## Recommendation (in a set, not stored)

| Field | Rule |
|---|---|
| Number | Starts at 1 in each set |
| Title | Bold |
| Sentence | One sentence |
| Why it matters | New. One line, per the rationale rule |
| Reflected Controls | Accepted Controls the recommendation keeps true. Empty for the two limits and for Profile or Objective recommendations |

## Coverage

A Control is covered when a queued or captured NFR reflects it. A shown, unselected recommendation does not cover it. While any Control is uncovered, a set contains only Control-derived recommendations, plus the two limits in the first set. Each set holds 3 to 5 items.

## NFR record (unchanged shape)

| Field | Source |
|---|---|
| `controls` | Accepted Control ids that influenced the NFR. Includes every Control its rationale names |
| Rationale | The line shown with **Why it matters:** at acceptance. Kept as written when the person edited it |
