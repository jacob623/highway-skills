#!/usr/bin/env bash
# Verifies Feature 158 source-document delivery sites; it does not prove runtime conversation behavior.
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
require_order() {
	first_line="$(grep -nF -- "$2" "$1" | head -n 1 | cut -d: -f1)"
	second_line="$(grep -nF -- "$3" "$1" | head -n 1 | cut -d: -f1)"
	if [[ -z "$first_line" || -z "$second_line" || "$first_line" -ge "$second_line" ]]; then
		echo "FAIL: $4 has incorrect order"
		fail=1
	fi
}
require_absent() { if flow "$1" | grep -Fq -- "$3"; then echo "FAIL: $2 still contains: $3"; fail=1; fi; }
require_count() {
	actual="$(flow "$1" | grep -Fo -- "$3" | wc -l | tr -d ' ')"
	if [[ "$actual" -ne "$4" ]]; then
		echo "FAIL: $2 expected $4 occurrences of '$3' but found $actual"
		fail=1
	fi
}

# Interpretation confidence guidance and exact placement.
require_order "$PROFILE" '#### Structure-revealing contributions' '##### Interpretation confidence' 'Profile skill interpretation subsection placement'
require_order "$PROFILE" '##### Interpretation confidence' '##### Organizational expression' 'Profile skill interpretation subsection placement'
require_flowed "$PROFILE" 'Profile skill' 'Prefer a grounded interpretation that can be corrected over a missing interpretation that forces the person to create it from scratch.'
require_flowed "$PROFILE" 'Profile skill' 'When accepted evidence already supports a useful distinction, implication, connection, tension, structure, organizing principle, or Working Idea, do not ask a question that merely seeks permission to express the interpretation.'
require_count "$PROFILE" 'Profile skill' '##### Interpretation confidence' 1

# Verification additions.
require_flowed "$PROFILE" 'Profile skill' 'A useful grounded interpretation is preferred over an unnecessary exploratory question.'
require_flowed "$PROFILE" 'Profile skill' 'Consequential uncertainty is still clarified when accepted evidence or advisory reasoning cannot resolve it.'

# Existing Profile behavior and protected Experience Standard boundaries remain present.
require_flowed "$PROFILE" 'Profile skill' '#### Advisory question scaffolding'
require_flowed "$PROFILE" 'Profile skill' '#### Structure-revealing contributions'
require_flowed "$PROFILE" 'Profile skill' '#### Contribution in practice'
require_flowed "$PROFILE" 'Profile skill' '#### Possibility-list Contribution Opportunities'
require_flowed "$PROFILE" 'Profile skill' 'One worked counter-example.'
require_flowed "$PROFILE" 'Profile skill' 'We are a bakery.'
require_flowed "$STANDARD" 'Experience Standard' '| X2.4 |'
require_flowed "$STANDARD" 'Experience Standard' '| X2.13 |'
require_flowed "$STANDARD" 'Experience Standard' '| X2.42 |'
require_flowed "$STANDARD" 'Experience Standard' '| X2.65 |'
require_flowed "$STANDARD" 'Experience Standard' '| X2.68 |'
require_flowed "$STANDARD" 'Experience Standard' '| X2.69 |'

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
echo 'OK: Feature 158 interpretation confidence delivery sites pass'
