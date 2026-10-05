#!/usr/bin/env bash
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
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
		echo "FAIL: Experience Standard contains forbidden $token"
		fail=1
	fi
}

for token in \
	'Version change: 8.3.0 → 8.4.0 (MINOR)' \
	'**Version**: 8.4.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-05' \
	'**Converged Proposal**: A complete candidate artifact or artifact set whose substantive Working Idea' \
	'| X2.13 | An Interactive Workflow MUST contribute a grounded Converged Proposal or useful Working Idea before asking when available relevant context supports either.' \
	'| X2.41 | An Interactive Workflow MUST NOT present a complete candidate as a Converged Proposal when the Working Idea is still changing through useful substantive development.' \
	'Before convergence, Highway should consider whether the person has had an opportunity to add something' \
	'When the person adds, corrects, removes, or extends content during the Contribution Opportunity' \
	'After a Substantive Contribution, Highway re-evaluates' \
	'When the person selects, combines, or reacts positively to Working Idea recommendations' \
	'| Working Idea versus Converged Proposal |' \
	'| Contribution Opportunity before convergence |' \
	'| Mature contribution |'; do
	require_text "$token"
done

if [[ "$(grep -c '^| X[0-9]' "$STANDARD")" -ne 45 ]]; then
	echo 'FAIL: Experience Standard rule inventory must contain 45 rules'
	fail=1
fi

for protected in \
	.highway/governance/constitution.md; do
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q .; then
		echo "FAIL: protected path changed: $protected"
		fail=1
	fi
done

require_absent 'CLAR identifiers'
require_absent 'persisted clarification history'

if [[ $fail -ne 0 ]]; then
	exit 1
fi
echo 'OK: Experience convergence contract passes'