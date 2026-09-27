# Research: Highway NFR Setup Experience

## Decision 1: Add active NFR collection behind the existing owner boundary

- **Decision**: Extend `highway-nfrs` with `setup`/`configure` conversational collection while keeping candidate state, NFR records, identifiers, catalogs, relationships, readiness, and completion claims NFR-owned.
- **Rationale**: The specification explicitly makes derived recommendations an optional starting point and requires open user-authored discovery. Setup must remain orchestration-only.
- **Alternatives considered**: Implementing collection in Setup was rejected because it would duplicate NFR logic and violate owner authority. Reusing Controls collection was rejected because NFR classification and persistence belong to NFRs.

## Decision 2: Keep readiness and active collection completion separate

- **Decision**: Preserve the exact four-field NFR readiness response and add a separate four-field collection result with `Action Status`, `Collection Result`, `Next Action`, and `Blocking Reason`.
- **Rationale**: Existing readiness describes persisted NFR/candidate state, while `Continue`/`Finished` describes the current conversation. The Controls contract establishes the repository precedent.
- **Alternatives considered**: Adding collection state to readiness was rejected because it would make a read-only persisted-state contract depend on transient interaction state. Inferring finish from readiness, accepted records, or candidate review was rejected by the explicit-finish requirement.

## Decision 3: Treat candidate presentation as a transient UX projection

- **Decision**: Derive a subject and descriptor from accepted Control evidence for display only, omit internal candidate machinery in routine output, and map `accept`, `change`, `replace`, and `skip` onto existing durable decisions.
- **Rationale**: The retained candidate state already contains authoritative provenance and decision values. A presentation projection changes language without changing persisted state.
- **Alternatives considered**: Adding Control classifications or new durable decision values was rejected because the specification prohibits new persisted types and preserves the existing candidate state.

## Decision 4: Use explicit finish followed by fresh readiness

- **Decision**: After NFR returns successful `Collection Result: Finished`, Setup requests fresh NFR readiness and advances only from the owner's terminal-success readiness result.
- **Rationale**: This preserves the owner-result-before-advancement rule and prevents collection completion from being mistaken for a persisted NFR baseline.
- **Alternatives considered**: Advancing directly from `Finished` was rejected because no NFR may have been accepted. Reusing stale readiness was rejected because persistence may have changed during collection.

## Decision 5: Reuse existing validation surfaces and regenerate outputs

- **Decision**: Extend `highway-nfr-onboarding.test.sh`, `nfr-management.test.sh`, Setup routing/executable tests, and UX alignment checks; validate skills and regenerate adapters/catalogs.
- **Rationale**: These surfaces already distinguish static contract checks, executable fixtures, readiness ownership, generated correspondence, and no-write guarantees.
- **Alternatives considered**: A separate test harness was rejected because it would duplicate established repository governance checks and risk missing regressions in existing onboarding behavior.

## Decision 6: Version the NFR contract as a breaking change

- **Decision**: Apply the Skill Versioning Policy to `highway-nfrs`; classify the version change as MAJOR unless governance review records a justified alternative. Setup remains at its existing Feature 095 version unless its contract changes beyond consuming the new owner result.
- **Rationale**: NFR setup/configure action selection, review presentation, collection completion, resume, and output contracts are materially redefined.
- **Alternatives considered**: A MINOR or PATCH classification was rejected as the default because existing direct review behavior and supported action semantics are superseded.
