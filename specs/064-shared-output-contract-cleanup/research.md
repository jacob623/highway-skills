# Research: Final Shared Output Contract Cleanup

## Decision 1: Keep the existing shared templates as the sole structural authorities

**Decision**: Keep `.highway/library/templates/output/control-catalog.md`,
`.highway/library/templates/output/discovery-record.md`, and
`.highway/library/templates/output/discovery-catalog.md` unchanged. Make the two affected skills
cite those complete templates for retained structure and replace duplicated shape prose with
conformance wording.

**Rationale**: Feature 062 established the shared-output model and the templates already define the
retained artifact identities, headings, ordering, fields, and catalog layout. Changing templates in
this feature would expand scope and could alter user-owned output interpretation.

**Alternatives considered**: Restating the missing shape in each skill; rejected because it recreates
structural drift. Changing the templates; rejected because template changes are explicitly out of
scope.

## Decision 2: Refactor only structural declarations and preserve behavior

**Decision**: In `highway-controls`, remove duplicated catalog listing/version/next-ID/management
shape declarations while retaining catalog derivation, no-timestamp determinism, allocation,
versioning, transaction, relationships, readiness, and NFR proposal behavior. In
`highway-discovery`, remove duplicated record headings, ordering, catalog fields, and index shape
while retaining input resolution, constraint handling, candidate generation/elimination, scoring,
ranking, recommendation, Reference Architecture and Reference Implementation evaluation,
allocation, privacy, determinism, no-write behavior, and ADR boundaries.

**Rationale**: Shared templates can define serialization shape but cannot own workflow decisions.
The skill contracts must continue to state behavior and ownership boundaries directly so agents do
not lose safety or advisory semantics during the migration.

**Alternatives considered**: Moving all output-related wording into templates; rejected because it
would make templates responsible for behavioral decisions and weaken validation of the workflows.

## Decision 3: Extend existing focused shell validation surfaces

**Decision**: Extend `.highway/tools/tests/output-template.test.sh` for shared citation and
structural-duplication assertions, and extend `.highway/tools/tests/highway-discovery.test.sh` for
Discovery-specific structure and behavior probes. Use temporary copies and independently seeded
failures for missing citations, reintroduced duplication, removed behavior, stale adapters, and
fixture residue.

**Rationale**: These tests already validate shared templates and Discovery behavior using the
repository's Bash 3.2-compatible toolchain, declared artifact classes, and disposable workspaces.
Reusing them preserves the existing enforcement and seeded-probe conventions without a new runtime.

**Alternatives considered**: A parser or external test framework; rejected because the current shell
harness already expresses the required document-contract checks and adding a dependency would breach
the repository's toolchain discipline.

## Decision 4: Regenerate all derived adapters from canonical skills

**Decision**: Run `.highway/tools/generate-agent-adapters.sh` after both canonical skill changes and
validate the GitHub Copilot, Claude Code, and Cursor outputs through existing adapter coverage and
distribution checks.

**Rationale**: Adapters are generated artifacts. Regeneration preserves canonical-source ownership
and ensures every representation reflects the migrated contract without hand-edited drift.

**Alternatives considered**: Editing six adapters directly; rejected because generated files are not
independent contract authorities and direct edits can produce cross-agent inconsistency.

## Decision 5: No external contracts or runtime design

**Decision**: Do not create `contracts/`, a parser, persistence mechanism, external service, or
runtime interface.

**Rationale**: The feature changes internal Markdown skill contracts, shared-template citations,
focused developer validation, and generated adapters. It exposes no network endpoint, library API,
or user-facing command schema beyond existing skills.

**Alternatives considered**: Treating test commands as public interfaces; rejected because they are
repository validation tools rather than external integrations.
