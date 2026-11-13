#!/usr/bin/env bash
# The skill text and scenario scripts that follow up the harness findings: a governance skill or
# highway-codify-config run on its own ends with a closing line, records keep every template
# heading, highway-codify re-shows a refused proposal, and every scenario reply is keyed to the
# question it answers.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring `accept`: return `Finished`. Emit nothing else. in a governance
# `review`, or adding `ask-pattern: \?` to any scenario, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/flows.sh
source "$HW_LIB/flows.sh"
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

# --- F7: a governance skill run on its own ends with a closing line ----------------------------

governance() {
	local skill="$1" one="$2" many="$3" version="$4"
	require_in "$skill" '## Procedure' 'then `capture`, then `identifier`, `title` when needed, and `write`. Both paths end at `close`.'
	require_in "$skill" '### review' '- `accept`: go to `close`.'
	require_in "$skill" '## Outputs' '- One closing line after review acceptance or a successful guided write, when the person ran this skill directly.'
	require_in "$skill" '### close' 'When `highway-setup` delegated this skill, return `Finished`. Emit nothing else.'
	require_in "$skill" '### close' "Otherwise emit one line and stop. When at least one $one is active, emit:"
	require_in "$skill" '### close' "Your $many are recorded."
	require_in "$skill" '### close' "When no $one is active, emit:"
	require_in "$skill" '### close' "No $many are recorded yet. Run $skill when you have one to add."
	require_in "$skill" '### ask' '- `decline`: write the empty catalog described in `write`. Go to `close`.'
	require_in "$skill" '### write' 'On success, go to `close`.'
	reject_in "$skill" '### write' 'On success, emit nothing.'
	reject_in "$skill" '### write' 'Do not add a closing line.'
	reject_in "$skill" '### review' '- `accept`: return `Finished`. Emit nothing else.'
	reject_in "$skill" '### ask' 'Return `Finished`. Emit nothing else.'
	require_in "$skill" '## Verification' '- Acceptance of that review goes to `close`.'
	require_in "$skill" '## Verification' '- Run by `highway-setup`, `close` returns `Finished` and emits nothing else. Run directly, it emits one closing line and no question.'
	require_in "$skill" '## Verification' '- A successful guided write goes to `close` and does not show the stored records.'
	reject_in "$skill" '## Verification' 'Acceptance of that review returns `Finished` and emits nothing else.'
	version_is "$skill" "$version"
}

governance highway-objectives Objective Objectives 8.8.0
governance highway-controls Control Controls 8.8.0
governance highway-nfrs NFR NFRs 9.9.0

require_in highway-codify-config '### How would you like to configure Highway Codify?' '- `decline`: when a return step is held, go to that step in its skill. Otherwise emit `Your platforms and coding standards are up to date.` Write nothing. Stop.'
version_is highway-codify-config 3.12.0

# --- F18: a record keeps every template heading and table header row --------------------------

keep_line() {
	printf '%s' "- Keep every heading and table header row of \`assets/$1\`, in order, even when a section has no content. Write \`None\` under a section with no content, after its table header row when it has one."
}

require_in highway-discovery '### write' "$(keep_line discovery-record.md)"
require_in highway-adr '### write' "$(keep_line adr-record.md)"
require_in highway-adr '### onboarding' '- The record keeps every heading of a Discovery-backed ADR, as `write` says, including `## Decision Confidence`.'
reject_in highway-adr '### onboarding' '- The record uses every section a Discovery-backed ADR uses.'
version_is highway-discovery 5.8.0
version_is highway-adr 6.8.0

# --- F15 and F5: a refused edit re-shows the proposal; a bare invocation is not a catalog request ---

require_in highway-codify '### revise' 'An edit that would break a listed Control or NFR is not applied. Say: [Title] stays in effect. To change a Control, run highway-controls. To change an NFR, run highway-nfrs. Then re-emit the proposal and stay on `revise`.'
require_in highway-codify '### Entry' '2. When the invocation is the word `catalog`, or asks to show the code catalog, go to `catalog`. Do not resume a task list or select an implementation. An invocation that names nothing is not a catalog request.'
version_is highway-codify 14.9.0

# --- F3, F16, F21, F5: every scenario reply answers the question it was written for ------------

SCEN="$HW_HARNESS/scenarios"
catchall="$(grep -rlE '^ask-pattern: (\\\?|\.|\.\*|\.\+)[[:space:]]*$' "$SCEN" --include='*.scenario' || true)"
if [[ -n "$catchall" ]]; then
	echo 'FAIL: a scenario keys a reply to any question:'
	printf '%s\n' "$catchall" | sed 's/^/    /'
	fail=1
fi

require_file "$SCEN/highway-assessment/assessment-smoke.scenario" 'ask: Where would you like to go next?'
for s in codify-control-unmet codify-standard-unmet; do
	require_file "$SCEN/highway-codify/$s.scenario" 'ask-pattern: different action|explore any of these options'
done

smoke_closes() {
	local file="$SCEN/$1" expect="$2" shows="$3"
	require_file "$file" "$expect"
	require_file "$file" "$shows"
	if grep -Eq '^expect: contains ' "$file"; then
		echo "FAIL: $(hw_rel "$file") still checks the fixture's own record with contains"
		fail=1
	fi
}
smoke_closes highway-controls/controls-smoke.scenario 'expect: contains-any library/governance/controls/*.md :: two-factor' 'shows: Your Controls are recorded.'
smoke_closes highway-nfrs/nfrs-smoke.scenario 'expect: contains-any library/governance/nfrs/*.md :: two seconds' 'shows: Your NFRs are recorded.'
smoke_closes highway-objectives/objectives-smoke.scenario 'expect: contains-any library/objectives/*.md :: repeat' 'shows: Your Objectives are recorded.'

for f in highway-onboarding/onboarding-smoke highway-implementation/chain-implementation highway-implementation/implementation-onboards-platform; do
	file="$SCEN/$f.scenario"
	infer="$(grep -cFx 'ask-pattern: unable to infer a platform' "$file")"
	who="$(grep -cFx 'ask-pattern: Who builds or runs' "$file")"
	if [[ "$infer" -ne 2 || "$who" -ne 2 ]]; then
		echo "FAIL: $(hw_rel "$file") does not answer two Unknown providers ($infer unable-to-infer, $who provider questions)"
		fail=1
	fi
	require_file "$file" 'say: No one.'
done

require_file "$SCEN/highway-codify/codify-configure.scenario" 'open: Use highway-codify with the word configure.'
require_file "$SCEN/highway-codify/codify-configure.scenario" 'shows: To configure platforms and coding standards, run highway-codify-config.'

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: the skill text and scenarios follow up the harness findings'
