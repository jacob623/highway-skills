# Quickstart: Agent Plugins Package

Run each step from the repository root. The harness needs Node 24 on `PATH`, and a token in
`harness/.env`.

## Build and check the plugin

```sh
framework/generate-catalog.sh
framework/generate-agent-adapters.sh
framework/generate-agent-plugin.sh          # OK: wrote highway-agent-plugin (16 skill(s))
framework/generate-agent-plugin.sh --check  # exit 0, no DRIFT lines
framework/validate-plugin.sh highway-agent-plugin   # OK: highway-agent-plugin (16 skill(s))
ls highway-agent-plugin                     # LICENSE  README.md  plugin.json  skills
```

## Reproducibility

Build twice and compare. Expect no diff (SC-002):

```sh
framework/generate-agent-plugin.sh && cp -R highway-agent-plugin /tmp/p1
framework/generate-agent-plugin.sh && diff -r /tmp/p1 highway-agent-plugin
```

## Drift is caught

Change a skill without rebuilding, and `--check` names the file:

```sh
printf '\n' >> skills/highway-help/SKILL.md
framework/generate-agent-plugin.sh --check  # DRIFT differs skills/highway-help/SKILL.md; exit 1
```

Then restore the skill.

## The suite

```sh
bash tests/agent-plugin.test.sh   # the plugin checks and their seeded defects
bash tests/run-all.sh             # every test passes
(cd harness && npm test)          # the harness unit tests pass
```

## Smoke run from the installed plugin

```sh
node harness/src/cli.ts --smoke --transcripts specs/246-agent-plugins-package/harness
git status --short specs/246-agent-plugins-package/harness   # prints nothing
```

Expect the following:

- The header shows `model=gpt-5.6-luna judge=gpt-5.6-luna`.
- Each attempt's `.jsonl` opens with `installed plugin highway (16 skills)`.
- No attempt fails with kind `plugin-install`.

Record skill-behavior failures per [smoke-findings](contracts/smoke-findings.md).
