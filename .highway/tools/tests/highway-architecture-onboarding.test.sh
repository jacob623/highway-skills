#!/usr/bin/env bash
# Verifies the Highway Reference Architecture workflow contract for Feature 175.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-architecture/SKILL.md"
RECORD_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/architecture-record.md"
CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/architecture-catalog.md"

fail=0
require_file() {
	if [[ ! -f "$1" ]]; then
		echo "FAIL: expected file does not exist: $1"
		fail=1
	fi
}
require_text() {
	local file="$1" text="$2"
	if [[ ! -f "$file" ]] || ! grep -Fq -- "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}
forbidden_text() {
	local file="$1" text="$2"
	if [[ -f "$file" ]] && grep -Fq -- "$text" "$file"; then
		echo "FAIL: forbidden '$text' present in $file"
		fail=1
	fi
}

require_file "$SKILL"
require_file "$RECORD_TEMPLATE"
require_file "$CATALOG_TEMPLATE"

if [[ -f "$SKILL" ]]; then
	require_text "$SKILL" "name: highway-architecture"
	require_text "$SKILL" "usage: \"Invoke as \`/highway-architecture\` with one ADR ID.\""
	require_text "$SKILL" "Exactly one explicit ADRXXXXXX identifier"
	require_text "$SKILL" "status is accepted"
	require_text "$SKILL" ".highway/library/templates/output/architecture-record.md"
	require_text "$SKILL" ".highway/library/templates/output/architecture-catalog.md"
	require_text "$SKILL" "ARCHXXXXXX"
	require_text "$SKILL" "proposed"
	require_text "$SKILL" "missing -> continue"
	require_text "$SKILL" "blocked -> continue"
	require_text "$SKILL" "malformed or inconsistent -> abort without writes"
	require_text "$SKILL" "validation before persistence"
	require_text "$SKILL" "atomic"
	require_text "$SKILL" "ADR remains authoritative"
	require_text "$SKILL" "does not modify ADR, Discovery, Request, Profile, Objective"
	require_text "$SKILL" "reject duplicate"
	require_text "$SKILL" "bounded retry limit"
	require_text "$SKILL" "no partial output"
	require_text "$SKILL" "byte-identical"
	require_text "$SKILL" "No timestamps"
	require_text "$SKILL" "No capability artifacts"
	require_text "$SKILL" "Reference Implementation Guidance"
	require_text "$SKILL" "implementation authorization is excluded"
	forbidden_text "$SKILL" "generate a capability artifact"
	forbidden_text "$SKILL" "authorize implementation by Reference Architecture"
fi

if [[ -f "$RECORD_TEMPLATE" ]]; then
	require_text "$RECORD_TEMPLATE" "name: architecture-record"
	require_text "$RECORD_TEMPLATE" "id: ARCHXXXXXX"
	require_text "$RECORD_TEMPLATE" "adr: ADRXXXXXX"
	require_text "$RECORD_TEMPLATE" "status: proposed"
	for section in \
		"## ADR Reference" "## Context" "## Architecture Summary" "## Architecture Style" \
		"## Logical Components" "## Interaction Model" "## Trust Boundaries" "## Deployment Pattern" \
		"## Key Technologies" "## Inherited ADR Decisions" "## Constraints" "## Objective Relationships" \
		"## Control Relationships" "## NFR Relationships" "## Required Capabilities" "## Assumptions" \
		"## Risks" "## Reference Implementation Guidance" "## Traceability"; do
		require_text "$RECORD_TEMPLATE" "$section"
	done
fi

if [[ -f "$CATALOG_TEMPLATE" ]]; then
	require_text "$CATALOG_TEMPLATE" "name: architecture-catalog"
	require_text "$CATALOG_TEMPLATE" "Next ID: ARCHXXXXXX"
	require_text "$CATALOG_TEMPLATE" "## Architecture Index"
	require_text "$CATALOG_TEMPLATE" "ADR ID"
	require_text "$CATALOG_TEMPLATE" "Architecture Path"
	require_text "$CATALOG_TEMPLATE" "Entries are unique"
	require_text "$CATALOG_TEMPLATE" "appear at most once"
fi

if (( fail != 0 )); then
	exit 1
fi
printf '%s\n' "PASS: highway-architecture onboarding contract"
