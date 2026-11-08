#!/usr/bin/env bash
# Every accepted Control keeps being offered an NFR, and a Control-derived rationale names the safeguard it enforces.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "no queued, shown, or captured NFR reflects yet" or "Each recommendation is a bold title and one sentence." fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
NFRS="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
fail=0

require() {
	grep -Fq -- "$1" "$NFRS" || {
		echo "FAIL: highway-nfrs omits: $1"
		fail=1
	}
}

reject() {
	if grep -Fq -- "$1" "$NFRS"; then
		echo "FAIL: highway-nfrs still contains: $1"
		fail=1
	fi
}

require 'version: 9.1.0'

require '1. Derive each recommendation from an accepted Control that no queued or captured NFR reflects yet. A shown recommendation the person did not select does not reflect its Control.'
require '5. Omit a title already queued or already captured. Omit a title already shown, unless it reflects an accepted Control that no queued or captured NFR reflects.'
require 'Omit every title in the set just shown.'

require 'Each recommendation is a bold title, one sentence, and an indented **Why it matters:** line.'
require 'In the set, **No system hosting** and **Direct purchase** each show their title, statement, and **Why it matters:** line.'
require 'An NFR that reflects one accepted Control has this rationale: **Enforces your Safeguard, [Control title],** by [how the expectation keeps that Control true].'
require 'An NFR that reflects more than one accepted Control has this rationale: **Enforces your Safeguards, [Control titles],** by [how the expectation keeps those Controls true].'
require 'Name two Controls as `[A] and [B]`. Name three or more as `[A], [B], and [C]`.'
require 'Use each accepted Control title as written. Any other rationale is one line grounded in the accepted Profile and accepted Objectives.'

count="$(grep -Fc -- '   **Why it matters:** [Rationale]' "$NFRS")"
if [[ "$count" -lt 4 ]]; then
	echo "FAIL: highway-nfrs shows **Why it matters:** in $count templates, expected at least 4"
	fail=1
fi

require 'The rationale is the **Why it matters:** line shown with that recommendation. Write the rationale of the person'"'"'s own expectation with the `recommend` rationale rule. Keep a rationale the person edits as written.'
require 'An added expectation becomes a new record. Write its rationale with the `recommend` rationale rule.'
require '`controls` lists the accepted Control ids that influenced this expectation, including every Control its rationale names.'

require '- Each recommendation shows its title, one sentence, and a **Why it matters:** line.'
require '- An NFR that reflects accepted Controls has a rationale that opens with **Enforces your Safeguard, [Control title],** or **Enforces your Safeguards, [Control titles],** and continues with "by".'
require '- A shown recommendation the person did not select does not reflect its Control. A later set offers that Control again.'
require '- A rationale the person edits is kept as written.'

reject 'no queued, shown, or captured NFR reflects yet'
reject '5. Omit a title already queued, already shown, or already captured.'
reject 'Each recommendation is a bold title and one sentence.'
reject 'each show their title and statement.'
reject 'The rationale is one line grounded in the accepted Profile, accepted Objectives, and accepted Controls.'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: every safeguard gets an operational expectation that names it'
