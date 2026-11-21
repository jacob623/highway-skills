# Quickstart: Plugin Bump on Change

## Prerequisites

- Repo on a feature branch with `main` (or `origin/main`) fetchable for merge-base  
- `python3`, `git`, bash  

## Validate version-bump guard

```bash
# Expect fail when skills differ from main and version equals baseline:
bash tests/plugin-version-bump.test.sh

# After bumping framework/plugin/plugin.json to a greater semver:
bash tests/plugin-version-bump.test.sh   # expect pass for version condition
```

## Validate suite exclude / only

```bash
bash tests/run-all.sh --exclude-plugin-gen
bash tests/run-all.sh --plugin-gen-only
```

## Finish-order dry run (covered-input feature)

See [contracts/finish-order.md](./contracts/finish-order.md).

## Docs / constitution

- `framework/README.md` states the finish order and closed list  
- `.specify/memory/constitution.md` encodes the obligation (not `framework/constitution.md`)  
