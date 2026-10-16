# Research: Highway Assessment

## Decision 1: Keep assessment logic in one canonical skill

**Decision**: Implement the workflow in `.highway/skills/highway-assessment/SKILL.md`. Generated adapters are produced by the existing adapter generator.

**Rationale**: The feature explicitly centralizes observation, analysis, correlation, and assessment. Existing artifact owners remain responsible for their own create, update, validate, and persist behavior.

**Alternatives considered**: Adding assessment sections to onboarding, architecture, implementation, or other owner skills was rejected because it would distribute ownership and create inconsistent behavior.

## Decision 2: Persist findings as one shared knowledge artifact

**Decision**: Persist the finding table in `.highway/library/knowledge/assessment-findings.md` with the standard library frontmatter and a single revision field.

**Rationale**: The MVP requires one durable retained artifact and no new artifact family. The existing library validator provides the repository's schema and governance boundary.

**Alternatives considered**: A finding catalog, `ASF` identifier family, per-finding files, or a database were rejected as out of scope and inconsistent with Git-native repository authority.

## Decision 3: Separate display identity from equivalence identity

**Decision**: Allocate sequential zero-padded `F###` display IDs for new findings and persist a deterministic fingerprint for equivalence checks. Reuse both the existing finding and display ID when the fingerprint matches.

**Rationale**: Human-readable IDs remain stable and easy to review while normalized fingerprints prevent duplicate findings when wording or analysis order changes.

**Alternatives considered**: Deriving `F###` directly from the fingerprint was rejected because it would make a human-facing sequential identifier encode an implementation detail. Using the fingerprint alone was rejected because it would reduce reviewability.

## Decision 4: Normalize fingerprints deterministically

**Decision**: Normalize line endings to LF, trim leading and trailing whitespace, lowercase values, collapse consecutive whitespace, and compose the fingerprint from Category, Domain, and normalized Finding Text.

**Rationale**: These rules make equivalent findings comparable across repeated runs while preserving meaningful differences.

**Alternatives considered**: Semantic similarity, model judgment, timestamps, filesystem ordering, and source artifact ordering were rejected because they are non-deterministic or exceed the MVP identity contract.

## Decision 5: Reject stale writes

**Decision**: Read and validate the findings revision before mutation. If the supplied revision differs from the stored revision, reject the update and require reload before retry. Increment revision exactly once after a successful write.

**Rationale**: The user selected stale-update rejection, which prevents last-write-wins data loss for concurrent reviewers.

**Alternatives considered**: Automatic merge and last-write-wins were rejected for the MVP because they can silently alter another reviewer's status or disposition.

## Decision 6: Use existing validation and generation tooling

**Decision**: Add a focused shell contract test and run the existing skill/library validators, adapter generator, catalog generators, full suite, and `git diff --check`.

**Rationale**: The repository already has deterministic generators and Bash 3.2-compatible test conventions. No new dependency is justified.

**Alternatives considered**: Introducing a new test framework or generator was rejected because it would increase the shipped surface without adding needed coverage.
