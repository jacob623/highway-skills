# Research: Highway Profile Path Migration

## Decision: Treat the canonical profile as a pure-YAML shared output artifact

**Decision**: Use `.highway/library/templates/output/profile.yaml` as the single authoritative profile and validate its exact YAML structure with the profile-specific validator. Do not wrap it in Markdown frontmatter or maintain a second Markdown artifact as the profile template.

**Rationale**: The specification requires a directly parseable YAML document, retained empty mappings, exact top-level ordering, and no frontmatter. The existing Markdown library validator's frontmatter contract is not an appropriate representation of this artifact.

**Alternatives considered**:
- Keep `.highway/profile.yaml`: rejected because it preserves the obsolete location and prevents one authoritative distributed path.
- Convert the profile to Markdown: rejected because it violates the pure-YAML requirement.
- Treat the profile as unvalidated data: rejected because schema/order/path integrity must be executable and distribution-safe.

## Decision: Use a repository-wide former-path audit

**Decision**: Add focused checks that fail when `.highway/profile.yaml` exists or when the former path appears in source, tests, fixtures, catalogs, adapters, adapter manifests, distribution manifests, or other distribution metadata. Require the canonical path to appear exactly where packaging expects it.

**Rationale**: A file move alone does not remove stale generated or packaging references. An explicit audit makes the zero-orphan success criterion repeatable and catches regressions when generated artifacts are refreshed.

**Alternatives considered**:
- Check only the two profile files: rejected because generated and manifest artifacts can retain stale paths.
- Rely on a full-suite pass: rejected because current tests may not assert absence of orphaned artifacts.
- Ignore generated outputs until release: rejected because the distribution correspondence rules require them to be current before packaging.

## Decision: Make version maintenance transactional

**Decision**: Carry the version in the proposed profile state and write it only after confirmation and successful content serialization. Use PATCH for confirmed add/update/remove, MINOR for confirmed reset, and MAJOR for schema-breaking changes. Declines and pre-write failures leave both content and version unchanged.

**Rationale**: Version changes describe accepted user-owned profile changes; advancing a version for a declined or failed operation would make the artifact history unreliable.

**Alternatives considered**:
- Increment before confirmation: rejected because declined operations would mutate the version.
- Increment after any command: rejected because malformed or ambiguous input is not a committed change.
- Use timestamps or generated change IDs: rejected because deterministic output is required.

## Decision: Regenerate all derived distribution artifacts

**Decision**: Update source inputs and the user-maintained distribution manifest as required, then regenerate catalogs, adapters, and distribution outputs and run correspondence tests.

**Rationale**: The repository treats generated artifacts as derived records; manual edits create drift and violate the development constitution. The path move changes both source inputs and packaging membership.

**Alternatives considered**:
- Hand-edit generated catalogs or adapters: rejected by D4.1 and D4.7.
- Leave old generated entries for compatibility: rejected because Feature 025 requires zero orphaned references.
- Add a second compatibility path: rejected because it creates two authoritative locations.

## Decision: Preserve user-owned values during relocation

**Decision**: Move profile content without normalizing wording, capitalization, grouping, ordering, or semantic values. Only the required path, schema representation, and version changes are applied.

**Rationale**: The profile is contextual user-owned input. A migration must not silently rewrite its meaning while changing its repository location.

**Alternatives considered**:
- Rebuild the default from questionnaire answers: rejected because migration should not infer or seed user content.
- Normalize all YAML formatting: rejected because byte-level preservation and user wording are explicit constraints.
