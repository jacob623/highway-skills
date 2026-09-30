# Research: NFR Skill Contract Simplification

## Decision 1: Keep NFR-owned candidate state as the single durable schema

**Decision**: Define the durable candidate-state shape once in
`.highway/catalog/nfr-candidate-state.md` and make `highway-nfrs` reference that authority from
Inputs, onboarding, readiness, verification, and errors.

**Rationale**: The current skill repeats candidate fields and lifecycle rules in several sections.
One schema authority reduces drift while preserving originating Control identity, stable order,
decisions, resume position, and readiness state.

**Alternatives considered**: Keeping repeated inline schemas was rejected because changes could leave
candidate onboarding, readiness, and recovery with conflicting state contracts.

## Decision 2: Preserve the existing owner boundary and result contracts

**Decision**: Controls continues to derive and invoke candidate generation after a successfully
created Control. NFRs owns durable state, candidate review, NFR persistence, relationships,
readiness, and collection completion. Preserve the four-field readiness, collection, and
candidate-generation result shapes.

**Rationale**: These boundaries are already implemented and exercised by Control-derived NFR tests.
The feature changes terminology and interaction contract, not ownership.

**Alternatives considered**: Moving derivation or letting Setup inspect candidate state was rejected
because it would duplicate ownership and make readiness dependent on internal state.

## Decision 3: Treat the NFR record placeholder change as a template contract revision

**Decision**: Change `nfr-record.md` metadata from `1.0.0` to `2.0.0`, replace the placeholders with
accepted-content wording, and preserve `id`, `title`, `status`, and identifier-only `controls`.

**Rationale**: The retained body contract changes from user-provided values to accepted values that
may come from direct authorship, accepted interpretation, or selected recommendations.

**Alternatives considered**: Keeping version `1.0.0` was rejected during clarification because the
retained template semantics change.

## Decision 4: Rewrite the runtime skill rather than incrementally preserve legacy prose

**Decision**: Replace generic interaction restatements, historical development compliance text,
post-write verification, and per-step error mappings with a concise NFR-specific workflow and
exceptions that cite shared governance.

**Rationale**: The Constitution and Experience Standard are authoritative for generic behavior;
duplicated runtime text creates competing instructions and obscures the NFR-specific contract.

**Alternatives considered**: Patching individual legacy paragraphs was rejected because the current
skill's repeated schemas and numbered workflow would continue to preserve contradictory behavior.

## Decision 5: Validate through canonical artifacts and generated outputs

**Decision**: Update focused NFR/template/readiness/relationship tests, validate the canonical skill
and template, regenerate adapters and catalogs, then run the full suite.

**Rationale**: NFR skill and template files are shipped through generated agent trees and shared
catalogs; source-only validation would not prove the distributed contract.

**Alternatives considered**: Testing only the canonical source was rejected because generated
artifacts are user-facing outputs and must remain aligned.
