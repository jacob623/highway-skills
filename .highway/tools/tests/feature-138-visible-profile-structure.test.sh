#!/usr/bin/env bash
# Verifies Feature 138 visible Profile structure and highway-profile deduplication.
# Superseded behavior: profile-record.md was a valid retained Profile whose body contract lived in
# a hidden comment, and highway-profile 6.0.0 restated that structure and treated volunteered
# downstream detail as Competitive Path evidence (D3.5).
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
TEMPLATE="$HIGHWAY_ROOT/library/templates/output/profile-record.md"
EMPTY="$SCRIPT_DIR/fixtures/profile-092/profile-record/empty.md"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
VALIDATE="$HIGHWAY_ROOT/tools/validate-profile.sh"
fail=0

require_text() {
	local file="$1" text="$2"
	if ! grep -Fq -- "$text" "$file"; then
		echo "FAIL: $file missing '$text'"
		fail=1
	fi
}

require_absent() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $file contains forbidden '$text'"
		fail=1
	fi
}

require_text "$TEMPLATE" 'Complete output skeleton for retained organizational Profile evidence.'
require_text "$TEMPLATE" 'version: 3.1.0'
require_text "$TEMPLATE" '## File Frontmatter'
require_text "$TEMPLATE" '## Body'
require_text "$TEMPLATE" 'schema_version: 3.0.0'
require_text "$TEMPLATE" '## Who We Are'
require_text "$TEMPLATE" "## Where We're Going"
require_text "$TEMPLATE" '## How We Plan to Get There'
require_text "$TEMPLATE" '## What Guides Our Decisions'
require_text "$TEMPLATE" '### Repository Name'
require_text "$TEMPLATE" 'The domain headings above define the permitted retained narrative sections and their ordering. Render a domain heading only when its domain state permits narrative.'
require_text "$TEMPLATE" '## Context is optional and follows all rendered Profile-domain narratives. Omit ## Context when no Context child has accepted content.'
require_text "$TEMPLATE" 'Within ## Context, render only accepted children. Absent Context children are omitted.'
require_text "$TEMPLATE" 'Organizational Context contains only accepted durable organizational context permitted by the Profile owner contract; it does not broaden Profile ownership beyond that contract.'
require_text "$TEMPLATE" 'Template metadata describes profile-record.md and is not retained Profile content.'
require_text "$TEMPLATE" 'The retained artifact contains only its retained frontmatter, # Organizational Profile, permitted accepted domain narratives, and permitted accepted optional Context.'
require_absent "$TEMPLATE" 'discussed always renders evidence'
require_absent "$TEMPLATE" '### Where you'"'"'re going'
require_absent "$TEMPLATE" 'highway_role'

if "$VALIDATE" "$TEMPLATE" >/dev/null 2>&1; then
	echo 'FAIL: skeleton template was accepted as a retained Profile'
	fail=1
fi
if ! "$VALIDATE" "$EMPTY" >/dev/null 2>&1; then
	echo 'FAIL: retained empty Profile fixture was rejected'
	fail=1
fi

require_text "$PROFILE" 'version: 7.0.0'
require_text "$PROFILE" 'The retained artifact is `.highway/library/knowledge/profile.md`.'
require_text "$PROFILE" 'The retained Profile follows the complete structure in .highway/library/templates/output/profile-record.md. Profile owns the meaning, evidence, state, and readiness of Identity, Vision, Competitive Path, and Guiding Principles. Accepted evidence that establishes a domain sets it to `discussed`; an explicit user boundary may set an otherwise unresolved domain to `bounded`. Optional Context does not change readiness. Schema 2.0.0 is Blocked and left unchanged.'
require_text "$PROFILE" 'A Repository Name supplied directly in response to this request is accepted as supplied and does not require a separate proposal review.'
require_text "$PROFILE" 'A domain becomes bounded only when the person explicitly indicates that they do not want to establish further Profile evidence for that domain.'
require_text "$PROFILE" 'Profile uses the collaborative-development model defined by the Highway Experience Standard. Working Ideas, Substantive Contributions, Conversational Clarification, Contribution Opportunities, Converged Proposals, and their interaction boundaries follow that shared contract. Profile defines what constitutes a complete candidate for each Profile domain and the Profile-specific evidence, readiness, persistence, and downstream ownership boundaries below.'
require_text "$PROFILE" 'Website and imported-source acquisition are limited to evidence relevant to the organizational Profile.'
require_text "$PROFILE" 'Website-derived and imported organizational information remains proposed until the applicable Profile acceptance boundary is crossed.'
require_text "$PROFILE" 'Do not use tone, style, phrasing, terminology, or communication patterns as evidence that a substantive organizational claim is true.'
require_text "$PROFILE" 'When the person volunteers a safeguard, operational expectation, architecture detail, implementation detail, or other downstream-owned information while developing Competitive Path, re-evaluate what that information reveals about the organization'"'"'s broad approach. Incorporate only that broad strategic meaning into Competitive Path when it changes the path. Do not develop, refine, recommend, validate, or retain the downstream-owned detail itself as Profile evidence solely because it was volunteered. When the detail does not change the broad organizational approach, leave it outside Competitive Path.'
require_text "$PROFILE" 'After acceptance changes retained Profile state, perform the accepted Profile mutation before any behavior that depends on that accepted knowledge. Acceptance authorizes the mutation but is not successful persistence. Return dependent readiness, completion, or another owner result only after the mutation succeeds.'
require_text "$PROFILE" 'If the final Profile domain is accepted, persist that mutation before emitting the guided completion synthesis.'
require_text "$PROFILE" 'Volunteered downstream-owned information appears in Competitive Path only through the broad strategic meaning it establishes; Profile does not develop or retain the downstream-owned specification itself.'
require_text "$PROFILE" 'A volunteered safeguard, operational expectation, architecture detail, or implementation detail that does not change the broad organizational approach remains outside Competitive Path.'
require_absent "$PROFILE" 'Website acquisition is limited to evidence relevant to the organizational Profile.'
require_absent "$PROFILE" '<br>'
require_absent "$PROFILE" 'persist the retained Profile, and only then return dependent readiness'
require_absent "$PROFILE" '## Who We Are'
lines="$(wc -l < "$PROFILE" | tr -d ' ')"
if [[ "$lines" -ge 372 ]]; then
	echo "FAIL: highway-profile is not shorter than version 6.0.0 ($lines lines)"
	fail=1
fi

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

if [[ "$fail" -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 138 visible Profile structure contract passes'
