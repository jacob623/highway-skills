#!/usr/bin/env bash
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
fail=0

for token in \
	'**Converged Proposal**: A complete candidate from the owning workflow whose substantive Working Idea' \
	'| X2.13 |' \
	'| X2.41 |' \
	'## Interaction Model' \
	'## Contribution Opportunity' \
	'## Interaction Boundaries' \
	'Working Idea material' \
	'Working Idea development until the substantive shape settles'; do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Experience Standard missing $token"; fail=1; }
done

if [[ "$(grep -cE '^\| X[0-9]+\.[0-9]+ \|' "$STANDARD")" -ne 45 ]]; then
	echo 'FAIL: Experience Standard rule inventory must contain 45 rules'
	fail=1
fi

for forbidden in 'CLAR identifiers' 'persisted clarification history' '## Candidates'; do
	if grep -Fq "$forbidden" "$STANDARD"; then
		echo "FAIL: Experience Standard contains forbidden $forbidden"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Experience convergence contract passes'
