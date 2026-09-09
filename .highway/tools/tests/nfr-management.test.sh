#!/usr/bin/env bash
# Verifies the highway-nfrs contract without creating user governance in the live repository.
set -u

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

# --- The skill declares the complete artifact and action contract -------------------------------
for required in \
	"name: highway-nfrs" \
	"metadata:" \
	"version: 1.0.0" \
	"library/governance/nfrs.md" \
	"library/governance/nfrs/NFRXXXXXX.md" \
	"controls: []" \
	"The catalog contains no timestamp" \
	"next_id" \
	"Add is MINOR" \
	"Remove or Set is MAJOR" \
	"identifier is" \
	"followed by six digits" \
	"never reissued after removal" \
	"every NFR that would be lost by identifier and title" \
	"Confirmation is withheld: abort and write nothing"; do
	require_text "$SKILL" "$required"
done

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
