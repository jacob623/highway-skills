# Contract: Plugin generation–specific suite list

## Closed list (authoritative)

1. `plugin-version-bump.test.sh`  
2. `agent-plugin.test.sh`  

No other suite member is plugin generation–specific unless this contract, `tests/run-all.sh`, and
`framework/README.md` are amended together.

## Suite flags

```text
bash tests/run-all.sh --exclude-plugin-gen   # skip the closed list
bash tests/run-all.sh --plugin-gen-only      # run only the closed list
bash tests/run-all.sh                        # run everything (default)
```

`--exclude-plugin-gen` and `--plugin-gen-only` are mutually exclusive.
