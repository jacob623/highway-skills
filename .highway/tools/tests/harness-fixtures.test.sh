#!/usr/bin/env bash
# Harness fixtures exist for the five stages and match their current output templates: every file
# mapped in harness/fixtures/templates.map carries its template's frontmatter keys, required
# headings, and table header rows, and every overlay names a stage.
set -u
# Instrument class: static-document-contract
# Artifact classes: harness-fixture, output-template
# Seeded failure probe: removing a required heading from a copy of a stage's implementation record makes template-check.sh fail on it, and a fixture with that copy fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
FIXTURES="$REPO_ROOT/harness/fixtures"
MAP="$FIXTURES/templates.map"
TEMPLATES="$HIGHWAY_ROOT/library/templates/output"
fail=0
TAB="$(printf '\t')"

if [[ ! -f "$MAP" ]]; then
	echo "FAIL: harness/fixtures/templates.map does not exist"
	exit 1
fi

while IFS="$TAB" read -r glob template; do
	case "$glob" in '' | '#'*) continue ;; esac
	if [[ -z "$template" || ! -f "$TEMPLATES/$template" ]]; then
		echo "FAIL: templates.map maps $glob to '$template', which is not an output template"
		fail=1
	fi
done <"$MAP"

for stage in setup request discovery architecture implementation; do
	if [[ ! -d "$FIXTURES/stages/$stage" ]] || [[ -z "$(find "$FIXTURES/stages/$stage" -type f)" ]]; then
		echo "FAIL: stage fixture harness/fixtures/stages/$stage is missing or empty"
		fail=1
	fi
done

if [[ "$fail" -eq 0 ]]; then
	if ! out="$(bash "$REPO_ROOT/harness/bin/fixture-check.sh")"; then
		while IFS="$TAB" read -r fixture path problem; do
			[[ -n "$fixture" ]] && echo "FAIL: fixture $fixture: $path: $problem"
		done <<<"$out"
		fail=1
	fi
fi

# Seeded probe: a record missing a required heading fails the template check.
record="$(find "$FIXTURES/stages/implementation/implementations" -name 'RI*.md' 2>/dev/null | head -n 1)"
if [[ -n "$record" ]]; then
	probe="$(mktemp)"
	grep -v '^## Technology Choice$' "$record" >"$probe"
	if bash "$REPO_ROOT/harness/bin/template-check.sh" implementation-record.md "$probe" >/dev/null 2>&1; then
		echo "FAIL: template-check.sh passed a record with no ## Technology Choice heading"
		fail=1
	fi
	rm -f "$probe"
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: every harness fixture matches its current output template"
