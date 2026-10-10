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

require_flowed "$PROFILE" 'Profile skill' '#### Possibility-list Contribution Opportunities'
require_flowed "$PROFILE" 'Profile skill' 'Before convergence, when accepted Profile evidence supports several distinct grounded possibilities'
require_flowed "$PROFILE" 'Profile skill' 'pre-convergence reaction material, not a recommendation set and not three advisory contributions'
require_flowed "$PROFILE" 'Profile skill' 'this behavior does not modify X2.69'
require_flowed "$PROFILE" 'Profile skill' 'Each item must remain provisional and traceable to accepted Profile evidence.'
require_flowed "$PROFILE" 'Profile skill' 'adopt, reject, combine, modify, or ignore items individually'
require_flowed "$PROFILE" 'Profile skill' 'an unaddressed item is not accepted'
require_flowed "$PROFILE" 'Profile skill' 'Use no more than three items'
require_flowed "$PROFILE" 'Profile skill' 'close with the shared emphasized question that asks what to add, correct, or remove.'
require_flowed "$PROFILE" 'Profile skill' 'Do not present the list as a candidate, acceptance request, or selection among options.'
require_flowed "$PROFILE" 'Profile skill' 'After convergence, present the singular Converged Proposal path instead.'
require_count "$PROFILE" 'Profile skill' '#### Advisory question scaffolding' 1
require_flowed "$STANDARD" 'Experience Standard' '| X2.69 | A contributed addition MUST NOT exceed one distinction or extension per Substantive Contribution. | One addition appears; a second, an enumerated set of offered options, or a recommendation set does not. |'

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 155 possibility-list delivery sites pass'
