#!/usr/bin/env bash
# Verifies Feature 155 source-document delivery sites; it does not prove runtime conversation behavior.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
fail=0

flow() { tr '\n' ' ' < "$1" | tr -s ' '; }
require_flowed() { flow "$1" | grep -Fq -- "$3" || { echo "FAIL: $2 missing: $3"; fail=1; }; }
require_count() {
	actual="$(flow "$1" | grep -Fo -- "$3" | wc -l | tr -d ' ')"
	if [[ "$actual" -ne "$4" ]]; then
		echo "FAIL: $2 expected $4 occurrences of '$3' but found $actual"
		fail=1
	fi
}

if flow "$PROFILE" | grep -Fq -- '#### Possibility-list Contribution Opportunities'; then
	echo "FAIL: Profile skill retains retired possibility-list guidance"
	fail=1
fi
require_flowed "$PROFILE" 'Profile skill' '### Identity Discovery Contribution Opportunity'
require_flowed "$PROFILE" 'Profile skill' '###### Vision Discovery Contribution Opportunity'
require_flowed "$PROFILE" 'Profile skill' '###### Competitive Path Discovery Contribution Opportunity'
require_flowed "$PROFILE" 'Profile skill' '###### Guiding Principles Discovery Contribution Opportunity'
require_count "$PROFILE" 'Profile skill' '**What would you add, correct, or remove?**' 5
require_flowed "$STANDARD" 'Experience Standard' '| X2.69 | A contributed addition MUST NOT exceed one distinction or extension per Substantive Contribution. | One addition appears; a second, an enumerated set of offered options, or a recommendation set does not. |'

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 155 possibility-list delivery sites pass'
