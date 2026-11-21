#!/usr/bin/env bash
# Discovers and runs every *.test.sh under tools/tests/, prints a pass/fail summary, and exits
# non-zero if any test fails.
#
# Plugin generation–specific closed list (feature 259):
#   plugin-version-bump.test.sh
#   agent-plugin.test.sh
# Flags (mutually exclusive):
#   --exclude-plugin-gen   skip the closed list
#   --plugin-gen-only      run only the closed list
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"

PLUGIN_GEN_TESTS=(
	plugin-version-bump.test.sh
	agent-plugin.test.sh
)

mode="all"
case "${1:-}" in
	"") ;;
	--exclude-plugin-gen) mode="exclude-plugin-gen" ;;
	--plugin-gen-only) mode="plugin-gen-only" ;;
	-h|--help)
		echo "Usage: tests/run-all.sh [--exclude-plugin-gen|--plugin-gen-only]" >&2
		exit 0
		;;
	*)
		echo "Usage: tests/run-all.sh [--exclude-plugin-gen|--plugin-gen-only]" >&2
		exit 2
		;;
esac

# Feature 092 checks are included by the existing *.test.sh discovery below; no separate dispatch
# list is required. Two tests seed probes into the live tree, because what they check -- packaging and adapter
# generation -- reads the real tree rather than a copy. Each names its probes with its own PID and
# removes them on exit, so a run killed before cleanup leaves residue no later run will claim.
#
# Sweeping in the owning test is not enough: tests run in name order, so residue is seen by
# whichever test sorts first and reported there. Observed twice -- an orphaned adapter row failed
# adapter-coverage, and an abandoned link probe failed distribution-packaging, each time naming a
# defect that did not exist and sending the reader to the wrong file.
rm -rf "$HW_ROOT"/distribution-probe-*.md \
	"$HW_AGENT_CODEX"/highway-help/distribution-devref-probe-*.md \
	"$HW_AGENT_CODEX"/highway-help/distribution-link-probe-*.md \
	"$HW_AGENT_CODEX"/highway-help/distribution-reject-probe-*.md \
	"$HW_AGENT_CODEX"/highway-help/shipped-tree-*probe-*.tmp \
	"$HW_HARNESS"/fixtures/overlays/probe-agent-skills-* \
	"$HW_SKILLS"/test-adapter-fixture-* \
	"$HW_AGENT_COPILOT"/test-adapter-fixture-* \
	"$HW_AGENT_CLAUDE"/test-adapter-fixture-* \
	"$HW_AGENT_CURSOR"/test-adapter-fixture-* \
	"$HW_AGENT_CODEX"/test-adapter-fixture-* \
	"$HW_AGENT_CODEX"/test-newagent-fixture-* \
	"$HW_FRAMEWORK"/shipped-tree-cliprobe-*.tmp \
	"$HW_FIXTURES"/shipped-tree-cliprobe-*.tmp
adapter_manifest="$HW_FRAMEWORK/.adapter-manifest"
if [[ -f "$adapter_manifest" ]] && grep -q 'test-adapter-fixture-' "$adapter_manifest"; then
	grep -v 'test-adapter-fixture-' "$adapter_manifest" >"$adapter_manifest.tmp" || true
	mv "$adapter_manifest.tmp" "$adapter_manifest"
fi

pass=0
fail=0
failed_names=()

is_plugin_gen() {
	local name="$1" t
	for t in "${PLUGIN_GEN_TESTS[@]}"; do
		[[ "$name" == "$t" ]] && return 0
	done
	return 1
}

run_test() {
	local test_file="$1" name
	name="$(basename "$test_file")"
	echo "==> Running $name"
	if bash "$test_file"; then
		echo "PASS: $name"
		pass=$((pass + 1))
	else
		echo "FAIL: $name"
		fail=$((fail + 1))
		failed_names+=("$name")
	fi
	echo
}

shopt -s nullglob
if [[ "$mode" == "plugin-gen-only" ]]; then
	for name in "${PLUGIN_GEN_TESTS[@]}"; do
		test_file="$HW_TESTS/$name"
		if [[ ! -f "$test_file" ]]; then
			echo "FAIL: missing plugin-gen test $name"
			fail=$((fail + 1))
			failed_names+=("$name")
			continue
		fi
		run_test "$test_file"
	done
else
	for test_file in "$HW_TESTS"/*.test.sh; do
		name="$(basename "$test_file")"
		if [[ "$mode" == "exclude-plugin-gen" ]] && is_plugin_gen "$name"; then
			echo "==> Skipping $name (--exclude-plugin-gen)"
			echo
			continue
		fi
		run_test "$test_file"
	done
fi
shopt -u nullglob

echo "--------------------------------------"
echo "Summary: $pass passed, $fail failed"
if (( fail > 0 )); then
	echo "Failed tests:"
	for n in "${failed_names[@]}"; do
		echo "  - $n"
	done
	exit 1
fi
exit 0
