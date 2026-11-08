#!/usr/bin/env bash
# The highway-implementation delivery platforms view proposes each unset field with the execution rules.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: removing step 3 from ### delivery platforms, or restoring "5. Return to `start`." in ### execution, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
IMPL="$HIGHWAY_ROOT/skills/highway-implementation/SKILL.md"
fail=0

section() {
	awk -v h="$2" '$0 == h {p=1; next} /^##/ {p=0} p' "$1"
}

require_in() {
	local heading="$1" text="$2"
	section "$IMPL" "$heading" | grep -Fq -- "$text" || {
		echo "FAIL: highway-implementation $heading omits: $text"
		fail=1
	}
}

E='### execution'
D='### delivery platforms'

require_in "$E" "A row with a blank Kind is not a candidate. This implementation's row is not a candidate."
require_in "$E" '5. Return to the step that named this one.'
if section "$IMPL" "$E" | grep -Fq -- '5. Return to `start`.'; then
	echo "FAIL: highway-implementation $E still returns only to start"
	fail=1
fi

require_in "$D" "3. Hold the record's value for each Execution field. Deployed by and Managed by are unset when \`Needed\`, empty, or naming a platform with no row. Language is unset when \`None\` or empty. Hold the \`execution\` value for each unset field. A value the person named in this visit replaces the held value."
require_in "$D" '4. Emit:'
require_in "$D" 'Otherwise rewrite the three Execution lines with the held fields. Change no other byte.'

require_in '## Verification' "- The delivery platforms view holds the record's fields, then the \`execution\` value for each unset one: Deployed by or Managed by that is \`Needed\`, empty, or has no row, and Language that is \`None\` or empty. A value the person named in the visit replaces it. This implementation's row is never a candidate."

for heading in "$E" "$D"; do
	words="$(section "$IMPL" "$heading" | wc -w | tr -d ' ')"
	if [[ "$words" -eq 0 || "$words" -gt 250 ]]; then
		echo "FAIL: highway-implementation $heading has $words words; the limit is 250"
		fail=1
	fi
	for word in 'so that' 'because' 'in order to' 'should' 'consider' 'prefer' 'usually' 'where appropriate'; do
		if section "$IMPL" "$heading" | grep -Fiwq -- "$word"; then
			echo "FAIL: highway-implementation $heading uses: $word"
			fail=1
		fi
	done
done

grep -Fq 'version: 7.7.0' "$IMPL" || {
	echo 'FAIL: highway-implementation omits: version: 7.7.0'
	fail=1
}

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: delivery platforms proposes each unset field from execution'
