# Data Model: Review Presentation Refinements

No stored record changes. These are emitted shapes and flow states.

## Captured item (Objectives, Controls, NFRs)

| Part | Rule |
|---|---|
| Marker | Numbered from 1, in queue order |
| First line | Bold title with a colon, then the statement |
| Details | Indented under the number |
| Separator | `---` between items, none after the last |

## Listed finding

| Part | Rule |
|---|---|
| Title | Bold, with a colon, based on the Finding text. Not stored |
| Summary | One sentence, after a blank line |
| Solution Complexity | Bold label, blank line, Low, Medium, or High |

## Assessment list replies

| Reply | Result |
|---|---|
| `select` | `finding` for that finding |
| `more` | Next set of up to 5 |
| `dismiss` | Each named finding set to Dismissed, list re-emitted and filled back to 5 |
| `decline` | `summary` |

## Request flow

`intake` (when no description) → `start` → `identifier` → `title` when needed → `write` → `close`

`capture` no longer exists.

## Solution Constraints display

| Record field | Shown as | Shown value for `unknown` or `[]` | Held for "none" |
|---|---|---|---|
| `allowed_solution_classes` | Allowed Solution Classes | None | `unknown` |
| `existing_platforms_required` | Existing Platforms Required | None | `[]` |
| `existing_platforms_preferred` | Existing Platforms Preferred | None | `[]` |
| `known_systems` | Known Systems | None | `[]` |
| `hosting_restrictions` | Hosting Restrictions | None | `unknown` |
| `vendor_restrictions` | Vendor Restrictions | None | `unknown` |
| `procurement_constraints` | Procurement Constraints | None | `unknown` |
| `regulatory_restrictions` | Regulatory Restrictions | None | `unknown` |
