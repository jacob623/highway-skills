#!/usr/bin/env bash
# Verifies the Feature 152 Profile conversation conformance amendment to the Experience Standard
# and the highway-profile skill.
#
# Evidence boundary: every assertion here is a static document contract. None of it is evidence that
# any governed behavior occurs in a real conversation (D3.8).
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
fail=0

require_text() {
	# require_text <file> <label> <literal>
	# `--` guards literals that begin with a hyphen, such as a Verification bullet.
	grep -Fq -- "$3" "$1" || { echo "FAIL: $2 missing: $3"; fail=1; }
}

require_absent() {
	# require_absent <file> <label> <literal>
	if grep -Fq -- "$3" "$1"; then
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
	# A point-of-use obligation is only per-site if the site count is asserted; otherwise four
	# sites can collapse into one and still satisfy every presence check.
	# Counted on the flowed text so markdown line wrapping cannot hide a site.
	actual="$(flow "$1" | grep -Fo -- "$3" | wc -l | tr -d ' ')"
	if [[ "$actual" -ne "$4" ]]; then
		echo "FAIL: $2 expected $4 occurrences of '$3' but found $actual"
		fail=1
	fi
}

# --- Seeded failure probe (D3.7): --probe <class> seeds a defect and requires detection;
# --probe <class> --neutralise runs the identical path unseeded and requires a clean pass.

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document generated-artifact "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

if [[ -n "$probe_class" ]]; then
	probe_dir="$SCRIPT_DIR/fixtures/feature-152-probe-$$"
	mkdir -p "$probe_dir"
	trap 'rm -rf "$probe_dir"' EXIT
	case "$probe_class" in
		source-document)
			# A source document missing a required rule row must be detected.
			probe_file="$probe_dir/standard.md"
			if [[ "$neutralise" -eq 0 ]]; then
				printf '| X2.57 | placeholder | placeholder |\n' >"$probe_file"
			else
				printf '| X2.57 | placeholder | placeholder |\n| X2.58 | placeholder | placeholder |\n' >"$probe_file"
			fi
			if grep -Fq '| X2.58 |' "$probe_file"; then exit 0; else exit 1; fi
			;;
		generated-artifact)
			# A generated adapter that drifts from its source must be detected.
			printf 'source content\n' >"$probe_dir/source.md"
			if [[ "$neutralise" -eq 0 ]]; then
				printf 'drifted content\n' >"$probe_dir/adapter.md"
			else
				printf 'source content\n' >"$probe_dir/adapter.md"
			fi
			if cmp -s "$probe_dir/source.md" "$probe_dir/adapter.md"; then exit 0; else exit 1; fi
			;;
	esac
fi

# --- Foundational: the Experience Standard amendment ---

for id in X2.58 X2.59 X2.60 X2.61 X2.62 X2.63 X2.64 X2.65 X2.66 X2.67; do
	require_text "$STANDARD" 'Experience Standard' "| $id |"
done

require_text "$STANDARD" 'Experience Standard' \
	"A domain's substance MUST cross an explicit acceptance boundary before it is retained."
require_text "$STANDARD" 'Experience Standard' \
	'An unambiguous approval MUST be treated as acceptance regardless of its wording.'
require_text "$STANDARD" 'Experience Standard' \
	'A re-presented candidate MUST name what changed since the person accepted it.'
require_text "$STANDARD" 'Experience Standard' \
	'A candidate whose development since acceptance is unclear MUST be presented for review.'
require_text "$STANDARD" 'Experience Standard' \
	'A term the person rejected MUST NOT reappear, including as a synonym.'
require_text "$STANDARD" 'Experience Standard' \
	"An amended candidate MUST retain the accepted content's original form."
require_text "$STANDARD" 'Experience Standard' \
	'A correction that cannot be located in accepted content MUST be reported to the person.'
require_text "$STANDARD" 'Experience Standard' \
	'An acknowledgment of a Substantive Contribution MUST add understanding beyond restating it.'
require_text "$STANDARD" 'Experience Standard' \
	'Each Substantive Contribution MUST receive one acknowledgment.'
require_text "$STANDARD" 'Experience Standard' \
	"A question requiring the person's response MUST be emphasized where it appears."

# Amended Observables. The rule text of X2.51 and X2.4 is unchanged.
require_flowed "$STANDARD" 'Experience Standard' \
	'comparison with confirmed content ignores whitespace differences'
require_flowed "$STANDARD" 'Experience Standard' \
	"material ambiguity in the person's own contribution is consequential"

rule_total="$(grep -cE '^\| X[0-9]+\.[0-9]+ \|' "$STANDARD")"
if [[ "$rule_total" -ne 64 ]]; then
	echo "FAIL: Experience Standard declares $rule_total X-rules; expected 64"
	fail=1
fi

require_text "$STANDARD" 'Experience Standard' '**Layer 2 - Experience.** Version `11.1.0`.'

# --- US1: a domain is accepted explicitly, and not re-asked ---

# The acceptance boundary is named at each of the four domain sites, not once centrally.
require_count "$PROFILE" 'Profile skill' 'as the acceptance boundary for' 4

for bullet in \
	'- Each domain crosses one acceptance boundary before its substance is retained.' \
	'- Confirmed substance is not presented again unless the re-presentation names what changed.' \
	'- A candidate whose development since acceptance is unclear is presented rather than suppressed.'; do
	require_text "$PROFILE" 'Profile skill' "$bullet"
done

# --- US2: every capture looks the same ---

for domain in Identity Vision 'Competitive Path' 'Guiding Principles'; do
	require_text "$PROFILE" 'Profile skill' "**Here's what I've captured as your $domain:**"
done

# The question is defined once (FR-014) and referenced from all four domain sites.
require_count "$PROFILE" 'Profile skill' '**What would you add, correct, or remove?**' 1
require_count "$PROFILE" 'Profile skill' 'the shared validation question' 4

for bullet in \
	'- Each domain presents its Converged Proposal under its capture heading.' \
	'- Each domain uses the single defined validation question.' \
	'- Each question requiring a response is emphasized.'; do
	require_text "$PROFILE" 'Profile skill' "$bullet"
done

# Superseded wording is removed outright, not deprecated (FR-030).
for superseded in \
	"**What's missing or wrong in this description of [Organization Name]?**" \
	"**What's missing or wrong about where [Organization Name] is" \
	"**What's missing or wrong about how [Organization Name] gets" \
	"**What's missing or wrong about what guides decisions at [Organization Name]?**" \
	'You can also change it or provide your own description.' \
	'You can also change it or provide your own vision.' \
	'You can also change it or provide your own approach.' \
	'You can also change it or provide your own principles.' \
	"- Each domain's validation question asks what is missing or wrong in the candidate."; do
	require_absent "$PROFILE" 'Profile skill' "$superseded"
done

# --- US3: a correction is honored as given ---

for bullet in \
	'- A term the person rejected does not reappear, including as a synonym.' \
	"- An amendment preserves the accepted content's form." \
	'- A correction that cannot be located is reported rather than applied elsewhere.'; do
	require_text "$PROFILE" 'Profile skill' "$bullet"
done

# --- US4: the conversation adds something ---

for bullet in \
	'- Each Substantive Contribution receives one acknowledgment.' \
	'- An acknowledgment adds understanding beyond restating the contribution.'; do
	require_text "$PROFILE" 'Profile skill' "$bullet"
done

# --- US5: nothing leaks from behind the curtain ---

require_flowed "$PROFILE" 'Profile skill' \
	'Domain completeness is obtained by reading the retained Profile record'
require_flowed "$PROFILE" 'Profile skill' \
'The authorized mutation is a write to the retained Profile record'

for bullet in \
	'- Domain completeness is obtained by reading the retained Profile record.' \
	'- Persistence writes the accepted domain mutation to the retained Profile record.' \
	'- Internal readiness vocabulary does not appear in orchestrated conversation.'; do
	require_text "$PROFILE" 'Profile skill' "$bullet"
done

# FR-026: the authorization is local to Profile. No general permission or prohibition is added.
require_absent "$STANDARD" 'Experience Standard' 'command surface'
require_absent "$STANDARD" 'Experience Standard' 'retained Profile record'

# --- US6: where you're going and how you'll get there stay distinct ---

require_flowed "$PROFILE" 'Profile skill' \
	'Vision does not elicit or retain the approach, sequencing, or organizational method'
require_text "$PROFILE" 'Profile skill' \
	'- Vision retains its boundary against approach, sequencing, and organizational method.'

# FR-028: cross-domain preservation appears at the point of composition, not only as a gate.
require_flowed "$PROFILE" 'Profile skill' \
	'carry it forward to the appropriate unresolved domain rather than discarding it'
require_text "$PROFILE" 'Profile skill' \
	'- Supported cross-domain implications are preserved for the appropriate unresolved domain.'

# --- Scope guard: highway-profile is the only skill this feature modifies (FR-029a) ---

for other in highway-controls highway-nfrs highway-objectives highway-new; do
	require_absent "$HIGHWAY_ROOT/skills/$other/SKILL.md" "$other skill" \
		'**What would you add, correct, or remove?**'
done

# --- The amended Profile reaches every agent surface byte for byte ---

for adapter in \
	.github/skills/highway-profile/SKILL.md \
	.claude/skills/highway-profile/SKILL.md \
	.cursor/skills/highway-profile/SKILL.md \
	.agents/skills/highway-profile/SKILL.md; do
	if ! cmp -s "$PROFILE" "$REPO_ROOT/$adapter"; then
		echo "FAIL: generated adapter differs from the Profile source: $adapter"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 152 Profile conversation conformance passes'
