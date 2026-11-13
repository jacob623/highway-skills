#!/usr/bin/env bash
# Verifies the validation cache: that it skips redundant work without ever skipping a verdict.
set -u
# Instrument class: executed-behavior
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
VALIDATE="$HW_FRAMEWORK/validate-skill.sh"
VALID_FIXTURE="$HW_FIXTURES/valid-skill"
INVALID_FIXTURE="$HW_FIXTURES/invalid-skill-missing-usage"
fail=0

WORK="$(mktemp -d "${TMPDIR:-/tmp}/validation-cache-test.XXXXXX")"
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

# Each case gets its own TMPDIR so the cache under test is isolated from the developer's real one
# and from other tests running at the same time.
fresh_home() {
	local home
	home="$(mktemp -d "$WORK/home.XXXXXX")"
	printf '%s' "$home"
}

cache_dir_of() { printf '%s' "$1/highway-validation-cache"; }

# Counts recorded keys, ignoring the transient names used while a record is being written.
key_count() {
	local dir="$1"
	[[ -d "$dir" ]] || { printf '0'; return 0; }
	find "$dir" -type f ! -name '.writing.*' | grep -c . | tr -d ' '
}

check() {
	# check <label> <condition-description> <actual> <expected>
	if [[ "$3" != "$4" ]]; then
		echo "FAIL: $1 -- $2: expected '$4', got '$3'"
		fail=1
	fi
}

# --- VC-2, VC-3: a cold validation runs in full and records its verdict ----------------------

home="$(fresh_home)"
cache="$(cache_dir_of "$home")"
cold_out="$(TMPDIR="$home" bash "$VALIDATE" "$VALID_FIXTURE" 2>/dev/null)"
cold_rc=$?
check "VC-2" "cold validation exits 0" "$cold_rc" "0"
check "VC-3" "cold validation records exactly one key" "$(key_count "$cache")" "1"

# --- VC-1: a warm validation reuses the verdict and reproduces it exactly --------------------

warm_out="$(TMPDIR="$home" bash "$VALIDATE" "$VALID_FIXTURE" 2>/dev/null)"
warm_rc=$?
check "VC-1" "warm validation exits 0" "$warm_rc" "0"
check "VC-1" "warm validation records no additional key" "$(key_count "$cache")" "1"
# Callers parse this output. A hit that printed less than a full run would be observably
# different from one, which is the defect this assertion exists to catch.
if [[ "$warm_out" != "$cold_out" ]]; then
	echo "FAIL: VC-1 -- cached report differs from the full report"
	echo "--- cold ---"; printf '%s\n' "$cold_out"
	echo "--- warm ---"; printf '%s\n' "$warm_out"
	fail=1
fi

# --- VC-4: a cached skill that is then broken is still rejected ------------------------------
#
# This is the assertion that decides whether the cache is worth having. A cache that reports a
# stale success for a skill that now violates a rule is worse than no cache, because it converts
# a loud failure into a silent one.

home="$(fresh_home)"
cache="$(cache_dir_of "$home")"
# The directory basename is the skill id and must match the frontmatter `name`, so the copy keeps
# the fixture's name and is isolated by its parent directory instead.
broken="$WORK/broken/valid-skill"
mkdir -p "$broken"
cp "$VALID_FIXTURE/SKILL.md" "$broken/SKILL.md"

seed_rc=0
TMPDIR="$home" bash "$VALIDATE" "$broken" >/dev/null 2>&1 || seed_rc=$?
check "VC-4" "the skill validates before it is broken" "$seed_rc" "0"
check "VC-4" "the passing verdict is recorded" "$(key_count "$cache")" "1"

# Remove a required frontmatter key, mirroring the invalid-skill-missing-usage fixture.
grep -v '^  usage:' "$broken/SKILL.md" >"$broken/SKILL.md.tmp"
mv "$broken/SKILL.md.tmp" "$broken/SKILL.md"

broken_rc=0
broken_err="$(TMPDIR="$home" bash "$VALIDATE" "$broken" 2>&1 >/dev/null)" || broken_rc=$?
if [[ "$broken_rc" == "0" ]]; then
	echo "FAIL: VC-4 -- a broken skill passed on a populated cache; the cache is masking defects"
	fail=1
fi
if ! printf '%s' "$broken_err" | grep -q 'ERROR: \['; then
	echo "FAIL: VC-4 -- the rejection did not carry its error text"
	fail=1
fi
check "VC-4" "a failed validation records nothing" "$(key_count "$cache")" "1"

# A fixture that has never validated must also be rejected, and must stay unrecorded.
home="$(fresh_home)"
cache="$(cache_dir_of "$home")"
inv_rc=0
TMPDIR="$home" bash "$VALIDATE" "$INVALID_FIXTURE" >/dev/null 2>&1 || inv_rc=$?
if [[ "$inv_rc" == "0" ]]; then
	echo "FAIL: VC-4 -- an invalid fixture passed validation"
	fail=1
fi
check "VC-4" "an invalid fixture records no key" "$(key_count "$cache")" "0"

# --- VC-5: editing the skill changes its key -------------------------------------------------

home="$(fresh_home)"
cache="$(cache_dir_of "$home")"
edited="$WORK/edited/valid-skill"
mkdir -p "$edited"
cp "$VALID_FIXTURE/SKILL.md" "$edited/SKILL.md"
TMPDIR="$home" bash "$VALIDATE" "$edited" >/dev/null 2>&1
before="$(key_count "$cache")"
printf '\nAn added sentence that changes the content without breaking any rule.\n' >>"$edited/SKILL.md"
TMPDIR="$home" bash "$VALIDATE" "$edited" >/dev/null 2>&1
check "VC-5" "an edited skill is recorded under a new key" "$(key_count "$cache")" "$((before + 1))"

# --- VC-6: changing the validator environment changes every key ------------------------------
#
# Exercised against a copy of the tree. Mutating the live governance documents to prove this would
# make the test write into the shared tree and force it into the serial pool for no added rigour.

source "$HW_LIB/validation-cache.sh"
tree="$WORK/tree"
mkdir -p "$tree"
cp -R "$HW_FRAMEWORK" "$(hw_at "$tree" "$HW_FRAMEWORK")"
copied_root="$tree"

VC_ENVIRONMENT_HASH=""
key_before="$(vc_key "$VALID_FIXTURE/SKILL.md" "$copied_root")"
printf '\n<!-- an amendment -->\n' >>"$(hw_at "$copied_root" "$(hw_doc constitution)")"
VC_ENVIRONMENT_HASH=""
key_after_gov="$(vc_key "$VALID_FIXTURE/SKILL.md" "$copied_root")"
if [[ "$key_before" == "$key_after_gov" ]]; then
	echo "FAIL: VC-6 -- editing a governance document left the key unchanged"
	fail=1
fi

printf '\n# an added comment\n' >>"$(hw_at "$copied_root" "$HW_LIB")/rule-checks.sh"
VC_ENVIRONMENT_HASH=""
key_after_lib="$(vc_key "$VALID_FIXTURE/SKILL.md" "$copied_root")"
if [[ "$key_after_lib" == "$key_after_gov" ]]; then
	echo "FAIL: VC-6 -- editing a validator library left the key unchanged"
	fail=1
fi

VC_ENVIRONMENT_HASH=""
key_repeat="$(vc_key "$VALID_FIXTURE/SKILL.md" "$copied_root")"
check "VC-6" "the key is stable for unchanged inputs" "$key_repeat" "$key_after_lib"

# --- VC-7: --no-cache validates fully and records nothing ------------------------------------

home="$(fresh_home)"
cache="$(cache_dir_of "$home")"
nocache_rc=0
nocache_out="$(TMPDIR="$home" bash "$VALIDATE" --no-cache "$VALID_FIXTURE" 2>/dev/null)" || nocache_rc=$?
check "VC-7" "--no-cache exits 0 on a valid skill" "$nocache_rc" "0"
check "VC-7" "--no-cache records nothing" "$(key_count "$cache")" "0"
if [[ "$nocache_out" != "$cold_out" ]]; then
	echo "FAIL: VC-7 -- --no-cache produced a different report from a normal cold run"
	fail=1
fi

# --no-cache must also ignore an existing record rather than merely decline to write one.
home="$(fresh_home)"
cache="$(cache_dir_of "$home")"
TMPDIR="$home" bash "$VALIDATE" "$VALID_FIXTURE" >/dev/null 2>&1
rc=0
TMPDIR="$home" bash "$VALIDATE" --no-cache "$VALID_FIXTURE" >/dev/null 2>&1 || rc=$?
check "VC-7" "--no-cache still exits 0 with a populated cache" "$rc" "0"

# --- VC-8: an unusable cache degrades to full validation -------------------------------------

home="$(fresh_home)"
chmod 500 "$home"
rc=0
out="$(TMPDIR="$home" bash "$VALIDATE" "$VALID_FIXTURE" 2>/dev/null)" || rc=$?
chmod 700 "$home"
check "VC-8" "an unwritable cache location still exits 0" "$rc" "0"
if [[ "$out" != "$cold_out" ]]; then
	echo "FAIL: VC-8 -- an unwritable cache changed the report"
	fail=1
fi

# A cleared cache between runs must behave as a plain miss, not as an error.
home="$(fresh_home)"
cache="$(cache_dir_of "$home")"
TMPDIR="$home" bash "$VALIDATE" "$VALID_FIXTURE" >/dev/null 2>&1
rm -rf "$cache"
rc=0
TMPDIR="$home" bash "$VALIDATE" "$VALID_FIXTURE" >/dev/null 2>&1 || rc=$?
check "VC-8" "a cleared cache still exits 0" "$rc" "0"
check "VC-8" "a cleared cache is repopulated" "$(key_count "$cache")" "1"

# --- VC-9: the cache is never created inside the repository ----------------------------------

rc=0
TMPDIR="$HW_ROOT" bash "$VALIDATE" "$VALID_FIXTURE" >/dev/null 2>&1 || rc=$?
check "VC-9" "a repository-internal cache location still exits 0" "$rc" "0"
if [[ -e "$HW_ROOT/highway-validation-cache" ]]; then
	echo "FAIL: VC-9 -- a cache directory was created inside the repository"
	rm -rf "$HW_ROOT/highway-validation-cache"
	fail=1
fi

# --- VC-10: editing a bundled file changes the skill's key -----------------------------------
#
# validate-skill.sh checks a skill's assets/ and references/, so a stale verdict must not be
# replayed after either changes.

bundled="$WORK/valid-skill"
cp -R "$VALID_FIXTURE" "$bundled"
mkdir -p "$bundled/assets" "$bundled/references"
printf '# Reference\n\nBackground material.\n' >"$bundled/references/note.md"
printf '# Asset\n' >"$bundled/assets/note.md"
VC_ENVIRONMENT_HASH=""
key_bundled="$(vc_key "$bundled/SKILL.md" "$HW_ROOT")"
printf 'An added line.\n' >>"$bundled/references/note.md"
if [[ "$(vc_key "$bundled/SKILL.md" "$HW_ROOT")" == "$key_bundled" ]]; then
	echo "FAIL: VC-10 -- editing references/ left the key unchanged"
	fail=1
fi
key_bundled="$(vc_key "$bundled/SKILL.md" "$HW_ROOT")"
printf 'An added line.\n' >>"$bundled/assets/note.md"
if [[ "$(vc_key "$bundled/SKILL.md" "$HW_ROOT")" == "$key_bundled" ]]; then
	echo "FAIL: VC-10 -- editing assets/ left the key unchanged"
	fail=1
fi

# --- VC-11: the folder name is part of the key; the folder's location is not ------------------
#
# A skill's name must match its folder, so a verdict recorded under one folder name must not be
# replayed for the same content under another.

renamed="$WORK/renamed-skill"
cp -R "$VALID_FIXTURE" "$renamed"
moved="$WORK/elsewhere/valid-skill"
mkdir -p "$WORK/elsewhere"
cp -R "$VALID_FIXTURE" "$moved"
key_fixture="$(vc_key "$VALID_FIXTURE/SKILL.md" "$HW_ROOT")"
check "VC-11" "the same folder name elsewhere keeps its key" \
	"$(vc_key "$moved/SKILL.md" "$HW_ROOT")" "$key_fixture"
if [[ "$(vc_key "$renamed/SKILL.md" "$HW_ROOT")" == "$key_fixture" ]]; then
	echo "FAIL: VC-11 -- a renamed folder kept its key"
	fail=1
fi
home="$(fresh_home)"
TMPDIR="$home" bash "$VALIDATE" "$VALID_FIXTURE" >/dev/null 2>&1
rc=0
TMPDIR="$home" bash "$VALIDATE" "$renamed" >/dev/null 2>&1 || rc=$?
check "VC-11" "a name that differs from its folder fails on a populated cache" "$rc" "1"

# --- VC-12: two skills validated one after the other each get their own verdict ----------------

FLOW_FIXTURE="$HW_FIXTURES/flow-skill"
home="$(fresh_home)"
first="$(TMPDIR="$home" bash "$VALIDATE" "$VALID_FIXTURE" 2>/dev/null | tail -1)"
second="$(TMPDIR="$home" bash "$VALIDATE" "$FLOW_FIXTURE" 2>/dev/null | tail -1)"
check "VC-12" "the first report names its own skill" "${first%% is valid*}" "OK: skill 'valid-skill'"
check "VC-12" "the second report names its own skill" "${second%% is valid*}" "OK: skill 'flow-skill'"

# --- VC-13, VC-14: a hashing step that fails is never a key ------------------------------------
#
# A shim earlier on PATH stands in for a tool that fails, as xargs does in some sandboxes. Before
# this was fixed, the failure left every input unhashed, every skill shared one key, and the first
# recorded success was replayed for every skill after it.

shim="$WORK/shim-xargs"
mkdir -p "$shim"
printf '#!/bin/sh\nexit 1\n' >"$shim/xargs"
chmod +x "$shim/xargs"
home="$(fresh_home)"
PATH="$shim:$PATH" TMPDIR="$home" bash "$VALIDATE" "$VALID_FIXTURE" >/dev/null 2>&1
rc=0
PATH="$shim:$PATH" TMPDIR="$home" bash "$VALIDATE" "$INVALID_FIXTURE" >/dev/null 2>&1 || rc=$?
check "VC-13" "an invalid skill fails after a valid one is cached, with xargs failing" "$rc" "1"

shim="$WORK/shim-hash"
mkdir -p "$shim"
printf '#!/bin/sh\nexit 1\n' >"$shim/sha256sum"
printf '#!/bin/sh\nexit 1\n' >"$shim/shasum"
chmod +x "$shim/sha256sum" "$shim/shasum"
home="$(fresh_home)"
cache="$(cache_dir_of "$home")"
rc=0
out="$(PATH="$shim:$PATH" TMPDIR="$home" bash "$VALIDATE" "$VALID_FIXTURE" 2>/dev/null)" || rc=$?
check "VC-14" "a failing hasher still validates in full" "$rc" "0"
check "VC-14" "a failing hasher records nothing" "$(key_count "$cache")" "0"
if [[ "$out" != "$cold_out" ]]; then
	echo "FAIL: VC-14 -- a failing hasher changed the report"
	fail=1
fi
rc=0
PATH="$shim:$PATH" TMPDIR="$home" bash "$VALIDATE" "$INVALID_FIXTURE" >/dev/null 2>&1 || rc=$?
check "VC-14" "an invalid skill still fails with a failing hasher" "$rc" "1"

# --- VC-15: a change to a skill a handoff names revalidates the skill holding the handoff ------
#
# P14.4 reads the steps of the skill a cross-skill handoff names, so that skill is an input to the
# verdict. Renaming the step must not leave the old success to be replayed.

xskills="$WORK/xskills"
mkdir -p "$xskills"
cp -R "$FLOW_FIXTURE" "$xskills/flow-skill"
cp -R "$FLOW_FIXTURE" "$xskills/highway-zeta"
sed 's/^name: flow-skill$/name: highway-zeta/' "$FLOW_FIXTURE/SKILL.md" >"$xskills/highway-zeta/SKILL.md"
sed 's#^Confirm the record and stop.#Confirm the record, then follow `close` in `highway-zeta`.#' \
	"$FLOW_FIXTURE/SKILL.md" >"$xskills/flow-skill/SKILL.md"
home="$(fresh_home)"
rc=0
TMPDIR="$home" bash "$VALIDATE" "$xskills/flow-skill" >/dev/null 2>&1 || rc=$?
check "VC-15" "the handoff resolves before the step is renamed" "$rc" "0"
sed 's/^### close$/### finish/' "$FLOW_FIXTURE/SKILL.md" \
	| sed 's/^name: flow-skill$/name: highway-zeta/' >"$xskills/highway-zeta/SKILL.md"
rc=0
err="$(TMPDIR="$home" bash "$VALIDATE" "$xskills/flow-skill" 2>&1 >/dev/null)" || rc=$?
check "VC-15" "the skill holding the handoff fails once its target step is renamed" "$rc" "1"
if [[ "$err" != *"ERROR: [P14.4]"* ]]; then
	echo "FAIL: VC-15 -- the renamed step was not reported under P14.4"
	fail=1
fi

# --- Report ----------------------------------------------------------------------------------

if (( fail != 0 )); then
	echo "FAILED: validation-cache"
	exit 1
fi
echo "OK: validation-cache"
exit 0
