#!/usr/bin/env bash
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONSTITUTION="$HIGHWAY_ROOT/governance/constitution.md"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
fail=0

require_text() {
	local token="$1"
	if ! grep -Fq "$token" "$CONSTITUTION"; then
		echo "FAIL: Constitution missing $token"
		fail=1
	fi
}

require_absent() {
	local token="$1"
	if grep -Fq "$token" "$CONSTITUTION"; then
		echo "FAIL: Constitution retains removed collaborative-interaction material $token"
		fail=1
	fi
}

require_text '| **Working Idea** | Transient developing material within Active Reasoning Context that is not authoritative user-owned knowledge. Its user-visible development and interaction semantics are governed by the Experience Standard. |'
require_text '| **Converged Proposal** | A complete candidate artifact or artifact set whose Working Idea has satisfied the applicable convergence requirements in the Experience Standard and can be presented at the artifact acceptance boundary. |'
require_text '| **Accepted User-Owned Artifact** | A candidate accepted through its owning workflow and persisted through the owner'"'"'s declared mutation path. |'
require_text 'Highway may develop non-authoritative Working Ideas before accepted repository knowledge is created.'
require_text 'The Experience Standard governs visible collaborative development'
require_text '| P12A.1 | A skill MUST treat Active Reasoning Context as transient until the applicable acceptance boundary is satisfied. | Unaccepted Working Ideas, interpretations, alternatives, implications, and recommendations are not accepted repository knowledge. | [agent-checkable] |'
require_text '| P12A.2 | A skill MUST distinguish a Working Idea from a Converged Proposal. | A Converged Proposal requires a complete owner candidate and satisfaction of the applicable Experience Standard convergence requirements. | [agent-checkable] |'
require_text '| P12A.3 | A skill MUST preserve relevant Active Reasoning Context until the active task resolves or the interaction ends. | Active Working Ideas influencing the current task remain available to later reasoning within that interaction. | [agent-checkable] |'
require_text '| P12A.4 | A skill MUST re-evaluate relevant context after accepted knowledge changes the active task. | Subsequent behavior uses the accepted knowledge together with other relevant declared context. | [agent-checkable] |'
require_text 'The Constitution governs the authority boundary between transient'
require_text 'The Experience Standard determines when collaborative development has converged enough'
require_text "Crossing the applicable acceptance boundary authorizes the owner'"
require_text '**Version**: 7.0.0 | **Ratified**: 2026-09-06 | **Last Amended**: 2026-10-06'
require_text 'P1.1-P1.4, P6.4, P6.6, and P7.3'
require_text 'P12A.1–P12A.4 remain individually addressable'

for token in \
	'When the owning workflow can present a complete candidate' \
	'it is a Converged Proposal' \
	'interpretation, refinement, alternatives, implications, tradeoffs, questions, relationships, and recommendations' \
	'Contributions and recommendations become Working Ideas within Active Reasoning Context while they are interpreted' \
	'Contribution Opportunity' \
	'Conversational Clarification' \
	'Substantive Contribution'; do
	require_absent "$token"
done

if [[ "$(grep -cE '^\| P[0-9]+[A-Z]?\.[0-9]+ ' "$CONSTITUTION")" -ne 77 ]]; then
	echo 'FAIL: Constitution rule inventory changed unexpectedly'
	fail=1
fi

if [[ "$(grep -cE '^\| X[0-9]+\.[0-9]+ \|' "$STANDARD")" -ne 45 ]]; then
	echo 'FAIL: Experience Standard rule inventory is not 45'
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'OK: Constitution and Experience Standard alignment contract passes'
