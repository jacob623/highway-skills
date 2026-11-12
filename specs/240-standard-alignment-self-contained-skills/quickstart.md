# Quickstart: verifying Phase 11

```bash
# Regenerate; a second run must leave no diff
bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh
git status --short skills .github .cursor .claude .agents framework

# The index sits in highway-help and nothing sits under .highway
test -f skills/highway-help/assets/index.json
test ! -e .highway

# Self-containment and bundled files
bash tests/self-contained-skills.test.sh
bash tests/bundled-files.test.sh

# Every skill, bundled files included
for d in skills/*/; do bash framework/validate-skill.sh --no-cache "$d"; done

# The distribution holds no source skills folder and no .highway
out="$(mktemp -d)" && bash framework/generate-distribution.sh "$out/dist" && ls -a "$out/dist"

# Full suite, then the harness tests (never at the same time)
bash tests/run-all.sh
cd harness && node --test "test/*.test.ts" && node_modules/.bin/tsc -p tsconfig.json
```
