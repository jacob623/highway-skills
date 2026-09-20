# Discovery Analysis Contract

## Inputs

Discovery receives exactly one completed `REQ` identifier and reads closed inputs in this order:
Request, Profile, Objective, Control, NFR, and optional Reference Architecture. Reference
Implementation data is consulted only for the advisory tie-break. Inputs are read-only and are
redacted before copying or matching.

## Deterministic Analysis Order

1. Resolve and validate the completed Request.
2. Load the closed inputs in the declared order and normalize line endings and comparison text.
3. Redact secrets and regulated personal data before output construction.
4. Preserve existing findings, assumptions, risks, and unknowns extraction rules.
5. Generate distinct options from Desired Change strategies, then implied strategies in the defined
   evidence precedence; deduplicate and reject incomplete options.
6. Sort viable options by Desired Change alignment, Objective alignment, constraint alignment, and
   alphabetical title, then assign stable `OPT` identifiers.
7. Evaluate every Reference Architecture candidate independently using exact matching only:
   explicit identifier, normalized title, capability identifier, Objective identifier, Control
   identifier, then NFR identifier. Record every match and the highest-precedence reason.
8. Calculate weighted scores, informational categories, matrix, confidence, rationale, and one
   recommendation according to the Recommendation Contract.
9. Validate the complete record and catalog before allocation or writing.

## Feature 049 Invariants

- Candidate generation is closed and ordered: explicit Desired Change strategies, then Objective,
   Control, NFR, Research Finding, and Reference Architecture evidence. Normalize and deduplicate
   before retaining two through five complete options.
- Option ordering uses Desired Change alignment, Objective alignment, constraint alignment, and
   alphabetical title; assign `OPT` plus six digits only after sorting.
- Reference Architecture candidates are evaluated independently with exact precedence: explicit
   identifier, exact normalized title, capability identifier, Objective identifier, Control
   identifier, then NFR identifier. Report every match and its highest-precedence reason.
- Scores use Objective 30, NFR 30, Control 20, Profile 10, and Risk Reduction 10; floor whole
   numbers, zero-denominator zero, and totals from 0 through 100. Informational categories never
   influence scoring or selection.

## Failure Behavior

Fewer than two viable options, failed required score calculation, invalid source data, failed
redaction, failed validation, allocation conflict after three attempts, or write failure aborts
without partial output. Missing or unreadable optional Reference Architecture data produces an
empty match set. Missing or unreadable Reference Implementation data produces zero tie-break counts.

## Ownership

Discovery emits advisory analysis and relationships only. It does not create or mutate Requests,
governance baselines, Reference Architectures, Reference Implementations, ADRs, or decisions.