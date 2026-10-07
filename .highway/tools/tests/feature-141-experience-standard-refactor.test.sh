#!/usr/bin/env bash
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
fail=0

require_text() {
	local token="$1"
	if ! grep -Fq "$token" "$STANDARD"; then
		echo "FAIL: Experience Standard missing $token"
		fail=1
	fi
}

require_absent() {
	local token="$1"
	if grep -Fq "$token" "$STANDARD"; then
		echo "FAIL: Experience Standard contains removed runtime material $token"
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
	'**Version**: `9.1.0` | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-06'; do
	require_text "$token"
done

if [[ "$(grep -cE '^\| X[0-9]+\.[0-9]+ \|' "$STANDARD")" -ne 33 ]]; then
	echo 'FAIL: Experience Standard rule inventory must contain 33 rules'
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

for old_section in \
	'#### Collaborative Development (Non-Normative Guidance)' \
	'#### Contextual Re-evaluation (Non-Normative Guidance)' \
	'#### Conversational Voice (Non-Normative Guidance)' \
	'#### Conversational Presence (Non-Normative Guidance)' \
	'### Context Awareness (Non-Normative Guidance)' \
	'## Candidates'; do
	require_absent "$old_section"
done

if [[ "$(grep -c '^| Scenario | Non-compliant | Compliant |' "$STANDARD")" -ne 1 ]]; then
	echo 'FAIL: Experience Standard must retain exactly five interaction boundary examples'
	fail=1
fi

example_rows="$(awk 'BEGIN { in_table=0; count=0 } index($0, "| Scenario | Non-compliant | Compliant |") == 1 { in_table=1; next } in_table && index($0, "|---|") == 1 { next } in_table && index($0, "|") == 1 { count++ } in_table && index($0, "|") != 1 { if (count > 0) print count; in_table=0 } END { if (in_table) print count }' "$STANDARD" | tail -1)"
if [[ "$example_rows" -ne 5 ]]; then
	echo "FAIL: expected exactly five interaction boundary examples, found $example_rows"
	fail=1
fi

for forbidden in \
	'Historical amendment record' \
	'Version change: 8.1.0' \
	'Version change: 7.2.0' \
	'Version change: 8.0.0' \
	'Version change: 8.3.0' \
	'#### Conversational Voice (Non-Normative Guidance)' \
	'#### Conversational Presence (Non-Normative Guidance)'; do
	require_absent "$forbidden"
done

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'OK: Feature 141 Experience Standard refactor contract passes'
