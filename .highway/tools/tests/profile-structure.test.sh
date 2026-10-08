#!/usr/bin/env bash
# Tests structural validation for the retained organizational profile.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VALIDATE="$HIGHWAY_ROOT/tools/validate-profile.sh"
FIXTURES="$SCRIPT_DIR/fixtures/profile"
fail=0

expect_valid() {
	local file="$1"
	if ! "$VALIDATE" "$file" >/dev/null 2>&1; then
		echo "FAIL: expected valid profile: $file"
		fail=1
	fi
}

expect_invalid() {
	local file="$1"
	if "$VALIDATE" "$file" >/dev/null 2>&1; then
		echo "FAIL: expected invalid profile: $file"
		fail=1
	fi
}

# Superseded behavior: profile-record.md was a valid retained Profile. Feature 138 makes it a skeleton (D3.5).
expect_invalid "$HIGHWAY_ROOT/library/templates/output/profile-record.md"
expect_valid "$SCRIPT_DIR/fixtures/profile-092/profile-record/empty.md"
expect_valid "$SCRIPT_DIR/fixtures/profile-092/profile-record/accepted.md"
expect_valid "$SCRIPT_DIR/fixtures/profile-092/profile-record/bounded-empty.md"

bounded_without_evidence="$TMPDIR/highway-profile-bounded-without-evidence.$$.md"
cp "$SCRIPT_DIR/fixtures/profile-092/profile-record/bounded-empty.md" "$bounded_without_evidence"
printf '%s\n' '## Who We Are' >> "$bounded_without_evidence"
expect_invalid "$bounded_without_evidence"
rm -f "$bounded_without_evidence"

SKILL="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
# Superseded behavior: the Profile skill version was 5.3.0 before the domain-meaning breaking change.
for required_text in \
	'four readiness domains' \
	'not_discussed' \
	'discussed' \
	'bounded' \
	'version: 11.0.0' \
	'Profile readiness' \
	'Profile determines domain completeness' \
	'Retain only the accepted cohesive domain narrative'; do
# Superseded behavior: version 6.0.0 restated generic acceptance confirmation. Feature 138 removes that tutorial (D3.5).
	if ! grep -Fq "$required_text" "$SKILL"; then
		echo "FAIL: Profile ownership contract missing '$required_text'"
		fail=1
	fi
done

for subject_heading in \
	"### Where you're going" \
	"### How you'll get there" \
	'### What will guide your decisions'; do
	if ! grep -Fq -- "$subject_heading" "$SKILL"; then
		echo "FAIL: subject heading missing from Profile source: $subject_heading"
		fail=1
	fi
done
for forbidden in 'presents Status: Complete' 'announces Next Action: None' 'readiness-domain'; do
	if grep -Fq -- "$forbidden" "$SKILL"; then
		echo "FAIL: Profile source exposes workflow mechanics: $forbidden"
		fail=1
	fi
done

for internal_category in \
	'Future State' \
	'Customer / Participant' \
	'Experience / Reputation'; do
	if grep -Fq "$internal_category" "$HIGHWAY_ROOT/library/templates/output/profile-record.md"; then
		echo "FAIL: internal grounding category persisted in Profile template: $internal_category"
		fail=1
	fi
done

for heading in \
	'## Who We Are' \
	"## Where We're Going" \
	'## How We Plan to Get There' \
	'## What Guides Our Decisions'; do
	if ! grep -Fq -- "$heading" "$HIGHWAY_ROOT/library/templates/output/profile-record.md"; then
		echo "FAIL: Profile template omits canonical generated heading '$heading'"
		fail=1
	fi
done
# Superseded behavior: the template included ## How Highway Helps for highway_role.
if grep -Fq '## How Highway Helps' "$HIGHWAY_ROOT/library/templates/output/profile-record.md" || grep -Fq 'highway_role' "$HIGHWAY_ROOT/library/templates/output/profile-record.md"; then
	echo 'FAIL: Profile template still includes Highway Role'
	fail=1
fi
# Superseded behavior: the hidden comment used 'discussed always renders evidence',
# 'bounded renders accepted evidence', and 'not_discussed never renders a narrative section'.
# Feature 138 states the same rendering rules in visible prose (D3.5).
for rule in \
	'discussed` renders accepted narrative' \
	'not_discussed` renders no narrative section' \
	'Omit ## Context when no Context child has accepted content.'; do
	if ! grep -Fq -- "$rule" "$HIGHWAY_ROOT/library/templates/output/profile-record.md"; then
		echo "FAIL: Profile template omits state-to-narrative rule '$rule'"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then
	exit 1
fi

echo "OK: profile structure fixtures pass"
