#!/usr/bin/env bash
# Verifies Feature 174 review-oriented recommendation exploration contracts.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: removing any owner review boundary or retaining a prohibited queue command fails.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fail=0

require_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

for owner in objectives controls nfrs; do
	case "$owner" in
		objectives) artifact="Objectives"; skill="$HIGHWAY_ROOT/skills/highway-objectives/SKILL.md" ;;
		controls) artifact="Controls"; skill="$HIGHWAY_ROOT/skills/highway-controls/SKILL.md" ;;
		nfrs) artifact="NFRs"; skill="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md" ;;
	esac

	require_text "$skill" "## Recommendation Exploration"
	require_text "$skill" "Review of selected $artifact begins only when:"
	require_text "$skill" "recommendation exhaustion occurs"
	require_text "$skill" "explicitly requests review"
	require_text "$skill" "Recommendation selection alone does not begin review."
	require_text "$skill" "Recommendation exploration remains active"
	require_text "$skill" "Development Lifecycle"
	require_text "$skill" "Creation Workflow"

	for prohibited in "Process the queue." "Capture the queue."; do
		if grep -Fq "$prohibited" "$skill"; then
			echo "FAIL: user-facing queue command '$prohibited' remains in $skill"
			fail=1
		fi
	done

done

for skill in \
	"$HIGHWAY_ROOT/skills/highway-objectives/SKILL.md" \
	"$HIGHWAY_ROOT/skills/highway-controls/SKILL.md" \
	"$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"; do
	if grep -Fq "1. Queue Processing" "$skill" || grep -Fq "4. Queue Processing" "$skill"; then
		echo "FAIL: detailed queue-processing sequence remains in $skill"
		fail=1
	fi
done

if (( fail > 0 )); then
	exit 1
fi

echo "PASS: Feature 174 review-oriented recommendation exploration contracts"
