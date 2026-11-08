#!/usr/bin/env bash
# Config proposals show Recommendation under each conflict and Evidence under each new realized capability on their own bold line, after a blank line.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: restoring "Recommendation: [One change that removes it.]" inline with a conflict description, or "Evidence:" inline with Realized By, fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG="$HIGHWAY_ROOT/skills/highway-codify-config/SKILL.md"
fail=0

section() {
	awk -v h="$2" '$0 == h {p=1; next} /^##/ {p=0} p' "$1"
}

require_block() {
	local heading="$1" first="$2" label="$3" body line block expected
	body="$(section "$CONFIG" "$heading")"
	line="$(printf '%s\n' "$body" | grep -nxF -- "$first" | head -1 | cut -d: -f1)"
	if [[ -z "$line" ]]; then
		echo "FAIL: highway-codify-config $heading omits: $first"
		fail=1
		return
	fi
	block="$(printf '%s\n' "$body" | awk -v s="$line" 'NR > s && NR <= s + 2')"
	expected="$(printf '%s\n%s' '' "$label")"
	if [[ "$block" != "$expected" ]]; then
		echo "FAIL: highway-codify-config $heading does not follow \"$first\" with a blank line, then: $label"
		fail=1
	fi
}

check_words() {
	local heading="$1" limit="$2" body words
	body="$(section "$CONFIG" "$heading")"
	words="$(printf '%s\n' "$body" | wc -w | tr -d ' ')"
	if [[ -z "$body" ]] || ((words > limit)); then
		echo "FAIL: highway-codify-config $heading has $words words; the limit is $limit"
		fail=1
	fi
}

recommendation='   **Recommendation:** [One change that removes it.]'
for heading in '### platform proposal' '### standard proposal'; do
	require_block "$heading" '1. **[Conflict]:** [Description quoting both entries and naming both records.]' "$recommendation"
done
require_block '### conflicts' '1. **[Conflict]:** [Description.]' "$recommendation"
require_block '### platform proposal' '1. **[Title]:** Realized By: [Platform].' '   **Evidence:** [What the current documentation describes.]'

for text in '] Recommendation: [' '. Evidence: ['; do
	if grep -Fq -- "$text" "$CONFIG"; then
		echo "FAIL: highway-codify-config still contains: $text"
		fail=1
	fi
done

check_words '### platform proposal' 400
check_words '### standard proposal' 400
check_words '### conflicts' 250

grep -Fq 'version: 3.5.0' "$CONFIG" || {
	echo 'FAIL: highway-codify-config omits: version: 3.5.0'
	fail=1
}

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: Recommendation and Evidence sit on their own bold line'
