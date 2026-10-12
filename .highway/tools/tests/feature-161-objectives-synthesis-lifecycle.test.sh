#!/usr/bin/env bash
# Contract checks for Feature 161 Objective synthesis lifecycle guidance.
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
	if grep -Fiq -- "$text" "$file"; then
		echo "FAIL: $label (unexpected '$text' in $file)" >&2
		fail=1
	else
		echo "OK: $label"
	fi
}

require_count() {
	local file="$1" text="$2" expected="$3" label="$4" actual
	actual="$(grep -Fic -- "$text" "$file")"
	if [[ "$actual" -eq "$expected" ]]; then
		echo "OK: $label"
	else
		echo "FAIL: $label (expected $expected occurrences of '$text', found $actual)" >&2
		fail=1
	fi
}

require_order() {
	local previous=0 current heading
	for heading in \
		"## Recommendation Development" \
		"### Objective Development Lifecycle" \
		"## Objective Queue and Acceptance Boundaries" \
		"## Interpretation Confidence"; do
		current="$(grep -nF "$heading" "$SOURCE" | head -n 1 | cut -d: -f1)"
		if [[ -z "$current" || "$current" -le "$previous" ]]; then
			echo "FAIL: lifecycle section order at '$heading'" >&2
			fail=1
		else
			echo "OK: lifecycle section order: $heading"
			previous="$current"
		fi
	done
}

if [[ ! -f "$SOURCE" ]]; then
	echo "FAIL: Objective source is missing: $SOURCE" >&2
	exit 1
fi

require_order
require_text "$SOURCE" "Recommendation Selected or User Provided Objective" "lifecycle starts with selection or user contribution"
require_text "$SOURCE" "Present Converged Objective proposal" "lifecycle names proposal presentation"
require_text "$SOURCE" "User Acceptance" "lifecycle names User Acceptance"
require_text "$SOURCE" "Next Objective" "lifecycle continues to next Objective"
require_text "$SOURCE" "A Converged Objective proposal contains:" "single authoritative proposal definition"
require_count "$SOURCE" "A Converged Objective proposal contains:" 1 "proposal definition appears exactly once"
require_text "$SOURCE" "Objective title;" "proposal title field"
require_text "$SOURCE" "Objective statement;" "proposal statement field"
require_text "$SOURCE" "proposed Success Measures;" "proposal Success Measure field"
require_text "$SOURCE" "synthesized Rationale." "proposal Rationale field"
require_text "$SOURCE" "Objective development should normally begin from a proposal rather than a question" "proposal-first discovery guidance"
require_text "$SOURCE" "Conversational discovery remains available but is the exception path" "discovery exception guidance"
require_text "$SOURCE" "accepted evidence cannot support reasonable Success Measures" "missing measure evidence exception"
require_text "$SOURCE" "consequential ambiguity remains unresolved" "ambiguity exception"
require_text "$SOURCE" "When accepted evidence reasonably supports likely Success Measures, propose them" "default measure proposal"
require_text "$SOURCE" "approve them" "measure approval path"
require_text "$SOURCE" "modify them" "measure modification path"
require_text "$SOURCE" "replace them" "measure replacement path"
require_text "$SOURCE" "remove them" "measure removal path"
require_text "$SOURCE" "Selection does not capture an Objective" "selection capture boundary"
require_text "$SOURCE" "active Objective queue" "active queue boundary"
require_text "$SOURCE" "Queue membership determines development order only" "queue ordering boundary"
require_text "$SOURCE" "Queue membership is not Objective capture" "queue non-capture boundary"
require_text "$SOURCE" "The owner MUST NOT transition directly from recommendation selection to Objective capture" "direct capture prohibition"
require_text "$SOURCE" "the Converged Objective proposal defined in the Objective Development Lifecycle" "queue references lifecycle"
require_text "$SOURCE" "User:" "queue example user prompt"
require_text "$SOURCE" "Capture all four" "queue example multiple selection"
require_text "$SOURCE" "processed one item at a time until it is exhausted" "queue example sequential processing"
require_text "$SOURCE" "the Converged Objective proposal defined in the Objective Development Lifecycle" "queue capture-boundary reference"
require_absent "$SOURCE" "The Converged Objective proposal is presented once" "queue does not redefine presentation rule"
require_absent "$SOURCE" "preliminary Objective" "queue does not define preliminary proposal"
require_absent "$SOURCE" "second complete Objective" "queue does not define second proposal anti-pattern"
require_text "$SOURCE" "Recommendations remain Working Ideas until accepted" "advisory acceptance boundary"
require_text "$SOURCE" "atomic persistence" "existing persistence contract retained"
require_text "$SOURCE" "Repository Context Participating Skill" "existing context contract retained"
require_absent "$SOURCE" "Selection captures an Objective" "selection does not claim capture"
require_absent "$SOURCE" "One review" "review is not lifecycle event"
require_absent "$SOURCE" "Only after review may the Objective be captured" "review is not capture boundary"
require_absent "$SOURCE" "The owner MUST first create a Converged Objective proposal containing:" "proposal fields are not duplicated"

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
echo "OK: Feature 161 Objective synthesis lifecycle contract passes"
