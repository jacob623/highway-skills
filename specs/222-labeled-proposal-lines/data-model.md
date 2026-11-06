# Data Model: Labeled Proposal Lines

## Conflict line

- List item: the bold conflict name and its description.
- Then one blank line.
- Then `**Recommendation:**` and one change that removes the conflict, indented three spaces.
- Shown in `platform proposal`, `standard proposal`, and `conflicts`.

## Capability line

- List item: the bold title and `Realized By: [Platform].`
- Then one blank line.
- Then `**Evidence:**` and what the current documentation describes, indented three spaces.
- Shown in `platform proposal`, under New Realized Capabilities.

## Unchanged

- The capabilities passed to `highway-implementation` keep Title, Realized By, and Evidence.
- `resolve` still starts from the selected conflict's recommendation.
- No catalog, record, or saved file changes.
