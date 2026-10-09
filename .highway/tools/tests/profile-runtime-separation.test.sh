#!/usr/bin/env bash
# Verifies Feature 143 Profile runtime separation.
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
		echo "FAIL: Profile skill contains removed runtime guidance '$text'"
		fail=1
	fi
}

for required in \
	'version: 11.1.0' \
	'#### Domain model' \
	'#### Domain completeness' \
	'##### Organizational expression' \
	'##### Identity' \
	'##### Vision' \
	'##### Competitive Path' \
	'##### Guiding Principles' \
	'#### Cross-domain reasoning' \
	'Profile determines domain completeness.' \
	'The Highway Experience Standard determines whether collaborative development has converged enough' \
	'Canonical questions are Profile-owned fallbacks for unresolved organizational information.' \
	'Acceptance authorizes the mutation but is not successful persistence.' \
	'Operations remain setup, configure, readiness, view, show, describe, add, update, remove, and reset.' \
	'An absent Profile is a valid initial state.' \
	'structurally invalid retained Profile is `Blocked` with Next Action' \
	'Optional Context and optional enrichment do not change readiness.' \
	'Expression guides representation, not truth' \
	'Competitive Path describes the broad organizational approach' \
	'Guiding Principles describe the enduring principles' \
	'Highway Identity is shared, non-normative context only.'; do
	require_text "$required"
done

for forbidden in \
	'schema 2.0.0' \
	'obsolete YAML' \
	'legacy Profile' \
	'When the owning workflow can present a complete candidate' \
	'shared Conversational Presence guidance' \
	'contribution precedence' \
	'From what I\x27ve found, a few parts of the organization stand out:' \
	'A few principles are taking shape:' \
	'X2.41' \
	'highway-vision.md' \
	'highway-platform-objectives.md' \
	"the Constitution's common failure model" \
	'#### Semantic convergence decision'; do
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
	.highway/library/knowledge/highway-identity.md; do
	if git -C "$REPO_ROOT" diff --name-only -- "$protected" | grep -q .; then
		echo "FAIL: protected Profile runtime artifact changed: $protected"
		fail=1
	fi
done

if [[ "$fail" -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 143 Profile runtime separation contract passes'
