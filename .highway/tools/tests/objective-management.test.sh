#!/usr/bin/env bash
# Contract and fixture checks for the user-owned Business Objective workflow.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-objectives/SKILL.md"
TEMPLATE="$HIGHWAY_ROOT/library/templates/output/objective-record.md"
FIXTURES="$SCRIPT_DIR/fixtures/objective-management"
WORK="$(mktemp -d)"
fail=0
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

pass() { echo "OK: $1"; }
check() {
	if "$@"; then
		return 0
	fi
	fail=1
	return 1
}
require_text() {
	local file="$1" text="$2" label="$3"
	if grep -Fq "$text" "$file"; then
		pass "$label"
	else
		echo "FAIL: $label (missing '$text' in $file)" >&2
		fail=1
	fi
}

if [[ ! -f "$SKILL" ]]; then
	echo "FAIL: source skill is missing: $SKILL" >&2
	exit 1
fi
if [[ ! -f "$TEMPLATE" ]]; then
	echo "FAIL: objective record template is missing: $TEMPLATE" >&2
	exit 1
fi

# The contract must expose the exact action surface and retained-record shape.
for action in setup configure view show describe add new update remove reset; do
	require_text "$SKILL" "\`$action\`" "supported action $action"
done
for field in "id: OBJXXXXXX" "status: active" "capabilities: []" "## Statement" "## Success Measures" "## Rationale"; do
	require_text "$TEMPLATE" "$field" "template field $field"
done
for path in "library/objectives/" "library/governance/objectives.md"; do
	require_text "$SKILL" "$path" "user-owned path $path"
done
for phrase in "Confirmation Status" "Resulting Version" "next_id" "byte-for-byte" "No timestamp" "never reused"; do
	require_text "$SKILL" "$phrase" "contract phrase $phrase"
done

# Fixtures are copied into temporary repositories so all byte comparisons are isolated.
for fixture in empty valid duplicate invalid-next-id missing-target; do
	if [[ -d "$FIXTURES/$fixture" ]]; then
		cp -R "$FIXTURES/$fixture" "$WORK/$fixture"
		pass "fixture copied: $fixture"
	else
		echo "FAIL: missing fixture: $fixture" >&2
		fail=1
	fi
done

before="$WORK/valid.before"
find "$WORK/valid" -type f -print | sort | while IFS= read -r file; do
	shasum "$file"
done >"$before"
if [[ -s "$before" ]]; then
	pass "valid baseline snapshot created"
else
	echo "FAIL: valid baseline snapshot is empty" >&2
	fail=1
fi

# Structural fixture checks cover duplicate IDs, invalid allocation, and missing catalog targets.
if [[ "$(grep -h '^id: OBJ' "$WORK/duplicate/library/objectives/"*.md | sort | uniq -d)" == "id: OBJ000001" ]]; then
	pass "duplicate identifier fixture detected"
else
	echo "FAIL: duplicate identifier fixture is not malformed as expected" >&2
	fail=1
fi
if grep -q 'Next identifier: OBJ000004' "$WORK/invalid-next-id/library/governance/objectives.md"; then
	pass "invalid next_id fixture detected"
else
	echo "FAIL: invalid next_id fixture is not malformed as expected" >&2
	fail=1
fi
if [[ ! -f "$WORK/missing-target/library/governance/objectives.md" ]]; then
	pass "missing catalog target fixture detected"
else
	echo "FAIL: missing catalog target fixture unexpectedly has a catalog" >&2
	fail=1
fi

# The skill contract must keep framework source and user-owned output separate.
if grep -Fq '.highway/library/objectives' "$SKILL"; then
	echo "FAIL: skill proposes an objective record under .highway" >&2
	fail=1
else
	pass "objective records stay outside .highway"
fi

# No live user-owned baseline may be created by the focused test itself.
if [[ -d "$REPO_ROOT/library/objectives" || -f "$REPO_ROOT/library/governance/objectives.md" ]]; then
	echo "FAIL: focused test found live objective output" >&2
	fail=1
else
	pass "focused test leaves live user-owned baseline absent"
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "OK: objective workflow contract and fixtures pass"
