# Reference Implementation Evaluation Contract

## Purpose

Define the internal Discovery contract for evaluating optional Reference Implementation evidence.

## Inputs

- Candidate Solution Options with Discovery-scoped `OPT` identifiers
- Existing Reference Architecture Matches for each option
- Optional authoritative Reference Implementation catalog
- Existing Request, Profile, Objective, Control, NFR, and Discovery inputs

## Matching Rules

A Reference Implementation matches an option only when it explicitly references:

1. A Reference Architecture matched by that option; or
2. The identifier of a Reference Architecture matched by that option.

Semantic similarity, inference, timestamps, recency, file dates, catalog order, and environment state are not valid matching inputs.

## Validation and Failure Behavior

- Unparseable artifacts, artifacts without valid stable identifiers, and artifacts missing required fields are malformed.
- Malformed artifacts are excluded and their exclusion reason is recorded.
- Unresolved Reference Architecture references are valid non-matches.
- Duplicate catalog identifiers are catalog inconsistencies; affected counts are zero.
- Missing or unreadable catalogs produce zero counts and do not fail Discovery.
- Matching and counting do not mutate source artifacts or ADR records.

## Count Contract

`Reference Implementation Count` is the number of unique matching implementation identifiers. Multiple matching paths for one identifier count once. The count is advisory and is not a Recommendation score component or confidence input.

## Output Evidence

The evaluation may expose matching identifiers, counts, and exclusion reasons as Discovery traceability evidence. It MUST NOT expose an approval, endorsement, authorization, correctness claim, or ADR decision.
