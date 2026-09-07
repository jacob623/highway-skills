#!/usr/bin/env bash
# Tests .highway/tools/generate-content-catalog.sh: schema shape, exactly one entry per valid
# fixture, non-zero exit (no partial catalog) on an invalid file, and determinism on re-run.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
GENERATE="$HIGHWAY_ROOT/tools/generate-content-catalog.sh"
FIXTURES="$SCRIPT_DIR/fixtures/content"
CATALOG_JSON="$HIGHWAY_ROOT/catalog/content-index.json"
CATALOG_MD="$HIGHWAY_ROOT/catalog/content-index.md"

TMP_NAME="test-content-fixture-$$"
GOV_FILE="$HIGHWAY_ROOT/content/governance/$TMP_NAME.md"
BACKUP_DIR="$(mktemp -d)"

fail=0

cleanup() {
	rm -f "$GOV_FILE"
	rm -f "$CATALOG_JSON" "$CATALOG_MD"
	[[ -f "$BACKUP_DIR/content-index.json" ]] && cp "$BACKUP_DIR/content-index.json" "$CATALOG_JSON"
	[[ -f "$BACKUP_DIR/content-index.md" ]] && cp "$BACKUP_DIR/content-index.md" "$CATALOG_MD"
	rm -rf "$BACKUP_DIR"
}
trap cleanup EXIT

[[ -f "$CATALOG_JSON" ]] && cp "$CATALOG_JSON" "$BACKUP_DIR/content-index.json"
[[ -f "$CATALOG_MD" ]] && cp "$CATALOG_MD" "$BACKUP_DIR/content-index.md"

# --- Part 1: a valid content file produces a well-shaped, single-entry catalog ---
cp "$FIXTURES/governance/valid/policy.md" "$GOV_FILE"

if ! "$GENERATE" >/tmp/generate-content-catalog.$$.log 2>&1; then
	echo "FAIL: generate-content-catalog.sh exited non-zero on a valid content set"
	cat /tmp/generate-content-catalog.$$.log
	fail=1
fi
rm -f /tmp/generate-content-catalog.$$.log

for key in generated_at entries; do
	if ! grep -q "\"$key\"" "$CATALOG_JSON"; then
		echo "FAIL: catalog/content-index.json missing top-level key '$key'"
		fail=1
	fi
done

if ! grep -q "\"name\": \"Example Governance Policy\"" "$CATALOG_JSON"; then
	echo "FAIL: catalog/content-index.json has no entry for the seeded fixture"
	fail=1
fi

for field in content_type name description version source_path; do
	if ! grep -q "\"$field\":" "$CATALOG_JSON"; then
		echo "FAIL: catalog/content-index.json entry missing field '$field'"
		fail=1
	fi
done

if ! grep -q "\"content_type\": \"governance\"" "$CATALOG_JSON"; then
	echo "FAIL: seeded fixture's entry does not report content_type 'governance'"
	fail=1
fi

if [[ ! -f "$CATALOG_MD" ]]; then
	echo "FAIL: catalog/content-index.md was not generated"
	fail=1
fi

# --- Part 2: determinism -- re-run with no changes yields identical entries ---
before_entries="$(grep -v '"generated_at"' "$CATALOG_JSON")"
"$GENERATE" >/dev/null 2>&1
after_entries="$(grep -v '"generated_at"' "$CATALOG_JSON")"
if [[ "$before_entries" != "$after_entries" ]]; then
	echo "FAIL: re-running with unchanged content/ produced a different catalog (aside from generated_at)"
	fail=1
fi

# --- Part 3: an invalid content file aborts generation entirely (no partial catalog) ---
cp "$FIXTURES/governance/invalid-bad-citation/policy.md" "$GOV_FILE"
catalog_before_invalid="$(cat "$CATALOG_JSON" 2>/dev/null || true)"
if "$GENERATE" >/tmp/generate-content-catalog-invalid.$$.log 2>&1; then
	echo "FAIL: generate-content-catalog.sh exited 0 despite an invalid content file present"
	fail=1
fi
if ! grep -q "$TMP_NAME" /tmp/generate-content-catalog-invalid.$$.log; then
	echo "FAIL: failure output did not name the failing file '$TMP_NAME'"
	fail=1
fi
rm -f /tmp/generate-content-catalog-invalid.$$.log
catalog_after_invalid="$(cat "$CATALOG_JSON" 2>/dev/null || true)"
if [[ "$catalog_before_invalid" != "$catalog_after_invalid" ]]; then
	echo "FAIL: catalog/content-index.json was modified despite generation failing (partial catalog written)"
	fail=1
fi

exit $fail
