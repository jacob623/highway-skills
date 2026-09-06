# catalog/

This directory holds the **generated** skill catalog. Nothing here is hand-edited.

- `index.json` — authoritative, machine-readable catalog. Conforms to
  [../../specs/001-multi-agent-skill-suite/contracts/catalog.schema.json](../../specs/001-multi-agent-skill-suite/contracts/catalog.schema.json).
  This is the contract a future, out-of-scope external application would consume to perform
  automated overlap detection.
- `index.md` — generated, human-readable rendering of `index.json`, for browsing the catalog
  without parsing JSON.

Both files are produced by running:

```sh
.highway/tools/generate-catalog.sh
```

Regenerating with no changes under `.highway/skills/` produces a byte-identical `index.json` (aside from
the `generated_at` timestamp) — see `data-model.md`'s determinism requirement. `overlap_flags` in
`index.json` are reviewer-maintained (see `.highway/skills/_authoring-standard.md`'s Manual Overlap
Review section) and are preserved across regenerations.
