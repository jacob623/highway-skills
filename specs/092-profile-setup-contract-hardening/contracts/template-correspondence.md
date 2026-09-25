# Template and Correspondence Contract

## Authoritative paths

- Shared output template: `.highway/library/templates/output/profile-record.md`
- Retained user-owned Profile: `.highway/library/knowledge/profile.md`
- Removed output templates: `.highway/library/templates/output/profile.md` and `.highway/library/templates/output/profile.yaml`

## Template boundary

`profile-record.md` is a library artifact that defines the complete reusable Profile structure. Its own metadata is not part of generated retained Profile content. The retained Profile contains only accepted organizational evidence and supported state/narrative structure.

## Correspondence procedure

Before regeneration:

1. List each Feature 092-changed authoritative source.
2. Use existing catalog, adapter, manifest, and distribution correspondence mechanisms to identify dependents.
3. Record each source/dependent pair, or `None` when no dependent exists.
4. Regenerate only identified dependents.
5. Run correspondence checks and record the result.

Generated adapters and catalogs must be derived from current source skills. No generated artifact may continue to cite the removed output-template paths or YAML fallback.
