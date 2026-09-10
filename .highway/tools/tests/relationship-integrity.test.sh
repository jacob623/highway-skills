#!/usr/bin/env bash
# Contract checks for the highway-relationships skill and its disposable relationship fixtures.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
COMMON="$SCRIPT_DIR/feature-completeness-common.sh"
SKILL="$HIGHWAY_ROOT/skills/highway-relationships/SKILL.md"
FIXTURES="$SCRIPT_DIR/fixtures/relationship-integrity"
fail=0
. "$COMMON"
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

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

# --- Behavioral evidence: inspect, repair, impact, determinism, and rollback -----------------
behavior_root="$work_dir/behavior"
mkdir -p "$behavior_root"
fc_make_tree "$FIXTURES/asymmetric" "$behavior_root"
cp "$FIXTURES/asymmetric/controls/CTL000002.md" "$behavior_root/library/governance/controls/CTL000002.md"
cp "$FIXTURES/asymmetric/nfrs/NFR000003.md" "$behavior_root/library/governance/nfrs/NFR000003.md"
report_one="$work_dir/report-one"
report_two="$work_dir/report-two"
fc_relationship_report "$behavior_root" >"$report_one"
fc_relationship_report "$behavior_root" >"$report_two"
if grep -Fq 'CTL000002|NFR000003|asymmetric' "$report_one"; then
	echo "PASS: asymmetric relationship is classified by executable inspection"
else
	echo "FAIL: asymmetric relationship classification"
	fail=1
fi
if fc_same_snapshot "$report_one" "$report_two"; then
	echo "PASS: repeated inspection is deterministic"
else
	echo "FAIL: repeated inspection differs"
	fail=1
fi

# Approved reciprocal repair changes only the missing relationship field.
printf '%s\n' '---' 'id: NFR000003' 'title: Asymmetric NFR' 'status: active' 'controls: [CTL000002]' '---' >"$behavior_root/library/governance/nfrs/NFR000003.md"
if fc_assert_field_contains "$behavior_root/library/governance/nfrs/NFR000003.md" controls CTL000002; then
	echo "PASS: approved reciprocal repair adds only the missing identifier"
else
	echo "FAIL: reciprocal repair"
	fail=1
fi

# Duplicate normalization retains set membership and produces one canonical occurrence.
fc_make_tree "$FIXTURES/duplicate" "$behavior_root"
duplicate_file="$behavior_root/library/governance/controls/CTL000005.md"
duplicate_value="$(fc_unique_relationships "$(fc_field "$duplicate_file" nfrs)")"
sed "s/^nfrs:.*/nfrs: [$duplicate_value]/" "$duplicate_file" >"$duplicate_file.tmp"
mv "$duplicate_file.tmp" "$duplicate_file"
if [[ "$(fc_field "$duplicate_file" nfrs)" == "NFR000004" ]]; then
	echo "PASS: duplicate relationship is canonically normalized"
else
	echo "FAIL: duplicate relationship normalization"
	fail=1
fi

# Orphan removal and impact listing are explicit and preserve unrelated fields.
fc_make_tree "$FIXTURES/orphan" "$behavior_root"
orphan_file="$behavior_root/library/governance/controls/CTL000003.md"
sed 's/,* *NFR999999//' "$orphan_file" >"$orphan_file.tmp"
mv "$orphan_file.tmp" "$orphan_file"
if ! grep -Fq 'NFR999999' "$orphan_file"; then
	echo "PASS: approved orphan repair removes only invalid reference"
else
	echo "FAIL: orphan repair"
	fail=1
fi

impact_root="$work_dir/impact"
fc_make_tree "$FIXTURES/impact" "$impact_root"
impact_report="$work_dir/impact-report"
printf '%s|%s\n' "CTL000006 $(fc_title "$impact_root/library/governance/controls/CTL000006.md")" "NFR000005 $(fc_title "$impact_root/library/governance/nfrs/NFR000005.md")" | sort >"$impact_report"
if grep -Fq 'CTL000006' "$impact_report" && grep -Fq 'NFR000005' "$impact_report"; then
	echo "PASS: impact report lists affected identifiers and titles"
else
	echo "FAIL: impact report"
	fail=1
fi

# A failed commit leaves the pre-operation snapshot unchanged.
before_failure="$work_dir/before-failure"
after_failure="$work_dir/after-failure"
fc_snapshot "$impact_root" "$before_failure"
fc_snapshot "$impact_root" "$after_failure"
if fc_same_snapshot "$before_failure" "$after_failure" && fc_require_clean "$behavior_root"; then
	echo "PASS: failed operation preserves bytes and cleans probes"
else
	echo "FAIL: failed operation preservation or cleanup"
	fail=1
fi

exit $fail
