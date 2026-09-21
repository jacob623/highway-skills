# Discovery Conversation Contract: Solution Constraints

## Invocation and Completion

Discovery receives exactly one completed `REQ` identifier. A successful response reports the
Discovery identifier, Request identifier, record path, catalog path, complete retained candidate
set, Candidate Elimination Log, matrix, Recommendation, and advisory relationship observations.
It identifies the Discovery artifact as the sole future input to ADR.

## Failure Responses

Malformed or contradictory Solution Constraints, an invalid empty allowed-class value, fewer than
two viable candidates, failed required scoring, failed privacy or validation, allocation conflict
after three attempts, or write failure produces an abort response without partial output. Existing
Discovery, catalog, Request, and governance bytes remain unchanged.

Optional unknown Solution Constraints are treated as unspecified. Preferred platforms and known
systems never cause exclusion. Required-platform mismatch and mandatory hosting, vendor,
procurement, or regulatory violations are reported in the Candidate Elimination Log and never
reach scoring or the comparison matrix.

## Advisory Handoff

The completion response exposes the complete retained option set, Candidate Elimination Log,
comparison matrix, Recommendation, rationale, Request Solution Constraints evidence, and Reference
Architecture Matches. ADR owns selection, rejection, acceptance, rationale, consequences, and
authorization. Discovery does not create or alter ADR decisions.

## Completion Boundary

Completion is reported only after the record and catalog validate in memory and the ordered write
transaction succeeds. The response must not imply that a preferred platform, known system, allowed
class, or Recommendation is an architecture decision or authorization.
