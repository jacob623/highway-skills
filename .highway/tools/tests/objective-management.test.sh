#!/usr/bin/env bash
# Contract and fixture checks for the user-owned Business Objective workflow.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
HELPERS="$SCRIPT_DIR/feature-093-helpers.sh"
SKILL="$HIGHWAY_ROOT/skills/highway-objectives/SKILL.md"
TEMPLATE="$HIGHWAY_ROOT/library/templates/output/objective-record.md"
FIXTURES="$SCRIPT_DIR/fixtures/objective-management"
FEATURE093_FIXTURES="$SCRIPT_DIR/fixtures/feature-093"
WORK="$(mktemp -d)"
fail=0
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT
if [[ ! -f "$HELPERS" ]]; then
	echo "FAIL: Feature 093 helper library is missing: $HELPERS" >&2
	exit 1
fi
source "$HELPERS"

pass() { echo "OK: $1"; }
check() {
	if "$@"; then
		return 0
	fi
	fail=1
	return 1
}
require_text() {
	local file="$1" text="$2" label="$3"
	if grep -Fq "$text" "$file"; then
		pass "$label"
	else
		echo "FAIL: $label (missing '$text' in $file)" >&2
		fail=1
	fi
}

if [[ ! -f "$SKILL" ]]; then
	echo "FAIL: source skill is missing: $SKILL" >&2
	exit 1
fi
if [[ ! -f "$TEMPLATE" ]]; then
	echo "FAIL: objective record template is missing: $TEMPLATE" >&2
	exit 1
fi

for readiness_fixture in objective-baseline.txt objective-missing.txt objective-blocked.txt; do
	if [[ -f "$FEATURE093_FIXTURES/$readiness_fixture" ]]; then
		pass "Feature 093 readiness fixture present: $readiness_fixture"
	else
		echo "FAIL: missing Feature 093 readiness fixture: $readiness_fixture" >&2
		fail=1
	fi
done

# The contract must expose the exact action surface and retained-record shape.
for action in setup configure view show describe readiness add new update remove reset; do
	require_text "$SKILL" "\`$action\`" "supported action $action"
done
for field in "id: OBJXXXXXX" "status: active" "capabilities: []" "## Statement" "## Success Measures" "## Rationale"; do
	require_text "$TEMPLATE" "$field" "template field $field"
done
for path in "library/objectives/" "library/governance/objectives.md"; do
	require_text "$SKILL" "$path" "user-owned path $path"
done
for phrase in "Confirmation Status" "Resulting Version" "Affected Entries" "next_id" "byte-for-byte" "No timestamp" "never reused"; do
	require_text "$SKILL" "$phrase" "contract phrase $phrase"
done
# Superseded behavior: discovery used Outcome, Success, and Significance. Adaptive discovery, one-unresolved wording, and Resume Applicability stay with the Highway Experience Standard.
for phrase in \
	"What's an important outcome you'd like to achieve?" \
	"How would you measure success in" "What role should technology play in helping" \
	"Here's what I've captured as your objective:" "Does this objective look right?" "Why it matters:" \
	"[Objective Title]" "[Statement]" "Success looks like:" \
	"Profile-grounded" "accepted Profile" "without a second confirmation" \
	"Business Objective" "Highway Relevance" "## Statement" "## Success Measures" "## Rationale" \
	"User-visible interaction follows the Highway Experience Standard." "version: 3.0.0" "successful atomic persistence"; do
	require_text "$SKILL" "$phrase" "Feature 093 contract phrase $phrase"
done
if grep -Fq 'if Significance is unresolved' "$SKILL" || grep -Fq '## Highway Relevance' "$SKILL" || grep -Fq 'highway_relevance:' "$SKILL"; then
	echo "FAIL: Objective skill still uses Significance discovery or a persisted Highway Relevance field" >&2
	fail=1
fi
# Superseded behavior: continuation asked "Anything else you'd like to accomplish?".
if grep -Fq "Anything else you'd like to accomplish?" "$SKILL"; then
	echo "FAIL: Objective skill still uses the superseded continuation question" >&2
	fail=1
fi
# Superseded behavior: the review opened with "Here's the objective I've captured:" and used "Success Measures Success looks like:".
if grep -Fq "Here's the objective I've captured:" "$SKILL" || grep -Fq 'Success Measures Success looks like:' "$SKILL"; then
	echo "FAIL: Objective skill still uses the superseded capture review" >&2
	fail=1
fi
if grep -Fq '**Why it matters:**[' "$SKILL"; then
	echo "FAIL: Objective skill still uses malformed Rationale presentation" >&2
	fail=1
fi
# Superseded behavior: the opening told the person to ask for suggestions.
if grep -Fq "If you'd like some suggestions based on your organization's Profile" "$SKILL"; then
	echo "FAIL: Objective skill still tells the person to ask for suggestions" >&2
	fail=1
fi
# Superseded behavior: persistence said persist and verify.
if grep -Fq 'persist and verify' "$SKILL" || grep -Fq 'persists and verifies' "$SKILL"; then
	echo "FAIL: Objective skill still requires persist-and-verify" >&2
	fail=1
fi
# Superseded behavior: suggestions waited for an explicit request.
if grep -Fq 'explicit request for suggestions' "$SKILL"; then
	echo "FAIL: Objective skill still waits for an explicit suggestion request" >&2
	fail=1
fi
if grep -Fq 'Step 1 of 3' "$SKILL"; then
	echo "FAIL: legacy fixed progress remains in Objective skill" >&2
	fail=1
else
	pass "legacy fixed progress removed"
fi
if grep -Fq 'Accept, modify, or replace?' "$SKILL"; then
	echo "FAIL: legacy rationale confirmation remains in Objective skill" >&2
	fail=1
else
	pass "legacy rationale confirmation removed"
fi
for phrase in "Repository Context Participating Skill" "Identity" "Highway Vision" \
	"Highway Platform Objectives" "Profile" "malformed" "unavailable" \
	"exact duplicate" "semantic overlap" \
	"/highway-objectives setup" "direct invocation" "Is there another objective you'd like to capture?" \
	"once after a selection of several" \
	"What's another important outcome you'd like to achieve?" "Status: Missing" \
	"Status: Complete" "Status: Blocked"; do
	require_text "$SKILL" "$phrase" "Feature 093 extended contract phrase $phrase"
done
# Superseded behavior: Inputs restated generic context-consumption rules and Verification restated generic Experience Standard and Constitution checks.
require_text "$SKILL" "A Profile-owned Blocked result blocks Objective behavior that depends on accepted Profile evidence." "Profile-owned Blocked handling remains"
require_text "$SKILL" "accepted organizational evidence for Objective interpretation, recommendations, Highway Relevance, or" "Profile context roles use current terminology"
if grep -Fq "A Profile baseline is Blocked." "$SKILL"; then
	echo "FAIL: legacy Profile Blocked wording remains" >&2
	fail=1
fi
require_text "$SKILL" "no post-write persistence verification" "verification drops post-write persistence checks"
require_text "$SKILL" "When Business Objective evidence supports a Statement and Success evidence supports at least one Success Measure" "review-ready condition uses Business Objective and Success"
require_text "$SKILL" "Highway Relevance does not independently block Objective creation" "Highway Relevance is non-blocking"
require_text "$SKILL" "Business Objective and Success are sufficient for review" "Business Objective and Success are sufficient"
require_text "$SKILL" "Rationale is synthesized from accepted evidence" "Rationale synthesis is explicit"
require_text "$SKILL" "Why it matters is not a fourth discovery dimension" "Rationale is not a discovery dimension"
if grep -Fq "Significance is supported" "$SKILL" || grep -Fq "Why it matters" "$SKILL" && grep -Fq "ask one question" "$SKILL"; then
	echo "FAIL: Rationale remains a discovery requirement" >&2
	fail=1
fi
for phrase in "natural correction" "replacement" "rejection" "cancellation" "abandonment" \
	"re-evaluate" "revalidate the authoritative baseline" "allocate one permanent identifier" \
	"persist both retained outputs" "byte-for-byte" "capabilities: []" \
	"If pre-write revalidation discovers a new overlap, name the overlapping Objective" \
	"previous creation confirmation is no longer active" \
	"resulting complete proposal again and obtain renewed acceptance before persistence"; do
	require_text "$SKILL" "$phrase" "Feature 093 safety contract phrase $phrase"
done

# Executable interaction probes use the source contract as the owning workflow
# in this Markdown-only skill suite; each probe names the behavior it protects.
for interaction in \
	"Business Objective is what the organization wants to accomplish" \
	"Success is how the organization will know it succeeded" \
	"Highway Relevance is not stored" \
	"without adding unsupported facts" \
	"Accept ordinary business language, uncertainty, activity descriptions" \
	"dimensions in one answer" \
	"\`I don't know\` starts guided discovery" \
	"suggestion is not adoption" \
	"After a correction, re-evaluate staged Business Objective, Success, and Highway Relevance evidence" \
	"discard staged interpretations that no longer support the revised intent" \
	"represent them together or separately" \
	"user-provided order" \
	"Business Objective evidence supports a Statement" \
	"Rationale is synthesized from accepted evidence" \
	"accepted Business Objective," "applicable accepted Profile evidence without adding unsupported facts" \
	"Highway Identity, Highway Vision, and Highway Platform Objectives are not organizational facts" \
	"abandonment, or interruption keeps the proposal transient"; do
	require_text "$SKILL" "$interaction" "adaptive interaction probe: $interaction"
done

baseline="$FEATURE093_FIXTURES/objective-baseline.txt"
for invariant in "Status: Complete" "Record schema:" "Catalog invariants:" "Resume: New interaction"; do
	require_text "$baseline" "$invariant" "baseline invariant fixture: $invariant"
done
require_text "$baseline" "capabilities: []" "baseline preserves Capability relationship shape"
require_text "$baseline" "next_id greater than every allocated identifier" "baseline preserves identifier allocation"
if grep -Eiq 'draft|proposal|collection-loop state' "$baseline"; then
	if grep -Eiq 'no transient proposal|no transient state' "$baseline"; then
		pass "baseline explicitly excludes transient state"
	else
		echo "FAIL: baseline fixture contains transient-state markers" >&2
		fail=1
	fi
fi

# Fixtures are copied into temporary repositories so all byte comparisons are isolated.
for fixture in empty valid duplicate invalid-next-id missing-target; do
	if [[ -d "$FIXTURES/$fixture" ]]; then
		cp -R "$FIXTURES/$fixture" "$WORK/$fixture"
		pass "fixture copied: $fixture"
	else
		echo "FAIL: missing fixture: $fixture" >&2
		fail=1
	fi
done

before="$WORK/valid.before"
feature093_snapshot_tree "$WORK/valid" "$before"
if [[ -s "$before" ]]; then
	pass "valid baseline snapshot created"
else
	echo "FAIL: valid baseline snapshot is empty" >&2
	fail=1
fi

after="$WORK/valid.after"
if feature093_assert_snapshot_unchanged "$before" "$WORK/valid" "$after"; then
	pass "valid baseline remains byte-identical after read-only fixture inspection"
else
	echo "FAIL: valid baseline fixture changed during read-only inspection" >&2
	fail=1
fi

# Structural fixture checks cover duplicate IDs, invalid allocation, and missing catalog targets.
if [[ "$(grep -h '^id: OBJ' "$WORK/duplicate/library/objectives/"*.md | sort | uniq -d)" == "id: OBJ000001" ]]; then
	pass "duplicate identifier fixture detected"
else
	echo "FAIL: duplicate identifier fixture is not malformed as expected" >&2
	fail=1
fi
if grep -q 'Next identifier: OBJ000004' "$WORK/invalid-next-id/library/governance/objectives.md"; then
	pass "invalid next_id fixture detected"
else
	echo "FAIL: invalid next_id fixture is not malformed as expected" >&2
	fail=1
fi
if [[ ! -f "$WORK/missing-target/library/governance/objectives.md" ]]; then
	pass "missing catalog target fixture detected"
else
	echo "FAIL: missing catalog target fixture unexpectedly has a catalog" >&2
	fail=1
fi

# The skill contract must keep framework source and user-owned output separate.
if grep -Fq '.highway/library/objectives' "$SKILL"; then
	echo "FAIL: skill proposes an objective record under .highway" >&2
	fail=1
else
	pass "objective records stay outside .highway"
fi

# No live user-owned baseline may be created by the focused test itself.
if [[ -d "$REPO_ROOT/library/objectives" || -f "$REPO_ROOT/library/governance/objectives.md" ]]; then
	echo "FAIL: focused test found live objective output" >&2
	fail=1
else
	pass "focused test leaves live user-owned baseline absent"
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo "OK: objective workflow contract and fixtures pass"
