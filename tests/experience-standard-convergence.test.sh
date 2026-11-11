#!/usr/bin/env bash
# Verifies the Experience Standard's current shape: its sections, rules, examples, and its
# independence from development governance. Each Experience Standard check lives here once.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
STANDARD="$(hw_doc experience-standard)"
fail=0

require_text() {
	if ! grep -Fq "$1" "$STANDARD"; then
		echo "FAIL: Experience Standard missing $1"
		fail=1
	fi
}

for rule in X1.6 X2.1 X2.3 X2.4 X2.5 X2.6 X2.7 X2.9 X2.10 X2.11 X2.12 X2.13 X2.15 X2.16 X2.17 X2.18 X2.19 X2.20 X2.21 X2.22 X2.24 X2.29 X2.30 X2.31 X2.32 X2.34 X2.35 X2.36 X2.37 X2.38 X2.41 X5.1 X5.2; do
	require_text "| $rule |"
done

for token in \
	'## Interaction Model' \
	'## Conversational Clarification' \
	'## Contribution Opportunity' \
	'## Constructive Advisory' \
	'## Recommendation Sets' \
	'## Interaction Boundaries' \
	'### X5 - Addressability of Emitted Messages' \
	'The standard is an adaptive loop, not a fixed number of turns' \
	'Domain completeness alone is not' \
	'owner perform its declared acceptance and persistence behavior' \
	'**Converged Proposal**: A complete candidate whose relevant substance is developed enough' \
	'Working Idea material' \
	'grounded reasoning materially improves it' \
	'acceptance boundary as approval of the representation'; do
	require_text "$token"
done

if [[ "$(grep -cE '^\| X[0-9]+\.[0-9]+ \|' "$STANDARD")" -ne 64 ]]; then
	echo 'FAIL: Experience Standard rule inventory must contain 64 rules'
	fail=1
fi

if [[ "$(grep -cE '^\| [^|]+ \|' "$STANDARD")" -lt 33 ]]; then
	echo 'FAIL: Experience Standard must retain rule tables'
	fail=1
fi

x5_line="$(grep -n '^### X5 - Addressability of Emitted Messages$' "$STANDARD" | cut -d: -f1)"
interaction_model_line="$(grep -n '^## Interaction Model$' "$STANDARD" | cut -d: -f1)"
if [[ -z "$x5_line" || -z "$interaction_model_line" || "$x5_line" -ge "$interaction_model_line" ]]; then
	echo 'FAIL: X5 must appear once before the Interaction Model'
	fail=1
fi

if [[ "$(grep -c '^| Scenario | Non-compliant | Compliant |' "$STANDARD")" -ne 1 ]]; then
	echo 'FAIL: Experience Standard must retain exactly one interaction boundary example table'
	fail=1
fi

example_rows="$(awk 'BEGIN { in_table=0; count=0 } index($0, "| Scenario | Non-compliant | Compliant |") == 1 { in_table=1; next } in_table && index($0, "|---|") == 1 { next } in_table && index($0, "|") == 1 { count++ } in_table && index($0, "|") != 1 { if (count > 0) print count; in_table=0 } END { if (in_table) print count }' "$STANDARD" | tail -1)"
if [[ "$example_rows" -ne 5 ]]; then
	echo "FAIL: expected exactly five interaction boundary examples, found $example_rows"
	fail=1
fi

for token in 'Highway Skills Constitution' 'P namespace' '## Tier Definitions' '[auto]' '[agent-checkable]' '[human-review]' '## Versioning Policy' '## Self-Application'; do
	if grep -qF "$token" "$STANDARD"; then
		echo "FAIL: Experience Standard retains development-governance dependency $token"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Experience Standard contract passes'
