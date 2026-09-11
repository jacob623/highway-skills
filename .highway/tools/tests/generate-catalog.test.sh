#!/usr/bin/env bash
# Tests .highway/tools/generate-catalog.sh: schema shape, exactly one entry per valid fixture skill,
# non-zero exit (no partial catalog) on an invalid skill, and determinism on re-run.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: generated-artifact
# Seeded failure probe: --probe <class> seeds a defect and observes detection; --probe <class>
# --neutralise runs the identical path unseeded and requires a clean pass. See the Feature 041
# probe-mode contract.

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" generated-artifact "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

# Two catalog snapshots agree once the `generated_at` field is excluded (D4.2 determinism).
# Shared by normal mode, which compares two real generator runs, and probe mode, which compares
# two seeded snapshots directly.
catalog_snapshots_match() {
	[[ "$1" == "$2" ]]
}

# --- Probe mode: a dedicated CLI path for the D3.7 harness, separate from the end-to-end run below ---
# Named per declared class (probe_<class, underscored>) so a harness -- or a reviewer -- can point
# at exactly the function a probe invocation runs.
probe_generated_artifact() {
	local before='{"entries":[{"id":"x","version":"1.0.0"}]}'
	local after
	if [[ "$neutralise" -eq 0 ]]; then
		after='{"entries":[{"id":"x","version":"1.0.1"}]}'
	else
		after='{"entries":[{"id":"x","version":"1.0.0"}]}'
	fi
	if catalog_snapshots_match "$before" "$after"; then
		return 0
	else
		return 1
	fi
}

if [[ -n "$probe_class" ]]; then
	case "$probe_class" in
		generated-artifact) probe_generated_artifact; exit $? ;;
	esac
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
GENERATE="$HIGHWAY_ROOT/tools/generate-catalog.sh"
FIXTURES="$SCRIPT_DIR/fixtures"
CATALOG_JSON="$HIGHWAY_ROOT/catalog/index.json"
CATALOG_MD="$HIGHWAY_ROOT/catalog/index.md"

TMP_ID="test-catalog-fixture-$$"
SKILL_DIR="$HIGHWAY_ROOT/skills/$TMP_ID"
BACKUP_DIR="$(mktemp -d)"

fail=0

cleanup() {
	rm -rf "$SKILL_DIR"
	# Restore whatever catalog existed (or didn't) before this test ran.
	rm -f "$CATALOG_JSON" "$CATALOG_MD"
	[[ -f "$BACKUP_DIR/index.json" ]] && cp "$BACKUP_DIR/index.json" "$CATALOG_JSON"
	[[ -f "$BACKUP_DIR/index.md" ]] && cp "$BACKUP_DIR/index.md" "$CATALOG_MD"
	rm -rf "$BACKUP_DIR"
}
trap cleanup EXIT

[[ -f "$CATALOG_JSON" ]] && cp "$CATALOG_JSON" "$BACKUP_DIR/index.json"
[[ -f "$CATALOG_MD" ]] && cp "$CATALOG_MD" "$BACKUP_DIR/index.md"

# --- Part 1: valid skill produces a well-shaped, single-entry catalog ---
mkdir -p "$SKILL_DIR"
cp "$FIXTURES/valid-skill/SKILL.md" "$SKILL_DIR/SKILL.md"
# The fixture's frontmatter name is authored to match the fixture's own directory id
# (`valid-skill`); rewrite it to this temp skill's id so it still satisfies sv_validate_name.
sed -i.bak "s/^name: .*/name: $TMP_ID/" "$SKILL_DIR/SKILL.md" && rm -f "$SKILL_DIR/SKILL.md.bak"

if ! "$GENERATE" >/tmp/generate-catalog.$$.log 2>&1; then
	echo "FAIL: .highway/tools/generate-catalog.sh exited non-zero on a valid skill set"
	cat /tmp/generate-catalog.$$.log
	fail=1
fi
rm -f /tmp/generate-catalog.$$.log

for key in generated_at entries overlap_flags; do
	if ! grep -q "\"$key\"" "$CATALOG_JSON"; then
		echo "FAIL: catalog/index.json missing top-level key '$key'"
		fail=1
	fi
done

if ! grep -q "\"id\": \"$TMP_ID\"" "$CATALOG_JSON"; then
	echo "FAIL: catalog/index.json has no entry for '$TMP_ID'"
	fail=1
fi

for field in name description usage compatibility version source_path; do
	if ! grep -q "\"$field\":" "$CATALOG_JSON"; then
		echo "FAIL: catalog/index.json entry missing field '$field'"
		fail=1
	fi
done

if [[ ! -f "$CATALOG_MD" ]]; then
	echo "FAIL: catalog/index.md was not generated"
	fail=1
fi

# --- Part 2: determinism -- re-run with no changes yields identical entries/overlap_flags ---
before_entries="$(grep -v '"generated_at"' "$CATALOG_JSON")"
"$GENERATE" >/dev/null 2>&1
after_entries="$(grep -v '"generated_at"' "$CATALOG_JSON")"
if ! catalog_snapshots_match "$before_entries" "$after_entries"; then
	echo "FAIL: re-running with unchanged skills/ content produced a different catalog (aside from generated_at)"
	fail=1
fi

# --- Part 3: an invalid skill aborts generation entirely (no partial catalog) ---
rm -rf "$SKILL_DIR"
mkdir -p "$SKILL_DIR"
cp "$FIXTURES/invalid-skill-missing-version/SKILL.md" "$SKILL_DIR/SKILL.md"
catalog_before_invalid="$(cat "$CATALOG_JSON" 2>/dev/null || true)"
if "$GENERATE" >/tmp/generate-catalog-invalid.$$.log 2>&1; then
	echo "FAIL: .highway/tools/generate-catalog.sh exited 0 despite an invalid skill present"
	fail=1
fi
if ! grep -q "$TMP_ID" /tmp/generate-catalog-invalid.$$.log; then
	echo "FAIL: failure output did not name the failing skill '$TMP_ID'"
	fail=1
fi
rm -f /tmp/generate-catalog-invalid.$$.log
catalog_after_invalid="$(cat "$CATALOG_JSON" 2>/dev/null || true)"
if [[ "$catalog_before_invalid" != "$catalog_after_invalid" ]]; then
	echo "FAIL: catalog/index.json was modified despite generation failing (partial catalog written)"
	fail=1
fi

exit $fail
