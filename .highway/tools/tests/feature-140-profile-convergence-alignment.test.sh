#!/usr/bin/env bash
# Verifies Profile-owned domain semantics and delegation to the shared runtime.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
fail=0

require_text() {
	local text="$1"
	if ! grep -Fq -- "$text" "$PROFILE"; then
		echo "FAIL: Profile skill missing '$text'"
		fail=1
	fi
}

for required in \
	'version: 11.1.0' \
	'Profile determines domain completeness' \
	'The Highway Experience Standard determines whether collaborative development has converged enough' \
	'Profile determines the four domain meanings' \
	'### Domain completeness' \
	'A domain is complete when accumulated evidence supports one cohesive organizational narrative' \
	'Profile-specific validation questions apply to the domain' \
	'### Cross-domain reasoning' \
	'When entering unresolved Vision' \
	'Canonical questions are Profile-owned fallbacks' \
	; do
	require_text "$required"
done

for forbidden in 'complete person-Highway recursive loop' 'X2.41' 'schema 2.0.0' 'obsolete YAML'; do
	if grep -Fq -- "$forbidden" "$PROFILE"; then
		echo "FAIL: Profile skill contains forbidden generic duplication '$forbidden'"
		fail=1
	fi
done

for generated in \
	.agents/skills/highway-profile/SKILL.md \
	.claude/skills/highway-profile/SKILL.md \
	.github/skills/highway-profile/SKILL.md \
	.cursor/skills/highway-profile/SKILL.md; do
	if [[ ! -f "$REPO_ROOT/$generated" ]] || ! cmp -s "$PROFILE" "$REPO_ROOT/$generated"; then
		echo "FAIL: generated Profile adapter is stale: $generated"
		fail=1
	fi
done

if [[ "$fail" -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 140 Profile convergence alignment contract passes'
