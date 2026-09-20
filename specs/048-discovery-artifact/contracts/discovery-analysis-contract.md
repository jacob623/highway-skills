# Discovery Analysis Contract

## Invocation

`highway-discovery` receives exactly one source identifier in the form `REQ` followed by exactly six digits. The identifier resolves to exactly one completed Request. No implicit newest-file, filename-scan, or batch selection is permitted.

## Closed Inputs

The analysis reads, in order:

1. The selected completed Request.
2. The Profile baseline, when present.
3. The Objective baseline, when present.
4. The Control baseline, when present.
5. The NFR baseline, when present.

Inputs are read-only. Missing optional baselines produce empty relationship sections and do not cause a failure. Missing, malformed, ambiguous, or incomplete Request input is fatal.

## Deterministic Rule Order

1. Normalize line endings and comparison text; preserve display spelling.
2. Redact secrets and regulated personal data before copying or matching.
3. Copy authoritative Request evidence into the fixed Request section.
4. Extract findings by the six Request evidence domains in source order.
5. Emit assumptions for absent, explicitly unknown, or dependency-bearing evidence.
6. Emit risks for explicit constraints, dependencies, unresolved assumptions, privacy exclusions, and write-sensitive failure conditions.
7. Emit unknowns for absent required evidence, unresolved terms, and explicit unknown markers.
8. Emit candidate approaches only from distinct desired-change strategies explicitly present in the evidence; otherwise emit the deterministic no-candidate statement.
9. Match Objective, Control, and NFR candidates by explicit identifier, exact normalized title/statement, or at least two normalized non-stopword tokens.
10. Deduplicate, sort, derive the title, validate, and serialize in template order.

Generated lists are sorted by their defined stable key. Relationship candidates sort by confidence rank High, Medium, Low and then identifier. Equal normalized values retain the earliest source occurrence.

## Confidence

- High: explicit identifier reference.
- Medium: exact normalized title or statement match.
- Low: at least two normalized non-stopword tokens from Request problem and desired change match a baseline statement.

A single token match is not sufficient. Every candidate includes rationale and remains advisory.

## Failure Contract

The skill aborts without writes for missing or invalid source identifiers, incomplete Requests, malformed catalogs, failed validation, privacy-redaction failure, allocation conflicts after three attempts, or any write failure. Existing Discovery and catalog bytes remain unchanged.

## Handoff

A successful Discovery is the sole Discovery input required by later `highway-adr` analysis. ADR generation consumes the Discovery and its Request reference and does not repeat Discovery analysis.
