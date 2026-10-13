#!/usr/bin/env bash
# Contract checks for Feature 166 Objective Archetypes guidance.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact, test-harness

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SOURCE="$HIGHWAY_ROOT/skills/highway-objectives/SKILL.md"
fail=0

require_text() {
	local file="$1" text="$2" label="$3"
	if grep -Fq -- "$text" "$file"; then
		echo "OK: $label"
	else
		echo "FAIL: $label (missing '$text' in $file)" >&2
		fail=1
	fi
}

require_absent() {
	local file="$1" text="$2" label="$3"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $label (unexpected '$text' in $file)" >&2
		fail=1
	else
		echo "OK: $label"
	fi
}

require_order() {
	local file="$1" first="$2" second="$3" label="$4"
	local first_line second_line
	first_line="$(grep -nF -- "$first" "$file" | head -n1 | cut -d: -f1)"
	second_line="$(grep -nF -- "$second" "$file" | head -n1 | cut -d: -f1)"
	if [[ -z "$first_line" || -z "$second_line" || "$first_line" -ge "$second_line" ]]; then
		echo "FAIL: $label" >&2
		fail=1
	else
		echo "OK: $label"
	fi
}

if [[ ! -f "$SOURCE" ]]; then
	echo "FAIL: Objective source is missing: $SOURCE" >&2
	exit 1
fi

require_order "$SOURCE" "## Recommendation Development" "## Objective Archetypes" "Objective Archetypes follows Recommendation Development"
require_order "$SOURCE" "## Objective Archetypes" "### Objective Development Lifecycle" "Objective Archetypes precedes the Objective Development Lifecycle"

for phrase in \
	"Objective recommendations are currently derived primarily from accepted Profile evidence." \
	"Objective Archetypes exist to improve recommendation coverage." \
	"do not create organizational facts" \
	"do not establish organizational intent" \
	"do not imply organizational problems exist" \
	"do not replace Profile-grounded recommendations" \
	"##### Growth" \
	"##### Operations" \
	"##### Customer" \
	"##### Capability"; do
	require_text "$SOURCE" "$phrase" "archetype principle or family: $phrase"
done

for phrase in \
	"Generate Profile-derived recommendations first." \
	"Evaluate recommendation coverage across the four archetype families." \
	"Determine whether meaningful coverage gaps exist." \
	"When useful coverage gaps exist, generate one or more archetype-derived recommendations." \
	"Present Profile-derived and archetype-derived recommendations together as a single recommendation set."; do
	require_text "$SOURCE" "$phrase" "recommendation generation: $phrase"
done

for phrase in \
	"Do not expose archetype families to the user." \
	"Do not ask the user to choose archetypes." \
	"Do not present archetypes as categories or workflow concepts." \
	"Recommendation source is internal recommendation logic only." \
	"All recommended Objectives remain Working Ideas until" \
	"The recommendation set should feel unified regardless of recommendation source."; do
	require_text "$SOURCE" "$phrase" "presentation boundary: $phrase"
done

for phrase in \
	"When a person requests additional suggestions, evaluate both:" \
	"accepted Profile evidence;" \
	"current accepted Objective portfolio." \
	"The recommendation remains a Working Idea until adopted." \
	"recommendation coverage gaps identified through Objective Archetypes"; do
	require_text "$SOURCE" "$phrase" "additional suggestions: $phrase"
done

for phrase in \
	"Objective Archetypes do not:" \
	"establish accepted Objectives;" \
	"create readiness requirements;" \
	"create additional lifecycle stages;" \
	"change Objective ownership, persistence, or acceptance behavior."; do
	require_text "$SOURCE" "$phrase" "recommendation boundary: $phrase"
done

for phrase in \
	"keep the user-authored path available" \
	"The Objective owner is expected to develop a complete first-pass Objective proposal"; do
	require_text "$SOURCE" "$phrase" "protected existing behavior: $phrase"
done

for adapter in \
	.github/skills/highway-objectives/SKILL.md \
	.claude/skills/highway-objectives/SKILL.md \
	.cursor/skills/highway-objectives/SKILL.md \
	.agents/skills/highway-objectives/SKILL.md; do
	if [[ ! -f "$REPO_ROOT/$adapter" ]]; then
		echo "FAIL: generated adapter is missing: $adapter" >&2
		fail=1
	elif cmp -s "$SOURCE" "$REPO_ROOT/$adapter"; then
		echo "OK: generated adapter matches source: $adapter"
	else
		echo "FAIL: generated adapter differs from source: $adapter" >&2
		fail=1
	fi
done

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi

echo 'OK: Feature 166 Objective Archetypes contract passes'
