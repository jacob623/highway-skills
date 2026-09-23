# Data Model: Controls and NFRs Onboarding Enhancement

## Existing persistent entities

### Control baseline

- Location: root-level `library/governance/controls/` and `library/governance/controls.md`.
- Identity: immutable `CTL` followed by six digits.
- Authority: catalog `next_id` is the only allocation source and identifiers are never reused.
- Record fields used by this feature: title, statement, status, rationale/body content, and related NFR identifiers.
- Lifecycle: absent or malformed baseline -> setup/readiness; proposed -> accepted/modified/replaced or removed; accepted -> persisted baseline.

### NFR baseline

- Location: root-level `library/governance/nfrs/` and `library/governance/nfrs.md`.
- Identity: immutable `NFR` followed by six digits.
- Authority: catalog `next_id` is the only allocation source and identifiers are never reused.
- Record fields used by this feature: title, statement, rationale, status, and identifier-only `controls` relationship.
- Direct lifecycle: authored proposal -> accepted NFR with `controls: []`.
- Derived lifecycle: candidate -> accepted/modified/replaced NFR with originating Control relationship, or rejected/cancelled without persistence.

## Disposable review entities

### Control setup proposal

- Fields: fixed category, submitted statement, generated advisory Proposed Title, collection order, and review decision state.
- Identity: session-local proposal position; no Control identifier.
- Valid decisions: Accept, Modify, Replace, Remove, or undecided before review completion.
- Duplicate flag: advisory only; does not merge or block proposals.
- Persistence rule: no proposal field is persisted before successful Control Review Complete.

### Control review session

- Fields: ordered proposals, one final decision per proposal when complete, completion/cancellation state.
- State transitions: active -> complete only when every proposal has exactly one final decision; active -> cancelled without decision completeness; active -> failed on validation or transaction failure.
- Writes: one validated transaction for the approved Control set; candidate generation begins only after successful persistence.

### Control-derived NFR candidate

- Fields: candidate title, statement, rationale, originating persisted Control identifier, originating Control title, derivation rule name/order, and review decision state.
- Identity: disposable candidate position plus originating Control identity; no NFR identifier.
- Ordering: originating Control identifier, then availability/security/performance rule order.
- Valid decisions: Accept, Modify, Replace, Reject, or undecided before review completion.

### NFR review session

- Fields: ordered candidates, one final decision per candidate when complete, completion/cancellation state.
- State transitions: active -> complete only when every candidate has exactly one final decision; active -> cancelled without decision completeness; active -> failed on duplicate, validation, allocation, or transaction failure.
- Writes: one validated transaction for the approved NFR set and relationships.

## Transaction invariants

- Collection and active review allocate no identifiers.
- Review cancellation preserves all pre-session governed bytes.
- Review completion with undecided items performs no allocation and no governed write.
- Duplicate NFR detection occurs before identifier allocation.
- A failed Control or NFR completion leaves no partial artifact, catalog, or relationship update.
- Candidate generation is one-way from accepted Controls and evaluates the final approved Control set.

## Readiness projection

- Control readiness: `Complete` for a valid baseline, `Missing` for no baseline, `Blocked` for malformed/inconsistent state.
- NFR readiness: `Complete` for accepted NFR artifacts, `In Progress` for successful candidates awaiting decisions, `Not Applicable` for successful zero candidates with no accepted NFRs, and `Blocked` for failed or malformed candidate state.
- Setup readiness consumes these owner projections in Profile -> Objectives -> Controls -> NFR order.
