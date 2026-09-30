#!/usr/bin/env bash
# Verifies owner readiness shape, terminality, delegation, and stop behavior.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, disposable-fixture
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
FIXTURES="$SCRIPT_DIR/fixtures/profile-092"
fail=0
require() { grep -Fq -- "$2" "$1" || { echo "FAIL: $1 missing '$2'"; fail=1; }; }
for file in "$FIXTURES/readiness/profile/absent.txt" "$FIXTURES/readiness/profile/incomplete.txt" "$FIXTURES/readiness/profile/complete.txt" "$FIXTURES/readiness/profile/blocked.txt"; do
	[[ "$(wc -l < "$file" | tr -d ' ')" -eq 4 ]] || { echo "FAIL: readiness response is not four fields: $file"; fail=1; }
done
require "$FIXTURES/readiness/setup/owner-loop.txt" 'status-only: report owner result without delegation'
require "$FIXTURES/readiness/setup/owner-loop.txt" 'stop: blocked unknown declined aborted failed'
require "$FIXTURES/readiness/setup/owner-loop.txt" 'nfr: In Progress is non-terminal'
for token in 'Profile readiness' 'Objectives readiness' 'Controls readiness' 'NFR readiness' 'never restore an unanswered question' 'does not author a Controls discovery question'; do
	require "$HIGHWAY_ROOT/skills/highway-setup/SKILL.md" "$token"
done
for token in 'Controls-purpose transition' 'Controls Action Result' 'Collection Result: Continue|Finished' 'fresh Controls readiness' 'pre-delegation `Complete`'; do
	require "$HIGHWAY_ROOT/skills/highway-setup/SKILL.md" "$token"
done
action_line="$(grep -n 'Controls Action Result' "$HIGHWAY_ROOT/skills/highway-setup/SKILL.md" | head -n 1 | cut -d: -f1)"
fresh_line="$(grep -n 'fresh Controls readiness' "$HIGHWAY_ROOT/skills/highway-setup/SKILL.md" | head -n 1 | cut -d: -f1)"
if [[ -z "$action_line" || -z "$fresh_line" || "$action_line" -ge "$fresh_line" ]]; then
	echo 'FAIL: Setup does not consume Controls action result before fresh readiness'
	fail=1
fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Setup owner-loop contract passes'
