# Contract: `framework/generate-agent-plugin.sh`

## Usage

```text
framework/generate-agent-plugin.sh            build highway-agent-plugin/
framework/generate-agent-plugin.sh --check    compare highway-agent-plugin/ with a fresh build
```

## Build mode

1. It validates every `skills/*/` folder with `framework/validate-skill.sh`. If any skill fails,
   it prints `ERROR: skill '<id>' failed validation; plugin NOT regenerated:` followed by the
   validator's output, exits 1, and writes nothing.
2. It refuses when `highway-agent-plugin/` exists and its `plugin.json` is missing or does not
   name `highway`. It prints `ERROR: 'highway-agent-plugin' was not produced by
   framework/generate-agent-plugin.sh -- refusing to overwrite it. Move it aside if it is safe to
   regenerate.` and exits 1 (D4.3).
3. It builds the shipped set into a temporary folder beside the target:
   - `framework/plugin/plugin.json` becomes `plugin.json`;
   - `framework/plugin/README.md` becomes `README.md`;
   - `framework/plugin/LICENSE` becomes `LICENSE`;
   - each `skills/<id>/` holding `SKILL.md` becomes `skills/<id>/`, with every file except
     dotfiles, in `LC_ALL=C` sorted order.
4. It replaces the target with the temporary folder, prints
   `OK: wrote highway-agent-plugin (<n> skill(s))`, and exits 0.

Files are copied with `cp`, never through a shell variable, so the bytes are identical. Nothing in
the output depends on time, the host, or the order `find` returns files (D4.2, FR-005).

## Check mode

It builds the shipped set into a temporary folder without validating skills, then compares that
folder with `highway-agent-plugin/`.

- For each difference it prints `DRIFT<TAB><differs|missing|extra><TAB><relative path>`, sorted.
- It exits 0 when there is no difference.
- It exits 1 when there is any difference, after the lines and
  `Run framework/generate-agent-plugin.sh to rebuild highway-agent-plugin/.`
- It exits 1 with `DRIFT<TAB>missing<TAB>.` when `highway-agent-plugin/` is absent.
- It never writes inside the repository. The temporary folder is under `${TMPDIR:-/tmp}`.

## Paths

All paths come from `framework/lib/paths.sh`, as `HW_PLUGIN` (the target) and `HW_PLUGIN_SOURCE`
(`framework/plugin`) (D2.5).
