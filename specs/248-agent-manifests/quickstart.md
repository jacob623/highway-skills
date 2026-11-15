# Quickstart: Agent Manifests

Run from the repository root. The bash suite takes about 11 minutes; run one at a time.

## Build and inspect

```bash
framework/generate-agent-plugin.sh
ls -A highway-agent-plugin
framework/validate-plugin.sh highway-agent-plugin
framework/generate-agent-plugin.sh --check
```

Expected: the folder lists the shipped set from [data-model.md](data-model.md); the validator
prints `OK: highway-agent-plugin (16 skill(s))`; `--check` prints nothing and exits 0.

## Prove one source

1. Change `description` in `framework/plugin/plugin.json`, run the generator, and run `git status
   --short highway-agent-plugin`: exactly the six manifests changed. Revert the edit and rebuild.
2. Add `"homepage": "x"` to the `cursor` entry in `framework/plugin/listing.json` and run the
   generator: it prints `ERROR: [LISTING] cursor.homepage: ...` and writes nothing. Revert.
3. Edit any generated manifest by hand and run `--check`: it reports `DRIFT differs <path>`.
   Rebuild.

## Suites

```bash
export PATH="$HOME/.local/node/bin:$PATH"
bash tests/agent-plugin.test.sh
bash tests/run-all.sh
npm --prefix harness test
npm --prefix harness run typecheck
```

## Copilot smoke run

```bash
node harness/src/cli.ts --agent copilot --smoke > specs/248-agent-manifests/harness/smoke.log
```

Expected: every attempt's log shows `system: installed plugin highway (16 skills)`; the log is
under 100 KB and holds no token or temporary path. Contract for the checks:
[contracts/checks.md](contracts/checks.md).
