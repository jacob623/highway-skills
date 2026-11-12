#!/usr/bin/env bash
# Fails when the user-facing distribution cannot be produced, or can be produced while broken.
#
# The defect this guards against is invisible locally: the repository always contains everything,
# so every other check passes while the extracted subset is missing something it needs. Only a
# user would find out. Producing the distribution here, and deliberately breaking it, is what
# makes that failure visible before it ships.
#
# Every probe is removed with rm. Do not revert a probe with version control: during feature 010
# that discarded unrelated uncommitted work in the same file.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, disposable-fixture, generated-artifact
# Seeded failure probe: --probe <class> seeds a defect and observes detection; --probe <class>
# --neutralise runs the identical path unseeded and requires a clean pass. See the Feature 042
# probe-mode contract, which supersedes Feature 041's.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
# shellcheck source=../framework/lib/distribution.sh
source "$HW_LIB/distribution.sh"
SHIPPED_SKILLS="$(hw_rel "$HW_AGENT_CODEX")"
# Probes are seeded in a folder that ships, so the generator classifies them as included.
PROBE_DIR="$HW_AGENT_CODEX/highway-help"
# Assembled so this file does not name the folder the distribution must not hold.
HIDDEN_ROOT=".""highway"
GEN="$HW_FRAMEWORK/generate-distribution.sh"
fail=0

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document disposable-fixture generated-artifact "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi

# Requires the generator to refuse the given target and to name the offending path when it does.
# Emits the reason on failure. Probe mode and normal mode both decide D4.3 through this function,
# so a guard that satisfies one cannot drift from the other.
assert_refusal_names() {
	local target="$1" needle="$2" log="$3"
	if "$GEN" "$target" >"$log" 2>&1; then
		echo "packaging did not refuse to overwrite: $target"
		return 1
	fi
	if ! grep -q 'refusing to overwrite' "$log"; then
		echo "packaging stopped for a reason other than the overwrite refusal: $target"
		return 1
	fi
	if ! grep -Fq "$needle" "$log"; then
		echo "the overwrite refusal did not name its target: $needle"
		return 1
	fi
	return 0
}

# --- Probe mode: a dedicated CLI path for the D3.7 harness, one build per invocation ---
if [[ -n "$probe_class" ]]; then
	probe_work="$(mktemp -d)"
	# Assembled at runtime rather than written literally, per the same reasoning as the
	# development-only reference probe below: this file is scanned by
	# shipped-tree-independence.test.sh for exactly this token.
	DEV_DIR="spec""s"
	dev_probe=""
	stray_probe=""
	cleanup_probe() {
		rm -rf "$probe_work"
		[[ -n "$dev_probe" ]] && rm -f "$dev_probe"
		[[ -n "$stray_probe" ]] && rm -f "$stray_probe"
	}
	trap cleanup_probe EXIT
	case "$probe_class" in
		source-document)
			dev_probe="$PROBE_DIR/distribution-devref-probe-$$.md"
			if [[ "$neutralise" -eq 0 ]]; then
				printf 'see the spec at %s/001-multi-agent-skill-suite/spec.md\n' "$DEV_DIR" >"$dev_probe"
			fi
			if "$GEN" "$probe_work/out" >"$probe_work/log" 2>&1; then
				exit 0
			elif grep -q "development-only location" "$probe_work/log"; then
				exit 1
			else
				exit 0
			fi
			;;
		disposable-fixture)
			stray_probe="$HW_ROOT/distribution-probe-$$.md"
			if [[ "$neutralise" -eq 0 ]]; then
				printf 'probe\n' >"$stray_probe"
			fi
			if "$GEN" "$probe_work/out" >"$probe_work/log" 2>&1; then
				exit 0
			elif grep -q "distribution-probe-$$" "$probe_work/log"; then
				exit 1
			else
				exit 0
			fi
			;;
		generated-artifact)
			# Both halves of D4.3's Enforcement Map note under one class, because the
			# modified-file refusal can only be seeded against a target the generator did
			# produce, and one build then serves both.
			built="$probe_work/built-$$"
			if ! "$GEN" "$built" >"$probe_work/build.log" 2>&1; then
				exit 0
			fi
			if [[ "$neutralise" -eq 1 ]]; then
				"$GEN" "$built" >"$probe_work/clean.log" 2>&1
				exit $?
			fi
			untracked_probe="$probe_work/untracked-$$"
			mkdir -p "$untracked_probe"
			printf 'hand-authored\n' >"$untracked_probe/notes.md"
			assert_refusal_names "$untracked_probe" "$untracked_probe" \
				"$probe_work/untracked.log" >/dev/null || exit 0
			victim="$built/README.md"
			printf 'drift\n' >>"$victim"
			assert_refusal_names "$built" "$victim" "$probe_work/modified.log" \
				>/dev/null || exit 0
			# Both refusals detected. Removing either one makes this leg exit 0.
			exit 1
			;;
	esac
fi

WORK="$(mktemp -d)"
cleanup_probes() {
	rm -f "$HW_ROOT"/distribution-probe-*.md \
		"$PROBE_DIR"/distribution-devref-probe-*.md \
		"$PROBE_DIR"/distribution-link-probe-*.md \
		"$PROBE_DIR"/distribution-reject-probe-*.md
}
cleanup() { cleanup_probes; rm -rf "$WORK"; }
trap cleanup EXIT

# A killed packaging run can leave a link probe in the included highway-help folder. Remove it before the
# first build so the next run reports its own behavior rather than stale state from an earlier run.
stale_link_probe="$PROBE_DIR/distribution-link-probe-stale.md"
printf 'see [the missing file](stale-probe-target.md)\n' >"$stale_link_probe"
cleanup_probes
if [[ -e "$stale_link_probe" ]]; then
	echo "FAIL: stale packaging probes were not removed before the first build"
	fail=1
fi

# --- The distribution can be produced and passes its own verification ---

dist="$WORK/dist"
if ! "$GEN" "$dist" >"$WORK/produce.log" 2>&1; then
	echo "FAIL: the distribution could not be produced"
	sed 's/^/    /' "$WORK/produce.log"
	fail=1
fi

# --- Two runs from the same repository state are byte-identical (FR-012) ---
# The production record is excluded: its content is a function of the files already compared.

second="$WORK/second"
if ! "$GEN" "$second" >"$WORK/second.log" 2>&1; then
	echo "FAIL: the second packaging run failed"
	sed 's/^/    /' "$WORK/second.log"
	fail=1
else
	if ! diff -r -x '.distribution-record' "$dist" "$second" >"$WORK/diff.log" 2>&1; then
		echo "FAIL: two packaging runs from the same repository state differ"
		sed 's/^/    /' "$WORK/diff.log"
		fail=1
	fi
fi

# --- Probe: an undeclared repository path is reported, not silently classified ---

probe_path="$HW_ROOT/distribution-probe-$$.md"
printf 'probe\n' >"$probe_path"
if "$GEN" "$WORK/p1" >"$WORK/p1.log" 2>&1; then
	echo "FAIL: an undeclared repository path did not stop packaging"
	fail=1
elif ! grep -q "distribution-probe-$$" "$WORK/p1.log"; then
	echo "FAIL: packaging rejected an undeclared path without naming it"
	fail=1
fi
rm -f "$probe_path"

# --- Probe: a development-only reference in a distributed file is caught ---
# The file is seeded under an included directory, so it is classified as shipping.
#
# The token is assembled at runtime rather than written literally. This file is scanned by
# shipped-tree-independence.test.sh, which searches for exactly this token, and a literal here
# would make that check fail on a file that is deliberately seeding a violation. Assembling it
# keeps the seeded probe real without exempting this file from a check that should cover it.
DEV_DIR="spec""s"

dev_probe="$PROBE_DIR/distribution-devref-probe-$$.md"
printf 'see the spec at %s/001-multi-agent-skill-suite/spec.md\n' "$DEV_DIR" >"$dev_probe"
if "$GEN" "$WORK/p2" >"$WORK/p2.log" 2>&1; then
	echo "FAIL: a development-only reference in a distributed file did not stop packaging"
	fail=1
elif ! grep -q "development-only location" "$WORK/p2.log"; then
	echo "FAIL: packaging rejected a development-only reference without naming the cause"
	fail=1
fi
rm -f "$dev_probe"

# --- Probe: an unresolvable cross-reference is caught ---

link_probe="$PROBE_DIR/distribution-link-probe-$$.md"
printf 'see [the missing file](no-such-file-%s.md)\n' "$$" >"$link_probe"
if "$GEN" "$WORK/p3" >"$WORK/p3.log" 2>&1; then
	echo "FAIL: an unresolvable cross-reference did not stop packaging"
	fail=1
elif ! grep -q "does not exist in the distribution" "$WORK/p3.log"; then
	echo "FAIL: packaging rejected an unresolvable reference without naming the target"
	fail=1
fi
rm -f "$link_probe"

# --- Probe: a rejected candidate is removed rather than left behind (FR-011) ---

reject_probe="$PROBE_DIR/distribution-reject-probe-$$.md"
printf 'see %s/001-multi-agent-skill-suite/spec.md\n' "$DEV_DIR" >"$reject_probe"
"$GEN" "$WORK/p4" >/dev/null 2>&1
rm -f "$reject_probe"
if [[ -d "$WORK/p4" ]]; then
	echo "FAIL: a rejected candidate distribution was left in place"
	fail=1
fi

# --- The distribution holds the skills, the front page, and no framework or test file ---

if [[ -d "$dist" ]]; then
	if ! grep -q 'PASS: skill validator succeeded against [0-9]* skills using only distribution contents and the framework' "$WORK/produce.log"; then
		echo "FAIL: packaging did not report validating the skills with the framework"
		fail=1
	fi
	for skill_md in "$HW_SKILLS"/*/SKILL.md; do
		skill_id="$(basename "$(dirname "$skill_md")")"
		if ! diff -q "$skill_md" "$dist/$SHIPPED_SKILLS/$skill_id/SKILL.md" >/dev/null 2>&1; then
			echo "FAIL: skill '$skill_id' is not shipped unchanged at $SHIPPED_SKILLS/$skill_id/SKILL.md"
			fail=1
		fi
	done
	if ! diff -q "$HW_FRAMEWORK/README.md" "$dist/README.md" >/dev/null 2>&1; then
		echo "FAIL: the distribution's README.md is not framework/README.md"
		fail=1
	fi
	for gone in framework tests skills "$HIDDEN_ROOT"; do
		if [[ -e "$dist/$gone" ]]; then
			echo "FAIL: the distribution contains $gone/"
			fail=1
		fi
	done
	if [[ ! -f "$dist/.distribution-record" ]]; then
		echo "FAIL: the distribution has no .distribution-record at its root"
		fail=1
	fi
fi

# --- The skill validation check must be capable of failing ---
# A verification tree missing its constitution must not validate. If this passes, the
# check is resolving something from outside the tree and proves nothing about the distribution.

if [[ -d "$dist" ]]; then
	broken="$WORK/broken"
	cp -R "$dist" "$broken"
	mv "$broken/$SHIPPED_SKILLS" "$(hw_at "$broken" "$HW_SKILLS")"
	cp -R "$HW_FRAMEWORK" "$(hw_at "$broken" "$HW_FRAMEWORK")"
	if ! env -u CONSTITUTION_FILE "$(hw_at "$broken" "$HW_FRAMEWORK")/validate-skill.sh" --no-cache \
		"$(hw_at "$broken" "$HW_SKILLS")/highway-help" >/dev/null 2>&1; then
		echo "FAIL: the verification tree did not validate highway-help before it was broken"
		fail=1
	fi
	rm -f "$(hw_at "$broken" "$(hw_doc constitution)")"
	if env -u CONSTITUTION_FILE "$(hw_at "$broken" "$HW_FRAMEWORK")/validate-skill.sh" --no-cache \
		"$(hw_at "$broken" "$HW_SKILLS")/highway-help" >/dev/null 2>&1; then
		echo "FAIL: a verification tree missing its governing document still validated"
		fail=1
	fi
fi

# --- The step refuses to overwrite a directory it did not produce (FR-013, D4.3) ---

guard="$WORK/guard"
mkdir -p "$guard"
printf 'hand-authored\n' >"$guard/notes.md"
if ! why="$(assert_refusal_names "$guard" "$guard" "$WORK/guard.log")"; then
	echo "FAIL: $why"
	fail=1
fi
if [[ "$(cat "$guard/notes.md" 2>/dev/null)" != "hand-authored" ]]; then
	echo "FAIL: packaging destroyed a file in a directory it did not produce"
	fail=1
fi

# --- The step refuses to overwrite a file modified inside a target it did produce (D4.3) ---
# The Enforcement Map note promises this half as well; until feature 042 nothing asserted it in
# any mode. The distribution built at the top is reused rather than built again, because nothing
# below this point reads it.

if [[ -d "$dist" ]]; then
	modified_victim="$dist/README.md"
	printf 'drift\n' >>"$modified_victim"
	if ! why="$(assert_refusal_names "$dist" "$modified_victim" "$WORK/modified.log")"; then
		echo "FAIL: $why"
		fail=1
	fi
fi

exit $fail
