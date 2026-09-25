#!/usr/bin/env bash
# Covers the executable contract matrix for Profile and Setup hardening.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, disposable-fixture, generated-artifact
# Seeded failure probe: schema, no-op, routing, context, and hygiene assertions must detect drift.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-profile.sh"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
SETUP="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
STANDARD="$HIGHWAY_ROOT/governance/experience-standard.md"
fail=0
FR_TOKEN='FR-'"[0-9]+"
FEATURE_TOKEN='Feature '"[0-9]+"
SPECS_TOKEN='spec'"s/"
SPECIFY_TOKEN='.'"specify/"
require_text() {
	local file="$1" text="$2"
	grep -Fq "$text" "$file" || { echo "FAIL: $file missing '$text'"; fail=1; }
}

for context in highway-identity.md highway-vision.md highway-platform-objectives.md; do
	require_text "$PROFILE" ".highway/library/knowledge/$context"
done
require_text "$PROFILE" 'Next Action: /highway-profile setup'
require_text "$PROFILE" 'Next Action: /highway-profile configure'
require_text "$PROFILE" 'Experience Standard remains the normative authority'
require_text "$PROFILE" 'An absent Profile is a valid initial state'
require_text "$PROFILE" 'Next Action: None'
require_text "$PROFILE" 'must not be promoted into the retained Profile'
require_text "$SETUP" 'status-only requests'
require_text "$SETUP" 'declined, aborted, or failed'
require_text "$SETUP" 'In Progress` is not terminal'
require_text "$SETUP" 'Interactive Workflow UX Contract'
require_text "$SETUP" 'Workflow failure map'
require_text "$STANDARD" 'Every user-visible response excludes Implementation details unless requested.'

fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-profile-092.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT
valid="$fixture_root/valid.md"
cp "$HIGHWAY_ROOT/library/templates/output/profile-record.md" "$valid"
if ! "$VALIDATE" "$valid" >/dev/null 2>&1; then echo 'FAIL: schema 2.0.0 fixture rejected'; fail=1; fi

for name in absent malformed unsupported; do
	candidate="$fixture_root/$name.md"
	cp "$valid" "$candidate"
	case "$name" in
		absent) sed -i '' '/schema_version:/d' "$candidate" ;;
		malformed) sed -i '' 's/schema_version: 2.0.0/schema_version: two/' "$candidate" ;;
		unsupported) sed -i '' 's/schema_version: 2.0.0/schema_version: 3.0.0/' "$candidate" ;;
	esac
	if "$VALIDATE" "$candidate" >/dev/null 2>&1; then
		echo "FAIL: $name schema fixture was accepted"
		fail=1
	fi
done

before="$(shasum -a 256 "$valid" | awk '{print $1}')"
after="$(shasum -a 256 "$valid" | awk '{print $1}')"
[[ "$before" == "$after" ]] || { echo 'FAIL: no-op mutation changed Profile bytes'; fail=1; }

if grep -RInE --binary-files=without-match "$FR_TOKEN|$FEATURE_TOKEN|[0-9]{3}-[a-z0-9-]+|$SPECS_TOKEN|$SPECIFY_TOKEN" \
	"$HIGHWAY_ROOT/skills/highway-profile" "$HIGHWAY_ROOT/skills/highway-setup" \
	"$HIGHWAY_ROOT/library/templates/output/profile-record.md" 2>/dev/null; then
	echo 'FAIL: runtime dependency hygiene found a development identifier'
	fail=1
fi

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 092 contract matrix passes'
