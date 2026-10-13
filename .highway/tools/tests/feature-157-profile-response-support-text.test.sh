#!/usr/bin/env bash
# Verifies Feature 157 Profile response support text and source-generated correspondence.
# Evidence boundary: every assertion here is a static document contract. It does not prove runtime
# conversational behavior.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact
# Seeded failure probe: --probe <class> creates a missing contract; --neutralise makes it pass.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
fail=0

flow() { tr '\n' ' ' < "$1" | tr -s ' '; }
require_text() { grep -Fq -- "$3" "$1" || { echo "FAIL: $2 missing: $3"; fail=1; }; }
require_flowed() { flow "$1" | grep -Fq -- "$3" || { echo "FAIL: $2 missing: $3"; fail=1; }; }
require_absent() { if flow "$1" | grep -Fq -- "$3"; then echo "FAIL: $2 still contains: $3"; fail=1; fi; }
require_ordered() {
	ordered_text="$(flow "$1")"
	case "$ordered_text" in
		*"$3"*"$4"*) ;;
		*) echo "FAIL: $2 expected '$3' before '$4'"; fail=1 ;;
	esac
}
require_count() {
	actual="$(flow "$1" | grep -Fo -- "$3" | wc -l | tr -d ' ')"
	if [[ "$actual" -ne "$4" ]]; then
		echo "FAIL: $2 expected $4 occurrences of '$3' but found $actual"
		fail=1
	fi
}

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
if [[ -n "$probe_class" ]]; then
	probe_dir="$SCRIPT_DIR/fixtures/feature-157-probe-$$"
	mkdir -p "$probe_dir"
	trap 'rm -rf "$probe_dir"' EXIT
	case "$probe_class" in
		source-document)
			if [[ "$neutralise" -eq 0 ]]; then printf 'placeholder\n' >"$probe_dir/source.md"; else printf 'Response Support Text\n' >"$probe_dir/source.md"; fi
			grep -Fq 'Response Support Text' "$probe_dir/source.md" || exit 1
			;;
		generated-artifact)
			printf 'source content\n' >"$probe_dir/source.md"
			if [[ "$neutralise" -eq 0 ]]; then printf 'drifted content\n' >"$probe_dir/adapter.md"; else printf 'source content\n' >"$probe_dir/adapter.md"; fi
			cmp -s "$probe_dir/source.md" "$probe_dir/adapter.md" || exit 1
			;;
		*) echo "FAIL: undeclared artifact class: $probe_class" >&2; exit 2 ;;
	esac
fi

# US1: one owner and a stable candidate review rendering contract.
require_flowed "$PROFILE" 'Profile skill' '##### Response Support Text'
require_flowed "$PROFILE" 'Profile skill' '###### Validation Question'
require_flowed "$PROFILE" 'Profile skill' '###### Acceptance Reassurance'
require_flowed "$PROFILE" 'Profile skill' '###### Discovery Reassurance'
require_flowed "$PROFILE" 'Profile skill' '###### Combined Reassurance'
require_flowed "$PROFILE" 'Profile skill' 'The default validation question is:'
require_flowed "$PROFILE" 'Profile skill' 'A sharper open question drawn from the active discussion may replace it when it still asks what to add, correct, or remove.'
require_flowed "$PROFILE" 'Profile skill' 'Present the candidate under its capture heading:'
require_flowed "$PROFILE" 'Profile skill' 'Place the Validation Question beneath the candidate.'
require_flowed "$PROFILE" 'Profile skill' 'Place the applicable reassurance beneath the Validation Question.'
require_flowed "$PROFILE" 'Profile skill' 'The Validation Question remains the only emphasized element in the review block.'
require_ordered "$PROFILE" 'Profile skill' 'Present the candidate under its capture heading:' 'Place the Validation Question beneath the candidate.'
require_ordered "$PROFILE" 'Profile skill' 'Place the Validation Question beneath the candidate.' 'Place the applicable reassurance beneath the Validation Question.'
require_ordered "$PROFILE" 'Profile skill' '#### Domain completeness' 'A domain is complete when accumulated evidence supports one cohesive organizational narrative'
require_ordered "$PROFILE" 'Profile skill' 'Profile-specific validation questions apply to the domain' '##### Response Support Text'
require_ordered "$PROFILE" 'Profile skill' '##### Response Support Text' '#### Advisory question scaffolding'
require_count "$PROFILE" 'Profile skill' '##### Response Support Text' 1

# US2: reassurance selection follows meaningful starting-point context.
require_flowed "$PROFILE" 'Profile skill' 'Use the Discovery Reassurance only when the person is being asked to originate unresolved organizational information and the workflow has not yet supplied a meaningful starting point for reaction.'
require_flowed "$PROFILE" 'Profile skill' 'Do not use the Discovery Reassurance merely because no Substantive Contribution has occurred yet.'
require_flowed "$PROFILE" 'Profile skill' 'A grounded possibility, interpretation, distinction, implication, connection, tension, tradeoff, recommendation, or other Working Idea already gives the person something to react to.'
require_flowed "$PROFILE" 'Profile skill' 'In those cases, use the Acceptance Reassurance or Combined Reassurance as appropriate.'
require_flowed "$PROFILE" 'Profile skill' 'Imported website evidence does not count as a user Substantive Contribution.'
require_flowed "$PROFILE" 'Profile skill' "Use the Acceptance Reassurance alone when the person is reacting to a candidate or Working Idea and \"I don't know\" would be unnatural."
require_flowed "$PROFILE" 'Profile skill' 'Use the Discovery Reassurance alone when the person is being asked to originate information and no meaningful starting point has yet been provided.'

# US3: canonical behavioral references preserve literal examples and protected behavior.
require_flowed "$PROFILE" 'Profile skill' 'The Acceptance Reassurance is:'
require_flowed "$PROFILE" 'Profile skill' 'The Discovery Reassurance is:'
require_flowed "$PROFILE" 'Profile skill' '#### Structure-revealing contributions'
require_flowed "$PROFILE" 'Profile skill' '#### Possibility-list Contribution Opportunities'
require_flowed "$PROFILE" 'Profile skill' 'one connected linear chain of reasoning'
require_flowed "$PROFILE" 'Profile skill' 'The addition must stop making sense when detached from the accepted evidence.'
require_count "$PROFILE" 'Profile skill' '**What would you add, correct, or remove?**' 2
require_flowed "$PROFILE" 'Profile skill' 'If this is accurate, just say so.'
require_flowed "$PROFILE" 'Profile skill' "If you don't know, say \"I don't know\" and we'll work through it together."
require_flowed "$STANDARD" 'Experience Standard' '| X2.69 | A contributed addition MUST NOT exceed one distinction or extension per Substantive Contribution. | One addition appears; a second, an enumerated set of offered options, or a recommendation set does not. |'
require_absent "$PROFILE" 'Profile skill' 'Before the first Substantive Contribution in an active domain, add the unemphasized reassurance'

# Generated adapters must remain byte-identical to the authoritative source.
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
echo 'OK: Feature 157 Profile response support text contract passes'
