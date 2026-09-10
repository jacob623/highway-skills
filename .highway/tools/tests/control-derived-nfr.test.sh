#!/usr/bin/env bash
# Verifies the review-first Control-derived NFR contract without creating user governance.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONTROL_SKILL="$HIGHWAY_ROOT/skills/highway-controls/SKILL.md"
NFR_SKILL="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
CONTROL_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/control-record.md"
NFR_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/nfr-record.md"
FIXTURE_DIR="$SCRIPT_DIR/fixtures/control-derived-nfr"
fail=0

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

exit $fail
