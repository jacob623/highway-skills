# Research: Seed Library Context Documents

## Decision 1: Store the copies in the knowledge library

- **Decision**: Place the three files directly under `.highway/library/knowledge/` with their existing filenames.
- **Rationale**: The documents are shared repository knowledge, and the feature specification explicitly selects the existing knowledge directory. Keeping the same filenames preserves discoverability and makes the source-to-library mapping deterministic.
- **Alternatives considered**: The library root was rejected because the repository already separates shared content by type. The governance and templates directories were rejected because these files are neither governance policies nor output templates.

## Decision 2: Treat the copy as an opaque byte operation

- **Decision**: Copy the source files without parsing, normalizing, reformatting, or regenerating their Markdown.
- **Rationale**: Byte identity is the feature's primary acceptance condition. An opaque filesystem copy preserves whitespace, line endings, encoding, and final-byte state.
- **Alternatives considered**: Reading and rewriting Markdown was rejected because it could normalize line endings or final newlines. Frontmatter transformation was rejected because no content transformation is requested.

## Decision 3: Preflight all sources, then copy and compare

- **Decision**: Check that all three exact source paths exist before producing destination output; copy each source to its matching destination and compare the result byte-for-byte.
- **Rationale**: A complete preflight prevents a missing source from producing a misleading partial success. A post-copy comparison makes the byte-for-byte requirement executable.
- **Alternatives considered**: Copying files one at a time before checking the complete source set was rejected because it can leave an incomplete library after a missing-source failure.

## Decision 4: Make reruns deterministic by replacing destination bytes

- **Decision**: If a destination exists with different bytes, replace it with the exact source bytes and verify the result; an exact existing destination is accepted as already complete.
- **Rationale**: The feature requires that successful completion never leave stale or conflicting destination content. Replacement keeps reruns convergent while preserving the source as the authority.
- **Alternatives considered**: Failing on every existing destination was rejected because it makes an already-correct rerun unnecessarily non-idempotent. Silently retaining a mismatch was rejected by FR-006.

## Decision 5: Validate through a focused repository test

- **Decision**: Add a focused test that checks source existence, destination existence, byte equality, source preservation, missing-source failure behavior, conflicting-destination convergence, and unrelated-file preservation.
- **Rationale**: These checks directly cover the feature's acceptance scenarios and can run under the repository's existing Bash 3.2-compatible test suite without adding a runtime dependency.
- **Alternatives considered**: Relying only on manual inspection was rejected because byte identity and failure behavior are deterministic and inexpensive to test automatically.

## Decision 6: No external interface contract

- **Decision**: Do not create a `contracts/` artifact for this feature.
- **Rationale**: The feature exposes no API, CLI schema, service endpoint, or cross-process protocol. Its contract is the source-to-destination file mapping and executable validation documented in the data model and quickstart.
- **Alternatives considered**: A command contract was considered but rejected because no new command is required by the specification.

## Decision 7: Keep opaque context documents out of the frontmatter catalog

- **Decision**: Exclude the three exact context filenames from `generate-library-catalog.sh` while retaining them in `.highway/library/knowledge/`.
- **Rationale**: The existing catalog validates every discovered Markdown file as a frontmatter-bearing library artifact. These requested copies must remain byte-for-byte identical to the root documents, which do not carry that frontmatter, and the feature explicitly does not require catalog entries.
- **Alternatives considered**: Adding frontmatter was rejected because it violates byte identity. Relaxing validation for every knowledge file was rejected because it would weaken existing library enforcement. Moving the files outside `knowledge/` was rejected because the requested destination is fixed.

## Decision 8: Keep temporary root seeds out of distributions

- **Decision**: Exclude the three temporary root source paths from `.highway/tools/.distribution-manifest` until the maintainer deletes them manually.
- **Rationale**: The root files are temporary implementation inputs, not shipped library copies. Explicit exclusion keeps packaging deterministic and prevents temporary source residue from entering the user-facing distribution.
- **Alternatives considered**: Including the root files was rejected because they are temporary and not part of the requested retained library surface. Leaving them unclassified was rejected because the manifest requires every repository path to be classified deliberately.
