#!/usr/bin/env bash
# Contract checks for Feature 160 Objective guidance structure and presentation.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact, test-harness

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SOURCE="$HIGHWAY_ROOT/skills/highway-objectives/SKILL.md"
fail=0

require_text() {
	local file="$1" text="$2" label="$3"
	if grep -Fiq -- "$text" "$file"; then
		echo "OK: $label"
	else
		echo "FAIL: $label (missing '$text' in $file)" >&2
		fail=1
	fi
}

require_absent() {
	local file="$1" text="$2" label="$3"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $label (unexpected '$text' in $file)" >&2
		fail=1
	else
		echo "OK: $label"
	fi
}

require_order() {
	local previous=0 current heading
	for heading in \
		"## Response Support Text" \
		"## Recommendation Development" \
		"## Interpretation Confidence" \
		"## Objective Contribution Guidance" \
		"## Objective Portfolio Assessment Guidance" \
		"## Objective Recommendation Presentation"; do
		current="$(grep -nF "$heading" "$SOURCE" | head -n 1 | cut -d: -f1)"
		if [[ -z "$current" || "$current" -le "$previous" ]]; then
			echo "FAIL: peer section order at '$heading'" >&2
			fail=1
		else
			echo "OK: peer section order: $heading"
			previous="$current"
		fi
	done
}

if [[ ! -f "$SOURCE" ]]; then
	echo "FAIL: Objective source is missing: $SOURCE" >&2
	exit 1
fi

require_order
require_text "$SOURCE" "**Objective**" "Objective remains the primary presentation anchor"
require_text "$SOURCE" "- **Scale Craft Kit Production and Fulfillment**" "recommendation exemplar outcome one"
require_text "$SOURCE" "- **Publish and Distribute Handwork Curriculum**" "recommendation exemplar outcome two"
require_text "$SOURCE" "- **Expand Local Studio Classes and Community Gatherings**" "recommendation exemplar outcome three"
require_text "$SOURCE" "select one, several, or all" "explicit recommendation selection choices"
require_text "$SOURCE" "modify any of them" "explicit recommendation modification path"
require_text "$SOURCE" "provide your own outcome" "explicit user-authored path"
require_text "$SOURCE" "additional suggestions" "explicit future suggestion availability"
require_text "$SOURCE" "grounded interpretation" "interpretation confidence guidance"
require_text "$SOURCE" "Recommendations are grounded in accepted Profile evidence" "recommendation development grounding"
require_text "$SOURCE" "recommendations remain Working Ideas until accepted" "recommendation acceptance boundary"
require_text "$SOURCE" "Creation Workflow" "creation workflow retained"
require_text "$SOURCE" "active Objective queue" "queue contract retained"
require_text "$SOURCE" "successful atomic persistence" "persistence contract retained"
require_text "$SOURCE" "Repository Context Participating Skill" "context declaration retained"

heading_count="$(grep -Ec '^## (Response Support Text|Recommendation Development|Interpretation Confidence|Objective Contribution Guidance|Objective Portfolio Assessment Guidance|Objective Recommendation Presentation)$' "$SOURCE")"
exemplar_count="$(grep -Ec '^### Illustrative Recommendation Presentation Example$' "$SOURCE")"
if [[ "$heading_count" -eq 6 && "$exemplar_count" -eq 1 ]]; then
	echo "OK: bounded Feature 160 guidance surface (6 peer headings, 1 exemplar)"
else
	echo "FAIL: Feature 160 guidance surface exceeds the clarified bound" >&2
	fail=1
fi

for adapter in \
	.github/skills/highway-objectives/SKILL.md \
	.claude/skills/highway-objectives/SKILL.md \
	.cursor/skills/highway-objectives/SKILL.md \
	.agents/skills/highway-objectives/SKILL.md; do
	if [[ ! -f "$REPO_ROOT/$adapter" ]]; then
		echo "FAIL: generated adapter is missing: $adapter" >&2
		fail=1
	elif cmp -s "$SOURCE" "$REPO_ROOT/$adapter"; then
		echo "OK: generated adapter matches source: $adapter"
	else
		echo "FAIL: generated adapter differs from source: $adapter" >&2
		fail=1
	fi
done

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "OK: Feature 160 Objective structural refinement contract passes"
