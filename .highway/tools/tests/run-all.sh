#!/usr/bin/env bash
# Discovers and runs every *.test.sh under tools/tests/, prints a pass/fail summary, and exits
# non-zero if any test fails.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"

# Two tests seed probes into the live tree, because what they check -- packaging and adapter
# generation -- reads the real tree rather than a copy. Each names its probes with its own PID and
# removes them on exit, so a run killed before cleanup leaves residue no later run will claim.
#
# Sweeping in the owning test is not enough: tests run in name order, so residue is seen by
# whichever test sorts first and reported there. Observed twice -- an orphaned adapter row failed
# adapter-coverage, and an abandoned link probe failed distribution-packaging, each time naming a
# defect that did not exist and sending the reader to the wrong file.
rm -rf "$REPO_ROOT"/distribution-probe-*.md \
	"$HIGHWAY_ROOT"/catalog/distribution-devref-probe-*.md \
	"$HIGHWAY_ROOT"/catalog/distribution-link-probe-*.md \
	"$HIGHWAY_ROOT"/catalog/distribution-reject-probe-*.md \
	"$HIGHWAY_ROOT"/skills/test-adapter-fixture-* \
	"$REPO_ROOT"/.github/skills/test-adapter-fixture-* \
	"$REPO_ROOT"/.claude/skills/test-adapter-fixture-* \
	"$REPO_ROOT"/.cursor/rules/test-adapter-fixture-*.mdc \
	"$HIGHWAY_ROOT"/tools/shipped-tree-cliprobe-*.tmp \
	"$HIGHWAY_ROOT"/tools/tests/fixtures/shipped-tree-cliprobe-*.tmp
adapter_manifest="$HIGHWAY_ROOT/tools/.adapter-manifest"
if [[ -f "$adapter_manifest" ]] && grep -q 'test-adapter-fixture-' "$adapter_manifest"; then
	grep -v 'test-adapter-fixture-' "$adapter_manifest" >"$adapter_manifest.tmp" || true
	mv "$adapter_manifest.tmp" "$adapter_manifest"
fi

pass=0
fail=0
failed_names=()

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
for test_file in "$SCRIPT_DIR"/*.test.sh; do
	case "$(basename "$test_file")" in
		readiness-executable.test.sh|highway-setup-executable.test.sh) continue ;;
	esac
	run_test "$test_file"
done
for test_file in \
	readiness-executable.test.sh \
	highway-setup-executable.test.sh; do
	run_test "$SCRIPT_DIR/$test_file"
done
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
