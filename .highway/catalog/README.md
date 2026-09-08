# catalog/

This directory holds the **generated** skill catalog and the **generated** shared library
catalog. Nothing here is hand-edited.

- `index.json` — authoritative, machine-readable skill catalog. Conforms to the catalog schema
  defined by feature 006 (help skill), which supersedes the schema from feature 001 (multi-agent
  skill suite) by adding the required `usage` field. This is the contract a future, out-of-scope
  external application would consume to perform automated overlap detection.
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

- `library-index.json` — authoritative, machine-readable listing of every file under
  `.highway/library/`, grouped by library type. Conforms to the library catalog schema defined by
  feature 005 (rename content to library).
  Kept as a separate, sibling schema rather than an extension of `index.json`'s schema, since
  that schema is closed to additional properties and shaped around skill-only fields
  (`compatibility`, `overlap_flags`) that do not fit a governance or knowledge file.
- `library-index.md` — generated, human-readable rendering of `library-index.json`, grouped by
  library type.

Both are produced by running:

```sh
.highway/tools/generate-library-catalog.sh
```
