# Quickstart: Validating Phase 12

Prerequisites:
- macOS or Linux with Bash and `python3` with PyYAML (`python3 -c 'import yaml'` exits 0).
- The suite needs the sandbox's "all" permission.
- Run commands from the repository root.

## 1. Every skill conforms

```bash
for d in skills/*/; do bash framework/validate-skill.sh --no-cache "$d" >/dev/null || echo "FAIL $d"; done
```

Expected: no output.

```bash
bash tests/agent-skills-format.test.sh
```

Expected: `PASS`. Each seeded violation fails with the finding in
[contracts/validator-format-checks.md](contracts/validator-format-checks.md).

## 2. Frontmatter shape

```bash
for f in skills/*/SKILL.md; do awk '/^---/{n++; next} n==1' "$f" | grep -E '^[a-z-]+:' | cut -d: -f1 | tr '\n' ' '; echo; done | sort -u
```

Expected: one line, `name description license metadata`.

```bash
grep -L 'Use when' skills/*/SKILL.md
```

Expected: no output.

## 3. Invocation-neutral text

```bash
for f in $(find skills -type f -name '*.md'); do awk -v f="$f" '/^## /{ex=($0 ~ /^## Example/)} !ex && /(^|[^a-z\/])\/highway-|\$highway-|highway:highway-/{print f": "$0}' "$f"; done
```

Expected: no output. See [contracts/invocation-text.md](contracts/invocation-text.md).

## 4. Help index and output

```bash
bash framework/generate-catalog.sh && grep -c '"dependencies"' skills/highway-help/assets/index.json
```

Expected: `0`. The index carries `usage` from `metadata.usage`; see
[contracts/help-output.md](contracts/help-output.md).

## 5. Retired features are gone

```bash
ls framework/frontmatter-lexicon.txt framework/lib/frontmatter-lexicon.sh framework/lib/dependency-check.sh 2>&1 | grep -c 'No such file'
```

Expected: `3`.

## 6. Regeneration and the full suite

```bash
bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh && git status --porcelain
```

Run this twice. The second run changes nothing.

```bash
bash tests/run-all.sh
```

Expected: `Summary: 84 passed, 0 failed`. Then run the harness tests and the type check, never at
the same time as the suite:

```bash
cd harness && N=/Applications/Cursor.app/Contents/Resources/app/resources/helpers/node
$N --test "test/*.test.ts" && $N node_modules/.bin/tsc -p tsconfig.json
```
