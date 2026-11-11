# Quickstart: Validating the Standard Alignment Removals

Run every command from the repository root.

## 1. The full suite passes (FR-015, SC-002)

```bash
.highway/tools/tests/run-all.sh
ls .highway/tools/tests/*.test.sh | wc -l
```

Expected: exit 0, and a test file count 4 lower than before the change.

## 2. The removed files are gone (FR-001, FR-008, FR-009)

```bash
for f in catalog/library-index.json catalog/library-index.md catalog/index.md catalog/README.md \
	library/governance/README.md library/knowledge/README.md library/templates/README.md \
	tools/generate-library-catalog.sh tools/audit-objective-rename.sh tools/.objective-rename-allowlist \
	tools/audit-profile-migration.sh tools/seed-library-context.sh \
	tools/tests/generate-library-catalog.test.sh tools/tests/objective-rename-contract.test.sh \
	tools/tests/profile-migration.test.sh tools/tests/seed-library-context.test.sh; do
	[ -e ".highway/$f" ] && echo "STILL PRESENT: $f"
done
```

Expected: no output.

## 3. Nothing references them (FR-002, FR-007, SC-001)

```bash
rg -l --hidden -g '!specs/**' -g '!standard-alignment.md' -g '!rollout-plan.md' -g '!.git/**' \
	-g '!harness/node_modules/**' -g '!harness/runs/**' \
	-e library-index -e generate-library-catalog -e 'catalog/README' -e 'catalog/index\.md' \
	-e overlap_flags -e audit-objective-rename -e objective-rename -e audit-profile-migration \
	-e seed-library-context -e 'profile-migration\.test' \
	-e 'library/(templates|knowledge|governance)/README' .
rg -n --hidden -g '!specs/**' -g '!.git/**' generated_at .highway .specify README.md
```

Expected: the first search prints only `.specify/memory/constitution.md`, whose matches are in
its Sync Impact Reports, and `.highway/tools/tests/generate-catalog.test.sh`, whose matches assert
that `index.md`, `generated_at`, and `overlap_flags` are absent. The second prints only that test
and the Profile fixture `.highway/tools/tests/fixtures/profile/generated-value.yaml`.

## 4. The catalog is deterministic (FR-004, FR-005, SC-003)

```bash
.highway/tools/generate-catalog.sh && cp .highway/catalog/index.json /tmp/catalog-1.json
.highway/tools/generate-catalog.sh && cmp /tmp/catalog-1.json .highway/catalog/index.json
git diff --exit-code .highway/catalog/index.json
```

Expected: `cmp` is silent, and the committed catalog matches a fresh run.

## 5. highway-help answers the same (FR-006, SC-004)

Compare each entry's `id`, `name`, `description`, `usage`, `compatibility`, `version`, and
`source_path` between the committed `index.json` before and after the change. Expected: all 15
entries identical except highway-help's `version` (3.1.0 to 3.1.1). Both help modes read only
these fields.

## 6. The agent copies and catalog are current (FR-012)

```bash
.highway/tools/generate-agent-adapters.sh && git status --short .agents .claude .cursor .github
```

Expected: no change beyond the highway-help copies already in the working tree.

## 7. The distribution holds none of the removed files (FR-011, SC-005)

```bash
.highway/tools/generate-distribution.sh /tmp/highway-dist-233
find /tmp/highway-dist-233 \( -name 'library-index*' -o -name index.md -o -name 'audit-*' \
	-o -name 'seed-library-context.sh' -o -name 'generate-library-catalog.sh' \) -print
```

Expected: the generator exits 0, and `find` prints nothing.

## 8. Harness lists name only existing paths (SC-006)

```bash
awk -F'\t' '/^(smoke|none)\t/ {print $2}' harness/selection/shared.txt | while read -r p; do
	[ -e "$p" ] || echo "MISSING: $p"
done
.highway/tools/tests/harness-path-map.test.sh
```

Expected: no `MISSING` line, and the path-map test passes.
