# Quickstart: Slim Highway Identity

## Check identity body

```bash
grep -F '## What Highway is' skills/highway-experience/references/highway-identity.md
grep -F '## Knowledge chain' skills/highway-experience/references/highway-identity.md
grep -F '## Boundaries' skills/highway-experience/references/highway-identity.md
! grep -F 'contextual intelligence' skills/highway-experience/references/highway-identity.md
```

## Suite

```bash
bash tests/constitution-profile-context.test.sh
bash tests/experience-activation.test.sh
```

## Finish order (after skills change)

```bash
bash tests/run-all.sh --exclude-plugin-gen
# bump framework/plugin/plugin.json
bash framework/generate-catalog.sh
bash framework/generate-agent-adapters.sh
bash framework/generate-agent-plugin.sh
bash tests/run-all.sh --plugin-gen-only
```
