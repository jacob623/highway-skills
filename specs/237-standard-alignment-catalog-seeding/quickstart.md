# Quickstart: validating catalog seeding

Run from the repository root.

## 1. Static checks

```bash
bash tests/catalog-seeding.test.sh     # assets, seeded set, entry checks, no create-when-absent
bash tests/shared-rules.test.sh        # both shared rules match their sources
ls .highway/library/templates/output/  # 14 record templates, no catalog
ls .highway/library/knowledge 2>&1     # gone
```

## 2. Template check on skeletons

```bash
for name in request-catalog adr-catalog codify-platforms assessment-findings storage; do
  bash harness/bin/template-check.sh "$name" "skills/highway-setup/assets/$name.md"
done                                   # each exits 0
bash harness/bin/fixture-check.sh      # every stage and overlay passes
```

A copy of a skeleton with a header column removed fails with `missing row:`.

## 3. Validator and generated artifacts

```bash
for d in skills/*/; do bash framework/validate-skill.sh --no-cache "$d/SKILL.md"; done
bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh
git status --short .highway/catalog .claude .cursor .github .agents framework/.adapter-manifest
```

A second regeneration changes nothing.

## 4. Suites

```bash
bash tests/run-all.sh                  # all pass
cd harness && node --test "test/*.test.ts" && node node_modules/.bin/tsc -p tsconfig.json
```

## 5. Live runs (optional, needs a Copilot token)

```bash
node harness/src/cli.ts --scenario setup-smoke            # 12 seeded files, each passes template
node harness/src/cli.ts --scenario request-setup-needed   # message shown, no question, no write
```
