#!/usr/bin/env bash
# The setup welcome ends with an overview of setup before Profile.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: a standalone "Let's get started." line or a literal overview heading fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0

require() {
	local text="$1"
	grep -Fxq -- "$text" "$SKILL" || {
		echo "FAIL: setup omits: $text"
		fail=1
	}
}

require 'Welcome to Highway'
require '*Turn organizational knowledge into connected decisions.*'
require '**Your context stays yours.**'
require 'Highway builds on information you choose to accept into your repository. Your repository remains the authoritative source of truth, and you retain ownership of the context and artifacts created through Highway.'
require "During setup we'll:"
require "- **Learn about your organization**, where you'd like to go, how you plan to get there, and what principles guide decisions."
require '- **Identify important business outcomes** worth pursuing.'
require '- **Establish safeguards** that future technology decisions should respect.'
require '- **Define operational expectations** for how future solutions should behave.'
require "You don't need to have everything figured out in advance. We'll build this foundation together, and you can refine it over time as your organization evolves."
require "Now, let's get started."

grep -Fq "Emit \"Welcome to Highway\" as a level-2 heading and \"During setup we'll:\" as a level-3 heading." "$SKILL" || {
	echo 'FAIL: setup does not name the overview heading level'
	fail=1
}

if grep -Fxq "Let's get started." "$SKILL"; then
	echo "FAIL: setup keeps the standalone Let's get started. line"
	fail=1
fi

if grep -q '^#\{1,6\} During setup' "$SKILL"; then
	echo 'FAIL: setup writes the overview heading as a literal heading'
	fail=1
fi

closing="$(grep -Fx -A 4 "Now, let's get started." "$SKILL" | tr '\n' '|')"
if [[ "$closing" != "Now, let's get started.||---||Then delegate \`highway-profile\`.|" ]]; then
	echo 'FAIL: the closing rule does not precede the Profile handoff'
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: setup welcome overview'
