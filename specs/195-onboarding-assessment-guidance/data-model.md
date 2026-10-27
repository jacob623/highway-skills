# Data Model: Onboarding and Assessment Guidance

No stored record changes. These are emitted shapes and flow states.

## Onboarding flow

`overview` → `capabilities` → `map` → `mapping` → `orchestrate` → `lineage` → `summary`

| Step | Change |
|---|---|
| `overview` | New. Emitted once, then `capabilities` |
| `capabilities` | No opening heading. Numbered single capabilities. AI-Assisted Engineering and Planning replaces Highway |
| `map` | Transition before the first capability only. Labels separated from values |

## Capability item

| Part | Rule |
|---|---|
| Marker | Numbered from 1 |
| Title | Bold, with a colon |
| Gap | One blank line |
| Description | Indented under the item |
| Scope | One capability |

## Assessment flow

`Entry` → `list of findings` ⇄ `finding` → `summary`

| From | Reply | To |
|---|---|---|
| `list of findings` | `select` | `finding` for that finding |
| `list of findings` | `more` | `list of findings` with the next set |
| `list of findings` | `decline` | `summary` |
| `finding` | `back` | `list of findings` |
| `finding` | `accept` | Row set to Accepted, then `list of findings` |
| `finding` | `dismiss` | Row set to Dismissed, then `list of findings` |
| `finding` | `explore` | Unchanged: row set to Accepted, then `highway-request` |
| `finding` | `decline` | `summary` |
| `list of findings` | No finding remains | `summary` |

## Listed finding

| Part | Rule |
|---|---|
| Order | Open findings from earlier runs, then new grounded findings |
| Count | At most 5 |
| Finding | Bold label, blank line, one-sentence summary |
| Complexity | Bold label, blank line, Low, Medium, or High |
| Write | A new finding is written as Open before the list is shown |
