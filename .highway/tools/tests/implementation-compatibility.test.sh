#!/usr/bin/env bash
# Verifies the Feature 178 implementation compatibility assessment contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document
# Seeded failure probe: --probe source-document exercises the probe contract; --neutralise restores it.

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi
if [[ -n "$probe_class" ]]; then
	probe_root="$(mktemp -d "${TMPDIR:-/tmp}/implementation-compatibility.XXXXXX")"
	probe_path="$probe_root/probe.md"
	trap 'rm -rf "$probe_root"' EXIT
	if [[ "$neutralise" -eq 1 ]]; then
		printf '%s\n' 'compatibility contract token' >"$probe_path"
	else
		printf '%s\n' 'missing required token' >"$probe_path"
	fi
	grep -Fq 'compatibility contract token' "$probe_path"
	exit $?
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-implementation/SKILL.md"
RECORD_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/implementation-record.md"
fail=0

require_text() {
	local file="$1" text="$2"
	if [[ ! -f "$file" ]] || ! grep -Fq -- "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

for text in \
	"Implementation Selections" \
	"one or more" \
	"Architecture Compatibility Assessment" \
	"Compatible" \
	"Incomplete" \
	"Incompatible" \
	"Coverage Summary" \
	"Compute" \
	"Messaging" \
	"Persistence" \
	"Identity" \
	"Networking" \
	"Security" \
	"Observability" \
	"Recovery" \
	"Deployment" \
	"Operations" \
	"Satisfied" \
	"Unsatisfied" \
	"Not Applicable" \
	"Implementation Gap Analysis" \
	"Missing Capability" \
	"Why It Matters" \
	"Suggested Realization" \
	"Recommendation Confidence" \
	"Unknown" \
	"Implementation Conflicts" \
	"Architecture Requirement" \
	"Implementation Selection" \
	"Conflict Explanation" \
	"Resolve Implementation" \
	"Revisit Architecture" \
	"Technology Realization Rationale" \
	"Architecture Authority" \
	"brownfield" \
	"no RI"; do
	require_text "$SKILL" "$text"
done

for text in \
	"## Architecture Compatibility Assessment" \
	"## Coverage Summary" \
	"## Implementation Gaps" \
	"## Implementation Conflicts" \
	"## Implementation Selections" \
	"## Technology Realization Rationale" \
	"Result: Compatible | Incomplete | Incompatible" \
	"Missing Capability" \
	"Why It Matters" \
	"Suggested Realization" \
	"Recommendation Confidence" \
	"Architecture Requirement" \
	"Implementation Selection" \
	"Conflict Explanation" \
	"Reason Selected" \
	"Supporting Evidence"; do
	require_text "$RECORD_TEMPLATE" "$text"
done

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
printf '%s\n' "PASS: implementation compatibility contract"
