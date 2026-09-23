# Control Review Output Contract

## Populated review

The canonical Control skill emits one entry per proposed Control. Every entry contains:

- `Category`
- `Proposed Title`
- `Statement`
- `Available Decisions: Accept, Modify, Replace, Remove`

Entries retain collection order. A generated Proposed Title is proposal-state content until successful `Review Complete`.

## Empty review

When no proposed Controls exist, Control Review emits exactly:

- `Status: Empty`
- `Entry Count: 0`

This output creates no placeholder governance artifact.

## Persistence boundary and routing

Before successful `Review Complete`, no proposal content, generated title, identifier allocation, or onboarding state is persisted. A valid existing Control baseline suppresses onboarding collection and proposal state, reports the baseline, and routes to existing add, update, remove, or view actions. Successful completion remains the only Control persistence boundary.
