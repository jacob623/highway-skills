# Research: Controls and NFRs Onboarding Enhancement

## Decision: Preserve the existing owner boundaries

- `/highway-setup` remains orchestration-only and evaluates Profile, Objectives, Controls, then NFR readiness.
- `/highway-controls` owns Control collection, Control review, identifier allocation, Control persistence, candidate generation, and Control-to-NFR relationship updates.
- `/highway-nfrs` owns direct NFR authoring, NFR candidate review aliases, NFR persistence, and NFR readiness.
- Rationale: the existing skills already define the authoritative artifact locations, readiness fields, identifier sources, and relationship direction.
- Alternatives considered: introducing a new onboarding skill was rejected because it would duplicate ownership and create a second governance entry point.

## Decision: Use a two-phase review state machine

1. Collection or candidate loading builds proposal state without identifiers or governed writes.
2. Per-item decisions are recorded in memory.
3. `Review Complete` requires exactly one final decision for every item.
4. Validation, duplicate checks, identifier allocation, artifact/catalog/relationship writes, and candidate generation occur only at the completion boundary.
5. Any failure restores or preserves every pre-operation byte; `Cancel Review` discards pending state without requiring complete decisions.

- Rationale: this directly satisfies the no-write, all-or-nothing, cancellation, and completeness requirements.
- Alternatives considered: writing after each accepted item was rejected because it permits partial baselines and makes cancellation ambiguous.

## Decision: Keep proposed title generation deterministic but algorithm-independent

- Generate an initial title from the submitted Control statement using a deterministic local heuristic.
- Treat it as advisory proposal data; allow review editing/replacement.
- Test the supplied MFA example and repeated identical inputs, but do not make the spec depend on a particular linguistic algorithm.
- Rationale: the spec requires stable onboarding behavior while allowing title quality to improve without changing persistence boundaries.
- Alternatives considered: an external or probabilistic title service was rejected because it would violate determinism and add a runtime dependency.

## Decision: Reuse the existing candidate derivation contract

- Normalize only title and statement for matching using the existing local normalization rules.
- Evaluate rules in availability, security, performance order.
- Order candidates first by persisted originating Control identifier, then by rule order.
- Generate candidates only after successful Control Review Complete, from the final approved Control set.
- Rationale: the existing Control skill already defines the one-way derivation and candidate fields.
- Alternatives considered: ordering by collection order or catalog text order was rejected because identifiers and explicit rule order are the stable contract.

## Decision: Treat duplicates as safe review diagnostics

- Duplicate proposed Controls are detected from approved content and shown as advisory information; each remains independently reviewable.
- Existing NFR duplication is a pre-allocation failure for the affected completion transaction and preserves all bytes.
- Rationale: duplicate Controls may be intentional or need separate decisions, while duplicate NFR artifacts cannot safely be created.
- Alternatives considered: silently coalescing duplicate Controls was rejected because it changes user content and decision cardinality.

## Decision: Use existing readiness states and exact four-field output

- Controls retain `Complete`, `Missing`, and `Blocked` semantics.
- NFRs use `Complete`, `In Progress`, `Not Applicable`, and `Blocked` as already defined.
- `/highway-setup` consumes owner readiness without recomputing it.
- Rationale: preserving the existing readiness contracts avoids incompatible dashboard behavior.
- Alternatives considered: adding a new onboarding-specific readiness vocabulary was rejected because it would require changes across all owners.

## Decision: Extend existing fixture-driven shell tests

- Add focused contract and behavioral fixtures under `.highway/tools/tests/`.
- Use temporary copied governance roots, byte snapshots, injected failure paths, and seeded duplicate/undecided/malformed states.
- Run focused tests, validators, generators, and the full suite after implementation.
- Rationale: this matches the repository's Bash 3.2-compatible test architecture and constitution requirements.
- Alternatives considered: introducing a new test framework was rejected because it adds a runtime dependency and bypasses established fixtures.

## Deferred to implementation planning

- Exact prompt prose and exact readiness summary sentences remain implementation details constrained by the existing skill output contracts.
- Performance, scale, observability, and localization targets are not material to this local Markdown/shell workflow and require no architectural decision for Feature 077.
