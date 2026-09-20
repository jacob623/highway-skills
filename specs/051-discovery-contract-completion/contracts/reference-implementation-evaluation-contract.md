# Reference Implementation Evaluation Contract

## Inputs

- Candidate Solution Options and Discovery-scoped `OPT` identifiers
- Existing Reference Architecture matches
- Optional authoritative Reference Implementation catalog
- Existing Request, Profile, Objective, Control, NFR, and Discovery inputs

## Matching

A Reference Implementation matches an option only when it explicitly references a matching
Reference Architecture or explicitly references the identifier of a Reference Architecture
matched by that option. No match exists otherwise.

Semantic similarity, inference, approximation, similarity scoring, timestamps, recency, file dates,
and environment state are not matching inputs.

## Counting and Validation

Reference Implementation Count is the number of unique matching stable implementation identifiers.
Multiple matching paths for one identifier count once.

Unparseable artifacts, artifacts without valid stable identifiers, and artifacts missing required
fields are malformed; exclude them and record the blocking reason. Unresolved Reference
Architecture references in otherwise valid artifacts are valid non-matches.

Missing or unreadable implementations contribute zero. An absent or unreadable catalog produces
zero counts. Duplicate catalog identifiers make affected catalog data inconsistent; exclude the
affected implementations, record the reason, and continue.

## Output Evidence and Mutation Boundary

The evaluation may expose matching identifiers, counts, and exclusion reasons as Discovery
traceability evidence. It MUST NOT expose endorsement, approval, correctness, suitability,
authorization, or an ADR decision. Evaluation MUST NOT mutate Reference Implementations, Reference
Architectures, governance baselines, Discovery source inputs, or ADR records.
