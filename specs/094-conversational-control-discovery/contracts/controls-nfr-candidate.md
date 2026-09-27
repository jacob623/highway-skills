# Controls/NFR Candidate Contract

## Generation

After each new Control is atomically persisted and all retained outputs verify, Controls invokes the
existing deterministic derivation using only the normalized Control title and statement. The fixed
rule order remains availability, security, performance. Each matching rule produces one candidate
with originating Control ID/title, candidate title, statement, rationale, and stable order.

Candidate generation runs once for each verified new Control, including when collection later pauses,
aborts, or is interrupted. Reused, updated, rejected, failed, and pre-existing Controls do not enter
this generation path.

## Ownership

Controls owns initial deterministic derivation. NFRs own candidate-generation readiness, candidate
classification/review, accepted NFR persistence, NFR identifiers, catalogs, and completion claims.
The implementation must reconcile and version both canonical skill contracts before completion.

## Readiness outcomes

- zero candidates with no accepted artifacts: `Not Applicable`;
- candidates with none accepted: `In Progress`;
- accepted valid artifacts: `Complete`;
- malformed or unavailable generation, contradictory result, or candidate failure: `Blocked` with a
  non-empty reason.

A blocked generation leaves the valid Control and catalog transaction intact, writes no partial NFR
relationship, and prevents Setup from advancing through NFR review. User-visible review begins only
after setup/configure returns `Collection Result: Finished`.
