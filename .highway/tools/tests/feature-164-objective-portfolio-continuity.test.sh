#!/usr/bin/env bash
# Contract checks for Feature 164 Objective portfolio continuity guidance.
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
	local content
	content="$(tr '\n' ' ' < "$file" | tr -s ' ')"
	if printf '%s' "$content" | grep -Fq -e "$text"; then
		echo "OK: $label"
	else
		echo "FAIL: $label (missing '$text' in $file)" >&2
		fail=1
	fi
}

require_absent() {
	local file="$1" text="$2" label="$3"
	if grep -Fq -e "$text" "$file"; then
		echo "FAIL: $label (unexpected '$text' in $file)" >&2
		fail=1
	else
		echo "OK: $label"
	fi
}

if [[ ! -f "$SOURCE" ]]; then
	echo "FAIL: Objective source is missing: $SOURCE" >&2
	exit 1
fi

for phrase in \
	"## Objective Portfolio Assessment Guidance" \
	"After an Objective is captured, the owner may provide a brief synthesis of the accepted Objective set." \
	"describe the current coverage provided by accepted Objectives" \
	"explain how the newly accepted Objective fits within the current Objective portfolio" \
	"remain concise" \
	"avoid repeating the full contents of accepted Objectives" \
	"When processing an active Objective queue, the synthesis may also identify the next Objective being developed." \
	"The synthesis is advisory." \
	"a second review" \
	"a second proposal" \
	"a recommendation set" \
	"a detailed portfolio assessment"; do
	require_text "$SOURCE" "$phrase" "synthesis guidance: $phrase"
done

for phrase in \
	"Your accepted Objectives now cover community development and curriculum distribution." \
	"Next we'll develop Scale Craft Kit Production and Fulfillment." \
	"Your accepted Objectives now cover curriculum distribution, kit fulfillment, and local studio engagement." \
	"If you'd like additional suggestions, just let me know." \
	"Is there another objective you'd like to capture?" \
	"Your accepted Objectives now cover curriculum, production, partnerships, and community development." \
	"Now let's establish the safeguards that should guide future technology decisions."; do
	require_text "$SOURCE" "$phrase" "continuity example: $phrase"
done

for phrase in \
	"After each queued Objective is captured" \
	"before asking the collection continuation question" \
	"Readiness becoming Complete does not end setup or configure" \
	"Existing Objective records" \
	"successful atomic persistence" \
	"Repository Context Participating Skill"; do
	require_text "$SOURCE" "$phrase" "protected transition boundary: $phrase"
done

for phrase in \
	"does not create a new lifecycle state" \
	"does not create a durable portfolio artifact"; do
	require_text "$SOURCE" "$phrase" "no new continuity mechanism: $phrase"
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

echo "OK: Feature 164 Objective portfolio continuity contract passes"
