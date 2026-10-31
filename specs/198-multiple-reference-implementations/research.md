# Research: Multiple Reference Implementations

## Decision: One architecture row lists its current decisions

- **Decision**: The architecture catalog keeps one row per architecture. The ADR ID column lists every current decision id for that row, in id order, separated by a comma and a space. An ADR id appears in at most one row. A superseded or removed decision is dropped from that list in the same write that changes its status.
- **Rationale**: The clarification asked for one-to-many relationships and for the catalog to match the architecture record. One row keeps the architecture id, title, and path stable.
- **Alternatives considered**: One catalog row per decision-architecture pair was rejected because the same architecture id would repeat. A separate relationship file was rejected because the catalog is already the index.

## Decision: Many implementation rows may name one architecture

- **Decision**: Remove the rule that an architecture id appears on at most one implementation-catalog row. Each implementation keeps its own row. The row's Architecture ID is its one parent.
- **Rationale**: Each implementation has its own id, title, and path. The many side is many rows, not a list inside one cell.
- **Alternatives considered**: A list of implementation ids on the architecture row was rejected because the implementation catalog would no longer be the index of implementations.

## Decision: The decision catalog gains an Architecture ID column

- **Decision**: Add Architecture ID after ADR Path. The value is the RA id the decision names, or `None` before an architecture exists. One decision has one value.
- **Rationale**: The clarification requires a decision row to show its one architecture, and the three catalogs to be updated together.
- **Alternatives considered**: Leaving the architecture only on the decision record was rejected because the catalog would diverge from the record.

## Decision: The ADR writes the reused architecture id

- **Decision**: When the decision reuses an architecture, `highway-adr` writes that RA id in the handoff and adds the new decision to the architecture's current-decision list and catalog row. It does not change the architecture's conceptual body. The handoff has no implementation entry. `Reference Implementation` is removed from the handoff.
- **Rationale**: The architecture already exists, so the handoff should name it at acceptance. The implementation id stays off the decision.
- **Alternatives considered**: Leaving the handoff `None` until a later skill ran was rejected because no new architecture is created on the reuse path.

## Decision: Replacement updates the list; running beside adds to it

- **Decision**: Replacement sets the earlier decision to `superseded`, removes it from the architecture's current-decision list, and adds the new decision when that architecture is kept. Running beside adds the new decision and leaves the earlier one on the list. Both updates happen in the ADR write.
- **Rationale**: The architecture lists current decisions only. The person is informed of which outcome the proposal will write. Acceptance is the only confirmation.
- **Alternatives considered**: Keeping the superseded decision on the architecture list was rejected because the clarification says current decisions.

## Decision: An option already has an implementation by exact decision title

- **Decision**: The option already has an implementation when a current decision for the matched architecture has the same selected-option title, character for character, and that architecture has a current implementation recorded for that decision. The closing message then names that implementation.
- **Rationale**: This is the clarification. A different title, including SQS beside Kafka, is not yet implemented.
- **Alternatives considered**: Treating any implementation of the architecture as a match was rejected by the clarification.

## Decision: The implementation skill no longer writes the decision

- **Decision**: Remove the implementation `name` step that sets an implementation id on the ADR. A second implementation for an architecture is allowed. The existing ones are shown, and a new one can still be accepted. A conflict with the architecture writes nothing.
- **Rationale**: The decision does not store an implementation id. Many implementations share one architecture.
- **Alternatives considered**: Keeping the ADR update and writing a list of implementation ids was rejected because the spec forbids an implementation entry on the decision.

## Decision: Coverage rows come from the architecture

- **Decision**: Replace the fixed ten-category coverage table with one row per responsibility stated on the architecture. Status is covered or not applicable. The conformance result is compatible only when every row is one of those two and there is no gap. A compatible record omits gap and conflict sections.
- **Rationale**: The spec requires the coverage list to be the architecture's responsibilities.
- **Alternatives considered**: Keeping the ten categories and adding responsibilities beside them was rejected because the fixed list would still be present.

## Decision: Tests

- **Decision**: Add `multiple-reference-implementations.test.sh`. Amend `adr-record-completeness.test.sh` so it no longer requires the handoff implementation field or an implementation skill that writes the ADR. Record both retired assertions in `retirements.md`.
- **Rationale**: D3.3 and D3.5.
