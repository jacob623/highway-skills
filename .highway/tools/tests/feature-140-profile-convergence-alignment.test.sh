#!/usr/bin/env bash
# Verifies Feature 140 Profile convergence alignment.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
fail=0

require_text() {
	local text="$1"
	if ! grep -Fq -- "$text" "$PROFILE"; then
		echo "FAIL: Profile skill missing '$text'"
		fail=1
	fi
}

require_absent() {
	local text="$1"
	if grep -Fq -- "$text" "$PROFILE"; then
		echo "FAIL: Profile skill contains forbidden generic duplication '$text'"
		fail=1
	fi
}

for required in \
	'version: 7.1.0' \
	'Domain completeness and conversational convergence remain distinct' \
	'contextual re-evaluation' \
	'present a Converged Proposal when the domain candidate is complete and its Working Idea has converged under the Highway Experience Standard' \
	'active Working Idea context support neither a Converged Proposal nor a useful Profile contribution' \
	'Domain completeness means Profile can construct a valid candidate; it does not by itself establish conversational convergence' \
	'Profile may surface a useful domain connection conversationally before representing it as a provisional facet, theme, strategic direction, principle, or final narrative' \
	'Provisional facets, themes, strategic pieces, and principle lists are representations of developed Working Idea substance' \
	'Use them only after the applicable domain candidate is complete and conversationally converged' \
	'When the Identity candidate is complete and the Working Idea has converged under the shared Experience Standard' \
	'After the Vision candidate is complete and the Working Idea has converged under the shared Experience Standard' \
	'After the Competitive Path candidate is complete and the Working Idea has converged under the shared Experience Standard' \
	'After the Guiding Principles candidate is complete and the Working Idea has converged under the shared Experience Standard' \
	'A substantive response to the Identity Contribution Opportunity may reopen Identity development' \
	'When a new Vision contribution changes how Profile understands the desired future' \
	'Profile may raise a plausible future connection' \
	'Profile may surface and discuss that connection as a Competitive Path Working Idea' \
	'Implementation mechanisms remain with their downstream owners' \
	'possible principle becomes visible' \
	'Re-evaluate what the response changes or reveals' \
	'Domain completeness does not by itself cause a Profile Working Idea to become a Converged Proposal.' \
	'A substantive response to a Contribution Opportunity may return the domain to collaborative development.' \
	'Profile does not manufacture additional turns merely because more detail could theoretically be collected.' \
	'Canonical questions remain the fallback' \
	'four readiness domains' \
	'Proposal evidence stays transient until accepted.'; do
	require_text "$required"
done

for forbidden in \
	'complete person-Highway recursive loop' \
	'X2.41' \
	'Profile does not require fixed recommendation sentence templates.'; do
	require_absent "$forbidden"
done

for generated in \
	.agents/skills/highway-profile/SKILL.md \
	.claude/skills/highway-profile/SKILL.md \
	.github/skills/highway-profile/SKILL.md \
	.cursor/skills/highway-profile/SKILL.md; do
	if [[ ! -f "$REPO_ROOT/$generated" ]] || ! cmp -s "$PROFILE" "$REPO_ROOT/$generated"; then
		echo "FAIL: generated Profile adapter is stale: $generated"
		fail=1
	fi
done

for protected in \
	.highway/library/templates/output/profile-record.md \
	.highway/governance/constitution.md \
	.highway/governance/experience-standard.md \
	.highway/library/knowledge/highway-identity.md \
	.highway/skills/highway-setup/SKILL.md \
	.highway/skills/highway-objectives/SKILL.md \
	.highway/skills/highway-controls/SKILL.md \
	.highway/skills/highway-nfrs/SKILL.md; do
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q .; then
		echo "FAIL: protected path changed: $protected"
		fail=1
	fi
done

if [[ "$fail" -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 140 Profile convergence alignment contract passes'
