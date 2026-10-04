# Research: Visible Profile Structure

## Decision: Template section headings match sibling records

**Decision**: Use `## File Frontmatter` and `## Body`. Keep template identity as YAML frontmatter. Keep retained Context children at `###`.

**Rationale**: Clarification on 2026-10-03 selected the sibling heading level. The brief's `### File Frontmatter` labels are conceptual, not the accepted section headings.

**Alternatives considered**: Third-level section headings as written in the brief. Rejected by clarification.

## Decision: Retained path stays `profile.md`

**Decision**: The skill continues to name `.highway/library/knowledge/profile.md`.

**Rationale**: Clarification selected the existing path. The brief's `highway-profile` knowledge filename is not a relocation.

**Alternatives considered**: Rename to `.highway/library/knowledge/highway-profile` or `.highway/library/knowledge/highway-profile.md`. Rejected because no other requirement asks for a move.

## Decision: Template metadata version is 3.1.0

**Decision**: Increment `metadata.version` from `3.0.0` to `3.1.0`. Leave retained `schema_version` at `3.0.0`.

**Rationale**: No library-template versioning policy exists. The retained field contract continues to hold while the template description changes and the hidden body contract becomes a visible skeleton. That is a MINOR template change by analogy to the Skill Versioning Policy. Shared-content practice requires a version bump when template content changes. The library catalog currently repeats description and version `3.0.0`, so regeneration must publish `3.1.0` and the new description.

**Alternatives considered**: Leave template metadata at `3.0.0`. Rejected because the visible file content changes. MAJOR `4.0.0` was rejected because retained schema and field names do not change.

## Decision: Skill version is 7.0.0

**Decision**: Classify the skill change as MAJOR, `6.0.0` to `7.0.0`.

**Rationale**: The current skill says volunteered downstream detail may be used as evidence of the broad Competitive Path. The replacement incorporates only broad strategic meaning when it changes the path, and it forbids retaining the downstream specification. That narrows a behavioral guarantee. Replacing Verification is not a patch. No capability is added, so MINOR does not apply.

**Alternatives considered**: Keep `6.0.0` or publish `6.1.0`. Rejected under the Skill Versioning Policy.

## Decision: The template file is no longer a valid retained Profile

**Decision**: Stop copying `profile-record.md` into tests as a valid Profile. Add or reuse a retained empty-profile fixture with the schema `3.0.0` frontmatter and `# Organizational Profile` title, and point existing copy helpers at that fixture.

**Rationale**: Sibling templates are skeleton documents. After this change, `profile-record.md` contains template metadata, fenced skeletons, and rendering rules. `validate-profile.sh` correctly rejects that file as a retained Profile. Current callers are `profile-structure.test.sh`, `profile-behavior.test.sh`, `profile-lifecycle.test.sh`, `profile-markdown-contract.test.sh`, `feature-092-contract.test.sh`, and `fixtures/profile-092/profile-fixtures.sh`. Superseding the template-as-profile assertion is required by D3.5; retained validity stays covered by fixtures.

**Alternatives considered**: Teach the validator to accept the skeleton file. Rejected because the template is not a retained artifact and the validator is outside this feature's behavioral change.

## Decision: Lock the new rendering sentences and supersede the old hidden-comment phrases

**Decision**: Replace the assertions for `discussed always renders evidence`, `bounded renders accepted evidence`, and `not_discussed never renders a narrative section` with the sentences in `contracts/profile-record.md`. Record the superseded phrases.

**Rationale**: Those phrases live only in the hidden HTML comment that this feature removes. The new sentences are the accepted rendering contract.

**Alternatives considered**: Keep both old and new phrases. Rejected because that would preserve the hidden-comment wording the feature removes.

## Decision: Refresh generated artifacts, but do not hand-edit adapters

**Decision**: After the skill edit, run `generate-agent-adapters.sh`, `generate-catalog.sh`, and `generate-instructions.sh`. After the template edit, run `generate-library-catalog.sh`. Commit library-catalog description and version changes. If a generator changes only `generated_at` on an otherwise untouched catalog, restore that file. If adapter generation reorders unrelated manifest rows, restore the prior order of those unrelated rows and record the reason.

**Rationale**: D4.7 requires regeneration after a generator input change. A timestamp-only diff is not a content change. Unrelated manifest reordering is a known generator side effect and is not part of this feature.

**Alternatives considered**: Hand-edit adapter copies. Rejected by D4.1.
