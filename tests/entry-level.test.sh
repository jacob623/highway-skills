#!/usr/bin/env bash
# Config proposals offer classes of automation, keep saved entries, and state each entry's consequence under it.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring the **Consequences:** section in a proposal shape, or removing ### entry level, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
CONFIG="$HW_SKILLS/highway-codify-config/SKILL.md"
fail=0

section() {
	awk -v h="$2" '$0 == h {p=1; next} /^##/ {p=0} p' "$1"
}

reject() {
	if grep -Fq -- "$2" "$1"; then
		echo "FAIL: $(basename "$(dirname "$1")") still contains: $2"
		fail=1
	fi
}

require() {
	grep -Fq -- "$2" "$1" || {
		echo "FAIL: $(basename "$(dirname "$1")") omits: $2"
		fail=1
	}
}

require_in() {
	section "$1" "$2" | grep -Fq -- "$3" || {
		echo "FAIL: $(basename "$(dirname "$1")") $2 omits: $3"
		fail=1
	}
}

require_in "$CONFIG" '### entry level' '1. Propose each entry as a class of automation for the type `use entries` took. A class names what the type is for.'
require_in "$CONFIG" '### entry level' '2. Propose a class only when `current` describes it for this type. When `current` describes none, or could not read the documentation, propose one When to use class and one When not to use class at the level of steps 3 and 4.'
require_in "$CONFIG" '### entry level' '3. For an agent, propose from classes such as Agentic automation, Local machine execution, Human in the loop, MCP integration, Sensitive data handling, and Autonomous automation.'
require_in "$CONFIG" '### entry level' '4. For a pipeline, propose from classes such as Continuous integration, Continuous delivery, File-based triggers, and Workflow orchestration.'
require_in "$CONFIG" '### entry level' '5. For a coding standard, and for any other type, propose classes at the level of steps 3 and 4.'
require_in "$CONFIG" '### entry level' '6. A task is not an entry. Code change proposals, Pull request review, Bug investigation, and Test authoring are tasks.'
require_in "$CONFIG" '### entry level' '7. Propose at most four When to use entries and at most four When not to use entries.'
require_in "$CONFIG" '### entry level' "8. Take no class from this organization's customers, products, data, or decisions."
require_in "$CONFIG" '### entry level' '9. Return to `use entries`.'

require_in "$CONFIG" '### use entries' '2. On an add or update of a standard whose Technology is a platforms-catalog title, the whole value, compared without regard to case, follow `platform entries`. Do not follow `entry level`.'
require_in "$CONFIG" '### use entries' '4. Write each entry as one condition or one outcome, in five words or fewer. Count a hyphenated term as one word.'
require_in "$CONFIG" '### use entries' '7. On an update, keep each saved entry. Rewrite a saved entry that breaks step 4 or step 5, and state the rewrite in its **Why it matters:** sentence.'
require_in "$CONFIG" '### use entries' '9. Under each entry, emit **Why it matters:** and one sentence stating the consequence of that entry for the work Highway proposes. Name no customer, product, or decision of this organization. The catalog view, a conflict quote, and the saved cell keep the entry only.'

require_in "$CONFIG" '### standard rules' '6. When fifteen suggestions lack the credentials rule, leave out the last suggestion the documentation no longer describes, or the last suggestion when all are still described. Name it in the consequence sentence that opens the proposal. Do not leave out a rule the person provided.'
require_in "$CONFIG" '### standard proposal' '6. For a remove, open the proposal with a consequence sentence saying `[Standard Path]` remains and is no longer used. List in Conflicts each standard whose Inherits From names it.'
require_in "$CONFIG" '### rule shape' '1. Write one rule with must once, one condition, and one outcome, in eight words or fewer.'

require "$CONFIG" '- Every proposal shows its fields as bold labels, list fields as ordered lists, then Conflicts, and ends with **What would you add or correct?** and the cancel line.'
require "$CONFIG" '- On an add, `entry level` proposes one to four classes of automation for each of When to use and When not to use, from what `current` describes, and no task.'

for name in '### platform proposal' '### standard proposal'; do
	entries="$(section "$CONFIG" "$name" | awk '
		{ line[NR] = $0 }
		END {
			for (i = 1; i <= NR; i++) {
				if (line[i] == "1. [Entry]") {
					total++
					if (line[i + 1] == "" && line[i + 2] == "   **Why it matters:** [One sentence stating the consequence of this entry.]") ok++
				}
			}
			print (total + 0) " " (ok + 0)
		}
	')"
	if [[ "$entries" != '2 2' ]]; then
		echo "FAIL: highway-codify-config ${name#\#\#\# } does not place a blank line, then Why it matters, under each entry ($entries)"
		fail=1
	fi
	if section "$CONFIG" "$name" | grep -Fq '**Consequences:**'; then
		echo "FAIL: highway-codify-config ${name#\#\#\# } still has a Consequences section"
		fail=1
	fi
done

reject "$CONFIG" '**Consequences:**'
reject "$CONFIG" 'Name it in Consequences.'
reject "$CONFIG" 'Name each rewrite in Consequences.'
reject "$CONFIG" 'say in Consequences that'
reject "$CONFIG" 'such as Workflow orchestration, Web Service, Application Front-End, Desired State Configuration Management, GitOps, or Code Deployment'
reject "$CONFIG" 'Relate each entry to automation capabilities.'

previous=0
for heading in '### current' '### entry level' '### use entries' '### platform proposal'; do
	line="$(grep -nxF -- "$heading" "$CONFIG" | head -1 | cut -d: -f1)"
	if [[ -z "$line" ]] || ((line <= previous)); then
		echo "FAIL: highway-codify-config $heading is missing or out of order"
		fail=1
	else
		previous="$line"
	fi
done
current_line="$(grep -nxF '### current' "$CONFIG" | head -1 | cut -d: -f1)"
level_line="$(grep -nxF '### entry level' "$CONFIG" | head -1 | cut -d: -f1)"
entries_line="$(grep -nxF '### use entries' "$CONFIG" | head -1 | cut -d: -f1)"
if [[ -n "$current_line" && -n "$level_line" && -n "$entries_line" ]]; then
	between="$(awk -v a="$current_line" -v b="$entries_line" 'NR > a && NR < b && /^### /' "$CONFIG" | wc -l | tr -d ' ')"
	if [[ "$between" != '1' ]]; then
		echo 'FAIL: highway-codify-config entry level does not stand immediately between current and use entries'
		fail=1
	fi
fi

check_words() {
	local heading="$1" limit="$2" words
	words="$(section "$CONFIG" "$heading" | wc -w | tr -d ' ')"
	if [[ -z "$(section "$CONFIG" "$heading")" ]] || ((words > limit)); then
		echo "FAIL: highway-codify-config $heading has $words words; the limit is $limit"
		fail=1
	fi
}

check_words '### entry level' 250
check_words '### use entries' 250
check_words '### platform proposal' 400
check_words '### standard proposal' 400

for heading in '### entry level' '### use entries'; do
	for word in 'so that' 'because' 'in order to' 'should' 'consider' 'prefer' 'usually' 'where appropriate'; do
		if section "$CONFIG" "$heading" | grep -Fiwq -- "$word"; then
			echo "FAIL: highway-codify-config $heading uses: $word"
			fail=1
		fi
	done
done


if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: config proposals offer classes of automation with each consequence under its entry'
