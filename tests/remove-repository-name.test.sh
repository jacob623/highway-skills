#!/usr/bin/env bash
# Repository Name is removed; Organization Name is the first Profile question and the only name.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"

fail=0

require() {
	local file="$1" text="$2"
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $file omits: $text"
		fail=1
	}
}

forbid() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $file still contains: $text"
		fail=1
	fi
}

PROFILE="$HW_SKILLS/highway-profile/SKILL.md"
RECORD="$(hw_template profile-record)"
PROPOSAL="$HW_SKILLS/highway-onboarding/references/proposal.md"
ONBOARDING="$HW_SKILLS/highway-onboarding/SKILL.md"
OBJECTIVES="$HW_SKILLS/highway-objectives/SKILL.md"
CONTROLS="$HW_SKILLS/highway-controls/SKILL.md"
NFRS="$HW_SKILLS/highway-nfrs/SKILL.md"

require "$PROFILE" 'version: 14.7.0'
require "$PROFILE" '**What is the organization'"'"'s name?**'
require "$PROFILE" 'Store the reply as Organization Name.'
require "$PROFILE" '**Do you already have something I can use to start understanding [Organization Name]?**'
require "$PROFILE" '- The person has nothing: go to `identity.ask`.'
require "$PROFILE" 'Write `## Context` with Organization Name.'
require "$PROFILE" 'Review has no organization-name migration prompt.'
forbid "$PROFILE" 'Repository Name'
forbid "$PROFILE" 'What would you like to call your Highway repository?'
forbid "$PROFILE" '### organization-name'

require "$RECORD" 'version: 3.2.0'
require "$RECORD" '### Organization Name'
require "$RECORD" '### Organization URL'
require "$RECORD" '### Organizational Context'
forbid "$RECORD" '### Repository Name'

require "$PROPOSAL" '[Name] is the accepted Organization Name.'
forbid "$PROPOSAL" 'Repository Name'
require "$ONBOARDING" 'version: 10.15.0'

require "$OBJECTIVES" 'Use the accepted Organization Name from the Profile.'
forbid "$OBJECTIVES" 'Repository Name'
require "$OBJECTIVES" 'version: 8.10.0'

require "$CONTROLS" 'Use the accepted Organization Name from the Profile.'
forbid "$CONTROLS" 'Repository Name'
require "$CONTROLS" 'version: 8.9.0'

require "$NFRS" 'Use the accepted Organization Name from the Profile.'
forbid "$NFRS" 'Repository Name'
require "$NFRS" 'version: 9.10.0'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "OK: repository name removed; organization name is first"
exit 0
