#!/usr/bin/env bash
# highway-onboarding hands each provider to highway-adr, then highway-architecture, then
# highway-implementation, through each owner's onboarding step, and holds no record rules itself.
# Each owner writes its record without a question, except the architecture and implementation title
# questions; highway-architecture's name step records the architecture in the ADR catalog; and the
# implementation step returns only to onboarding.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: a copy of highway-adr without its routing sentence to `onboarding` fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
ADR="$HW_SKILLS/highway-adr/SKILL.md"
ARCH="$HW_SKILLS/highway-architecture/SKILL.md"
IMPL="$HW_SKILLS/highway-implementation/SKILL.md"
ONBOARD="$HW_SKILLS/highway-onboarding/SKILL.md"
fail=0

# step <file> <heading>: the lines of one ### step.
step() {
	awk -v h="$2" '$0 == h {p=1; next} p && /^##/ {exit} p' "$1"
}

# missing <file> <text>: prints the text when the file lacks it.
missing() {
	grep -Fq -- "$2" "$1" || printf '%s lacks: %s\n' "$(basename "$(dirname "$1")")" "$2"
}

# step_missing <file> <heading> <text>: prints the text when that step lacks it.
step_missing() {
	step "$1" "$2" | grep -Fq -- "$3" || printf '%s %s lacks: %s\n' "$(basename "$(dirname "$1")")" "$2" "$3"
}

# present <file> <text>: prints the text when the file still has it.
present() {
	if grep -Fq -- "$2" "$1"; then
		printf '%s still has: %s\n' "$(basename "$(dirname "$1")")" "$2"
	fi
}

report() {
	[[ -n "$1" ]] || return 0
	printf 'FAIL: %s\n' "$1"
	fail=1
}

# adr_checks <file>: the highway-adr side of the handoff.
adr_checks() {
	missing "$1" 'When `highway-onboarding` hands off a provider, go to `onboarding`.'
	step_missing "$1" '### onboarding' 'Write the ADR as accepted without asking the person.'
	step_missing "$1" '### onboarding' 'add the provider name to the title and derive the id again. Do not ask.'
	step_missing "$1" '### onboarding' '`request` is `onboarding`. `discovery` is `highway`.'
	step_missing "$1" '### onboarding' 'Selection Source as `Accepted onboarding mapping`'
	step_missing "$1" '### onboarding' 'Do not ask whether a decision replaces or runs beside another.'
	step_missing "$1" '### onboarding' 'Return to `highway-onboarding` and say the ADR could not be written.'
	missing "$1" 'Each Discovery ID appears on at most one row, except `highway`'
	missing "$1" 'assets/adr-record.md'
	present "$1" 'architecture-record.md'
}

while IFS= read -r line; do report "$line"; done < <(adr_checks "$ADR")

# highway-architecture: the onboarding step, its two questions, and the ADR catalog Architecture ID.
while IFS= read -r line; do report "$line"; done < <(
	missing "$ARCH" 'When `highway-onboarding` hands off an accepted ADR id, go to `onboarding`.'
	step_missing "$ARCH" '### onboarding' 'Write the architecture as accepted without asking the person, except for the questions in step 4.'
	step_missing "$ARCH" '### onboarding' 'Ask only these:'
	step_missing "$ARCH" '### onboarding' 'A `decline` writes nothing and returns to `highway-onboarding` without an architecture.'
	step_missing "$ARCH" '### onboarding' 'Do not write Key Technologies.'
	step_missing "$ARCH" '### onboarding' 'Do not go to `close`.'
	step_missing "$ARCH" '### name' "and that ADR's Architecture ID in \`adrs/adrs.md\` to the same id"
	missing "$ARCH" 'confirm these seeded files exist: `adrs/adrs.md`, `architectures/architectures.md`.'
	missing "$ARCH" 'assets/architecture-record.md'
	present "$ARCH" 'adr-record.md'
)

# highway-implementation: the onboarding step, its one question, and the nested return.
while IFS= read -r line; do report "$line"; done < <(
	missing "$IMPL" 'When `highway-onboarding` hands off an accepted `RA` id, a provider, and the capabilities it serves, go to `onboarding`.'
	step_missing "$IMPL" '### onboarding' 'This visit returns only to `highway-onboarding`. Do not go to a step another `highway-implementation` visit holds.'
	step_missing "$IMPL" '### onboarding' 'Execution is `Deployed by: Needed`, `Managed by: Needed`, and `Language: Needed`.'
	step_missing "$IMPL" '### onboarding' 'Ask only the `title` message'
	step_missing "$IMPL" '### onboarding' 'A `decline` writes nothing and returns to `highway-onboarding` without an implementation.'
	step_missing "$IMPL" '### onboarding' 'Follow `platforms`.'
	step_missing "$IMPL" '### platforms' 'When `onboarding` follows this step, return to `highway-onboarding` instead of going to `close`.'
	missing "$IMPL" 'assets/implementation-record.md'
)

# highway-onboarding: hands off in order, retries once, and holds no record rules or templates.
while IFS= read -r line; do report "$line"; done < <(
	step_missing "$ONBOARD" '### orchestrate' 'Ask the person nothing yourself.'
	step_missing "$ONBOARD" '### orchestrate' "follow that owner's \`onboarding\` once more"
	step_missing "$ONBOARD" '### orchestrate' 'When the person declines a title an owner asks for'
	step_missing "$ONBOARD" '### orchestrate' 'Do not ask to configure. Do not continue the queue.'
	step_missing "$ONBOARD" '### review' 'Update that record in its existing structure.'
	for text in \
		'Derive the id from that title.' \
		'a 0, b 1, c 2' \
		'templates/output' \
		'assets/' \
		'Do not use `highway-adr`' \
		'The architecture uses an `RA` id.' \
		'The implementation uses an `RI` id' \
		'Selection Source as' \
		'follow `platforms` in `highway-implementation`'; do
		present "$ONBOARD" "$text"
	done
)
adr_line="$(grep -nF 'Follow `onboarding` in `highway-adr`' "$ONBOARD" | head -n 1 | cut -d: -f1)"
arch_line="$(grep -nF 'Follow `onboarding` in `highway-architecture`' "$ONBOARD" | head -n 1 | cut -d: -f1)"
impl_line="$(grep -nF 'Follow `onboarding` in `highway-implementation`' "$ONBOARD" | head -n 1 | cut -d: -f1)"
if [[ -z "$adr_line" || -z "$arch_line" || -z "$impl_line" ]] || ((adr_line >= arch_line || arch_line >= impl_line)); then
	report "highway-onboarding does not hand off to highway-adr, highway-architecture, then highway-implementation"
fi

# Seeded probe: highway-adr without its routing sentence fails the highway-adr checks.
probe_dir="$(mktemp -d)"
trap 'rm -rf "$probe_dir"' EXIT
mkdir -p "$probe_dir/highway-adr"
grep -vF 'When `highway-onboarding` hands off a provider, go to `onboarding`.' "$ADR" >"$probe_dir/highway-adr/SKILL.md"
if [[ -z "$(adr_checks "$probe_dir/highway-adr/SKILL.md")" ]]; then
	report "probe: highway-adr without its routing sentence passed"
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: onboarding hands each record to its owner"
