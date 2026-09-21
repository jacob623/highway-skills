# Research: Highway New Shared Output Contract Migration

## Decision 1: Keep the Request templates as the sole structural authorities

**Decision**: Keep `.highway/library/templates/output/request-record.md` and
`.highway/library/templates/output/request-catalog.md` unchanged and make `highway-new` cite them
as the complete structures for its two retained outputs.

**Rationale**: Feature 063 changes ownership wording and verification, not user-owned Request
shape. The templates already provide the shared contract required by P9.1 and avoid a second
structure namespace.

**Alternatives considered**: Restating the Request sections in `highway-new`; rejected because it
recreates drift. Changing the templates; rejected because template migration is explicitly out of
scope.

## Decision 2: Retain all behavioral rules in the canonical skill

**Decision**: Remove only duplicated record and catalog structure prose. Retain evidence collection,
privacy screening, deterministic questions/examples/title generation, allocation and retry limits,
validation, transactions, status, Solution Constraints semantics, and Discovery/ADR boundaries.

**Rationale**: Templates can own serialized shape but cannot decide intake completeness, privacy,
allocation, or handoff behavior. The requested migration is safe only when those behavioral
invariants remain directly stated and testable in `highway-new`.

**Alternatives considered**: Moving all output-related text to templates; rejected because it would
weaken workflow behavior and make the templates responsible for decisions they cannot express.

## Decision 3: Extend existing shell validation with disposable fixtures

**Decision**: Add focused source-document and disposable-fixture assertions to the repository's
existing output-contract or `highway-new` test surface, using temporary copies and independent
seeded defects.

**Rationale**: The repository already validates Markdown contracts with Bash 3.2-compatible tools,
keeps generated artifacts derived, and uses disposable probes for contract enforcement. Reusing
that surface avoids a new dependency and proves that canonical and user-owned bytes are preserved.

**Alternatives considered**: Introducing a parser or external test framework; rejected because the
existing shell harness already expresses the required checks and the project has no runtime API.

## Decision 4: Regenerate all derived highway-new adapters from canonical source

**Decision**: Run the existing adapter generator after the canonical skill changes and validate
GitHub Copilot, Claude Code, and Cursor correspondence through the existing adapter-coverage and
package checks.

**Rationale**: Generated adapters are derived artifacts and manual edits would create source drift.
The repository's established generator and coverage checks already define the expected workflow.

**Alternatives considered**: Editing generated adapters directly; rejected because it violates
canonical-source ownership and risks inconsistent distributed skills.

## Decision 5: Do not create external contracts

**Decision**: Leave `contracts/` absent for Feature 063.

**Rationale**: The feature changes internal Markdown skill contracts, shared-template citations,
validation scripts, and generated adapters. It exposes no network endpoint, public library API,
or external command schema.

**Alternatives considered**: Treating developer test commands as public interfaces; rejected because
they are repository validation tools, not user-facing integrations.
