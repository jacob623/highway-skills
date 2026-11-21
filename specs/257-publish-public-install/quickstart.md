# Quickstart: Publish and Public Install

## Prerequisites

- Repo on branch `257-publish-public-install` (or with this feature merged).
- Git credentials that can push to `https://github.com/highway-systems/agent-plugin.git`.
- Harness keys for Copilot, Cursor, Claude, and Codex in `harness/.env` as today.

## 1. Identity and catalogs

```sh
# After implementation: repository URL updated and plugin regenerated
grep -n 'highway-systems/agent-plugin' framework/plugin/plugin.json
framework/generate-agent-plugin.sh --check
test -f highway-agent-plugin/.agents/plugins/marketplace.json
test -f highway-agent-plugin/.cursor-plugin/marketplace.json
```

Expected: check exits 0; catalogs exist; root `plugin.json` `repository` is the public URL.

## 2. URL guard and suite

```sh
tests/publish-url.test.sh   # or the suite entry that owns the guard
tests/run-all.sh            # full bash suite when ready for D3.2
```

Expected: guard fails if an install example still names `jacob623/highway-skills`; suite green.

## 3. Dry-run publish, then publish

```sh
framework/publish-agent-plugin.sh --dry-run
framework/publish-agent-plugin.sh
```

Expected: dry-run reports gates passed; real run pushes and leaves tag `v0.1.0` (first publish).

## 4. Public-install smoke (pinned)

```sh
REF=v0.1.0   # or the commit SHA printed by publish
npm --prefix harness test && npm --prefix harness run typecheck
node harness/src/cli.ts --agent copilot --smoke --plugin-source public --plugin-ref "$REF"
node harness/src/cli.ts --agent cursor --smoke --plugin-source public --plugin-ref "$REF"
node harness/src/cli.ts --agent claude --smoke --plugin-source public --plugin-ref "$REF"
node harness/src/cli.ts --agent codex --smoke --plugin-source public --plugin-ref "$REF"
```

Expected: every attempt installs all Highway skills from the pinned ref. Record logs under
`specs/257-publish-public-install/harness/` (commit redacted logs). Match skill-behavior failures
to `harness-model-findings.md`.

## 5. Docs check

Open `highway-agent-plugin/README.md`: install examples use `highway-systems/agent-plugin`; no
executable required for Copilot/Cursor/Claude/Codex. Contributor docs may still mention adapters.
