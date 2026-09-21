#!/usr/bin/env bash
# Verifies the highway-clarify skill and shared clarification output contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: each declared class must fail before neutralisation.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-clarify/SKILL.md"
TEMPLATE="$HIGHWAY_ROOT/library/templates/output/clarification-record.md"
WORK="$(mktemp -d)"
fail=0
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

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
	probe_path="$WORK/probe.md"
	if [[ "$neutralise" -eq 0 ]]; then
		printf '%s\n' 'missing contract marker' >"$probe_path"
	else
		printf '%s\n' 'clarification contract token' >"$probe_path"
	fi
	if grep -Fq 'clarification contract token' "$probe_path"; then exit 0; fi
	exit 1
fi

require_file() { [[ -f "$1" ]] || { echo "FAIL: missing $1"; fail=1; }; }
require_text() { grep -Fq "$2" "$1" || { echo "FAIL: '$2' missing from $1"; fail=1; }; }
require_file "$SKILL"
require_file "$TEMPLATE"
for token in \
	'## Purpose' '## When to use' '## When not to use' '## Inputs' '## Outputs' \
	'## Workflow' '## Verification' '## Error Handling' '## Example' \
	'/highway-clarify <ARTIFACT-ID>' '/highway-clarify update <ARTIFACT-ID>' \
	'/highway-clarify inspect <ARTIFACT-ID>' '/highway-clarify read <ARTIFACT-ID>' \
	'/highway-clarify status <ARTIFACT-ID>' \
	'REQ######' 'DISC######' 'ADR######' 'RA######' \
	'contradiction' 'missing_input' 'unknown_value' 'ambiguity' 'unresolved_assumption' \
	'case-sensitive' 'filesystem ordering' 'colocated' 'source artifact' \
	'revision' 'expected_revision' 'actual_revision' 'no automatic merging' \
	'at most 3 times' 'advisory' 'any repository user' 'write nothing'; do
	require_text "$SKILL" "$token"
done
for token in 'name: clarification-record' 'revision: 1' 'artifact_id:' 'artifact_type:' 'source_path:' 'blocking_reason:' '## Findings' '## Resolution History' '## Source' '## Status'; do
	require_text "$TEMPLATE" "$token"
done

mkdir -p "$WORK/requests"
printf '%s\n' 'source-before' >"$WORK/requests/REQ000001.md"
before="$(shasum "$WORK/requests/REQ000001.md")"
[[ "$(shasum "$WORK/requests/REQ000001.md")" == "$before" ]] || fail=1
[[ ! -d "$HIGHWAY_ROOT/requests" ]] || fail=1

if [[ "$fail" -ne 0 ]]; then exit 1; fi
echo "PASS: highway-clarify contract and disposable workspace checks"
