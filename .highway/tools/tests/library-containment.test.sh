#!/usr/bin/env bash
# Fails when Highway's library validator would judge a file the user owns.
#
# The validator classifies a library file by matching a path glob. Before this check existed, the
# same user file was judged when named by an absolute path and declined when named by a relative
# one -- so whether a user's own governance content was held to Highway's authoring rules depended
# on how someone happened to type the path.
#
# The boundary is the framework root, not its library/ subdirectory: the fixtures this suite relies
# on live under tools/tests/fixtures/library/, so a narrower scope would decline every one of them
# and the containment would be bought by breaking the tests that prove it.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-library.sh"
fail=0

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

# A file shaped exactly like the ones highway-controls writes, in the place it writes them.
user_dir="$tmp_root/library/governance/controls"
mkdir -p "$user_dir"
cat >"$user_dir/CTL000001.md" <<'EOF'
---
id: CTL000001
title: Administrative Access Requires MFA
nfrs: []
status: active
---
Administrative access MUST require multi-factor authentication.
EOF

# --- A user file is declined however its path is written -----------------------------------------

for form in relative absolute; do
	if [[ "$form" == "absolute" ]]; then
		target="$user_dir/CTL000001.md"
	else
		target="$(cd "$tmp_root" && pwd)/library/governance/controls/CTL000001.md"
		target="${target#"$tmp_root"/}"
		( cd "$tmp_root" || exit 1 )
	fi

	out="$( cd "$tmp_root" && "$VALIDATE" "$target" 2>&1 )"
	if [[ $? -eq 0 ]]; then
		echo "FAIL: a user-owned file was validated when named by its $form path"
		fail=1
		continue
	fi
	if [[ "$out" != *"OUT-OF-SCOPE"* ]]; then
		echo "FAIL: a user-owned file named by its $form path was rejected, but not as out of scope. Got:"
		printf '%s\n' "$out" | sed 's/^/    /'
		fail=1
	fi
done

# --- No Highway rule id is ever reported against user content ------------------------------------

out="$( cd "$tmp_root" && "$VALIDATE" "library/governance/controls/CTL000001.md" 2>&1 )"
if printf '%s\n' "$out" | grep -qE '\[P[0-9]+\.[0-9]+\]'; then
	echo "FAIL: a Highway rule id was reported against a file the user owns:"
	printf '%s\n' "$out" | grep -E '\[P[0-9]+\.[0-9]+\]' | sed 's/^/    /'
	fail=1
fi

# --- Fixtures inside the framework root are still judged -----------------------------------------
#
# Without this the check above is satisfiable by declining everything, which would be containment
# achieved by switching the validator off.

fixture="$HIGHWAY_ROOT/tools/tests/fixtures/library/governance/valid/policy.md"
if [[ -f "$fixture" ]]; then
	if ! "$VALIDATE" "$fixture" >/dev/null 2>&1; then
		echo "FAIL: a valid fixture inside the framework root was not validated"
		fail=1
	fi
else
	echo "FAIL: the governance fixture is missing; this check would pass without testing anything"
	fail=1
fi

# --- Nothing the skill writes lands inside the framework -----------------------------------------

if [[ -d "$REPO_ROOT/.highway/library/governance/controls" ]]; then
	echo "FAIL: Control files were written under the framework root, where Highway's rules reach them"
	fail=1
fi

exit $fail
