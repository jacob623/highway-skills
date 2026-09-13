#!/usr/bin/env bash
# Proves that the frontmatter contract manifest is the sole authority on which frontmatter keys are
# required: adding a required row to the manifest, and changing nothing else, must make a previously
# conforming artifact stop conforming. Feature 045 asserted this and demonstrated it once by hand;
# nothing defended it, so a regression would have been silent. Per feature 046.
#
# The target is a fixture rather than a real skill deliberately. The proof must not depend on which
# artifact it validates, and a fixture cannot later acquire the probe key through unrelated editorial
# work on a real skill's frontmatter.
#
# The tracked manifest is never written. Every mutation happens on a temporary copy reached through
# FRONTMATTER_CONTRACT_FILE, so a failure partway through cannot leave the repository altered.
set -u
# Instrument class: executed-behavior
# Artifact classes: source-document, disposable-fixture
# Seeded failure probe: restrict the validator's required-key set to keys having bespoke checks;
# this test must then report the expected missing-field finding was absent.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-skill.sh"
FIXTURES="$SCRIPT_DIR/fixtures"
MANIFEST="$HIGHWAY_ROOT/tools/.frontmatter-contract"
TARGET="$FIXTURES/valid-skill"

fail=0
tmp_dir=""

cleanup() {
	[[ -n "$tmp_dir" && -d "$tmp_dir" ]] && rm -rf "$tmp_dir"
}
trap cleanup EXIT

tmp_dir="$(mktemp -d)"

# A key no skill and no fixture declares, so the expected finding is attributable to the manifest
# row and not to unrelated frontmatter.
PROBE_KEY="contract-proof-probe-key"

# --- The probe key must genuinely be absent everywhere, or the proof proves nothing -------------

if grep -rqF "$PROBE_KEY" "$HIGHWAY_ROOT/skills" "$FIXTURES" 2>/dev/null; then
	echo "FAIL: probe key '$PROBE_KEY' already appears in a skill or fixture; the proof would be meaningless"
	fail=1
fi

# --- Control: an unmodified copy of the manifest leaves the target conforming -------------------
# Without this, a validator that rejected everything unconditionally would satisfy the checks below.

control_manifest="$tmp_dir/control"
cp "$MANIFEST" "$control_manifest"
control_out="$(FRONTMATTER_CONTRACT_FILE="$control_manifest" "$VALIDATE" "$TARGET" 2>&1)"
control_rc=$?
if [[ $control_rc -ne 0 ]]; then
	echo "FAIL: expected the target to conform against an unmodified manifest copy, got exit $control_rc. Output:"
	echo "$control_out"
	fail=1
fi
if [[ "$control_out" == *"$PROBE_KEY"* ]]; then
	echo "FAIL: the unmodified manifest copy produced a finding naming the probe key. Output:"
	echo "$control_out"
	fail=1
fi

# --- Adding a required row at each scope must make the same target stop conforming --------------

assert_required_row_is_enforced() {
	local scope="$1" expected_field="$2" manifest out rc

	manifest="$tmp_dir/$scope"
	cp "$MANIFEST" "$manifest"
	printf '%s\t%s\tyes\t-\n' "$scope" "$PROBE_KEY" >> "$manifest"

	out="$(FRONTMATTER_CONTRACT_FILE="$manifest" "$VALIDATE" "$TARGET" 2>&1)"
	rc=$?

	if [[ $rc -eq 0 ]]; then
		echo "FAIL: adding a required '$scope' key to the manifest left the target conforming (exit 0)."
		echo "      The manifest is not the authority on which keys are required."
		echo "$out"
		fail=1
		return
	fi

	# Asserts on the key, not on the total finding count: an unrelated future check could
	# legitimately add a finding, and that must not break this proof.
	if [[ "$out" != *"missing required field '$expected_field'"* ]]; then
		echo "FAIL: expected a missing-field finding naming '$expected_field'. Got:"
		echo "$out"
		fail=1
	fi
}

assert_required_row_is_enforced "top" "$PROBE_KEY"
assert_required_row_is_enforced "metadata" "metadata.$PROBE_KEY"

# --- The tracked manifest must be untouched, on every path -------------------------------------

if ! cmp -s "$MANIFEST" "$control_manifest"; then
	echo "FAIL: the tracked manifest at $MANIFEST was modified during this test"
	fail=1
fi

if [[ $fail -eq 0 ]]; then
	echo "OK: the frontmatter contract manifest governs required keys at both scopes"
fi
exit $fail
