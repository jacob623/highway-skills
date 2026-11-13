#!/usr/bin/env bash
# The skill text that resolves the harness findings: a title in the opening selects its record, pasted
# material is used, the storage contract decides absence by exact path, onboarding's unknown leads
# forward, one state asks one question, and highway-implementation marks its reply lists.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring any pinned line, such as onboarding's `unknown` that re-emits the
# block, or removing a `Classify the reply:` line from highway-implementation, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
STORAGE="$(hw_doc storage)"
fail=0

text() {
	fl_skill_text_file "$HW_SKILLS/$1"
}

section() {
	awk -v h="$2" '$0 == h {p=1; next} /^##/ {p=0} p' "$1"
}

require_in() {
	local skill="$1" heading="$2" line="$3"
	section "$(text "$skill")" "$heading" | grep -Fq -- "$line" || {
		echo "FAIL: $skill $heading omits: $line"
		fail=1
	}
}

reject_in() {
	local skill="$1" heading="$2" line="$3"
	if section "$(text "$skill")" "$heading" | grep -Fq -- "$line"; then
		echo "FAIL: $skill $heading still contains: $line"
		fail=1
	fi
}

require_file() {
	local file="$1" line="$2"
	grep -Fq -- "$line" "$file" || {
		echo "FAIL: $(hw_rel "$file") omits: $line"
		fail=1
	}
}

version_is() {
	local skill="$1" version="$2"
	grep -Fxq "  version: $version" "$HW_SKILLS/$skill/SKILL.md" || {
		echo "FAIL: $skill is not at version $version"
		fail=1
	}
}

# --- F1: a title in the opening selects its record ---------------------------------------------

require_in highway-adr '### Entry' '1. Read the invocation for one Discovery id and one option id. When it has no Discovery id and contains the exact title of one waiting Discovery, as `choose-discovery` defines it, that Discovery'"'"'s id is present. Compare without regard to case.'
require_in highway-architecture '### Entry' '1. Read the invocation for one ADR id. When it has no ADR id and contains the exact title of one waiting ADR, as `choose` defines it, that ADR'"'"'s id is present. Compare without regard to case.'
require_in highway-discovery '### Entry' '1. Read the invocation for one Request id or one Discovery id. When it has neither, and contains the exact title of one Discovery that is ready to explore, as `choose` defines it, that Discovery'"'"'s id is present. Otherwise, when it contains the exact title of one Request that is ready to analyze, that Request'"'"'s id is present. Compare without regard to case.'
require_in highway-implementation '### Entry' '3. Read the invocation for one Reference Architecture id. When it has none and contains the exact title of one accepted architecture, that architecture'"'"'s id is present. Compare without regard to case.'

# --- F2: pasted material is supplied material ---------------------------------------------------

require_in highway-profile '### offer' '- The person has nothing: go to `identity.ask`.'
require_in highway-profile '### offer' '- Text, with or without a link: the text is supplied material for every domain. Store a link in it as Organization URL and retrieve it. When the link cannot be read, say so once and continue with the text. Go to `identity.review` when the material supports at least one Identity finding. Otherwise go to `identity.ask`.'
require_in highway-profile '### offer' '- A link or document with no other text: retrieve it. Store a supplied link as Organization URL. Go to `identity.review` when it supports at least one Identity finding. Otherwise go to `identity.ask`.'
require_in highway-profile '### offer' '- A link with no other text, when retrieval is unavailable: go to `identity.ask`. Do not mention the missing retrieval.'
require_in highway-profile '### offer' "Facts from supplied material stay proposed until accepted in that domain's proposal."
reject_in highway-profile '### offer' '- Retrieval is unavailable: go to `identity.ask`.'
require_in highway-profile '## Error Handling' '- Pasted text is supplied material. A link in it that cannot be read is named once, and the skill continues with the text.'
require_in highway-profile '## Error Handling' '- A link with no other text and no retrieval continues at `identity.ask` without mentioning the missing capability.'

# --- F6, F10, F12: the storage contract decides absence by exact path ---------------------------

require_file "$STORAGE" 'Version `1.2.0`.'
require_file "$STORAGE" '"Read a file" and "Check a file exists" act on the exact path. A search or pattern tool does not decide whether a file exists. A file is absent only when one of those two operations reports it absent at its path.'
require_file "$STORAGE" 'A folder is created by writing a file in it.'
section "$STORAGE" '## What a skill does not do' | grep -Fxq -- '- Run a shell command.' || {
	echo 'FAIL: the storage contract does not list running a shell command'
	fail=1
}
section "$STORAGE" '## What a skill does not do' | grep -Fxq -- '- Decide that a file is absent from a search or pattern result.' || {
	echo 'FAIL: the storage contract does not list deciding absence from a search'
	fail=1
}
version_is highway-experience 1.2.0

require_in highway-objectives '### Entry' '1. Read `library/governance/objectives.md`. Then read each record it indexes at `library/objectives/[ID].md`, with "Read a file".'
require_in highway-controls '### Entry' '1. Read `library/governance/controls.md`. Then read each active record it indexes at `library/governance/controls/[ID].md`, with "Read a file".'
require_in highway-nfrs '### Entry' '1. Read `library/governance/nfrs.md`. Then read each active record it indexes at `library/governance/nfrs/[ID].md`, with "Read a file".'

# --- F5: once the queue holds titles, every set asks whether to review ---------------------------

queue_question() {
	local skill="$1" holds="$2" empty="$3"
	require_in "$skill" '### queue' "$holds"
	reject_in "$skill" '### queue' "$empty"
}
queue_question highway-objectives \
	'**Would you like to select any of these outcomes, modify them, or are you ready to review the selected objectives?**' \
	'**Which of these outcomes would you like to pursue, or what would you like to focus on?**'
queue_question highway-controls \
	'**Would you like to select any of these safeguards, modify them, or are you ready to review the selected Controls?**' \
	'**Which of these safeguards would you like to establish, or what would you like to focus on?**'
queue_question highway-nfrs \
	'**Would you like to select any of these operational expectations, modify them, or are you ready to review the selected NFRs?**' \
	'**Which of these operational expectations would you like to establish, or what would you like to focus on?**'

# --- F4: onboarding's unknown leads forward -------------------------------------------------------

require_in highway-onboarding '### map' 'Cursor, VS Code, GitHub Copilot, Claude, and Codex are names the session may identify.'
require_in highway-onboarding '### map' '- `unknown`: when the provider is `Unknown`, emit the provider question below instead of this block. Otherwise re-emit this block. Stay on `map`.'
require_in highway-onboarding '### map' '**Who builds or runs [Capability title] today?**'
require_in highway-onboarding '### map' "If no one does, just say so and I'll mark the provider as Does not exist."
require_in highway-onboarding '### map' '- No one, or `unknown`: set the provider to `Does not exist`. Re-emit this block. Stay on `map`.'
reject_in highway-onboarding '### map' '- `unknown`: re-emit this block, including the unable-to-infer line. Stay on `map`.'

# --- F4: codify shows the menu before the plan -----------------------------------------------------

require_in highway-codify '### check' '5. When none qualify, go to `menu`. Do not show the plan until the person selects 1. Do not say the check ran.'

# --- F9: highway-implementation marks each reply list as an instruction ----------------------------

IMPL_TEXT="$(text highway-implementation)"
unmarked="$(awk '
	/^```/ { fence = !fence; next }
	fence { next }
	/^- / {
		if (!group) { group = 1; start = prev; reply = 0 }
		if ($0 ~ /`(accept|edit|decline|unknown|question|select)`[^:]*:/) reply = 1
		next
	}
	/^[[:space:]]+[^[:space:]]/ && group { next }
	/^$/ { next }
	{
		if (group && reply && start != "Classify the reply:" && start != "Classify the latest reply before any other action.") print start
		group = 0; prev = $0
	}
	END { if (group && reply && start != "Classify the reply:" && start != "Classify the latest reply before any other action.") print start }
' "$IMPL_TEXT")"
if [[ -n "$unmarked" ]]; then
	echo 'FAIL: highway-implementation has a reply list not introduced by "Classify the reply:", after:'
	printf '%s\n' "$unmarked" | sed 's/^/    /'
	fail=1
fi
marked="$(grep -cFx 'Classify the reply:' "$IMPL_TEXT")"
if [[ "$marked" -ne 6 ]]; then
	echo "FAIL: highway-implementation has $marked \"Classify the reply:\" lines, expected 6"
	fail=1
fi
require_in highway-implementation '### field' "2. When the name has an accepted implementation and no row, emit \"Let's configure [Platform].\" Then follow \`highway-codify-config\` for [Platform], with the return step \`execution\` in \`highway-implementation\`."
require_in highway-implementation '### field' "3. When the name has no accepted implementation, emit \"Let's onboard [Platform].\" Then follow \`highway-onboarding\` for [Platform], with the return step \`execution\` in \`highway-implementation\`."
require_in highway-implementation '### start' '- `accept`: when Deployed by or Managed by is Needed, name that field and re-emit this block. When a stated responsibility is neither covered nor marked not applicable, name it and re-emit this block. In both cases stay on `start`. Otherwise go to `identifier`.'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: the skill text resolves the harness findings'
