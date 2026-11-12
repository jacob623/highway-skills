# Quickstart: Validate Onboarding Handoffs

Run from the repository root under bash.

## Prerequisites

- Phase 9 merged; branch `feature/std-alignment-phase10`.
- Baseline: `bash tests/run-all.sh` passes (84) and the harness tests pass (81).

## 1. Templates have moved

```bash
ls skills/highway-adr/assets/adr-record.md skills/highway-architecture/assets/architecture-record.md \
   skills/highway-implementation/assets/implementation-record.md
test ! -e .highway/library && echo "library gone"
rg -n '\.highway/library' skills framework/lib harness/bin harness/src   # no output
```

## 2. Skills validate

```bash
for s in highway-adr highway-architecture highway-implementation highway-onboarding; do
  bash framework/validate-skill.sh --no-cache "skills/$s" || echo "FAIL $s"
done
```

Each prints its verdict lines with no `ERROR`.

## 3. Handoff contract

```bash
bash tests/onboarding-handoffs.test.sh
bash tests/record-templates.test.sh
```

See [contracts/onboarding-entry-steps.md](contracts/onboarding-entry-steps.md) and
[contracts/adr-catalog-architecture-id.md](contracts/adr-catalog-architecture-id.md).

## 4. Harness

```bash
bash tests/harness-scenarios.test.sh && bash tests/harness-fixtures.test.sh
cd harness && /Applications/Cursor.app/Contents/Resources/app/resources/helpers/node --test "test/*.test.ts"
bash harness/bin/path-map.sh skills/highway-adr/assets/adr-record.md   # part of highway-adr
```

A live run of `onboarding-smoke`, `chain-architecture`, and `implementation-onboards-platform` needs a
token and is outside this change.

## 5. Full checks

```bash
bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh && git status --short
bash tests/run-all.sh          # 85 passing
bash framework/generate-distribution.sh /tmp/hw-dist-239
```

Expected: regeneration leaves no diff beyond this change, the suite passes, and the distribution holds
each template under its skill and no `.highway/library/`.
