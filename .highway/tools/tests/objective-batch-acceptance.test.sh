#!/usr/bin/env bash
# The guided objectives review shows the whole queue once.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: absence of the batch heading or return of the one-at-a-time bridge fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-objectives/SKILL.md"
fail=0

require() {
	local text="$1"
	grep -Fq "$text" "$SKILL" || {
		echo "FAIL: objectives skill omits: $text"
		fail=1
	}
}

require "**Here's what I've captured as your objectives:**"
require "**Success looks like:**"
require "**Why it matters:**"
require 'Put `---` between Objectives.'

if grep -Fq "**Here's what I've captured as your objective:**" "$SKILL"; then
	echo "FAIL: objectives skill still captures one objective at a time"
	fail=1
fi
if grep -Fq "Next we'll develop" "$SKILL"; then
	echo "FAIL: objectives skill still bridges into the next objective"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "PASS: objective batch acceptance"
