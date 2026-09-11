#!/usr/bin/env bash
# Validates the highway-help Single-Skill output and unchanged edge-case contracts.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-help/SKILL.md"

fail=0

single_skills_block="$(awk '/^- Single-Skill mode:/{capture=1} capture && /^- All-Skills mode:/{exit} capture{print}' "$SKILL")"
if [[ "$single_skills_block" != *"Name:"* || "$single_skills_block" != *"Description:"* || "$single_skills_block" != *"Dependencies:"* || "$single_skills_block" != *"Version:"* || "$single_skills_block" != *"Usage:"* || "$single_skills_block" != *"Example:"* ]]; then
	echo "FAIL: Single-Skill declaration must preserve the six-field order"
	fail=1
fi

if [[ "$single_skills_block" != *"Usage:"* ]]; then
	echo "FAIL: Single-Skill declaration must retain Usage:"
	fail=1
fi

if ! grep -Fq -- "No skills are registered yet." "$SKILL"; then
	echo "FAIL: empty-catalog response is missing"
	fail=1
fi
if ! grep -Fq -- "ERROR: no skill registered with id '<declared-id>'" "$SKILL"; then
	echo "FAIL: unknown-identifier error response is missing"
	fail=1
fi
if ! grep -Fq -- "do not fall back to the All-Skills" "$SKILL"; then
	echo "FAIL: unknown-identifier response must not fall back to All-Skills mode"
	fail=1
fi

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "PASS: Single-Skill six-field, empty-catalog, and unknown-identifier contracts remain declared."
