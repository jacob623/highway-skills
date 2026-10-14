# Data Model: Controls NFR Decoupling

This feature removes an obsolete candidate-state model. It does not add retained fields or rewrite accepted records.

## Governance Ownership Chain

The active ownership sequence is:

```text
Profile -> Objectives -> Controls -> NFRs
```

Each owner independently recommends, develops, captures, persists, and continues collection within its own domain.

- **Validation**: an owner may use accepted upstream context as recommendation grounding, but no downstream owner requires a generated candidate lifecycle from an upstream owner.
- **Persistence**: existing user-owned records and catalogs remain governed by their current owner templates.

## Control Owner

The Controls owner manages Control-specific behavior only.

- **Responsibilities**: Control recommendation, proposal development, classification, explicit acceptance, capture, persistence, readiness, relationship safeguards, and collection continuation.
- **Inputs**: active user evidence and accepted context permitted by the existing Controls contract.
- **Outputs**: Control review/mutation results and Control collection/readiness results.
- **Removed relationship**: no NFR candidate-generation action, originating Control generation input, candidate result, or candidate recovery state.

## NFR Owner

The NFR owner manages NFR-specific behavior independently.

- **Responsibilities**: existing NFR classification, recommendation/development behavior already in scope, acceptance, capture, persistence, readiness, relationships, and collection continuation.
- **Inputs**: active user evidence and accepted context permitted by the existing NFR contract.
- **Removed relationship**: no required Control-originated candidate, pending candidate queue, candidate-generation result, or candidate-state recovery.
- **Scope boundary**: direct NFR recommendation redesign is a follow-on feature, not part of this refactor.

## Candidate-State Artifact

The obsolete framework-owned artifact represented durable Control-derived NFR candidate state.

- **Former contents**: originating Control identity, generation attempt, ordered candidates, decisions, pending review, readiness, and blocking/recovery state.
- **State**: removed.
- **Validation**: no active owner, catalog, readiness, workflow, verification, or error-handling contract may require it.

## Retained Control and NFR Records

Existing accepted records remain user-owned governance data.

- **Control record**: existing identifier, title, status, statement, rationale, NFR relationship identifiers, and optional recommendation grounding remain governed by the Control template.
- **NFR record**: existing identifier, title, status, statement, rationale, and Control relationship identifiers remain governed by the NFR template.
- **Mutation rule**: removal of candidate generation alone does not delete, rewrite, reclassify, or re-relate either record.

## Generated Skill Artifacts

Adapters, catalogs, manifests, and distributed instructions are derived representations of authoritative source files.

- **Validation**: after source or library removal, regenerated artifacts contain no orphaned candidate-state entry or stale candidate-generation ownership reference.
- **Persistence**: generated artifacts remain derived; they are not hand-edited.
