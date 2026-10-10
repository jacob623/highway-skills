#!/usr/bin/env bash
# Verifies Feature 156 source-document delivery sites; it does not prove runtime conversation behavior.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
fail=0

flow() { tr '\n' ' ' < "$1" | tr -s ' '; }
require_flowed() { flow "$1" | grep -Fq -- "$3" || { echo "FAIL: $2 missing: $3"; fail=1; }; }
require_absent() { if flow "$1" | grep -Fq -- "$3"; then echo "FAIL: $2 still contains: $3"; fail=1; fi; }
require_count() {
	actual="$(flow "$1" | grep -Fo -- "$3" | wc -l | tr -d ' ')"
	if [[ "$actual" -ne "$4" ]]; then
		echo "FAIL: $2 expected $4 occurrences of '$3' but found $actual"
		fail=1
	fi
}

# Structure preference and non-contribution boundaries.
require_flowed "$PROFILE" 'Profile skill' '#### Structure-revealing contributions'
require_flowed "$PROFILE" 'Profile skill' 'prefer contributions that reveal structure already present in accepted evidence'
require_flowed "$PROFILE" 'Profile skill' 'Structure is not a summary of accepted facts.'
require_flowed "$PROFILE" 'Profile skill' 'relationship, pattern, role, tension, or organizing principle'
require_flowed "$PROFILE" 'Profile skill' 'Do not treat restatement, reorganization, relabeling, paraphrase, or synonym replacement alone as a contribution.'
require_flowed "$PROFILE" 'Profile skill' 'Do not skip directly to an extension when useful structure is available.'

# Connected chain and anti-branching behavior.
require_flowed "$PROFILE" 'Profile skill' 'one connected linear chain of reasoning'
require_flowed "$PROFILE" 'Profile skill' 'Each step must derive directly from the immediately preceding step, remain traceable'
require_flowed "$PROFILE" 'Profile skill' 'structure, implication, possibility, or tradeoff'
require_flowed "$PROFILE" 'Profile skill' 'Diverging alternatives, recommendation sets, and opportunity catalogs are not permitted.'
require_flowed "$PROFILE" 'Profile skill' 'The addition must stop making sense when detached from the accepted evidence.'
require_flowed "$PROFILE" 'Profile skill' 'keep it as a Working Idea outside the candidate unless the person adopts it'

# Existing contracts and protected source boundaries.
require_flowed "$PROFILE" 'Profile skill' '#### Advisory question scaffolding'
require_flowed "$PROFILE" 'Profile skill' 'prefer them in this order: distinction, implication, connection, tension, tradeoff, possibility, recommendation'
require_flowed "$PROFILE" 'Profile skill' 'A contribution is not satisfied by renaming, relabeling, summarizing, or paraphrasing accepted evidence.'
require_flowed "$PROFILE" 'Profile skill' 'What the moment actually calls for is the question that opens the material up'
require_count "$PROFILE" 'Profile skill' '**What would you add, correct, or remove?**' 1
require_flowed "$STANDARD" 'Experience Standard' '| X2.69 | A contributed addition MUST NOT exceed one distinction or extension per Substantive Contribution. | One addition appears; a second, an enumerated set of offered options, or a recommendation set does not. |'

# Generated Profile adapters must match the source document exactly.
for generated in \
	"$REPO_ROOT/.github/skills/highway-profile/SKILL.md" \
	"$REPO_ROOT/.claude/skills/highway-profile/SKILL.md" \
	"$REPO_ROOT/.cursor/skills/highway-profile/SKILL.md" \
	"$REPO_ROOT/.agents/skills/highway-profile/SKILL.md"; do
	if [[ ! -f "$generated" ]] || ! cmp -s "$PROFILE" "$generated"; then
		echo "FAIL: generated Profile adapter differs from source: $generated"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 156 structure-revealing advisory delivery sites pass'
