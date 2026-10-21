# Research: Remove Unused Skills

## Decision: Delete the four skill directories and do not reserve the names

- **Decision**: Remove `.highway/skills/highway-clarify/`, `highway-inquiry/`, `highway-relationships/`, and `highway-new/`. Do not leave a stub that redirects the old name.
- **Rationale**: The spec says these skills are no longer offered. `highway-new` was only a reserved name after the request skill took its behavior. A stub would still offer the name.
- **Alternatives considered**: Keeping `highway-new` as a pointer to `highway-request` was rejected because the spec removes that skill.

## Decision: Delete owned templates and keep the shared request templates

- **Decision**: Delete `.highway/library/templates/output/clarification-record.md`, `clarification-catalog.md`, and `.highway/library/templates/requirements-inquiry.md`. Keep `request-record.md` and `request-catalog.md`.
- **Rationale**: Only `highway-clarify` cites the clarification templates. Only `highway-inquiry` cites the inquiry template. `highway-request` cites both request templates. Discovery may read an existing clarification record when one is present, and that does not require the template files.
- **Alternatives considered**: Deleting the request templates with `highway-new` was rejected because the request skill still writes them. Rewriting Discovery to stop mentioning clarifications was rejected because the spec leaves the remaining skills unchanged.

## Decision: Delete published copies and distribution rows, then regenerate catalogs

- **Decision**: Remove each skill's adapter directory under `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/`. Remove its `include` rows from `.highway/tools/.distribution-manifest`. Run `generate-catalog.sh` and `generate-library-catalog.sh` afterward. Run `generate-agent-adapters.sh` only to confirm the remaining adapters are unchanged.
- **Rationale**: The adapter generator copies skills and does not delete an adapter whose source is gone. D4.6 requires that no catalog entry, adapter, or distribution row name a missing skill.
- **Alternatives considered**: Hand-editing the generated catalog was rejected because catalogs are generated. Leaving the adapters in place was rejected because they would still offer the skill.

## Decision: Remove tests that only cover the deleted skills and edit mixed tests

- **Decision**: Delete `.highway/tools/tests/highway-clarify.test.sh`, `highway-new.test.sh`, and `relationship-integrity.test.sh`. Edit `output-template.test.sh` and `highway-ux-alignment.test.sh` so they no longer require the removed skills or the clarification templates. Record each removal in `specs/187-remove-unused-skills/retirements.md` with the skill it served.
- **Rationale**: Those three tests exist for the removed skills. The other two also protect templates and experience wording for skills that stay.
- **Alternatives considered**: Deleting `output-template.test.sh` was rejected because it still checks the shared templates the remaining skills cite.

## Decision: Leave historical feature specs in place

- **Decision**: Do not delete past `specs/` directories that mention the removed skills. Do not change the remaining skill text to scrub an optional clarification mention.
- **Rationale**: Those specs are the history of earlier decisions. They do not offer the skill. The spec allows a mention that does not offer the skill or require its template.
- **Alternatives considered**: Rewriting every historical spec was rejected because it would change records that are not the product surface.
