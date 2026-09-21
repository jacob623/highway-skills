# Research: highway-nfrs Shared Output Contract Final Cleanup

## Decision 1: Keep the existing NFR templates unchanged and make them the sole structural authorities

**Decision**: Keep `.highway/library/templates/output/nfr-record.md` and
`.highway/library/templates/output/nfr-catalog.md` unchanged. Make `highway-nfrs` cite both complete
templates for retained structure and replace duplicated shape prose with conformance wording.

**Rationale**: The templates already define the retained NFR record frontmatter/body and catalog
headings/version/next identifier/index structure. Changing them would expand scope and could alter
the interpretation of user-owned outputs.

**Alternatives considered**: Restating the missing shape in the skill; rejected because it recreates
structural drift. Changing the templates; rejected because template changes are outside this feature.

## Decision 2: Refactor only structural declarations and preserve NFR workflow behavior

**Decision**: Remove the duplicated NFR record field/body verification and catalog contents/layout
prose from `highway-nfrs`. Retain classification, Control routing, outcome routing, allocation,
versioning, destructive-action confirmation, relationship boundaries, transaction safety,
determinism, validation, readiness, and no-write failure behavior.

**Rationale**: Shared templates own serialization shape, while skills must continue to state workflow
rules and safety boundaries directly. Moving behavior into templates would weaken the skill contract.

**Alternatives considered**: Moving all output-related wording into templates; rejected because that
would make templates responsible for workflow decisions. Removing all verification; rejected because
behavioral and template-conformance validation remain necessary.

## Decision 3: Extend existing NFR-focused shell validation surfaces

**Decision**: Extend `.highway/tools/tests/output-template.test.sh` and
`.highway/tools/tests/nfr-management.test.sh` with independent disposable probes for missing
citations, restored record/catalog shape, removed behavior, stale adapters, byte preservation, and
fixture cleanup.

**Rationale**: These tests already validate shared output templates and the `highway-nfrs` contract
using the repository's macOS Bash 3.2-compatible conventions. Reusing them avoids a new framework or
dependency and preserves existing seeded-failure evidence.

**Alternatives considered**: Adding a parser or external test framework; rejected because the current
shell harness already expresses these document-contract checks and toolchain discipline prohibits
unneeded dependencies.

## Decision 4: Regenerate all derived NFR adapters from the canonical skill

**Decision**: Run `.highway/tools/generate-agent-adapters.sh` after the canonical skill change and
validate the GitHub Copilot, Claude Code, and Cursor outputs through existing adapter coverage and
distribution checks.

**Rationale**: Generated adapters are derived artifacts and cannot be independent contract
 authorities. Regeneration prevents stale or hand-edited representations.

**Alternatives considered**: Editing three adapters directly; rejected because it can create
cross-agent inconsistency and violates canonical-source ownership.

## Decision 5: No external contracts or runtime design

**Decision**: Do not create `contracts/`, a parser, persistence mechanism, external service, or new
runtime interface.

**Rationale**: This feature changes an internal Markdown skill contract, focused developer
validation, and generated adapters. It exposes no network endpoint, library API, or new command
schema.

**Alternatives considered**: Treating test commands as public interfaces; rejected because they are
repository validation tools rather than external integrations.
