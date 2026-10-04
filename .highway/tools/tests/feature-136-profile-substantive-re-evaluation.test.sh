#!/usr/bin/env bash
# Verifies Feature 136 Profile substantive re-evaluation and fuller Identity behavior.
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
		echo "FAIL: Profile skill contains forbidden '$text'"
		fail=1
	fi
}

# Superseded behavior: version 5.3.0 and Identity assembly that omitted imported organizational material.
for required in \
	'version: 6.0.0' \
	'Apply X2.38-X2.40 to each Substantive Contribution' \
	'Each Substantive Contribution becomes new reasoning material' \
	'first re-evaluate what it changes, clarifies, introduces, qualifies, connects, or leaves unresolved' \
	'consequential uncertainty can change the active result' \
	'without a ceremonial question' \
	'Process each response, selected recommendation, or validated discovery across all four domains before choosing the next behavior' \
	'After each Substantive Contribution, re-evaluate the active understanding' \
	'Identity establishes the meaningful organizational picture' \
	'provisional substantive facets' \
	'materially assembles Identity from website discovery, imported organizational material, multiple evidence sources, or substantial interpretation' \
	'domain-complete organizational description that Profile does not materially reshape' \
	'durable organizational activity and purpose' \
	'Do not use Identity completeness to inventory platforms' \
	'Identity Contribution Opportunity and Identity Conversational Clarification serve different purposes' \
	'evaluates the full accepted Identity and other relevant accepted Profile evidence' \
	'how those parts affect the future being created' \
	'how those accepted pieces reinforce, sequence, constrain, or depend on one another' \
	'treat each Substantive Contribution as new reasoning material and apply X2.38-X2.40' \
	'When a response both accepts a displayed Converged Proposal and supplies new substantive information' \
	'The newly supplied information does not silently rewrite the already accepted domain' \
	'A Conversational Clarification is the one unresolved response-demanding question for that turn' \
	'Do not treat every clarification response as satisfying Profile' \
	'New substantive evidence is evaluated for relevance across all unresolved Profile domains' \
	'Identity provisional facets remain Working Idea content' \
	'Profile does not create a clarification record or invoke highway-clarify' \
	'schema_version: 3.0.0'; do
	require_text "$required"
done

for forbidden in \
	'Identity facet fields' \
	'clarification state' \
	'reasoning state'; do
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
	.highway/governance/experience-standard.md \
	.highway/library/templates/output/profile-record.md \
	.highway/skills/highway-setup/SKILL.md \
	.highway/skills/highway-clarify/SKILL.md \
	.highway/governance/constitution.md; do
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q .; then
		echo "FAIL: protected path changed: $protected"
		fail=1
	fi
done

if [[ "$fail" -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 136 Profile substantive re-evaluation contract passes'
