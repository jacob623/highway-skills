#!/usr/bin/env bash
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
fail=0

for token in \
	'**Converged Proposal**: A complete candidate whose relevant substance is developed enough' \
	'| X2.4 |' \
	'| X2.13 |' \
	'| X2.37 |' \
	'| X2.38 |' \
	'| X2.41 |' \
	'## Interaction Model' \
	'## Contribution Opportunity' \
	'## Interaction Boundaries' \
	'Working Idea material' \
	'grounded reasoning materially improves it' \
	'acceptance boundary as approval of the representation'; do
	grep -Fq "$token" "$STANDARD" || { echo "FAIL: Experience Standard missing $token"; fail=1; }
done

# Superseded behavior: 33 rules, before Feature 150 added X2.42-X2.57.
if [[ "$(grep -cE '^\| X[0-9]+\.[0-9]+ \|' "$STANDARD")" -ne 59 ]]; then
	echo 'FAIL: Experience Standard rule inventory must contain 49 rules'
	fail=1
fi

for retired in X2.8 X2.14 X2.39 X2.40; do
	if grep -qF "| $retired |" "$STANDARD"; then
		echo "FAIL: retired rule remains active: $retired"
		fail=1
	fi
done

for forbidden in 'CLAR identifiers' 'persisted clarification history' '## Candidates'; do
	if grep -Fq "$forbidden" "$STANDARD"; then
		echo "FAIL: Experience Standard contains forbidden $forbidden"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Experience convergence contract passes'
