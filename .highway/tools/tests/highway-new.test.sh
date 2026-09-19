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
		'REQ' \
		'No business constraints' \
		'No known constraints' \
		'proposed' \
		'write nothing' \
		'preserve the original bytes' \
		'.highway/library/templates/output/request-record.md' \
		'.highway/library/templates/output/request-catalog.md'; do
		require_text "$SKILL" "$token"
	done
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
	for token in 'name: request-record' 'id: REQXXXXXX' '## Problem' '## Actors' '## Current Process' '## Desired Change' '## Success Measure' '## Business Constraints' '## Completeness'; do
		require_text "$RECORD_TEMPLATE" "$token"
	done
fi
if [[ -f "$CATALOG_TEMPLATE" ]]; then
	for token in 'name: request-catalog' 'Version: 1.0.0' 'Next ID: REQXXXXXX' '| ID | Title | Status |'; do
		require_text "$CATALOG_TEMPLATE" "$token"
	done
fi

# User-owned request output must not be introduced into the framework tree by this test.
request_glob='*/requests/REQ*.md'
design_glob="*/${dev_specs}*"
if find "$REPO_ROOT" -path "$request_glob" -not -path "$design_glob" -print -quit | grep -q .; then
	echo "FAIL: repository-owned request fixture found outside the feature design tree"
	fail=1
fi

exit "$fail"
