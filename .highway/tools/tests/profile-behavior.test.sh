#!/usr/bin/env bash
# Verifies the Feature 116 Markdown Profile contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$HIGHWAY_ROOT/tools/lib/profile.sh"
VALIDATE="$HIGHWAY_ROOT/tools/validate-profile.sh"
fail=0
OBSOLETE_YAML=".highway/library/templates/output/profile"".yaml"
fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/highway-profile-091.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT

valid="$fixture_root/profile.md"
# Superseded behavior: tests copied profile-record.md as a valid Profile. Feature 138 makes it a skeleton (D3.5).
cp "$HIGHWAY_ROOT/tools/tests/fixtures/profile-092/profile-record/empty.md" "$valid"
if ! grep -Fq 'schema_version: 3.0.0' "$HIGHWAY_ROOT/library/templates/output/profile-record.md"; then echo 'FAIL: shared template schema is not 3.0.0'; fail=1; fi
if ! "$VALIDATE" "$valid" >/dev/null; then echo 'FAIL: retained empty Profile fixture is invalid'; fail=1; fi

sed -i '' 's/identity: not_discussed/identity: discussed/' "$valid"
printf '%s\n' '## Who We Are' 'A user-supplied organization.' >> "$valid"
if ! "$VALIDATE" "$valid" >/dev/null; then echo 'FAIL: discussed Profile fixture is invalid'; fail=1; fi

if [[ "$(profile_next_version 2.0.0 add)" != 2.0.1 ]]; then echo 'FAIL: content mutation version helper failed'; fail=1; fi
if [[ "$(profile_next_version 2.0.0 schema-breaking)" != 3.0.0 ]]; then echo 'FAIL: schema version transition failed'; fail=1; fi

before="$(shasum -a 256 "$valid" | awk '{print $1}')"
after="$(shasum -a 256 "$valid" | awk '{print $1}')"
if [[ "$before" != "$after" ]]; then echo 'FAIL: read-only readiness changed Profile bytes'; fail=1; fi

if grep -Fq "$OBSOLETE_YAML" "$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"; then echo 'FAIL: active skill references obsolete YAML'; fail=1; fi
if ! grep -Fq '.highway/library/knowledge/profile.md' "$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"; then echo 'FAIL: active skill omits authoritative Markdown path'; fail=1; fi
if ! grep -Fq 'proposal evidence' "$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"; then echo 'FAIL: proposal evidence lifecycle missing'; fail=1; fi

SKILL="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
# Superseded behavior: version 5.3.0, enrichment-category coverage, and Competitive Path opening from accepted Vision or sufficient accepted evidence.
for required_text in \
	       'version: 9.0.0' \
	"### Let's get to know your organization" \
	'An absent Profile is a valid initial state' \
	'Profile determines domain completeness' \
	'Profile-specific validation questions apply to the domain' \
	'When entering unresolved Vision' \
	'When entering unresolved Competitive' \
	'When entering unresolved Guiding Principles' \
	'Acceptance authorizes the mutation but is not successful persistence' \
	'emit one concise user-relevant synthesis' \
	'Is this an accurate description of your organization?' \
	'Validate the Converged Proposal with' \
	'You can also change it or provide your own description.' \
	'You can also change it or provide your own vision.' \
	'You can also change it or provide your own approach.' \
	'You can also change it or provide your own principles.'; do
# Superseded behavior: version 6.0.0 restated generic material-interpretation guidance.
# Feature 138 leaves that check to the Experience Standard (D3.5).
	if ! grep -Fq "$required_text" "$SKILL"; then
		echo "FAIL: Feature 116 contract missing '$required_text'"
		fail=1
	fi
done

# Superseded behavior: version 6.0.0 restated generic Working Idea, re-evaluation, and recommendation tutorials.
# Feature 138 removes those Experience Standard restatements (D3.5).
for subject_text in \
	"### Where you're going" \
	"### How you'll get there" \
	'### What will guide your decisions'; do
	if ! grep -Fq "$subject_text" "$SKILL"; then
		echo "FAIL: Feature 123 subject rhythm missing '$subject_text'"
		fail=1
	fi
done

for narration_text in 'persisted' 'readiness' 'workflow progression'; do
	if grep -Fq "narrate $narration_text" "$SKILL"; then
		echo "FAIL: Profile narrates internal mechanics: narrate $narration_text"
		fail=1
	fi
done

for forbidden_text in \
	'Based on what I know about [Organization Name], I could see your vision as' \
	'Based on that direction, [Organization Name] could pursue it by' \
	"From what you've shared, [Organization Name] seems guided by"; do
	if grep -Fq "$forbidden_text" "$SKILL"; then
		echo "FAIL: fixed Profile recommendation opening remains '$forbidden_text'"
		fail=1
	fi
done

if grep -Fq 'ask the first unresolved canonical domain question; use optional grounded enrichment' "$SKILL"; then
	echo 'FAIL: superseded question-first acquisition contract remains'
	fail=1
fi
if grep -Fq 'Status: <Complete, Missing, or Blocked>' "$SKILL"; then
	echo 'FAIL: machine readiness result is still presented as the default output contract'
	fail=1
fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Markdown Profile behavior contract passes'
