#!/usr/bin/env bash
# Verifies Profile keeps contribution ownership with the shared runtime.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
fail=0
for text in \
	'The Highway Experience Standard determines whether collaborative development has converged enough' \
	'Profile determines domain completeness' \
	'Profile-specific validation questions apply to the domain' \
	'Profile uses transient Conversational Clarification through the Highway Experience Standard' \
	'transient'; do
	if ! grep -Fq -- "$text" "$PROFILE"; then echo "FAIL: Profile skill missing '$text'"; fail=1; fi
done
if grep -Fq -- 'Contribution Opportunity authorizes acceptance' "$PROFILE"; then echo 'FAIL: Contribution Opportunity is coupled to acceptance'; fail=1; fi
if grep -Fq -- '## Enrichment' "$PROFILE"; then echo 'FAIL: superseded Enrichment section remains'; fail=1; fi
for generated in .agents/skills/highway-profile/SKILL.md .claude/skills/highway-profile/SKILL.md .github/skills/highway-profile/SKILL.md .cursor/skills/highway-profile/SKILL.md; do
	if [[ ! -f "$REPO_ROOT/$generated" ]] || ! cmp -s "$PROFILE" "$REPO_ROOT/$generated"; then echo "FAIL: generated adapter stale: $generated"; fail=1; fi
done
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 134 Profile Contribution Opportunity contract passes'
