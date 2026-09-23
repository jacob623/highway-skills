# Setup Readiness Contract

`/highway-setup` remains an orchestration-only consumer of owner readiness.

## Evaluation order

1. Profile readiness
2. Business Objective readiness
3. Control readiness
4. NFR readiness

A non-complete prerequisite stops evaluation and marks later owners Not Evaluated. Control-derived candidate generation does not begin until Control readiness is complete. NFR `Complete` and `Not Applicable` are terminally successful owner states; `In Progress`, `Missing`, or `Blocked` routes to the owner-provided next action.

The setup dashboard preserves the existing ordered status fields and management routes. It does not write Profile, Objective, Control, NFR, candidate, catalog, or relationship artifacts.
