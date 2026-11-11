# Quickstart: Validate Phase 9

Run from the repository root. The bash suite and the skill validator need the sandbox disabled.

## 1. Placement

```bash
ls skills/highway-codify/assets skills/highway-codify-config/assets skills/highway-request/assets
ls .highway/library/templates/output/    # adr-record.md architecture-record.md implementation-record.md
rg -n 'templates/output/(codify-|coding-standard|control-record|nfr-record|objective-record|discovery-record|request-record|profile-record)' skills    # nothing
rg -n '\.highway/library/knowledge/' skills    # nothing
```

## 2. Validator

```bash
bash framework/validate-skill.sh --no-cache skills/highway-request    # OK, report unchanged
bash framework/validate-skill.sh --no-cache skills/highway-setup      # OK, no skeleton named
```

The seeded failure is in `tests/record-templates.test.sh`; see
[contracts/asset-template-check.md](contracts/asset-template-check.md).

## 3. Skeletons

```bash
bash tests/catalog-seeding.test.sh
```

See [contracts/skeleton-reference.md](contracts/skeleton-reference.md).

## 4. Verdicts unchanged

Record every skill and fixture verdict before the first edit and after the last, and diff the two. The
expected difference is none.

## 5. Regeneration, suite, harness, distribution

```bash
bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh    # twice; no change
bash tests/run-all.sh                                                              # 84 passed
cd harness && node --test "test/*.test.ts" && node node_modules/.bin/tsc -p tsconfig.json
bash framework/generate-distribution.sh "$(mktemp -d)/dist"    # each moved template inside its skill
```
