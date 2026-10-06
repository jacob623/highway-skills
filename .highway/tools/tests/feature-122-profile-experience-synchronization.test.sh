#!/usr/bin/env bash
# Verifies Profile synchronization with the shared runtime contract.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
TEMPLATE="$HIGHWAY_ROOT/library/templates/output/profile-record.md"
fail=0
require() { grep -Fq -- "$1" "$PROFILE" || { echo "FAIL: Profile skill missing '$1'"; fail=1; }; }
for text in \
	'Profile determines domain completeness' \
	'#### Domain completeness' \
	'When entering unresolved Vision' \
	'When entering unresolved Competitive' \
	'When entering unresolved Guiding Principles' \
	'connect the accepted Profile understanding to later Highway guidance' \
	'A domain is complete when accumulated evidence supports one cohesive organizational narrative'; do require "$text"; done
for forbidden in 'Profile does not require fixed recommendation sentence templates.' 'X2.36' '## Enrichment'; do
	if grep -Fq -- "$forbidden" "$PROFILE"; then echo "FAIL: superseded Profile wording remains '$forbidden'"; fail=1; fi
done
for token in 'schema_version: 3.0.0' 'identity: not_discussed' 'vision: not_discussed' 'competitive_path: not_discussed' 'guiding_principles: not_discussed'; do
	grep -Fq "$token" "$TEMPLATE" || { echo "FAIL: Profile template missing '$token'"; fail=1; }
done
for generated in .agents/skills/highway-profile/SKILL.md .claude/skills/highway-profile/SKILL.md .github/skills/highway-profile/SKILL.md .cursor/skills/highway-profile/SKILL.md; do
	if [[ ! -f "$REPO_ROOT/$generated" ]] || ! cmp -s "$PROFILE" "$REPO_ROOT/$generated"; then echo "FAIL: generated adapter stale: $generated"; fail=1; fi
done
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 122 Profile synchronization contract passes'
