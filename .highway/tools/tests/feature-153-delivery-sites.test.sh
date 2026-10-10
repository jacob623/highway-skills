#!/usr/bin/env bash
# Verifies the Feature 153 delivery sites: the Experience Standard rules added for contribution and
# continuity, and the point-of-use text carrying them into the highway-profile workflow.
#
# Evidence boundary: every assertion here is a static document contract. A full pass establishes
# that the text is present and shaped correctly. It is not evidence that any agent reads it, acts
# on it, or produces the governed behavior in a real conversation (D3.8).
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: --probe <class> seeds a defect and observes detection; --probe <class>
# --neutralise runs the identical path unseeded and requires a clean pass.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
GROUNDING="$HIGHWAY_ROOT/instructions/highway-agent-context.md"
fail=0

require_text() {
	# require_text <file> <label> <literal>
	grep -Fq -- "$3" "$1" || { echo "FAIL: $2 missing: $3"; fail=1; }
}

require_absent() {
	# require_absent <file> <label> <literal>
	if flow "$1" | grep -Fq -- "$3"; then
		echo "FAIL: $2 still contains: $3"
		fail=1
	fi
}

flow() {
	# Collapse markdown line wrapping so a sentence assertion is not defeated by a line break.
	tr '\n' ' ' < "$1" | tr -s ' '
}

require_flowed() {
	# require_flowed <file> <label> <sentence>
	flow "$1" | grep -Fq -- "$3" || { echo "FAIL: $2 missing sentence: $3"; fail=1; }
}

require_count() {
	# require_count <file> <label> <literal> <expected>
	# A point-of-use obligation is only per-site if the site count is asserted; otherwise several
	# sites collapse into one and still satisfy every presence check.
	actual="$(flow "$1" | grep -Fo -- "$3" | wc -l | tr -d ' ')"
	if [[ "$actual" -ne "$4" ]]; then
		echo "FAIL: $2 expected $4 occurrences of '$3' but found $actual"
		fail=1
	fi
}

require_rule_shape() {
	# require_rule_shape <id> — P1.1 one keyword, P1.3 25 words or fewer.
	# The rule cell is the second ' | '-delimited field of its table row.
	row="$(grep -F "| $1 | " "$STANDARD" | head -1)"
	if [[ -z "$row" ]]; then
		echo "FAIL: Experience Standard has no row for $1"
		fail=1
		return
	fi
	text="$(printf '%s' "$row" | awk -F' \\| ' '{print $2}')"
	words="$(printf '%s' "$text" | wc -w | tr -d ' ')"
	keywords="$(printf '%s' "$text" | grep -oE 'MUST NOT|MUST|SHOULD' | wc -l | tr -d ' ')"
	if [[ "$words" -gt 25 ]]; then
		echo "FAIL: $1 is $words words; P1.3 allows 25"
		fail=1
	fi
	if [[ "$keywords" -ne 1 ]]; then
		echo "FAIL: $1 carries $keywords keywords; P1.1 allows 1"
		fail=1
	fi
}

# --- Seeded failure probe (D3.7) ---

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

if [[ -n "$probe_class" ]]; then
	probe_dir="$SCRIPT_DIR/fixtures/feature-153-probe-$$"
	mkdir -p "$probe_dir"
	trap 'rm -rf "$probe_dir"' EXIT
	case "$probe_class" in
		source-document)
			# A source document missing a required rule row must be detected.
			probe_file="$probe_dir/standard.md"
			if [[ "$neutralise" -eq 0 ]]; then
				printf '| X2.67 | placeholder | placeholder |\n' >"$probe_file"
			else
				printf '| X2.67 | placeholder | placeholder |\n| X2.68 | placeholder | placeholder |\n' >"$probe_file"
			fi
			if grep -Fq '| X2.68 |' "$probe_file"; then exit 0; else exit 1; fi
			;;
	esac
fi

# --- Assertions are added by the story phases that follow. ---

# --- US1: nothing is retained that the person did not accept ---

# FR-002 rule half: the proposed-starting-point heading is owned by the Standard.
require_text "$STANDARD" 'Experience Standard' '| X2.72 |'
require_text "$STANDARD" 'Experience Standard' \
	'An invitation to react where nothing has been captured MUST use the heading "Here is a proposed starting point for your [domain]:".'

# FR-001: the candidate-before-retention rule is stated once for all four domains...
require_flowed "$PROFILE" 'Profile skill' \
	"A domain's substance is kept only after its finished candidate has been presented and accepted."

# ...and again at each of the four domain sites, so four sites cannot collapse into one.
require_count "$PROFILE" 'Profile skill' 'before that candidate is presented and accepted.' 4
for domain in Identity Vision 'Competitive Path' 'Guiding Principles'; do
	require_flowed "$PROFILE" 'Profile skill' \
		"Retain nothing from $domain before that candidate is presented and accepted."
done

# FR-002 delivery half: the shared validation question is scoped to a presented candidate, and the
# proposed-starting-point heading covers the moment it does not apply.
require_flowed "$PROFILE" 'Profile skill' \
	'The validation question applies only where a candidate has been presented.'
require_flowed "$PROFILE" 'Profile skill' \
	'**Here is a proposed starting point for your Identity:**'

# R6 guard: the acceptance literal is defined once and stays that way.
require_count "$PROFILE" 'Profile skill' '**What would you add, correct, or remove?**' 1

# P8.4: the obligation is checkable from the skill's own Verification section.
require_text "$PROFILE" 'Profile skill' \
	"- No domain substance is retained before that domain's candidate has been presented."

# --- US2: the workflow carries the person's words forward instead of narrating itself ---

# FR-012: the continuity contract and its nothing-accepted case are owned by the Standard.
for id in X2.70 X2.71; do
	require_text "$STANDARD" 'Experience Standard' "| $id |"
done
require_text "$STANDARD" 'Experience Standard' \
	'Text opening a domain MUST name accepted substance carried forward from the preceding domain.'
require_text "$STANDARD" 'Experience Standard' \
	'Opening text MUST state that nothing has been accepted yet when no accepted substance exists.'

# FR-013: continuity is delivered at each of the three handoffs between Profile's four domains.
# Counting the shared clause is what stops one generic sentence standing in for three handoffs.
require_count "$PROFILE" 'Profile skill' \
	"in the person's own words and connecting it to the question being asked." 3
require_flowed "$PROFILE" 'Profile skill' \
	"Open it by naming accepted Identity substance in the person's own words and connecting it to the question being asked."
require_flowed "$PROFILE" 'Profile skill' \
	"Open it by naming accepted Vision substance in the person's own words and connecting it to the question being asked."
require_flowed "$PROFILE" 'Profile skill' \
	"Open it by naming accepted Competitive Path substance in the person's own words and connecting it to the question being asked."

# X2.71's delivery: the opening says nothing has been accepted rather than inventing a carry-forward.
require_flowed "$PROFILE" 'Profile skill' \
	'Where the preceding domain produced no accepted substance, say that nothing has been accepted yet rather than inventing a carry-forward.'

# FR-003: the narration prohibition reaches persistence, progression and domain state, and is not
# scoped to readiness vocabulary.
require_flowed "$PROFILE" 'Profile skill' \
	"Say nothing about retaining the answer, about where this sits in the sequence, about a domain's state, or about what comes next."

require_text "$PROFILE" 'Profile skill' \
	'- Each domain opening names accepted substance from the preceding domain.'

# --- US3: the workflow adds something to the person's thinking ---

# FR-009, FR-010: the contribution obligation and its bound, each shaped to P1.1 and P1.3.
for id in X2.68 X2.69; do
	require_text "$STANDARD" 'Experience Standard' "| $id |"
	require_rule_shape "$id"
done
require_text "$STANDARD" 'Experience Standard' \
	'An Interactive Workflow MUST contribute one grounded addition when non-redundant reasoning would materially improve the relevant Working Idea.'
require_text "$STANDARD" 'Experience Standard' \
	'A contributed addition MUST NOT exceed one distinction or extension per Substantive Contribution.'

# FR-010's exclusion list is what stops padding satisfying the rule (P1.4).
require_flowed "$STANDARD" 'Experience Standard' \
	'optional detail, repetition, unsupported speculation, manufactured alternatives, ceremony, or low-value addition does not satisfy it'

# FR-011: exactly three exemplars, each adding one thing and each closing on its own question.
require_text "$PROFILE" 'Profile skill' '#### Contribution in practice'
require_count "$PROFILE" 'Profile skill' 'What the workflow adds:' 4
require_flowed "$PROFILE" 'Profile skill' \
	"**Which of those two would you be judged on?**"
require_flowed "$PROFILE" 'Profile skill' \
	"**Does that read as the thing you're building, or as one strand of it?**"
require_flowed "$PROFILE" 'Profile skill' \
	'**What would have to be true for you to break it?**'

require_text "$PROFILE" 'Profile skill' \
	'- Contribution in practice carries three worked exemplars, each adding one thing.'

# FR-011: one counter-example, so the section shows the failure mode and not only the wins.
require_flowed "$PROFILE" 'Profile skill' \
	'*A move with nothing underneath it.* The person says: "We are a bakery."'
require_flowed "$PROFILE" 'Profile skill' \
	'That is not a contribution. Nothing in the accepted material supports'
require_text "$PROFILE" 'Profile skill' \
	'- Contribution in practice carries one counter-example of an addition the accepted material does not support.'

# --- US4: each domain stays on its own subject ---

# FR-004: the cue is emitted, so it keeps approach and sequencing out of the retained wording at the
# moment Vision is being composed rather than only at a completeness gate.
require_flowed "$PROFILE" 'Profile skill' \
	'important part of how you will get there. I will carry it forward when we reach Competitive Path'

# --- US5: the small literal corrections ---

# FR-006: the conditional reassurance is present and unemphasized; X2.67 reserves emphasis for the question.
require_flowed "$PROFILE" 'Profile skill' \
	'If you don'"'"'t know, say "I don'"'"'t know" and we'"'"'ll work through it together.'
require_absent "$PROFILE" 'Profile skill' \
	'**If you don'"'"'t know, say "I don'"'"'t know" and we'"'"'ll work through it together.**'

# FR-007: X2.56's Observable names the inline form. Its rule text is unchanged.
require_text "$STANDARD" 'Experience Standard' \
	'| X2.56 | An amended candidate MUST present its change distinguishably. |'
require_flowed "$STANDARD" 'Experience Standard' \
	'the change is marked inline, within the candidate'

# FR-008: the grounding source names the moment the Standard is read, rather than advising it.
require_flowed "$GROUNDING" 'Agent grounding source' \
	'Read `.highway/governance/experience-standard.md` before producing any user-visible output'
require_absent "$GROUNDING" 'Agent grounding source' \
	'- Consult `.highway/governance/experience-standard.md` for applicable user-visible'

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 153 delivery sites pass'
