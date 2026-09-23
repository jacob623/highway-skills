# Control Onboarding Command Contract

## Commands

- `/highway-controls setup` and `/highway-controls configure` enter guided Control collection when prerequisites are complete and no valid Control baseline exists.
- If a valid Control baseline exists, setup reports it, displays no collection prompts, and routes to existing `add`, `update`, `remove`, or view actions.
- Existing `readiness`, `view`, `show`, `describe`, `add`, `update`, `remove`, and `set` actions remain supported.

## Collection contract

- Categories are presented exactly in this order: Security; Availability and Resilience; Operational; Compliance and Governance.
- One statement is collected at a time. A first-response case-insensitive `none` completes the category.
- Each submitted statement receives a deterministic advisory Proposed Title; the title may be edited during review.
- Collection cancellation discards all in-memory proposals and writes no governed artifact.

## Review contract

- Review displays category, Proposed Title, and statement for every proposal.
- Per-proposal decisions are Accept, Modify, Replace, or Remove.
- Duplicate proposals are advisory and remain independently reviewable.
- `Review Complete` requires exactly one final decision for every proposal. It allocates identifiers and performs one all-or-nothing Control transaction.
- Candidate generation runs only after successful completion, using the final persisted Control set.
- `Cancel Review` terminates without requiring decisions and preserves all proposal, Control, catalog, relationship, and candidate bytes.
