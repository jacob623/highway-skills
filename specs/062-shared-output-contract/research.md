# Research: Shared Output Contract Implementation

## Decision 1: Use the existing `.highway/library/templates/output/` library as the sole structural authority

**Decision**: Keep retained record and catalog templates under `.highway/library/templates/output/`, and make each emitting skill cite the complete template for every retained file it produces.

**Rationale**: Constitution P9.1 requires file-emitting skills to cite a shared template for the complete structure. The current repository already uses this library for Request, Objective, Control, NFR, Discovery, Profile, and Clarification artifacts. Extending the existing location avoids a second contract namespace and keeps validators and generators aligned.

**Alternatives considered**: Defining structure inside each skill; rejected because it preserves duplication and contract drift. Creating a new contract directory; rejected because it would duplicate the established library boundary.

## Decision 2: Create catalog templates from current generated catalog behavior

**Decision**: Add Objective, Control, and NFR catalog templates where absent. Preserve the current user-owned catalog paths, version semantics, next-ID semantics, index fields, ownership statements, and ordering behavior observed in the corresponding skills and generated catalogs.

**Rationale**: The feature requires a complete record/catalog pair for each retained baseline, but the current inventory has only Request and Discovery catalog templates. Creating templates from current behavior makes the template authoritative without changing the behavior or persisted user-owned artifacts.

**Alternatives considered**: Replacing existing catalogs with a new unified format; rejected because it changes user-owned structure and allocation semantics outside scope. Treating generated catalogs as the authority; rejected because generated outputs are derived and can become stale.

## Decision 3: Keep behavioral rules in skills and remove only duplicated structural prose

**Decision**: Refactor Outputs and Verification sections to cite complete templates while retaining workflow, lifecycle, ownership, allocation, versioning, validation, readiness, relationship, transaction, determinism, and domain-specific decision rules in the skills.

**Rationale**: Templates define shape; skills define behavior. Removing behavioral statements would weaken workflows and make the migration unsafe. The distinction is directly testable by checking required behavior tokens after structural prose is removed.

**Alternatives considered**: Moving all output-related prose into templates; rejected because templates cannot own workflow decisions, filtering, allocation, readiness, or transaction behavior.

## Decision 4: Extend the existing output-template test instead of adding a new test framework

**Decision**: Add shared-output contract assertions to `.highway/tools/tests/output-template.test.sh`, using the existing shell conventions, validators, generated-artifact checks, temporary workspaces, and seeded probe model.

**Rationale**: The existing test already verifies P9.1 registration, record templates, skill citations, validators, and dependent skill coverage. Extending it keeps the repository's enforcement map centralized and avoids new dependencies.

**Alternatives considered**: A new parser or external test framework; rejected because the project is Markdown/Bash governance tooling and the current test vocabulary already covers the needed contract checks.

## Decision 5: Treat the five baseline pairs as the primary scope

**Decision**: Migrate Request, Objective, Control, NFR, and Discovery record/catalog pairs. Keep Profile YAML and Clarification record contracts under existing shared-template governance, but do not redesign them in this feature.

**Rationale**: These five are the retained baseline types explicitly named in the feature brief and each has an emitting skill or established retained catalog. Profile and Clarification are already shared-template consumers with different structural formats and would broaden the migration without improving the requested baseline contract.

**Alternatives considered**: Migrate every output template in one pass; rejected because YAML and interactive clarification contracts have different structural semantics and would increase risk without changing the five-baseline ownership outcome.

## Decision 6: No external API contracts are needed

**Decision**: Do not create `contracts/` for Feature 062.

**Rationale**: The feature changes internal Markdown skill contracts, shared templates, validation scripts, and generated adapters/catalogs. It exposes no network endpoint, public library API, or external command schema.

**Alternatives considered**: Documenting shell commands as external contracts; rejected because the commands are repository developer validation tools, not user-facing integration interfaces.
