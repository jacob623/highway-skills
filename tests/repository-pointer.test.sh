#!/usr/bin/env bash
# Effective knowledge root, pointer schemas, and experience-owned dual gate (Phase 15 / spec 258).
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: removing Dual offer from the gate asset fails this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"

fail=0
STORAGE="$(hw_doc storage)"
SKILL="$HW_EXPERIENCE/SKILL.md"
GATE="$HW_EXPERIENCE/assets/repository-gate.md"

require() {
	local file="$1" text="$2"
	[[ -f "$file" ]] && grep -Fq -- "$text" "$file" || {
		echo "FAIL: ${file#$HW_ROOT/} omits: $text"
		fail=1
	}
}

reject() {
	local file="$1" text="$2"
	if [[ -f "$file" ]] && grep -Fq -- "$text" "$file"; then
		echo "FAIL: ${file#$HW_ROOT/} still contains: $text"
		fail=1
	fi
}

if [[ ! -f "$GATE" ]]; then
	echo "FAIL: missing $GATE"
	fail=1
fi

for text in \
	'## Effective Highway knowledge root' \
	'## Pointer files' \
	'## Resolution order' \
	'**usable** local pointer' \
	'Setup-here override' \
	'`highway-experience` alone owns resolve-root' \
	'`hw-repository.md`' \
	'`hw-repository.local.md`' \
	'must not store product or codify code' \
	'Version `1.4.0`.'; do
	require "$STORAGE" "$text"
done

for text in \
	'## Dual offer' \
	'## Invalid path' \
	'## URL only' \
	'## Persist local path' \
	'## Persist URL' \
	'## Setup next action' \
	'## Bound ready' \
	'Run `highway-setup`' \
	'hw-repository.local.md' \
	'ignore file'; do
	require "$GATE" "$text"
done

require "$SKILL" 'assets/repository-gate.md'
require "$SKILL" 'Return **ready**'
require "$SKILL" 'Return **not-ready**'
require "$SKILL" 'setup-here override'
require "$SKILL" '**same** invocation'

# No separate resolution skill; no Oops dual-unaware gate in experience asset.
if [[ -d "$HW_SKILLS/highway-repository" ]]; then
	echo "FAIL: highway-repository skill must not exist"
	fail=1
fi
reject "$GATE" '**Oops... we need to setup your repository.**'

# Owning skills must not embed the old Oops gate.
while IFS= read -r f; do
	[[ -f "$f" ]] || continue
	id="$(basename "$(dirname "$f")")"
	[[ "$id" == highway-experience || "$id" == highway-setup || "$id" == highway-help || "$id" == highway-profile || "$id" == highway-objectives || "$id" == highway-controls || "$id" == highway-nfrs ]] && continue
	if grep -Fq '**Oops... we need to setup your repository.**' "$f"; then
		echo "FAIL: $id still embeds Oops setup-only gate"
		fail=1
	fi
done <<EOF
$(find "$HW_SKILLS" -name SKILL.md | LC_ALL=C sort)
EOF

# Absent-pointer / cwd-as-root: contract still allows open project as root when it is knowledge.
require "$STORAGE" 'Else if the open project itself is a Highway knowledge root → the open project is the effective'

# Seeded failure probe
probe_dir="$(mktemp -d)"
trap 'rm -rf "$probe_dir"' EXIT
sed '/## Dual offer/d' "$GATE" >"$probe_dir/gate.md"
if grep -Fq '## Dual offer' "$probe_dir/gate.md"; then
	echo "FAIL: probe could not remove Dual offer"
	fail=1
elif grep -Fq '## Dual offer' "$GATE"; then
	:
else
	echo "FAIL: Dual offer missing from live gate (cannot probe)"
	fail=1
fi
# Prove the check would catch absence:
if ! grep -Fq '## Dual offer' "$GATE"; then
	echo "FAIL: live gate missing Dual offer"
	fail=1
fi
if grep -Fq '## Dual offer' "$probe_dir/gate.md"; then
	echo "FAIL: probe file still has Dual offer"
	fail=1
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: repository pointer contract'
