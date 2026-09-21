#!/usr/bin/env bash
# Verifies the highway-nfrs contract without creating user governance in the live repository.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
VALIDATE="$HIGHWAY_ROOT/tools/validate-library.sh"
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

nfr_structure_not_duplicated() {
	file="$1"
	if grep -Fq "Confirm each record has id, title, status, controls: [], a statement, and a rationale." "$file" ||
		grep -Fq "Confirm the catalog indexes every record and records a next_id greater than every allocated ID." "$file"; then
		return 1
	fi
}

# --- The skill declares the complete artifact and action contract -------------------------------
for required in \
	"name: highway-nfrs" \
	"metadata:" \
	"version: 1.0.1" \
	"library/governance/nfrs.md" \
	"library/governance/nfrs/NFRXXXXXX.md" \
	"controls: []" \
	".highway/library/templates/output/nfr-record.md" \
	".highway/library/templates/output/nfr-catalog.md" \
	"The catalog contains no timestamp" \
	"next_id" \
	"Add is MINOR" \
	"Remove or Set is MAJOR" \
	"identifier is" \
	"followed by six digits" \
	"never reissued after removal" \
	"every NFR that would be lost by identifier and title" \
	"concrete alternative" \
	"one existing NFR or the entire baseline" \
	"skips Highway prose" \
	"obligation-preserving Update is PATCH" \
	"Confirmation is withheld: abort and write nothing"; do
	require_text "$SKILL" "$required"
done

for behavior_token in "Control-shaped" "/highway-controls" "outcome-shaped" "/highway-nfrs" "transaction" "identical catalog" "write nothing"; do
	require_text "$SKILL" "$behavior_token"
done

# Structural authority must be cited, while record and catalog shape remain owned by templates.
record_citation_fixture="$tmp_root/nfr-record-missing-citation.md"
sed '/nfr-record\.md/d' "$SKILL" > "$record_citation_fixture"
if grep -Fq ".highway/library/templates/output/nfr-record.md" "$record_citation_fixture"; then
	echo "FAIL: missing NFR record citation fixture was accepted"
	fail=1
fi

duplicate_fixture="$tmp_root/nfr-duplicate-structure.md"
cp "$SKILL" "$duplicate_fixture"
printf '%s\n' 'Confirm each record has id, title, status, controls: [], a statement, and a rationale.' >> "$duplicate_fixture"
if nfr_structure_not_duplicated "$duplicate_fixture"; then
	echo "FAIL: duplicated NFR structure fixture was accepted"
	fail=1
fi

if ! nfr_structure_not_duplicated "$SKILL"; then
	echo "FAIL: highway-nfrs still duplicates record or catalog structure"
	fail=1
fi

for action in "### Action selection" "| Explicitly says add" "| Explicitly says update" "| Explicitly says remove" "| Explicitly says set"; do
	require_text "$SKILL" "$action"
done

# --- A user-owned NFR is declined by the Highway library validator by both path forms -----------
user_dir="$tmp_root/library/governance/nfrs"
mkdir -p "$user_dir"
cat >"$user_dir/NFR000001.md" <<'EOF'
---
id: NFR000001
title: Availability
controls: []
status: active
---
Systems must remain available during a single availability-zone failure.

Redundancy avoids service loss during a zone failure.
EOF

relative_output="$(cd "$tmp_root" && "$VALIDATE" "library/governance/nfrs/NFR000001.md" 2>&1)"
absolute_output="$(cd "$tmp_root" && "$VALIDATE" "$user_dir/NFR000001.md" 2>&1)"
for output in "$relative_output" "$absolute_output"; do
	if [[ "$output" != *"OUT-OF-SCOPE"* ]]; then
		echo "FAIL: root-level NFR was not declined as OUT-OF-SCOPE"
		fail=1
	fi
done

# --- The source location is distinct from the framework's own governance library --------------
if [[ -d "$REPO_ROOT/.highway/library/governance/nfrs" ]]; then
	echo "FAIL: NFR records exist under .highway/library/governance"
	fail=1
fi

exit $fail
