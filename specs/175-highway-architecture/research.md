# Research: Highway Reference Architecture Workflow

## Decision: Mirror the existing ADR workflow boundary

- **Decision**: Treat `highway-architecture` as a read-only consumer of exactly one accepted ADR and optional governance context, with Reference Architecture owning only the conceptual architecture record and its catalog entry.
- **Rationale**: The existing `highway-adr` contract already establishes exact identifier resolution, immutable upstream evidence, owner-specific persistence, and a clean handoff to Reference Architecture. Reusing that boundary avoids competing decision ownership.
- **Alternatives considered**: Letting architecture revise ADR decisions or select alternatives was rejected because ADR owns decision, rationale, alternatives, and consequences. Consuming the newest matching file was rejected because it is nondeterministic and violates catalog ownership.

## Decision: Use catalog-owned `ARCHXXXXXX` allocation

- **Decision**: Allocate permanent architecture identifiers from `architectures/architectures.md`, advance `Next ID` exactly once, and reject duplicate architecture creation for the same ADR.
- **Rationale**: This matches existing Highway catalog workflows and preserves retry-safe, deterministic identity semantics.
- **Alternatives considered**: Random or timestamp-based identifiers were rejected because they break reproducibility and stable traceability. Deriving an identifier from the ADR was rejected because it does not provide independent permanent record identity.

## Decision: Use shared output templates as the structure authority

- **Decision**: Define `architecture-record.md` and `architecture-catalog.md` as complete shared output skeletons; the skill declares their paths and domain behavior without reproducing generic template structure.
- **Rationale**: Shared templates are the repository contract for retained artifact shape and prevent drift between related skills.
- **Alternatives considered**: Embedding the complete record structure only in the skill was rejected because it duplicates shared output contracts. Using an unstructured narrative record was rejected because required sections and deterministic validation need a stable shape.

## Decision: Treat optional governance states distinctly

- **Decision**: Missing optional Profile, Objective, Control, or NFR evidence allows creation without fabricated content; blocked evidence allows creation but becomes an architecture risk; malformed or internally inconsistent supplied evidence aborts without writes.
- **Rationale**: This preserves optional-input behavior while preventing malformed data from entering a retained architecture and making blocked uncertainty invisible.
- **Alternatives considered**: Treating all optional failures as absence was rejected because it hides malformed evidence. Treating blocked evidence as fatal was rejected because blocked status is an explicit risk state and does not invalidate an otherwise accepted ADR.

## Decision: Keep the MVP conceptual and implementation-neutral

- **Decision**: Generate logical components, interactions, deployment patterns, trust boundaries, capabilities, assumptions, risks, constraints, and future implementation guidance, but no capability artifacts, diagrams, threat models, scoring, or implementation outputs.
- **Rationale**: The feature's value is a reusable knowledge handoff between ADR and a future Reference Implementation owner. Conceptual scope prevents premature implementation authority.
- **Alternatives considered**: Generating deployable architecture or implementation artifacts was rejected because Reference Implementation remains the downstream owner. Adding diagrams and threat modeling was deferred because they require separate contracts and validation surfaces.

## Decision: Validate and publish atomically

- **Decision**: Resolve, validate, build, allocate, and verify all content in memory before committing one architecture record and one catalog update; any failure preserves pre-operation bytes.
- **Rationale**: Existing Highway workflows require no partial output, immutable upstream artifacts, bounded allocation retries, and deterministic repeated runs.
- **Alternatives considered**: Writing the record before the catalog was rejected because a later catalog failure would leave orphaned output. Updating the catalog before record validation was rejected because it could consume an identifier without a valid artifact.

## Decision: Use shell contract tests and the repository suite

- **Decision**: Add a focused architecture onboarding/contract test and run it with adapter coverage, validation checks, and the complete `.highway/tools/tests/run-all.sh` suite.
- **Rationale**: The repository uses shell tests as its executable contract surface and targets macOS Bash 3.2 without new dependencies.
- **Alternatives considered**: Introducing a new test framework was rejected because it would add runtime/toolchain dependencies and diverge from existing validation patterns.
