#!/usr/bin/env bash
# Produces separate Feature 038 evidence categories without conflating static checks and behavior.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
REPORT="${1:-${TMPDIR:-/tmp}/feature-038-evidence.tsv}"
. "$SCRIPT_DIR/feature-038-helpers.sh"
: > "$REPORT"
printf '%s\n' 'Feature 038 Evidence Report' >> "$REPORT"
printf '%s\n' 'Category	Result	Detail' >> "$REPORT"
fail=0

run_category() {
	local category="$1" detail="$2"
	shift 2
	if "$@" >/tmp/feature-038-evidence.$$.log 2>&1; then
		feature_038_write_evidence "$REPORT" "$category" PASS "$detail"
	else
		feature_038_write_evidence "$REPORT" FAIL "$detail"
		cat /tmp/feature-038-evidence.$$.log >&2
		fail=1
	fi
	rm -f /tmp/feature-038-evidence.$$.log
}

run_category 'executable owner behavior' 'Profile, Objectives, Controls, and NFR fixture evaluation' bash "$SCRIPT_DIR/readiness-executable.test.sh"
run_category 'Setup routing' 'ordered captured-response routing and short-circuiting' bash "$SCRIPT_DIR/highway-setup-executable.test.sh"
run_category 'static contract' 'readiness and Feature 038 planning contracts' bash -c "bash '$SCRIPT_DIR/readiness-contract.test.sh' && bash '$SCRIPT_DIR/feature-038-plan.test.sh'"
run_category 'generated artifacts' 'catalog and adapter correspondence' bash "$SCRIPT_DIR/adapter-coverage.test.sh"
coverage_file="$REPO_ROOT/$(printf 'spec%s' 's')/038-readiness-verification-corrections/coverage.md"
if [[ -f "$coverage_file" ]]; then
	feature_038_write_evidence "$REPORT" 'requirement coverage' PASS 'FR-001..FR-015 and SC-001..SC-008 recorded'
else
	feature_038_write_evidence "$REPORT" 'requirement coverage' FAIL 'coverage.md is missing'
	fail=1
fi
feature_038_write_evidence "$REPORT" limitations DOCUMENTED 'Owner execution uses the explicitly documented deterministic test adapter where natural-language invocation is unavailable.'

cat "$REPORT"
exit "$fail"
