#!/usr/bin/env bash
# Organization and offering instructions are present as steps, not explanations.
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

PROFILE="$HW_SKILLS/highway-profile/SKILL.md"
STANDARD="$(hw_doc experience-standard)"
EXPERIENCE="$HW_EXPERIENCE/""SKILL.md"
ONBOARDING="$HW_SKILLS/highway-onboarding/SKILL.md"
PROPOSAL="$HW_SKILLS/highway-onboarding/references/proposal.md"
OBJECTIVES="$HW_SKILLS/highway-objectives/SKILL.md"
ASSESSMENT="$HW_SKILLS/highway-assessment/SKILL.md"

require "$STANDARD" 'X2.73'
require "$STANDARD" 'When the organization name contains an offering'"'"'s distinguishing name, an organizational sentence MUST use the full organization name.'
require "$STANDARD" 'The short name appears only for the offering.'
require "$STANDARD" 'Version `11.2.0`.'
require "$EXPERIENCE" 'version: 1.6.0'

require "$PROFILE" 'version: 14.7.0'
require "$PROFILE" '**What is the organization'"'"'s name?**'
require "$PROFILE" 'State who the organization is in one finding.'
require "$PROFILE" 'State each offering in its own finding.'
require "$PROFILE" 'Do not add a finding to reach a count.'
require "$PROFILE" 'Name an offering with the person'"'"'s words for the kind of thing.'
require "$PROFILE" 'Drop the product'"'"'s proper name, its feature list, and how it is built.'
require "$PROFILE" 'When no category word remains, ask one question. Do not coin a category.'
require "$PROFILE" 'Do not store a product as the organization or as the offering unless the person says they are the same subject.'
require "$PROFILE" 'Name the organization in Future State.'
require "$PROFILE" 'Do not infer Vision from offering language alone.'
require "$PROFILE" 'When the organization and an offering are mixed and the subject is neither one alone, ask one question. Do not emit a proposal in that message.'
require "$PROFILE" 'When the organization name contains an offering'"'"'s distinguishing name, put the full organization name in an organizational sentence. Put the short name only on the offering.'
require "$PROFILE" '### split'
require "$PROFILE" 'Restate who the organization is and each offering.'
require "$PROFILE" 'A merge that does not say they are the same subject does not write.'

STOP='When the person separates the organization from an offering the accepted Profile fuses, stop.'
ACCEPT='On accept, stop this skill and run highway-profile review before any other record.'
DECLINE='On decline, stay stopped.'
for skill in "$ONBOARDING" "$OBJECTIVES" "$ASSESSMENT"; do
	require "$skill" "$STOP"
	require "$skill" "$ACCEPT"
	require "$skill" "$DECLINE"
done

CAPABILITY='Do not propose a product behavior, feature, or packaging choice as a capability unless the person says the organization operates it.'
require "$ONBOARDING" "$CAPABILITY"
require "$PROPOSAL" "$CAPABILITY"
require "$ONBOARDING" 'version: 10.15.0'
require "$OBJECTIVES" 'version: 8.10.0'
require "$ASSESSMENT" 'version: 5.6.0'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "OK: organization and offering instructions"
exit 0
