#!/usr/bin/env bash
# Verifies Profile-specific re-evaluation and Identity ownership boundaries.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
fail=0
# Superseded behavior: 'provisional', 'materially assembles', and 'facets provisionally' asserted the
# permissive Identity hook that let Profile decide when to show facets before synthesis. Feature 150
# deletes it; Experience Standard X2.37 and X2.41 now owe the opportunity on a factual trigger.
for text in \
	'version: 11.0.0' \
	'Evaluate each source across all unresolved Profile domains' \
	'New substantive organizational evidence is evaluated across every unresolved Profile domain' \
	'Identity establishes who the organization is' \
	'durable' \
	'not a technology-landscape inventory' \
	'full accepted'; do
	if ! grep -Fq -- "$text" "$PROFILE"; then echo "FAIL: Profile skill missing '$text'"; fail=1; fi
done
for forbidden in 'Identity facet fields' 'clarification state' 'reasoning state' '## Enrichment'; do
	if grep -Fq -- "$forbidden" "$PROFILE"; then echo "FAIL: Profile skill contains forbidden '$forbidden'"; fail=1; fi
done
for generated in .agents/skills/highway-profile/SKILL.md .claude/skills/highway-profile/SKILL.md .github/skills/highway-profile/SKILL.md .cursor/skills/highway-profile/SKILL.md; do
	if [[ ! -f "$REPO_ROOT/$generated" ]] || ! cmp -s "$PROFILE" "$REPO_ROOT/$generated"; then echo "FAIL: generated adapter stale: $generated"; fail=1; fi
done
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 136 Profile substantive re-evaluation contract passes'
