# Contract: Storage effective knowledge root

**Consumer**: Every Highway skill via `highway-experience` → `references/storage-contract.md`

## Obligations

1. Define **effective Highway knowledge root** and state that all four storage operations use paths
   relative to that root (Local working tree = that root).
2. Document resolution order: usable local pointer → cwd knowledge root → URL-only stop → dual
   gate (owned by experience).
3. Document pointer files (see `pointer-files.md`); knowledge-only; not product code targets.
4. Mode record read/write under effective root.
5. Exception: local pointer `path:` may be absolute as configuration that sets the root; skill
   storage-operation arguments remain relative.
6. Version bump MINOR on the storage-contract document.

## Non-goals

- Filling Remote or Chat operation columns beyond “not supported yet” plus URL-only Local note.
- MCP.
