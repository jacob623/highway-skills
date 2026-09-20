# Discovery Conversation Contract

## Invocation and Completion

Discovery receives exactly one completed `REQ` identifier and reports the resulting `DISC`
identifier, Request identifier, record path, catalog path, and advisory relationship observations.
It does not request discretionary analysis text or accept requester-authored replacements for
rule-generated sections.

## Failure Responses

Fewer than two viable options, failed required score calculation, invalid source data, failed
redaction, failed validation, allocation conflict after three attempts, or write failure produces
an abort response without partial output. Existing Discovery and catalog bytes remain unchanged.
Missing or unreadable optional Reference Architecture data produces an empty match set. Missing or
unreadable Reference Implementation data produces zero tie-break counts.

## Advisory Handoff

The completion response identifies the Discovery artifact as the sole input for later ADR work and
exposes the complete option set, Recommendation, rationale, Comparison Matrix, and Reference
Architecture Matches. ADR owns selection, rejection, acceptance, rationale, and consequences.

## Feature 049 Completion Boundary

Completion is reported only after the record and catalog validate in memory and the ordered write
transaction succeeds. An abort, failed analysis, or failed write reports the reason and performs
no partial write. A successful response identifies the Discovery and Request, exposes every option,
the matrix, Recommendation rationale, and Reference Architecture Matches, and identifies the
Discovery artifact as the sole future ADR analysis input.
