#!/usr/bin/env bash
# Verifies the Feature 150 collaborative convergence amendment to the Experience Standard and Profile.
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
	grep -Fq "$3" "$1" || { echo "FAIL: $2 missing: $3"; fail=1; }
}

require_absent() {
	# require_absent <file> <label> <literal>
	if grep -Fq "$3" "$1"; then
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
	flow "$1" | grep -Fq "$3" || { echo "FAIL: $2 missing sentence: $3"; fail=1; }
}

require_flowed_absent() {
	# require_flowed_absent <file> <label> <sentence>
	if flow "$1" | grep -Fq "$3"; then
		echo "FAIL: $2 still contains sentence: $3"
		fail=1
	fi
}

# US1 - the convergence condition is factual and the Contribution Opportunity has a shape.
for id in X2.42 X2.43 X2.44 X2.45 X2.46 X2.57; do
	require_text "$STANDARD" 'Experience Standard' "| $id |"
done

require_text "$STANDARD" 'Experience Standard' \
	'An Interactive Workflow MUST provide a Contribution Opportunity before convergence when the person has made no Substantive Contribution to the active subject.'
require_text "$STANDARD" 'Experience Standard' \
	'An Interactive Workflow MUST NOT present a Converged Proposal for a subject to which the person has made no Substantive Contribution.'
require_absent "$STANDARD" 'Experience Standard' \
	'When Highway materially shaped a Working Idea, the person MUST receive a Contribution Opportunity'
require_absent "$STANDARD" 'Experience Standard' 'unless prior interaction already provided one'

for definition in \
	'**Exploratory Move**: A development of a Working Idea' \
	'**Grounded Possibility**: A direction traceable to accepted material' \
	'**Attribution**: An inline statement, at the point of use'; do
	require_text "$STANDARD" 'Experience Standard' "$definition"
done

require_absent "$STANDARD" 'Experience Standard' 'Idea Highway materially shaped before it becomes a Converged Proposal'
require_text "$STANDARD" 'Experience Standard' 'Its substance is not a candidate, and nothing in it can be accepted.'

# FR-027: the amendment introduces no turn-counting vocabulary.
require_absent "$STANDARD" 'Experience Standard' 'Development Turn'
require_absent "$PROFILE" 'Profile skill' 'Development Turn'

# The permissive Identity hook is replaced by the Standard's factual trigger.
require_absent "$PROFILE" 'Profile skill' 'When Profile materially assembles'

# FR-025: retired identifiers are never reused.
for retired in X1.7 X2.2 X2.8 X2.14 X2.23 X2.25 X2.26 X2.27 X2.28 X2.33 X2.39 X2.40; do
	if grep -Fq "| $retired |" "$STANDARD"; then
		echo "FAIL: retired rule identifier reused: $retired"
		fail=1
	fi
done

# US2 - the three later domains open with material to react to.
for id in X2.47 X2.48; do
	require_text "$STANDARD" 'Experience Standard' "| $id |"
done

require_text "$STANDARD" 'Experience Standard' 'an ungrounded option is marked speculative where it appears'

for domain in Vision 'Competitive Path' 'Guiding Principles'; do
	require_flowed "$PROFILE" 'Profile skill' \
		"Open that subject with grounded possibilities drawn from accepted Profile evidence before asking the $domain question."
done

# Identity opportunities stay conditional; it gains no opening sentence.
if flow "$PROFILE" | grep -Fq 'before asking the Identity question'; then
	echo 'FAIL: Profile skill opens Identity with grounded possibilities'
	fail=1
fi

# US3 - no acceptance request is answerable by agreeing.
for id in X2.49 X2.50 X2.51; do
	require_text "$STANDARD" 'Experience Standard' "| $id |"
done

for closed in \
	'Is this an accurate description of your organization?' \
	"Does this accurately reflect where you'd like [Organization Name] to go?" \
	'Does this accurately reflect how [Organization Name] plans to get there?' \
	'Does this accurately reflect what should guide decisions at [Organization Name]?'; do
	require_flowed_absent "$PROFILE" 'Profile skill' "$closed"
done

# Feature 152 replaced the four per-domain open validation questions with one shared
# question. The requirement enforced here is unchanged: validation is asked openly.
require_flowed "$PROFILE" 'Profile skill' \
	'**What would you add, correct, or remove?**'

require_flowed "$PROFILE" 'Profile skill' \
	'A sharper open question drawn from the conversation may stand in for it, as long as it stays emphasized and still asks what to add, correct, or remove.'

# US4 - introduced vocabulary and ungrounded claims are marked as Highway's.
for id in X2.52 X2.53 X2.54; do
	require_text "$STANDARD" 'Experience Standard' "| $id |"
done

require_flowed "$STANDARD" 'Experience Standard' \
	'Mark the vocabulary and the claims that are yours.'
require_flowed "$STANDARD" 'Experience Standard' \
	'Ordinary paraphrase of what they meant needs no marking; marking everything makes the marking worthless.'
require_flowed "$STANDARD" 'Experience Standard' 'An unadopted term stays out of the captured record.'

# US5 - an amendment preserves accepted text and shows only what changed.
for id in X2.55 X2.56; do
	require_text "$STANDARD" 'Experience Standard' "| $id |"
done

# The Standard's rule inventory. Raised from 59 by Feature 153, which adds X2.68 through X2.72.
rule_total="$(grep -cE '^\| X[0-9]+\.[0-9]+ \|' "$STANDARD")"
if [[ "$rule_total" -ne 64 ]]; then
	echo "FAIL: Experience Standard rule inventory is $rule_total, expected 64"
	fail=1
fi

# FR-024: each rule added by this feature states one keyword and stays within 25 words.
for id in X2.42 X2.43 X2.44 X2.45 X2.46 X2.47 X2.48 X2.49 X2.50 X2.51 X2.52 X2.53 X2.54 X2.55 X2.56 X2.57; do
	rule_cell="$(grep -F "| $id |" "$STANDARD" | awk -F'|' '{print $3}')"
	if [[ -z "$rule_cell" ]]; then
		echo "FAIL: rule cell for $id could not be read"
		fail=1
		continue
	fi
	keywords="$(printf '%s' "$rule_cell" | sed 's/MUST-level/mustlevel/g; s/MUST NOT/MUSTNOT/g' \
		| tr ' ' '\n' | grep -cE '^(MUSTNOT|MUST|SHOULD)$')"
	if [[ "$keywords" -ne 1 ]]; then
		echo "FAIL: $id states $keywords normative keywords, expected exactly 1"
		fail=1
	fi
	words="$(printf '%s' "$rule_cell" | awk '{print NF}')"
	if [[ "$words" -gt 25 ]]; then
		echo "FAIL: $id rule text is $words words, exceeding the 25-word limit"
		fail=1
	fi
done

# Profile carries output wording only: no rule text and no X identifier.
must_count="$(grep -cF 'MUST' "$PROFILE")"
if [[ "$must_count" -ne 0 ]]; then
	echo "FAIL: Profile skill contains $must_count MUST-level lines; rule text belongs to the Experience Standard"
	fail=1
fi
require_absent "$PROFILE" 'Profile skill' 'X2.41'

# The amended Profile reaches every agent surface byte for byte.
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
echo 'OK: Feature 150 collaborative convergence passes'
