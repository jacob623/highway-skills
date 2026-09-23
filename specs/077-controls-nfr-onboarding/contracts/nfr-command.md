# NFR Onboarding Command Contract

## Commands

- `/highway-nfrs review` and `/highway-nfrs onboarding` enter Control-derived candidate review.
- Existing `readiness`, `inspect`, `add`, `update`, `remove`, and `set` actions remain supported.
- `/highway-nfrs setup` and `/highway-nfrs configure` are not onboarding actions.

## Candidate review contract

- Each candidate displays title, statement, rationale, originating Control identifier, and originating Control title.
- Candidate order is originating persisted Control identifier, then availability, security, performance rule order.
- Per-candidate decisions are Accept, Modify, Replace, Reject, or Cancel.
- `Review Complete` requires exactly one final decision for every candidate and writes the accepted NFR set in one transaction.
- Duplicate NFR detection occurs before identifier allocation; a duplicate fails safely without partial writes.
- `Cancel Review` terminates without requiring decisions and preserves candidate, NFR, catalog, and relationship bytes.
- Direct NFR authoring remains independent and starts with `controls: []`.

## Readiness contract

- Successful candidate generation with undecided candidates reports `In Progress`.
- Successful zero-candidate generation with no accepted NFRs reports `Not Applicable`.
- Accepted NFR artifacts report `Complete`.
- Candidate-generation failure or malformed candidate state reports `Blocked`.
