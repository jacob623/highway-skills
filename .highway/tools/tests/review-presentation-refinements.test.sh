#!/usr/bin/env bash
# Capture reviews are numbered, and a request is proposed and accepted once with readable Solution Constraints.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring the request capture step or a snake-case Solution Constraints label fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILLS="$HIGHWAY_ROOT/skills"
REQUEST="$SKILLS/highway-request/SKILL.md"
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

for pair in "highway-objectives:Objective" "highway-controls:Control" "highway-nfrs:NFR"; do
	skill="$SKILLS/${pair%%:*}/SKILL.md"
	noun="${pair#*:}"
	require "$skill" '1. **[Title]:** [Statement]'
	require "$skill" '   **Why it matters:** [Rationale]'
	require "$skill" "Number every $noun in the review, starting at 1, in queue order."
	require "$skill" "Put \`---\` between ${noun}s."
	require "$skill" "A number in the reply refers to the $noun with that number in the review just shown."
done
require "$SKILLS/highway-objectives/SKILL.md" '   **Success looks like:**'

require "$REQUEST" 'otherwise `start`, then `identifier`,'
require "$REQUEST" '**Here is a proposed starting point for your request:**'
require "$REQUEST" 'Emit this level-1 heading:'
require "$REQUEST" 'Emit these level-2 headings, in this order, with the text under each:'
require "$REQUEST" 'Derive a short title from the Problem.'
require "$REQUEST" 'Show `None` when a value is `unknown` or an empty list.'
require "$REQUEST" 'When the person says "none" for a field, hold an empty list for `existing_platforms_required`, `existing_platforms_preferred`, and `known_systems`.'
require "$REQUEST" 'Hold `unknown` for `allowed_solution_classes`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and `regulatory_restrictions`.'
require "$REQUEST" 'Otherwise go to `identifier`.'
for label in 'Allowed Solution Classes' 'Existing Platforms Required' 'Existing Platforms Preferred' 'Known Systems' \
	'Hosting Restrictions' 'Vendor Restrictions' 'Procurement Constraints' 'Regulatory Restrictions'; do
	require "$REQUEST" "- **$label:**"
done
reject "$REQUEST" '### capture'
reject "$REQUEST" "**Here's what I've captured as your request:**"
reject "$REQUEST" '**allowed_solution_classes:**'
reject "$REQUEST" '**hosting_restrictions:**'
reject "$REQUEST" 'go to `capture`'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: review presentation refinements"
