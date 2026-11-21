# Data Model: Highway Repository Pointer

## Entities

### Open project

The working tree where the skill was invoked.

| Field | Notes |
| --- | --- |
| Root path | Agent cwd / workspace root for the invocation |

### Highway knowledge root

Directory that holds organizational Highway records.

| Recognition | Rule |
| --- | --- |
| Marker A | Readable `library/knowledge/profile.md` |
| Marker B | Readable `library/knowledge/storage.md` |
| Knowledge root? | Either marker present and readable |

### Committed repository pointer

Path in **open project**: `hw-repository.md`

| Field | Type | Rules |
| --- | --- | --- |
| `repository` | git URL string | Required when file exists; portable HTTPS or SSH git URL; never an absolute filesystem path; file not gitignored by this feature |

Illustrative body:

```markdown
# Highway repository

repository: https://github.com/org/highway
```

### Local repository pointer

Path in **open project**: `hw-repository.local.md`

| Field | Type | Rules |
| --- | --- | --- |
| `path` | filesystem path | Required when file exists; absolute **or** relative to open project root; must resolve to a readable directory that is a Highway knowledge root before use or persist; file MUST be listed in `.gitignore` when written by this feature |

Illustrative body:

```markdown
# Highway repository (local)

path: /absolute/or/relative/path/to/highway-checkout
```

### Effective knowledge root

Computed per run (not a stored file).

| Priority | Condition | Result |
| --- | --- | --- |
| 1 | Usable local pointer (FR-004a) | That directory |
| 2 | Else open project is knowledge root | Open project |
| 3 | Else committed URL only | Not ready (URL-only guidance); no Local root |
| 4 | Else | Dual gate |

**Override**: When activating skill is `highway-setup` and person chooses setup-here, effective root
for that setup run is the **open project** even if a local pointer file exists.

### Experience readiness result

| Result | Meaning |
| --- | --- |
| ready | Effective knowledge root established; owning skill may proceed |
| not-ready | Gate or URL-only or invalid path; owning skill writes nothing and ends (except setup-here inside `highway-setup`) |

## Relationships

- Pointer files live in the **open project**, never inside the knowledge tree they point at (unless
  open project is also the knowledge root and someone commits a self-pointer — not required).
- Mode record `library/knowledge/storage.md` is always under the **effective** knowledge root.
- Product/code targets (Phase 16) are not modeled here and must not reuse these file names.

## Validation rules

1. Do not persist local pointer unless path passes knowledge-root check and gitignore accepted.
2. Do not persist committed pointer with a filesystem path in `repository:`.
3. Reject unreadable / non-knowledge local paths without falling back to open non-knowledge cwd.
