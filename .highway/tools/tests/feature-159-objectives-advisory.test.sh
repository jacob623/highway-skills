#!/usr/bin/env bash
# Contract checks for Feature 159 Objective collaboration and recommendation behavior.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SOURCE="$HIGHWAY_ROOT/skills/highway-objectives/SKILL.md"
fail=0

require_text() {
	local file="$1" text="$2" label="$3"
	local content
	content="$(tr '\n' ' ' < "$file" | tr -s ' ')"
	if printf '%s' "$content" | grep -Fq "$text"; then
		echo "OK: $label"
	else
		echo "FAIL: $label (missing '$text' in $file)" >&2
		fail=1
	fi
}

require_absent() {
	local file="$1" text="$2" label="$3"
	if grep -Fq "$text" "$file"; then
		echo "FAIL: $label (unexpected '$text' in $file)" >&2
		fail=1
	else
		echo "OK: $label"
	fi
}

if [[ ! -f "$SOURCE" ]]; then
	echo "FAIL: Objective source is missing: $SOURCE" >&2
	exit 1
fi

for phrase in \
	"## Response Support Text" \
	"What would you add, correct, or remove?" \
	"If this is accurate, just say so." \
	"If you don't know, say \"I don't know\" and we'll work through it together." \
	"If none of these fit, feel free to suggest your own outcome." \
	"If you'd like additional suggestions, just let me know." \
	"## Objective Contribution Guidance" \
	"## Objective Portfolio Assessment Guidance" \
	"Illustrative Continuation Example" \
	"Your current Objectives provide strong coverage across curriculum distribution" \
	"Additional Objectives may begin overlapping with outcomes already represented" \
	"one grounded observation at a time" \
	"strategic concentration" \
	"focus fragmentation"; do
	require_text "$SOURCE" "$phrase" "support/advisory phrase: $phrase"
done

for phrase in \
	"### Profile-Informed Recommendations" \
	"Every accepted Profile should be evaluated" \
	"Profile evidence does not create Objectives" \
	"Profile evidence does not transfer ownership" \
	"## Recommendation Exploration" \
	"Review of selected Objectives begins only when:" \
	"Recommendation exhaustion occurs when:" \
	"Selecting recommendations expands the active queue." \
	"Selection does not end recommendation exploration." \
	"Recommendations currently under evaluation are not queue members." \
	"Only selected recommendations are eligible for review." \
	"Once review begins, recommendation exploration is closed." \
	"Creation Workflow orchestrates Recommendation Presentation" \
	"Collection Result: Continue does not require review"; do
	require_text "$SOURCE" "$phrase" "recommendation exploration contract: $phrase"
done

for phrase in \
	"active Objective queue" \
	"Recommendation selection continues queue construction" \
	"Process each selected Objective through proposal and acceptance" \
	"capture accepted Objectives" \
	"A user-provided Objective follows the same proposal" \
	"selecting one, several, or all" \
	"modifying recommendations before adoption" \
	"stop manufacturing recommendations" \
	"explicitly keep future recommendation support available"; do
	require_text "$SOURCE" "$phrase" "workflow phrase: $phrase"
done

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

require_absent "$SOURCE" "Does this objective look right?" "legacy Objective review prompt removed"
require_absent "$SOURCE" "capture them together" "legacy combined recommendation capture removed"
require_text "$SOURCE" "Objective statement;" "retained Objective statement contract preserved"
require_text "$SOURCE" "proposed Success Measures;" "retained Success Measures contract preserved"
require_text "$SOURCE" "successful atomic persistence" "atomic persistence contract preserved"
require_text "$SOURCE" "library/objectives/" "user-owned Objective path preserved"
require_text "$SOURCE" "Repository Context Participating Skill" "Repository Context declaration preserved"
require_text "$SOURCE" "version: 4.0.0" "breaking skill version increment recorded"

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "OK: Feature 159 Objective advisory contract passes"