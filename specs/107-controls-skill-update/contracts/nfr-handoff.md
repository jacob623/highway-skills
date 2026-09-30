# Controls-to-NFR Handoff Contract

After a successfully created new Control, Controls invokes the NFR owner's candidate-generation
action once with the originating `CTLXXXXXX` and the deterministic derived input required by the
NFR owner.

Controls consumes only the declared candidate-generation result:

- successful generation: continue according to the active Controls collection contract;
- zero candidates: use the NFR owner's declared zero-candidate path;
- Blocked generation: preserve the successfully created Control and catalog, create no partial NFR
  relationship, and consume the non-empty blocking reason.

Controls does not own or describe candidate state, candidate counts, classification, review,
accepted NFR persistence, NFR identifiers, NFR readiness, or NFR completion. NFR review remains
deferred until Controls collection is explicitly finished if the NFR owner's contract requires it.

Candidate generation does not run for reused, updated, rejected, failed, or pre-existing Controls.
