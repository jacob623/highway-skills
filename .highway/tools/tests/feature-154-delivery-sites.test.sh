#!/usr/bin/env bash
# Verifies Feature 154 source-document delivery sites; it does not prove runtime conversation behavior.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: --probe source-document seeds a missing literal; --neutralise requires a pass.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
SETUP="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0

flow() { tr '\n' ' ' < "$1" | tr -s ' '; }
require_text() { grep -Fq -- "$3" "$1" || { echo "FAIL: $2 missing: $3"; fail=1; }; }
require_flowed() { flow "$1" | grep -Fq -- "$3" || { echo "FAIL: $2 missing: $3"; fail=1; }; }
require_absent() { if flow "$1" | grep -Fq -- "$3"; then echo "FAIL: $2 still contains: $3"; fail=1; fi; }
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
	probe_dir="$SCRIPT_DIR/fixtures/feature-154-probe-$$"
	mkdir -p "$probe_dir"
	trap 'rm -rf "$probe_dir"' EXIT
	if [[ "$probe_class" != source-document ]]; then echo "FAIL: undeclared artifact class: $probe_class" >&2; exit 2; fi
	if [[ "$neutralise" -eq 0 ]]; then printf 'placeholder\n' >"$probe_dir/source.md"; else printf 'Here is a proposed starting point\n' >"$probe_dir/source.md"; fi
	grep -Fq 'Here is a proposed starting point' "$probe_dir/source.md" || exit 1
fi

# US1: proposal reassurance and contribution-state guidance.
require_flowed "$PROFILE" 'Profile skill' 'If this is accurate, just say so.'
require_flowed "$PROFILE" 'Profile skill' 'If you don'"'"'t know, say "I don'"'"'t know" and we'"'"'ll work through it together.'
require_absent "$PROFILE" 'Profile skill' '**If this is accurate, just say so.**'
require_flowed "$PROFILE" 'Profile skill' 'Imported website evidence does not count as a Substantive Contribution.'
require_flowed "$PROFILE" 'Profile skill' 'After the first Substantive Contribution in that domain, remove the conditional reassurance.'

# US2: X2.72 and domain-boundary delivery.
require_text "$STANDARD" 'Experience Standard' '| X2.72 |'
require_flowed "$STANDARD" 'Experience Standard' 'An invitation to react where nothing has been captured MUST use the heading "Here is a proposed starting point for your [domain]:".'
require_absent "$STANDARD" 'Experience Standard' 'Here'"'"'s a direction worth considering — what'"'"'s missing from it?'
for domain in Identity Vision 'Competitive Path' 'Guiding Principles'; do
	require_flowed "$PROFILE" 'Profile skill' "**Here is a proposed starting point for your $domain:**"
done
require_text "$PROFILE" 'Profile skill' '**Here'"'"'s what I'"'"'ve captured as your [domain]:**'
require_flowed "$PROFILE" 'Profile skill' 'That is an important part of how you will get there. I will carry it forward when we reach Competitive Path, and return to Vision.'
require_absent "$PROFILE" 'Profile skill' 'belongs to Competitive Path'
require_absent "$PROFILE" 'Profile skill' 'That is not Vision'

# US3: direct approval reaches candidate presentation.
require_flowed "$PROFILE" 'Profile skill' 'When the person gives unambiguous approval, proceed directly to the Converged Proposal and then its validation question.'
require_flowed "$PROFILE" 'Profile skill' 'Anything you'"'"'d change before we keep this?'
require_flowed "$PROFILE" 'Profile skill' 'Approval with new substantive information triggers re-evaluation.'

# US4: one grounded advisory addition precedes applicable Profile-owned questions.
require_text "$PROFILE" 'Profile skill' '#### Advisory question scaffolding'
require_flowed "$PROFILE" 'Profile skill' 'Before a Profile-owned question whose answer depends on advisory reasoning, present one grounded advisory addition when accepted Profile evidence supports one.'
require_flowed "$PROFILE" 'Profile skill' 'keep it as a Working Idea outside the candidate unless the person adopts it'
require_flowed "$PROFILE" 'Profile skill' 'Canonical questions, validation questions, acceptance-boundary questions, and direct clarification of consequential ambiguity are excluded.'
require_count "$PROFILE" 'Profile skill' 'The question is the only emphasized element' 1
require_flowed "$PROFILE" 'Profile skill' 'prefer them in this order: distinction, implication, connection, tension, tradeoff, possibility, recommendation'
require_flowed "$PROFILE" 'Profile skill' 'A contribution is not satisfied by renaming, relabeling, summarizing, or paraphrasing accepted evidence.'
require_flowed "$PROFILE" 'Profile skill' '_A tradeoff made visible._ The person says growth should never come at the expense of meaningful work.'
require_flowed "$PROFILE" 'Profile skill' '**When those two pull in different directions, which one should win?**'

# US5: fresh Setup welcome ordering.
require_text "$SETUP" 'Setup skill' '### Welcome'
require_flowed "$SETUP" 'Setup skill' 'When beginning initial Setup, before the first Profile-owned action, emit the Highway welcome as the first user-visible output.'
require_flowed "$SETUP" 'Setup skill' 'Do not emit review, loading, supplied-website, checking, setup-order, readiness, or workflow narration before the welcome.'
require_text "$SETUP" 'Setup skill' 'Do not emit this welcome on a resumed Setup interaction.'

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 154 delivery sites pass'
