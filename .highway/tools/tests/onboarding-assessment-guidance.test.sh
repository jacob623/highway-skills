#!/usr/bin/env bash
# Onboarding opens with an overview and numbered capabilities. Assessment lists findings before showing one.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring the save-or-discard line or the separate open list fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ONBOARDING="$HIGHWAY_ROOT/skills/highway-onboarding/SKILL.md"
ASSESSMENT="$HIGHWAY_ROOT/skills/highway-assessment/SKILL.md"
fail=0

require() {
	local file="$1" text="$2"
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $(basename "$(dirname "$file")") omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $(basename "$(dirname "$file")") still contains: $text"
		fail=1
	fi
}

require "$ONBOARDING" 'Follow the steps in this order: `overview`, `capabilities`'
require "$ONBOARDING" '### overview'
require "$ONBOARDING" "Emit \"What we'll do together\" as a level-3 heading."
require "$ONBOARDING" 'This is where Highway helps you navigate your technology landscape.'
require "$ONBOARDING" "During onboarding we'll:"
require "$ONBOARDING" '- **Identify important business capabilities** your organization relies on.'
require "$ONBOARDING" '- **Understand the platforms and processes** that support those capabilities today.'
require "$ONBOARDING" "- **Validate Highway's understanding** before any architecture knowledge is created."
require "$ONBOARDING" '- **Capture accepted knowledge** as connected architecture and implementation context.'
require "$ONBOARDING" "You don't need to have everything documented in advance. We'll build that understanding together, one capability at a time."
require "$ONBOARDING" "Now, let's get started."
require "$ONBOARDING" '2. **[Capability title]:**'
require "$ONBOARDING" 'Each item names one capability.'
require "$ONBOARDING" "**We've identified the capabilities that matter to your organization. Now let's look at how those capabilities are provided today.**"
require "$ONBOARDING" "For each capability, we'll identify the platforms, services, processes, or people that help deliver it."
require "$ONBOARDING" 'On the first capability, emit this before the block. Do not emit it again.'
reject "$ONBOARDING" 'On the first visit, emit this level-3 heading'
reject "$ONBOARDING" '**Highway:** Connect accepted business goals'
reject "$ONBOARDING" '**Business Purpose:** [Business purpose.]'

for label in '**[Capability title]:**' '**Business Purpose:**' '**Provider:**'; do
	awk -v label="$label" '
		index($0, label) == 1 && $0 == label { getline nxt; if (nxt == "") found = 1 }
		END { exit found ? 0 : 1 }
	' "$ONBOARDING" || {
		echo "FAIL: highway-onboarding mapping label lacks a blank line before its value: $label"
		fail=1
	}
done

require "$ASSESSMENT" '### list of findings'
require "$ASSESSMENT" "Emit \"Let's see what your repository may be telling us.\" as a level-3 heading."
require "$ASSESSMENT" 'Highway will review accepted knowledge, surface observations that may be worth your attention, and suggest opportunities, improvements, or next steps where they may create value.'
require "$ASSESSMENT" '**Based on what Highway knows, these may be worth visiting:**'
require "$ASSESSMENT" '1. **Finding:**'
require "$ASSESSMENT" '**Complexity:**'
require "$ASSESSMENT" 'Show at most 5 findings.'
require "$ASSESSMENT" 'Put findings whose Status is `Open` first.'
require "$ASSESSMENT" 'Write each new finding through `write` with Status `Open` before emitting the list.'
require "$ASSESSMENT" '**Would you like to explore any of these findings in more detail?**'
require "$ASSESSMENT" "If you'd like to see additional findings, just say so."
require "$ASSESSMENT" '- `select`: chooses a listed finding, by number or by its summary.'
require "$ASSESSMENT" '- `more`: asks to see additional findings.'
require "$ASSESSMENT" '- `back`: asks to go back to the list of findings.'
require "$ASSESSMENT" "If you'd like to go back to the list of findings, just say so."
require "$ASSESSMENT" '- `accept`: update the written row to Status `Accepted` through `write`. Then go to `list of findings`.'
require "$ASSESSMENT" '- `dismiss`: update the written row to Status `Dismissed` through `write`. Then go to `list of findings`.'
reject "$ASSESSMENT" 'If you want to save this for later, or discard it entirely, just say so.'
reject "$ASSESSMENT" '### open'
reject "$ASSESSMENT" 'list the retained findings'

list_line=$(grep -n '^### list of findings$' "$ASSESSMENT" | cut -d: -f1)
finding_line=$(grep -n '^### finding$' "$ASSESSMENT" | cut -d: -f1)
if [[ -z "$list_line" || -z "$finding_line" || "$list_line" -ge "$finding_line" ]]; then
	echo "FAIL: highway-assessment list of findings does not come before finding"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: onboarding and assessment guidance"
