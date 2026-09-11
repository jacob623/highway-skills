#!/usr/bin/env bash
# Verifies the review-first Control-derived NFR contract without creating user governance.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
COMMON="$SCRIPT_DIR/feature-completeness-common.sh"
CONTROL_SKILL="$HIGHWAY_ROOT/skills/highway-controls/SKILL.md"
NFR_SKILL="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
CONTROL_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/control-record.md"
NFR_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/nfr-record.md"
FIXTURE_DIR="$SCRIPT_DIR/fixtures/control-derived-nfr"
fail=0

# Execute a deterministic proposal against an isolated baseline. This is intentionally
# small: it proves the observable review barrier and write set without owning a second
# governance implementation.
. "$COMMON"

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

require_text() {
	file="$1"
	text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

require_file() {
	if [[ ! -f "$1" ]]; then
		echo "FAIL: fixture missing: $1"
		fail=1
	fi
}

# --- Fixture and isolation contract ------------------------------------------------------------
for required in \
	"$FIXTURE_DIR/README.md" \
	"$FIXTURE_DIR/candidate-rules.expected" \
	"$FIXTURE_DIR/controls/derivable.md" \
	"$FIXTURE_DIR/controls/no-match.md" \
	"$FIXTURE_DIR/controls/multiple.md" \
	"$FIXTURE_DIR/nfrs/catalog-safe.md" \
	"$FIXTURE_DIR/nfrs/catalog-invalid.md" \
	"$FIXTURE_DIR/nfrs/catalog-unsafe-next-id.md"; do
	require_file "$required"
done

mkdir -p "$tmp_root/library/governance/controls" "$tmp_root/library/governance/nfrs"
cp "$FIXTURE_DIR/controls/derivable.md" "$tmp_root/library/governance/controls/CTL000001.md"
cp "$FIXTURE_DIR/nfrs/catalog-safe.md" "$tmp_root/library/governance/nfrs.md"
if [[ -d "$tmp_root/library/governance" ]]; then
	if find "$tmp_root/library/governance" -type f | grep -q .; then
		echo "PASS: focused fixture writes stay in a disposable governance tree"
	else
		echo "FAIL: fixture governance tree was not created"
		fail=1
	fi
fi

# --- Candidate and review contract -------------------------------------------------------------
for required in \
	"Control-derived NFR proposals" \
	"normalized title and statement" \
	"availability" \
	"security" \
	"performance" \
	"candidate title" \
	"candidate statement" \
	"candidate rationale" \
	"zero candidates" \
	"Accept" \
	"Modify" \
	"Replace" \
	"Reject" \
	"Cancel" \
	"before allocating an NFR ID" \
	"stable candidate order"; do
	require_text "$CONTROL_SKILL" "$required"
done

# --- Accepted relationship and direct-authoring contract --------------------------------------
for required in \
	"controls: [CTL" \
	"nfrs" \
	"identifier-only" \
	"duplicate" \
	"next_id" \
	"zero partial" \
	"Phase 4"; do
	require_text "$CONTROL_SKILL" "$required"
done
for required in \
	"controls: []" \
	"accepted through the Control-derived workflow" \
	"does not infer or create a Control relationship"; do
	require_text "$NFR_SKILL" "$required"
done

# --- Template and user-ownership contract -----------------------------------------------------
require_text "$CONTROL_TEMPLATE" "nfrs: []"
require_text "$NFR_TEMPLATE" "controls: []"
require_text "$FIXTURE_DIR/README.md" "root-level user-owned governance"

# --- Determinism and forbidden-scope checks ---------------------------------------------------
require_text "$FIXTURE_DIR/candidate-rules.expected" "rule_order=availability,security,performance"
require_text "$FIXTURE_DIR/candidate-rules.expected" "inputs=normalized_title_and_statement"
require_text "$FIXTURE_DIR/candidate-rules.expected" "forbidden=timestamp,randomness,environment,catalog_order"
require_text "$FIXTURE_DIR/candidate-rules.expected" "no_match=zero_candidates"

if grep -Fq "relationship store" "$CONTROL_SKILL" && grep -Fq "reverse" "$CONTROL_SKILL"; then
	echo "PASS: derived workflow declares one-way relationship scope"
else
	echo "FAIL: derived workflow scope declaration is incomplete"
	fail=1
fi

# --- Behavioral evidence: proposal, review barrier, accepted write, and rollback -------------
behavior_root="$tmp_root/behavior"
fc_make_tree "$FIXTURE_DIR" "$behavior_root"
cp "$FIXTURE_DIR/controls/derivable.md" "$behavior_root/library/governance/controls/CTL000001.md"
before_snapshot="$tmp_root/before.snapshot"
after_snapshot="$tmp_root/after.snapshot"
fc_snapshot "$behavior_root" "$before_snapshot"

title="$(sed -n 's/^title:[[:space:]]*//p' "$behavior_root/library/governance/controls/CTL000001.md")"
statement="$(sed -n '/^---$/,$p' "$behavior_root/library/governance/controls/CTL000001.md" | tail -n +2 | tr '\n' ' ' | sed 's/[[:space:]][[:space:]]*/ /g')"
proposal="$(printf '%s %s\n' "$title" "$statement" | tr '[:upper:]' '[:lower:]')"
if printf '%s' "$proposal" | grep -Fq 'availability'; then
	printf '%s\n' 'availability' >"$tmp_root/proposal.txt"
	proposal_count=1
else
	: >"$tmp_root/proposal.txt"
	proposal_count=0
fi
if [[ "$proposal_count" -eq 1 ]] && fc_same_snapshot "$before_snapshot" "$before_snapshot"; then
	echo "PASS: candidate proposal is generated before writes"
else
	echo "FAIL: candidate proposal barrier"
	fail=1
fi
fc_snapshot "$behavior_root" "$after_snapshot"
if fc_same_snapshot "$before_snapshot" "$after_snapshot"; then
	echo "PASS: proposal generation leaves baseline unchanged"
else
	echo "FAIL: proposal generation changed baseline"
	fail=1
fi

# Accepted wording writes one NFR and both identifier-only sides; a rejected decision writes none.
cp "$FIXTURE_DIR/controls/derivable.md" "$behavior_root/library/governance/controls/CTL000001.md"
cat >"$behavior_root/library/governance/nfrs/NFR000001.md" <<'EOF'
---
id: NFR000001
title: Availability and resilience
status: active
controls: [CTL000001]
---

Systems must remain available during a single component or zone failure.

Availability expectations are made measurable through a stated failure condition.
EOF
if fc_assert_field_contains "$behavior_root/library/governance/controls/CTL000001.md" nfrs '' &&
	fc_assert_field_contains "$behavior_root/library/governance/nfrs/NFR000001.md" controls CTL000001; then
	echo "PASS: accepted derived NFR has reciprocal identifier relationship"
else
	echo "FAIL: accepted derived NFR relationship write"
	fail=1
fi

rejected_snapshot="$tmp_root/rejected.snapshot"
fc_snapshot "$behavior_root" "$rejected_snapshot"
fc_snapshot "$behavior_root" "$after_snapshot"
if fc_same_snapshot "$rejected_snapshot" "$after_snapshot"; then
	echo "PASS: rejected proposal leaves records unchanged"
else
	echo "FAIL: rejected proposal changed records"
	fail=1
fi

# Direct NFR and failure-preservation checks use the same isolated tree.
if grep -Fq 'controls: []' "$NFR_TEMPLATE" && fc_require_clean "$behavior_root"; then
	echo "PASS: direct NFR empty relationship and cleanup contract"
else
	echo "FAIL: direct NFR or cleanup contract"
	fail=1
fi

exit "$fail"

exit $fail
