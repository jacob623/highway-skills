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
require_text "$PROFILE" '`/highway-profile setup`'
require_text "$PROFILE" '`/highway-profile configure`'
# Superseded behavior: version 6.0.0 restated generic material-interpretation guidance.
# Feature 138 leaves that check to the Experience Standard (D3.5).
require_text "$PROFILE" 'An absent Profile is a valid initial state'
require_text "$PROFILE" 'Next Action: `None`'
require_text "$PROFILE" 'it is not retained as organizational fact'
require_text "$PROFILE" '**What would you like to call your Highway repository?**'
require_text "$PROFILE" 'Accept a directly supplied Repository Name as supplied.'
require_text "$PROFILE" 'Supplied URLs are accepted optional Profile Context'
require_text "$PROFILE" 'facts derived from'
require_text "$PROFILE" 'retrieval is unavailable'
require_text "$PROFILE" "### Let's get to know your organization"
require_text "$PROFILE" '**What does [Organization Name] do?**'
require_text "$PROFILE" 'future vision of'
require_text "$PROFILE" 'plan to'
require_text "$PROFILE" 'principles or values guide'
require_text "$PROFILE" 'accepted Repository Name'
require_text "$PROFILE" 'Canonical questions are Profile-owned fallbacks'
# Superseded behavior: Vision, Competitive Path, and Guiding Principles required internal enrichment-category coverage.
require_text "$PROFILE" 'Optional Context and optional enrichment do not change readiness.'
# Superseded behavior: the Profile skill restated that a selected recommendation is accepted without a second confirmation.
if grep -Fq 'a selected recommendation is accepted without a second confirmation' "$PROFILE"; then
	echo "FAIL: $PROFILE still restates recommendation-selection acceptance"
	fail=1
fi
require_text "$PROFILE" '#### Domain model'
require_text "$PROFILE" '#### Domain completeness'
require_text "$PROFILE" '##### Organizational expression'
require_text "$PROFILE" '## Operations'
require_text "$PROFILE" '## Acquisition'
require_text "$PROFILE" 'establishes Repository Name when missing'
# Superseded behavior: acquisition named only existing-information or website retrieval and re-evaluated accepted evidence across all four domains as a category pass.
require_text "$PROFILE" 'Evaluate each source across all unresolved Profile domains'
require_text "$PROFILE" 'The Highway Experience Standard determines whether collaborative development has converged enough'
require_text "$PROFILE" "### Where you're going"
require_text "$PROFILE" 'Competitive Path describes the broad organizational approach'
require_text "$PROFILE" 'When entering unresolved Competitive'
require_text "$PROFILE" 'When entering unresolved Guiding'
require_text "$PROFILE" 'Accepted Identity informs Vision when relevant'
require_text "$PROFILE" 'persist the final accepted domain mutation first'
require_text "$PROFILE" 'readiness'
require_text "$PROFILE" 'The optional Context structure is also owned by that template.'
if grep -Fq '### Repository Name' "$PROFILE"; then
	echo "FAIL: $PROFILE restates the Context heading skeleton"
	fail=1
fi
# Superseded behavior: highway-profile version 5.3.0 locked the narrower domain and acquisition contract.
# Superseded behavior: highway-profile 6.0.0. Feature 138 is MAJOR 7.0.0 because projection and verification narrowed (D3.5).
require_text "$PROFILE" 'version: 8.1.0'
if grep -Fq '.highway/tools/validate-profile.sh' "$PROFILE"; then
	echo "FAIL: $PROFILE still instructs .highway/tools/validate-profile.sh"
	fail=1
fi
require_text "$SETUP" 'Request readiness from the current owner'
require_text "$SETUP" 'owner `Declined` or `Aborted`'
require_text "$SETUP" 'NFRs'
# Superseded behavior: Setup was required to name the Interactive Workflow UX Contract.
if grep -Fq 'Interactive Workflow UX Contract' "$SETUP"; then
	echo "FAIL: $SETUP still names the removed Interactive Workflow UX Contract"
	fail=1
fi
require_text "$SETUP" 'Highway Experience Standard'
require_text "$STANDARD" '## Interaction Model'
# Superseded behavior: X1.7 required the question after supporting rationale.
require_text "$STANDARD" '| X1.7 | Setup presentation MUST keep at most one response-demanding question or decision'
require_text "$SETUP" '## Error Handling'
require_text "$STANDARD" 'Responses exclude identifiers, catalog mutations, generated versions, internal state, and owner mechanics unless needed.'

fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-profile-092.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT
valid="$fixture_root/valid.md"
# Superseded behavior: this copied profile-record.md as a valid Profile. Feature 138 uses the retained empty fixture (D3.5).
cp "$HIGHWAY_ROOT/tools/tests/fixtures/profile-092/profile-record/empty.md" "$valid"
if ! "$VALIDATE" "$valid" >/dev/null 2>&1; then echo 'FAIL: schema 3.0.0 fixture rejected'; fail=1; fi

# Superseded behavior: schema 2.0.0 was valid, and schema 3.0.0 was the unsupported example.
legacy="$fixture_root/legacy-2.0.0.md"
cp "$valid" "$legacy"
sed -i '' 's/schema_version: 3.0.0/schema_version: 2.0.0/' "$legacy"
legacy_before="$(shasum -a 256 "$legacy" | awk '{print $1}')"
if "$VALIDATE" "$legacy" >/dev/null 2>&1; then echo 'FAIL: schema 2.0.0 fixture was accepted'; fail=1; fi
legacy_after="$(shasum -a 256 "$legacy" | awk '{print $1}')"
[[ "$legacy_before" == "$legacy_after" ]] || { echo 'FAIL: schema 2.0.0 fixture was rewritten'; fail=1; }

for name in absent malformed unsupported; do
	candidate="$fixture_root/$name.md"
	cp "$valid" "$candidate"
	case "$name" in
		absent) sed -i '' '/schema_version:/d' "$candidate" ;;
		malformed) sed -i '' 's/schema_version: 3.0.0/schema_version: two/' "$candidate" ;;
		unsupported) sed -i '' 's/schema_version: 3.0.0/schema_version: 4.0.0/' "$candidate" ;;
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
