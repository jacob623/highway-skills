#!/usr/bin/env bash
# Verifies X2.3 interaction-wide behavior while preserving X2.7-X2.10 outputs.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, disposable-fixture
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
FIXTURES="$SCRIPT_DIR/fixtures/profile-092/interaction"
fail=0
require() { grep -Fq -- "$2" "$1" || { echo "FAIL: $1 missing '$2'"; fail=1; }; }
for file in "$FIXTURES/normal/response.txt" "$FIXTURES/cross-rule/response.txt"; do
	for token in 'Next Action:' 'Acknowledgment:' 'Progress:'; do require "$file" "$token"; done
done
require "$FIXTURES/cross-rule/response.txt" 'Decision Context:'
require "$FIXTURES/cross-rule/response.txt" 'Relevant Examples:'
require "$FIXTURES/explicit-details/response.txt" 'implementation details'
require "$HIGHWAY_ROOT/governance/experience-standard.md" 'Every user-visible response excludes Implementation details unless requested.'
for skill in highway-profile highway-setup highway-objectives highway-controls highway-nfrs; do
	if ! grep -Fq 'implementation details' "$HIGHWAY_ROOT/skills/$skill/SKILL.md" ||
		{ ! grep -Fq 'unless requested' "$HIGHWAY_ROOT/skills/$skill/SKILL.md" &&
		  ! grep -Fq 'only when needed' "$HIGHWAY_ROOT/skills/$skill/SKILL.md" &&
		  ! grep -Fq 'do not expose' "$HIGHWAY_ROOT/skills/$skill/SKILL.md"; }; then
		echo "FAIL: $skill does not state the X2.3 detail boundary"; fail=1
	fi
done
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: X2.3 interaction contract passes'
