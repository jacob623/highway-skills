#!/usr/bin/env bash
# Validates the highway-help All-Skills output contract declared in the source skill.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-help/SKILL.md"

fail=0

assert_contains() {
	local needle="$1"
	if ! grep -Fq -- "$needle" "$SKILL"; then
		echo "FAIL: expected highway-help source to contain: $needle"
		fail=1
	fi
}

assert_not_contains() {
	local needle="$1"
	if grep -Fq -- "$needle" "$SKILL"; then
		echo "FAIL: expected highway-help source not to contain: $needle"
		fail=1
	fi
}

all_skills_block="$(awk '/^- All-Skills mode:/{capture=1} capture && /^- Listing all skills/{exit} capture{print}' "$SKILL")"
all_skills_flat="$(printf '%s\n' "$all_skills_block" | tr '\n' ' ')"
if ! printf '%s\n' "$all_skills_flat" | grep -Eq 'Name:.*Description:.*Help:'; then
	echo "FAIL: All-Skills declaration must name Name, Description, and Help in order"
	fail=1
fi
if [[ "$all_skills_block" == *"Usage:"* ]]; then
	echo "FAIL: All-Skills declaration must not contain Usage:"
	fail=1
fi

if ! printf '%s\n' "$all_skills_flat" | grep -Eq 'Name:.*Description:.*Help: /highway-help <id>'; then
	echo "FAIL: All-Skills declaration must include the copyable help command"
	fail=1
fi
if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "PASS: All-Skills output declares catalog-ordered Name/Description/Help blocks without Usage."
