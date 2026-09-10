#!/usr/bin/env bash
# Contract checks for the highway-relationships skill and its disposable relationship fixtures.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-relationships/SKILL.md"
FIXTURES="$SCRIPT_DIR/fixtures/relationship-integrity"
fail=0

assert_file() {
	local file="$1"
	if [[ ! -f "$file" ]]; then
		echo "FAIL: missing file '$file'"
		fail=1
	fi
}

assert_contains() {
	local file="$1" expected="$2"
	if ! grep -Fq "$expected" "$file"; then
		echo "FAIL: '$file' does not contain '$expected'"
		fail=1
	fi
}

assert_not_contains() {
	local file="$1" forbidden="$2"
	if grep -Fq "$forbidden" "$file"; then
		echo "FAIL: '$file' contains forbidden text '$forbidden'"
		fail=1
	fi
}

# The shipped skill and every representative fixture must exist.
assert_file "$SKILL"
for fixture in \
	"$FIXTURES/valid/controls/CTL000001.md" \
	"$FIXTURES/valid/nfrs/NFR000001.md" \
	"$FIXTURES/direct-nfr/nfrs/NFR000002.md" \
	"$FIXTURES/asymmetric/controls/CTL000002.md" \
	"$FIXTURES/asymmetric/nfrs/NFR000003.md" \
	"$FIXTURES/orphan/controls/CTL000003.md" \
	"$FIXTURES/malformed/controls/CTL000004.md" \
	"$FIXTURES/duplicate/controls/CTL000005.md" \
	"$FIXTURES/duplicate/nfrs/NFR000004.md" \
	"$FIXTURES/impact/controls/CTL000006.md" \
	"$FIXTURES/impact/nfrs/NFR000005.md" \
	"$FIXTURES/replacement/controls/CTL000007.md"; do
	assert_file "$fixture"
done

if [[ ! -f "$SKILL" ]]; then
	exit 1
fi

# Ownership and mode contract.
assert_contains "$SKILL" 'State one mode explicitly: `Inspect`, `Repair`, or `Impact`.'
assert_contains "$SKILL" "Do not use this skill to create, update, remove, or replace a Control or NFR."
assert_contains "$SKILL" 'The relationship graph is read only from the existing `nfrs` field'
assert_contains "$SKILL" 'NFR records.'
assert_contains "$SKILL" 'A direct NFR with `controls: []` is valid'

# Inspection and classification contract.
for section in \
	"Relationship Summary" \
	"Valid Relationships" \
	"Broken Relationships" \
	"Asymmetric Relationships" \
	"Orphan References" \
	"Required Repairs" \
	"Blocking Conditions"; do
	assert_contains "$SKILL" "$section"
done
for finding in valid malformed orphaned asymmetric duplicate blocked; do
	assert_contains "$SKILL" "$finding"
done
assert_contains "$SKILL" '`Inspect` is always read-only.'
assert_contains "$SKILL" "Do not write"

# Repair proposal, confirmation, and atomicity contract.
for proposal_field in \
	"current relationship state" \
	"proposed relationship state" \
	"reason for the recommendation" \
	"impact on reciprocal traceability"; do
	assert_contains "$SKILL" "$proposal_field"
done
assert_contains "$SKILL" "Ask for an explicit decision for every recommendation"
assert_contains "$SKILL" 'ambiguous or incomplete decision'
assert_contains "$SKILL" "Stage"
assert_contains "$SKILL" "zero partial writes"
assert_contains "$SKILL" 'Commit only approved changes to `Control.nfrs` and `NFR.controls`.'
assert_contains "$SKILL" "Preserve all other frontmatter"

# Destructive impact and determinism contract.
assert_contains "$SKILL" "For Control removal, NFR removal, or baseline replacement"
assert_contains "$SKILL" "A count is never sufficient."
assert_contains "$SKILL" "For identical baseline bytes and identical mode inputs"
assert_contains "$SKILL" "no timestamp"
assert_contains "$SKILL" "incidental filesystem ordering"
assert_contains "$SKILL" "This skill does not delete records"

# Fixture semantics exercise the graph cases without modifying fixture content.
assert_contains "$FIXTURES/valid/controls/CTL000001.md" "nfrs: [NFR000001]"
assert_contains "$FIXTURES/valid/nfrs/NFR000001.md" "controls: [CTL000001]"
assert_contains "$FIXTURES/direct-nfr/nfrs/NFR000002.md" "controls: []"
assert_contains "$FIXTURES/asymmetric/controls/CTL000002.md" "nfrs: [NFR000003]"
assert_contains "$FIXTURES/asymmetric/nfrs/NFR000003.md" "controls: []"
assert_contains "$FIXTURES/orphan/controls/CTL000003.md" "NFR999999"
assert_contains "$FIXTURES/malformed/controls/CTL000004.md" "NFR-not-an-id"
assert_contains "$FIXTURES/duplicate/controls/CTL000005.md" "NFR000004, NFR000004"

# Impact fixture preserves the individually named records needed by the report.
assert_contains "$FIXTURES/impact/controls/CTL000006.md" "title: Control scheduled for removal"
assert_contains "$FIXTURES/impact/nfrs/NFR000005.md" "title: Related NFR scheduled for impact analysis"
assert_contains "$FIXTURES/replacement/controls/CTL000007.md" "title: Baseline replacement candidate"

# The skill must not pretend to own future relationship types or a second store.
assert_not_contains "$SKILL" "relationship database"
assert_not_contains "$SKILL" "relationship index"

exit $fail
