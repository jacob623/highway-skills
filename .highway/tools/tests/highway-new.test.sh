#!/usr/bin/env bash
# Verifies the highway-new source skill, shared request templates, and static output contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: --probe <class> observes a missing contract token; --probe <class>
# --neutralise checks the identical path with the token restored.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SELF="highway-new.test.sh"
SKILL="$HIGHWAY_ROOT/skills/highway-new/SKILL.md"
RECORD_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/request-record.md"
CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/request-catalog.md"
MANIFEST="$HIGHWAY_ROOT/tools/.distribution-manifest"
FIXTURES="$SCRIPT_DIR/fixtures/highway-new"

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document generated-artifact disposable-fixture "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

if [[ -n "$probe_class" ]]; then
	probe_path="$SCRIPT_DIR/highway-new-probe-$$.md"
	trap 'rm -f "$probe_path"' EXIT
	if [[ "$neutralise" -eq 0 ]]; then
		printf '%s\n' 'missing required contract token' >"$probe_path"
	else
		printf '%s\n' 'required contract token' >"$probe_path"
	fi
	if grep -Fq 'required contract token' "$probe_path"; then
		exit 0
	fi
	exit 1
fi

fail=0
require_file() {
	local file="$1"
	if [[ ! -f "$file" ]]; then
		echo "FAIL: expected file does not exist: $file"
		fail=1
	fi
}
require_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

require_fixture_text() {
	local fixture="$1" text="$2"
	if ! grep -Fq "$text" "$FIXTURES/$fixture"; then
		echo "FAIL: '$text' missing from fixture $fixture"
		fail=1
	fi
}

require_file "$SKILL"
require_file "$RECORD_TEMPLATE"
require_file "$CATALOG_TEMPLATE"
for fixture in valid-request.md incomplete-request.md invalid-identifier.md privacy-sensitive.md; do
	require_file "$FIXTURES/$fixture"
done

if [[ -f "$SKILL" ]]; then
	for token in \
		'## Purpose' \
		'## When to use' \
		'## When not to use' \
		'## Inputs' \
		'## Outputs' \
		'## Verification' \
		'## Error Handling' \
		'## Example' \
		'Problem, Actors, Current Process, Desired Change, Success Measure, Business Constraints' \
		'one natural-language question' \
		'one to three examples' \
		'one question at a time' \
		'Solution Constraints' \
		'allowed_solution_classes' \
		'one or more non-empty values' \
		'allowed_solution_classes must contain one or more values or unknown' \
		'Solution Constraints field error' \
		'None known' \
		'existing_platforms_required' \
		'existing_platforms_preferred' \
		'known_systems' \
		'hosting_restrictions' \
		'vendor_restrictions' \
		'procurement_constraints' \
		'regulatory_restrictions' \
		'extensible list' \
		'without ranking' \
		'empty array' \
		'unknown' \
		'absent constraint is neutral' \
		'privacy' \
		'Discovery' \
		'ADR' \
		'REQ' \
		'proposed' \
		'write nothing' \
		'preserve the original bytes' \
		'.highway/library/templates/output/request-record.md' \
		'.highway/library/templates/output/request-catalog.md'; do
		require_text "$SKILL" "$token"
	done
	if grep -Fq 'No business constraints' "$SKILL" || grep -Fq 'No known constraints' "$SKILL"; then
		echo "FAIL: legacy Business Constraints absence wording remains"
		fail=1
	fi
	if grep -Eiq 'solution_class[_a-z]*:[[:space:]]*(true|false)|allow[_-]?custom[_-]?development:[[:space:]]*(true|false)' "$SKILL"; then
		echo "FAIL: source skill contains legacy solution-class boolean terminology"
		fail=1
	fi
	dev_specs='specs''/'
	dev_specify='.specify''/'
	if grep -Eq "(^|[[:space:]])${dev_specs}|(^|[[:space:]])${dev_specify}" "$SKILL"; then
		echo "FAIL: source skill references development-only paths"
		fail=1
	fi
fi

if [[ -f "$MANIFEST" ]]; then
	for path in \
		'.highway/library/templates/output/request-record.md' \
		'.highway/library/templates/output/request-catalog.md' \
		'.github/skills/highway-new' \
		'.claude/skills/highway-new' \
		'.cursor/rules/highway-new.mdc'; do
		require_text "$MANIFEST" "$path"
	done
fi

if [[ -f "$RECORD_TEMPLATE" ]]; then
	for token in 'name: request-record' 'id: REQXXXXXX' '## Problem' '## Actors' '## Current Process' '## Desired Change' '## Success Measure' '## Business Constraints' '## Solution Constraints' 'allowed_solution_classes:' 'existing_platforms_required:' 'existing_platforms_preferred:' 'known_systems:' 'hosting_restrictions:' 'vendor_restrictions:' 'procurement_constraints:' 'regulatory_restrictions:' '## Completeness'; do
		require_text "$RECORD_TEMPLATE" "$token"
	done
	if grep -nE '^## (Business Constraints|Solution Constraints|Completeness)$' "$RECORD_TEMPLATE" | awk 'NR == 1 { previous = $1; next } { if ($1 <= previous) exit 1; previous = $1 }'; then
		:
	else
		echo "FAIL: request record sections are not ordered"
		fail=1
	fi
fi
if [[ -f "$CATALOG_TEMPLATE" ]]; then
	for token in 'name: request-catalog' 'Version: 1.0.0' 'Next ID: REQXXXXXX' '| ID | Title | Status |'; do
		require_text "$CATALOG_TEMPLATE" "$token"
	done
fi

if [[ -f "$FIXTURES/valid-request.md" ]]; then
	for token in \
		'allowed_solution_classes:' \
		'SaaS' \
		'Custom Development' \
		'existing_platforms_required:' \
		'SAP' \
		'existing_platforms_preferred:' \
		'Salesforce' \
		'known_systems:' \
		'Workday' \
		'hosting_restrictions: []' \
		'vendor_restrictions: unknown' \
		'procurement_constraints:' \
		'No Net New Purchases' \
		'regulatory_restrictions: []'; do
		require_fixture_text valid-request.md "$token"
	done
fi

if [[ -f "$FIXTURES/incomplete-request.md" ]]; then
	require_fixture_text incomplete-request.md '## Solution Constraints'
	require_fixture_text incomplete-request.md 'Completeness'
	if grep -qx 'Complete' "$FIXTURES/incomplete-request.md"; then
		echo "FAIL: incomplete fixture is marked complete"
		fail=1
	fi
fi

# User-owned request output must not be introduced into the framework tree by this test.
request_glob='*/requests/REQ*.md'
design_glob="*/${dev_specs}*"
if find "$REPO_ROOT" -path "$request_glob" -not -path "$design_glob" -print -quit | grep -q .; then
	echo "FAIL: repository-owned request fixture found outside the feature design tree"
	fail=1
fi

exit "$fail"
