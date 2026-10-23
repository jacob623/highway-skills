#!/usr/bin/env bash
# The new NFR review carries two operating limits, and Request copies them by title.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: a missing default limit or a changed Discovery skill fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
NFRS="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
REQUEST="$HIGHWAY_ROOT/skills/highway-request/SKILL.md"
DISCOVERY="$HIGHWAY_ROOT/skills/highway-discovery/SKILL.md"
fail=0

require() {
	local file="$1" text="$2"
	grep -Fq "$text" "$file" || {
		echo "FAIL: $(basename "$(dirname "$file")") omits: $text"
		fail=1
	}
}

require "$NFRS" '**No system hosting:** Solutions are delivered as managed services the organization does not host or operate.'
require "$NFRS" '**Direct purchase:** The owner buys the service directly from the vendor that operates it.'
require "$NFRS" 'Include **No system hosting** and **Direct purchase** in the first recommendation set.'
require "$NFRS" 'A limit the person does not select is not queued and does not apply.'

require "$REQUEST" 'When an active NFR is titled **No system hosting**'
require "$REQUEST" 'When an active NFR is titled **Direct purchase**'
require "$REQUEST" 'managed service'
require "$REQUEST" 'hosted system'
require "$REQUEST" 'procurement_constraints'
require "$REQUEST" 'vendor_restrictions'
require "$REQUEST" 'Do not recreate a removed or retitled limit from another NFR.'

if ! git -C "$REPO_ROOT" diff --exit-code -- .highway/skills/highway-discovery/SKILL.md >/dev/null; then
	echo "FAIL: Discovery changed during the operating-limit feature"
	fail=1
fi
if ! git -C "$REPO_ROOT" diff --cached --exit-code -- .highway/skills/highway-discovery/SKILL.md >/dev/null; then
	echo "FAIL: Discovery has staged changes during the operating-limit feature"
	fail=1
fi
# The path is used so a missing Discovery file fails the check above through git.
[[ -f "$DISCOVERY" ]] || { echo "FAIL: Discovery skill is missing"; fail=1; }

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: static operating NFRs"
