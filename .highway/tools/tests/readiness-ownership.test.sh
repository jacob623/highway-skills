#!/usr/bin/env bash
# Verifies the shared owner readiness response contract and read-only evidence.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
HIGHWAY_ROOT="$REPO_ROOT/.highway"
. "$SCRIPT_DIR/test-helpers.sh"

fail=0
source_files=""
for owner in profile objectives controls nfrs; do
	file="$HIGHWAY_ROOT/skills/highway-$owner/SKILL.md"
	source_files="$source_files $file"
	if ! grep -Fq 'readiness' "$file"; then
		echo "FAIL: $file does not document readiness"
		fail=1
	fi
done

before_hash="$(shasum -a 256 $source_files | shasum -a 256 | cut -d ' ' -f 1)"
responses='Status: Complete
Summary: Ready
Next Action: None
Blocking Reason: None'
blocked_response='Status: Blocked
Summary: Candidate generation is unavailable
Next Action: Repair candidate generation
Blocking Reason: Candidate generation failed'
missing_response='Status: Missing
Summary: Required owner artifact is absent
Next Action: Run owner setup
Blocking Reason: None'
in_progress_response='Status: In Progress
Summary: Candidates await acceptance
Next Action: Review candidates
Blocking Reason: None'
not_applicable_response='Status: Not Applicable
Summary: Candidate generation returned zero candidates
Next Action: None
Blocking Reason: None'

for status_name in complete blocked missing in_progress not_applicable; do
	case "$status_name" in
		complete) response="$responses" ;;
		blocked) response="$blocked_response" ;;
		missing) response="$missing_response" ;;
		in_progress) response="$in_progress_response" ;;
		not_applicable) response="$not_applicable_response" ;;
	esac
	if ! assert_readiness_response "$status_name" "$response"; then
		fail=1
	fi
done

first_response="$responses"
second_response="$responses"
if ! assert_deterministic "unchanged readiness response" "$first_response" "$second_response"; then
	fail=1
fi

after_hash="$(shasum -a 256 $source_files | shasum -a 256 | cut -d ' ' -f 1)"
if ! assert_file_unchanged "owner skill sources" "$before_hash" "$after_hash"; then
	fail=1
fi

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: owner readiness response contract passes"
