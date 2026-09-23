# Research: Controls and NFR Review Output Contracts

## Decision: Keep review contracts in the owning canonical skills

**Rationale:** Feature 077 established the Control and NFR skills as the workflow owners. Feature 078 clarifies their output obligations without transferring ownership or introducing a separate runtime contract layer. Canonical sources remain `.highway/skills/highway-controls/SKILL.md` and `.highway/skills/highway-nfrs/SKILL.md`.

**Alternatives considered:** Separate review contract files were rejected because they would fragment ownership and create a second source of truth.

## Decision: Use the minimal explicit empty-review shape

**Rationale:** Empty review output is transient presentation state, not readiness state. Both empty cases therefore emit exactly `Status: Empty` and `Entry Count: 0`, without creating placeholder governance artifacts.

**Alternatives considered:** Reusing the four-field readiness response was rejected because it would conflate review presentation with persisted-artifact readiness.

## Decision: Preserve existing deterministic ordering

**Rationale:** Control proposals retain collection order. NFR candidates retain persisted originating Control identifier order followed by availability, security, and performance derivation order. This makes repeated renders auditable without timestamps, randomness, environment values, filesystem ordering, or session state.

**Alternatives considered:** Sorting by filesystem order or review-session timing was rejected because both are unstable and outside the workflow contracts.

## Decision: Keep readiness owned by accepted artifact state

**Rationale:** Only successful `Review Complete` outcomes may affect subsequent readiness evaluation. Cancellation, rejection, validation, allocation, duplicate-detection, and write failures preserve readiness-consumed accepted artifact state.

**Alternatives considered:** Projecting proposal or candidate state into readiness was rejected because it would introduce a new readiness state and violate the Feature 078 scope boundary.

## Decision: Test contract visibility with existing shell fixtures

**Rationale:** The repository uses Bash 3.2-compatible static contract assertions and disposable governance fixtures. Focused tests can verify populated and empty output fields, ordering, write boundaries, routing, readiness ownership, and duplicate-failure preservation without a new dependency or runtime implementation.

**Alternatives considered:** Introducing a schema validator or new test framework was rejected because the feature changes existing Markdown contracts and the current harness already provides the required evidence surface.

## Resolved unknowns

- No new dependency, storage technology, runtime command, workflow stage, identifier scheme, readiness state, governance artifact, or ownership boundary is required.
- Existing Control/NFR templates remain authoritative and are not changed by this feature.
- Generated adapters and catalogs are updated only if canonical skill sources change, using the existing generators and correspondence checks.
