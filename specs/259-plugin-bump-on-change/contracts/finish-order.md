# Contract: Covered-input finish order

## When

A Spec Kit feature (or equivalent change set) modifies covered plugin-build inputs under `skills/`
or `framework/plugin/` (other than a version-only edit).

## Sequence

1. `bash tests/run-all.sh --exclude-plugin-gen` → exit 0  
2. Harness (only if this feature already requires it) → exit 0  
3. Bump `version` in `framework/plugin/plugin.json` to a strictly greater `MAJOR.MINOR.PATCH` than
   the comparison baseline  
4. `bash framework/generate-agent-plugin.sh` → exit 0  
5. `bash tests/run-all.sh --plugin-gen-only` → exit 0  

## Out of scope

- Public publish / promote  
- Newly mandating harness for every covered-input feature  
