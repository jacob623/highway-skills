#!/usr/bin/env bash
# A codify plan review asks what to add, correct, or remove before the plan menu returns.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: removing the review question from `### review`, or restoring `Answer, then emit this menu.`, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
CODIFY="$(fl_skill_text_file "$HW_SKILLS/highway-codify")"
QUESTION='**What would you add, correct, or remove?**'
WALK='Read every section of `plan.md` with the person. Answer each question they ask along the way. Write nothing. After the last section, ask:'
fail=0

if [[ ! -f "$CODIFY" ]]; then
	echo "FAIL: highway-codify is missing"
	exit 1
fi

require() {
	grep -Fq -- "$1" "$CODIFY" || {
		echo "FAIL: highway-codify omits: $1"
		fail=1
	}
}

reject() {
	if grep -Fq -- "$1" "$CODIFY"; then
		echo "FAIL: highway-codify still contains: $1"
		fail=1
	fi
}

section() {
	awk -v h="$1" '$0 == h {p=1; next} /^##/ {p=0} p' "$CODIFY"
}

require_in() {
	local name="$1" text="$2"
	section "### $name" | grep -Fq -- "$text" || {
		echo "FAIL: highway-codify $name omits: $text"
		fail=1
	}
}

reject_in() {
	local name="$1" text="$2"
	if section "### $name" | grep -Fq -- "$text"; then
		echo "FAIL: highway-codify $name contains: $text"
		fail=1
	fi
}

heading_line() {
	grep -n "^### $1\$" "$CODIFY" | head -n 1 | cut -d: -f1
}

line_in() {
	section "### $1" | grep -nF -- "$2" | head -n 1 | cut -d: -f1
}

require '`check`, `menu`, `review` when chosen, `tasks`,'
require_in Classify 'On `review`, a change to the plan is `edit`, and "no", "nothing", or "looks good" is `accept`.'

menu=$(heading_line menu)
review=$(heading_line review)
tasks=$(heading_line tasks)
if [[ -z "$menu" || -z "$review" || -z "$tasks" ]] || [[ "$review" -le "$menu" || "$review" -ge "$tasks" ]]; then
	echo "FAIL: highway-codify ### review is missing or not between ### menu and ### tasks"
	fail=1
fi

require_in menu 'The plan is complete for feature <number>-<action>. **Would you like to:**'
require_in menu '1. Review the plan?'
require_in menu '2. Continue to code the solution?'
require_in menu '- `1`: go to `review`.'
require_in menu '- A stated edit: regenerate the plan. Go to `check`.'
require_in menu '- `2`: go to `tasks`.'
reject 'Answer, then emit this menu.'
reject_in menu "$QUESTION"
reject_in tasks "$QUESTION"

replies=(
	'- `accept`: emit the menu. Go to `menu`.'
	'- `edit`: emit one consequence sentence. Regenerate the plan. Go to `check`.'
	'- `question`: answer, then ask this question again. Stay on `review`.'
	'- `unknown`: ask this question again. Stay on `review`.'
	'- `decline`: stop. Write nothing.'
)
require_in review "$WALK"
require_in review "$QUESTION"
require_in review 'If this is accurate, just say so.'
require_in review 'Do not emit the menu with this question.'
for reply in "${replies[@]}"; do
	require_in review "$reply"
done

walk_at=$(line_in review "$WALK")
question_at=$(line_in review "$QUESTION")
reply_at=$(line_in review "${replies[0]}")
if [[ -z "$walk_at" || -z "$question_at" || -z "$reply_at" ]] || [[ "$question_at" -le "$walk_at" || "$question_at" -ge "$reply_at" ]]; then
	echo "FAIL: highway-codify review does not ask the question after the walkthrough and before the replies"
	fail=1
fi

require '- Reviewing the plan reads every section, then asks **What would you add, correct, or remove?** and "If this is accurate, just say so." before the menu returns. Accepting emits the menu, and a change regenerates the plan and runs `check`. Continuing to code asks no review question.'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: a plan review asks what to add, correct, or remove before the menu'
