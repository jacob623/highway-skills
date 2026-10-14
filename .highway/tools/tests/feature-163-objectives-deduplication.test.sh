#!/usr/bin/env bash
# Contract checks for Feature 163 Objective section ownership and deduplication.
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
	if grep -Fq -e "$text" "$file"; then
		echo "OK: $label"
	else
		echo "FAIL: $label (missing '$text' in $file)" >&2
		fail=1
	fi
}

require_absent() {
	local file="$1" text="$2" label="$3"
	if grep -Fq -e "$text" "$file"; then
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
	"### Objective Development Lifecycle" \
	"Recommendation Selected or User Provided Objective" \
	"Present Converged Objective proposal" \
	"User Acceptance" \
	"Capture" \
	"Next Objective" \
	"- Objective title;" \
	"- Objective statement;" \
	"- proposed Success Measures;" \
	"- synthesized Rationale." \
	"The Objective owner is expected to develop a complete first-pass Objective proposal" \
	"Conversational discovery remains available but is the exception path."; do
	require_text "$SOURCE" "$phrase" "canonical lifecycle owner: $phrase"
done

for phrase in \
	"Selection does not capture an Objective." \
	"active Objective queue" \
	"Queue membership determines development order only" \
	"the Converged Objective proposal defined in the Objective Development Lifecycle has been presented" \
	"Illustrative queue example:"; do
	require_text "$SOURCE" "$phrase" "queue ownership: $phrase"
done

for phrase in \
	"Process each selected Objective through proposal and acceptance"; do
	require_text "$SOURCE" "$phrase" "Creation Workflow ownership: $phrase"
done

for phrase in \
	"Prefer a grounded interpretation that can be corrected" \
	"Recommendations are grounded in accepted Profile evidence." \
	"The user-authored path remains available and" \
	"The Objective should remain the primary conversational anchor."; do
	require_text "$SOURCE" "$phrase" "focused owner or example: $phrase"
done

for phrase in \
	"Normal path:" \
	"NOT:" \
	"The Converged Objective proposal is presented once." \
	"The person accepts, corrects, replaces, or rejects that proposal." \
	"Process each queued recommendation sequentially:" \
	"- present the Converged Objective proposal defined in the Objective Development Lifecycle;" \
	"- obtain User Acceptance;" \
	"- capture the Objective;" \
	"- continue to the next queue item." \
	"When accepted evidence supports a reasonable Objective interpretation, develop the Objective before asking an exploratory question." \
	"Then develop Success Measures." \
	"Do not begin with a chain of Success questions before the Objective itself is visible." \
	"The owner must derive proposed Success Measures when the recommendation contains sufficient accepted"; do
	require_absent "$SOURCE" "$phrase" "duplicate guidance removed: $phrase"
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

require_text "$SOURCE" "Objective statement;" "Objective statement record contract preserved"
require_text "$SOURCE" "proposed Success Measures;" "Success Measures record contract preserved"
require_text "$SOURCE" "successful atomic persistence" "atomic persistence contract preserved"
require_text "$SOURCE" "library/objectives/" "user-owned Objective path preserved"
require_text "$SOURCE" "Repository Context Participating Skill" "Repository Context declaration preserved"

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi

echo "OK: Feature 163 Objective deduplication contract passes"
