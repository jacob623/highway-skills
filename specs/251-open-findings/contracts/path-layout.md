# Contract: Attempt path layout (F20)

## Requirements

1. Each attempt receives a unique throwaway home and project under one work root.
2. Work root is created with prefix `hh-` under `os.tmpdir()`.
3. Homes live under `<work>/h/`; projects under `<work>/p/`.
4. Directory labels do not embed the full scenario id (use attempt number + mkdtemp random suffix).
5. `pathRewriter({ project, home, work, tmp })` still rewrites those roots in logs.
6. Outside-project reads/writes still deny; plugin install checks unchanged.
7. No skill or scenario change for path length.

## Measurement

On confirmation logs, count `denied:` (or equivalent) lines whose path shows a dropped temp/work segment, nested `p/`/`projects` invention, or other collapsed absolute path as described in F20 Basis. Compare to baseline citations in F20 (spec 250 Cursor smokes and earlier Copilot runs). Any confirmed reduction after the layout change closes F20.
