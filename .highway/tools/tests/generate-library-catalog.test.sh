#!/usr/bin/env bash
# Tests .highway/tools/generate-library-catalog.sh: schema shape, exactly one entry per valid
# fixture, non-zero exit (no partial catalog) on an invalid file, and determinism on re-run.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
GENERATE="$HIGHWAY_ROOT/tools/generate-library-catalog.sh"
FIXTURES="$SCRIPT_DIR/fixtures/library"
CATALOG_JSON="$HIGHWAY_ROOT/catalog/library-index.json"
CATALOG_MD="$HIGHWAY_ROOT/catalog/library-index.md"

TMP_NAME="test-library-fixture-$$"
GOV_FILE="$HIGHWAY_ROOT/library/governance/$TMP_NAME.md"
BACKUP_DIR="$(mktemp -d)"

fail=0

cleanup() {
	rm -f "$GOV_FILE"
	rm -f "$CATALOG_JSON" "$CATALOG_MD"
	[[ -f "$BACKUP_DIR/library-index.json" ]] && cp "$BACKUP_DIR/library-index.json" "$CATALOG_JSON"
	[[ -f "$BACKUP_DIR/library-index.md" ]] && cp "$BACKUP_DIR/library-index.md" "$CATALOG_MD"
	rm -rf "$BACKUP_DIR"
}
trap cleanup EXIT

[[ -f "$CATALOG_JSON" ]] && cp "$CATALOG_JSON" "$BACKUP_DIR/library-index.json"
[[ -f "$CATALOG_MD" ]] && cp "$CATALOG_MD" "$BACKUP_DIR/library-index.md"

# --- Part 1: a valid library file produces a well-shaped, single-entry catalog ---
cp "$FIXTURES/governance/valid/policy.md" "$GOV_FILE"

if ! "$GENERATE" >/tmp/generate-library-catalog.$$.log 2>&1; then
	echo "FAIL: generate-library-catalog.sh exited non-zero on a valid library set"
	cat /tmp/generate-library-catalog.$$.log
	fail=1
fi
rm -f /tmp/generate-library-catalog.$$.log

for key in generated_at entries; do
	if ! grep -q "\"$key\"" "$CATALOG_JSON"; then
		echo "FAIL: catalog/library-index.json missing top-level key '$key'"
		fail=1
	fi
done

if ! grep -q "\"name\": \"Example Governance Policy\"" "$CATALOG_JSON"; then
	echo "FAIL: catalog/library-index.json has no entry for the seeded fixture"
	fail=1
fi

for output_template in nfr-record control-record; do
	if ! grep -q "library/templates/output/$output_template.md" "$CATALOG_JSON"; then
		echo "FAIL: nested output template '$output_template' is missing from the library catalog"
		fail=1
	fi
done

for field in library_type name description version source_path; do
	if ! grep -q "\"$field\":" "$CATALOG_JSON"; then
		echo "FAIL: catalog/library-index.json entry missing field '$field'"
		fail=1
	fi
done

if ! grep -q "\"library_type\": \"governance\"" "$CATALOG_JSON"; then
	echo "FAIL: seeded fixture's entry does not report library_type 'governance'"
	fail=1
fi

if [[ ! -f "$CATALOG_MD" ]]; then
	echo "FAIL: catalog/library-index.md was not generated"
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

# --- Part 3: an invalid library file aborts generation entirely (no partial catalog) ---
cp "$FIXTURES/governance/invalid-bad-citation/policy.md" "$GOV_FILE"
catalog_before_invalid="$(cat "$CATALOG_JSON" 2>/dev/null || true)"
if "$GENERATE" >/tmp/generate-library-catalog-invalid.$$.log 2>&1; then
	echo "FAIL: generate-library-catalog.sh exited 0 despite an invalid library file present"
	fail=1
fi
if ! grep -q "$TMP_NAME" /tmp/generate-library-catalog-invalid.$$.log; then
	echo "FAIL: failure output did not name the failing file '$TMP_NAME'"
	fail=1
fi
rm -f /tmp/generate-library-catalog-invalid.$$.log
catalog_after_invalid="$(cat "$CATALOG_JSON" 2>/dev/null || true)"
if [[ "$catalog_before_invalid" != "$catalog_after_invalid" ]]; then
	echo "FAIL: catalog/library-index.json was modified despite generation failing (partial catalog written)"
	fail=1
fi

exit $fail
