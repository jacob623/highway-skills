# Quickstart: Highway Repository Pointer

Validate after implementation. Run from repository root.

## Prerequisites

- Suite dependencies as today (`tests/run-all.sh`)
- Plugin regenerate after skill edits: `framework/generate-agent-plugin.sh` (or project’s usual
  generate path)

## 1. Static suite

```sh
tests/run-all.sh
```

Expect pass, including new `tests/repository-pointer.test.sh` and updated
`catalog-seeding.test.sh` / `storage-contract.test.sh`.

## 2. Contract pins

Confirm:

- `skills/highway-experience/references/storage-contract.md` defines effective root + pointers
- `skills/highway-experience/assets/repository-gate.md` exists
- Owning skills listed in the catalog-seeding check no longer contain the Oops headline block
- No skill named `highway-repository`

## 3. Manual dual-tree check (optional)

1. Create `/tmp/hw-knowledge` with a minimal knowledge root (`library/knowledge/storage.md`
   Mode Local, and/or `profile.md`).
2. Create `/tmp/hw-open` empty (not a knowledge root).
3. In an agent with Highway skills, open `/tmp/hw-open`, run `highway-request` (or help that
   activates experience): expect dual gate.
4. Provide path `/tmp/hw-knowledge`, accept persist + gitignore: expect
   `/tmp/hw-open/hw-repository.local.md` and ignore entry; skill continues against knowledge
   tree.
5. Re-run: no re-prompt while path valid.
6. URL-only: write only `hw-repository.md` with a URL, no local path → expect URL-only stop,
   no catalogs under `/tmp/hw-open`.

## Expected outcomes

| Scenario | Outcome |
| --- | --- |
| Pointer to knowledge root | Storage hits knowledge tree |
| No pointer, non-knowledge open | Dual gate; no silent seed |
| URL only | Guidance; no Local writes as knowledge into open |
| Single knowledge cwd, no pointers | Unchanged Local behavior |
