#!/usr/bin/env bash
# Codify checks the record after selection, hands an incomplete one to highway-implementation, and treats a Language as a code project.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: removing `### record check` or `### code project` from highway-codify, or restoring `### platforms needed`, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
SKILLS="$HW_SKILLS"
CODIFY="$(fl_skill_text_file "$SKILLS/highway-codify")"
IMPL="$(fl_skill_text_file "$SKILLS/highway-implementation")"
ONBOARD="$(fl_skill_text_file "$SKILLS/highway-onboarding")"
RI_RECORD="$(hw_template implementation-record)"
CDY_RECORD="$(hw_template codify-record)"
fail=0

section() {
	awk -v h="$2" '$0 == h {p=1; next} /^##/ {p=0} p' "$1"
}

require_in() {
	local file="$1" heading="$2" text="$3"
	section "$file" "$heading" | grep -Fq -- "$text" || {
		echo "FAIL: $(basename "$(dirname "$file")") $heading omits: $text"
		fail=1
	}
}

require() {
	local file="$1" text="$2"
	grep -Fq -- "$text" "$file" || {
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $(basename "$(dirname "$file")")/$(basename "$file") still contains: $text"
		fail=1
	fi
}

limit() {
	local file="$1" heading="$2" max="$3" words word
	words="$(section "$file" "$heading" | wc -w | tr -d ' ')"
	if [[ "$words" -eq 0 || "$words" -gt "$max" ]]; then
		echo "FAIL: $(basename "$(dirname "$file")") $heading has $words words; the limit is $max"
		fail=1
	fi
	for word in 'so that' 'because' 'in order to' 'should' 'consider' 'prefer' 'usually' 'where appropriate' 'MUST' 'SHOULD'; do
		if section "$file" "$heading" | grep -Fiwq -- "$word"; then
			echo "FAIL: $(basename "$(dirname "$file")") $heading uses: $word"
			fail=1
		fi
	done
}

require_in "$CODIFY" '### Entry' '7. After a selection, go to `record check`.'
require_in "$CODIFY" '### choose' 'A number, a title, or a description selects one. Show the title. Go to `record check`.'
require "$CODIFY" '`choose` when no implementation is named; `record check`; `code project` for a code project, or `rank`, with `codified`, when no action is named; then `suggest`, `draft`, `code tasks` for a code project, `provider`, `standards`,'

R='### record check'
for text in \
	'1. The record is incomplete when Deployed by or Managed by is `Needed`, empty, or names a platform with no row.' \
	'2. The record is incomplete when Language is `Needed`, empty, or names a standard with no row. Language `None` names no standard and is complete.' \
	'3. When `highway-implementation` returned here and the record is still incomplete, stop.' \
	"**[Product Title]'s implementation record is missing critical detail required for highway-codify proposals.**" \
	"Let's set those details now for [Product Title]." \
	'5. Then follow `highway-implementation` for [RI id], with the return step `record check` in `highway-codify`. Ask nothing.' \
	'6. When Language names a coding standard, go to `code project`.' \
	'7. Otherwise, when an action is selected or the invocation named one, go to `draft`. Otherwise go to `rank`.' \
	'A return keeps the selected implementation and any selected action, and reads the record again.'; do
	require_in "$CODIFY" "$R" "$text"
done

require_in "$CODIFY" '### codified' 'Return to the step that named this one.'

C='### code project'
for text in \
	"The product is a code project when the selected implementation's Language names a coding standard. That standard is the Language standard." \
	"1. An Establish feature is recorded when an accepted row lists this implementation and a Features entry's \`<action>\` starts with \`establish\`." \
	'2. With none recorded, the only suggestion is `Establish [implementation title]`, even when an instance is running.' \
	'When another action is selected or named, say Establish comes first. Go to `suggest`.' \
	'3. With one recorded, go to `draft` when an action is selected or the invocation named one.' \
	'4. Otherwise take one suggestion per item, in this order: each Realized Capability, each Realized Interface, each Coverage row marked covered, then each NFR Realization item.' \
	'5. Each title is a change to the product code.' \
	'6. Follow `codified`. Keep at most five. Drop items from the end. Go to `suggest`.'; do
	require_in "$CODIFY" "$C" "$text"
done

T='### code tasks'
for text in \
	'1. Until an Establish feature is recorded, another action waits. Say Establish comes first.' \
	"2. A code task writes or changes the product's source code. Its target is the product. It shows **Language:** [Language standard] in place of **Provider:**." \
	'3. Establish proposes code tasks for the project structure, the build file, the entry point, the configuration, and a health check. It proposes no Realized Capability. The person adds scope on `revise`.' \
	"4. When Deployed by's row has Kind \`pipeline\`, Establish adds tasks that write that pipeline. Each shows **Provider:** [Deployed by]." \
	'5. Every other action proposes code tasks that change the product code.' \
	"6. A code task's Standards are the Language standard, each standard it inherits, then each standard whose Technology appears on its own in the Technology Choice \`Choice:\`." \
	"7. The Language standard places the source files. The pipeline's platform standard places only the pipeline files." \
	"8. The diagram starts at the Executor. Each code task's arrow points to the product." \
	"9. A new product's title is the implementation title. After Establish, each action joins the product whose Features hold the Establish feature. No other implementation joins it, and it joins no other product."; do
	require_in "$CODIFY" "$T" "$text"
done

code_intro="$(awk '/^### /{exit} p; /^# /{p=1}' "$SKILLS/highway-codify/references/code.md")"
for text in \
	'For a code project, these rules apply in this flow:' \
	'- Setup Instructions say how to build, configure, and run the product. User Guide says how to use its interfaces.' \
	'- The close says `The code was not run.` in place of `The automation was not run.`'; do
	printf '%s\n' "$code_intro" | grep -Fxq -- "$text" || {
		echo "FAIL: highway-codify references/code.md introduction omits: $text"
		fail=1
	}
done

P='### provider'
require_in "$CODIFY" "$P" '1. The Executor is Deployed by when the action is establishing or the product is a code project. Otherwise the Executor is Managed by.'
require_in "$CODIFY" "$P" '2. When the Executor names a platform with no row, go to `record check`. Do not show the proposal. Write nothing.'

require_in "$CODIFY" '### draft' 'For a code project, follow `code tasks`.'
require_in "$CODIFY" '### standards' "For a code project, \`code tasks\` decides a code task's list."
require_in "$CODIFY" '### join' 'When this implementation, or an implementation a product lists, is a code project, `code tasks` decides the join.'
require_in "$CODIFY" '### folder' 'For a code project, `code tasks` decides the title.'
require_in "$CODIFY" '### layout' 'For a code project, `code tasks` decides the folders.'
require_in "$CODIFY" '### propose' 'For a code project, `code tasks` decides the diagram and the **Language:** line.'
require_in "$CODIFY" '### code' 'For a code project, the code project rules at the start of this flow decide both parts.'
require_in "$CODIFY" '### close' 'For a code project, the code project rules at the start of this flow decide the not-run line.'
require_in "$CODIFY" '### revise' 'a Provider or a Language standard, at least one task'
require "$CODIFY" "writing the product's own code when the implementation names a Language."
require "$CODIFY" '- A return with the record still incomplete stops and writes nothing.'
require "$CODIFY" 'A code task shows Language in place of Provider. The Executor is Deployed by.'

reject "$CODIFY" '### platforms needed'
reject "$CODIFY" 'When this run holds a named platform'
reject "$CODIFY" 'for this single codify run'
reject "$CODIFY" 'A held platform or coding standard is never written to the implementation.'

for heading in "$R" "$C" "$P"; do
	limit "$CODIFY" "$heading" 250
done
limit "$CODIFY" "$T" 400

D='### delivery platforms'
require "$IMPL" '`delivery platforms`, with `delivery decline`, when `highway-codify` hands off an accepted implementation;'
for text in \
	'Language is unset when `Needed`, empty, or naming a standard with no row.' \
	'**Here is the proposed Deployed by, Managed by and Language for [Product Title]**' \
	'- `accept`: when Deployed by, Managed by, or Language is Needed, name that field and re-emit this view.' \
	'- `decline`: go to `delivery decline`.'; do
	require_in "$IMPL" "$D" "$text"
done

for heading in '### start' "$D"; do
	count="$(section "$IMPL" "$heading" | grep -Fxc -- '**Why it matters:** [From `why it matters`.]')"
	if [[ "$count" -ne 3 ]]; then
		echo "FAIL: highway-implementation $heading has $count Why it matters lines; expected 3"
		fail=1
	fi
done

W='### why it matters'
for text in \
	'- Deployed by names a platform: highway-codify will use [codify platform] to get [Product title] up and running.' \
	'- Deployed by is Needed: highway-codify needs a codify platform to get [Product title] up and running.' \
	'- Managed by names a platform: highway-codify will use [codify platform] for managing [Product title] once its running.' \
	'- Managed by is Needed: highway-codify needs a codify platform for managing [Product title] once its running.' \
	'- Language names a standard: highway-codify will treat [Product title] as a [Language] coding project.' \
	'- Language is None: highway-codify will treat this as a Platform to manage as opposed to a coding project to write.'; do
	require_in "$IMPL" "$W" "$text"
done
limit "$IMPL" "$W" 250

DD='### delivery decline'
for text in \
	'Leaving the preferred delivery platforms for [Title] unset. highway-codify needs these details before it can make proposals for [Title].' \
	'**Would you like to return and provide these details now?**' \
	'- A yes: re-emit the `delivery platforms` view.' \
	'- A no, or `decline`: go to the held step.'; do
	require_in "$IMPL" "$DD" "$text"
done
limit "$IMPL" "$D" 400
limit "$IMPL" "$DD" 250

require "$IMPL" 'Execution is `Deployed by: Needed`, `Managed by: Needed`, and `Language: Needed`.'
require "$IMPL" '- An onboarded implementation stores Deployed by, Managed by, and Language as `Needed`.'
reject "$ONBOARD" 'When the caller named the return step `provider` in `highway-codify`'

require "$RI_RECORD" 'Language: <Standard Title, None, or Needed>'
require "$CDY_RECORD" 'In a code project, a code task shows **Language:** with the Language standard in place of **Provider:**, and its target is the product.'
require "$CDY_RECORD" "In a code project, each code task's arrow points to the product."
require "$CDY_RECORD" 'In a code project, Setup Instructions say how to build, configure, and run the product, and User Guide says how to use its interfaces.'


if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: a complete record leads codify, and a Language makes a code project'
