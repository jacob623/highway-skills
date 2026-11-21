# Contract: Harness plugin source switches

## Switches

| Switch | Values | Default |
| --- | --- | --- |
| `--plugin-source` | `local` \| `public` | `local` |
| `--plugin-ref` | tag or commit SHA | unset |

## Rules

- `local`: install from the built `highway-agent-plugin/` as today. `--plugin-ref` is ignored or
  rejected with a clear error (prefer ignore with help note).
- `public`: `--plugin-ref` is **required**. Harness clones
  `https://github.com/highway-systems/agent-plugin` at that ref into a disposable directory and
  installs from that directory via existing driver `installPlugin` paths.
- Missing `--plugin-ref` with `--plugin-source public` → exit 2 before any scenario.
- Help text and `harness/README.md` document both switches.

## Live exit for this feature

After publish, for each of `copilot`, `cursor`, `claude`, `codex`:

```text
node harness/src/cli.ts --agent <id> --smoke --plugin-source public --plugin-ref <tag|sha>
```

Install/load failures block the feature; skill-behavior failures become findings.
